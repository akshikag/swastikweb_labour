<template>
  <v-app class="register-app">
    <main class="register-page">
      <img class="page-art" src="../assets/worker-login-bg.png" alt="" aria-hidden="true" />

      <section class="register-content" aria-labelledby="board-title">
        <header class="board-heading">
          <h1 id="board-title"><span>हिमाचल प्रदेश भवन एवं</span><strong>अन्य सन्निर्माण कामगार कल्याण बोर्ड</strong></h1>
          <p>कौशल से अवसर तक – निर्माण क्षेत्र का विश्वसनीय मंच</p>
        </header>

        <section class="register-panel">
          <div class="panel-icon-row" aria-hidden="true"><span></span><div><v-icon :icon="step === 1 ? 'mdi-account-plus' : 'mdi-cellphone-key'" /></div><span></span></div>

          <template v-if="step === 1">
            <h2>Worker Register / श्रमिक रजिस्टर</h2>
            <p class="panel-subtitle">Create your account to continue</p>

            <form novalidate @submit.prevent="sendOtp">
              <label class="field" :class="{ 'field--error': v$.form.name.$error }"><v-icon icon="mdi-account" /><input v-model="form.name" type="text" autocomplete="name" placeholder="Full Name *" /></label>
              <p v-if="v$.form.name.$error" class="error-text">Full name is required</p>

              <label class="field"><v-icon icon="mdi-email" /><input v-model="form.email" type="email" autocomplete="email" placeholder="Email (Optional)" /></label>
              <p v-if="v$.form.email.$error" class="error-text">{{ v$.form.email.$errors[0]?.$message }}</p>

              <label class="field" :class="{ 'field--error': v$.form.phone.$error }"><v-icon icon="mdi-phone" /><input v-model="form.phone" type="tel" inputmode="numeric" maxlength="10" autocomplete="tel" placeholder="Phone Number *" @input="form.phone = form.phone.replace(/\D/g, '').slice(0, 10)" /></label>
              <p v-if="v$.form.phone.$error" class="error-text">{{ v$.form.phone.$errors[0]?.$message }}</p>

              <label class="field" :class="{ 'field--error': v$.form.password.$error }"><v-icon icon="mdi-lock" /><input v-model="form.password" :type="showPassword ? 'text' : 'password'" autocomplete="new-password" placeholder="Password *" /><button type="button" class="password-toggle" :aria-label="showPassword ? 'Hide password' : 'Show password'" @click="showPassword = !showPassword"><v-icon :icon="showPassword ? 'mdi-eye-off' : 'mdi-eye'" /></button></label>
              <p v-if="v$.form.password.$error" class="error-text">{{ v$.form.password.$errors[0]?.$message }}</p>

              <p class="password-note"><v-icon icon="mdi-information-outline" /><span>At least 6 characters, 1 number, and 1 special character are required.<br />कम से कम 6 अक्षर, 1 संख्या और 1 विशेष चिन्ह होना चाहिए।</span></p>

              <label class="agreement"><input v-model="isAgreed" type="checkbox" /><span>I agree to the <button type="button" @click="showTerms = true">Terms &amp; Conditions</button></span></label>

              <button class="primary-button" type="submit">SEND OTP</button>
              <router-link class="login-link" to="/worker-login">Already have an account? Login</router-link>
            </form>
          </template>

          <template v-else>
            <h2>Verify OTP</h2>
            <p class="panel-subtitle">Enter the 6-digit OTP sent to {{ form.phone }}</p>
            <form @submit.prevent="verifyOtp">
              <label class="field otp-field"><v-icon icon="mdi-shield-key" /><input v-model="otp" type="tel" inputmode="numeric" maxlength="6" autocomplete="one-time-code" placeholder="Enter OTP *" @input="otp = otp.replace(/\D/g, '').slice(0, 6)" /></label>
              <button class="primary-button" type="submit">VERIFY OTP</button>
            </form>
            <button class="resend-button" type="button" :disabled="resendTimer > 0 || isResendingOtp || resendCount >= maxResendCount" @click="resendOtp">
              <template v-if="resendCount >= maxResendCount">Resend Limit Reached</template>
              <template v-else-if="resendTimer > 0">Resend OTP ({{ formattedResendTimer }})</template>
              <template v-else>Resend OTP</template>
            </button>
          </template>
        </section>

      </section>

      <v-dialog v-model="showTerms" width="600">
        <v-card><v-card-title>Terms &amp; Conditions</v-card-title><v-card-text>{{ terms || 'Terms and conditions are currently unavailable.' }}</v-card-text><v-card-actions><v-spacer /><v-btn color="primary" @click="showTerms = false">Close</v-btn></v-card-actions></v-card>
      </v-dialog>
    </main>
  </v-app>
</template>

<script>
import useVuelidate from '@vuelidate/core'
import { email, helpers, minLength, numeric, required } from '@vuelidate/validators'
import api from '@/services/api.js'
import apiRoutes from '@/services/apiRoutes.js'

export default {
  name: 'WorkerRegister',
  setup() { return { v$: useVuelidate() } },
  data() {
    return {
      terms: '', isAgreed: false, showTerms: false, showPassword: false,
      step: 1, otp: '', resendTimer: 0, resendTimerInterval: null,
      resendOtpDelay: 60, isResendingOtp: false, resendCount: 0, maxResendCount: 3,
      form: { name: '', email: '', phone: '', password: '' }
    }
  },
  computed: {
    formattedResendTimer() {
      const minutes = Math.floor(this.resendTimer / 60)
      const seconds = this.resendTimer % 60
      return `${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`
    }
  },
  validations() {
    return {
      form: {
        name: { required },
        email: { email: helpers.withMessage('Invalid email', email) },
        phone: {
          required,
          numeric: helpers.withMessage('Phone must be digits', numeric),
          minLength: helpers.withMessage('Phone must be 10 digits', minLength(10)),
          validPhone: helpers.withMessage('Enter a valid 10-digit phone number', value => /^[6-9]\d{9}$/.test(value))
        },
        password: { required, minLength: helpers.withMessage('Minimum 6 characters', minLength(6)) }
      }
    }
  },
  async mounted() { await this.getConfig() },
  beforeUnmount() { this.clearResendTimer() },
  methods: {
    async sendOtp() {
      if (!this.isAgreed) { alert('You must agree to the Terms & Conditions before submitting.'); return }
      if (!await this.v$.$validate()) return
      try {
        const response = await api.post(apiRoutes.workerSendOTP, { phone: this.form.phone })
        if (response.data.success) {
          this.resendCount = 0
          this.otp = ''
          this.step = 2
          this.startResendTimer()
        } else alert(response.data.message || 'Failed to send OTP')
      } catch (error) { alert(error.response?.data?.message || 'Unable to send OTP. Please try again.') }
    },
    async verifyOtp() {
      if (!/^\d{6}$/.test(this.otp)) { alert('Please enter a valid 6-digit OTP'); return }
      try {
        const verification = await api.post(apiRoutes.workerVerifyOTP, { phone: this.form.phone, otp: this.otp })
        if (!verification.data.success) { alert(verification.data.message || 'OTP verification failed'); return }
        const registration = await api.post(apiRoutes.workerRegister, this.form)
        localStorage.setItem('labour_currentUser', JSON.stringify(registration.data))
        localStorage.setItem('labouchowk_userType', 'worker')
        alert('Registration successful!')
        this.$router.push('/worker-dashboard-profile')
      } catch (error) {
        alert(error.response?.data?.message || Object.values(error.response?.data?.errors || {}).flat().join('\n') || 'Registration failed.')
      }
    },
    async resendOtp() {
      if (this.resendTimer > 0 || this.isResendingOtp || this.resendCount >= this.maxResendCount) return
      this.isResendingOtp = true
      try {
        const response = await api.post(apiRoutes.workerSendOTP, { phone: this.form.phone })
        if (response.data.success) {
          this.resendCount++
          if (this.resendCount < this.maxResendCount) this.startResendTimer()
        } else alert(response.data.message || 'Failed to resend OTP')
      } catch (error) { alert(error.response?.data?.message || 'Unable to resend OTP.') }
      finally { this.isResendingOtp = false }
    },
    startResendTimer() {
      this.clearResendTimer()
      this.resendTimer = this.resendOtpDelay
      this.resendTimerInterval = window.setInterval(() => {
        if (this.resendTimer > 0) this.resendTimer--
        if (this.resendTimer <= 0) this.clearResendTimer()
      }, 1000)
    },
    clearResendTimer() {
      if (this.resendTimerInterval) window.clearInterval(this.resendTimerInterval)
      this.resendTimerInterval = null
    },
    async getConfig() {
      try {
        const response = await api.get(apiRoutes.getAllConfig)
        this.terms = response.data?.data?.find(item => item.key === 'worker_agreement')?.value || ''
      } catch { this.terms = '' }
    }
  }
}
</script>

<style scoped>
.register-app { background: #fff; }
.register-page { position: relative; width: 100%; height: max(100dvh, min(177.5vw, 1672px)); min-height: 720px; overflow: hidden; background: #fff; font-family: 'Poppins', sans-serif; }
.page-art { position: absolute; inset: 0; width: 100%; height: 100%; object-fit: cover; object-position: center; pointer-events: none; }
.register-content { position: absolute; top: 20.5%; left: 50%; z-index: 2; width: min(92vw, 720px); transform: translateX(-50%); }
.board-heading { text-align: center; }
.board-heading h1 { margin: 0; font-size: clamp(22px, 5.7vw, 40px); font-weight: 800; line-height: 1.33; letter-spacing: -.045em; }
.board-heading h1 span, .board-heading h1 strong { display: block; white-space: nowrap; }
.board-heading h1 span { color: #073e85; } .board-heading h1 strong { color: #a2080c; font-weight: 800; }
.board-heading > p { margin: clamp(8px, 1.2vh, 14px) 0 clamp(15px, 2vh, 23px); color: #272727; font-size: clamp(13px, 3.4vw, 23px); font-weight: 700; white-space: nowrap; }
.board-heading ul { display: flex; justify-content: center; align-items: center; margin: clamp(7px, 1vh, 12px) 0 clamp(15px, 2vh, 23px); padding: 0; list-style: none; }
.board-heading li { display: flex; align-items: center; gap: 6px; padding: 0 clamp(13px, 3.8vw, 28px); font-size: clamp(12px, 3.2vw, 21px); font-weight: 600; white-space: nowrap; }
.board-heading li + li { border-left: 1px solid #8f8f8f; }
.board-heading li .v-icon { font-size: clamp(27px, 6.5vw, 43px); }
.board-heading li:nth-child(1) .v-icon { color: #0b4baa; } .board-heading li:nth-child(2) .v-icon { color: #16963a; } .board-heading li:nth-child(3) .v-icon { color: #ff5a0a; }
.register-panel { position: relative; min-height: clamp(510px, 62vh, 735px); padding: clamp(82px, 10.5vh, 114px) clamp(18px, 4vw, 36px) clamp(18px, 2.5vh, 30px); border: 1px solid rgb(177 204 222 / 28%); border-radius: clamp(27px, 5vw, 42px); background: rgb(255 255 255 / 92%); box-shadow: 0 5px 18px rgb(60 108 146 / 10%); text-align: center; }
.panel-icon-row { position: absolute; top: 22px; left: 50%; display: grid; grid-template-columns: clamp(60px, 16vw, 115px) auto clamp(60px, 16vw, 115px); align-items: center; gap: clamp(12px, 3vw, 23px); transform: translateX(-50%); }
.panel-icon-row > span { height: 2px; background: #ccdeeb; }
.panel-icon-row > div { display: grid; place-items: center; width: clamp(64px, 16vw, 100px); height: clamp(64px, 16vw, 100px); border-radius: 50%; background: linear-gradient(145deg, #248be6, #0862c5); color: #fff; font-size: clamp(36px, 8.5vw, 55px); }
.register-panel h2 {
  margin: 0;
  padding-inline: 4px;
  color: #071b38;
  font-size: clamp(17px, 5vw, 20px) !important;
  font-weight: 800;
  line-height: 1.5 !important;
  overflow-wrap: anywhere;
  white-space: normal !important;
}
.panel-subtitle { margin: 7px 0 clamp(15px, 2vh, 23px); color: #344154; font-size: clamp(15px, 3.7vw, 25px); }
.field { display: grid; grid-template-columns: clamp(31px, 7vw, 46px) 1fr auto; align-items: center; min-height: clamp(48px, 6.6vh, 67px); padding: 0 clamp(14px, 3vw, 22px); border: 1px solid #c6cbd0; border-radius: clamp(7px, 1.5vw, 11px); background: #fafafa; color: #697386; text-align: left; }
.field + .field, .error-text + .field { margin-top: clamp(9px, 1.2vh, 14px); }
.field--error { border-color: #c62828; }
.field .v-icon { font-size: clamp(21px, 5vw, 31px); }
.field input { width: 100%; height: 100%; border: 0; outline: 0; background: transparent; color: #20252a; font-size: clamp(15px, 3.6vw, 23px); }
.field input::placeholder { color: #858d9d; opacity: 1; }
.password-toggle { display: grid; place-items: center; border: 0; background: none; color: #697386; cursor: pointer; }
.error-text { margin: 2px 0 -5px; color: #c62828; text-align: left; font-size: 10px; }
.password-note { display: flex; gap: 8px; align-items: flex-start; margin: 8px 2px 13px; color: #526078; text-align: left; font-size: clamp(8px, 2vw, 13px); line-height: 1.3; }
.password-note .v-icon { flex: 0 0 auto; font-size: clamp(18px, 4vw, 24px); }
.agreement { display: flex; align-items: center; gap: 10px; margin: 0 2px clamp(14px, 1.8vh, 20px); text-align: left; font-size: clamp(12px, 3vw, 19px); }
.agreement input { width: clamp(19px, 4.5vw, 27px); height: clamp(19px, 4.5vw, 27px); accent-color: #1575d1; }
.agreement button { padding: 0; border: 0; background: none; color: #0874d7; text-decoration: underline; cursor: pointer; }
.primary-button { width: 100%; min-height: clamp(48px, 6.5vh, 65px); border: 0; border-radius: clamp(7px, 1.5vw, 11px); background: linear-gradient(100deg, #1379da, #1485e5); color: #fff; font-size: clamp(17px, 4.2vw, 28px); font-weight: 600; letter-spacing: .11em; box-shadow: 0 6px 12px rgb(0 85 177 / 20%); cursor: pointer; }
.login-link, .resend-button { display: inline-block; margin-top: clamp(13px, 1.8vh, 20px); border: 0; background: none; color: #6511c4; font-size: clamp(13px, 3.3vw, 21px); text-decoration: underline; cursor: pointer; }
.resend-button:disabled { color: #777; cursor: default; }
.otp-field { margin-top: 30px; }
.otp-field + .primary-button { margin-top: clamp(14px, 2vh, 20px); }
.pledge { margin-top: clamp(25px, 3.2vh, 40px); color: #07509e; text-align: center; font-size: clamp(15px, 3.8vw, 25px); font-weight: 800; line-height: 1.25; }
.pledge span { display: block; width: 40px; height: 2px; margin: 8px auto 0; background: #ff7900; }
@media (max-width: 374px) { .register-content { width: 95vw; } .board-heading h1 { font-size: 18px; } .board-heading > p { font-size: 10.5px; } .board-heading li { padding-inline: 8px; } .register-panel { padding-inline: 14px; } .register-panel h2 { font-size: 17px !important; } }
@media (max-height: 740px) { .register-content { top: 20.5%; } .board-heading h1 { font-size: 18px; line-height: 1.22; } .board-heading > p { margin-top: 4px; font-size: 10.5px; } .board-heading ul { margin-block: 4px 9px; } .register-panel { min-height: 500px; padding-top: 66px; } .panel-icon-row { top: 11px; } .panel-icon-row > div { width: 51px; height: 51px; font-size: 29px; } .panel-subtitle { margin-block: 4px 11px; } .field { min-height: 43px; } .field + .field, .error-text + .field { margin-top: 7px; } .password-note { margin-block: 5px 8px; } .agreement { margin-bottom: 10px; } .primary-button { min-height: 42px; } .login-link { margin-top: 9px; } .pledge { margin-top: 15px; } }
@media (min-width: 700px) { .register-content { width: min(73vw, 720px); } }
</style>
