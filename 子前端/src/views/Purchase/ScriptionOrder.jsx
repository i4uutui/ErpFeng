import { defineComponent, ref } from 'vue'
import ScriptionOrder from '@/components/pages/Purchase/ScriptionOrder';
import { getItem } from '@/assets/js/storage';
import ScriptionOrder2 from '@/components/pages/Purchase/ScriptionOrder2';

export default defineComponent({
  setup() {
    const user = ref(getItem('user'))
    return() => (
      <>
        {
          user.value.purchase_v == 1 ? <ScriptionOrder /> : <ScriptionOrder2 />
        }
      </>
    )
  }
});