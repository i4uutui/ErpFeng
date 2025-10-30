import { defineComponent, ref, onMounted, reactive, watch, nextTick } from 'vue'
import request from '@/utils/request';
import router from '@/router';
import { getItem } from '@/assets/js/storage';
import { filterMenu, getPageHeight } from '@/utils/tool';

export default defineComponent({
  setup(){
    const cascaderRef = ref(null)
    const formRef = ref(null);
    const formCard = ref(null)
    const pagin = ref(null)
    const formHeight = ref(0);
    const props = reactive({
      multiple: true,
    })
    const user = getItem('user')
    const rules = reactive({
      username: [
        { required: true, message: '请输入用户名', trigger: 'blur' },
      ],
      name: [],
      power: [
        { required: true, message: '请选择用户权限', trigger: 'blur' },
      ]
    })
    let dialogVisible = ref(false)
    let form = ref({
      uid: user.id,
      username: '',
      password: '',
      cycle_id: '',
      name: '',
      power: [] // 新增权限字段
    })
    let processCycle = ref([])
    let tableData = ref([])
    let currentPage = ref(1);
    let pageSize = ref(20);
    let total = ref(0);
    let edit = ref(0)
    let options = ref([])
    let placeholder = ref('')

    onMounted(() => {
      nextTick(async () => {
        formHeight.value = await getPageHeight([formCard.value, pagin.value]);
      })

      fetchAdminList()
      generateCascaderOptions()
      getProcessCycle()
    })

    // 获取子管理员列表
    const fetchAdminList = async () => {
      const res = await request.get('/api/user', {
        params: {
          page: currentPage.value,
          pageSize: pageSize.value
        },
      });
      tableData.value = res.data;
      total.value = res.total;
    };
    // 获取制程
    const getProcessCycle = async () => {
      const res = await request.get('/api/getProcessCycle')
      if(res.code == 200){
        processCycle.value = res.data
      }
    }
    const handleSubmit = async (formEl) => {
      if (!formEl) return
      await formEl.validate(async (valid, fields) => {
        if (valid){
          if(!edit.value){
            form.value.attr = 2
            form.value.company = user.company
            const formValue = {
              ...form.value,
              power: JSON.stringify(form.value.power)
            }
            const res = await request.post('/api/user', formValue);
            if(res && res.code == 200){
              ElMessage.success('新增成功');
              dialogVisible.value = false;
            }
            
          }else{
            // 修改
            const myForm = {
              id: edit.value,
              username: form.value.username,
              password: form.value.password,
              name: form.value.name,
              cycle_id: form.value.cycle_id,
              power: JSON.stringify(form.value.power),
              status: form.value.status,
              uid: user.id,
              company: user.company,
              attr: 2
            }
            const res = await request.put('/api/user', myForm);
            if(res && res.code == 200){
              ElMessage.success('修改成功');
              dialogVisible.value = false;
            }
          }
          fetchAdminList();
        }
      })
    }
    const handleDelete = (row) => {
      ElMessageBox.confirm(
        "是否确认删除？",
        "提示",
        {
          confirmButtonText: '确认',
          cancelButtonText: '取消',
          type: 'warning',
        }
      ).then(async () => {
        const res = await request.delete('/api/user/' + row.id);
        if(res && res.code == 200){
          ElMessage.success('删除成功');
          fetchAdminList();
        }
      }).catch(() => {})
    }
    const closeUser = async (row) => {
      form.value = row;
      const power = row.power
      form.value.power = power
      edit.value = row.id;
      const { password, ...newData } = form.value
      const res = await request.put('/api/user', newData);
      if(res && res.code == 200){
        ElMessage.success('修改成功');
      }
    }
    const handleUplate = (row) => {
      edit.value = row.id;
      placeholder.value = '不输入则默认旧密码'
      dialogVisible.value = true;
      form.value.username = row.username;
      form.value.name = row.name;
      form.value.power = JSON.parse(row.power); // 清空权限选择
      form.value.status = row.status;
      form.value.uid = row.uid;
      form.value.company = row.company;
      form.value.cycle_id = row.cycle_id
      
      if(rules.password){
        delete rules.password
      }
    }
    // 生成级联选择器的选项
    const generateCascaderOptions = () => {
      const { children } = router.options.routes.find(route => route.name === 'Layout');
      const groupedRoutes = {};
      children.forEach(route => {
        if (route.name === 'Home') return;
        
        const { parent } = route.meta;
        if (!groupedRoutes[parent]) {
          groupedRoutes[parent] = [];
        }
        const menuItem = {
          value: route.name, // 菜单权限标识
          label: route.meta.title,
          children: [] // 存放按钮权限
        };
        if (route.meta.buttons && route.meta.buttons.length) {
          menuItem.children = route.meta.buttons.map(btn => ({
            value: btn.code, // 按钮权限标识
            label: btn.label, // 按钮显示名称
          }));
        }
        groupedRoutes[parent].push(menuItem);
      });
      let filtered = Object.fromEntries(
        Object.entries(filterMenu(groupedRoutes, ['ApprovalStep', 'Trajectory', 'Home', 'Version'])).filter(([_, routes]) => routes.length > 0)
      );
      options.value = Object.entries(filtered).map(([key, value]) => ({
        value: key,
        label: key,
        children: value,
      }));
    }
    // 新增管理员
    const handleAdd = () => {
      edit.value = 0;
      dialogVisible.value = true;
      form.value.username = '';
      form.value.password = '';
      form.value.name = '';
      form.value.cycle_id = ''
      form.value.power = []; // 清空权限选择

      placeholder.value = '请输入密码'
      rules.password = [
        { required: true, message: '请输入密码', trigger: 'blur' },
        { min: 6, message: '密码长度不少于6位', trigger: 'blur' },
      ]
    };
    // 取消弹窗
    const handleClose = () => {
      edit.value = 0;
      dialogVisible.value = false;
      form.value.username = '';
      form.value.password = '';
      form.value.name = '';
      form.value.cycle_id = ''
      form.value.power = []; // 清空权限选择
    }
    const handleChange = (values) => {

    }
    function syncChildrenCheckStatus(nodes) {
      nodes.forEach(node => {
        if (node.children && node.children.length > 0) {
          node.children.forEach(child => {
            child.checked = node.checked;
          });
          syncChildrenCheckStatus(node.children);
        }
      });
    }
    function findNodeByName(arr, targetName) {
      for (const node of arr) {
        if (node.value === targetName) {
          return node;
        }
        if (node.children && node.children.length > 0) {
          const result = findNodeByName(node.children, targetName);
          if (result) {
            return result;
          }
        }
      }
      return null;
    }
    // 分页相关
    function pageSizeChange(val) {
      currentPage.value = 1;
      pageSize.value = val;
      fetchAdminList()
    }
    function currentPageChange(val) {
      currentPage.value = val;
      fetchAdminList();
    }
    return() => (
      <>
        <ElCard>
          {{
            header: () => (
              <div class="clearfix" ref={ formCard }>
                <ElButton style="margin-top: -5px" type="primary" v-permission={ 'user:add' } onClick={ handleAdd } >
                  新增用户
                </ElButton>
              </div>
            ),
            default: () => (
              <>
                <ElTable data={ tableData.value } border stripe height={ `calc(100vh - ${formHeight.value + 224}px)` } style={{ width: "100%" }}>
                  <ElTableColumn prop="username" label="用户名" width="180" />
                  <ElTableColumn prop="name" label="姓名" width="180" />
                  <ElTableColumn prop="cycle.name" label="工作岗位" width="180"></ElTableColumn>
                  <ElTableColumn prop="status" label="是否开启" width="180">
                    {(scope) => <ElSwitch v-model={ scope.row.status } active-value={ 1 } inactive-value={ 0 } onChange={ () => closeUser(scope.row) } />}
                  </ElTableColumn>
                  <ElTableColumn prop="created_at" label="创建时间" width="180" />
                  <ElTableColumn label="操作">
                    {(scope) => (
                      <>
                        <ElButton size="small" type="default" v-permission={ 'user:edit' } onClick={ () => handleUplate(scope.row) }>修改</ElButton>
                        <ElButton size="small" type="danger" v-permission={ 'user:delete' } onClick={ () => handleDelete(scope.row) }>删除</ElButton>
                      </>
                    )}
                  </ElTableColumn>
                </ElTable>
                <ElPagination ref={ pagin } layout="prev, pager, next, jumper, total" currentPage={ currentPage.value } pageSize={ pageSize.value } total={ total.value } defaultPageSize={ pageSize.value } style={{ justifyContent: 'center', paddingTop: '10px' }} onUpdate:currentPage={ (page) => currentPageChange(page) } onUupdate:pageSize={ (size) => pageSizeChange(size) } />
              </>
            )
          }}
        </ElCard>
        <ElDialog v-model={ dialogVisible.value } title={ edit.value ? '修改用户' : '新增用户' } onClose={ () => handleClose() }>
          {{
            default: () => (
              <ElForm model={ form.value } ref={ formRef } rules={ rules } label-width="80px">
                <ElFormItem label="用户名" prop="username">
                  <ElInput v-model={ form.value.username } placeholder="请输入用户名" />
                </ElFormItem>
                <ElFormItem label="密码" prop="password">
                  <ElInput v-model={ form.value.password } type="password" placeholder={ placeholder.value } />
                </ElFormItem>
                <ElFormItem label="姓名" prop="name">
                  <ElInput v-model={ form.value.name } placeholder="请输入姓名" />
                </ElFormItem>
                <ElFormItem label="所属部门" prop="cycle_id">
                  <ElSelect v-model={ form.value.cycle_id } multiple={false} filterable remote remote-show-suffix clearable placeholder="请选择所属部门">
                    {processCycle.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="菜单权限" prop="power" class="userCascader">
                  <ElCascader ref={ cascaderRef } v-model={ form.value.power } options={ options.value } props={ props } showAllLevels={ false } collapseTags={ true } placeholder="请选择用户权限" onChange={ handleChange }>
                    {{
                      tag: ({ data }) => {
                        const processedParents = new Set();
                        const levelCount = { level1: 0, level2: 0, level3: 0 };

                        function processParent(node) {
                          if (!node) return;
                          const uniqueKey = `${node.label}-${node.level}`;
                          if (!processedParents.has(uniqueKey)) {
                            processedParents.add(uniqueKey);
                            if (node.level === 1) levelCount.level1++;
                            if (node.level === 2) levelCount.level2++;
                          }
                          processParent(node.parent);
                        }

                        // 遍历所有节点
                        data.forEach(item => {
                          const currentNode = item.node;
                          processParent(currentNode.parent);
                          if (currentNode.level === 3) {
                            levelCount.level3++;
                          } else if (currentNode.level === 2) {
                            const uniqueKey = `${currentNode.label}-${currentNode.level}`;
                            if (!processedParents.has(uniqueKey)) {
                              processedParents.add(uniqueKey);
                              levelCount.level2++;
                            }
                          }
                        });
                        return <div class="flex">
                          { levelCount.level1 > 0 ? <ElTag class="mr10">一级菜单 / { levelCount.level1 }</ElTag> : '' }
                          { levelCount.level2 > 0 ? <ElTag class="mr10">二级菜单 / { levelCount.level2 }</ElTag> : '' }
                          { levelCount.level3 > 0 ? <ElTag class="mr10">三级菜单 / { levelCount.level3 }</ElTag> : '' }
                        </div>
                      }
                    }}
                  </ElCascader>
                </ElFormItem>
                <ElFormItem label="是否开启" prop="status">
                  <ElSwitch v-model={ form.value.status } active-value={ 1 } inactive-value={ 0 } />
                </ElFormItem>
              </ElForm>
            ),
            footer: () => (
              <span class="dialog-footer">
                <ElButton onClick={ handleClose }>取消</ElButton>
                <ElButton type="primary" onClick={ () => handleSubmit(formRef.value) }>确定</ElButton>
              </span>
            )
          }}
        </ElDialog>
      </>
    )
  }
})