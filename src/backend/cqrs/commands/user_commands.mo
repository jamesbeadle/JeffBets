import Base "mo:waterway-mops/BaseTypes";

module UserQueries {

  public type UpdateProfilePicture = {
    principalId: Base.PrincipalId;
    profilePicture: Blob;
    profilePictureExtension: Text;
  };

  public type UpdateWithdrawalAddress = {
    principalId: Base.PrincipalId;
    withdrawalAddress: Text;
  };

  public type PauseAccount = {
    principalId: Base.PrincipalId;
    pauseDays: Nat;
  };

  public type SetDailyBetLimit = {
    principalId: Base.PrincipalId;
    maxBetLimit: Nat64;
  };

  public type SetMonthlyBetLimit = {
    principalId: Base.PrincipalId;
    monthlyBetLimit: Nat64;
  };

  public type Withdraw = {
    principalId: Base.PrincipalId;
    amount: Nat64;
  };
};
