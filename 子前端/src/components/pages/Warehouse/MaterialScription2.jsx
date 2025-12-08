import { defineComponent, onMounted, reactive, ref, nextTick } from 'vue'
import { getRandomString, PreciseMath, getPageHeight, isEmptyValue } from '@/utils/tool'
import { reportOperationLog } from '@/utils/log';
import { getItem } from '@/assets/js/storage';
import request from '@/utils/request';
import dayjs from "dayjs"
import "@/assets/css/print.scss"
import "@/assets/css/landscape.scss"
import HeadForm from '@/components/form/HeadForm';
import deepClone from '@/utils/deepClone';

export default defineComponent({
  setup(){
    const statusType = reactive({
      0: '待审批',
      1: '已通过',
      2: '已拒绝',
      3: '已反审',
      4: '待提交'
    })
    const operateValue = reactive({
      1: '入库',
      2: '出库'
    })
    const statusList = ref([{ id: 0, name: '待审批' }, { id: 1, name: '已通过' }, { id: 2, name: '已拒绝' }, { id: 3, name: '已反审' }, { id: 4, name: '待提交' }])
    const operate = reactive([{ id: 1, name: '入库' }, { id: 2, name: '出库' }])
    const user = getItem('user')
    const approval = getItem('approval').filter(e => e.type == 'material_warehouse')
    // 找到当前这个用户在这个页面中是否有审批权限
    const approvalUser = approval.find(e => e.user_id == user.id)
    const nowDate = ref()
    const formHeight = ref(0);
    const formCard = ref(null)
    const formRef = ref(null)
    const calcUnit = ref(getItem('constant').filter(o => o.type == 'calcUnit'))
    const rules = ref({})
    let form = ref({
      ware_id: 1,
      house_id: '',
      house_name: '',
      operate: '',  // 入库 or 出库
      type: '', // 常量类型
      material_bom_id: '', // 材料BOM
      plan_id: '', // 供应商id or 制程id
      plan: '', // 供应商 or 制程
      procure_id: '', // 采购单号的ID
      notice_id: '',
      item_id: '',
      code: '',
      name: '',
      model_spec: '',
      other_features: '',
      quantity: '',
      pay_quantity: '',
      buy_price: '',
      price: '',
      unit: '',
      inv_unit: ''
    })
    let dialogVisible = ref(false)
    let constObj = ref({})
    let constType = ref([]) // 常量列表
    let houseList = ref([]) // 仓库名称列表
    let supplierList = ref([]) // 供应商列表
    let cycleList = ref([]) // 制程列表
    let materialList = ref([]) // 材料编码
    let materialBuy = ref([]) // 采购单列表
    let outBuy = ref([]) // 委外单列表
    let materialBomList = ref([]) // 获取材料BOM列表2
    let noticeList = ref([])
    let tableData = ref([])
    let allSelect = ref([])
    let edit = ref('')
    // 筛选使用
    let typeSelectList = ref([])
    let houseId = ref('')
    let operateId = ref('')
    let typeId = ref('')
    let supplierId = ref('')
    let cycleId = ref('')
    let materialId = ref('')
    let statusId = ref('')
    let dateTime = ref([])

    onMounted(async () => {
      nowDate.value = dayjs().format('YYYY-MM-DD HH:mm:ss')

      const currentDate = dayjs();
      const firstDay = currentDate.startOf('month').format('YYYY-MM-DD HH:mm:ss');
      const lastDay = currentDate.endOf('month').format('YYYY-MM-DD HH:mm:ss');
      dateTime.value = [firstDay, lastDay]

      nextTick(async () => {
        formHeight.value = await getPageHeight([formCard.value]);
      })

      await filterQuery()
      setTimeout(() => {
        getConstType()
        getSupplierInfo() // 获取供应商
        getProcessCycle() // 获取制程
        getMaterialCode() // 获取材料编码
        getHouseList() // 获取仓库名称
        getMaterialOrderList() // 获取采购单列表
        getProductNotice() //获取生产通知单
        getOutList() // 委外加工单
        getMaterialBom2() //获取材料BOM列表2
      }, 500);

    })

    const filterQuery = async () => {
      const res = await request.post('/api/warehouse_apply', {
        ware_id: 1,
        house_id: houseId.value,
        operate: operateId.value,
        type: typeId.value ? typeId.value : constType.value.filter(e => e.type == 'materialIn' || e.type == 'materialOut').map(o => o.id),
        plan_id: supplierId.value ? supplierId.value : cycleId.value,
        item_id: materialId.value,
        status: statusId.value,
        source_type: 'material_warehouse',
        apply_time: dateTime.value
      })
      tableData.value = res.data
    }
    // 获取采购单列表
    const getMaterialOrderList = async () => {
      const res = await request.get('/api/getMaterialOrderList')
      if(res.code == 200){
        materialBuy.value = res.data
      }
    }
    // 获取常量
    const getConstType = async () => {
      const res = await request.post('/api/get_warehouse_type', { type: ['materialIn', 'materialOut', 'house'] })
      constType.value = res.data.filter(item => item.name !== '生产领料')

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
    // 获取供应商
    const getSupplierInfo = async () => {
      const res = await request.get('/api/getSupplierInfo')
      supplierList.value = res.data
    }
    // 获取制程
    const getProcessCycle = async () => {
      const res = await request.get('/api/getProcessCycle')
      cycleList.value = res.data
    }
    // 获取材料编码
    const getMaterialCode = async () => {
      const res = await request.get('/api/getMaterialCode')
      materialList.value = res.data
    }
    // 获取仓库名称
    const getHouseList = async () => {
      const res = await request.get('/api/warehouse_cycle', { params: { ware_id: 1 } })
      houseList.value = res.data
      form.value.house_id = res.data[0].id
      form.value.house_name = res.data[0].name
    }
    // 获取生产通知单
    const getProductNotice = async () => {
      const res = await request.get('/api/getProductNotice')
      noticeList.value = res.data
    }
    // 获取委外加工单列表
    const getOutList = async () => {
      const res = await request.get('/api/getOutList')
      if(res.code == 200){
        outBuy.value = res.data
      }
    }
    // 获取材料BOM列表2.0
    const getMaterialBom2 = async (product_id) => {
      const res = await request.get('/api/getMaterialBom2', { params: { product_id } })
      if(res.code == 200){
        materialBomList.value = res.data
      }
    }
    // 反审批
    const handleBackApproval = async (row) => {
      ElMessageBox.confirm('是否确认反审批？', '提示', {
        confirmButtonText: '确认',
        cancelButtonText: '取消',
        cancelButtonClass: 'el-button--warning',
        type: 'warning',
        distinguishCancelAndClose: true,
      }).then(async () => {
        const res = await request.post('/api/approval_backFlow', { id: row.id })
        if(res.code == 200){
          ElMessage.success('反审批成功')
          filterQuery()

          const str = `{ 仓库：${row.house_name}，${operateValue[row.operate]}方式：${constObj.value[row.type]}，物料编码：${row.code} }`
          reportOperationLog({
            operationType: 'backApproval',
            module: '材料出入库',
            desc: `反审批了出/入库单：${str}`,
            data: { newData: row.id }
          })
        }
      }).catch(() => {})
    }
    // 处理审批
    const approvalApi = async (action, data) => {
      const res = await request.post('/api/handleApproval', {
        data,
        action,
        source_type: 'material_warehouse',
        ware_id: form.value.ware_id
      })
      if(res.code == 200){
        ElMessage.success('审批成功')
        filterQuery()

        const appValue = action == 1 ? '通过' : '拒绝'
        reportOperationLog({
          operationType: 'approval',
          module: '材料出入库',
          desc: `审批${appValue}了出/入库单，它们有：${data}`,
          data: { newData: { data, action, ware_id: form.value.ware_id } }
        })
      }
    }
    const handleApproval = async (row) => {
      if([2,3,4].includes(row.status)) return ElMessage.error('该作业未提交审批，无法审批')
      if(row.status == 1) return ElMessage.error('该作业已经审批通过')
      handleApprovalDialog([row.id])
    }
    // 批量处理审批
    const setApprovalAllData = () => {
      if(!allSelect.value.length) return ElMessage.error('请选择要审批的数据')
      const all = allSelect.value.filter(o => o.status == 0)
      if(!all.length) return ElMessage.error('暂无可审批的数据，请检查')
      
      const ids = all.map(o => o.id) 
      handleApprovalDialog(ids)
    }
    const handleApprovalDialog = (data) => {
      ElMessageBox.confirm('是否确认审批？', '提示', {
        confirmButtonText: '通过',
        cancelButtonText: '否绝',
        cancelButtonClass: 'el-button--warning',
        type: 'warning',
        distinguishCancelAndClose: true,
      }).then(() => {
        approvalApi(1, data)
      }).catch((action) => {
        if(action === 'cancel'){
          approvalApi(2, data)
        }
      })
    }
    const setApiData = async (data) => {
      const res = await request.post('/api/add_wareHouse_order', { data, type: 'material_warehouse' })
      if(res && res.code == 200){
        ElMessage.success('提交成功');
        filterQuery();

        reportOperationLog({
          operationType: 'keyApproval',
          module: '材料出入库',
          desc: `出/入库单提交审核：${data}`,
          data: { newData: { data, type: 'material_warehouse' } }
        })
      }
    }
    const handleStatusData = async (row) => {
      handleWareHouseDialog([row.id])
    }
    // 批量提交审批
    const setStatusAllData = async () => {
      if(!allSelect.value.length) return ElMessage.error('请选择要提交的数据')
      const all = allSelect.value.filter(o => [2, 3, 4].includes(o.status))
      if(!all.length) return ElMessage.error('暂无可提交的数据')

      const ids = all.map(o => o.id)
      handleWareHouseDialog(ids)
    }
    const handleWareHouseDialog = (data) => {
      ElMessageBox.confirm('是否确认提交？审批期间不可修改。', '提示', {
        confirmButtonText: '提交',
        cancelButtonText: '取消',
        cancelButtonClass: 'el-button--warning',
        type: 'warning',
      }).then(() => {
        setApiData(data)
      }).catch(() => {})
    }
    const handleSubmit = async (formEl) => {
      if (!formEl) return
      await formEl.validate(async (valid, fields) => {
        if (valid){
          if(!edit.value){
            const res = await request.post('/api/add_ware_data', form.value)
            if(res.code == 200){
              dialogVisible.value = false;
              ElMessage.success('新增成功')
              filterQuery();
            }
          }else{
            if(form.value.approval){
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
      // if(row.procure_id){ // 用于采购入库的
      //   buyChange(row.procure_id)
      // }
    }
    const handleAdd = (value) => {
      edit.value = 0
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
      // 只有指定入库类型才需要生产通知单
      if([5, 6, 9].includes(value)){
        form.value.notice_id = null
      }
      // 如果非采购入库，清空采购入库
      if(value != 4){
        form.value.procure_id = ''
      }
    }
    // 获取出入库单列表
    const buyChange = async (id) => {
      const res = await request.get('/api/getMaterialOrderList', { params: { id } })
      const data = res.data
      planChange(data[0].supplier_id, 'supplier_abbreviation')
      getMaterialList(data[0].order)
      form.value.plan_id = data[0].supplier_id
    }
    // 选择采购单后，获取材料数据
    const getMaterialList = async (order) => {
      const arr = deepClone(order)
      const list = arr.map(e => ({...e, id: e.material_id}))
      materialList.value = list
      const material = list.filter(o => o.is_houser == 1)[0]
      form.value.item_id = material.id
      form.value.quantity = material.number
      form.value.buy_price = material.price
      form.value.code = material.material_code
      form.value.name = material.material_name
      form.value.other_features = material.other_features
      form.value.unit = Number(material.unit)
      form.value.inv_unit = Number(material.usage_unit)
      if(Number(material.unit) == Number(material.usage_unit)){
        form.value.pay_quantity = material.number
      }
      getWareHouseMaterialUnit(material.material_id, 'cg')
      getWareHouseMaterialPrice(material.material_id, 'cg')
    }
    // 出入库单确认接口调用
    const handlePurchaseIsBuying = async (ids) => {
      if(!ids.length) return ElMessage.error('请选择委外作业')
      const res = await request.post('/api/handleMaterialIsBuying', { ids })
      if(res.code == 200){
        ElMessage.success('委外加工单确认成功')
        filterQuery();
      }
    }
    // 批量出入库单确认
    const handleProcurementAll = () => {
      if(!allSelect.value.length) return ElMessage.error('请选择要确认的数据')
      const all = allSelect.value.filter(o => o.status == 1 && o.is_buying == 1 && o.apply_id == user.id)
      if(!all.length) return ElMessage.error('暂无可确认的数据，请检查')
      function isAllTypesSame(array) {
        const firstType = array[0].operate;
        return array.every(item => item.operate === firstType);
      }
      if(!isAllTypesSame(all)) return ElMessage.error('请将出/入库单分开确认')

      const ids = all.map(e => e.id)

      ElMessageBox.confirm('是否确认出入库单？', '提示', {
        confirmButtonText: '确认',
        cancelButtonText: '取消',
        cancelButtonClass: 'el-button--warning',
        type: 'warning',
        distinguishCancelAndClose: true,
      }).then(() => {
        handlePurchaseIsBuying(ids)
      }).catch((action) => {
        
      })
    }
    // 单个出入库单确认
    const handleProcurement = (row) => {
      if(row.status != 1) return ElMessage.error('该作业未审批通过，不能确认出入库单')
      if(row.is_buying != 1) return ElMessage.error('不能重复生成出入库')
      const ids = [row.id]
    
      ElMessageBox.confirm('是否确认出入库单？', '提示', {
        confirmButtonText: '确认',
        cancelButtonText: '取消',
        cancelButtonClass: 'el-button--warning',
        type: 'warning',
        distinguishCancelAndClose: true,
      }).then(() => {
        handlePurchaseIsBuying(ids)
      }).catch((action) => {
        
      })
    }
    const planChange = (value, label) => {
      const list = label == 'name' ? cycleList.value : supplierList.value
      const obj = list.find(e => e.id == value)
      form.value.plan = obj[label]
    }
    const materialChange = (value) => {
      const obj = materialList.value.find(e => e.id == value)
      if(form.value.procure_id){
        form.value.quantity = obj.number
        form.value.buy_price = obj.price
        return
      }
      form.value.code = obj.material_code
      form.value.name = obj.material_name
      form.value.model_spec = obj.model
      form.value.other_features = obj.other_features
      // 从仓库中将价格带出来
      const type = form.value.type
      if(type != 4){
        getWareHouseMaterialPrice(value)
      }
      if(!form.value.procure_id){
        getWareHouseMaterialUnit(value)
      }
    }
    // cg的意思是，假如选择了采购单后，cg就会有值，有值的情况下，不需要将unit传进去
    const getWareHouseMaterialPrice = async (id, cg) => {
      const res = await request.get('/api/getWareHouseMaterialPrice', { params: { id } })
      if(res.code == 200){
        if(form.value.type != 4){
          form.value.buy_price = res.data?.buy_price ? Number(res.data.buy_price) : ''
        }
        form.value.price = form.value.price ? form.value.price : res.data?.price ? Number(res.data.price) : ''
      }
    }
    // cg的意思是，假如选择了采购单后，cg就会有值，有值的情况下，不需要将unit传进去
    const getWareHouseMaterialUnit = async (id, cg) => {
      const res = await request.get('/api/getWareHouseMaterialUnit', { params: { id } })
      if(res.code == 200){
        if(form.value.type != 4){
          form.value.unit = res.data?.unit ? Number(res.data.unit) : ''
        }
        form.value.inv_unit = form.value.inv_unit ? form.value.inv_unit : res.data?.inv_unit ? Number(res.data.inv_unit) : ''
      }
    }
    const handleDelete = (row, index) => {
      tableData.value.splice(index, 1)
    }
    const formOperateSelect = async (value) => {
      typeId.value = '' // 重新选择出入库后，重置出入库方式
      const typeValue = value == 1 ? 'materialIn' : 'materialOut'
      const res = await request.post('/api/getConstType', { type: typeValue })
      typeSelectList.value = res.data
    }
    const formSupplierSelect = (value) => {
      cycleId.value = ''
    }
    const formCycleSelect = (value) => {
      supplierId.value = ''
    }
    const handleClose = () => {
      dialogVisible.value = false
      getMaterialCode()
      reset()
    }
    const reset = () => {
      setTimeout(() => {
        form.value = {
          ware_id: 1,
          house_id: houseList.value[0].id,
          house_name: houseList.value[0].name,
          operate: '',
          type: '',
          plan_id: '',
          plan: '',
          procure_id: '',
          notice_id: '',
          item_id: '',
          code: '',
          name: '',
          model_spec: '',
          other_features: '',
          quantity: '',
          pay_quantity: '',
          buy_price: '',
          price: ''
        }
      }, 200);
    }
    // 用户主动多选，然后保存到allSelect
    const handleSelectionChange = (select) => {
      allSelect.value = JSON.parse(JSON.stringify(select))
    }
    const dateChange = (value) => {
      const startTime = `${value[0]} 00:00:00`
      const endTime = `${value[1]} 23:59:59`
      dateTime.value = [startTime, endTime]
    }
    const getConstList = () => {
      if (!constType.value) return [];

      let arr = []
      if(form.value.operate == 1){
        arr = constType.value.filter(e => e.type == 'materialIn')
      }
      if(form.value.operate == 2){
        arr = constType.value.filter(e => e.type == 'materialOut')
      }
      return arr || [];
    }
    const getTitleValue = () => {
      return form.value.operate ? operateValue[form.value.operate] : ''
    }
    const getTotalNumber = (value) => {
      return (allSelect.value.length ? allSelect.value : tableData.value).reduce((sum, item) => {
        return PreciseMath.add(sum, (Number(item[value]) || 0))
      }, 0)
    }
    // 待审批/已拒绝时，文字变成红色
    const handleRowStyle = ({ row }) => {
      // 查询当前用户是否有审批权限
      const isApproval = !!approvalUser && !!row.approval;
      // 获取当前这条数据中，当前用户的审批步骤
      const rowApproval = row.approval?.find(o => o.user_id == approvalUser?.user_id)
      if(isApproval){
        if(row.status == 0 && row.step + 1 == rowApproval.step && rowApproval.status == 0){
          return { color: 'red' }
        }
      }else{
        if(row.status == 0 || row.status == 2 || row.status == 3){
          return { color: 'red' }
        }
      }
    }

    return() => (
      <>
        <ElCard style={{ height: '100%' }}>
          {{
            header: () => (
              <HeadForm headerWidth="270px" ref={ formCard }>
                {{
                  left: () => (
                    <>
                      <ElFormItem v-permission={ 'MaterialHouseScription:addIn' }>
                        <ElButton type="primary" onClick={ () => handleAdd(1) } style={{ width: '100px' }}>新增入库单</ElButton>
                      </ElFormItem>
                      <ElFormItem v-permission={ 'MaterialHouseScription:addOut' }>
                        <ElButton type="primary" onClick={ () => handleAdd(2) } style={{ width: '100px' }}>新增出库单</ElButton>
                      </ElFormItem>
                      <ElFormItem v-permission={ 'MaterialHouseScription:set' }>
                        <ElButton type="primary" onClick={ () => setStatusAllData() } style={{ width: '100px' }}> 批量提交 </ElButton>
                      </ElFormItem>
                      {
                        !isEmptyValue(approvalUser) ? 
                        <ElFormItem>
                          <ElButton type="primary" onClick={ () => setApprovalAllData() } style={{ width: '100px' }}> 批量审批 </ElButton>
                        </ElFormItem> : 
                        <></>
                      }
                      <ElFormItem v-permission={ 'MaterialHouseScription:buy' }>
                        <ElButton type="primary" onClick={ () => handleProcurementAll() } style={{ width: '100px' }}> 批量确认 </ElButton>
                      </ElFormItem>
                    </>
                  ),
                  center: () => (
                    <>
                      <ElFormItem label="仓库名称:">
                        <ElSelect v-model={ houseId.value } multiple={false} filterable remote remote-show-suffix clearable valueKey="id" placeholder="请选择仓库名称" style={{ width: '160px' }}>
                          {houseList.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                        </ElSelect>
                      </ElFormItem>
                      <ElFormItem label="出入库:">
                        <ElSelect v-model={ operateId.value } multiple={false} filterable remote remote-show-suffix clearable valueKey="id" placeholder="请选择出入库" onChange={ (row) => formOperateSelect(row) } style={{ width: '160px' }}>
                          {operate.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                        </ElSelect>
                      </ElFormItem>
                      <ElFormItem label="出入库方式:">
                        <ElSelect v-model={ typeId.value } multiple={false} filterable remote remote-show-suffix clearable valueKey="id" placeholder="请选择出入库方式" style={{ width: '160px' }}>
                          {typeSelectList.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                        </ElSelect>
                      </ElFormItem>
                      <ElFormItem label="供应商:">
                        <ElSelect v-model={ supplierId.value } multiple={false} filterable remote remote-show-suffix clearable valueKey="id" placeholder="请选择供应商" onChange={ (row) => formSupplierSelect(row) } style={{ width: '160px' }}>
                          {supplierList.value.map((e, index) => <ElOption value={ e.id } label={ e.supplier_abbreviation } key={ index } />)}
                        </ElSelect>
                      </ElFormItem>
                      <ElFormItem label="制程:">
                        <ElSelect v-model={ cycleId.value } multiple={false} filterable remote remote-show-suffix clearable valueKey="id" placeholder="请选择制程" onChange={ (row) => formCycleSelect(row) } style={{ width: '160px' }}>
                          {cycleList.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                        </ElSelect>
                      </ElFormItem>
                      <ElFormItem label="材料名称:">
                        <ElSelect v-model={ materialId.value } multiple={false} filterable remote remote-show-suffix clearable valueKey="id" placeholder="请选择材料名称" style={{ width: '160px' }}>
                          {materialList.value.map((e, index) => <ElOption value={ e.id } label={ e.material_name } key={ index } />)}
                        </ElSelect>
                      </ElFormItem>
                      <ElFormItem label="审批状态:">
                        <ElSelect v-model={ statusId.value } multiple={false} filterable remote remote-show-suffix clearable valueKey="id" placeholder="请选择审批状态" style={{ width: '160px' }}>
                          {statusList.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                        </ElSelect>
                      </ElFormItem>
                      <ElFormItem label="周期:">
                        <ElDatePicker v-model={ dateTime.value } type="daterange" clearable={ false } range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期" value-format="YYYY-MM-DD" onChange={ (row) => dateChange(row) } />
                      </ElFormItem>
                    </>
                  ),
                  right: () => (
                    <ElFormItem>
                      <ElButton type="primary" onClick={ () => filterQuery() }>查询</ElButton>
                    </ElFormItem>
                  )
                }}
              </HeadForm>
            ),
            default: () => (
              <>
                <ElTable data={ tableData.value } border stripe height={ `calc(100vh - ${formHeight.value + 220}px)` } style={{ width: "100%" }} rowStyle={ handleRowStyle } onSelectionChange={ (select) => handleSelectionChange(select) }>
                  <ElTableColumn type="selection" width="55" fixed="left" />
                  <ElTableColumn label="审批状态" width="100">
                    {({row}) => {
                      if(!isEmptyValue(row)){
                        if(row.status == 1) return <span>{ statusType[row.status] }</span>
                        
                        // 判断当前用户是否有权限和审批记录，否则直接返回默认状态文案
                        const hasApprovalPerm = !!approvalUser && !!row.approval
                        if(hasApprovalPerm){
                          // 如果有权限，获取当前这条数据中，该用户的审批步骤
                          const rowApproval = row.approval?.find(o => o.user_id == approvalUser.user_id)
                          // 存在该用户的审批记录，且当前步骤>=审批步骤 = 已审批
                          if(rowApproval && row.step >= rowApproval.step){
                            return <span>已审批</span>
                          }
                        }
                        return <span>{statusType[row.status]}</span>;
                      }
                    }}
                  </ElTableColumn>
                  <ElTableColumn prop="notice.notice" label="生产通知单" width="100" />
                  <ElTableColumn prop="house_name" label="仓库名称" width="100" />
                  <ElTableColumn label="出入库" width="80">
                    {({row}) => <span>{operateValue[row.operate]}</span>}
                  </ElTableColumn>
                  <ElTableColumn label="出入库方式" width="100">
                    {({row}) => <span>{constObj.value[row.type]}</span>}
                  </ElTableColumn>
                  <ElTableColumn prop="plan" label="供应商/制程" width="120" />
                  <ElTableColumn prop="code" label="材料编码" width="90" />
                  <ElTableColumn prop="name" label="材料名称" width="100" />
                  <ElTableColumn prop="quantity" label="数量">
                    {({row}) => <span>{ row.quantity ? row.quantity : 0 }</span>}
                  </ElTableColumn>
                  <ElTableColumn prop="model_spec" label="型号&规格" width="110" />
                  <ElTableColumn prop="other_features" label="其他特性" width="110" />
                  <ElTableColumn label="采购单价(元)" width="110">
                    {({row}) => <span>{ row.buy_price ? row.buy_price : 0 }</span>}
                  </ElTableColumn>
                  <ElTableColumn label="内部单价(元)" width="110">
                    {({row}) => <span>{ row.price ? row.price : 0 }</span>}
                  </ElTableColumn>
                  <ElTableColumn label="使用单位" width="90">
                    {({row}) => <span>{ calcUnit.value.find(e => e.id == row.inv_unit)?.name }</span>}
                  </ElTableColumn>
                  <ElTableColumn label="交易单位" width="90">
                    {({row}) => <span>{ calcUnit.value.find(e => e.id == row.unit)?.name }</span>}
                  </ElTableColumn>
                  <ElTableColumn label="总价(元)" width="110">
                    {({row}) => {
                      if(!isEmptyValue(row)){
                        return <span>{ row.approval ? row.total_price : row.buy_price ? PreciseMath.mul(row.buy_price, row.quantity) : '' }</span>
                      }
                    }}
                  </ElTableColumn>
                  <ElTableColumn prop="apply_name" label="申请人" width="90" />
                  <ElTableColumn prop="apply_time" label="申请时间" width="110" />
                  <ElTableColumn label="操作" width="210" fixed="right">
                    {{
                      default: (scope, $index) => {
                        const row = scope.row
                        if(!isEmptyValue(row)){
                          let dom = []
                          // 查询当前用户是否有审批权限
                          const isApproval = !!approvalUser && !!row.approval;
                          // 如果当前用户有审批权限，获取当前这条数据中，该用户的审批步骤
                          const rowApproval = isApproval ? row.approval.find(o => o.user_id === approvalUser.user_id) : null;
                          // 查询这条数据相对当前用户来说，状态是否可以修改
                          const { apply_id, is_buying, status } = row;
                          const isUserApplied = apply_id === user.id && is_buying === 1;
                          const isStatusValid = status === 2 || status === 3 || status == 4;
                          const isRowStatus = status === undefined || (isUserApplied && isStatusValid);

                          if(isRowStatus){
                            dom.push(
                              <>
                                <ElButton size="small" type="warning" v-permission={ 'MaterialHouseScription:edit' } onClick={ () => handleUplate(row) }>修改</ElButton>
                                <ElButton size="small" type="primary" v-permission={ 'MaterialHouseScription:set' } onClick={ () => handleStatusData(row) }>提交</ElButton>
                              </>
                            )
                          }

                          if(isApproval && row.is_buying === 1){
                            if(rowApproval && row.status === 0 && row.step + 1 === rowApproval.step && rowApproval.status == 0){
                              dom.push(<ElButton size="small" type="primary" onClick={() => handleApproval(row)}>审批</ElButton>)
                            }
                            if(rowApproval && row.status === 1 || (row.status === 0 && rowApproval.status === 1)){
                              dom.push(<ElButton size="small" type="primary" onClick={() => handleBackApproval(row)}>反审批</ElButton>)
                            }
                            if(rowApproval && row.status == 0 && rowApproval.status == 0 && row.step + 1 !== rowApproval.step){
                              dom.push(<ElButton size="small" type="primary" disabled>待审批</ElButton>)
                            }
                            if(rowApproval && row.status == 0 && rowApproval.status == 1 && row.step + 1 !== rowApproval.step){
                              dom.push(<ElButton size="small" type="primary" disabled>已审批</ElButton>)
                            }
                          }
                          if(row.status == undefined){
                            dom.push(<ElButton size="small" type="danger" onClick={ () => handleDelete(row, $index) }>删除</ElButton>)
                          }
                          if(row.status == 1 && row.is_buying == 1 && row.apply_id == user.id){
                            dom.push(<ElButton size="small" type="primary"  v-permission={ 'MaterialHouseScription:buy' } onClick={ () => handleProcurement(row) }>出入库单确认</ElButton>)
                          }
                          return dom
                        }
                      }
                    }}
                  </ElTableColumn>
                </ElTable>
              </>
            )
          }}
        </ElCard>
        <ElDialog v-model={ dialogVisible.value } title={ `材料${getTitleValue()}单` } width='785' center draggable onClose={ () => handleClose() }>
          {{
            default: () => (
              <ElForm class="ml20" model={ form.value } ref={ formRef } inline={ true } rules={ rules } label-width="95">
                <ElFormItem label="仓库名称" prop="house_id">
                  <ElSelect disabled={ edit.value } v-model={ form.value.house_id } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择仓库名称" onChange={ (row) => houseChange(row) }>
                    {houseList.value.map((e, index) => e && (
                      <ElOption value={ e.id } label={ e.name } key={ index } />
                    ))}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label={ `${getTitleValue()}方式` } prop="type">
                  <ElSelect disabled={ edit.value } v-model={ form.value.type } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder={ `请选择${getTitleValue()}方式` } onChange={ (row) => typeChange(row) }>
                    {getConstList().map((e, index) => e && (
                      <ElOption value={ e.id } label={ e.name } key={ index } />
                    ))}
                  </ElSelect>
                </ElFormItem>
                {
                  form.value.type == 4 ? 
                  <ElFormItem label="采购单" prop="procure_id">
                    <ElSelect v-model={ form.value.procure_id } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择采购单号" onChange={ (row) => buyChange(row) }>
                      {materialBuy.value.map((o, index) => <ElOption value={ o.id } label={ o.no } key={ index } />)}
                    </ElSelect>
                  </ElFormItem> : ''
                }
                {
                  [4,8,17,18].includes(Number(form.value.type)) ?
                  <ElFormItem label="生产通知单" prop="notice_id">
                    <ElSelect disabled={ edit.value } v-model={ form.value.notice_id } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择生产通知单">
                      {noticeList.value.map((o, index) => <ElOption value={ o.id } label={ o.notice } key={ index } />)}
                    </ElSelect>
                  </ElFormItem> : ''
                }
                {
                  form.value.type == 8 ? 
                  <ElFormItem label="委外加工单" prop="procure_id">
                    <ElSelect v-model={ form.value.procure_id } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择委外加工单" onChange={ (row) => outChange(row) }>
                      {outBuy.value.map((o, index) => <ElOption value={ o.id } label={ o.no } key={ index } />)}
                    </ElSelect>
                  </ElFormItem> : ''
                }
                {
                  [4, 8].includes(Number(form.value.type)) ? 
                  <ElFormItem label="供应商" prop="plan_id">
                    <ElSelect v-model={ form.value.plan_id } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择供应商" onChange={ (row) => planChange(row, 'supplier_abbreviation') }>
                      {supplierList.value.map((e, index) => e && (
                        <ElOption value={ e.id } label={ e.supplier_abbreviation } key={ index } />
                      ))}
                    </ElSelect>
                  </ElFormItem> :
                  [17, 18].includes(Number(form.value.type)) ? 
                  <ElFormItem label="制程" prop="plan_id">
                    <ElSelect v-model={ form.value.plan_id } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择制程" onChange={ (row) => planChange(row, 'name') }>
                      {cycleList.value.map((e, index) => e && (
                        <ElOption value={ e.id } label={ e.name } key={ index } />
                      ))}
                    </ElSelect>
                  </ElFormItem> :
                  <></>
                }
                {
                  form.value.type == 18 ? 
                  <ElFormItem label="材料BOM" prop="material_bom_id">
                    <ElSelect v-model={ form.value.material_bom_id } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择材料BOM">
                      {materialBomList.value.map((e, index) => e && (
                        <ElOption value={ e.id } label={ e.name } key={ index } />
                      ))}
                    </ElSelect>
                  </ElFormItem> :
                  <>
                    <ElFormItem label="材料编码" prop="item_id">
                      <ElSelect v-model={ form.value.item_id } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择材料编码" onChange={ (row) => materialChange(row) }>
                        {materialList.value.map((e, index) => e && (
                          <ElOption value={ e.id } label={ e.material_code } disabled={ form.value.procure_id ? !e.is_houser : false } key={ index } />
                        ))}
                      </ElSelect>
                    </ElFormItem>
                    <ElFormItem label="材料名称">
                      <ElSelect class="disabled" v-model={ form.value.item_id } multiple={false} disabled filterable remote remote-show-suffix valueKey="id" placeholder="请选择材料名称">
                        {materialList.value.map((e, index) => e && (
                          <ElOption value={ e.id } label={ e.material_name } key={ index } />
                        ))}
                      </ElSelect>
                    </ElFormItem>
                    {
                      form.value.type != 4 ? <ElFormItem label="数量" prop="quantity">
                        <ElInput v-model={ form.value.quantity } placeholder="请输入数量" />
                      </ElFormItem> : ''
                    }
                    {
                      form.value.type == 4 ? <ElFormItem label="采购单价" prop="buy_price">
                        <ElInput v-model={ form.value.buy_price } type="number" placeholder="请输入采购单价" />
                      </ElFormItem> : ''
                    }
                    <ElFormItem label="内部单价" prop="price">
                      <ElInput v-model={ form.value.price } type="number" placeholder="请输入内部单价" />
                    </ElFormItem>
                    {
                      form.value.type != 4 ? <ElFormItem label="使用单位" prop="inv_unit">
                      <ElSelect v-model={ form.value.inv_unit } multiple={ false } filterable remote remote-show-suffix placeholder="请选择使用单位">
                        {calcUnit.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                      </ElSelect>
                    </ElFormItem> : ''
                    }
                    {
                      form.value.type == 4 ? <div>
                        <ElFormItem label="交易单位">
                          <ElSelect v-model={ form.value.unit } multiple={ false } filterable remote remote-show-suffix placeholder='请选择交易单位'>
                            {calcUnit.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                          </ElSelect>
                        </ElFormItem>
                        <ElFormItem label="交易数量">
                          <ElInput v-model={ form.value.pay_quantity } placeholder="请输入交易数量" />
                        </ElFormItem>
                        <ElFormItem label="使用单位">
                          <ElSelect v-model={ form.value.inv_unit } multiple={ false } filterable remote remote-show-suffix placeholder="请选择使用单位">
                            {calcUnit.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                          </ElSelect>
                        </ElFormItem>
                        <ElFormItem label="入库数量">
                          <ElInput v-model={ form.value.quantity } placeholder="请输入入库数量" />
                        </ElFormItem>
                      </div> : ''
                    }
                  </>
                }
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