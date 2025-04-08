import Ids "mo:waterway-mops/Ids";

module ProfileCanisterCommands {

  public type CreateProfile = {
    principalId: Ids.PrincipalId;
  };

  public type PauseAccount = {
    principalId: Ids.PrincipalId;
    pauseDays: Nat;
  };

  public type SetDailyBetLimit = {
    principalId: Ids.PrincipalId;
    maxBetLimit: Nat64;
  };

  public type SetMonthlyBetLimit = {
    principalId: Ids.PrincipalId;
    monthlyBetLimit: Nat64;
  };

  public type Withdraw = {
    principalId: Ids.PrincipalId;
    amount: Nat64;
  };

  public type AcceptTerms = {
    principalId: Ids.PrincipalId;
  };

  public type VerifyBettingAccount = {
    principalId: Ids.PrincipalId;
  };

  public type SubmitBetslip = {
    principalId: Ids.PrincipalId;
  };

  public type UpdateSettledBet = {
    principalId: Ids.PrincipalId;
  };
  
};
