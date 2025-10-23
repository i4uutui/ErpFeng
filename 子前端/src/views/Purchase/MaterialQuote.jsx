import { defineComponent, ref, onMounted, reactive } from 'vue'
import request from '@/utils/request';
import MySelect from '@/components/tables/mySelect.vue';
import { reportOperationLog } from '@/utils/log';

export default defineComponent({
  setup(){
    const formRef = ref(null);
    const rules = reactive({
      supplier_id: [
        { required: true, message: '请选择供应商编码', trigger: 'blur' },
      ],
      material_id: [
        { required: true, message: '请选择材料编码', trigger: 'blur' },
      ],
      delivery: [
        { required: true, message: '请输入送货方式', trigger: 'blur' },
      ],
      price: [
        { required: true, message: '请输入采购单价', trigger: 'blur' },
      ],
      transaction_currency: [
        { required: true, message: '请输入交易币别', trigger: 'blur' },
      ],
    })
    let dialogVisible = ref(false)
    let form = ref({
      supplier_id: '',
      notice_id: '',
      material_id: '',
      product_id: '',
      price: '',
      delivery: '',
      packaging: '', 
      transaction_currency: '', 
      other_transaction_terms: '', 
      remarks: ''
    })
    let supplierList = ref([])
    let noticeList = ref([])
    let materialList = ref([])
    let tableData = ref([])
    let edit = ref(0)

    onMounted(() => {
      getSupplierInfo()
      getProductNotice()
      getMaterialCode()
    })

    const getSupplierInfo = async () => {
      const res = await request.get('/api/getSupplierInfo')
      if(res.code == 200){
        supplierList.value = res.data
      }
    }
    const getProductNotice = async () => {
      const res = await request.get('/api/getProductNotice')
      if(res.code == 200){
        noticeList.value = res.data
      }
    }
    const getMaterialCode = async () => {
      const res = await request.get('/api/getMaterialCode')
      if(res.code == 200){
        materialList.value = res.data
      }
    }
    const handleArchive = async () => {
      if(!tableData.value.length) return ElMessage.error('暂无数据可存档！');
      ElMessageBox.confirm('是否确认存档', '提示', {
        confirmButtonText: '确认',
        cancelButtonText: '取消',
        type: 'warning',
      }).then(async () => {
        const data = tableData.value.map(e => ({
          supplier_id: e.supplier_id,
          notice_id: e.notice_id,
          material_id: e.material_id,
          product_id: e.product_id,
          price: e.price,
          delivery: e.delivery,
          packaging: e.packaging, 
          transaction_currency: e.transaction_currency, 
          other_transaction_terms: e.other_transaction_terms, 
          remarks: e.remarks
        }))
        const res = await request.post('/api/material_quote', { data });
        if(res && res.code == 200){
          ElMessage.success('存档成功');
          tableData.value = []

          reportOperationLog({
            operationType: 'keyup',
            module: '原材料报价',
            desc: `存档原材料报价`,
            data: { newData: { data: data } }
          })
        }
      }).catch(() => {})
    }
    const handleSubmit = async (formEl) => {
      if (!formEl) return
      await formEl.validate(async (valid, fields) => {
        if (valid){
          const data = form.value
          const supplier = supplierList.value.find(o => o.id == form.value.supplier_id)
          const notice = noticeList.value.find(o => o.id == form.value.notice_id)
          const material = materialList.value.find(o => o.id == form.value.material_id)
          const formData = {
            supplier: {
              supplier_code: supplier.supplier_code,
              supplier_abbreviation: supplier.supplier_abbreviation,
            },
            notice: {
              notice: notice.notice,
            },
            material: {
              material_code: material.material_code,
              material_name: material.material_name,
              model: material.model,
              specification: material.specification,
              other_features: material.other_features,
              purchase_unit: material.purchase_unit,
            },
            product_id: notice.product_id,
            supplier_id: data.supplier_id,
            notice_id: data.notice_id,
            material_id: data.material_id,
            price: data.price,
            delivery: data.delivery,
            packaging: data.packaging,
            transaction_currency: data.transaction_currency,
            other_transaction_terms: data.other_transaction_terms,
            remarks: data.remarks,
          }
          dialogVisible.value = false;
          if(edit.value >= 0){
            tableData.value[edit.value] = formData
          }else{
            tableData.value.push(formData)
          }
        }
      })
    }
    const handleDelete = ({ $index }) => {
      ElMessageBox.confirm('是否确认删除', '提示', {
        confirmButtonText: '确认',
        cancelButtonText: '取消',
        type: 'warning',
      }).then(async () => {
        tableData.value.splice($index, 1)
        ElMessage.success('删除成功')
      }).catch(() => {})
    }
    const handleUplate = ({ row, $index }) => {
      edit.value = $index
      dialogVisible.value = true;
      form.value = { ...row };
    }
    // 新增
    const handleAdd = () => {
      edit.value = -1;
      dialogVisible.value = true;
      resetForm()
    };
    // 取消弹窗
    const handleClose = () => {
      edit.value = -1;
      dialogVisible.value = false;
      resetForm()
    }
    const resetForm = () => {
      form.value = {
        supplier_id: '',
        notice_id: '',
        material_id: '',
        product_id: '',
        price: '',
        delivery: '',
        packaging: '', 
        transaction_currency: '', 
        other_transaction_terms: '', 
        remarks: ''
      }
    }
    const supplierChange = (row) => {
      form.value.delivery = row.supply_method
      form.value.transaction_currency = row.transaction_currency
    }
    const goArchive = () => {
      window.open('/#/purchase/material-quote-archive', '_blank')
    }

    return() => (
      <>
        <ElCard>
          {{
            header: () => (

              <div class="flex row-between">
                <div>
                  <ElButton style="margin-top: -5px" type="primary" v-permission={ 'MaterialQuote:add' } onClick={ handleAdd } >
                    新增材料报价
                  </ElButton>
                  <ElButton style="margin-top: -5px" type="primary" v-permission={ 'MaterialQuote:archive' } onClick={ handleArchive } >
                    存档
                  </ElButton>
                </div>
                <div>
                  <ElButton style="margin-top: -5px" type="warning" v-permission={ 'MaterialQuote:newPage' } onClick={ goArchive } >
                    材料报价库
                  </ElButton>
                </div>
              </div>
            ),
            default: () => (
              <>
                <ElTable data={ tableData.value } border stripe style={{ width: "100%" }}>
                  <ElTableColumn prop="supplier.supplier_code" label="供应商编码" width="100" />
                  <ElTableColumn prop="supplier.supplier_abbreviation" label="供应商名称" width="100" />
                  <ElTableColumn prop="notice.notice" label="生产订单号" width="100" />
                  <ElTableColumn prop="material.material_code" label="材料编码" width="100" />
                  <ElTableColumn prop="material.material_name" label="材料名称" width="100" />
                  <ElTableColumn prop="material.model" label="型号" width="100" />
                  <ElTableColumn prop="material.specification" label="规格" width="100" />
                  <ElTableColumn prop="material.other_features" label="其他特性" width="100" />
                  <ElTableColumn prop="material.purchase_unit" label="采购单位" width="100" />
                  <ElTableColumn prop="price" label="采购单价" width="100" />
                  <ElTableColumn prop="delivery" label="送货方式" width="100" />
                  <ElTableColumn prop="packaging" label="包装要求" width="100" />
                  <ElTableColumn prop="transaction_currency" label="交易币别" width="100" />
                  <ElTableColumn prop="other_transaction_terms" label="其它交易条件" width="120" />
                  <ElTableColumn prop="remarks" label="备注" width="100" />
                  <ElTableColumn prop="created_at" label="创建时间" width="100" />
                  <ElTableColumn label="操作" width="140" fixed="right">
                    {(scope) => (
                      <>
                        <ElButton size="small" type="default" onClick={ () => handleUplate(scope) }>修改</ElButton>
                        <ElButton size="small" type="danger" onClick={ () => handleDelete(scope) }>删除</ElButton>
                      </>
                    )}
                  </ElTableColumn>
                </ElTable>
              </>
            )
          }}
        </ElCard>
        <ElDialog v-model={ dialogVisible.value } title={ edit.value ? '修改材料报价' : '新增材料报价' } onClose={ () => handleClose() }>
          {{
            default: () => (
              <ElForm model={ form.value } ref={ formRef } inline={ true } rules={ rules } label-width="110px">
                <ElFormItem label="供应商编码" prop="supplier_id">
                  <MySelect v-model={ form.value.supplier_id } apiUrl="/api/getSupplierInfo" query="supplier_code" itemValue="supplier_code" placeholder="请选择供应商编码" onChange={ (value) => supplierChange(value) } />
                </ElFormItem>
                <ElFormItem label="生产订单号" prop="notice_id">
                  <MySelect v-model={ form.value.notice_id } apiUrl="/api/getProductNotice" query="notice" itemValue="notice" placeholder="请选择生产订单号" />
                </ElFormItem>
                <ElFormItem label="材料编码" prop="material_id">
                  <MySelect v-model={ form.value.material_id } apiUrl="/api/getMaterialCode" query="material_code" itemValue="material_code" placeholder="请选择材料编码" />
                </ElFormItem>
                <ElFormItem label="采购单价" prop="price">
                  <ElInput v-model={ form.value.price } placeholder="请输入采购单价" />
                </ElFormItem>
                <ElFormItem label="送货方式" prop="delivery">
                  <ElInput v-model={ form.value.delivery } placeholder="请输入送货方式" />
                </ElFormItem>
                <ElFormItem label="包装要求" prop="packaging">
                  <ElInput v-model={ form.value.packaging } placeholder="请输入包装要求" />
                </ElFormItem>
                <ElFormItem label="交易币别" prop="transaction_currency">
                  <ElInput v-model={ form.value.transaction_currency } placeholder="请输入交易币别" />
                </ElFormItem>
                <ElFormItem label="其它交易条件" prop="other_transaction_terms">
                  <ElInput v-model={ form.value.other_transaction_terms } placeholder="请输入其它交易条件" />
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
})