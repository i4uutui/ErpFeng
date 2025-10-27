import { defineComponent, ref, onMounted, reactive } from 'vue'
import request from '@/utils/request';

export default defineComponent({
  setup(){
    let search = ref({
      supplier_code: '',
      supplier_abbreviation: '',
      material_code: '',
      material_name: '',
    })
    let tableData = ref([])
    let currentPage = ref(1);
    let pageSize = ref(10);
    let total = ref(0);

    onMounted(() => {
      fetchProductList()
    })

    // 获取列表
    const fetchProductList = async () => {
      const res = await request.get('/api/material_quote', {
        params: {
          page: currentPage.value,
          pageSize: pageSize.value,
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
              <div class="flex">
                <ElForm inline={ true } class="cardHeaderFrom">
                  <ElFormItem label="供应商编码:">
                    <ElInput v-model={ search.value.supplier_code } style="width: 240px" placeholder="请输入产品编码" />
                  </ElFormItem>
                  <ElFormItem label="供应商名称:">
                    <ElInput v-model={ search.value.supplier_abbreviation } style="width: 240px" placeholder="请输入产品名称" />
                  </ElFormItem>
                  <ElFormItem label="材料编码:">
                    <ElInput v-model={ search.value.material_code } style="width: 240px" placeholder="请输入产品编码" />
                  </ElFormItem>
                  <ElFormItem label="材料名称:">
                    <ElInput v-model={ search.value.material_name } style="width: 240px" placeholder="请输入材料名称" />
                  </ElFormItem>
                  <ElFormItem>
                    <ElButton style="margin-top: -5px" type="primary" onClick={ () => fetchProductList() }>查询</ElButton>
                  </ElFormItem>
                </ElForm>
              </div>
            ),
            default: () => (
              <>
                <ElTable data={ tableData.value } border stripe style={{ width: "100%" }}>
                  <ElTableColumn prop="supplier.supplier_code" label="供应商编码" width="100" />
                  <ElTableColumn prop="supplier.supplier_abbreviation" label="供应商名称" width="100" />
                  {/* <ElTableColumn label="生产订单号" width="100">
                    {({row}) => row.notice_id == 0 ? '非管控材料' : row.notice.notice}
                  </ElTableColumn> */}
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