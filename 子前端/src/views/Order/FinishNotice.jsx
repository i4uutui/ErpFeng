import { defineComponent, onMounted, ref, reactive, nextTick } from 'vue'
import request from '@/utils/request';
import { getPageHeight } from '@/utils/tool';
import HeadForm from '@/components/form/HeadForm';

export default defineComponent({
  setup(){
    const formCard = ref(null)
    const pagin = ref(null)
    const formHeight = ref(0);
    let tableData = ref([])
    let currentPage = ref(1);
    let pageSize = ref(20);
    let total = ref(0);
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
          is_finish: 0,
          ...search.value
        },
      });
      tableData.value = res.data;
      total.value = res.total;
    };
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
                  <ElTableColumn prop="customer.customer_abbreviation" label="客户名称" width="100" />
                  <ElTableColumn prop="sale.customer_order" label="客户订单号" width="100" />
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
                </ElTable>
                <ElPagination ref={ pagin } layout="prev, pager, next, jumper, total" currentPage={ currentPage.value } pageSize={ pageSize.value } total={ total.value } defaultPageSize={ pageSize.value } style={{ justifyContent: 'center', paddingTop: '10px' }} onUpdate:currentPage={ (page) => currentPageChange(page) } onUupdate:pageSize={ (size) => pageSizeChange(size) } />
              </>
            )
          }}
        </ElCard>
      </>
    )
  }
})