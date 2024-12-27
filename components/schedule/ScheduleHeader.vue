<!-- components/schedule/ScheduleHeader.vue -->
<template>
  <div class="space-y-4">
    <!-- ヘッダー -->
    <div class="flex items-center justify-between">
      <h1 class="text-2xl font-semibold">
        November <span class="text-primary-500">2024</span>
      </h1>
      <!-- アイコングループ -->
      <UButtonGroup>
        <UButton
          v-for="icon in headerIcons"
          :key="icon"
          :icon="icon"
          color="gray"
          variant="ghost"
        />
      </UButtonGroup>
    </div>

    <!-- カレンダーグリッド -->
    <div class="p-2">
      <div class="grid grid-cols-7 gap-1">
        <!-- 曜日ヘッダー -->
        <div
          v-for="day in weekDays"
          :key="day"
          class="text-center text-sm text-gray-500"
        >
          {{ day }}
        </div>
        <!-- 日付 -->
        <UButton
          v-for="date in dates"
          :key="date.day"
          :variant="date.isToday ? 'solid' : 'ghost'"
          color="primary"
          class="aspect-square flex items-center justify-center"
        >
          {{ date.day }}
        </UButton>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import dayjs from "dayjs";

const headerIcons = ["lucide-calendar-days", "lucide-inbox", "lucide-settings"];
const weekDays = [...Array(7)].map((_, i) => dayjs().day(i).format("ddd"));
const startOfWeek = dayjs().startOf("week");
const dates = [...Array(7)].map((_, i) => {
  const date = startOfWeek.add(i, "day");
  return {
    day: date.date(),
    isToday: date.isSame(dayjs(), "day"),
  };
});
</script>
