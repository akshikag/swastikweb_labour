<template>
  <section class="employer-profile-page">
    <LogoutAppBar />

    <main class="profile-content">
      <div class="profile-title-block">
        <h1>My Profile</h1>
        <div class="profile-title-rule" aria-hidden="true">
          <span></span><i></i><span></span>
        </div>
      </div>

      <nav class="profile-menu" aria-label="Employer profile sections">
        <button
          v-for="item in menuItems"
          :key="item.title"
          class="profile-menu-item"
          type="button"
          @click="$router.push(item.route)"
        >
          <span class="profile-menu-icon"><v-icon :icon="item.icon" /></span>
          <span class="profile-menu-title">{{ item.title }}</span>
          <v-icon class="profile-menu-arrow" icon="mdi-chevron-right" />
        </button>
      </nav>
    </main>
  </section>
</template>

<script>
import LogoutAppBar from '@/components/header/LogoutAppBar.vue'

export default {
  components: { LogoutAppBar },
  data: () => ({
    menuItems: [
      { title: 'Basic Details', icon: 'mdi-account', route: '/employer-dashboard-profile-basic' },
      { title: 'Identity & Verification', icon: 'mdi-card-account-details', route: '/employer-dashboard-profile-identity' },
      { title: 'Location Information', icon: 'mdi-map-marker', route: '/employer-dashboard-profile-location' },
      { title: 'Work Details', icon: 'mdi-briefcase', route: '/employer-dashboard-profile-work' },
      { title: 'Change Password', icon: 'mdi-lock-reset', route: '/employer-dashboard-profile-password' },
      { title: 'Help', icon: 'mdi-help-circle', route: '/employer-dashboard-profile-help' },
    ],
  }),
}
</script>

<style scoped>
.employer-profile-page {
  min-height: calc(100vh - 64px);
  overflow: hidden;
  color: #071b58;
  background: #fff url('@/assets/authenticated-background.png') center top/100% 100% no-repeat;
}

.profile-content {
  width: min(930px, calc(100% - 44px));
  margin: 50px auto 90px;
}

.profile-title-block {
  margin-bottom: 38px;
  text-align: center;
}

.profile-title-block h1 {
  margin: 0;
  color: #071b58;
  font-size: clamp(38px, 4.4vw, 57px);
  font-weight: 800;
  letter-spacing: -.8px;
}

.profile-title-rule {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 11px;
  width: 300px;
  margin: 19px auto 0;
}

.profile-title-rule span {
  width: 114px;
  height: 2px;
  background: #14357f;
}

.profile-title-rule i {
  display: block;
  width: 19px;
  height: 19px;
  border: 2px solid #1167df;
  transform: rotate(45deg);
}

.profile-menu {
  display: grid;
  gap: 16px;
}

.profile-menu-item {
  display: flex;
  align-items: center;
  width: 100%;
  min-height: 104px;
  padding: 16px 28px;
  border: 1px solid #badcff;
  border-radius: 23px;
  color: #071b58;
  background: rgba(255, 255, 255, .92);
  box-shadow: 0 7px 18px rgba(21, 111, 210, .12);
  font-family: 'Poppins', sans-serif;
  text-align: left;
  cursor: pointer;
  transition: transform .18s, border-color .18s, box-shadow .18s;
}

.profile-menu-item:hover {
  border-color: #57a9f5;
  box-shadow: 0 10px 22px rgba(21, 111, 210, .2);
  transform: translateY(-2px);
}

.profile-menu-item:focus-visible {
  outline: 3px solid rgba(17, 103, 223, .3);
  outline-offset: 2px;
}

.profile-menu-icon {
  display: grid;
  place-items: center;
  flex: 0 0 77px;
  width: 77px;
  height: 77px;
  margin-right: 29px;
  border-radius: 18px;
  color: #0962d4;
  background: #e2f1ff;
}

.profile-menu-icon .v-icon { font-size: 42px; }
.profile-menu-title { flex: 1; font-size: clamp(22px, 2.8vw, 34px); line-height: 1.2; font-weight: 500; }
.profile-menu-arrow { flex: 0 0 auto; color: #071b58; font-size: 42px; }

@media (max-width: 650px) {
  .employer-profile-page { min-height: calc(100vh - 64px); background-size: auto 100%; }
  .profile-content { width: calc(100% - 24px); margin: 15px auto 88px; }
  .profile-title-block { margin-bottom: 25px; }
  .profile-title-block h1 { font-size: 36px; }
  .profile-title-rule { width: 220px; margin-top: 14px; }
  .profile-title-rule span { width: 78px; }
  .profile-menu { gap: 12px; }
  .profile-menu-item { min-height: 40px; padding: 3px 7px; border-radius: 17px; }
  .profile-menu-icon { flex: 0 0 30px; width: 30px; height: 30px; margin-right: 15px; border-radius: 13px; }
  .profile-menu-icon .v-icon { font-size: 25px; }
  .profile-menu-title { font-size: clamp(16px, 4.8vw, 22px); }
  .profile-menu-arrow { font-size: 31px; }
}

@media (max-width: 390px) {
  .profile-content { width: calc(100% - 20px); }
  .profile-title-block h1 { font-size: 34px; }
  .profile-menu-title { font-size: 16px; }
}
</style>
