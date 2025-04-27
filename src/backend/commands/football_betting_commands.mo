import Ids "mo:waterway-mops/Ids";
import FootballIds "mo:waterway-mops/football/FootballIds";

module FootballBettingCommands {

  public type SubmitBetslip = {
    principalId: Ids.PrincipalId;
    leagueId: FootballIds.LeagueId;
    seasonId: FootballIds.SeasonId;
    totalStake: Nat64;
    expectedReturn: Nat64;
  };

};
