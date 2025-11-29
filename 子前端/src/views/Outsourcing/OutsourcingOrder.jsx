import { defineComponent, onMounted, ref, computed, nextTick } from 'vue'
import { useStore } from '@/stores';
import { getNoLast, getPageHeight, setPurchaseOrderNo } from '@/utils/tool'
import { getItem } from '@/assets/js/storage';
import request from '@/utils/request';
import dayjs from "dayjs"
import "@/assets/css/print.scss"
import "@/assets/css/landscape.scss"
import { setPrint } from '@/utils/print';

export default defineComponent({
  setup() {
    const store = useStore()
    const expandableTable = ref(null)
    const formCard = ref(null)
    const pagin = ref(null)
    const user = getItem('user')
    const formHeight = ref(0);
    const calcUnit = ref(getItem('constant').filter(o => o.type == 'calcUnit'))
    const printNo = computed(() => store.printNo)
    const nowDate = ref()
    let allSelect = ref([])
    let tableData = ref([])
    let currentPage = ref(1);
    let pageSize = ref(20);
    let total = ref(0);

    onMounted(() => {
      nextTick(async () => {
        formHeight.value = await getPageHeight([pagin.value, formCard.value]);
      })
      nowDate.value = dayjs().format('YYYY-MM-DD HH:mm:ss')
      getGurchaseOrder()
    })

    const getGurchaseOrder = async () => {
      const params = {
        page: currentPage.value,
        pageSize: pageSize.value,
      }
      const res = await request.get('/api/get_outsourcing_order', { params })
      if(res.code == 200){
        tableData.value = res.data.map(e => {
          e.expand = false
          return e
        });
        total.value = res.total;
      }
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
        if(row.no){
          no.value = row.no
        }else{
          await getNoLast('WW')
          await setPurchaseOrderNo(printNo.value, row.id, 'WW', 2)
          await getGurchaseOrder()
        }
        const head = [ `供应商：${row.supplier_abbreviation}`, `产品编码：${row.product_code}`, `产品名称：${row.product_name}`, `生产订单：${row.notice}`, ]
        const head2 = [['序号', '部件编码', '部件名称', '工艺编码', '工艺名称', '加工要求', '单位', '委外数量', '加工单价', '币别', '要求交期']]
        const body = row.order.map((e, index) => {
          const arr = [index + 1, e.processBom.part.part_code, e.processBom.part.part_name, e.processChildren.process.process_code, e.processChildren.process.process_name, e.ment, calcUnit.value.find(o => o.id == e.unit)?.name, e.number, e.price,e.transaction_currency,e.delivery_time]
          return arr
        })
        const data = {
          no: no.value ? no.value : printNo.value,
          name: '委外加工单'
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
                <ElTable ref={ expandableTable } data={ tableData.value } border stripe height={ `calc(100vh - ${formHeight.value + 196}px)` } onSelectionChange={ (select) => handleSelectionChange(select) } onRowClick={ (row, column) => handleRowClick(row, column) }>
                  <ElTableColumn type="expand" width="1">
                    {({ row }) => (
                      <ElTable data={ row.order } border stripe>
                        <ElTableColumn prop="processBom.part.part_code" label="部件编码" />
                        <ElTableColumn prop="processBom.part.part_name" label="部件名称" />
                        <ElTableColumn prop="processChildren.process.process_code" label="工艺编码" />
                        <ElTableColumn prop="processChildren.process.process_name" label="工艺名称" />
                        <ElTableColumn prop="ment" label="加工要求" />
                        <ElTableColumn label="单位" width="100">
                          {({row}) => <span>{ calcUnit.value.find(e => e.id == row.unit)?.name }</span>}
                        </ElTableColumn>
                        <ElTableColumn prop="number" label="委外数量" />
                        <ElTableColumn prop="price" label="加工单价" />
                        <ElTableColumn prop="transaction_currency" label="交易币别" />
                        <ElTableColumn prop="delivery_time" label="要求交期" />
                      </ElTable>
                    )}
                  </ElTableColumn>
                  {/* <ElTableColumn type="selection" width="55" /> */}
                  <ElTableColumn prop="no" label="委外单号" />
                  <ElTableColumn prop="notice" label="生产订单号">
                    {({row}) => {
                      const str = row.notice_id == 0 ? '非管控材料' : row.notice
                      return str
                    }}
                  </ElTableColumn>
                  <ElTableColumn prop="supplier_code" label="供应商编码" />
                  <ElTableColumn prop="supplier_abbreviation" label="供应商名称" />
                  <ElTableColumn prop="product_code" label="产品编码" />
                  <ElTableColumn prop="product_name" label="产品名称" />
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