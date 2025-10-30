import { defineComponent, onMounted, ref, reactive, computed } from 'vue'
import dayjs from 'dayjs';
import request from '@/utils/request';
import "@/assets/css/production.scss"

export default defineComponent({
  setup(){
    const loadStats = ref({
      stats: [
        {
          name: '备料组',
          maxLoad: 40
        },
        {
          name: '设备组',
          maxLoad: 30
        },
        {
          name: '生产组',
          maxLoad: 50
        }
      ],
      dates: [
        {
          date: '2025-10-10',
          digital: [5,'-',9]
        },
        {
          date: '2025-10-11',
          digital: ['休',7,9]
        },
        {
          date: '2025-10-12',
          digital: ['休',7,'-']
        },
        {
          date: '2025-10-13',
          digital: [10,7,'-']
        }
      ]
    })
    return() => (
      <>
        <ElCard>
          {{
            header: () => {
              return <ElTable data={loadStats.value.stats} border style={{ width: "100%" }} size="small">
                <ElTableColumn prop="name" width="100" align="center">
                  {{
                    header: () => (
                      <>
                        <span style={{ color: 'red', cursor: 'pointer' }}>全屏展示</span>
                      </>
                    )
                  }}
                </ElTableColumn>
                <ElTableColumn prop="maxLoad" label="极限负荷" width="90" align="center" />
                {loadStats.value.dates.map(dateItem => (
                  <ElTableColumn key={dateItem} label={dateItem.date} width="90" align="center" >
                    {{
                      default: (scope) => {
                        const rowIndex = scope.$index;
                        return dateItem.digital[rowIndex];
                      }
                    }}
                  </ElTableColumn>
                ))}
              </ElTable>
            },
          }}
        </ElCard>
      </>
    )
  }
})