
<script setup lang="ts">
import { gql } from "graphql-tag";
import { VueDraggable } from 'vue-draggable-plus';

const GET_ACTIONS = gql`
  query GetActions {
    actionsCollection {
      edges {
        node {
          id
          title
          context
          start_time
          end_time
        }
      }
    }
  }
`;

const { result } = useQuery(GET_ACTIONS);

const scheduledActions = computed(() =>
  result.value?.actionsCollection?.edges
    ?.map(edge => edge.node)
    .filter(action => action.start_time)
    .sort((a, b) => new Date(a.start_time) - new Date(b.start_time)) || []
);

const unscheduledActions = computed(() =>
  result.value?.actionsCollection?.edges
    ?.map(edge => edge.node)
    .filter(action => !action.start_time) || []
);

const onSort = (evt: any) => {
  console.log('New order:', evt.to.id);
};
</script>

<template>
  <div class="flex flex-col h-full">
    <!-- Scheduled Actions -->
    <div class="flex-1 p-4 overflow-y-auto">
      <VueDraggable 
        v-model="scheduledActions" 
        id="scheduled"
        item-key="id" 
        @end="onSort"
        :animation="300" 
        ghost-class="ghost"
        :group="{ name: 'actions' }"
        class="space-y-4"
      >
        <div v-for="action in scheduledActions" :key="action.id"
          class="bg-white rounded-lg shadow-sm p-4 cursor-move hover:bg-gray-50">
          <ScheduleTimelineItem :action="action" />
        </div>
      </VueDraggable>
    </div>

    <!-- Unscheduled Actions -->
    <div class="border-t border-gray-200 p-4 bg-gray-50">
      <h3 class="text-sm font-medium text-gray-500 mb-4">Unscheduled Tasks</h3>
      <VueDraggable 
        v-model="unscheduledActions" 
        id="unscheduled"
        item-key="id" 
        @end="onSort"
        :animation="300" 
        ghost-class="ghost"
        :group="{ name: 'actions' }"
        class="flex flex-wrap gap-4"
      >
        <div v-for="action in unscheduledActions" :key="action.id"
          class="bg-white rounded-lg shadow-sm p-2 cursor-move hover:bg-gray-50 w-48">
          <div class="flex items-center gap-2">
            <div class="w-8 h-8 rounded-full" :class="contextColors[action.context] || 'bg-gray-500'">
              <UIcon :name="contextIcons[action.context] || 'i-lucide-check'" class="w-5 h-5 m-1.5 text-white"/>
            </div>
            <span class="text-sm">{{ action.title }}</span>
          </div>
        </div>
      </VueDraggable>
    </div>
  </div>
</template>

<style scoped>
.ghost {
  opacity: 0.5;
  background: #c8ebfb;
}

.chosen {
  background: #eee;
}

.drag {
  opacity: 0.9;
}
</style>
