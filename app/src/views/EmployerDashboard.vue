<template>
    <v-app class="employer-dashboard-shell">
        <!-- Page Content -->
        <v-main>
            <router-view />
            <DashboardBottomNavigation role="employer" />
        </v-main>
    </v-app>
</template>
<script setup>
import DashboardBottomNavigation from '@/components/navigation/DashboardBottomNavigation.vue'
</script>
<style scoped>
.employer-dashboard-shell :deep(.v-main) {
    padding-bottom: calc(78px + env(safe-area-inset-bottom)) !important;
}
</style>
