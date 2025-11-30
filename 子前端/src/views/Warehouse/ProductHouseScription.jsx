import { defineComponent, onMounted, reactive, ref, nextTick, computed } from 'vue'
import { useStore } from '@/stores';
import { getRandomString, PreciseMath, numberToChinese, getPageHeight, isEmptyValue } from '@/utils/tool'
import { reportOperationLog } from '@/utils/log';
import { getItem } from '@/assets/js/storage';
import request from '@/utils/request';
import dayjs from "dayjs"
import "@/assets/css/print.scss"
import "@/assets/css/landscape.scss"
import HeadForm from '@/components/form/HeadForm';

export default defineComponent({
  setup(){
    const store = useStore()
    const statusType = reactive({
      0: '待审批',
      1: '已通过',
      2: '已拒绝',
      3: '已反审'
    })
    const operateValue = reactive({
      1: '入库',
      2: '出库'
    })
    const statusList = ref([{ id: 0, name: '待审批' }, { id: 1, name: '已通过' }, { id: 2, name: '已拒绝' }, { id: 3, name: '已反审' }])
    const operate = reactive([{ id: 1, name: '入库' }, { id: 2, name: '出库' }])
    const user = getItem('user')
    const approval = getItem('approval').filter(e => e.type == 'product_warehouse')
    // 找到当前这个用户在这个页面中是否有审批权限
    const approvalUser = approval.find(e => e.user_id == user.id)
    const nowDate = ref()
    const formHeight = ref(0);
    const formCard = ref(null)
    const formRef = ref(null)
    const calcUnit = ref(getItem('constant').filter(o => o.type == 'calcUnit'))
    const rules = ref({})
    let form = ref({
      ware_id: 3,
      house_id: '',
      house_name: '',
      operate: '',  // 入库 or 出库
      type: '', // 常量类型
      plan_id: '', // 客户id or 制程id
      plan: '', // 客户 or 制程
      notice_id: '',
      sale_id: '',
      item_id: '',
      code: '',
      name: '',
      model_spec: '',
      other_features: '',
      quantity: '',
      buy_price: '',
      price: '',
      unit: '',
      inv_unit: ''
    })
    let dialogVisible = ref(false)
    let constObj = ref({})
    let constType = ref([]) // 常量列表
    let houseList = ref([]) // 仓库名称列表
    let customerList = ref([]) // 供应商列表
    let cycleList = ref([]) // 制程列表
    let productList = ref([]) // 材料编码
    let noticeList = ref([])
    let saleList = ref([])
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
    let dateTime = ref([])
    // 用来打印用的
    let printers = ref([]) //打印机列表
    let printDataIds = ref([]) // 需要打印的数据的id
    let printVisible = ref(false)
    let setPdfBlobUrl = ref('')

    const printNo = computed(() => store.printNo)

    onMounted(async () => {
      nowDate.value = dayjs().format('YYYY-MM-DD HH:mm:ss')
      // 获取最近一年的日期
      const today = dayjs()
      const lastYearStart = today.subtract(1, 'year').startOf('day').format('YYYY-MM-DD HH:mm:ss')
      const lastYearEnd = today.endOf('day').format('YYYY-MM-DD HH:mm:ss')
      dateTime.value = [lastYearStart, lastYearEnd]

      nextTick(async () => {
        formHeight.value = await getPageHeight([formCard.value]);
      })

      await getConstType()
      await getCustomerInfo() // 获取客户
      await getProcessCycle() // 获取制程
      await getProductsCode() // 获取产品编码
      await getHouseList() // 获取仓库名称
      await filterQuery()
      await getSaleOrder()
      await getProductNotice() //获取生产通知单

      getPrinters()
    })

    const getPrinters = async () => {
      const res = await request.get('/api/printers')
      printers.value = res.data
    }
    const filterQuery = async () => {
      const res = await request.post('/api/warehouse_apply', {
        ware_id: 3,
        house_id: houseId.value,
        operate: operateId.value,
        type: typeId.value ? typeId.value : constType.value.filter(e => e.type == 'productIn' || e.type == 'productOut').map(o => o.id),
        plan_id: customerId.value ? customerId.value : cycleId.value,
        item_id: productId.value,
        status: statusId.value,
        source_type: 'product_warehouse',
        apply_time: dateTime.value
      })
      tableData.value = res.data
    }
    // 获取常量
    const getConstType = async () => {
      const res = await request.post('/api/get_warehouse_type', { type: ['productIn', 'productOut', 'house'] })
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
      const res = await request.get('/api/warehouse_cycle', { params: { ware_id: 3 } })
      houseList.value = res.data
      if(res.data.length){
        form.value.house_id = res.data[0].id
        form.value.house_name = res.data[0].name
      }
    }
    // 获取销售订单列表
    const getSaleOrder = async () => {
      const res = await request.get('/api/getSaleOrder')
      saleList.value = res.data
    }
    // 获取生产通知单
    const getProductNotice = async () => {
      const res = await request.get('/api/getProductNotice')
      noticeList.value = res.data
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
            module: '成品出入库',
            desc: `反审批了出/入库单：${str}`,
            data: { newData: row.id }
          })
        }
      }).catch(() => {})
    }
    // 处理审批
    const approvalApi = async (action, data) => {
      const ids = data.map(e => e.id)
      const res = await request.post('/api/handleApproval', {
        data: ids,
        action,
        source_type: 'product_warehouse',
        ware_id: form.value.ware_id
      })
      if(res.code == 200){
        ElMessage.success('审批成功')
        filterQuery()

        let str = ''
        data.forEach((e, index) => {
          if(e.status == 0){
            const obj = `{ 仓库：${e.house_name}，${operateValue[e.operate]}方式：${constObj.value[e.type]}，物料编码：${e.code} }`
            str += obj
            if(index < data.length - 1){
              str += '，'
            }
          }
        })
        if(!str) return
        const appValue = action == 1 ? '通过' : '拒绝'
        reportOperationLog({
          operationType: 'approval',
          module: '成品出入库',
          desc: `审批${appValue}了出/入库单，它们有：${str}`,
          data: { newData: { data: ids, action, ware_id: form.value.ware_id } }
        })
      }
    }
    const handleApproval = async (row) => {
      if(row.status == 1) return ElMessage.error('该数据已通过审批，无需再重复审批')
      handleApprovalDialog([row])
    }
    // 批量处理审批
    const setApprovalAllData = () => {
      const json = allSelect.value.length ? allSelect.value.filter(o => o.status == 0) : tableData.value.filter(o => o.status == 0)
      if(json.length == 0){
        return ElMessage.error('暂无可提交的数据')
      }
      handleApprovalDialog(json)
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
      const res = await request.post('/api/add_wareHouse_order', { data, type: 'product_warehouse' })
      if(res && res.code == 200){
        ElMessage.success('提交成功');
        filterQuery();

        let str = ''
        data.forEach((e, index) => {
          if(e.status == undefined || e.status == 2){
            const obj = `{ 仓库：${e.house_name}，${operateValue[e.operate]}方式：${constObj.value[e.type]}，物料编码：${e.code} }`
            str += obj
            if(index < data.length - 1){
              str += '，'
            }
          }
        })
        if(!str) return
        reportOperationLog({
          operationType: 'keyApproval',
          module: '材料出入库',
          desc: `出/入库单提交审核：${str}`,
          data: { newData: { data, type: 'material_warehouse' } }
        })
      }
    }
    const handleStatusData = async (row) => {
      const data = getFormData(row)
      handleWareHouseDialog([data])
    }
    // 批量提交审批
    const setStatusAllData = async () => {
      const json = allSelect.value.length ? allSelect.value.filter(o => !o.approval || o.status == 2) : tableData.value.filter(o => !o.approval || o.status == 2 || o.status == 3)
      if(json.length == 0){
        ElMessage.error('暂无可提交的数据')
      }
      const data = json.map(e => {
        return getFormData(e)
      })
      handleWareHouseDialog(data)
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
    const getFormData = (e) => {
      let obj = {
        ware_id: 3,
        house_id: e.house_id,
        house_name: e.house_name,
        operate: e.operate,  // 入库 or 出库
        type: e.type, // 常量类型
        plan_id: e.plan_id, // 供应商id or 制程id
        plan: e.plan, // 供应商 or 制程
        notice_id: e.notice_id,
        item_id: e.item_id,
        sale_id: e.sale_id,
        code: e.code,
        name: e.name,
        model_spec: e.model_spec,
        other_features: e.other_features,
        quantity: e.quantity,
        buy_price: e.buy_price,
        price: e.price,
        unit: e.unit,
        inv_unit: e.inv_unit,
        status: e.status,
        approval: e.approval?.length ? e.approval.map(e => e.id) : []
      }
      if(e.status == 2 || e.status == 3){
        obj.id = e.id
      }
      return obj
    }
    const handleSubmit = async (formEl) => {
      if (!formEl) return
      await formEl.validate(async (valid, fields) => {
        if (valid){
          if(!edit.value){
            const obj = JSON.parse(JSON.stringify(form.value))
            if((obj.type == 10 || obj.type == 13 || obj.type == 14) && obj.notice_id){
              obj.notice = { id: obj.notice_id, notice: noticeList.value.find(o => o.id == obj.notice_id).notice }
            }else{
              obj.notice_id = null
            }
            const quantity = Number(obj.quantity)
            if(!(quantity || quantity > 0)){
              return ElMessage.error('非法数量，请输入正整数的数量')
            }
            const res = await request.post('/api/queryWarehouse', obj)
            if(res.code != 200) return
            obj.id = getRandomString() // 临时ID
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
      const json = allSelect.value.filter(e => e.status && e.status == 1 && e.is_buying == 1 && e.apply_id == user.id)
      if(!json.length) return ElMessage.error('暂无可操作确认的数据')
      function isAllTypesSame(array) {
        const firstType = array[0].operate;
        return array.every(item => item.operate === firstType);
      }
      if(!isAllTypesSame(json)) return ElMessage.error('请将出/入库单分开确认')

      const ids = json.map(e => e.id)

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
      if(!row.status || row.status != 1) return ElMessage.error("该作业未审批通过，请提交审批")
      if(row.is_buying != 1) return ElMessage.error('不能重复生成出入库单')
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
    const handleUplate = (row) => {
      edit.value = row.id;
      dialogVisible.value = true;
      form.value = { ...row };
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
      form.value.sale_id = ''
      form.value.item_id = ''
      // 只有指定入库类型才需要生产通知单
      if([11, 12, 15, 16].includes(value)){
        form.value.notice_id = null
      }
      if(![13, 14].includes(value)){
        form.value.plan_id = null
      }
      if(value != 14){
        form.value.sale_id = null
      }
    }
    const saleChange = (value) => {
      const item = saleList.value.find(o => o.id == value)
      form.value.plan_id = item.customer_id
      form.value.item_id = item.product_id
      form.value.quantity = item.order_number
      form.value.buy_price = item.quot.product_price
      planChange(item.customer_id, 'customer_abbreviation')
      productChange(item.product_id)
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
      form.value.model_spec = obj.model
      form.value.other_features = obj.other_features
      form.value.unit = obj.unit ? Number(obj.unit) : form.value.unit ? Number(form.value.unit) : ''
      getWareHouseMaterialPrice(value)
      getWareHouseMaterialUnit(value)
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
          ware_id: 3,
          house_id: houseList.value[0].id,
          house_name: houseList.value[0].name,
          operate: '',
          type: '',
          plan_id: '',
          plan: '',
          sale_id: '',
          notice_id: '',
          item_id: '',
          code: '',
          name: '',
          model_spec: '',
          other_features: '',
          quantity: '',
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
    // 选择生产通知单后返回的数据
    const noticeChange = async (value) => {
      const row = noticeList.value.find(o => o.id == value)
      form.value.sale_id = row.sale_id
      form.value.plan_id = row.customer_id
      form.value.item_id = row.product_id
      form.value.quantity = row.sale.order_number
      form.value.buy_price = row.sale.quot.product_price
      form.value.unit = Number(row.sale.unit)
      getWareHouseMaterialPrice(row.product_id)
      getWareHouseMaterialUnit(row.product_id)
    }
    const getWareHouseMaterialPrice = async (id) => {
      const res = await request.get('/api/getWareHouseMaterialPrice', { params: { id } })
      if(res.code == 200){
        form.value.price = res.data?.price ? Number(res.data.price) : ''
      }
    }
    const getWareHouseMaterialUnit = async (id) => {
      const res = await request.get('/api/getWareHouseMaterialUnit', { params: { id } })
      if(res.code == 200){
        form.value.inv_unit = res.data?.inv_unit ? Number(res.data.inv_unit) : ''
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
                      <ElFormItem v-permission={ 'ProductHouseScription:addIn' }>
                        <ElButton type="primary" onClick={ () => handleAdd(1) } style={{ width: '100px' }}>新增入库单</ElButton>
                      </ElFormItem>
                      <ElFormItem v-permission={ 'ProductHouseScription:addOut' }>
                        <ElButton type="primary" onClick={ () => handleAdd(2) } style={{ width: '100px' }}>新增出库单</ElButton>
                      </ElFormItem>
                      <ElFormItem v-permission={ 'ProductHouseScription:set' }>
                        <ElButton type="primary" onClick={ () => setStatusAllData() } style={{ width: '100px' }}> 批量提交 </ElButton>
                      </ElFormItem>
                      {
                        !isEmptyValue(approvalUser) ? 
                        <ElFormItem>
                          <ElButton type="primary" onClick={ () => setApprovalAllData() } style={{ width: '100px' }}> 批量审批 </ElButton>
                        </ElFormItem> : 
                        <></>
                      }
                      <ElFormItem v-permission={ 'ProductHouseScription:buy' }>
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
                      <ElFormItem label="客户:">
                        <ElSelect v-model={ customerId.value } multiple={false} filterable remote remote-show-suffix clearable valueKey="id" placeholder="请选择客户" onChange={ (row) => formcustomerSelect(row) } style={{ width: '160px' }}>
                          {customerList.value.map((e, index) => <ElOption value={ e.id } label={ e.customer_abbreviation } key={ index } />)}
                        </ElSelect>
                      </ElFormItem>
                      <ElFormItem label="产品名称:">
                        <ElSelect v-model={ productId.value } multiple={false} filterable remote remote-show-suffix clearable valueKey="id" placeholder="请选择产品名称" style={{ width: '160px' }}>
                          {productList.value.map((e, index) => <ElOption value={ e.id } label={ e.product_name } key={ index } />)}
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
                  <ElTableColumn prop="plan" label="客户/制程" width="120" />
                  <ElTableColumn prop="code" label="物料编码" width="90" />
                  <ElTableColumn prop="name" label="物料名称" width="100" />
                  <ElTableColumn prop="quantity" label="数量">
                    {({row}) => <span>{ row.quantity ? row.quantity : 0 }</span>}
                  </ElTableColumn>
                  <ElTableColumn prop="model_spec" label="型号&规格" width="110" />
                  <ElTableColumn prop="other_features" label="其他特性" width="110" />
                  <ElTableColumn label="销售单价(元)" width="110">
                    {({row}) => <span>{ row.buy_price ? row.buy_price : 0 }</span>}
                  </ElTableColumn>
                  <ElTableColumn label="内部单价(元)" width="110">
                    {({row}) => <span>{ row.price ? row.price : 0 }</span>}
                  </ElTableColumn>
                  <ElTableColumn label="库存单位" width="90">
                    {({row}) => <span>{ calcUnit.value.find(e => e.id == row.inv_unit)?.name }</span>}
                  </ElTableColumn>
                  <ElTableColumn label="销售单位" width="90">
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
                      default: ({ row }) => {
                        if(!isEmptyValue(row)){
                          let dom = []
                          // 查询当前用户是否有审批权限
                          const isApproval = !!approvalUser && !!row.approval;
                          // 如果当前用户有审批权限，获取当前这条数据中，该用户的审批步骤
                          const rowApproval = isApproval ? row.approval.find(o => o.user_id === approvalUser.user_id) : null;
                          // 查询这条数据相对当前用户来说，状态是否可以修改
                          const { apply_id, is_buying, status } = row;
                          const isUserApplied = apply_id === user.id && is_buying === 1;
                          const isStatusValid = status === 2 || status === 3;
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
                            dom.push(<ElButton size="small" type="primary"  v-permission={ 'ProductHouseScription:buy' } onClick={ () => handleProcurement(row) }>出入库单确认</ElButton>)
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
        <ElDialog v-model={ dialogVisible.value } title={ `成品${getTitleValue()}单` } width='785' center draggable onClose={ () => handleClose() }>
          {{
            default: () => (
              <ElForm class="ml20" model={ form.value } ref={ formRef } inline={ true } rules={ rules } label-width="95">
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
                  form.value.type == 10 || form.value.type == 13 || form.value.type == 14 ?
                  <ElFormItem label="生产通知单" prop="notice_id">
                    <ElSelect v-model={ form.value.notice_id } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择生产通知单" onChange={ (value) => noticeChange(value) }>
                      {noticeList.value.map((o, index) => <ElOption value={ o.id } label={ o.notice } key={ index } />)}
                    </ElSelect>
                  </ElFormItem> : ''
                }
                {
                  form.value.type == 10 || form.value.type == 13 || form.value.type == 14 ? <ElFormItem label="销售订单" prop="sale_id">
                    <ElSelect v-model={ form.value.sale_id } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择销售订单" onChange={ (row) => saleChange(row) }>
                      {saleList.value.map((e, index) => e && (
                        <ElOption value={ e.id } label={ e.customer_order } key={ index } />
                      ))}
                    </ElSelect>
                  </ElFormItem> :
                  <></>
                }
                {
                  form.value.type == 13 || form.value.type == 14 ? 
                  <ElFormItem label="客户" prop="plan_id">
                    <ElSelect v-model={ form.value.plan_id } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择客户" onChange={ (row) => planChange(row, 'customer_abbreviation') }>
                      {customerList.value.map((e, index) => e && (
                        <ElOption value={ e.id } label={ e.customer_abbreviation } key={ index } />
                      ))}
                    </ElSelect>
                  </ElFormItem> :
                  <></>
                }
                <ElFormItem label="产品编码" prop="item_id">
                  <ElSelect v-model={ form.value.item_id } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择产品编码" onChange={ (row) => productChange(row) }>
                    {productList.value.map((e, index) => e && (
                      <ElOption value={ e.id } label={ e.product_code } key={ index } />
                    ))}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="产品名称">
                  <ElSelect class="disabled" v-model={ form.value.item_id } multiple={false} disabled filterable remote remote-show-suffix valueKey="id" placeholder="请选择产品名称">
                    {productList.value.map((e, index) => e && (
                      <ElOption value={ e.id } label={ e.product_name } key={ index } />
                    ))}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="数量" prop="quantity">
                  <ElInput v-model={ form.value.quantity } placeholder="请输入数量" />
                </ElFormItem>
                <ElFormItem label="销售单价" prop="buy_price">
                  <ElInput v-model={ form.value.buy_price } placeholder="请输入销售单价" />
                </ElFormItem>
                <ElFormItem label="内部单价" prop="price">
                  <ElInput v-model={ form.value.price } type="number" placeholder="请输入内部单价" />
                </ElFormItem>
                <ElFormItem label="销售单位" prop="unit">
                  <ElSelect v-model={ form.value.unit } multiple={ false } filterable remote remote-show-suffix placeholder='请选择销售单位'>
                    {calcUnit.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="库存单位" prop="inv_unit">
                  <ElSelect v-model={ form.value.inv_unit } multiple={ false } filterable remote remote-show-suffix placeholder="请选择库存单位">
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