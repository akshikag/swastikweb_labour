<template>
    <BackButtonAppBar />
    <main class="identity-page">
      <div class="identity-heading"><h1>पहचान और सत्यापन - <span>Identity &amp;<br class="mobile-break" /> Verification</span></h1><div class="heading-rule"><i></i></div></div>
      <v-form class="identity-form-card" @submit.prevent="submitForm">
        <v-alert class="pending-alert" type="info" variant="tonal" color="primary"><strong>सत्यापन लंबित - Verification Pending</strong></v-alert>
        <div class="identity-field"><span class="identity-icon"><v-icon icon="mdi-file-document" /></span><div class="identity-control"><label>दस्तावेज़ प्रकार - Document Type <b>*</b></label><v-select v-model="form.docType" :items="docTypes" item-title="title" item-value="value" placeholder="Select document type" variant="outlined" hide-details required /></div></div>
        <div class="identity-field"><span class="identity-icon"><v-icon icon="mdi-pound" /></span><div class="identity-control"><label>दस्तावेज़ नंबर - Document Number <b>*</b></label><v-text-field v-model="form.docNumber" placeholder="Enter document number" variant="outlined" hide-details :rules="[validateDocumentNumber]" @update:model-value="normalizeDocumentNumber" /></div></div>
        <div class="identity-field"><span class="identity-icon"><v-icon icon="mdi-upload" /></span><div class="identity-control"><label>दस्तावेज़ अपलोड करें - Upload Document</label><v-file-input v-model="form.pdfFile" accept=".pdf" placeholder="Click to upload or drag and drop" hint="PDF (Max 2 MB)" persistent-hint prepend-icon="" prepend-inner-icon="" variant="outlined" hide-details="auto" :rules="[fileSizeRule, fileTypeRule]" /></div></div>
        <div class="identity-field"><span class="identity-icon"><v-icon icon="mdi-card-account-details" /></span><div class="identity-control"><label>e-Shram Card Number</label><v-text-field v-model="form.labourLicence" placeholder="Enter e-Shram Card Number" variant="outlined" hide-details /></div></div>
        <v-btn class="identity-save" type="submit" block>Save <v-icon end icon="mdi-arrow-right" /></v-btn>
      </v-form>
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

<style scoped>
.identity-page{min-height:calc(100vh - 100px);padding:28px 18px 100px;color:#082566;background:#fff url('@/assets/authenticated-background.png') center/100% 100% no-repeat}.identity-heading{text-align:center;margin:3px auto 28px}.identity-heading h1{margin:0;color:#102966;font-size:clamp(28px,4vw,48px);font-weight:800;line-height:1.18}.identity-heading h1 span{color:#102966}.heading-rule{display:flex;justify-content:center;align-items:center;width:285px;margin:18px auto 0;border-top:2px solid #0b68d7}.heading-rule i{width:17px;height:17px;border:2px solid #0b68d7;background:#fff;transform:rotate(45deg)}.identity-form-card{width:min(870px,100%);margin:0 auto;padding:34px 32px 28px;border:1px solid #a9d5ff;border-radius:23px;background:#fffffff2;box-shadow:0 8px 24px #1676d21c}.pending-alert{margin-bottom:28px;border:1px solid #8bc7ff!important;border-radius:13px!important;background:#e9f5ff!important;color:#0962d4!important;font-size:clamp(20px,2.3vw,29px)}.identity-field{display:flex;align-items:flex-start;gap:28px;margin-bottom:22px;padding:22px 24px;border:1px solid #c3e1ff;border-radius:17px;background:#ffffffe6}.identity-icon{display:grid;place-items:center;flex:0 0 76px;width:76px;height:76px;border-radius:16px;color:#0869d8;background:#e3f2ff}.identity-icon .v-icon{font-size:42px}.identity-control{flex:1;min-width:0}.identity-control label{display:block;margin:0 0 8px;color:#123881;font-size:clamp(20px,2.3vw,29px);font-weight:800}.identity-control label b{color:#f02727}.identity-control :deep(.v-field){border-radius:12px;background:#f1f8ff}.identity-control :deep(.v-field__input){min-height:58px;padding-inline:28px;font-size:20px;color:#183e7a}.identity-control :deep(.v-field__prepend-inner){display:none}.identity-save{height:66px!important;border-radius:14px;background:linear-gradient(110deg,#1688ed,#0867d6)!important;color:#fff;font-size:28px;font-weight:800}.identity-save .v-icon{font-size:34px}@media(max-width:650px){.identity-page{padding:20px 10px 90px}.identity-heading{margin-bottom:18px}.identity-heading h1{font-size:25px}.identity-form-card{padding:18px 10px;border-radius:18px}.pending-alert{margin-bottom:14px;font-size:16px}.identity-field{gap:12px;margin-bottom:12px;padding:12px 10px;border-radius:13px}.identity-icon{flex-basis:42px;width:42px;height:42px;border-radius:10px}.identity-icon .v-icon{font-size:24px}.identity-control label{margin-bottom:4px;font-size:15px}.identity-control :deep(.v-field__input){min-height:30px!important;padding-inline:14px!important;font-size:14px!important}.identity-save{height:52px!important;font-size:17px!important}.mobile-break{display:block}}
</style>
