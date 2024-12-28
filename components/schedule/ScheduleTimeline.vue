
<script setup lang="ts">
import { gql } from "graphql-tag";
import {
  type DraggableEvent,
  type UseDraggableReturn,
  VueDraggable
} from 'vue-draggable-plus';

const el = ref<UseDraggableReturn>()
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

const actions = computed(() =>
  result.value?.actionsCollection?.edges?.map(edge => edge.node) || []
);

const onSort = (evt: any) => {
  // Here you would implement the logic to save the new order
  console.log('New order:', actions.value.map(action => action.id));
};
</script>

<template>
  <div class="p-4">
    <VueDraggable ref="el" v-model="actions" item-key="id" @end="onSort" :animation="300" ghost-class="ghost"
      chosen-class="chosen" drag-class="drag" handle=".drag-handle" class="space-y-2">
      <template #item="{ element }">
        <div class="bg-white rounded-lg shadow-sm p-2 cursor-move drag-handle hover:bg-gray-50 transition-colors">
          <ScheduleTimelineItem :action="element" />
        </div>
      </template>
    </VueDraggable>
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
