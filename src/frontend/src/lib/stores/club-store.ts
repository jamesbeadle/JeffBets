import { writable } from "svelte/store";
import type {
  Club,
  LeagueId,
} from "../../../../declarations/backend/backend.did";
import { ClubService } from "../services/club-service";
import { DataHashService } from "../services/data-hash-service";
import { serializeData, deserializeData } from "../utils/helpers";
import { MAX_CACHED_LEAGUES } from "../constants/app.constants";

function createClubStore() {
  const { subscribe, update } = writable<Record<number, Club[]>>({});

  let leagueCacheOrder: number[] = [];

  async function syncClubs(leagueId: number) {
    try {
      const localHashKey = `clubs_hash_${leagueId}`;
      const localClubsKey = `clubs_${leagueId}`;

      const localHash = localStorage.getItem(localHashKey);
      const clubHash = await new DataHashService().getCategoryHash(
        "clubs",
        leagueId,
      );

      let clubs: Club[];

      if (!localHash || clubHash !== localHash) {
        clubs = await getClubs(leagueId);
        localStorage.setItem(localClubsKey, serializeData(clubs));
        localStorage.setItem(localHashKey, clubHash || "");
      } else {
        const cached = localStorage.getItem(localClubsKey);
        if (cached) {
          clubs = deserializeData(cached) as Club[];
        } else {
          clubs = await getClubs(leagueId);
          localStorage.setItem(localClubsKey, serializeData(clubs));
        }
      }

      update((current: Record<number, Club[]>) => ({
        ...current,
        [leagueId]: clubs,
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
          localStorage.removeItem(`clubs_${leastUsedLeagueId}`);
          localStorage.removeItem(`clubs_hash_${leastUsedLeagueId}`);
        }
      }
    } catch (error) {
      console.error(`Error syncing clubs for league ${leagueId}:`, error);
      const cached = localStorage.getItem(`clubs_${leagueId}`);
      if (cached) {
        const clubs = deserializeData(cached) as Club[];
        update((current: Record<number, Club[]>) => ({
          ...current,
          [leagueId]: clubs,
        }));
      }
    }
  }

  async function getClubs(leagueId: LeagueId) {
    return new ClubService().getClubs(leagueId);
  }

  return {
    getClubs,
    syncClubs,
  };
}

export const clubStore = createClubStore();
