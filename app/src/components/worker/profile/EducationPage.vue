<template>
    <BackButtonAppBar />

    <v-container class="education-page" fluid>
        <div class="education-title">My Education Details</div>
        <div class="education-title-rule"></div>
        <v-row class="education-layout">
            <v-col cols="12" class="text-center">

                <!-- ADD EDUCATION -->
                <v-card class="education-card education-form-card" elevation="0">
                    <v-row dense class="education-form-grid">
                        <v-col cols="12">
                            <label class="education-label">Education Level <b>*</b></label><v-select v-model="newEducation.level" :items="educationLevels"
                                variant="outlined" density="comfortable" hide-details />
                        </v-col>

                        <v-col cols="12">
                            <div class="education-field-row"><span class="education-field-icon"><v-icon>mdi-bank</v-icon></span><div class="education-field-control"><label class="education-label">Institution / School / College <b>*</b></label><v-text-field v-model="newEducation.institution"
                                variant="outlined" density="comfortable" hide-details />
                            </div></div>
                        </v-col>

                        <v-col cols="12">
                            <div class="education-field-row"><span class="education-field-icon"><v-icon>mdi-calendar-month</v-icon></span><div class="education-field-control"><label class="education-label">Passing Year <b>*</b></label><v-text-field v-model="newEducation.year" type="number"
                                variant="outlined" density="comfortable" hide-details />
                            </div></div>
                        </v-col>

                        <v-col cols="12">
                            <div class="education-field-row"><span class="education-field-icon"><v-icon>mdi-file-upload</v-icon></span><div class="education-field-control"><label class="education-label">Upload Certificate</label><v-file-input v-model="newEducation.file"
                                variant="outlined" density="comfortable" hide-details
                                accept=".pdf,.jpg,.jpeg,.png" />
                            </div></div>
                        </v-col>

                        <v-col cols="12">
                            <v-btn color="primary" block class="education-add-button" @click="addEducation">
                                <v-icon start>mdi-plus</v-icon> Add Education
                            </v-btn>
                        </v-col>
                    </v-row>
                </v-card>

                <!-- EDUCATION LIST -->
                <v-card class="education-card uploaded-card" elevation="0">
                    <h3 class="uploaded-title"><span class="uploaded-icon"><v-icon>mdi-file-document</v-icon></span>Uploaded Education Details</h3>

                    <v-row dense>
                        <v-col cols="12" v-for="(edu, index) in educationList" :key="index" class="mb-3">
                            <v-card class="education-record pa-3" outlined>
                                <v-row align="center" justify="space-between">
                                    <v-col cols="auto">
                                        <h4 class="mb-1">{{ edu.education_level }}</h4>
                                        <p class="mb-0 text-caption">
                                            {{ edu.institution }} ({{ edu.passing_year }})
                                        </p>
                                    </v-col>

                                    <v-col cols="auto" class="d-flex align-center">
                                        <v-btn v-if="edu.certificate" color="green" size="small" variant="tonal"
                                            @click="viewCertificate(edu)">
                                            <v-icon left>mdi-eye</v-icon> View
                                        </v-btn>

                                        <v-btn color="red" size="small" variant="tonal" class="ml-2"
                                            @click="deleteEducation(edu)">
                                            <v-icon left>mdi-delete</v-icon> Delete
                                        </v-btn>
                                    </v-col>
                                </v-row>
                            </v-card>
                        </v-col>
                    </v-row>
                    <!-- v-model -->
                    <div v-if="educationList.length === 0" class="education-empty">
                        <v-icon size="56">mdi-file-document-outline</v-icon>
                        No education records added yet.
                    </div>
                </v-card>
                <v-dialog v-model="showModal" max-width="900px">
                    <v-card>
                        <v-card-title class="d-flex justify-space-between">
                            Certificate
                            <v-btn icon @click="showModal = false">
                                <v-icon>mdi-close</v-icon>
                            </v-btn>
                        </v-card-title>

                        <v-card-text>
                            <iframe v-if="selectedCertificate" :src="selectedCertificate" width="100%" height="500px"
                                style="border:none;">
                            </iframe>
                        </v-card-text>
                    </v-card>
                </v-dialog>

            </v-col>
        </v-row>
    </v-container>
</template>

<script>
import BackButtonAppBar from "@/components/header/BackButtonAppBar.vue";
import api from "@/services/api";
import apiRoutes from "@/services/apiRoutes";


export default {
    name: "EducationPage",
    components: { BackButtonAppBar },

    data() {
        return {
            educationLevels: [
                "8th",
                "10th",
                "12th",
                "Graduation",
                "Post Graduation",
                "Diploma",
                "Technical Certificate",
                "Other",
            ],

            newEducation: {
                level: "",
                institution: "",
                year: "",
                file: null,
            },

            educationList: [],
            showModal: false,
            selectedCertificate: null,
        };
    },

    methods: {
        async addEducation() {
            if (
                !this.newEducation.level ||
                !this.newEducation.institution ||
                !this.newEducation.year
            ) {
                alert("Please fill all required fields.");
                return;
            }

            let base64File = null;

            if (this.newEducation.file) {
                base64File = await this.toBase64(this.newEducation.file);
            }

            try {
                const workerData = JSON.parse(localStorage.getItem("labour_currentUser"));

                const res = await api.post(apiRoutes.workerAddEducation, {
                    worker_id: workerData.worker.id,
                    education_level: this.newEducation.level,
                    institution: this.newEducation.institution,
                    passing_year: this.newEducation.year,
                    certificate: base64File,
                });

                console.log("Saved:", res.data);

                alert("Education added successfully.");

                this.$router.push("/worker-dashboard-profile");

                this.newEducation = { level: "", institution: "", year: "", file: null };
            } catch (err) {
                console.log(err)
                alert(
                    "Error !!\n" +
                    Object.values(err.response?.data?.errors || {}).flat().join("\n")
                );
            }
        },

        viewCertificate(edu) {
            if (!edu.certificate) {
                alert("No certificate uploaded.");
                return;
            }

            this.selectedCertificate = edu.certificate;
            this.showModal = true;
        },
        async getEducation() {
            try {
                const workerData = JSON.parse(localStorage.getItem('labour_currentUser'))
                const res = await api.get(`${apiRoutes.workerGetEducation}/${workerData.worker.id}`);
                console.log('educations', res.data)
                if (res.data && res.data.data) {
                    this.educationList = res.data.data; // expected: [{id, name}]
                }
            } catch (error) {
                console.error("Error fetching educations:", error);
                alert("Failed to load educations.");
            }
        },

        deleteEducation(edu) {
            console.log(edu);
            if (!confirm("Are you sure you want to delete this education?")) {
                return;
            }
            const workerData = JSON.parse(localStorage.getItem('labour_currentUser'))
            api.delete(apiRoutes.workerDeleteEducation + '/' + workerData.worker.id + "/" + edu.id)
                .then((response) => {
                    if (response.data.success) {
                        alert("Education deleted successfully");
                        this.getEducation();
                    } else {
                        alert("Failed to delete");
                    }
                })
                .catch((error) => {
                    console.error(error);
                    alert("Something went wrong");
                });
        },
        // Convert file → Base64
        toBase64(file) {
            return new Promise((resolve, reject) => {
                const reader = new FileReader();
                reader.readAsDataURL(file);
                reader.onload = () => resolve(reader.result);
                reader.onerror = reject;
            });
        },
    },
    mounted() {
        this.getEducation();
    }

};
</script>

<style scoped>
.education-page{min-height:calc(100vh - 64px);padding:34px 14px 100px;background:#fff url('@/assets/authenticated-background.png') center top/100% 100% no-repeat;color:#071b58}
.education-layout{max-width:920px;margin:0 auto}.education-title{text-align:center;font-size:clamp(32px,4vw,52px);font-weight:800;margin:8px 0 12px}.education-title-rule{width:100px;height:8px;border-radius:8px;background:#ffb092;margin:0 auto 28px}.education-card{border-radius:24px!important;background:#fffffff2!important;box-shadow:0 8px 24px #163e711a!important;padding:28px 32px!important;margin-bottom:24px}.education-form-grid{row-gap:4px}.education-form-card :deep(.v-label){font-size:18px;font-weight:600;color:#102752;opacity:1}.education-form-card :deep(.v-field){border:1px solid #bad0e8;border-radius:14px;background:#f8fbff;min-height:64px}.education-form-card :deep(.v-field__input){font-size:19px;padding-inline:18px}.education-form-card :deep(.v-field__prepend-inner){color:#294465}.education-form-card :deep(.v-file-input .v-field__input){padding-inline-start:18px}.education-add-button{height:68px!important;border-radius:16px;font-size:25px!important;font-weight:800;letter-spacing:.2px;margin-top:10px}.uploaded-title{display:flex;align-items:center;gap:20px;font-size:30px;margin:0 0 22px;font-weight:800}.uploaded-icon{display:grid;place-items:center;width:72px;height:72px;border-radius:50%;background:#e5f2ff;color:#0768d5}.uploaded-icon .v-icon{font-size:38px}.education-record{border-radius:16px!important;border-color:#d5e3f2!important;background:#fbfdff!important}.education-empty{display:flex;flex-direction:column;align-items:center;justify-content:center;min-height:150px;border-radius:16px;background:#f3f7fc;color:#596a87;font-size:22px;gap:10px}.education-empty .v-icon{color:#aab8cb}.v-card{transition:.2s ease-in-out}.v-card:hover{transform:translateY(-2px)}
@media(max-width:650px){.education-page{padding:15px 8px 82px;background-size:auto 100%}.education-title{font-size:30px;margin-top:5px}.education-title-rule{height:5px;width:70px;margin-bottom:17px}.education-card{padding:18px 14px!important;border-radius:18px!important}.education-form-card :deep(.v-label){font-size:15px}.education-form-card :deep(.v-field){min-height:48px;border-radius:11px}.education-form-card :deep(.v-field__input){font-size:15px;min-height:46px;padding-inline:12px}.education-add-button{height:52px!important;font-size:17px!important;border-radius:12px}.uploaded-title{font-size:22px;gap:10px}.uploaded-icon{width:48px;height:48px}.uploaded-icon .v-icon{font-size:27px}.education-empty{font-size:16px;min-height:120px}.education-empty .v-icon{font-size:42px!important}}
.education-label{display:block;text-align:left;font-size:18px;font-weight:600;color:#102752;margin:4px 0 8px}.education-label b{color:#e3262e}
.education-form-card :deep(.v-field__prepend-inner .v-icon){color:#294465;font-size:25px}.education-form-card :deep(.v-select .v-field__append-inner .v-icon){color:#19365b;font-size:28px}
.education-field-row{display:flex;align-items:flex-end;gap:18px}.education-field-icon{flex:0 0 70px;width:70px;height:70px;margin-bottom:1px;border-radius:16px;display:grid;place-items:center;background:#e5f2ff;color:#126bd0}.education-field-icon .v-icon{font-size:34px}.education-field-control{flex:1;min-width:0}.education-field-control :deep(.v-field__prepend-inner){display:none}
@media(max-width:650px){.education-field-row{gap:10px}.education-field-icon{flex-basis:42px;width:42px;height:42px;border-radius:11px}.education-field-icon .v-icon{font-size:23px}}
</style>
