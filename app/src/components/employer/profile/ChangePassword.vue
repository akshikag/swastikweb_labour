<template>
    <BackButtonAppBar />
    <main class="password-page">
        <v-card class="password-card" elevation="0">
            <header class="password-heading">
                <h1>Change Password</h1>
                <p>Keep your account secure with a strong password</p>
            </header>

            <div class="password-field">
                <span class="password-field-icon"><v-icon icon="mdi-lock" /></span>
                <div class="password-control">
                    <label>Old Password <b>*</b></label>
                    <v-text-field v-model="form.old_password" :type="showOld ? 'text' : 'password'"
                        placeholder="Enter your old password" variant="outlined" hide-details>
                        <template #append-inner>
                            <v-icon class="visibility-toggle" :icon="showOld ? 'mdi-eye-off-outline' : 'mdi-eye-outline'"
                                @click="showOld = !showOld" />
                        </template>
                    </v-text-field>
                </div>
            </div>

            <div class="password-field">
                <span class="password-field-icon"><v-icon icon="mdi-lock" /></span>
                <div class="password-control">
                    <label>New Password <b>*</b></label>
                    <v-text-field v-model="form.new_password" :type="showNew ? 'text' : 'password'"
                        placeholder="Enter new password" variant="outlined" hide-details>
                        <template #append-inner>
                            <v-icon class="visibility-toggle" :icon="showNew ? 'mdi-eye-off-outline' : 'mdi-eye-outline'"
                                @click="showNew = !showNew" />
                        </template>
                    </v-text-field>
                </div>
            </div>

            <div class="password-field">
                <span class="password-field-icon"><v-icon icon="mdi-lock" /></span>
                <div class="password-control">
                    <label>Confirm Password <b>*</b></label>
                    <v-text-field v-model="form.cnf_password" :type="showConfirm ? 'text' : 'password'"
                        placeholder="Confirm new password" variant="outlined" hide-details>
                        <template #append-inner>
                            <v-icon class="visibility-toggle" :icon="showConfirm ? 'mdi-eye-off-outline' : 'mdi-eye-outline'"
                                @click="showConfirm = !showConfirm" />
                        </template>
                    </v-text-field>
                </div>
            </div>

            <aside class="password-requirements">
                <v-icon icon="mdi-information" />
                <div>
                    <strong>Password Requirements:</strong>
                    <ul>
                        <li>Between 6 and 20 characters</li>
                        <li>Use a mix of uppercase and lowercase letters</li>
                        <li>Include at least one number</li>
                        <li>Include at least one special character</li>
                    </ul>
                </div>
            </aside>

            <v-btn class="employer-primary-action password-save" block @click="submitForm">
                Save <v-icon icon="mdi-arrow-right" />
            </v-btn>
        </v-card>
    </main>
</template>

<script setup>
import BackButtonAppBar from "@/components/header/BackButtonAppBar.vue";
import api from "@/services/api.js";
import apiRoutes from "@/services/apiRoutes.js";
import { useRouter } from 'vue-router'

import { ref } from 'vue'

const router = useRouter()

const form = ref({
    old_password: '',
    new_password: '',
    cnf_password: ''
})
const showOld = ref(false)
const showNew = ref(false)
const showConfirm = ref(false)

async function submitForm() {

    if (!form.value.old_password) {
        alert('Please enter your old password.');
        return false;
    }
    if (form.value.old_password.length < 6 || form.value.old_password.length > 20) {
        alert('Old password must be between 6 and 20 characters.');
        return false;
    }

    // New password
    if (!form.value.new_password) {
        alert('Please enter your new password.');
        return false;
    }
    if (form.value.new_password.length < 6 || form.value.new_password.length > 20) {
        alert('New password must be between 6 and 20 characters.');
        return false;
    }

    // Confirm password
    if (!form.value.cnf_password) {
        alert('Please confirm your new password.');
        return false;
    }
    if (form.value.cnf_password !== form.value.new_password) {
        alert('Confirm password does not match the new password.');
        return false;
    }

    const employerData = JSON.parse(localStorage.getItem('labour_currentUser'))
    try {
        const res = await api.post(apiRoutes.employerChangePassword, {
            employer_id: employerData.employer.id,
            old_password: form.value.old_password,
            new_password: form.value.new_password,
            new_password_confirmation: form.value.cnf_password,
        });

        //console.log("Success:", res.data)
        alert('Success !!')

        localStorage.removeItem('labour_currentUser')
        localStorage.removeItem('labouchowk_userType')
        router.push('/')

    } catch (err) {
        alert(
            "Error !!\n" + err.response?.data?.message
        )
        console.error("Error login:", err)
    }

}


</script>

<style scoped>
.password-page {
    min-height: calc(100vh - 100px);
    padding: clamp(32px, 6vh, 64px) 12px 100px;
    color: #082664;
    background: #fff url('@/assets/authenticated-background.png') center/100% 100% no-repeat;
}

.password-card {
    width: min(850px, 100%);
    margin: 0 auto;
    padding: 38px 36px 30px;
    border: 1px solid #dcebf8;
    border-radius: 25px !important;
    background: rgba(255, 255, 255, .95) !important;
    box-shadow: 0 10px 28px rgba(18, 63, 114, .13) !important;
}

.password-heading { margin-bottom: 38px; text-align: left; }
.password-heading h1 { margin: 0; color: #202124; font-size: clamp(30px, 4vw, 46px); font-weight: 800; line-height: 1.15; }
.password-heading p { margin: 9px 0 0; color: #667898; font-size: clamp(16px, 2.2vw, 23px); line-height: 1.35; }

.password-field { display: flex; align-items: flex-end; gap: 22px; margin-bottom: 25px; }
.password-field-icon { display: grid; place-items: center; flex: 0 0 62px; width: 62px; height: 62px; margin-bottom: 1px; border: 1px solid #cae1fb; border-radius: 14px; color: #0869d8; background: #eaf5ff; }
.password-field-icon .v-icon { font-size: 34px; }
.password-control { flex: 1; min-width: 0; text-align: left; }
.password-control label { display: block; margin-bottom: 8px; color: var(--app-form-label); font-size: clamp(18px, 2.2vw, 25px); font-weight: 800; }
.password-control label b { color: #f02828; }
.password-control :deep(.v-field) { min-height: 62px; border-radius: 12px; color: var(--app-form-input-border); background: var(--app-form-input-bg); }
.password-control :deep(.v-field__outline) { --v-field-border-opacity: 1; }
.password-control :deep(.v-field__input) { min-height: 60px; padding-inline: 20px; color: var(--app-form-input-text); font-size: 18px; }
.password-control :deep(input::placeholder) { color: var(--app-form-placeholder); opacity: 1; }
.password-control :deep(.v-field__append-inner) { padding-right: 11px; color: #7c8da7; }
.visibility-toggle { cursor: pointer; }

.password-requirements { display: flex; gap: 18px; margin: 6px 0 26px; padding: 21px 24px; border-radius: 13px; color: #637593; background: #eaf4ff; font-size: 16px; text-align: left; }
.password-requirements > .v-icon { flex: 0 0 auto; margin-top: 3px; color: #0870dc; font-size: 39px; }
.password-requirements strong { display: block; margin-bottom: 7px; color: var(--app-form-label); font-size: 17px; }
.password-requirements ul { margin: 0; padding-left: 21px; line-height: 1.55; }
.password-save { text-transform: uppercase; }
.password-save .v-icon { margin-left: 14px; }

@media (max-width: 650px) {
    .password-page { padding: 18px 8px 90px; background-size: auto 100%; }
    .password-card { padding: 24px 11px 19px; border-radius: 18px !important; }
    .password-heading { margin-bottom: 24px; padding-inline: 2px; }
    .password-heading h1 { font-size: 26px; }
    .password-heading p { margin-top: 6px; font-size: 14px; }
    .password-field { gap: 9px; margin-bottom: 17px; }
    .password-field-icon { flex-basis: 39px; width: 39px; height: 39px; border-radius: 10px; }
    .password-field-icon .v-icon { font-size: 22px; }
    .password-control label { margin-bottom: 4px; font-size: 14px; }
    .password-control :deep(.v-field) { min-height: 52px; border-radius: 9px; }
    .password-control :deep(.v-field__input) { min-height: 50px; padding-inline: 11px; font-size: 13px; }
    .password-control :deep(.v-field__append-inner) { padding-right: 6px; }
    .password-requirements { gap: 10px; margin-bottom: 18px; padding: 14px 11px; font-size: 12px; }
    .password-requirements > .v-icon { font-size: 28px; }
    .password-requirements strong { font-size: 13px; }
    .password-requirements ul { padding-left: 16px; line-height: 1.5; }
}
</style>
