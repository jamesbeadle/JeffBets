import { ActorFactory } from "../utils/ActorFactory";
import { isError } from "../utils/helpers";
import { authStore } from "$lib/stores/auth-store";

export class PlayerService {
  constructor() {}

  async getPlayers(leagueId: LeagueId): Promise<PlayerDTO[]> {
    const identityActor: any = await ActorFactory.createIdentityActor(
      authStore,
      process.env.BACKEND_CANISTER_ID ?? "",
    );

    const result = await identityActor.getPlayers(leagueId);
    if (isError(result)) throw new Error("Failed to fetch players");
    return result.ok;
  }

  async getLoanedPlayers(leagueId: LeagueId): Promise<LoanedPlayerDTO[]> {
    const identityActor: any = await ActorFactory.createIdentityActor(
      authStore,
      process.env.BACKEND_CANISTER_ID ?? "",
    );
    const result = await identityActor.getLoanedPlayers(leagueId);
    if (isError(result)) throw new Error("Failed to fetch players");
    return result.ok;
  }
}
