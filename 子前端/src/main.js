import { createApp } from "vue";
import { createPinia } from "pinia";
import App from "./App.jsx";
import router from "./router";
import permissionDirective from "./utils/permission";
import Print from "vue3-print-nb";
import { preloadFont } from "./utils/preload-font";

import "@/assets/css/reset.css";
import "@/assets/css/common.css";
import "@/assets/css/main.css";

import { VxeUI } from 'vxe-pc-ui'
// vxe的样式
import 'vxe-table/lib/style.css'
// 导入vxe默认的语言
import zhCN from 'vxe-pc-ui/lib/language/zh-CN'
VxeUI.setI18n('zh-CN', zhCN)
VxeUI.setLanguage('zh-CN')

const store = createPinia();
const app = createApp(App);

app.use(store);
app.use(router);
app.use(Print);
app.use(permissionDirective); // 注册权限指令

app.mount("#app");

setTimeout(() => {
  preloadFont(); // 此时开始加载，不阻塞页面首次渲染
}, 1000);
