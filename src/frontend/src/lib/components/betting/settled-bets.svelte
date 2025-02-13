<script lang="ts">
  import OpenFPLIcon from "../../icons/OpenFPLIcon.svelte";
  import ArrowDown from "$lib/icons/ArrowDown.svelte";
  import ArrowUp from "$lib/icons/ArrowUp.svelte";

  const settledBets = [
   
    {
      id: 3,
      status: 'won',
      stake: 10,
      returns: 15.50,
      date: 'Feb 01 2025',
      selections: [
        {
          match: 'Arsenal vs Manchester City',
          league: 'Premier League',
          pick: 'Arsenal to win',
          odds: 1.50,
          result: 'Won',
          score: '5 - 1',
          gameweek: 24
        }
      ]
    },
    {
      id: 4,
      status: 'lost',
      stake: 15,
      returns: 0,
      date: 'Feb 01 2025',
      selections: [
        {
          match: 'Arsenal vs Manchester City',
          league: 'Premier League',
          pick: 'Manchester City to win',
          odds: 2.25,
          result: 'Lost',
          score: '5 - 1',
          gameweek: 24
        }
      ]
    },
    {
      id: 5,
      status: 'won',
      stake: 10,
      returns: 15.50,
      date: 'Feb 01 2025',
      selections: [
        {
          match: 'Chelsea vs West Ham',
          league: 'Premier League',
          pick: 'Chelsea to win',
          odds: 1.50,
          result: 'Won',
          score: '2 - 1',
          gameweek: 24
        }
      ]
    },
  ];
  
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
  {#each settledBets as bet}
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
                  <ArrowUp className="w-5 h-5 text-gray-600" />
                {:else}
                  <ArrowDown className="w-5 h-5 text-gray-600" />
                {/if}
              </span>
            </div>
          </div>
        </button>
        
        {#if !expandedBets.has(bet.id)}
          <div class="px-2 py-1 text-xs text-gray-400 bg-[#F9F9F9] border-x border-b rounded-b-lg border-gray-100">
            Bet placed on Jan 31 2025, 14:30
          </div>
        {/if}
      </div>

      {#if expandedBets.has(bet.id)}
        <div class="p-4 rounded-b-lg bg-[#F9F9F9] border-x border-b border-gray-100">
          {#each bet.selections as selection}
            <div class="mb-2">
              <div class="flex items-center justify-between">
                <span class="text-sm text-gray-500">{bet.date}</span>
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
                <p class="text-xs text-gray-500">{selection.league}</p>
                <span class="text-xs font-medium text-gray-700">Full Time Score: {selection.score}</span>
              </div>
            </div>
          {/each}

          <div class="flex justify-between pt-2 mt-4 text-black border-t border-gray-100">
            <div>
              <p class="text-xs text-gray-500">Stake</p>
              <span class="flex items-center text-sm font-medium">
                <OpenFPLIcon className="w-3 h-3 mr-1" />
                {bet.stake.toFixed(2)}
              </span>
            </div>
            <div class="text-right">
              <p class="text-xs text-gray-500">Returns</p>
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

  {#if settledBets.length === 0}
    <div class="flex flex-col items-center justify-center flex-1 px-8 py-16 text-center">
      <p class="text-lg text-gray-400 md:text-sm">
        No settled bets to display
      </p>
    </div>
  {/if}
</div>
