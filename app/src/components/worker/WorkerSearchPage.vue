<!-- ---------------------------------- -->
<template>
    <LogoutAppBar />

    <main class="worker-search-page">
        <!-- Title -->
        <div class="search-heading">
            <h1>Find Work/Jobs</h1>
            <span aria-hidden="true"><i></i><b>◇</b><i></i></span>
        </div>

        <!-- Filters -->
        <section class="search-filters" aria-label="Job search filters">
            <label class="filter-card">
                <span class="filter-icon"><v-icon icon="mdi-map-marker" /></span>
                <span class="filter-copy">
                    <strong>Location</strong>
                    <input v-model="filters.location" type="text" placeholder="Enter location" @keyup.enter="filterjobs" />
                </span>
            </label>

            <label class="filter-card">
                <span class="filter-icon"><v-icon icon="mdi-map-marker" /></span>
                <span class="filter-copy">
                    <strong>Pincode</strong>
                    <input v-model="filters.pincode" type="text" inputmode="numeric" placeholder="Enter pincode" @keyup.enter="filterjobs" />
                </span>
            </label>

            <label class="filter-card filter-card--select">
                <span class="filter-icon"><v-icon icon="mdi-briefcase" /></span>
                <span class="filter-copy">
                    <strong>Select Skill</strong>
                    <select v-model="filters.skill" aria-label="Select skill">
                        <option value="">Choose Skill</option>
                        <option v-for="skill in skills" :key="skill.id" :value="skill.id">{{ skill.name }}</option>
                    </select>
                </span>
                <button v-if="filters.skill" class="clear-filter" type="button" aria-label="Clear skill" @click.prevent="filters.skill = ''"><v-icon icon="mdi-close" /></button>
                <v-icon class="select-chevron" icon="mdi-chevron-down" />
            </label>

            <label class="filter-card filter-card--select">
                <span class="filter-icon"><v-icon icon="mdi-ruler" /></span>
                <span class="filter-copy">
                    <strong>Range (km)</strong>
                    <select v-model="filters.range" aria-label="Select range">
                        <option value="">Select range</option>
                        <option v-for="range in ranges" :key="range.id" :value="range.id">{{ range.name }}</option>
                    </select>
                </span>
                <button v-if="filters.range" class="clear-filter" type="button" aria-label="Clear range" @click.prevent="filters.range = ''"><v-icon icon="mdi-close" /></button>
                <v-icon class="select-chevron" icon="mdi-chevron-down" />
            </label>
        </section>

        <!-- Range Filter -->
        <div class="search-actions">
            <button class="search-button" type="button" @click="filterjobs">
                <v-icon icon="mdi-magnify" />
                <span>Search</span>
            </button>
            <button class="map-button" type="button" @click="toggleMap">
                <v-icon :icon="showMap ? 'mdi-format-list-bulleted' : 'mdi-map-outline'" />
                <span>{{ showMap ? 'List View' : 'Map View' }}</span>
            </button>
        </div>

        <div v-if="loading" class="d-flex justify-center align-center" style="height: 200px;">
            <v-progress-circular indeterminate color="primary" size="50"></v-progress-circular>
        </div>

        <!-- Map View -->
        <div v-show="showMap" id="mapContainer" class="map-container"></div>
        <!-- List View -->
        <v-row dense v-show="!showMap">
            <v-col v-for="job in jobs" :key="job.id" cols="12" sm="6" md="4">
                <v-card class="pa-3 rounded-lg job-result-card" elevation="2">
                    <v-row align="center" no-gutters>
                        <!-- Avatar -->
                        <v-col cols="auto">
                            <v-avatar size="60" color="orange lighten-2">
                                <v-img :src="job.employer_image_url" alt="job Image" cover></v-img>
                            </v-avatar>
                        </v-col>

                        <!-- Info -->
                        <v-col class="pl-3">
                            <h4 class="mb-1 text-subtitle-1">{{ job.title }}</h4>
                            <p class="mb-1 text-subtitle-2">{{ job.employer_name }}</p>

                            <p class="mb-0 text-caption">📍 {{ job.employer_phone }}</p>
                            <p class="mb-0 text-caption">💰 {{ job.rate }}</p>
                            <!-- <v-chip-group class="d-flex flex-wrap">
                                <v-chip v-for="skill in job.skills_list" :key="skill" class="ma-1" color=""
                                    text-color="white" pill>
                                    {{ skill.name }}
                                </v-chip>
                            </v-chip-group> -->
                        </v-col>

                        <!-- Button -->
                        <v-col cols="auto" class="pl-2">
                            <v-btn color="primary" size="small" icon @click="showJobDetails(job)">
                                <v-icon>mdi-chevron-right</v-icon>
                            </v-btn>
                        </v-col>
                    </v-row>
                </v-card>
            </v-col>
        </v-row>

        <!-- Load More -->
        <div v-if="has_more && !showMap" class="text-center mt-4">
            <v-btn color="primary" variant="tonal" @click="loadMore">
                Load More
            </v-btn>
        </div>
    </main>
</template>

<script>

import LogoutAppBar from "@/components/header/LogoutAppBar.vue";
import L from "leaflet";
import "leaflet/dist/leaflet.css";

import api from "@/services/api.js";
import apiRoutes from "@/services/apiRoutes.js";
import { Geolocation } from "@capacitor/geolocation";

export default {
    name: "SearchJobPage",
    components: { LogoutAppBar },
    data() {
        return {
            loading: false,
            map: null,
            markers: [],
            showMap: false,
            visibleCount: 10,
            filters: {
                location: "",
                pincode: "",
                skill: "",
                range: "",
            },
            latitude: "",
            longitude: "",
            skills: [],
            jobs: [],
            ranges: [
                { id: 1, name: '1' },
                { id: 5, name: '5' },
                { id: 10, name: '10' },
                { id: 20, name: '20' },
                { id: 50, name: '50' },
                { id: 100, name: '100' },
            ],
            page: 1,
            has_more: false,
            mapObj: null,
            markerObj: null,
            selectedLocation: null,
        };
    },
    computed: {

    },
    mounted() {
        this.getjobs(),
            this.getskill(),
            this.useCurrentLocation()
        // this.openMap()
    },
    methods: {
        async getskill() {
            try {
                const res = await api.get(apiRoutes.getAllSkill);
                //console.log('skills', res.data)
                if (res.data && res.data.data) {
                    this.skills = res.data.data; // expected: [{id, name}]
                }
            } catch (error) {
                //console.error("Error fetching skills:", error);
                alert("Failed to load skills.");
            }
        },

        async getjobs() {
            this.loading = true;
            try {
                const res = await api.get(apiRoutes.workerSearchjobJobs, {
                    params: {
                        location: this.filters.location,
                        pincode: this.filters.pincode,
                        lat: this.latitude,
                        long: this.longitude,
                        skill_id: this.filters.skill,
                        range: this.filters.range,
                        page: this.page,
                    }
                });

                // console.log('job', res.data)

                if (res.data?.jobs) {
                    // APPEND new jobs to old list
                    this.jobs = [...this.jobs, ...res.data.jobs];
                    // update page for next "Load More"

                    this.page = res.data.next_page;
                    this.has_more = res.data.has_more;

                    if (this.showMap) {
                        this.addjobMarkers();
                    }

                }
                this.loading = false;
            } catch (error) {
                //console.error("Error fetching skills:", error);
                alert("Failed to load job.");
                this.loading = false;
            }
        },

        filterjobs() {
            this.page = 1;
            this.jobs = [];
            this.getjobs()

        },

        loadMore() {
            this.getjobs()
        },
        showJobDetails(job) {
            this.$router.push({ name: 'worker-dashboard-employer-detail', params: { id: job.id } });
        },

        // map integrate
        toggleMap() {
            this.showMap = !this.showMap;

            if (this.showMap) {
                setTimeout(() => {
                    this.initMap();

                    // Fix for hidden map inside v-show
                    setTimeout(() => {
                        if (this.mapObj?.invalidateSize) {
                            this.mapObj.invalidateSize();
                        }
                    }, 200);
                }, 200);
            }
        },

        // openMap() {
        //     this.showMap = true;
        //     this.selectedLocation = {
        //         lat: this.latitude,
        //         lng: this.longitude,
        //     };

        //     setTimeout(() => this.initMap(), 350);
        // },

        loadMapplsScript() {
            return new Promise((resolve, reject) => {
                if (!apiRoutes.mapSecretKey) return reject(new Error("Mappls API key is missing."));
                if (window.mappls) return resolve();

                const script = document.createElement("script");
                script.src =
                    "https://apis.mappls.com/advancedmaps/api/" + apiRoutes.mapSecretKey + "/map_sdk?v=3.0&layer=vector";
                script.async = true;
                script.onload = resolve;
                script.onerror = () => reject(new Error("Mappls SDK could not be loaded."));
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

        async useCurrentLocation() {
            try {
                const coords = await Geolocation.getCurrentPosition();
                this.latitude = coords.coords.latitude;
                this.longitude = coords.coords.longitude;

                const lat = this.latitude;
                const lng = this.longitude;

                if (this.markerObj?.setPosition) this.markerObj.setPosition({ lat, lng });
                else if (this.markerObj?.setLatLng) this.markerObj.setLatLng([lat, lng]);
                if (this.mapObj?.setCenter) this.mapObj.setCenter({ lat, lng });
                else if (this.mapObj?.setView) this.mapObj.setView([lat, lng], this.mapObj.getZoom());
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
            this.latitude = this.selectedLocation.lat;
            this.longitude = this.selectedLocation.lng;

            this.showMap = false;
        },
        // -------------------------------------

        createUserMarkerSVG() {
            return `
            <svg width="30" height="30" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                <circle cx="12" cy="12" r="8" fill="#E53935" opacity="0.4"/>
                <circle cx="12" cy="12" r="4" fill="#E53935"/>
            </svg>
            `;
        },
        createUserMarkerIcon() {
            return "data:image/svg+xml;base64," + btoa(this.createUserMarkerSVG());
        },

        initFallbackMap() {
            const lat = Number(this.latitude) || 28.6139;
            const lng = Number(this.longitude) || 77.209;
            this.selectedLocation = { lat, lng };
            if (this.mapObj?.remove) this.mapObj.remove();
            this.mapObj = L.map("mapContainer").setView([lat, lng], 14);
            L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
                attribution: "&copy; OpenStreetMap contributors",
            }).addTo(this.mapObj);
            this.markerObj = L.marker([lat, lng], { draggable: true }).addTo(this.mapObj);
            const updateLocation = ({ lat, lng }) => {
                this.selectedLocation = { lat, lng };
                this.latitude = lat;
                this.longitude = lng;
            };
            this.markerObj.on("dragend", (event) => updateLocation(event.target.getLatLng()));
            this.mapObj.on("click", (event) => {
                const { lat, lng } = event.latlng;
                this.markerObj.setLatLng([lat, lng]);
                updateLocation({ lat, lng });
            });
            this.addjobMarkers();
        },

        async initMap() {
            try {
                await this.loadMapplsScript();

            this.mapObj = null;
            this.markerObj = null;



            const lat = this.latitude || 28.6139;
            const lng = this.longitude || 77.209;

            this.selectedLocation = { lat, lng };

            this.mapObj = new mappls.Map("mapContainer", {
                center: { lat, lng },
                zoom: 14,
            });

            // Add user marker (blue dot)
            this.markerObj = new mappls.Marker({
                map: this.mapObj,
                position: { lat, lng },
                draggable: true,
                icon: this.createUserMarkerIcon(),
            });

            this.markerObj.on("dragend", (evt) => {
                ////console.log(evt)
                const lat = evt.target._lngLat.lat || evt.latitude;
                const lng = evt.target._lngLat.lng || evt.longitude;

                this.selectedLocation = { lat, lng };

                this.latitude = this.selectedLocation.lat;
                this.longitude = this.selectedLocation.lng;
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
                        icon: this.createUserMarkerIcon(),

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

                this.latitude = this.selectedLocation.lat;
                this.longitude = this.selectedLocation.lng;

                //console.log("Clicked:", this.selectedLocation);
            });


            // Add job markers
            this.addjobMarkers();
            } catch (error) {
                console.warn("Mappls unavailable; using OpenStreetMap fallback.", error);
                this.initFallbackMap();
            }
        },
        addjobMarkers() {
            if (!this.jobs || this.jobs.length === 0) return;


            this.clearjobMarkers();

            this.markers = [];

            this.jobs.forEach(job => {
                if (this.mapObj instanceof L.Map) {
                    const marker = L.marker([Number(job.lat), Number(job.long)]).addTo(this.mapObj);
                    marker.bindPopup(`<strong>${job.title || "Job"}</strong><br>${job.employer_phone || ""}`);
                    this.markers.push(marker);
                    return;
                }
                const marker = new mappls.Marker({
                    map: this.mapObj,
                    position: { lat: job.lat, lng: job.long },
                    icon: this.createMarkerIcon(this.getPrimaryColor()),
                    // fitbounds: true,
                    popupHtml: `
                                   <div style="padding: 8px; font-size: 14px;">
                    <strong>${job.title}</strong><br>
                    📞 ${job.employer_phone}<br><br>
                    <button id="viewDetailsBtn_${job.id}"
                        style="padding:6px 10px; background:#1976D2; color:#fff; border:none; border-radius:4px;">
                        View Details
                    </button>
                </div>
                                `
                });

                this.markers.push(marker);

                // Attach click event for popup button after marker is clicked
                marker.addListener("click", () => {
                    // Wait a tiny bit for popup to render
                    setTimeout(() => {
                        const btn = document.getElementById(`viewDetailsBtn_${job.id}`);
                        if (btn) {
                            btn.onclick = () => {
                                // Navigate to detail page with job id
                                this.$router.push({ name: "worker-dashboard-employer-detail", params: { id: job.id } });
                            };
                        }
                    }, 50);
                });
            });

        },
        clearjobMarkers() {
            if (this.markers && this.markers.length > 0) {
                this.markers.forEach(marker => {
                    marker.remove(); // remove from map
                });
                this.markers = [];
            }
        },


    },
};
</script>

<style scoped>
.worker-search-page {
    width: min(calc(100% - 36px), 760px);
    min-height: calc(100vh - 156px);
    margin: 0 auto;
    padding: clamp(24px, 5vw, 48px) 0 32px;
}

.search-heading {
    display: flex;
    align-items: center;
    flex-direction: column;
    margin-bottom: clamp(18px, 3.5vw, 32px);
    color: #041b49;
    text-align: center;
}

.search-heading h1 {
    margin: 0;
    font-size: clamp(28px, 6.5vw, 42px);
    font-weight: 800;
    line-height: 1.12;
    letter-spacing: -0.045em;
}

.search-heading > span {
    display: flex;
    align-items: center;
    justify-content: center;
    width: min(210px, 55%);
    margin-top: 7px;
    color: #536684;
}

.search-heading i {
    flex: 1;
    height: 1px;
    background: #71829b;
}

.search-heading b {
    margin-inline: 5px;
    font-size: 20px;
    font-weight: 500;
    line-height: 1;
}

.search-filters {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: clamp(10px, 2vw, 16px);
}

.filter-card {
    position: relative;
    display: flex;
    align-items: center;
    min-width: 0;
    min-height: clamp(62px, 11vw, 83px);
    padding: 9px clamp(9px, 2vw, 15px);
    border: 1px solid #c6e2fa;
    border-radius: clamp(9px, 2vw, 14px);
    background: rgb(255 255 255 / 94%);
    box-shadow: 0 4px 9px rgb(23 102 164 / 14%);
    cursor: text;
}

.filter-card:focus-within {
    border-color: #1978d8;
    box-shadow: 0 0 0 2px rgb(25 120 216 / 12%), 0 4px 9px rgb(23 102 164 / 14%);
}

.filter-icon {
    flex: 0 0 auto;
    display: grid;
    place-items: center;
    width: clamp(38px, 7vw, 52px);
    aspect-ratio: 1;
    margin-right: clamp(8px, 1.8vw, 14px);
    border-radius: 9px;
    color: #0565c5;
    background: #e6f3ff;
}

.filter-icon .v-icon { font-size: clamp(22px, 4.2vw, 31px); }

.filter-copy {
    display: flex;
    flex: 1;
    flex-direction: column;
    min-width: 0;
    color: #263a58;
    line-height: 1.15;
}

.filter-copy strong {
    overflow: hidden;
    font-size: clamp(12px, 2.8vw, 17px);
    font-weight: 600;
    text-overflow: ellipsis;
    white-space: nowrap;
}

.filter-copy input,
.filter-copy select {
    width: 100%;
    min-width: 0;
    margin-top: 4px;
    padding: 0;
    border: 0;
    outline: 0;
    background: transparent;
    color: #627087;
    font: inherit;
    font-size: clamp(10px, 2.35vw, 14px);
    line-height: 1.35;
}

.filter-copy input::placeholder { color: #8390a3; opacity: 1; }
.filter-copy select { appearance: none; padding-right: 34px; cursor: pointer; }
.clear-filter { position: absolute; right: 30px; display: grid; place-items: center; width: 23px; height: 23px; padding: 0; border: 0; border-radius: 50%; background: #9299a3; color: #fff; cursor: pointer; }
.clear-filter .v-icon { font-size: 15px; }
.select-chevron { position: absolute; right: 9px; color: #0873d9; font-size: 21px; pointer-events: none; }

.search-actions {
    display: grid;
    grid-template-columns: minmax(0, 1.95fr) minmax(112px, 1fr);
    gap: clamp(12px, 2.6vw, 24px);
    margin: clamp(24px, 5vw, 42px) 0 22px;
}

.search-button,
.map-button {
    display: flex;
    align-items: center;
    justify-content: center;
    min-height: clamp(49px, 8vw, 63px);
    border: 0;
    border-radius: 8px;
    font: inherit;
    font-size: clamp(14px, 3.3vw, 20px);
    font-weight: 700;
    letter-spacing: .04em;
    text-transform: uppercase;
    cursor: pointer;
}

.search-button {
    gap: 14px;
    color: #fff;
    background: linear-gradient(100deg, #1687ed, #0069d5);
    box-shadow: 0 6px 13px rgb(0 97 202 / 25%);
}

.search-button .v-icon { font-size: clamp(24px, 4.5vw, 31px); }
.map-button { gap: 9px; color: #0861b8; background: #e2f2ff; }
.map-button .v-icon { font-size: clamp(25px, 4.5vw, 31px); }
.search-button:active,
.map-button:active { transform: translateY(1px); }

.map-container {
    height: min(55vh, 480px);
    margin-bottom: 18px;
    overflow: hidden;
    border: 1px solid #c6e2fa;
    border-radius: 14px;
    box-shadow: 0 5px 14px rgb(12 79 134 / 15%);
}

.job-result-card {
    border: 1px solid rgb(152 198 233 / 55%);
    background: rgb(255 255 255 / 94%) !important;
    transition: 0.2s ease;
}

.job-result-card:hover {
    transform: translateY(-3px);
    box-shadow: 0 6px 14px rgb(3 74 133 / 16%) !important;
}

@media (max-width: 390px) {
    .worker-search-page { width: calc(100% - 24px); }
    .search-filters { gap: 8px; }
    .filter-card { padding-inline: 7px; }
    .filter-icon { width: 34px; margin-right: 7px; }
    .filter-copy strong { font-size: 11px; }
    .filter-copy input,
    .filter-copy select { font-size: 9px; }
    .search-actions { grid-template-columns: minmax(0, 1.8fr) minmax(103px, 1fr); gap: 10px; }
    .search-button,
    .map-button { font-size: 12px; }
}
</style>
