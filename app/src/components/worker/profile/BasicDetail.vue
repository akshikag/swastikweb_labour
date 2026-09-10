<template>
    <v-app-bar v-if="false" color="primary" dark flat style="position: sticky;" class="pb-2 pt-4 px-2">
        <v-row align="center" class="fill-height" no-gutters>
            <v-col class="d-flex align-center ms-2 mt-2" cols="auto" style="gap: 12px;">
                <div style="width: 32px;height: 32px;border: 2px solid white;border-radius: 50%;overflow: hidden;
                        display: flex;justify-content: center;align-items: center;">
                    <img src="@/assets/himachal-emblem.png" alt="Himachal Pradesh government emblem"
                        style="width: 28px; height: 28px; object-fit: cover;" />
                </div>
                <div style="line-height: 1;">
                    <div style="font-weight: 700; font-size: 14px;">Govt. of Himachal Pradesh</div>
                    <div style="font-size: 12px;">हिमाचल प्रदेश सरकार</div>
                </div>
            </v-col>
        </v-row>
        <v-btn icon @click="goBack">
            <v-icon>mdi-arrow-left-bold</v-icon>
        </v-btn>
    </v-app-bar>
    <BackButtonAppBar />
    <main class="basic-page">
      <div class="basic-heading"><h1>Basic <span>Information</span></h1><div class="heading-rule"><i></i></div><p>सुरक्षित श्रमशक्ति - समृद्ध हिमाचल</p></div>
      <v-form class="basic-form-card" @submit.prevent="submitForm">
        <div class="field-row"><span class="field-icon"><v-icon icon="mdi-account" /></span><div class="field-control"><label>Full Name <b>*</b></label><v-text-field v-model="form.name" placeholder="Enter your full name" variant="outlined" hide-details /></div></div>
        <div class="field-row"><span class="field-icon"><v-icon icon="mdi-calendar-month" /></span><div class="field-control"><label>Age (in Years) <b>*</b></label><v-text-field v-model="form.age" type="text" inputmode="numeric" pattern="[0-9]*" placeholder="Enter age" variant="outlined" hide-details @keydown="preventInvalidAgeInput" @input="sanitizeAgeInput" /></div></div>
        <div class="field-row"><span class="field-icon"><v-icon icon="mdi-gender-male-female" /></span><div class="field-control"><label>Gender <b>*</b></label><v-radio-group v-model="form.gender" inline hide-details><v-radio label="Male" value="male" /><v-radio label="Female" value="female" /><v-radio label="Other" value="other" /></v-radio-group></div></div>
        <div class="field-row"><span class="field-icon"><v-icon icon="mdi-phone" /></span><div class="field-control"><label>Mobile Number <b>*</b></label><v-text-field v-model="form.mobile" placeholder="Enter mobile number" variant="outlined" hide-details /></div></div>
        <div class="field-row"><span class="field-icon"><v-icon icon="mdi-email" /></span><div class="field-control"><label>Email (Optional)</label><v-text-field v-model="form.email" placeholder="Enter email address" variant="outlined" hide-details /></div></div>
        <div class="field-row upload-row"><span class="field-icon"><v-icon icon="mdi-camera" /></span><div class="field-control"><label>Upload Profile Image</label><v-file-input v-model="form.image" accept="image/*" prepend-icon="" prepend-inner-icon="mdi-cloud-upload" placeholder="Click to upload" hint="JPG, PNG (Max 2 MB)" persistent-hint variant="outlined" show-size hide-details="auto" @update:model-value="handleFileChange" /><v-avatar v-if="form.imageUrl" size="70" class="preview-avatar"><v-img :src="form.imageUrl" cover /></v-avatar></div></div>
        <v-btn class="save-button" type="submit" block>Save <v-icon end icon="mdi-arrow-right" /></v-btn>
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

function resolveImageUrl(url) {
    if (!url) return '';

    if (typeof url === 'object' && url instanceof File) {
        return URL.createObjectURL(url);
    }

    if (typeof url === 'string') {
        const value = url.trim();
        if (!value) return '';
        if (value.startsWith('data:') || value.startsWith('http://') || value.startsWith('https://')) {
            return value;
        }

        const backendBaseUrl = (api.defaults.baseURL || '').replace(/\/api\/?$/, '');
        if (value.startsWith('/')) {
            return `${backendBaseUrl}${value}`;
        }
        return `${backendBaseUrl}/${value.replace(/^\/+/, '')}`;
    }

    return '';
}

const form = ref({
    name: '',
    age: '',
    gender: '',
    mobile: '',
    email: '',
    image: '',
    imageUrl: '',
})

const workerData = JSON.parse(localStorage.getItem('labour_currentUser'))

onMounted(async () => {
    try {
        const res = await api.get(`${apiRoutes.workerGetWorkerByid}/${workerData.worker.id}`);
        console.log("Success:", res.data);

        const data = res.data.worker;
        // Populate form values safely
        form.value = {
            name: data.profile?.name || '',         // use profile.name if exists
            email: data.email || '',                // email directly from data
            mobile: data.phone || '',               // phone directly from data
            age: data.profile?.age || '',           // profile.age if exists
            gender: data.profile?.gender || '',     // profile.gender if exists
            image: null,
            imageUrl: resolveImageUrl(data.profile?.profile_image_url || null),
        };

    } catch (err) {
        console.error("Error fetching worker details:", err);
        alert(
            "Error !!\n" +
            Object.values(err.response?.data?.errors || {}).flat().join("\n")
        );
        console.error("Error fetching worker details:", err);
    }
});



async function submitForm() {
    if (!validateForm()) {
        // Validation failed, stop execution
        return;
    }
    let base64Image = null;

    if (form.value.image) {
        base64Image = await toBase64(form.value.image);
    }

    try {
        const res = await api.put(apiRoutes.workerUpdate + '/' + workerData.worker.id, {
            email: form.value.email,
            phone: form.value.mobile,
            name: form.value.name,
            age: form.value.age,
            gender: form.value.gender,
            profile_image: base64Image,
        });

        console.log("Success:", res.data)

        router.push('/worker-dashboard-profile-identity')

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
        reader.readAsDataURL(file); // converts to base64 string
        reader.onload = () => resolve(reader.result);
        reader.onerror = (error) => reject(error);
    });
};

function handleFileChange(file) {
    const selectedFile = Array.isArray(file) ? file[0] : file;

    if (!selectedFile) {
        form.value.image = '';
        form.value.imageUrl = '';
        return;
    }

    form.value.image = selectedFile;
    form.value.imageUrl = resolveImageUrl(selectedFile);
}

function preventInvalidAgeInput(event) {
    const allowedKeys = ['Backspace', 'Delete', 'Tab', 'ArrowLeft', 'ArrowRight', 'Home', 'End'];
    const isShortcut = (event.ctrlKey || event.metaKey) && ['a', 'c', 'v', 'x'].includes(event.key.toLowerCase());

    if (!/^[0-9]$/.test(event.key) && !allowedKeys.includes(event.key) && !isShortcut) {
        event.preventDefault();
    }
}

function sanitizeAgeInput(event) {
    const digitsOnly = String(event.target.value || '').replace(/\D/g, '');
    event.target.value = digitsOnly;
    form.value.age = digitsOnly;
}

function goBack() {
    router.push('/worker-dashboard-profile')
}

function validateForm() {
    const { name, age, gender, mobile } = form.value;

    if (!name) {
        alert('Please fill in Name.');
        return false;
    }
    if (!mobile) {
        alert('Please fill in Mobile.');
        return false;
    }
    if (age === '' || age === null || age === undefined) {
        alert('Please fill in Age.');
        return false;
    }
    if (!Number.isInteger(Number(age)) || Number(age) < 0) {
        alert('Age must be a whole number and cannot be negative.');
        return false;
    }
    if (!gender) {
        alert('Please fill in Gender.');
        return false;
    }

    // All fields valid
    return true;
}

</script>

<style scoped>
.basic-page{min-height:calc(100vh - 100px);padding:28px 18px 100px;color:#082566;background:#fff url('@/assets/authenticated-background.png') center/100% 100% no-repeat}.basic-heading{text-align:center;margin:4px auto 26px}.basic-heading h1{margin:0;font-size:clamp(34px,5vw,56px);font-weight:800;color:#102966}.basic-heading h1 span{color:#0878df}.basic-heading p{margin:14px 0 0;font-size:clamp(19px,2.5vw,29px);font-weight:500}.heading-rule{display:flex;justify-content:center;align-items:center;width:250px;margin:13px auto 0;border-top:2px solid #0b68d7}.heading-rule i{width:16px;height:16px;border:2px solid #0b68d7;background:#fff;transform:rotate(45deg)}.basic-form-card{width:min(870px,100%);margin:0 auto;padding:34px 32px 28px;border:1px solid #a9d5ff;border-radius:23px;background:#fffffff2;box-shadow:0 8px 24px #1676d21c}.field-row{display:flex;align-items:flex-start;gap:28px;margin-bottom:22px}.field-icon{display:grid;place-items:center;flex:0 0 76px;width:76px;height:76px;margin-top:4px;border-radius:16px;color:#0869d8;background:#e3f2ff}.field-icon .v-icon{font-size:42px}.field-control{flex:1;min-width:0}.field-control label{display:block;margin:0 0 8px;font-size:clamp(21px,2.4vw,30px);font-weight:800;color:#123881}.field-control label b{color:#f02727}.field-control :deep(.v-field){border-radius:12px;background:#f1f8ff}.field-control :deep(.v-field__input){min-height:58px;padding-inline:28px;font-size:21px;color:#183e7a}.field-control :deep(.v-label){color:#7890b4}.field-control :deep(.v-selection-control-group){justify-content:space-between}.field-control :deep(.v-radio){margin-inline-end:20px}.field-control :deep(.v-radio .v-label){font-size:20px;color:#102e68;opacity:1}.upload-row .field-control :deep(.v-field){min-height:100px;border:1px dashed #79baff}.upload-row .field-control :deep(.v-field__input){align-items:center}.preview-avatar{margin-top:10px}.save-button{height:66px!important;border-radius:14px;background:linear-gradient(110deg,#1688ed,#0867d6)!important;color:#fff;font-size:28px;font-weight:800;letter-spacing:.4px}.save-button .v-icon{font-size:34px}@media(max-width:650px){.basic-page{padding:20px 10px 90px}.basic-heading{margin-bottom:18px}.basic-heading h1{font-size:34px}.basic-heading p{font-size:18px}.basic-form-card{padding:22px 12px 18px;border-radius:18px}.field-row{gap:12px;margin-bottom:14px}.field-icon{flex-basis:42px;width:42px;height:42px;margin-top:2px;border-radius:11px}.field-icon .v-icon{font-size:24px}.field-control label{font-size:18px;margin-bottom:4px}.field-control :deep(.v-field__input){min-height:44px;padding-inline:14px;font-size:16px}.field-control :deep(.v-radio .v-label){font-size:15px}.field-control :deep(.v-radio){margin-inline-end:4px}.save-button{height:52px!important;font-size:22px}}
.save-button{height:52px !important;font-size:17px !important}
.upload-row :deep(.v-input__prepend),.upload-row :deep(.v-field__prepend-inner){display:none !important}
</style>
