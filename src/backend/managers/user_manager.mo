import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Buffer "mo:base/Buffer";
import Cycles "mo:base/ExperimentalCycles";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Nat8 "mo:base/Nat8";
import Nat64 "mo:base/Nat64";
import Option "mo:base/Option";
import Order "mo:base/Order";
import Principal "mo:base/Principal";
import Time "mo:base/Time";
import List "mo:base/List";

import T "../types/app_types";
import BettingTypes "../types/betting_types";
import Ids "mo:waterway-mops/Ids";
import FootballTypes "mo:waterway-mops/football/FootballTypes";
import Enums "mo:waterway-mops/Enums";
import Management "mo:waterway-mops/Management";
import Account "mo:waterway-mops/Account";
import FixtureQueries "mo:waterway-mops/queries/football-queries/FixtureQueries";
import CanisterIds "mo:waterway-mops/CanisterIds";
import Constants "mo:waterway-mops/Constants";
import ProfileCanister "../canister_definitions/profile-canister";

import BettingUtilities "../utilities/betting_utilities";
import Environment "../environment";
import Utilities "../utilities/utilities";
import AppTypes "../types/app_types";
import UserCommands "../commands/user_commands";
import BettingQueries "../queries/betting_queries";
import UserQueries "../queries/user_queries";
import AuditQueries "../queries/audit_queries";
import IcfcLedger "../mops/interfaces/ICFCLedger";
import BettingEnums "../enums/betting_enums";
import ProfileCanisterQueries "../queries/profile_canister_queries";
import ProfileCanisterCommands "../commands/profile_canister_commands";

module {

  public class UserManager() {

    private var profileCanisterIds: [(Ids.PrincipalId, Ids.CanisterId)] = [];
    private var uniqueProfileCanisterIds: [Ids.CanisterId] = [];
    private var activeProfileCanisterId = "";
    private var usernames: [(Ids.PrincipalId, Text)] = [];
    
    public func getProfile(principalId : Text, kycProfile: ?AppTypes.KYCProfile) : async Result.Result<UserQueries.Profile, Enums.Error> {
      await checkOrCreateProfile(principalId);
      let profileCanisterId = Array.find(profileCanisterIds, func(profileCanisterEntry: (Ids.PrincipalId, Ids.CanisterId)) : Bool {
        profileCanisterEntry.0 == principalId;
      });

      switch(profileCanisterId){
        case (?foundCanisterId){
          let profile_canister = actor (foundCanisterId.1) : actor {
            getProfile : (dto: ProfileCanisterQueries.GetProfile) -> async Result.Result<ProfileCanisterQueries.Profile, Enums.Error>;
          };
          let profileResult = await profile_canister.getProfile({principalId});

          var kycApprovalDate: Int = 0;
          var kycComplete = false;
          var kycRef = "";
          var kycSubmissionDate: Int = 0;

          switch(kycProfile){
            case (?foundKYCProfile){
              kycRef := foundKYCProfile.reference;
              kycSubmissionDate := foundKYCProfile.kycSubmissionDate;
              switch(foundKYCProfile.shuftiResponse){
                case (?foundResponse){
                  switch(foundResponse){
                    case(#ShuftiAcceptedResponse accepted){
                      kycComplete := foundKYCProfile.kycApprovalDate < Time.now() and accepted.event == "verification.accepted";
                      kycApprovalDate := foundKYCProfile.kycApprovalDate;
                    };
                    case (_){}
                  };
                };
                case (null){}
              };
            };
            case (null){}
          };
          

          switch(profileResult){
            case (#ok profile){
              return #ok({
                accountBalance = profile.accountBalance;
                accountOnPause = profile.accountOnPause;
                joinedDate = profile.joinedDate;
                kycApprovalDate = kycApprovalDate;
                kycComplete = kycComplete;
                kycRef = kycRef;
                kycSubmissionDate = kycSubmissionDate;
                maxBetLimit = profile.maxBetLimit;
                monthlyBetLimit = profile.monthlyBetLimit;
                monthlyBetTotal = profile.monthlyBetTotal;
                principalId = profile.principalId;
                profilePicture = profile.profilePicture;
                profilePictureExtension = profile.profilePictureExtension;
                termsAcceptedDate = profile.termsAcceptedDate;
                username = profile.username;
                withdrawalAddress = profile.withdrawalAddress;
              });
            };
            case (_){
              return #err(#NotFound);
            }
          }
        };
        case (null){
          return #err(#NotFound);
        }
      };
    };



    public func  agreeTerms(principalId: Ids.PrincipalId) : async Result.Result<(), Enums.Error> {
      
      await checkOrCreateProfile(principalId);
      
      let userProfileCanisterId = Array.find<(Ids.PrincipalId, Ids.CanisterId)>(profileCanisterIds, func(entry: (Ids.PrincipalId, Ids.CanisterId)) : Bool {
        entry.0 == principalId;
      });

      switch(userProfileCanisterId){
        case (?foundCanisterId){

          let profile_canister = actor (foundCanisterId.1) : actor {
            acceptTerms : (dto: ProfileCanisterCommands.AcceptTerms) -> async Result.Result<(), Enums.Error>;
          };
          let result = await profile_canister.acceptTerms({ principalId });
          return result;
        };
        case (null){
          return #err(#NotFound);
        }
      };
    };

    public func pauseAccount(principalId: Ids.PrincipalId, dto: UserCommands.PauseAccount) : async Result.Result<(), Enums.Error> {
      await checkOrCreateProfile(principalId);
      let userProfileCanisterId = Array.find<(Ids.PrincipalId, Ids.CanisterId)>(profileCanisterIds, func(entry: (Ids.PrincipalId, Ids.CanisterId)) : Bool {
        entry.0 == principalId;
      });

      switch(userProfileCanisterId){
        case (?foundCanisterId){
          let profile_canister = actor (foundCanisterId.1) : actor {
            pauseAccount : (dto: ProfileCanisterCommands.PauseAccount) -> async Result.Result<(), Enums.Error>;
          };
          return await profile_canister.pauseAccount({principalId; pauseDays = dto.pauseDays});
        };
        case (null){
          return #err(#NotFound);
        }
      };
    };

    public func setDailyBetLimit(principalId: Ids.PrincipalId, dto: UserCommands.SetDailyBetLimit) : async Result.Result<(), Enums.Error> {
      await checkOrCreateProfile(dto.principalId);
      let userProfileCanisterId = Array.find<(Ids.PrincipalId, Ids.CanisterId)>(profileCanisterIds, func(entry: (Ids.PrincipalId, Ids.CanisterId)) : Bool {
        entry.0 == dto.principalId;
      });

      switch(userProfileCanisterId){
        case (?foundCanisterId){
          let profile_canister = actor (foundCanisterId.1) : actor {
            setMaxBetLimit : (dto: UserCommands.SetDailyBetLimit) -> async Result.Result<(), Enums.Error>;
          };
          return await profile_canister.setMaxBetLimit(dto);
        };
        case (null){
          return #err(#NotFound);
        }
      };
    };

    public func setMonthlyBetLimit(principalId: Ids.PrincipalId, dto: UserCommands.SetMonthlyBetLimit) : async Result.Result<(), Enums.Error> {
      await checkOrCreateProfile(dto.principalId);
      let userProfileCanisterId = Array.find<(Ids.PrincipalId, Ids.CanisterId)>(profileCanisterIds, func(entry: (Ids.PrincipalId, Ids.CanisterId)) : Bool {
        entry.0 == dto.principalId;
      });

      switch(userProfileCanisterId){
        case (?foundCanisterId){
          let profile_canister = actor (foundCanisterId.1) : actor {
            setMonthlyBetLimit : (dto: UserCommands.SetMonthlyBetLimit) -> async Result.Result<(), Enums.Error>;
          };
          return await profile_canister.setMonthlyBetLimit(dto);
        };
        case (null){
          return #err(#NotFound);
        }
      };
    };

    public func placeBet(principalId: Ids.PrincipalId, dto: BettingCommands.SubmitBetslip) : async Result.Result<BettingTypes.BetSlip, Enums.Error> {
      await checkOrCreateProfile(dto.principalId);
      let userProfileCanisterId = Array.find<(Ids.PrincipalId, Ids.CanisterId)>(profileCanisterIds, func(entry: (Ids.PrincipalId, Ids.CanisterId)) : Bool {
        entry.0 == dto.principalId;
      });

      switch(userProfileCanisterId){
        case (?foundCanisterId){
          let profile_canister = actor (foundCanisterId.1) : actor {
            placeBet : (dto: BettingCommands.SubmitBetslip) -> async Result.Result<BettingTypes.BetSlip, Enums.Error>;
          };
          return await profile_canister.placeBet(dto);
        };
        case (null){
          return #err(#NotFound);
        }
      };
    };

    public func getUserBets(principalId: Ids.PrincipalId, dto: BettingQueries.GetUserBets) : async Result.Result<BettingQueries.UserBets, Enums.Error>{
      await checkOrCreateProfile(dto.principalId);
      let userProfileCanisterId = Array.find<(Ids.PrincipalId, Ids.CanisterId)>(profileCanisterIds, func(entry: (Ids.PrincipalId, Ids.CanisterId)) : Bool {
        entry.0 == dto.principalId;
      });

      switch(userProfileCanisterId){
        case (?foundCanisterId){
          let profile_canister = actor (foundCanisterId.1) : actor {
            getUserBets : (dto: BettingQueries.GetUserBets) -> async Result.Result<BettingQueries.UserBets, Enums.Error>;
          };
          return await profile_canister.getUserBets(dto);
        };
        case (null){
          return #err(#NotFound);
        }
      };
    };

    public func settleBet(dto: MopsLeagueNotificationCommands.CompleteFixtureNotification) : async () {
      
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        getBetslipFixtures : shared query (dto: BettingQueries.GetBetslipFixtures) -> async Result.Result<[FixtureQueries.Fixture], Enums.Error>;
      };
      let fixturesResult = await data_canister.getBetslipFixtures({
        selections = unsettledBetslip.selections;
      });

      switch(fixturesResult){
        case (#ok betFixtures){ 

          let updatedSelectionBuffer = Buffer.fromArray<BettingTypes.Selection>([]);
          label selectionLoop for(selection in Iter.fromArray(unsettledBetslip.selections)){
            let fixtureResult = Array.find<FixtureQueries.Fixture>(betFixtures, func (fixture: FixtureQueries.Fixture) : Bool {
              fixture.id == selection.fixtureId;
            });

            switch(fixtureResult){
              case (?fixture){
                switch(selection.selectionDetail){
                  case(#AnytimeAssist detail){
                    let foundAssist = Array.find<FootballTypes.PlayerEventData>(fixture.events, func(playerEvent: FootballTypes.PlayerEventData) : Bool {
                      playerEvent.eventType == #GoalAssisted and playerEvent.playerId == detail.playerId;
                    });

                    if(Option.isSome(foundAssist)){
                      updatedSelectionBuffer.add(BettingUtilities.createWinningSelection(selection));
                    } else {
                      updatedSelectionBuffer.add(BettingUtilities.createLosingSelection(selection));
                    };
                  };
                  case(#AnytimeGoalscorer detail){
                    let foundGoal = Array.find<FootballTypes.PlayerEventData>(fixture.events, func(playerEvent: FootballTypes.PlayerEventData) : Bool {
                      playerEvent.eventType == #Goal and playerEvent.playerId == detail.playerId;
                    });

                    if(Option.isSome(foundGoal)){
                      updatedSelectionBuffer.add(BettingUtilities.createWinningSelection(selection));
                    } else {
                      updatedSelectionBuffer.add(BettingUtilities.createLosingSelection(selection));
                    };
                  };
                  case(#BothTeamsToScore detail){

                    var correctResult = false;

                    if(
                      detail.bothTeamsToScore and 
                      fixture.homeGoals > 0 and 
                      fixture.awayGoals > 0){
                        correctResult := true;
                    };

                    if(
                      not detail.bothTeamsToScore and 
                      (fixture.homeGoals == 0 or 
                      fixture.awayGoals == 0)){
                        correctResult := true;
                    };

                    if(correctResult){
                      updatedSelectionBuffer.add(BettingUtilities.createWinningSelection(selection));
                    } else {
                      updatedSelectionBuffer.add(BettingUtilities.createLosingSelection(selection));
                    }
                  };
                  case(#BothTeamsToScoreAndWinner detail){

                    var correctScoreResult = false;

                    if(
                      detail.bothTeamsToScore and 
                      fixture.homeGoals > 0 and 
                      fixture.awayGoals > 0){
                        correctScoreResult := true;
                    };

                    if(
                      not detail.bothTeamsToScore and 
                      (fixture.homeGoals == 0 or 
                      fixture.awayGoals == 0)){
                        correctScoreResult := true;
                    };

                    var correctWinnerResult = false;

                    if(detail.matchResult == #HomeWin and fixture.homeGoals > fixture.awayGoals){
                      correctWinnerResult := true;
                    };

                    if(detail.matchResult == #Draw and fixture.homeGoals == fixture.awayGoals){
                      correctWinnerResult := true;
                    };

                    if(detail.matchResult == #AwayWin and fixture.homeGoals < fixture.awayGoals){
                      correctWinnerResult := true;
                    };

                    if(correctScoreResult and correctWinnerResult){
                      updatedSelectionBuffer.add(BettingUtilities.createWinningSelection(selection));
                    } else {
                      updatedSelectionBuffer.add(BettingUtilities.createLosingSelection(selection));
                    };
                  };
                  case(#CorrectResult detail){
                    var correctResult = false;

                    if(detail.matchResult == #HomeWin and fixture.homeGoals > fixture.awayGoals){
                      correctResult := true;
                    };

                    if(detail.matchResult == #Draw and fixture.homeGoals == fixture.awayGoals){
                      correctResult := true;
                    };

                    if(detail.matchResult == #AwayWin and fixture.homeGoals < fixture.awayGoals){
                      correctResult := true;
                    };

                    if(correctResult){
                      updatedSelectionBuffer.add(BettingUtilities.createWinningSelection(selection));
                    } else {
                      updatedSelectionBuffer.add(BettingUtilities.createLosingSelection(selection));
                    };
                  };
                  case(#CorrectScore detail){
                    let correctResult = detail.homeGoals == fixture.homeGoals and detail.awayGoals == fixture.awayGoals;
                    if(correctResult){
                      updatedSelectionBuffer.add(BettingUtilities.createWinningSelection(selection));
                    } else {
                      updatedSelectionBuffer.add(BettingUtilities.createLosingSelection(selection));
                    };
                  };
                  case(#FirstAssist detail){
                    let assists = Array.filter<FootballTypes.PlayerEventData>(fixture.events, func(playerEvent: FootballTypes.PlayerEventData){
                      playerEvent.eventType == #GoalAssisted;
                    });
                    
                    if(Array.size(assists) == 0){
                      updatedSelectionBuffer.add(BettingUtilities.createLosingSelection(selection));
                      continue selectionLoop;
                    };

                    let sortedAssists = Array.sort(
                      assists,
                      func(a : FootballTypes.PlayerEventData, b : FootballTypes.PlayerEventData) : Order.Order {
                        if (a.eventEndMinute < b.eventEndMinute) { return #less };
                        if (a.eventEndMinute == b.eventEndMinute) { return #equal };
                        return #greater;
                      },
                    );


                    let firstAssist = sortedAssists[0];
                    if(firstAssist.playerId == detail.playerId){
                      updatedSelectionBuffer.add(BettingUtilities.createWinningSelection(selection));
                    } else {
                      updatedSelectionBuffer.add(BettingUtilities.createLosingSelection(selection));
                    };
                  };
                  case(#FirstGoalscorer detail){
                    let goals = Array.filter<FootballTypes.PlayerEventData>(fixture.events, func(playerEvent: FootballTypes.PlayerEventData){
                      playerEvent.eventType == #Goal;
                    });
                    
                    if(Array.size(goals) == 0){
                      updatedSelectionBuffer.add(BettingUtilities.createLosingSelection(selection));
                      continue selectionLoop;
                    };

                    let sortedGoals = Array.sort(
                      goals,
                      func(a : FootballTypes.PlayerEventData, b : FootballTypes.PlayerEventData) : Order.Order {
                        if (a.eventEndMinute < b.eventEndMinute) { return #less };
                        if (a.eventEndMinute == b.eventEndMinute) { return #equal };
                        return #greater;
                      },
                    );

                    let firstGoal = sortedGoals[0];
                    if(firstGoal.playerId == detail.playerId){
                      updatedSelectionBuffer.add(BettingUtilities.createWinningSelection(selection));
                    } else {
                      updatedSelectionBuffer.add(BettingUtilities.createLosingSelection(selection));
                    };
                  };
                  case(#HalfTimeFullTimeResult detail){
                    let firstHalfHomeGoals = Array.size(Array.filter<FootballTypes.PlayerEventData>(fixture.events, func(playerEvent: FootballTypes.PlayerEventData){
                      playerEvent.eventType == #Goal and 
                      playerEvent.clubId == fixture.homeClubId and 
                      playerEvent.eventEndMinute <= 45;
                    }));

                    let firstHalfAwayGoals = Array.size(Array.filter<FootballTypes.PlayerEventData>(fixture.events, func(playerEvent: FootballTypes.PlayerEventData){
                      playerEvent.eventType == #Goal and 
                      playerEvent.clubId == fixture.awayClubId and 
                      playerEvent.eventEndMinute <= 45;
                    }));

                    var firstHalfResult: BettingTypes.MatchResult = #Draw;

                    if(firstHalfHomeGoals > firstHalfAwayGoals) {
                      firstHalfResult := #HomeWin;
                    };

                    if(firstHalfHomeGoals < firstHalfAwayGoals) {
                      firstHalfResult := #AwayWin;
                    };

                    let homeGoals = Array.size(Array.filter<FootballTypes.PlayerEventData>(fixture.events, func(playerEvent: FootballTypes.PlayerEventData){
                      playerEvent.eventType == #Goal and 
                      playerEvent.clubId == fixture.homeClubId
                    }));

                    let awayGoals = Array.size(Array.filter<FootballTypes.PlayerEventData>(fixture.events, func(playerEvent: FootballTypes.PlayerEventData){
                      playerEvent.eventType == #Goal and 
                      playerEvent.clubId == fixture.awayClubId
                    }));

                    var matchResult: BettingTypes.MatchResult = #Draw;

                    if(homeGoals > awayGoals) {
                      matchResult := #HomeWin;
                    };

                    if(homeGoals < awayGoals) {
                      matchResult := #AwayWin;
                    };

                    if(detail.halfTimeResult == firstHalfResult and detail.fullTimeResult == matchResult){
                      updatedSelectionBuffer.add(BettingUtilities.createWinningSelection(selection));
                    } else {
                      updatedSelectionBuffer.add(BettingUtilities.createLosingSelection(selection));
                    };                  
                  };
                  case(#HalfTimeScore detail){
                    let firstHalfHomeGoals = Array.size(Array.filter<FootballTypes.PlayerEventData>(fixture.events, func(playerEvent: FootballTypes.PlayerEventData){
                      playerEvent.eventType == #Goal and 
                      playerEvent.clubId == fixture.homeClubId and 
                      playerEvent.eventEndMinute <= 45;
                    }));

                    let firstHalfAwayGoals = Array.size(Array.filter<FootballTypes.PlayerEventData>(fixture.events, func(playerEvent: FootballTypes.PlayerEventData){
                      playerEvent.eventType == #Goal and 
                      playerEvent.clubId == fixture.awayClubId and 
                      playerEvent.eventEndMinute <= 45;
                    }));

                    if(detail.homeGoals == Nat8.fromNat(firstHalfHomeGoals) and detail.awayGoals == Nat8.fromNat(firstHalfAwayGoals)){
                      updatedSelectionBuffer.add(BettingUtilities.createWinningSelection(selection));
                    } else {
                      updatedSelectionBuffer.add(BettingUtilities.createLosingSelection(selection));
                    };
                  };
                  case(#LastAssist detail){
                    let assists = Array.filter<FootballTypes.PlayerEventData>(fixture.events, func(playerEvent: FootballTypes.PlayerEventData){
                      playerEvent.eventType == #GoalAssisted;
                    });
                    
                    if(Array.size(assists) == 0){
                      updatedSelectionBuffer.add(BettingUtilities.createLosingSelection(selection));
                      continue selectionLoop;
                    };

                    let sortedAssists = Array.sort(
                      assists,
                      func(a : FootballTypes.PlayerEventData, b : FootballTypes.PlayerEventData) : Order.Order {
                        if (a.eventEndMinute < b.eventEndMinute) { return #less };
                        if (a.eventEndMinute == b.eventEndMinute) { return #equal };
                        return #greater;
                      },
                    );


                    let lastAssist = sortedAssists[Array.size(sortedAssists) - 1];
                    if(lastAssist.playerId == detail.playerId){
                      updatedSelectionBuffer.add(BettingUtilities.createWinningSelection(selection));
                    } else {
                      updatedSelectionBuffer.add(BettingUtilities.createLosingSelection(selection));
                    };
                  };
                  case(#LastGoalscorer detail){
                    let goals = Array.filter<FootballTypes.PlayerEventData>(fixture.events, func(playerEvent: FootballTypes.PlayerEventData){
                      playerEvent.eventType == #Goal;
                    });
                    
                    if(Array.size(goals) == 0){
                      updatedSelectionBuffer.add(BettingUtilities.createLosingSelection(selection));
                      continue selectionLoop;
                    };

                    let sortedGoals = Array.sort(
                      goals,
                      func(a : FootballTypes.PlayerEventData, b : FootballTypes.PlayerEventData) : Order.Order {
                        if (a.eventEndMinute < b.eventEndMinute) { return #less };
                        if (a.eventEndMinute == b.eventEndMinute) { return #equal };
                        return #greater;
                      },
                    );

                    let lastGoal = sortedGoals[Array.size(sortedGoals) - 1];
                    if(lastGoal.playerId == detail.playerId){
                      updatedSelectionBuffer.add(BettingUtilities.createWinningSelection(selection));
                    } else {
                      updatedSelectionBuffer.add(BettingUtilities.createLosingSelection(selection));
                    };
                  };
                  case(#MissPenalty detail){
                    let foundMissedPenalty = Array.find<FootballTypes.PlayerEventData>(fixture.events, func(playerEvent: FootballTypes.PlayerEventData) : Bool {
                      playerEvent.eventType == #PenaltyMissed and playerEvent.playerId == detail.playerId;
                    });

                    if(Option.isSome(foundMissedPenalty)){
                      updatedSelectionBuffer.add(BettingUtilities.createWinningSelection(selection));
                    } else {
                      updatedSelectionBuffer.add(BettingUtilities.createLosingSelection(selection));
                    };
                  };
                  case(#PenaltyMissed detail){
                    let foundMissedPenalty = Array.find<FootballTypes.PlayerEventData>(fixture.events, func(playerEvent: FootballTypes.PlayerEventData) : Bool {
                      playerEvent.eventType == #PenaltyMissed and playerEvent.clubId == detail.clubId;
                    });

                    if(Option.isSome(foundMissedPenalty)){
                      updatedSelectionBuffer.add(BettingUtilities.createWinningSelection(selection));
                    } else {
                      updatedSelectionBuffer.add(BettingUtilities.createLosingSelection(selection));
                    };
                  };
                  case(#RedCard detail){
                    let foundRedCard = Array.find<FootballTypes.PlayerEventData>(fixture.events, func(playerEvent: FootballTypes.PlayerEventData) : Bool {
                      playerEvent.eventType == #RedCard and playerEvent.playerId == detail.playerId;
                    });

                    if(Option.isSome(foundRedCard)){
                      updatedSelectionBuffer.add(BettingUtilities.createWinningSelection(selection));
                    } else {
                      updatedSelectionBuffer.add(BettingUtilities.createLosingSelection(selection));
                    };
                  };
                  case(#ScoreBrace detail){
                    let playerGoals = Array.filter<FootballTypes.PlayerEventData>(fixture.events, func(playerEvent: FootballTypes.PlayerEventData){
                      playerEvent.eventType == #Goal and playerEvent.playerId == detail.playerId;
                    });
                    if(Array.size(playerGoals) >= 2){
                      updatedSelectionBuffer.add(BettingUtilities.createWinningSelection(selection));
                    } else {
                      updatedSelectionBuffer.add(BettingUtilities.createLosingSelection(selection));
                    }
                  };
                  case(#ScoreHatrick detail){
                    let playerGoals = Array.filter<FootballTypes.PlayerEventData>(fixture.events, func(playerEvent: FootballTypes.PlayerEventData){
                      playerEvent.eventType == #Goal and playerEvent.playerId == detail.playerId;
                    });
                    if(Array.size(playerGoals) >= 3){
                      updatedSelectionBuffer.add(BettingUtilities.createWinningSelection(selection));
                    } else {
                      updatedSelectionBuffer.add(BettingUtilities.createLosingSelection(selection));
                    }
                  };
                  case(#YellowCard detail){
                    let foundYellowCard = Array.find<FootballTypes.PlayerEventData>(fixture.events, func(playerEvent: FootballTypes.PlayerEventData) : Bool {
                      playerEvent.eventType == #YellowCard and playerEvent.playerId == detail.playerId;
                    });

                    if(Option.isSome(foundYellowCard)){
                      updatedSelectionBuffer.add(BettingUtilities.createWinningSelection(selection));
                    } else {
                      updatedSelectionBuffer.add(BettingUtilities.createLosingSelection(selection));
                    };
                  };
                };

              };
              case (null){}
            };          
          };  

          let betslip: BettingTypes.BetSlip = {
            betType = unsettledBetslip.betType;
            id = unsettledBetslip.id;
            placedBy = unsettledBetslip.placedBy;
            placedOn = unsettledBetslip.placedOn;
            result = unsettledBetslip.result;
            selections = Buffer.toArray(updatedSelectionBuffer);
            settledOn = unsettledBetslip.settledOn;
            status = unsettledBetslip.status;
            totalStake = unsettledBetslip.totalStake;
            expectedReturns = unsettledBetslip.expectedReturns;
            totalWinnings = unsettledBetslip.totalWinnings;
          };
          
          var betResult: BettingEnums.BetResult = #Lost;
          var perfectBetResult: BettingEnums.BetResult = #Lost;
          
          let losingSelections = Array.filter<BettingTypes.Selection>(betslip.selections, func(selection: BettingTypes.Selection) {
            selection.result == #Lost;
          });
          if(Array.size(losingSelections) == 0){
            perfectBetResult := #Won;
          };
          var totalWinnings: Nat64 = 0;

          switch(betslip.betType){
            case (#Single){
              if(Array.size(betslip.selections) != 1){
                await voidBet(betslip);
                return;
              };
              if(perfectBetResult == #Won){
                totalWinnings := BettingUtilities.getCumulativeSelectionWinnings(betslip);
                betResult := #Won;
              };
            };
            case (#Double){
              if(Array.size(betslip.selections) != 2){
                await voidBet(betslip);
                return;
              };
              if(perfectBetResult == #Won){
                totalWinnings := BettingUtilities.getCumulativeSelectionWinnings(betslip);
                betResult := #Won;
              };
            };
            case (#Treble){
              if(Array.size(betslip.selections) != 3){
                await voidBet(betslip);
                return;
              };
              if(perfectBetResult == #Won){
                totalWinnings := BettingUtilities.getCumulativeSelectionWinnings(betslip);
                betResult := #Won;
              };
            };
            case (#FourFold){
              if(Array.size(betslip.selections) != 4){
                await voidBet(betslip);
                return;
              };
              if(perfectBetResult == #Won){
                totalWinnings := BettingUtilities.getCumulativeSelectionWinnings(betslip);
                betResult := #Won;
              };
            };
            case (#FiveFold){
              if(Array.size(betslip.selections) != 5){
                await voidBet(betslip);
                return;
              };
              if(perfectBetResult == #Won){
                totalWinnings := BettingUtilities.getCumulativeSelectionWinnings(betslip);
                betResult := #Won;
              };
            };
            case (#SixFold){
              if(Array.size(betslip.selections) != 6){
                await voidBet(betslip);
                return;
              };
              if(perfectBetResult == #Won){
                totalWinnings := BettingUtilities.getCumulativeSelectionWinnings(betslip);
                betResult := #Won;
              };
            };
            case (#SevenFold){
              if(Array.size(betslip.selections) != 7){
                await voidBet(betslip);
                return;
              };
              if(perfectBetResult == #Won){
                totalWinnings := BettingUtilities.getCumulativeSelectionWinnings(betslip);
                betResult := #Won;
              };
            };
            case (#EightFold){
              if(Array.size(betslip.selections) != 8){
                await voidBet(betslip);
                return;
              };
              if(perfectBetResult == #Won){
                totalWinnings := BettingUtilities.getCumulativeSelectionWinnings(betslip);
                betResult := #Won;
              };
            };
            case (#NineFold){
              if(Array.size(betslip.selections) != 9){
                await voidBet(betslip);
                return;
              };
              if(perfectBetResult == #Won){
                totalWinnings := BettingUtilities.getCumulativeSelectionWinnings(betslip);
                betResult := #Won;
              };
            };
            case (#TenFold){
              if(Array.size(betslip.selections) != 10){
                await voidBet(betslip);
                return;
              };
              if(perfectBetResult == #Won){
                totalWinnings := BettingUtilities.getCumulativeSelectionWinnings(betslip);
                betResult := #Won;
              };
            };
            case (#Patent){
              if(Array.size(betslip.selections) != 3){
                await voidBet(betslip);
                return;
              };

              totalWinnings := BettingUtilities.getPatentSelectionWinnings(betslip);

              if(totalWinnings > 0){
                betResult := #Won;
              };
            };
            case (#Trixie){
              if(Array.size(betslip.selections) != 3){
                await voidBet(betslip);
                return;
              };

              totalWinnings := BettingUtilities.getTrixieSelectionWinnings(betslip);

              if(totalWinnings > 0){
                betResult := #Won;
              };
            };
            case (#Yankee){
              if(Array.size(betslip.selections) != 4){
                await voidBet(betslip);
                return;
              };

              totalWinnings := BettingUtilities.getYankeeSelectionWinnings(betslip);

              if(totalWinnings > 0){
                betResult := #Won;
              };
            };
            case (#Lucky15){
              if(Array.size(betslip.selections) != 4){
                await voidBet(betslip);
                return;
              };

              totalWinnings := BettingUtilities.getLucky15SelectionWinnings(betslip);

              if(totalWinnings > 0){
                betResult := #Won;
              };
            };
            case (#Lucky31){
              if(Array.size(betslip.selections) != 5){
                await voidBet(betslip);
                return;
              };

              totalWinnings := BettingUtilities.getLucky31SelectionWinnings(betslip);

              if(totalWinnings > 0){
                betResult := #Won;
              };
            };
            case (#Lucky63){
              if(Array.size(betslip.selections) != 6){
                await voidBet(betslip);
                return;
              };

              totalWinnings := BettingUtilities.getLucky63SelectionWinnings(betslip);

              if(totalWinnings > 0){
                betResult := #Won;
              };
            };
            case (#Canadian){
              if(Array.size(betslip.selections) != 5){
                await voidBet(betslip);
                return;
              };

              totalWinnings := BettingUtilities.getCanadianSelectionWinnings(betslip);

              if(totalWinnings > 0){
                betResult := #Won;
              };
            };
            case (#Heinz){
              if(Array.size(betslip.selections) != 6){
                await voidBet(betslip);
                return;
              };

              totalWinnings := BettingUtilities.getHeinzSelectionWinnings(betslip);

              if(totalWinnings > 0){
                betResult := #Won;
              };
            };
            case (#SuperHeinz){
              if(Array.size(betslip.selections) != 7){
                await voidBet(betslip);
                return;
              };

              totalWinnings := BettingUtilities.getSuperHeinzSelectionWinnings(betslip);

              if(totalWinnings > 0){
                betResult := #Won;
              };
            };
            case (#Goliath){
              if(Array.size(betslip.selections) != 8){
                await voidBet(betslip);
                return;
              };

              totalWinnings := BettingUtilities.getGoliathSelectionWinnings(betslip);

              if(totalWinnings > 0){
                betResult := #Won;
              };
            };

          };
          
          let _ = await payWinnings(betslip.placedBy, totalWinnings);

          let updatedBetSlip: BettingTypes.BetSlip = {
            id = betslip.id;
            placedBy = betslip.placedBy;
            placedOn = betslip.placedOn;
            status = #Settled;
            result = betResult;
            selections = Buffer.toArray(updatedSelectionBuffer);
            betType = betslip.betType;
            totalStake = betslip.totalStake;
            expectedReturns = unsettledBetslip.expectedReturns;
            totalWinnings = totalWinnings;
            settledOn = Time.now();
          };

          let profileCanisterId = Array.find(profileCanisterIds, func(profileCanisterEntry: (Ids.PrincipalId, Ids.CanisterId)) : Bool {
            profileCanisterEntry.0 == betslip.placedBy;
          });

          switch(profileCanisterId){
            case (?foundCanisterId){
              let profile_canister = actor (foundCanisterId.1) : actor {
                updateSettledBet : (principalId : Ids.PrincipalId, betslip: BettingTypes.BetSlip) -> async ();
              };
              return await profile_canister.updateSettledBet(foundCanisterId.0, updatedBetSlip);
            };
            case (null){}
          };
        };
        case (#err _){}
      };
    };


    // TODO confirm the profile create procedure for the golf

    private func createProfileCanister() : async () {
      
      Cycles.add<system>(50_000_000_000_000);
      
      let canister = await ProfileCanister._ProfileCanister();
      
      let canister_principal = Principal.fromActor(canister);
      let canisterId = Principal.toText(canister_principal);
      activeProfileCanisterId := canisterId;
      let uniqueProfileCanisterIdsBuffer = Buffer.fromArray<Ids.CanisterId>(uniqueProfileCanisterIds);
      uniqueProfileCanisterIdsBuffer.add(canisterId);
      uniqueProfileCanisterIds := Buffer.toArray(uniqueProfileCanisterIdsBuffer);
      
      let IC : Management.Management = actor (Environment.Default);
      let _ = await Utilities.updateCanister_(canister, ?Principal.fromText(Environment.BACKEND_CANISTER_ID), IC);
    };

    private func createProfile(principalId: Ids.PrincipalId) : async () {
      let profileCanisterIdsBuffer = Buffer.fromArray<(Ids.PrincipalId, Ids.CanisterId)>(profileCanisterIds);
      
      let profile_canister = actor (activeProfileCanisterId) : actor {
        createProfile : (principalId : Text) -> async Result.Result<(), Enums.Error>;
      };
      let profileResult = await profile_canister.createProfile(principalId);

      switch(profileResult){
        case (#ok _){
          profileCanisterIdsBuffer.add(principalId, activeProfileCanisterId);
          profileCanisterIds := Buffer.toArray(profileCanisterIdsBuffer);
        };
        case (#err _){}
      };    
    };

    private func activeCanisterFull() : async Bool {
      let profile_canister = actor (activeProfileCanisterId) : actor {
        canisterFull : () -> async Bool;
      };
      return await profile_canister.canisterFull();
    };
    
    private func voidBet(betslip: BettingTypes.BetSlip) : async (){
      let profileCanisterId = Array.find(profileCanisterIds, func(profileCanisterEntry: (Ids.PrincipalId, Ids.CanisterId)) : Bool {
        profileCanisterEntry.0 == betslip.placedBy;
      });

      switch(profileCanisterId){
        case (?foundCanisterId){
          
          let profile_canister = actor (foundCanisterId.1) : actor {
            voidBet : (betslip: BettingTypes.BetSlip) -> async ();
          };
          return await profile_canister.voidBet(betslip);
        };
        case (null){ }
      };
      
    };

    // TODO: Confirm this functionality

    private func payWinnings(winnerPrincipalId: Ids.PrincipalId, totalWinnings: Nat64) : async () {
      let ledger : IcfcLedger.Interface = actor (CanisterIds.ICFC_SNS_LEDGER_CANISTER_ID);
          
      let _ = await ledger.icrc1_transfer ({
        memo = ?Text.encodeUtf8("0");
        from_subaccount = ?Account.defaultSubaccount();
        to = {owner = Principal.fromText(winnerPrincipalId); subaccount = null};
        amount = Nat64.toNat(totalWinnings);
        fee = ?Nat64.toNat(Constants.FPL_TRANSACTION_FEE); // TODO JOHN: MOPS RENAME should be ICFC ledger fee
        created_at_time = ?Nat64.fromNat(Int.abs(Time.now()))
      });
    };

    //Stable storage functions

    public func getStableProfileCanisterIds() : [(Ids.PrincipalId, Ids.CanisterId)] {
      return profileCanisterIds;
    };

    public func setStableProfileCanisterIds(stable_profile_canister_ids: [(Ids.PrincipalId, Ids.CanisterId)]) {
      profileCanisterIds := stable_profile_canister_ids;
    };

    public func getStableUniqueProfileCanisterIds () : [Ids.CanisterId] {
      return uniqueProfileCanisterIds;
    };

    public func setStableUniqueProfileCanisterIds(stable_unique_profile_canister_ids: [Ids.CanisterId]){
      uniqueProfileCanisterIds := stable_unique_profile_canister_ids;
    };

    public func getStableActiveProfileCanisterId() : Ids.CanisterId {
      return activeProfileCanisterId;
    };

    public func setStableActiveProfileCanisterId(stable_active_profile_canister_id: Ids.CanisterId) {
      activeProfileCanisterId := stable_active_profile_canister_id;
    };

    public func getStableUsernames() : [(Ids.PrincipalId, Text)] {
      return usernames;
    };

    public func setStableUsernames(stable_usernames: [(Ids.PrincipalId, Text)]) {
      usernames := stable_usernames;
    };

    public func getUserAuditList(offset: Nat) : async [AuditQueries.AuditRecord] {
      
      let allUsersBuffer = Buffer.fromArray<AuditQueries.AuditRecord>([]);
      for(canisterId in Iter.fromArray(uniqueProfileCanisterIds)){
        let profile_canister = actor (canisterId) : actor {
          getUserAuditList : () -> async [AuditQueries.AuditRecord];
        };
        let users = await profile_canister.getUserAuditList();
        allUsersBuffer.append(Buffer.fromArray(users));
      };
      let droppedEntries = List.drop<AuditQueries.AuditRecord>(List.fromArray(Buffer.toArray(allUsersBuffer)), offset);
      return List.toArray(List.take<AuditQueries.AuditRecord>(droppedEntries, 100));
    };

    public func verifyBettingAccount(principalId: Ids.PrincipalId) : async (){
      let profileCanisterId = Array.find(profileCanisterIds, func(profileCanisterEntry: (Ids.PrincipalId, Ids.CanisterId)) : Bool {
        profileCanisterEntry.0 == principalId;
      });

      switch(profileCanisterId){
        case (?foundCanisterId){
          
          let profile_canister = actor (foundCanisterId.1) : actor {
            verifyBettingAccount : (principalId: Ids.PrincipalId) -> async ();
          };
          return await profile_canister.verifyBettingAccount(principalId);
        };
        case (null){ }
      };
    };

  };
};
