import Base "mo:waterway-mops/BaseTypes";

module AuditDTOs {
  public type AuditRecordDTO = {
    principalId: Base.PrincipalId;
    joinedDate: Int;
    termsAcceptedDate: Int;
    kycComplete: Bool;
    kycSubmissionDate: Int;
    kycApprovalDate: Int;
    kycRef: Text;
  };
};
