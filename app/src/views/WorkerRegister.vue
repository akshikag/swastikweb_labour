<template>
    <v-app>
        <v-app-bar color="primary" dark flat style="position: sticky;" class="py-2 pt-3 px-1">
            <v-row align="center" class="fill-height" no-gutters>
                <v-col class="d-flex align-center ms-2 mt-2" cols="auto" style="gap: 12px;">
                    <div
                        style="width: 32px;height: 32px;border: 2px solid white;border-radius: 50%;overflow: hidden; display: flex;justify-content: center;align-items: center;">
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
            <v-container class="py-12 fill-height d-flex align-center" fluid>
                <v-row>
                    <v-col cols="12">
                        <v-card class="pa-6 py-10" elevation="6">

                            <v-sheet color="primary" rounded="circle" width="72" height="72"
                                class="d-flex align-center justify-center mx-auto mb-4" elevation="4">
                                <v-icon color="white" size="40">mdi-account-plus</v-icon>
                            </v-sheet>

                            <v-card-title class="text-h5 font-weight-bold text-center mb-5">
                                Worker Register
                            </v-card-title>

                            <!-- Step 1 -->
                            <v-form v-if="step === 1" @submit.prevent="sendOtp">

                                <v-text-field v-model="form.name" label="Full Name *" variant="filled"
                                    :error="v$.form.name.$error"
                                    :error-messages="v$.form.name.$errors.map(e => e.$message)" />

                                <v-text-field v-model="form.email" label="Email (Optional)" variant="filled"
                                    type="email" :error="v$.form.email.$error"
                                    :error-messages="v$.form.email.$errors.map(e => e.$message)" />

                                <v-text-field v-model="form.phone" label="Phone Number *" variant="filled"
  maxlength="10" :counter="10"   :error="v$.form.phone.$error" @input="form.phone = form.phone.replace(/\D/g, '').slice(0, 10)"
                                    :error-messages="v$.form.phone.$errors.map(e => e.$message)" />

                                <v-text-field v-model="form.password" label="Password *" type="password" variant="filled"
                                    :error="v$.form.password.$error"
                                    :error-messages="v$.form.password.$errors.map(e => e.$message)" />

                                <!-- Agreement Checkbox -->
                                <v-checkbox v-model="isAgreed" hide-details color="primary">
                                    <template #label>
                                        I agree to the
                                        <span class="text-primary" style="cursor: pointer; text-decoration: underline;"
                                            @click.stop="showTerms = true">
                                            Terms & Conditions
                                        </span>
                                    </template>
                                </v-checkbox>
                                <!-- Terms Modal -->
                                <v-dialog v-model="showTerms" width="600">
                                    <v-card>
                                        <v-card-title class="text-h6">Terms & Conditions</v-card-title>
                                        <v-card-text>
                                            {{ terms }}
                                        </v-card-text>

                                        <v-card-actions>
                                            <v-spacer></v-spacer>
                                            <v-btn color="primary" @click="showTerms = false">Close</v-btn>
                                        </v-card-actions>
                                    </v-card>
                                </v-dialog>
                                <!--  -->

                                <v-btn type="submit" color="primary" block class="mt-4">Send OTP</v-btn>

                                <div class="text-center mt-3">
                                    <router-link to="/worker-login">Already have an account? Login</router-link>
                                </div>
                            </v-form>

                            <!-- Step 2 -->
                            <v-form v-if="step === 2" @submit.prevent="verifyOtp">
                                <v-text-field v-model="otp" label="Enter OTP *" variant="filled" required />
                                <v-btn type="submit" color="primary" block class="mt-4">Verify OTP</v-btn>

                                <div class="text-center mt-4">
 <v-btn
    class="resend-btn"
    color="primary"
    variant="outlined"
    :disabled="
        resendTimer > 0 ||
        isResendingOtp ||
        resendCount >= maxResendCount
    "
    :loading="isResendingOtp"
    @click="resendOtp"
>
    <template v-if="resendCount >= maxResendCount">
        Resend Limit Reached
    </template>

    <template v-else-if="resendTimer > 0">
        Resend OTP ({{ formattedResendTimer }})
    </template>

    <template v-else>
        Resend OTP
    </template>
</v-btn>

<div
    v-if="resendCount >= maxResendCount"
    class="text-error text-caption mt-2"
>
    You have reached the maximum of {{ maxResendCount }} resend attempts.
</div>
</div>

                            </v-form>

                        </v-card>
                    </v-col>
                </v-row>
            </v-container>
        </v-main>
    </v-app>
</template>

<script>
import useVuelidate from "@vuelidate/core";
import { required, email, numeric, minLength, helpers } from "@vuelidate/validators";

import api from "@/services/api.js";
import apiRoutes from "@/services/apiRoutes.js";

export default {
    name: "WorkerRegister",

    data() {
        return {
            terms: "",
            isAgreed: false,
            showTerms: false,
            step: 1,
            otp: "123456",
            resendTimer: 0,
        resendTimerInterval: null,
        resendOtpDelay: 60,
        isResendingOtp: false,
        resendCount: 0,
        maxResendCount: 3,
            form: {
                name: "",
                email: "",
                phone: "",
                password: "",
            },
        };
    },
computed: {
    formattedResendTimer() {
        const minutes = Math.floor(this.resendTimer / 60);
        const seconds = this.resendTimer % 60;

        return `${String(minutes).padStart(2, "0")}:${String(seconds).padStart(2, "0")}`;
    },
},

    validations() {
        return {
            form: {
                name: { required },

                email: {
                    email: helpers.withMessage("Invalid email", email),
                },

                phone: {
                    required,
                    numeric: helpers.withMessage("Phone must be digits", numeric),
                    minLength: helpers.withMessage("Phone must be 10 digits", minLength(10)),
                },

                password: {
                    required,
                    minLength: helpers.withMessage("Minimum 6 characters", minLength(6)),
                },
            },
        };
    },

    setup() {
        return { v$: useVuelidate() };
    },

    methods: {
    async sendOtp() {
    if (!this.isAgreed) {
        alert("You must agree to the Terms & Conditions before submitting.");
        return;
    }

    const valid = await this.v$.$validate();

    if (!valid) {
        alert("Please fix validation errors");
        return;
    }

    try {
        // First check if phone already registered
        const checkRes = await api.post('worker/check-phone', { phone: this.form.phone });

        if (checkRes.data?.exists) {
            alert('Phone number already registered. Please login or use a different number.');
            return;
        }

        // Call backend to send OTP
        const res = await api.post(apiRoutes.workerSendOTP, {
            phone: this.form.phone,
        });

        if (res.data.success) {
            // Reset resend attempts for a new OTP process
            this.resendCount = 0;
            this.otp = "123456";

            alert(`OTP sent to ${this.form.phone}. Check your SMS.`);

            this.step = 2;

            // Start timer immediately after first OTP is sent
            this.startResendTimer();
        } else {
            alert(res.data.message || "Failed to send OTP");
        }
    } catch (error) {
        alert(
            error.response?.data?.message ||
            "Unable to send OTP. Please try again."
        );
    }
},

        async verifyOtp() {
            if (!this.otp) {
                alert("Please enter OTP");
                return;
            }

            try {
                // Verify OTP with backend
                const res = await api.post(apiRoutes.workerVerifyOTP, {
                    phone: this.form.phone,
                    otp: this.otp,
                });

                if (res.data.success) {
                    // OTP verified, now register
                    const registerRes = await api.post(apiRoutes.workerRegister, this.form);

                    alert("Registration successful!");
                    localStorage.setItem("labour_currentUser", JSON.stringify(registerRes.data));
                    localStorage.setItem("labouchowk_userType", "worker");

                    this.$router.push("/worker-dashboard-profile");
                } else {
                    alert(res.data.message || "OTP verification failed");
                }
            } catch (err) {
                alert(
                    err.response?.data?.message ||
                    Object.values(err.response?.data?.errors || {})
                        .flat()
                        .join("\n")
                );
            }
        },

async resendOtp() {
    // Stop resend during timer, API request, or after 3 attempts
    if (
        this.resendTimer > 0 ||
        this.isResendingOtp ||
        this.resendCount >= this.maxResendCount
    ) {
        return;
    }

    this.isResendingOtp = true;

    try {
        const res = await api.post(apiRoutes.workerSendOTP, {
            phone: this.form.phone,
        });

        if (res.data.success) {
            // Count only successful resend attempts
            this.resendCount++;

            this.otp = "123456";

            alert(
                `OTP resent successfully. Attempt ${this.resendCount} of ${this.maxResendCount}. Check your SMS.`
            );

            // Start timer only when more resend attempts remain
            if (this.resendCount < this.maxResendCount) {
                this.startResendTimer();
            } else {
                this.clearResendTimer();
                this.resendTimer = 0;
            }
        } else {
            alert(res.data.message || "Failed to resend OTP");
        }
    } catch (error) {
        alert(
            error.response?.data?.message ||
            "Unable to resend OTP. Please try again."
        );
    } finally {
        this.isResendingOtp = false;
    }
},

startResendTimer() {
    this.clearResendTimer();

    this.resendTimer = this.resendOtpDelay;

    this.resendTimerInterval = window.setInterval(() => {
        if (this.resendTimer > 0) {
            this.resendTimer--;
        }

        if (this.resendTimer <= 0) {
            this.clearResendTimer();
        }
    }, 1000);
},

clearResendTimer() {
    if (this.resendTimerInterval) {
        window.clearInterval(this.resendTimerInterval);
        this.resendTimerInterval = null;
    }
},

        goBack() {
            this.$router.back();
        },
        async getConfig() {
            try {

                const res = await api.get(apiRoutes.getAllConfig);
                console.log('config', res.data.data);

                if (res.data && res.data.data) {
                    const configs = res.data.data;

                    this.terms = configs.find(item => item.key === 'worker_agreement')?.value || '';

                }
            } catch (error) {
                //console.error("Failed:", error);
                alert("Failed!!.");
            }

        }
    },
   mounted() {
        this.getConfig();
    },

    beforeUnmount() {
        this.clearResendTimer();
    }
};
</script>

<style scoped>
.resend-btn:disabled,
.resend-btn.v-btn--disabled {
    background-color: #e0e0e0 !important;
    color: #616161 !important;
    border-color: #bdbdbd !important;
    opacity: 1 !important;
}
</style>
