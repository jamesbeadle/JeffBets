import Base "../types/base_types";

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
