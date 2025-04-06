
module AuditQueries {

  public type GetUserAudit = {
    page: Nat;
    principalId: Text;
  };

  public type UserAuditList = {
    date: Int;
    users: [AuditRecord];
    offset: Nat;
  };

  public type AuditRecord = {
    /* // TODO - Confirm query requirements on audit. */
  };
};
