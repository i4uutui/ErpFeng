import { defineComponent, reactive, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { SwitchButton } from '@element-plus/icons-vue'
import { clearStorage, getItem, setItem } from '@/assets/js/storage';
import request from '@/utils/request';
import imageError from '@/assets/images/0fc7d20532fdaf769a25683617711.png'
import logo from '@/assets/images/logo.png'
import yun from '@/assets/images/yun.png'
import company from '@/assets/images/company.png'
import "./main.css"

export default defineComponent({
  setup(){
    const router = useRouter();
    const user = reactive(getItem('user'))

    onMounted(() => {
      getApprovalFlow()
    })

    const getApprovalFlow = async () => {
      const res = await request.get('/api/get_approval_flow')
      setItem('approval', res.data)
    }
    const errorHandler = () => {
      // 头像没显示出来
    }
    const loginOut = () => {
      ElMessageBox.confirm('是否确认退出登录？', '提示', {
        confirmButtonText: '退出',
        cancelButtonText: '取消',
        type: 'warning',
      }).then(() => {
        clearStorage()
        router.push('/login');
      }).catch(() => {})
    }
    const goVersion = () => {
      router.push('/version')
    }

    return() => (
      <>
        <div class="flex row-between" style={{ height: '100%' }}>
          <div class="flex flex-1">
            <img src={ logo } style={{ height: "60px" }} />
            <img class="ml10" src={ yun } style={{ height: "60px" }} />
          </div>
          <div>
            <img src={ company } style={{ height: "60px" }} />
          </div>
          <div class="flex flex-1 row-right">
            {/* <div class="mr20" style={{ color: 'blue', cursor: 'pointer' }} onClick={ () => goVersion() }>更新日志 !</div> */}
            <ElAvatar shape="circle" size={ 60 } fit="cover" src={ user.avatar_url }>
              <img src={ imageError } style={{ width: "40px", borderRadius: '50%' }} />
            </ElAvatar>
            <div class="pl20">欢迎您，{ user.name }</div>
            <div class="ml10" style={{ color: 'red', cursor: 'pointer' }} onClick={ loginOut }>退出</div>
          </div>
        </div>
      </>
    )
  }
})