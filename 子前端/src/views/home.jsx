import { defineComponent } from 'vue'
import ToDo from '@/components/home/ToDo'
import HolidayCalendar from '@/components/home/HolidayCalendar'
import orderEchart from '@/components/home/orderEchart'
import '@/assets/css/home.scss'

export default defineComponent({
  setup(){
    return() => (
      <>
        <div class='home'>
          <ElCard style={{ height: '100%' }}>
            {{
              default: () => (
                <>
                  <ElRow gutter={ 16 }>
                    <ElCol md={ 24 } xl={ 24 }>
                      <ToDo />
                    </ElCol>
                  </ElRow>
                  <ElRow gutter={ 16 }>
                    <ElCol md={ 10 } xl={ 10 }>
                      <HolidayCalendar />
                    </ElCol>
                    <ElCol md={ 8 } xl={ 8 }>
                      <orderEchart />
                    </ElCol>
                  </ElRow>
                </>
              )
            }}
          </ElCard>
        </div>
      </>
    )
  }
})