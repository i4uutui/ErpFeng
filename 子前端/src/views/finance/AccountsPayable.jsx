import { defineComponent, ref, onMounted } from 'vue'
import request from '@/utils/request';
import dayjs from "dayjs"

export default defineComponent({
  setup() {
    let tableData = ref([])
    let currentPage = ref(1);
    let pageSize = ref(10);
    let total = ref(0);
    let dateTime = ref([])

    onMounted(() => {
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
          type: 4,
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
              <ElForm inline={ true }>
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
                <ElTable data={ tableData.value } border stripe style={{ width: "100%" }}>
                  <ElTableColumn prop="created_at" label="日期" />
                  <ElTableColumn prop="plan" label="供应商" />
                  <ElTableColumn prop="buyPrint.no" label="采购单号" width="160" />
                  <ElTableColumn prop="print.no" label="入库单号" width="160" />
                  <ElTableColumn prop="code" label="材料编码" />
                  <ElTableColumn prop="name" label="材料名称" />
                  <ElTableColumn prop="model_spec" label="规格&型号" width="160" />
                  <ElTableColumn prop="other_features" label="其它性能" />
                  <ElTableColumn prop="quantity" label="入库数量" />
                  <ElTableColumn prop="buy_price" label="入库单价" />
                  <ElTableColumn prop="total_price" label="总价" />
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