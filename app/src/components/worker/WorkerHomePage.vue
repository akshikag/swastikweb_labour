<template>
  <div class="worker-home-page">
    <DashboardAppBar />

    <main class="dashboard-content">
      <div v-if="loading" class="dashboard-loader" aria-live="polite">
        <v-progress-circular indeterminate color="primary" size="50" />
      </div>

      <template v-else>
        <section class="profile-card">
          <div class="profile-summary">
            <div class="profile-avatar">
              <img
                v-if="worker.photo"
                :src="worker.photo"
                :alt="worker.name || 'Worker profile'"
                @error="worker.photo = ''"
              />
              <v-icon v-else icon="mdi-account" />
            </div>

            <div class="profile-details">
              <div class="profile-line profile-name">
                <v-icon icon="mdi-account" />
                <strong>{{ worker.name || 'Worker' }}</strong>
              </div>
              <div class="profile-line">
                <v-icon icon="mdi-phone" />
                <span>{{ worker.phone || '—' }}</span>
              </div>
              <div v-if="worker.email" class="profile-line profile-email">
                <v-icon icon="mdi-email" />
                <span>{{ worker.email }}</span>
              </div>
            </div>
          </div>

          <div class="quick-actions">
            <article class="action-card availability-card">
              <strong>{{ worker.isAvailable === 'Yes' ? 'Available' : 'Not Available' }}</strong>
              <label class="availability-switch" aria-label="Change availability">
                <input
                  type="checkbox"
                  :checked="worker.isAvailable === 'Yes'"
                  @change="toggleAvailability"
                />
                <span></span>
              </label>
            </article>

            <button class="action-card applied-card" type="button" @click="goToJobApplied">
              <v-icon icon="mdi-briefcase" />
              <strong>Work / Job<br />Applied</strong>
            </button>

            <button class="action-card chat-card" type="button" @click="goToChat">
              <v-icon icon="mdi-message" />
              <strong>Chat</strong>
            </button>
          </div>
        </section>

        <section class="worker-stats" aria-label="Worker information">
          <article class="info-card">
            <span class="info-icon info-icon--blue"><v-icon icon="mdi-map-marker" /></span>
            <div>
              <small>Location</small>
              <strong>{{ worker.location || 'Not provided' }}</strong>
            </div>
          </article>

          <article class="info-card experience-card">
            <span class="info-icon info-icon--blue"><v-icon icon="mdi-briefcase" /></span>
            <div>
              <small>Experience</small>
              <strong>{{ worker.experience || 0 }} Years</strong>
            </div>
            <span class="experience-bars" aria-hidden="true"><i></i><i></i><i></i></span>
          </article>

          <article class="info-card">
            <span class="info-icon info-icon--orange"><v-icon icon="mdi-calendar" /></span>
            <div>
              <small>Age</small>
              <strong>{{ worker.age || '—' }}</strong>
            </div>
            <v-icon class="age-watermark" icon="mdi-account" />
          </article>

          <button class="info-card schemes-card" type="button" @click="goToscheme">
            <span class="info-icon info-icon--blue"><v-icon icon="mdi-currency-inr" /></span>
            <strong>Welfare and<br />Schemes</strong>
            <span class="scheme-arrow"><v-icon icon="mdi-chevron-right" /></span>
          </button>
        </section>

        <section class="detail-panel work-history-panel">
          <h3 class="section-title">
            <span class="section-icon section-icon--orange"><v-icon icon="mdi-clipboard-text" /></span>
            Work History
          </h3>

          <div v-if="experienceHistory.length" class="history-list">
            <article v-for="(exp, index) in experienceHistory" :key="index" class="history-card">
              <dl class="history-details">
                <dt>Project Name:</dt>
                <dd>{{ exp.project_name || 'N/A' }}</dd>
                <dt>Project Duration:</dt>
                <dd>{{ formatDate(exp.start_date) }} - {{ formatDate(exp.end_date) }}</dd>
                <dt>Employer Name:</dt>
                <dd>{{ exp.employer_name || 'N/A' }}</dd>
                <dt>Descriptions:</dt>
                <dd>{{ exp.task_description || 'N/A' }}</dd>
                <template v-if="exp.skills && exp.skills.length">
                  <dt>Skills:</dt>
                  <dd class="history-skills">
                    <span v-for="(skill, skillIndex) in exp.skills" :key="skillIndex">
                      {{ skill.name }}
                    </span>
                  </dd>
                </template>
              </dl>

              <div class="history-footer">
                <div>
                  <v-icon icon="mdi-database" />
                  <span><strong>Payment:</strong>{{ exp.payment_status || 'N/A' }} (₹{{ exp.total_amount || 0 }})</span>
                </div>
                <div v-if="exp.rating">
                  <v-icon class="rating-star" icon="mdi-star" />
                  <span><strong>Rating:</strong>{{ exp.rating }}/5</span>
                </div>
              </div>
            </article>
          </div>
          <p v-else class="empty-state">No work history added yet.</p>
        </section>

        <section class="detail-panel skills-panel">
          <h3 class="section-title">
            <span class="section-icon"><v-icon icon="mdi-cog" /></span>
            Skills &amp; Specializations
          </h3>
          <div v-if="worker.skills.length" class="skill-list">
            <span v-for="skill in worker.skills" :key="skill.id || skill.name">{{ skill.name }}</span>
          </div>
          <p v-else class="empty-state">No skills added yet.</p>
        </section>
      </template>
    </main>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import api from '@/services/api.js'
import apiRoutes from '@/services/apiRoutes.js'
import dayjs from 'dayjs'
import { useRouter } from 'vue-router'
import DashboardAppBar from '@/components/header/DashboardAppBar.vue'

const router = useRouter()

const worker = ref({
  name: '',
  photo: '',
  phone: '',
  skill: '',
  rating: 0,
  reviews: 0,
  location: '',
  experience: '',
  rate: '',
  isAvailable: '',
  skills: [],
  age: '',
  gender: '',
  email: '',
})

const loading = ref(false)
const experienceHistory = ref([])

function goToJobApplied() {
  router.push('/worker-dashboard-home-job-applied')
}

async function toggleAvailability(event) {
  const previousValue = worker.value.isAvailable
  worker.value.isAvailable = event.target.checked ? 'Yes' : 'No'
  const workerData = JSON.parse(localStorage.getItem('labour_currentUser'))

  try {
    await api.put(`${apiRoutes.workerUpdate}/${workerData.worker.id}`, {
      availability: worker.value.isAvailable,
    })
  } catch (err) {
    worker.value.isAvailable = previousValue
    event.target.checked = previousValue === 'Yes'
    alert(
      'Error !!\n' +
      (Object.values(err.response?.data?.errors || {}).flat().join('\n') || 'Unable to update availability.')
    )
  }
}

async function getWorker() {
  loading.value = true
  const workerData = JSON.parse(localStorage.getItem('labour_currentUser'))

  try {
    const res = await api.get(`${apiRoutes.workerGetWorkerByid}/${workerData.worker.id}`)
    const data = res.data.worker

    worker.value = {
      name: data.profile?.name || '',
      photo: data.profile?.profile_image_url || '',
      phone: data.phone || '',
      skill: data.skill?.name || '',
      rating: data.rating || 0,
      reviews: data.reviews || 0,
      location: [data.profile?.district_detail?.district_name, data.profile?.state_detail?.state_name]
        .filter(Boolean)
        .join(', '),
      experience: data.profile?.experience || '',
      rate: data.profile?.rate || '',
      isAvailable: data.profile?.availability || '',
      skills: data.profile?.skills || [],
      age: data.profile?.age || '',
      gender: data.profile?.gender || '',
      email: data.email || '',
    }
  } catch (err) {
    alert(
      'Error !!\n' +
      (Object.values(err.response?.data?.errors || {}).flat().join('\n') || 'Unable to load worker details.')
    )
  } finally {
    loading.value = false
  }
}

async function getWorkerHistory() {
  const workerData = JSON.parse(localStorage.getItem('labour_currentUser'))

  try {
    const res = await api.get(apiRoutes.workerfetchAllWorkerJobHistory, {
      params: { worker_id: workerData.worker.id },
    })
    experienceHistory.value = res.data.data || []
  } catch (err) {
    console.error('Error fetching worker history:', err)
  }
}

onMounted(() => {
  getWorker()
  getWorkerHistory()
})

function formatDate(date) {
  return date ? dayjs(date).format('DD MMM YYYY') : 'N/A'
}

function goToscheme() {
  router.push('/worker-dashboard-home-scheme')
}

function goToChat() {
  router.push({ name: 'worker-chat' })
}

function logout() {
  localStorage.removeItem('labour_currentUser')
  localStorage.removeItem('labouchowk_userType')
  router.push('/')
}
</script>

<style scoped>
.worker-home-page {
  --dashboard-blue: #075bb8;
  --dashboard-navy: #041b49;
  min-height: 100vh;
  padding-bottom: 28px;
  color: var(--dashboard-navy);
  background: transparent;
}

.government-header {
  position: relative;
  z-index: 1;
  display: flex;
  align-items: center;
  justify-content: space-between;
  min-height: clamp(92px, 12.3vw, 116px);
  padding: max(15px, env(safe-area-inset-top)) clamp(24px, 10.8vw, 105px) 18px;
  overflow: hidden;
  border-bottom-right-radius: clamp(72px, 16vw, 150px) clamp(38px, 7vw, 68px);
  color: #fff;
  background:
    radial-gradient(circle at 58% 120%, rgb(47 153 235 / 35%), transparent 42%),
    linear-gradient(118deg, #287fd2 0%, #075dbd 48%, #00458e 100%);
  box-shadow: 0 5px 15px rgb(2 74 151 / 16%);
}

.government-header::after {
  content: '';
  position: absolute;
  top: -50px;
  right: -54px;
  width: clamp(58px, 9vw, 92px);
  height: 185px;
  transform: rotate(24deg);
  background: linear-gradient(90deg, #ff7317, #ffd4bc 58%, #fff);
}

.government-brand,
.logout-button { position: relative; z-index: 1; }
.government-brand { display: flex; align-items: center; gap: clamp(12px, 2.2vw, 22px); }
.government-emblem { display: grid; place-items: center; width: clamp(58px, 8.4vw, 80px); aspect-ratio: 1; padding: 8px; overflow: hidden; border-radius: 50%; background: #fff; box-shadow: 0 3px 9px rgb(0 45 105 / 24%); }
.government-emblem img { width: 100%; height: 100%; object-fit: contain; }
.government-copy { display: flex; flex-direction: column; line-height: 1.08; }
.government-copy strong { font-size: clamp(20px, 3.2vw, 31px); font-weight: 800; }
.government-copy small { margin-top: 6px; font-size: clamp(15px, 2.6vw, 25px); }

.logout-button { display: flex; align-items: center; gap: clamp(9px, 1.8vw, 17px); margin-right: clamp(16px, 5vw, 48px); border: 0; background: transparent; color: #fff; font: inherit; font-size: clamp(15px, 2.3vw, 22px); font-weight: 800; text-transform: uppercase; cursor: pointer; }
.logout-button .v-icon { font-size: clamp(25px, 3.5vw, 34px); }

.dashboard-content { width: min(calc(100% - 28px), 730px); margin: clamp(22px, 2.7vw, 28px) auto 0; }
.dashboard-loader { display: grid; place-items: center; min-height: 360px; }

.profile-card,
.detail-panel { border: 1px solid rgb(139 171 198 / 30%); border-radius: clamp(17px, 2.2vw, 22px); background: rgb(255 252 249 / 94%); box-shadow: 0 5px 14px rgb(8 71 123 / 18%); }
.profile-card { padding: clamp(18px, 2.2vw, 22px) clamp(14px, 3vw, 30px); }
.profile-summary { display: flex; align-items: center; min-height: clamp(145px, 19vw, 185px); padding: 0 clamp(4px, 2.2vw, 20px) clamp(14px, 2vw, 20px); }
.profile-avatar { flex: 0 0 auto; display: grid; place-items: center; width: clamp(116px, 20vw, 190px); aspect-ratio: 1; overflow: hidden; border: clamp(5px, .7vw, 7px) solid #fff; border-radius: 50%; background: #fde8dc; color: #b63e0e; box-shadow: 0 3px 11px rgb(49 74 95 / 22%); }
.profile-avatar img { width: 100%; height: 100%; object-fit: cover; }
.profile-avatar .v-icon { font-size: clamp(74px, 13vw, 122px); }
.profile-details { display: grid; gap: clamp(10px, 1.8vw, 17px); min-width: 0; margin-left: clamp(20px, 4vw, 40px); }
.profile-line { display: flex; align-items: center; gap: clamp(12px, 2vw, 20px); min-width: 0; font-size: clamp(18px, 3vw, 29px); }
.profile-line .v-icon { flex: 0 0 auto; color: #0864c5; font-size: clamp(23px, 3vw, 30px); }
.profile-line span { overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.profile-name strong { font-size: clamp(25px, 4vw, 39px); line-height: 1.15; }
.profile-email { font-size: clamp(13px, 2vw, 19px); }

.quick-actions { display: grid; grid-template-columns: repeat(3, 1fr); gap: clamp(12px, 2.8vw, 28px); }
.action-card { display: flex; min-width: 0; min-height: clamp(118px, 15vw, 145px); padding: 12px; border: 1px solid rgb(71 124 168 / 16%); border-radius: clamp(13px, 1.8vw, 18px); align-items: center; justify-content: center; flex-direction: column; color: var(--dashboard-navy); font: inherit; text-align: center; box-shadow: 0 4px 10px rgb(31 82 119 / 11%); }
button.action-card { cursor: pointer; }
.action-card .v-icon { margin-bottom: 8px; color: #075ab7; font-size: clamp(35px, 4.8vw, 47px); }
.action-card strong { font-size: clamp(15px, 2.3vw, 22px); line-height: 1.16; }
.availability-card { background: linear-gradient(135deg, #f0fff2, #f7fff6); }
.availability-card > strong { color: #147d38; }
.applied-card { background: linear-gradient(135deg, #e8f5ff, #d8edff); }
.chat-card { background: linear-gradient(135deg, #fff7f1, #ffebdf); }
.availability-switch { position: relative; display: block; width: clamp(70px, 9vw, 88px); height: clamp(36px, 4.8vw, 47px); margin-top: 10px; }
.availability-switch input { position: absolute; opacity: 0; pointer-events: none; }
.availability-switch span { position: absolute; inset: 0; border-radius: 999px; background: #aab5bf; cursor: pointer; transition: .2s ease; }
.availability-switch span::after { content: ''; position: absolute; top: 4px; left: 4px; width: calc(100% - 8px); max-width: calc(clamp(36px, 4.8vw, 47px) - 8px); aspect-ratio: 1; border-radius: 50%; background: #fff; box-shadow: 0 2px 5px rgb(0 0 0 / 24%); transition: .2s ease; }
.availability-switch input:checked + span { background: linear-gradient(90deg, #15933e, #2bb95b); }
.availability-switch input:checked + span::after { transform: translateX(calc(clamp(70px, 9vw, 88px) - clamp(36px, 4.8vw, 47px))); }

.worker-stats { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: clamp(12px, 1.7vw, 17px); margin-top: clamp(18px, 2.2vw, 22px); }
.info-card { position: relative; display: flex; align-items: center; min-width: 0; min-height: clamp(116px, 15vw, 143px); padding: clamp(14px, 2vw, 20px) clamp(16px, 2.6vw, 26px); overflow: hidden; border: 1px solid rgb(110 161 203 / 25%); border-radius: clamp(13px, 1.7vw, 17px); background: rgb(255 255 255 / 93%); color: var(--dashboard-navy); box-shadow: 0 4px 10px rgb(28 88 138 / 16%); }
button.info-card { width: 100%; font: inherit; text-align: left; cursor: pointer; }
.info-icon { z-index: 1; flex: 0 0 auto; display: grid; place-items: center; width: clamp(53px, 7.2vw, 70px); aspect-ratio: 1; margin-right: clamp(15px, 2.2vw, 22px); border-radius: 50%; }
.info-icon .v-icon { font-size: clamp(32px, 4.6vw, 45px); }
.info-icon--blue { color: #0861bd; background: #e1f0ff; }
.info-icon--orange { color: #bc1919; background: #fff0e8; }
.info-card div { min-width: 0; }
.info-card small { display: block; font-size: clamp(14px, 2.2vw, 21px); }
.info-card strong { display: block; margin-top: 4px; font-size: clamp(18px, 2.7vw, 26px); line-height: 1.25; }
.experience-bars { position: absolute; right: 22px; bottom: 25px; display: flex; align-items: end; gap: 5px; opacity: .8; }
.experience-bars i { display: block; width: clamp(8px, 1.5vw, 14px); height: 27px; border-radius: 5px; background: #c5e2ff; }
.experience-bars i:nth-child(2) { height: 42px; }
.experience-bars i:nth-child(3) { height: 57px; }
.age-watermark { position: absolute; right: 28px; bottom: 16px; color: #c5e2ff; font-size: clamp(45px, 7vw, 68px); opacity: .9; }
.schemes-card { background: linear-gradient(135deg, rgb(255 255 255 / 94%), rgb(227 243 255 / 93%)); }
.schemes-card > strong { flex: 1; color: #064192; }
.scheme-arrow { display: grid; place-items: center; width: clamp(40px, 5.5vw, 54px); aspect-ratio: 1; border-radius: 50%; background: #d8ecff; }
.scheme-arrow .v-icon { color: #064192; font-size: clamp(26px, 3.5vw, 34px); }

.detail-panel { margin-top: clamp(18px, 2.2vw, 22px); padding: clamp(14px, 2.2vw, 22px); }
.section-title { display: flex; align-items: center; gap: 15px; margin: 0 0 12px; color: #064192; font-size: clamp(20px, 3vw, 29px); line-height: 1.2; }
.section-icon { display: grid; place-items: center; width: clamp(49px, 6vw, 59px); aspect-ratio: 1; border-radius: 50%; color: #075ab7; background: #e1f0ff; }
.section-icon--orange { color: #bc1919; background: #fff0e8; }
.section-icon .v-icon { font-size: clamp(28px, 3.6vw, 36px); }
.history-card,
.skill-list { padding: clamp(17px, 2.8vw, 27px); border: 1px solid rgb(91 134 168 / 20%); border-radius: 14px; background: rgb(255 255 255 / 88%); box-shadow: 0 2px 7px rgb(33 75 108 / 8%); }
.history-card + .history-card { margin-top: 14px; }
.history-details { display: grid; grid-template-columns: minmax(138px, .75fr) 1.6fr; gap: 7px 18px; margin: 0; font-size: clamp(14px, 2vw, 20px); line-height: 1.3; }
.history-details dt { font-weight: 800; }
.history-details dd { min-width: 0; margin: 0; overflow-wrap: anywhere; }
.history-skills { display: flex; flex-wrap: wrap; gap: 7px; }
.history-skills span,
.skill-list span { display: inline-flex; padding: 6px 18px; border-radius: 999px; background: #e7e8eb; line-height: 1.2; }
.history-footer { display: grid; grid-template-columns: 1.4fr .85fr; margin-top: 17px; padding-top: 17px; border-top: 1px solid #d5d8dc; }
.history-footer > div { display: flex; align-items: center; gap: 13px; min-width: 0; }
.history-footer > div + div { padding-left: 24px; border-left: 1px solid #ccd1d7; }
.history-footer .v-icon { flex: 0 0 auto; color: #0964c4; font-size: clamp(34px, 4.8vw, 47px); }
.history-footer .rating-star { color: #b81b1b; }
.history-footer span { display: flex; flex-direction: column; font-size: clamp(13px, 1.9vw, 18px); }
.history-footer strong { color: #064192; font-size: 1.08em; }
.skills-panel { margin-bottom: 16px; }
.skill-list { display: flex; flex-wrap: wrap; gap: 9px; }
.skill-list span { font-size: clamp(13px, 1.8vw, 17px); }
.empty-state { margin: 6px 0 2px; padding: 18px; border-radius: 12px; background: rgb(255 255 255 / 80%); color: #5d6875; text-align: center; }

@media (max-width: 560px) {
  .government-header { padding-inline: 18px; }
  .government-header::after { right: -66px; }
  .logout-button { margin-right: 8px; }
  .logout-button span { display: none; }
  .dashboard-content { width: min(calc(100% - 20px), 730px); }
  .profile-card { padding-inline: 10px; }
  .profile-summary { padding-inline: 3px; }
  .profile-avatar { width: 105px; }
  .profile-details { margin-left: 16px; }
  .quick-actions { gap: 8px; }
  .action-card { min-height: 104px; padding-inline: 5px; }
  .worker-stats { gap: 9px; }
  .info-card { min-height: 104px; padding: 12px 10px; }
  .info-icon { width: 45px; margin-right: 9px; }
  .experience-bars { right: 8px; bottom: 9px; opacity: .45; }
  .age-watermark { right: 9px; bottom: 8px; opacity: .45; }
  .scheme-arrow { width: 34px; }
  .history-details { grid-template-columns: 120px 1fr; gap-inline: 10px; }
  .history-footer > div + div { padding-left: 12px; }
}

@media (max-width: 390px) {
  .government-copy strong { font-size: 17px; }
  .government-copy small { font-size: 13px; }
  .government-emblem { width: 52px; }
  .profile-avatar { width: 92px; }
  .profile-name strong { font-size: 21px; }
  .profile-line { gap: 8px; font-size: 16px; }
  .action-card strong { font-size: 13px; }
  .info-card strong { font-size: 15px; }
  .info-card small { font-size: 12px; }
  .history-details { grid-template-columns: 106px 1fr; font-size: 12px; }
}
</style>
