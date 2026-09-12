<template>
  <v-app class="employer-login-app">
    <main class="employer-login-page">
      <img class="page-art" src="../assets/worker-login-bg.png" alt="" aria-hidden="true" />

      <section class="login-content" aria-labelledby="board-title">
        <header class="board-heading">
          <h1 id="board-title">
            <span>हिमाचल प्रदेश भवन एवं</span>
            <strong>अन्य सन्निर्माण कामगार कल्याण बोर्ड</strong>
          </h1>
          <p>कौशल से अवसर तक – निर्माण क्षेत्र का विश्वसनीय मंच</p>

          <ul class="trust-list" aria-label="Platform features">
            <li><v-icon icon="mdi-shield-check-outline" /><span>सत्यापित</span></li>
            <li><v-icon icon="mdi-clock-outline" /><span>निर्माण क्षेत्र का<br />विश्वसनीय मंच</span></li>
            <li><v-icon icon="mdi-handshake-outline" /><span>विश्वसनीय</span></li>
          </ul>
        </header>

        <section class="login-panel" aria-labelledby="login-title">
          <div class="employer-icon"><v-icon icon="mdi-account-hard-hat" /></div>
          <h2 id="login-title">Employer Login / एम्प्लॉयर लॉगिन</h2>
          <span class="title-accent" aria-hidden="true"></span>

          <form novalidate @submit.prevent="login">
            <label class="input-field" :class="{ 'input-field--error': v$.mobile.$error }">
              <v-icon icon="mdi-cellphone" />
              <input
                v-model="mobile"
                type="tel"
                inputmode="numeric"
                autocomplete="tel"
                maxlength="10"
                placeholder="Mobile Number / मोबाइल नंबर *"
                aria-label="Mobile Number"
                @input="mobile = mobile.replace(/\D/g, '').slice(0, 10)"
              />
            </label>
            <p v-if="mobileErrors.length" class="field-error">{{ mobileErrors[0] }}</p>

            <label class="input-field password-field" :class="{ 'input-field--error': v$.password.$error }">
              <v-icon icon="mdi-lock" />
              <input
                v-model="password"
                :type="showPassword ? 'text' : 'password'"
                autocomplete="current-password"
                placeholder="Password / पासवर्ड *"
                aria-label="Password"
              />
              <button type="button" class="password-toggle" :aria-label="showPassword ? 'Hide password' : 'Show password'" @click="showPassword = !showPassword">
                <v-icon :icon="showPassword ? 'mdi-eye-outline' : 'mdi-eye-off-outline'" />
              </button>
            </label>
            <p v-if="passwordErrors.length" class="field-error">{{ passwordErrors[0] }}</p>

            <p class="password-note">
              <span>At least 6 characters, 1 number, and 1 special character are required.</span>
              <span>कम से कम 6 अक्षर, 1 संख्या और 1 विशेष चिन्ह होना चाहिए।</span>
            </p>

            <button class="login-button" type="submit" :disabled="isSubmitting">
              {{ isSubmitting ? 'कृपया प्रतीक्षा करें…' : 'LOGIN / लॉगिन' }}
            </button>
          </form>

          <nav class="login-links" aria-label="Employer account links">
            <router-link to="/employer-forgot-password">
              <v-icon icon="mdi-lock-question" />
              <span>Forgot Password /<br />पासवर्ड भूल गए</span>
            </router-link>
            <i aria-hidden="true"></i>
            <router-link to="/employer-register">
              <v-icon icon="mdi-account-plus" />
              <span>Employer Register /<br />एम्प्लॉयर रजिस्टर</span>
            </router-link>
          </nav>
        </section>

        <p class="page-pledge">श्रमिक सशक्त&nbsp; | &nbsp;निर्माण समृद्ध&nbsp; | &nbsp;हिमाचल प्रगतिशील</p>
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
const mobile = ref('')
const password = ref('')
const showPassword = ref(false)
const isSubmitting = ref(false)

const rules = {
  mobile: {
    required: helpers.withMessage('Mobile number is required', required),
    numeric: helpers.withMessage('Enter numbers only', numeric),
    minLength: helpers.withMessage('Mobile number must be 10 digits', minLength(10)),
    mobileFormat: helpers.withMessage('Enter a valid 10-digit mobile number', value => /^[6-9]\d{9}$/.test(value))
  },
  password: {
    required: helpers.withMessage('Password is required', required),
    minLength: helpers.withMessage('Minimum 6 characters required', minLength(6))
  }
}

const v$ = useVuelidate(rules, { mobile, password })
const mobileErrors = computed(() => v$.value.mobile.$errors.map(error => error.$message))
const passwordErrors = computed(() => v$.value.password.$errors.map(error => error.$message))

async function login() {
  v$.value.$touch()
  if (v$.value.$invalid || isSubmitting.value) return

  isSubmitting.value = true
  try {
    const response = await api.post(apiRoutes.employerLogin, {
      phone: mobile.value,
      password: password.value
    })

    localStorage.setItem('labour_currentUser', JSON.stringify(response.data))
    localStorage.setItem('labouchowk_userType', 'employer')
    router.push('/employer-dashboard-home')
  } catch (error) {
    const data = error.response?.data
    const validationErrors = Object.values(data?.errors || {}).flat()
    alert(validationErrors.join('\n') || data?.message || 'Unable to login. Please try again.')
  } finally {
    isSubmitting.value = false
  }
}

</script>

<style scoped>
.employer-login-app { background: #fff; }

.employer-login-page {
  position: relative;
  width: 100%;
  height: max(100dvh, min(177.5vw, 1672px));
  min-height: 650px;
  overflow: hidden;
  background: #fff;
  color: #151515;
  font-family: 'Poppins', sans-serif;
}

.page-art {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
  object-position: center;
  pointer-events: none;
  user-select: none;
}

.login-content {
  position: absolute;
  top: 25.2%;
  left: 50%;
  z-index: 2;
  width: min(92vw, 820px);
  transform: translateX(-50%);
}

.board-heading { text-align: center; }
.board-heading h1 { margin: 0; font-size: clamp(23px, 5vw, 42px); font-weight: 800; line-height: 1.34; letter-spacing: -.045em; }
.board-heading h1 span,
.board-heading h1 strong { display: block; white-space: nowrap; }
.board-heading h1 span { color: #0a4c96; }
.board-heading h1 strong { color: #aa090d; font-weight: 800; }
.board-heading > p { margin: clamp(10px, 1.6vh, 18px) 0 0; color: #252b35; font-size: clamp(14px, 3vw, 24px); font-weight: 700; white-space: nowrap; }

.trust-list { display: flex; justify-content: center; align-items: center; margin: clamp(10px, 1.5vh, 17px) 0 clamp(17px, 2.5vh, 28px); padding: 0; list-style: none; }
.trust-list li { display: flex; align-items: center; gap: clamp(5px, 1.25vw, 10px); padding: 0 clamp(12px, 3.5vw, 29px); font-size: clamp(13px, 2.8vw, 22px); font-weight: 600; line-height: 1.14; white-space: nowrap; }
.trust-list li + li { border-left: 1px solid #8f8f8f; }
.trust-list .v-icon { font-size: clamp(28px, 6vw, 45px); }
.trust-list li:nth-child(1) .v-icon { color: #0b4baa; }
.trust-list li:nth-child(2) .v-icon { color: #16963a; }
.trust-list li:nth-child(3) .v-icon { color: #ff5a0a; }

.login-panel {
  position: relative;
  min-height: clamp(410px, 51vh, 610px);
  padding: clamp(71px, 9.5vh, 104px) clamp(25px, 5.5vw, 45px) clamp(22px, 3vh, 34px);
  border: 1px solid rgb(177 204 222 / 35%);
  border-radius: clamp(28px, 6vw, 45px);
  background: rgb(255 255 255 / 92%);
  box-shadow: 0 8px 24px rgb(60 108 146 / 14%);
}

.employer-icon { position: absolute; top: 0; left: 50%; display: grid; place-items: center; width: clamp(68px, 17vw, 108px); height: clamp(68px, 17vw, 108px); border-radius: 50%; background: linear-gradient(145deg, #1856a8, #073c86); color: #fff; transform: translate(-50%, 8%); box-shadow: 0 3px 8px rgb(4 60 130 / 15%); }
.employer-icon .v-icon { font-size: clamp(36px, 9vw, 59px); }
.login-panel h2 { margin: 0 !important; text-align: center; font-size: clamp(24px, 5vw, 40px) !important; font-weight: 800; line-height: 1.15 !important; white-space: nowrap; }
.title-accent { display: block; width: 106px; height: 5px; margin: 13px auto clamp(22px, 3vh, 34px); border-radius: 5px; background: #fb665c; }

.input-field { display: grid; grid-template-columns: clamp(30px, 7vw, 46px) 1fr auto; align-items: center; min-height: clamp(58px, 8.4vh, 84px); padding: 0 clamp(14px, 3.4vw, 24px); border: 2px solid #bfc4c5; border-radius: clamp(7px, 1.5vw, 11px); background: linear-gradient(90deg, #fff 0 13%, #edf6ff 13% 94%, #fff 94%); color: #b42e28; box-shadow: inset 0 1px 2px rgb(0 0 0 / 3%); }
.input-field + .input-field,
.field-error + .input-field { margin-top: clamp(14px, 2vh, 22px); }
.input-field--error { border-color: #c62828; }
.input-field .v-icon { font-size: clamp(22px, 5.5vw, 34px); }
.input-field input { width: 100%; height: 100%; border: 0; outline: 0; background: transparent; color: #15191f; font-family: 'Poppins', sans-serif; font-size: clamp(15px, 3.8vw, 25px); font-weight: 500; }
.input-field input::placeholder { color: #99a1ad; opacity: 1; }
.password-toggle { display: grid; place-items: center; border: 0; background: transparent; color: #6f7480; cursor: pointer; }
.field-error { margin: 3px 0 -6px; color: #c62828; font-size: clamp(9px, 2.2vw, 12px); }
.password-note { display: flex; flex-direction: column; margin: clamp(5px, .8vh, 9px) 4px clamp(14px, 2vh, 22px); color: #5e6878; font-size: clamp(9px, 2.2vw, 14px); line-height: 1.35; }

.login-button { width: 100%; min-height: clamp(49px, 6.8vh, 67px); border: 0; border-radius: clamp(7px, 1.5vw, 11px); background: linear-gradient(180deg, #176cd2, #0d4fa4); color: #fff; font-size: clamp(17px, 4vw, 28px); font-weight: 600; cursor: pointer; box-shadow: 0 4px 10px rgb(0 55 130 / 20%); }
.login-button:disabled { opacity: .65; cursor: wait; }

.login-links { display: grid; grid-template-columns: 1fr 1px 1fr; align-items: center; gap: clamp(10px, 2.4vw, 18px); margin-top: clamp(24px, 3vh, 34px); padding-top: clamp(18px, 2.5vh, 28px); border-top: 1px solid #d5dbe4; }
.login-links i { width: 1px; height: 48px; background: #8c8c8c; }
.login-links a { display: flex; align-items: center; justify-content: center; gap: 9px; color: #0756b2; font-size: clamp(9px, 2vw, 15px); font-weight: 500; line-height: 1.25; }
.login-links .v-icon { flex: 0 0 auto; font-size: clamp(24px, 5vw, 36px); }
.page-pledge { margin: clamp(38px, 5vh, 60px) auto 0; color: #0753a9; font-size: clamp(12px, 2.4vw, 19px); font-weight: 700; text-align: center; white-space: nowrap; }

@media (max-width: 480px) {
  .login-content { width: 94vw; }
  .board-heading h1 { font-size: 20px; }
  .board-heading > p { font-size: 12px; }
  .trust-list li { padding-inline: 8px; font-size: 12px; }
  .login-panel { padding-inline: 18px; }
  .login-panel h2 { font-size: 21px !important; }
  .login-links { gap: 5px; }
  .login-links a { gap: 4px; font-size: 8px; }
  .page-pledge { font-size: 10px; }
}

@media (max-height: 740px) {
  .login-content { top: 23.7%; }
  .board-heading h1 { font-size: clamp(19px, 5.2vw, 23px); line-height: 1.24; }
  .board-heading > p { margin-top: 6px; }
  .trust-list { margin-block: 5px 12px; }
  .login-panel { min-height: 390px; padding-top: 62px; }
  .employer-icon { width: 58px; height: 58px; }
  .employer-icon .v-icon { font-size: 32px; }
  .title-accent { margin-block: 6px 15px; }
  .input-field { min-height: 48px; }
  .input-field + .input-field, .field-error + .input-field { margin-top: 10px; }
  .password-note { margin-block: 4px 10px; }
  .login-button { min-height: 42px; }
  .login-links { margin-top: 20px; padding-top: 14px; }
  .page-pledge { margin-top: 24px; }
}

@media (min-width: 700px) { .login-content { width: min(84vw, 820px); } }
</style>
