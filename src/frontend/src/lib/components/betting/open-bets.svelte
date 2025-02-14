<script lang="ts">
    import EmptyBetSlipIcon from "$lib/icons/EmptyBetSlipIcon.svelte";
    import OpenFPLIcon from "../../icons/OpenFPLIcon.svelte";
    import ArrowDown from "$lib/icons/ArrowDown.svelte";
    import ArrowUp from "$lib/icons/ArrowUp.svelte";

    const unsettledBets = [ {
      id: 1,
      status: 'unsettled',
      stake: 20,
      returns: 0,
      date: 'Feb 15 2025',
      selections: [
        {
          match: 'Brighton vs Chelsea',
          league: 'Premier League',
          pick: 'Over 3.5 goals',
          odds: 2.75,
          result: 'Unsettled',
          score: 'Unplayed',
          gameweek: 25
        }
      ]
    },
    {
      id: 2,
      status: 'unsettled',
      stake: 20,
      returns: 0,
      date: 'Feb 15 2025',
      selections: [
        {
          match: 'Manchester City vs Newcastle',
          league: 'Premier League',
          pick: 'Over 2.5 goals',
          odds: 1.75,
          result: 'Unsettled',
          score: 'Unplayed',
          gameweek: 25
        }
      ]
    },
    ]

    let expandedBets = new Set<number>();

    function toggleBet(betId: number) {
      if (expandedBets.has(betId)) {
        expandedBets.delete(betId);
      } else {
        expandedBets.add(betId);
      }
      expandedBets = expandedBets;
    }

</script>

<div class="flex flex-col flex-1 mt-4 overflow-auto ">
  {#each unsettledBets as bet}
    <div class="my-1">
      <div>
        <button 
          class={`w-full p-2 ${
            bet.status === 'won' 
              ? 'bg-BrandGreen' 
              : bet.status === 'lost'
                ? 'bg-BrandBase'
                : 'bg-[#3CA1FF]'
          } ${!expandedBets.has(bet.id) ? 'rounded-t-lg' : 'rounded-t-lg'}`}
          on:click={() => toggleBet(bet.id)}
        >
          <div class="flex items-center justify-between">
            <span class="text-sm font-medium text-white">{bet.selections[0].pick}</span>
            <div class="flex items-center gap-2">
              <span class="text-sm font-medium text-white">@ {bet.selections[0].odds}</span>
              <span class="text-white">
                {#if expandedBets.has(bet.id)}
                  <ArrowUp className="w-5 h-5 text-BrandGray" />
                {:else}
                  <ArrowDown className="w-5 h-5 text-BrandGray" />
                {/if}
              </span>
            </div>
          </div>
        </button>
        
        {#if !expandedBets.has(bet.id)}
          <div class="px-2 py-1 text-xs text-BrandGray bg-[#F9F9F9] border-x border-b rounded-b-lg border-BrandGray">
            Bet placed on Feb 10 2025, 17:30
          </div>
        {/if}
      </div>

      {#if expandedBets.has(bet.id)}
        <div class="p-4 rounded-b-lg bg-[#F9F9F9] border-x border-b border-BrandGray">
          {#each bet.selections as selection}
            <div class="mb-2">
              <div class="flex items-center justify-between">
                <span class="text-sm text-BrandGray">{bet.date}</span>
                <span class={`text-sm font-medium text-white px-3 py-1 rounded-md ${
                  bet.status === 'won' 
                    ? 'bg-BrandGreen' 
                    : bet.status === 'lost'
                      ? 'bg-BrandBase'
                      : 'bg-[#3CA1FF]'
                }`}>
                  {bet.status.toUpperCase()}
                </span>
              </div>
              <p class="mt-2 text-sm font-medium text-black">{selection.match}</p>
              <div class="flex flex-col gap-2 mt-1">
                <p class="text-xs text-BrandGray">{selection.league}</p>
                <span class="text-xs font-medium text-BrandGray">Full Time Score: {selection.score}</span>
              </div>
            </div>
          {/each}

          <div class="flex justify-between pt-2 mt-4 text-black border-t border-BrandGray">
            <div>
              <p class="text-xs text-BrandGray">Stake</p>
              <span class="flex items-center text-sm font-medium">
                <OpenFPLIcon className="w-3 h-3 mr-1" />
                {bet.stake.toFixed(2)}
              </span>
            </div>
            <div class="text-right">
              <p class="text-xs text-BrandGray">Returns</p>
              <span class="flex items-center text-sm font-medium">
                <OpenFPLIcon className="w-3 h-3 mr-1" />
                {bet.returns.toFixed(2)}
              </span>
            </div>
          </div>
        </div>
      {/if}
    </div>
  {/each}

  {#if unsettledBets.length === 0}
    <div class="flex flex-col items-center justify-center flex-1 px-8 py-16 text-center">
      <p class="text-lg text-BrandGray md:text-sm">
        No settled bets to display
      </p>
    </div>
  {/if}
</div>