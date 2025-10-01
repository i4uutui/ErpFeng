import { defineComponent, onMounted, ref } from 'vue'
import request from '@/utils/request';
import "@/assets/css/print.scss"
import "@/assets/css/landscape.scss"

export default defineComponent({
  setup(){
    let tableData = ref([])
    let noticeList = ref([])
    let notice_number = ref('')
    let isPrint = ref(false)

    const printObj = ref({
      id: "printTable", // 这里是要打印元素的ID
      popTitle: "派工单", // 打印的标题
      // preview: true, // 是否启动预览模式，默认是false
      zIndex: 20003, // 预览窗口的z-index，默认是20002，最好比默认值更高
      previewBeforeOpenCallback() { console.log('正在加载预览窗口！'); }, // 预览窗口打开之前的callback
      previewOpenCallback() { console.log('已经加载完预览窗口，预览打开了！') }, // 预览窗口打开时的callback
      beforeOpenCallback(vue) {
        console.log('开始打印之前！')
        isPrint.value = true
      }, // 开始打印之前的callback
      openCallback(vue) {
        console.log('监听到了打印窗户弹起了！')
      }, // 调用打印时的callback
      closeCallback() {
        console.log('关闭了打印工具！')
        isPrint.value = false
      }, // 关闭打印的callback(点击弹窗的取消和打印按钮都会触发)
      clickMounted() { console.log('点击v-print绑定的按钮了！') },
    })

    onMounted(() => {
      // fetchProductList()
      getNoticeList()
    })

    // 获取列表
    const fetchProductList = async () => {
      let query = {}
      if(notice_number.value) query.notice_number = notice_number.value
      const res = await request.get('/api/workOrder', { params: { ...query } });
      tableData.value = res.data;

    };
    const getNoticeList = async () => {
      const res = await request.get('/api/workOrder' );
      if(res.data.length){
        noticeList.value = res.data.filter((item, index) => {
          const firstIndex = res.data.findIndex(el => el.notice_number == item.notice_number);
          return index === firstIndex;
        });
      }
    }
    
    return() => (
      <>
        <ElCard>
          {{
            header: () => (
              <div class="flex">
                <div class="pr10 flex">
                  <span style="width: 120px">生产订单号:</span>
                  <ElSelect v-model={ notice_number.value } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择生产订单号" onChange={ () => fetchProductList() }>
                    {noticeList.value.map((e, index) => <ElOption value={ e.notice_number } label={ e.notice_number } key={ index } />)}
                  </ElSelect>
                </div>
                <div class="pr10">
                  {/* <ElButton style="margin-top: -5px" type="primary" onClick={ () => fetchProductList() }>
                    查询
                  </ElButton> */}
                  <ElButton style="margin-top: -5px" type="primary" v-permission={ 'WorkOrder:print' } v-print={ printObj.value }>
                    打印
                  </ElButton>
                </div>
              </div>
            ),
            default: () => (
              <>
                <ElTable data={ tableData.value } border stripe style={{ width: "100%" }}>
                  <ElTableColumn prop='notice_number' label="生产订单号" width="100" />
                  <ElTableColumn prop='product_code' label="产品编码" width="100" />
                  <ElTableColumn prop='product_name' label="产品名称" width="100" />
                  <ElTableColumn prop='product_drawing' label="工程图号" width="100" />
                  <ElTableColumn prop='delivery_time' label="客户交期" width="100" />
                  <ElTableColumn prop='part_code' label="部件编码" width="100" />
                  <ElTableColumn prop='part_name' label="部件名称" width="100" />
                  <ElTableColumn prop='out_number' label="生产数量" width="100" />
                  <ElTableColumn label="派工二维码">
                    {{
                      default: ({row}) => {
                        const divDom = <div class="flex">
                          {row.bom.children.map(e => <div style={{ marginRight: '10px' }}><img src={ e.qr_code } width={ 120 } height={ 120 } /><div style={{ textAlign: 'center' }}>{ e.equipment.cycle.name }:{e.process.process_name}</div></div>)}
                        </div>
                        return divDom
                      }
                    }}
                  </ElTableColumn>
                </ElTable>
                <div class="printTable" id='totalTable2'>
                  <div id="printTable">
                    <table class="print-table">
                      <thead>
                        <tr>
                          <th colspan="4" class="title-cell">
                            <div class="popTitle" style={{ textAlign: 'center', fontSize: '36px' }}>派工单</div>
                          </th>
                        </tr>
                        <tr>
                          <th colspan="4" class="header-cell">
                            <div class="flex row-between print-header">
                              <div>生产订单号：{ notice_number.value }</div>
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
                        {tableData.value.map(e => {
                          const tr = <tr class="table-row">
                            <td>{ e.part_code }</td>
                            <td>{ e.part_name }</td>
                            <td>{ e.out_number }</td>
                            <td><div class="flex">{ e.bom.children.map(o => {
                              const divDom = <div style={{ marginRight: '10px' }}>
                                <img src={ o.qr_code } width={ 100 } height={ 100 } />
                                <div style={{ textAlign: 'center' }}>{ o.equipment.cycle.name }:{o.process.process_name}</div>
                              </div>
                              return divDom
                            }) }</div></td>
                          </tr>
                          return tr
                        })}
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