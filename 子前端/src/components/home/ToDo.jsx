import { getItem } from '@/assets/js/storage';
import { defineComponent, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router';
import request from '@/utils/request'

export default defineComponent({
  setup(){
    const router = useRouter()
    const user = getItem('user')

    let dataObj = ref({})

    onMounted(() => {
      statistics()
    })

    const statistics = async () => {
      const res = await request.get('/api/statistics')
      if(res.code == 200){
        dataObj.value = res.data
      }
    }
    const goToDo = (url, value) => {
      const allRoutes = router.getRoutes();
      const path = allRoutes.find(route => route.path === url);

      if(user.type == 1) return router.push(url)
      if(path && user.power.includes(value)){
        return router.push(url)
      }else{
        return ElMessage('暂无权限')
      }
    }
    
    return() => (
      <ElCard shadow="always" bodyStyle={{ width: '100%' }}>
        {{
          header: () => (
            <div class="card-header">
              <span>待办事项</span>
            </div>
          ),
          default: () => (
            <ElRow>
              <ElCol md={ 6 } xl={ 6 } class="text-center mb-4">
                <ElStatistic title="采购单" value={ dataObj.value.materialMent } valueStyle={{ fontSize: '32px', fontWeight: 'blod', color: dataObj.value.materialMent > 0 ? "red" : '' }} onClick={ () => goToDo('/purchase/purchase-order', 'PurchaseOrder') } />
              </ElCol>
              <ElCol md={ 6 } xl={ 6 } class="text-center mb-4">
                <ElStatistic title="委外加工单" value={ dataObj.value.outsourcingOrder } valueStyle={{ fontSize: '32px', fontWeight: 'blod', color: dataObj.value.outsourcingOrder > 0 ? "red" : '' }} onClick={ () => goToDo('/outsourcing/outsourcing-order', 'OutsourcingOrder') } />
              </ElCol>
              <ElCol md={ 6 } xl={ 6 } class="text-center mb-4">
                <ElStatistic title="材料出入库" value={ dataObj.value.materialOrder } valueStyle={{ fontSize: '32px', fontWeight: 'blod', color: dataObj.value.materialOrder > 0 ? "red" : '' }} onClick={ () => goToDo('/warehouse/material-house', 'MaterialHouse') } />
              </ElCol>
              <ElCol md={ 6 } xl={ 6 } class="text-center mb-4">
                <ElStatistic title="成品出入库" value={ dataObj.value.productOrder } valueStyle={{ fontSize: '32px', fontWeight: 'blod', color: dataObj.value.productOrder > 0 ? "red" : '' }} onClick={ () => goToDo('/warehouse/product-house', 'ProductHouse') } />
              </ElCol>
            </ElRow>
          )
        }}
      </ElCard>
    )
  }
})