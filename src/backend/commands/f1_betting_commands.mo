import Ids "mo:waterway-mops/Ids";

module GolfBettingCommands {

  public type SubmitBetslip = {
    principalId: Ids.PrincipalId;
    tournamentInstanceId: F1Ids.RaceInstanceId;
    totalStake: Nat64;
    expectedReturn: Nat64;
  };
};
