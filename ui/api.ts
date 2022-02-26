import axios from "axios"

/**
 * Global level axios configuration. These settings are automatically used in other places by using an axiosInstance instead of axios directly
 */
 let axiosInstance = axios.create({
    headers: {'Content-Type': 'application/json'},
    responseType: "json"
});