<!-- ------------------ -->
<template>
    <BackButtonAppBar />
    <main class="location-page">
        <header class="location-heading">
            <h1>स्थान जानकारी - Location Information</h1>
            <div class="heading-rule" aria-hidden="true"><span></span><i></i><span></span></div>
        </header>

        <v-form class="location-form-card" @submit.prevent="submitForm">
            <div class="location-field">
                <span class="location-icon"><v-icon icon="mdi-office-building-marker" /></span>
                <div class="location-control">
                    <label>कार्यस्थल / कार्यालय का पता - Worksite / Office Address</label>
                    <v-text-field v-model="form.location" placeholder="Enter worksite / office address"
                        variant="outlined" hide-details="auto" />
                </div>
            </div>

            <div class="location-field">
                <span class="location-icon"><v-icon icon="mdi-home" /></span>
                <div class="location-control">
                    <label>Plot Number/Office Number <b>*</b></label>
                    <v-text-field v-model="form.plot_no" placeholder="Enter plot number / office number"
                        variant="outlined" hide-details="auto" hint="Required field" persistent-hint />
                </div>
            </div>

            <div class="location-field">
                <span class="location-icon"><v-icon icon="mdi-map-marker" /></span>
                <div class="location-control">
                    <label>Area/ Village / शहर - street_area_village</label>
                    <v-text-field v-model="form.street_area_village" placeholder="Enter area / village / city"
                        variant="outlined" hide-details="auto" />
                </div>
            </div>

            <div class="location-field">
                <span class="location-icon"><v-icon icon="mdi-map" /></span>
                <div class="location-control">
                    <label>राज्य - State <b>*</b></label>
                    <v-select v-model="form.state" :items="states" item-title="state_name" item-value="lgd_code"
                        placeholder="Select State" variant="outlined" hide-details="auto" hint="Required field"
                        persistent-hint @update:modelValue="getDistrict" />
                </div>
            </div>

            <div class="location-field">
                <span class="location-icon"><v-icon icon="mdi-bank" /></span>
                <div class="location-control">
                    <label>जिला - District <b>*</b></label>
                    <v-select v-model="form.district" :items="districts" item-value="lgd_code"
                        item-title="district_name" placeholder="Select District" variant="outlined"
                        hide-details="auto" hint="Required field" persistent-hint />
                </div>
            </div>

            <div class="location-field">
                <span class="location-icon"><v-icon icon="mdi-barcode" /></span>
                <div class="location-control">
                    <label>Pincode <b>*</b></label>
                    <v-text-field v-model="form.pincode" type="text" inputmode="numeric" maxlength="6"
                        placeholder="Enter pincode" variant="outlined" hide-details="auto"
                        hint="Required field" persistent-hint />
                </div>
            </div>

            <v-btn class="location-action" type="button" block @click="useCurrentLocation">
                <v-icon icon="mdi-crosshairs-gps" />Use Current Location
            </v-btn>

            <v-btn class="employer-primary-action location-save" type="submit" block>
                <v-icon icon="mdi-content-save" />Save
            </v-btn>
        </v-form>
    </main>
</template>

<script setup>
import { ref, onMounted } from "vue";
import BackButtonAppBar from "@/components/header/BackButtonAppBar.vue";
import { useRouter } from 'vue-router'
import { Geolocation } from "@capacitor/geolocation";

import api from "@/services/api.js";
import apiRoutes from "@/services/apiRoutes.js";

const router = useRouter()

const form = ref({
    location: "",
    plot_no: "",
    street_area_village: "",
    district: "",
    state: "",
    pincode: "",
    lat: "",
    long: "",
});

const states = ref([]);
const districts = ref([]);

async function populateAddressFromCoordinates(lat, lng) {
    const endpoint = "https://search.mappls.com/search/address/rev-geocode";
    const params = new URLSearchParams({
        lat: String(lat),
        lng: String(lng),
        access_token: apiRoutes.mapSecretKey,
    });
    const response = await fetch(endpoint + "?" + params.toString());
    if (!response.ok) throw new Error("Unable to find an address for this GPS location.");

    const address = (await response.json()).results?.[0];
    if (!address) throw new Error("No address was found for this GPS location.");

    form.value.location = address.formatted_address || address.formattedAddress || form.value.location || "";
    form.value.plot_no = address.houseNumber || address.houseName || form.value.plot_no || "";
    form.value.street_area_village = [address.street, address.subLocality, address.locality, address.village, address.city]
        .filter(Boolean)
        .filter((value, index, values) => values.indexOf(value) === index)
        .join(", ");
    form.value.pincode = address.pincode || "";

    // store raw coordinates as strings
    form.value.lat = String(lat);
    form.value.long = String(lng);

    const stateName = String(address.state || "").trim().toLowerCase();
    const stateCode = Number(address.sttLgdCd || address.stateLgdCode);
    const matchedState = states.value.find((state) =>
        Number(state.lgd_code) === stateCode || state.state_name?.trim().toLowerCase() === stateName
    );

    if (matchedState) {
        form.value.state = matchedState.lgd_code;
        await getDistrict();

        const districtName = String(address.district || "").replace(/\s+district/i, "").trim().toLowerCase();
        const districtCode = Number(address.dstLgdCd || address.districtLgdCode);
        const matchedDistrict = districts.value.find((district) =>
            Number(district.lgd_code) === districtCode ||
            district.district_name?.replace(/\s+district/i, "").trim().toLowerCase() === districtName
        );
        form.value.district = matchedDistrict?.lgd_code || "";
    }
}

async function useCurrentLocation() {
    try {
        const position = await Geolocation.getCurrentPosition({ enableHighAccuracy: true, timeout: 15000 });
        await populateAddressFromCoordinates(position.coords.latitude, position.coords.longitude);
    } catch (error) {
        console.error("Unable to populate employer address from GPS:", error);
        alert(error?.message || "Please allow location access to populate your address automatically.");
    }
}

async function submitForm() {
    if (!form.value.state) {
        alert("Please select a State");
        return;
    }

    if (!form.value.district) {
        alert("Please select a District");
        return;
    }

    if (!form.value.plot_no.trim()) {
        alert("Please enter plot_no");
        return;
    }

    // if (!form.value.street_area_village.trim()) {
    //     alert("Please enter street_area_village");
    //     return;
    // }

    if (!form.value.pincode) {
        alert("Please enter Pincode");
        return;
    }

    // Pincode validation (6 digits, doesn’t start with 0)
    const pinRegex = /^[1-9][0-9]{5}$/;
    if (!pinRegex.test(form.value.pincode)) {
        alert("Please enter a valid 6-digit Pincode");
        return;
    }

    try {
        const employerData = JSON.parse(localStorage.getItem("labour_currentUser"));

        const res = await api.put(apiRoutes.employerUpdate + '/' + employerData.employer.id, {
            location: form.value.location,
            plot_no: form.value.plot_no,
            street_area_village: form.value.street_area_village,
            district: form.value.district.toString(),
            state: form.value.state.toString(),
            pin_code: form.value.pincode,
            lat: form.value.lat,
            long: form.value.long,
        });

        console.log("Success:", res.data)

        router.push('/employer-dashboard-profile-work')

    } catch (err) {
        alert(
            "Error !!\n" +
            Object.values(err.response?.data?.errors || {}).flat().join("\n")
        )
        console.error("Error login:", err)
    }

    // console.log(form.value);

}

async function getState() {

    try {
        const res = await api.get(apiRoutes.getState);
        //console.log("Success:", res.data);

        states.value = res.data.data;
        form.value.state = "";
        form.value.district = "";

        //console.log(form.value);
        //console.log("Success: states:", states);

    } catch (err) {
        alert(
            "Error !!\n" +
            Object.values(err.response?.data?.errors || {}).flat().join("\n")
        );
        //console.error("Error fetching worker details:", err);
    }

}

async function getDistrict() {
    form.value.district = "";
    if (!form.value.state) return
    try {
        const res = await api.post(apiRoutes.getDistrict, { state_id: form.value.state });
        //console.log("Success:district", res.data);

        districts.value = res.data.data;
        //console.log("Success: states:", districts);

    } catch (err) {
        alert(
            "Error !!\n" +
            Object.values(err.response?.data?.errors || {}).flat().join("\n")
        );
        //console.error("Error fetching worker details:", err);
    }
}

async function getData() {

    try {
        const employerData = JSON.parse(localStorage.getItem("labour_currentUser"));
        const res = await api.get(`${apiRoutes.employerGetById}/${employerData.employer.id}`);

        console.log("Success: location -", res.data);

        const data = res.data.employer;
        // Populate form values safely
        form.value = {
            location: data.profile?.location || '',
            plot_no: data.profile?.plot_no || '',
            street_area_village: data.profile?.street_area_village || '',
            // district: data.profile?.district || '',
            state: parseInt(data.profile?.state) || '',
            pincode: data.profile?.pin_code || '',
            lat: data.profile?.lat || '',
            long: data.profile?.long || '',
        };

        await getDistrict(form.value.state);

        // Now that districts are loaded, set district value
        form.value.district = parseInt(data.profile?.district);

    } catch (err) {
        alert(
            "Error !!\n" +
            Object.values(err.response?.data?.errors || {}).flat().join("\n")
        );
        console.error("Error fetching worker details:", err);
    }

}

onMounted(async () => {
    await getState();
    await getData();
});

</script>

<style scoped>
.location-page {
    min-height: calc(100vh - 100px);
    padding: 24px 10px 100px;
    color: #082566;
    background: #fff url('@/assets/authenticated-background.png') center/100% 100% no-repeat;
}

.location-heading { margin: 0 auto 27px; text-align: center; }
.location-heading h1 { margin: 0; color: #102966; font-size: clamp(28px, 4vw, 45px); font-weight: 800; line-height: 1.2; }
.heading-rule { display: flex; align-items: center; justify-content: center; width: min(360px, 82vw); margin: 17px auto 0; }
.heading-rule span { flex: 1; height: 2px; background: #0b68d7; }
.heading-rule i { width: 18px; height: 18px; border: 2px solid #0b68d7; background: #fff; transform: rotate(45deg); }

.location-form-card {
    width: min(870px, 100%);
    margin: 0 auto;
    padding: 28px 24px 24px;
    border: 1px solid #82c2ff;
    border-radius: 23px;
    background: rgba(255, 255, 255, .95);
    box-shadow: 0 8px 24px rgba(22, 118, 210, .11);
}

.location-field { display: flex; align-items: flex-start; gap: 18px; margin-bottom: 18px; }
.location-icon { display: grid; place-items: center; flex: 0 0 58px; width: 58px; height: 58px; margin-top: 25px; border-radius: 13px; color: #647590; background: #edf2f8; }
.location-icon .v-icon { font-size: 31px; }
.location-control { flex: 1; min-width: 0; text-align: left; }
.location-control label { display: block; max-width: 100%; margin: 0 0 7px; overflow: hidden; color: #122d65; font-size: clamp(17px, 2.1vw, 24px); font-weight: 800; line-height: 1.25; text-overflow: ellipsis; white-space: nowrap; }
.location-control label b { color: #e6222f; }
.location-control :deep(.v-field) { min-height: 58px; border-radius: 11px; color: #6d9bd2; background: #edf6ff; }
.location-control :deep(.v-field__outline) { --v-field-border-opacity: 1; }
.location-control :deep(.v-field__input) { min-height: 56px; padding-inline: 18px; color: #52627b; font-size: 17px; }
.location-control :deep(input::placeholder) { color: #94a8c5; opacity: 1; }
.location-control :deep(.v-messages__message),
.location-control :deep(.v-field__append-inner) { color: #7285a5; }

.location-action {
    width: 100%;
    height: 52px !important;
    margin: 2px 0 10px;
    border-radius: 12px;
    color: #fff;
    background: linear-gradient(110deg, #1688ed, #0867d6) !important;
    box-shadow: 0 5px 11px rgba(4, 92, 185, .24) !important;
    font-size: 15px;
    font-weight: 800;
}

.location-action .v-icon,
.location-save .v-icon { margin-right: 10px; font-size: 25px; }
.location-save { margin-top: 2px; text-transform: uppercase; }

@media (max-width: 650px) {
    .location-page { padding: 18px 8px 90px; background-size: auto 100%; }
    .location-heading { margin-bottom: 21px; }
    .location-heading h1 { padding-inline: 5px; font-size: clamp(22px, 6.8vw, 30px); }
    .heading-rule { margin-top: 13px; }
    .location-form-card { padding: 19px 10px 18px; border-radius: 18px; }
    .location-field { gap: 10px; margin-bottom: 14px; }
    .location-icon { flex-basis: 42px; width: 42px; height: 42px; margin-top: 23px; border-radius: 10px; }
    .location-icon .v-icon { font-size: 24px; }
    .location-control label { margin-bottom: 5px; font-size: 14px; }
    .location-control :deep(.v-field) { min-height: 52px; }
    .location-control :deep(.v-field__input) { min-height: 50px; padding-inline: 12px; font-size: 14px; }
    .location-control :deep(.v-messages__message) { font-size: 11px; }
}

@media (max-width: 370px) {
    .location-heading h1 { font-size: 21px; }
    .location-control label { font-size: 13px; }
}
</style>
