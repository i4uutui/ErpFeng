import { defineComponent, onMounted, ref, reactive } from 'vue'
import request from '@/utils/request';
import '@/assets/css/WarehouseRate.scss'
import { reportOperationLog } from '@/utils/log';
import { getItem } from '@/assets/js/storage';

export default defineComponent({
  setup() {
    const formRef = ref(null);
    const rules = reactive({})
    const calcUnit = ref(getItem('constant').filter(o => o.type == 'calcUnit'))
    let dialogVisible = ref(false)
    let form = ref({
      inv_unit: '',
      unit: '',
      buy_price: '',
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
      // await fetchWareList()
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
      const res = await request.post('/api/get_warehouse_type', { type: 'house' })
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
            ElMessage.success('操作成功');
            dialogVisible.value = false;
            fetchWareList()
            
            reportOperationLog({
              operationType: 'update',
              module: '仓库进出存',
              desc: `修改物料信息：物料编码：${form.value.code}，物料名称：${form.value.name}`,
              data: { newData: form.value }
            })
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
      fetchWareList()
    }
    function currentPageChange(val) {
      currentPage.value = val;
      fetchWareList();
    }
    const getTypeName = (value) => {
      return value == 3 ? '销售' : '采购'
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
                <ElTableColumn prop="model_spec" label="型号&规格" width="110" />
                <ElTableColumn prop="other_features" label="其他特性" width="90" />
                <ElTableColumn prop="quantity" label="最新库存" width="90" />
                <ElTableColumn prop="price" label="内部单价" width="90" />
                <ElTableColumn prop="buy_price" label={ `${ getTypeName(menuWareIndex.value) }单价` } width="90" />
                <ElTableColumn label="使用单位" width="90">
                  {({row}) => <span>{ calcUnit.value.find(e => e.id == row.inv_unit)?.name }</span>}
                </ElTableColumn>
                <ElTableColumn label={ `${ getTypeName(menuWareIndex.value) }单位` } width="90">
                  {({row}) => <span>{ calcUnit.value.find(e => e.id == row.unit)?.name }</span>}
                </ElTableColumn>
                <ElTableColumn prop="last_in_time" label="最后入库时间" width="120" />
                <ElTableColumn prop="last_out_time" label="最后出库时间" width="120" />
                <ElTableColumn label="操作" width="100" fixed="right">
                  {(scope) => (
                    <>
                      <ElButton size="small" type="warning" v-permission={ 'WarehouseRate:edit' } onClick={ () => handleUplate(scope.row) }>修改</ElButton>
                    </>
                  )}
                </ElTableColumn>
              </ElTable>
              <ElPagination layout="prev, pager, next, jumper, total" currentPage={ currentPage.value } pageSize={ pageSize.value } total={ total.value } defaultPageSize={ pageSize.value } style={{ justifyContent: 'center', paddingTop: '10px' }} onUpdate:currentPage={ (page) => currentPageChange(page) } onUupdate:pageSize={ (size) => pageSizeChange(size) } />
            </div>
          </div>
        </ElCard>
        <ElDialog v-model={ dialogVisible.value } title='修改物料' width='745' center draggable onClose={ () => handleClose() }>
          {{
            default: () => (
              <ElForm class="ml25" model={ form.value } ref={ formRef } inline={ true } rules={ rules } label-width="80">
                <ElFormItem label="物料编码">
                  <ElInput v-model={ form.value.code } disabled={ true } />
                </ElFormItem>
                <ElFormItem label="物料名称">
                  <ElInput v-model={ form.value.name } disabled={ true } />
                </ElFormItem>
                <ElFormItem label={ `${ getTypeName(form.value.ware_id) }单价` } prop="buy_price">
                  <ElInput v-model={ form.value.buy_price } placeholder={ `请输入${ getTypeName(form.value.ware_id) }单价` } />
                </ElFormItem>
                <ElFormItem label="内部单价" prop="price">
                  <ElInput v-model={ form.value.price } placeholder="请输入内部单价" />
                </ElFormItem>
                <ElFormItem label={ `${ getTypeName(form.value.ware_id) }单位` } prop="unit">
                  <ElSelect v-model={ form.value.unit } multiple={ false } filterable remote remote-show-suffix placeholder={ `请选择${ getTypeName(form.value.ware_id) }单位` }>
                    {calcUnit.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="使用单位" prop="inv_unit">
                  <ElSelect v-model={ form.value.inv_unit } multiple={ false } filterable remote remote-show-suffix placeholder="请选择使用单位">
                    {calcUnit.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
              </ElForm>
            ),
            footer: () => (
              <span class="dialog-footer">
                <ElButton onClick={ handleClose } type="warning">取消</ElButton>
                <ElButton type="primary" onClick={ () => handleSubmit(formRef.value) }>确定</ElButton>
              </span>
            )
          }}
        </ElDialog>
      </>
    )
  }
})