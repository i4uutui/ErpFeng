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
      transaction_method: '',
      other_transaction_terms: '',
      other_text: ''
    })
    let method = ref([])
    let payTime = ref([])
    let saleList = ref([])
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
      getSaleOrder()
      getConstType()
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
    const getSaleOrder = async () => {
      const res = await request.get('/api/getSaleOrder')
      if(res.code == 200){
        saleList.value = res.data
      }
    }
    // 获取常量
    const getConstType = async () => {
      const res = await request.post('/api/getConstType', { type: ['payInfo', 'payTime'] })
      if(res.code == 200){
        method.value = res.data.filter(o => o.type == 'payInfo')
        payTime.value = res.data.filter(o => o.type == 'payTime')
      }
    }
    const handleSubmit = async (formEl) => {
      if (!formEl) return
      await formEl.validate(async (valid, fields) => {
        if (valid){
          if(!edit.value){
            const res = await request.post('/api/product_quotation', form.value);
            if(res && res.code == 200){
              ElMessage.success('新增成功');
              dialogVisible.value = false;
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
              reportOperationLog({
                operationType: 'update',
                module: '产品报价',
                desc: `修改产品报价，报价单号：${myForm.notice}`,
                data: { newData: myForm }
              })
            }
          }
          fetchProductList();
          getSaleOrder()
        }
      })
    }
    const handleUplate = (row) => {
      edit.value = row.id;
      dialogVisible.value = true;
      row.other_transaction_terms = Number(row.other_transaction_terms)
      row.sale_id = row.sale.id
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
        transaction_method: '',
        other_transaction_terms: '',
        other_text: ''
      }
    }
    const saleChange = (value) => {
      const row = saleList.value.find(o => o.id == value)
      form.value.other_transaction_terms = Number(row.customer.other_transaction_terms)
      form.value.transaction_method = Number(row.customer.transaction_method)
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
                  <ElTableColumn label="交易方式" width="120">
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
                  <ElTableColumn prop="created_at" label="创建时间" width="120" />
                  <ElTableColumn label="操作" width="140" fixed="right">
                    {(scope) => (
                      <>
                        <ElButton size="small" type="warning" v-permission={ 'ProductQuote:edit' } onClick={ () => handleUplate(scope.row) }>修改</ElButton>
                      </>
                    )}
                  </ElTableColumn>
                </ElTable>
                <ElPagination ref={ pagin } layout="prev, pager, next, jumper, total" currentPage={ currentPage.value } pageSize={ pageSize.value } total={ total.value } defaultPageSize={ pageSize.value } style={{ justifyContent: 'center', paddingTop: '10px' }} onUpdate:currentPage={ (page) => currentPageChange(page) } onUupdate:pageSize={ (size) => pageSizeChange(size) } />
              </>
            )
          }}
        </ElCard>
        <ElDialog v-model={ dialogVisible.value } title={ edit.value ? '修改产品报价' : '新增产品报价' } width='785' center draggable onClose={ () => handleClose() }>
          {{
            default: () => (
              <ElForm class="ml30" model={ form.value } ref={ formRef } inline={ true } rules={ rules } label-width="95">
                <ElFormItem label="客户订单号" prop="sale_id">
                  <ElSelect v-model={ form.value.sale_id } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择客户订单号" onChange={ (row) => saleChange(row) }>
                    {saleList.value.map((e, index) => <ElOption value={ e.id } label={ e.customer_order } disabled={ !e.is_quote } key={ index } />)}
                  </ElSelect>
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