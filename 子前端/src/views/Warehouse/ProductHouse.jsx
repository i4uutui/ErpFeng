import { defineComponent, onMounted, reactive, ref, nextTick } from 'vue'
import { getRandomString, PreciseMath, numberToChinese } from '@/utils/tool'
import { getItem } from '@/assets/js/storage';
import request from '@/utils/request';
import dayjs from "dayjs"
import "@/assets/css/print.scss"
import "@/assets/css/landscape.scss"
import { reportOperationLog } from '@/utils/log';
import html2pdf from 'html2pdf.js';
import WinPrint from '@/components/print/winPrint';

export default defineComponent({
  setup(){
    const statusType = reactive({
      0: '待审批',
      1: '已通过',
      2: '已拒绝'
    })
    const operateValue = reactive({
      1: '入库',
      2: '出库'
    })
    const statusList = ref([{ id: 0, name: '待审批' }, { id: 1, name: '已通过' }, { id: 2, name: '已拒绝' }])
    const operate = reactive([{ id: 1, name: '入库' }, { id: 2, name: '出库' }])
    const approval = getItem('approval').filter(e => e.type == 'product_warehouse')
    const user = getItem('user')
    const nowDate = ref()
    const formHeight = ref(0);
    const formCard = ref(null)
    const formRef = ref(null)
    const rules = ref({})
    let form = ref({
      ware_id: 3,
      house_id: '',
      house_name: '',
      operate: '',  // 入库 or 出库
      type: '', // 常量类型
      plan_id: '', // 客户id or 制程id
      plan: '', // 客户 or 制程
      sale_id: '',
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
    let customerList = ref([]) // 供应商列表
    let cycleList = ref([]) // 制程列表
    let productList = ref([]) // 材料编码
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

    const printObj = ref({
      id: "printTable", // 这里是要打印元素的ID
      popTitle: "委外加工单", // 打印的标题
      // preview: true, // 是否启动预览模式，默认是false
      zIndex: 20003, // 预览窗口的z-index，默认是20002，最好比默认值更高
      previewBeforeOpenCallback() { console.log('正在加载预览窗口！'); }, // 预览窗口打开之前的callback
      previewOpenCallback() { console.log('已经加载完预览窗口，预览打开了！') }, // 预览窗口打开时的callback
      beforeOpenCallback(vue) {
        console.log('开始打印之前！')
        isPrint.value = true
      }, // 开始打印之前的callback
      openCallback(vue) {
        console.log('监听到了打印窗户弹起了！')
      }, // 调用打印时的callback
      closeCallback() {
        console.log('关闭了打印工具！')
        isPrint.value = false
      }, // 关闭打印的callback(点击弹窗的取消和打印按钮都会触发)
      clickMounted() { console.log('点击v-print绑定的按钮了！') },
    })

    onMounted(async () => {
      nowDate.value = dayjs().format('YYYY-MM-DD HH:mm:ss')
      // 获取最近一年的日期
      const today = dayjs()
      const lastYearStart = today.subtract(1, 'year').startOf('day').format('YYYY-MM-DD HH:mm:ss')
      const lastYearEnd = today.endOf('day').format('YYYY-MM-DD HH:mm:ss')
      dateTime.value = [lastYearStart, lastYearEnd]

      nextTick(() => {
        getFormHeight();
      })

      await getConstType()
      await getCustomerInfo() // 获取客户
      await getProcessCycle() // 获取制程
      await getProductsCode() // 获取产品编码
      await getHouseList() // 获取仓库名称
      await filterQuery()
      await getSaleOrder()

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
        // source_type: 'product_warehouse',
        apply_time: dateTime.value
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
      const res = await request.get('/api/warehouse_cycle', { params: { ware_id: 3 } })
      houseList.value = res.data
      form.value.house_id = res.data[0].id
      form.value.house_name = res.data[0].name
    }
    // 获取销售订单列表
    const getSaleOrder = async () => {
      const res = await request.get('/api/getSaleOrder')
      saleList.value = res.data
    }
    // 反审批
    const handleBackApproval = async (row) => {
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
    }
    // 处理审批
    const approvalApi = async (action, data) => {
      const ids = data.map(e => e.id)
      const res = await request.post('/api/handleApproval', {
        data: ids,
        action,
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
        ElMessage.error('暂无可提交的数据')
      }
      handleApprovalDialog(json)
    }
    const handleApprovalDialog = (data) => {
      ElMessageBox.confirm('是否确认审批？', '提示', {
        confirmButtonText: '同意',
        cancelButtonText: '拒绝',
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
      const json = allSelect.value.length ? allSelect.value.filter(o => !o.approval || o.status == 2) : tableData.value.filter(o => !o.approval || o.status == 2)
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
        item_id: e.item_id,
        sale_id: e.sale_id,
        code: e.code,
        name: e.name,
        model_spec: e.model_spec,
        other_features: e.other_features,
        quantity: e.quantity,
        buy_price: e.buy_price,
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
      form.value.sale_id = ''
    }
    const saleChange = (value) => {
      const item = saleList.value.find(o => o.id == value)
      form.value.plan_id = item.customer_id
      form.value.item_id = item.product_id
      form.value.quantity = item.order_number
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
      form.value.model_spec = `${obj.model}/${obj.specification}`
      form.value.other_features = obj.other_features
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
    // 计算页面中表单的高度
    const getFormHeight = async () => {
      await nextTick()
      if (formCard.value) {
        const offsetH = formCard.value.$el.offsetHeight;
        formHeight.value = offsetH; // 选择需要的高度类型
      }
    };
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
    const handleRowStyle = ({ row }) => {
      if(row.status == 0){
        return { color: 'red' }
      }
    }
    const onPrint = async () => {
      const list = allSelect.value.length ? allSelect.value : tableData.value
      if(!list.length) return ElMessage.error('请选择需要打印的数据')
      const canPrintData = list.filter(o => o.status != undefined && o.status == 1)
      if(!canPrintData.length) return ElMessage.error('暂无可打印的数据或未审核通过')
      
      const ids = canPrintData.map(e => e.id)
      printDataIds.value = ids
      
      const printTable = document.getElementById('printTable'); // 对应页面中表格的 ID
      const opt = {
        margin: 10,
        filename: 'table-print.pdf',
        image: { type: 'jpeg', quality: 0.98 },
        html2canvas: { scale: 2 }, // 保证清晰度
        jsPDF: { unit: 'mm', format: 'a4', orientation: 'landscape' }
      };
      // 生成 PDF 并转为 Blob
      html2pdf().from(printTable).set(opt).output('blob').then(async pdfBlob => {
        let urlTwo = URL.createObjectURL(pdfBlob);
        setPdfBlobUrl.value = urlTwo
        printVisible.value = true
      }); 
    }
    const getPrintType = () => {
      if(tableData.value.length){
        return tableData.value[0].operate == 1 ? 'PI' : 'PO'
      }
      return ''
    }

    return() => (
      <>
        <ElCard style={{ height: '100%' }}>
          {{
            header: () => (
              <ElForm ref={ formCard } inline={ true } class="cardHeaderFrom">
                <ElFormItem v-permission={ 'ProductHouse:addIn' }>
                  <ElButton style="margin-top: -5px" type="primary" onClick={ () => handleAdd(1) }>新增入库单</ElButton>
                </ElFormItem>
                <ElFormItem v-permission={ 'ProductHouse:addOut' }>
                  <ElButton style="margin-top: -5px" type="primary" onClick={ () => handleAdd(2) }>新增出库单</ElButton>
                </ElFormItem>
                <ElFormItem v-permission={ 'ProductHouse:set' }>
                  <ElButton style="margin-top: -5px" type="primary" onClick={ () => setStatusAllData() }> 批量提交 </ElButton>
                </ElFormItem>
                {
                  approval.findIndex(e => e.user_id == user.id) >= 0 ? 
                  <ElFormItem>
                    <ElButton style="margin-top: -5px" type="primary" onClick={ () => setApprovalAllData() }> 批量审批 </ElButton>
                  </ElFormItem> : 
                  <></>
                }
                <ElFormItem v-permission={ 'ProductHouse:print' }>
                  <ElButton style="margin-top: -5px" type="primary" onClick={ () => onPrint() }> 出入库打印 </ElButton>
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
                <ElFormItem label="产品名称:">
                  <ElSelect v-model={ productId.value } multiple={false} filterable remote remote-show-suffix clearable valueKey="id" placeholder="请选择产品名称">
                    {productList.value.map((e, index) => <ElOption value={ e.id } label={ e.product_name } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="审批状态:">
                  <ElSelect v-model={ statusId.value } multiple={false} filterable remote remote-show-suffix clearable valueKey="id" placeholder="请选择审批状态">
                    {statusList.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="周期:">
                  <el-date-picker v-model={ dateTime.value } type="daterange" clearable={ false } range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期" value-format="YYYY-MM-DD" onChange={ (row) => dateChange(row) } />
                </ElFormItem>
                <ElFormItem>
                  <ElButton style="margin-top: -5px" type="primary" onClick={ () => filterQuery() }>筛选</ElButton>
                </ElFormItem>
              </ElForm>
            ),
            default: () => (
              <>
                <ElTable data={ tableData.value } border stripe height={ `calc(100vh - ${formHeight.value + 220}px)` } style={{ width: "100%" }} rowStyle={ handleRowStyle } onSelectionChange={ (select) => handleSelectionChange(select) }>
                  <ElTableColumn type="selection" width="55" fixed="left" />
                  <ElTableColumn label="审批状态" width="100">
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
                  <ElTableColumn prop="quantity" label="数量">
                    {({row}) => <span>{ row.quantity ? row.quantity : 0 }</span>}
                  </ElTableColumn>
                  <ElTableColumn prop="model_spec" label="规格型号" width="110" />
                  <ElTableColumn prop="other_features" label="其他特性" width="110" />
                  <ElTableColumn prop="buy_price" label="单价(元)" width="110">
                    {({row}) => <span>{ row.buy_price ? row.buy_price : 0 }</span>}
                  </ElTableColumn>
                  <ElTableColumn prop="buy_price" label="总价(元)" width="110" />
                  <ElTableColumn label="总价(元)" width="110">
                    {({row}) => <span>{ row.status ? row.total_price : PreciseMath.mul(row.buy_price, row.quantity) }</span>}
                  </ElTableColumn>
                  <ElTableColumn prop="apply_name" label="申请人" width="90" />
                  <ElTableColumn prop="apply_time" label="申请时间" width="110" />
                  <ElTableColumn label="操作" width="150" fixed="right">
                    {{
                      default: ({ row }) => {
                        let dom = []
                        if(row.status == undefined || row.status == 2){
                          dom.push(<>
                            <ElButton size="small" type="default" v-permission={ 'ProductHouse:edit' } onClick={ () => handleUplate(row) }>修改</ElButton>
                            <ElButton size="small" type="primary" v-permission={ 'ProductHouse:set' } onClick={ () => handleStatusData(row) }>提交</ElButton>
                          </>)
                        }
                        if(row.status == 0 && approval.findIndex(e => e.user_id == user.id) >= 0){
                          dom.push(<>
                            <ElButton size="small" type="primary" onClick={ () => handleApproval(row) }>审批</ElButton>
                          </>)
                        }
                        if(row.status == 1 && approval.findIndex(e => e.user_id == user.id) >= 0){
                          dom.push(<>
                            <ElButton size="small" type="primary" onClick={ () => handleBackApproval(row) }>反审批</ElButton>
                          </>)
                        }
                        return dom
                      }
                    }}
                  </ElTableColumn>
                </ElTable>
                <ElDialog v-model={ printVisible.value } title="打印预览" width="900px" destroyOnClose>
                  {{
                    default: () => (
                      <WinPrint printType={ getPrintType() } url={ setPdfBlobUrl.value } printList={ printers.value } onClose={ () => printVisible.value = false } dataIds={ printDataIds.value } />
                    ),
                  }}
                </ElDialog>
                <div class="printTable" id='totalTable2'>
                  <div id="printTable">
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
                              <div>仓库类别：成品仓</div>
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
                  form.value.type == 14 ? <ElFormItem label="销售订单" prop="sale_id">
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
                <ElFormItem label="单价" prop="buy_price">
                  <ElInput v-model={ form.value.buy_price } placeholder="请输入单价" />
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