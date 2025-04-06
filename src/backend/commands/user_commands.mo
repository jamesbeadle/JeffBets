import Ids "mo:waterway-mops/Ids";

module UserQueries {

  public type UpdateProfilePicture = {
    principalId: Ids.PrincipalId;
    profilePicture: Blob;
    profilePictureExtension: Text;
  };

  public type UpdateWithdrawalAddress = {
    principalId: Ids.PrincipalId;
    withdrawalAddress: Text;
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
};
