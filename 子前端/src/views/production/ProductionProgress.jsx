import { defineComponent, ref, onMounted, reactive } from 'vue'
import request from '@/utils/request';
import Progress from '@/components/production/ProductionProgress'
import open from '@/assets/images/open.png'
import close from '@/assets/images/close.png'
import close1 from '@/assets/images/close1.png'

export default defineComponent({
  setup(){
    let tableData = ref([])
    let currentPage = ref(1);
    let pageSize = ref(10);
    let total = ref(0);
    let dialogVisible = ref(false)
    let notice = ref('')
    let full = ref(false)

    onMounted(() => {
      fetchAdminList()
    })

    // 获取生产订单列表
    const fetchAdminList = async () => {
      const res = await request.get('/api/production_list', {
        params: {
          page: currentPage.value,
          pageSize: pageSize.value,
        },
      });
      tableData.value = res.data;
      total.value = res.total;
    };
    const handleUplate = (row) => {
      notice.value = row.notice
      dialogVisible.value = true
    }
    const openFull = () => {
      const element = document.body;
      if(full.value){
        if (document.exitFullscreen) {
          document.exitFullscreen();
        } else if (document.webkitExitFullscreen) {
          document.webkitExitFullscreen();
        } else if (document.msExitFullscreen) {
          document.msExitFullscreen();
        }
      }else{
        if (element.requestFullscreen) {
          element.requestFullscreen();
        } else if (element.webkitRequestFullscreen) {
          element.webkitRequestFullscreen();
        } else if (element.msRequestFullscreen) {
          element.msRequestFullscreen();
        }
      }
      full.value = !full.value
    }
    const handleClose = () => {
      dialogVisible.value = false
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
            default: () => (
              <>
                <ElTable data={ tableData.value } border stripe style={{ width: "100%" }}>
                  <ElTableColumn prop="notice" label="生产订单号" />
                  <ElTableColumn prop="customer.customer_abbreviation" label="客户名称" />
                  <ElTableColumn prop="product.product_code" label="产品编码" />
                  <ElTableColumn prop="product.product_name" label="产品名称" />
                  <ElTableColumn prop="rece_time" label="接单日期" />
                  <ElTableColumn label="操作" width="140" fixed="right">
                    {(scope) => (
                      <>
                        <ElButton size="small" type="default" onClick={ () => handleUplate(scope.row) }>进度</ElButton>
                      </>
                    )}
                  </ElTableColumn>
                </ElTable>
                <ElPagination layout="prev, pager, next, jumper, total" currentPage={ currentPage.value } pageSize={ pageSize.value } total={ total.value } defaultPageSize={ pageSize.value } style={{ justifyContent: 'center', paddingTop: '10px' }} onUpdate:currentPage={ (page) => currentPageChange(page) } onUupdate:pageSize={ (size) => pageSizeChange(size) } />
              </>
            )
          }}
        </ElCard>
        <ElDialog v-model={ dialogVisible.value } fullscreen appendToBody closeOnClickModal={ false } destroyOnClose showClose={ false }>
          {{
            default: () => <Progress notice={ notice.value } />,
            header: () => (
              <>
                <div class='flex' style={{ justifyContent: 'end', marginRight: '10px' }}>
                  <div class="flex" style={{ cursor: 'pointer' }} onClick={ () => openFull() }>
                    <div><img src={ full.value ? close : open } style={{ width: '20px', height: '20px' }} /></div>
                  </div>
                  {full.value == false ? <div class="flex" style={{ cursor: 'pointer' }} onClick={ () => handleClose() }>
                    <div style={{ marginLeft: "10px" }}><img src={ close1 } style={{ width: '20px', height: '20px' }} /></div>
                  </div> : ''}
                </div>
              </>
            )
          }}
        </ElDialog>
      </>
    )
  }
})