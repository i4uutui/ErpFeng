import { defineComponent, ref, reactive, onMounted, nextTick } from 'vue';
import request from '@/utils/request'
import dayjs from 'dayjs';


export default defineComponent({
  setup() {
    let dateTime = ref([])

    onMounted(async () => {
      // 获取最近一年的日期
      const currentDate = dayjs()
      const firstDay = currentDate.startOf('month').format('YYYY-MM-DD HH:mm:ss');
      const lastDay = currentDate.endOf('month').format('YYYY-MM-DD HH:mm:ss');
      dateTime.value = [firstDay, lastDay]

    });

    const dateChange = (value) => {
      const startTime = `${value[0]} 00:00:00`
      const endTime = `${value[1]} 23:59:59`
      dateTime.value = [startTime, endTime]
    }
    
    return () => (
      <ElCard shadow="always" bodyStyle={{ width: '100%', height: '500px', display: 'flex', flexDirection: 'column' }}>
        <div class="flex row-between w100">
          <div class="f16">出勤统计</div>
          <div style={{ width: '70%', marginRight: '0' }}>
            <ElDatePicker v-model={ dateTime.value } type="daterange" clearable={ false } range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期" value-format="YYYY-MM-DD" onChange={ (row) => dateChange(row) } style={{ width: '100%' }} />
          </div>
        </div>
        <div class="w100 flex-1">
          <div class="flex homeCardOrder row-between" style={{ flexDirection: 'column', height: '100%', padding: '30px 0 20px 0' }}>
            <ElCard shadow="always" bodyStyle={{ width: '100%' }}>
              <div class="flex row-between w100">
                <div>理论在岗：</div>
                <div>
                  <span class="f26" style={{ color: '#409eff' }}>0</span>
                  <span>人</span>
                </div>
              </div>
            </ElCard>
            <ElCard shadow="always" bodyStyle={{ width: '100%' }}>
              <div class="flex row-between w100">
                <div>请假人数：</div>
                <div>
                  <span class="f26" style={{ color: '#409eff' }}>0</span>
                  <span>人</span>
                </div>
              </div>
            </ElCard>
            <ElCard shadow="always" bodyStyle={{ width: '100%' }}>
              <div class="flex row-between w100">
                <div>实际到岗：</div>
                <div>
                  <span class="f26" style={{ color: '#409eff' }}>0</span>
                  <span>人</span>
                </div>
              </div>
            </ElCard>
            <ElCard shadow="always" bodyStyle={{ width: '100%' }}>
              <div class="flex row-between w100">
                <div>迟到早退：</div>
                <div>
                  <span class="f26" style={{ color: '#409eff' }}>0</span>
                  <span>人</span>
                </div>
              </div>
            </ElCard>
            <ElCard shadow="always" bodyStyle={{ width: '100%' }}>
              <div class="flex row-between w100">
                <div>缺勤人数：</div>
                <div>
                  <span class="f26" style={{ color: '#409eff' }}>0</span>
                  <span>人</span>
                </div>
              </div>
            </ElCard>
          </div>
        </div>
      </ElCard>
    );
  }
});
