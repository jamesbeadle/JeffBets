import T "../types/app_types";
import BettingTypes "../types/betting_types";
import Base "mo:waterway-mops/BaseTypes";
import Result "mo:base/Result";
import Array "mo:base/Array";
import Option "mo:base/Option";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import Time "mo:base/Time";
import Nat "mo:base/Nat";
import Debug "mo:base/Debug";
import Float "mo:base/Float";
import Environment "../environment";
import OddsGenerator "odds_generator";
import SHA224 "mo:waterway-mops/SHA224";
import FootballIds "mo:waterway-mops/football/FootballIds";
import FootballEnums "mo:waterway-mops/football/FootballEnums";
import FootballTypes "mo:waterway-mops/football/FootballTypes";
import Enums "mo:waterway-mops/Enums";
import FixtureQueries "mo:waterway-mops/queries/football-queries/FixtureQueries";
import PlayerQueries "mo:waterway-mops/queries/football-queries/PlayerQueries";
import AppQueries "../queries/app_queries";
import MopsAppQueries "../mops/app_queries";
import BettingQueries "../queries/betting_queries";

module {

  public class OddsManager() {

    private var matchOddsCache: [(FootballIds.LeagueId, [(FootballIds.FixtureId, BettingTypes.MatchOdds)])] = [];
    private let oddsGenerator = OddsGenerator.OddsGenerator();
  
    public func getHomepageLeagueFixtures(dto: BettingQueries.GetBettableHomepageFixtures) : BettingQueries.BettableHomepageFixtures {
 
      let matchOddsResult = Array.find<(FootballIds.LeagueId, [(FootballIds.FixtureId, BettingTypes.MatchOdds)])>(matchOddsCache, func(matchOddsCacheEntry: (FootballIds.LeagueId, [(FootballIds.FixtureId, BettingTypes.MatchOdds)])) : Bool {
        matchOddsCacheEntry.0 == dto.leagueId;
      });

      switch(matchOddsResult){
        case (?foundMatchOdds){
          return Array.map<(FootballIds.FixtureId, BettingTypes.MatchOdds), BettingQueries.HomePageFixture>(foundMatchOdds.1, func (oddsEntry: (FootballIds.FixtureId, BettingTypes.MatchOdds)) {
            let matchOdds = oddsEntry.1;
            return { 
              fixtures = {
                leagueId = matchOdds.leagueId;
                gameweek = matchOdds.gameweek;
                fixtureId = matchOdds.fixtureId;
                homeOdds = matchOdds.correctResults.homeOdds;
                drawOdds = matchOdds.correctResults.drawOdds;
                awayOdds = matchOdds.correctResults.awayOdds;
              }
            };
          });
        };
        case (null){
          return {fixtures = []};
        }
      };
    };
    
    public func getMatchOdds(dto: BettingQueries.GetMatchOdds) : Result.Result<BettingQueries.MatchOdds, Enums.Error> {
      
      let leagueOddsCache = Array.find<(FootballIds.LeagueId, [(FootballIds.FixtureId, BettingTypes.MatchOdds)])>(matchOddsCache, 
          func(entry: (FootballIds.LeagueId, [(FootballIds.FixtureId, BettingTypes.MatchOdds)])) : Bool {
            entry.0 == dto.leagueId;
      });

      switch(leagueOddsCache){
        case (?foundLeagueOdds){
          let fixtureOddsResult = Array.find<(FootballIds.FixtureId, BettingTypes.MatchOdds)>(foundLeagueOdds.1, func(entry: (FootballIds.FixtureId, BettingTypes.MatchOdds)) : Bool {
            entry.0 == dto.fixtureId;
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

    public func recalculate(leagueId: FootballIds.LeagueId, seasonId: FootballIds.SeasonId, leagueStatus: FootballTypes.LeagueStatus) : async () {
      
      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        getBettableFixtures : shared query (leagueId: FootballIds.LeagueId, seasonId: FootballIds.SeasonId) -> async Result.Result<[FixtureQueries.Fixture], Enums.Error>;
        getPlayers : shared query (leagueId: FootballIds.LeagueId) -> async Result.Result<[PlayerQueries.Player], Enums.Error>;
        getLeagueTable : shared query (leagueId: FootballIds.LeagueId, seasonId: FootballIds.SeasonId) -> async Result.Result<FootballTypes.LeagueTable, Enums.Error>;
      };
      let fixturesResult = await data_canister.getBettableFixtures(leagueId, seasonId);
      let playersResult = await data_canister.getPlayers(leagueId);

      let priorSeasonLeagueTable = await data_canister.getLeagueTable(leagueId, seasonId - 1);
      switch(priorSeasonLeagueTable){
        case (#ok priorSeasonTable){

          matchOddsCache := Array.map<(FootballIds.LeagueId, [(FootballIds.FixtureId, BettingTypes.MatchOdds)]), (FootballIds.LeagueId, [(FootballIds.FixtureId, BettingTypes.MatchOdds)])>(matchOddsCache, func(entry: (FootballIds.LeagueId, [(FootballIds.FixtureId, BettingTypes.MatchOdds)])){
            if(entry.0 == leagueId){
              return (entry.0, [])
            } else {
              return entry;
            }
          }); 
          
          switch(fixturesResult){
            case (#ok fixtures){
              let futureFixtures = Array.filter<FixtureQueries.Fixture>(fixtures, func(fixtureEntry: FixtureQueries.Fixture){
                fixtureEntry.status == #Unplayed and fixtureEntry.kickOff > Time.now();
              }); 
              switch(playersResult){
                case (#ok players){
      
                  for(fixture in Iter.fromArray(futureFixtures)){

                    let stats: BettingTypes.Stats = buildBettingStats(priorSeasonTable, fixtures, fixture, leagueStatus.totalGameweeks);
                    
                    let fixturePlayers = Array.filter<PlayerQueries.Player>(players, func(player: PlayerQueries.Player){
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
                    let playerPenaltyMissedOddsBuffer = Buffer.fromArray<BettingTypes.PlayerSelectionOdds>([]);
                    let yellowCardsOddsBuffer = Buffer.fromArray<BettingTypes.PlayerSelectionOdds>([]);
                    let redCardsOddsBuffer = Buffer.fromArray<BettingTypes.PlayerSelectionOdds>([]);
                    
                    for(player in Iter.fromArray(fixturePlayers)){

                      firstAssistersOddsBuffer.add({
                        playerId = player.id;
                        odds = oddsGenerator.getFirstAssistOdds(stats, player);
                      });

                      firstGoalscorersOddsBuffer.add({
                        playerId = player.id;
                        odds = oddsGenerator.getFirstGoalscorerOdds(stats, player);
                      });

                      anytimeAssistOddsBuffer.add({
                        playerId = player.id;
                        odds = oddsGenerator.getAnytimeAssistOdds(stats, player);
                      });

                      anytimeScorerOddsBuffer.add({
                        playerId = player.id;
                        odds = oddsGenerator.getAnytimeScorerOdds(stats, player);
                      });

                      lastAssistOddsBuffer.add({
                        playerId = player.id;
                        odds = oddsGenerator.getLastAssistOdds(stats, player);
                      });

                      lastGoalscorerOddsBuffer.add({
                        playerId = player.id;
                        odds = oddsGenerator.getLastScorerOdds(stats, player);
                      });

                      scoresBraceOddsBuffer.add({
                        playerId = player.id;
                        odds = oddsGenerator.getScoresBraceOdds(stats, player);
                      });

                      scoresHatTrickOddsBuffer.add({
                        playerId = player.id;
                        odds = oddsGenerator.getScoreHatrickOdds(stats, player);
                      });

                      playerPenaltyMissedOddsBuffer.add({
                        playerId = player.id;
                        odds = oddsGenerator.getPlayerPenaltyMissOdds(stats, player);
                      });

                      yellowCardsOddsBuffer.add({
                        playerId = player.id;
                        odds = oddsGenerator.getYellowCardOdds(stats, player);
                      });

                      redCardsOddsBuffer.add({
                        playerId = player.id;
                        odds = oddsGenerator.getRedCardOdds(stats, player);
                      });
                    };
                    
                    let correctResultsOdds = oddsGenerator.getCorrectResultOdds(stats);
                    let bothTeamsToScoreOdds = oddsGenerator.getBothTeamsToScoreOdds(stats);
                    let bothTeamsToScoreAndWinnerOdds = oddsGenerator.getBothTeamsToScoreWithWinnerOdds(stats);
                    let correctScoresOdds = oddsGenerator.getCorrectScoreOdds(stats);
                    let goalsOverUnderOdds = oddsGenerator.getGoalsOverUnderOdds(stats);
                    let halfTimeFullTimeResultOdds = oddsGenerator.getHalfTimeFullTimeResultOdds(stats);
                    let halfTimeScoresOdds = oddsGenerator.getHalfTimeCorrectScoreOdds(stats);
                    let teamPenaltyMissOdds = oddsGenerator.getTeamPenaltyMissOdds(stats);

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
                      penaltyMissed = teamPenaltyMissOdds;
                      penaltyMissers = Buffer.toArray(playerPenaltyMissedOddsBuffer);
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
        case (#err _){};
      };   
    };

    private func buildBettingStats(priorSeasonTable: FootballTypes.LeagueTable, fixtures: [FixtureQueries.Fixture], fixture: FixtureQueries.Fixture, totalGameweeks: Nat8) : BettingTypes.Stats {
      let finalisedHomeClubFixtures = Array.filter<FixtureQueries.Fixture>(fixtures, func(entry: FixtureQueries.Fixture){
        entry.status == #Finalised and
        (entry.homeClubId == fixture.homeClubId or entry.awayClubId == fixture.homeClubId)
      });

      let homeWins = Array.filter<FixtureQueries.Fixture>(finalisedHomeClubFixtures, func(homeEntry: FixtureQueries.Fixture){
        (homeEntry.homeGoals > homeEntry.awayGoals and homeEntry.homeClubId == fixture.homeClubId) or
        (homeEntry.homeGoals < homeEntry.awayGoals and homeEntry.awayClubId == fixture.homeClubId);
      });

      let homeClubDraws = Array.filter<FixtureQueries.Fixture>(finalisedHomeClubFixtures, func(homeEntry: FixtureQueries.Fixture){
        (homeEntry.homeGoals == homeEntry.awayGoals and homeEntry.homeClubId == fixture.homeClubId) or
        (homeEntry.homeGoals == homeEntry.awayGoals and homeEntry.awayClubId == fixture.homeClubId);
      });

      let finalisedAwayClubFixtures = Array.filter<FixtureQueries.Fixture>(fixtures, func(entry: FixtureQueries.Fixture){
        entry.status == #Finalised and
        (entry.homeClubId == fixture.awayClubId or entry.awayClubId == fixture.awayClubId)
      });


      let awayWins = Array.filter<FixtureQueries.Fixture>(finalisedAwayClubFixtures, func(awayEntry: FixtureQueries.Fixture){
        (awayEntry.homeGoals > awayEntry.awayGoals and awayEntry.homeClubId == fixture.awayClubId) or
        (awayEntry.homeGoals < awayEntry.awayGoals and awayEntry.awayClubId == fixture.awayClubId);
      });

      let awayDraws = Array.filter<FixtureQueries.Fixture>(finalisedAwayClubFixtures, func(awayEntry: FixtureQueries.Fixture){
        (awayEntry.homeGoals == awayEntry.awayGoals and awayEntry.homeClubId == fixture.awayClubId) or
        (awayEntry.homeGoals == awayEntry.awayGoals and awayEntry.awayClubId == fixture.awayClubId);
      });

      let totalHomeClubPoints: Nat = (Array.size(homeWins) * 3) + Array.size(homeClubDraws);
      let totalAwayClubPoints: Nat = (Array.size(awayWins) * 3) + Array.size(awayDraws);

      let homeTeamPriorSeason = Array.find(priorSeasonTable.entries, func(entry: FootballTypes.LeagueTableEntry) : Bool {
        entry.clubId == fixture.homeClubId;
      });

      let awayTeamPriorSeason = Array.find(priorSeasonTable.entries, func(entry: FootballTypes.LeagueTableEntry) : Bool {
        entry.clubId == fixture.awayClubId;
      });

      var homeTeamPriorSeasonFinish: Nat = 999;
      var awayTeamPriorSeasonFinish: Nat = 999;


      switch(homeTeamPriorSeason){
        case (?season){
          homeTeamPriorSeasonFinish := season.position;
        };
        case (null) {};
      };

      switch(awayTeamPriorSeason){
        case (?season){
          awayTeamPriorSeasonFinish := season.position;
        };
        case (null) {};
      };

      var totalHomeGamesWon: Float = Float.fromInt(Array.size(homeWins));
      var totalAwayGamesWon: Float = Float.fromInt(Array.size(awayWins));
      var totalHomeGamesPlayed: Float = Float.fromInt(Array.size(finalisedHomeClubFixtures));
      var totalAwayGamesPlayed: Float = Float.fromInt(Array.size(finalisedAwayClubFixtures));

      var homeCurrentSeasonWinPercentage: Float = totalHomeGamesWon / totalHomeGamesPlayed;
      var awayCurrentSeasonWinPercentage: Float = totalAwayGamesWon / totalAwayGamesPlayed;

      return {
        priorSeasonTable;
        totalHomeClubPoints;
        totalAwayClubPoints;
        homeTeamPriorSeasonFinish;
        awayTeamPriorSeasonFinish;
        totalGameweeks;
        homeCurrentSeasonWinPercentage;
        awayCurrentSeasonWinPercentage;
        currentSeasonFixtures = fixtures;
        bettingFixture = fixture;
      };

    };

    private func storeMatchOdds(matchOdds: BettingTypes.MatchOdds){
      
      let existingLeague = Array.find<(FootballIds.LeagueId, [(FootballIds.FixtureId, BettingTypes.MatchOdds)])>(matchOddsCache, func(entry: (FootballIds.LeagueId, [(FootballIds.FixtureId, BettingTypes.MatchOdds)])) : Bool {
        entry.0 == matchOdds.leagueId
      });

      switch(existingLeague){
        case (?foundLeague){
          let existingFixtureOdds = Array.find<(FootballIds.FixtureId, BettingTypes.MatchOdds)>(foundLeague.1, func(fixtureEntry: (FootballIds.FixtureId, BettingTypes.MatchOdds)) : Bool {
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
      matchOddsCache := Array.map<(FootballIds.LeagueId, [(FootballIds.FixtureId, BettingTypes.MatchOdds)]), (FootballIds.LeagueId, [(FootballIds.FixtureId, BettingTypes.MatchOdds)])>(matchOddsCache, func(entry: (FootballIds.LeagueId, [(FootballIds.FixtureId, BettingTypes.MatchOdds)])){
        if(entry.0 == matchOdds.leagueId){
          return (entry.0, Array.map<(FootballIds.FixtureId, BettingTypes.MatchOdds), (FootballIds.FixtureId, BettingTypes.MatchOdds)>(entry.1, func(matchOddsEntry: (FootballIds.FixtureId, BettingTypes.MatchOdds)){
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
      matchOddsCache := Array.map<(FootballIds.LeagueId, [(FootballIds.FixtureId, BettingTypes.MatchOdds)]), (FootballIds.LeagueId, [(FootballIds.FixtureId, BettingTypes.MatchOdds)])>(matchOddsCache, func(entry: (FootballIds.LeagueId, [(FootballIds.FixtureId, BettingTypes.MatchOdds)])){
        if(entry.0 == matchOdds.leagueId){
          let leagueOddsBuffer = Buffer.fromArray<(FootballIds.FixtureId, BettingTypes.MatchOdds)>(entry.1);
          leagueOddsBuffer.add((matchOdds.fixtureId, matchOdds));
          return (entry.0, Buffer.toArray(leagueOddsBuffer));
        } else {
          return entry;
        };
      });
    };

    private func addInitialLeagueMatchOdds(matchOdds: BettingTypes.MatchOdds){
      let matchOddsCacheBuffer = Buffer.fromArray<(FootballIds.LeagueId, [(FootballIds.FixtureId, BettingTypes.MatchOdds)])>(matchOddsCache);
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
    
    public func getDataHashes() : Result.Result<[MopsAppQueries.DataHash], Enums.Error> {
      return #ok(dataHashes)
    };

    public func getStableMatchOddsCache(): [(FootballIds.LeagueId, [(FootballIds.FixtureId, BettingTypes.MatchOdds)])]{
      return matchOddsCache;
    };

    public func setStableMatchOddsCache(stable_match_odds_cache: [(FootballIds.LeagueId, [(FootballIds.FixtureId, BettingTypes.MatchOdds)])]){
      matchOddsCache := stable_match_odds_cache;
    };

  };
};
