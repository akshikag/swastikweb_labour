<template>
  <v-app class="worker-login-app">
    <main class="worker-login-page">
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
            <li><v-icon icon="mdi-clock-outline" /><span>त्वरित</span></li>
            <li><v-icon icon="mdi-handshake-outline" /><span>विश्वसनीय</span></li>
          </ul>
        </header>

        <section class="login-panel" aria-labelledby="login-title">
          <div class="worker-icon"><v-icon icon="mdi-account-hard-hat" /></div>
          <h2 id="login-title">Worker Login /श्रमिक लॉगिन</h2>
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
              {{ isSubmitting ? 'कृपया प्रतीक्षा करें…' : 'LOGIN/लॉगिन' }}
            </button>
          </form>

          <nav class="login-links" aria-label="Worker account links">
            <router-link to="/worker-forgot-password"><v-icon icon="mdi-lock-question" /><span>Forgot Password/पासवर्ड भूल गए</span></router-link>
            <i aria-hidden="true"></i>
            <router-link to="/worker-register"><v-icon icon="mdi-account-plus-outline" /><span>Worker Register/श्रमिक रजिस्टर</span></router-link>
          </nav>
        </section>
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
    const response = await api.post(apiRoutes.workerLogin, {
      phone: mobile.value,
      password: password.value
    })

    localStorage.setItem('labour_currentUser', JSON.stringify(response.data))
    localStorage.setItem('labouchowk_userType', 'worker')
    router.push('/worker-dashboard-home')
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
.worker-login-app { background: #fff; }

.worker-login-page {
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
  width: min(91vw, 720px);
  transform: translateX(-50%);
}

.board-heading { text-align: center; }
.board-heading h1 {
  margin: 0;
  font-size: clamp(23px, 6vw, 42px);
  font-weight: 800;
  line-height: 1.34;
  letter-spacing: -0.045em;
}
.board-heading h1 span,
.board-heading h1 strong { display: block; white-space: nowrap; }
.board-heading h1 span { color: #073e85; }
.board-heading h1 strong { color: #a2080c; font-weight: 800; }
.board-heading > p {
  margin: clamp(14px, 2vh, 22px) 0 0;
  color: #272727;
  font-size: clamp(14px, 3.7vw, 25px);
  font-weight: 700;
  white-space: nowrap;
}

.trust-list {
  display: flex;
  justify-content: center;
  align-items: center;
  margin: clamp(10px, 1.5vh, 17px) 0 clamp(17px, 2.5vh, 28px);
  padding: 0;
  list-style: none;
}
.trust-list li {
  display: flex;
  align-items: center;
  gap: clamp(5px, 1.25vw, 10px);
  padding: 0 clamp(14px, 4vw, 30px);
  font-size: clamp(13px, 3.5vw, 23px);
  font-weight: 600;
  white-space: nowrap;
}
.trust-list li + li { border-left: 1px solid #8f8f8f; }
.trust-list .v-icon { font-size: clamp(28px, 7vw, 45px); }
.trust-list li:nth-child(1) .v-icon { color: #0b4baa; }
.trust-list li:nth-child(2) .v-icon { color: #16963a; }
.trust-list li:nth-child(3) .v-icon { color: #ff5a0a; }

.login-panel {
  position: relative;
  min-height: clamp(410px, 51vh, 610px);
  padding: clamp(71px, 9.5vh, 104px) clamp(25px, 5.5vw, 45px) clamp(15px, 2vh, 24px);
  border: 1px solid rgb(177 204 222 / 24%);
  border-radius: clamp(28px, 6vw, 45px) clamp(28px, 6vw, 45px) 0 0;
  background: linear-gradient(180deg, rgb(255 255 255 / 94%), rgb(255 255 255 / 85%) 77%, rgb(255 255 255 / 28%));
  box-shadow: 0 5px 18px rgb(60 108 146 / 9%);
}

.worker-icon {
  position: absolute;
  top: 0;
  left: 50%;
  display: grid;
  place-items: center;
  width: clamp(68px, 17vw, 108px);
  height: clamp(68px, 17vw, 108px);
  border-radius: 50%;
  background: linear-gradient(145deg, #1856a8, #073c86);
  color: #fff;
  font-size: clamp(36px, 9vw, 59px);
  transform: translate(-50%, 8%);
  box-shadow: 0 3px 8px rgb(4 60 130 / 15%);
}

.login-panel h2 {
  margin: 0;
  text-align: center;
  font-size: clamp(24px, 6vw, 41px);
  font-weight: 800;
  line-height: 1.15;
  white-space: nowrap;
}
.title-accent { display: block; width: 52px; height: 3px; margin: 9px auto clamp(22px, 3vh, 34px); background: #fb665c; }

.input-field {
  display: grid;
  grid-template-columns: clamp(30px, 7vw, 46px) 1fr auto;
  align-items: center;
  min-height: clamp(58px, 8.4vh, 84px);
  padding: 0 clamp(14px, 3.4vw, 24px);
  border: 1px solid #bfc4c5;
  border-radius: clamp(7px, 1.5vw, 11px);
  background: rgb(255 255 255 / 91%);
  color: #a5352d;
  box-shadow: inset 0 1px 2px rgb(0 0 0 / 3%);
}
.input-field + .input-field,
.field-error + .input-field { margin-top: clamp(14px, 2vh, 22px); }
.input-field--error { border-color: #c62828; }
.input-field .v-icon { font-size: clamp(22px, 5.5vw, 34px); }
.input-field input {
  width: 100%;
  height: 100%;
  border: 0;
  outline: 0;
  background: transparent;
  color: #25282c;
  font-family: 'Poppins', sans-serif;
  font-size: clamp(15px, 3.8vw, 25px);
  font-weight: 500;
}
.input-field input::placeholder { color: #aeb2b4; opacity: 1; }
.password-toggle { display: grid; place-items: center; border: 0; background: transparent; color: #8b8d8e; cursor: pointer; }
.field-error { margin: 3px 0 -6px; color: #c62828; font-size: clamp(9px, 2.2vw, 12px); }

.password-note {
  display: flex;
  flex-direction: column;
  margin: clamp(5px, 0.8vh, 9px) 4px clamp(14px, 2vh, 22px);
  color: #565656;
  font-size: clamp(9px, 2.35vw, 14px);
  line-height: 1.35;
}

.login-button {
  width: 100%;
  min-height: clamp(49px, 6.8vh, 67px);
  border: 0;
  border-radius: clamp(6px, 1.3vw, 9px);
  background: linear-gradient(180deg, #245daf, #154b9b);
  color: #fff;
  font-size: clamp(17px, 4.3vw, 28px);
  font-weight: 500;
  cursor: pointer;
  box-shadow: 0 3px 7px rgb(0 55 130 / 15%);
}
.login-button:disabled { opacity: 0.65; cursor: wait; }

.login-links {
  display: grid;
  grid-template-columns: 1fr 1px 1fr;
  align-items: center;
  gap: clamp(10px, 2.4vw, 18px);
  margin-top: clamp(56px, 8vh, 90px);
}
.login-links i { width: 1px; height: 24px; background: #8c8c8c; }
.login-links a {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 5px;
  color: #0647a0;
  font-size: clamp(8px, 2.15vw, 14px);
  font-weight: 500;
  line-height: 1.2;
  white-space: nowrap;
}
.login-links .v-icon { flex: 0 0 auto; font-size: clamp(18px, 4.5vw, 28px); }

@media (max-width: 374px) {
  .login-content { width: 94vw; }
  .board-heading h1 { font-size: 20px; }
  .board-heading > p { font-size: 12px; }
  .trust-list li { padding-inline: 9px; }
  .login-panel { padding-inline: 18px; }
  .login-panel h2 { font-size: 21px; }
  .login-links { gap: 5px; }
  .login-links a { font-size: 7.5px; }
}

@media (max-height: 680px) {
  .login-content { top: 23.7%; }
  .board-heading h1 { font-size: clamp(19px, 5.2vw, 23px); line-height: 1.24; }
  .board-heading > p { margin-top: 6px; }
  .trust-list { margin-block: 5px 12px; }
  .login-panel { min-height: 390px; padding-top: 62px; }
  .worker-icon { width: 58px; height: 58px; font-size: 32px; }
  .title-accent { margin-block: 6px 15px; }
  .input-field { min-height: 48px; }
  .input-field + .input-field, .field-error + .input-field { margin-top: 10px; }
  .password-note { margin-block: 4px 10px; }
  .login-button { min-height: 42px; }
  .login-links { margin-top: 31px; }
}

@media (min-width: 700px) { .login-content { width: min(73vw, 720px); } }
</style>
