import { defineComponent, onMounted, ref, computed, nextTick, reactive } from 'vue'
import { useStore } from '@/stores';
import { getNoLast, getPageHeight, PreciseMath, setPurchaseOrderNo } from '@/utils/tool'
import { getItem } from '@/assets/js/storage';
import request from '@/utils/request';
import dayjs from "dayjs"
import "@/assets/css/print.scss"
import "@/assets/css/landscape.scss"
import { setPrint } from '@/utils/print';

export default defineComponent({
  setup() {
    const operateValue = reactive({
      1: '入库',
      2: '出库'
    })
    const store = useStore()
    const expandableTable = ref(null)
    const pagin = ref(null)
    const user = getItem('user')
    const formHeight = ref(0);
    const printNo = computed(() => store.printNo)
    const nowDate = ref()
    let dateTime = ref([])
    let constTypeList = ref([])
    let allSelect = ref([])
    let tableData = ref([])
    let currentPage = ref(1);
    let pageSize = ref(20);
    let total = ref(0);

    onMounted(async () => {
      nextTick(async () => {
        formHeight.value = await getPageHeight([pagin.value]);
      })
      nowDate.value = dayjs().format('YYYY-MM-DD HH:mm:ss')
      // 获取最近一年的日期
      const today = dayjs()
      const lastYearStart = today.subtract(1, 'year').startOf('day').format('YYYY-MM-DD HH:mm:ss')
      const lastYearEnd = today.endOf('day').format('YYYY-MM-DD HH:mm:ss')
      dateTime.value = [lastYearStart, lastYearEnd]
      
      await getConstType()
      await getGurchaseOrder()
    })

    const getGurchaseOrder = async () => {
      const params = {
        page: currentPage.value,
        pageSize: pageSize.value,
        ware_id: 3
      }
      const res = await request.get('/api/getWareHouseList', { params })
      if(res.code == 200){
        tableData.value = res.data.map(e => {
          e.expand = false
          return e
        });
        total.value = res.total;
      }
    }
    // 获取常量
    const getConstType = async () => {
      const res = await request.post('/api/get_warehouse_type', { type: ['productIn', 'productOut'] })
      constTypeList.value = res.data
    }
    // 用户主动多选，然后保存到allSelect
    const handleSelectionChange = (select) => {
      allSelect.value = JSON.parse(JSON.stringify(select))
    }
    // 点击某行时的回调
    const handleRowClick = (row, column) => {
      expandableTable.value.toggleRowExpansion(row);
    }
    // 打印
    const onPrint = async (row) => {
      if(row.order && row.order.length){
        let no = ref('')
        const operate = row.order[0].operate
        if(row.no){
          no.value = row.no
        }else{
          const noType = operate == 1 ? 'PR' : 'PC'
          await getNoLast(noType)
          await setPurchaseOrderNo(printNo.value, row.id, noType, 3)
          await getGurchaseOrder()
        }
        const head = [ `仓库类别：成品仓`, `仓库名称：${ row.house.name }`, `统计周期：${ dateTime.value[0] } 至 ${dateTime.value[1]}`]
        const head2 = [['序号', '客户/制程', '物料编码', '物料名称', '规格型号', '数量', '单价', '总价']]
        const body = row.order.map((e, index) => {
          const arr = [index + 1, e.plan, e.code, e.name, e.model_spec, e.quantity, e.buy_price ? e.buy_price : 0, e.approval ? e.total_price : PreciseMath.mul(e.buy_price, e.quantity)]
          return arr
        })
        const data = {
          no: no.value ? no.value : printNo.value,
          name: operate == 1 ? '成品入库单' : '成品出库单'
        }
        const foot = [
          '核准：', '审查：', `制表：${user.name}`, `日期：${nowDate.value}`
        ]
        setPrint(head, head2, body, data, foot)
      }else{
        ElMessage.error('暂无可打印的数据')
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

    return() => (
      <>
        <ElCard>
          {{
            // header: () => (
            //   <HeadForm headerWidth="270px" ref={ formCard }>
            //     {{
            //       left: () => (
            //         <>
            //           <ElFormItem v-permission={ 'PurchaseOrder:print' }>
            //             <ElButton type="primary" style={{ width: '100px' }} onClick={ () => onPrint() }>批量打印</ElButton>
            //           </ElFormItem>
            //         </>
            //       )
            //     }}
            //   </HeadForm>
            // ),
            default: () => (
              <>
                <ElTable ref={ expandableTable } data={ tableData.value } border stripe height={ `calc(100vh - ${formHeight.value + 196}px)` } style={{ width: "100%" }} onSelectionChange={ (select) => handleSelectionChange(select) } onRowClick={ (row, column) => handleRowClick(row, column) }>
                  <ElTableColumn type="expand" width="1">
                    {({ row }) => (
                      <ElTable data={ row.order } border stripe>
                        <ElTableColumn label="出入库方式" width="100">
                          {({row}) => <span>{constTypeList.value.find(o => o.id == row.type).name}</span>}
                        </ElTableColumn>
                        <ElTableColumn prop="plan" label="客户/制程" width="120" />
                        <ElTableColumn prop="code" label="物料编码" width="90" />
                        <ElTableColumn prop="name" label="物料名称" width="100" />
                        <ElTableColumn prop="quantity" label="数量">
                          {({row}) => <span>{ row.quantity ? row.quantity : 0 }</span>}
                        </ElTableColumn>
                        <ElTableColumn prop="model_spec" label="型号&规格" width="110" />
                        <ElTableColumn prop="other_features" label="其他特性" width="110" />
                        <ElTableColumn prop="buy_price" label="单价(元)" width="110">
                          {({row}) => <span>{ row.buy_price ? row.buy_price : 0 }</span>}
                        </ElTableColumn>
                        <ElTableColumn label="总价(元)" width="110">
                          {({row}) => <span>{ row.approval ? row.total_price : PreciseMath.mul(row.buy_price, row.quantity) }</span>}
                        </ElTableColumn>
                        <ElTableColumn prop="apply_name" label="申请人" />
                        <ElTableColumn prop="apply_time" label="申请时间" />
                      </ElTable>
                    )}
                  </ElTableColumn>
                  {/* <ElTableColumn type="selection" width="55" /> */}
                  <ElTableColumn label="出入库">
                    {({row}) => <span>{operateValue[row.operate]}</span>}
                  </ElTableColumn>
                  <ElTableColumn prop="no" label="出入库单号" />
                  <ElTableColumn label="仓库类型">
                    {({row}) => <span>成品仓</span>}
                  </ElTableColumn>
                  <ElTableColumn prop="house.name" label="仓库名称" />
                  <ElTableColumn prop="created_at" label="创建时间" />
                  <ElTableColumn label="操作" width="200" fixed="right">
                    {{
                      default: ({ row }) => (
                        <>
                          <ElButton size="small" type="primary" v-permission={ 'PurchaseOrder:print' } onClick={ () => onPrint(row) }>打印</ElButton>
                        </>
                      )
                    }}
                  </ElTableColumn>
                </ElTable>
                <ElPagination ref={ pagin } layout="prev, pager, next, jumper, total" currentPage={ currentPage.value } pageSize={ pageSize.value } total={ total.value } defaultPageSize={ pageSize.value } style={{ justifyContent: 'center', paddingTop: '10px' }} onUpdate:currentPage={ (page) => currentPageChange(page) } onUpdate:pageSize={ (size) => pageSizeChange(size) } />
              </>
            )
          }}
        </ElCard>
      </>
    )
  }
});