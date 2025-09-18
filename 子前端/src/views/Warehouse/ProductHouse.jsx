import { defineComponent, onMounted, reactive, ref } from 'vue'
import { getRandomString, PreciseMath } from '@/utils/tool'
import request from '@/utils/request';

export default defineComponent({
  setup(){
    const statusType = reactive({
      0: '待审核',
      1: '已通过',
      2: '已拒绝'
    })
    const operateValue = reactive({
      1: '入库',
      2: '出库'
    })
    const statusList = ref([{ id: 0, name: '待审核' }, { id: 1, name: '已通过' }, { id: 2, name: '已拒绝' }])
    const operate = reactive([{ id: 1, name: '入库' }, { id: 2, name: '出库' }])
    const formRef = ref(null)
    const rules = ref({})
    let form = ref({
      ware_id: 2,
      house_id: '',
      house_name: '',
      operate: '',  // 入库 or 出库
      type: '', // 常量类型
      plan_id: '', // 客户id or 制程id
      plan: '', // 客户 or 制程
      item_id: '',
      code: '',
      name: '',
      model_spec: '',
      quantity: '',
      buy_price: '',
    })
    let dialogVisible = ref(false)
    let constObj = ref({})
    let constType = ref([]) // 常量列表
    let houseList = ref([]) // 仓库名称列表
    let customerList = ref([]) // 供应商列表
    let cycleList = ref([]) // 制程列表
    let productList = ref([]) // 材料编码
    let tableData = ref([])
    let allSelect = ref([])
    let edit = ref('')
    // 筛选使用
    let typeSelectList = ref([])
    let houseId = ref('')
    let operateId = ref('')
    let typeId = ref('')
    let customerId = ref('')
    let cycleId = ref('')
    let productId = ref('')
    let statusId = ref('')

    onMounted(async () => {
      await getConstType()
      await getCustomerInfo() // 获取客户
      await getProcessCycle() // 获取制程
      await getProductsCode() // 获取产品编码
      await getHouseList() // 获取仓库名称
      await filterQuery()
    })

    const filterQuery = async () => {
      const res = await request.post('/api/warehouse_apply', {
        house_id: houseId.value,
        operate: operateId.value,
        type: typeId.value ? typeId.value : constType.value.filter(e => e.type == 'productIn' || e.type == 'productOut').map(o => o.id),
        plan_id: customerId.value ? customerId.value : cycleId.value,
        item_id: productId.value,
        status: statusId.value,
      })
      tableData.value = res.data
    }
    // 获取常量
    const getConstType = async () => {
      const res = await request.post('/api/getConstType', { type: ['productIn', 'productOut', 'house'] })
      constType.value = res.data

      const transformedData = {};
      res.data.forEach(item => {
        if (item.hasOwnProperty('id') && item.hasOwnProperty('name')) {
          transformedData[item.id] = item.name;
        } else {
          console.error('无效的项目结构:', item);
        }
      });
      constObj.value = transformedData
    }
    // 获取客户
    const getCustomerInfo = async () => {
      const res = await request.get('/api/getCustomerInfo')
      customerList.value = res.data
    }
    // 获取制程
    const getProcessCycle = async () => {
      const res = await request.get('/api/getProcessCycle')
      cycleList.value = res.data
    }
    // 获取产品编码
    const getProductsCode = async () => {
      const res = await request.get('/api/getProductsCode')
      productList.value = res.data
    }
    // 获取仓库名称
    const getHouseList = async () => {
      const res = await request.get('/api/warehouse_cycle', { params: { ware_id: 2 } })
      houseList.value = res.data
      form.value.house_id = res.data[0].id
      form.value.house_name = res.data[0].name
    }
    const setApiData = async (data) => {
      const res = await request.post('/api/add_wareHouse_order', { data })
      if(res && res.code == 200){
        ElMessage.success('提交成功');
        filterQuery();
      }
    }
    const handleStatusData = async (row) => {
      const data = getFormData(row)
      setApiData([data])
    }
    // 批量提交审核
    const setStatusAllData = async () => {
      const json = allSelect.value.length ? allSelect.value.filter(o => o.status == undefined) : tableData.value.filter(o => o.status == undefined)
      if(json.length == 0){
        ElMessage.error('暂无可提交的数据')
      }
      const data = json.map(e => {
        return getFormData(e)
      })
      setApiData(data)
    }
    const getFormData = (e) => {
      return {
        ware_id: 2,
        house_id: e.house_id,
        house_name: e.house_name,
        operate: e.operate,  // 入库 or 出库
        type: e.type, // 常量类型
        plan_id: e.plan_id, // 供应商id or 制程id
        plan: e.plan, // 供应商 or 制程
        item_id: e.item_id,
        code: e.code,
        name: e.name,
        model_spec: e.model_spec,
        quantity: e.quantity,
        buy_price: e.buy_price,
      }
    }
    const handleSubmit = async (formEl) => {
      if (!formEl) return
      await formEl.validate(async (valid, fields) => {
        if (valid){
          if(!edit.value){
            const obj = JSON.parse(JSON.stringify(form.value))
            const res = await request.post('/api/queryWarehouse', obj)
            if(res.code != 200) return
            obj.id = getRandomString() // 临时ID
            console.log(obj);
            tableData.value = [obj, ...tableData.value]
            dialogVisible.value = false;
            
          }else{
            if(form.value.status >= 0){
              // 修改
              const myForm = {
                id: edit.value,
                ...form.value
              }
              const res = await request.put('/api/wareHouse_order', myForm);
              if(res && res.code == 200){
                ElMessage.success('修改成功');
                dialogVisible.value = false;
                filterQuery();
              }
            }else{
              const obj = JSON.parse(JSON.stringify(form.value))
              const res = await request.post('/api/queryWarehouse', obj)
              if(res.code != 200) return
              tableData.value = tableData.value.map(o => {
                if(o.id == edit.value){
                  return obj
                }
                return o
              })
              dialogVisible.value = false;
            }
          }
        }
      })
    }
    const handleUplate = (row) => {
      edit.value = row.id;
      dialogVisible.value = true;
      form.value = { ...row };
    }
    const handleAdd = (value) => {
      form.value.operate = value
      dialogVisible.value = true
      const list = getConstList();
      form.value.type = list.length > 0 ? list[0].id : '';
    }
    const houseChange = (value) => {
      const jsonObj = houseList.value.find(e => e.id == value)
      form.value.house_name = jsonObj.name
    }
    const typeChange = (value) => {
      form.value.plan_id = ''
      form.value.plan = ''
      if(value != 4){
        form.value.buy_price = ''
      }
    }
    const planChange = (value, label) => {
      const list = label == 'name' ? cycleList.value : customerList.value
      const obj = list.find(e => e.id == value)
      form.value.plan = obj[label]
    }
    const productChange = (value) => {
      const obj = productList.value.find(e => e.id == value)
      form.value.code = obj.product_code
      form.value.name = obj.product_name
      form.value.model_spec = `${obj.model}/${obj.specification}`
    }
    const formOperateSelect = async (value) => {
      typeId.value = '' // 重新选择出入库后，重置出入库方式
      const typeValue = value == 1 ? 'productIn' : 'productOut'
      const res = await request.post('/api/getConstType', { type: typeValue })
      typeSelectList.value = res.data
    }
    const formcustomerSelect = (value) => {
      cycleId.value = ''
    }
    const formCycleSelect = (value) => {
      customerId.value = ''
    }
    const handleClose = () => {
      dialogVisible.value = false
      reset()
    }
    const reset = () => {
      setTimeout(() => {
        form.value = {
          ware_id: 2,
          house_id: houseList.value[0].id,
          house_name: houseList.value[0].name,
          operate: '',
          type: '',
          plan_id: '',
          plan: '',
          item_id: '',
          code: '',
          name: '',
          model_spec: '',
          quantity: '',
          buy_price: '',
        }
      }, 200);
    }
    // 用户主动多选，然后保存到allSelect
    const handleSelectionChange = (select) => {
      allSelect.value = JSON.parse(JSON.stringify(select))
    }
    const getConstList = () => {
      if (!constType.value) return [];

      let arr = []
      if(form.value.operate == 1){
        arr = constType.value.filter(e => e.type == 'productIn')
      }
      if(form.value.operate == 2){
        arr = constType.value.filter(e => e.type == 'productOut')
      }
      return arr || [];
    }
    const getTitleValue = () => {
      return form.value.operate ? operateValue[form.value.operate] : ''
    }

    return() => (
      <>
        <ElCard bodyStyle={{ height: "calc(100vh - 144px )" }}>
          {{
            header: () => (
              <ElForm inline={ true } class="cardHeaderFrom">
                <ElFormItem v-permission={ 'OutsourcingOrder:add' }>
                  <ElButton style="margin-top: -5px" type="primary" onClick={ () => handleAdd(1) }>添加入库单</ElButton>
                </ElFormItem>
                <ElFormItem>
                  <ElButton style="margin-top: -5px" type="primary" onClick={ () => handleAdd(2) }>添加出库单</ElButton>
                </ElFormItem>
                <ElFormItem>
                  <ElButton style="margin-top: -5px" type="primary" onClick={ () => setStatusAllData() }> 批量提交审核 </ElButton>
                </ElFormItem>
                <ElFormItem label="仓库名称:">
                  <ElSelect v-model={ houseId.value } multiple={false} filterable remote remote-show-suffix clearable valueKey="id" placeholder="请选择仓库名称">
                    {houseList.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="出入库:">
                  <ElSelect v-model={ operateId.value } multiple={false} filterable remote remote-show-suffix clearable valueKey="id" placeholder="请选择出入库" onChange={ (row) => formOperateSelect(row) }>
                    {operate.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="出入库方式:">
                  <ElSelect v-model={ typeId.value } multiple={false} filterable remote remote-show-suffix clearable valueKey="id" placeholder="请选择出入库方式">
                    {typeSelectList.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="客户:">
                  <ElSelect v-model={ customerId.value } multiple={false} filterable remote remote-show-suffix clearable valueKey="id" placeholder="请选择客户" onChange={ (row) => formcustomerSelect(row) }>
                    {customerList.value.map((e, index) => <ElOption value={ e.id } label={ e.customer_abbreviation } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                {/* <ElFormItem label="制程:">
                  <ElSelect v-model={ cycleId.value } multiple={false} filterable remote remote-show-suffix clearable valueKey="id" placeholder="请选择制程" onChange={ (row) => formCycleSelect(row) }>
                    {cycleList.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                  </ElSelect>
                </ElFormItem> */}
                <ElFormItem label="产品名称:">
                  <ElSelect v-model={ productId.value } multiple={false} filterable remote remote-show-suffix clearable valueKey="id" placeholder="请选择产品名称">
                    {productList.value.map((e, index) => <ElOption value={ e.id } label={ e.product_name } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="审核状态:">
                  <ElSelect v-model={ statusId.value } multiple={false} filterable remote remote-show-suffix clearable valueKey="id" placeholder="请选择审核状态">
                    {statusList.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem>
                  <ElButton style="margin-top: -5px" type="primary" onClick={ () => filterQuery() }>筛选</ElButton>
                </ElFormItem>
              </ElForm>
            ),
            default: () => (
              <>
                <ElTable data={ tableData.value } border stripe style={{ width: "100%" }} onSelectionChange={ (select) => handleSelectionChange(select) }>
                  <ElTableColumn type="selection" width="55" />
                  <ElTableColumn label="审核状态" width="100">
                    {({row}) => <span>{row.status >= 0 ? statusType[row.status] : ''}</span>}
                  </ElTableColumn>
                  <ElTableColumn prop="house_name" label="仓库名称" width="100" />
                  <ElTableColumn label="出入库" width="80">
                    {({row}) => <span>{operateValue[row.operate]}</span>}
                  </ElTableColumn>
                  <ElTableColumn label="出入库方式" width="100">
                    {({row}) => <span>{constObj.value[row.type]}</span>}
                  </ElTableColumn>
                  <ElTableColumn prop="plan" label="客户/制程" width="120" />
                  <ElTableColumn prop="code" label="物料编码" width="90" />
                  <ElTableColumn prop="name" label="物料名称" width="100" />
                  <ElTableColumn prop="quantity" label="数量" />
                  <ElTableColumn prop="model_spec" label="规格型号" width="110" />
                  <ElTableColumn prop="buy_price" label="金额(元)" width="110" />
                  <ElTableColumn label="总价(元)" width="110">
                    {({row}) => <span>{ row.status ? row.total_price : PreciseMath.mul(row.buy_price, row.quantity) }</span>}
                  </ElTableColumn>
                  <ElTableColumn prop="apply_name" label="申请人" width="90" />
                  <ElTableColumn prop="apply_time" label="申请时间" width="110" />
                  <ElTableColumn prop="approve_name" label="审核人" width="90" />
                  <ElTableColumn prop="approve_time" label="审核时间" width="110" />
                  <ElTableColumn label="操作" width="150" fixed="right">
                    {({row}) => (
                      <>
                        {row.status == undefined || row.status == 2 ? <>
                          <ElButton size="small" type="default" onClick={ () => handleUplate(row) }>修改</ElButton>
                          <ElButton size="small" type="primary" onClick={ () => handleStatusData(row) }>提交</ElButton>
                        </> : ''}
                      </>
                    )}
                  </ElTableColumn>
                </ElTable>
              </>
            )
          }}
        </ElCard>
        <ElDialog v-model={ dialogVisible.value } title={ `${getTitleValue()}单` } onClose={ () => handleClose() }>
          {{
            default: () => (
              <ElForm model={ form.value } ref={ formRef } inline={ true } rules={ rules } label-width="110px">
                <ElFormItem label="仓库名称" prop="house_id">
                  <ElSelect v-model={ form.value.house_id } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择仓库名称" onChange={ (row) => houseChange(row) }>
                    {houseList.value.map((e, index) => e && (
                      <ElOption value={ e.id } label={ e.name } key={ index } />
                    ))}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label={ `${getTitleValue()}方式` } prop="type">
                  <ElSelect v-model={ form.value.type } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder={ `请选择${getTitleValue()}方式` } onChange={ (row) => typeChange(row) }>
                    {getConstList().map((e, index) => e && (
                      <ElOption value={ e.id } label={ e.name } key={ index } />
                    ))}
                  </ElSelect>
                </ElFormItem>
                {
                  form.value.type == 13 || form.value.type == 14 ? 
                  <ElFormItem label="客户" prop="plan_id">
                    <ElSelect v-model={ form.value.plan_id } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择客户" onChange={ (row) => planChange(row, 'customer_abbreviation') }>
                      {customerList.value.map((e, index) => e && (
                        <ElOption value={ e.id } label={ e.customer_abbreviation } key={ index } />
                      ))}
                    </ElSelect>
                  </ElFormItem> :
                  // form.value.type == 7 ? 
                  // <ElFormItem label="制程" prop="plan_id">
                  //   <ElSelect v-model={ form.value.plan_id } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择制程" onChange={ (row) => planChange(row, 'name') }>
                  //     {cycleList.value.map((e, index) => e && (
                  //       <ElOption value={ e.id } label={ e.name } key={ index } />
                  //     ))}
                  //   </ElSelect>
                  // </ElFormItem> :
                  <></>
                }
                <ElFormItem label="产品编码" prop="item_id">
                  <ElSelect v-model={ form.value.item_id } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择产品编码" onChange={ (row) => productChange(row) }>
                    {productList.value.map((e, index) => e && (
                      <ElOption value={ e.id } label={ e.product_code } key={ index } />
                    ))}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="数量" prop="quantity">
                  <ElInput v-model={ form.value.quantity } placeholder="请输入数量" />
                </ElFormItem>
                <ElFormItem label="金额" prop="buy_price">
                  <ElInput v-model={ form.value.buy_price } placeholder="请输入金额" />
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