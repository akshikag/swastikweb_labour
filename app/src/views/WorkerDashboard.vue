<template>
    <v-app class="worker-dashboard-shell">
        <!-- App Bar -->
        <v-main>
            <router-view />
            <!-- Bottom Navigation -->
            <v-bottom-navigation :model-value="activeTab" class="worker-bottom-nav" color="primary" grow app>
                <v-btn to="/worker-dashboard-home">
                    <v-icon>mdi-home</v-icon>
                    <span>Home</span>
                </v-btn>

                <v-btn to="/worker-dashboard-search">
                    <v-icon>mdi-magnify</v-icon>
                    <span>Search</span>
                </v-btn>

                <v-btn to="/worker-dashboard-profile">
                    <v-icon>mdi-account-circle</v-icon>
                    <span>Profile</span>
                </v-btn>
            </v-bottom-navigation>
        </v-main>
    </v-app>
</template>
<script>

export default {

    data() {
        return {};
    },
    computed: {
        activeTab() {
            const path = this.$route.path;
            if (path.startsWith('/worker-dashboard-search')) return 1;
            if (path.startsWith('/worker-dashboard-profile')) return 2;
            return 0;
        },
    },
};
</script>
<style scoped>
.worker-dashboard-shell :deep(.v-main) {
    padding-bottom: calc(78px + env(safe-area-inset-bottom)) !important;
}

.worker-bottom-nav {
    position: fixed !important;
    z-index: 1000 !important;
    left: 0 !important;
    right: 0 !important;
    bottom: 0 !important;
    height: calc(78px + env(safe-area-inset-bottom)) !important;
    padding: 0 clamp(14px, 7vw, 68px) env(safe-area-inset-bottom);
    background: rgb(255 255 255 / 97%) !important;
    box-shadow: 0 -4px 18px rgb(5 54 105 / 14%) !important;
}

.worker-bottom-nav :deep(.v-btn) {
    min-width: 0 !important;
    height: 70px !important;
    border-radius: 24px 24px 0 0 !important;
    color: #03163c;
    font-size: 14px;
    letter-spacing: 0;
    text-transform: none;
}

.worker-bottom-nav :deep(.v-btn .v-icon) {
    margin-bottom: 2px;
    font-size: 29px;
}

.worker-bottom-nav :deep(.v-btn--active) {
    color: #075bb8 !important;
    background: linear-gradient(180deg, #e8f4ff, #f8fcff) !important;
}

.worker-bottom-nav :deep(.v-btn--active .v-icon) {
    transform: scale(1.08);
}

.worker-bottom-nav :deep(.v-btn__overlay) {
    opacity: 0 !important;
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
