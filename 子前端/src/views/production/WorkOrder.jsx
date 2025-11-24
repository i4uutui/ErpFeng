import { defineComponent, nextTick, onMounted, ref } from 'vue'
import request from '@/utils/request';
import "@/assets/css/print.scss"
import "@/assets/css/landscape.scss"
import { getPageHeight } from '@/utils/tool';
import { setPrint } from '@/utils/workPrint';

export default defineComponent({
  setup(){
    const formCard = ref(null)
    const formHeight = ref(0);
    let tableData = ref([])
    let noticeList = ref([])
    let notice_id = ref('')
    let printers = ref([]) //打印机列表

    onMounted(() => {
      nextTick(async () => {
        formHeight.value = await getPageHeight([formCard.value]);
      })
      getPrinters() // 获取打印机列表
      getNoticeList()
    })
    
    // 获取列表
    const fetchProductList = async (value) => {
      const res = await request.get('/api/workQrCode', { params: { notice_id: notice_id.value } });
      tableData.value = res.data
    };
    const getNoticeList = async () => {
      const res = await request.get('/api/workOrder' );
      if(res.data.length){
        noticeList.value = res.data;
      }
    }
    // 获取打印机列表
    const getPrinters = async () => {
      const res = await request.get('/api/printers')
      printers.value = res.data
    }
    // 执行打印
    const onPrint = async () => {
      const list = tableData.value
      if(!list.length) return ElMessage.error('请选择需要打印的数据')
      const body = list.map((e, index) => {
        return {
          part_code: e.part_code,
          part_name: e.part_name,
          out_number: e.out_number,
          images: e.bom.children.map((e, index) => ({ url: e.qr_code, title: `${index + 1}-${e.equipment.cycle.sort}:${e.process.process_name}` }))
        }
      })
      const row = noticeList.value.find(o => o.id == notice_id.value)
      const notice = `生产订单号：${row.notice}`
      const product_code = `产品编码：${tableData.value[0]?.product_code}`
      const product_name = `产品名称：${tableData.value[0]?.product_name}`
      const drawing = `工程图号：${tableData.value[0]?.drawing}`
      const delivery_time = `客户交期：${tableData.value[0]?.notice.delivery_time}`
      const head = [notice, product_code, product_name, drawing, delivery_time]
      
      setPrint(head, body)
    }
    
    return() => (
      <>
        <ElCard>
          {{
            header: () => (
              <div class="flex" ref={ formCard }>
                <div class="pr10 flex">
                  <span style="width: 120px">生产订单号:</span>
                  <ElSelect v-model={ notice_id.value } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择生产订单号" onChange={ (value) => fetchProductList(value) }>
                    {noticeList.value.map((e, index) => <ElOption value={ e.id } label={ e.notice } key={ index } />)}
                  </ElSelect>
                </div>
                <div class="pr10">
                  {/* <ElButton style="margin-top: -5px" type="primary" onClick={ () => fetchProductList() }>
                    查询
                  </ElButton> */}
                  <ElButton style="margin-top: -5px" type="primary" v-permission={ 'WorkOrder:print' } onClick={ () => onPrint() }>
                    打印
                  </ElButton>
                </div>
              </div>
            ),
            default: () => (
              <>
                <ElTable data={ tableData.value } border stripe height={ `calc(100vh - ${formHeight.value + 224}px)` } style={{ width: "100%" }}>
                  <ElTableColumn prop='notice.notice' label="生产订单号" width="100" />
                  <ElTableColumn prop='product_code' label="产品编码" width="100" />
                  <ElTableColumn prop='product_name' label="产品名称" width="100" />
                  <ElTableColumn prop='drawing' label="工程图号" width="100" />
                  <ElTableColumn prop='notice.delivery_time' label="客户交期" width="100" />
                  <ElTableColumn prop='part_code' label="部件编码" width="100" />
                  <ElTableColumn prop='part_name' label="部件名称" width="100" />
                  <ElTableColumn prop='out_number' label="生产数量" width="100" />
                  <ElTableColumn label="派工二维码">
                    {{
                      default: ({ row }) => {
                        // 外层 div 添加 flex-wrap: wrap（自动换行）和 gap（换行/列间距，替代 marginRight）
                        const divDom = (
                          <div style={{ display: 'flex', flexWrap: 'wrap', gap: '10px', padding: '5px 0' }}>
                            {row.bom?.children?.map((e, index) => (
                              // 去掉 marginRight，用外层 gap 统一控制间距（更整洁）
                              <div key={index} style={{ textAlign: 'center' }}>
                                <img src={e.qr_code} width={120} height={120} style={{ display: 'block' }} />
                                <div style={{ marginTop: '5px' }}>
                                  {e.equipment?.cycle?.sort}:{e.process?.process_name}
                                </div>
                              </div>
                            ))}
                          </div>
                        );
                        return divDom;
                      }
                    }}
                  </ElTableColumn>
                </ElTable>
              </>
            )
          }}
        </ElCard>
      </>
    )
  }
})