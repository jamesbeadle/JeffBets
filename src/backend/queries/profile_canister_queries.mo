import Ids "mo:waterway-mops/Ids";
import MopsTypes "../mops/mops_types";
module ProfileCanisterQueries {
    
  public type GetProfile = {
    principalId : Ids.PrincipalId;
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

  public type GetUserBets = {
    principalId : Ids.PrincipalId;
  };

  public type UserBets = {

  };

  public type GetUserAuditList = {

  };

  public type UserAuditList = {

  };

  public type AuditRecord = {
    /* // TODO - Confirm query requirements on audit. */
  };
}