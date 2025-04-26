<script lang="ts">
  import { getFlagComponent } from "$lib/utils/helpers";
  interface Props {
    className: string;
  }

  let { className } : Props = $props();
  const flag = getFlagComponent(64);
</script>

<component
  this={flag}
  class={className}
></component>