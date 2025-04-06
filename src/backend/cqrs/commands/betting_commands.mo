import Ids "mo:waterway-mops/Ids";
import FootballIds "mo:waterway-mops/football/FootballIds";
import FootballDefinitions "mo:waterway-mops/football/FootballDefinitions";

module BettingCommands {

  public type SubmitBetslip = {
    principalId: Ids.PrincipalId;
    leagueId: FootballIds.LeagueId;
    seasonId: FootballIds.SeasonId;
    totalStake: Nat64;
    expectedReturn: Nat64;
  };

  public type RequestFixtures = {
    leagueId: FootballIds.LeagueId;
    seasonId: FootballIds.SeasonId;
  };

  public type GetSnapshotPlayers = {
    seasonId: FootballIds.SeasonId;
    leagueId: FootballIds.LeagueId;
    gameweek: FootballDefinitions.GameweekNumber;
  };

  public type UpdateRewardPools = {
    seasonId : FootballIds.SeasonId;
    seasonLeaderboardPool : Nat64;
    monthlyLeaderboardPool : Nat64;
    weeklyLeaderboardPool : Nat64;
    mostValuableTeamPool : Nat64;
    highestScoringMatchPlayerPool : Nat64;
    allTimeWeeklyHighScorePool : Nat64;
    allTimeMonthlyHighScorePool : Nat64;
    allTimeSeasonHighScorePool : Nat64;
  };

  public type GetPlayerDetails = {
    playerId : FootballIds.ClubId;
    seasonId : FootballIds.SeasonId;
  };

  public type GameweekFilters = {
    seasonId : FootballIds.SeasonId;
    gameweek : FootballDefinitions.GameweekNumber;
  };
};
