<template>
    <BackButtonAppBar />
    <main class="skill-page">
                <v-form v-model="valid" ref="skillForm" class="skill-form-card">
                        <div class="skill-heading"><span class="skill-heading-icon"><v-icon icon="mdi-briefcase" /></span><div><h1>कौशल सूचना - <span>Skill Information</span></h1><p>Tell us about your skills and work experience</p></div></div>
                            <!-- Skill Selection -->
                            <div class="skill-field"><span class="skill-icon"><v-icon icon="mdi-file-document" /></span><div class="skill-control"><label>Select Skill <b>*</b></label><v-select v-model="form.skill_id" :items="skills" item-title="name" item-value="id" multiple chips placeholder="Select Skill" variant="outlined" hide-details /></div></div>

                            <v-text-field v-if="(form.skill_id || []).includes('other')" label="Specify other skills (comma separated)" v-model="form.other_skills" variant="outlined" />

                            <!-- Experience Input -->
                            <div class="skill-field"><span class="skill-icon"><v-icon icon="mdi-calendar-month" /></span><div class="skill-control"><label>Experience (Years) <b>*</b></label><v-text-field v-model="form.experience" type="number" placeholder="Enter experience in years" variant="outlined" hide-details :rules="[v => v !== '' || 'Experience is required', v => Number(v) >= 0 || 'Experience cannot be negative']" /></div></div>

                            <!-- Preferred Work Type -->
                            <div class="skill-field"><span class="skill-icon"><v-icon icon="mdi-briefcase" /></span><div class="skill-control"><label>Preferred Work Type <b>*</b></label><v-select v-model="form.workType" :items="['Daily Wage', 'Contract']" placeholder="Select Work Type" variant="outlined" hide-details :rules="[v => !!v || 'Please select work type']" /></div></div>

                            <!-- Experience Input -->
                            <div class="skill-field"><span class="skill-icon rupee">₹</span><div class="skill-control"><label>Daily Rate (₹) <b>*</b></label><v-text-field v-model="form.rate" type="number" placeholder="Enter daily rate" variant="outlined" hide-details :rules="[v => !!v || 'Rate ie required !!']" /></div></div>

                            <!-- Experience Input -->
                            <!-- Preferred Work Type -->
                            <div class="skill-field"><span class="skill-icon"><v-icon icon="mdi-clock-outline" /></span><div class="skill-control"><label>Select Availability for Work <b>*</b></label><v-select v-model="form.availability" :items="['Yes', 'No']" placeholder="Select Availability" variant="outlined" hide-details :rules="[v => !!v || 'Please select work type']" /></div></div>



                        <v-btn class="skill-submit" type="submit" block @click="submitForm">Submit <v-icon end icon="mdi-arrow-right" /></v-btn>
                </v-form>
    </main>
</template>

<script>
import BackButtonAppBar from "@/components/header/BackButtonAppBar.vue";
import api from "@/services/api.js";
import apiRoutes from "@/services/apiRoutes.js";
export default {
    components: { BackButtonAppBar },
    data() {
        return {
            valid: false,
            skills: [],
            form: {
                skill_id: [],
                other_skills: '',
                age: '',
                experience: "",
                rate: "",
                availability: [],
                workType: [],
            },
        };
    },
    methods: {
        async getSkills() {
            try {
                this.loading = true;
                const res = await api.get(apiRoutes.getAllSkill);
                console.log('skills', res.data)
                if (res.data && res.data.data) {
                    // append an 'Other' option so user can enter freeform skills
                    this.skills = res.data.data.concat([{ id: 'other', name: 'Other' }]);
                }
            } catch (error) {
                console.error("Error fetching skills:", error);
                alert("Failed to load skills.");
            }
        },
        async getWoker() {
            try {
                const workerData = JSON.parse(localStorage.getItem('labour_currentUser'))
                const res = await api.get(`${apiRoutes.workerGetWorkerByid}/${workerData.worker.id}`);
                console.log("Success:", res.data);

                const data = res.data.worker;
                // Populate form values safely
                this.form = {
                    age: data.profile?.age || '',
                    experience: data.profile?.experience || '',         // use profile.name if exists
                    workType: data.profile?.work_type || '',                // email directly from data
                    skill_id: data.profile?.skill_id || [],               // phone directly from data
                    other_skills: data.profile?.other_skills || '',
                    availability: data.profile?.availability || '',
                    rate: data.profile?.rate || '',
                };

            } catch (err) {
                alert(
                    "Error !!\n" +
                    Object.values(err.response?.data?.errors || {}).flat().join("\n")
                );
                console.error("Error fetching worker details:", err);
            }
        },
        async submitForm() {
            if (this.$refs.skillForm.validate()) {
                //console.log("Form Submitted:", this.form);
                try {
                    const workerData = JSON.parse(localStorage.getItem('labour_currentUser'))
                    // if age is present, ensure it's greater than experience
                    if (this.form.age !== '' && this.form.age !== null && this.form.experience !== '' && this.form.experience !== null) {
                        if (Number(this.form.age) <= Number(this.form.experience)) {
                            alert('Age must be greater than experience.');
                            return;
                        }
                    }

                    // send numeric skill ids only; send any other_skills separately
                    const skillIds = (this.form.skill_id || []).filter(s => s !== 'other');
                    const res = await api.put(apiRoutes.workerUpdate + '/' + workerData.worker.id, {
                        skill_id: skillIds,
                        other_skills: this.form.other_skills || null,
                        experience: this.form.experience,
                        work_type: this.form.workType,
                        availability: this.form.availability,
                        rate: this.form.rate,
                    });

                    //console.log("Success:", res.data)
                    alert("Form submitted successfully!");
                    this.$router.push('/worker-dashboard-profile-workhistory')

                } catch (err) {
                    alert(
                        "Error !!\n" +
                        Object.values(err.response?.data?.errors || {}).flat().join("\n")
                    )
                    console.error("Error login:", err)
                }

            }
        },
    },
    mounted() {
        this.getSkills();
        this.getWoker();
    }
};
</script>


<style scoped>
.skill-page{min-height:calc(100vh - 100px);padding:28px 18px 100px;color:#082566;background:#fff url('@/assets/authenticated-background.png') center/100% 100% no-repeat}.skill-form-card{width:min(870px,100%);margin:0 auto;padding:34px 32px 28px;border:1px solid #a9d5ff;border-radius:23px;background:#fffffff2;box-shadow:0 8px 24px #1676d21c}.skill-heading{display:flex;align-items:center;gap:30px;margin:0 0 42px}.skill-heading-icon{display:grid;place-items:center;flex:0 0 86px;width:86px;height:86px;border-radius:50%;color:#0869d8;background:#e3f2ff}.skill-heading-icon .v-icon{font-size:47px}.skill-heading h1{margin:0;color:#122f6b;font-size:clamp(27px,3.8vw,45px);font-weight:800}.skill-heading h1 span{color:#123881}.skill-heading p{margin:6px 0 0;color:#667696;font-size:clamp(18px,2.4vw,27px)}.skill-field{display:flex;align-items:flex-start;gap:28px;margin-bottom:22px}.skill-icon{display:grid;place-items:center;flex:0 0 76px;width:76px;height:76px;margin-top:4px;border-radius:16px;color:#0869d8;background:#e3f2ff;font-size:42px;font-weight:700}.skill-icon .v-icon{font-size:42px}.skill-control{flex:1;min-width:0}.skill-control label{display:block;margin:0 0 8px;color:#123881;font-size:clamp(20px,2.4vw,29px);font-weight:800}.skill-control label b{color:#f02727}.skill-control :deep(.v-field){border-radius:12px;background:#f1f8ff}.skill-control :deep(.v-field__input){min-height:58px;padding-inline:28px;font-size:20px;color:#183e7a}.skill-control :deep(.v-chip){background:#d9edff;color:#075bb8}.skill-submit{height:66px!important;margin-top:8px;border-radius:14px;background:linear-gradient(110deg,#1688ed,#0867d6)!important;color:#fff;font-size:28px;font-weight:800;letter-spacing:.4px}.skill-submit .v-icon{font-size:34px}@media(max-width:650px){.skill-page{padding:20px 10px 90px}.skill-form-card{padding:22px 12px 18px;border-radius:18px}.skill-heading{gap:15px;margin-bottom:25px}.skill-heading-icon{flex-basis:58px;width:58px;height:58px}.skill-heading-icon .v-icon{font-size:32px}.skill-heading h1{font-size:23px}.skill-heading p{font-size:15px}.skill-field{gap:12px;margin-bottom:14px}.skill-icon{flex-basis:42px;width:42px;height:42px;margin-top:2px;border-radius:11px;font-size:26px}.skill-icon .v-icon{font-size:24px}.skill-control label{font-size:15px;margin-bottom:4px}.skill-control :deep(.v-field__input){min-height:30px!important;padding-inline:14px!important;font-size:14px!important}.skill-submit{height:52px!important;font-size:17px!important}.skill-submit .v-icon{font-size:25px}}
.skill-control :deep(.v-select .v-field),.skill-control :deep(.v-select .v-field__input){min-height:56px!important}.skill-control :deep(.v-select .v-field__input){padding-block:10px!important;align-items:center}
</style>
