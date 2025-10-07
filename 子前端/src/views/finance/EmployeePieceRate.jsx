import { defineComponent, onMounted, ref } from 'vue'
import request from '@/utils/request';
import { PreciseMath } from '@/utils/tool'
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
      const res = await request.post('/api/rate_wage', {
        page: 1,
        pageSize: 10,
        created_at: dateTime.value
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
                  <ElTableColumn prop="menber.employee_id" label="员工工号" />
                  <ElTableColumn prop="menber.name" label="员工姓名" />
                  <ElTableColumn prop="menber.cycle_name" label="员工制程" />
                  <ElTableColumn prop="created_at" label="生产日期" width="120" />
                  <ElTableColumn prop="bomChildren.notice" label="生产单号" />
                  <ElTableColumn prop="product.product_code" label="产品编码" />
                  <ElTableColumn prop="product.product_name" label="产品名称" />
                  <ElTableColumn prop="part.part_code" label="部件编码" />
                  <ElTableColumn prop="part.part_name" label="部件名称" />
                  <ElTableColumn prop="process.process_code" label="工艺编码" />
                  <ElTableColumn prop="process.process_name" label="工艺名称" />
                  <ElTableColumn prop="number" label="完成数量" />
                  <ElTableColumn prop="bomChildren.price" label="加工单价" />
                  <ElTableColumn label="计件工资">
                    {({row}) => <span>{ PreciseMath.add(row.number, row.bomChildren.price) }</span>}
                  </ElTableColumn>
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