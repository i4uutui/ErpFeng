import { defineComponent, reactive, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { SwitchButton } from '@element-plus/icons-vue'
import { getItem, setItem } from '@/assets/js/storage';
import request from '@/utils/request';
import imageError from '@/assets/images/0fc7d20532fdaf769a25683617711.png'
import logo from '@/assets/images/logo.png'
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
        localStorage.clear()
        router.push('/login');
      }).catch(() => {})
    }

    return() => (
      <>
        <ElRow align='middle' style={{ height: "64px" }}>
          <ElCol span={ 8 }>
            <img src={ logo } style={{ width: "340px" }} />
          </ElCol>
          <ElCol span={ 8 }>
            <div class="f28" style={{ fontWeight: 'bold', textAlign: 'center' }}>
              {/* 企业数字化管理平台 */}
            </div>
          </ElCol>
          <ElCol span={ 8 }>
            <div class="flex row-right">
              <ElAvatar shape="circle" size={ 40 } fit="cover" src={ user.avatar_url }>
                <img src={ imageError } style={{ width: "40px", borderRadius: '50%' }} />
              </ElAvatar>
              <div class="pl10">欢迎你，{ user.username }</div>
              <div style={{ color: 'red', marginLeft: '10px', cursor: 'pointer' }} onClick={ loginOut }>退出</div>
            </div>
          </ElCol>
        </ElRow>
      </>
    )
  }
})