import type {
  GetUserAudit,
  UserAuditList,
} from "../../../../declarations/backend/backend.did";
import { authStore } from "../stores/auth-store";
import { ActorFactory } from "../utils/ActorFactory";
import { isError } from "../utils/helpers";

export class AuditService {
  constructor() {}

  async getUserAudit(dto: GetUserAudit): Promise<UserAuditList | undefined> {
    const identityActor: any = await ActorFactory.createIdentityActor(
      authStore,
      process.env.BACKEND_CANISTER_ID ?? "",
    );

    const result = await identityActor.getUserAudit(dto);
    if (isError(result)) throw new Error("Failed to get user audit");
    return result.ok;
  }
}
