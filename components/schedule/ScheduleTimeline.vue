
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
  console.log('New order:', actions.value.map(action => action.id));
};
</script>

<template>
  <div class="p-4 max-w-3xl mx-auto">
    <VueDraggable ref="el" v-model="actions" item-key="id" @end="onSort" :animation="300" ghost-class="ghost"
      chosen-class="chosen" drag-class="drag" handle=".drag-handle" class="space-y-8">
      <div class="bg-white rounded-lg shadow-sm p-4 cursor-move drag-handle hover:bg-gray-50 transition-colors"
        v-for="action in actions">
        <ScheduleTimelineItem :action="action" />
      </div>
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
