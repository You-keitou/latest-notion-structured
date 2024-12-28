<script>
definePageMeta({
  colorMode: "dark",
});
</script>

<template>
  <div>
    <NuxtLayout>
      <NuxtLoadingIndicator />
      <NuxtPage />
      <UNotifications />
    </NuxtLayout>
  </div>
</template>

<style>
@import url("https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600&display=swap");

* {
  font-family: "Plus Jakarta Sans", sans-serif;
}
</style>
