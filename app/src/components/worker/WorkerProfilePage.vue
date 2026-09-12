<template>
  <section class="worker-profile-page">
    <DashboardAppBar />
    <main class="profile-content">
      <div class="profile-title-block"><h1>My Profile</h1><div class="profile-title-rule"><span></span><i></i><span></span></div></div>
      <nav class="profile-menu" aria-label="Profile sections">
        <button v-for="item in menuItems" :key="item.title" class="profile-menu-item" type="button" @click="$router.push(item.route)">
          <span class="profile-menu-icon"><v-icon :icon="item.icon" /></span><span class="profile-menu-title">{{ item.title }}</span><v-icon class="profile-menu-arrow" icon="mdi-chevron-right" />
        </button>
      </nav>
    </main>
  </section>
</template>

<script>
import DashboardAppBar from '@/components/header/DashboardAppBar.vue'

export default {
  data: () => ({ menuItems: [
    { title: 'Basic Details', icon: 'mdi-account', route: '/worker-dashboard-profile-basic' },
    { title: 'Identity & Verification', icon: 'mdi-card-account-details', route: '/worker-dashboard-profile-identity' },
    { title: 'Location Information', icon: 'mdi-map-marker', route: '/worker-dashboard-profile-location' },
    { title: 'Skill Details', icon: 'mdi-briefcase', route: '/worker-dashboard-profile-skill' },
    { title: 'Add Experience / Work History', icon: 'mdi-plus', route: '/worker-dashboard-profile-workhistory' },
    { title: 'Add Education', icon: 'mdi-plus', route: '/worker-dashboard-profile-education' },
    { title: 'Change Password', icon: 'mdi-lock-reset', route: '/worker-dashboard-profile-password' },
    { title: 'Help', icon: 'mdi-help-circle', route: '/worker-dashboard-profile-help' },
  ] }),
  components: { DashboardAppBar },
}
</script>

<style scoped>
.worker-profile-page{min-height:calc(100vh - 64px);color:#071b58;background:#fff url('@/assets/authenticated-background.png') center top/100% 100% no-repeat;overflow:hidden}
.profile-hero{position:relative;z-index:1;display:flex;align-items:center;justify-content:space-between;min-height:230px;padding:30px clamp(30px,6.2vw,64px) 35px;color:#fff;background:linear-gradient(112deg,#2589ed,#0877df 52%,#03499f);border-bottom-right-radius:150px 66px;box-shadow:0 8px 22px #0039992e}
.profile-hero:after{content:'';position:absolute;right:-38px;bottom:-34px;width:220px;height:110px;border-radius:50%;background:#d9eeff;opacity:.65;transform:rotate(-25deg);z-index:-1}
.profile-brand{display:flex;align-items:center;gap:34px}.profile-emblem{display:grid;place-items:center;width:142px;height:142px;padding:22px;overflow:hidden;border-radius:50%;background:#fff;box-shadow:0 8px 18px #002a732e}.profile-emblem img{width:100%;height:100%;object-fit:contain}.profile-government-copy{display:flex;flex-direction:column;gap:9px;line-height:1.06}.profile-government-copy strong{font-size:clamp(29px,3.3vw,47px);font-weight:800;letter-spacing:-.8px}.profile-government-copy small{font-size:clamp(26px,2.8vw,40px)}.profile-logout{align-self:flex-start;margin:21px 24px 0 0;border:0;color:#fff;background:transparent;cursor:pointer}.profile-logout .v-icon{font-size:57px}
.profile-content{width:min(930px,calc(100% - 44px));margin:68px auto 90px}.profile-title-block{text-align:center;margin-bottom:38px}.profile-title-block h1{margin:0;color:#071b58;font-size:clamp(38px,4.4vw,57px);font-weight:800;letter-spacing:-.8px}.profile-title-rule{display:flex;align-items:center;justify-content:center;gap:11px;margin:19px auto 0;width:300px}.profile-title-rule span{width:114px;height:2px;background:#14357f}.profile-title-rule i{display:block;width:19px;height:19px;border:2px solid #1167df;transform:rotate(45deg)}
.profile-menu{display:grid;gap:16px}.profile-menu-item{display:flex;align-items:center;width:100%;min-height:104px;padding:16px 28px;border:1px solid #badcff;border-radius:23px;color:#071b58;background:#ffffffeB;box-shadow:0 7px 18px #156fd21f;text-align:left;cursor:pointer;transition:.18s}.profile-menu-item:hover{transform:translateY(-2px);border-color:#57a9f5;box-shadow:0 10px 22px #156fd233}.profile-menu-icon{display:grid;place-items:center;flex:0 0 77px;width:77px;height:77px;margin-right:29px;border-radius:18px;color:#0962d4;background:#e2f1ff}.profile-menu-icon .v-icon{font-size:42px}.profile-menu-title{flex:1;font-size:clamp(22px,2.8vw,34px);line-height:1.2;font-weight:500}.profile-menu-arrow{color:#071b58;font-size:42px}
@media(max-width:650px){.worker-profile-page{min-height:calc(100vh - 64px);background-size:auto 100%}.profile-hero{min-height:148px;padding:20px 18px 25px;border-bottom-right-radius:90px 42px}.profile-brand{gap:15px}.profile-emblem{width:83px;height:83px;padding:13px}.profile-government-copy{gap:5px}.profile-government-copy strong{font-size:clamp(18px,5.7vw,28px);letter-spacing:-.3px}.profile-government-copy small{font-size:clamp(17px,5vw,25px)}.profile-logout{margin:7px 0 0 8px}.profile-logout .v-icon{font-size:39px}.profile-content{width:calc(100% - 24px);margin-top:15px}.profile-title-block{margin-bottom:25px}.profile-title-block h1{font-size:36px}.profile-title-rule{width:220px;margin-top:14px}.profile-title-rule span{width:78px}.profile-menu{gap:12px}.profile-menu-item{min-height:40px !important;padding:3px 7px !important;border-radius:17px !important}.profile-menu-icon{flex:0 0 30px !important;width:30px !important;height:30px !important;margin-right:15px;border-radius:13px}.profile-menu-icon .v-icon{font-size:25px !important}.profile-menu-title{font-size:clamp(16px,4.8vw,22px)}.profile-menu-arrow{font-size:31px}}
@media(max-width:390px){.desktop-break{display:none}.profile-government-copy strong{font-size:17px}.profile-government-copy small{font-size:15px}.profile-emblem{width:72px;height:72px}}
</style>
