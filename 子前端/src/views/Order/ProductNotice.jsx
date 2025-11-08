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
        { required: true, message: '请选择报价单号', trigger: 'blur' },
      ],
      notice: [
        { required: true, message: '请输入生产单号', trigger: 'blur' },
      ],
      delivery_time: [
        { required: true, message: '请输入交货日期', trigger: 'blur' },
      ],
    })
    let dialogVisible = ref(false)
    let form = ref({
      sale_id: '',
      notice: '',
      delivery_time: '',
    })
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
    })
    
    // 获取列表
    const fetchProductList = async () => {
      const res = await request.get('/api/product_notice', {
        params: {
          page: currentPage.value,
          pageSize: pageSize.value,
          is_finish: 1,
          ...search.value
        },
      });
      tableData.value = res.data;
      total.value = res.total;
    };
    // 获取销售订单的数据
    const getSaleOrder = async (is_sale, my_id) => {
      let where = {}
      if(is_sale){
        const params = {
          is_sale
        }
        if(my_id){
          params.my_id = my_id
        }
        where = { params }
      }
      const res = await request.get('/api/getSaleOrder', where)
      if(res.code == 200){
        saleList.value = res.data
      }
    }
    const handleSubmit = async (formEl) => {
      if (!formEl) return
      await formEl.validate(async (valid, fields) => {
        if (valid){
          if(!edit.value){
            const res = await request.post('/api/product_notice', form.value);
            if(res && res.code == 200){
              ElMessage.success('新增成功');
              dialogVisible.value = false;
              fetchProductList();
              reportOperationLog({
                operationType: 'add',
                module: '生产通知单',
                desc: `新增生产通知单，订单号：${form.value.notice}`,
                data: { newData: form.value }
              })
            }
            
          }else{
            // 修改
            const myForm = {
              id: edit.value,
              ...form.value
            }
            const res = await request.put('/api/product_notice', myForm);
            if(res && res.code == 200){
              ElMessage.success('修改成功');
              dialogVisible.value = false;
              fetchProductList();
              reportOperationLog({
                operationType: 'update',
                module: '生产通知单',
                desc: `修改生产通知单，订单号：${myForm.notice}`,
                data: { newData: myForm }
              })
            }
          }
        }
      })
    }
    const handleScheduling = (row) => {
      ElMessageBox.confirm('是否确认将此通知单进行排产？', '提示', {
        confirmButtonText: '确认',
        cancelButtonText: '取消',
        type: 'warning',
      }).then(res => {
        request.post('/api/set_production_progress', { id: row.id }).then(res => {
          if(res && res.code == 200){
            ElMessage.success('操作成功');
            reportOperationLog({
              operationType: 'paichang',
              module: '生产通知单',
              desc: `执行通知单排产，订单号：${row.notice}`,
              data: { newData: row.id }
            })
          }
        })
      }).catch({})
    }
    const handleFinish = (row) => {
      ElMessageBox.confirm('是否确认完结此生产订单？此操作不可恢复', '提示', {
        confirmButtonText: '确认',
        cancelButtonText: '取消',
        type: 'warning',
      }).then(res => {
        request.post('/api/finish_production_notice', { id: row.id }).then(res => {
          if(res && res.code == 200){
            ElMessage.success('操作成功');
            fetchProductList()
          }
        })
      }).catch({})
    }
    const handleUplate = (row) => {
      getSaleOrder(1, row.sale_id)
      edit.value = row.id;
      dialogVisible.value = true;
      form.value = { ...row };
    }
    // 新增
    const handleAdd = () => {
      getSaleOrder(1)
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
        delivery_time: '',
      }
    }
    const noticeChange = (value) => {
      const item = saleList.value.find(o => o.id == value)
      form.value.delivery_time = item.goods_time
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
              <HeadForm headerWidth="170px" labelWidth="100" ref={ formCard }>
                {{
                  left: () => (
                    <ElFormItem v-permission={ 'ProductNotice:add' }>
                      <ElButton type="primary" onClick={ handleAdd } style={{ width: '120px' }}>新增生产通知单</ElButton>
                    </ElFormItem>
                  ),
                  center: () => (
                    <>
                      <ElFormItem label="生产订单号：">
                        <ElInput v-model={ search.value.notice } placeholder="请输入生产订单号" style={{ width: '160px' }} />
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
                  <ElTableColumn prop="notice" label="生产订单号" width="120" />
                  <ElTableColumn prop="sale.rece_time" label="接单日期" width="120" />
                  <ElTableColumn prop="customer.customer_code" label="客户编码" width="100" />
                  <ElTableColumn prop="customer.customer_abbreviation" label="客户名称" width="100" />
                  <ElTableColumn prop="sale.customer_order" label="客户订单号" width="140" />
                  <ElTableColumn prop="product.product_code" label="产品编码" width="120" />
                  <ElTableColumn prop="product.product_name" label="产品名称" width="100" />
                  <ElTableColumn prop="product.drawing" label="工程图号" width="120" />
                  <ElTableColumn prop="product.model" label="型号&规格" width="120" />
                  {/* <ElTableColumn prop="product.specification" label="规格" width="100" /> */}
                  <ElTableColumn prop="product.component_structure" label="产品结构" width="100" />
                  <ElTableColumn prop="product.other_features" label="其它特性" width="100" />
                  <ElTableColumn prop="sale.product_req" label="产品要求" width="140" />
                  <ElTableColumn prop="sale.order_number" label="订单数量" width="100" />
                  <ElTableColumn prop="sale.unit" label="单位" width="80" />
                  <ElTableColumn prop="delivery_time" label="交货日期" width="120" />
                  <ElTableColumn prop="created_at" label="创建时间" width="120" />
                  <ElTableColumn label="操作" width="200" fixed="right">
                    {(scope) => (
                      <>
                        <ElButton size="small" type="warning" v-permission={ 'ProductNotice:edit' } onClick={ () => handleUplate(scope.row) }>修改</ElButton>
                        <ElButton size="small" type="primary" v-permission={ 'ProductNotice:date' } onClick={ () => handleScheduling(scope.row) }>排产</ElButton>
                        <ElButton size="small" type="danger" v-permission={ 'ProductNotice:finish' } onClick={ () => handleFinish(scope.row) }>结案</ElButton>
                      </>
                    )}
                  </ElTableColumn>
                </ElTable>
                <ElPagination ref={ pagin } layout="prev, pager, next, jumper, total" currentPage={ currentPage.value } pageSize={ pageSize.value } total={ total.value } defaultPageSize={ pageSize.value } style={{ justifyContent: 'center', paddingTop: '10px' }} onUpdate:currentPage={ (page) => currentPageChange(page) } onUupdate:pageSize={ (size) => pageSizeChange(size) } />
              </>
            )
          }}
        </ElCard>
        <ElDialog v-model={ dialogVisible.value } title={ edit.value ? '修改生产通知单' : '新增生产通知单' } width='785' center draggable onClose={ () => handleClose() }>
          {{
            default: () => (
              <ElForm class="ml30" model={ form.value } ref={ formRef } inline={ true } rules={ rules } label-width="95">
                <ElFormItem label="客户订单号" prop="sale_id">
                  <ElSelect v-model={ form.value.sale_id } multiple={false} filterable remote remote-show-suffix valueKey="id" disabled={ edit.value != 0 } placeholder="请选择客户订单号" onChange={ (row) => noticeChange(row) }>
                    {saleList.value.map((e, index) => <ElOption value={ e.id } label={ e.customer_order } disabled={ !e.is_sale } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="生产订单号" prop="notice">
                  <ElInput v-model={ form.value.notice } placeholder="请输入生产订单号" />
                </ElFormItem>
                <ElFormItem label="交货日期" prop="delivery_time">
                  <ElDatePicker v-model={ form.value.delivery_time } clearable={ false } value-format="YYYY-MM-DD" type="date" placeholder="请选择交货日期" />
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