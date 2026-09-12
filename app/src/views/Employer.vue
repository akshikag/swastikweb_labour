<template>
    <section class="employer-selection-page">

                <div class="board-introduction">
                    <h1><span>हिमाचल प्रदेश भवन एवं</span><strong>अन्य सन्निर्माण कामगार कल्याण बोर्ड</strong></h1>
                    <p>कौशल से अवसर तक - निर्माण क्षेत्र का विश्वसनीय मंच</p>
                    <div class="board-highlights" aria-label="Board highlights">
                        <span><v-icon>mdi-shield-check-outline</v-icon>सत्यापित</span>
                        <span><v-icon>mdi-clock-outline</v-icon>त्वरित</span>
                        <span><v-icon>mdi-handshake-outline</v-icon>विश्वसनीय</span>
                    </div>
                </div>

                <article class="employer-choice-card">
                    <span class="choice-avatar"><v-icon>mdi-account</v-icon></span>
                    <h2>Are you an existing employer?</h2>
                    <p>Choose an option to continue</p>

                    <button class="choice-button choice-button--existing" type="button" @click="showScreen('employer-login')">
                        <v-icon>mdi-login</v-icon>
                        <span><strong>Existing User</strong><small>Login with phone number</small></span>
                        <v-icon class="choice-arrow">mdi-chevron-right</v-icon>
                    </button>

                    <button class="choice-button choice-button--new" type="button" @click="registerEmployer">
                        <v-icon>mdi-account-plus</v-icon>
                        <span><strong>New User</strong><small>Register for the first time</small></span>
                        <v-icon class="choice-arrow">mdi-chevron-right</v-icon>
                    </button>
                </article>

                <div class="selection-footer-copy">श्रमिक का सम्मान<br />हमारा संकल्प<span></span></div>
    </section>
</template>

<script>
export default {
    name: "AuthSelection",
    methods: {
        showScreen(screen) {
            this.$router.push({ name: screen });
        },
        registerEmployer() {
            this.$router.push({ name: 'employer-register' });
        },
        goBack() {
            this.$router.back();
        },
    },
};
</script>

<style scoped>
.employer-selection-app{background:#fff}.employer-selection-page{position:relative;isolation:isolate;min-height:100vh;padding:138px 24px 84px;overflow:hidden;background:#fff url('@/assets/worker-login-bg.png') center top/100% 100% no-repeat;color:#072a6a}.selection-back{position:absolute;z-index:2;top:16px;left:14px;display:grid;place-items:center;width:38px;height:38px;border:0;border-radius:50%;color:#fff;background:#0871cf;box-shadow:0 4px 8px #0a4d853d;cursor:pointer}.selection-back .v-icon{font-size:28px}.board-introduction{position:relative;z-index:1;max-width:500px;margin:0 auto 16px;text-align:center}.board-introduction h1{margin:0;font-size:clamp(19px,3.2vw,34px);line-height:1.15;font-weight:800}.board-introduction h1 span{display:block;color:#0752a5}.board-introduction h1 strong{display:block;color:#c6101c}.board-introduction p{margin:6px 0 8px;color:#061f4d;font-size:clamp(12px,1.9vw,19px);font-weight:700}.board-highlights{display:flex;justify-content:center;gap:16px;color:#071d51;font-size:clamp(12px,1.8vw,18px);font-weight:700}.board-highlights span{display:flex;align-items:center;gap:4px}.board-highlights .v-icon{font-size:25px}.board-highlights span:nth-child(1) .v-icon{color:#0860c7}.board-highlights span:nth-child(2) .v-icon{color:#1baf3d}.board-highlights span:nth-child(3) .v-icon{color:#ff741f}.employer-choice-card{position:relative;z-index:1;width:min(620px,100%);margin:0 auto;padding:52px 14px 12px;border:1px solid #d5e7f8;border-radius:25px;background:#fffffff2;box-shadow:0 7px 18px #12529b18;text-align:center}.choice-avatar{position:absolute;top:-13px;left:50%;display:grid;place-items:center;width:62px;height:62px;border-radius:50%;color:#fff;background:#076bd3;box-shadow:0 5px 10px #0754a440;transform:translateX(-50%)}.choice-avatar .v-icon{font-size:43px}.employer-choice-card h2{margin:9px 0 4px;color:#061e4e;font-size:clamp(20px,3vw,30px);font-weight:800}.employer-choice-card>p{margin:0 0 18px;color:#183c77;font-size:clamp(16px,2.3vw,22px)}.choice-button{display:flex;align-items:center;width:100%;min-height:78px;margin:10px 0;border-radius:12px;padding:12px 18px;border:2px solid transparent;background:transparent;text-align:left;cursor:pointer;transition:transform .18s,box-shadow .18s}.choice-button:hover{transform:translateY(-1px);box-shadow:0 5px 12px #074d9e1f}.choice-button>.v-icon:first-child{flex:0 0 34px;margin-right:13px;font-size:31px}.choice-button span{display:flex;flex:1;flex-direction:column;gap:3px}.choice-button strong{font-size:clamp(17px,2.5vw,23px);line-height:1.1}.choice-button small{font-size:clamp(14px,2vw,19px)}.choice-arrow{font-size:33px}.choice-button--existing{border-color:#ff7900;color:#051e4c}.choice-button--existing>.v-icon:first-child,.choice-button--existing .choice-arrow{color:#ff7900}.choice-button--new{border-color:#0a77dc;background:linear-gradient(110deg,#168ae9,#0871d9);color:#fff}.choice-button--new>.v-icon:first-child,.choice-button--new .choice-arrow{color:#fff}.selection-footer-copy{position:absolute;z-index:1;bottom:32px;left:50%;width:100%;color:#084f9e;font-size:clamp(16px,2.5vw,24px);font-weight:800;line-height:1.02;text-align:center;transform:translateX(-50%)}.selection-footer-copy span{display:block;width:44px;height:2px;margin:7px auto 0;background:#f16631}
@media(min-width:651px){.employer-selection-page{padding-top:210px}.board-introduction{margin-bottom:24px}.employer-choice-card{padding:62px 34px 22px}.choice-button{min-height:92px}.selection-footer-copy{bottom:42px}}
@media(max-width:390px){.employer-selection-page{padding:140px 10px 78px}.board-highlights{gap:10px}.board-highlights .v-icon{font-size:22px}.employer-choice-card{padding-inline:13px}.choice-button{min-height:72px;padding:10px 13px}.choice-button>.v-icon:first-child{margin-right:9px;font-size:27px}.choice-arrow{font-size:28px}}
/* Prevent text and icon collisions at every screen width. */
.employer-selection-page{display:flex;flex-direction:column;align-items:center;box-sizing:border-box;overflow-x:hidden;overflow-y:auto}
.board-introduction{width:100%;flex:0 0 auto}.board-highlights{flex-wrap:wrap;row-gap:7px}.board-highlights span{white-space:nowrap}
.employer-choice-card{flex:0 0 auto}.choice-button{gap:12px}.choice-button>.v-icon:first-child{margin-right:0}.choice-button span{min-width:0;overflow-wrap:anywhere}.choice-arrow{flex:0 0 auto}
.selection-footer-copy{position:relative;bottom:auto;left:auto;flex:0 0 auto;margin-top:auto;padding-top:24px;transform:none}
.employer-selection-page{background-image:url('@/assets/worker-login-bg.png')!important;background-size:100% auto!important;background-position:center top!important;background-repeat:no-repeat!important;background-attachment:scroll}
.employer-selection-page{min-height:100dvh}
</style>
