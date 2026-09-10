<template>
    <section class="employer-register-page">

                <div class="register-board-introduction">
                    <h1><span>हिमाचल प्रदेश भवन एवं</span><strong>अन्य सन्निर्माण कामगार कल्याण बोर्ड</strong></h1>
                    <p>कौशल से अवसर तक - निर्माण क्षेत्र का विश्वसनीय मंच</p>
                </div>

                <v-card class="register-card" elevation="0">
                    <span class="register-avatar"><v-icon>mdi-account-plus</v-icon></span>
                    <h2>Employer Register / नियोक्ता रजिस्टर</h2>
                    <p class="register-subtitle">Create your account to continue</p>

                    <v-form v-if="step === 1" class="register-form" @submit.prevent="sendOtp">
                        <v-text-field v-model="form.name" placeholder="Full Name *" prepend-inner-icon="mdi-account" variant="outlined" hide-details="auto" :error-messages="v$.form.name.$errors.map(e => e.$message)" />
                        <v-text-field v-model="form.email" placeholder="Email (Optional)" prepend-inner-icon="mdi-email" variant="outlined" type="email" hide-details="auto" :error-messages="v$.form.email.$errors.map(e => e.$message)" />
                        <v-text-field v-model="form.phone" placeholder="Phone Number *" prepend-inner-icon="mdi-phone" variant="outlined" maxlength="10" :counter="10" hide-details="auto" @input="form.phone = form.phone.replace(/\D/g, '').slice(0, 10)" :error-messages="v$.form.phone.$errors.map(e => e.$message)" />
                        <v-text-field v-model="form.password" placeholder="Password *" prepend-inner-icon="mdi-lock" variant="outlined" :type="showPassword ? 'text' : 'password'" hide-details="auto" :error-messages="v$.form.password.$errors.map(e => e.$message)">
                            <template #append-inner><v-icon class="register-visibility" @click="showPassword = !showPassword">{{ showPassword ? 'mdi-eye-off-outline' : 'mdi-eye-outline' }}</v-icon></template>
                        </v-text-field>
                        <small class="register-password-help">At least 6 characters, 1 number, and 1 special character are required.</small>

                        <v-checkbox v-model="isAgreed" class="register-agreement" hide-details color="primary">
                            <template #label>I agree to the <span @click.stop="showTerms = true">Terms &amp; Conditions</span></template>
                        </v-checkbox>

                        <v-btn type="submit" block class="register-submit">Send OTP</v-btn>
                        <router-link class="register-login-link" to="/employer-login">Already have an account? Login</router-link>
                    </v-form>

                    <v-form v-if="step === 2" class="register-form otp-form" @submit.prevent="verifyOtp">
                        <v-text-field v-model="otp" placeholder="Enter OTP *" prepend-inner-icon="mdi-shield-key-outline" variant="outlined" maxlength="6" required hide-details />
                        <v-btn type="submit" block class="register-submit">Verify OTP</v-btn>
                        <div class="otp-resend-wrap">
                            <v-btn class="resend-btn" color="primary" variant="outlined" :disabled="resendTimer > 0 || isResendingOtp || resendCount >= maxResendCount" :loading="isResendingOtp" @click="resendOtp">
                                <template v-if="resendCount >= maxResendCount">Resend Limit Reached</template>
                                <template v-else-if="resendTimer > 0">Resend OTP ({{ formattedResendTimer }})</template>
                                <template v-else>Resend OTP</template>
                            </v-btn>
                            <div v-if="resendCount >= maxResendCount" class="text-error text-caption mt-2">You have reached the maximum of {{ maxResendCount }} resend attempts.</div>
                        </div>
                    </v-form>
                </v-card>

                <v-dialog v-model="showTerms" width="600">
                    <v-card><v-card-title class="text-h6">Terms &amp; Conditions</v-card-title><v-card-text>{{ terms }}</v-card-text><v-card-actions><v-spacer></v-spacer><v-btn color="primary" @click="showTerms = false">Close</v-btn></v-card-actions></v-card>
                </v-dialog>
    </section>
</template>

<script>
import api from "@/services/api.js";
import apiRoutes from "@/services/apiRoutes.js";

// Vuelidate
import useVuelidate from "@vuelidate/core";
import { required, minLength, email, numeric, helpers } from "@vuelidate/validators";

export default {
    name: "EmployerRegister",

   data() {
    return {
        terms: "",
        isAgreed: false,
        showTerms: false,
        showPassword: false,
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
                name: { required: helpers.withMessage("Full name is required", required) },

                email: {
                    email: helpers.withMessage("Invalid email format", email),
                },

                phone: {
                    required: helpers.withMessage("Phone number is required", required),
                    numeric: helpers.withMessage("Phone must be digits only", numeric),
                    minLength: helpers.withMessage("Phone must be 10 digits", minLength(10)),
                },

                password: {
                    required: helpers.withMessage("Password is required", required),
                    minLength: helpers.withMessage("Password must be at least 6 characters", minLength(6)),
                },
            },
        };
    },

    setup() {
        return { v$: useVuelidate() };
    },

    methods: {
        // ===== Step 1 =====
       async sendOtp() {
    if (!this.isAgreed) {
        alert("You must agree to the Terms & Conditions before submitting.");
        return;
    }

    const isValid = await this.v$.$validate();

    if (!isValid) {
        return;
    }

    try {
        // Call backend to send OTP
        const res = await api.post(apiRoutes.employerSendOTP, {
            phone: this.form.phone,
        });

        if (res.data.success) {
            alert(`OTP sent to ${this.form.phone}. Check your SMS.`);
            this.step = 2;
            this.otp = "123456";
            this.resendCount = 0;
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

        // ===== Step 2 =====
        async verifyOtp() {
            if (!this.otp) {
                alert("Please enter OTP");
                return;
            }

            try {
                // Verify OTP with backend
                const res = await api.post(apiRoutes.employerVerifyOTP, {
                    phone: this.form.phone,
                    otp: this.otp,
                });

                if (res.data.success) {
                    // OTP verified, now register
                    const registerRes = await api.post(apiRoutes.employerRegister, this.form);

                    alert("Registration successful!");
                    localStorage.setItem("labour_currentUser", JSON.stringify(registerRes.data));
                    localStorage.setItem("labouchowk_userType", "employer");

                    this.$router.push("/employer-dashboard-profile");
                } else {
                    alert(res.data.message || "OTP verification failed");
                }
            } catch (err) {
                alert(
                    err.response?.data?.message ||
                    "Registration Failed!!\n" +
                    Object.values(err.response?.data?.errors || {}).flat().join("\n")
                );
            }
        },

       async resendOtp() {
    // Prevent resend while countdown is active.
    if (this.resendTimer > 0 || this.isResendingOtp || this.resendCount >= this.maxResendCount) {
        return;
    }

    this.isResendingOtp = true;

    try {
        const res = await api.post(apiRoutes.employerSendOTP, {
            phone: this.form.phone,
        });

        if (res.data.success) {
            this.resendCount++;
            this.otp = "123456";
            alert(`OTP resent! Check your SMS. Attempt ${this.resendCount} of ${this.maxResendCount}`);

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

                    this.terms = configs.find(item => item.key === 'employer_agreement')?.value || '';

                }
            } catch (error) {
                // console.error("Error fetching Failed:", error);
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
.employer-register-app{background:#fff}.employer-register-page{position:relative;display:flex;flex-direction:column;align-items:center;box-sizing:border-box;min-height:100vh;padding:145px 18px 34px;overflow-x:hidden;background:#fff url('@/assets/worker-login-bg.png') center top/100% 100% no-repeat fixed;color:#062761}.register-back{position:absolute;z-index:2;top:16px;left:14px;display:grid;place-items:center;width:39px;height:39px;border:0;border-radius:50%;color:#fff;background:#0871cf;box-shadow:0 4px 8px #0a4d853d;cursor:pointer}.register-back .v-icon{font-size:28px}.register-board-introduction{width:100%;max-width:530px;margin:0 auto 20px;text-align:center}.register-board-introduction h1{margin:0;font-size:clamp(19px,3vw,34px);line-height:1.15;font-weight:800}.register-board-introduction h1 span{display:block;color:#0752a5}.register-board-introduction h1 strong{display:block;color:#c6101c}.register-board-introduction p{margin:7px 0 0;color:#061f4d;font-size:clamp(12px,1.8vw,19px);font-weight:700}.register-card{position:relative;z-index:1;overflow:visible!important;width:min(620px,100%);padding:57px 18px 26px;border:1px solid #d8e8f8;border-radius:26px!important;background:#fffffff2!important;box-shadow:0 8px 20px #12529b1c!important;text-align:center}.register-avatar{position:absolute;z-index:2;top:-28px;left:50%;display:grid;place-items:center;width:64px;height:64px;border-radius:50%;color:#fff;background:#0874db;box-shadow:0 5px 10px #0754a440;transform:translateX(-50%)}.register-avatar .v-icon{font-size:42px;line-height:1}.register-card h2{margin:8px 0 4px;color:#061e4e;font-size:clamp(21px,3.1vw,31px);line-height:1.2;font-weight:800;white-space:normal;overflow-wrap:anywhere}.register-subtitle{margin:0 0 16px;color:#284371;font-size:clamp(15px,2.1vw,21px)}.register-form{display:grid;gap:9px;text-align:left}.register-form :deep(.v-field){min-height:52px;border-radius:10px;background:#f7fbff}.register-form :deep(.v-field__input){min-height:50px;padding-inline:14px;font-size:16px;color:#173867}.register-form :deep(.v-field__prepend-inner){color:#536883}.register-form :deep(.v-field__append-inner){color:#61718d}.register-form :deep(.v-field--variant-outlined .v-field__outline){color:#a9bdd5;opacity:1}.register-form :deep(.v-field--focused .v-field__outline){color:#0871d8}.register-form :deep(.v-messages__message){font-size:12px}.register-visibility{cursor:pointer}.register-password-help{display:block;margin:-5px 0 0 27px;color:#5c6d89;font-size:11px;line-height:1.2}.register-agreement{margin:-2px 0 0!important;font-size:14px}.register-agreement :deep(.v-label){color:#172e5c;opacity:1}.register-agreement span{margin-left:4px;color:#075fcc;text-decoration:underline;cursor:pointer}.register-submit{height:52px!important;margin-top:2px;border-radius:10px;background:linear-gradient(110deg,#198ce9,#0873dc)!important;color:#fff;font-size:17px!important;font-weight:800;letter-spacing:.8px}.register-login-link{display:block;margin-top:3px;color:#5300bf;font-size:14px;text-align:center;text-decoration:underline}.otp-form{max-width:380px;margin:0 auto}.otp-resend-wrap{text-align:center}.resend-btn{height:42px;border-radius:9px;font-weight:700}.resend-btn:disabled,.resend-btn.v-btn--disabled{background-color:#e0e0e0!important;color:#616161!important;border-color:#bdbdbd!important;opacity:1!important}
@media(min-width:651px){.employer-register-page{padding-top:210px}.register-card{padding:66px 38px 34px}.register-form{gap:14px}.register-form :deep(.v-field){min-height:62px}.register-form :deep(.v-field__input){min-height:60px;font-size:18px}.register-submit{height:62px!important;font-size:21px!important}.register-password-help{font-size:13px}.register-login-link{font-size:16px}}
@media(max-width:390px){.employer-register-page{padding:143px 10px 24px}.register-board-introduction{margin-bottom:16px}.register-card{padding:53px 15px 20px}.register-card h2{font-size:21px}.register-subtitle{font-size:15px}.register-form{gap:7px}.register-form :deep(.v-field){min-height:44px}.register-form :deep(.v-field__input){min-height:42px;font-size:14px}.register-form :deep(.v-field__prepend-inner){padding-right:7px}.register-password-help{font-size:9px;margin-left:20px}.register-agreement{font-size:12px}.register-submit{height:43px!important;font-size:15px!important}.register-login-link{font-size:13px}}
.employer-register-page{min-height:100dvh}
</style>
