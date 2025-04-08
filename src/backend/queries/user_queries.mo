import Ids "mo:waterway-mops/Ids";
import MopsTypes "../mops/mops_types";

module UserQueries {

  public type GetProfile = {
  };

  public type Profile = {
    principalId : Ids.PrincipalId;
    termsAcceptedDate: Int;
    joinedDate: Int;
    accountOnPause: Bool;
    pauseEndDate: Int;
    maxBetLimit: Nat64;
    maxBetLimitSet: Int;
    monthlyBetLimit: Nat64;
    monthlyBetLimitSet: Int;
    kycComplete: Bool;
    kycSubmissionDate: Int;
    kycApprovalDate: Int;
    kycRef: Text;
    linkedEcosystemProfiles: [(MopsTypes.TokenEcosystem, Ids.PrincipalId)];
  };
  
};
