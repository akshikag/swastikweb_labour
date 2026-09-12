<template>
    <LogoutAppBar />
    <v-container class="employer-home-page" fluid>
        <div v-if="loading" class="d-flex justify-center align-center" style="height: 200px;">
            <v-progress-circular indeterminate color="primary" size="50"></v-progress-circular>
        </div>
        <!-- Employer Info Card -->
        <v-card class="employer-profile-card" elevation="0" v-if="!loading">
            <v-avatar class="employer-avatar" size="88">
                <img v-if="employer.profile.profile_image_base64" :src="employer.profile.profile_image_base64" alt="Employer" />
                <v-icon v-else>mdi-account</v-icon>
            </v-avatar>
            <div class="employer-profile-copy">
                <h2>{{ employer.profile.name || 'Employer' }}</h2>
                <div class="employer-role"><v-icon>mdi-briefcase</v-icon>Employer</div>
                <div class="employer-phone"><v-icon>mdi-phone</v-icon>{{ employer.phone }}</div>
            </div>
            <div class="profile-ornament">PEOPLE<br />WORK<br />PROSPER<br />TOGETHER<span></span></div>
        </v-card>

        <!-- Action Cards -->
        <v-row class="employer-actions" dense v-if="!loading">
            <v-col cols="6">
                <v-card class="employer-action-card" elevation="0" @click="goTo('employer-dashboard-home-postjob')">
                    <v-icon class="action-icon">mdi-briefcase-plus</v-icon>
                    <strong>Post Job</strong><small>Hire Skilled Workers</small>
                </v-card>
            </v-col>
            <v-col cols="6">
                <v-card class="employer-action-card" elevation="0" @click="goTo('employer-dashboard-home-myjob')">
                    <v-icon class="action-icon">mdi-format-list-bulleted-square</v-icon>
                    <strong>My Jobs</strong><small>Manage Your Job Posts</small>
                </v-card>
            </v-col>

            <v-col cols="12">
                <v-card class="employer-action-card employer-action-card--wide" elevation="0" @click="goTo('employer-dashboard-search')">
                    <v-icon class="action-icon">mdi-account-search</v-icon>
                    <strong>Find Worker</strong><small>Connect with Skilled Workers</small>
                </v-card>
            </v-col>

            <!-- <v-col cols="6">
                <v-card class="pa-4 text-center" color="secondary" @click="goTo('employer-dashboard-home-applyworker')">
                    <v-icon size="36" color="primary">mdi-account-cog</v-icon>
                    <div class="mt-2">Applied Worker</div>
                </v-card>
            </v-col> -->

        </v-row>
    </v-container>
</template>

<script>
import LogoutAppBar from '@/components/header/LogoutAppBar.vue';
import api from "@/services/api.js";
import apiRoutes from "@/services/apiRoutes.js";

export default {
    components: { LogoutAppBar },
    data() {
        return {
            loading: false,
            employer: {

                profile: {
                    profile_image_base64: '',  // Employer avatar
                    name: '',                  // Employer name
                },
                phone: '',                     // Employer phone number
                skills: [],

            },
            stats: {
                hired: 12,
                activeJobs: 5,
                messages: 9,
            },
        };
    },
    methods: {
        goTo(page) {
            console.log("Navigating to:", page);
            // Example navigation
            this.$router.push(`/${page}`);
        },
        async getEmployer() {
            this.loading = true;
            const employerData = JSON.parse(localStorage.getItem("labour_currentUser"));

            try {
                const res = await api.get(
                    `${apiRoutes.employerGetById}/${employerData.employer.id}`
                );
                const data = res.data.employer;
                //this.employer = data;
                this.employer.profile.profile_image_base64 = data.profile?.profile_image_base64 || this.defaultAvatar;
                this.employer.profile.name = data.profile?.name || '';
                this.employer.phone = data.phone || '';
                this.employer.skills = data.skills || [];
                //console.log(data);
                this.loading = false;
            } catch (err) {
                alert("Error loading data", err);
                this.loading = false;
            }

        }
    },
    mounted() {
        this.getEmployer()
    }
};
</script>

<style scoped>
.employer-home-page{min-height:calc(100vh - 64px);padding:20px 10px 100px!important;background:#fff url('@/assets/authenticated-background.png') center/100% 100% no-repeat;color:#082664}.employer-profile-card{position:relative;display:flex;align-items:center;width:min(680px,100%);min-height:124px;margin:0 auto 14px;padding:17px 22px 17px 24px;border:1px solid #d4e4f3;border-radius:10px!important;background:#fffffff2!important;box-shadow:0 5px 14px #143d6c1f!important;overflow:hidden}.employer-avatar{flex:0 0 88px;background:#bfe1ff;color:#075db8}.employer-avatar img{width:100%;height:100%;object-fit:cover}.employer-avatar .v-icon{font-size:51px}.employer-profile-copy{min-width:0;margin-left:28px;padding-left:24px;border-left:1px solid #d5e0ed}.employer-profile-copy h2{margin:0 0 6px;color:#071d4d;font-size:28px;line-height:1.1;font-weight:800}.employer-role,.employer-phone{display:flex;align-items:center;gap:8px;color:#273a5d;font-size:16px;line-height:1.65}.employer-role .v-icon,.employer-phone .v-icon{font-size:20px;color:#687991}.profile-ornament{margin-left:auto;padding-left:15px;color:#9caec3;font-size:9px;line-height:1.45;letter-spacing:2px;text-align:center}.profile-ornament:before{content:'◆ ▲ ◆';display:block;margin-bottom:4px;color:#c4d4e7;font-size:18px;letter-spacing:1px}.profile-ornament span{display:block;width:28px;height:2px;margin:8px auto 0;background:#ffac8d}.employer-actions{width:min(680px,100%);margin:0 auto!important}.employer-actions :deep(.v-col){padding:0 5px 10px}.employer-action-card{position:relative;display:flex;align-items:center;justify-content:center;flex-direction:column;min-height:112px;padding:14px 8px;border-radius:9px!important;background:#cae7ff!important;color:#082664;cursor:pointer;overflow:hidden;transition:transform .18s,box-shadow .18s}.employer-action-card:after{content:'';position:absolute;right:-30px;bottom:-37px;width:92px;height:74px;border-radius:50%;background:#b5dcff;opacity:.7}.employer-action-card:hover{transform:translateY(-2px);box-shadow:0 7px 14px #164f8427!important}.action-icon{z-index:1;margin-bottom:5px;color:#075bb8;font-size:43px!important}.employer-action-card strong,.employer-action-card small{z-index:1}.employer-action-card strong{font-size:18px;line-height:1.2}.employer-action-card small{margin-top:4px;color:#45688d;font-size:12px}.employer-action-card--wide{min-height:100px}
@media(max-width:480px){.employer-home-page{padding:10px 8px 90px!important}.employer-profile-card{min-height:122px;padding:16px 12px}.employer-avatar{flex-basis:86px}.employer-profile-copy{margin-left:15px;padding-left:14px}.employer-profile-copy h2{font-size:24px}.employer-role,.employer-phone{font-size:14px;gap:5px}.profile-ornament{padding-left:5px;font-size:7px;letter-spacing:1px}.profile-ornament:before{font-size:14px}.employer-action-card{min-height:112px}.employer-action-card strong{font-size:17px}.employer-action-card small{font-size:11px}}
</style>
