import { createRouter, createWebHistory, createWebHashHistory } from 'vue-router';

const routes = [
  // 总后台路由
  {
    path: '/',
    name: 'AdminLogin',
    component: () => import('../views/Login.vue')
  },
  {
    path: '/admin/user',
    name: 'AdminUserList',
    component: () => import('../views/UserList.vue')
  },
  {
    path: '/admin/company',
    name: 'AdminCompany',
    component: () => import('../views/Company.vue')
  }
];

const router = createRouter({
  history: createWebHashHistory(),
  routes
});

export default router;  