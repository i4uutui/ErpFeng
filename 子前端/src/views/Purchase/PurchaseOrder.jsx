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
    const user = getItem('user')
    const nowDate = ref()
    const formRef = ref(null);
    const formCard = ref(null)
    const formHeight = ref(0);
    const rules = reactive({
      supplier_id: [
        { required: true, message: '请选择供应商编码', trigger: 'blur' }
      ],
      notice_id: [
        { required: true, message: '请选择生产订单', trigger: 'blur' }
      ],
      material_bom_id: [
        { required: true, message: '请选择材料BOM', trigger: 'blur' }
      ]
    })
    const approval = getItem('approval').filter(e => e.type == 'material_warehouse')
    let dialogVisible = ref(false)
    let form = ref({
      quote_id: '',
      material_bom_id: '',
      material_bom_children_id: '',
      notice_id: '',
      notice: '',
      supplier_id: '',
      supplier_code: '',
      supplier_abbreviation: '',
      product_id: '',
      product_code: '',
      product_name: '',
      material_id: '',
      material_code: '',
      material_name: '',
      model_spec: '',
      other_features: '',
      unit: '',
      price: '',
      order_number: '',
      number: '',
      delivery_time: '',
    })
    let tableData = ref([])
    let allSelect = ref([])
    let edit = ref(-1)
    let search = ref({
      notice_number: '',
      supplier_code: '',
      supplier_abbreviation: '',
      product_code: '',
      product_name: '',
      status: ''
    })
    let supplierInfo = ref([]) // 供应商编码列表
    let proList = ref([]) // 产品编码列表
    let materialList = ref([]) // 材料编码列表
    let productNotice = ref([]) // 获取生产订单通知单列表
    let materialQuote = ref([]) // 报价单列表
    let materialBomList = ref([]) // 材料BOM表列表
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
      getPrinters() // 获取打印机列表

      fetchProductList() // 获取数据列表
      getSupplierInfo() // 供应商编码列表
      getProductNotice() // 获取生产通知单列表
      getMaterialQuote() // 获取报价单列表
      getMaterialBom() // 获取材料BOM
    })
    
    // 获取打印机列表
    const getPrinters = async () => {
      const res = await request.get('/api/printers')
      printers.value = res.data
    }
    // 获取数据列表
    const fetchProductList = async () => {
      const res = await request.get('/api/material_ment', { params: search.value });
      tableData.value = res.data;

      // 打印的时候用的
      if(!res.data.length) return
      const data = res.data[0]
      supplierName.value = data.supplier_abbreviation
      productName.value = data.product_name
      productCode.value = data.product_code
      noticeNumber.value = data.notice
    }
    // 获取供应商编码
    const getSupplierInfo = async () => {
      const res = await request.get('/api/getSupplierInfo')
      const data = res.data
      supplierInfo.value = data
    }
    // 获取生产通知单
    const getProductNotice = async () => {
      const res = await request.get('/api/getProductNotice')
      const data = { id: 0, notice: '非管控材料' }
      productNotice.value = [data, ...res.data]
    }
    // 获取报价单列表
    const getMaterialQuote = async () => {
      const res = await request.get('/api/getMaterialQuote')
      if(res.code == 200){
        materialQuote.value = res.data
      }
    }
    // 获取材料BOM列表
    const getMaterialBom = async () => {
      const res = await request.get('/api/getMaterialBom')
      if(res.code == 200){
        materialBomList.value = res.data
      }
    }
    // 获取材料BOM子数据列表
    const getMaterialBomChildren = async (id) => {
      const res = await request.get('/api/getMaterialBomChildren', { params: { id } })
      if(res.code == 200){
        if(res.data.length){
          const data = res.data.flatMap(item => ({
            ...item.material,
            material_bom_children_id: item.id,
            is_buy: item.is_buy
          }))
          materialList.value = data.length ? data : []
          // 默认让系统选中第一个材料
          if(materialList.value.length && !form.value.material_id){
            for(const item of materialList.value){
              if (item.is_buy == 0){
                form.value.material_bom_children_id = item.material_bom_children_id
                form.value.material_id = item.id
                form.value.material_code = item.material_code
                form.value.material_name = item.material_name
                form.value.model_spec = `${item.model}/${item.specification}`
                form.value.other_features = item.other_features
                break;
              }
            }
          }
        }
      }
    }
    const arr = [{ is_buy: 1 }, { is_buy: 1 }, { is_buy: 0 }, { is_buy: 1 }]
    // 获取产品列表
    const getProductsList = async (id) => {
      const res = await request.get('/api/getProductsCode', { params: { id } })
      proList.value = res.data

      if(id == 0) return
      form.value.product_id = id
      form.value.product_code = res.data[0].product_code
      form.value.product_name = res.data[0].product_name
    }
    // 弹窗确认按钮
    const handleSubmit = async (formEl) => {
      if (!formEl) return
      await formEl.validate(async (valid, fields) => {
        if (valid){
          if(edit.value === -1){
            const obj = JSON.parse(JSON.stringify(form.value))
            obj.id = getRandomString() // 临时ID
            console.log(obj);
            tableData.value = [obj, ...tableData.value]
            // 重置
            dialogVisible.value = false;
          }else{
            if(form.value.status){
              // 修改
              const myForm = {
                id: edit.value,
                ...form.value
              }
              const res = await request.put('/api/material_ment', myForm);
              if(res && res.code == 200){
                ElMessage.success('修改成功');
                dialogVisible.value = false;
                fetchProductList();
                reportOperationLog({
                  operationType: 'update',
                  module: '采购单',
                  desc: `修改采购单，供应商编码：${myForm.supplier_code}，生产订单号：${myForm.notice}，产品编码：${myForm.product_code}，材料编码：${myForm.material_code}`,
                  data: { newData: myForm }
                })
              }
            }else{
              const obj = JSON.parse(JSON.stringify(form.value))
              tableData.value = tableData.value.map(o => {
                if(o.id == edit.value){
                  return obj
                }
                return o
              })
              // 重置
              dialogVisible.value = false;
            }
          }
        }
      })
    }
    // 权限用户处理反审批接口
    const handleBackApproval = (row) => {
      ElMessageBox.confirm('是否确认反审批？', '提示', {
        confirmButtonText: '通过',
        cancelButtonText: '拒绝',
        type: 'warning',
        distinguishCancelAndClose: true,
      }).then(async () => {
        const res = await request.post('/api/handlePurchaseBackFlow', { id: row.id })
        if(res.code == 200){
          ElMessage.success('反审批成功')
          fetchProductList()

          const str = `供应商编码：${row.supplier_code}，生产订单号：${row.notice}，产品编码：${row.product_code}，材料编码：${row.material_code}`
          reportOperationLog({
            operationType: 'backApproval',
            module: '采购单',
            desc: `反审批了采购单，${str}`,
            data: { newData: row.id }
          })
        }
      }).catch((action) => {
        
      })
    }
    // 权限用户处理审批接口
    const approvalApi = async (action, data) => {
      const dataIds = data.map(e => e.id)
      const res = await request.post('/api/handlePurchaseApproval', {
        data: dataIds,
        action
      })
      if(res.code == 200){
        ElMessage.success('审批成功')
        fetchProductList()

        let str = ''
        data.forEach((e, index) => {
          const obj = `{ 供应商编码：${e.supplier_code}，生产订单号：${e.notice}，产品编码：${e.product_code}，材料编码：${e.material_code} }`
          str += obj
          if(index < data.length - 1){
            str += '，'
          }
        })
        const appValue = action == 1 ? '通过' : '拒绝'
        reportOperationLog({
          operationType: 'approval',
          module: '采购单',
          desc: `审批${appValue}了采购单，它们有：${str}`,
          data: { newData: { data, type: 'purchase_order' } }
        })
      }
    }
    // 提交数据审核接口
    const setApiData = async (data) => {
      const res = await request.post('/api/add_material_ment', { data, type: 'purchase_order' })
      if(res && res.code == 200){
        ElMessage.success('提交成功');
        fetchProductList();

        let str = ''
        data.forEach((e, index) => {
          const obj = `{ 供应商编码：${e.supplier_code}，生产订单号：${e.notice}，产品编码：${e.product_code}，材料编码：${e.material_code} }`
          str += obj
          if(index < data.length - 1){
            str += '，'
          }
        })
        reportOperationLog({
          operationType: 'keyApproval',
          module: '采购单',
          desc: `采购单提交审核：${str}`,
          data: { newData: { data, type: 'purchase_order' } }
        })
      }
    }
    // 权限用户单个处理审批
    const handleApproval = async (row) => {
      if(row.status == 1) return ElMessage.error('该数据已通过审批，无需再重复审批')
      handleApprovalDialog([row])
    }
    // 权限用户批量处理审批
    const setApprovalAllData = () => {
      const json = allSelect.value.length ? allSelect.value.filter(o => o.status == 0) : tableData.value.filter(o => o.status == 0)
      if(json.length == 0){
        ElMessage.error('暂无可提交的数据')
      }
      handleApprovalDialog(json)
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
    // 单个提交本地数据进行审批
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
        quote_id: e.quote_id,
        material_bom_children_id: e.material_bom_children_id,
        material_bom_id: e.material_bom_id,
        notice_id: e.notice_id,
        notice: e.notice,
        supplier_id: e.supplier_id,
        supplier_code: e.supplier_code,
        supplier_abbreviation: e.supplier_abbreviation,
        product_id: e.product_id,
        product_code: e.product_code,
        product_name: e.product_name,
        material_id: e.material_id,
        material_code: e.material_code,
        material_name: e.material_name,
        model_spec: e.model_spec,
        other_features: e.other_features,
        unit: e.unit,
        price: e.price,
        order_number: e.order_number,
        number: e.number,
        delivery_time: e.delivery_time,
      }
      if(e.status == 2){
        obj.id = e.id
      }
      return obj
    }
    // 修改采购单
    const handleUplate = (row) => {
      edit.value = row.id;
      dialogVisible.value = true;
      form.value = { ...row };
      console.log(form.value);
      getProductsList(row.product_id !== 0 ? row.product_id : '')
      getMaterialBomChildren(row.material_bom_id)
    }
    // 新增采购单
    const addOutSourcing = () => {
      edit.value = -1;
      dialogVisible.value = true;
      resetForm()
    }
    // 取消弹窗
    const handleClose = () => {
      edit.value = -1;
      dialogVisible.value = false;
      resetForm()
    }
    const resetForm = () => {
      form.value = {
        quote_id: '',
        material_bom_id: '',
        material_bom_children_id: '',
        notice_id: '',
        notice: '',
        supplier_id: '',
        supplier_code: '',
        supplier_abbreviation: '',
        product_id: '',
        product_code: '',
        product_name: '',
        material_id: '',
        material_code: '',
        material_name: '',
        model_spec: '',
        other_features: '',
        unit: '',
        price: '',
        order_number: '',
        number: '',
        delivery_time: '',
      }
    }
    // 待审批时，文字变成红色
    const handleRowStyle = ({ row }) => {
      if(row.status == 0){
        return { color: 'red' }
      }
    }
    // 用户主动多选，然后保存到allSelect
    const handleSelectionChange = (select) => {
      allSelect.value = JSON.parse(JSON.stringify(select))
    }
    // 生产订单选中后返回的数据
    const noticeChange = (value) => {
      if(value === 0){
        getProductsList()
        return
      }
      const notice = productNotice.value.find(e => e.id == value)
      form.value.notice = notice.notice
      form.value.number = notice.sale.order_number
      form.value.delivery_time = notice.delivery_time
      getProductsList(notice.product_id)
    }
    // 材料BOM选中后返回的数据
    const materialBomChange = (value) => {
      // 重新选择材料BOM的话，需要重置材料数据
      form.value.material_id = ''
      form.value.material_code = ''
      form.value.material_name = ''
      materialList.value = []
      getMaterialBomChildren(value)
    }
    // 报价单选中后返回的数据
    const quoteChange = (value) => {
      const row = materialQuote.value.find(o => o.id == value)
      if(!form.value.material_bom_id){
        form.value.material_id = row.material_id
        form.value.material_code = row.material.material_code
        form.value.material_name = row.material.material_name
      }
      form.value.supplier_id = row.supplier_id
      form.value.supplier_code = row.supplier.supplier_code
      form.value.supplier_abbreviation = row.supplier.supplier_abbreviation
      form.value.price = row.price
      form.value.unit = row.unit
    }
    // 材料编码选择后返回的数据
    const materialChange = (value) => {
      const material = materialList.value.find(e => e.id == value)
      form.value.material_bom_children_id = material.material_bom_children_id
      form.value.material_code = material.material_code
      form.value.material_name = material.material_name
      form.value.model_spec = `${material.model}/${material.specification}`
      form.value.other_features = material.other_features
      form.value.unit = material.usage_unit
    }
    const supplierChange = (value) => {
      const supplier = supplierInfo.value.find(e => e.id == value)
      form.value.supplier_code = supplier.supplier_code
      form.value.supplier_abbreviation = supplier.supplier_abbreviation
    }
    // 执行打印
    const onPrint = async () => {
      const list = allSelect.value.length ? allSelect.value : tableData.value
      if(!list.length) return ElMessage.error('请选择需要打印的数据')
      const canPrintData = list.filter(o => o.status != undefined && o.status == 1)
      if(!canPrintData.length) return ElMessage.error('暂无可打印的数据或未审核通过')
      
      await getNoLast('ES')
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
                      <ElFormItem v-permission={ 'PurchaseOrder:add' }>
                        <ElButton type="primary" onClick={ addOutSourcing } style={{ width: '100px' }}> 新增采购单 </ElButton>
                      </ElFormItem>
                      <ElFormItem v-permission={ 'PurchaseOrder:set' }>
                        <ElButton type="primary" onClick={ setStatusAllData } style={{ width: '100px' }}> 批量提交 </ElButton>
                      </ElFormItem>
                      {
                        approval.findIndex(e => e.user_id == user.id) >= 0 ? 
                        <ElFormItem>
                          <ElButton type="primary" onClick={ () => setApprovalAllData() } style={{ width: '100px' }}> 批量审批 </ElButton>
                        </ElFormItem> : 
                        <></>
                      }
                      <ElFormItem v-permission={ 'PurchaseOrder:print' }>
                        <ElButton type="primary" onClick={ () => onPrint() } style={{ width: '100px' }}> 采购单打印 </ElButton>
                      </ElFormItem>
                    </>
                  ),
                  center: () => (
                    <>
                      <ElFormItem label="生产订单号:">
                        <ElInput v-model={ search.value.notice_number } placeholder="请输入生产订单号" style={{ width: '192px' }} />
                      </ElFormItem>
                      <ElFormItem label="供应商编码:">
                        <ElInput v-model={ search.value.supplier_code } placeholder="请输入供应商编码" style={{ width: '192px' }} />
                      </ElFormItem>
                      <ElFormItem label="供应商名称:">
                        <ElInput v-model={ search.value.supplier_abbreviation } placeholder="请输入供应商名称" style={{ width: '192px' }} />
                      </ElFormItem>
                      <ElFormItem label="产品编码:">
                        <ElInput v-model={ search.value.product_code } placeholder="请输入产品编码" style={{ width: '192px' }} />
                      </ElFormItem>
                      <ElFormItem label="产品名称:">
                        <ElInput v-model={ search.value.product_name } placeholder="请输入产品名称" style={{ width: '192px' }} />
                      </ElFormItem>
                      <ElFormItem label="审批状态:">
                        <ElSelect v-model={ search.value.status } multiple={false} filterable remote remote-show-suffix clearable valueKey="id" placeholder="请选择审批状态" style={{ width: '192px' }}>
                          {statusList.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                        </ElSelect>
                      </ElFormItem>
                    </>
                  ),
                  right: () => (
                    <>
                      <ElFormItem>
                        <ElButton type="primary" onClick={ () => fetchProductList() }>查询</ElButton>
                      </ElFormItem>
                    </>
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
                  <ElTableColumn prop="notice" label="生产订单号" width='100'>
                    {({row}) => row.notice_id == 0 ? '非管控材料' : row.notice}
                  </ElTableColumn>
                  <ElTableColumn prop="supplier_code" label="供应商编码" width='100' />
                  <ElTableColumn prop="supplier_abbreviation" label="供应商名称" width='100' />
                  <ElTableColumn prop="product_code" label="产品编码" width='100' />
                  <ElTableColumn prop="product_name" label="产品名称" width='120' />
                  <ElTableColumn prop="material_code" label="材料编码" width='100' />
                  <ElTableColumn prop="material_name" label="材料名称" width='100' />
                  <ElTableColumn prop="model_spec" label="型号&规格" width='100' />
                  <ElTableColumn prop="other_features" label="其它特性" width='100' />
                  <ElTableColumn prop="unit" label="采购单位" width='100' />
                  <ElTableColumn prop="price" label="采购单价" width='100' />
                  {/* <ElTableColumn prop="order_number" label="预计数量" width='100' /> */}
                  <ElTableColumn prop="number" label="采购数量" width='100' />
                  <ElTableColumn prop="delivery_time" label="交货时间" width='110' />
                  <ElTableColumn prop="apply_name" label="申请人" width="90" />
                  <ElTableColumn prop="apply_time" label="申请时间" width="110" />
                  <ElTableColumn label="操作" width="150" fixed="right">
                    {{
                      default: ({ row }) => {
                        let dom = []
                        if(row.status == undefined || row.status == 2){
                          dom.push(<>
                            <ElButton size="small" type="default" v-permission={ 'PurchaseOrder:edit' } onClick={ () => handleUplate(row) }>修改</ElButton>
                            <ElButton size="small" type="primary" v-permission={ 'PurchaseOrder:set' } onClick={ () => handleStatusData(row) }>提交</ElButton>
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
                      <WinPrint printType="ES" url={ setPdfBlobUrl.value } printList={ printers.value } onClose={ () => printVisible.value = false } dataIds={ printDataIds.value } />
                    ),
                  }}
                </ElDialog>
                <div class="printTable" id='totalTable2'>
                  <div id="printTable">
                    <div class="No">编码：{ printNo.value }</div>
                    <table class="print-table">
                      <thead>
                        <tr>
                          <th colspan="10" class="title-cell">
                            <div class="popTitle" style={{ textAlign: 'center', fontSize: '36px' }}>采购单</div>
                          </th>
                        </tr>
                        <tr>
                          <th colspan="10" class="header-cell">
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
                          <th>材料编码</th>
                          <th>材料名称</th>
                          <th>型号&规格</th>
                          <th>其它特性</th>
                          <th>采购单位</th>
                          <th>采购单价</th>
                          <th>采购数量</th>
                          <th>交货时间</th>
                        </tr>
                      </thead>
                      <tbody>
                        {(allSelect.value.length ? allSelect.value : tableData.value).map((e, index) => {
                          const tr = <tr class="table-row">
                            <td>{ index + 1 }</td>
                            <td>{ statusType[e.status] }</td>
                            <td>{ e.material_code }</td>
                            <td>{ e.material_name }</td>
                            <td>{ e.model_spec }</td>
                            <td>{ e.other_features }</td>
                            <td>{ e.unit }</td>
                            <td>{ e.price }</td>
                            <td>{ e.number }</td>
                            <td>{ e.delivery_time }</td>
                          </tr>
                          return tr
                        })}
                        <tr class="header-cell">
                          <td colspan="10">
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
        <ElDialog v-model={ dialogVisible.value } title={ edit.value ? '修改采购单' : '新增采购单' } onClose={ () => handleClose() }>
          {{
            default: () => (
              <ElForm model={ form.value } ref={ formRef } inline={ true } rules={ rules } label-width="110px">
                <ElFormItem label="生产订单" prop="notice_id">
                  <ElSelect v-model={ form.value.notice_id } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择生产订单" onChange={ (row) => noticeChange(row) }>
                    {productNotice.value.map((e, index) => <ElOption value={ e.id } label={ e.notice } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="材料BOM" prop="material_bom_id">
                  <ElSelect v-model={ form.value.material_bom_id } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择材料BOM" onChange={ (row) => materialBomChange(row) }>
                    {materialBomList.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="报价单" prop="quote_id">
                  <ElSelect v-model={ form.value.quote_id } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择报价单" onChange={ (value) => quoteChange(value) }>
                    {materialQuote.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="交货时间" prop="delivery_time">
                  <ElDatePicker v-model={ form.value.delivery_time } value-format="YYYY-MM-DD" type="date" placeholder="请选择交货时间" clearable={ false } />
                </ElFormItem>
                <ElFormItem label="产品编码" prop="product_id">
                  <ElSelect v-model={ form.value.product_id } multiple={ false } filterable remote remote-show-suffix valueKey="id" placeholder="请选择产品编码" onChange={ (row) => productChange(row) }>
                    {proList.value.map((e, index) => {
                      return <ElOption value={ e.id } label={ e.product_code } key={ index } />
                    })}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="产品名称" prop="product_id">
                  <el-input v-model={ form.value.product_name } readonly placeholder="请选择产品名称"></el-input>
                </ElFormItem>
                <ElFormItem label="材料编码" prop="material_id">
                  <ElSelect v-model={ form.value.material_id } multiple={ false } filterable remote remote-show-suffix valueKey="id" placeholder="请选择材料编码" onChange={ (row) => materialChange(row) }>
                    {materialList.value.map((e, index) => {
                      return <ElOption value={ e.id } label={ e.material_code } key={ index } disabled={ e.is_buy == 1 ? true : false } />
                    })}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="材料名称" prop="material_id">
                  <el-input v-model={ form.value.material_name } readonly placeholder="请选择材料名称"></el-input>
                </ElFormItem>
                <ElFormItem label="供应商编码" prop="supplier_id">
                  <ElSelect v-model={ form.value.supplier_id } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择供应商编码" onChange={ (row) => supplierChange(row) }>
                    {supplierInfo.value.map((e, index) => <ElOption value={ e.id } label={ e.supplier_code } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="供应商名称" prop="supplier_id">
                  <el-input v-model={ form.value.supplier_abbreviation } readonly placeholder="请选择供应商名称"></el-input>
                </ElFormItem>
                <ElFormItem label="型号&规格" prop="model_spec">
                  <ElInput v-model={ form.value.model_spec } placeholder="请输入型号&规格" />
                </ElFormItem>
                <ElFormItem label="其它特性" prop="other_features">
                  <ElInput v-model={ form.value.other_features } placeholder="请输入其它特性" />
                </ElFormItem>
                <ElFormItem label="采购单价" prop="price">
                  <ElInput v-model={ form.value.price } placeholder="请输入采购单价" />
                </ElFormItem>
                <ElFormItem label="采购单位" prop="unit">
                  <ElInput v-model={ form.value.unit } placeholder="请输入采购单位" />
                </ElFormItem>
                {/* <ElFormItem label="预计数量" prop="order_number">
                  <ElInput v-model={ form.value.order_number } disabled placeholder="请输入预计数量" />
                </ElFormItem> */}
                <ElFormItem label="采购数量" prop="number">
                  <ElInput v-model={ form.value.number } placeholder="请输入采购数量" />
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