import { defineComponent, ref, onMounted, nextTick } from 'vue'
import request from '@/utils/request';
import { getPageHeight } from '@/utils/tool';
import HeadForm from '@/components/form/HeadForm';
import { getItem } from '@/assets/js/storage';

export default defineComponent({
  setup(){
    const formCard = ref(null)
    const pagin = ref(null)
    const formHeight = ref(0);
    const invoice = ref(getItem('constant').filter(o => o.type == 'invoice'))
    const payTime = ref(getItem('constant').filter(o => o.type == 'payTime'))
    const supplyMethod =  ref(getItem('constant').filter(o => o.type == 'supplyMethod'))
    const method = ref(getItem('constant').filter(o => o.type == 'payInfo'))
    const calcUnit = ref(getItem('constant').filter(o => o.type == 'calcUnit'))
    let search = ref({
      supplier_code: '',
      supplier_abbreviation: '',
      material_code: '',
      material_name: '',
    })
    let tableData = ref([])
    let currentPage = ref(1);
    let pageSize = ref(20);
    let total = ref(0);

    onMounted(() => {
      nextTick(async () => {
        formHeight.value = await getPageHeight([formCard.value, pagin.value]);
      })
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
    const goBack = () => {
      window.location.href = "/#/purchase/material-quote";
    }

    return() => (
      <>
        <ElCard>
          {{
            header: () => (
              <HeadForm headerWidth="150px" labelWidth="100" ref={ formCard }>
                {{
                  center: () => (
                    <>
                      <ElFormItem label="供应商编码：">
                        <ElInput v-model={ search.value.supplier_code } placeholder="请输入供应商编码" />
                      </ElFormItem>
                      <ElFormItem label="供应商名称：">
                        <ElInput v-model={ search.value.supplier_abbreviation } placeholder="请输入供应商名称" />
                      </ElFormItem>
                      <ElFormItem label="材料编码：">
                        <ElInput v-model={ search.value.material_code } placeholder="请输入材料编码" />
                      </ElFormItem>
                      <ElFormItem label="材料名称：">
                        <ElInput v-model={ search.value.material_name } placeholder="请输入材料名称" />
                      </ElFormItem>
                    </>
                  ),
                  right: () => (
                    <>
                      <ElFormItem>
                        <ElButton type="primary" onClick={ fetchProductList }>查询</ElButton>
                      </ElFormItem>
                      <ElFormItem>
                        <ElButton type="warning" onClick={ () => goBack() } >返回</ElButton>
                      </ElFormItem>
                    </>
                  )
                }}
              </HeadForm>
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
                  <ElTableColumn label="交易单位" width="100">
                    {({row}) => <span>{ calcUnit.value.find(e => e.id == row.unit)?.name }</span>}
                  </ElTableColumn>
                  <ElTableColumn label="送货方式" width="100">
                    {({row}) => <span>{ supplyMethod.value.find(e => e.id == row.delivery)?.name }</span>}
                  </ElTableColumn>
                  <ElTableColumn prop="packaging" label="包装要求" width="100" />
                  <ElTableColumn label="交易方式" width="100">
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
                  <ElTableColumn label="税票要求" width="110">
                    {({row}) => <span>{ invoice.value.find(e => e.id == row.invoice)?.name }</span>}
                  </ElTableColumn>
                  <ElTableColumn prop="created_at" label="创建日期" width="120" />
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