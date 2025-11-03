import { defineComponent, onMounted, ref, reactive, nextTick } from 'vue'
import request from '@/utils/request';
import MySelect from '@/components/tables/mySelect.vue';
import { reportOperationLog } from '@/utils/log';
import { getPageHeight } from '@/utils/tool';
import HeadForm from '@/components/form/HeadForm';

export default defineComponent({
  setup(){
    const formRef = ref(null);
    const formCard = ref(null)
    const pagin = ref(null)
    const formHeight = ref(0);
    const rules = reactive({
      sale_id: [
        { required: true, message: '请选择销售订单', trigger: 'blur' },
      ],
      notice: [
        { required: true, message: '请输入报价单号', trigger: 'blur' },
      ],
      product_price: [
        { required: true, message: '请输入产品单价', trigger: 'blur' },
      ],
      transaction_currency: [
        { required: true, message: '请输入交易币别', trigger: 'blur' },
      ],
    })
    let dialogVisible = ref(false)
    let form = ref({
      sale_id: '',
      notice: '',
      product_price: '',
      transaction_currency: '',
      other_transaction_terms: ''
    })
    let tableData = ref([])
    let currentPage = ref(1);
    let pageSize = ref(20);
    let total = ref(0);
    let edit = ref(0)
    let search = ref({
      notice: '',
      customer_code: '',
      customer_abbreviation: '',
      product_code: '',
      product_name: '',
      drawing: ''
    })

    onMounted(() => {
      nextTick(async () => {
        formHeight.value = await getPageHeight([formCard.value, pagin.value]);
      })
      fetchProductList()
    })

    // 获取列表
    const fetchProductList = async () => {
      const res = await request.get('/api/product_quotation', {
        params: {
          page: currentPage.value,
          pageSize: pageSize.value,
          ...search.value
        },
      });
      tableData.value = res.data;
      total.value = res.total;
    };
    const handleSubmit = async (formEl) => {
      if (!formEl) return
      await formEl.validate(async (valid, fields) => {
        if (valid){
          if(!edit.value){
            const res = await request.post('/api/product_quotation', form.value);
            if(res && res.code == 200){
              ElMessage.success('新增成功');
              dialogVisible.value = false;
              fetchProductList();
              reportOperationLog({
                operationType: 'add',
                module: '产品报价',
                desc: `新增产品报价，报价单号：${form.value.notice}`,
                data: { newData: form.value }
              })
            }
            
          }else{
            // 修改
            const myForm = {
              id: edit.value,
              ...form.value
            }
            const res = await request.put('/api/product_quotation', myForm);
            if(res && res.code == 200){
              ElMessage.success('修改成功');
              dialogVisible.value = false;
              fetchProductList();
              reportOperationLog({
                operationType: 'update',
                module: '产品报价',
                desc: `修改产品报价，报价单号：${myForm.notice}`,
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
        sale_id: '',
        notice: '',
        product_price: '',
        transaction_currency: '',
        other_transaction_terms: '',
      }
    }
    const saleChange = (row) => {
      form.value.other_transaction_terms = row.customer.other_transaction_terms
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
              <HeadForm headerWidth="150px" ref={ formCard }>
                {{
                  left: () => (
                    <ElFormItem v-permission={ 'ProductQuote:add' }>
                      <ElButton type="primary" onClick={ handleAdd } style={{ width: '100px' }}>新增产品报价</ElButton>
                    </ElFormItem>
                  ),
                  center: () => (
                    <>
                      <ElFormItem label="报价单号：">
                        <ElInput v-model={ search.value.notice } placeholder="请输入报价单号" style={{ width: '160px' }} />
                      </ElFormItem>
                      <ElFormItem label="客户编码：">
                        <ElInput v-model={ search.value.customer_code } placeholder="请输入客户编码" style={{ width: '160px' }} />
                      </ElFormItem>
                      <ElFormItem label="客户名称：">
                        <ElInput v-model={ search.value.customer_abbreviation } placeholder="请输入客户名称" style={{ width: '160px' }} />
                      </ElFormItem>
                      <ElFormItem label="产品编码：">
                        <ElInput v-model={ search.value.product_code } placeholder="请输入产品编码" style={{ width: '160px' }} />
                      </ElFormItem>
                      <ElFormItem label="产品名称：">
                        <ElInput v-model={ search.value.product_name } placeholder="请输入产品名称" style={{ width: '160px' }} />
                      </ElFormItem>
                      <ElFormItem label="工程图号：">
                        <ElInput v-model={ search.value.drawing } placeholder="请输入工程图号" style={{ width: '160px' }} />
                      </ElFormItem>
                    </>
                  ),
                  right: () => (
                    <ElFormItem>
                      <ElButton type="primary" onClick={ fetchProductList }>查询</ElButton>
                    </ElFormItem>
                  )
                }}
              </HeadForm>
            ),
            default: () => (
              <>
                <ElTable data={ tableData.value } border stripe height={ `calc(100vh - ${formHeight.value + 224}px)` } style={{ width: "100%" }}>
                  <ElTableColumn prop="notice" label="报价单号" width="100" />
                  <ElTableColumn prop="customer.customer_code" label="客户编码" width="120" />
                  <ElTableColumn prop="customer.customer_abbreviation" label="客户名称" width="120" />
                  <ElTableColumn prop="product.product_code" label="产品编码" width="100" />
                  <ElTableColumn prop="product.product_name" label="产品名称" width="100" />
                  <ElTableColumn prop="product.drawing" label="工程图号" width="100" />
                  <ElTableColumn prop="product.model" label="型号&规格" width="180" />
                  {/* <ElTableColumn prop="product.specification" label="规格" width="100" /> */}
                  <ElTableColumn prop="product.other_features" label="其他特性" width="100" />
                  <ElTableColumn prop="sale.customer_order" label="客户订单号" width="120" />
                  <ElTableColumn prop="sale.order_number" label="订单数量" width="100" />
                  <ElTableColumn prop="sale.unit" label="单位" width="100" />
                  <ElTableColumn prop="product_price" label="产品单价" width="100" />
                  <ElTableColumn prop="transaction_currency" label="交易币别" width="100" />
                  <ElTableColumn prop="other_transaction_terms" label="交易条件" width="120" />
                  <ElTableColumn prop="created_at" label="创建时间" width="120" />
                  <ElTableColumn label="操作" width="140" fixed="right">
                    {(scope) => (
                      <>
                        <ElButton size="small" type="default" v-permission={ 'ProductQuote:edit' } onClick={ () => handleUplate(scope.row) }>修改</ElButton>
                      </>
                    )}
                  </ElTableColumn>
                </ElTable>
                <ElPagination ref={ pagin } layout="prev, pager, next, jumper, total" currentPage={ currentPage.value } pageSize={ pageSize.value } total={ total.value } defaultPageSize={ pageSize.value } style={{ justifyContent: 'center', paddingTop: '10px' }} onUpdate:currentPage={ (page) => currentPageChange(page) } onUupdate:pageSize={ (size) => pageSizeChange(size) } />
              </>
            )
          }}
        </ElCard>
        <ElDialog v-model={ dialogVisible.value } title={ edit.value ? '修改产品报价' : '新增产品报价' } width='785' center onClose={ () => handleClose() }>
          {{
            default: () => (
              <ElForm class="ml30" model={ form.value } ref={ formRef } inline={ true } rules={ rules } label-width="95">
                <ElFormItem label="销售订单" prop="sale_id">
                  <MySelect v-model={ form.value.sale_id } arrValue={ ['customer_order', 'product.drawing'] } apiUrl="/api/getSaleOrder" query="customer_order" itemValue="customer_order" placeholder="请选择销售订单" onChange={ (value) => saleChange(value) } />
                </ElFormItem>
                <ElFormItem label="报价单号" prop="notice">
                  <ElInput v-model={ form.value.notice } placeholder="请输入报价单号" />
                </ElFormItem>
                <ElFormItem label="产品单价" prop="product_price">
                  <ElInput v-model={ form.value.product_price } placeholder="请输入产品单价" />
                </ElFormItem>
                <ElFormItem label="交易币别" prop="transaction_currency">
                  <ElInput v-model={ form.value.transaction_currency } placeholder="请输入交易币别" />
                </ElFormItem>
                <ElFormItem label="交易条件" prop="other_transaction_terms">
                  <ElInput v-model={ form.value.other_transaction_terms } placeholder="请输入交易条件" />
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