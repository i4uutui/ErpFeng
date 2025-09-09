import { defineComponent, onMounted, ref } from 'vue'
import request from '@/utils/request';
import '@/assets/css/WarehouseRate.scss'

export default defineComponent({
  setup() {
    let wareType = ref([])
    let wareActive = ref('')
    let tabList = ref([])
    
    onMounted(() => {
      getWareTypeList()
    })
    
    // 获取仓库类型列表
    const getWareTypeList = async () => {
      const res = await request.get('/api/getWarehouseType')
      wareType.value = res.data
      wareActive.value = res.data[0].id
      fetchTabList()
    }
    // 获取Tab列表
    const fetchTabList = async () => {
      const res = await request.get('/api/warehouse_cycle', {
        params: {
          page: 1,
          pageSize: 100,
          ware_id: wareActive.value
        },
      });
      tabList.value = res.data;
    };
    const menuClick = (row) => {
      wareActive.value = row.index
      fetchTabList()
    }
    const onTabClick = (pane) => {
      const row = tabList.value[pane.index]
    }
    
    return() => (
      <>
        <ElCard bodyStyle={{ height: "calc(100vh - 144px )" }}>
          <div class='flex wareHouse' style={{ alignItems: 'flex-start', height: '100%' }}>
            <ElMenu default-active="1">
              {wareType.value.map((e, index) => <ElMenuItem index={ e.id.toString() } key={ index } onClick={ (row) => menuClick(row) }>{e.name}</ElMenuItem>)}
            </ElMenu>
            <div class="right" style={{ paddingLeft: '20px' }}>
              <ElTabs type="card" onTabClick={ (pane, e) => onTabClick(pane, e) }>
                {tabList.value.map((item, index) => (
                  <ElTabPane label={ item.name }></ElTabPane>
                ))}
              </ElTabs>

            </div>
          </div>
          
        </ElCard>
      </>
    )
  }
})