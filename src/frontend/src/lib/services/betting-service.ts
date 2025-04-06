import type {
  FixtureId,
  HomePageFixture,
  LeagueId,
  MatchOdds,
  SubmitBetslip,
} from "../../../../declarations/backend/backend.did";
import { isError } from "$lib/utils/helpers";
import { authStore } from "$lib/stores/auth-store";
import { ActorFactory } from "$lib/utils/ActorFactory";

export class BettingService {
  constructor() {}

  async getBettableHomepageFixtures(
    leagueId: LeagueId,
  ): Promise<HomePageFixture[]> {
    const identityActor: any = await ActorFactory.createIdentityActor(
      authStore,
      process.env.BACKEND_CANISTER_ID ?? "",
    );
    const result = await identityActor.getBettableHomepageFixtures(leagueId);
    if (isError(result))
      throw new Error("Failed to fetch bettable league fixtures");
    return result.ok;
  }

  async getMatchOdds(
    leagueId: LeagueId,
    fixtureId: FixtureId,
  ): Promise<MatchOdds> {
    const identityActor: any = await ActorFactory.createIdentityActor(
      authStore,
      process.env.BACKEND_CANISTER_ID ?? "",
    );
    const result = await identityActor.getMatchOdds(leagueId, fixtureId);
    if (isError(result)) throw new Error("Failed to fetch match odds");
    return result.ok;
  }

  async placeBet(dto: SubmitBetslip): Promise<any> {
    const identityActor: any = await ActorFactory.createIdentityActor(
      authStore,
      process.env.BACKEND_CANISTER_ID ?? "",
    );
    const result = await identityActor.placeBet(dto);
    if (isError(result)) throw new Error("Failed to submit betslip");
    return result.ok;
  }
}
