<script lang="ts">
  import { getFlagComponent } from "$lib/utils/helpers";
  interface Props {
    className: string;
  }

  let { className } : Props = $props();
  const flag = getFlagComponent(46);
</script>

<component
  this={flag}
  class={className}
></component>