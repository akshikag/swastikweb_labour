<template>
    <BackButtonAppBar />
    <main class="identity-page">
        <header class="identity-heading">
            <h1>पहचान और सत्यापन -<br /><span>Identity &amp; Verification</span></h1>
            <div class="heading-rule" aria-hidden="true"><span></span><i></i><span></span></div>
        </header>

        <v-card class="identity-form-card" elevation="0">
            <v-alert class="pending-alert" type="info" variant="tonal">
                <strong>सत्यापन लंबित - Verification Pending</strong>
            </v-alert>

            <div class="identity-field">
                <span class="identity-icon"><v-icon icon="mdi-file-document" /></span>
                <div class="identity-control">
                    <label>दस्तावेज़ प्रकार - Document Type <b>*</b></label>
                    <v-select v-model="form.docType" :items="docTypes" item-title="title" item-value="value"
                        placeholder="Select document type" variant="outlined" hide-details="auto" required />
                </div>
            </div>

            <div class="identity-field">
                <span class="identity-icon identity-hash">#</span>
                <div class="identity-control">
                    <label>दस्तावेज़ नंबर - Document Number <b>*</b></label>
                    <v-text-field v-model="form.docNumber" placeholder="Enter document number"
                        variant="outlined" hide-details="auto" :rules="[validateDocumentNumber]"
                        @input="normalizeDocumentNumber" />
                </div>
            </div>

            <div class="identity-field upload-field">
                <span class="identity-icon"><v-icon icon="mdi-upload" /></span>
                <div class="identity-control">
                    <label>दस्तावेज़ अपलोड करें - Upload Document</label>
                    <v-file-input v-model="form.pdfFile" placeholder="Choose PDF document" prepend-icon=""
                        variant="outlined" hide-details="auto" accept=".pdf,application/pdf"
                        :rules="[fileSizeRule, fileTypeRule]" />
                    <small>PDF (Max 2 MB)</small>

                    <button v-if="pdfUrl" class="pdf-preview" type="button" @click="openPdf(pdfUrl)">
                        <v-icon icon="mdi-file-pdf-box" />
                        <span>View uploaded document</span>
                    </button>
                </div>
            </div>

            <div class="identity-field">
                <span class="identity-icon"><v-icon icon="mdi-card-account-details" /></span>
                <div class="identity-control">
                    <label>श्रम लाइसेंस (वैकल्पिक) - Labour Licence (Optional)</label>
                    <v-text-field v-model="form.labourLicence" placeholder="Enter labour licence number"
                        variant="outlined" hide-details="auto" />
                </div>
            </div>

            <v-btn class="employer-primary-action identity-save" block @click="submitForm">
                Save <v-icon icon="mdi-arrow-right" />
            </v-btn>
        </v-card>

        <v-dialog v-model="pdfDialog" width="800">
            <v-card class="pdf-dialog-card">
                <v-card-title class="d-flex justify-space-between align-center">
                    View Document
                    <v-btn icon="mdi-close" variant="text" @click="pdfDialog = false" />
                </v-card-title>
                <v-card-text>
                    <iframe v-if="selectedPdf" :src="selectedPdf" title="Uploaded identity document"
                        width="100%" height="600"></iframe>
                </v-card-text>
            </v-card>
        </v-dialog>
    </main>
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

<style scoped>
.identity-page {
    min-height: calc(100vh - 100px);
    padding: 24px 10px 100px;
    color: #082566;
    background: #fff url('@/assets/authenticated-background.png') center/100% 100% no-repeat;
}

.identity-heading { margin: 0 auto 29px; text-align: center; }
.identity-heading h1 { margin: 0; color: #102966; font-size: clamp(28px, 4vw, 46px); font-weight: 800; line-height: 1.18; }
.identity-heading h1 span { color: #102966; }
.heading-rule { display: flex; align-items: center; justify-content: center; width: min(360px, 82vw); margin: 18px auto 0; }
.heading-rule span { flex: 1; height: 2px; background: #0b68d7; }
.heading-rule i { width: 18px; height: 18px; border: 2px solid #0b68d7; background: #fff; transform: rotate(45deg); }

.identity-form-card {
    width: min(870px, 100%);
    margin: 0 auto;
    padding: 22px 22px 25px;
    border: 1px solid #82c2ff;
    border-radius: 23px !important;
    background: rgba(255, 255, 255, .95) !important;
    box-shadow: 0 8px 24px rgba(22, 118, 210, .11) !important;
}

.pending-alert { margin-bottom: 18px; border: 1px solid #77bfff !important; border-radius: 13px !important; background: #d9edff !important; color: #0864cf !important; font-size: clamp(16px, 2.2vw, 23px); }
.pending-alert :deep(.v-alert__prepend) { color: #0872da; }

.identity-field { display: flex; align-items: flex-start; gap: 18px; margin-bottom: 13px; padding: 15px 16px; border: 1px solid #badafb; border-radius: 17px; background: rgba(255, 255, 255, .92); }
.identity-icon { display: grid; place-items: center; flex: 0 0 58px; width: 58px; height: 58px; border-radius: 13px; color: #0869d8; background: #e3f2ff; }
.identity-icon .v-icon { font-size: 31px; }
.identity-hash { font-size: 35px; font-weight: 500; }
.identity-control { flex: 1; min-width: 0; text-align: left; }
.identity-control label { display: block; margin: 0 0 8px; color: #123881; font-size: clamp(17px, 2.1vw, 24px); font-weight: 800; line-height: 1.25; }
.identity-control label b { color: #f02727; }
.identity-control :deep(.v-field) { min-height: 58px; border-radius: 11px; color: #6d9bd2; background: #edf6ff; }
.identity-control :deep(.v-field__outline) { --v-field-border-opacity: 1; }
.identity-control :deep(.v-field__input) { min-height: 56px; padding-inline: 18px; color: #183e7a; font-size: 17px; }
.identity-control :deep(input::placeholder) { color: #8da3c2; opacity: 1; }
.identity-control :deep(.v-messages__message) { color: #d42834; font-size: 12px; }
.identity-control small { display: block; margin: 7px 0 0 10px; color: #7285a5; font-size: 12px; }
.upload-field .identity-control :deep(.v-field) { min-height: 64px; }

.pdf-preview { display: flex; align-items: center; gap: 8px; margin-top: 11px; padding: 7px 11px; border: 1px solid #ffc5c5; border-radius: 9px; color: #b51d27; background: #fff3f3; font: inherit; font-size: 13px; cursor: pointer; }
.pdf-preview .v-icon { font-size: 25px; }
.identity-save { margin-top: 4px; text-transform: uppercase; }
.identity-save .v-icon { margin-left: 14px; }
.pdf-dialog-card { border-radius: 18px !important; }
.pdf-dialog-card .v-card-title { color: #102966; font-weight: 800; }
.pdf-dialog-card iframe { border: 0; border-radius: 10px; }

@media (max-width: 650px) {
    .identity-page { padding: 18px 8px 90px; background-size: auto 100%; }
    .identity-heading { margin-bottom: 22px; }
    .identity-heading h1 { font-size: clamp(23px, 7vw, 30px); }
    .heading-rule { margin-top: 14px; }
    .identity-form-card { padding: 17px 10px 18px; border-radius: 18px !important; }
    .pending-alert { margin-bottom: 14px; font-size: 15px; }
    .identity-field { gap: 10px; margin-bottom: 12px; padding: 11px 9px; border-radius: 13px; }
    .identity-icon { flex-basis: 42px; width: 42px; height: 42px; border-radius: 10px; }
    .identity-icon .v-icon { font-size: 24px; }
    .identity-hash { font-size: 27px; }
    .identity-control label { margin-bottom: 5px; font-size: 14px; }
    .identity-control :deep(.v-field) { min-height: 52px; }
    .identity-control :deep(.v-field__input) { min-height: 50px; padding-inline: 12px; font-size: 14px; }
    .identity-control small { font-size: 11px; }
    .pdf-preview { font-size: 11px; }
}

@media (max-width: 370px) {
    .identity-heading h1 { font-size: 22px; }
    .identity-control label { font-size: 13px; }
}
</style>
