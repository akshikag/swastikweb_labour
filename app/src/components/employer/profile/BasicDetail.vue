<template>
    <BackButtonAppBar />

    <main class="basic-page">
        <header class="basic-heading">
            <h1><span>बुनियादी जानकारी</span> - Basic Information</h1>
            <div class="heading-rule" aria-hidden="true"><span></span><i></i><span></span></div>
        </header>

        <v-card class="basic-form-card" elevation="0">
            <div class="field-row">
                <span class="field-icon"><v-icon icon="mdi-account" /></span>
                <div class="field-control">
                    <label>नियोक्ता / संगठन का नाम - Name of Employer / Organisation <b>*</b></label>
                    <v-text-field v-model="form.name" placeholder="Enter employer / organisation name"
                        variant="outlined" hide-details="auto" :error="v$.name.$error"
                        :error-messages="v$.name.$errors.map(() => 'Name is required')" />
                </div>
            </div>

            <div class="field-row">
                <span class="field-icon"><v-icon icon="mdi-cellphone" /></span>
                <div class="field-control">
                    <label>मोबाइल नंबर - Mobile Number <b>*</b></label>
                    <v-text-field v-model="form.mobile" type="tel" inputmode="numeric" maxlength="10"
                        placeholder="Enter mobile number" variant="outlined" hide-details="auto"
                        :error="v$.mobile.$error" :error-messages="v$.mobile.$errors.map(err =>
                            err.$validator === 'required' ? 'Mobile is required' : 'Mobile must be 10 digits')" />
                </div>
            </div>

            <div class="field-row">
                <span class="field-icon"><v-icon icon="mdi-email" /></span>
                <div class="field-control">
                    <label>ईमेल आईडी (वैकल्पिक) - Email ID (Optional)</label>
                    <v-text-field v-model="form.email" type="email" placeholder="Enter email address"
                        variant="outlined" hide-details="auto" :error="v$.email.$error"
                        :error-messages="v$.email.$errors.map(() => 'Invalid email format')" />
                </div>
            </div>

            <div class="field-row gender-row">
                <span class="field-icon"><v-icon icon="mdi-gender-male-female" /></span>
                <div class="field-control">
                    <label>Gender <b>*</b></label>
                    <div class="gender-options" role="radiogroup" aria-label="Gender">
                        <label class="gender-option">
                            <input v-model="form.gender" type="radio" value="male" />
                            <span class="gender-radio" aria-hidden="true"></span>
                            <span>Male</span>
                        </label>
                        <label class="gender-option">
                            <input v-model="form.gender" type="radio" value="female" />
                            <span class="gender-radio" aria-hidden="true"></span>
                            <span>Female</span>
                        </label>
                        <label class="gender-option">
                            <input v-model="form.gender" type="radio" value="other" />
                            <span class="gender-radio" aria-hidden="true"></span>
                            <span>Other</span>
                        </label>
                    </div>
                    <p v-if="v$.gender.$error" class="gender-error">Gender is required</p>
                </div>
            </div>

            <div class="field-row">
                <span class="field-icon"><v-icon icon="mdi-briefcase" /></span>
                <div class="field-control">
                    <label>नियोक्ता का प्रकार - Type of Employer <b>*</b></label>
                    <v-select v-model="form.employerType" :items="[
                        { title: 'Individual', value: 'individual' },
                        { title: 'Contractor', value: 'contractor' },
                        { title: 'Company', value: 'company' },
                        { title: 'Agency', value: 'agency' },
                    ]" placeholder="Select Employer Type" variant="outlined" hide-details="auto"
                        :error="v$.employerType.$error"
                        :error-messages="v$.employerType.$errors.map(() => 'Employer type is required')" />
                </div>
            </div>

            <div class="field-row upload-row">
                <span class="field-icon"><v-icon icon="mdi-camera" /></span>
                <div class="field-control">
                    <label>Upload Profile Image</label>
                    <v-file-input v-model="form.image" accept="image/jpeg,image/png,image/gif"
                        placeholder="Choose profile image" variant="outlined" hide-details="auto" show-size
                        prepend-icon="" :error="imageError" :error-messages="imageErrorMessage"
                        @change="handleFileChange" />
                    <small>JPG, PNG or GIF (Max 2 MB)</small>
                    <v-avatar size="120" class="image-preview">
                        <v-img v-if="form.imageUrl" :src="form.imageUrl" cover />
                        <v-icon v-else size="64" color="grey">mdi-account</v-icon>
                    </v-avatar>
                </div>
            </div>

            <v-btn class="employer-primary-action save-button" block @click="submitForm">
                Save <v-icon icon="mdi-arrow-right" />
            </v-btn>
        </v-card>
    </main>
</template>


<script setup>
import { ref, onMounted } from "vue";
import { useRouter } from "vue-router";
import BackButtonAppBar from "@/components/header/BackButtonAppBar.vue";
import api from "@/services/api.js";
import apiRoutes from "@/services/apiRoutes.js";

/* VUELIDATE */
import useVuelidate from "@vuelidate/core";
import { required, email, minLength, maxLength } from "@vuelidate/validators";

const router = useRouter();

/* FORM MODEL */
const form = ref({
    name: "",
    mobile: "",
    email: "",
    gender: "",
    employerType: "",
    image: "",
    imageUrl: "",
});

// Image validation error states
const imageError = ref(false);
const imageErrorMessage = ref("");



// Handle file change event (validate image)
const handleFileChange = (event) => {
    const file = event.target.files[0];

    if (file) {
        const isValid = validateImage(file);
        if (isValid) {
            // Valid file, update image in form
            form.value.image = file;
            form.value.imageUrl = URL.createObjectURL(file);  // For preview
        } else {
            // Invalid file, clear the image
            form.value.image = null;
            form.value.imageUrl = null;
        }
    }
};

// Validate image file (size and type)
const validateImage = (file) => {
    const allowedTypes = ["image/jpeg", "image/png", "image/gif"];
    const maxSize = 2 * 1024 * 1024; // 2MB max size

    // Check if the file is an allowed image type
    if (!allowedTypes.includes(file.type)) {
        imageError.value = true;
        imageErrorMessage.value = "Only JPEG, PNG, and GIF images are allowed.";
        return false;
    }

    // Check if the file size is within the limit
    if (file.size > maxSize) {
        imageError.value = true;
        imageErrorMessage.value = "Image size must be less than 5MB.";
        return false;
    }

    imageError.value = false;  // Reset error if file is valid
    imageErrorMessage.value = "";
    return true;
};
/* VUELIDATE RULES */
const rules = {
    name: { required },
    mobile: { required, minLength: minLength(10), maxLength: maxLength(10) },
    email: { email },
    gender: { required },
    employerType: { required },
};

const v$ = useVuelidate(rules, form);

/* GET EMPLOYER DETAILS */
const employerData = JSON.parse(localStorage.getItem("labour_currentUser"));

onMounted(async () => {
    try {
        const res = await api.get(
            `${apiRoutes.employerGetById}/${employerData.employer.id}`
        );

        const data = res.data.employer;

        form.value = {
            name: data.profile?.name || "",
            email: data.email || "",
            mobile: data.phone || "",
            employerType: data.profile?.emp_type || "",
            gender: data.profile?.gender || "",
            imageUrl: data.profile?.profile_image_base64 || null,
        };
    } catch (err) {
        alert("Error loading data", err);
    }
});

/* SUBMIT FORM */
async function submitForm() {
    const isValid = await v$.value.$validate();


    if (!isValid || imageError.value) {
        alert("Please fix the highlighted errors.");
        return;
    }

    let base64Image = null;

    if (form.value.image) {
        base64Image = await toBase64(form.value.image);
    }

    try {
        await api.put(
            apiRoutes.employerUpdate + "/" + employerData.employer.id,
            {
                email: form.value.email,
                phone: form.value.mobile,
                name: form.value.name,
                emp_type: form.value.employerType,
                gender: form.value.gender,
                profile_image: base64Image,
            }
        );

        router.push("/employer-dashboard-profile-identity");
    } catch (err) {
        alert("Update failed!", err);
    }
}

/* Convert File to Base64 */
const toBase64 = (file) => {
    return new Promise((resolve, reject) => {
        const reader = new FileReader();
        reader.readAsDataURL(file);
        reader.onload = () => resolve(reader.result);
        reader.onerror = (err) => reject(err);
    });
};
</script>

<style scoped>
.basic-page {
    min-height: calc(100vh - 100px);
    padding: 28px 18px 100px;
    color: #082566;
    background: #fff url('@/assets/authenticated-background.png') center/100% 100% no-repeat;
}

.basic-heading { margin: 3px auto 30px; text-align: center; }
.basic-heading h1 { margin: 0; color: #102966; font-size: clamp(30px, 4.4vw, 48px); font-weight: 800; line-height: 1.2; }
.basic-heading h1 span { color: #102966; }
.heading-rule { display: flex; align-items: center; justify-content: center; gap: 0; width: min(360px, 82vw); margin: 17px auto 0; }
.heading-rule span { flex: 1; height: 2px; background: #0b68d7; }
.heading-rule i { width: 17px; height: 17px; border: 2px solid #0b68d7; background: #fff; transform: rotate(45deg); }

.basic-form-card {
    width: min(870px, 100%);
    margin: 0 auto;
    padding: 34px 32px 28px;
    border: 1px solid #82c2ff;
    border-radius: 23px !important;
    background: rgba(255, 255, 255, .95) !important;
    box-shadow: 0 8px 24px rgba(22, 118, 210, .11) !important;
}

.field-row { display: flex; align-items: flex-start; gap: 24px; margin-bottom: 21px; }
.field-icon { display: grid; place-items: center; flex: 0 0 62px; width: 62px; height: 62px; margin-top: 25px; border-radius: 15px; color: #0869d8; background: #e3f2ff; }
.field-icon .v-icon { font-size: 34px; }
.field-control { flex: 1; min-width: 0; text-align: left; }
.field-control label { display: block; margin: 0 0 8px; color: #123881; font-size: clamp(18px, 2.1vw, 25px); font-weight: 800; line-height: 1.25; }
.field-control label b { color: #f02727; }
.field-control :deep(.v-field) { min-height: 58px; border-radius: 12px; color: #6d9bd2; background: #edf6ff; }
.field-control :deep(.v-field__outline) { --v-field-border-opacity: 1; }
.field-control :deep(.v-field__input) { min-height: 58px; padding-inline: 18px; color: #183e7a; font-size: 18px; }
.field-control :deep(input::placeholder) { color: #8da3c2; opacity: 1; }
.field-control :deep(.v-messages__message) { color: #d42834; font-size: 12px; }
.field-control small { display: block; margin: 7px 0 0 4px; color: #6d7e9a; font-size: 12px; }

.gender-row .field-icon { margin-top: 19px; }
.gender-options { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 10px 18px; width: 100%; padding: 5px 3px 2px; }
.gender-option { display: flex !important; align-items: center; gap: 9px; min-width: 0; margin: 0 !important; color: #173b70 !important; font-size: 17px !important; font-weight: 400 !important; line-height: 1.2 !important; white-space: nowrap; cursor: pointer; }
.gender-option input { position: absolute; width: 1px; height: 1px; opacity: 0; pointer-events: none; }
.gender-radio { position: relative; flex: 0 0 20px; width: 20px; height: 20px; border: 2px solid #7893bb; border-radius: 50%; background: #fff; }
.gender-option input:checked + .gender-radio { border-color: #1475d4; }
.gender-option input:checked + .gender-radio::after { content: ''; position: absolute; inset: 4px; border-radius: 50%; background: #1475d4; }
.gender-option input:focus-visible + .gender-radio { outline: 3px solid rgba(20, 117, 212, .25); outline-offset: 2px; }
.gender-error { margin: 5px 0 0; color: #d42834; font-size: 12px; }
.upload-row .field-icon { margin-top: 25px; }
.upload-row .field-control :deep(.v-field) { min-height: 104px; border-style: dashed; }
.upload-row .field-control :deep(.v-field__input) { min-height: 100px; align-items: center; }
.image-preview { display: flex; margin: 13px 0 0; border: 2px solid #d6eaff; background: #f2f8ff; }

.save-button { margin-top: 3px; text-transform: uppercase; }
.save-button .v-icon { margin-left: 14px; }

@media (max-width: 650px) {
    .basic-page { padding: 20px 8px 90px; background-size: auto 100%; }
    .basic-heading { margin-bottom: 22px; }
    .basic-heading h1 { padding-inline: 5px; font-size: clamp(22px, 7vw, 31px); }
    .heading-rule { margin-top: 13px; }
    .basic-form-card { padding: 20px 11px 18px; border-radius: 18px !important; }
    .field-row { gap: 10px; margin-bottom: 14px; }
    .field-icon { flex-basis: 42px; width: 42px; height: 42px; margin-top: 23px; border-radius: 11px; }
    .field-icon .v-icon { font-size: 24px; }
    .field-control label { margin-bottom: 5px; font-size: 15px; }
    .field-control :deep(.v-field) { min-height: 54px; border-radius: 10px; }
    .field-control :deep(.v-field__input) { min-height: 52px; padding-inline: 13px; font-size: 14px; }
    .gender-row .field-icon { margin-top: 18px; }
    .gender-options { grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 12px 14px; padding-top: 7px; }
    .gender-option { gap: 7px; font-size: 14px !important; }
    .gender-radio { flex-basis: 19px; width: 19px; height: 19px; }
    .upload-row .field-control :deep(.v-field) { min-height: 92px; }
    .upload-row .field-control :deep(.v-field__input) { min-height: 88px; }
    .image-preview { width: 92px !important; height: 92px !important; }
}

@media (max-width: 380px) {
    .basic-heading h1 { font-size: 22px; }
    .field-control label { font-size: 14px; }
    .gender-options { grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 11px 8px; }
}
</style>
