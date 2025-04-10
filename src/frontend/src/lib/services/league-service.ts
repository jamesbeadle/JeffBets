import type { League } from "../../../../declarations/backend/backend.did";
import { authStore } from "../stores/auth-store";
import { ActorFactory } from "../utils/ActorFactory";
import { isError } from "../utils/helpers";

export class LeagueService {
  constructor() {}

  async getLeagues(): Promise<League[]> {
    const identityActor: any = await ActorFactory.createIdentityActor(
      authStore,
      process.env.BACKEND_CANISTER_ID ?? "",
    );
    const result = await identityActor.getLeagues();
    if (isError(result)) throw new Error("Failed to fetch leagues");
    return result.ok;
  }

  async getBettableLeagues(): Promise<League[]> {
    const identityActor: any = await ActorFactory.createIdentityActor(
      authStore,
      process.env.BACKEND_CANISTER_ID ?? "",
    );
    const result = await identityActor.getUpToDateLeagues();
    if (isError(result)) throw new Error("Failed to fetch leagues");
    return result.ok;
  }

  async getLeagueStatus(leagueId: number): Promise<LeagueStatus> {
    const identityActor: any = await ActorFactory.createIdentityActor(
      authStore,
      process.env.BACKEND_CANISTER_ID ?? "",
    );
    const result = await identityActor.getLeagueStatus(leagueId);
    if (isError(result)) throw new Error("Failed to fetch league status");
    return result.ok;
  }
}
