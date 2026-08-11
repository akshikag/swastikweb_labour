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
                        outlined :rules="[validateDocumentNumber]" @update:model-value="normalizeDocumentNumber"></v-text-field>

                    <v-file-input v-model="form.pdfFile" label="दस्तावेज़ अपलोड करें - Upload Document"
                        prepend-icon="mdi-upload" dense outlined accept=".pdf"
                        :rules="[fileSizeRule, fileTypeRule]"></v-file-input>

                    <v-text-field label="e-Shram Card Number" v-model="form.labourLicence" dense
                        outlined></v-text-field>

                    <v-btn block color="primary" large @click="submitForm">Save </v-btn>
                </v-card>
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
    pdf_url: "",
})



const docTypes = ref([
    { title: 'PAN Card', value: 'pancard' },
    { title: 'Driving License', value: 'driving_license' },
    { title: 'Voter ID', value: 'voterid' }
])

const workerData = JSON.parse(localStorage.getItem('labour_currentUser'))

onMounted(async () => {
    try {
        const res = await api.get(`${apiRoutes.workerGetWorkerByid}/${workerData.worker.id}`);
        console.log("Success:", res.data);

        const data = res.data.worker;
        // Populate form values safely
        form.value = {
            docType: data.profile?.docType || '',
            labourLicence: data.profile?.eshram || '',
            docNumber: data.profile?.docNumber || '',
            pdf_url: data.profile?.pdf_url || '',
        };

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
    const normalized = String(value ?? "").toUpperCase().replace(/[^A-Z0-9\s-]/g, "");
    if (form.value.docNumber !== normalized) {
        form.value.docNumber = normalized;
    }
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
            if (!/^[A-Z]{2}[0-9]{13}$/.test(cleaned)) {
                return 'Driving License must contain 2 letters followed by 13 digits.';
            }
            break;
        case 'voterid':
            if (!/^[A-Z]{3}[0-9]{7}$/.test(cleaned)) {
                return 'Voter ID must contain 3 letters followed by 7 digits.';
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
        const res = await api.put(apiRoutes.workerUpdate + '/' + workerData.worker.id, {

            docType: form.value.docType,
            docNumber: form.value.docNumber,
            eshram: form.value.labourLicence,
            pdf: base64Pdf,
        });

        console.log("Success:", res.data)

        router.push('/worker-dashboard-profile-location')

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
