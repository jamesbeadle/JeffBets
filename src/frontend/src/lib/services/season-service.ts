import { ActorFactory } from "$lib/utils/ActorFactory";
import { isError } from "$lib/utils/helpers";
import { authStore } from "$lib/stores/auth-store";

export class SeasonService {
  constructor() {}

  async getSeasons(leagueId: number): Promise<SeasonDTO[] | undefined> {
    const identityActor: any = await ActorFactory.createIdentityActor(
      authStore,
      process.env.BACKEND_CANISTER_ID ?? "",
    );
    const result = await identityActor.getSeasons(leagueId);
    if (isError(result)) throw new Error("Failed to fetch seasons");
    return result.ok;
  }
}
