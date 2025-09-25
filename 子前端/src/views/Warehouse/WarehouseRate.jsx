import { defineComponent, onMounted, ref, reactive } from 'vue'
import request from '@/utils/request';
import '@/assets/css/WarehouseRate.scss'

export default defineComponent({
  setup() {
    const formRef = ref(null);
    const rules = reactive({})
    let dialogVisible = ref(false)
    let form = ref({
      inv_unit: '',
      price: ''
    })
    let isPartId = ref(false) // 临时
    let wareType = ref([])
    let menuWareIndex = ref('')
    let wareActive = ref('')
    let tabsActive = ref('')
    let tabList = ref([])
    let materialList = ref([])
    let partList = ref([])
    let productList = ref([])
    let tableData = ref([])
    let currentPage = ref(1);
    let pageSize = ref(10);
    let total = ref(0);
    
    onMounted(async () => {
      await getWareTypeList()
      await getMaterialList()
      await getPartList()
      await getProductList()
      await fetchWareList()
    })
    
    // 仓库列表
    const fetchWareList = async () => {
      const res = await request.get('/api/get_wareHouser', { params: {
        house_id: tabsActive.value,
        page: currentPage.value,
        pageSize: pageSize.value
      } })
      if(res.code == 200){
        tableData.value = res.data;
        total.value = res.total;
      }
    }
    // 获取仓库类型列表
    const getWareTypeList = async () => {
      const res = await request.post('/api/getConstType', { type: 'house' })
      wareType.value = res.data
      wareActive.value = res.data[0].id
      menuWareIndex.value = res.data[0].id
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
      tabsActive.value = res.data[0].id
      fetchWareList()
    };
    // 提交修改
    const handleSubmit = async (formEl) => {
      if (!formEl) return
      await formEl.validate(async (valid, fields) => {
        if (valid){
          const res = await request.put('/api/set_wareHouser', form.value);
          if(res && res.code == 200){
            ElMessage.success('新增成功');
            dialogVisible.value = false;
          }
        }
      })
    }
    // 获取材料编码列表
    const getMaterialList = async () => {
      const res = await request.get('/api/getMaterialCode')
      materialList.value = res.data
    }
    // 获取部件编码列表
    const getPartList = async () => {
      const res = await request.get('/api/getPartCode')
      partList.value = res.data
    }
    // 获取产品编码列表
    const getProductList = async () => {
      const res = await request.get('/api/getProductsCode')
      productList.value = res.data
    }
    const menuChange = (value) => {
      menuWareIndex.value = value
    }
    const handleUplate = (row) => {
      const item = JSON.parse(JSON.stringify(row))
      item.price = Number(item.price)
      form.value = item
      dialogVisible.value = true
    }
    // 取消弹窗
    const handleClose = () => {
      isPartId.value = false
      dialogVisible.value = false;
      resetForm()
    }
    const resetForm = () => {
      form.value = {
        inv_unit: '',
        price: '',
      }
    }
    const menuClick = (row) => {
      wareActive.value = row.index
      fetchTabList()
    }
    const onTabClick = (pane) => {
      fetchWareList()
    }
    // 分页相关
    function pageSizeChange(val) {
      currentPage.value = 1;
      pageSize.value = val;
      fetchProductList()
    }
    function currentPageChange(val) {
      currentPage.value = val;
      fetchProductList();
    }
    
    return() => (
      <>
        <ElCard bodyStyle={{ height: "calc(100vh - 144px )" }}>
          <div class='flex wareHouse' style={{ alignItems: 'flex-start', height: '100%' }}>
            <ElMenu default-active="1" style={{ width: '85px' }} onSelect={ (row) => menuChange(row) }>
              {wareType.value.map((e, index) => <ElMenuItem index={ e.id.toString() } key={ index } onClick={ (row) => menuClick(row) }>{e.name}</ElMenuItem>)}
            </ElMenu>
            <div class="right" style={{ padding: '0 20px', width: 'calc(100% - 100px)' }}>
              <ElTabs v-model={ tabsActive.value } type="card" onTabChange={ (pane) => onTabClick(pane) }>
                {tabList.value.map((item, index) => (
                  <ElTabPane label={ item.name } name={ item.id } key={ item.id }></ElTabPane>
                ))}
              </ElTabs>
              <ElTable data={ tableData.value } border stripe height={`calc(100vh - 280px)`} style={{ width: "100%" }}>
                <ElTableColumn prop="code" label="物料编码" width="90" />
                <ElTableColumn prop="name" label="物料名称" width="90" />
                <ElTableColumn prop="model_spec" label="规格型号" width="90" />
                <ElTableColumn prop="other_features" label="其他特性" width="90" />
                <ElTableColumn prop="inv_unit" label="库存单位" width="90" />
                <ElTableColumn prop="initial" label="期初数量" width="90" />
                <ElTableColumn prop="number_in" label="入库数量" width="90" />
                <ElTableColumn prop="number_out" label="出库数量" width="90" />
                <ElTableColumn prop="number_new" label="最新库存" width="90" />
                <ElTableColumn prop="price" label="内部单价" width="90" />
                <ElTableColumn prop="price_total" label="存货金额" width="90" />
                <ElTableColumn prop="price_out" label="出库金额" width="90" />
                <ElTableColumn prop="last_in_time" label="最后入库时间" width="120" />
                <ElTableColumn prop="last_out_time" label="最后出库时间" width="120" />
                <ElTableColumn label="操作" width="100" fixed="right">
                  {(scope) => (
                    <>
                      <ElButton size="small" type="default" v-permission={ 'WarehouseRate:edit' } onClick={ () => handleUplate(scope.row) }>修改</ElButton>
                    </>
                  )}
                </ElTableColumn>
              </ElTable>
              <ElPagination layout="prev, pager, next, jumper, total" currentPage={ currentPage.value } pageSize={ pageSize.value } total={ total.value } defaultPageSize={ pageSize.value } style={{ justifyContent: 'center', paddingTop: '10px' }} onUpdate:currentPage={ (page) => currentPageChange(page) } onUupdate:pageSize={ (size) => pageSizeChange(size) } />
            </div>
          </div>
        </ElCard>
        <ElDialog v-model={ dialogVisible.value } title='修改物料' onClose={ () => handleClose() }>
          {{
            default: () => (
              <ElForm model={ form.value } ref={ formRef } inline={ true } rules={ rules } label-width="110px">
                <ElFormItem label="物料编码">
                  <ElInput v-model={ form.value.code } disabled={ true } />
                </ElFormItem>
                <ElFormItem label="物料名称">
                  <ElInput v-model={ form.value.name } disabled={ true } />
                </ElFormItem>
                <ElFormItem label="库存单位" prop="inv_unit">
                  <ElInput v-model={ form.value.inv_unit } placeholder="请输入库存单位" />
                </ElFormItem>
                <ElFormItem label="内部单价" prop="price">
                  <ElInput v-model={ form.value.price } placeholder="请输入内部单价" />
                </ElFormItem>
              </ElForm>
            ),
            footer: () => (
              <span class="dialog-footer">
                <ElButton onClick={ handleClose }>取消</ElButton>
                <ElButton type="primary" onClick={ () => handleSubmit(formRef.value) }>确定</ElButton>
              </span>
            )
          }}
        </ElDialog>
      </>
    )
  }
})