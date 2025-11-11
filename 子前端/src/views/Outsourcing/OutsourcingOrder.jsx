import { defineComponent, onMounted, reactive, ref, computed, nextTick } from 'vue'
import { useStore } from '@/stores';
import { getRandomString, getNoLast, getPageHeight } from '@/utils/tool'
import { reportOperationLog } from '@/utils/log';
import { getItem } from '@/assets/js/storage';
import request from '@/utils/request';
import dayjs from "dayjs"
import "@/assets/css/print.scss"
import "@/assets/css/landscape.scss"
import html2pdf from 'html2pdf.js';
import WinPrint from '@/components/print/winPrint';
import HeadForm from '@/components/form/HeadForm';

export default defineComponent({
  setup() {
    const store = useStore()
    const statusType = reactive({
      0: '待审批',
      1: '已通过',
      2: '已拒绝'
    })
    const statusList = ref([{ id: 0, name: '待审批' }, { id: 1, name: '已通过' }, { id: 2, name: '已拒绝' }])
    const approval = getItem('approval').filter(e => e.type == 'outsourcing_order')
    const user = getItem('user')
    const nowDate = ref()
    const formRef = ref(null);
    const formCard = ref(null)
    const formHeight = ref(0);
    const rules = reactive({
      supplier_id: [
        { required: true, message: '请选择供应商编码', trigger: 'blur' }
      ],
      process_bom_id: [
        { required: true, message: '请选择工艺BOM表', trigger: 'blur' }
      ],
    })
    let dialogVisible = ref(false)
    let form = ref({
      notice_id: '',
      quote_id: '',
      supplier_id: '',
      supplier_abbreviation: '',
      process_bom_id: '',
      process_bom_children_id: '',
      price: '',
      number: '',
      ment: '',
      unit: '',
      transaction_currency: '',
      other_transaction_terms: '',
      remarks: '',
      delivery_time: ''
    })
    let search = ref({
      notice: '',
      supplier_code: '',
      supplier_abbreviation: '',
      status: '',
    })
    let tableData = ref([])
    let allSelect = ref([])
    let edit = ref(0)
    let noticeList = ref([])
    let supplierList = ref([])
    let quoteList = ref([])
    let supplierInfo = ref([]) // 供应商编码列表
    let bomList = ref([]) // 工艺Bom列表
    let procedure = ref([]) // 工序列表
    let productNotice = ref([]) // 获取生产订单通知单列表
    // 用来打印用的
    let printers = ref([]) //打印机列表
    let printDataIds = ref([]) // 需要打印的数据的id
    let printVisible = ref(false)
    let setPdfBlobUrl = ref('')
    let supplierName = ref('')
    let productName = ref('')
    let productCode = ref('')
    let noticeNumber = ref('')

    const printNo = computed(() => store.printNo)
    
    onMounted(() => {
      nextTick(async () => {
        formHeight.value = await getPageHeight([formCard.value]);
      })
      nowDate.value = dayjs().format('YYYY-MM-DD HH:mm:ss')
      getPrinters() // 打印机列表
      fetchProductList() // 数据列表
      getProductNotice() // 获取生产通知单列表
      getSupplierInfo() // 供应商编码列表
    })
    
    const getPrinters = async () => {
      const res = await request.get('/api/printers')
      printers.value = res.data
    }
    // 获取列表
    const fetchProductList = async () => {
      const res = await request.get('/api/outsourcing_order', { params: search.value });
      tableData.value = res.data;

      // 打印的时候用的
      if(res.data.length){
        const data = res.data[0]
        supplierName.value = data.supplier.supplier_abbreviation
        productName.value = data.processBom.product.product_name
        productCode.value = data.processBom.product.product_code
        noticeNumber.value = data.notice.notice
      }
    }
    // 获取生产通知单列表
    const getProductNotice = async () => {
      const res = await request.get('/api/getProductNotice')
      productNotice.value = res.data
    }
    // 获取供应商列表
    const getSupplierInfo = async () => {
      const res = await request.get('/api/getSupplierInfo')
      supplierInfo.value = res.data
    }
    // 获取委外报价单
    const getOutsourcingQuote = async (notice_id) => {
      const res = await request.get('/api/getOutsourcingQuote', { params: { notice_id } })
      quoteList.value = res.data
    }
    // 获取工艺BOM列表
    const getProcessBomList = async (product_id) => {
      const res = await request.get('/api/getProcessBom', { params: { product_id } })
      bomList.value = res.data
    }
    const getProcessBomChildren = async (value) => {
      const res = await request.get(`/api/getProcessBomChildren?process_bom_id=${value}`)
      procedure.value = res.data
    }
    // 弹窗确认按钮
    const handleSubmit = async (formEl) => {
      if (!formEl) return
      await formEl.validate(async (valid, fields) => {
        if (valid){
          if(!edit.value){
            const obj = JSON.parse(JSON.stringify(form.value))
            obj.notice = productNotice.value.find(o => o.id == obj.notice_id)
            obj.processBom = bomList.value.find(o => o.id == obj.process_bom_id)
            obj.processChildren = procedure.value.find(o => o.id == obj.process_bom_children_id)
            obj.supplier = supplierInfo.value.find(o => o.id == obj.supplier_id)
            obj.id = getRandomString() // 临时ID
            tableData.value = [obj, ...tableData.value]
            // 重置
            procedure.value = []
            dialogVisible.value = false;
          }else{
            if(form.value.status){
              // 修改
              const myForm = {
                id: edit.value,
                notice_id: form.value.notice_id,
                supplier_id: form.value.supplier_id,
                supplier_abbreviation: form.value.supplier_abbreviation,
                process_bom_id: form.value.process_bom_id,
                process_bom_children_id: form.value.process_bom_children_id,
                price: form.value.price,
                number: form.value.number,
                ment: form.value.ment,
                unit: form.value.unit,
                transaction_currency: form.value.transaction_currency,
                other_transaction_terms: form.value.other_transaction_terms,
                remarks: form.value.remarks,
                delivery_time: form.value.delivery_time
              }
              const res = await request.put('/api/outsourcing_order', myForm);
              if(res && res.code == 200){
                ElMessage.success('修改成功');
                dialogVisible.value = false;
                fetchProductList();

                const supplier = supplierList.value.find(o => o.id == myForm.supplier_id)
                const notice = noticeList.value.find(o => o.id == myForm.notice_id)
                const processBom = bomList.value.find(o => o.id == myForm.process_bom_id)
                const proce = procedure.value.find(o => o.id == myForm.process_bom_children_id)
                reportOperationLog({
                  operationType: 'update',
                  module: '委外加工单',
                  desc: `修改委外加工单，供应商编码：${supplier.supplier_code}，生产订单号：${notice.notice}，工艺BOM：${processBom.name}，工艺工序：${proce ? proce.name : ''}`,
                  data: { newData: myForm }
                })
              }
            }else{
              const obj = JSON.parse(JSON.stringify(form.value))
              obj.notice = productNotice.value.find(o => o.id == obj.notice_id)
              obj.processBom = bomList.value.find(o => o.id == obj.process_bom_id)
              obj.processChildren = procedure.value.find(o => o.id == obj.process_bom_children_id)
              obj.supplier = supplierInfo.value.find(o => o.id == obj.supplier_id)
              tableData.value = tableData.value.map(o => {
                if(o.id == edit.value){
                  return obj
                }
                return o
              })
              // 重置
              procedure.value = []
              dialogVisible.value = false;
            }
          }
        }
      })
    }
    // 提交数据审核接口
    const setApiData = async (data) => {
      const res = await request.post('/api/add_outsourcing_order', { data, type: 'outsourcing_order' })
      if(res && res.code == 200){
        ElMessage.success('提交成功');
        fetchProductList();

        let str = ''
        data.forEach((e, index) => {
          const supplier = supplierList.value.find(o => o.id == e.supplier_id)
          const notice = noticeList.value.find(o => o.id == e.notice_id)
          const processBom = bomList.value.find(o => o.id == e.process_bom_id)
          const proce = procedure.value.find(o => o.id == e.process_bom_children_id)
          const obj = `{ 供应商编码：${supplier.supplier_code}，生产订单号：${notice.notice}，工艺BOM：${processBom.name}，工艺工序：${proce ? proce.name : ''} }`
          str += obj
          if(index < data.length - 1){
            str += '，'
          }
        })
        reportOperationLog({
          operationType: 'keyApproval',
          module: '委外加工单',
          desc: `委外加工单提交审核：${str}`,
          data: { newData: { data, type: 'outsourcing_order' } }
        })
      }
    }
    // 权限用户处理审批接口
    const approvalApi = async (action, data) => {
      const ids = data.map(e => e.id)
      const res = await request.post('/api/handleOutsourcingApproval', {
        data: ids,
        action
      })
      if(res.code == 200){
        ElMessage.success('审批成功')
        fetchProductList()

        let str = ''
        data.forEach((e, index) => {
          const supplier = supplierList.value.find(o => o.id == e.supplier_id)
          const notice = noticeList.value.find(o => o.id == e.notice_id)
          const processBom = bomList.value.find(o => o.id == e.process_bom_id)
          const childPro = e.processChildren.process
          const childEqu = e.processChildren.equipment
          const proce = `${childPro.process_code}:${childPro.process_name} - ${childEqu.equipment_code}:${childEqu.equipment_name}`
          const obj = `{ 供应商编码：${supplier.supplier_code}，生产订单号：${notice.notice}，工艺BOM：${processBom.name}，工艺工序：${proce} }`
          str += obj
          if(index < data.length - 1){
            str += '，'
          }
        })
        const appValue = action == 1 ? '通过' : '拒绝'
        reportOperationLog({
          operationType: 'approval',
          module: '委外加工单',
          desc: `审批${appValue}了委外加工单，它们有：${str}`,
          data: { newData: { data, action } }
        })
      }
    }
    // 权限用户处理反审批接口
    const handleBackApproval = async (row) => {
      ElMessageBox.confirm('是否确认反审批？', '提示', {
        confirmButtonText: '通过',
        cancelButtonText: '拒绝',
        type: 'warning',
        distinguishCancelAndClose: true,
      }).then(async () => {
        const res = await request.post('/api/handleOutsourcingBackFlow', { id: row.id })
        if(res.code == 200){
          ElMessage.success('反审批成功')
          fetchProductList()

          const supplier = supplierList.value.find(o => o.id == row.supplier_id)
          const notice = noticeList.value.find(o => o.id == row.notice_id)
          const processBom = bomList.value.find(o => o.id == row.process_bom_id)
          const childPro = row.processChildren.process
          const childEqu = row.processChildren.equipment
          const proce = `${childPro.process_code}:${childPro.process_name} - ${childEqu.equipment_code}:${childEqu.equipment_name}`
          const str = `供应商编码：${supplier.supplier_code}，生产订单号：${notice.notice}，工艺BOM：${processBom.name}，工艺工序：${proce}`
          reportOperationLog({
            operationType: 'backApproval',
            module: '委外加工单',
            desc: `反审批了委外加工单，${str}`,
            data: { newData: row.id }
          })
        }
      }).catch((action) => {
        
      })
    }
    // 生产订单选中后返回的数据
    const noticeChange = (value) => {
      const row = productNotice.value.find(o => o.id == value)
      form.value.number = row.sale.order_number
      form.value.delivery_time = row.delivery_time
      getOutsourcingQuote(row.id)
      getProcessBomList(row.product_id)
    }
    // 修改委外加工
    const handleUplate = async (row) => {
      edit.value = row.id;
      dialogVisible.value = true;
      form.value = { ...row };
      const notice = productNotice.value.find(o => o.id == row.notice_id)
      await getOutsourcingQuote(notice.id)
      await getProcessBomList(notice.product_id)
      await getProcessBomChildren(row.process_bom_id)
    }
    // 工艺BOM选中后返回的数据
    const changeBomSelect = (value) => {
      procedure.value = []
      form.value.process_bom_children_id = ''
      getProcessBomChildren(value)
    }
    const quoteChange = async (value) => {
      const row = quoteList.value.find(o => o.id == value)
      form.value.process_bom_id = row.processBom.id
      await getProcessBomChildren(row.processChildren.process_bom_id)
      form.value.process_bom_children_id = row.processChildren.id

      form.value.supplier_id = row.supplier_id
      form.value.supplier_abbreviation = row.supplier.supplier_abbreviation
      form.value.price = row.price
      form.value.transaction_currency = row.transaction_currency
      form.value.other_transaction_terms = row.other_transaction_terms
    }
    // 单个提交本地数据进行审批
    const handleStatusData = async (row) => {
      const data = getFormData(row)
      setApiData([data])
    }
    // 权限用户批量处理审批
    const setApprovalAllData = () => {
      const json = allSelect.value.length ? allSelect.value.filter(o => o.status == 0) : tableData.value.filter(o => o.status == 0)
      if(json.length == 0){
        ElMessage.error('暂无可提交的数据')
      }
      handleApprovalDialog(json)
    }
    // 权限用户单个处理审批
    const handleApproval = async (row) => {
      if(row.status == 1) return ElMessage.error('该数据已通过审批，无需再重复审批')
      handleApprovalDialog([row])
    }
    // 权限用户审批时，弹窗询问是否确认
    const handleApprovalDialog = (data) => {
      ElMessageBox.confirm('是否确认审批？', '提示', {
        confirmButtonText: '通过',
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
    // 批量提交本地数据进行审批
    const setStatusAllData = () => {
      const json = allSelect.value.filter(o => !o.approval || o.status == 2)
      if(json.length == 0){
        return ElMessage.error('暂无可提交的数据')
      }
      const data = json.map(e => {
        return getFormData(e)
      })
      setApiData(data)
    }
    const getFormData = (e) => {
      const obj = {
        notice_id: e.notice_id,
        quote_id: e.quote_id,
        supplier_id: e.supplier_id,
        supplier_abbreviation: e.supplier_abbreviation,
        process_bom_id: e.process_bom_id,
        process_bom_children_id: e.process_bom_children_id,
        price: e.price,
        number: e.number,
        ment: e.ment,
        unit: e.unit,
        transaction_currency: e.transaction_currency,
        other_transaction_terms: e.other_transaction_terms,
        remarks: e.remarks,
        delivery_time: e.delivery_time
      }
      if(e.status == 2){
        obj.id = e.id
      }
      return obj
    }
    // 待审批时，文字变成红色
    const handleRowStyle = ({ row }) => {
      if(row.status == 0){
        return { color: 'red' }
      }
    }
    // 新增委外加工
    const addOutSourcing = () => {
      edit.value = 0;
      dialogVisible.value = true;
      resetForm()
    }
    // 取消弹窗
    const handleClose = () => {
      edit.value = 0;
      dialogVisible.value = false;
      resetForm()
    }
    // 用户主动多选，然后保存到allSelect
    const handleSelectionChange = (select) => {
      allSelect.value = JSON.parse(JSON.stringify(select))
    }
    const resetForm = () => {
      form.value = {
        notice_id: '',
        quote_id: '',
        supplier_id: '',
        supplier_abbreviation: '',
        process_bom_id: '',
        process_bom_children_id: '',
        price: '',
        number: '',
        ment: '',
        unit: '',
        transaction_currency: '',
        other_transaction_terms: '',
        remarks: '',
        delivery_time: ''
      }
    }
    const onPrint = async () => {
      const list = allSelect.value.length ? allSelect.value : tableData.value
      if(!list.length) return ElMessage.error('请选择需要打印的数据')
      const canPrintData = list.filter(o => o.status != undefined && o.status == 1)
      if(!canPrintData.length) return ElMessage.error('暂无可打印的数据或未审核通过')
      
      await getNoLast('TV')
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

    return() => (
      <>
        <ElCard>
          {{
            header: () => (
              <HeadForm headerWidth="270px" ref={ formCard }>
                {{
                  left: () => (
                    <>
                      <ElFormItem v-permission={ 'OutsourcingOrder:add' }>
                        <ElButton type="primary" onClick={ addOutSourcing } style={{ width: '100px' }}> 新增加工单 </ElButton>
                      </ElFormItem>
                      <ElFormItem v-permission={ 'OutsourcingOrder:set' }>
                        <ElButton type="primary" onClick={ setStatusAllData } style={{ width: '100px' }}> 批量提交 </ElButton>
                      </ElFormItem>
                      {
                        approval.findIndex(e => e.user_id == user.id) >= 0 ? 
                        <ElFormItem>
                          <ElButton type="primary" onClick={ () => setApprovalAllData() } style={{ width: '100px' }}> 批量审批 </ElButton>
                        </ElFormItem> : 
                        <></>
                      }
                      <ElFormItem v-permission={ 'OutsourcingOrder:print' }>
                        <ElButton type="primary" onClick={ () => onPrint() } style={{ width: '100px' }}> 加工单打印 </ElButton>
                      </ElFormItem>
                    </>
                  ),
                  center: () => (
                    <>
                      <ElFormItem label="生产订单号:">
                        <ElInput v-model={ search.value.notice } placeholder="请输入生产订单号" style={{ width: '192px' }} />
                      </ElFormItem>
                      <ElFormItem label="供应商编码:">
                        <ElInput v-model={ search.value.supplier_code } placeholder="请输入供应商编码" style={{ width: '192px' }} />
                      </ElFormItem>
                      <ElFormItem label="供应商名称:">
                        <ElInput v-model={ search.value.supplier_abbreviation } placeholder="请输入供应商名称" style={{ width: '192px' }} />
                      </ElFormItem>
                      <ElFormItem label="审批状态:">
                        <ElSelect v-model={ search.value.status } multiple={false} filterable remote remote-show-suffix clearable valueKey="id" placeholder="请选择审批状态" style={{ width: '192px' }}>
                          {statusList.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                        </ElSelect>
                      </ElFormItem>
                    </>
                  ),
                  right: () => (
                    <ElFormItem>
                      <ElButton type="primary" onClick={ () => fetchProductList() }>筛选</ElButton>
                    </ElFormItem>
                  )
                }}
              </HeadForm>
            ),
            default: () => (
              <>
                <ElTable data={ tableData.value } border stripe height={ `calc(100vh - ${formHeight.value + 224}px)` } rowStyle={ handleRowStyle } onSelectionChange={ (select) => handleSelectionChange(select) }>
                  <ElTableColumn type="selection" width="55" />
                  <ElTableColumn label="状态" width='80'>
                    {({row}) => {
                      const spanDom = <span>{ statusType[row.status] }</span>
                      return spanDom
                    }}
                  </ElTableColumn>
                  <ElTableColumn prop="notice.notice" label="生产订单号" width='100' />
                  <ElTableColumn prop="supplier.supplier_code" label="供应商编码" width='100' />
                  <ElTableColumn prop="supplier.supplier_abbreviation" label="供应商名称" width='100' />
                  <ElTableColumn prop="processBom.product.product_code" label="产品编码" width='100' />
                  <ElTableColumn prop="processBom.product.product_name" label="产品名称" width='100' />
                  <ElTableColumn prop="processBom.part.part_code" label="部位编码" width='100' />
                  <ElTableColumn prop="processBom.part.part_name" label="部位名称" width='100' />
                  <ElTableColumn prop="processChildren.process.process_code" label="工艺编码" width='100' />
                  <ElTableColumn prop="processChildren.process.process_name" label="工艺名称" width='100' />
                  <ElTableColumn prop="ment" label="加工要求" width='100' />
                  <ElTableColumn prop="unit" label="单位" width='80' />
                  <ElTableColumn prop="number" label="委外数量" width='100' />
                  <ElTableColumn prop="price" label="加工单价" width='90' />
                  <ElTableColumn prop="transaction_currency" label="交易币别" width='90' />
                  <ElTableColumn prop="other_transaction_terms" label="结算周期" width='100' />
                  <ElTableColumn prop="delivery_time" label="要求交期" width='120' />
                  <ElTableColumn prop="remarks" label="备注" width='100' />
                  <ElTableColumn label="操作" width="150" fixed="right">
                    {{
                      default: ({ row }) => {
                        let dom = []
                        if(row.status == undefined || row.status == 2){
                          dom.push(<>
                            <ElButton size="small" type="warning" v-permission={ 'OutsourcingOrder:edit' } onClick={ () => handleUplate(row) }>修改</ElButton>
                            <ElButton size="small" type="primary" v-permission={ 'OutsourcingOrder:set' } onClick={ () => handleStatusData(row) }>提交</ElButton>
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
                      <WinPrint printType="TV" url={ setPdfBlobUrl.value } printList={ printers.value } onClose={ () => printVisible.value = false } dataIds={ printDataIds.value } />
                    ),
                  }}
                </ElDialog>
                <div class="printTable" id='totalTable2'>
                  <div id="printTable">
                    <div class="No">编码：{ printNo.value }</div>
                    <table class="print-table">
                      <thead>
                        <tr>
                          <th colspan="11" class="title-cell">
                            <div class="popTitle" style={{ textAlign: 'center', fontSize: '36px' }}>委外加工单</div>
                          </th>
                        </tr>
                        <tr>
                          <th colspan="11" class="header-cell">
                            <div class="flex row-between print-header">
                              <div>供应商：{ supplierName.value }</div>
                              <div>产品编码：{ productName.value }</div>
                              <div>产品名称：{ productCode.value }</div>
                              <div>生产订单：{ noticeNumber.value }</div>
                            </div>
                          </th>
                        </tr>
                        <tr class="table-header">
                          <th>序号</th>
                          <th>状态</th>
                          <th>部件编码</th>
                          <th>部件名称</th>
                          <th>工艺编码</th>
                          <th>工艺名称</th>
                          <th>加工要求</th>
                          <th>单位</th>
                          <th>委外数量</th>
                          <th>加工单价</th>
                          <th>币别</th>
                          <th>要求交期</th>
                        </tr>
                      </thead>
                      <tbody>
                        {(allSelect.value.length ? allSelect.value : tableData.value).map((e, index) => {
                          const tr = <tr class="table-row">
                            <td>{ index + 1 }</td>
                            <td>{ statusType[e.status] }</td>
                            <td>{ e.processBom.part.part_code }</td>
                            <td>{ e.processBom.part.part_name }</td>
                            <td>{ e.processChildren.process.process_code }</td>
                            <td>{ e.processChildren.process.process_name }</td>
                            <td>{ e.ment }</td>
                            <td>{ e.unit }</td>
                            <td>{ e.number }</td>
                            <td>{ e.price }</td>
                            <td>{ e.transaction_currency }</td>
                            <td>{ e.delivery_time }</td>
                          </tr>
                          return tr
                        })}
                        <tr class="header-cell">
                          <td colspan="11">
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
        <ElDialog v-model={ dialogVisible.value } title={ edit.value ? '修改委外加工' : '新增委外加工' } width='785' center draggable onClose={ () => handleClose() }>
          {{
            default: () => (
              <ElForm class="ml30" model={ form.value } ref={ formRef } inline={ true } rules={ rules } label-width="95">
                <ElFormItem label="生产订单" prop="notice_id">
                  <ElSelect v-model={ form.value.notice_id } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择生产订单" onChange={ (value) => noticeChange(value) }>
                    {productNotice.value.map((e, index) => <ElOption value={ e.id } label={ e.notice } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="报价单" prop="quote_id">
                  <ElSelect v-model={ form.value.quote_id } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择报价单" onChange={ (value) => quoteChange(value) }>
                    {quoteList.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="工艺BOM" prop="process_bom_id">
                  <ElSelect v-model={ form.value.process_bom_id } multiple={ false } filterable remote remote-show-suffix valueKey="id" placeholder="请选择工艺BOM" onChange={(value) => changeBomSelect(value)}>
                    {bomList.value.map((e, index) => {
                      return <ElOption value={ e.id } label={ e.name } key={ index } />
                    })}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="工艺工序" prop="process_bom_children_id">
                  <ElSelect v-model={ form.value.process_bom_children_id } multiple={ false } filterable remote remote-show-suffix valueKey="id" placeholder="请选择工艺工序">
                    {procedure.value.map((e, index) => {
                      return <ElOption value={ e.id } label={ e.name } key={ index } />
                    })}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="供应商编码" prop="supplier_id">
                  <ElSelect v-model={ form.value.supplier_id } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择供应商编码">
                    {supplierInfo.value.map((e, index) => <ElOption value={ e.id } label={ e.supplier_code } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="供应商名称">
                  <el-input v-model={ form.value.supplier_abbreviation } readonly placeholder="请选择材料名称"></el-input>
                </ElFormItem>
                <ElFormItem label="加工单价" prop="price">
                  <ElInput v-model={ form.value.price } placeholder="请输入加工单价" />
                </ElFormItem>
                <ElFormItem label="交易币别" prop="transaction_currency">
                  <ElInput v-model={ form.value.transaction_currency } placeholder="请输入交易币别" />
                </ElFormItem>
                <ElFormItem label="委外数量" prop="number">
                  <ElInput v-model={ form.value.number } placeholder="请输入委外数量" />
                </ElFormItem>
                <ElFormItem label="单位" prop="unit">
                  <ElInput v-model={ form.value.unit } placeholder="请输入单位" />
                </ElFormItem>
                <ElFormItem label="加工要求" prop="ment">
                  <ElInput v-model={ form.value.ment } placeholder="请输入加工要求" />
                </ElFormItem>
                <ElFormItem label="交易条件" prop="other_transaction_terms">
                  <ElInput v-model={ form.value.other_transaction_terms } placeholder="请输入交易条件" />
                </ElFormItem>
                <ElFormItem label="要求交期" prop="delivery_time">
                  <ElDatePicker v-model={ form.value.delivery_time } value-format="YYYY-MM-DD" type="date" placeholder="请选择交期" clearable={ false } />
                </ElFormItem>
                <ElFormItem label="备注" prop="remarks">
                  <ElInput v-model={ form.value.remarks } placeholder="请输入备注" />
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
});