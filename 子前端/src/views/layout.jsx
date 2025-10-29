import Mhead from '@/components/main/mhead';
import LeftMenu from '@/components/main/leftMenu';
import { defineComponent } from 'vue';
import { RouterView } from 'vue-router'
import { getItem } from '@/assets/js/storage';

export default defineComponent({
  setup(){
    const user = getItem('user')
    const company = getItem('company')

    return() => (
      <ElContainer style={{ height: "100vh", minWidth: '1600px' }}>
        <ElHeader height='74px' style={{ borderBottom: "1px solid #eee", backgroundColor: '#FFF' }}>
          <Mhead />
        </ElHeader>
        <ElContainer style={{ height: "calc(100vh - 104px)" }}>
          <LeftMenu></LeftMenu>
          <ElMain><RouterView /></ElMain>
        </ElContainer>
        <ElFooter height='40px' style="backgroundColor: #FFF">
          <div class="flex row-center" style={{ height: "40px" }}>
            <div class="flex-1 text-left">
            开发者： 东莞元方企业管理咨询有限公司 | 徐庆华：18666885858
            </div>
            <div class="flex-1 text-center">
            粤ICP备2024266535号-2 | SQ01-V1.01
            </div>
            <div class="flex-1 text-right">
              使用企业： { company.name } | 使用者： { user.username }
            </div>
          </div>
        </ElFooter>
      </ElContainer>
    )
  }
})