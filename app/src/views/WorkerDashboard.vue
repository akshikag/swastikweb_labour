<template>
    <v-app class="worker-dashboard-shell">
        <!-- App Bar -->
        <v-main>
            <router-view />
            <DashboardBottomNavigation role="worker" />
        </v-main>
    </v-app>
</template>
<script setup>
import DashboardBottomNavigation from '@/components/navigation/DashboardBottomNavigation.vue'
</script>
<style scoped>
.worker-dashboard-shell :deep(.v-main) {
    padding-bottom: calc(78px + env(safe-area-inset-bottom)) !important;
}

/* Shared field appearance for every page inside the worker dashboard. */
.worker-dashboard-shell :deep(.v-field) {
    background: #eef6ff !important;
    --v-field-border-opacity: 1 !important;
}

.worker-dashboard-shell :deep(.v-field--variant-outlined .v-field__outline) {
    color: #082f77 !important;
    opacity: 1 !important;
}

.worker-dashboard-shell :deep(.v-field--focused .v-field__outline) {
    color: #075fd0 !important;
}
</style>
