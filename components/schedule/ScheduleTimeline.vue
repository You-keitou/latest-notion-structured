<script lang="ts" setup>
import { gql } from "graphql-tag";

const GET_PROJECTS = gql`
  query GetActions {
    actionsCollection {
      edges {
        node {
          id
          title
        }
      }
    }
  }
`;

const { data } = await useAsyncQuery(GET_PROJECTS);
</script>

<template>
  <div>
    <h1>ScheduleTimeline</h1>
    {{ data }}
  </div>
</template>

<style scoped></style>
