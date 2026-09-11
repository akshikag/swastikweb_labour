<template>
    <BackButtonAppBar />
    <v-container class="fill-height d-flex align-center justify-center" fluid>
        <v-row>
            <v-col cols="12">
                <!-- Location Information -->
                <v-card outlined class="pa-6">
                    <!-- <h4 class="mb-4">Current plot_no</h4> -->

                    <!-- plot_no -->
                    <v-text-field label="House Number / Plot Number" v-model="form.plot_no" class="mb-3" required @blur="$refs.plotnoField?.$el.classList.add('required')" hint="Required field" persistent-hint></v-text-field>

                    <!-- street_area_village -->
                    <v-text-field label="Area/  Village / शहर - street_area_village" v-model="form.street_area_village"
                        class="mb-3"></v-text-field>
                    <!-- State -->
                    <v-select label="राज्य - State *" v-model="form.state" :items="states" item-title="state_name"
                        item-value="lgd_code" @update:modelValue="getDistrict" required hint="Required field" persistent-hint></v-select>

                    <!-- District -->
                    <v-select label="जिला - District *" v-model="form.district" :items="districts" item-value="lgd_code"
                        item-title="district_name" class="mb-3" required hint="Required field" persistent-hint></v-select>

                    <v-text-field label="Pincode *" v-model="form.pincode" item-value="value" required hint="Required field" persistent-hint></v-text-field>

                        <!-- Use Current Location Button -->
                        <v-btn class="mb-2" color="primary" @click="useCurrentLocation">Use Current Location</v-btn>

                        <!-- Map Selector -->

                        <v-btn class="mb-2" color="primary" @click="openMap">Select Location on Map</v-btn>

                    <v-text-field v-model="form.latitude" label="Latitude" readonly outlined dense />

                    <v-text-field v-model="form.longitude" label="Longitude" readonly outlined dense />

                    <v-snackbar v-model="snackbar.show" :timeout="3000" top>
                        {{ snackbar.message }}
                    </v-snackbar>


                    <v-btn block color="primary" large @click="submitForm">Save </v-btn>
                </v-card>


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
            </v-col>
        </v-row>
    </v-container>
</template>

<script setup>
import { ref, onMounted, nextTick } from "vue";
import L from "leaflet";
import "leaflet/dist/leaflet.css";
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
const mapSelectionInProgress = ref(false);

const states = ref([]);
const districts = ref([]);

const snackbar = ref({ show: false, message: "" });

// -------------------------------------------------
//map

function openMap() {
    if (!apiRoutes.mapSecretKey) {
        snackbar.value.message = "MapmyIndia API key is missing.";
        snackbar.value.show = true;
        return;
    }

    showMap.value = true;
    selectedLocation.value = {
        lat: Number(form.value.latitude) || 28.6139,
        lng: Number(form.value.longitude) || 77.209,
    };

    form.value.latitude = String(selectedLocation.value.lat);
    form.value.longitude = String(selectedLocation.value.lng);

    nextTick(() => initMap());
}

function loadMapplsScript() {
    return new Promise((resolve, reject) => {
        if (!apiRoutes.mapSecretKey) {
            reject(new Error("MapmyIndia API key is missing."));
            return;
        }

        if (window.mappls) {
            resolve();
            return;
        }

        const script = document.createElement("script");
        script.src = `https://apis.mappls.com/advancedmaps/api/${apiRoutes.mapSecretKey}/map_sdk?v=3.0&layer=vector`;
        script.async = true;
        script.onload = () => resolve();
        script.onerror = () => reject(new Error("Unable to load MapmyIndia SDK."));
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

function updateMarkerPosition(lat, lng) {
    if (!markerObj.value) return;

    if (typeof markerObj.value.setPosition === "function") {
        markerObj.value.setPosition({ lat, lng });
        return;
    }

    if (typeof markerObj.value.setLatLng === "function") {
        markerObj.value.setLatLng([lat, lng]);
    }
}

function updateMapCenter(lat, lng) {
    if (!mapObj.value) return;

    if (typeof mapObj.value.setCenter === "function") {
        mapObj.value.setCenter({ lat, lng });
        return;
    }

    if (typeof mapObj.value.setView === "function") {
        mapObj.value.setView([lat, lng], mapObj.value.getZoom?.() ?? 14);
    }
}

async function applySelectedLocation(lat, lng) {
    if (!Number.isFinite(Number(lat)) || !Number.isFinite(Number(lng))) return;

    const safeLat = Number(lat);
    const safeLng = Number(lng);

    mapSelectionInProgress.value = true;
    selectedLocation.value = { lat: safeLat, lng: safeLng };
    form.value.latitude = String(safeLat);
    form.value.longitude = String(safeLng);
    updateMarkerPosition(safeLat, safeLng);
    updateMapCenter(safeLat, safeLng);

    try {
        await populateAddressFromCoordinates(safeLat, safeLng);
    } catch (error) {
        console.warn("Address refresh after map selection failed:", error);
    } finally {
        mapSelectionInProgress.value = false;
    }
}

function initFallbackMap() {
    if (!document.getElementById("mapContainer")) return;

    if (mapObj.value && typeof mapObj.value.remove === "function") {
        mapObj.value.remove();
    }

    const lat = Number(form.value.latitude) || 28.6139;
    const lng = Number(form.value.longitude) || 77.209;

    mapObj.value = L.map("mapContainer", { zoomControl: true });
    mapObj.value.setView([lat, lng], 14);

    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
        attribution: "&copy; OpenStreetMap contributors",
    }).addTo(mapObj.value);

    if (markerObj.value && typeof markerObj.value.remove === "function") {
        markerObj.value.remove();
    }

    markerObj.value = L.marker([lat, lng], { draggable: true }).addTo(mapObj.value);

    markerObj.value.on("dragend", async (event) => {
        const coords = event.target.getLatLng();
        await applySelectedLocation(coords.lat, coords.lng);
    });

    mapObj.value.on("click", async (event) => {
        const { lat, lng } = event.latlng;
        await applySelectedLocation(lat, lng);
    });

    snackbar.value.message = "MapmyIndia key is invalid or blocked; using OpenStreetMap fallback for location selection.";
    snackbar.value.show = true;
}

async function initMap() {
    try {
        await loadMapplsScript();

        if (!document.getElementById("mapContainer")) return;

        mapObj.value = null;
        markerObj.value = null;

        const lat = Number(form.value.latitude) || 28.6139;
        const lng = Number(form.value.longitude) || 77.209;

        selectedLocation.value = { lat, lng };

        mapObj.value = new window.mappls.Map("mapContainer", {
            center: { lat, lng },
            zoom: 14,
        });

        markerObj.value = new window.mappls.Marker({
            map: mapObj.value,
            position: { lat, lng },
            draggable: true,
            icon: createMarkerIcon(getPrimaryColor()),
        });

        markerObj.value.on("dragend", async (evt) => {
            const mapPoint = evt?.target?._lngLat || evt;
            const lat = mapPoint.lat ?? evt?.latitude;
            const lng = mapPoint.lng ?? evt?.longitude;

            await applySelectedLocation(lat, lng);
        });

        mapObj.value.on("click", async (e) => {
            const point = e?.lngLat || e?.latlng || {};
            const lat = point.lat;
            const lng = point.lng;

            if (!lat && !lng) return;

            if (markerObj.value && typeof markerObj.value.setPosition === "function") {
                markerObj.value.setPosition({ lat, lng });
            } else {
                markerObj.value = new window.mappls.Marker({
                    map: mapObj.value,
                    position: { lat, lng },
                    draggable: true,
                    icon: createMarkerIcon(getPrimaryColor())
                });

                markerObj.value.on("dragend", async (evt) => {
                    const mapPoint = evt?.target?._lngLat || evt;
                    const lat = mapPoint.lat ?? evt?.latitude;
                    const lng = mapPoint.lng ?? evt?.longitude;
                    await applySelectedLocation(lat, lng);
                });
            }

            await applySelectedLocation(lat, lng);
        });
    } catch (error) {
        console.error("MapmyIndia map load failed:", error);
        initFallbackMap();
    }
}

async function populateAddressFromCoordinates(lat, lng, options = {}) {
    const preserveMapSelection = options.preserveMapSelection ?? mapSelectionInProgress.value;

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

                snackbar.value.message = preserveMapSelection ? "Selected map location updated." : "Address populated from GPS";
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

        snackbar.value.message = preserveMapSelection ? "Selected map location updated." : "Address populated from fallback geocoder";
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

        form.value.latitude = String(lat);
        form.value.longitude = String(lng);
        selectedLocation.value = { lat, lng };

        updateMarkerPosition(lat, lng);
        updateMapCenter(lat, lng);

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
/* Highlight required field asterisks in red */
:deep(.v-field__label) {
    color: inherit;
}

/* Make asterisks in required field labels appear in red */
:deep(.v-select__label),
:deep(.v-text-field__label) {
    position: relative;
}

/* Style for required field hint text */
:deep(.v-messages__message) {
    font-size: 0.75rem;
    color: #666;
    font-weight: 500;
}

/* Add visual indicator for required fields */
.required-field {
    position: relative;
}

.required-field::after {
    content: ' *';
    color: #d32f2f;
    font-weight: bold;
}
</style>
.v-card {
    border-radius: 12px;
}
