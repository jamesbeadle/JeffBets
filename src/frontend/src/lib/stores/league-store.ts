import { writable } from "svelte/store";
import { LeagueService } from "../services/league-service";
import { DataHashService } from "$lib/services/data-hash-service";
import { serializeData, deserializeData } from "../utils/helpers";
import { MAX_CACHED_LEAGUES } from "../constants/app.constants";
import type { League } from "../../../../declarations/backend/backend.did";

function createLeagueStore() {
  const { subscribe, update } = writable<Record<number, League>>({});

  let leagueCacheOrder: number[] = [];

  async function syncLeagues(toggledLeagueId: number) {
    try {
      const localHashKey = "leagues_hash";
      const localLeaguesKey = "leagues";

      const localHash = localStorage.getItem(localHashKey);
      const leagueHash = await new DataHashService().getLeaguesHash(
        toggledLeagueId,
      );

      let leagues: League[];

      if (!localHash || leagueHash !== localHash) {
        leagues = await getLeagues();
        localStorage.setItem(localLeaguesKey, serializeData(leagues));
        localStorage.setItem(localHashKey, leagueHash || "");
      } else {
        const cached = localStorage.getItem(localLeaguesKey);
        if (cached) {
          const cachedLeagues = deserializeData(cached) as League[];
          const serverLeagues = await getLeagues();

          const cachedLeagueMap = new Map(
            cachedLeagues.map((league) => [league.id, league]),
          );
          serverLeagues.forEach((serverLeague) => {
            cachedLeagueMap.set(serverLeague.id, serverLeague);
          });
          leagues = Array.from(
            new Map(
              serverLeagues.map((league) => [league.id, league]),
            ).values(),
          );
        } else {
          leagues = await getLeagues();
          localStorage.setItem(localLeaguesKey, serializeData(leagues));
        }
      }

      if (toggledLeagueId !== undefined) {
        if (!leagueCacheOrder.includes(toggledLeagueId)) {
          leagueCacheOrder.push(toggledLeagueId);
        } else {
          leagueCacheOrder = leagueCacheOrder.filter(
            (id) => id !== toggledLeagueId,
          );
          leagueCacheOrder.push(toggledLeagueId);
        }
      }

      const excessLeagues = leagueCacheOrder.slice(
        0,
        leagueCacheOrder.length - MAX_CACHED_LEAGUES,
      );
      const filteredLeagues = leagueCacheOrder
        .slice(-MAX_CACHED_LEAGUES)
        .map((id) => leagues.find((league) => league.id === id))
        .filter((league): league is League => league !== undefined);

      localStorage.setItem(localLeaguesKey, serializeData(filteredLeagues));

      excessLeagues.forEach((excessLeagueId) => {
        leagueCacheOrder = leagueCacheOrder.filter(
          (id) => id !== excessLeagueId,
        );
      });

      update((current) =>
        filteredLeagues.reduce(
          (acc, league) => {
            acc[league.id] = league;
            return acc;
          },
          {} as Record<number, League>,
        ),
      );
    } catch (error) {
      console.error("Error syncing leagues:", error);

      const cached = localStorage.getItem("leagues");
      if (cached) {
        const leagues = deserializeData(cached) as League[];
        update((current) =>
          leagues.reduce(
            (acc, league) => {
              acc[league.id] = league;
              return acc;
            },
            {} as Record<number, League>,
          ),
        );
      }
    }
  }

  async function getLeagues() {
    return new LeagueService().getLeagues();
  }

  async function getBettableLeagues() {
    return new LeagueService().getBettableLeagues();
  }

  return {
    subscribe,
    syncLeagues,
    getLeagues,
    getBettableLeagues,
  };
}

export const leagueStore = createLeagueStore();
