import { defineComponent, ref } from 'vue'
import { getItem } from '@/assets/js/storage';
import ScriptionOrder from '@/components/pages/Purchase/ScriptionOrder';
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