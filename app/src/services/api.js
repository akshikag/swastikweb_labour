import axios from "axios";

const api = axios.create({
    baseURL: import.meta.env.VITE_API_BASE_URL ||
        `http://${window.location.hostname}:8000/api/`,
    timeout: 10000, // 10 sec timeout
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
    }
});

// Optional: add auth token automatically
api.interceptors.request.use((config) => {
    const userData = JSON.parse(localStorage.getItem('labour_currentUser'))
    const token = userData?.token // optional chaining avoids errors
    //console.log(token);
    if (token) config.headers.Authorization = `Bearer ${token}`;
    return config;
});


// Intercept responses
api.interceptors.response.use(
    response => response,
    error => {
        const requestUrl = error.config?.url || '';
        const isLoginRequest = requestUrl.includes('worker/login') ||
            requestUrl.includes('employer/login');

        if (error.response?.status === 401 && !isLoginRequest) {
            // Token expired or unauthorized — redirect to home/login page
            alert('Authorization Failled!!')
            window.location.href = '/';
        }
        return Promise.reject(error);
    }
);


export default api;
