import { writable } from "svelte/store";
import { FixtureService } from "../services/fixture-service";
import { DataHashService } from "../services/data-hash-service";
import { serializeData, deserializeData } from "../utils/helpers";
import { MAX_CACHED_LEAGUES } from "../constants/app.constants";
import { leagueStore } from "./league-store";
import type {
  Fixture,
  LeagueId,
  SeasonId,
} from "../../../../declarations/backend/backend.did";

function createFixtureStore() {
  const { subscribe, update } = writable<Record<number, Fixture[]>>({});

  let leagueCacheOrder: number[] = [];

  async function syncFixtures(leagueId: LeagueId, seasonId: SeasonId) {
    try {
      const localHashKey = `fixtures_hash_${leagueId}`;
      const localFixturesKey = `fixtures_${leagueId}`;

      const localHash = localStorage.getItem(localHashKey);
      const fixtureHash = await new DataHashService().getCategoryHash(
        "fixtures",
        leagueId,
      );

      let fixtures: Fixture[];

      let leagueStatus = await leagueStore.getLeagueStatus(leagueId, seasonId);

      if (!localHash || fixtureHash !== localHash) {
        fixtures = await getFixtures(leagueId, leagueStatus.activeSeasonId);
        localStorage.setItem(localFixturesKey, serializeData(fixtures));
        localStorage.setItem(localHashKey, fixtureHash || "");
      } else {
        const cached = localStorage.getItem(localFixturesKey);
        if (cached) {
          fixtures = deserializeData(cached) as Fixture[];
        } else {
          fixtures = await getFixtures(leagueId, leagueStatus.activeSeasonId);
          localStorage.setItem(localFixturesKey, serializeData(fixtures));
        }
      }

      update((current: Record<number, Fixture[]>) => ({
        ...current,
        [leagueId]: fixtures,
      }));

      if (!leagueCacheOrder.includes(leagueId)) {
        leagueCacheOrder.push(leagueId);
      } else {
        leagueCacheOrder = leagueCacheOrder.filter((id) => id !== leagueId);
        leagueCacheOrder.push(leagueId);
      }

      if (leagueCacheOrder.length > MAX_CACHED_LEAGUES) {
        const leastUsedLeagueId = leagueCacheOrder.shift();
        if (leastUsedLeagueId !== undefined) {
          localStorage.removeItem(`fixtures_${leastUsedLeagueId}`);
          localStorage.removeItem(`fixtures_hash_${leastUsedLeagueId}`);
        }
      }
    } catch (error) {
      console.error(`Error syncing fixtures for league ${leagueId}:`, error);
      const cached = localStorage.getItem(`fixtures_${leagueId}`);
      if (cached) {
        const fixtures = deserializeData(cached) as Fixture[];
        update((current: Record<number, Fixture[]>) => ({
          ...current,
          [leagueId]: fixtures,
        }));
      }
    }
  }

  async function getFixtures(
    leagueId: number,
    seasonId: number,
  ): Promise<Fixture[]> {
    return new FixtureService().getFixtures(leagueId, seasonId);
  }

  function getFixturesByLeagueId(leagueId: number): Fixture[] | undefined {
    let data: Record<number, Fixture[]> = {};
    const unsubscribe = subscribe((value) => {
      data = value;
    });
    unsubscribe();

    return data[leagueId];
  }

  return {
    syncFixtures,
    getFixtures,
    getFixturesByLeagueId,
  };
}

export const fixtureStore = createFixtureStore();
