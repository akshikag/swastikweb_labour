<template>
    <v-app>
        <v-app-bar color="primary" dark flat class="py-2 pt-3 px-1">
            <v-row align="center" class="fill-height" no-gutters>
                <v-col class="d-flex align-center ms-2 mt-2" cols="auto" style="gap: 12px;">
                    <div style="width: 32px;height: 32px;border: 2px solid white;border-radius: 50%;overflow: hidden;
              display: flex;justify-content: center;align-items: center;">
                        <img src="../assets/bharat.jpg" alt="India Flag"
                            style="width: 28px; height: 28px; object-fit: cover;" />
                    </div>
                    <div style="line-height: 1;">
                        <div style="font-weight: 700; font-size: 14px;">भारत सरकार</div>
                        <div style="font-size: 12px;">Govt. of India</div>
                    </div>
                </v-col>
            </v-row>
            <v-btn icon @click="goBack">
                <v-icon>mdi-arrow-left-bold</v-icon>
            </v-btn>
        </v-app-bar>

        <v-main>
            <v-container class="py-12 fill-height d-flex align-center justify-center" fluid>
                <v-row>
                    <v-col cols="12">
                        <v-card class="pa-6 py-10" elevation="6">
                            <v-sheet color="primary" rounded="circle" width="64" height="64"
                                class="d-flex align-center justify-center mx-auto mb-4">
                                <v-icon color="white" size="36">mdi-lock-reset</v-icon>
                            </v-sheet>

                            <v-card-title class="text-h6 font-weight-bold text-center mb-5">
                                Forgot Password
                            </v-card-title>

                            <!-- STEP 1 MOBILE -->
                            <v-form v-if="step === 1" @submit.prevent="sendOtp">
                                <v-text-field v-model="mobile" label="Mobile Number *" variant="filled"
                                    :error="v$.mobile.$error" :error-messages="mobileErrors" />
                                <v-btn type="submit" color="primary" block class="mt-4">Send OTP</v-btn>
                            </v-form>

                            <!-- STEP 2 OTP -->
                            <v-form v-if="step === 2" @submit.prevent="verifyOtp">
                                <v-text-field v-model="otp" label="Enter OTP *" variant="filled" :error="v$.otp.$error"
                                    :error-messages="otpErrors" />
                                <v-btn type="submit" color="primary" block class="mt-4">Verify OTP</v-btn>

                                <div class="text-center mt-3">
                                    <v-btn text small @click="resendOtp">Resend OTP</v-btn>
                                </div>
                            </v-form>

                            <!-- STEP 3 PASSWORD -->
                            <v-form v-if="step === 3" @submit.prevent="changePassword">
                                <v-text-field v-model="newPassword" label="New Password *" type="password"
                                    variant="filled" :error="v$.newPassword.$error"
                                    :error-messages="newPasswordErrors" />

                                <v-text-field v-model="confirmPassword" label="Confirm Password *" type="password"
                                    variant="filled" :error="v$.confirmPassword.$error"
                                    :error-messages="confirmPasswordErrors" />

                                <v-btn type="submit" color="primary" block class="mt-4">
                                    Change Password
                                </v-btn>
                            </v-form>

                            <div class="text-center mt-3" v-if="step === 1">
                                <router-link to="/worker-login">Back to Login</router-link>
                            </div>

                        </v-card>
                    </v-col>
                </v-row>
            </v-container>
        </v-main>
    </v-app>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import useVuelidate from '@vuelidate/core'
import { required, minLength, numeric, helpers } from '@vuelidate/validators'
import api from "@/services/api.js"
import apiRoutes from "@/services/apiRoutes.js"

const router = useRouter()

// ----------------------
// FORM STATES
// ----------------------
const step = ref(1)
const mobile = ref('')
const otp = ref('')
const newPassword = ref('')
const confirmPassword = ref('')

// ----------------------
// VALIDATION RULES
// ----------------------
const rules = {
    mobile: {
        required,
        numeric,
        minLength: minLength(10),
        mobileFormat: helpers.withMessage(
            "Invalid mobile number",
            v => /^[6-9]\d{9}$/.test(v)
        )
    },
    otp: {
        required,
        minLength: minLength(6)
    },
    newPassword: {
        required,
        minLength: minLength(6)
    },
    confirmPassword: {
        required,
        sameAsPassword: helpers.withMessage(
            "Passwords do not match",
            v => v === newPassword.value
        )
    }
}

const v$ = useVuelidate(rules, { mobile, otp, newPassword, confirmPassword })

// ----------------------
// Computed Error Messages
// ----------------------
const mobileErrors = computed(() => v$.value.mobile.$errors.map(e => e.$message))
const otpErrors = computed(() => v$.value.otp.$errors.map(e => e.$message))
const newPasswordErrors = computed(() => v$.value.newPassword.$errors.map(e => e.$message))
const confirmPasswordErrors = computed(() => v$.value.confirmPassword.$errors.map(e => e.$message))

// ----------------------
// STEP 1 - SEND OTP
// ----------------------
function sendOtp() {
    v$.value.mobile.$touch()
    if (v$.value.mobile.$invalid) return

    try {
        // Call backend to send OTP
        api.post(apiRoutes.workerSendOTP, {
            phone: mobile.value,
        }).then(res => {
            if (res.data.success) {
                alert(`OTP sent to ${mobile.value}. Check your SMS.`)
                step.value = 2
            } else {
                alert(res.data.message || 'Failed to send OTP')
            }
        }).catch(error => {
            alert(error.response?.data?.message || 'Unable to send OTP. Please try again.')
        })
    } catch (error) {
        alert('Error sending OTP')
    }
}

// ----------------------
// STEP 2 - VERIFY OTP
// ----------------------
function verifyOtp() {
    v$.value.otp.$touch()
    if (v$.value.otp.$invalid) return

    try {
        // Call backend to verify OTP
        api.post(apiRoutes.workerVerifyOTP, {
            phone: mobile.value,
            otp: otp.value,
        }).then(res => {
            if (res.data.success) {
                alert("OTP Verified!")
                step.value = 3
            } else {
                alert(res.data.message || "Invalid OTP")
            }
        }).catch(error => {
            alert(error.response?.data?.message || 'OTP verification failed')
        })
    } catch (error) {
        alert('Error verifying OTP')
    }
}

function resendOtp() {
    try {
        // Call backend to resend OTP
        api.post(apiRoutes.workerSendOTP, {
            phone: mobile.value,
        }).then(res => {
            if (res.data.success) {
                alert(`OTP resent to ${mobile.value}. Check your SMS.`)
            } else {
                alert(res.data.message || 'Failed to resend OTP')
            }
        }).catch(error => {
            alert(error.response?.data?.message || 'Unable to resend OTP. Please try again.')
        })
    } catch (error) {
        alert('Error resending OTP')
    }
}

// ----------------------
// STEP 3 - CHANGE PASSWORD
// ----------------------
async function changePassword() {
    v$.value.newPassword.$touch()
    v$.value.confirmPassword.$touch()

    if (v$.value.newPassword.$invalid || v$.value.confirmPassword.$invalid) return

    try {
        await api.post(apiRoutes.workerForgotPassword, {
            phone: mobile.value,
            password: newPassword.value,
        })
        alert("Password changed successfully!")
        router.push('/worker-login')
    } catch (err) {
        alert(
            "Failed!\n" +
            Object.values(err.response?.data?.errors || {}).flat().join("\n")
        )
    }
}

function goBack() {
    router.back()
}
</script>
