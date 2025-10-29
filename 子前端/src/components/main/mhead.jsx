import { defineComponent, reactive, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { SwitchButton } from '@element-plus/icons-vue'
import { getItem, setItem } from '@/assets/js/storage';
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
        localStorage.clear()
        router.push('/login');
      }).catch(() => {})
    }

    return() => (
      <>
        <ElRow align='middle' style={{ height: "74px" }}>
          <ElCol span={ 5 }>
            <div class="flex">
              <img src={ logo } style={{ height: "60px" }} />
              <img src={ yun } style={{ height: "60px", marginLeft: "10px" }} />
            </div>
          </ElCol>
          <ElCol span={ 14 }>
            <div class="f28" style={{ fontWeight: 'bold', textAlign: 'center' }}>
              {/* 企业数字化管理平台 */}
              <img src={ company } style={{ height: "60px" }} />
            </div>
          </ElCol>
          <ElCol span={ 5 }>
            <div class="flex row-right">
              <div style={{ marginRight: '20px', color: 'blue' }}>版本更新 !</div>
              <ElAvatar shape="circle" size={ 60 } fit="cover" src={ user.avatar_url }>
                <img src={ imageError } style={{ width: "40px", borderRadius: '50%' }} />
              </ElAvatar>
              <div class="pl20">欢迎你，{ user.name }</div>
              <div style={{ color: 'red', marginLeft: '10px', cursor: 'pointer' }} onClick={ loginOut }>退出</div>
            </div>
          </ElCol>
        </ElRow>
      </>
    )
  }
})