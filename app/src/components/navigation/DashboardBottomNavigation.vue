<template>
  <v-bottom-navigation :model-value="activeTab" class="dashboard-bottom-nav" color="primary" grow app>
    <v-btn :to="`${dashboardPrefix}-home`">
      <v-icon>mdi-home</v-icon>
      <span>Home</span>
    </v-btn>

    <v-btn :to="`${dashboardPrefix}-search`">
      <v-icon>mdi-magnify</v-icon>
      <span>Search</span>
    </v-btn>

    <v-btn :to="`${dashboardPrefix}-profile`">
      <v-icon>mdi-account-circle</v-icon>
      <span>Profile</span>
    </v-btn>
  </v-bottom-navigation>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'

const props = defineProps({
  role: {
    type: String,
    required: true,
    validator: (value) => ['worker', 'employer'].includes(value),
  },
})

const route = useRoute()
const dashboardPrefix = computed(() => `/${props.role}-dashboard`)
const activeTab = computed(() => {
  if (route.path.startsWith(`${dashboardPrefix.value}-search`)) return 1
  if (route.path.startsWith(`${dashboardPrefix.value}-profile`)) return 2
  return 0
})
</script>

<style scoped>
.dashboard-bottom-nav {
  position: fixed !important;
  z-index: 1000 !important;
  left: 0 !important;
  right: 0 !important;
  bottom: 0 !important;
  height: calc(78px + env(safe-area-inset-bottom)) !important;
  padding: 0 clamp(14px, 7vw, 68px) env(safe-area-inset-bottom);
  border-radius: 24px 24px 0 0 !important;
  background: rgb(255 255 255 / 97%) !important;
  box-shadow: 0 -4px 18px rgb(5 54 105 / 14%) !important;
}

.dashboard-bottom-nav :deep(.v-btn) {
  min-width: 0 !important;
  height: 70px !important;
  border-radius: 24px 24px 0 0 !important;
  color: #03163c;
  font-size: 14px;
  letter-spacing: 0;
  text-transform: none;
}

.dashboard-bottom-nav :deep(.v-btn .v-icon) {
  margin-bottom: 2px;
  font-size: 29px;
}

.dashboard-bottom-nav :deep(.v-btn--active) {
  color: #075bb8 !important;
  background: linear-gradient(180deg, #e8f4ff, #f8fcff) !important;
}

.dashboard-bottom-nav :deep(.v-btn--active .v-icon) {
  transform: scale(1.08);
}

.dashboard-bottom-nav :deep(.v-btn__overlay) {
  opacity: 0 !important;
}
</style>
