import { defineComponent, onMounted, reactive, ref, computed, nextTick } from 'vue'
import { useStore } from '@/stores';
import { getRandomString, getNoLast, getPageHeight, isEmptyValue } from '@/utils/tool'
import { reportOperationLog } from '@/utils/log';
import { getItem } from '@/assets/js/storage';
import request from '@/utils/request';
import dayjs from "dayjs"
import HeadForm from '@/components/form/HeadForm';

export default defineComponent({
  setup() {
    const store = useStore()
    const statusType = reactive({
      0: '待审批',
      1: '已通过',
      2: '已拒绝',
      3: '已反审'
    })
    const statusList = ref([{ id: 0, name: '待审批' }, { id: 1, name: '已通过' }, { id: 2, name: '已拒绝' }, { id: 3, name: '已反审' }])
    const user = getItem('user')
    const nowDate = ref()
    const formRef = ref(null);
    const formCard = ref(null)
    const formHeight = ref(0);
    const calcUnit = ref(getItem('constant').filter(o => o.type == 'calcUnit'))
    const rules = ref({
      supplier_id: [
        { required: true, message: '请选择供应商编码', trigger: 'blur' }
      ],
      notice_id: [
        { required: true, message: '请选择生产订单', trigger: 'blur' }
      ],
      material_bom_id: [
        { required: true, message: '请选择材料BOM', trigger: 'blur' }
      ],
      material_id: [
        { required: true, message: '请选择材料编码', trigger: 'blur' }
      ],
      number: [
        { required: true, message: '请输入采购数量', trigger: 'blur' }
      ]
    })
    const approval = getItem('approval').filter(e => e.type == 'purchase_order')
    // 找到当前这个用户在这个页面中是否有审批权限
    const approvalUser = approval.find(e => e.user_id == user.id)
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
      usage_unit: '',
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
    let mergedTable = ref([]) // 打印前合并后的数据

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
      // getMaterialBom() // 获取材料BOM
    })
    
    // 获取打印机列表
    const getPrinters = async () => {
      const res = await request.get('/api/printers')
      printers.value = res.data
    }
    // 获取数据列表
    const fetchProductList = async () => {
      const res = await request.get('/api/material_ment', { params: search.value });
      tableData.value = res.data.map(e => {
        e.unit = e.unit ? Number(e.unit) : e.unit
        e.usage_unit = e.usage_unit ? Number(e.usage_unit) : e.usage_unit
        return e
      });

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
    const getMaterialBom = async (product_id) => {
      const res = await request.get('/api/getMaterialBom', { params: { product_id } })
      if(res.code == 200){
        materialBomList.value = res.data
      }
    }
    // 获取材料列表
    const getMaterialCode = async () => {
      const res = await request.get('/api/getMaterialCode')
      if(res.code == 200){
        materialList.value = res.data.map(item => ({ ...item, is_show: false }))
      }
    }
    // 获取材料BOM子数据列表
    const getMaterialBomChildren = async (id) => {
      const res = await request.get('/api/getMaterialBomChildren', { params: { id } })
      if(res.code == 200){
        if(res.data.length){
          let materialKeyId = []
          // 筛选出用户新增的临时数据
          const list = tableData.value.filter(o => !o.status)
          if(list.length){
            list.forEach(e => {
              // 查一下当前用户新增时选择的生产订单&材料BOM，之前新增的临时数据是否有
              if(e.notice_id == form.value.notice_id && e.material_bom_id == form.value.material_bom_id){
                materialKeyId.push(e.material_id)
              }
            })
          }

          const data = res.data.flatMap(item => ({
            ...item.material,
            material_bom_children_id: item.id,
            is_buy: (item.is_buy == 1 || materialKeyId.includes(item.material_id)) ? 1 : 0
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
                form.value.model_spec = item.model
                form.value.other_features = item.other_features
                form.value.unit = Number(item.purchase_unit)
                form.value.usage_unit = Number(item.usage_unit)
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
      if(form.value.notice_id == 0){
        form.value.product_id = ''
        form.value.product_code = ''
        form.value.product_name = ''
        return
      }
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
                  module: '采购作业',
                  desc: `修改采购作业，供应商编码：${myForm.supplier_code}，生产订单号：${myForm.notice}，产品编码：${myForm.product_code}，材料编码：${myForm.material_code}`,
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
        confirmButtonText: '确认',
        cancelButtonText: '取消',
        cancelButtonClass: 'el-button--warning',
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
            module: '采购作业',
            desc: `反审批了采购作业，${str}`,
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
          module: '采购作业',
          desc: `审批${appValue}了采购作业，它们有：${str}`,
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
          module: '采购作业',
          desc: `采购作业提交审核：${str}`,
          data: { newData: { data, type: 'purchase_order' } }
        })
      }
    }
    // 采购单确认接口调用
    const handlePurchaseIsBuying = async (ids) => {
      if(!ids.length) return ElMessage.error('请选择采购作业')
      const res = await request.post('/api/handlePurchaseIsBuying', { ids })
      if(res.code == 200){
        ElMessage.success('采购单确认成功')
        fetchProductList();
      }
    }
    // 批量采购单确认
    const handleProcurementAll = () => {
      const json = allSelect.value.filter(e => e.status && e.status == 1 && e.is_buying == 1 && e.apply_id == user.id)
      if(!json.length) return ElMessage.error('暂无可操作确认的数据')
      const ids = json.map(e => e.id)

      ElMessageBox.confirm('是否确认采购单？', '提示', {
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
    // 单个采购单确认
    const handleProcurement = (row) => {
      if(!row.status || row.status != 1) return ElMessage.error("该作业未审批通过，请提交审批")
      if(row.is_buying != 1) return ElMessage.error('不能重复生成采购单')
      const ids = [row.id]
    
      ElMessageBox.confirm('是否确认采购单？', '提示', {
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
      ElMessageBox.confirm('是否通过审批？', '提示', {
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
    // 单个提交本地数据进行审批
    const handleStatusData = async (row) => {
      for(let key in row){
        if(row[key] === '' || row[key] === undefined || row[key] === null){
          row[key] = null
        }
      }
      const data = getFormData(row)
      setApiData([data])
    }
    // 批量提交本地数据进行审批
    const setStatusAllData = () => {
      const json = allSelect.value.filter(o => !o.approval || o.status == 2 || o.status == 3)
      if(json.length == 0){
        return ElMessage.error('暂无可提交的数据')
      }
      const data = json.map(e => {
        for(let key in e){
          if(e[key] === '' || e[key] === undefined || e[key] === null){
            e[key] = null
          }
        }
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
        usage_unit: e.usage_unit,
        price: e.price,
        order_number: e.order_number,
        number: e.number,
        delivery_time: e.delivery_time,
        approval: e.approval?.length ? e.approval.map(e => e.id) : []
      }
      if(e.status == 2 || e.status == 3){
        obj.id = e.id
      }
      return obj
    }
    // 修改采购作业
    const handleUplate = (row) => {
      edit.value = row.id;
      dialogVisible.value = true;
      form.value = { ...row };
      setRules(form.value.notice_id)
      getProductsList(row.product_id !== 0 ? row.product_id : '')
      getMaterialBom(row.product_id !== 0 ? row.product_id : '')
      getMaterialBomChildren(row.material_bom_id)
    }
    // 新增采购作业
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
        usage_unit: '',
        price: '',
        order_number: '',
        number: '',
        delivery_time: '',
      }
    }
    // 用户主动多选，然后保存到allSelect
    const handleSelectionChange = (select) => {
      allSelect.value = JSON.parse(JSON.stringify(select))
    }
    // 生产订单选中后返回的数据
    const noticeChange = (value) => {
      setRules(value)
      if(value === 0){
        form.value.product_id = ''
        form.value.product_code = ''
        form.value.product_name = ''
        getProductsList()
        getMaterialBom()
        return
      }
      const notice = productNotice.value.find(e => e.id == value)
      form.value.notice = notice.notice
      form.value.number = notice.sale.order_number
      form.value.delivery_time = notice.delivery_time
      getProductsList(notice.product_id)
      getMaterialBom(notice.product_id)
    }
    const setRules = (value) => {
      if(value == 0){
        getMaterialCode()
        if(rules.value.material_bom_id && rules.value.material_bom_id.length){
          delete rules.value.material_bom_id
        }
      }else{
        rules.value.material_bom_id = [
          { required: true, message: '请选择材料BOM', trigger: 'blur' }
        ]
      }
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
      form.value.unit = Number(row.unit)
      form.value.usage_unit = Number(row.material.usage_unit)
    }
    // 材料编码选择后返回的数据
    const materialChange = (value) => {
      const material = materialList.value.find(e => e.id == value)
      form.value.material_bom_children_id = material.material_bom_children_id
      form.value.material_code = material.material_code
      form.value.material_name = material.material_name
      form.value.model_spec = material.model
      form.value.other_features = material.other_features
      form.value.unit = material.purchase_unit
      form.value.usage_unit = material.usage_unit
    }
    const supplierChange = (value) => {
      const supplier = supplierInfo.value.find(e => e.id == value)
      form.value.supplier_code = supplier.supplier_code
      form.value.supplier_abbreviation = supplier.supplier_abbreviation
    }
    const productChange = (value) => {
      const row = proList.value.find(o => o.id == value)
      form.value.product_id = row.id
      form.value.product_code = row.product_code
      form.value.product_name = row.product_name
    }
    // 删除
    const handleDelete = (row, index) => {
      tableData.value.splice(index, 1)
    }
    const setMerged = (arr) => {
      const mergedMap = new Map();

      // 遍历数组，合并重复项
      arr.forEach(item => {
        // 生成唯一键：用连字符连接两个关键字段，避免冲突
        const key = `${item.supplier_id}-${item.material_id}`;
        
        if (mergedMap.has(key)) {
          // 已存在重复项：累加 number
          const existingItem = mergedMap.get(key);
          mergedMap.set(key, {
            ...existingItem,
            number: Number(existingItem.number) + Number(item.number)
          });
        } else {
          // 不存在：直接存入 Map
          mergedMap.set(key, { ...item });
        }
      });
      // 步骤3：将 Map 的值转换为最终数组（按插入顺序排列）
      return Array.from(mergedMap.values());
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
        <ElCard>
          {{
            header: () => (
              <HeadForm headerWidth="270px" ref={ formCard }>
                {{
                  left: () => (
                    <>
                      <ElFormItem v-permission={ 'ScriptionOrder:add' }>
                        <ElButton type="primary" onClick={ addOutSourcing } style={{ width: '100px' }}> 新增采购作业 </ElButton>
                      </ElFormItem>
                      <ElFormItem v-permission={ 'ScriptionOrder:set' }>
                        <ElButton type="primary" onClick={ setStatusAllData } style={{ width: '100px' }}> 批量提交 </ElButton>
                      </ElFormItem>
                      {
                        !isEmptyValue(approvalUser) ? 
                        <ElFormItem>
                          <ElButton type="primary" onClick={ () => setApprovalAllData() } style={{ width: '100px' }}> 批量审批 </ElButton>
                        </ElFormItem> : 
                        <></>
                      }
                      <ElFormItem v-permission={ 'ScriptionOrder:buy' }>
                        <ElButton type="primary" onClick={ () => handleProcurementAll() } style={{ width: '100px' }}> 批量确认 </ElButton>
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
                      if(!isEmptyValue(row)){
                        if(row.is_buying == 0){
                          return '已采购'
                        }
                        if(row.status == 1 || row.status == 3) return <span>{ statusType[row.status] }</span>
                        
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
                  <ElTableColumn label="采购单位" width='100'>
                    {({row}) => <span>{ calcUnit.value.find(e => e.id == row.unit)?.name }</span>}
                  </ElTableColumn>
                  <ElTableColumn label="使用单位" width='100'>
                    {({row}) => <span>{ calcUnit.value.find(e => e.id == row.usage_unit)?.name }</span>}
                  </ElTableColumn>
                  <ElTableColumn prop="price" label="采购单价" width='100' />
                  <ElTableColumn prop="number" label="采购数量" width='100' />
                  <ElTableColumn prop="delivery_time" label="交货时间" width='110' />
                  <ElTableColumn prop="apply_name" label="申请人" width="90" />
                  <ElTableColumn prop="apply_time" label="申请时间" width="110" />
                  <ElTableColumn label="操作" width="200" fixed="right">
                    {{
                      default: ({ row, $index }) => {
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
                                <ElButton size="small" type="warning" v-permission={ 'ScriptionOrder:edit' } onClick={ () => handleUplate(row) }>修改</ElButton>
                                <ElButton size="small" type="primary" v-permission={ 'ScriptionOrder:set' } onClick={ () => handleStatusData(row) }>提交</ElButton>
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
                            dom.push(<ElButton size="small" type="primary"  v-permission={ 'ScriptionOrder:buy' } onClick={ () => handleProcurement(row) }>采购单确认</ElButton>)
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
        <ElDialog v-model={ dialogVisible.value } title={ edit.value ? '修改采购作业' : '新增采购作业' } width='785' center draggable onClose={ () => handleClose() }>
          {{
            default: () => (
              <ElForm class="ml30" model={ form.value } ref={ formRef } inline={ true } rules={ rules.value } label-width="95">
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
                  <ElDatePicker v-model={ form.value.delivery_time } value-format="YYYY-MM-DD" type="date" placeholder="请选择交货时间" clearable={ false }  style={{ width: "100%" }} />
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
                <ElFormItem label="材料名称">
                  <el-input v-model={ form.value.material_name } readonly placeholder="请选择材料名称"></el-input>
                </ElFormItem>
                <ElFormItem label="供应商编码" prop="supplier_id">
                  <ElSelect v-model={ form.value.supplier_id } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择供应商编码" onChange={ (row) => supplierChange(row) }>
                    {supplierInfo.value.map((e, index) => <ElOption value={ e.id } label={ e.supplier_code } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="供应商名称">
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
                  <ElSelect v-model={ form.value.unit } multiple={ false } filterable remote remote-show-suffix placeholder="请选择采购单位">
                    {calcUnit.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="使用单位" prop="usage_unit">
                  <ElSelect v-model={ form.value.usage_unit } multiple={ false } filterable remote remote-show-suffix placeholder="请选择使用单位">
                    {calcUnit.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="采购数量" prop="number">
                  <ElInput v-model={ form.value.number } placeholder="请输入采购数量" />
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