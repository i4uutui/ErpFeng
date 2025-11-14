import { defineComponent, nextTick, onMounted, ref, computed } from 'vue'
import request from '@/utils/request';
import "@/assets/css/print.scss"
import "@/assets/css/landscape.scss"
import { getPageHeight } from '@/utils/tool';
import html2pdf from 'html2pdf.js';
import WinPrint from '@/components/print/winPrint';
// import { exportPDF } from '@/utils/exportPDF';

// import { jsPDF } from "jspdf";
// import  { applyPlugin } from 'jspdf-autotable'
// applyPlugin ( jsPDF )
// import { arial } from '@/utils/font/arial.js';

export default defineComponent({
  setup(){
    const formCard = ref(null)
    const formHeight = ref(0);
    let tableData = ref([])
    let noticeList = ref([])
    let notice_id = ref('')
    let setPdfBlobUrl = ref('')
    const noticeNumber = computed(() => {
      const row = noticeList.value.find(o => o.notice_id == notice_id.value)
      return row?.notice.notice
    })
    let isPrint = ref(false)
    let printers = ref([]) //打印机列表
    let printVisible = ref(false)
    let printDataIds = ref([]) // 需要打印的数据的id

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

      const printTable = document.getElementById('printTable'); // 对应页面中表格的 ID

      // const doc = new jsPDF()
      // doc.addFileToVFS("../../utils/font/arial.ttf", arial);
      // doc.addFont("../../utils/font/arial.ttf", "arial", "normal");
      // doc.setFont('arial');
      // doc.autoTable( { html : '#print-table' } ) 
      // doc.save ( 'table.pdf' )



      // const dataUrl = await exportPDF(printTable.innerHTML)
      // setPdfBlobUrl.value = dataUrl
      // printVisible.value = true
      // return


      const opt = {
        margin: 10,
        filename: 'workOrder.pdf',
        image: { type: 'jpeg', quality: 0.98 },
        pagebreak: {
          mode: 'avoid-all', // 自动分页
          before: 'table-header',
          // margin: 10 // 分页后页边距，避免表头与页边距重叠
        },
        onclose: (e) => {
          console.log(e);
        },
        html2canvas: { 
          scale: 2, // 提高清晰度（默认1，2倍更清晰）
          useCORS: true, // 允许跨域图片
          allowTaint: true, // 允许有污染的图片（跨域但无 CORS 时）
          logging: false,
          letterRendering: true,
        }, // 保证清晰度
        jsPDF: {
          unit: 'mm',
          format: 'a4',
          orientation: 'landscape',
          putOnlyUsedFonts: true,
          compress: true
        }
      };
      // 生成 PDF 并转为 Blob
      html2pdf().from(printTable).set(opt).output('blob').then(async pdfBlob => {
        let urlTwo = URL.createObjectURL(pdfBlob);
        setPdfBlobUrl.value = urlTwo
        printVisible.value = true
      }); 
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
                                  {e.equipment?.cycle?.name}:{e.process?.process_name}
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
                <ElDialog v-model={ printVisible.value } title="打印预览" width="900px" destroyOnClose>
                  {{
                    default: () => (
                      <WinPrint printType="ES" url={ setPdfBlobUrl.value } printList={ printers.value } onClose={ () => printVisible.value = false } dataIds={ printDataIds.value } />
                    ),
                  }}
                </ElDialog>
                <div class="printTable" id='totalTable2'>
                  <div id="printTable">
                    <table class="print-table" id='print-table' style={{ width: '100%', borderCollapse: 'collapse' }}>
                      <thead>
                        <tr>
                          <th colspan="4" class="title-cell">
                            <div class="popTitle" style={{ textAlign: 'center', fontSize: '36px' }}>派工单</div>
                          </th>
                        </tr>
                        <tr>
                          <th colspan="4" class="header-cell">
                            <div class="flex row-between print-header">
                              <div>生产订单号：{ noticeNumber.value }</div>
                              <div>产品编码：{ tableData.value[0]?.product_code }</div>
                              <div>产品名称：{ tableData.value[0]?.product_name }</div>
                              <div>工程图号：{ tableData.value[0]?.product_drawing }</div>
                              <div>客户交期：{ tableData.value[0]?.delivery_time }</div>
                            </div>
                          </th>
                        </tr>
                        <tr class="table-header">
                          <th>部件编码</th>
                          <th>部件名称</th>
                          <th>生产数量</th>
                          <th>派工二维码</th>
                        </tr>
                      </thead>
                      <tbody>
                        {tableData.value.map((e, rowIndex) => (
                          <tr class="table-row" key={ rowIndex } style="page-break-inside: avoid;">
                            <td>{ e.part_code }</td>
                            <td>{ e.part_name }</td>
                            <td>{ e.out_number }</td>
                            <td>
                              <div style={{ display: 'flex', flexWrap: 'wrap', gap: '10px', padding: '5px 0' }}>
                                { 
                                  e.bom.children.map((o, qrIndex) => (
                                    <div key={ qrIndex } style={{ marginRight: '10px', width: '80px', height: '120px', pageBreakInside: 'avoid' }}>
                                      <img src={ o.qr_code } width={ 100 } height={ 100 } />
                                      <div style={{ textAlign: 'center', fontSize: '12px' }}>{ o.equipment.cycle.name }:{o.process.process_name}</div>
                                    </div>
                                  )) 
                                }
                              </div>
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                </div>
              </>
            )
          }}
        </ElCard>
      </>
    )
  }
})