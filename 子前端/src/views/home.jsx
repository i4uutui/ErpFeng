import { defineComponent } from 'vue'
import ToDo from '@/components/home/ToDo'
import HolidayCalendar from '@/components/home/HolidayCalendar'
import OrderTotal from '@/components/home/orderTotal'
import TurnTotal from '@/components/home/turnTotal'
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
                    <ElCol md={ 7 } xl={ 8 }>
                      <OrderTotal />
                    </ElCol>
                    <ElCol md={ 10 } xl={ 10 }>
                      <HolidayCalendar />
                    </ElCol>
                    <ElCol md={ 7 } xl={ 8 }>
                      <TurnTotal />
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