
<template>
  <div class="flex items-center gap-4">
    <div class="text-sm text-gray-500 w-24 text-right">{{ time }}</div>
    <div class="relative">
      <div class="absolute h-full w-0.5 bg-gray-200 left-1/2 -translate-x-1/2 -top-4"></div>
      <div class="w-10 h-10 rounded-full" :class="bgColorClass" :title="action.context">
        <UIcon :name="icon" class="w-6 h-6 m-2 text-white"/>
      </div>
    </div>
    <div class="flex-1">
      <h3 class="text-sm font-medium">{{ action.title }}</h3>
      <p v-if="duration" class="text-xs text-gray-500">{{ duration }}</p>
    </div>
    <div class="w-8">
      <input type="checkbox" class="rounded-full" :checked="action?.completed">
    </div>
  </div>
</template>

<script setup lang="ts">
const props = defineProps<{
  action: {
    id: string;
    title: string;
    context?: string;
    start_time?: string;
    end_time?: string;
    completed?: boolean;
  };
}>();

const time = computed(() => props.action.start_time?.slice(0, 5));
const duration = computed(() => {
  if (props.action.start_time && props.action.end_time) {
    return `${props.action.start_time.slice(0, 5)} - ${props.action.end_time.slice(0, 5)}`;
  }
  return '';
});

const contextColors = {
  office: 'bg-blue-500',
  home: 'bg-green-500',
  outside: 'bg-orange-500',
  default: 'bg-gray-500'
};

const contextIcons = {
  office: 'i-lucide-briefcase',
  home: 'i-lucide-home',
  outside: 'i-lucide-map',
  default: 'i-lucide-check'
};

const bgColorClass = computed(() => contextColors[props.action.context as keyof typeof contextColors] || contextColors.default);
const icon = computed(() => contextIcons[props.action.context as keyof typeof contextIcons] || contextIcons.default);
</script>
