<template>
    <BackButtonAppBar />
    <v-container class="password-page" fluid>
        <v-card class="password-card" elevation="0">
            <div class="password-heading"><div><h1>Change Password</h1><p>Keep your account secure with a strong password</p></div></div>
            <div class="password-field"><span class="password-field-icon"><v-icon>mdi-lock</v-icon></span><div class="password-control"><label>Old Password <b>*</b></label><v-text-field v-model="form.old_password" :type="showOld ? 'text' : 'password'" placeholder="Enter your old password" variant="outlined" hide-details><template #append-inner><v-icon class="visibility-toggle" @click="showOld = !showOld">{{ showOld ? 'mdi-eye-off-outline' : 'mdi-eye-outline' }}</v-icon></template></v-text-field></div></div>
            <div class="password-field"><span class="password-field-icon"><v-icon>mdi-lock</v-icon></span><div class="password-control"><label>New Password <b>*</b></label><v-text-field v-model="form.new_password" :type="showNew ? 'text' : 'password'" placeholder="Enter new password" variant="outlined" hide-details><template #append-inner><v-icon class="visibility-toggle" @click="showNew = !showNew">{{ showNew ? 'mdi-eye-off-outline' : 'mdi-eye-outline' }}</v-icon></template></v-text-field></div></div>
            <div class="password-field"><span class="password-field-icon"><v-icon>mdi-lock</v-icon></span><div class="password-control"><label>Confirm Password <b>*</b></label><v-text-field v-model="form.cnf_password" :type="showConfirm ? 'text' : 'password'" placeholder="Confirm new password" variant="outlined" hide-details><template #append-inner><v-icon class="visibility-toggle" @click="showConfirm = !showConfirm">{{ showConfirm ? 'mdi-eye-off-outline' : 'mdi-eye-outline' }}</v-icon></template></v-text-field></div></div>
            <div class="password-requirements"><v-icon>mdi-information</v-icon><div><strong>Password Requirements:</strong><ul><li>At least 8 characters long</li><li>Include at least one uppercase letter</li><li>Include at least one lowercase letter</li><li>Include at least one number</li><li>Include at least one special character (e.g. ! @ # $ %)</li></ul></div></div>
            <v-btn class="password-save" block @click="submitForm">Save <v-icon end>mdi-arrow-right</v-icon></v-btn>
        </v-card>
    </v-container>
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

    const workerData = JSON.parse(localStorage.getItem('labour_currentUser'))
    try {
        const res = await api.post(apiRoutes.workerChangePassword, {
            worker_id: workerData.worker.id,
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
.password-page{min-height:calc(100vh - 64px);padding:52px 16px 105px;background:#fff url('@/assets/authenticated-background.png') center/100% 100% no-repeat;color:#082664}.password-card{width:min(850px,100%);margin:0 auto;padding:42px 36px 30px;border-radius:25px!important;background:#fffffff2!important;box-shadow:0 10px 28px #123f7220!important}.password-heading{display:flex;align-items:center;gap:26px;margin-bottom:42px}.password-heading-icon{display:grid;place-items:center;flex:0 0 104px;width:104px;height:104px;border-radius:50%;background:#e3f2ff;color:#0869d8}.password-heading-icon .v-icon{font-size:58px}.password-heading h1{margin:0;font-size:clamp(31px,4vw,50px);font-weight:800}.password-heading p{margin:7px 0 0;font-size:clamp(17px,2.3vw,27px);color:#677898}.password-field{display:flex;align-items:flex-end;gap:24px;margin-bottom:30px}.password-field-icon{display:grid;place-items:center;flex:0 0 76px;width:76px;height:76px;margin-bottom:1px;border:1px solid #cae1fb;border-radius:15px;background:#eaf5ff;color:#0869d8}.password-field-icon .v-icon{font-size:42px}.password-control{flex:1;min-width:0}.password-control label{display:block;margin-bottom:8px;color:#102f74;font-size:clamp(19px,2.4vw,29px);font-weight:800}.password-control label b{color:#f02828}.password-control :deep(.v-field){min-height:64px;border-radius:13px;background:#eef6ff}.password-control :deep(.v-field__input){min-height:62px;padding-inline:26px;font-size:20px;color:#17396f}.password-control :deep(.v-field__append-inner){padding-right:13px;color:#637492}.visibility-toggle{cursor:pointer}.password-requirements{display:flex;gap:20px;padding:22px 26px;margin:8px 0 28px;border-radius:13px;background:#edf5ff;color:#60718f;font-size:18px;text-align:left}.password-requirements>.v-icon{flex:0 0 auto;margin-top:4px;color:#0870dc;font-size:48px}.password-requirements strong{display:block;margin-bottom:8px;color:#113675;font-size:19px}.password-requirements ul{margin:0;padding-left:24px;line-height:1.65}.password-save{height:66px!important;border-radius:13px;background:linear-gradient(110deg,#1688ed,#0867d6)!important;color:#fff;font-size:28px!important;font-weight:800;letter-spacing:.3px}.password-save .v-icon{font-size:34px}
@media(max-width:650px){.password-page{padding:20px 10px 90px;background-size:auto 100%}.password-card{padding:24px 12px 20px;border-radius:18px!important}.password-heading{gap:13px;margin-bottom:25px}.password-heading-icon{flex-basis:58px;width:58px;height:58px}.password-heading-icon .v-icon{font-size:33px}.password-heading h1{font-size:27px}.password-heading p{font-size:15px}.password-field{gap:12px;margin-bottom:18px}.password-field-icon{flex-basis:42px;width:42px;height:42px;border-radius:11px}.password-field-icon .v-icon{font-size:24px}.password-control label{margin-bottom:4px;font-size:15px}.password-control :deep(.v-field){min-height:30px;border-radius:10px}.password-control :deep(.v-field__input){min-height:30px!important;padding-inline:14px!important;font-size:14px!important}.password-control :deep(.v-field__append-inner){padding-right:8px}.password-requirements{gap:12px;padding:16px 14px;margin-bottom:20px;font-size:14px}.password-requirements>.v-icon{font-size:34px}.password-requirements strong{font-size:15px}.password-requirements ul{padding-left:18px;line-height:1.55}.password-save{height:52px!important;font-size:17px!important}.password-save .v-icon{font-size:25px}}
</style>
