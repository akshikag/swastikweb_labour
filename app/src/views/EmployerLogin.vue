<template>
    <v-app>
        <v-app-bar color="primary" dark flat style="position: sticky;" class="pb-2 pt-4 px-2">
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
                                <v-icon color="white" size="36">mdi-account-hard-hat</v-icon>
                            </v-sheet>

                            <v-card-title class="text-h6 font-weight-bold text-center mb-5">
                                Employer Login
                            </v-card-title>

                            <v-form @submit.prevent="login">

                                <!-- MOBILE -->
                                <v-text-field v-model="mobile" label="Mobile Number *" variant="filled"
                                    :error="v$.mobile.$error"
                                    :error-messages="v$.mobile.$errors.map(e => e.$message)" />

                                <!-- PASSWORD -->
                                <v-text-field v-model="password" label="Password *" type="password" variant="filled"
                                    :error="v$.password.$error"
                                    :error-messages="v$.password.$errors.map(e => e.$message)" />

                                <v-btn type="submit" color="primary" block class="mt-4">
                                    Login
                                </v-btn>

                                <router-link to="/employer-forgot-password">Forgot Password</router-link>

                                <div class="text-center mt-3">
                                    <router-link to="/employer-register">Employer Register</router-link>
                                </div>

                            </v-form>

                        </v-card>
                    </v-col>
                </v-row>

            </v-container>
        </v-main>
    </v-app>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

import { useVuelidate } from '@vuelidate/core'
import { required, minLength, maxLength, numeric } from '@vuelidate/validators'

import api from "@/services/api.js";
import apiRoutes from "@/services/apiRoutes.js";

const router = useRouter()

// -------------------- FORM FIELDS --------------------
const mobile = ref('')
const password = ref('')

// -------------------- VALIDATION RULES --------------------
const rules = {
    mobile: {
        required,
        numeric,
        minLength: minLength(10),
        maxLength: maxLength(10)
    },
    password: {
        required,
        minLength: minLength(6)
    }
}

const v$ = useVuelidate(rules, { mobile, password })

// -------------------- LOGIN FUNCTION --------------------
const login = async () => {

    const isValid = await v$.value.$validate()
    if (!isValid) return

    try {
        const res = await api.post(apiRoutes.employerLogin, {
            phone: mobile.value,
            password: password.value
        });

        localStorage.setItem('labour_currentUser', JSON.stringify(res.data))
        localStorage.setItem('labouchowk_userType', 'employer')

        alert("Login successful!")
        router.push('/employer-dashboard-home')

    } catch (err) {
        const data = err.response?.data
        const validationErrors = Object.values(data?.errors || {}).flat()
        alert(validationErrors.join("\n") || data?.message || "Unable to login. Please try again.")
    }
}

function goBack() {
    router.back()
}
</script>
