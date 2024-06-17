import axios from "axios";

const api = axios.create({
  // baseURL: "http://0.0.0.0:3000/", // local test on localhost
  baseURL: "http://10.193.231.210:3000/", // local test on gitlab
});

export default api;
