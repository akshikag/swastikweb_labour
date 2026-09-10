<template>
    <BackButtonAppBar />
    <v-container class="help-page" fluid>
        <v-card class="help-card" elevation="0">
            <header class="help-heading">
                <div><h1>Need Help?</h1><p>We’re here to assist you.</p></div>
                <span class="help-heading-icon"><v-icon>mdi-help-circle-outline</v-icon></span>
            </header>
            <v-divider class="help-divider" />

            <button class="help-contact-row" type="button" @click="contactSupport">
                <span class="help-row-icon"><v-icon>mdi-email</v-icon></span>
                <span class="help-row-copy"><strong>Email</strong><small>{{ email || 'Get in touch via email' }}</small></span>
                <v-icon class="help-arrow">mdi-chevron-right</v-icon>
            </button>
            <v-divider class="help-divider" />
            <a class="help-contact-row" :href="phone ? `tel:${phone}` : '#'">
                <span class="help-row-icon"><v-icon>mdi-phone</v-icon></span>
                <span class="help-row-copy"><strong>Contact No</strong><small>{{ phone || 'Speak to our support team' }}</small></span>
                <v-icon class="help-arrow">mdi-chevron-right</v-icon>
            </a>
            <v-divider class="help-divider" />

            <v-btn class="help-support-button" block @click="contactSupport"><v-icon start>mdi-headset</v-icon>Contact Support<v-icon end>mdi-chevron-right</v-icon></v-btn>
        </v-card>
        <div class="help-footer-copy">TOGETHER FOR<br />A BRIGHTER HIMACHAL<span></span></div>
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
            // You can change this to open chat or another route
            window.location.href = "mailto:" + this.email;
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
.help-page{min-height:calc(100vh - 64px);padding:42px 18px 100px;background:#fff url('@/assets/authenticated-background.png') center/100% 100% no-repeat;color:#082664}.help-card{width:min(860px,100%);margin:0 auto;padding:44px 48px 38px;border:1px solid #d0e3f5;border-radius:27px!important;background:#fffffff2!important;box-shadow:0 10px 28px #123f7220!important}.help-heading{display:flex;align-items:center;justify-content:space-between;gap:24px;padding:0 18px 30px}.help-heading h1{margin:0;color:#071f53;font-size:clamp(38px,5vw,58px);font-weight:800;line-height:1.1}.help-heading p{margin:8px 0 0;color:#637595;font-size:clamp(21px,3vw,31px)}.help-heading-icon{display:grid;place-items:center;width:108px;height:108px;border-radius:50%;background:#e3f2ff;color:#0869d8}.help-heading-icon .v-icon{font-size:65px}.help-divider{border-color:#d1dbe7!important;opacity:1}.help-contact-row{display:flex;align-items:center;width:100%;min-height:170px;padding:22px 10px;border:0;background:transparent;color:inherit;text-align:left;text-decoration:none;cursor:pointer}.help-row-icon{display:grid;place-items:center;flex:0 0 116px;width:116px;height:116px;margin-right:42px;border-radius:50%;background:#e5f3ff;color:#076ad5}.help-row-icon .v-icon{font-size:61px}.help-row-copy{display:flex;flex:1;flex-direction:column;gap:7px;min-width:0}.help-row-copy strong{color:#071f53;font-size:clamp(27px,3.5vw,39px);line-height:1.1}.help-row-copy small{overflow-wrap:anywhere;color:#637595;font-size:clamp(21px,2.8vw,30px)}.help-arrow{flex:0 0 auto;color:#8295b3;font-size:50px}.help-support-button{height:84px!important;margin-top:30px;border-radius:16px;background:linear-gradient(110deg,#1688ed,#0867d6)!important;color:#fff;font-size:clamp(21px,3vw,30px)!important;font-weight:800;letter-spacing:.6px}.help-support-button .v-icon{font-size:38px}.help-footer-copy{margin:40px auto 0;color:#7890b2;font-size:clamp(14px,2vw,21px);font-weight:600;letter-spacing:7px;line-height:1.7;text-align:center}.help-footer-copy span{display:block;width:72px;height:3px;margin:12px auto;background:#ffae91}
@media(max-width:650px){.help-page{padding:30px 10px 88px;background-size:auto 100%}.help-card{padding:22px 12px 20px;border-radius:20px!important}.help-heading{padding:0 6px 18px;gap:12px}.help-heading h1{font-size:35px}.help-heading p{font-size:18px;margin-top:5px}.help-heading-icon{width:72px;height:72px}.help-heading-icon .v-icon{font-size:44px}.help-contact-row{min-height:105px;padding:12px 4px}.help-row-icon{flex-basis:72px;width:72px;height:72px;margin-right:20px}.help-row-icon .v-icon{font-size:40px}.help-row-copy{gap:4px}.help-row-copy strong{font-size:24px}.help-row-copy small{font-size:17px}.help-arrow{font-size:37px}.help-support-button{height:58px!important;margin-top:20px;font-size:18px!important}.help-support-button .v-icon{font-size:28px}.help-footer-copy{margin-top:25px;font-size:12px;letter-spacing:4px}}
</style>
