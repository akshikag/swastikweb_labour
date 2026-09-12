<template>
    <BackButtonAppBar />
    <main class="work-page">
        <v-card class="work-form-card" elevation="0">
            <header class="work-heading">
                <h1>कार्य विवरण - Work Details</h1>
                <div class="heading-rule" aria-hidden="true"><span></span><i></i><span></span></div>
            </header>

            <div class="work-field">
                <span class="work-icon"><v-icon icon="mdi-hard-hat" /></span>
                <div class="work-control">
                    <label>कार्य श्रेणी - Typical Work Category</label>
                    <v-select v-model="form.workCategory" multiple chips :items="workCategories"
                        item-title="name" item-value="id" placeholder="Select work category"
                        variant="outlined" hide-details="auto" />
                </div>
            </div>

            <div class="work-field">
                <span class="work-icon"><v-icon icon="mdi-account-group" /></span>
                <div class="work-control">
                    <label>प्रति माह औसत श्रमिक - Average Workers Hired per Month</label>
                    <v-select v-model="form.workerRange" :items="workerRanges" item-title="title"
                        item-value="value" placeholder="Select average workers"
                        variant="outlined" hide-details="auto" />
                </div>
            </div>

            <v-btn class="employer-primary-action work-save" block @click="submitForm">
                Save <v-icon icon="mdi-arrow-right" />
            </v-btn>
        </v-card>
    </main>
</template>

<script setup>
import { ref, onMounted } from "vue";
import BackButtonAppBar from "@/components/header/BackButtonAppBar.vue";
import api from "@/services/api.js";
import apiRoutes from "@/services/apiRoutes.js";
import { useRouter } from 'vue-router'


const form = ref({
    workCategory: [],
    workerRange: "",
});


const router = useRouter()
const workCategories = ref([
    // { title: "Construction", value: "construction" },
    // { title: "Manufacturing", value: "manufacturing" },
    // { title: "Service", value: "service" },
    // { title: "Agriculture", value: "agriculture" },
]);

const workerRanges = ref([
    { title: "1-10", value: "1-10" },
    { title: "11-50", value: "11-50" },
    { title: "51-100", value: "51-100" },
    { title: "100+", value: "100+" },
]);

async function submitForm() {
    //console.log(form.value);

    try {
        const employerData = JSON.parse(localStorage.getItem("labour_currentUser"));

        const res = await api.put(apiRoutes.employerUpdate + '/' + employerData.employer.id, {
            skills: form.value.workCategory,
            avg_worker: form.value.workerRange,

        });

        console.log("Success:", res.data)
        router.push('/employer-dashboard-home')

    } catch (err) {
        alert(
            "Error !!\n" +
            Object.values(err.response?.data?.errors || {}).flat().join("\n")
        )
        console.error("Error login:", err)
    }
}

async function getSkills() {
    try {
        const res = await api.get(apiRoutes.getAllSkill);
        console.log('skills', res.data)
        if (res.data && res.data.data) {
            workCategories.value = res.data.data; // expected: [{id, name}]
        }
    } catch (error) {
        console.error("Error fetching skills:", error);
        alert("Failed to load skills.");
    }
}


async function getData() {

    try {
        const employerData = JSON.parse(localStorage.getItem("labour_currentUser"));
        const res = await api.get(`${apiRoutes.employerGetById}/${employerData.employer.id}`);

        // console.log("Success: location -", res.data);

        const data = res.data.employer;
        // Populate form values safely
        form.value = {
            workCategory: data.skills.map(s => s.id),
            workerRange: data.profile?.avg_worker || ''
        };


    } catch (err) {
        alert(
            "Error !!\n" +
            Object.values(err.response?.data?.errors || {}).flat().join("\n")
        );
        console.error("Error fetching worker details:", err);
    }

}

onMounted(() => {
    getSkills(),
        getData()
})
</script>

<style scoped>
.work-page {
    min-height: calc(100vh - 100px);
    min-height: calc(100dvh - 100px);
    box-sizing: border-box;
    padding: clamp(34px, 7vh, 78px) 14px 100px;
    color: #082566;
    background-color: #fff;
    background-image: url('@/assets/authenticated-background.png');
    background-position: center top;
    background-repeat: no-repeat;
    background-size: 100% 100%;
}

.work-form-card {
    width: min(870px, 100%);
    margin: 0 auto;
    padding: 42px 44px 38px;
    border: 1px solid #d8e8f8;
    border-radius: 28px !important;
    background: rgba(255, 255, 255, .95) !important;
    box-shadow: 0 10px 28px rgba(18, 63, 114, .13) !important;
}

.work-heading { margin-bottom: 39px; text-align: left; }
.work-heading h1 { margin: 0; color: #102966; font-size: clamp(30px, 4.2vw, 47px); font-weight: 800; line-height: 1.18; }
.heading-rule { display: flex; align-items: center; width: min(360px, 72%); margin-top: 18px; }
.heading-rule span { flex: 1; height: 2px; background: #0b68d7; }
.heading-rule i { width: 18px; height: 18px; border: 2px solid #0b68d7; background: #fff; transform: rotate(45deg); }

.work-field {
    display: flex;
    align-items: center;
    gap: 20px;
    min-height: 125px;
    margin-bottom: 22px;
    padding: 18px 20px;
    border: 1px solid var(--app-form-input-border);
    border-radius: 16px;
    background: linear-gradient(115deg, #fff, var(--app-form-input-bg));
    box-shadow: 0 3px 10px rgba(16, 79, 147, .07);
}

.work-icon {
    display: grid;
    place-items: center;
    flex: 0 0 76px;
    width: 76px;
    height: 76px;
    padding-right: 18px;
    border-right: 1px solid #c9d8ea;
    color: #7b9abd;
}

.work-icon .v-icon { font-size: 45px; }
.work-control { flex: 1; min-width: 0; text-align: left; }
.work-control label { display: block; margin: 0 0 7px; color: var(--app-form-label); font-size: clamp(18px, 2.3vw, 25px); font-weight: 700; line-height: 1.28; }
.work-control :deep(.v-field) { min-height: 55px; border: 0; border-radius: 9px; color: var(--app-form-input-border); background: var(--app-form-input-bg); box-shadow: none; }
.work-control :deep(.v-field__outline) { --v-field-border-opacity: 0; }
.work-control :deep(.v-field__input) { min-height: 53px; padding-inline: 0 12px; color: var(--app-form-input-text); font-size: 17px; }
.work-control :deep(.v-field__append-inner) { color: #536987; }
.work-control :deep(.v-chip) { color: #075cb7; background: #d7ebff; }
.work-control :deep(input::placeholder) { color: var(--app-form-placeholder); opacity: 1; }

.work-save { margin-top: 30px; text-transform: uppercase; }
.work-save .v-icon { margin-left: 14px; }

@media (max-width: 650px) {
    .work-page { padding: 24px 8px 90px; }
    .work-form-card { padding: 27px 11px 20px; border-radius: 20px !important; }
    .work-heading { margin-bottom: 25px; padding-inline: 8px; text-align: center; }
    .work-heading h1 { font-size: clamp(23px, 7vw, 30px); }
    .heading-rule { width: 82%; margin: 14px auto 0; }
    .work-field { gap: 10px; min-height: 105px; margin-bottom: 13px; padding: 12px 10px; border-radius: 13px; }
    .work-icon { flex-basis: 45px; width: 45px; height: 58px; padding-right: 9px; }
    .work-icon .v-icon { font-size: 29px; }
    .work-control label { margin-bottom: 4px; font-size: 14px; }
    .work-control :deep(.v-field) { min-height: 50px; }
    .work-control :deep(.v-field__input) { min-height: 48px; font-size: 14px; }
    .work-control :deep(.v-chip) { height: 25px; font-size: 11px; }
    .work-save { margin-top: 20px; }
}

@media (max-width: 370px) {
    .work-heading h1 { font-size: 22px; }
    .work-control label { font-size: 13px; }
}
</style>
