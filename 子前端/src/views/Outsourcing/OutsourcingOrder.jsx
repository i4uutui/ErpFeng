import { defineComponent, ref, onMounted } from 'vue';
import { getItem } from "@/assets/js/storage";
import request from '@/utils/request';
import dayjs from "dayjs"
import "@/assets/css/print.scss"
import MySelect from '@/components/tables/mySelect.vue';

export default defineComponent({
  setup() {
    const user = ref()
    const nowDate = ref()
    let supplier_abbreviation = ref('')
    let product_name = ref('')
    let product_code = ref('')
    let notice = ref('')
    let tableData = ref([])
    let currentPage = ref(1);
    let pageSize = ref(30);
    let total = ref(0);
    let isPrint = ref(false)
    let allSelect = ref([])
    
    const printObj = ref({
      id: "printTable", // 这里是要打印元素的ID
      popTitle: "委外加工单", // 打印的标题
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
      user.value = getItem('user')
      nowDate.value = dayjs().format('YYYY-MM-DD HH:mm:ss')
      fetchProductList()
    })
    
    // 获取列表
    const fetchProductList = async () => {
      const res = await request.post('/api/outsourcing_quote', {
        page: currentPage.value,
        pageSize: pageSize.value,
        supplier_abbreviation: supplier_abbreviation.value,
        product_name: product_name.value,
        product_code: product_code.value,
        notice: notice.value,
      });
      tableData.value = res.data;
      total.value = res.total;
    };
    const setWarehousing = (value) => {
      ElMessage.error('等待实现......')
    }
    // 点击入库按钮
    const handleWarehousing = (row) => {
      ElMessageBox.confirm('是否确认入库？', '提示', {
        confirmButtonText: '确认',
        cancelButtonText: '取消',
        type: 'warning',
      }).then(res => {
        const all = [row.id]
        setWarehousing(all)
      }).catch({})
    }
    // 用户主动多选，然后保存到allSelect
    const handleSelectionChange = (select) => {
      allSelect.value = select.map(e => e.id)
    }
    // 筛选
    const search = () => {
      fetchProductList()
    }
    // 新增委外加工
    const addOutSourcing = () => {
      
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
            header: () => (
              <div class="flex flex-wrap">
                <div class="pr10 pb20 flex">
                  <span style="width: 90px">供应商名称:</span>
                  <ElInput v-model={ supplier_abbreviation.value } style="width: 160px" placeholder="请输入"/>
                </div>
                <div class="pr10 pb20 flex">
                  <span style="width: 74px">产品编码:</span>
                  <ElInput v-model={ product_code.value } style="width: 160px" placeholder="请输入"/>
                </div>
                <div class="pr10 pb20 flex">
                  <span style="width: 74px">产品名称:</span>
                  <ElInput v-model={ product_name.value } style="width: 160px" placeholder="请输入"/>
                </div>
                <div class="pr10 pb20 flex">
                  <span style="width: 74px">生产订单:</span>
                  <ElInput v-model={ notice.value } style="width: 160px" placeholder="请输入"/>
                </div>
                <div class="pr10 pb20">
                  <ElButton style="margin-top: -5px" type="primary" onClick={ addOutSourcing }>
                    新增委外加工
                  </ElButton>
                  <ElButton style="margin-top: -5px" type="primary" onClick={ search }>
                    查询
                  </ElButton>
                  <ElButton style="margin-top: -5px" type="primary" v-permission={ 'OutsourcingOrder:print' } v-print={ printObj.value }>
                    委外加工单打印
                  </ElButton>
                </div>
              </div>
            ),
            default: () => (
              <>
                <ElTable data={ tableData.value } border stripe onSelectionChange={ (select) => handleSelectionChange(select) }>
                  <ElTableColumn prop="processBom.part.part_code" label="部位编码" />
                  <ElTableColumn prop="processBom.part.part_name" label="部位名称" />
                  <ElTableColumn prop="processChildren.process.process_code" label="工艺编码" />
                  <ElTableColumn prop="processChildren.process.process_name" label="工艺名称" />
                  <ElTableColumn label="加工要求">
                    {({ row }) => <ElInput v-model={ row.ment } placeholder="请输入加工要求" />}
                  </ElTableColumn>
                  <ElTableColumn prop="notice.sale.unit" label="单位" />
                  <ElTableColumn label="委外数量">
                    {({ row }) => <el-input v-model={ row.number } type='number' placeholder="请输入委外数量" />}
                  </ElTableColumn>
                  <ElTableColumn label="加工单价">
                    {({ row }) => <el-input v-model={ row.now_price } type="number" placeholder="请输入加工单价" />}
                  </ElTableColumn>
                  <ElTableColumn prop="notice.sale.delivery_time" label="要求交期" />
                </ElTable>
                <ElPagination layout="prev, pager, next, jumper, total" currentPage={ currentPage.value } pageSize={ pageSize.value } total={ total.value } defaultPageSize={ pageSize.value } style={{ justifyContent: 'center', paddingTop: '10px' }} onUpdate:currentPage={ (page) => currentPageChange(page) } onUupdate:pageSize={ (size) => pageSizeChange(size) } />




                <div class="printTable" id='totalTable2'>
                  <div id="printTable">
                    <div class="flex row-between" style="padding: 20px;width: 640px;">
                      <div>
                        供应商:{ supplier_abbreviation.value }
                      </div>
                      <div>
                        产品编码:{ product_code.value }
                      </div>
                      <div>
                        产品名称:{ product_name.value }
                      </div>
                      <div>
                        生产订单:{ notice.value }
                      </div>
                    </div>
                    <ElTable data={ tableData.value } border stripe style={{ width: "780px" }}>
                      <ElTableColumn prop="processBom.part.part_code" label="部位编码" width="80" />
                      <ElTableColumn prop="processBom.part.part_name" label="部位名称" width="80" />
                      <ElTableColumn prop="processChildren.process.process_code" label="工艺编码" width="80" />
                      <ElTableColumn prop="processChildren.process.process_name" label="工艺名称" width="80" />
                      <ElTableColumn prop="ment" label="加工要求" width="100" />
                      <ElTableColumn prop="notice.sale.unit" label="单位" width="80" />
                      <ElTableColumn prop="number" label="委外数量" width="100" />
                      <ElTableColumn prop="price" label="加工单价" width="80" />
                      <ElTableColumn prop="notice.sale.delivery_time" label="要求交期" width="100" />
                    </ElTable>
                    <div id="extraPrintContent" class="flex" style="justify-content: space-between; padding-top: 6px;width: 780px">
                      <div>核准：</div>
                      <div>审查：</div>
                      <div>制表：{ user.value?.name }</div>
                      <div>日期：{ nowDate.value }</div>
                    </div>
                  </div>
                </div>
              </>
            )
          }}
        </ElCard>
      </>
    )
  }
});