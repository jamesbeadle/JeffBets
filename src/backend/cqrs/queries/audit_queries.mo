import AuditDTOs "../../dtos/audit_dtos";

module AuditQueries {

  public type GetUserAudit = {
    page: Nat;
    principalId: Text;
  };

  public type UserAuditList = {
    date: Int;
    users: [AuditDTOs.AuditRecordDTO];
    offset: Nat;
  };
};
