import { defineComponent, ref, onMounted, reactive, nextTick } from 'vue'
import request from '@/utils/request';
import MySelect from '@/components/tables/mySelect.vue';
import { reportOperationLog } from '@/utils/log';
import { getPageHeight } from '@/utils/tool';

export default defineComponent({
  setup(){
    const formRef = ref(null);
    const formCard = ref(null)
    const formHeight = ref(0);
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
      unit: [
        { required: true, message: '请输入采购单位', trigger: 'blur' }
      ]
    })
    let dialogVisible = ref(false)
    let form = ref({
      supplier_id: '',
      supplier_abbreviation: '',
      material_id: '',
      price: '',
      delivery: '',
      packaging: '', 
      transaction_currency: '',
      unit: '',
      other_transaction_terms: '', 
      remarks: ''
    })
    let supplierList = ref([])
    let noticeList = ref([])
    let materialBomList = ref([])
    let materialList = ref([])
    let tableData = ref([])
    let edit = ref(-1)

    onMounted(() => {
      nextTick(async () => {
        formHeight.value = await getPageHeight([formCard.value]);
      })
      getMaterialCode()
      getSupplierInfo()
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
        const data = { id: 0, notice: '非管控材料' }
        noticeList.value = [data, ...res.data]
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
          supplier_abbreviation: e.supplier_abbreviation,
          material_id: e.material_id,
          price: e.price,
          delivery: e.delivery,
          packaging: e.packaging, 
          transaction_currency: e.transaction_currency, 
          unit: e.unit,
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
          const material = materialList.value.find(o => o.id == form.value.material_id)
          const formData = {
            supplier: {
              supplier_code: supplier.supplier_code,
              supplier_abbreviation: supplier.supplier_abbreviation,
            },
            material: {
              material_code: material.material_code,
              material_name: material.material_name,
              model: material.model,
              specification: material.specification,
              other_features: material.other_features,
              purchase_unit: material.purchase_unit,
            },
            supplier_id: data.supplier_id,
            supplier_code: supplier.supplier_code,
            supplier_abbreviation: supplier.supplier_abbreviation,
            material_id: data.material_id,
            material_code: material.material_code,
            material_name: material.material_name,
            price: data.price,
            delivery: data.delivery,
            packaging: data.packaging,
            transaction_currency: data.transaction_currency,
            unit: data.unit,
            other_transaction_terms: data.other_transaction_terms,
            remarks: data.remarks,
          }
          console.log(formData);
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
        supplier_abbreviation: '',
        material_id: '',
        material_name: '',
        price: '',
        delivery: '',
        packaging: '', 
        transaction_currency: '', 
        unit: '',
        other_transaction_terms: '', 
        remarks: ''
      }
    }
    const supplierChange = (row) => {
      form.value.supplier_abbreviation = row.supplier_abbreviation
      form.value.delivery = row.supply_method
      form.value.transaction_currency = row.transaction_currency
    }
    const materialChange = (value) => {
      const row = materialList.value.find(o => o.id == value)
      form.value.material_name = row.material_name
    }
    const goArchive = () => {
      window.open('/#/purchase/material-quote-archive', '_blank')
    }

    return() => (
      <>
        <ElCard>
          {{
            header: () => (
              <div class="flex row-between" ref={ formCard }>
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
                <ElTable data={ tableData.value } border stripe height={ `calc(100vh - ${formHeight.value + 224}px)` } style={{ width: "100%" }}>
                  <ElTableColumn prop="supplier.supplier_code" label="供应商编码" width="100" />
                  <ElTableColumn prop="supplier.supplier_abbreviation" label="供应商名称" width="100" />
                  <ElTableColumn prop="material.material_code" label="材料编码" width="100" />
                  <ElTableColumn prop="material.material_name" label="材料名称" width="100" />
                  <ElTableColumn prop="material.model" label="型号" width="100" />
                  <ElTableColumn prop="material.specification" label="规格" width="100" />
                  <ElTableColumn prop="material.other_features" label="其他特性" width="100" />
                  <ElTableColumn prop="price" label="采购单价" width="100" />
                  <ElTableColumn prop="transaction_currency" label="交易币别" width="100" />
                  <ElTableColumn prop="unit" label="采购单位" width="100" />
                  <ElTableColumn prop="delivery" label="送货方式" width="100" />
                  <ElTableColumn prop="packaging" label="包装要求" width="100" />
                  <ElTableColumn prop="other_transaction_terms" label="其它交易条件" width="120" />
                  <ElTableColumn prop="remarks" label="备注" width="170" />
                  <ElTableColumn prop="created_at" label="创建时间" width="120" />
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
                {/* <ElFormItem label="生产订单号" prop="notice_id">
                  <ElSelect v-model={ form.value.notice_id } multiple={ false } filterable remote remote-show-suffix valueKey="id" placeholder="请选择生产订单号" onChange={ (value) => noticeChange(value) }>
                    {noticeList.value.map((e, index) => {
                      return <ElOption value={ e.id } label={ e.notice } key={ index } />
                    })}
                  </ElSelect>
                </ElFormItem> */}
                {/* <ElFormItem label="材料BOM" prop='material_bom_id'>
                  <ElSelect v-model={ form.value.material_bom_id } multiple={ false } filterable remote remote-show-suffix valueKey="id" placeholder="请选择材料BOM" onChange={ (value) => materialBomChange(value) }>
                    {materialBomList.value.map((e, index) => {
                      return <ElOption value={ e.id } label={ e.name } key={ index } />
                    })}
                  </ElSelect>
                </ElFormItem> */}
                <ElFormItem label="材料编码" prop="material_id">
                  <ElSelect v-model={ form.value.material_id } multiple={ false } filterable remote remote-show-suffix valueKey="id" placeholder="请选择材料编码" onChange={ (value) => materialChange(value) }>
                    {materialList.value.map((e, index) => {
                      return <ElOption value={ e.id } label={ e.material_code } key={ index } />
                    })}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="材料名称" prop="material_id">
                  <el-input v-model={ form.value.material_name } readonly placeholder="请选择材料名称"></el-input>
                </ElFormItem>
                <ElFormItem label="供应商编码" prop="supplier_id">
                  <MySelect v-model={ form.value.supplier_id } apiUrl="/api/getSupplierInfo" query="supplier_code" itemValue="supplier_code" placeholder="请选择供应商编码" onChange={ (value) => supplierChange(value) } />
                </ElFormItem>
                <ElFormItem label="供应商名称" prop="supplier_id">
                  <el-input v-model={ form.value.supplier_abbreviation } readonly placeholder="请选择供应商名称"></el-input>
                </ElFormItem>
                <ElFormItem label="采购单价" prop="price">
                  <ElInput v-model={ form.value.price } placeholder="请输入采购单价" />
                </ElFormItem>
                <ElFormItem label="交易币别" prop="transaction_currency">
                  <ElInput v-model={ form.value.transaction_currency } placeholder="请输入交易币别" />
                </ElFormItem>
                <ElFormItem label="采购单位" prop="unit">
                  <ElInput v-model={ form.value.unit } placeholder="请输入采购单位" />
                </ElFormItem>
                <ElFormItem label="送货方式" prop="delivery">
                  <ElInput v-model={ form.value.delivery } placeholder="请输入送货方式" />
                </ElFormItem>
                <ElFormItem label="包装要求" prop="packaging">
                  <ElInput v-model={ form.value.packaging } placeholder="请输入包装要求" />
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