<template>
    <BackButtonAppBar />
    <v-container class="fill-height d-flex align-center justify-center" fluid>
        <v-row>
            <v-col cols="12" class="text-center mb-4">
                <!-- Identity & Verification -->
                <v-card outlined class="pa-4 mb-4">
                    <h4 class="mb-3">पहचान और सत्यापन - Identity & Verification</h4>
                    <v-alert type="info" variant="tonal" color="orange">
                        सत्यापन लंबित - Verification Pending
                    </v-alert>

                    <v-select label="दस्तावेज़ प्रकार - Document Type *" v-model="form.docType" :items="docTypes"
                        item-title="title" item-value="value" color="primary" required></v-select>

                    <v-text-field label="दस्तावेज़ नंबर - Document Number *" v-model="form.docNumber" dense
                        outlined :rules="[validateDocumentNumber]" @input="normalizeDocumentNumber"></v-text-field>

                    <v-file-input v-model="form.pdfFile" label="दस्तावेज़ अपलोड करें - Upload Document"
                        prepend-icon="mdi-upload" dense outlined accept=".pdf"
                        :rules="[fileSizeRule, fileTypeRule]"></v-file-input>

                    <v-avatar size="120" class="my-3">
                        <!-- PDF Icon -->
                        <v-btn v-if="pdfUrl" icon color="red" @click="openPdf(pdfUrl)"
                            style="width: 120px; height: 120px; overflow: hidden;">
                            <embed :src="pdfUrl" type="application/pdf"
                                style="width: 100%; height: 100%; object-fit: cover; pointer-events: none;" />
                        </v-btn>

                        <v-icon v-else size="64" color="grey">
                            mdi-file-pdf-box
                        </v-icon>
                    </v-avatar>

                    <v-text-field label="श्रम लाइसेंस (वैकल्पिक) - Labour Licence (Optional)"
                        v-model="form.labourLicence" dense outlined></v-text-field>

                    <v-btn block color="primary" large @click="submitForm">Save </v-btn>
                </v-card>
                <!-- PDF Viewer Modal -->
                <v-dialog v-model="pdfDialog" width="800">
                    <v-card>
                        <v-card-title class="headline d-flex justify-space-between">View Document
                            <v-btn icon @click="pdfDialog = false">
                                <v-icon>mdi-close</v-icon>
                            </v-btn>
                        </v-card-title>

                        <v-card-text>
                            <iframe v-if="selectedPdf" :src="selectedPdf" width="100%" height="600px"></iframe>
                        </v-card-text>
                    </v-card>
                </v-dialog>
            </v-col>
        </v-row>

    </v-container>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import BackButtonAppBar from "@/components/header/BackButtonAppBar.vue";
import api from "@/services/api.js";
import apiRoutes from "@/services/apiRoutes.js";

const router = useRouter()

const form = ref({
    docType: '',
    docNumber: '',
    labourLicence: '',
    pdfFile: null,
    // pdf_url: "",
})

const pdfUrl = ref(null);          // URL returned from API
const pdfDialog = ref(false);      // Modal state
const selectedPdf = ref(null);     // PDF to view

// -------- OPEN PDF IN MODAL --------
const openPdf = (url) => {
    selectedPdf.value = url;
    pdfDialog.value = true;
};



const docTypes = ref([
    { title: 'PAN Card', value: 'pancard' },
    { title: 'Driving License', value: 'driving_license' },
    { title: 'Voter ID', value: 'voterid' }
])

function viewCertificate(file) {
    if (!file) {
        alert("No File.");
        return;
    }

    showModal.value = true;
}

const employerData = JSON.parse(localStorage.getItem('labour_currentUser'))

onMounted(async () => {
    try {
        const res = await api.get(`${apiRoutes.employerGetById}/${employerData.employer.id}`);
        console.log("Success:", res.data);

        const data = res.data.employer;
        // Populate form values safely
        form.value = {
            docType: data.profile?.docType || '',
            labourLicence: data.profile?.eshram || '',
            docNumber: data.profile?.docNumber || '',
            // pdf_url: data.profile?.profile_doc_base64 || '',
        };
        pdfUrl.value = data.profile?.profile_doc_base64 || '';

    } catch (err) {
        const validationErrors = Object.values(err.response?.data?.errors || {}).flat().join("\n");
        const message = validationErrors || err.response?.data?.message || err.message || "Unable to save identity details.";
        alert("Error !!\n" + message);
        console.error("Identity verification error:", err);
    }
});


// -------------------------------------------
const MAX_SIZE_MB = 2; // 2 MB

// Rule to check file type
const getSelectedFile = (value) => Array.isArray(value) ? value[0] : value;

const fileTypeRule = (value) => {
    const file = getSelectedFile(value);
    if (!file) return true;
    return file.type === "application/pdf" || "Only PDF files are allowed.";
};

// Rule to check file size
const fileSizeRule = (value) => {
    const file = getSelectedFile(value);
    if (!file) return true;
    return file.size / 1024 / 1024 <= MAX_SIZE_MB || "File must be smaller than " + MAX_SIZE_MB + " MB.";
};

function normalizeDocumentNumber(value) {
    if (!value) return;
    const normalized = String(value).trim().toUpperCase();
    form.value.docNumber = normalized;
}

function validateDocumentNumber(value) {
    const input = String(value || '').trim();

    if (!input) {
        return 'Please enter the document number.';
    }

    const normalized = input.toUpperCase();
    const cleaned = normalized.replace(/[-\s]/g, '');

    switch (form.value.docType) {
        case 'pancard':
            if (!/^[A-Z]{5}[0-9]{4}[A-Z]$/.test(cleaned)) {
                return 'PAN must be 10 characters: 5 letters, 4 digits, and 1 letter.';
            }
            break;
        case 'driving_license':
            if (!/^[A-Z0-9]{5,20}$/.test(cleaned)) {
                return 'Driving License should be 5–20 alphanumeric characters.';
            }
            break;
        case 'voterid':
            if (!/^[A-Z0-9]{8,12}$/.test(cleaned)) {
                return 'Voter ID should be 8–12 alphanumeric characters.';
            }
            break;
        default:
            return 'Please select a document type first.';
    }

    return true;
}

// Convert PDF to Base64


async function submitForm() {
    if (!form.value.docType) {
        alert('Please select a Document Type.');
        return false;
    }

    const docValidationMessage = validateDocumentNumber(form.value.docNumber);
    if (docValidationMessage !== true) {
        alert(docValidationMessage);
        return false;
    }

    // if (!labourLicence) {
    //     alert('Please enter the Eshram no.');
    //     return false;
    // }

    let base64Pdf = null;
    const selectedFile = getSelectedFile(form.value.pdfFile);

    try {
        if (selectedFile) {
            const typeError = fileTypeRule(selectedFile);
            const sizeError = fileSizeRule(selectedFile);
            if (typeError !== true || sizeError !== true) {
                alert(typeError !== true ? typeError : sizeError);
                return false;
            }
            base64Pdf = await toBase64(selectedFile);
        }
        const res = await api.put(apiRoutes.employerUpdate + '/' + employerData.employer.id, {

            docType: form.value.docType,
            docNumber: form.value.docNumber,
            eshram: form.value.labourLicence,
            pdf: base64Pdf,
        });

        console.log("Success:", res.data)

        router.push('/employer-dashboard-profile-location')

    } catch (err) {
        alert(
            "Error !!\n" +
            Object.values(err.response?.data?.errors || {}).flat().join("\n")
        )
        console.error("Error login:", err)
    }
}

// Convert File to Base64
const toBase64 = (file) => {
    return new Promise((resolve, reject) => {
        const reader = new FileReader();
        reader.onload = () => resolve(reader.result);
        reader.onerror = () => reject(new Error("The selected PDF could not be read. Please select it again."));
        reader.onabort = () => reject(new Error("PDF reading was cancelled. Please select it again."));
        reader.readAsDataURL(file);
    });
};


</script>

<style></style>
