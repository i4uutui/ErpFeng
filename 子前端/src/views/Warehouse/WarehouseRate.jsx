import { defineComponent, onMounted, ref, reactive, nextTick } from 'vue'
import request from '@/utils/request';
import dayjs from "dayjs"
import '@/assets/css/WarehouseRate.scss'
import { reportOperationLog } from '@/utils/log';
import { getItem } from '@/assets/js/storage';
import { getPageHeight } from '@/utils/tool';
import HeadForm from '@/components/form/HeadForm';
import deepClone from '@/utils/deepClone';
import Check from './components/check.vue';

export default defineComponent({
  setup() {
    const operate = reactive([{ id: 1, name: '入库' }, { id: 2, name: '出库' }])
    const checkRef = ref(null)
    const formHeight = ref(0);
    const formCard = ref(null)
    const pagin = ref(null)
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
    let tabsActive = ref({})
    let materialList = ref([])
    let partList = ref([])
    let productList = ref([])
    let typeSelectList = ref([])
    let tableData = ref([])
    let currentPage = ref(1);
    let pageSize = ref(10);
    let total = ref(0);
    let search = ref({
      operateId: '',
      typeId: '',
      item_id: '',
      dateTime: []
    })
    
    onMounted(() => {
      // 获取最近一年的日期
      const currentDate = dayjs();
      const firstDay = currentDate.startOf('month').format('YYYY-MM-DD HH:mm:ss');
      const lastDay = currentDate.endOf('month').format('YYYY-MM-DD HH:mm:ss');
      search.value.dateTime = [firstDay, lastDay]
      
      nextTick(async () => {
        formHeight.value = await getPageHeight([formCard.value, pagin.value]);
      })
      getWareTypeList()

      setTimeout(() => {
        getMaterialList()
        getPartList()
        getProductList()
      }, 500);
    })
    
    // 仓库列表数据
    const fetchWareList = async () => {
      const res = await request.get('/api/get_wareHouser', { params: {
        house_id: tabsActive.value.id,
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
      const res = await request.get('/api/get_warehouseList', { params: { type: 'house' } })
      wareType.value = res.data
      tabsActive.value = res.data[0].cycle[0]
      fetchWareList()
    }
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
    const formOperateSelect = async (value) => {
      let typeValue = ''
      if(tabsActive.value.ware_id == 1){
        typeValue = value == 1 ? 'materialIn' : 'materialOut'
      }else{
        typeValue = value == 1 ? 'productIn' : 'productOut'
      }
      const res = await request.post('/api/get_warehouse_type', { type: typeValue })
      typeSelectList.value = res.data
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
    const wareTab = (row) => {
      search.value.operateId = ''
      search.value.typeId = ''
      search.value.item_id = ''
      typeSelectList.value = []
      tabsActive.value = row
      fetchWareList()
    }
    const dateChange = (value) => {
      const startTime = `${value[0]} 00:00:00`
      const endTime = `${value[1]} 23:59:59`
      dateTime.value = [startTime, endTime]
    }
    const searchApply = () => {
      const obj = deepClone(search.value)
      obj.ware_id = tabsActive.value.ware_id
      obj.house_id = tabsActive.value.id
      checkRef.value.typeSelectList = typeSelectList.value
      checkRef.value.dialogVisible = true
      checkRef.value.fetchList(obj)
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
    const getWuliaoName = (value) => {
      return value == 3 ? '产品' : '材料'
    }
    
    return() => (
      <>
        <ElCard bodyStyle={{ height: "calc(100vh - 248px )" }}>
          {{
            header: () => (
              <HeadForm headerWidth="270px" ref={ formCard }>
                {{
                  center: () => (
                    <>
                      <ElFormItem label="出入库:">
                        <ElSelect v-model={ search.value.operateId } multiple={false} filterable remote remote-show-suffix clearable valueKey="id" placeholder="请选择出入库" onChange={ (row) => formOperateSelect(row) } style={{ width: '160px' }}>
                          {operate.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                        </ElSelect>
                      </ElFormItem>
                      <ElFormItem label="出入库方式:">
                        <ElSelect v-model={ search.value.typeId } multiple={false} filterable remote remote-show-suffix clearable valueKey="id" placeholder="请选择出入库方式" style={{ width: '160px' }}>
                          {typeSelectList.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                        </ElSelect>
                      </ElFormItem>
                      <ElFormItem label={`${ getWuliaoName(tabsActive.value.ware_id) }名称:`}>
                        <ElSelect v-model={ search.value.item_id } multiple={false} filterable remote remote-show-suffix clearable valueKey="id" placeholder={ `请选择${ getWuliaoName(tabsActive.value.ware_id) }名称` } style={{ width: '160px' }}>
                          {tableData.value.map((e, index) => <ElOption value={ e.item_id } label={ e.name } key={ index } />)}
                        </ElSelect>
                      </ElFormItem>
                      <ElFormItem label="周期:">
                        <ElDatePicker v-model={ search.value.dateTime } type="daterange" clearable={ false } range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期" value-format="YYYY-MM-DD" onChange={ (row) => dateChange(row) } />
                      </ElFormItem>
                    </>
                  ),
                  right: () => (
                    <ElFormItem>
                      <ElButton type="primary" onClick={ () => searchApply() }>盘点</ElButton>
                    </ElFormItem>
                  )
                }}
              </HeadForm>
            ),
            default: () => (
              <div class='flex wareHouse' style={{ alignItems: 'flex-start' }}>
                <div class='menus'>
                  {
                    wareType.value.map(e => (
                      <div class='item'>
                        <span class="title">{ e.name }</span>
                        <div class='itemMenu'>
                          {
                            e.cycle.map(cycle => <div class='li' onClick={ () => wareTab(cycle) }><span class={ `title${tabsActive.value.id == cycle.id ? ' active' : ''}` }>{ cycle.name }</span></div>)
                          }
                        </div>
                      </div>
                    ))
                  }
                </div>
                <div class="right" style={{ padding: '0 20px', width: 'calc(100% - 100px)' }}>
                  <ElTable data={ tableData.value } border stripe height={ `calc(100vh - ${formHeight.value + 220}px)` } style={{ width: "100%" }}>
                    <ElTableColumn prop="code" label={ `${ getWuliaoName(tabsActive.value.ware_id) }编码` } width="90" />
                    <ElTableColumn prop="name" label={ `${ getWuliaoName(tabsActive.value.ware_id) }名称` } width="90" />
                    <ElTableColumn prop="model_spec" label="型号&规格" width="110" />
                    <ElTableColumn prop="other_features" label="其他特性" width="90" />
                    <ElTableColumn prop="quantity" label="最新库存" width="90" />
                    <ElTableColumn prop="price" label="内部单价" width="90" />
                    <ElTableColumn prop="buy_price" label={ `${ getTypeName(tabsActive.value.ware_id) }单价` } width="90" />
                    <ElTableColumn label="使用单位" width="90">
                      {({row}) => <span>{ calcUnit.value.find(e => e.id == row.inv_unit)?.name }</span>}
                    </ElTableColumn>
                    <ElTableColumn label={ `${ getTypeName(tabsActive.value.ware_id) }单位` } width="90">
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
                  <ElPagination ref={ pagin } layout="prev, pager, next, jumper, total" currentPage={ currentPage.value } pageSize={ pageSize.value } total={ total.value } defaultPageSize={ pageSize.value } style={{ justifyContent: 'center', paddingTop: '10px' }} onUpdate:currentPage={ (page) => currentPageChange(page) } onUupdate:pageSize={ (size) => pageSizeChange(size) } />
                </div>
              </div>
            )
          }}
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
        <Check ref={ checkRef } />
      </>
    )
  }
})