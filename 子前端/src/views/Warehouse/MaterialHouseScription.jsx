import { defineComponent, onMounted, reactive, ref, nextTick, computed } from 'vue'
import { useStore } from '@/stores';
import { getRandomString, PreciseMath, numberToChinese, getNoLast, getPageHeight, isEmptyValue } from '@/utils/tool'
import { reportOperationLog } from '@/utils/log';
import { getItem } from '@/assets/js/storage';
import request from '@/utils/request';
import dayjs from "dayjs"
import "@/assets/css/print.scss"
import "@/assets/css/landscape.scss"
import html2pdf from 'html2pdf.js';
import WinPrint from '@/components/print/winPrint';
import HeadForm from '@/components/form/HeadForm';
import deepClone from '@/utils/deepClone';

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
    const approval = getItem('approval').filter(e => e.type == 'material_warehouse')
    // 找到当前这个用户在这个页面中是否有审批权限
    const approvalUser = approval.find(e => e.user_id == user.id)
    const nowDate = ref()
    const formHeight = ref(0);
    const formCard = ref(null)
    const formRef = ref(null)
    const rules = ref({})
    let form = ref({
      ware_id: 1,
      house_id: '',
      house_name: '',
      operate: '',  // 入库 or 出库
      type: '', // 常量类型
      plan_id: '', // 供应商id or 制程id
      plan: '', // 供应商 or 制程
      buyPrint_id: '', // 采购单号的ID
      item_id: '',
      code: '',
      name: '',
      model_spec: '',
      other_features: '',
      quantity: '',
      buy_price: '',
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
      await getSupplierInfo() // 获取供应商
      await getProcessCycle() // 获取制程
      await getMaterialCode() // 获取材料编码
      await getHouseList() // 获取仓库名称
      await filterQuery()
      await getMaterialOrderList() // 获取采购单列表

      getPrinters()
    })

    const getPrinters = async () => {
      const res = await request.get('/api/printers')
      printers.value = res.data
    }
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
      const res = await request.post('/api/getConstType', { type: ['materialIn', 'materialOut', 'house'] })
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
      const ids = data.map(e => e.id)
      const res = await request.post('/api/handleApproval', {
        data: ids,
        action,
        source_type: 'material_warehouse',
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
          module: '材料出入库',
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
        ElMessage.error('暂无可提交的数据')
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
      const res = await request.post('/api/add_wareHouse_order', { data, type: 'material_warehouse' })
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
      const json = allSelect.value.length ? allSelect.value.filter(o => !o.approval || o.status == 2) : tableData.value.filter(o => !o.approval || o.status == 2)
      if(json.length == 0){
        return ElMessage.error('暂无可提交的数据')
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
      const obj = {
        ware_id: 1,
        house_id: e.house_id,
        house_name: e.house_name,
        operate: e.operate,  // 入库 or 出库
        type: e.type, // 常量类型
        plan_id: e.plan_id, // 供应商id or 制程id
        plan: e.plan, // 供应商 or 制程
        buyPrint_id: e.buyPrint_id, //采购单号的ID
        item_id: e.item_id,
        code: e.code,
        name: e.name,
        model_spec: e.model_spec,
        other_features: e.other_features,
        quantity: e.quantity,
        buy_price: e.buy_price,
        status: e.status,
        approval: e.approval?.length ? e.approval.map(e => e.id) : []
      }
      if(e.status == 2){
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
            const quantity = Number(obj.quantity)
            if(!(quantity || quantity > 0)){
              return ElMessage.error('非法数量，请输入正整数的数量')
            }
            const res = await request.post('/api/queryWarehouse', obj) // 用来做检查的接口
            if(res.code != 200) return
            obj.id = getRandomString() // 临时ID
            console.log(obj);
            tableData.value = [obj, ...tableData.value]
            dialogVisible.value = false;
            
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
      if(value != 4){
        form.value.buy_price = ''
      }
      form.value.buyPrint_id = ''
    }
    const outChange = async (value) => {
      const res = await request.get('/api/getOutsourcingOrder', { params: { print_id: value } })
      const data = res.data
      planChange(data[0].supplier.id, 'supplier_abbreviation')
      form.value.plan_id = data[0].supplier.id
      form.value.buy_price = data[0].price
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
      const json = allSelect.value.filter(e => e.status && e.status == 1 && e.is_buying == 1)
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
    const planChange = (value, label) => {
      const list = label == 'name' ? cycleList.value : supplierList.value
      const obj = list.find(e => e.id == value)
      form.value.plan = obj[label]
    }
    const materialChange = (value) => {
      const obj = materialList.value.find(e => e.id == value)
      if(form.value.buyPrint_id){
        form.value.quantity = obj.number
        form.value.buy_price = obj.price
        return
      }
      form.value.code = obj.material_code
      form.value.name = obj.material_name
      form.value.model_spec = obj.model
      form.value.other_features = obj.other_features
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
          buyPrint_id: '',
          item_id: '',
          code: '',
          name: '',
          model_spec: '',
          other_features: '',
          quantity: '',
          buy_price: '',
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
    // const onPrint = async () => {
    //   const list = allSelect.value.length ? allSelect.value : tableData.value
    //   if(!list.length) return ElMessage.error('请选择需要打印的数据')
    //   const canPrintData = list.filter(o => o.status != undefined && o.status == 1)
    //   if(!canPrintData.length) return ElMessage.error('暂无可打印的数据或未审核通过')

    //   const printType = getPrintType()
    //   await getNoLast(printType)
    //   const ids = canPrintData.map(e => e.id)
    //   printDataIds.value = ids
      
    //   const printTable = document.getElementById('printTable'); // 对应页面中表格的 ID
    //   const opt = {
    //     margin: 10,
    //     filename: 'table-print.pdf',
    //     image: { type: 'jpeg', quality: 0.98 },
    //     pagebreak: {
    //       mode: ['avoid-all', 'css', 'avoid']
    //     },
    //     html2canvas: { scale: 2 }, // 保证清晰度
    //     jsPDF: { unit: 'mm', format: 'a4', orientation: 'landscape' }
    //   };
    //   // 生成 PDF 并转为 Blob
    //   html2pdf().from(printTable).set(opt).output('blob').then(async pdfBlob => {
    //     let urlTwo = URL.createObjectURL(pdfBlob);
    //     setPdfBlobUrl.value = urlTwo
    //     printVisible.value = true
    //   }); 
    // }
    // const getPrintType = () => {
    //   if(tableData.value.length){
    //     return tableData.value[0].operate == 1 ? 'MR' : 'MC'
    //   }
    //   return ''
    // }

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
                        approval.findIndex(e => e.user_id == user.id) >= 0 ? 
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
                  <ElTableColumn prop="house_name" label="仓库名称" width="100" />
                  <ElTableColumn label="出入库" width="80">
                    {({row}) => <span>{operateValue[row.operate]}</span>}
                  </ElTableColumn>
                  <ElTableColumn label="出入库方式" width="100">
                    {({row}) => <span>{constObj.value[row.type]}</span>}
                  </ElTableColumn>
                  <ElTableColumn prop="plan" label="供应商/制程" width="120" />
                  <ElTableColumn prop="code" label="物料编码" width="90" />
                  <ElTableColumn prop="name" label="物料名称" width="100" />
                  <ElTableColumn prop="quantity" label="数量">
                    {({row}) => <span>{ row.quantity ? row.quantity : 0 }</span>}
                  </ElTableColumn>
                  <ElTableColumn prop="model_spec" label="规格&型号" width="110" />
                  <ElTableColumn prop="other_features" label="其他特性" width="110" />
                  <ElTableColumn prop="buy_price" label="单价(元)" width="110">
                    {({row}) => <span>{ row.buy_price ? row.buy_price : 0 }</span>}
                  </ElTableColumn>
                  <ElTableColumn label="总价(元)" width="110">
                    {({row}) => <span>{ row.approval ? row.total_price : PreciseMath.mul(row.buy_price, row.quantity) }</span>}
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
                          if(row.status == 1 && row.is_buying == 1){
                            dom.push(<ElButton size="small" type="primary"  v-permission={ 'MaterialHouseScription:buy' } onClick={ () => handleProcurement(row) }>出入库单确认</ElButton>)
                          }
                          return dom
                        }
                      }
                    }}
                  </ElTableColumn>
                </ElTable>
                <div class="printTable" id='totalTable2'>
                  <div id="printTable">
                    <div class="No">编码：{ printNo.value }</div>
                    <table class="print-table">
                      <thead>
                        <tr>
                          <th colspan="9" class="title-cell">
                            <div class="popTitle" style={{ textAlign: 'center', fontSize: '36px' }}>{ tableData.value.length ? `${operateValue[tableData.value[0].operate]}单` : '' }</div>
                          </th>
                        </tr>
                        <tr>
                          <th colspan="9" class="header-cell">
                            <div class="flex row-between print-header">
                              <div>仓库类别：材料仓</div>
                              <div>仓库名称：{ tableData.value.length ? tableData.value[0].house_name : '' }</div>
                              <div>统计周期：{ dateTime.value[0] } 至 {dateTime.value[1]}</div>
                            </div>
                          </th>
                        </tr>
                        <tr class="table-header">
                          <th>序号</th>
                          <th>状态</th>
                          <th>供应商/制程</th>
                          <th>物料编码</th>
                          <th>物料名称</th>
                          <th>规格型号</th>
                          <th>数量</th>
                          <th>单价</th>
                          <th>总价</th>
                        </tr>
                      </thead>
                      <tbody>
                        {(allSelect.value.length ? allSelect.value : tableData.value).map((e, index) => {
                          const tr = <tr class="table-row">
                            <td>{ index + 1 }</td>
                            <td>{ e.status >= 0 ? statusType[e.status] : '' }</td>
                            <td>{ e.plan }</td>
                            <td>{ e.code }</td>
                            <td>{ e.name }</td>
                            <td>{ e.model_spec }</td>
                            <td>{ e.quantity }</td>
                            <td>{ e.buy_price ? e.buy_price : 0 }</td>
                            <td>{ e.approval ? e.total_price : PreciseMath.mul(e.buy_price, e.quantity) }</td>
                          </tr>
                          return tr
                        })}
                        <tr class="table-row">
                          <td>统计</td>
                          <td colSpan={ 5 }>人民币大写：{ numberToChinese(getTotalNumber('total_price')) }</td>
                          <td>{ getTotalNumber('quantity') }</td>
                          <td>/</td>
                          <td>{ getTotalNumber('total_price') }</td>
                        </tr>
                        <tr class="header-cell">
                          <td colspan="9">
                            <div class="flex row-between print-header">
                              <div>核准：</div>
                              <div>审查：</div>
                              <div>制表：{ user.name }</div>
                              <div>日期：{ nowDate.value }</div>
                            </div>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                </div>
              </>
            )
          }}
        </ElCard>
        <ElDialog v-model={ dialogVisible.value } title={ `${getTitleValue()}单` } width='785' center draggable onClose={ () => handleClose() }>
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
                  form.value.type == 4 ? 
                  <ElFormItem label="采购单" prop="buyPrint_id">
                    <ElSelect v-model={ form.value.buyPrint_id } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择采购单号" onChange={ (row) => buyChange(row) }>
                      {materialBuy.value.map((o, index) => <ElOption value={ o.id } label={ o.no } key={ index } />)}
                    </ElSelect>
                  </ElFormItem> : ''
                }
                {
                  form.value.type == 8 ? 
                  <ElFormItem label="委外加工单" prop="buyPrint_id">
                    <ElSelect v-model={ form.value.buyPrint_id } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择委外加工单" onChange={ (row) => outChange(row) }>
                      {outBuy.value.map((o, index) => <ElOption value={ o.id } label={ o.no } key={ index } />)}
                    </ElSelect>
                  </ElFormItem> : ''
                }
                {
                  form.value.type == 4 || form.value.type == 8 ? 
                  <ElFormItem label="供应商" prop="plan_id">
                    <ElSelect v-model={ form.value.plan_id } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择供应商" onChange={ (row) => planChange(row, 'supplier_abbreviation') }>
                      {supplierList.value.map((e, index) => e && (
                        <ElOption value={ e.id } label={ e.supplier_abbreviation } key={ index } />
                      ))}
                    </ElSelect>
                  </ElFormItem> :
                  form.value.type == 7 ? 
                  <ElFormItem label="制程" prop="plan_id">
                    <ElSelect v-model={ form.value.plan_id } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择制程" onChange={ (row) => planChange(row, 'name') }>
                      {cycleList.value.map((e, index) => e && (
                        <ElOption value={ e.id } label={ e.name } key={ index } />
                      ))}
                    </ElSelect>
                  </ElFormItem> :
                  <></>
                }
                <ElFormItem label="材料编码" prop="item_id">
                  <ElSelect v-model={ form.value.item_id } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择材料编码" onChange={ (row) => materialChange(row) }>
                    {materialList.value.map((e, index) => e && (
                      <ElOption value={ e.id } label={ e.material_code } disabled={ form.value.buyPrint_id ? !e.is_houser : false } key={ index } />
                    ))}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="材料名称">
                  <ElSelect class="disabled" v-model={ form.value.item_id } multiple={false} disabled filterable remote remote-show-suffix valueKey="id" placeholder="请选择材料名称" onChange={ (row) => materialChange(row) }>
                    {materialList.value.map((e, index) => e && (
                      <ElOption value={ e.id } label={ e.material_name } key={ index } />
                    ))}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="数量" prop="quantity">
                  <ElInput v-model={ form.value.quantity } placeholder="请输入数量" />
                </ElFormItem>
                <ElFormItem label="单价" prop="buy_price">
                  <ElInput v-model={ form.value.buy_price } type="number" placeholder="请输入单价" />
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