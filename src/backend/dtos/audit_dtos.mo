import Ids "mo:waterway-mops/Ids";

module AuditDTOs {
  public type AuditRecordDTO = {
    principalId: Ids.PrincipalId;
    joinedDate: Int;
    termsAcceptedDate: Int;
    kycComplete: Bool;
    kycSubmissionDate: Int;
    kycApprovalDate: Int;
    kycRef: Text;
  };
};
