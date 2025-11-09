import { defineComponent, nextTick, onMounted, ref } from 'vue'
import { getPageHeight, PreciseMath } from '@/utils/tool'
import request from '@/utils/request';
import dayjs from "dayjs"
import HeadForm from '@/components/form/HeadForm';

export default defineComponent({
  setup() {
    const formCard = ref(null)
    const pagin = ref(null)
    const formHeight = ref(0);
    let processCycle = ref([])
    let tableData = ref([])
    let currentPage = ref(1);
    let pageSize = ref(20);
    let total = ref(0);
    let search = ref({
      created_at: [],
      employee_id: '',
      name: '',
      cycle_id: ''
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
      getProcessCycle()
    })

    const getList = async () => {
      const res = await request.post('/api/rate_wage', {
        page: 1,
        pageSize: 10,
        ...search.value
      })
      tableData.value = res.data;
      total.value = res.total;
    }
    // 获取制程
    const getProcessCycle = async () => {
      const res = await request.get('/api/getProcessCycle')
      if(res.code == 200){
        processCycle.value = res.data
      }
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
              <HeadForm headerWidth="150px" labelWidth="60" ref={ formCard }>
                {{
                  center: () => (
                    <>
                      <ElFormItem label="周期：">
                        <el-date-picker v-model={ search.value.created_at } type="daterange" clearable={ false } range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期" value-format="YYYY-MM-DD" onChange={ (row) => dateChange(row) } />
                      </ElFormItem>
                      <ElFormItem label="工号：">
                        <ElInput v-model={ search.value.employee_id } placeholder="请输入工号" />
                      </ElFormItem>
                      <ElFormItem label="姓名：">
                        <ElInput v-model={ search.value.name } placeholder="请输入姓名" />
                      </ElFormItem>
                      <ElFormItem label="部门：">
                        <ElSelect v-model={ search.value.cycle_id } multiple={false} filterable remote remote-show-suffix placeholder="请选择制程组">
                          {processCycle.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                        </ElSelect>
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
                  <ElTableColumn prop="menber.employee_id" label="员工工号" />
                  <ElTableColumn prop="menber.name" label="员工姓名" />
                  <ElTableColumn prop="menber.cycle.name" label="所属部门" />
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
                <ElPagination ref={ pagin } layout="prev, pager, next, jumper, total" currentPage={ currentPage.value } pageSize={ pageSize.value } total={ total.value } defaultPageSize={ pageSize.value } style={{ justifyContent: 'center', paddingTop: '10px' }} onUpdate:currentPage={ (page) => currentPageChange(page) } onUupdate:pageSize={ (size) => pageSizeChange(size) } />
              </>
            )
          }}
        </ElCard>
      </>
    )
  }
})