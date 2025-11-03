import { defineComponent, onMounted, ref, reactive, nextTick } from 'vue'
import request from '@/utils/request';
import MySelect from '@/components/tables/mySelect.vue';
import { getPageHeight } from '@/utils/tool';
import HeadForm from '@/components/form/HeadForm';

export default defineComponent({
  setup(){
    const formRef = ref(null);
    const formCard = ref(null)
    const pagin = ref(null)
    const formHeight = ref(0);
    const rules = reactive({
      supplier_id: [
        { required: true, message: '请选择供应商编码', trigger: 'blur' }
      ],
      process_bom_id: [
        { required: true, message: '请选择工艺BOM表', trigger: 'blur' }
      ],
      process_bom_children_id: [
        { required: true, message: '请选择工艺工序', trigger: 'blur' }
      ],
      process_index: [
        { required: true, message: '请选择工序', trigger: 'blur' }
      ],
      transaction_currency: [
        { required: true, message: '请输入交易币别', trigger: 'blur' }
      ],
      other_transaction_terms: [
        { required: true, message: '请输入交易条件', trigger: 'blur' }
      ],
    })
    let dialogVisible = ref(false)
    let form = ref({
      notice_id: '',
      supplier_id: '',
      process_bom_id: '',
      process_index: '',
      price: '',
      transaction_currency: '',
      other_transaction_terms: '',
      remarks: ''
    })
    let tableData = ref([])
    let currentPage = ref(1);
    let pageSize = ref(20);
    let total = ref(0);
    let edit = ref(0)
    let supplierList = ref([])
    let noticeList = ref([])
    let bomList = ref([]) // 工艺Bom列表
    let procedure = ref([]) // 工序列表
    let allSelect = ref([]) // 用户选择的列表
    let search = ref({
      supplier_code: '',
      supplier_abbreviation: '',
      product_code: '',
      product_name: '',
      drawing: '',
    })
    
    onMounted(() => {
      nextTick(async () => {
        formHeight.value = await getPageHeight([formCard.value, pagin.value]);
      })
      fetchProductList()
      getSupplierInfo()
      getProductNotice()
      // getProcessBomList()
    })
    
    // 获取列表
    const fetchProductList = async () => {
      const res = await request.get('/api/outsourcing_quote', {
        params: {
          page: currentPage.value,
          pageSize: pageSize.value,
          ...search.value
        }
      });
      tableData.value = res.data;
      total.value = res.total;
    };
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
    const getProcessBomList = async (product_id) => {
      const res = await request.get('/api/getProcessBom', { params: { product_id } })
      bomList.value = res.data
    }
    const getProcessBomChildren = async (value) => {
      const res = await request.get(`/api/getProcessBomChildren?process_bom_id=${value}`)
      procedure.value = res.data
    }
    const handleSubmit = async (formEl) => {
      if (!formEl) return
      await formEl.validate(async (valid, fields) => {
        if (valid){
          if(!edit.value){
            const res = await request.post('/api/add_outsourcing_quote', form.value);
            if(res && res.code == 200){
              ElMessage.success('新增成功');
              dialogVisible.value = false;
              fetchProductList();

              const supplier = supplierList.value.find(o => o.id == form.value.supplier_id)
              const notice = noticeList.value.find(o => o.id == form.value.notice_id)
              const processBom = bomList.value.find(o => o.id == form.value.process_bom_id)
              const proce = procedure.value.find(o => o.id == form.value.process_bom_children_id)
              reportOperationLog({
                operationType: 'add',
                module: '委外报价',
                desc: `新增委外报价，供应商编码：${supplier.supplier_code}，生产订单号：${notice.notice}，工艺BOM：${processBom.name}，工艺工序：${proce ? proce.name : ''}`,
                data: { newData: form.value }
              })
            }
            
          }else{
            // 修改
            const myForm = {
              id: edit.value,
              notice_id: form.value.notice_id,
              supplier_id: form.value.supplier_id,
              process_bom_id: form.value.process_bom_id,
              process_index: form.value.process_index,
              price: form.value.price,
              transaction_currency: form.value.transaction_currency,
              other_transaction_terms: form.value.other_transaction_terms,
              remarks: form.value.remarks
            }
            const res = await request.put('/api/outsourcing_quote', myForm);
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
                module: '委外报价',
                desc: `修改委外报价，供应商编码：${supplier.supplier_code}，生产订单号：${notice.notice}，工艺BOM：${processBom.name}，工艺工序：${proce ? proce.name : ''}`,
                data: { newData: myForm }
              })
            }
          }
        }
      })
    }
    const handleSelectionChange = (select) => {
      allSelect.value = select.map(e => {
        return { id: e.id, status: 2 }
      })
    }
    const changeBomSelect = (value) => {
      procedure.value = []
      form.value.process_bom_children_id = ''
      getProcessBomChildren(value)
    }
    const handleUplate = async (row) => {
      edit.value = row.id;
      row.process_bom_children_id = Number(row.process_bom_children_id)
      form.value = { ...row };
      const notice = noticeList.value.find(o => o.id == row.notice_id)
      await getProcessBomList(notice.product_id)
      await getProcessBomChildren(row.process_bom_id)
      dialogVisible.value = true;
    }
    // 新增
    const handleAdd = () => {
      edit.value = 0;
      dialogVisible.value = true;
      procedure.value = []
      form.value.process_bom_children_id = ''
      resetForm()
    };
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
        process_index: '',
        price: '',
        transaction_currency: '',
        other_transaction_terms: '',
        remarks: ''
      }
    }
    const noticeChange = (row) => {
      if(row && row.product_id){
        getProcessBomList(row.product_id)
      }
    }
    // 分页相关
    function pageSizeChange(val) {
      currentPage.value = 1;
      pageSize.value = val;
      fetchProductList()
    }
    function currentPageChange(val) {
      currentPage.value = val;
      fetchProductList();
    }

    return() => (
      <>
        <ElCard>
          {{
            header: () => (
              <HeadForm headerWidth="180px" labelWidth="100" ref={ formCard }>
                {{
                  left: () => (
                    <>
                      <ElFormItem v-permission={ 'OutsourcingQuote:add' }>
                        <ElButton type="primary" onClick={ () => handleAdd() } style={{ width: '100px' }}>新增委外报价</ElButton>
                      </ElFormItem>
                    </>
                  ),
                  center: () => (
                    <>
                      <ElFormItem label="供应商编码：">
                        <ElInput v-model={ search.value.supplier_code } placeholder="请输入供应商编码" />
                      </ElFormItem>
                      <ElFormItem label="供应商名称：">
                        <ElInput v-model={ search.value.supplier_abbreviation } placeholder="请输入供应商名称" />
                      </ElFormItem>
                      <ElFormItem label="产品编码：">
                        <ElInput v-model={ search.value.product_code } placeholder="请输入产品编码" />
                      </ElFormItem>
                      <ElFormItem label="产品名称：">
                        <ElInput v-model={ search.value.product_name } placeholder="请输入产品名称" />
                      </ElFormItem>
                      <ElFormItem label="工程图号：">
                        <ElInput v-model={ search.value.drawing } placeholder="请输入工程图号" />
                      </ElFormItem>
                    </>
                  ),
                  right: () => (
                    <ElFormItem>
                      <ElButton type="primary" onClick={ () => fetchProductList() }>查询</ElButton>
                    </ElFormItem>
                  )
                }}
              </HeadForm>
            ),
            default: () => (
              <>
                <ElTable data={ tableData.value } border stripe height={ `calc(100vh - ${formHeight.value + 224}px)` } style={{ width: "100%" }} onSelectionChange={ (select) => handleSelectionChange(select) }>
                  <ElTableColumn prop="supplier.supplier_code" label="供应商编码" width="100" />
                  <ElTableColumn prop="supplier.supplier_abbreviation" label="供应商名称" width="100" />
                  <ElTableColumn prop="notice.notice" label="生产订单" width="120" />
                  <ElTableColumn prop="processBom.product.product_code" label="产品编码" width="90" />
                  <ElTableColumn prop="processBom.product.product_name" label="产品名称" width="90" />
                  <ElTableColumn prop="processBom.product.drawing" label="工程图号" width="100" />
                  <ElTableColumn prop="processBom.product.model" label="型号&规格" width="120" />
                  <ElTableColumn prop="processBom.part.part_code" label="部件编码" width="90" />
                  <ElTableColumn prop="processBom.part.part_name" label="部件名称" width="90" />
                  <ElTableColumn prop="processChildren.process.process_code" label="工艺编码" width="100" />
                  <ElTableColumn prop="processChildren.process.process_name" label="工艺名称" width="120" />
                  <ElTableColumn prop="price" label="加工单价" width="100" />
                  <ElTableColumn prop="transaction_currency" label="交易币别" width="100" />
                  <ElTableColumn prop="other_transaction_terms" label="交易条件" width="100" />
                  <ElTableColumn prop="remarks" label="备注" width="170" />
                  <ElTableColumn prop="created_at" label="创建时间" width="120" />
                  <ElTableColumn label="操作" width="100" fixed="right">
                    {(scope) => (
                      <>
                        <ElButton size="small" type="default" onClick={ () => handleUplate(scope.row) } v-permission={ 'OutsourcingQuote:edit' }>修改</ElButton>
                      </>
                    )}
                  </ElTableColumn>
                </ElTable>
                <ElPagination ref={ pagin } layout="prev, pager, next, jumper, total" currentPage={ currentPage.value } pageSize={ pageSize.value } total={ total.value } defaultPageSize={ pageSize.value } style={{ justifyContent: 'center', paddingTop: '10px' }} onUpdate:currentPage={ (page) => currentPageChange(page) } onUupdate:pageSize={ (size) => pageSizeChange(size) } />
              </>
            )
          }}
        </ElCard>
        <ElDialog v-model={ dialogVisible.value } title={ edit.value ? '修改委外报价' : '新增委外报价' } width='775' center draggable onClose={ () => handleClose() }>
          {{
            default: () => (
              <ElForm class="ml20" model={ form.value } ref={ formRef } inline={ true } rules={ rules } label-width="95">
                <ElFormItem label="生产订单" prop="notice_id">
                  <MySelect v-model={ form.value.notice_id } apiUrl="/api/getProductNotice" query="notice" itemValue="notice" placeholder="请选择生产订单" onChange={ (value) => noticeChange(value) } />
                </ElFormItem>
                <ElFormItem label="工艺BOM" prop="process_bom_id">
                  <ElSelect v-model={ form.value.process_bom_id } multiple={ false } filterable remote remote-show-suffix valueKey="id" placeholder="请选择工艺BOM" onChange={ (value) => changeBomSelect(value) }>
                    {bomList.value.map((e, index) => {
                      return <ElOption value={ e.id } label={ e.name } key={ index } />
                    })}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="工艺工序" prop="process_bom_children_id">
                  <ElSelect v-model={ form.value.process_bom_children_id } multiple={ false } filterable remote remote-show-suffix valueKey="id" placeholder="请选择工艺工序" onChange="changeSelect">
                  {procedure.value.map((e, index) => {
                    return <ElOption value={ e.id } label={ e.name } key={ index } />
                  })}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="供应商编码" prop="supplier_id">
                  <MySelect v-model={ form.value.supplier_id } apiUrl="/api/getSupplierInfo" query="supplier_code" itemValue="supplier_code" placeholder="请选择供应商编码" />
                </ElFormItem>
                <ElFormItem label="加工单价" prop="price">
                  <ElInput v-model={ form.value.price } placeholder="请输入加工单价" />
                </ElFormItem>
                <ElFormItem label="交易币别" prop="transaction_currency">
                  <ElInput v-model={ form.value.transaction_currency } placeholder="请输入交易币别" />
                </ElFormItem>
                <ElFormItem label="交易条件" prop="other_transaction_terms">
                  <ElInput v-model={ form.value.other_transaction_terms } placeholder="请输入交易条件" />
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