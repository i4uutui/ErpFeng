import { defineComponent, ref, onMounted, reactive, nextTick } from 'vue'
import request from '@/utils/request';
import MySelect from '@/components/tables/mySelect.vue';
import { reportOperationLog } from '@/utils/log';
import { getPageHeight } from '@/utils/tool';
import { getItem } from '@/assets/js/storage';

export default defineComponent({
  setup(){
    const formRef = ref(null);
    const formCard = ref(null)
    const formHeight = ref(0);
    const invoice = ref(getItem('constant').filter(o => o.type == 'invoice'))
    const payTime = ref(getItem('constant').filter(o => o.type == 'payTime'))
    const supplyMethod =  ref(getItem('constant').filter(o => o.type == 'supplyMethod'))
    const method = ref(getItem('constant').filter(o => o.type == 'payInfo'))
    const calcUnit = ref(getItem('constant').filter(o => o.type == 'calcUnit'))
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
      transaction_method: '',
      other_transaction_terms: '', 
      other_text: '',
      invoice: ''
    })
    let supplierList = ref([])
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
          transaction_method: e.transaction_method,
          other_transaction_terms: e.other_transaction_terms,
          other_text: e.other_text,
          invoice: e.invoice ? e.invoice : null
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
            transaction_method: data.transaction_method,
            other_transaction_terms: data.other_transaction_terms,
            other_text: data.other_text,
            invoice: data.invoice ? data.invoice : '',
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
      row.other_transaction_terms = Number(row.other_transaction_terms)
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
        transaction_method: '',
        other_transaction_terms: '', 
        invoice: '',
        other_text: ''
      }
    }
    const supplierChange = (row) => {
      form.value.supplier_abbreviation = row.supplier_abbreviation
      form.value.delivery = row.supply_method
      form.value.transaction_currency = row.transaction_currency
      form.value.other_transaction_terms = Number(row.other_transaction_terms)
      form.value.other_text = row.other_text
      form.value.transaction_method = row.transaction_method
    }
    const materialChange = (value) => {
      const row = materialList.value.find(o => o.id == value)
      form.value.material_name = row.material_name
      form.value.unit = row.purchase_unit ? Number(row.purchase_unit) : ''
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
                  <ElTableColumn prop="material.model" label="型号&规格" width="180" />
                  <ElTableColumn prop="material.other_features" label="其他特性" width="100" />
                  <ElTableColumn prop="price" label="采购单价" width="100" />
                  <ElTableColumn prop="transaction_currency" label="交易币别" width="100" />
                  <ElTableColumn label="采购单位" width="100">
                    {({row}) => <span>{ calcUnit.value.find(e => e.id == row.unit)?.name }</span>}
                  </ElTableColumn>
                  <ElTableColumn label="送货方式" width="100">
                    {({row}) => <span>{ supplyMethod.value.find(e => e.id == row.delivery)?.name }</span>}
                  </ElTableColumn>
                  <ElTableColumn prop="packaging" label="包装要求" width="100" />
                  <ElTableColumn label="交易方式" width="100">
                    {({row}) => <span>{ method.value.find(e => e.id == row.transaction_method)?.name }</span>}
                  </ElTableColumn>
                  <ElTableColumn label="结算周期" width="120">
                    {({row}) => {
                      const rowId = row.other_transaction_terms
                      if(rowId == 28){
                        return <span>{ row.other_text }</span>
                      }
                      return <span>{ payTime.value.find(e => e.id == row.other_transaction_terms)?.name }</span>
                    }}
                  </ElTableColumn>
                  <ElTableColumn label="税票要求" width="110">
                    {({row}) => <span>{ invoice.value.find(e => e.id == row.invoice)?.name }</span>}
                  </ElTableColumn>
                  <ElTableColumn prop="created_at" label="创建日期" width="120" />
                  <ElTableColumn label="操作" width="140" fixed="right">
                    {(scope) => (
                      <>
                        <ElButton size="small" type="warning" onClick={ () => handleUplate(scope) }>修改</ElButton>
                        <ElButton size="small" type="danger" onClick={ () => handleDelete(scope) }>删除</ElButton>
                      </>
                    )}
                  </ElTableColumn>
                </ElTable>
              </>
            )
          }}
        </ElCard>
        <ElDialog v-model={ dialogVisible.value } title={ edit.value >= 0 ? '修改材料报价' : '新增材料报价' } width='790' center draggable onClose={ () => handleClose() }>
          {{
            default: () => (
              <ElForm class="ml30" model={ form.value } ref={ formRef } inline={ true } rules={ rules } label-width="100">
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
                  <ElSelect v-model={ form.value.unit } multiple={ false } filterable remote remote-show-suffix placeholder="请选择采购单位">
                    {calcUnit.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="送货方式" prop="delivery">
                  <ElSelect v-model={ form.value.delivery } multiple={ false } filterable remote remote-show-suffix placeholder="请选择送货方式">
                    {supplyMethod.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="包装要求" prop="packaging">
                  <ElInput v-model={ form.value.packaging } placeholder="请输入包装要求" />
                </ElFormItem>
                <ElFormItem label="交易方式" prop="transaction_method">
                  <ElSelect v-model={ form.value.transaction_method } multiple={ false } filterable remote remote-show-suffix placeholder="请选择交易方式">
                    {method.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="结算周期" prop="other_transaction_terms">
                  <ElSelect v-model={ form.value.other_transaction_terms } multiple={ false } filterable remote remote-show-suffix placeholder="请选择结算周期">
                    {payTime.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                { form.value.other_transaction_terms == 28 ? <ElFormItem label="其他" prop="other_text">
                  <ElInput v-model={ form.value.other_text } placeholder="请输入结算周期" />
                </ElFormItem> : '' }
                <ElFormItem label="税票要求" prop="invoice">
                  <ElSelect v-model={ form.value.invoice } multiple={ false } filterable remote remote-show-suffix placeholder="请选择税票要求">
                    {invoice.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                  </ElSelect>
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