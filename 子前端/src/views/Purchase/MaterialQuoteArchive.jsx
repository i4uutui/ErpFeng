import { defineComponent, ref, onMounted, nextTick } from 'vue'
import request from '@/utils/request';
import { getPageHeight } from '@/utils/tool';
import HeadForm from '@/components/form/HeadForm';

export default defineComponent({
  setup(){
    const formCard = ref(null)
    const pagin = ref(null)
    const formHeight = ref(0);
    let search = ref({
      supplier_code: '',
      supplier_abbreviation: '',
      material_code: '',
      material_name: '',
    })
    let invoice = ref([])
    let payTime = ref([])
    let supplyMethod = ref([])
    let tableData = ref([])
    let currentPage = ref(1);
    let pageSize = ref(20);
    let total = ref(0);

    onMounted(() => {
      nextTick(async () => {
        formHeight.value = await getPageHeight([formCard.value, pagin.value]);
      })
      fetchProductList()
      getConstType()
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
    // 获取常量
    const getConstType = async () => {
      const res = await request.post('/api/getConstType', { type: ['invoice', 'supplyMethod', 'payTime'] })
      if(res.code == 200){
        invoice.value = res.data.filter(o => o.type == 'invoice')
        payTime.value = res.data.filter(o => o.type == 'payTime')
        supplyMethod.value =  res.data.filter(o => o.type == 'supplyMethod')
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
    const goBack = () => {
      window.location.href = "/#/purchase/material-quote";
    }

    return() => (
      <>
        <ElCard>
          {{
            header: () => (
              <div class="flex row-between" ref={ formCard }>
                <div class="flex flex-1">
                  <div class="flex pl10">
                    <span>供应商编码：</span>
                    <ElInput v-model={ search.value.supplier_code } style={{ width: '160px' }} placeholder="请输入产品编码" />
                  </div>
                  <div class="flex pl10">
                    <span>供应商名称：</span>
                    <ElInput v-model={ search.value.supplier_abbreviation } style={{ width: '160px' }} placeholder="请输入产品名称" />
                  </div>
                  <div class="flex pl10">
                    <span>材料编码：</span>
                    <ElInput v-model={ search.value.material_code } style={{ width: '160px' }} placeholder="请输入产品编码" />
                  </div>
                  <div class="flex pl10">
                    <span>材料名称：</span>
                    <ElInput v-model={ search.value.material_name } style={{ width: '160px' }} placeholder="请输入材料名称" />
                  </div>
                  <div class="pl10">
                    <ElButton style="margin-top: -5px" type="primary" onClick={ fetchProductList } >
                      查询
                    </ElButton>
                  </div>
                </div>
                <div class="pl10">
                  <ElButton style="margin-top: -5px" type="warning" onClick={ () => goBack() } >
                    返回
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
                  <ElTableColumn prop="unit" label="采购单位" width="100" />
                  <ElTableColumn label="送货方式" width="100">
                    {({row}) => <span>{ supplyMethod.value.find(e => e.id == row.delivery)?.name }</span>}
                  </ElTableColumn>
                  <ElTableColumn prop="packaging" label="包装要求" width="100" />
                  <ElTableColumn label="结算周期" width="120">
                    {({row}) => <span>{ payTime.value.find(e => e.id == row.other_transaction_terms)?.name }</span>}
                  </ElTableColumn>
                  <ElTableColumn label="税票要求" width="110">
                    {({row}) => <span>{ invoice.value.find(e => e.id == row.invoice)?.name }</span>}
                  </ElTableColumn>
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