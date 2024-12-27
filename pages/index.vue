<script setup lang="ts">
import ScheduleHeader from "~/components/schedule/ScheduleHeader.vue";
import ScheduleTimeline from "~/components/schedule/ScheduleTimeline.vue";

definePageMeta({
  middleware: "auth",
});

useSeoMeta({
  title: "Nuxt Supabase Starter - Supercharged Your Project",
});

const toast = useToast();

const packageInstall = "npx nuxt-supabase-starter my-app";

const copyText = () => {
  navigator.clipboard.writeText(packageInstall);
  toast.add({
    color: "green",
    title: "Copied to clipboard!",
    icon: "i-lucide-check-circle",
  });
};
</script>

<template>
  <UContainer class="h-screen py-2 flex flex-col">
    <!-- メインコンテンツ -->
    <ScheduleHeader />
    <ScheduleTimeline class="flex-1 overflow-y-auto" />
  </UContainer>
</template>

<style scoped></style>
