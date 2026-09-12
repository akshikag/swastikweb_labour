<template>
  <v-app class="worker-choice-app">
    <main class="worker-choice-page">
      <img class="page-art" src="../assets/worker-login-bg.png" alt="" aria-hidden="true" />

      <section class="choice-content" aria-labelledby="board-title">
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

        <section class="choice-panel" aria-labelledby="choice-title">
          <div class="panel-icon-row" aria-hidden="true">
            <span></span>
            <div class="panel-icon"><v-icon icon="mdi-account" /></div>
            <span></span>
          </div>

          <h2 id="choice-title">Are you an existing worker?</h2>
          <p class="choice-subtitle">Choose an option to continue</p>

          <nav class="choice-options" aria-label="Worker account options">
            <button class="choice-card choice-card--existing" type="button" @click="showScreen('worker-login')">
              <span class="choice-card__icon"><v-icon icon="mdi-login" /></span>
              <span class="choice-card__copy"><strong>Existing User</strong><small>Login with phone number</small></span>
              <v-icon class="choice-card__arrow" icon="mdi-chevron-right" />
            </button>

            <button class="choice-card choice-card--new" type="button" @click="registerWorker">
              <span class="choice-card__icon"><v-icon icon="mdi-account-plus" /></span>
              <span class="choice-card__copy"><strong>New User</strong><small>Register for the first time</small></span>
              <v-icon class="choice-card__arrow" icon="mdi-chevron-right" />
            </button>
          </nav>

          <div class="worker-pledge">
            <p>श्रमिक का सम्मान<br />हमारा संकल्प</p>
            <span aria-hidden="true"></span>
          </div>
        </section>
      </section>
    </main>
  </v-app>
</template>

<script>
export default {
  name: 'AuthSelection',
  methods: {
    showScreen(screen) {
      this.$router.push({ name: screen })
    },
    registerWorker() {
      this.$router.push({ name: 'worker-register' })
    }
  }
}
</script>

<style scoped>
.worker-choice-app { background: #fff; }

.worker-choice-page {
  position: relative;
  width: 100%;
  height: max(100dvh, min(177.5vw, 1672px));
  min-height: 620px;
  overflow: hidden;
  background: #fff;
  color: #071b38;
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

.choice-content {
  position: absolute;
  top: 22.5%;
  left: 50%;
  z-index: 2;
  width: min(93vw, 720px);
  transform: translateX(-50%);
}

.board-heading { text-align: center; }
.board-heading h1 {
  margin: 0;
  font-size: clamp(23px, 6vw, 42px);
  font-weight: 850;
  line-height: 1.35;
  letter-spacing: -0.045em;
}
.board-heading h1 span,
.board-heading h1 strong { display: block; white-space: nowrap; }
.board-heading h1 span { color: #0a438c; }
.board-heading h1 strong { color: #a6090d; font-weight: 850; }
.board-heading > p {
  margin: clamp(12px, 1.8vh, 20px) 0 0;
  color: #282828;
  font-size: clamp(14px, 3.7vw, 25px);
  font-weight: 750;
  white-space: nowrap;
}

.trust-list {
  display: flex;
  justify-content: center;
  align-items: center;
  margin: clamp(9px, 1.4vh, 16px) 0 clamp(17px, 2.5vh, 28px);
  padding: 0;
  list-style: none;
}
.trust-list li {
  display: flex;
  align-items: center;
  gap: clamp(5px, 1.25vw, 10px);
  padding: 0 clamp(14px, 4vw, 30px);
  color: #202020;
  font-size: clamp(13px, 3.5vw, 23px);
  font-weight: 650;
  white-space: nowrap;
}
.trust-list li + li { border-left: 1px solid #8f8f8f; }
.trust-list .v-icon { font-size: clamp(28px, 7vw, 45px); }
.trust-list li:nth-child(1) .v-icon { color: #0b4ba8; }
.trust-list li:nth-child(2) .v-icon { color: #159737; }
.trust-list li:nth-child(3) .v-icon { color: #ff620d; }

.choice-panel {
  position: relative;
  min-height: clamp(415px, 55vh, 650px);
  padding: clamp(58px, 8vh, 88px) clamp(16px, 3.5vw, 32px) 0;
  border: 1px solid rgb(175 207 229 / 30%);
  border-radius: clamp(24px, 5vw, 40px) clamp(24px, 5vw, 40px) 0 0;
  background: linear-gradient(180deg, rgb(255 255 255 / 94%) 0%, rgb(255 255 255 / 88%) 76%, rgb(255 255 255 / 34%) 100%);
  box-shadow: 0 5px 18px rgb(60 108 146 / 10%);
}

.panel-icon-row {
  position: absolute;
  top: 0;
  left: 50%;
  display: grid;
  grid-template-columns: clamp(62px, 17vw, 120px) auto clamp(62px, 17vw, 120px);
  align-items: center;
  gap: clamp(12px, 3.4vw, 24px);
  transform: translate(-50%, -2%);
}
.panel-icon-row > span { height: 2px; background: #d4e2ec; }
.panel-icon {
  display: grid;
  place-items: center;
  width: clamp(54px, 14vw, 90px);
  height: clamp(54px, 14vw, 90px);
  border-radius: 50%;
  background: #0757ad;
  color: #ffffff;
  box-shadow: 0 5px 10px rgb(7 87 173 / 28%);
  font-size: clamp(32px, 8.5vw, 54px);
}

.choice-panel h2 {
  margin: clamp(16px, 2.4vh, 27px) 0 0;
  text-align: center;
  font-family: 'Poppins', sans-serif;
  font-size: clamp(20px, 6.35vw, 20px);
  font-weight: 800;
  line-height: 1.12;
  letter-spacing: -0.03em;
}
.choice-subtitle {
  margin: clamp(7px, 1.1vh, 12px) 0 clamp(23px, 3.6vh, 38px);
  color: #344154;
  text-align: center;
  font-family: 'Poppins', sans-serif;
  font-size: clamp(17px, 4.5vw, 30px);
}

.choice-options { display: grid; gap: clamp(13px, 2vh, 22px); }
.choice-card {
  display: grid;
  grid-template-columns: clamp(56px, 15vw, 96px) 1fr clamp(25px, 6vw, 40px);
  align-items: center;
  width: 100%;
  min-height: clamp(91px, 13.1vh, 145px);
  padding: clamp(12px, 1.8vh, 20px) clamp(16px, 4vw, 28px);
  border-radius: clamp(10px, 2.5vw, 18px);
  text-align: left;
  cursor: pointer;
  touch-action: manipulation;
  -webkit-tap-highlight-color: transparent;
}
.choice-card--existing {
  border: clamp(2px, 0.45vw, 4px) solid #ff8200;
  background: rgb(255 255 255 / 91%);
  color: #071b38;
  box-shadow: 0 5px 10px rgb(91 72 40 / 14%);
}
.choice-card--new {
  border: 0;
  background: linear-gradient(110deg, #167bd9, #0b6fda 55%, #1681e3);
  color: #fff;
  box-shadow: 0 8px 14px rgb(0 87 176 / 19%);
}
.choice-card:focus-visible { outline: 3px solid #063d8d; outline-offset: 3px; }
.choice-card:active { transform: translateY(1px); }
.choice-card .v-icon { --v-icon-size-multiplier: 0.50; }
.choice-card__icon { display: grid; place-items: center; font-size: clamp(35px, 9vw, 58px); }
.choice-card--existing .choice-card__icon { color: #ff8200; }
.choice-card__copy { display: flex; flex-direction: column; min-width: 0; }
.choice-card__copy strong {
  font-family: 'Poppins', sans-serif;
  font-size: clamp(17px, 5.7vw, 17px) !important;
  font-weight: 800;
  line-height: 1.50;
  white-space: nowrap;
}
.choice-card__copy small {
  margin-top: clamp(5px, 0.8vh, 9px);
  font-family: 'Poppins', sans-serif;
  font-size: clamp(15px, 4.4vw, 15px);
  line-height: 1.50;
  white-space: nowrap;
}
.choice-card__arrow { justify-self: end; color: inherit; font-size: clamp(34px, 8vw, 52px); }
.choice-card--existing .choice-card__arrow { color: #ff8200; }

.worker-pledge {
  margin-top: clamp(35px, 5vh, 56px);
  color: #09509d;
  text-align: center;
  font-size: clamp(16px, 4.1vw, 27px);
  font-weight: 800;
  line-height: 1.25;
}
.worker-pledge p { margin: 0; }
.worker-pledge span { display: block; width: 38px; height: 2px; margin: 8px auto 0; background: #ff7900; }

@media (max-width: 374px) {
  .choice-content { width: 95vw; }
  .board-heading h1 { font-size: 20px; }
  .board-heading > p { font-size: 12px; }
  .trust-list li { padding-inline: 9px; }
  .choice-panel { padding-inline: 13px; }
  .choice-panel h2 { font-size: 23px; }
  .choice-card { grid-template-columns: 49px 1fr 24px; padding-inline: 13px; }
  .choice-card__copy strong { font-size: 21px; }
  .choice-card__copy small { font-size: 15px; }
}

@media (max-height: 680px) {
  .choice-content { top: 21.8%; }
  .board-heading h1 { font-size: clamp(19px, 5.2vw, 23px); line-height: 1.25; }
  .board-heading > p { margin-top: 6px; }
  .trust-list { margin-block: 5px 12px; }
  .choice-panel { min-height: 390px; padding-top: 58px; }
  .choice-panel h2 { margin-top: 8px; }
  .choice-subtitle { margin-block: 5px 17px; }
  .choice-card { min-height: 80px; }
  .choice-options { gap: 10px; }
  .worker-pledge { margin-top: 22px; }
}

@media (min-width: 700px) { .choice-content { width: min(73vw, 720px); } }
</style>
