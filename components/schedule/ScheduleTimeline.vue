
<script setup lang="ts">
import { gql } from "graphql-tag";
import VueDraggable from 'vuedraggable';

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

const { data } = await useAsyncQuery(GET_ACTIONS);
const actions = computed(() => 
  data.value?.actionsCollection?.edges?.map(edge => edge.node) || []
);

const onSort = (evt: any) => {
  // ここでドラッグ&ドロップ後の並び順を保存するロジックを実装
  console.log('New order:', actions.value.map(action => action.id));
};
</script>

<template>
  <div class="p-4">
    <VueDraggable 
      v-model="actions" 
      item-key="id"
      @end="onSort"
      handle=".drag-handle"
      class="space-y-2"
    >
      <template #item="{ element }">
        <div class="bg-white rounded-lg shadow-sm p-2 cursor-move drag-handle">
          <ScheduleTimelineItem :action="element" />
        </div>
      </template>
    </VueDraggable>
  </div>
</template>
