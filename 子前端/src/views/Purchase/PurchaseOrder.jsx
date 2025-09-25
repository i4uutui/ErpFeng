import { defineComponent, ref, onMounted, reactive } from 'vue';
import { getItem } from "@/assets/js/storage";
import { getRandomString } from '@/utils/tool'
import request from '@/utils/request';
import dayjs from "dayjs"
import "@/assets/css/print.scss"
import "@/assets/css/landscape.scss"

export default defineComponent({
  setup() {
    const statusType = reactive({
      0: '待审批',
      1: '已通过',
      2: '已拒绝'
    })
    const statusList = ref([{ id: 0, name: '待审批' }, { id: 1, name: '已通过' }, { id: 2, name: '已拒绝' }])
    const user = getItem('user')
    const nowDate = ref()
    const formRef = ref(null);
    const rules = reactive({
      supplier_id: [
        { required: true, message: '请选择供应商编码', trigger: 'blur' }
      ],
    })
    const approval = getItem('approval').filter(e => e.type == 'material_warehouse')
    let dialogVisible = ref(false)
    let form = ref({
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
    let proList = ref([]) // 产品编码列表
    let materialList = ref([]) // 材料编码列表
    let productNotice = ref([]) // 获取生产订单通知单列表
    // 用来打印用的
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
      getProductsList() // 产品编码列表
      getMaterialCode() // 材料编码列表
      getSupplierInfo() // 供应商编码列表
      getProductNotice() // 获取生产订单通知单列表
    })
    
    // 获取列表
    const fetchProductList = async () => {
      const res = await request.post('/api/material_ment', {
        notice: notice_number.value,
        supplier_code: supplier_code.value,
        product_code: product_code.value,
        status: statusId.value,
      });
      tableData.value = res.data;
      getNoticeList() //获取订单号用来筛选

      // 打印的时候用的
      const data = res.data[0]
      supplierName.value = data.supplier_abbreviation
      productName.value = data.product_name
      productCode.value = data.product_code
      noticeNumber.value = data.notice
    }
    const getNoticeList = async () => {
      const res = await request.get('/api/getMaterialMent')
      noticeList.value = Array.from(res.data.map(e => e.notice) .reduce((map, item) => {
        map.set(item, item);
        return map;
      }, new Map()).values())
      supplierList.value = Array.from(res.data.map(e => e.supplier_code) .reduce((map, item) => {
        map.set(item, item);
        return map;
      }, new Map()).values())
      productList.value = Array.from(res.data.map(e => e.product_code).reduce((map, item) => {
        map.set(item, item)
        return map;
      }, new Map()).values())
    }
    const getProductsList = async () => {
      const res = await request.get('/api/getProductsCode')
      proList.value = res.data
    }
    const getMaterialCode = async () => {
      const res = await request.get(`/api/getMaterialCode`)
      materialList.value = res.data
    }
    const getSupplierInfo = async () => {
      const res = await request.get('/api/getSupplierInfo')
      supplierInfo.value = res.data
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
              const res = await request.put('/api/outsourcing_order', myForm);
              if(res && res.code == 200){
                ElMessage.success('修改成功');
                dialogVisible.value = false;
                fetchProductList();
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
    const setApiData = async (data) => {
      const res = await request.post('/api/add_material_ment', { data, type: 'purchase_order' })
      if(res && res.code == 200){
        ElMessage.success('提交成功');
        fetchProductList();
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
    // 反审批
    const handleBackApproval = async ({ id }) => {
      const res = await request.post('/api/handlePurchaseBackFlow', { id })
      if(res.code == 200){
        ElMessage.success('反审批成功')
        fetchProductList()
      }
    }
    // 处理审批
    const approvalApi = async (action, data) => {
      const res = await request.post('/api/handlePurchaseApproval', {
        data,
        action
      })
      if(res.code == 200){
        ElMessage.success('审批成功')
        fetchProductList()
      }
    }
    const handleApproval = async (row) => {
      if(row.status == 1) return ElMessage.error('该数据已通过审批，无需再重复审批')
      const data = [row.id]
      handleApprovalDialog(data)
    }
    // 批量处理审批
    const setApprovalAllData = () => {
      const json = allSelect.value.length ? allSelect.value.filter(o => o.status == 0) : tableData.value.filter(o => o.status == 0)
      if(json.length == 0){
        ElMessage.error('暂无可提交的数据')
      }
      const data = json.map(e => e.id)
      handleApprovalDialog(data)
    }
    const handleApprovalDialog = (data) => {
      ElMessageBox.confirm('是否确认审批？', '提示', {
        confirmButtonText: '提交',
        cancelButtonText: '取消',
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
    const handleUplate = (row) => {
      edit.value = row.id;
      dialogVisible.value = true;
      form.value = { ...row };
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
    const supplierChange = (value) => {
      const supplier = supplierInfo.value.find(e => e.id == value)
      form.value.supplier_code = supplier.supplier_code
      form.value.supplier_abbreviation = supplier.supplier_abbreviation
    }
    const noticeChange = (value) => {
      const notice = productNotice.value.find(e => e.id == value)
      form.value.notice = notice.notice
      form.value.product_id = notice.product_id
      form.value.product_code = notice.product.product_code
      form.value.product_name = notice.product.product_name
      form.value.order_number = notice.sale.order_number
      form.value.number = notice.sale.order_number
      form.value.delivery_time = notice.sale.delivery_time
    }
    const productChange = (value) => {
      const product = proList.value.find(e => e.id == value)
      form.value.product_code = product.product_code
      form.value.product_name = product.product_name
    }
    const materialChange = (value) => {
      const material = materialList.value.find(e => e.id == value)
      form.value.material_code = material.material_code
      form.value.material_name = material.material_name
      form.value.model_spec = `${material.model}/${material.specification}`
      form.value.other_features = material.other_features
      form.value.unit = material.usage_unit
    }
    
    return() => (
      <>
        <ElCard>
          {{
            header: () => (
              <ElForm inline={ true } class="cardHeaderFrom">
                <ElFormItem v-permission={ 'PurchaseOrder:add' }>
                  <ElButton style="margin-top: -5px" type="primary" onClick={ addOutSourcing }> 新增采购单 </ElButton>
                </ElFormItem>
                <ElFormItem v-permission={ 'PurchaseOrder:set' }>
                  <ElButton style="margin-top: -5px" type="primary" onClick={ setStatusAllData }> 批量提交 </ElButton>
                </ElFormItem>
                {
                  approval.findIndex(e => e.user_id == user.id) >= 0 ? 
                  <ElFormItem>
                    <ElButton style="margin-top: -5px" type="primary" onClick={ () => setApprovalAllData() }> 批量审批 </ElButton>
                  </ElFormItem> : 
                  <></>
                }
                <ElFormItem v-permission={ 'PurchaseOrder:print' }>
                  <ElButton style="margin-top: -5px" type="primary" v-print={ printObj.value }> 采购单打印 </ElButton>
                </ElFormItem>
                <ElFormItem label="生产订单号:">
                  <ElSelect v-model={ notice_number.value } multiple={false} filterable remote remote-show-suffix clearable valueKey="id" placeholder="请选择生产订单号">
                    {noticeList.value.map((e, index) => <ElOption value={ e } label={ e } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="供应商编码:">
                  <ElSelect v-model={ supplier_code.value } multiple={false} filterable remote remote-show-suffix clearable valueKey="id" placeholder="请选择供应商编码">
                    {supplierList.value.map((e, index) => <ElOption value={ e } label={ e } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="产品编码:">
                  <ElSelect v-model={ product_code.value } multiple={false} filterable remote remote-show-suffix clearable valueKey="id" placeholder="请选择产品编码">
                    {productList.value.map((e, index) => <ElOption value={ e } label={ e } key={ index } />)}
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
                <ElTable data={ tableData.value } border stripe onSelectionChange={ (select) => handleSelectionChange(select) }>
                  <ElTableColumn type="selection" width="55" />
                  <ElTableColumn label="状态" width='80'>
                    {({row}) => {
                      const spanDom = <span>{ statusType[row.status] }</span>
                      return spanDom
                    }}
                  </ElTableColumn>
                  <ElTableColumn prop="notice" label="生产订单号" width='100' />
                  <ElTableColumn prop="supplier_code" label="供应商编码" width='100' />
                  <ElTableColumn prop="supplier_abbreviation" label="供应商名称" width='100' />
                  <ElTableColumn prop="product_code" label="产品编码" width='100' />
                  <ElTableColumn prop="product_name" label="产品名称" width='120' />
                  <ElTableColumn prop="material_code" label="材料编码" width='100' />
                  <ElTableColumn prop="material_name" label="材料名称" width='100' />
                  <ElTableColumn prop="model_spec" label="型号&规格" width='100' />
                  <ElTableColumn prop="other_features" label="其它特性" width='100' />
                  <ElTableColumn prop="unit" label="单位" width='100' />
                  <ElTableColumn prop="price" label="单价" width='100' />
                  <ElTableColumn prop="order_number" label="预计数量" width='100' />
                  <ElTableColumn prop="number" label="实际数量" width='100' />
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
                <div class="printTable" id='totalTable2'>
                  <div id="printTable">
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
                          <th>单位</th>
                          <th>单价</th>
                          <th>数量</th>
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
        <ElDialog v-model={ dialogVisible.value } title={ edit.value ? '修改委外加工' : '新增委外加工' } onClose={ () => handleClose() }>
          {{
            default: () => (
              <ElForm model={ form.value } ref={ formRef } inline={ true } rules={ rules } label-width="110px">
                <ElFormItem label="供应商编码" prop="supplier_id">
                  <ElSelect v-model={ form.value.supplier_id } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择供应商编码" onChange={ (row) => supplierChange(row) }>
                    {supplierInfo.value.map((e, index) => <ElOption value={ e.id } label={ e.supplier_code } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="生产订单" prop="notice_id">
                  <ElSelect v-model={ form.value.notice_id } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择生产订单" onChange={ (row) => noticeChange(row) }>
                    {productNotice.value.map((e, index) => <ElOption value={ e.id } label={ e.notice } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="产品编码" prop="product_id">
                  <ElSelect v-model={ form.value.product_id } multiple={ false } filterable remote remote-show-suffix valueKey="id" placeholder="请选择产品编码" onChange={ (row) => productChange(row) }>
                    {proList.value.map((e, index) => {
                      return <ElOption value={ e.id } label={ e.product_code } key={ index } />
                    })}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="材料编码" prop="material_id">
                  <ElSelect v-model={ form.value.material_id } multiple={ false } filterable remote remote-show-suffix valueKey="id" placeholder="请选择材料编码" onChange={ (row) => materialChange(row) }>
                    {materialList.value.map((e, index) => {
                      return <ElOption value={ e.id } label={ e.material_code } key={ index } />
                    })}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="型号&规格" prop="model_spec">
                  <ElInput v-model={ form.value.model_spec } placeholder="请输入型号&规格" />
                </ElFormItem>
                <ElFormItem label="其它特性" prop="other_features">
                  <ElInput v-model={ form.value.other_features } placeholder="请输入其它特性" />
                </ElFormItem>
                <ElFormItem label="单位" prop="unit">
                  <ElInput v-model={ form.value.unit } placeholder="请输入单位" />
                </ElFormItem>
                <ElFormItem label="单价" prop="price">
                  <ElInput v-model={ form.value.price } placeholder="请输入单价" />
                </ElFormItem>
                {/* <ElFormItem label="预计数量" prop="order_number">
                  <ElInput v-model={ form.value.order_number } disabled placeholder="请输入预计数量" />
                </ElFormItem> */}
                <ElFormItem label="实际数量" prop="number">
                  <ElInput v-model={ form.value.number } placeholder="请输入实际数量" />
                </ElFormItem>
                <ElFormItem label="交货时间" prop="delivery_time">
                  <ElDatePicker v-model={ form.value.delivery_time } value-format="YYYY-MM-DD" type="date" placeholder="请选择交货时间" clearable={ false } />
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