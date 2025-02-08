import { AuditService } from "$lib/services/audit-service";
import type { GetUserAudit } from "../../../../declarations/backend/backend.did";

function createAuditStore() {
  async function getUserAudit(dto: GetUserAudit): Promise<any> {
    return new AuditService().getUserAudit(dto);
  }

  return {
    getUserAudit,
  };
}

export const auditStore = createAuditStore();
