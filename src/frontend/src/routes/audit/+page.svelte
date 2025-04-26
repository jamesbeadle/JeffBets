<script lang="ts">
    import { onMount } from "svelte";
    import { goto } from "$app/navigation";
    import Layout from "../Layout.svelte";
    import FullScreenSpinner from "$lib/components/shared/global/full-screen-spinner.svelte";
  
    import { authStore } from "$lib/stores/auth-store";
    import { auditStore } from "$lib/stores/audit-store";
    import { userStore } from "$lib/stores/user-store";
    import { formatUnixDateToSmallReadable, formatUnixTimeToTime } from "$lib/utils/helpers";
    import type { UserAuditList } from "../../../../declarations/backend/backend.did";
  
    let isLoading = true;
    let auditData: UserAuditList | undefined = undefined;
    
  
    onMount(async () => {
        await authStore.sync();
    
        authStore.subscribe((store) => {
            
            let isLoggedIn = store.identity !== null && store.identity !== undefined;
            if(!isLoggedIn){
                goto('/');
                return;
            }
        });

        let isAuditor = false//TODO await userStore.isAuditor();
        if(!isAuditor){
            goto('/');
            return;
        }

        //auditData = await auditStore.getUserAudit(1); //TODO
        isLoading = false;
    });
  </script>
  
  <Layout>
    {#if isLoading}
      <FullScreenSpinner />
    {:else}
        {#if auditData}
            <div class="m-4 bg-panel rounded-md p-4">
                <h1 class="text-2xl font-bold mb-4">KYC Audit</h1>
                <div class="overflow-x-auto">
                <table class="min-w-full table-auto border-collapse">
                    <thead>
                    <tr class="bg-BrandGray text-white">
                        <th class="py-2 px-4 text-left">Principal ID</th>
                        <th class="py-2 px-4 text-left">Joined Date</th>
                        <th class="py-2 px-4 text-left">Terms Accepted Date</th>
                        <th class="py-2 px-4 text-left">KYC Submission Date</th>
                        <th class="py-2 px-4 text-left">KYC Approval Date</th>
                        <th class="py-2 px-4 text-left">KYC Reference</th>
                    </tr>
                    </thead>
                    <tbody>
                    {#each auditData.users as user}
                        <tr class="border-b border-BrandGray">
                            <td class="py-2 px-4 font-sm">{user.principalId}</td>
                            <td class="py-2 px-4">{user.joinedDate && user.joinedDate > 0 ? formatUnixDateToSmallReadable(Number(user.joinedDate)) + ", " + formatUnixTimeToTime(Number(user.joinedDate)) : "-"}</td>
                            <td class="py-2 px-4">{user.termsAcceptedDate && user.termsAcceptedDate > 0 ? formatUnixDateToSmallReadable(Number(user.termsAcceptedDate)) + ", " + formatUnixTimeToTime(Number(user.termsAcceptedDate))  :  "-"}</td>
                            <td class="py-2 px-4">{user.kycSubmissionDate && user.kycSubmissionDate > 0 ? formatUnixDateToSmallReadable(Number(user.kycSubmissionDate)) + ", " + formatUnixTimeToTime(Number(user.kycSubmissionDate)) : "-"}</td>
                            <td class="py-2 px-4">{user.kycApprovalDate && user.kycApprovalDate > 0 ? formatUnixDateToSmallReadable(Number(user.kycApprovalDate)) + ", " + formatUnixTimeToTime(Number(user.kycApprovalDate)) : "-"}</td>
                            <td class="py-2 px-4">{user.kycRef || "-"}</td>
                        </tr>
                    {/each}
                    </tbody>
                </table>
                </div>
            </div>
        {/if}
    {/if}
  </Layout>
  