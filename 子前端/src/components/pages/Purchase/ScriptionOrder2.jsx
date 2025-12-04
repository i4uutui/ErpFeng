import { defineComponent, onMounted, reactive, ref, nextTick, watch } from 'vue'
import { getPageHeight, isEmptyValue } from '@/utils/tool'
import { reportOperationLog } from '@/utils/log';
import { getItem } from '@/assets/js/storage';
import request from '@/utils/request';
import HeadForm from '@/components/form/HeadForm';

export default defineComponent({
  setup() {
    const user = getItem('user')
    const statusType = reactive({
      0: '待审批',
      1: '已通过',
      2: '已拒绝',
      3: '已反审',
      4: '待提交'
    })
    const statusList = ref([{ id: 0, name: '待审批' }, { id: 1, name: '已通过' }, { id: 2, name: '已拒绝' }, { id: 3, name: '已反审' }, { id: 4, name: '待提交' }])
    const calcUnit = ref(getItem('constant').filter(o => o.type == 'calcUnit'))
    const approval = getItem('approval').filter(e => e.type == 'purchase_order')
    // 找到当前这个用户在这个页面中是否有审批权限
    const approvalUser = approval.find(e => e.user_id == user.id)
    const formHeight = ref(0);
    const formCard = ref(null)
    const formRef = ref(null)
    const rules = ref({
      notice_id: [
        { required: true, message: '请选择生产订单', trigger: 'blur' }
      ],
      material_bom_id: [
        { required: true, message: '请选择材料BOM', trigger: 'change' }
      ],
    })

    let form = ref({
      notice_id: '',
      material_bom_id: '',
      seq_id: '',
      quote_id: '',
      delivery_time: '',
      product_id: '',
      material_id: '',
      material_code: '',
      material_name: '',
      supplier_id: '',
      model_spec: '',
      other_features: '',
      price: '',
      unit: '',
      usage_unit: '',
      number: '',
    })
    let dialogVisible = ref(false)
    let productNotice = ref([]) // 获取生产订单通知单列表
    let materialBomList = ref([]) // 获取材料BOM列表
    let materialQuote = ref([]) // 获取报价单列表
    let proList = ref([]) // 产品编码列表
    let materialList = ref([]) // 材料编码列表
    let supplierInfo = ref([]) // 获取供应商列表
    let allSelect = ref([])
    let tableData = ref([])
    let search = ref({
      notice_number: '',
      supplier_code: '',
      supplier_abbreviation: '',
      product_code: '',
      product_name: '',
      status: '',
    })
    let edit = ref(false)

    onMounted(() => {
      nextTick(async () => {
        formHeight.value = await getPageHeight([formCard.value]);
      })

      fetchProductList() // 获取数据列表

      setTimeout(() => {
        getProductNotice()
        getMaterialQuote()
        getSupplierInfo()
      }, 500);
    })

    // 获取数据列表
    const fetchProductList = async () => {
      const res = await request.get('/api/material_ment', { params: search.value });
      tableData.value = res.data
    }
    // 获取生产通知单
    const getProductNotice = async () => {
      const res = await request.get('/api/getProductNotice')
      const data = { id: 0, notice: '非管控材料' }
      productNotice.value = [data, ...res.data]
    }
    // 获取材料BOM列表
    const getMaterialBom = async (product_id) => {
      const res = await request.get('/api/getMaterialBom', { params: { product_id } })
      if(res.code == 200){
        materialBomList.value = res.data
      }
    }
    // 获取材料BOM列表2.0
    const getMaterialBom2 = async (product_id) => {
      const res = await request.get('/api/getMaterialBom2', { params: { product_id } })
      if(res.code == 200){
        materialBomList.value = res.data
      }
    }
    // 获取报价单列表
    const getMaterialQuote = async () => {
      const res = await request.get('/api/getMaterialQuote')
      if(res.code == 200){
        materialQuote.value = res.data
      }
    }
    // 获取产品列表
    const getProductsList = async (value) => {
      const res = await request.get('/api/getProductsCode')
      proList.value = res.data
      if(value === 0){
        form.value.product_id = res.data[0].id
      }
    }
    // 获取材料列表
    const getMaterialCode = async (value) => {
      const res = await request.get('/api/getMaterialCode')
      if(res.code == 200){
        materialList.value = res.data.map(item => ({ ...item, is_show: false }))
        if(value === 0){
          form.value.material_id = res.data[0].id
        }
      }
    }
    // 获取供应商编码
    const getSupplierInfo = async () => {
      const res = await request.get('/api/getSupplierInfo')
      supplierInfo.value = res.data
    }
    // 获取材料BOM子数据列表
    const getMaterialBomChildren = async (id) => {
      const res = await request.get('/api/getMaterialBomChildren', { params: { id } })
      if(res.code == 200){
        const data = res.data.flatMap(item => ({
          ...item.material,
          id: item.material_id,
          is_buy: item.is_buy,
          seq_id: item.id
        }))
        materialList.value = data
        for(const item of data){
          if (item.is_buy == 0){
            form.value.seq_id = item.seq_id // 工序ID
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
    // 弹窗确认按钮
    const handleSubmit = async (formEl) => {
      if (!formEl) return
      await formEl.validate(async (valid, fields) => {
        if(valid){
          if(edit.value){
            if(form.value.notice_id == 0){
              const res = await request.post('/api/add_material_row', form.value)
              if(res.code == 200){
                ElMessage.success('新增成功')
                dialogVisible.value = false
                fetchProductList()
              }
            }else{
              const res = await request.post('/api/add_material_more', form.value)
              if(res.code == 200){
                ElMessage.success('新增成功')
                dialogVisible.value = false
                fetchProductList()
              }
            }
          }else{
            const res = await request.put('/api/material_ment', form.value)
            if(res.code == 200){
              ElMessage.success('修改成功')
              dialogVisible.value = false
              fetchProductList()
            }
          }
        }
      })
    }
    // 提交数据审核接口
    const setApiData = (data) => {
      ElMessageBox.confirm('是否确认提交审批？', '提示', {
        confirmButtonText: '确认',
        cancelButtonText: '取消',
        cancelButtonClass: 'el-button--warning',
        type: 'warning',
        distinguishCancelAndClose: true,
      }).then(async () => {
        const res = await request.post('/api/add_material_ment', { data, type: 'purchase_order' })
        if(res && res.code == 200){
          ElMessage.success('提交成功');
          fetchProductList();

          reportOperationLog({
            operationType: 'keyApproval',
            module: '采购作业',
            desc: `采购作业提交审核：${data}`,
            data: { newData: { data, type: 'purchase_order' } }
          })
        }
      }).catch((action) => {})
    }
    // 权限用户处理审批接口
    const approvalApi = async (action, data) => {
      const res = await request.post('/api/handlePurchaseApproval', {
        data,
        action
      })
      if(res.code == 200){
        ElMessage.success('审批成功')
        fetchProductList()

        const appValue = action == 1 ? '通过' : '拒绝'
        reportOperationLog({
          operationType: 'approval',
          module: '采购作业',
          desc: `审批${appValue}了采购作业，id为：${data}`,
          data: { newData: { data, type: 'purchase_order' } }
        })
      }
    }
    // 确认采购单
    const handlePurchaseIsBuying = async (data) => {
      const res = await request.post('/api/handlePurchaseIsBuying', { data })
      if(res.code == 200){
        ElMessage.success('采购单确认成功')
        fetchProductList()

        reportOperationLog({
          operationType: 'approval',
          module: '采购作业',
          desc: `采购单确认成功，id为：${data}`,
          data: { newData: { data, type: 'purchase_order' } }
        })
      }
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

          reportOperationLog({
            operationType: 'approval',
            module: '采购作业',
            desc: `反审批采购作业，id为：${row.id}`,
            data: { newData: { data, type: 'purchase_order' } }
          })
        }
      }).catch((action) => {
        
      })
    }
    // 删除按钮
    const handleDelete = async (row) => {
      ElMessageBox.confirm('是否确认删除？删除后不可恢复', '提示', {
        confirmButtonText: '确认',
        cancelButtonText: '取消',
        cancelButtonClass: 'el-button--warning',
        type: 'warning',
        distinguishCancelAndClose: true,
      }).then(async () => {
        const res = await request.delete(`/api/del_material_row/${row.id}`)
        if(res.code == 200){
          ElMessage.success('删除成功')
          fetchProductList()

          reportOperationLog({
            operationType: 'approval',
            module: '采购作业',
            desc: `删除成功采购作业，id为：${row.id}`,
            data: { newData: { data, type: 'purchase_order' } }
          })
        }
      }).catch((action) => {
        
      })
    }

    // 单个提交
    const handleStatusData = (row) => {
      setApiData([row.id])
    }
    // 批量提交
    const setStatusAllData = () => {
      if(!allSelect.value.length) return ElMessage.error('请选择要提交的数据')
      const all = allSelect.value.filter(o => [2, 3, 4].includes(o.status))
      if(!all.length) return ElMessage.error('暂无可提交的数据')
      
      const ids = all.map(o => o.id)
      setApiData(ids)
    }
    // 权限用户单个处理审批
    const handleApproval = async (row) => {
      if([2,3,4].includes(row.status)) return ElMessage.error('该采购作业未提交审批，无法审批')
      if(row.status == 1) return ElMessage.error('该作业已经审批通过')
      handleApprovalDialog([row.id])
    }
    // 权限用户批量处理审批
    const setApprovalAllData = () => {
      if(!allSelect.value.length) return ElMessage.error('请选择要审批的数据')
      const all = allSelect.value.filter(o => o.status == 0)
      if(!all.length) return ElMessage.error('暂无可审批的数据，请检查')
      
      const ids = all.map(o => o.id) 
      handleApprovalDialog(ids)
    }
    // 权限用户审批，弹窗询问
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
    // 单个确认采购单
    const handleProcurement = (row) => {
      if(row.status != 1) return ElMessage.error('该作业未审批通过，不能确认采购单')
      if(row.is_buying != 1) return ElMessage.error('不能重复生成采购单')
      handlePurchaseIsDialog([row.id])
    }
    // 批量确认采购单
    const handleProcurementAll = () => {
      if(!allSelect.value.length) return ElMessage.error('请选择要确认的数据')
      const all = allSelect.value.filter(o => o.status == 1)
      if(!all.length) return ElMessage.error('暂无可确认的数据，请检查')
      
      const ids = all.map(o => o.id) 
      handlePurchaseIsDialog(ids)
    }
    // 确认采购单，弹窗询问
    const handlePurchaseIsDialog = (data) => {
      ElMessageBox.confirm('是否确认采购单？', '提示', {
        confirmButtonText: '确认',
        cancelButtonText: '取消',
        cancelButtonClass: 'el-button--warning',
        type: 'warning',
        distinguishCancelAndClose: true,
      }).then(() => {
        handlePurchaseIsBuying(data)
      }).catch(() => {})
    }
    // 修改弹窗
    const handleUplate = (row) => {
      form.value = row
      edit.value = false
      dialogVisible.value = true
      if(row.notice_id == 0){
        getMaterialBom()
        getProductsList()
        getMaterialCode()
      }else{
        getMaterialBom2()
        getProductsList(row.product_id)
        getMaterialBomChildren(row.material_bom_id)
      }
    }
    // 新增
    const addOutSourcing = () => {
      dialogVisible.value = true
      edit.value = true
    }
    // 关闭弹窗后
    const handleClose = () => {
      dialogVisible.value = false
      materialList.value = []
      proList.value = []
      form.value = {
        notice_id: '',
        material_bom_id: '',
        seq_id: '',
        quote_id: '',
        delivery_time: '',
        product_id: '',
        material_id: '',
        material_code: '',
        material_name: '',
        model_spec: '',
        other_features: '',
        price: '',
        unit: '',
        usage_unit: '',
        number: '',
      }
    }
    // 监听form表单中的notice_id
    watch(() => form.value.notice_id, (newValue, oldValue) => {
      if(oldValue == 0){
        reseForm()
      }
    })
    // 生产订单选中后返回的数据
    const noticeChange = (value) => {
      if(value == 0){
        if(rules.value.material_bom_id && rules.value.material_bom_id.length){
          delete rules.value.material_bom_id
        }
        const ruleObj = {
          material_id: [
            { required: true, message: '请选择材料编码', trigger: 'change' }
          ],
          supplier_id: [
            { required: true, message: '请选择供应商编码', trigger: 'change' }
          ],
          number: [
            { required: true, message: '请输入采购数量', trigger: 'blur' }
          ]
        }
        rules.value = { ...rules.value, ...ruleObj }
        getProductsList(value)
        getMaterialCode(value)
        getMaterialBom()
      }else{
        if(rules.value.material_id && rules.value.material_id.length){
          delete rules.value.material_id
        }
        if(rules.value.supplier_id && rules.value.supplier_id.length){
          delete rules.value.supplier_id
        }
        if(rules.value.number && rules.value.number.length){
          delete rules.value.number
        }
        const ruleObj = {
          material_bom_id: [
            { required: true, message: '请选择材料BOM', trigger: 'blur' }
          ],
        }
        rules.value = { ...rules.value, ...ruleObj }
        const row = productNotice.value.find(o => o.id == value)
        getProductsList(value)
        getMaterialBom2()
      }
    }
    // 重置弹窗的表单
    const reseForm = () => {
      form.value.material_bom_id = ''
      form.value.seq_id = ''
      form.value.quote_id = ''
      form.value.delivery_time = ''
      form.value.product_id = ''
      form.value.material_id = ''
      form.value.material_code = ''
      form.value.material_name = ''
      form.value.supplier_id = ''
      form.value.model_spec = ''
      form.value.other_features = ''
      form.value.price = ''
      form.value.unit = ''
      form.value.usage_unit = ''
      form.value.number = ''
    }
    // 选择材料BOM后
    const materialBomChange = (value) => {
      if(form.value.notice_id == 0){
        form.value.material_id = ''
        form.value.material_code = ''
        form.value.material_name = ''
        materialList.value = []
        getMaterialBomChildren(value)
      }
    }
    // 选择报价单后
    const quoteChange = (value) => {
      const row = materialQuote.value.find(o => o.id == value)
      if(!form.value.material_bom_id){
        form.value.material_id = row.material_id
        form.value.material_code = row.material.material_code
        form.value.material_name = row.material.material_code
      }
      form.value.supplier_id = row.supplier_id
      form.value.price = row.price
      form.value.unit = Number(row.unit)
      form.value.usage_unit = Number(row.material.usage_unit)
    }
    // 选择产品编码后
    const productChange = (value) => {

    }
    // 选择材料编码后
    const materialChange = (value) => {
      const material = materialList.value.find(e => e.id == value)
      form.value.material_code = material.material_code
      form.value.material_name = material.material_name
      form.value.model_spec = material.model
      form.value.other_features = material.other_features
      form.value.unit = Number(material.purchase_unit)
      form.value.usage_unit = Number(material.usage_unit)
      if(form.value.notice_id != 0){
        form.value.seq_id = material.seq_id
      }
    }
    // 选择供应商后
    const supplierChange = (value) => {}
    // 用户主动多选，然后保存到allSelect
    const handleSelectionChange = (select) => {
      allSelect.value = JSON.parse(JSON.stringify(select))
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
                <ElTable data={ tableData.value } border stripe height={ `calc(100vh - ${formHeight.value + 234}px)` } rowStyle={ handleRowStyle } onSelectionChange={ (select) => handleSelectionChange(select) }>
                  <ElTableColumn type="selection" width="55" />
                  <ElTableColumn label="状态" width='80'>
                    {({row}) => {
                      if(!isEmptyValue(row)){
                        if(row.is_buying == 0){
                          return '已采购'
                        }
                        if([1, 3, 4].includes(row.status)) return <span>{ statusType[row.status] }</span>
                        
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
                  <ElTableColumn label="生产订单号" width='100'>
                    {({row}) => row.notice_id == 0 ? '非管控材料' : row.notice.notice}
                  </ElTableColumn>
                  <ElTableColumn prop="supplier.supplier_code" label="供应商编码" width='100' />
                  <ElTableColumn prop="supplier.supplier_abbreviation" label="供应商名称" width='100' />
                  <ElTableColumn prop="product.product_code" label="产品编码" width='100' />
                  <ElTableColumn prop="product.product_name" label="产品名称" width='120' />
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
                          const isStatusValid = status === 2 || status === 3 || status == 4;
                          const isRowStatus = isUserApplied && isStatusValid;

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
                          if(row.status == 4){
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
        <ElDialog v-model={ dialogVisible.value } title={ edit.value ? '新增采购作业' : '修改采购作业' } width='785' center draggable onClose={ () => handleClose() }>
          {{
            default: () => (
              <ElForm class="ml30" model={ form.value } ref={ formRef } inline={ true } rules={ rules.value } label-width="95">
                <ElFormItem label="生产订单" prop="notice_id">
                  <ElSelect disabled={ !edit.value } v-model={ form.value.notice_id } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择生产订单" onChange={ (row) => noticeChange(row) }>
                    {productNotice.value.map((e, index) => <ElOption value={ e.id } label={ e.notice } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="材料BOM" prop="material_bom_id">
                  <ElSelect disabled={ !edit.value } v-model={ form.value.material_bom_id } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择材料BOM" onChange={ (row) => materialBomChange(row) }>
                    {materialBomList.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="报价单" prop="quote_id">
                  <ElSelect disabled={ edit.value && form.value.notice_id != 0 } v-model={ form.value.quote_id } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择报价单" onChange={ (value) => quoteChange(value) }>
                    {materialQuote.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="交货时间" prop="delivery_time">
                  <ElDatePicker disabled={ edit.value && form.value.notice_id != 0 } v-model={ form.value.delivery_time } value-format="YYYY-MM-DD" type="date" placeholder="请选择交货时间" clearable={ false }  style={{ width: "100%" }} />
                </ElFormItem>
                <ElFormItem label="产品编码">
                  <ElSelect disabled={ edit.value && form.value.notice_id != 0 } v-model={ form.value.product_id } multiple={ false } filterable remote remote-show-suffix valueKey="id" placeholder="请选择产品编码" onChange={ (row) => productChange(row) }>
                    {proList.value.map((e, index) => {
                      return <ElOption value={ e.id } label={ e.product_code } key={ index } />
                    })}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="产品名称">
                  <ElSelect class={ form.value.notice_id != 0 ? '' : 'disabled' } disabled v-model={ form.value.product_id } multiple={ false } filterable remote remote-show-suffix  valueKey="id" placeholder="请选择产品名称">
                    {proList.value.map((e, index) => {
                      return <ElOption value={ e.id } label={ e.product_name } key={ index } />
                    })}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="材料编码" prop="material_id">
                  <ElSelect disabled={ edit.value && form.value.notice_id != 0 } v-model={ form.value.material_id } multiple={ false } filterable remote remote-show-suffix valueKey="id" placeholder="请选择材料编码" onChange={ (row) => materialChange(row) }>
                    {materialList.value.map((e, index) => {
                      return <ElOption value={ e.id } label={ e.material_code } key={ index } disabled={ e.is_buy == 1 ? true : false } />
                    })}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="材料名称">
                  <ElSelect class={ form.value.notice_id != 0 ? '' : 'disabled' } disabled v-model={ form.value.material_id } multiple={ false } filterable remote remote-show-suffix valueKey="id" placeholder="请选择材料名称">
                    {materialList.value.map((e, index) => {
                      return <ElOption value={ e.id } label={ e.material_name } key={ index } disabled={ e.is_buy == 1 ? true : false } />
                    })}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="供应商编码" prop="supplier_id">
                  <ElSelect disabled={ edit.value && form.value.notice_id != 0 } v-model={ form.value.supplier_id } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择供应商编码" onChange={ (row) => supplierChange(row) }>
                    {supplierInfo.value.map((e, index) => <ElOption value={ e.id } label={ e.supplier_code } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="供应商名称">
                  <ElSelect class={ form.value.notice_id != 0 ? '' : 'disabled' } disabled v-model={ form.value.supplier_id } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择供应商名称">
                    {supplierInfo.value.map((e, index) => <ElOption value={ e.id } label={ e.supplier_abbreviation } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="型号&规格" prop="model_spec">
                  <ElInput disabled={ edit.value && form.value.notice_id != 0 } v-model={ form.value.model_spec } placeholder="请输入型号&规格" />
                </ElFormItem>
                <ElFormItem label="其它特性" prop="other_features">
                  <ElInput disabled={ edit.value && form.value.notice_id != 0 } v-model={ form.value.other_features } placeholder="请输入其它特性" />
                </ElFormItem>
                <ElFormItem label="采购单价" prop="price">
                  <ElInput disabled={ edit.value && form.value.notice_id != 0 } v-model={ form.value.price } placeholder="请输入采购单价" />
                </ElFormItem>
                <ElFormItem label="采购单位" prop="unit">
                  <ElSelect disabled={ edit.value && form.value.notice_id != 0 } v-model={ form.value.unit } multiple={ false } filterable remote remote-show-suffix placeholder="请选择采购单位">
                    {calcUnit.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="使用单位" prop="usage_unit">
                  <ElSelect disabled={ edit.value && form.value.notice_id != 0 } v-model={ form.value.usage_unit } multiple={ false } filterable remote remote-show-suffix placeholder="请选择使用单位">
                    {calcUnit.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="采购数量" prop="number">
                  <ElInput disabled={ edit.value && form.value.notice_id != 0 } v-model={ form.value.number } placeholder="请输入采购数量" />
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