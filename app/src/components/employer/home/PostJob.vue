<template>
    <BackButtonAppBar />

    <v-container fluid class="post-job-page">
        <v-card elevation="0" class="post-job-card">
            <div class="post-job-heading">
                <span class="post-job-heading-icon"><v-icon icon="mdi-wall" /></span>
                <div>
                    <v-card-title>Post a New Job</v-card-title>
                    <p>Create opportunities. Build a stronger Himachal.</p>
                </div>
            </div>

            <v-form ref="jobForm" class="post-job-form" lazy-validation @submit.prevent="submitForm">

                <!-- SECTION 1: JOB INFO -->
                <h4 class="section-title"><v-icon icon="mdi-briefcase" />Job Information</h4>

                <v-row dense>

                    <!-- Job Title -->
                    <v-col cols="12" sm="6">
                        <v-text-field v-model="form.title" label="Job Title *" prepend-inner-icon="mdi-briefcase"
                            :error="v$.form.title.$error"
                            :error-messages="v$.form.title.$errors.map(() => 'Job title is required')" outlined dense />
                    </v-col>

                    <!-- Category -->
                    <v-col cols="12" sm="6">
                        <v-select v-model="form.category" label="Job Category *" :items="categories" multiple
                            item-title="name" item-value="id" prepend-inner-icon="mdi-hammer-wrench"
                            :error="v$.form.category.$error"
                            :error-messages="v$.form.category.$errors.map(() => 'Category is required')" outlined
                            dense />
                    </v-col>

                    <!-- Dates -->
                    <v-col cols="12" sm="6">
                        <v-text-field v-model="form.startDate" label="Start Date *" type="date"
                            prepend-inner-icon="mdi-calendar-start" :error="v$.form.startDate.$error"
                            :error-messages="v$.form.startDate.$errors.map(() => 'Start date required')" outlined
                            dense />
                    </v-col>

                    <v-col cols="12" sm="6">
                        <v-text-field v-model="form.endDate" label="End Date *" type="date"
                            prepend-inner-icon="mdi-calendar-end" :error="v$.form.endDate.$error"
                            :error-messages="v$.form.endDate.$errors.map(() => 'End date required')" outlined dense />
                    </v-col>

                    <!-- Duration -->
                    <v-col cols="12">
                        <v-text-field v-model="form.duration" label="Work Duration (Days)" type="number"
                            prepend-inner-icon="mdi-clock-outline" outlined dense />
                    </v-col>
                </v-row>

                <!-- SECTION 2: ADDRESS -->
                <h4 class="section-title"><v-icon icon="mdi-map-marker" />Job Address</h4>

                <v-row dense>

                    <v-col cols="12">
                        <v-textarea v-model="form.address" label="Full Address *" prepend-inner-icon="mdi-map-marker"
                            :error="v$.form.address.$error"
                            :error-messages="v$.form.address.$errors.map(() => 'Address required')" outlined rows="2"
                            dense />
                    </v-col>

                    <!-- State -->
                    <v-col cols="12" sm="6">
                        <v-select v-model="form.state" label="राज्य - State *" :items="states" item-title="state_name"
                            item-value="lgd_code" :error="v$.form.state.$error"
                            :error-messages="v$.form.state.$errors.map(() => 'State required')"
                            @update:modelValue="getDistrict" />
                    </v-col>

                    <!-- District -->
                    <v-col cols="12" sm="6">
                        <v-select v-model="form.district" label="जिला - District *" :items="districts"
                            item-value="lgd_code" item-title="district_name" :error="v$.form.district.$error"
                            :error-messages="v$.form.district.$errors.map(() => 'District required')" />
                    </v-col>

                    <!-- Pincode -->
                    <v-col cols="12" sm="6">
                        <v-text-field v-model="form.pincode" label="Pincode *" type="number"
                            prepend-inner-icon="mdi-map-marker-radius" :error="v$.form.pincode.$error" :error-messages="v$.form.pincode.$errors.map(e =>
                            e.$validator === 'minLength' ? 'Pincode must be 6 digits' : 'Pincode required'
                        )" outlined dense />
                    </v-col>

                    <!-- Map Selector -->
                    <v-col cols="12" sm="6">
                        <v-btn class="map-button" block @click="openMap"><v-icon icon="mdi-map-outline" />Select Location on Map</v-btn>
                    </v-col>

                    <v-col cols="12" sm="6">
                        <v-text-field v-model="form.latitude" label="Latitude" readonly outlined dense />
                    </v-col>

                    <v-col cols="12" sm="6">
                        <v-text-field v-model="form.longitude" label="Longitude" readonly outlined dense />
                    </v-col>
                </v-row>

                <!-- SECTION 3: DESCRIPTION -->
                <h4 class="section-title"><v-icon icon="mdi-file-document" />Work Description</h4>

                <v-row dense>

                    <v-col cols="12">
                        <v-textarea v-model="form.description" label="Job Description *" prepend-inner-icon="mdi-text"
                            :error="v$.form.description.$error"
                            :error-messages="v$.form.description.$errors.map(() => 'Description is required')" outlined
                            rows="3" dense />
                    </v-col>

                    <v-col cols="12" sm="6">
                        <v-text-field v-model="form.tools" label="Tools Required" prepend-inner-icon="mdi-toolbox"
                            outlined dense hint="Separate with commas" />
                    </v-col>

                    <v-col cols="12" sm="6">
                        <v-text-field v-model="form.requiredPeople" label="Required People *" type="number"
                            prepend-inner-icon="mdi-account-group" :error="v$.form.requiredPeople.$error"
                            :error-messages="v$.form.requiredPeople.$errors.map(() => 'Required people is mandatory')"
                            outlined dense />
                    </v-col>

                    <v-col cols="12" sm="6">
                        <v-text-field v-model="form.workTime" label="Work Time (e.g. 9 AM - 6 PM)"
                            prepend-inner-icon="mdi-clock-time-four" outlined dense />
                    </v-col>

                    <!-- Work Type -->
                    <v-col cols="12" sm="6">
                        <v-select v-model="form.workType" label="Preferred Work Type *"
                            prepend-inner-icon="mdi-briefcase" :items="['Daily Wage', 'Contract']" :error="v$.form.workType.$error"
                            :error-messages="v$.form.workType.$errors.map(() => 'Work type required')" outlined dense />
                    </v-col>
                    <!-- Duration -->
                    <v-col cols="12" sm="6">
                        <v-text-field v-model="form.rate" label="Work Rate/Day Rs" type="number"
                            prepend-inner-icon="mdi-clock-outline" outlined dense />
                    </v-col>
                </v-row>

                <!-- Facilities -->
                <h4 class="section-title"><v-icon icon="mdi-cog" />Facilities Provided</h4>

                <v-row dense>
                    <v-col cols="12">
                        <v-select v-model="form.facilitie" label="Facilities" :items="facilities" item-title="name"
                            item-value="id" prepend-inner-icon="mdi-format-list-bulleted" multiple chips />
                    </v-col>
                </v-row>

                <!-- Submit -->
                <v-btn class="post-job-submit employer-primary-action" type="submit" block>
                    <v-icon>mdi-send</v-icon> Post Job
                </v-btn>

            </v-form>

            <!-- MAP DIALOG -->
            <v-dialog v-model="showMap" max-width="600px">
                <v-card>
                    <v-card-title>Select Location</v-card-title>

                    <v-card-text>
                        <div id="mapContainer" style="width:100%; height:400px;"></div>
                        <v-btn class="mt-3" small color="primary" @click="useCurrentLocation">Use My Location</v-btn>
                    </v-card-text>

                    <v-card-actions>
                        <v-spacer></v-spacer>
                        <v-btn color="primary" @click="confirmLocation" variant="tonal">Confirm</v-btn>
                        <v-btn color="error" @click="showMap = false" variant="tonal">Cancel</v-btn>
                    </v-card-actions>
                </v-card>
            </v-dialog>

        </v-card>
    </v-container>
</template>

<script>
import BackButtonAppBar from "@/components/header/BackButtonAppBar.vue";
import { Geolocation } from "@capacitor/geolocation";
import api from "@/services/api.js";
import apiRoutes from "@/services/apiRoutes.js";

// Vuelidate
import useVuelidate from "@vuelidate/core";
import { required, minLength, numeric } from "@vuelidate/validators";


export default {
    components: { BackButtonAppBar },

    data() {
        return {
            v$: null,

            showMap: false,
            mapObj: null,
            markerObj: null,
            selectedLocation: null,

            categories: [

            ],

            // facilities: [
            //     { name: "Water", icon: "mdi-water" },
            //     { name: "Food", icon: "mdi-food" },
            //     { name: "Shelter", icon: "mdi-home" },
            //     { name: "Safety", icon: "mdi-shield-check" },
            //     { name: "First Aid", icon: "mdi-hospital-box" },
            // ],

            form: {
                title: "",
                category: null,
                startDate: "",
                endDate: "",
                duration: "",
                address: "",
                pincode: "",
                state: null,
                description: "",
                tools: "",
                requiredPeople: "",
                workTime: "",
                facilitie: null,
                latitude: "",
                longitude: "",
                district: null,
                workType: "",
                rate: ""
            },
            states: [],
            districts: [],
            facilities: [],
        };
    },
    validations() {
        return {
            form: {
                title: { required },
                category: { required },
                address: { required },
                pincode: { required, numeric, minLength: minLength(6) },
                state: { required },
                district: { required },
                description: { required },
                requiredPeople: { required, numeric },
                workType: { required },
                startDate: { required },
                endDate: { required },
                //facilitie: { required }
            }
        };
    },
    created() {
        this.v$ = useVuelidate();
    },


    methods: {
        // toggleFacility(fac) {
        //     const i = this.form.facilities.indexOf(fac);
        //     if (i > -1) this.form.facilities.splice(i, 1);
        //     else this.form.facilities.push(fac);
        // },

        async submitForm() {
            // if (this.$refs.jobForm.validate()) {
            //     //console.log("Job Posted:", this.form);
            //     alert("Job posted successfully!");
            // }

            const isValid = await this.v$.$validate();

            if (!isValid) {
                alert("Please fill all required fields.");
                return;
            }


            try {
                const employerData = JSON.parse(localStorage.getItem("labour_currentUser"));
                const res = await api.post(apiRoutes.employerJobPost, {

                    employer_id: employerData.employer.id,
                    title: this.form.title,
                    description: this.form.description,
                    skills_id: this.form.category,
                    address: this.form.address,
                    // qualification :
                    job_type: this.form.workType,
                    tools_required: this.form.tools,
                    required_people: this.form.requiredPeople,
                    work_time: this.form.workTime,
                    work_duration: this.form.duration,
                    lat: this.form.latitude,
                    long: this.form.longitude,
                    start_date: this.form.startDate,
                    end_date: this.form.endDate,
                    state: this.form.state.toString(),
                    district: this.form.district.toString(),
                    pincode: this.form.pincode,
                    facilities: this.form.facilitie,
                    rate: this.form.rate,
                });
                alert('Success !!');
                //console.log("Success:", res.data)
                this.$router.push('/employer-dashboard-home-myjob');

            } catch (err) {
                alert(
                    "Error !!\n" +
                    Object.values(err.response?.data?.errors || {}).flat().join("\n")
                )
                //console.error("Error post:", err)
            }
        },
        openMap() {
            this.showMap = true;
            this.selectedLocation = {
                lat: this.form.latitude,
                lng: this.form.longitude,
            };

            setTimeout(() => this.initMap(), 350);
        },

        loadMapplsScript() {
            return new Promise((resolve) => {
                if (window.mappls) return resolve();

                const script = document.createElement("script");
                script.src =
                    "https://apis.mappls.com/advancedmaps/api/" + apiRoutes.mapSecretKey + "/map_sdk?v=3.0&layer=vector";
                script.async = true;
                script.onload = resolve;
                document.body.appendChild(script);
            });
        },
        getPrimaryColor() {
            return getComputedStyle(document.documentElement)
                .getPropertyValue("--v-primary-base") // Vuetify 3 variable
                .trim() || "#1976D2"; // fallback
        },

        // Create SVG marker dynamically
        createMarkerSVG(color) {
            return `
        <svg width="32" height="32" viewBox="0 0 24 24" fill="${color}" xmlns="http://www.w3.org/2000/svg">
            <path d="M12 2C8.1 2 5 5.1 5 9c0 5.2 7 13 7 13s7-7.8 7-13c0-3.9-3.1-7-7-7zm0 9.5c-1.4 0-2.5-1.1-2.5-2.5S10.6 6.5 12 6.5s2.5 1.1 2.5 2.5S13.4 11.5 12 11.5z"/>
        </svg>
        `;
        },

        // Convert SVG to Base64 for Mappls Marker icon
        createMarkerIcon(color) {
            return "data:image/svg+xml;base64," + btoa(this.createMarkerSVG(color));
        },
        async initMap() {
            await this.loadMapplsScript();

            // Always reset when opening dialog
            this.mapObj = null;
            this.markerObj = null;

            const lat = this.form.latitude || 28.6139;
            const lng = this.form.longitude || 77.209;

            this.selectedLocation = { lat, lng };

            this.mapObj = new window.mappls.Map("mapContainer", {
                center: { lat, lng },
                zoom: 14,
            });

            // Draw initial marker
            this.markerObj = new window.mappls.Marker({
                map: this.mapObj,
                position: { lat, lng },
                draggable: true,
                icon: this.createMarkerIcon(this.getPrimaryColor()),
            });

            this.markerObj.on("dragend", (evt) => {
                ////console.log(evt)
                const lat = evt.target._lngLat.lat || evt.latitude;
                const lng = evt.target._lngLat.lng || evt.longitude;

                this.selectedLocation = { lat, lng };

                this.form.latitude = this.selectedLocation.lat;
                this.form.longitude = this.selectedLocation.lng;
                //console.log("Dragged:", this.selectedLocation);
            });

            this.mapObj.on("click", (e) => {

                //console.log('dd', e.lngLat)
                const lat = e.lngLat.lat;
                const lng = e.lngLat.lng;

                this.selectedLocation = { lat, lng };

                // If marker exists -> move it
                if (this.markerObj) {
                    this.markerObj.setPosition({ lat, lng });
                } else {
                    // Create new marker
                    this.markerObj = new mappls.Marker({
                        map: this.mapObj,
                        position: { lat, lng },
                        draggable: true,
                        icon: this.createMarkerIcon(this.getPrimaryColor())
                    });

                    // Add dragend event only once
                    this.markerObj.on("dragend", (evt) => {
                        ////console.log(evt)
                        const lat = evt.target._lngLat.lat || evt.latitude;
                        const lng = evt.target._lngLat.lng || evt.longitude;

                        this.selectedLocation = { lat, lng };
                        //console.log("Dragged:", this.selectedLocation);
                    });
                }

                this.form.latitude = this.selectedLocation.lat;
                this.form.longitude = this.selectedLocation.lng;

                //console.log("Clicked:", this.selectedLocation);
            });



            // setTimeout(() => this.mapObj.invalidateSize(), 300);
        },

        async useCurrentLocation() {
            try {
                const coords = await Geolocation.getCurrentPosition();
                this.form.latitude = coords.coords.latitude;
                this.form.longitude = coords.coords.longitude;

                const lat = this.form.latitude;
                const lng = this.form.longitude;

                this.markerObj.setPosition({ lat, lng });
                //console.log("GPS allowed");
            } catch (e) {
                //console.log("GPS not allowed");
            }

        },

        confirmLocation() {
            if (!this.selectedLocation || !this.selectedLocation.lat) {
                alert("Please select a location first!");
                return;
            }

            //console.log(this.selectedLocation);
            this.form.latitude = this.selectedLocation.lat;
            this.form.longitude = this.selectedLocation.lng;

            this.showMap = false;
        },
        ///get data for form
        async getState() {
            try {
                const res = await api.get(apiRoutes.getState);
                //console.log("state:", res.data);

                this.states = res.data.data;
                this.form.state = "";
                this.form.district = "";

                ////console.log(form.value);
                ////console.log("Success: states:", states);

            } catch (err) {
                alert(
                    "Error !!\n" +
                    Object.values(err.response?.data?.errors || {}).flat().join("\n")
                );
                //console.error("Error fetching state", err);
            }

        },
        async getDistrict() {
            this.form.district = "";
            if (!this.form.state) return
            try {
                const res = await api.post(apiRoutes.getDistrict, { state_id: this.form.state });
                ////console.log("Success:district", res.data);

                this.districts = res.data.data;
                //console.log("Success: districts:", this.districts);

            } catch (err) {
                alert(
                    "Error !!\n" +
                    Object.values(err.response?.data?.errors || {}).flat().join("\n")
                );
                //console.error("Error fetching districts:", err);
            }

        },
        async getFacilities() {
            try {
                const res = await api.get(apiRoutes.getFacilities);
                //console.log('Facilities', res.data)
                if (res.data && res.data.data) {
                    this.facilities = res.data.data; // expected: [{id, name}]
                }
            } catch (error) {
                //console.error("Error fetching facilities:", error);
                alert("Failed to load facilities.");
            }

        },
        async getSkills() {

            try {
                const res = await api.get(apiRoutes.getAllSkill);
                //console.log('skills', res.data)
                if (res.data && res.data.data) {
                    this.categories = res.data.data; // expected: [{id, name}]
                }
            } catch (error) {
                //console.error("Error fetching skills:", error);
                alert("Failed to load skills.");
            }

        }

    },

    mounted() {
        this.useCurrentLocation(),
            this.getState(),
            this.getFacilities(),
            this.getSkills()

    },
};
</script>

<style scoped>
.post-job-page {
    position: relative;
    min-height: calc(100vh - 100px);
    padding: 22px 18px 96px !important;
    overflow: hidden;
    color: #0b316d;
    background: #f8fcff url('@/assets/authenticated-background.png') center/100% 100% no-repeat fixed;
}

.post-job-page::before,
.post-job-page::after {
    content: '';
    position: absolute;
    z-index: 0;
    pointer-events: none;
}

.post-job-page::before {
    top: 9%;
    left: -85px;
    width: 250px;
    height: 520px;
    opacity: .11;
    background: #1179d4;
    clip-path: polygon(0 24%, 27% 24%, 34% 7%, 40% 24%, 83% 24%, 88% 31%, 43% 31%, 43% 100%, 32% 100%, 32% 31%, 0 31%);
}

.post-job-page::after {
    right: -100px;
    bottom: 8%;
    width: 430px;
    height: 300px;
    opacity: .13;
    background: linear-gradient(145deg, transparent 0 36%, #268bdc 37% 45%, transparent 46% 55%, #8bc4f3 56% 65%, transparent 66%);
    clip-path: polygon(0 100%, 17% 52%, 32% 70%, 49% 17%, 66% 68%, 80% 37%, 100% 78%, 100% 100%);
}

.post-job-card {
    position: relative;
    z-index: 1;
    width: min(760px, 100%);
    margin: 0 auto;
    padding: 20px 20px 18px;
    border: 1px solid #d8e9f8;
    border-radius: 20px !important;
    background: rgba(255, 255, 255, .95) !important;
    box-shadow: 0 10px 28px rgba(10, 73, 134, .17) !important;
}

.post-job-heading {
    display: flex;
    align-items: center;
    gap: 16px;
    padding: 0 12px 15px;
}

.post-job-heading-icon {
    display: grid;
    place-items: center;
    flex: 0 0 50px;
    width: 50px;
    height: 50px;
    border-radius: 9px;
    color: #fff;
    background: linear-gradient(135deg, #ff8b43, #eb4d25);
    box-shadow: 0 5px 11px rgba(223, 74, 26, .22);
}

.post-job-heading-icon .v-icon { font-size: 34px; }
.post-job-heading .v-card-title { padding: 0; color: #082e67; font-size: clamp(25px, 3.4vw, 35px); line-height: 1.1; font-weight: 800; }
.post-job-heading p { margin: 4px 0 0; color: #6c7f9e; font-size: clamp(14px, 2vw, 19px); }

.section-title {
    display: flex;
    align-items: center;
    gap: 16px;
    min-height: 56px;
    margin: 14px 0 10px;
    padding: 10px 20px;
    border-radius: 13px;
    color: #082f69;
    background: linear-gradient(90deg, #eaf5ff, #f4f9fd);
    font-size: clamp(19px, 2.5vw, 25px);
    font-weight: 800;
}

.section-title .v-icon { color: #0875dc; font-size: 31px; }
.post-job-form :deep(.v-row) { margin: -5px -8px; }
.post-job-form :deep(.v-col) { padding: 5px 8px; }

.post-job-form :deep(.v-field) {
    min-height: 66px;
    border-radius: 12px;
    color: #afcae5;
    background: linear-gradient(120deg, #fff, #f9fcff);
    box-shadow: 0 2px 6px rgba(11, 83, 151, .08);
}

.post-job-form :deep(.v-field__outline) { --v-field-border-opacity: 1; }
.post-job-form :deep(.v-field__prepend-inner) { align-items: center; padding-right: 13px; color: #0874d8; }
.post-job-form :deep(.v-field__prepend-inner .v-icon) { font-size: 29px; opacity: 1; }
.post-job-form :deep(.v-field__input) { min-height: 64px; color: #173b70; font-size: 16px; }
.post-job-form :deep(.v-label) { color: #173b70; opacity: 1; }
.post-job-form :deep(input::placeholder),
.post-job-form :deep(textarea::placeholder) { color: #8a99b0; opacity: 1; }
.post-job-form :deep(.v-field__append-inner) { color: #0b376c; }
.post-job-form :deep(.v-messages__message) { color: #d22c37; font-size: 12px; }
.post-job-form :deep(.v-chip) { background: #e3f2ff; color: #075cb7; }
.post-job-form :deep(.v-textarea .v-field__prepend-inner) { align-items: flex-start; padding-top: 10px; }

.map-button,
.post-job-submit {
    min-height: 66px;
    border-radius: 12px;
    color: #fff !important;
    background: linear-gradient(115deg, #1689ed, #0768d7) !important;
    box-shadow: 0 5px 11px rgba(4, 92, 185, .24) !important;
    font-size: 15px;
    font-weight: 800;
    letter-spacing: .15px;
}

.map-button .v-icon,
.post-job-submit .v-icon { margin-right: 12px; font-size: 28px; }
.post-job-submit { height: 52px !important; margin-top: 18px; font-size: 17px; text-transform: uppercase; }
.post-job-submit .v-icon { font-size: 25px; transform: rotate(-8deg); }

.post-job-card :deep(.v-dialog .v-card) { border-radius: 18px; }

@media (max-width: 650px) {
    .post-job-page { padding: 14px 8px 82px !important; background-size: auto 100%; }
    .post-job-card { padding: 15px 10px 13px; border-radius: 16px !important; }
    .post-job-heading { gap: 11px; padding: 0 4px 10px; }
    .post-job-heading-icon { flex-basis: 43px; width: 43px; height: 43px; }
    .post-job-heading-icon .v-icon { font-size: 29px; }
    .post-job-heading .v-card-title { font-size: 22px; }
    .post-job-heading p { font-size: 12px; }
    .section-title { min-height: 46px; margin: 10px 0 8px; padding: 8px 13px; gap: 10px; border-radius: 10px; font-size: 18px; }
    .section-title .v-icon { font-size: 26px; }
    .post-job-form :deep(.v-row) { margin: -4px; }
    .post-job-form :deep(.v-col) { padding: 4px; }
    .post-job-form :deep(.v-field) { min-height: 56px; border-radius: 10px; }
    .post-job-form :deep(.v-field__input) { min-height: 54px; padding-inline: 11px; font-size: 14px; }
    .post-job-form :deep(.v-field__prepend-inner) { padding-right: 8px; }
    .post-job-form :deep(.v-field__prepend-inner .v-icon) { font-size: 24px; }
    .map-button { min-height: 56px; font-size: 13px; }
    .post-job-submit { height: 52px !important; font-size: 17px; }
}
</style>
