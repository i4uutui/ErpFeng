import { defineComponent, ref, onMounted, nextTick } from 'vue'
import request from '@/utils/request';
import dayjs from "dayjs"
import { getPageHeight, PreciseMath } from '@/utils/tool';
import HeadForm from '@/components/form/HeadForm';
import { getItem } from '@/assets/js/storage';

export default defineComponent({
  setup() {
    const formCard = ref(null)
    const pagin = ref(null)
    const formHeight = ref(0);
    const calcUnit = ref(getItem('constant').filter(o => o.type == 'calcUnit'))
    let tableData = ref([])
    let currentPage = ref(1);
    let pageSize = ref(20);
    let total = ref(0);
    let search = ref({
      created_at: [],
      supplier_code: '',
      supplier_abbreviation: ''
    })

    onMounted(() => {
      nextTick(async () => {
        formHeight.value = await getPageHeight([formCard.value, pagin.value]);
      })
      const currentDate = dayjs();
      const firstDay = currentDate.startOf('month').format('YYYY-MM-DD HH:mm:ss');
      const lastDay = currentDate.endOf('month').format('YYYY-MM-DD HH:mm:ss');
      search.value.created_at = [firstDay, lastDay]
      getList()
    })

    const getList = async () => {
      const res = await request.post('/api/getReceivablePrice', {
        page: 1,
        pageSize: 10,
        type: 4,
        ...search.value
      })
      tableData.value = res.data;
      total.value = res.total;
    }
    const dateChange = (value) => {
      const startTime = `${value[0]} 00:00:00`
      const endTime = `${value[1]} 23:59:59`
      search.value.created_at = [startTime, endTime]
    }
    // 分页相关
    function pageSizeChange(val) {
      currentPage.value = 1;
      pageSize.value = val;
      fetchAdminList()
    }
    function currentPageChange(val) {
      currentPage.value = val;
      fetchAdminList();
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
                      <ElFormItem label="周期：">
                        <el-date-picker v-model={ search.value.created_at } type="daterange" clearable={ false } range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期" value-format="YYYY-MM-DD" onChange={ (row) => dateChange(row) } />
                      </ElFormItem>
                      <ElFormItem label="供应商编码：">
                        <ElInput v-model={ search.value.supplier_code } placeholder="请输入供应商编码" />
                      </ElFormItem>
                      <ElFormItem label="供应商名称：">
                        <ElInput v-model={ search.value.supplier_abbreviation } placeholder="请输入供应商名称" />
                      </ElFormItem>
                    </>
                  ),
                  right: () => (
                    <>
                      <ElFormItem>
                        <ElButton type="primary" onClick={ () => getList() }>查询</ElButton>
                      </ElFormItem>
                    </>
                  )
                }}
              </HeadForm>
            ),
            default: () => (
              <>
                <ElTable data={ tableData.value } border stripe height={ `calc(100vh - ${formHeight.value + 224}px)` } style={{ width: "100%" }}>
                  <ElTableColumn prop="created_at" label="日期" width="110" />
                  <ElTableColumn prop="supplier.supplier_code" label="供应商编码" width="140" />
                  <ElTableColumn prop="supplier.supplier_abbreviation" label="供应商名称" width="140" />
                  <ElTableColumn prop="buy.ment.no" label="采购单号" width="160" />
                  <ElTableColumn prop="apply.no" label="入库单号" width="160" />
                  <ElTableColumn prop="code" label="材料编码" width="130" />
                  <ElTableColumn prop="name" label="材料名称" width="130" />
                  <ElTableColumn prop="model_spec" label="型号&规格" width="110" />
                  <ElTableColumn prop="other_features" label="其它性能" width="110" />
                  <ElTableColumn prop="buy_price" label="采购单价" width="110" />
                  {/* <ElTableColumn prop="price" label="内部单价" width="110" /> */}
                  <ElTableColumn label="采购单位" width="110">
                    {({row}) => <span>{ calcUnit.value.find(e => e.id == row.unit)?.name }</span>}
                  </ElTableColumn>
                  <ElTableColumn prop="pay_quantity" label="交易数量" width="110" />
                  <ElTableColumn label="使用单位" width="110">
                    {({row}) => <span>{ calcUnit.value.find(e => e.id == row.inv_unit)?.name }</span>}
                  </ElTableColumn>
                  <ElTableColumn prop="quantity" label="入库数量" width="110" />
                  <ElTableColumn label="交易金额" width="130">
                    {({row}) => PreciseMath.mul(row.buy_price, row.pay_quantity).toFixed(2)}
                  </ElTableColumn>
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