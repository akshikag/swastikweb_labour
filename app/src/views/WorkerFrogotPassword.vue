<template>
  <v-app class="forgot-app">
    <main class="forgot-page">
      <img class="page-art" src="../assets/worker-login-bg.png" alt="" aria-hidden="true" />

      <section class="forgot-content" aria-labelledby="board-title">
        <header class="board-heading">
          <h1 id="board-title"><span>हिमाचल प्रदेश भवन एवं</span><strong>अन्य सन्निर्माण कामगार कल्याण बोर्ड</strong></h1>
          <p>कौशल से अवसर तक – निर्माण क्षेत्र का विश्वसनीय मंच</p>
          <ul aria-label="Platform features">
            <li><v-icon icon="mdi-shield-check-outline" /><span>सत्यापित</span></li>
            <li><v-icon icon="mdi-clock-outline" /><span>त्वरित</span></li>
            <li><v-icon icon="mdi-handshake-outline" /><span>विश्वसनीय</span></li>
          </ul>
        </header>

        <section class="forgot-panel">
          <div class="panel-icon-row" aria-hidden="true"><span></span><div><v-icon :icon="step === 1 ? 'mdi-lock-reset' : step === 2 ? 'mdi-cellphone-key' : 'mdi-lock-check'" /></div><span></span></div>

          <template v-if="step === 1">
            <h2>Forgot Password</h2>
            <p class="panel-subtitle">Enter your registered mobile number to receive OTP</p>
            <form @submit.prevent="sendOtp">
              <label class="field" :class="{ 'field--error': v$.mobile.$error }">
                <input v-model="mobile" type="tel" inputmode="numeric" maxlength="10" autocomplete="tel" placeholder="Mobile Number *" @input="mobile = mobile.replace(/\D/g, '').slice(0, 10)" />
              </label>
              <p v-if="mobileErrors.length" class="error-text">{{ mobileErrors[0] }}</p>
              <button class="primary-button" type="submit">SEND OTP</button>
            </form>
            <router-link class="back-login" to="/worker-login">Back to Login</router-link>
          </template>

          <template v-else-if="step === 2">
            <h2>Verify OTP</h2>
            <p class="panel-subtitle">Enter the 6-digit OTP sent to {{ mobile }}</p>
            <form @submit.prevent="verifyOtp">
              <label class="field" :class="{ 'field--error': v$.otp.$error }">
                <input v-model="otp" type="tel" inputmode="numeric" maxlength="6" autocomplete="one-time-code" placeholder="Enter OTP *" @input="otp = otp.replace(/\D/g, '').slice(0, 6)" />
              </label>
              <p v-if="otpErrors.length" class="error-text">{{ otpErrors[0] }}</p>
              <button class="primary-button" type="submit">VERIFY OTP</button>
            </form>
            <button class="text-button" type="button" @click="resendOtp">Resend OTP</button>
          </template>

          <template v-else>
            <h2>Change Password</h2>
            <p class="panel-subtitle">Create a secure new password</p>
            <form @submit.prevent="changePassword">
              <label class="field" :class="{ 'field--error': v$.newPassword.$error }"><input v-model="newPassword" type="password" autocomplete="new-password" placeholder="New Password *" /></label>
              <p v-if="newPasswordErrors.length" class="error-text">{{ newPasswordErrors[0] }}</p>
              <label class="field second-field" :class="{ 'field--error': v$.confirmPassword.$error }"><input v-model="confirmPassword" type="password" autocomplete="new-password" placeholder="Confirm Password *" /></label>
              <p v-if="confirmPasswordErrors.length" class="error-text">{{ confirmPasswordErrors[0] }}</p>
              <button class="primary-button" type="submit">CHANGE PASSWORD</button>
            </form>
          </template>
        </section>

        <div class="pledge">श्रमिक का सम्मान<br />हमारा संकल्प<span></span></div>
      </section>
    </main>
  </v-app>
</template>

<script setup>
import { computed, ref } from 'vue'
import { useRouter } from 'vue-router'
import useVuelidate from '@vuelidate/core'
import { helpers, minLength, numeric, required } from '@vuelidate/validators'
import api from '@/services/api.js'
import apiRoutes from '@/services/apiRoutes.js'

const router = useRouter()
const step = ref(1)
const mobile = ref('')
const otp = ref('')
const newPassword = ref('')
const confirmPassword = ref('')

const rules = {
  mobile: { required, numeric, minLength: minLength(10), mobileFormat: helpers.withMessage('Invalid mobile number', value => /^[6-9]\d{9}$/.test(value)) },
  otp: { required, minLength: minLength(6) },
  newPassword: { required, minLength: minLength(6) },
  confirmPassword: { required, sameAsPassword: helpers.withMessage('Passwords do not match', value => value === newPassword.value) }
}

const v$ = useVuelidate(rules, { mobile, otp, newPassword, confirmPassword })
const mobileErrors = computed(() => v$.value.mobile.$errors.map(error => error.$message))
const otpErrors = computed(() => v$.value.otp.$errors.map(error => error.$message))
const newPasswordErrors = computed(() => v$.value.newPassword.$errors.map(error => error.$message))
const confirmPasswordErrors = computed(() => v$.value.confirmPassword.$errors.map(error => error.$message))

async function sendOtp() {
  v$.value.mobile.$touch()
  if (v$.value.mobile.$invalid) return
  try {
    const response = await api.post(apiRoutes.workerSendOTP, { phone: mobile.value })
    if (response.data.success) step.value = 2
    else alert(response.data.message || 'Failed to send OTP')
  } catch (error) { alert(error.response?.data?.message || 'Unable to send OTP. Please try again.') }
}

async function verifyOtp() {
  v$.value.otp.$touch()
  if (v$.value.otp.$invalid) return
  try {
    const response = await api.post(apiRoutes.workerVerifyOTP, { phone: mobile.value, otp: otp.value })
    if (response.data.success) step.value = 3
    else alert(response.data.message || 'Invalid OTP')
  } catch (error) { alert(error.response?.data?.message || 'OTP verification failed') }
}

async function resendOtp() {
  try {
    const response = await api.post(apiRoutes.workerSendOTP, { phone: mobile.value })
    alert(response.data.success ? `OTP resent to ${mobile.value}.` : response.data.message || 'Failed to resend OTP')
  } catch (error) { alert(error.response?.data?.message || 'Unable to resend OTP. Please try again.') }
}

async function changePassword() {
  v$.value.newPassword.$touch()
  v$.value.confirmPassword.$touch()
  if (v$.value.newPassword.$invalid || v$.value.confirmPassword.$invalid) return
  try {
    await api.post(apiRoutes.workerForgotPassword, { phone: mobile.value, password: newPassword.value })
    alert('Password changed successfully!')
    router.push('/worker-login')
  } catch (error) {
    alert(error.response?.data?.message || Object.values(error.response?.data?.errors || {}).flat().join('\n') || 'Unable to change password.')
  }
}
</script>

<style scoped>
.forgot-app { background: #fff; }
.forgot-page { position: relative; width: 100%; height: max(100dvh, min(177.5vw, 1672px)); min-height: 650px; overflow: hidden; background: #fff; font-family: 'Poppins', sans-serif; }
.page-art { position: absolute; inset: 0; width: 100%; height: 100%; object-fit: cover; object-position: center; pointer-events: none; }
.forgot-content { position: absolute; top: 22.7%; left: 50%; z-index: 2; width: min(93vw, 720px); transform: translateX(-50%); }
.board-heading { text-align: center; }
.board-heading h1 { margin: 0; font-size: clamp(23px, 6vw, 42px); font-weight: 800; line-height: 1.34; letter-spacing: -.045em; }
.board-heading h1 span, .board-heading h1 strong { display: block; white-space: nowrap; }
.board-heading h1 span { color: #073e85; }
.board-heading h1 strong { color: #a2080c; font-weight: 800; }
.board-heading > p { margin: clamp(12px, 1.8vh, 20px) 0 0; color: #272727; font-size: clamp(14px, 3.7vw, 25px); font-weight: 700; white-space: nowrap; }
.board-heading ul { display: flex; justify-content: center; align-items: center; margin: clamp(9px, 1.4vh, 16px) 0 clamp(18px, 2.5vh, 28px); padding: 0; list-style: none; }
.board-heading li { display: flex; align-items: center; gap: 6px; padding: 0 clamp(14px, 4vw, 30px); font-size: clamp(13px, 3.5vw, 23px); font-weight: 600; white-space: nowrap; }
.board-heading li + li { border-left: 1px solid #8f8f8f; }
.board-heading li .v-icon { font-size: clamp(28px, 7vw, 45px); }
.board-heading li:nth-child(1) .v-icon { color: #0b4baa; } .board-heading li:nth-child(2) .v-icon { color: #16963a; } .board-heading li:nth-child(3) .v-icon { color: #ff5a0a; }
.forgot-panel { position: relative; min-height: clamp(350px, 43vh, 510px); padding: clamp(91px, 12vh, 125px) clamp(25px, 5vw, 44px) clamp(25px, 3.5vh, 40px); border: 1px solid rgb(177 204 222 / 30%); border-radius: clamp(26px, 5vw, 40px); background: rgb(255 255 255 / 91%); box-shadow: 0 5px 18px rgb(60 108 146 / 10%); text-align: center; }
.panel-icon-row { position: absolute; top: 25px; left: 50%; display: grid; grid-template-columns: clamp(62px, 17vw, 120px) auto clamp(62px, 17vw, 120px); align-items: center; gap: clamp(12px, 3vw, 24px); transform: translateX(-50%); }
.panel-icon-row > span { height: 2px; background: #ccdeeb; }
.panel-icon-row > div { display: grid; place-items: center; width: clamp(68px, 17vw, 105px); height: clamp(68px, 17vw, 105px); border-radius: 50%; background: linear-gradient(145deg, #248be6, #0862c5); color: #fff; font-size: clamp(38px, 9vw, 58px); }
.forgot-panel h2 { margin: 0; color: #071b38; font-size: clamp(27px, 6.5vw, 44px); font-weight: 800; line-height: 1.15; }
.panel-subtitle { margin: clamp(9px, 1.3vh, 14px) 0 clamp(22px, 3vh, 34px); color: #24344f; font-size: clamp(14px, 3.7vw, 24px); line-height: 1.35; }
.field { display: flex; align-items: center; min-height: clamp(60px, 8.4vh, 84px); padding: 0 clamp(18px, 4vw, 30px); border: 0; border-bottom: 1px solid #666; border-radius: clamp(8px, 2vw, 15px); background: #f7f7f8; }
.field--error { border-color: #c62828; }
.field input { width: 100%; height: 100%; border: 0; outline: 0; background: transparent; color: #222; font-size: clamp(17px, 4.3vw, 28px); }
.field input::placeholder { color: #85878c; opacity: 1; }
.second-field { margin-top: 13px; }
.error-text { margin: 3px 0 -5px; color: #c62828; text-align: left; font-size: 11px; }
.primary-button { width: 100%; min-height: clamp(55px, 7.3vh, 73px); margin-top: clamp(22px, 3vh, 34px); border: 0; border-radius: clamp(7px, 1.7vw, 12px); background: linear-gradient(100deg, #1379da, #1485e5); color: #fff; font-size: clamp(19px, 4.8vw, 32px); font-weight: 500; letter-spacing: .18em; box-shadow: 0 6px 12px rgb(0 85 177 / 20%); cursor: pointer; }
.back-login, .text-button { display: inline-block; margin-top: clamp(22px, 3vh, 34px); border: 0; background: none; color: #6511c4; font-size: clamp(17px, 4.2vw, 28px); text-decoration: underline; cursor: pointer; }
.pledge { margin-top: clamp(34px, 4.5vh, 52px); color: #07509e; text-align: center; font-size: clamp(16px, 4vw, 26px); font-weight: 800; line-height: 1.25; }
.pledge span { display: block; width: 40px; height: 2px; margin: 8px auto 0; background: #ff7900; }
@media (max-width: 374px) { .forgot-content { width: 95vw; } .board-heading h1 { font-size: 19px; } .board-heading > p { font-size: 11px; } .board-heading li { padding-inline: 9px; } .forgot-panel { padding-inline: 18px; } }
@media (max-height: 680px) { .forgot-content { top: 21.5%; } .board-heading h1 { font-size: 19px; line-height: 1.23; } .board-heading > p { margin-top: 5px; font-size: 11px; } .board-heading ul { margin-block: 5px 11px; } .forgot-panel { min-height: 330px; padding-top: 74px; } .panel-icon-row { top: 16px; } .panel-icon-row > div { width: 58px; height: 58px; font-size: 32px; } .panel-subtitle { margin-block: 6px 15px; } .field { min-height: 49px; } .primary-button { min-height: 45px; margin-top: 16px; } .back-login, .text-button { margin-top: 16px; } .pledge { margin-top: 20px; } }
@media (min-width: 700px) { .forgot-content { width: min(73vw, 720px); } }
</style>
