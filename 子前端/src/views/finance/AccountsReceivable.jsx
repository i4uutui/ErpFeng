import { defineComponent, ref, onMounted, nextTick } from 'vue'
import request from '@/utils/request';
import dayjs from "dayjs"
import { getPageHeight } from '@/utils/tool';

export default defineComponent({
  setup() {
    const formCard = ref(null)
    const pagin = ref(null)
    const formHeight = ref(0);
    let tableData = ref([])
    let currentPage = ref(1);
    let pageSize = ref(20);
    let total = ref(0);
    let dateTime = ref([])

    onMounted(() => {
      nextTick(async () => {
        formHeight.value = await getPageHeight([formCard.value, pagin.value]);
      })

      const currentDate = dayjs();
      const firstDay = currentDate.startOf('month').format('YYYY-MM-DD HH:mm:ss');
      const lastDay = currentDate.endOf('month').format('YYYY-MM-DD HH:mm:ss');
      dateTime.value = [firstDay, lastDay]
      getList()
    })

    const getList = async () => {
      const res = await request.get('/api/getReceivablePrice', {
        params: {
          page: 1,
          pageSize: 10,
          type: 14,
          created_at: dateTime.value
        }
      })
      tableData.value = res.data;
      total.value = res.total;
    }
    const dateChange = (value) => {
      const startTime = `${value[0]} 00:00:00`
      const endTime = `${value[1]} 23:59:59`
      dateTime.value = [startTime, endTime]
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
              <ElForm inline={ true } ref={ formCard }>
                <ElFormItem label="周期:">
                  <el-date-picker v-model={ dateTime.value } type="daterange" clearable={ false } range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期" value-format="YYYY-MM-DD" onChange={ (row) => dateChange(row) } />
                </ElFormItem>
                <ElFormItem>
                  <ElButton type="primary" onClick={ () => getList() }>查询</ElButton>
                </ElFormItem>
              </ElForm>
            ),
            default: () => (
              <>
                <ElTable data={ tableData.value } border stripe height={ `calc(100vh - ${formHeight.value + 224}px)` } style={{ width: "100%" }}>
                  <ElTableColumn prop="created_at" label="日期" />
                  <ElTableColumn prop="plan" label="客户名称" />
                  <ElTableColumn prop="sale.customer_order" label="客户订单" />
                  <ElTableColumn prop="print.no" label="送货单号" width="160" />
                  <ElTableColumn prop="code" label="产品编码" />
                  <ElTableColumn prop="name" label="产品名称" />
                  <ElTableColumn prop="model_spec" label="规格&型号" width="160" />
                  <ElTableColumn prop="other_features" label="其它性能" />
                  <ElTableColumn prop="quantity" label="送货数量" />
                  <ElTableColumn prop="buy_price" label="产品单价" />
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