import { defineComponent, ref, reactive, nextTick, watch } from 'vue';
import { Key, UserFilled } from '@element-plus/icons-vue'
import { useRouter } from 'vue-router';
import { setItem } from '@/assets/js/storage';
import request from '@/utils/request';
import "@/assets/css/login.css"
import { reportOperationLog } from '@/utils/log';
import logo from '@/assets/images/logo.png'
import yun from '@/assets/images/yun.png'

export default defineComponent({
  setup(){
    const router = useRouter();
    const loginFormRef = ref(null);
    const passwordInputRef = ref(null);
    const loginForm = ref({
      username: process.env.NODE_ENV === 'development' ? 'admin1' : '',
      // 显示用的掩码
      passwordMask: process.env.NODE_ENV === 'development' ? '******' : '',
    });
    // 真实存储的密码（隐藏，不显示给用户）
    const realPassword = ref(process.env.NODE_ENV === 'development' ? 'admin123' : '');
    const loginRules = reactive({
      username: [
        { required: true, message: '请输入用户名', trigger: 'blur' },
      ],
      passwordMask: [
        { required: true, message: '请输入密码', trigger: 'blur' },
      ],
    });

    watch(() => loginForm.value.passwordMask, (newPass, oldPass) => {
      if(newPass.length > oldPass.length){
        const value = newPass.replace(/\*/g, "")
        realPassword.value = realPassword.value + value
        loginForm.value.passwordMask = '*'.repeat(realPassword.value.length)
        console.log(realPassword.value);
      }
      if(newPass.length < oldPass.length){
        const leng = oldPass.length - newPass.length
        realPassword.value = realPassword.value.slice(0, -leng)
      }
    })

    const handlePasswordInput = (inputValue) => {
      // const value = inputValue.replace(/\*/g, "");
      // realPassword.value = realPassword.value + value
      // console.log(realPassword.value);
      // 2. 强制设置显示为*（不受v-model干扰，因为用了:value单向绑定）
      // loginForm.value.passwordMask = '*'.repeat(realPassword.value.length)
      // 3. 修复光标位置（确保始终在最后）
      // if (passwordInputRef.value) {
      //   const nativeInput = passwordInputRef.value.$el.querySelector('input');
      //   if (nativeInput) {
      //     const cursorPosition = inputValue.length;
      //     // 用setTimeout确保在DOM更新后执行，避免光标错位
      //     setTimeout(() => {
      //       nativeInput.setSelectionRange(cursorPosition, cursorPosition);
      //     }, 0);
      //   }
      // }
    };

    const handleLogin = async () => {
      // 验证表单
      const valid = await loginFormRef.value.validate().catch(() => false);
      if (!valid) return false;

      // 登录前临时切换密码框类型为text
      await nextTick();

      const params = {
        username: loginForm.value.username,
        password: realPassword.value,
      }
      const res = await request.post('api/login', params);
      if (res.code !== 200) return;
      setItem('token', res.token);
      setItem('user', res.user)
      setItem('company', res.company)
      ElMessage.success('登录成功');
      // 登录成功清空表单
      loginForm.value.username = '';
      loginForm.value.password = '';
      reportOperationLog({
        operationType: 'login',
        module: '登录',
        desc: `用户{ ${res.user.name} }成功登录`,
        data: { newData: { username: loginForm.value.username, password: '***' } }
      });
      router.push('/');
    };

    return() => (
      <div class="login-container">
        <div class="login-wrapper">
          <div class="flex row-center mb50">
            <img src={ logo } style={{ height: "60px", width: 'auto' }} />
            <img class="ml20" src={ yun } style={{ height: "60px", width: 'auto' }} />
          </div>
          {/* <div class="login-title">企业数字化管理平台</div> */}
          <ElForm ref={ loginFormRef } model={ loginForm.value } rules={ loginRules } label-width="0" autocomplete="off" class="login-form">
            <ElFormItem prop="username">
              <ElInput v-model={ loginForm.value.username } prefix-icon={ UserFilled } placeholder="用户名" autocomplete="off" onKeydown={(e) => e.key === 'Enter' && handleLogin()} />
            </ElFormItem>
            <ElFormItem prop="password">
              <ElInput ref={ passwordInputRef } v-model={ loginForm.value.passwordMask } prefix-icon={ Key } type="text" placeholder="密码" autocomplete="off" onKeydown={(e) => e.key === 'Enter' && handleLogin()} onInput={ handlePasswordInput } onContextmenu={(e) => e.preventDefault()} />
            </ElFormItem>

            <ElFormItem>
              <ElButton type="primary" onClick={ handleLogin } class="w-full" style={{ width: "100%", marginTop: '15px' }}>
                登　录
              </ElButton>
            </ElFormItem>

          </ElForm>
        </div>
      </div>
    )
  }
})