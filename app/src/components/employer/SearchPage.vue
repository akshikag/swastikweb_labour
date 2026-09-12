<template>
    <LogoutAppBar />

    <v-container class="employer-search-page" fluid>
        <!-- Title -->
        <h2 class="search-page-title">Find Work/Jobs</h2>

        <!-- Filters -->
        <v-row class="search-filters" dense>
            <v-col cols="6">
                <div class="search-filter-field"><span class="filter-icon"><v-icon>mdi-map-marker</v-icon></span><div class="filter-control"><label>Location</label><v-text-field v-model="filters.location" placeholder="Enter location" variant="outlined" density="compact" hide-details /></div></div>
            </v-col>

            <v-col cols="6">
                <div class="search-filter-field"><span class="filter-icon"><v-icon>mdi-map-marker</v-icon></span><div class="filter-control"><label>Pincode</label><v-text-field v-model="filters.pincode" placeholder="Enter pincode" variant="outlined" density="compact" hide-details /></div></div>
            </v-col>

            <v-col cols="6">
                <div class="search-filter-field"><span class="filter-icon"><v-icon>mdi-briefcase</v-icon></span><div class="filter-control"><label>Select Skill</label><v-select v-model="filters.skill" :items="skills" item-title="name" item-value="id" placeholder="Choose Skill" variant="outlined" density="compact" hide-details clearable /></div></div>
            </v-col>
            <v-col cols="6">
                <div class="search-filter-field"><span class="filter-icon"><v-icon>mdi-ruler</v-icon></span><div class="filter-control"><label>Range (km)</label><v-select v-model="filters.range" :items="ranges" item-title="name" item-value="id" placeholder="Select range" variant="outlined" density="compact" hide-details clearable /></div></div>
            </v-col>
        </v-row>

        <!-- Range Filter -->
        <v-row class="search-actions align-center mb-3 mt-2">
            <v-col cols="8" class="text-right">
                <v-btn color="primary" prepend-icon="mdi-magnify" class="w-100" @click="filterWorkers">
                    SEARCH
                </v-btn>
            </v-col>
            <v-col cols="4" class="text-right">
                <!-- Toggle View -->
                <v-btn variant="tonal" color="primary" @click="toggleMap">
                    <v-icon left>{{ showMap ? 'mdi-format-list-bulleted' : 'mdi-map' }}</v-icon>
                    {{ showMap ? 'LIST VIEW' : 'MAP VIEW' }}
                </v-btn>
            </v-col>
        </v-row>

        <div v-if="loading" class="d-flex justify-center align-center" style="height: 200px;">
            <v-progress-circular indeterminate color="primary" size="50"></v-progress-circular>
        </div>

        <!-- Map View -->
        <div v-show="showMap" id="mapContainer" style="height: 400px; border-radius: 12px;" class="mb-4"></div>
        <!-- List View -->
        <v-row dense v-show="!showMap">
            <v-col v-for="worker in workers" :key="worker.id" cols="12" sm="6" md="4">
                <v-card class="worker-result-card" elevation="0">
                    <v-row align="center" no-gutters>
                        <!-- Avatar -->
                        <v-col cols="auto">
                            <v-avatar size="60" color="orange lighten-2">
                                <v-img :src="worker.profile_image_url" alt="Worker Image" cover></v-img>
                            </v-avatar>
                        </v-col>

                        <!-- Info -->
                        <v-col class="pl-3">
                            <h4 class="mb-1 text-subtitle-1">{{ worker.name }}</h4>
                            <p class="mb-0 text-caption">📞 {{ worker.phone }}</p>
                            <p class="mb-0 text-caption">📍 {{ worker.street_area_village }}</p>
                            <p class="mb-0 text-caption">🛠️ {{ (worker.skill_names || []).join(', ') }}</p>
                        </v-col>

                        <!-- Button -->
                        <v-col cols="auto" class="pl-2">
                            <v-btn color="primary" size="small" icon @click="showDetails(worker)">
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
    </v-container>
</template>

<script>
import L from "leaflet";
import "leaflet/dist/leaflet.css";
import LogoutAppBar from "@/components/header/LogoutAppBar.vue";

import api from "@/services/api.js";
import apiRoutes from "@/services/apiRoutes.js";
import { Geolocation } from "@capacitor/geolocation";

export default {
    name: "EmployerSearchPage",
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
            workers: [],
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
        this.getWorkers(),
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

        async getWorkers() {
            this.loading = true;
            try {
                const res = await api.get(apiRoutes.employerWorkerfetchAllWorker, {
                    params: {
                        location: this.filters.location,
                        lat: this.latitude,
                        long: this.longitude,
                        skill_id: this.filters.skill,
                        range: this.filters.range,
                        page: this.page,
                    }
                });

                console.log('worker', res.data)
                if (res.data?.workers) {
                    // APPEND new workers to old list
                    this.workers = [...this.workers, ...res.data.workers];
                    // update page for next "Load More"

                    this.page = res.data.next_page;
                    this.has_more = res.data.has_more;

                    if (this.showMap) {
                        this.addWorkerMarkers();
                    }

                }
                this.loading = false;
            } catch (error) {
                //console.error("Error fetching skills:", error);
                alert("Failed to load worker.");
                this.loading = false;
            }
        },

        filterWorkers() {
            this.page = 1;
            this.workers = [];
            this.getWorkers()

        },

        loadMore() {
            this.getWorkers()
        },
        showDetails(worker) {
            this.$router.push({
                name: "employer-dashboard-home-applied-worker-detail",
                params: { id: worker.id },
            });
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
            this.addWorkerMarkers();
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


            // Add worker markers
            this.addWorkerMarkers();
            } catch (error) {
                console.warn("Mappls unavailable; using OpenStreetMap fallback.", error);
                this.initFallbackMap();
            }
        },
        addWorkerMarkers() {
            if (!this.workers || this.workers.length === 0) return;


            this.clearWorkerMarkers();

            this.markers = [];

            this.workers.forEach(worker => {
                if (this.mapObj instanceof L.Map) {
                    const marker = L.marker([Number(worker.lat), Number(worker.long)]).addTo(this.mapObj);
                    marker.bindPopup(`<strong>${worker.name || "Worker"}</strong><br>${worker.phone || ""}`);
                    this.markers.push(marker);
                    return;
                }
                const marker = new mappls.Marker({
                    map: this.mapObj,
                    position: { lat: worker.lat, lng: worker.long },
                    icon: this.createMarkerIcon(this.getPrimaryColor()),
                    // fitbounds: true,
                    popupHtml: `
                                   <div style="padding: 8px; font-size: 14px;">
                    <strong>${worker.name}</strong><br>
                    📞 ${worker.phone}<br><br>
                    <button id="viewDetailsBtn_${worker.id}"
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
                        const btn = document.getElementById(`viewDetailsBtn_${worker.id}`);
                        if (btn) {
                            btn.onclick = () => {
                                // Navigate to detail page with worker id
                                this.$router.push({ name: "employer-dashboard-home-applied-worker-detail", params: { id: worker.id } });
                            };
                        }
                    }, 50);
                });
            });

        },
        clearWorkerMarkers() {
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
.employer-search-page{min-height:calc(100vh - 64px);padding:16px 15px 92px!important;background:#fff url('@/assets/authenticated-background.png') center/100% 100% no-repeat;color:#142b58}.search-page-title{margin:4px 0 18px;color:#171d2b;font-size:25px;font-weight:800;text-align:center}.search-filters{width:100%;margin:0 auto}.search-filters :deep(.v-col){padding:3px!important}.search-filters :deep(.v-field){min-height:41px;border:1px solid #aeb9c8;border-radius:5px;background:#fff}.search-filters :deep(.v-field__input){min-height:39px;padding-inline:10px;font-size:16px}.search-filters :deep(.v-label){font-size:15px;color:#777}.search-filters :deep(.v-field__prepend-inner){color:#7c7c7c;padding-right:5px}.search-filters :deep(.v-field__append-inner){color:#777}.search-actions{margin:12px 0 16px!important}.search-actions :deep(.v-col){padding:3px!important}.search-actions .v-btn{height:37px!important;border-radius:4px;font-size:14px;font-weight:800;letter-spacing:.5px}.search-actions .v-btn:first-child{background:#167cd5!important;color:#fff}.search-actions .v-btn:last-child{background:#e5f1fc!important;color:#1269b7}.worker-result-card{min-height:126px;padding:10px 12px;border:1px solid #d8d8d8;border-radius:9px!important;background:#fffffff5!important;box-shadow:0 2px 5px #0000001c!important;transition:transform .18s,box-shadow .18s}.worker-result-card:hover{transform:translateY(-2px);box-shadow:0 6px 14px #00000022!important}.worker-result-card :deep(.v-avatar){flex:0 0 auto}.worker-result-card :deep(.v-col){padding:0}.worker-result-card :deep(.pl-3){padding-left:12px!important}.worker-result-card h4{color:#343434;font-size:16px!important;font-weight:500}.worker-result-card p{margin:2px 0!important;color:#444;font-size:12px;line-height:1.45}.worker-result-card .v-btn{width:40px;height:40px;background:#147bd6!important;box-shadow:0 3px 7px #0b579c3d}.worker-result-card .v-btn .v-icon{color:#fff;font-size:25px}.employer-search-page :deep(#mapContainer){border:1px solid #bdd2e7;box-shadow:0 3px 10px #163f6b1c}.employer-search-page .v-progress-circular{margin-top:25px}
@media(min-width:651px){.employer-search-page{padding:28px 24px 110px!important}.search-page-title{font-size:34px}.search-filters,.search-actions{max-width:900px}.worker-result-card{max-width:900px;margin:0 auto}}
@media(max-width:390px){.employer-search-page{padding-inline:10px!important}.search-page-title{font-size:23px;margin-bottom:14px}.search-filters :deep(.v-field__input){font-size:14px}.search-actions .v-btn{font-size:12px}.worker-result-card p{font-size:11px}}
.search-page-title{margin:6px 0 22px;color:#0a2255;font-size:30px;font-weight:800;letter-spacing:-.8px}.search-page-title:after{content:'◇';display:block;margin:4px auto 0;color:#546d99;font-size:18px;font-weight:400;line-height:1}.search-filter-field{display:flex;align-items:center;gap:8px;min-height:62px;padding:7px 8px;border:1px solid #b9dcff;border-radius:10px;background:#fff;box-shadow:0 5px 12px #1676d218}.filter-icon{display:grid;place-items:center;flex:0 0 34px;width:34px;height:34px;border-radius:9px;background:#e1f1ff;color:#086aca}.filter-icon .v-icon{font-size:22px}.filter-control{flex:1;min-width:0}.filter-control label{display:block;margin:0 0 1px;color:#1c345f;font-size:12px;font-weight:700;line-height:1.1;text-align:left}.filter-control :deep(.v-field){min-height:26px;border:0!important;border-radius:0;background:transparent;box-shadow:none}.filter-control :deep(.v-field__outline){display:none}.filter-control :deep(.v-field__input){min-height:25px;padding:0!important;color:#1d3d70;font-size:12px}.filter-control :deep(.v-field__input input::placeholder){color:#8294ae;opacity:1}.filter-control :deep(.v-field__append-inner){padding:0;color:#0870d5}.filter-control :deep(.v-field__clearable){display:none}.search-actions{margin-top:16px!important}.search-actions .v-btn:first-child{background:#087fe5!important}.search-actions .v-btn:last-child{background:#e4f2ff!important;color:#086ac4!important}.search-actions .v-btn .v-icon{font-size:22px}
@media(max-width:390px){.search-page-title{font-size:29px;margin-bottom:20px}.search-filter-field{min-height:62px}.filter-icon{flex-basis:34px;width:34px}.filter-control label{font-size:12px}.filter-control :deep(.v-field__input){font-size:12px}.search-actions{margin-top:17px!important}.search-actions .v-btn{height:49px!important;font-size:13px}}
</style>
