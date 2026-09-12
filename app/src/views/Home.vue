<template>
  <v-app class="welcome-app">
    <main class="welcome-page">
      <img class="welcome-page__art" src="../assets/labour-chowk-welcome-bg.png" alt="" aria-hidden="true" />

      <section class="welcome-content" aria-labelledby="welcome-title">
        <header class="welcome-heading">
          <h1 id="welcome-title">
            <span>हिमाचल प्रदेश भवन एवं</span>
            <strong>अन्य सन्निर्माण कामगार कल्याण बोर्ड</strong>
          </h1>
          <div class="heading-rule" aria-hidden="true"><span>◇</span></div>
          <p class="welcome-tagline">कौशल से अवसर तक – निर्माण क्षेत्र का विश्वसनीय मंच</p>

          <ul class="trust-list" aria-label="Platform features">
            <li><span class="trust-icon trust-icon--verified"><v-icon icon="mdi-shield-check-outline" /></span><span>सत्यापित</span></li>
            <li><span class="trust-icon trust-icon--quick"><v-icon icon="mdi-clock-outline" /></span><span>त्वरित</span></li>
            <li><span class="trust-icon trust-icon--trusted"><v-icon icon="mdi-handshake-outline" /></span><span>विश्वसनीय</span></li>
          </ul>
        </header>

        <div class="labour-chowk-label">
          <span aria-hidden="true"></span>
          <p>हिमाचल प्रदेश डिजिटल लेबर चौक</p>
          <span aria-hidden="true"></span>
        </div>

        <nav class="role-options" aria-label="Choose your role">
          <button class="role-card role-card--worker" type="button" @click="onWorkerClick">
            <span class="role-card__icon"><v-icon icon="mdi-account-hard-hat" /></span>
            <span class="role-card__divider" aria-hidden="true"></span>
            <span class="role-card__copy"><strong>I am a Worker</strong><small>मैं एक श्रमिक हूँ</small></span>
            <span class="role-card__arrow" aria-hidden="true"><v-icon icon="mdi-arrow-right" /></span>
          </button>

          <button class="role-card role-card--employer" type="button" @click="onEmployerClick">
            <span class="role-card__icon"><v-icon icon="mdi-briefcase" /></span>
            <span class="role-card__divider" aria-hidden="true"></span>
            <span class="role-card__copy"><strong>I am an Employer</strong><small>मैं नियोक्ता हूँ</small></span>
            <span class="role-card__arrow" aria-hidden="true"><v-icon icon="mdi-arrow-right" /></span>
          </button>
        </nav>
      </section>
    </main>
  </v-app>
</template>

<script setup>
import { onMounted, nextTick } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()

function onWorkerClick() {
  router.push('/worker')
}

function onEmployerClick() {
  router.push('/employer')
}

onMounted(async () => {
  const currentUser = localStorage.getItem('labouchowk_currentUser')
  const userType = localStorage.getItem('labouchowk_userType')

  if (currentUser && userType) {
    if (userType === 'worker') router.replace('/worker-dashboard')
    else if (userType === 'employer') router.replace('/employer-dashboard')
  }

  await nextTick()
  const existingScript = document.querySelector('script[src*="bhashini"]')
  if (existingScript) existingScript.remove()

  const script = document.createElement('script')
  script.src = 'https://translation-plugin.bhashini.co.in/v3/website_translation_utility.js'
  script.async = true
  script.setAttribute('language-icon-color', '#0b3f91')
  document.body.appendChild(script)
})
</script>

<style scoped>
.welcome-app { background: #fff; }

.welcome-page {
  position: relative;
  width: 100%;
  height: max(100dvh, min(177.5vw, 1672px));
  min-height: 560px;
  overflow: hidden;
  background: #fff;
  color: #101010;
  font-family: 'Poppins', sans-serif;
}

.welcome-page__art {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
  object-position: center;
  pointer-events: none;
  user-select: none;
}

.welcome-content {
  position: absolute;
  top: 28.8%;
  left: 50%;
  z-index: 1;
  display: flex;
  flex-direction: column;
  width: min(88vw, 600px);
  height: auto;
  margin: 0;
  padding: 0;
  transform: translateX(-50%);
}

.welcome-heading { text-align: center; }

.welcome-heading h1 {
  margin: 0;
  font-size: clamp(20px, 5.7vw, 21px) !important;
  line-height: 1.50;
  font-weight: 800;
  letter-spacing: -0.035em;
}

.welcome-heading h1 span,
.welcome-heading h1 strong { display: block; }
.welcome-heading h1 span { color: #0a4194; }
.welcome-heading h1 strong { color: #981014; font-weight: 800; }

.heading-rule {
  display: flex;
  align-items: center;
  gap: 4px;
  width: 82%;
  margin: clamp(8px, 1.4vh, 15px) auto clamp(7px, 1.2vh, 13px);
  color: #737373;
  font-size: 13px;
}

.heading-rule::before,
.heading-rule::after {
  content: "";
  flex: 1;
  height: 1px;
  background: linear-gradient(90deg, transparent, #969696);
}
.heading-rule::after { background: linear-gradient(90deg, #969696, transparent); }

.welcome-tagline {
  margin: 0;
  font-size: clamp(14px, 3.75vw, 25px);
  line-height: 1.35;
  white-space: nowrap;
}

.trust-list {
  display: flex;
  justify-content: center;
  align-items: center;
  margin: clamp(7px, 1.2vh, 14px) 0 0;
  padding: 0;
  list-style: none;
}

.trust-list li {
  display: flex;
  align-items: center;
  gap: clamp(4px, 1.3vw, 9px);
  padding: 0 clamp(9px, 3vw, 20px);
  font-size: clamp(14px, 3.8vw, 24px);
  white-space: nowrap;
}
.trust-list li + li { border-left: 1px solid #7e7e7e; }

.trust-icon { display: inline-grid; place-items: center; font-size: clamp(25px, 7vw, 43px); }
.trust-icon--verified { color: #0b48a1; }
.trust-icon--quick { color: #078b35; }
.trust-icon--trusted { color: #e74e08; }

.labour-chowk-label {
  display: grid;
  grid-template-columns: 1fr auto 1fr;
  align-items: center;
  width: 91%;
  margin: clamp(9px, 1.5vh, 16px) auto clamp(10px, 1.5vh, 17px);
}

.labour-chowk-label > span { position: relative; height: 2px; background: #0b4297; }
.labour-chowk-label > span::after {
  content: "";
  position: absolute;
  top: 50%;
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: #0b4297;
  transform: translateY(-50%);
}
.labour-chowk-label > span:first-child::after { left: 0; }
.labour-chowk-label > span:last-child::after { right: 0; }

.labour-chowk-label p {
  margin: 0;
  padding: clamp(6px, 0.85vh, 10px) clamp(13px, 3.5vw, 24px);
  border-radius: 999px;
  background: linear-gradient(180deg, #104eb1 0%, #073686 100%);
  box-shadow: inset 0 1px 0 rgb(255 255 255 / 25%);
  color: #fff;
  font-size: clamp(17px, 4.7vw, 30px);
  font-weight: 750;
  line-height: 1.15;
  white-space: nowrap;
}

.role-options { display: grid; gap: clamp(9px, 1.3vh, 15px); }

.role-card {
  display: grid;
  grid-template-columns: clamp(58px, 16vw, 102px) 1px 1fr clamp(38px, 10vw, 62px);
  align-items: center;
  width: 100%;
  min-height: clamp(76px, 11.2vh, 115px);
  padding: clamp(7px, 1.1vh, 12px) clamp(12px, 3.2vw, 22px);
  border: 1px solid;
  border-radius: clamp(13px, 3.5vw, 21px);
  text-align: left;
  box-shadow: 0 3px 5px rgb(23 42 73 / 18%);
  cursor: pointer;
  -webkit-tap-highlight-color: transparent;
  touch-action: manipulation;
}

.role-card--worker {
  border-color: #d8baa3;
  background: linear-gradient(105deg, rgb(255 252 248 / 96%), rgb(255 247 239 / 91%));
  color: #4c1c02;
}
.role-card--employer {
  border-color: #7ca6dc;
  background: linear-gradient(105deg, rgb(250 253 255 / 96%), rgb(235 245 255 / 92%));
  color: #07347f;
}
.role-card:focus-visible { outline: 3px solid #f4a43a; outline-offset: 3px; }
.role-card:active { transform: translateY(1px); box-shadow: 0 1px 3px rgb(23 42 73 / 20%); }

.role-card__icon,
.role-card__arrow { display: grid; place-items: center; border-radius: 50%; }
.role-card__icon {
  justify-self: start;
  width: clamp(50px, 13.5vw, 84px);
  height: clamp(50px, 13.5vw, 84px);
  background: rgb(218 118 42 / 10%);
  font-size: clamp(29px, 8vw, 49px);
}
.role-card--employer .role-card__icon { background: rgb(47 128 224 / 10%); }
.role-card__divider { width: 1px; height: 72%; background: currentColor; opacity: 0.25; }

.role-card__copy {
  display: flex;
  flex-direction: column;
  min-width: 0;
  padding-left: clamp(14px, 4vw, 26px);
  color: #090909;
}
.role-card__copy strong {
  font-family: 'Poppins', sans-serif;
  font-size: clamp(17px, 5.7vw, 17px) !important;
  line-height: 1.50;
  font-weight: 800;

  white-space: nowrap;
}
.role-card__copy small {
  margin-top: clamp(3px, 0.55vh, 7px);
  font-size: clamp(15px, 4vw, 25px);
  line-height: 1.1;
  white-space: nowrap;
}

.role-card__arrow {
  justify-self: end;
  width: clamp(36px, 9vw, 57px);
  height: clamp(36px, 9vw, 57px);
  background: rgb(225 122 44 / 10%);
  font-size: clamp(24px, 6.5vw, 40px);
}
.role-card--employer .role-card__arrow { background: rgb(45 124 222 / 10%); }

@media (max-width: 374px) {
  .welcome-content { width: 91vw; }
  .welcome-tagline { font-size: 13px; }
  .trust-list li { padding-inline: 7px; }
  .labour-chowk-label { width: 95%; }
  .role-card { grid-template-columns: 52px 1px 1fr 34px; padding-inline: 10px; }
  .role-card__copy { padding-left: 12px; }
  .role-card__copy strong { font-size: 17px; }
}

@media (max-height: 680px) {
  .welcome-heading h1 { font-size: clamp(20px, 5.7vw, 21px) !important;
  line-height: 1.50;
  }
  .heading-rule { margin-block: 5px; }
  .trust-list { margin-top: 4px; }
  .trust-icon { font-size: 23px; }
  .labour-chowk-label { margin-block: 6px 7px; }
  .labour-chowk-label p { padding-block: 5px; font-size: clamp(15px, 4.25vw, 18px); }
  .role-options { gap: 7px; }
  .role-card { min-height: 66px; padding-block: 5px; }
  .role-card__icon { width: 46px; height: 46px; font-size: 27px; }
  .role-card__copy small { margin-top: 2px; }
}

@media (min-width: 700px) { .welcome-content { width: min(68vw, 600px); } }

@media (orientation: landscape) and (max-height: 600px) {
  .welcome-page {
    height: max(620px, min(177.5vw, 1050px));
    min-height: 620px;
  }
  .welcome-content { top: 175px; padding-bottom: 40px; }
}
</style>
