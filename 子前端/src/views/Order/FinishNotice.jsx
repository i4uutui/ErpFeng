import { defineComponent, onMounted, ref, reactive } from 'vue'
import request from '@/utils/request';

export default defineComponent({
  setup(){
    let tableData = ref([])
    let currentPage = ref(1);
    let pageSize = ref(10);
    let total = ref(0);
    
    onMounted(() => {
      fetchProductList()
    })
    
    // 获取列表
    const fetchProductList = async () => {
      const res = await request.get('/api/product_notice', {
        params: {
          page: currentPage.value,
          pageSize: pageSize.value,
          is_finish: 0
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
            // header: () => (
            //   <div class="clearfix">
            //     <ElButton style="margin-top: -5px" type="primary" v-permission={ 'ProductNotice:add' } onClick={ handleAdd } >
            //       新增生产通知单
            //     </ElButton>
            //   </div>
            // ),
            default: () => (
              <>
                <ElTable data={ tableData.value } border stripe style={{ width: "100%" }}>
                  <ElTableColumn prop="notice" label="生产订单号" width="120" />
                  <ElTableColumn prop="sale.rece_time" label="接单日期" width="120" />
                  <ElTableColumn prop="customer.customer_abbreviation" label="客户名称" width="100" />
                  <ElTableColumn prop="sale.customer_order" label="客户订单号" width="100" />
                  <ElTableColumn prop="product.product_code" label="产品编码" width="120" />
                  <ElTableColumn prop="product.product_name" label="产品名称" width="100" />
                  <ElTableColumn prop="product.drawing" label="工程图号" width="120" />
                  <ElTableColumn prop="product.component_structure" label="产品结构" width="100" />
                  <ElTableColumn prop="product.model" label="型号" width="120" />
                  <ElTableColumn prop="product.specification" label="规格" width="100" />
                  <ElTableColumn prop="product.other_features" label="其它特性" width="100" />
                  <ElTableColumn prop="sale.product_req" label="产品要求" width="140" />
                  <ElTableColumn prop="sale.order_number" label="订单数量" width="100" />
                  <ElTableColumn prop="sale.unit" label="单位" width="80" />
                  <ElTableColumn prop="delivery_time" label="交货日期" width="120" />
                  <ElTableColumn prop="created_at" label="创建时间" width="120" />
                </ElTable>
                <ElPagination layout="prev, pager, next, jumper, total" currentPage={ currentPage.value } pageSize={ pageSize.value } total={ total.value } defaultPageSize={ pageSize.value } style={{ justifyContent: 'center', paddingTop: '10px' }} onUpdate:currentPage={ (page) => currentPageChange(page) } onUupdate:pageSize={ (size) => pageSizeChange(size) } />
              </>
            )
          }}
        </ElCard>
      </>
    )
  }
})