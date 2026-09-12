<template>
  <header class="dashboard-app-bar">
    <div class="dashboard-government-brand" :class="{ 'dashboard-government-brand--no-emblem': hideEmblem }">
      <span v-if="!hideEmblem" class="dashboard-government-emblem">
        <img src="@/assets/himachal-emblem1.png" alt="Himachal Pradesh government emblem" />
      </span>
      <span class="dashboard-government-copy">
        <strong>Govt. of Himachal Pradesh</strong>
        <small>हिमाचल प्रदेश सरकार</small>
      </span>
    </div>

    <button class="dashboard-logout-button" type="button" @click="logout">
      <span>Logout</span>
      <v-icon icon="mdi-logout" />
    </button>
  </header>
</template>

<script setup>
import { useRouter } from 'vue-router'

defineProps({
  hideEmblem: { type: Boolean, default: false },
})

const router = useRouter()

function logout() {
  localStorage.removeItem('labour_currentUser')
  localStorage.removeItem('labouchowk_userType')
  router.push('/')
}
</script>

<style scoped>
.dashboard-app-bar {
  position: relative;
  z-index: 20;
  display: flex;
  align-items: center;
  justify-content: space-between;
  min-height: 100px;
  padding: max(12px, env(safe-area-inset-top)) clamp(24px, 6vw, 64px) 14px;
  overflow: hidden;
  border-bottom-right-radius: 105px 48px;
  color: #fff;
  background:
    radial-gradient(circle at 58% 120%, rgb(47 153 235 / 35%), transparent 42%),
    linear-gradient(118deg, #287fd2 0%, #075dbd 48%, #00458e 100%);
  box-shadow: 0 5px 15px rgb(2 74 151 / 16%);
}

.dashboard-app-bar::after {
  content: '';
  position: absolute;
  top: -50px;
  right: -54px;
  width: clamp(58px, 9vw, 92px);
  height: 185px;
  transform: rotate(24deg);
  background: linear-gradient(90deg, #ff7317, #ffd4bc 58%, #fff);
}

.dashboard-government-brand,
.dashboard-logout-button { position: relative; z-index: 1; }
.dashboard-government-brand { display: flex; align-items: center; gap: 3px; }
.dashboard-government-brand--no-emblem { gap: 0; }
.dashboard-government-emblem { display: grid; place-items: center; width: 77px; height: 64px; padding: 7px; }
.dashboard-government-emblem img { width: 100%; height: 100%; object-fit: contain; }
.dashboard-government-copy { display: flex; flex-direction: column; line-height: 1.08; }
.dashboard-government-copy strong { font-size: clamp(18px, 2.3vw, 25px); font-weight: 800; }
.dashboard-government-copy small { margin-top: 4px; font-size: clamp(15px, 2vw, 21px); }
.dashboard-logout-button { display: flex; align-items: center; gap: clamp(9px, 1.8vw, 17px); margin-right: clamp(16px, 5vw, 48px); border: 0; background: transparent; color: #fff; font: inherit; font-size: clamp(15px, 2.3vw, 22px); font-weight: 800; text-transform: uppercase; cursor: pointer; }
.dashboard-logout-button .v-icon { font-size: 43px; }

@media (max-width: 560px) {
  .dashboard-app-bar { padding-inline: 18px; min-height: 100px; }
  .dashboard-app-bar::after { right: -66px; }
  .dashboard-logout-button { margin-right: 8px; }
  .dashboard-logout-button span { display: none; }
}

@media (max-width: 390px) {
  .dashboard-government-copy strong { font-size: 17px; }
  .dashboard-government-copy small { font-size: 13px; }
  .dashboard-government-emblem { width: 77px; height: 64px; }
}
</style>
