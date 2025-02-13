import FootballTypes "mo:waterway-mops/FootballTypes";
import Base "mo:waterway-mops/BaseTypes";

module BettingCommands {

  public type SubmitBetslip = {
    principalId: Base.PrincipalId;
    leagueId: FootballTypes.LeagueId;
    seasonId: FootballTypes.SeasonId;
    totalStake: Nat64;
    expectedReturn: Nat64;
  };

  public type RequestFixtures = {
    leagueId: FootballTypes.LeagueId;
    seasonId: FootballTypes.SeasonId;
  };

  public type GetSnapshotPlayers = {
    seasonId: FootballTypes.SeasonId;
    leagueId: FootballTypes.LeagueId;
    gameweek: FootballTypes.GameweekNumber;
  };

  public type UpdateRewardPools = {
    seasonId : FootballTypes.SeasonId;
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
    playerId : FootballTypes.ClubId;
    seasonId : FootballTypes.SeasonId;
  };

  public type GameweekFilters = {
    seasonId : FootballTypes.SeasonId;
    gameweek : FootballTypes.GameweekNumber;
  };
};
