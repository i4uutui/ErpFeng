import { defineComponent, ref, onMounted, watch } from 'vue';
import { getItem } from '@/assets/js/storage';
import { useRoute } from 'vue-router';
import router from '@/router';
import "./main.css"

export default defineComponent({
  setup(){
    const route = useRoute()
    const user = getItem('user')
    const menuRoutes = ref([]);
    const permissions = ref(user.power ? user.power : []); // 假设从后端获取的权限列表
    let menuDefaultActive = ref(route.path)
    const openedMenus = ref([]);

    // 处理菜单展开状态
    const handleMenuOpen = (key) => {
      openedMenus.value.push(key);
    };
    // 处理菜单关闭状态
    const handleMenuClose = (key) => {
      openedMenus.value = openedMenus.value.filter(k => k !== key);
    };
    // 监听路由变化，更新激活状态和展开状态
    watch(
      () => route.path,
      (newPath) => {
        menuDefaultActive.value = newPath;
        
        // 找到当前路由对应的父菜单并展开
        menuRoutes.value.forEach(group => {
          const hasActiveChild = group.children.some(route => 
            newPath.startsWith(route.path)
          );
          
          if (hasActiveChild && !openedMenus.value.includes(group.title)) {
            openedMenus.value.push(group.title);
          } else if (!hasActiveChild && openedMenus.value.includes(group.title)) {
            openedMenus.value = openedMenus.value.filter(k => k !== group.title);
          }
        });
      },
      { immediate: true } // 初始化时立即执行
    );

    onMounted(() => {
      const { children } = router.options.routes.find(route => route.name === 'Layout');
      const groupedRoutes = {};

      // 单独处理首页路由，确保其始终被包含
      const homeRoute = children.find(route => route.name === 'Home');
      if (homeRoute) {
        const { parent } = homeRoute.meta;
        if (!groupedRoutes[parent]) {
          groupedRoutes[parent] = [];
        }
        groupedRoutes[parent].push(homeRoute);
      }

      children.forEach(route => {
        if (route.name === 'Home') return; // 跳过首页，已单独处理
        
        const { parent } = route.meta;
        if (!groupedRoutes[parent]) {
          groupedRoutes[parent] = [];
        }
        if(permissions.value.length){
          if (permissions.value.includes(route.name)) {
            groupedRoutes[parent].push(route);
          }
        }else{
          groupedRoutes[parent].push(route);
        }
      });
      // 过滤掉没有子路由的父菜单组
      const filteredRoutes = Object.fromEntries(
        Object.entries(groupedRoutes).filter(([_, routes]) => routes.length > 0)
      );
      menuRoutes.value = Object.entries(filteredRoutes).map(([key, value]) => {
        const menu = value.filter(row => row.meta.menu == true)
        return {
          title: key,
          children: menu
        }
      });
    });

    return() => (
      <>
        <ElAside style={{ width: "150px", backgroundColor: '#eee' }}>
          <ElMenu default-active="2" class="el-menu-vertical-demo" defaultActive={ menuDefaultActive.value } router unique-opened openeds={openedMenus.value} onOpen={handleMenuOpen} onClose={handleMenuClose}>
            {menuRoutes.value.map(({ title, children }) => {
              if(children.length != 1){
                return (
                  <ElSubMenu key={title} index={title} title={title}>
                    {{
                      title: () => title,
                      default: () => children.map(route => (
                        <ElMenuItem key={route.name} index={route.path}>
                          {route.meta.title}
                        </ElMenuItem>
                      ))
                    }}
                  </ElSubMenu>
                )
              }else{
                return (
                  <ElMenuItem key={children[0].path} index={children[0].path}>
                    {children[0].meta.title}
                  </ElMenuItem>
                )
              }
            })}
          </ElMenu>
        </ElAside>
      </>
    )
  }
})
