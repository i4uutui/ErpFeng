import { defineComponent, ref, reactive, onMounted, nextTick } from 'vue';
import request from '@/utils/request'
import dayjs from 'dayjs';


export default defineComponent({
  setup() {
    let data = ref({})
    let dateTime = ref([])

    onMounted(async () => {
      // 获取最近一年的日期
      const currentDate = dayjs()
      const firstDay = currentDate.startOf('month').format('YYYY-MM-DD HH:mm:ss');
      const lastDay = currentDate.endOf('month').format('YYYY-MM-DD HH:mm:ss');
      dateTime.value = [firstDay, lastDay]
      
      getOrderTotal()
    });

    const getOrderTotal = async () => {
      const res = await request.get('/api/order_total')
      if(res.code == 200){
        data.value = res.data
      }
    }
    const dateChange = (value) => {
      const startTime = `${value[0]} 00:00:00`
      const endTime = `${value[1]} 23:59:59`
      dateTime.value = [startTime, endTime]

      getOrderTotal()
    }
    
    return () => (
      <ElCard shadow="always" bodyStyle={{ width: '100%', height: '500px', display: 'flex', flexDirection: 'column' }}>
        <div class="flex row-between w100">
          <div class="f16">订单统计</div>
          <div style={{ width: '70%', marginRight: '0' }}>
            <ElDatePicker v-model={ dateTime.value } type="daterange" clearable={ false } range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期" value-format="YYYY-MM-DD" onChange={ (row) => dateChange(row) } style={{ width: '100%' }} />
          </div>
        </div>
        <div class="w100 flex-1">
          <div class="flex homeCardOrder row-between" style={{ flexDirection: 'column', height: '100%', padding: '30px 0 20px 0' }}>
            <ElCard shadow="always" bodyStyle={{ width: '100%' }}>
              <div class="flex w100 row-between">
                <div>在线订单：</div>
                <div>
                  <span class="f26" style={{ color: '#409eff' }}>{ data.value.onlineOrder }</span>
                  <span>笔</span>
                </div>
              </div>
            </ElCard>
            <ElCard shadow="always" bodyStyle={{ width: '100%' }}>
              <div class="flex w100 row-between">
                <div>完成订单：</div>
                <div>
                  <span class="f26" style={{ color: '#409eff' }}>{ data.value.finishOrder }</span>
                  <span>笔</span>
                </div>
              </div>
            </ElCard>
            <ElCard shadow="always" bodyStyle={{ width: '100%' }}>
              <div class="flex w100 row-between">
                <div>延期订单：</div>
                <div>
                  <span class="f26" style={{ color: '#409eff' }}>0</span>
                  <span>笔</span>
                </div>
              </div>
            </ElCard>
            <ElCard shadow="always" bodyStyle={{ width: '100%' }}>
              <div class="flex w100 row-between">
                <div>延期预警：</div>
                <div>
                  <span class="f26" style={{ color: '#409eff' }}>0</span>
                  <span>项</span>
                </div>
              </div>
            </ElCard>
            <ElCard shadow="always" bodyStyle={{ width: '100%' }}>
              <div class="flex w100 row-between">
                <div>订单存量：</div>
                <div>
                  <span class="f26" style={{ color: '#409eff' }}>{ data.value.orderNumber }</span>
                  <span>PCS</span>
                </div>
              </div>
            </ElCard>
          </div>
        </div>
      </ElCard>
    );
  }
});
