import { defineComponent, ref } from 'vue'
import { getItem } from '@/assets/js/storage'
import MaterialScription from '@/components/pages/Warehouse/MaterialScription'
import MaterialScription2 from '@/components/pages/Warehouse/MaterialScription2'

export default defineComponent({
  setup(){
    const user = ref(getItem('user'))

    return() => (
      <>
        {
          user.value.purchase_v == 1 ? <MaterialScription /> : <MaterialScription2 />
        }
      </>
    )
  }
})