import { defineComponent, ref, reactive } from 'vue';
import { Key, UserFilled } from '@element-plus/icons-vue'
import { useRouter } from 'vue-router';
import { setItem } from '@/assets/js/storage';
import request from '@/utils/request';
import "@/assets/css/login.css"
import { reportOperationLog } from '@/utils/log';
import logoImg from '@/assets/images/logo.png'

export default defineComponent({
  setup(){
    const router = useRouter();
    const loginFormRef = ref(null);
    const loginForm = reactive({
      username: process.env.NODE_ENV === 'development' ? 'admin1' : '',
      password: process.env.NODE_ENV === 'development' ? 'admin123' : '',
    });
    const loginRules = reactive({
      username: [
        { required: true, message: '请输入用户名', trigger: 'blur' },
      ],
      password: [
        { required: true, message: '请输入密码', trigger: 'blur' },
      ],
    });

    const handleLogin = () => {
      loginFormRef.value.validate((valid) => {
        if (!valid) return false;
        request.post('api/login', loginForm).then(res => {
          if(res.code != 200) return
          setItem('token', res.token);
          setItem('user', res.user)
          setItem('company', res.company)
          ElMessage.success('登录成功');
          router.push('/');

          reportOperationLog({
            operationType: 'login',
            module: '登录',
            desc: `用户{ ${res.user.name} }成功登录`,
            data: { newData: { username: loginForm.username, password: '***' } }
          })
        })
      });
    };

    return() => (
      <div class="login-container">
        <div class="login-wrapper">
          <div class="login-logo"><img src={ logoImg } alt="" /></div>
          <div class="login-title">元方易捷 - 全栈式企业数字化管理平台</div>
          <ElForm ref={ loginFormRef } model={ loginForm } rules={ loginRules } label-width="0" class="login-form">
            <ElFormItem prop="username">
              <ElInput v-model={ loginForm.username } prefix-icon={ UserFilled } placeholder="用户名" onKeydown={(e) => e.key === 'Enter' && handleLogin()} />
            </ElFormItem>
            <ElFormItem prop="password">
              <ElInput v-model={ loginForm.password } prefixIcon={ Key } type="password" placeholder="密码" onKeydown={(e) => e.key === 'Enter' && handleLogin()} />
            </ElFormItem>
            <ElFormItem>
              <ElButton type="primary" onClick={ handleLogin } class="w-full" style={{ width: "100%" }}>
                登录
              </ElButton>
            </ElFormItem>
          </ElForm>
        </div>
      </div>
    )
  }
})