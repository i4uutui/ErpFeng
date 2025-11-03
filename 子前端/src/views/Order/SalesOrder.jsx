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
      rece_time: [
        { required: true, message: '请选择接单日期', trigger: 'blur' },
      ],
      customer_id: [
        { required: true, message: '请选择客户', trigger: 'blur' },
      ],
      customer_order: [
        { required: true, message: '请输入客户订单号', trigger: 'blur' },
      ],
      product_id: [
        { required: true, message: '请选择产品编码', trigger: 'blur' },
      ],
      product_req: [
        { required: true, message: '请输入产品要求', trigger: 'blur' },
      ],
      order_number: [
        { required: true, message: '请输入订单数量', trigger: 'blur' },
      ],
      unit: [
        { required: true, message: '请输入单位', trigger: 'blur' },
      ],
      delivery_time: [
        { required: true, message: '请输入预拟交期', trigger: 'blur' },
      ],
    })
    let dialogVisible = ref(false)
    let form = ref({
      rece_time: '',
      customer_id: '',
      customer_order: '',
      product_id: '',
      product_req: '',
      order_number: '',
      unit: '',
      delivery_time: '',
      goods_time: '',
      goods_address: '',
    })
    let customerList = ref([])
    let tableData = ref([])
    let currentPage = ref(1);
    let pageSize = ref(20);
    let total = ref(0);
    let edit = ref(0)
    let search = ref({
      customer_code: '',
      customer_abbreviation: '',
      customer_order: '',
      product_code: '',
      product_name: '',
      drawing: ''
    })

    onMounted(() => {
      nextTick(async () => {
        formHeight.value = await getPageHeight([formCard.value, pagin.value]);
      })
      fetchProductList()
      getCustomerInfo()
    })

    // 获取列表
    const fetchProductList = async () => {
      const res = await request.get('/api/sale_order', {
        params: {
          page: currentPage.value,
          pageSize: pageSize.value,
          ...search.value
        },
      });
      tableData.value = res.data;
      total.value = res.total;
    };
    // 获取客户信息列表
    const getCustomerInfo = async () => {
      const res = await request.get('/api/getCustomerInfo')
      if(res.code == 200){
        customerList.value = res.data
      }
    }
    const handleSubmit = async (formEl) => {
      if (!formEl) return
      await formEl.validate(async (valid, fields) => {
        if (valid){
          if(!edit.value){
            const res = await request.post('/api/sale_order', form.value);
            if(res && res.code == 200){
              ElMessage.success('新增成功');
              dialogVisible.value = false;
              fetchProductList();
              reportOperationLog({
                operationType: 'add',
                module: '销售订单',
                desc: `新增销售订单，客户订单号：${form.value.customer_order}`,
                data: { newData: form.value }
              })
            }
            
          }else{
            // 修改
            const myForm = {
              id: edit.value,
              ...form.value
            }
            const res = await request.put('/api/sale_order', myForm);
            if(res && res.code == 200){
              ElMessage.success('修改成功');
              dialogVisible.value = false;
              fetchProductList();
              reportOperationLog({
                operationType: 'update',
                module: '销售订单',
                desc: `修改销售订单，客户订单号：${myForm.customer_order}`,
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
        rece_time: '',
        customer_id: '',
        customer_order: '',
        product_id: '',
        product_req: '',
        order_number: '',
        unit: '',
        delivery_time: '',
        goods_time: '',
        goods_address: '',
      }
    }
    const customerChange = (value) => {
      const item = customerList.value.find(o => o.id == value)
      form.value.goods_address = item.delivery_address
    }
    const productChange = (row) => {
      form.value.product_req = row.production_requirements
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
              <HeadForm headerWidth="150px" labelWidth="100" ref={ formCard }>
                {{
                  left: () => (
                    <ElFormItem v-permission={ 'SalesOrder:add' }>
                      <ElButton type="primary" onClick={ handleAdd } style={{ width: '100px' }}>新增销售订单</ElButton>
                    </ElFormItem>
                  ),
                  center: () => (
                    <>
                      <ElFormItem label="客户编码：">
                        <ElInput v-model={ search.value.customer_code } placeholder="请输入客户编码" style={{ width: '160px' }} />
                      </ElFormItem>
                      <ElFormItem label="客户名称：">
                        <ElInput v-model={ search.value.customer_abbreviation } placeholder="请输入客户名称" style={{ width: '160px' }} />
                      </ElFormItem>
                      <ElFormItem label="客户订单号：">
                        <ElInput v-model={ search.value.customer_order } placeholder="请输入客户订单号" style={{ width: '160px' }} />
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
                  <ElTableColumn prop="rece_time" label="接单日期" width="110" />
                  <ElTableColumn prop="customer.customer_code" label="客户编码" width="100" />
                  <ElTableColumn prop="customer.customer_abbreviation" label="客户名称" width="100" />
                  <ElTableColumn prop="customer_order" label="客户订单号" width="120" />
                  <ElTableColumn prop="product.product_code" label="产品编码" width="120" />
                  <ElTableColumn prop="product.product_name" label="产品名称" width="100" />
                  <ElTableColumn prop="product.drawing" label="工程图号" width="100" />
                  <ElTableColumn prop="product.component_structure" label="产品结构" width="100" />
                  <ElTableColumn prop="product.model" label="型号&规格" width="180" />
                  {/* <ElTableColumn prop="product.specification" label="规格" width="100" /> */}
                  <ElTableColumn prop="product.other_features" label="其他特性" width="100" />
                  <ElTableColumn prop="product_req" label="产品要求" width="140" />
                  <ElTableColumn prop="order_number" label="订单数量" width="100" />
                  <ElTableColumn prop="unit" label="单位" width="80" />
                  <ElTableColumn prop="delivery_time" label="预拟交期" width="120" />
                  <ElTableColumn prop="goods_address" label="送货地点" width="120" />
                  <ElTableColumn label="是否已生成通知单" width="140">
                    {{
                      default: ({row}) => {
                        const dom = row.notice ? '已生成' : <span style={{ color: 'red' }}>未生成</span>
                        return dom
                      }
                    }}
                  </ElTableColumn>
                  <ElTableColumn prop="created_at" label="创建时间" width="120" />
                  <ElTableColumn label="操作" width="140" fixed="right">
                    {(scope) => (
                      <>
                        <ElButton size="small" type="default" v-permission={ 'SalesOrder:edit' } onClick={ () => handleUplate(scope.row) }>修改</ElButton>
                      </>
                    )}
                  </ElTableColumn>
                </ElTable>
                <ElPagination ref={ pagin } layout="prev, pager, next, jumper, total" currentPage={ currentPage.value } pageSize={ pageSize.value } total={ total.value } defaultPageSize={ pageSize.value } style={{ justifyContent: 'center', paddingTop: '10px' }} onUpdate:currentPage={ (page) => currentPageChange(page) } onUupdate:pageSize={ (size) => pageSizeChange(size) } />
              </>
            )
          }}
        </ElCard>
        <ElDialog v-model={ dialogVisible.value } title={ edit.value ? '修改销售订单' : '新增销售订单' } width='785' center draggable onClose={ () => handleClose() }>
          {{
            default: () => (
              <ElForm class="ml30" model={ form.value } ref={ formRef } inline={ true } rules={ rules } label-width="95">
                <ElFormItem label="接单日期" prop="rece_time">
                  <ElDatePicker v-model={ form.value.rece_time } clearable={ false } value-format="YYYY-MM-DD" type="date" placeholder="请选择接单日期" />
                </ElFormItem>
                <ElFormItem label="客户编码" prop="customer_id">
                  <ElSelect v-model={ form.value.customer_id } multiple={false} filterable remote remote-show-suffix clearable valueKey="id" placeholder="请选择客户编码" onChange={ (value) => customerChange(value) }>
                    {customerList.value.map((e, index) => <ElOption value={ e.id } label={ e.customer_code } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="客户名称" prop="customer_id">
                  <ElSelect v-model={ form.value.customer_id } multiple={false} filterable remote remote-show-suffix clearable valueKey="id" placeholder="请选择客户编码" onChange={ (value) => customerChange(value) }>
                    {customerList.value.map((e, index) => <ElOption value={ e.id } label={ e.customer_abbreviation } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="客户订单号" prop="customer_order">
                  <ElInput v-model={ form.value.customer_order } placeholder="请输入客户订单号" />
                </ElFormItem>
                <ElFormItem label="产品编码" prop="product_id">
                  <MySelect v-model={ form.value.product_id } apiUrl="/api/getProductsCode" query="product_code" itemValue="product_code" placeholder="请选择产品编码" onChange={ (value) => productChange(value) } />
                </ElFormItem>
                <ElFormItem label="产品要求" prop="product_req">
                  <ElInput v-model={ form.value.product_req } placeholder="请输入产品要求" />
                </ElFormItem>
                <ElFormItem label="订单数量" prop="order_number">
                  <ElInput v-model={ form.value.order_number } placeholder="请输入订单数量" />
                </ElFormItem>
                <ElFormItem label="单位" prop="unit">
                  <ElInput v-model={ form.value.unit } placeholder="请输入单位" />
                </ElFormItem>
                <ElFormItem label="预拟交期" prop="delivery_time">
                  <ElDatePicker v-model={ form.value.delivery_time } clearable={ false } value-format="YYYY-MM-DD" type="date" placeholder="请选择预拟交期" />
                </ElFormItem>
                <ElFormItem label="交货地点" prop="goods_address">
                  <ElInput v-model={ form.value.goods_address } placeholder="请输入送货地点" />
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