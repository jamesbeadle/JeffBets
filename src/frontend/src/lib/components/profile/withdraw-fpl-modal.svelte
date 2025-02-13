<script lang="ts">
    import { toasts } from "$lib/stores/toasts-store";
  import { userStore } from "$lib/stores/user-store";
    import { onMount } from "svelte";
    import Modal from "../shared/modal.svelte";
    import { writable } from "svelte/store";
    import LocalSpinner from "../shared/local-spinner.svelte";

  export let visible: boolean;
  export let closeModal: () => void;
  export let cancelModal: () => void;
  export let withdrawalAddress: string = "";
  export let withdrawalInputAmount: string = "";
  let dots = writable('.');
  let dot_interval: ReturnType<typeof setInterval>;

  let fplBalance = 0n;
  let fplBalanceFormatted = "0.0000"; 

  let errorMessage: string = "";
  let isLoading = true;

  onMount(async () => {
    try {
      startDotAnimation();
      await userStore.sync();
      await fetchBalances();
    } catch (error) {
      console.error("Error fetching FPL balance:", error);
      isLoading = false;
    }
  });

  async function fetchBalances() {
    try {
      isLoading = true;
      fplBalance = await userStore.getFPLBalance();
      console.log(fplBalance)
      fplBalanceFormatted = (Number(fplBalance) / 100_000_000).toFixed(4);
    } catch (error) {
      console.error("Error fetching FPL balance:", error);
    } finally {
      clearInterval(dot_interval);
      isLoading = false;
    }
  }

  function startDotAnimation(){
    let count = 1;
    dot_interval = setInterval(() => {
      count = (count % 3) + 1;
      dots.set('.'.repeat(count));
    }, 500);
  }

  function isPrincipalValid(principalId: string): boolean {
    if (!principalId) {
      return false;
    }
    const regex = /^([a-z2-7]{5}-){10}[a-z2-7]{3}$/i;
    return regex.test(principalId);
  }

  function isAmountValid(amount: string): boolean {
    if (!amount) {
      return false;
    }
    const regex = /^\d+(\.\d{1,4})?$/;
    return regex.test(amount);
  }

  function convertToE8s(amount: string): bigint {
    const [whole, fraction = ""] = amount.split(".");
    const fractionPadded = (fraction + "00000000").substring(0, 8);
    return (BigInt(whole) * 100_000_000n) + BigInt(fractionPadded);
  }

  function isWithdrawAmountValid(amount: string, balance: bigint): boolean {
    console.log("checking withdrawal amount")
    console.log(amount)
    console.log(balance)
    if (!isAmountValid(amount)) {
      return false;
    }
    const amountInE8s = convertToE8s(amount);
    console.log(amountInE8s)
    return amountInE8s <= balance;
  }

  function setMaxWithdrawAmount() {
    const maxAmount = Number(fplBalance) / 100_000_000;
    withdrawalInputAmount = maxAmount.toFixed(4);
  }

  $: isSubmitDisabled = !isPrincipalValid(withdrawalAddress) || !isWithdrawAmountValid(withdrawalInputAmount, fplBalance);

  $: errorMessage = (!isAmountValid(withdrawalInputAmount) || !isWithdrawAmountValid(withdrawalInputAmount, fplBalance)) && withdrawalInputAmount
    ? "Withdrawal amount greater than account balance."
    : "";

  async function withdrawFPL() {
    try {
      isLoading = true;
      const amountInE8s = convertToE8s(withdrawalInputAmount);
      await userStore.withdrawFPL(withdrawalAddress, amountInE8s);
      toasts.addToast( { message: "Withdrawal Successful.", type: "success" });
      await closeModal();
      isLoading = false;
    } catch (error) {
      console.error("Error withdrawing FPL:", error);
      cancelModal();
    } finally {
    }
  }
</script>

<Modal showModal={visible} onClose={closeModal}>
  <div class="mx-4 p-4">
    <div class="flex justify-between items-center my-2">
      <h3 class="default-header">Withdraw FPL</h3>
      <button class="times-button" on:click={cancelModal}>&times;</button>
    </div>
    {#if isLoading}
      <LocalSpinner />
    {:else}
      <form on:submit|preventDefault={withdrawFPL}>
        <p>FPL Balance: {fplBalanceFormatted}</p>
        <div class="mt-4">
          <input
            type="text"
            class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"
            placeholder="Withdrawal Address"
            bind:value={withdrawalAddress}
          />
        </div>
        <div class="mt-4 flex items-center">
          <input
            type="text"
            class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black mr-2"
            placeholder="Withdrawal Amount"
            bind:value={withdrawalInputAmount}
          />
          <button
            type="button"
            class="brand-button text-xs"
            on:click={setMaxWithdrawAmount}
          >
            Max
          </button>
        </div>
        {#if errorMessage}
          <div class="mt-2 text-red-600">{errorMessage}</div>
        {/if}
        <div class="items-center py-3 flex space-x-4 flex-row">
          <button
            class="px-4 py-2 brand-cancel-button"
            type="button"
            on:click={cancelModal}
          >
            Cancel
          </button>
          <button
            class={`px-4 py-2 ${
              isSubmitDisabled ? "brand-button-disabled" : "brand-button"
            }`}
            type="submit"
            disabled={isSubmitDisabled}
          >
            Withdraw
          </button>
        </div>
      </form>
    {/if}
  </div>
</Modal>
