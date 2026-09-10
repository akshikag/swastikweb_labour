<template>
    <BackButtonAppBar />
    <main class="location-page">
      <v-form class="location-form-card" @submit.prevent="submitForm">
                    <!-- <h4 class="mb-4">Current plot_no</h4> -->

                    <!-- plot_no -->
                    <div class="location-field"><span class="location-icon"><v-icon icon="mdi-home" /></span><div class="location-control"><label>House Number / Plot Number <b>*</b></label><v-text-field v-model="form.plot_no" placeholder="Enter house number / plot number" variant="outlined" hide-details="auto" hint="Required field" persistent-hint required /></div></div>

                    <!-- street_area_village -->
                    <div class="location-field"><span class="location-icon"><v-icon icon="mdi-map-marker" /></span><div class="location-control"><label>Area/ Village / क्षेत्र - street_area...</label><v-text-field v-model="form.street_area_village" placeholder="Enter area / village / street area..." variant="outlined" hide-details /></div></div>
                    <!-- State -->
                    <div class="location-field"><span class="location-icon"><v-icon icon="mdi-map" /></span><div class="location-control"><label>राज्य - State <b>*</b></label><v-select v-model="form.state" :items="states" item-title="state_name" item-value="lgd_code" placeholder="Select State" variant="outlined" hide-details="auto" hint="Required field" persistent-hint @update:modelValue="getDistrict" required /></div></div>

                    <!-- District -->
                    <div class="location-field"><span class="location-icon"><v-icon icon="mdi-bank" /></span><div class="location-control"><label>जिला - District <b>*</b></label><v-select v-model="form.district" :items="districts" item-value="lgd_code" item-title="district_name" placeholder="Select District" variant="outlined" hide-details="auto" hint="Required field" persistent-hint required /></div></div>

                    <div class="location-field"><span class="location-icon"><v-icon icon="mdi-barcode" /></span><div class="location-control"><label>Pincode <b>*</b></label><v-text-field v-model="form.pincode" placeholder="Enter pincode" variant="outlined" hide-details="auto" hint="Required field" persistent-hint required /></div></div>

                        <!-- Use Current Location Button -->
                        <v-btn class="location-action" color="primary" @click="useCurrentLocation"><v-icon start icon="mdi-crosshairs-gps" />Use Current Location</v-btn>

                        <!-- Map Selector -->

                        <v-btn class="location-action" color="primary" @click="openMap"><v-icon start icon="mdi-map-outline" />Select Location on Map</v-btn>

                    <div class="location-field compact"><span class="location-icon"><v-icon icon="mdi-crosshairs" /></span><div class="location-control"><label>Latitude</label><v-text-field v-model="form.latitude" placeholder="Latitude" readonly variant="outlined" hide-details /></div></div>

                    <div class="location-field compact"><span class="location-icon"><v-icon icon="mdi-crosshairs" /></span><div class="location-control"><label>Longitude</label><v-text-field v-model="form.longitude" placeholder="Longitude" readonly variant="outlined" hide-details /></div></div>

                    <v-snackbar v-model="snackbar.show" :timeout="3000" top>
                        {{ snackbar.message }}
                    </v-snackbar>


        <v-btn class="location-save" type="submit" block><v-icon start icon="mdi-content-save" />Save</v-btn>
      </v-form>


                <!-- MAP DIALOG -->
                <v-dialog v-model="showMap" max-width="600px">
                    <v-card>
                        <v-card-title>Select Location</v-card-title>

                        <v-card-text>
                            <div id="mapContainer" style="width:100%; height:400px;"></div>
                            <v-btn class="mt-3" small color="primary" @click="useCurrentLocation">Use My
                                Location</v-btn>
                        </v-card-text>

                        <v-card-actions>
                            <v-spacer></v-spacer>
                            <v-btn color="primary" @click="confirmLocation" variant="tonal">Confirm</v-btn>
                            <v-btn color="error" @click="showMap = false" variant="tonal">Cancel</v-btn>
                        </v-card-actions>
                    </v-card>
                </v-dialog>
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
    plot_no: "",
    street_area_village: "",
    district: "",
    state: "",
    pincode: "",
    latitude: "",
    longitude: ""

});

const showMap = ref(false);
const mapObj = ref(null);
const markerObj = ref(null);
const selectedLocation = ref(null);

const states = ref([]);
const districts = ref([]);

const snackbar = ref({ show: false, message: "" });

// -------------------------------------------------
//map

function openMap() {
    showMap.value = true;
    selectedLocation.value = {
        lat: form.value.latitude,
        lng: form.value.longitude,
    };

    form.value.latitude = selectedLocation.value.lat;
    form.value.longitude = selectedLocation.value.lng;

    setTimeout(() => initMap(), 100);
}

function loadMapplsScript() {
    return new Promise((resolve) => {
        if (window.mappls) return resolve();

        const script = document.createElement("script");
        script.src =
            "https://apis.mappls.com/advancedmaps/api/" + apiRoutes.mapSecretKey + "/map_sdk?v=3.0&layer=vector";
        script.async = true;
        script.onload = resolve;
        document.body.appendChild(script);
    });
}
function getPrimaryColor() {
    return getComputedStyle(document.documentElement)
        .getPropertyValue("--v-primary-base") // Vuetify 3 variable
        .trim() || "#1976D2"; // fallback
}

// Create SVG marker dynamically
function createMarkerSVG(color) {
    return `
        <svg width="32" height="32" viewBox="0 0 24 24" fill="${color}" xmlns="http://www.w3.org/2000/svg">
            <path d="M12 2C8.1 2 5 5.1 5 9c0 5.2 7 13 7 13s7-7.8 7-13c0-3.9-3.1-7-7-7zm0 9.5c-1.4 0-2.5-1.1-2.5-2.5S10.6 6.5 12 6.5s2.5 1.1 2.5 2.5S13.4 11.5 12 11.5z"/>
        </svg>
        `;
}

// Convert SVG to Base64 for Mappls Marker icon
function createMarkerIcon(color) {
    return "data:image/svg+xml;base64," + btoa(createMarkerSVG(color));
}
async function initMap() {
    await loadMapplsScript();

    // Always reset when opening dialog
    mapObj.value = null;
    markerObj.value = null;

    const lat = form.value.latitude || 28.6139;
    const lng = form.value.longitude || 77.209;

    selectedLocation.value = { lat, lng };

    mapObj.value = new window.mappls.Map("mapContainer", {
        center: { lat, lng },
        zoom: 14,
    });

    // Draw initial marker
    markerObj.value = new window.mappls.Marker({
        map: mapObj.value,
        position: { lat, lng },
        draggable: true,
        icon: createMarkerIcon(getPrimaryColor()),
    });

    markerObj.value.on("dragend", (evt) => {
        ////console.log(evt)
        const lat = evt.target._lngLat.lat || evt.latitude;
        const lng = evt.target._lngLat.lng || evt.longitude;

        selectedLocation.value = { lat, lng };

        form.value.latitude = selectedLocation.value.lat;
        form.value.longitude = selectedLocation.value.lng;
        //console.log("Dragged:", this.selectedLocation);
    });

    mapObj.value.on("click", (e) => {

        //console.log('dd', e.lngLat)
        const lat = e.lngLat.lat;
        const lng = e.lngLat.lng;

        selectedLocation.value = { lat, lng };

        // If marker exists -> move it
        if (markerObj.value) {
            markerObj.value.setPosition({ lat, lng });
        } else {
            // Create new marker
            markerObj.value = new mappls.Marker({
                map: mapObj.value,
                position: { lat, lng },
                draggable: true,
                icon: createMarkerIcon(getPrimaryColor())
            });

            // Add dragend event only once
            markerObj.value.on("dragend", (evt) => {
                ////console.log(evt)
                const lat = evt.target._lngLat.lat || evt.latitude;
                const lng = evt.target._lngLat.lng || evt.longitude;

                selectedLocation.value = { lat, lng };
                //console.log("Dragged:", this.selectedLocation);
            });
        }

        form.value.latitude = selectedLocation.value.lat;
        form.value.longitude = selectedLocation.value.lng;

        //console.log("Clicked:", this.selectedLocation);
    });

    // setTimeout(() => this.mapObj.invalidateSize(), 300);
}

async function populateAddressFromCoordinates(lat, lng) {
    // Try Mappls first, then fallback to Nominatim on network failure or no results
    try {
        const endpoint = "https://search.mappls.com/search/address/rev-geocode";
        const params = new URLSearchParams({
            lat: String(lat),
            lng: String(lng),
            access_token: apiRoutes.mapSecretKey,
        });
        const mapplsUrl = endpoint + "?" + params.toString();
        const response = await fetch(mapplsUrl);
        if (!response.ok) {
            console.error("Mappls reverse-geocode failed:", { url: mapplsUrl, status: response.status, statusText: response.statusText });
        } else {
            const payload = await response.json();
            const address = payload.results?.[0];
            if (address) {
                form.value.plot_no = address.houseNumber || address.houseName || form.value.plot_no || "";
                form.value.street_area_village = [address.street, address.subLocality, address.locality, address.village, address.city]
                    .filter(Boolean)
                    .filter((value, index, values) => values.indexOf(value) === index)
                    .join(", ");
                form.value.pincode = address.pincode || "";

                const stateCode = Number(address.sttLgdCd);
                const matchedState = states.value.find((state) =>
                    Number(state.lgd_code) === stateCode ||
                    state.state_name?.toLowerCase() === address.state?.toLowerCase()
                );
                if (matchedState) {
                    form.value.state = matchedState.lgd_code;
                    await getDistrict();

                    const districtCode = Number(address.dstLgdCd);
                    const districtName = String(address.district || "").replace(/\s+district/i, "").trim().toLowerCase();
                    const matchedDistrict = districts.value.find((district) =>
                        Number(district.lgd_code) === districtCode ||
                        district.district_name?.toLowerCase() === districtName
                    );
                    form.value.district = matchedDistrict?.lgd_code || "";
                }

                snackbar.value.message = "Address populated from GPS";
                snackbar.value.show = true;
                return;
            } else {
                console.warn("Mappls reverse-geocode returned no results", { url: mapplsUrl, status: response.status, payload });
            }
        }
        // If Mappls responded but had no results, fall through to fallback
    } catch (err) {
        console.error("Mappls reverse-geocode request error:", err);
    }

    // Fallback: use Nominatim reverse geocode (no API key) for a best-effort address
    try {
        const nomUrl = `https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${encodeURIComponent(lat)}&lon=${encodeURIComponent(lng)}&addressdetails=1`;
        const resp = await fetch(nomUrl, { headers: { 'Accept': 'application/json' } });
        if (!resp.ok) {
            console.error('Nominatim reverse-geocode failed', { url: nomUrl, status: resp.status, statusText: resp.statusText });
            throw new Error('Nominatim reverse geocode failed');
        }
        const data = await resp.json();
        const addr = data.address || {};

        form.value.plot_no = addr.house_number || form.value.plot_no || "";
        const parts = [addr.road, addr.neighbourhood, addr.suburb, addr.village, addr.town, addr.city].filter(Boolean);
        form.value.street_area_village = parts.filter((v, i, a) => a.indexOf(v) === i).join(', ');
        form.value.pincode = addr.postcode || form.value.pincode || "";

        // Try to match state by name
        const stateName = String(addr.state || "").trim().toLowerCase();
        const matchedState = states.value.find((s) => s.state_name?.trim().toLowerCase() === stateName);
        if (matchedState) {
            form.value.state = matchedState.lgd_code;
            await getDistrict();
            // Attempt district match
            const districtName = String(addr.county || addr.state_district || addr.city_district || addr.region || "").replace(/\s+district/i, "").trim().toLowerCase();
            const matchedDistrict = districts.value.find((d) => d.district_name?.replace(/\s+district/i, "").trim().toLowerCase() === districtName);
            form.value.district = matchedDistrict?.lgd_code || form.value.district || "";
        }

        snackbar.value.message = "Address populated from fallback geocoder";
        snackbar.value.show = true;
        return;
    } catch (err) {
        console.error("Reverse geocode fallback failed:", err);
        snackbar.value.message = "Network error while reverse-geocoding. Try again.";
        snackbar.value.show = true;
        throw err;
    }
}

async function useCurrentLocation() {
    try {
        const position = await Geolocation.getCurrentPosition({ enableHighAccuracy: true, timeout: 15000 });
        const lat = position.coords.latitude;
        const lng = position.coords.longitude;

        form.value.latitude = lat;
        form.value.longitude = lng;
        selectedLocation.value = { lat, lng };
        markerObj.value?.setPosition({ lat, lng });
        mapObj.value?.setCenter?.({ lat, lng });

        await populateAddressFromCoordinates(lat, lng);
        snackbar.value.message = "Location populated from device GPS";
        snackbar.value.show = true;
    } catch (error) {
        console.error("Unable to populate address from GPS:", error);
        snackbar.value.message = error?.message || "Please allow location access to populate your address automatically.";
        snackbar.value.show = true;
    }
}

function confirmLocation() {
    if (!selectedLocation.value || !selectedLocation.value.lat) {
        alert("Please select a location first!");
        return;
    }

    //console.log(this.selectedLocation);
    form.value.latitude = selectedLocation.value.lat;
    form.value.longitude = selectedLocation.value.lng;

    showMap.value = false;
}
// ------------------------------------------------

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
        const workerData = JSON.parse(localStorage.getItem('labour_currentUser'))
        const res = await api.put(apiRoutes.workerUpdate + '/' + workerData.worker.id, {
            plot_no: form.value.plot_no,
            street_area_village: form.value.street_area_village,
            district: form.value.district.toString(),
            state: form.value.state.toString(),
            pin_code: form.value.pincode,
            lat: form.value.latitude.toString(),
            long: form.value.longitude.toString(),
        });

        console.log("Success:", res.data)

        router.push('/worker-dashboard-profile-skill')

    } catch (err) {
        alert(
            "Error !!\n" +
            Object.values(err.response?.data?.errors || {}).flat().join("\n")
        )
        console.error("Error login:", err)
    }

    console.log(form.value);

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
        const workerData = JSON.parse(localStorage.getItem('labour_currentUser'))
        const res = await api.get(`${apiRoutes.workerGetWorkerByid}/${workerData.worker.id}`);

        console.log("Success: location -", res.data);

        const data = res.data.worker;
        // Populate form values safely
        form.value = {
            plot_no: data.profile?.plot_no || '',
            street_area_village: data.profile?.street_area_village || '',
            // district: data.profile?.district || '',
            state: parseInt(data.profile?.state) || '',
            pincode: data.profile?.pin_code || '',
            latitude: data.profile?.lat ? parseFloat(data.profile?.lat) : '',
            longitude: data.profile?.long ? parseFloat(data.profile?.long) : '',
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

    // If profile already has coordinates, try to reverse-geocode them to populate address fields.
    if (form.value.latitude && form.value.longitude) {
        try {
            await populateAddressFromCoordinates(form.value.latitude, form.value.longitude);
        } catch (err) {
            console.warn("Reverse geocode failed, falling back to device geolocation:", err);
            await useCurrentLocation();
        }
    } else {
        // No saved coords — try to get current device location
        await useCurrentLocation();
    }
});
</script>

<style scoped>
.location-page{min-height:calc(100vh - 100px);padding:28px 18px 100px;color:#082566;background:#fff url('@/assets/authenticated-background.png') center/100% 100% no-repeat}.location-form-card{width:min(870px,100%);margin:0 auto;padding:34px 32px 28px;border:1px solid #a9d5ff;border-radius:23px;background:#fffffff2;box-shadow:0 8px 24px #1676d21c}.location-field{display:flex;align-items:flex-start;gap:28px;margin-bottom:21px}.location-icon{display:grid;place-items:center;flex:0 0 58px;width:58px;height:58px;margin-top:4px;border-radius:13px;color:#68758a;background:#f0f4f9}.location-icon .v-icon{font-size:33px}.location-control{flex:1;min-width:0}.location-control label{display:block;margin:0 0 7px;color:#122d65;font-size:clamp(20px,2.4vw,29px);font-weight:800}.location-control label b{color:#e6222f}.location-control :deep(.v-field){border-radius:11px;background:#f8fbff}.location-control :deep(.v-field__input){min-height:58px;padding-inline:28px;font-size:20px;color:#52627b}.location-control :deep(.v-messages__message){font-size:15px;color:#7a8495}.location-action,.location-save{width:100%;height:62px!important;margin:0 0 10px;border-radius:12px;background:linear-gradient(110deg,#1688ed,#0867d6)!important;color:#fff;font-size:22px;font-weight:800;letter-spacing:.3px}.location-save{margin-top:8px;height:66px!important}.location-action .v-icon,.location-save .v-icon{font-size:32px}.compact{margin-top:18px;margin-bottom:14px}.compact .location-icon{background:transparent}.compact .location-control label{font-size:20px}.compact .location-control :deep(.v-field__input){min-height:55px}.location-control :deep(.v-field__prepend-inner){display:none}@media(max-width:650px){.location-page{padding:20px 10px 90px}.location-form-card{padding:18px 10px;border-radius:18px}.location-field{gap:12px;margin-bottom:13px}.location-icon{flex-basis:42px;width:42px;height:42px;margin-top:2px;border-radius:10px}.location-icon .v-icon{font-size:24px}.location-control label{margin-bottom:4px;font-size:15px}.location-control :deep(.v-field__input){min-height:30px!important;padding-inline:14px!important;font-size:14px!important}.location-control :deep(.v-messages__message){font-size:12px}.location-action{height:52px!important;font-size:16px}.location-save{height:52px!important;font-size:17px}.location-action .v-icon,.location-save .v-icon{font-size:25px}.compact{margin-top:10px}.compact .location-control label{font-size:15px}.compact .location-control :deep(.v-field__input){min-height:30px}}
</style>
