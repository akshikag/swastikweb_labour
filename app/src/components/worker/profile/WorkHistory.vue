<template>
    <BackButtonAppBar />
    <v-container class="work-history-page" fluid>
        <v-card class="work-history-card" elevation="0">
            <div class="work-history-heading"><span class="work-heading-icon"><v-icon>mdi-hard-hat</v-icon></span><div><h1>Worker Experience/Work History</h1><p>Add your work experience details</p></div></div>
            <v-form ref="formRef" @submit.prevent="submitForm">
                <section v-for="(job, index) in workHistory" :key="index" class="work-entry">
                    <div class="work-field"><span class="work-field-icon"><v-icon>mdi-office-building</v-icon></span><div><label>Employer Name <b>*</b></label><v-text-field v-model="job.employer_name" placeholder="Enter employer name" required :rules="[v => !!v || 'Employer Name is required']" hide-details /></div></div>
                    <div class="work-field"><span class="work-field-icon"><v-icon>mdi-file-document</v-icon></span><div><label>Project Name <b>*</b></label><v-text-field v-model="job.project_name" placeholder="Enter project name" required :rules="[v => !!v || 'Project Name is required']" hide-details /></div></div>
                    <div class="work-field"><span class="work-field-icon"><v-icon>mdi-map-marker</v-icon></span><div><label>Work Place <b>*</b></label><v-text-field v-model="job.work_place" placeholder="Enter work place / site location" required :rules="[v => !!v || 'Work Place is required']" hide-details /></div></div>
                    <div class="work-field"><span class="work-field-icon"><v-icon>mdi-briefcase</v-icon></span><div><label>Work Type <b>*</b></label><v-text-field v-model="job.work_type" placeholder="Enter work type" required :rules="[v => !!v || 'Work Type is required']" hide-details /></div></div>
                    <div class="work-field"><span class="work-field-icon"><v-icon>mdi-hammer-wrench</v-icon></span><div><label>Skill</label><v-select v-model="job.skill_id" :items="skills" item-title="name" item-value="id" multiple chips clearable placeholder="Select skill" hide-details /></div></div>
                    <div class="work-field work-field--textarea"><span class="work-field-icon"><v-icon>mdi-text-box-outline</v-icon></span><div><label>Task Description</label><v-textarea v-model="job.task_description" placeholder="Enter task description" rows="3" hide-details /></div></div>
                    <div class="work-field"><span class="work-field-icon"><v-icon>mdi-calendar</v-icon></span><div><label>Start Date <b>*</b></label><v-text-field v-model="job.start_date" type="date" required :rules="[v => !!v || 'Start Date is required']" hide-details /></div></div>
                    <div class="work-field"><span class="work-field-icon"><v-icon>mdi-calendar</v-icon></span><div><label>End Date <b>*</b></label><v-text-field v-model="job.end_date" type="date" required :rules="[v => !!v || 'End Date is required']" hide-details /></div></div>
                    <div class="work-field"><span class="work-field-icon"><v-icon>mdi-timer-outline</v-icon></span><div><label>Days Worked <b>*</b></label><v-text-field v-model="job.days_worked" type="number" placeholder="Enter number of days" @input="calculateTotal(job)" required :rules="[v => !!v || 'Days Worked is required']" hide-details /></div></div>
                    <div class="work-field"><span class="work-field-icon"><v-icon>mdi-currency-inr</v-icon></span><div><label>Daily Wage <b>*</b></label><v-text-field v-model="job.daily_wage" type="number" placeholder="Enter daily wage (₹)" @input="calculateTotal(job)" required :rules="[v => !!v || 'Daily Wage is required']" hide-details /></div></div>
                    <div class="work-field"><span class="work-field-icon"><v-icon>mdi-cash-multiple</v-icon></span><div><label>Total Amount</label><v-text-field v-model="job.total_amount" type="number" placeholder="Enter total amount (₹)" readonly hide-details /></div></div>
                    <div class="work-field"><span class="work-field-icon"><v-icon>mdi-credit-card</v-icon></span><div><label>Payment Status <b>*</b></label><v-select v-model="job.payment_status" :items="['pending', 'paid', 'partial']" placeholder="Select payment status" :rules="[v => !!v || 'Payment Status is required']" required hide-details /></div></div>
                    <div class="work-field work-field--textarea"><span class="work-field-icon"><v-icon>mdi-comment-text-outline</v-icon></span><div><label>Remarks</label><v-textarea v-model="job.remarks" placeholder="Enter remarks" rows="2" hide-details /></div></div>
                    <div class="work-field"><span class="work-field-icon"><v-icon>mdi-star</v-icon></span><div><label>Rating (1-5)</label><div class="rating-control"><v-rating v-model="job.rating" color="primary" active-color="primary" hover size="30" density="comfortable" /></div></div></div>
                    <v-btn v-if="workHistory.length > 1" class="remove-work" variant="text" @click="removeJob(index)"><v-icon start>mdi-delete</v-icon>Remove</v-btn>
                </section>
                <div class="work-actions"><v-btn class="add-more-button" @click="addJob"><v-icon start>mdi-plus</v-icon>Add More</v-btn><v-btn class="submit-work-button" type="submit"><v-icon start>mdi-check</v-icon>Submit Work History</v-btn></div>
            </v-form>
        </v-card>
    </v-container>
</template>

<script setup>
import { ref, onMounted } from "vue";
import api from "@/services/api.js";
import apiRoutes from "@/services/apiRoutes.js";
import BackButtonAppBar from "@/components/header/BackButtonAppBar.vue";
import { useRouter } from 'vue-router'

const router = useRouter()

// Reactive array of jobs
const workHistory = ref([
    {
        employer_name: null,
        project_name: "",
        work_place: "",
        work_type: "",
        skill_id: null,
        task_description: "",
        start_date: "",
        end_date: "",
        days_worked: null,
        daily_wage: null,
        total_amount: null,
        payment_status: "",
        remarks: "",
        rating: null
    }
]);

const skills = ref([]);
onMounted(async () => {
    try {
        const res = await api.get(apiRoutes.getAllSkill);
        console.log('skills', res.data)
        if (res.data && res.data.data) {
            skills.value = res.data.data; // expected: [{id, name}]
        }
    } catch (error) {
        console.error("Error fetching skills:", error);
        alert("Failed to load skills.");
    }
});

// Add new job row
function addJob() {
    workHistory.value.push({
        employer_name: null,
        project_name: "",
        work_place: "",
        work_type: "",
        skill_id: [],
        task_description: "",
        start_date: "",
        end_date: "",
        days_worked: null,
        daily_wage: null,
        total_amount: null,
        payment_status: "",
        remarks: "",
        rating: null
    });
}

// Remove job row
function removeJob(index) {
    workHistory.value.splice(index, 1);
}

// Calculate total_amount dynamically
function calculateTotal(job) {
    const days = parseFloat(job.days_worked) || 0;
    const wage = parseFloat(job.daily_wage) || 0;
    job.total_amount = days * wage;
}

// Submit
async function submitForm() {
    const workerData = JSON.parse(localStorage.getItem('labour_currentUser'))
    try {
        // Validate required fields before sending
        for (const work of workHistory.value) {
            if (!work.employer_name || !work.employer_name.trim()) {
                alert('Please fill Employer Name for all entries');
                return false;
            }
            if (!work.project_name || !work.project_name.trim()) {
                alert('Please fill Project Name for all entries');
                return false;
            }
            if (!work.work_place || !work.work_place.trim()) {
                alert('Please fill Work Place for all entries');
                return false;
            }
            if (!work.work_type || !work.work_type.trim()) {
                alert('Please fill Work Type for all entries');
                return false;
            }
            if (!work.start_date) {
                alert('Please fill Start Date for all entries');
                return false;
            }
            if (!work.end_date) {
                alert('Please fill End Date for all entries');
                return false;
            }
            if (!work.days_worked) {
                alert('Please fill Days Worked for all entries');
                return false;
            }
            if (!work.daily_wage) {
                alert('Please fill Daily Wage for all entries');
                return false;
            }
            if (!work.payment_status) {
                alert('Please fill Payment Status for all entries');
                return false;
            }
        }

        const payload = workHistory.value.map(w => ({ ...w, worker_id: workerData.worker.id }));

        // Send all entries in one bulk request
        await api.post(apiRoutes.workerCreateJobHistory, payload);

        alert("Work history submitted successfully!");
        router.push('/worker-dashboard-profile-education')
    } catch (error) {
        console.error('Error submitting work history:', error);
        alert('Error submitting work history. Please try again.');
    }
}
</script>





<style scoped>
.work-history-page{min-height:calc(100vh - 64px);padding:32px 16px 105px;background:#fff url('@/assets/authenticated-background.png') center/100% 100% no-repeat;color:#102b62}.work-history-card{width:min(760px,100%);margin:0 auto;padding:30px 32px;border-radius:25px!important;background:#fffffff2!important;box-shadow:0 12px 28px #123f7221!important}.work-history-heading{display:flex;gap:20px;align-items:center;margin-bottom:24px;text-align:left}.work-heading-icon{display:grid;place-items:center;width:74px;height:74px;border-radius:50%;background:#e7f3ff;color:#075ecb}.work-heading-icon .v-icon{font-size:43px}.work-history-heading h1{margin:0;font-size:clamp(25px,3.4vw,38px);line-height:1.15;font-weight:800}.work-history-heading p{margin:5px 0 0;color:#70809d;font-size:18px}.work-entry{padding:10px 12px 14px;border-radius:18px;background:#ffffffd9}.work-field{display:flex;align-items:flex-end;gap:18px;padding:7px 0}.work-field>div{flex:1;min-width:0}.work-field-icon{display:grid;place-items:center;flex:0 0 58px;width:58px;height:58px;margin-bottom:1px;border-radius:14px;background:#eef6ff;color:#21527e}.work-field-icon .v-icon{font-size:30px}.work-field label{display:block;margin:0 0 5px;font-size:16px;font-weight:700;color:#112e65;text-align:left}.work-field label b{color:#dd2633}.work-field :deep(.v-field){min-height:50px;border:1px solid #c4d5ea;border-radius:10px;background:#fbfdff;box-shadow:none}.work-field :deep(.v-field__input){min-height:48px;padding-inline:14px;font-size:16px;color:#1d365e}.work-field :deep(.v-field__input input::placeholder),.work-field :deep(textarea::placeholder){color:#8090ab;opacity:1}.work-field :deep(.v-field__append-inner){color:#283d5f}.work-field :deep(.v-chip){background:#e1f0ff;color:#075dbd}.work-field--textarea{align-items:flex-start}.work-field--textarea .work-field-icon{margin-top:25px}.work-field--textarea :deep(textarea){min-height:78px;padding-top:12px}.remove-work{margin:8px 0 0 auto;color:#d22b3a}.work-actions{display:flex;align-items:center;gap:12px;margin-top:18px}.work-actions .v-btn{height:56px;border-radius:10px;font-size:17px;font-weight:800}.add-more-button{min-width:200px;background:#1180e6!important;color:#fff}.submit-work-button{flex:1;background:#238d3b!important;color:#fff}
@media(max-width:650px){.work-history-page{padding:15px 8px 82px;background-size:auto 100%}.work-history-card{padding:18px 12px;border-radius:18px!important}.work-history-heading{gap:12px;margin-bottom:15px}.work-heading-icon{width:54px;height:54px}.work-heading-icon .v-icon{font-size:31px}.work-history-heading h1{font-size:22px}.work-history-heading p{font-size:14px}.work-entry{padding:6px 0}.work-field{gap:10px;padding:5px 0}.work-field-icon{flex-basis:42px;width:42px;height:42px;border-radius:11px}.work-field-icon .v-icon{font-size:23px}.work-field label{font-size:14px;margin-bottom:3px}.work-field :deep(.v-field){min-height:37px;border-radius:8px}.work-field :deep(.v-field__input){min-height:35px;padding-inline:11px;font-size:14px}.work-field--textarea .work-field-icon{margin-top:22px}.work-field--textarea :deep(textarea){min-height:56px;padding-top:8px}.work-actions{flex-direction:column;gap:10px}.work-actions .v-btn{width:100%;height:50px;font-size:16px}.add-more-button{min-width:0}}
.work-field :deep(.v-field){min-height:58px;background:#f1f8ff}.work-field :deep(.v-field__input){min-height:58px}.work-field :deep(.v-select .v-field),.work-field :deep(.v-select .v-field__input){min-height:58px!important}.work-field :deep(.v-select .v-field__input){align-items:center}
@media(max-width:650px){.work-field :deep(.v-field){min-height:30px;background:#f1f8ff}.work-field :deep(.v-field__input){min-height:30px!important;padding-inline:14px!important;font-size:14px!important}.work-field :deep(.v-select .v-field),.work-field :deep(.v-select .v-field__input){min-height:30px!important}}
.work-field :deep(.v-field--variant-filled){border:2px solid #082f77!important;border-radius:10px!important;background:#eef6ff!important}.work-field :deep(.v-field--variant-filled .v-field__overlay){opacity:0!important}
.work-field :deep(.v-select .v-field){height:58px!important;min-height:58px!important}.work-field :deep(.v-select .v-field__input){height:58px!important;min-height:58px!important;align-items:center}.rating-control{display:flex;align-items:center;height:58px;padding:0 14px;border:2px solid #082f77;border-radius:10px;background:#eef6ff}.rating-control :deep(.v-rating){color:#9ab1c9}.rating-control :deep(.v-icon){font-size:30px}
@media(max-width:650px){.work-field :deep(.v-select .v-field){height:30px!important;min-height:30px!important;--v-field-input-padding-top:0px;--v-field-input-padding-bottom:0px}.work-field :deep(.v-select .v-field__input){height:30px!important;min-height:30px!important;padding-block:0!important;align-items:center}.rating-control{height:42px;padding:0 8px}.rating-control :deep(.v-icon){font-size:24px}}
/* Keep every Work History select at the requested fixed field height. */
.work-field :deep(.v-select .v-field){height:53px!important;min-height:53px!important;--v-field-input-padding-top:0px;--v-field-input-padding-bottom:0px}
.work-field :deep(.v-select .v-field__input){height:53px!important;min-height:53px!important;padding-block:8px!important;align-items:center}
</style>
