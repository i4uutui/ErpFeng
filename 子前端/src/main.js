import { createApp } from 'vue';
import { createPinia } from 'pinia'
import App from './App.jsx';
import router from './router';
import permissionDirective from './utils/permission';
import Print from 'vue3-print-nb';

import "@/assets/css/reset.css"
import "@/assets/css/common.css"
import "@/assets/css/main.css"

const store = createPinia()
const app = createApp(App);

app.use(store)
app.use(router);
app.use(Print)
app.use(permissionDirective); // 注册权限指令

app.mount('#app');  