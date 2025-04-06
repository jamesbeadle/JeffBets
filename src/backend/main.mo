// TODO: Should these be pulled mops or from defintions?
import Environment "environment";
import Utilities "utilities/utilities";
import Management "utilities/Management";
import FPLLedger "managers/fpl_ledger_manager";

/* ----- Mops Packages ----- */
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Float "mo:base/Float";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Nat64 "mo:base/Nat64";
import Option "mo:base/Option";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Timer "mo:base/Timer";
import Time "mo:base/Time";


/* ----- Canister Definition Files ----- */

import ProfileCanister "canister_definitions/profile-canister";


/* ----- Queries ----- */

import AppDTOs "dtos/app_dtos"; //TODO 
import FootballDTOs "dtos/football_dtos";
import BettingQueries "cqrs/queries/betting_queries";
import AuditQueries "cqrs/queries/audit_queries";


/* ----- Commands ----- */

import AppCommands "cqrs/commands/app_commands";
import UserCommands "cqrs/commands/user_commands";
import BettingCommands "cqrs/commands/betting_commands";


/* ----- Managers ----- */

import UserManager "managers/user_manager";
import OddsManager "managers/odds_manager";
import KYCManager "managers/kyc_manager";




//ONLY STABLE TYPEs
import Base "mo:waterway-mops/BaseTypes";
import Ids "mo:waterway-mops/Ids";
import T "types/app_types";
import BettingTypes "types/betting_types";
import AppTypes "types/app_types";
import ShuftiTypes "types/shufti_types";


actor Self {
  
  private var appStatus: Base.AppStatus = { 
    onHold = false;
    version = "0.0.1";
  };  
  
  public shared query func getAppStatus() : async Result.Result<AppDTOs.AppStatusDTO, T.Error> {
    return #ok(appStatus);
  };

  private let ledger = FPLLedger.FPLLedger();
  private let userManager = UserManager.UserManager(); 
  private let oddsManager = OddsManager.OddsManager(); 
  private let kycManager = KYCManager.KYCManager();
  
  private stable var openBets: [BettingTypes.BetSlip] = [];
  private stable var totalBetsStaked: Nat64 = 0;
  private stable var totalPotentialPayout: Nat64 = 0;

  private stable var activeBettingLeagues: [FootballTypes.LeagueId] = [];

  /* Application functions */

  public shared query func getDataHashes(): async Result.Result<[AppDTOs.DataHashDTO], T.Error> {
    return oddsManager.getDataHashes();
  };

  /* User management functions */

  public shared ({ caller }) func getProfile() : async Result.Result<FootballDTOs.ProfileDTO, T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    let kycProfile = kycManager.getKYCProfile(principalId);
    
    return await userManager.getProfile(principalId, kycProfile);
  };

  public shared ({ caller }) func agreeTerms() : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    return await userManager.agreeTerms(principalId);
  };

  public shared ({ caller }) func updateUsername(dto: AppCommands.UpdateUsername) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert dto.principalId == principalId;
    return await userManager.updateUsername(dto);
  };

  public shared ({ caller }) func updateProfilePicture(dto: AppCommands.UpdateProfilePicture) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert dto.principalId == principalId;
    return await userManager.updateProfilePicture(dto);
  };

  public shared ({ caller }) func updateWithdrawalAddress(dto: AppCommands.UpdateWithdrawalAddress) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert dto.principalId == principalId;
    return await userManager.updateWithdrawalAddress(dto);
  };

  public shared ({ caller }) func pauseAccount(dto: UserCommands.PauseAccount) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert dto.principalId == principalId;
    return await userManager.pauseAccount(dto);
  };

  public shared ({ caller }) func setDailyBetLimit(dto: UserCommands.SetDailyBetLimit) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert dto.principalId == principalId;
    return await userManager.setDailyBetLimit(dto);
  };

  public shared ({ caller }) func setMonthlyBetLimit(dto: UserCommands.SetMonthlyBetLimit) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert dto.principalId == principalId;
    return await userManager.setMonthlyBetLimit(dto);
  };

  /* Betting functions */

  public shared query func getBettableHomepageFixtures(leagueId: FootballTypes.LeagueId) : async Result.Result<[AppDTOs.HomePageFixtureDTO], T.Error> {
    return #ok(oddsManager.getHomepageLeagueFixtures(leagueId));
  };

  public shared query func getMatchOdds(leagueId: FootballTypes.LeagueId, fixtureId: FootballTypes.FixtureId) : async Result.Result<AppDTOs.MatchOddsDTO, T.Error> {
    return oddsManager.getMatchOdds(leagueId, fixtureId);
  };
  
  public shared ({ caller }) func placeBet(dto: BettingCommands.SubmitBetslip) : async Result.Result<BettingTypes.BetSlip, T.Error>{
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert dto.principalId == principalId;

    assert validateBetslip(dto);
    assert await betWithinPlatformLimits(dto.totalStake);

    let kycProfile = kycManager.getKYCProfile(principalId);

    let profileResult = await userManager.getProfile(principalId, kycProfile);
    switch(profileResult){
      case (#ok profile){
        assert not profile.accountOnPause;
        assert profile.kycComplete; 
        assert profile.accountBalance >= dto.totalStake;
        assert profile.maxBetLimit >= dto.totalStake;
        assert profile.monthlyBetTotal + dto.totalStake <= profile.monthlyBetLimit;
      };
      case (#err error){
        return #err(error);
      }
    };

    let betslipResult = await userManager.placeBet(dto);
    switch(betslipResult){
      case (#ok betslip){

        let openBetsBuffer = Buffer.fromArray<BettingTypes.BetSlip>(openBets);
        openBetsBuffer.add(betslip);
        openBets := Buffer.toArray(openBetsBuffer);

        totalBetsStaked := calculateTotalStaked();
        totalPotentialPayout := calculateTotalPotentialPayout();
        return #ok(betslip);
      };
      case (#err error){
        return #err(error);
      }
    }
  };

  public shared ({ caller }) func getUserBets(dto: BettingQueries.GetUserBets) : async Result.Result<BettingQueries.UserBetsList, T.Error>{
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert dto.principalId == principalId;
    return await userManager.getUserBets(dto);
  };

  private func validateBetslip(dto: BettingCommands.SubmitBetslip) : Bool {

    //for the accumulator type
      //calculate the expected returns of each row and ensure what they expect from each users submission

      //get the object the frontend has to do the comparison

      //game is unplayed

    return false;
  };

  private func calculateTotalPotentialPayout() : Nat64 {
    return Array.foldLeft<BettingTypes.BetSlip, Nat64>(
        openBets,
        0,
        func(acc : Nat64, betslip : BettingTypes.BetSlip) : Nat64 {

          let totalPayouts = Array.foldLeft<BettingTypes.Selection, Nat64>(
            betslip.selections,
            0,
            func(acc: Nat64, selection: BettingTypes.Selection) : Nat64 {
              let betPayoutFloat: Float = Utilities.convertNat64ToFloat(selection.stake) * selection.odds;
              return acc + Utilities.convertFloatToNat64(betPayoutFloat);
            }
          );

          return acc + totalPayouts;
        },
      );
  };

  private func calculateTotalStaked() : Nat64 {
    return Array.foldLeft<BettingTypes.BetSlip, Nat64>(
        openBets,
        0,
        func(acc : Nat64, betslip : BettingTypes.BetSlip) : Nat64 {
          return acc + betslip.totalStake;
        },
      );
  };

  private func betWithinPlatformLimits(stake: Nat64) : async Bool {

    let ledgerBalance = await ledger.getPotBalance(Principal.fromActor(Self));
    
    let maxSingleBetStake: Nat64 = Nat64.div(ledgerBalance, 100);

    if(stake > maxSingleBetStake){
      return false;
    };
    
    if(totalPotentialPayout + stake > ledgerBalance){
      return false;
    };

    return true;
  };

  private func settleBets(completedFixtureId: FootballTypes.FixtureId) : async (){

    let updatedOpenBetsBuffer = Buffer.fromArray<BettingTypes.BetSlip>([]);
    for(bet in Iter.fromArray(openBets)){
      
      let unsettledSelections = Array.filter<BettingTypes.Selection>(bet.selections, 
        func(selection: BettingTypes.Selection){
          selection.result == #Open;
        }
      );

      let unsettledFixture = Array.find<BettingTypes.Selection>(bet.selections, 
        func(selection: BettingTypes.Selection) : Bool {
          selection.result == #Open and selection.fixtureId == completedFixtureId;
        }
      );

      let betCompletesSlip = Array.size(unsettledSelections) == 1 and Option.isSome(unsettledFixture);

      if(betCompletesSlip){
        await userManager.settleBet(bet);
      } else {
        updatedOpenBetsBuffer.add({
          betType = bet.betType;
          id = bet.id;
          placedBy = bet.placedBy;
          placedOn = bet.placedOn;
          selections = Array.map<BettingTypes.Selection, BettingTypes.Selection>(bet.selections, func(selection: BettingTypes.Selection){
            if(selection.fixtureId == completedFixtureId){
              return {
                fixtureId = selection.fixtureId;
                odds = selection.odds;
                result = selection.result;
                selectionDetail = selection.selectionDetail;
                selectionType = selection.selectionType;
                stake = selection.stake;
                status = #Settled;
                winnings = selection.winnings;
                expectedReturns = selection.expectedReturns;
                leagueId = selection.leagueId;
              }
            } else { return selection; };
          });
          status = bet.status;
          result = bet.result;
          totalStake = bet.totalStake;
          expectedReturns = bet.expectedReturns;
          totalWinnings = bet.totalWinnings;
          settledOn = Time.now();
        });
      };
    }; 

    totalBetsStaked := calculateTotalStaked();
    totalPotentialPayout := calculateTotalPotentialPayout();
  };

  /* Stable variable backup for managers */

  //User Manager
  private stable var stable_profile_canister_ids: [(Ids.PrincipalId, Base.CanisterId)] = [];
  private stable var stable_unique_profile_canister_ids: [Ids.CanisterId] = [];
  private stable var stable_active_profile_canister_id: Text = "";
  private stable var stable_usernames: [(Ids.PrincipalId, Text)] = [];
  private stable var stable_kyc_profiles: [(Ids.PrincipalId, AppTypes.KYCProfile)] = [];

  //Odds Manager
  private stable var stable_match_odds_cache: [(FootballTypes.LeagueId, [(FootballTypes.FixtureId, BettingTypes.MatchOdds)])] = [];

  system func preupgrade() {
    stable_profile_canister_ids := userManager.getStableProfileCanisterIds();
    stable_unique_profile_canister_ids := userManager.getStableUniqueProfileCanisterIds();
    stable_active_profile_canister_id := userManager.getStableActiveProfileCanisterId();
    stable_usernames := userManager.getStableUsernames();
    stable_match_odds_cache := oddsManager.getStableMatchOddsCache();
    stable_kyc_profiles := kycManager.getStableKYCProfiles();
  };

  system func postupgrade() {
    userManager.setStableProfileCanisterIds(stable_profile_canister_ids);
    userManager.setStableUniqueProfileCanisterIds(stable_unique_profile_canister_ids);
    userManager.setStableActiveProfileCanisterId(stable_active_profile_canister_id);
    userManager.setStableUsernames(stable_usernames);
    oddsManager.setStableMatchOddsCache(stable_match_odds_cache);
    kycManager.setStableKYCProfiles(stable_kyc_profiles);
    ignore Timer.setTimer<system>(#nanoseconds(Int.abs(1)), postUpgradeCallback); 
  };

  private func postUpgradeCallback() : async (){
    
    /*
    await oddsManager.recalculate(1, 1, {
      activeGameweek = 0;
      activeMonth = 0;
      activeSeasonId = 0;
      completedGameweek = 0;
      leagueId = 0;
      seasonActive = true;
      totalGameweeks = 38;
      transferWindowActive = false;
      transferWindowEndDay = 0;
      transferWindowEndMonth = 0;
      transferWindowStartDay = 0;
      transferWindowStartMonth = 0;
      unplayedGameweek = 0;

    });
    */
    //await oddsManager.recalculate(2, 1);
    //await updateProfileCanisterWasms();
  };

  private func updateProfileCanisterWasms() : async (){
    let profileCanisterIds = userManager.getStableUniqueProfileCanisterIds();
    let IC : Management.Management = actor (Environment.Default);
    for(canisterId in Iter.fromArray(profileCanisterIds)){
      await IC.stop_canister({ canister_id = Principal.fromText(canisterId); });
      let oldProfileCanister = actor (canisterId) : actor {};
      let _ = await (system ProfileCanister._ProfileCanister)(#upgrade oldProfileCanister)();
      await IC.start_canister({ canister_id = Principal.fromText(canisterId); });
    };
  };

  //Audit functions
  
  public shared ({ caller }) func isAuditor() : async Result.Result<Bool, T.Error> {
    return #ok(checkAuditor(Principal.toText(caller)));
  };

  public shared ({ caller }) func getUserAudit(dto: AuditQueries.GetUserAudit) : async Result.Result<AuditQueries.UserAuditList, T.Error> {
    assert checkAuditor(Principal.toText(caller));
    return #err(#NotFound);

    //return #ok(await userManager.getUserAuditList(dto)); 
  };
  
  private func checkAuditor(principalId: Text) : Bool {
    return Option.isSome(Array.find<Ids.PrincipalId>(Environment.AUDITOR_PRINCIPALS, func(dataAdmin: Ids.PrincipalId) : Bool{
      dataAdmin == principalId;
    }));
  };

  //Callback Functions
  


  /*

  //Todo this should be called by the notification callback functions
  
  public shared ({ caller }) func updateBettingOdds(leagueId: FootballTypes.LeagueId, seasonId: FootballTypes.SeasonId) : async Result.Result<(), T.Error> {
    assert Principal.toText(caller) == Environment.DATA_CANISTER_ID;
    await oddsManager.recalculate(leagueId, seasonId);
    return #ok();
  };
  */
  
  public shared ({ caller }) func storeKYCReference(kycReference: Text) : async (){
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    kycManager.storeKYCReference(kycReference, principalId);
  };

  public shared func kycVerificationCallback(response: ShuftiTypes.ShuftiResponse) : async Result.Result<(), T.Error> {
    let principalResult = kycManager.storeVerificationResponse(response);

    switch(principalResult){
      case (?principalId){
        await userManager.verifyBettingAccount(principalId);
        return #ok();
      };
      case (null){}
    };
    return #err(#NotFound);
  };

  //Data canister notification callback functions

  public shared ({ caller }) func notifyAppsOfLoan(leagueId: FootballTypes.LeagueId, playerId: FootballTypes.PlayerId) : async Result.Result<(), T.Error> {
    assert Principal.toText(caller) == Environment.DATA_CANISTER_ID;
    //TODO
    return #ok();
  };

  public shared ({ caller }) func notifyAppsOfLoanExpired(leagueId: FootballTypes.LeagueId, playerId: FootballTypes.PlayerId) : async Result.Result<(), T.Error> {
    assert Principal.toText(caller) == Environment.DATA_CANISTER_ID;
    
    //TODO

    return #ok();
  };

  public shared ({ caller }) func notifyAppsOfTransfer(leagueId: FootballTypes.LeagueId, playerId: FootballTypes.PlayerId) : async Result.Result<(), T.Error> {
    assert Principal.toText(caller) == Environment.DATA_CANISTER_ID;
    //TODO
    return #ok();
  };

  public shared ({ caller }) func notifyAppsOfRetirement(leagueId: FootballTypes.LeagueId, playerId: FootballTypes.PlayerId) : async Result.Result<(), T.Error> {
    assert Principal.toText(caller) == Environment.DATA_CANISTER_ID;

    //TODO

    return #ok();
  };

  public shared ({ caller }) func notifyAppsOfPositionChange(leagueId: FootballTypes.LeagueId, playerId: FootballTypes.PlayerId) : async Result.Result<(), T.Error> {
    assert Principal.toText(caller) == Environment.DATA_CANISTER_ID;
    //TODO
    return #ok();
  };

  public shared ({ caller }) func notifyAppsOfGameweekStarting(leagueId: FootballTypes.LeagueId, seasonId: FootballTypes.SeasonId, gameweek: FootballTypes.GameweekNumber) : async Result.Result<(), T.Error> {
    assert Principal.toText(caller) == Environment.DATA_CANISTER_ID;
    //TODO
    return #ok();
  };

  public shared ({ caller }) func notifyAppsOfFixtureComplete(leagueId: FootballTypes.LeagueId, seasonId: FootballTypes.SeasonId, gameweek: FootballTypes.GameweekNumber) : async Result.Result<(), T.Error> {
    assert Principal.toText(caller) == Environment.DATA_CANISTER_ID;
    let leagueStatusResult = await getLeagueStatus(leagueId);
    switch (leagueStatusResult) {
      case (#ok leagueStatus) {
        await oddsManager.recalculate(leagueId, seasonId,leagueStatus);
        return #ok();
      };
      case (#err error) {
        return #err(error);
      };
    };
    return #ok();
  };

  public shared ({ caller }) func notifyAppsOfFixtureFinalised(leagueId: FootballTypes.LeagueId, seasonId: FootballTypes.SeasonId, gameweek: FootballTypes.GameweekNumber) : async Result.Result<(), T.Error> {
    
    assert Principal.toText(caller) == Environment.DATA_CANISTER_ID;

    let leagueStatusResult = await getLeagueStatus(leagueId);
    switch (leagueStatusResult) {
      case (#ok leagueStatus) {
        await oddsManager.recalculate(leagueId, seasonId,leagueStatus);
        //settleBets();
        return #ok();
      };
      case (#err error) {
        return #err(error);
      };
    };

  };


  public shared ({ caller }) func notifyAppsOfSeasonComplete(leagueId: FootballTypes.LeagueId, seasonId: FootballTypes.SeasonId) : async Result.Result<(), T.Error> {
    
    assert Principal.toText(caller) == Environment.DATA_CANISTER_ID;
    
    //TODO
    
    return #ok();
  };

  private func getLeagueStatus(leagueId: FootballTypes.LeagueId) : async Result.Result<FootballTypes.LeagueStatus, T.Error> {
    let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
      getLeagueStatus : shared query (leagueId : FootballTypes.LeagueId) -> async Result.Result<FootballTypes.LeagueStatus, T.Error>;
    };
    return await data_canister.getLeagueStatus(leagueId);
  };

   
};
