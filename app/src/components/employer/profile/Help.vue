<template>
    <BackButtonAppBar />
    <v-container class="help-page" fluid>
        <v-card class="help-card" elevation="0">
            <header class="help-heading">
                <div>
                    <h1>Need Help?</h1>
                    <p>We’re here to assist you.</p>
                </div>
                <span class="help-heading-icon"><v-icon icon="mdi-help-circle-outline" /></span>
            </header>

            <v-divider class="help-divider" />

            <button class="help-contact-row" type="button" @click="contactSupport">
                <span class="help-row-icon"><v-icon icon="mdi-email" /></span>
                <span class="help-row-copy">
                    <strong>Email</strong>
                    <small>{{ email || 'Get in touch via email' }}</small>
                </span>
                <v-icon class="help-arrow" icon="mdi-chevron-right" />
            </button>

            <v-divider class="help-divider" />

            <a class="help-contact-row" :href="phone ? `tel:${phone}` : undefined">
                <span class="help-row-icon"><v-icon icon="mdi-phone" /></span>
                <span class="help-row-copy">
                    <strong>Contact No</strong>
                    <small>{{ phone || 'Speak to our support team' }}</small>
                </span>
                <v-icon class="help-arrow" icon="mdi-chevron-right" />
            </a>

            <v-divider class="help-divider" />

            <v-btn class="employer-primary-action help-support-button" block @click="contactSupport">
                <v-icon icon="mdi-headset" />Contact Support<v-icon icon="mdi-chevron-right" />
            </v-btn>
        </v-card>

        <div class="help-footer-copy">
            TOGETHER FOR<br />A BRIGHTER HIMACHAL
            <span></span>
        </div>
    </v-container>
</template>

<script>

import BackButtonAppBar from "@/components/header/BackButtonAppBar.vue";
import api from "@/services/api";
import apiRoutes from "@/services/apiRoutes";

export default {
    components: { BackButtonAppBar },
    name: "HelpCard",
    data() {
        return {
            phone: "",
            email: ""
        }
    },
    methods: {
        contactSupport() {
            if (this.email) window.location.href = "mailto:" + this.email;
        },
        async getConfig() {
            try {

                const res = await api.get(apiRoutes.getAllConfig);
                console.log('config', res.data.data);

                if (res.data && res.data.data) {
                    const configs = res.data.data;

                    this.phone = configs.find(item => item.key === 'help_phone')?.value || '';
                    this.email = configs.find(item => item.key === 'help_email')?.value || '';
                }
            } catch (error) {
                console.error("Error fetching help:", error);
                alert("Failed to load help.");
            }

        }
    },
    mounted() {
        this.getConfig()
    },
};
</script>

<style scoped>
.help-page {
    min-height: calc(100vh - 100px);
    min-height: calc(100dvh - 100px);
    box-sizing: border-box;
    padding: 32px 10px 100px;
    color: #082664;
    background-color: #fff;
    background-image: url('@/assets/authenticated-background.png');
    background-position: center top;
    background-repeat: no-repeat;
    background-size: 100% 100%;
}

.help-card {
    width: min(860px, 100%);
    margin: 0 auto;
    padding: 36px 40px 30px;
    border: 1px solid #c6e0f7;
    border-radius: 27px !important;
    background: rgba(255, 255, 255, .95) !important;
    box-shadow: 0 10px 28px rgba(18, 63, 114, .13) !important;
}

.help-heading { display: flex; align-items: center; justify-content: space-between; gap: 24px; padding: 0 12px 27px; text-align: left; }
.help-heading h1 { margin: 0; color: #071f53; font-size: clamp(36px, 4.8vw, 55px); font-weight: 800; line-height: 1.1; }
.help-heading p { margin: 8px 0 0; color: #637595; font-size: clamp(19px, 2.8vw, 28px); }
.help-heading-icon { display: grid; place-items: center; flex: 0 0 98px; width: 98px; height: 98px; border-radius: 50%; color: #0869d8; background: #e3f2ff; }
.help-heading-icon .v-icon { font-size: 58px; }
.help-divider { border-color: #d1dbe7 !important; opacity: 1; }

.help-contact-row { display: flex; align-items: center; width: 100%; min-height: 145px; padding: 20px 10px; border: 0; color: inherit; background: transparent; font-family: 'Poppins', sans-serif; text-align: left; text-decoration: none; cursor: pointer; }
.help-row-icon { display: grid; place-items: center; flex: 0 0 96px; width: 96px; height: 96px; margin-right: 34px; border-radius: 50%; color: #076ad5; background: #e5f3ff; }
.help-row-icon .v-icon { font-size: 51px; }
.help-row-copy { display: flex; flex: 1; flex-direction: column; gap: 7px; min-width: 0; }
.help-row-copy strong { color: #071f53; font-size: clamp(25px, 3.3vw, 36px); line-height: 1.1; }
.help-row-copy small { overflow-wrap: anywhere; color: #637595; font-size: clamp(18px, 2.6vw, 27px); line-height: 1.35; }
.help-arrow { flex: 0 0 auto; color: #8295b3; font-size: 46px; }

.help-support-button { margin-top: 20px; text-transform: uppercase; }
.help-support-button .v-icon:first-child { margin-right: 10px; }
.help-support-button .v-icon:last-child { margin-left: auto; }
.help-footer-copy { margin: 34px auto 0; color: #7890b2; font-size: clamp(13px, 1.8vw, 19px); font-weight: 600; letter-spacing: 7px; line-height: 1.7; text-align: center; }
.help-footer-copy span { display: block; width: 72px; height: 3px; margin: 12px auto; background: #ffae91; }

@media (max-width: 650px) {
    .help-page { padding: 30px 8px 88px; }
    .help-card { padding: 22px 12px 20px; border-radius: 20px !important; }
    .help-heading { gap: 12px; padding: 0 6px 18px; }
    .help-heading h1 { font-size: 33px; }
    .help-heading p { margin-top: 5px; font-size: 17px; }
    .help-heading-icon { flex-basis: 70px; width: 70px; height: 70px; }
    .help-heading-icon .v-icon { font-size: 43px; }
    .help-contact-row { min-height: 103px; padding: 11px 4px; }
    .help-row-icon { flex-basis: 66px; width: 66px; height: 66px; margin-right: 18px; }
    .help-row-icon .v-icon { font-size: 36px; }
    .help-row-copy { gap: 3px; }
    .help-row-copy strong { font-size: 22px; }
    .help-row-copy small { font-size: 15px; }
    .help-arrow { font-size: 33px; }
    .help-support-button { margin-top: 20px; }
    .help-footer-copy { margin-top: 25px; font-size: 11px; letter-spacing: 4px; }
}

@media (max-width: 370px) {
    .help-heading h1 { font-size: 29px; }
    .help-heading p { font-size: 15px; }
    .help-row-icon { flex-basis: 58px; width: 58px; height: 58px; margin-right: 12px; }
    .help-row-copy strong { font-size: 20px; }
    .help-row-copy small { font-size: 13px; }
}
</style>
