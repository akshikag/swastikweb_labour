<template>
  <v-app :class="{ 'authenticated-app': isAuthenticatedPage }">
    <button
      v-if="showGlobalBackButton"
      class="global-back-button"
      type="button"
      aria-label="Go to previous page"
      @click="goBack"
    >
      <v-icon icon="mdi-arrow-left" />
    </button>
    <router-view />
  </v-app>
</template>

<script>

export default {
  name: 'App',

  data: () => ({
    //
  }),

  computed: {
    isAuthenticatedPage() {
      return this.$route.matched.some(routeRecord => routeRecord.meta.requiresAuth)
    },

    showGlobalBackButton() {
      return this.$route.path !== '/' && !this.isAuthenticatedPage
    },
  },

  methods: {
    goBack() {
      if (window.history.state?.back) {
        this.$router.back()
      } else {
        this.$router.push('/')
      }
    },
  },
}
</script>

<style>
.global-back-button {
  position: fixed;
  top: max(14px, calc(env(safe-area-inset-top) + 10px));
  left: max(12px, calc(env(safe-area-inset-left) + 12px));
  z-index: 10050;
  display: grid;
  place-items: center;
  width: clamp(38px, 10vw, 46px);
  height: clamp(38px, 10vw, 46px);
  padding: 0;
  border: 1px solid rgb(255 255 255 / 75%);
  border-radius: 50%;
  background: linear-gradient(145deg, #2488dd, #0752a5);
  color: #fff;
  font-size: clamp(22px, 5.7vw, 27px);
  box-shadow: 0 3px 10px rgb(1 54 119 / 28%);
  cursor: pointer;
  touch-action: manipulation;
  -webkit-tap-highlight-color: transparent;
}

.global-back-button:active {
  transform: translateY(1px);
  box-shadow: 0 1px 5px rgb(1 54 119 / 25%);
}

.global-back-button:focus-visible {
  outline: 3px solid #ff8a00;
  outline-offset: 3px;
}

.authenticated-app {
  position: relative;
  isolation: isolate;
  background: transparent !important;
}

.authenticated-app::before {
  content: '';
  position: fixed;
  inset: 0;
  z-index: -1;
  background: #fff url('@/assets/authenticated-background.png') center / 100% 100% no-repeat;
}

.authenticated-app .v-application,
.authenticated-app .v-application__wrap,
.authenticated-app .v-main {
  background: transparent !important;
}
</style>
