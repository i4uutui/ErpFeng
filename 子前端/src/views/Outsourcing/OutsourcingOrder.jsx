import { defineComponent, ref, onMounted, reactive } from 'vue';
import { getItem } from "@/assets/js/storage";
import { getRandomString } from '@/utils/tool'
import request from '@/utils/request';
import dayjs from "dayjs"
import "@/assets/css/print.scss"
import "@/assets/css/landscape.scss"
import { reportOperationLog } from '@/utils/log';
import html2pdf from 'html2pdf.js';
import WinPrint from '@/components/print/winPrint';

export default defineComponent({
  setup() {
    const statusType = reactive({
      0: '待审批',
      1: '已通过',
      2: '已拒绝'
    })
    const statusList = ref([{ id: 0, name: '待审批' }, { id: 1, name: '已通过' }, { id: 2, name: '已拒绝' }])
    const approval = getItem('approval').filter(e => e.type == 'material_warehouse')
    const user = getItem('user')
    const nowDate = ref()
    const formRef = ref(null);
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
      supplier_id: '',
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
    let tableData = ref([])
    let isPrint = ref(false)
    let allSelect = ref([])
    let edit = ref(0)
    let notice_number = ref('')
    let supplier_code = ref('')
    let product_code = ref('')
    let noticeList = ref([])
    let supplierList = ref([])
    let productList = ref([])
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
    let statusId = ref('')
    
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
    
    onMounted(() => {
      nowDate.value = dayjs().format('YYYY-MM-DD HH:mm:ss')
      fetchProductList()
      getProcessBomList() // 工艺Bom列表
      getSupplierInfo() // 供应商编码列表
      getProductNotice() // 获取生产订单通知单列表

      getPrinters()
    })
    
    const getPrinters = async () => {
      const res = await request.get('/api/printers')
      printers.value = res.data
    }
    // 获取列表
    const fetchProductList = async () => {
      const res = await request.post('/api/outsourcing_order', {
        notice: notice_number.value,
        supplier_code: supplier_code.value,
        product_code: product_code.value,
        status: statusId.value,
      });
      tableData.value = res.data;
      getNoticeList() //获取订单号用来筛选

      // 打印的时候用的
      if(res.data.length){
        const data = res.data[0]
        supplierName.value = data.supplier.supplier_abbreviation
        productName.value = data.processBom.product.product_name
        productCode.value = data.processBom.product.product_code
        noticeNumber.value = data.notice.notice
      }
    }
    const getNoticeList = async () => {
      const res = await request.get('/api/getOutsourcingQuote')
      noticeList.value = Array.from(res.data.map(e => e.notice) .reduce((map, item) => {
        map.set(item.notice, item);
        return map;
      }, new Map()).values())
      supplierList.value = Array.from(res.data.map(e => e.supplier) .reduce((map, item) => {
        map.set(item.supplier_code, item);
        return map;
      }, new Map()).values())
      productList.value = Array.from(res.data.map(e => e.processBom.product).reduce((map, item) => {
        map.set(item.product_code, item)
        return map;
      }, new Map()).values())
    }
    const getProcessBomList = async () => {
      const res = await request.get('/api/getProcessBom')
      bomList.value = res.data
    }
    const getSupplierInfo = async () => {
      const res = await request.get('/api/getSupplierInfo')
      supplierInfo.value = res.data
    }
    const getProcessBomChildren = async (value) => {
      const res = await request.get(`/api/getProcessBomChildren?process_bom_id=${value}`)
      procedure.value = res.data
    }
    const getProductNotice = async () => {
      const res = await request.get('/api/getProductNotice')
      productNotice.value = res.data
    }
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
    const handleStatusData = async (row) => {
      const data = getFormData(row)
      setApiData([data])
    }
    // 批量提交本地数据进行审批
    const setStatusAllData = () => {
      const json = allSelect.value.length ? allSelect.value.filter(o => !o.approval || o.status == 2) : tableData.value.filter(o => !o.approval || o.status == 2)
      if(json.length == 0){
        ElMessage.error('暂无可提交的数据')
      }
      const data = json.map(e => {
        return getFormData(e)
      })
      setApiData(data)
    }
    const getFormData = (e) => {
      const obj = {
        notice_id: e.notice_id,
        supplier_id: e.supplier_id,
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
    // 反审批
    const handleBackApproval = async (row) => {
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
    }
    // 处理审批
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
    const changeBomSelect = (value) => {
      procedure.value = []
      form.value.process_bom_children_id = ''
      getProcessBomChildren(value)
    }
    const handleUplate = (row) => {
      edit.value = row.id;
      dialogVisible.value = true;
      form.value = { ...row };
      getProcessBomChildren(row.process_bom_id)
    }
    // 用户主动多选，然后保存到allSelect
    const handleSelectionChange = (select) => {
      allSelect.value = JSON.parse(JSON.stringify(select))
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
    const resetForm = () => {
      form.value = {
        notice_id: '',
        supplier_id: '',
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

    return() => (
      <>
        <ElCard>
          {{
            header: () => (
              <ElForm inline={ true } class="cardHeaderFrom">
                <ElFormItem v-permission={ 'OutsourcingOrder:add' }>
                  <ElButton style="margin-top: -5px" type="primary" onClick={ addOutSourcing }> 新增委外加工单 </ElButton>
                </ElFormItem>
                <ElFormItem v-permission={ 'OutsourcingOrder:set' }>
                  <ElButton style="margin-top: -5px" type="primary" onClick={ setStatusAllData }> 批量提交 </ElButton>
                </ElFormItem>
                {
                  approval.findIndex(e => e.user_id == user.id) >= 0 ? 
                  <ElFormItem>
                    <ElButton style="margin-top: -5px" type="primary" onClick={ () => setApprovalAllData() }> 批量审批 </ElButton>
                  </ElFormItem> : 
                  <></>
                }
                <ElFormItem v-permission={ 'OutsourcingOrder:print' }>
                  <ElButton style="margin-top: -5px" type="primary" onClick={ () => onPrint() }> 委外加工单打印 </ElButton>
                </ElFormItem>
                <ElFormItem label="生产订单号:">
                  <ElSelect v-model={ notice_number.value } multiple={false} filterable remote remote-show-suffix clearable valueKey="id" placeholder="请选择生产订单号">
                    {noticeList.value.map((e, index) => <ElOption value={ e.notice } label={ e.notice } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="供应商编码:">
                  <ElSelect v-model={ supplier_code.value } multiple={false} filterable remote remote-show-suffix clearable valueKey="id" placeholder="请选择供应商编码">
                    {supplierList.value.map((e, index) => <ElOption value={ e.supplier_code } label={ e.supplier_code } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="产品编码:">
                  <ElSelect v-model={ product_code.value } multiple={false} filterable remote remote-show-suffix clearable valueKey="id" placeholder="请选择产品编码">
                    {productList.value.map((e, index) => <ElOption value={ e.product_code } label={ e.product_code } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="审批状态:">
                  <ElSelect v-model={ statusId.value } multiple={false} filterable remote remote-show-suffix clearable valueKey="id" placeholder="请选择审批状态">
                    {statusList.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem>
                  <ElButton style="margin-top: -5px" type="primary" onClick={ () => fetchProductList() }>筛选</ElButton>
                </ElFormItem>
              </ElForm>
            ),
            default: () => (
              <>
                <ElTable data={ tableData.value } border stripe rowStyle={ handleRowStyle } onSelectionChange={ (select) => handleSelectionChange(select) }>
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
                  <ElTableColumn prop="processBom.part.part_code" label="部位编码" width='100' />
                  <ElTableColumn prop="processBom.part.part_name" label="部位名称" width='100' />
                  <ElTableColumn prop="processChildren.process.process_code" label="工艺编码" width='100' />
                  <ElTableColumn prop="processChildren.process.process_name" label="工艺名称" width='100' />
                  <ElTableColumn prop="ment" label="加工要求" width='100' />
                  <ElTableColumn prop="unit" label="单位" width='80' />
                  <ElTableColumn prop="number" label="委外数量" width='100' />
                  <ElTableColumn prop="price" label="加工单价" width='90' />
                  <ElTableColumn prop="transaction_currency" label="交易币别" width='90' />
                  <ElTableColumn prop="other_transaction_terms" label="交易条件" width='100' />
                  <ElTableColumn prop="delivery_time" label="要求交期" width='120' />
                  <ElTableColumn prop="remarks" label="备注" width='100' />
                  <ElTableColumn label="操作" width="150" fixed="right">
                    {{
                      default: ({ row }) => {
                        let dom = []
                        if(row.status == undefined || row.status == 2){
                          dom.push(<>
                            <ElButton size="small" type="default" v-permission={ 'OutsourcingOrder:edit' } onClick={ () => handleUplate(row) }>修改</ElButton>
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
        <ElDialog v-model={ dialogVisible.value } title={ edit.value ? '修改委外加工' : '新增委外加工' } onClose={ () => handleClose() }>
          {{
            default: () => (
              <ElForm model={ form.value } ref={ formRef } inline={ true } rules={ rules } label-width="110px">
                <ElFormItem label="供应商编码" prop="supplier_id">
                  <ElSelect v-model={ form.value.supplier_id } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择供应商编码">
                    {supplierInfo.value.map((e, index) => <ElOption value={ e.id } label={ e.supplier_code } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="生产订单" prop="notice_id">
                  <ElSelect v-model={ form.value.notice_id } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择生产订单">
                    {productNotice.value.map((e, index) => <ElOption value={ e.id } label={ e.notice } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="工艺BOM" prop="process_bom_id">
                  <ElSelect v-model={ form.value.process_bom_id } multiple={ false } filterable remote remote-show-suffix valueKey="id" placeholder="请选择工艺BOM" onChange={ (value) => changeBomSelect(value) }>
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
                <ElFormItem label="加工单价" prop="price">
                  <ElInput v-model={ form.value.price } placeholder="请输入加工单价" />
                </ElFormItem>
                <ElFormItem label="委外数量" prop="number">
                  <ElInput v-model={ form.value.number } placeholder="请输入委外数量" />
                </ElFormItem>
                <ElFormItem label="加工要求" prop="ment">
                  <ElInput v-model={ form.value.ment } placeholder="请输入加工要求" />
                </ElFormItem>
                <ElFormItem label="单位" prop="unit">
                  <ElInput v-model={ form.value.unit } placeholder="请输入单位" />
                </ElFormItem>
                <ElFormItem label="交易币别" prop="transaction_currency">
                  <ElInput v-model={ form.value.transaction_currency } placeholder="请输入交易币别" />
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
                <ElButton onClick={ handleClose }>取消</ElButton>
                <ElButton type="primary" onClick={ () => handleSubmit(formRef.value) }>确定</ElButton>
              </span>
            )
          }}
        </ElDialog>
      </>
    )
  }
});