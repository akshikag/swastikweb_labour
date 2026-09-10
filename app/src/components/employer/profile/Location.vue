<!-- ------------------ -->
<template>
    <BackButtonAppBar />
    <v-container class="fill-height d-flex align-center justify-center" fluid>
        <v-row>
            <v-col cols="12">
                <!-- Location Information -->
                <v-card outlined class="pa-6">
                    <!-- <h4 class="mb-4">Current plot_no</h4> -->
                    <h4 class="mb-4">स्थान जानकारी - Location Information</h4>

                    <!-- Address -->
                    <v-text-field label="कार्यस्थल / कार्यालय का पता - Worksite / Office Address"
                        v-model="form.location" class="mb-3"></v-text-field>
                    <!-- plot_no -->
                    <v-text-field label="Plot Number/Office Number" v-model="form.plot_no" class="mb-3"></v-text-field>

                    <!-- street_area_village -->
                    <v-text-field label="Area/  Village / शहर - street_area_village" v-model="form.street_area_village"
                        class="mb-3"></v-text-field>
                    <!-- State -->
                    <v-select label="राज्य - State" v-model="form.state" :items="states" item-title="state_name"
                        item-value="lgd_code" @update:modelValue="getDistrict"></v-select>

                    <!-- District -->
                    <v-select label="जिला - District" v-model="form.district" :items="districts" item-value="lgd_code"
                        item-title="district_name" class="mb-3"></v-select>

                    <v-text-field label="Pincode" v-model="form.pincode" item-value="value"></v-text-field>
                    <v-btn class="mb-3" color="primary" @click="useCurrentLocation">Use Current Location</v-btn>

                    <v-btn block color="primary" large @click="submitForm">Save </v-btn>
                </v-card>
            </v-col>
        </v-row>
    </v-container>
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
.v-card {
    border-radius: 12px;
}
</style>
