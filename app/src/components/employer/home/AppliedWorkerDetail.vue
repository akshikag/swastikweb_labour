<template>
    <BackButtonAppBar />
    <v-container class="worker-detail-page">
        <!-- Header -->
        <v-card class="worker-hero-card" elevation="0">
            <div class="worker-hero-mountains" aria-hidden="true"></div>
            <span class="worker-status"><i></i>Available</span>
            <v-card-title class="text-h6 font-weight-bold d-flex align-center justify-space-between">
            </v-card-title>
            <div v-if="loading" class="d-flex justify-center align-center" style="height: 200px;">
                <v-progress-circular indeterminate color="primary" size="50"></v-progress-circular>
            </div>
            <div class="worker-hero-content">
                <v-avatar class="worker-hero-avatar" size="200" color="orange lighten-2">
                    <v-img :src="worker.photo" alt="Worker Image" cover></v-img>
                </v-avatar>
                <div class="worker-hero-details">
                    <p class="font-weight-bold mb-1 text-subtitle-1 ">
                        <v-icon left color="white">mdi-account</v-icon>
                        {{ worker.name }}
                    </p>
                    <p class="mb-1">
                        <v-icon left color="white">mdi-phone</v-icon>
                        {{ worker.phone }}
                    </p>
                    <p class="mb-0">
                        <v-icon left color="white">mdi-card-account-details-outline</v-icon>
                        Worker Profile
                    </p>
                </div>
                <div class="worker-hero-tagline" aria-hidden="true">Skilled Hands<br>Stronger Himachal<span></span></div>
            </div>

            <v-card-actions class="mt-2">
                <v-btn color="white" variant="flat" class="mr-2" @click="callWorker(worker.phone)">
                    <v-icon left color="primary">mdi-phone</v-icon>
                    Call
                </v-btn>
                <v-spacer></v-spacer>
                <!-- <v-btn color="secondary" variant="flat" @click="hireWorker">
                    <v-icon left>mdi-account-check</v-icon>
                    Accept
                </v-btn> -->
            </v-card-actions>
        </v-card>

        <!-- Worker Info -->
        <v-row dense class="worker-stat-grid mb-4">
            <v-col cols="6" sm="6">
                <v-card class="worker-stat-card" elevation="0">
                    <v-icon color="orange" size="28">mdi-briefcase</v-icon>
                    <div class="worker-stat-copy"><strong>{{ worker.experience }}</strong><small>Experience</small></div>
                </v-card>
            </v-col>



            <v-col cols="6" sm="6">
                <v-card class="worker-stat-card" elevation="0">
                    <v-icon color="orange" size="28">mdi-currency-inr</v-icon>
                    <div class="worker-stat-copy"><strong>{{ worker.rate }}</strong><small>Daily Rate</small></div>
                </v-card>
            </v-col>

            <v-col cols="6" sm="6">
                <v-card class="worker-stat-card" elevation="0">
                    <v-icon color="orange" size="28">mdi-clock-outline</v-icon>
                    <div class="worker-stat-copy"><strong>{{ worker.availability }}</strong><small>Availability</small></div>
                </v-card>
            </v-col>
            <v-col cols="6" sm="6">
                <v-card class="worker-stat-card" elevation="0" @click="chat()">
                    <v-icon color="orange" size="28">mdi-mail</v-icon>
                    <div class="worker-stat-copy"><strong>Chat</strong><small>Send a Message</small></div>
                </v-card>
            </v-col>
            <v-col cols="12">
                <v-card class="worker-stat-card worker-address-card" elevation="0">
                    <v-icon color="orange" size="28">mdi-map-marker</v-icon>
                    <div class="worker-stat-copy"><strong>{{ worker.location }}</strong><small>Address</small></div>
                </v-card>
            </v-col>
        </v-row>

        <!-- Skills -->
        <v-card class="worker-skills-card" elevation="0">
            <h3 class="font-weight-bold mb-3">
                <v-icon left color="primary">mdi-tools</v-icon> Skills & Specializations
            </h3>
            <v-chip-group column>
                <v-chip v-for="( skill, i ) in  worker.skills " :key="i" color="primary" text-color="white"
                    class="ma-1">
                    <v-icon start small>mdi-hammer</v-icon>{{ skill.name }}
                </v-chip>
            </v-chip-group>
        </v-card>

        <!-- Work History -->
        <v-card class="worker-history-card" elevation="0">
            <div class="worker-history-summary" role="button" tabindex="0" @click="showHistory = !showHistory"
                @keydown.enter.prevent="showHistory = !showHistory">
                <v-icon class="worker-history-summary-icon" color="primary">mdi-history</v-icon>
                <div>
                    <h3 class="font-weight-bold">Work History</h3>
                    <p>View past work experience and projects</p>
                </div>
                <v-icon class="worker-history-chevron" color="primary">{{ showHistory ? 'mdi-chevron-up' : 'mdi-chevron-right' }}</v-icon>
            </div>

            <div v-if="showHistory" class="worker-history-entries">
            <v-card v-for="( exp, index ) in  experienceHistory " :key="index" class="worker-history-entry mb-3 pa-3 work-card" outlined
                shaped elevation="2">
                <!-- Header -->
                <div class="d-flex justify-space-between font-weight-medium mb-1">
                    <span class="primary--text"><strong>Project Name:</strong> {{ exp.project_name }}</span>
                    <span class="grey--text text--darken-1">{{ exp.start_date }} - {{ exp.end_date }}</span>
                </div>

                <!-- Employer / Company -->
                <div class="font-weight-medium">
                    <strong>Employer Name:</strong> {{ exp.employer_name }}
                </div>

                <!-- Work Type / Description -->
                <p class="mb-1"><strong>Descriptions:</strong> {{ exp.task_description }}</p>

                <!-- Skills -->
                <div>
                    <strong>Skills:</strong>
                    <v-chip-group column>
                        <v-chip v-for="skill in exp.skills" :key="skill" class="ma-1" color="" text-color="white" pill>
                            {{ skill.name }}
                        </v-chip>
                    </v-chip-group>
                </div>

                <!-- Payment & Rating -->
                <div class="d-flex justify-space-between mt-2">
                    <span><strong>Payment:</strong> {{ exp.total_amount }}</span>
                    <span><strong>Rating:</strong> {{ exp.rating }}/5</span>
                </div>
            </v-card>
            <p v-if="!experienceHistory.length" class="worker-history-empty">No work history added yet.</p>
            </div>
        </v-card>

        <!-- Reviews -->
        <!-- <v-card class="pa-4" outlined rounded="lg">
            <h3 class="font-weight-bold mb-3">
                <v-icon left color="primary">mdi-star</v-icon> Reviews
            </h3>
            <v-card v-for="(review, index) in worker.reviewsList" :key="index" class="mb-3 pa-3" outlined rounded="lg">
                <div class="d-flex justify-space-between mb-1">
                    <span class="font-weight-medium">{{ review.reviewer }}</span>
                    <div>
                        <v-icon v-for="n in review.stars" :key="n" color="amber" size="18">mdi-star</v-icon>
                    </div>
                </div>
                <p class="mb-1">{{ review.text }}</p>
                <small class="grey--text">{{ review.date }}</small>
            </v-card>
        </v-card> -->
    </v-container>
</template>

<script>
import BackButtonAppBar from "@/components/header/BackButtonAppBar.vue";
import api from "@/services/api.js";
import apiRoutes from "@/services/apiRoutes.js";

export default {
    components: { BackButtonAppBar },
    name: "AppliedWorkerDetail",
    data() {
        return {
            loading: false,
            showHistory: false,
            experienceHistory: [
            ],
            worker: {
                id: "",
                name: "",
                email: "",
                photo: "",
                phone: "",
                skill: "",
                experience: "",
                rate: "",
                availability: "",
                location: "",
                skills: [],

                reviewsList: [
                    // {
                    //     reviewer: "Amit Sharma",
                    //     stars: 5,
                    //     text: "Excellent work quality and punctual. Highly recommended!",
                    //     date: "2 days ago",
                    // },
                    // {
                    //     reviewer: "Sunil Verma",
                    //     stars: 4,
                    //     text: "Good work, but was slightly delayed on one project.",
                    //     date: "1 week ago",
                    // },
                ],
            },
        };
    },
    methods: {
        callWorker(phone) {
            window.location.href = `tel:${phone}`;
        },
        chat() {
            const targetId = this.worker.id || this.$route.params.id;
            if (targetId) {
                this.$router.push({ name: 'worker-chat', params: { id: targetId } });
            } else {
                this.$router.push({ name: 'worker-chat' });
            }
        },
        getInitials(name) {
            if (!name) return '';
            const parts = name.split(' ');
            if (parts.length === 1) return parts[0].charAt(0).toUpperCase();
            return (parts[0].charAt(0) + parts[1].charAt(0)).toUpperCase();
        },
        async getWorker() {
            this.loading = true;
            const id = this.$route.params.id;
            try {
                const res = await api.get(apiRoutes.employerWorkerGetWorkerByID + id);
                console.log("Success worker:", res.data);
                const data = res.data.worker;
                this.worker = {
                    id: data.id || this.$route.params.id,
                    name: data.profile?.name || "", // You may need to add 'name' field in API if missing
                    email: data.email || "",
                    photo: data.profile?.profile_image_url,
                    phone: data.phone || "",
                    skill: data.skill?.name || "", // if skill relation exists
                    rating: data.rating || 0, // default if rating exists
                    reviews: data.reviews || 0,
                    location: (data.profile?.district_detail?.district_name || "") +
                        " , " +
                        (data.profile?.state_detail?.state_name || ""),
                    experience: data.profile?.experience || "",
                    rate: data.profile?.rate || "",
                    availability: data.profile?.availability || "",
                    skills: data.profile?.skills || [], // Array of skills
                    // experienceHistory: data.profile?.experienceHistory || [],
                    age: data.profile?.age,
                    gender: data.profile?.gender,
                    email: data.email || "",
                };
                this.loading = false; // stop loading
            } catch (err) {
                alert(
                    "Error !!\n" +
                    Object.values(err.response?.data?.errors || {}).flat().join("\n")
                );
                console.error("Error fetching worker details:", err);
                this.loading = false; // stop loading
            }

        },
        async getWorkerHistory() {
            this.loading = true;
            const id = this.$route.params.id;
            try {
                const res = await api.get(apiRoutes.employerWorkerfetchAllWorkerJobHistory, { params: { worker_id: id } });
                console.log("Success worker history:", res.data);
                const data = res.data.data;
                this.experienceHistory = data;
                this.loading = false; // stop loading
            } catch (err) {
                alert(
                    "Error !!\n" +
                    Object.values(err.response?.data?.errors || {}).flat().join("\n")
                );
                console.error("Error fetching worker details:", err);
                this.loading = false; // stop loading
            }
        }
    },
    mounted() {
        this.getWorker(),
            this.getWorkerHistory()
    }
};
</script>

<style scoped>
.worker-detail-page{min-height:calc(100vh - 64px);padding:25px 18px 100px!important;background:#fff url('@/assets/authenticated-background.png') center/100% 100% no-repeat;color:#081d4d}.worker-hero-card{position:relative;width:min(860px,100%);margin:0 auto 22px;padding:52px 30px 26px;border-radius:24px!important;background:linear-gradient(145deg,#168ce9eF,#0755bdeF),url('@/assets/authenticated-background.png') center/cover;color:#fff;box-shadow:0 10px 22px #0751a63d!important;overflow:visible!important}.worker-status{position:absolute;top:24px;right:24px;display:flex;align-items:center;gap:9px;padding:8px 18px;border:1px solid #ffffff58;border-radius:24px;background:#0754a559;font-size:18px;font-weight:700}.worker-status i{width:16px;height:16px;border-radius:50%;background:#19db99;box-shadow:0 0 0 2px #fff}.worker-hero-card :deep(.v-row){display:flex;flex-direction:column;align-items:center;margin:0!important}.worker-hero-card :deep(.v-col){width:100%;max-width:none;padding:0!important;text-align:center}.worker-hero-avatar{border:4px solid #fff;box-shadow:0 4px 10px #052e743b}.worker-hero-card :deep(.v-col:nth-child(2)){margin-top:12px}.worker-hero-card p{margin:4px 0!important;font-size:20px}.worker-hero-card p:first-child{font-size:36px;line-height:1.1}.worker-hero-card p .v-icon{margin-right:10px}.worker-hero-card :deep(.v-card-actions){justify-content:center;margin-top:18px!important;padding:0!important}.worker-hero-card :deep(.v-card-actions .v-btn){width:min(285px,100%);height:62px;border-radius:32px;color:#1165c1;background:#fff;font-size:25px;font-weight:800}.worker-stat-grid{width:min(860px,100%);margin:0 auto!important}.worker-stat-grid :deep(.v-col){padding:0 8px 16px!important}.worker-stat-card{display:flex;align-items:center;gap:22px;min-height:122px;padding:18px 24px;border:1px solid #d5e6f5;border-radius:18px!important;background:#fffffff2!important;box-shadow:0 7px 16px #0c57931a!important;text-align:left;transition:transform .18s,box-shadow .18s}.worker-stat-card:hover{transform:translateY(-2px);box-shadow:0 9px 20px #0c579329!important}.worker-stat-card>.v-icon{display:grid;place-items:center;flex:0 0 72px;width:72px;height:72px;border-radius:50%;font-size:42px!important;color:#076bd3!important;background:#e3f2ff}.worker-stat-grid :nth-child(2) .worker-stat-card>.v-icon{color:#f07822!important;background:#fff0e8}.worker-stat-grid :nth-child(3) .worker-stat-card>.v-icon{color:#0ab47a!important;background:#e3fbf4}.worker-stat-card>div{margin:0!important;color:#071f52;font-size:30px;font-weight:800;line-height:1.1}.worker-stat-card small{display:block;color:#71809c;font-size:17px;margin-top:5px}.worker-address-card{justify-content:flex-start}.worker-address-card>div{font-size:23px!important}.worker-skills-card,.worker-history-card{width:min(860px,100%);margin:0 auto 22px;padding:25px 28px;border:1px solid #d5e6f5;border-radius:20px!important;background:#fffffff2!important;box-shadow:0 7px 16px #0c57931a!important}.worker-skills-card h3,.worker-history-card h3{display:flex;align-items:center;gap:10px;margin:0 0 18px;color:#0758ae;font-size:27px}.worker-skills-card h3 .v-icon,.worker-history-card h3 .v-icon{font-size:34px}.worker-skills-card :deep(.v-chip){height:auto;min-height:43px;padding:8px 17px;border-radius:24px;background:#e4f2ff!important;color:#16345f!important;font-size:16px}.worker-skills-card :deep(.v-chip .v-icon){color:#075fbd}.worker-history-entry{border:1px solid #d7e5f3!important;border-radius:14px!important;background:#fafdff!important}.worker-history-entry p,.worker-history-entry div{color:#31476b}.worker-history-entry .primary--text{color:#075bb8!important}.worker-history-card{margin-bottom:0}.worker-history-card>h3{color:#0758ae}
@media(max-width:650px){.worker-detail-page{padding:15px 10px 88px!important;background-size:auto 100%}.worker-hero-card{padding:48px 14px 21px;border-radius:19px!important}.worker-status{top:15px;right:14px;padding:5px 11px;font-size:13px}.worker-status i{width:11px;height:11px}.worker-hero-avatar{width:150px!important;height:150px!important}.worker-hero-card p{font-size:16px}.worker-hero-card p:first-child{font-size:27px}.worker-hero-card :deep(.v-card-actions .v-btn){height:49px;font-size:20px}.worker-stat-grid :deep(.v-col){padding:0 4px 9px!important}.worker-stat-card{min-height:90px;gap:10px;padding:12px 11px;border-radius:14px!important}.worker-stat-card>.v-icon{flex-basis:47px;width:47px;height:47px;font-size:28px!important}.worker-stat-card>div{font-size:23px}.worker-stat-card small{font-size:12px}.worker-address-card>div{font-size:17px!important}.worker-skills-card,.worker-history-card{padding:18px 14px;margin-bottom:14px;border-radius:16px!important}.worker-skills-card h3,.worker-history-card h3{font-size:21px}.worker-skills-card :deep(.v-chip){font-size:13px;min-height:35px;padding:5px 10px}.worker-history-entry{font-size:13px}}

/* Compact worker profile hero treatment: keep the card's existing footprint while
   matching the blue mountain panel used in the worker detail reference. */
.worker-hero-card{isolation:isolate;min-height:400px;padding:62px 28px 24px!important;background:linear-gradient(145deg,#168fe9 0%,#0875d5 48%,#0751b8 100%)!important;overflow:hidden!important}
.worker-hero-card::before{content:"";position:absolute;inset:0;z-index:0;background:linear-gradient(180deg,transparent 38%,rgba(4,70,157,.22) 100%),radial-gradient(ellipse at 14% 108%,rgba(6,51,127,.75) 0 20%,transparent 21%),radial-gradient(ellipse at 83% 108%,rgba(4,57,137,.68) 0 18%,transparent 19%);pointer-events:none}
.worker-hero-card::after{content:"";position:absolute;z-index:0;left:-4%;right:-4%;bottom:-1px;height:47%;opacity:.34;background:linear-gradient(135deg,transparent 0 12%,#0d61bd 12% 18%,transparent 18% 28%,#0d61bd 28% 35%,transparent 35% 45%,#0d61bd 45% 52%,transparent 52%),linear-gradient(33deg,transparent 0 17%,#063d97 17% 25%,transparent 25% 38%,#0a56aa 38% 46%,transparent 46%);clip-path:polygon(0 43%,8% 52%,16% 35%,24% 51%,34% 21%,44% 52%,55% 25%,65% 52%,75% 32%,85% 54%,93% 39%,100% 52%,100% 100%,0 100%);pointer-events:none}
.worker-hero-mountains{position:absolute;z-index:0;left:0;right:0;bottom:0;height:34%;opacity:.15;background:linear-gradient(135deg,transparent 0 37%,#fff 37% 39%,transparent 39% 48%,#fff 48% 50%,transparent 50%),linear-gradient(45deg,transparent 0 47%,#fff 47% 49%,transparent 49%);clip-path:polygon(0 64%,12% 50%,22% 65%,33% 27%,45% 64%,57% 39%,69% 66%,80% 34%,91% 63%,100% 49%,100% 100%,0 100%);pointer-events:none}
.worker-hero-card> :not(.worker-hero-mountains, .worker-status){position:relative;z-index:1}
.worker-status{z-index:2;background:rgba(2,67,153,.48)!important;border-color:rgba(255,255,255,.46)!important;box-shadow:inset 0 0 0 1px rgba(255,255,255,.08)}
.worker-hero-card :deep(.v-row){position:relative;z-index:1}
.worker-hero-avatar{width:150px!important;height:150px!important;border-width:4px!important;box-shadow:0 3px 9px rgba(2,38,94,.38)!important}
.worker-hero-card p{font-size:18px!important;font-weight:600;letter-spacing:.01em}
.worker-hero-card p:first-child{font-size:32px!important;font-weight:800;letter-spacing:.02em;text-transform:uppercase}
.worker-hero-card p .v-icon{font-size:24px!important;vertical-align:middle}
.worker-hero-card :deep(.v-card-actions){position:relative;z-index:1;margin-top:18px!important;padding:0!important}
.worker-hero-card :deep(.v-card-actions .v-btn){height:50px!important;width:min(285px,100%);border-radius:28px!important;font-size:23px!important;letter-spacing:.04em;box-shadow:0 3px 8px rgba(1,44,117,.2)}
.worker-hero-card :deep(.v-card-actions .v-btn .v-icon){font-size:25px!important}
@media(max-width:650px){.worker-hero-card{min-height:400px;padding:52px 14px 21px!important}.worker-hero-avatar{width:150px!important;height:150px!important}.worker-hero-card p{font-size:16px!important}.worker-hero-card p:first-child{font-size:27px!important}.worker-hero-card :deep(.v-card-actions .v-btn){height:49px!important;font-size:20px!important}}

/* Applied-worker detail reference layout */
.worker-detail-page{width:min(100%,980px)!important;max-width:980px!important;margin:0 auto!important;padding:28px 22px 110px!important;background-size:100% 100%!important}
.worker-hero-card{width:100%!important;min-height:468px!important;margin:0 auto 22px!important;padding:210px 28px 24px!important;border-radius:27px!important;background:linear-gradient(145deg,rgba(15,143,232,.97),rgba(5,74,181,.98)),url('@/assets/authenticated-background.png') center/cover!important;box-shadow:0 11px 22px rgba(4,67,146,.26)!important;overflow:visible!important}
.worker-hero-card>.v-card-title{display:none!important}
.worker-hero-mountains{height:46%!important;opacity:.27!important;background:linear-gradient(142deg,transparent 0 32%,rgba(112,184,247,.75) 32% 35%,transparent 35% 43%,rgba(11,89,191,.78) 43% 49%,transparent 49%),linear-gradient(38deg,transparent 0 28%,rgba(5,54,139,.86) 28% 36%,transparent 36% 48%,rgba(10,77,165,.78) 48% 57%,transparent 57%),linear-gradient(180deg,transparent 0 65%,rgba(4,47,126,.55) 65% 100%)!important;clip-path:polygon(0 42%,9% 55%,18% 37%,28% 57%,37% 25%,48% 57%,58% 34%,68% 58%,78% 30%,89% 56%,100% 40%,100% 100%,0 100%)!important}
.worker-hero-card::after{height:45%!important;opacity:.45!important;background:linear-gradient(160deg,transparent 0 45%,rgba(33,121,215,.8) 45% 49%,transparent 49% 61%,rgba(4,53,137,.8) 61% 100%)!important;clip-path:polygon(0 44%,10% 56%,20% 39%,31% 59%,42% 30%,53% 58%,64% 37%,76% 59%,87% 34%,100% 52%,100% 100%,0 100%)!important}
.worker-hero-content{position:static!important;display:flex;flex-direction:column;align-items:center;text-align:center}
.worker-hero-avatar{position:absolute!important;top:-44px;left:50%;z-index:2;transform:translateX(-50%);width:255px!important;height:255px!important;border:5px solid #fff!important;box-shadow:0 4px 12px rgba(0,36,92,.38)!important}
.worker-hero-details{display:flex;flex-direction:column;align-items:center;position:relative;z-index:2}
.worker-hero-card p{margin:5px 0!important;line-height:1.18;font-size:23px!important;font-weight:600!important}
.worker-hero-card p:first-child{font-size:38px!important;line-height:1.12;font-weight:800!important;letter-spacing:.015em;text-transform:uppercase}
.worker-hero-card p .v-icon{margin-right:12px;font-size:28px!important}
.worker-hero-tagline{position:absolute;right:34px;bottom:128px;z-index:2;color:rgba(255,255,255,.76);font-family:cursive;font-size:24px;line-height:1.12;transform:rotate(-8deg);text-align:center}
.worker-hero-tagline span{display:block;width:70px;height:4px;margin:10px auto 0;background:#9bc8f3;transform:rotate(-8deg)}
.worker-hero-card :deep(.v-card-actions){position:relative;z-index:2;justify-content:center;margin-top:27px!important;padding:0!important;border-top:1px solid rgba(255,255,255,.7)}
.worker-hero-card :deep(.v-card-actions .v-btn){width:285px!important;height:64px!important;margin-top:15px;border-radius:34px!important;color:#1260b9!important;background:#fff!important;font-size:27px!important;font-weight:800!important;letter-spacing:.02em;box-shadow:none!important}
.worker-hero-card :deep(.v-card-actions .v-btn .v-icon){font-size:28px!important;color:#1260b9!important}
.worker-stat-grid{width:100%!important;margin:0 auto 2px!important}
.worker-stat-grid :deep(.v-col){padding:0 8px 16px!important}
.worker-stat-card{min-height:140px!important;padding:19px 26px!important;gap:26px;border-radius:19px!important;background:rgba(255,255,255,.96)!important;box-shadow:0 7px 17px rgba(11,83,150,.14)!important}
.worker-stat-card>.v-icon{flex:0 0 74px;width:74px;height:74px;font-size:43px!important;background:#e4f2ff!important;color:#0969d2!important}
.worker-stat-grid :nth-child(2) .worker-stat-card>.v-icon{background:#fff0e7!important;color:#ef731d!important}
.worker-stat-grid :nth-child(3) .worker-stat-card>.v-icon{background:#e0faf2!important;color:#05b67c!important}
.worker-stat-grid :nth-child(4) .worker-stat-card>.v-icon{background:#e3f0ff!important;color:#086bd3!important}
.worker-stat-card>div{font-size:31px!important;line-height:1.08!important;color:#071d4d!important}
.worker-stat-card small{font-size:19px!important;color:#71809d!important;margin-top:5px!important}
.worker-address-card{position:relative;overflow:hidden;z-index:0;min-height:112px!important}
.worker-address-card::after{content:"";position:absolute;right:-2%;bottom:-20%;width:48%;height:145%;z-index:-1;opacity:.28;background:linear-gradient(150deg,transparent 0 30%,#b7dafd 30% 35%,transparent 35% 44%,#80baf0 44% 50%,transparent 50% 58%,#d0e7fd 58%);clip-path:polygon(0 51%,13% 37%,26% 55%,40% 27%,55% 51%,70% 35%,84% 56%,100% 40%,100% 100%,0 100%)}
.worker-address-card>.v-icon{position:relative;z-index:1}
.worker-address-card>div{position:relative;z-index:1;font-size:25px!important}
.worker-skills-card,.worker-history-card{width:100%!important;margin:0 auto 22px!important;padding:27px 29px!important;border-radius:21px!important;background:rgba(255,255,255,.96)!important;box-shadow:0 7px 17px rgba(11,83,150,.13)!important}
.worker-skills-card h3{display:flex;align-items:center;gap:10px;margin:0 0 17px!important;color:#075bb8!important;font-size:28px!important}
.worker-skills-card h3 .v-icon{font-size:37px!important}
.worker-skills-card :deep(.v-chip-group){display:flex;flex-wrap:wrap;gap:5px 14px}
.worker-skills-card :deep(.v-chip){height:auto;min-height:49px;margin:0!important;padding:9px 20px!important;border-radius:28px!important;background:#e3f1ff!important;color:#142d57!important;font-size:19px!important}
.worker-skills-card :deep(.v-chip .v-icon){color:#075fbd!important;font-size:22px!important}
.worker-history-card{padding:24px 29px!important}
.worker-history-summary{display:flex;align-items:center;gap:19px;cursor:pointer;user-select:none}
.worker-history-summary-icon{font-size:55px!important;color:#0969d2!important}
.worker-history-summary h3{margin:0!important;color:#075bb8!important;font-size:29px!important;line-height:1.15}
.worker-history-summary p{margin:5px 0 0;color:#71809d;font-size:19px}
.worker-history-chevron{margin-left:auto;font-size:38px!important;color:#56647d!important}
.worker-history-entries{margin-top:20px}
.worker-history-empty{margin:12px 0 0;color:#71809d;font-size:16px}
@media(max-width:650px){.worker-detail-page{padding:18px 10px 90px!important}.worker-hero-card{min-height:400px!important;padding:145px 14px 18px!important;border-radius:20px!important}.worker-hero-avatar{top:-27px;width:156px!important;height:156px!important;border-width:4px!important}.worker-status{top:14px;right:13px;padding:5px 11px;font-size:13px}.worker-status i{width:11px;height:11px}.worker-hero-card p{font-size:16px!important}.worker-hero-card p:first-child{font-size:26px!important}.worker-hero-card p .v-icon{font-size:21px!important;margin-right:7px}.worker-hero-tagline{right:15px;bottom:96px;font-size:13px}.worker-hero-tagline span{width:38px;height:2px;margin-top:5px}.worker-hero-card :deep(.v-card-actions){margin-top:17px!important}.worker-hero-card :deep(.v-card-actions .v-btn){width:220px!important;height:49px!important;margin-top:10px;font-size:20px!important}.worker-hero-card :deep(.v-card-actions .v-btn .v-icon){font-size:22px!important}.worker-stat-grid :deep(.v-col){padding:0 4px 9px!important}.worker-stat-card{min-height:101px!important;gap:10px;padding:12px 11px!important;border-radius:14px!important}.worker-stat-card>.v-icon{flex-basis:48px;width:48px;height:48px;font-size:28px!important}.worker-stat-card>div{font-size:22px!important}.worker-stat-card small{font-size:12px!important}.worker-address-card{min-height:83px!important}.worker-address-card>div{font-size:16px!important}.worker-skills-card,.worker-history-card{padding:18px 14px!important;margin-bottom:14px!important;border-radius:16px!important}.worker-skills-card h3{font-size:21px!important}.worker-skills-card h3 .v-icon{font-size:29px!important}.worker-skills-card :deep(.v-chip){font-size:13px!important;min-height:35px;padding:5px 10px!important}.worker-history-summary{gap:10px}.worker-history-summary-icon{font-size:43px!important}.worker-history-summary h3{font-size:21px!important}.worker-history-summary p{font-size:13px}.worker-history-chevron{font-size:29px!important}}
/* Keep the compact status badge independent of the centered profile content. */
.worker-hero-card > .worker-status {
    position: absolute;
    top: 18px;
    right: 18px;
    z-index: 3;
    display: inline-flex;
    width: max-content;
    align-items: center;
    gap: 5px;
    padding: 5px 9px;
    font-size: 12px;
    line-height: 16px;
    white-space: nowrap;
}

.worker-hero-card > .worker-status i {
    flex: 0 0 8px;
    width: 8px;
    height: 8px;
    box-shadow: 0 0 0 1px #fff;
}

@media (max-width: 650px) {
    .worker-hero-card > .worker-status {
        top: 12px;
        right: 10px;
        gap: 4px;
        padding: 4px 7px;
        font-size: 10px;
        line-height: 14px;
    }

    .worker-hero-card > .worker-status i {
        flex-basis: 7px;
        width: 7px;
        height: 7px;
    }
}

@media (max-width: 380px) {
    .worker-hero-card > .worker-status {
        /* The avatar narrows here, leaving room beside it on small phones. */
        top: 112px;
    }
}
</style>
