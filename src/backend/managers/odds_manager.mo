import T "../types/app_types";
import FootballTypes "mo:waterway-mops/FootballTypes";
import BettingTypes "../types/betting_types";
import Base "mo:waterway-mops/BaseTypes";
import Result "mo:base/Result";
import Array "mo:base/Array";
import Option "mo:base/Option";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import Time "mo:base/Time";
import Nat "mo:base/Nat";
import Environment "../environment";
import OddsGenerator "odds_generator";
import SHA224 "../utilities/SHA224";
import AppDTOs "../dtos/app_dtos";
import FootballDTOs "../dtos/football_dtos";

module {

  public class OddsManager() {

    private var matchOddsCache: [(FootballTypes.LeagueId, [(FootballTypes.FixtureId, BettingTypes.MatchOdds)])] = [];
    private let oddsGenerator = OddsGenerator.OddsGenerator();
  
    public func getHomepageLeagueFixtures(leagueId: FootballTypes.LeagueId) : [AppDTOs.HomePageFixtureDTO] {
 
      let matchOddsResult = Array.find<(FootballTypes.LeagueId, [(FootballTypes.FixtureId, BettingTypes.MatchOdds)])>(matchOddsCache, func(matchOddsCacheEntry: (FootballTypes.LeagueId, [(FootballTypes.FixtureId, BettingTypes.MatchOdds)])) : Bool {
        matchOddsCacheEntry.0 == leagueId;
      });

      switch(matchOddsResult){
        case (?foundMatchOdds){
          return Array.map<(FootballTypes.FixtureId, BettingTypes.MatchOdds), AppDTOs.HomePageFixtureDTO>(foundMatchOdds.1, func (oddsEntry: (FootballTypes.FixtureId, BettingTypes.MatchOdds)) {
            let matchOdds = oddsEntry.1;
            return {
              leagueId = matchOdds.leagueId;
              gameweek = matchOdds.gameweek;
              fixtureId = matchOdds.fixtureId;
              homeOdds = matchOdds.correctResults.homeOdds;
              drawOdds = matchOdds.correctResults.drawOdds;
              awayOdds = matchOdds.correctResults.awayOdds;
            };
          });
        };
        case (null){
          return [];
        }
      };
    };
    
    public func getMatchOdds(leagueId: FootballTypes.LeagueId, fixtureId: FootballTypes.FixtureId) : Result.Result<AppDTOs.MatchOddsDTO, T.Error> {
      
      let leagueOddsCache = Array.find<(FootballTypes.LeagueId, [(FootballTypes.FixtureId, BettingTypes.MatchOdds)])>(matchOddsCache, 
          func(entry: (FootballTypes.LeagueId, [(FootballTypes.FixtureId, BettingTypes.MatchOdds)])) : Bool {
            entry.0 == leagueId;
      });

      switch(leagueOddsCache){
        case (?foundLeagueOdds){
          let fixtureOddsResult = Array.find<(FootballTypes.FixtureId, BettingTypes.MatchOdds)>(foundLeagueOdds.1, func(entry: (FootballTypes.FixtureId, BettingTypes.MatchOdds)) : Bool {
            entry.0 == fixtureId;
          });
          switch(fixtureOddsResult){
            case (?foundFixtureOdds){
              return #ok(foundFixtureOdds.1);
            };
            case (null){};
          };
        };
        case (null){};
      };
      return #err(#NotFound);
    };

    public func recalculate(leagueId: FootballTypes.LeagueId, seasonId: FootballTypes.SeasonId) : async () {
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        getFixtures : shared query (leagueId: FootballTypes.LeagueId, seasonId: FootballTypes.SeasonId) -> async Result.Result<[FootballDTOs.FixtureDTO], T.Error>;
        getPlayers : shared query (leagueId: FootballTypes.LeagueId) -> async Result.Result<[FootballDTOs.PlayerDTO], T.Error>;
      };
      let fixturesResult = await data_canister.getFixtures(leagueId, seasonId);
      let playersResult = await data_canister.getPlayers(leagueId);

      matchOddsCache := Array.map<(FootballTypes.LeagueId, [(FootballTypes.FixtureId, BettingTypes.MatchOdds)]), (FootballTypes.LeagueId, [(FootballTypes.FixtureId, BettingTypes.MatchOdds)])>(matchOddsCache, func(entry: (FootballTypes.LeagueId, [(FootballTypes.FixtureId, BettingTypes.MatchOdds)])){
        if(entry.0 == leagueId){
          return (entry.0, [])
        } else {
          return entry;
        }
      }); 
      
      switch(fixturesResult){
        case (#ok fixtures){
          let futureFixtures = Array.filter<FootballDTOs.FixtureDTO>(fixtures, func(fixtureEntry: FootballDTOs.FixtureDTO){
            fixtureEntry.status == #Unplayed and fixtureEntry.kickOff > Time.now();
          }); 
          switch(playersResult){
            case (#ok players){
  
              for(fixture in Iter.fromArray(futureFixtures)){

                let fixturePlayers = Array.filter<FootballDTOs.PlayerDTO>(players, func(player: FootballDTOs.PlayerDTO){
                  player.clubId == fixture.homeClubId or player.clubId == fixture.awayClubId
                });
                
                let firstAssistersOddsBuffer = Buffer.fromArray<BettingTypes.PlayerSelectionOdds>([]);
                let firstGoalscorersOddsBuffer = Buffer.fromArray<BettingTypes.PlayerSelectionOdds>([]);
                let anytimeAssistOddsBuffer = Buffer.fromArray<BettingTypes.PlayerSelectionOdds>([]);
                let anytimeScorerOddsBuffer = Buffer.fromArray<BettingTypes.PlayerSelectionOdds>([]);
                let lastAssistOddsBuffer = Buffer.fromArray<BettingTypes.PlayerSelectionOdds>([]);
                let lastGoalscorerOddsBuffer = Buffer.fromArray<BettingTypes.PlayerSelectionOdds>([]);
                let scoresBraceOddsBuffer = Buffer.fromArray<BettingTypes.PlayerSelectionOdds>([]);
                let scoresHatTrickOddsBuffer = Buffer.fromArray<BettingTypes.PlayerSelectionOdds>([]);
                let penaltyMissersOddsBuffer = Buffer.fromArray<BettingTypes.PlayerSelectionOdds>([]);
                let yellowCardsOddsBuffer = Buffer.fromArray<BettingTypes.PlayerSelectionOdds>([]);
                let redCardsOddsBuffer = Buffer.fromArray<BettingTypes.PlayerSelectionOdds>([]);
                
                for(player in Iter.fromArray(fixturePlayers)){

                  firstAssistersOddsBuffer.add({
                    playerId = player.id;
                    odds = oddsGenerator.getFirstAssistOdds(fixtures, fixture, player);
                  });

                  firstGoalscorersOddsBuffer.add({
                    playerId = player.id;
                    odds = oddsGenerator.getFirstGoalscorerOdds(fixtures, fixture, player);
                  });

                  anytimeAssistOddsBuffer.add({
                    playerId = player.id;
                    odds = oddsGenerator.getAnytimeAssistOdds(fixtures, fixture, player);
                  });

                  anytimeScorerOddsBuffer.add({
                    playerId = player.id;
                    odds = oddsGenerator.getAnytimeScorerOdds(fixtures, fixture, player);
                  });

                  lastAssistOddsBuffer.add({
                    playerId = player.id;
                    odds = oddsGenerator.getLastAssistOdds(fixtures, fixture, player);
                  });

                  lastGoalscorerOddsBuffer.add({
                    playerId = player.id;
                    odds = oddsGenerator.getLastScorerOdds(fixtures, fixture, player);
                  });

                  scoresBraceOddsBuffer.add({
                    playerId = player.id;
                    odds = oddsGenerator.getScoresBraceOdds(player, player.clubId == fixture.homeClubId);
                  });

                  scoresHatTrickOddsBuffer.add({
                    playerId = player.id;
                    odds = oddsGenerator.getScoreHatrickOdds(player, player.clubId == fixture.homeClubId);
                  });

                  penaltyMissersOddsBuffer.add({
                    playerId = player.id;
                    odds = oddsGenerator.getMissesPenaltyOdds(player, player.clubId == fixture.homeClubId);
                  });

                  yellowCardsOddsBuffer.add({
                    playerId = player.id;
                    odds = oddsGenerator.getYellowCardsOdds(player, player.clubId == fixture.homeClubId);
                  });

                  redCardsOddsBuffer.add({
                    playerId = player.id;
                    odds = oddsGenerator.getRedCardsOdds(player, player.clubId == fixture.homeClubId);
                  });

                };
                
                
                let bothTeamsToScoreOdds = oddsGenerator.getBothTeamsToScoreOdds();
                let bothTeamsToScoreAndWinnerOdds = oddsGenerator.getBothTeamsToScoreAndWinnerOdds();
                let correctResultsOdds = oddsGenerator.getCorrectResultOdds(fixtures, fixture);
                let correctScoresOdds = oddsGenerator.getCorrectScoreOdds();
                let goalsOverUnderOdds = oddsGenerator.getGoalsOverUnderOdds();
                let halfTimeFullTimeResultOdds = oddsGenerator.getHalfTimeFullTimeResultOdds();
                let halfTimeScoresOdds = oddsGenerator.getHalfTimeScoreOdds();
                let penaltyMissedOdds = oddsGenerator.getPenaltyMissedOdds();

                let matchOdds: BettingTypes.MatchOdds = {
                  leagueId = leagueId;
                  gameweek = fixture.gameweek;
                  fixtureId = fixture.id;
                  anytimeAssist = Buffer.toArray(anytimeAssistOddsBuffer);
                  anytimeScorers = Buffer.toArray(anytimeScorerOddsBuffer);
                  bothTeamsToScore = bothTeamsToScoreOdds;
                  bothTeamsToScoreAndWinner = bothTeamsToScoreAndWinnerOdds;
                  correctResults = correctResultsOdds;
                  correctScores = correctScoresOdds;
                  firstAssisters = Buffer.toArray(firstAssistersOddsBuffer);
                  firstGoalscorers = Buffer.toArray(firstGoalscorersOddsBuffer);
                  goalsOverUnder = goalsOverUnderOdds;
                  halfTimeFullTimeResult = halfTimeFullTimeResultOdds;
                  halfTimeScores = halfTimeScoresOdds;
                  lastAssist = Buffer.toArray(lastAssistOddsBuffer);
                  lastGoalscorers = Buffer.toArray(lastGoalscorerOddsBuffer);
                  penaltyMissed = penaltyMissedOdds;
                  penaltyMissers = Buffer.toArray(penaltyMissersOddsBuffer);
                  redCards = Buffer.toArray(redCardsOddsBuffer);
                  scoresBrace = Buffer.toArray(scoresBraceOddsBuffer);
                  scoresHatTrick = Buffer.toArray(scoresHatTrickOddsBuffer);
                  yellowCards = Buffer.toArray(yellowCardsOddsBuffer);
                };
                storeMatchOdds(matchOdds);
              };
            };
            case (#err _){};
          };
        };
        case (#err _){}
      };
           
    };

    private func storeMatchOdds(matchOdds: BettingTypes.MatchOdds){
      
      let existingLeague = Array.find<(FootballTypes.LeagueId, [(FootballTypes.FixtureId, BettingTypes.MatchOdds)])>(matchOddsCache, func(entry: (FootballTypes.LeagueId, [(FootballTypes.FixtureId, BettingTypes.MatchOdds)])) : Bool {
        entry.0 == matchOdds.leagueId
      });

      switch(existingLeague){
        case (?foundLeague){
          let existingFixtureOdds = Array.find<(FootballTypes.FixtureId, BettingTypes.MatchOdds)>(foundLeague.1, func(fixtureEntry: (FootballTypes.FixtureId, BettingTypes.MatchOdds)) : Bool {
            fixtureEntry.0 == matchOdds.fixtureId;
          });

          switch(existingFixtureOdds){
            case (?_){
              replaceMatchOdds(matchOdds);
            };
            case (null){
              addNewMatchOdds(matchOdds);
            }
          };
        };
        case (null){
          addInitialLeagueMatchOdds(matchOdds);
        };
      };
    };

    private func replaceMatchOdds(matchOdds: BettingTypes.MatchOdds){
      matchOddsCache := Array.map<(FootballTypes.LeagueId, [(FootballTypes.FixtureId, BettingTypes.MatchOdds)]), (FootballTypes.LeagueId, [(FootballTypes.FixtureId, BettingTypes.MatchOdds)])>(matchOddsCache, func(entry: (FootballTypes.LeagueId, [(FootballTypes.FixtureId, BettingTypes.MatchOdds)])){
        if(entry.0 == matchOdds.leagueId){
          return (entry.0, Array.map<(FootballTypes.FixtureId, BettingTypes.MatchOdds), (FootballTypes.FixtureId, BettingTypes.MatchOdds)>(entry.1, func(matchOddsEntry: (FootballTypes.FixtureId, BettingTypes.MatchOdds)){
            if(matchOddsEntry.0 == matchOdds.fixtureId){
              return (matchOddsEntry.0, matchOdds);
            } else {
              return matchOddsEntry;
            };
          }));
        } else {
          return entry;
        };
      });
    };

    private func addNewMatchOdds(matchOdds: BettingTypes.MatchOdds){
      matchOddsCache := Array.map<(FootballTypes.LeagueId, [(FootballTypes.FixtureId, BettingTypes.MatchOdds)]), (FootballTypes.LeagueId, [(FootballTypes.FixtureId, BettingTypes.MatchOdds)])>(matchOddsCache, func(entry: (FootballTypes.LeagueId, [(FootballTypes.FixtureId, BettingTypes.MatchOdds)])){
        if(entry.0 == matchOdds.leagueId){
          let leagueOddsBuffer = Buffer.fromArray<(FootballTypes.FixtureId, BettingTypes.MatchOdds)>(entry.1);
          leagueOddsBuffer.add((matchOdds.fixtureId, matchOdds));
          return (entry.0, Buffer.toArray(leagueOddsBuffer));
        } else {
          return entry;
        };
      });
    };

    private func addInitialLeagueMatchOdds(matchOdds: BettingTypes.MatchOdds){
      let matchOddsCacheBuffer = Buffer.fromArray<(FootballTypes.LeagueId, [(FootballTypes.FixtureId, BettingTypes.MatchOdds)])>(matchOddsCache);
      matchOddsCacheBuffer.add(matchOdds.leagueId, [(matchOdds.fixtureId, matchOdds)]);
      matchOddsCache := Buffer.toArray(matchOddsCacheBuffer);
    };

    //Stable storage

     private var dataHashes : [Base.DataHash] = [
    ];

    private func findHash(category: Text): ?Base.DataHash {
      return Array.find<Base.DataHash>(dataHashes, func(hashObj: Base.DataHash): Bool {
        hashObj.category == category;
      });
    };

    public func updateDataHash(category : Text) : async () {
      let hashBuffer = Buffer.fromArray<Base.DataHash>([]);
      var updated = false;

      for (hashObj in Iter.fromArray(dataHashes)) {
        if (hashObj.category == category) {
          let randomHash = await SHA224.getRandomHash();
          hashBuffer.add({ category = hashObj.category; hash = randomHash });
          updated := true;
        } else { hashBuffer.add(hashObj) };
      };

      if(not updated){
          let randomHash = await SHA224.getRandomHash();
          hashBuffer.add({ category = category; hash = randomHash });
      };

      dataHashes := Buffer.toArray<Base.DataHash>(hashBuffer);
    };

    public func updateFixtureHash(leagueId: Nat): async () {
      let category = "fixtures_" # Nat.toText(leagueId);
      await updateDataHash(category);
    };

    public func updateClubHash(leagueId: Nat): async () {
      let category = "clubs_" # Nat.toText(leagueId);
      await updateDataHash(category);
    };

    public func updatePlayerHash(leagueId: Nat): async () {
      let category = "players_" # Nat.toText(leagueId);
      await updateDataHash(category);
    };

    public func addNewDataHash(category: Text) : async () {
      let exists = findHash(category);
      if(Option.isNull(exists)){
        let hashBuffer = Buffer.fromArray<Base.DataHash>(dataHashes);
        let randomHash = await SHA224.getRandomHash();
        hashBuffer.add({ category = category; hash = randomHash });
        dataHashes := Buffer.toArray<Base.DataHash>(hashBuffer);
      }
    };
    
    public func getDataHashes() : Result.Result<[AppDTOs.DataHashDTO], T.Error> {
      return #ok(dataHashes)
    };

    public func getStableMatchOddsCache(): [(FootballTypes.LeagueId, [(FootballTypes.FixtureId, BettingTypes.MatchOdds)])]{
      return matchOddsCache;
    };

    public func setStableMatchOddsCache(stable_match_odds_cache: [(FootballTypes.LeagueId, [(FootballTypes.FixtureId, BettingTypes.MatchOdds)])]){
      matchOddsCache := stable_match_odds_cache;
    };

  };
};
