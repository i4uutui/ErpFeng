import { defineComponent, ref, onMounted, nextTick } from 'vue'
import request from '@/utils/request';
import dayjs from "dayjs"
import { getPageHeight } from '@/utils/tool';
import HeadForm from '@/components/form/HeadForm';

export default defineComponent({
  setup() {
    const formCard = ref(null)
    const pagin = ref(null)
    const formHeight = ref(0);
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
      const res = await request.post('/api/getOutSourcingPrice', {
        page: 1,
        pageSize: 10,
        type: 8,
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
              <HeadForm headerWidth="150px"  labelWidth="100" ref={ formCard }>
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
                  <ElTableColumn prop="created_at" label="日期" />
                  <ElTableColumn prop="supplier.supplier_code" label="供应商编码" />
                  <ElTableColumn prop="supplier.supplier_abbreviation" label="供应商名称" />
                  <ElTableColumn prop="buyPrint.no" label="委外单号" width="160" />
                  <ElTableColumn prop="print.no" label="入库单号" width="160" />
                  <ElTableColumn prop="sourcing.notice.notice" label="生产订单" />
                  <ElTableColumn prop="sourcing.processBom.part.part_name" label="部位名称" />
                  <ElTableColumn prop="sourcing.processChildren.process.process_name" label="工艺名称" />
                  <ElTableColumn prop="sourcing.ment" label="加工内容" />
                  <ElTableColumn prop="quantity" label="入库数量" />
                  <ElTableColumn prop="buy_price" label="委外单价" />
                  <ElTableColumn prop="total_price" label="总价" />
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