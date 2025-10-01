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
      // notice_id: [
      //   { required: true, message: '请选择生产订单号', trigger: 'blur' },
      // ],
      material_id: [
        { required: true, message: '请选择材料编码', trigger: 'blur' },
      ],
      delivery: [
        { required: true, message: '请输入送货方式', trigger: 'blur' },
      ],
      packaging: [
        { required: true, message: '请输入包装要求', trigger: 'blur' },
      ],
      transaction_currency: [
        { required: true, message: '请输入交易币别', trigger: 'blur' },
      ],
      other_transaction_terms: [
        { required: true, message: '请输入交易条件', trigger: 'blur' },
      ]
    })
    let dialogVisible = ref(false)
    let form = ref({
      supplier_id: '',
      notice_id: '',
      material_id: '',
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
    let currentPage = ref(1);
    let pageSize = ref(10);
    let total = ref(0);
    let edit = ref(0)

    onMounted(() => {
      fetchProductList()
      getSupplierInfo()
      getProductNotice()
      getMaterialCode()
    })

    // 获取列表
    const fetchProductList = async () => {
      const res = await request.get('/api/material_quote', {
        params: {
          page: currentPage.value,
          pageSize: pageSize.value
        },
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
    const getMaterialCode = async () => {
      const res = await request.get('/api/getMaterialCode')
      if(res.code == 200){
        materialList.value = res.data
      }
    }
    const handleSubmit = async (formEl) => {
      if (!formEl) return
      await formEl.validate(async (valid, fields) => {
        if (valid){
          if(!edit.value){
            const res = await request.post('/api/material_quote', form.value);
            if(res && res.code == 200){
              ElMessage.success('新增成功');
              dialogVisible.value = false;
              fetchProductList();
              
              const supplier = supplierList.value.find(o => o.id == form.value.supplier_id)
              const notice = noticeList.value.find(o => o.id == form.value.notice_id)
              const material = materialList.value.find(o => o.id == form.value.material_id)
              reportOperationLog({
                operationType: 'add',
                module: '原材料报价',
                desc: `新增原材料报价，供应商编码：${supplier.supplier_code}，生产订单号：${notice.notice}，材料编码：${material.material_code}`,
                data: { newData: form.value }
              })
            }
            
          }else{
            // 修改
            const myForm = {
              id: edit.value,
              supplier_id: form.value.supplier_id,
              notice_id: form.value.notice_id,
              material_id: form.value.material_id,
              price: form.value.price,
              delivery: form.value.delivery,
              packaging: form.value.packaging, 
              transaction_currency: form.value.transaction_currency, 
              other_transaction_terms: form.value.other_transaction_terms, 
              remarks: form.value.remarks
            }
            const res = await request.put('/api/material_quote', myForm);
            if(res && res.code == 200){
              ElMessage.success('修改成功');
              dialogVisible.value = false;
              fetchProductList();
              const supplier = supplierList.value.find(o => o.id == myForm.supplier_id)
              const notice = noticeList.value.find(o => o.id == myForm.notice_id)
              const material = materialList.value.find(o => o.id == myForm.material_id)
              reportOperationLog({
                operationType: 'update',
                module: '原材料报价',
                desc: `修改原材料报价，供应商编码：${supplier.supplier_code}，生产订单号：${notice.notice}，材料编码：${material.material_code}`,
                data: { newData: myForm }
              })
            }
          }
        }
      })
    }
    const handleUplate = (row) => {
      edit.value = row.id;
      dialogVisible.value = true;
      form.value = { ...row };
    }
    // 新增
    const handleAdd = () => {
      edit.value = 0;
      dialogVisible.value = true;
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
        supplier_id: '',
        notice_id: '',
        material_id: '',
        price: '',
        delivery: '',
        packaging: '', 
        transaction_currency: '', 
        other_transaction_terms: '', 
        remarks: ''
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
              <div class="clearfix">
                <ElButton style="margin-top: -5px" type="primary" v-permission={ 'MaterialQuote:add' } onClick={ handleAdd } >
                  新增材料报价
                </ElButton>
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
                        <ElButton size="small" type="default" v-permission={ 'MaterialQuote:edit' } onClick={ () => handleUplate(scope.row) }>修改</ElButton>
                      </>
                    )}
                  </ElTableColumn>
                </ElTable>
                <ElPagination layout="prev, pager, next, jumper, total" currentPage={ currentPage.value } pageSize={ pageSize.value } total={ total.value } defaultPageSize={ pageSize.value } style={{ justifyContent: 'center', paddingTop: '10px' }} onUpdate:currentPage={ (page) => currentPageChange(page) } onUupdate:pageSize={ (size) => pageSizeChange(size) } />
              </>
            )
          }}
        </ElCard>
        <ElDialog v-model={ dialogVisible.value } title={ edit.value ? '修改材料报价' : '新增材料报价' } onClose={ () => handleClose() }>
          {{
            default: () => (
              <ElForm model={ form.value } ref={ formRef } inline={ true } rules={ rules } label-width="110px">
                <ElFormItem label="供应商编码" prop="supplier_id">
                  <MySelect v-model={ form.value.supplier_id } apiUrl="/api/getSupplierInfo" query="supplier_code" itemValue="supplier_code" placeholder="请选择供应商编码" />
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