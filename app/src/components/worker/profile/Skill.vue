<template>
    <BackButtonAppBar />
    <v-container class="fill-height d-flex align-center justify-center" fluid>
        <v-row>
            <v-col cols="12">
                <!-- skill -->
                <v-form v-model="valid" ref="skillForm" class="mb-4">
                    <v-card outlined class="py-4">
                        <v-card-title class="font-weight-bold">
                            कौशल सूचना * Skill Information
                        </v-card-title>
                        <v-card-text>
                            <!-- Skill Selection -->
                            <div class="mb-2">Select Skills:</div>
                            <v-select v-model="form.skill_id" :items="skills" item-title="name" item-value="id" multiple
                                chips label="Select Skill *" :rules="[v => (v || []).length > 0 || 'Select at least one skill']"
                                @update:model-value="markFormDirty" />

                            <v-text-field v-if="(form.skill_id || []).includes('other')" label="Specify other skills (comma separated)" v-model="form.other_skills"
                                :rules="[v => !(form.skill_id || []).includes('other') || !!String(v || '').trim() || 'Specify your other skills']"
                                @update:model-value="markFormDirty" class="mt-3" />

                            <!-- Experience Input -->
                            <v-text-field label="Experience (Years) *" v-model="form.experience" type="number"
                                :rules="[v => v !== '' || 'Experience is required', v => Number(v) >= 0 || 'Experience cannot be negative']"
                                @update:model-value="markFormDirty" class="mt-3" />

                            <!-- Preferred Work Type -->
                            <v-select label="Preferred Work Type *" v-model="form.workType"
                                :items="['Daily Wage', 'Contract']" :rules="[v => !!v || 'Please select work type']"
                                @update:model-value="markFormDirty" class="mt-3" />

                            <!-- Experience Input -->
                            <v-text-field label="Daily Rate (Rs) *" v-model="form.rate" type="number"
                                :rules="[v => !!v || 'Rate is required']" @update:model-value="markFormDirty" class="mt-3" />

                            <!-- Experience Input -->
                            <!-- Preferred Work Type -->
                            <v-select label="Select Availability for work *" v-model="form.availability"
                                :items="['Yes', 'No']" :rules="[v => !!v || 'Please select availability']"
                                @update:model-value="markFormDirty" class="mt-3" />



                        </v-card-text>



                        <v-btn class="mx-3" block color="primary" large @click="submitForm">Submit</v-btn>

                    </v-card>
                </v-form>


            </v-col>
        </v-row>
    </v-container>
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
            formHasUserInput: false,
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
        markFormDirty() {
            this.formHasUserInput = true;
        },
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
                // Do not replace a draft if the user started editing before this request completed.
                if (this.formHasUserInput) return;
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
            const { valid } = await this.$refs.skillForm.validate();
            if (valid) {
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
                    const selectedSkills = this.form.skill_id || [];
                    const skillIds = selectedSkills.filter(s => s !== 'other');
                    const payload = {
                        skill_id: skillIds,
                        experience: this.form.experience,
                        work_type: this.form.workType,
                        availability: this.form.availability,
                        rate: this.form.rate,
                    };

                    // Only include this new field when it is actually needed. This also
                    // keeps normal skill updates compatible until the migration is run.
                    if (selectedSkills.includes('other')) {
                        payload.other_skills = this.form.other_skills.trim();
                    }

                    await api.put(apiRoutes.workerUpdate + '/' + workerData.worker.id, payload);

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


<style></style>
