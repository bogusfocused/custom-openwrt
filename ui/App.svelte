<script>
  let name = "world";
  import providers from "./providers.json";
  var gd = providers.providers[9];
</script>

{#each gd.Options as item}
  <div>
    <span><b>{item.Help.split("\n", 1)[0]}</b></span><br />
    <span>{item.Help.split("\n", 2)[1]}</span><br />
    <input />
    <br />
    <pre>{item.Help}</pre><br />
  </div>
{/each}
