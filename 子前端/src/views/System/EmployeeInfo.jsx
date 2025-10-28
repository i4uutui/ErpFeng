import { defineComponent, ref, onMounted, reactive, nextTick } from 'vue'
import request from '@/utils/request';
import { reportOperationLog } from '@/utils/log';
import { getPageHeight } from '@/utils/tool';

export default defineComponent({
  setup(){
    const formRef = ref(null);
    const formCard = ref(null)
    const pagin = ref(null)
    const formHeight = ref(0);
    const rules = reactive({
      employee_id: [
        { required: true, message: '请输入员工工号', trigger: 'blur' },
      ],
      name: [
        { required: true, message: '请输入姓名', trigger: 'blur' },
      ],
      cycle_id: [
        { required: true, message: '请输入所属制程', trigger: 'blur' },
      ],
      position: [
        { required: true, message: '请输入生产岗位', trigger: 'blur' },
      ],
      salary_attribute: [
        { required: true, message: '请输入工资属性', trigger: 'blur' },
      ],
    })
    let dialogVisible = ref(false)
    let form = ref({
      employee_id: '',
      name: '',
      password: '',
      cycle_id: '',
      cycle_name: '',
      position: '',
      salary_attribute: '',
    })
    let processCycle = ref([])
    let tableData = ref([])
    let currentPage = ref(1);
    let pageSize = ref(20);
    let total = ref(0);
    let edit = ref(0)
    let constType = ref([])

    onMounted(() => {
      nextTick(async () => {
        formHeight.value = await getPageHeight([formCard.value, pagin.value]);
      })

      getProcessCycle()
      fetchProductList()
      getConstType()
    })

    // 获取列表
    const fetchProductList = async () => {
      const res = await request.get('/api/employee_info', {
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
    // 获取常量
    const getConstType = async () => {
      const res = await request.post('/api/getConstType', { type: 'employeeInfo' })
      if(res.code == 200){
        constType.value = res.data
      }
    }
    const handleSubmit = async (formEl) => {
      if (!formEl) return
      await formEl.validate(async (valid, fields) => {
        if (valid){
          if(!edit.value){
            const res = await request.post('/api/employee_info', form.value);
            if(res && res.code == 200){
              ElMessage.success('新增成功');
              dialogVisible.value = false;
              fetchProductList();
              reportOperationLog({
                operationType: 'add',
                module: '员工信息',
                desc: `新增员工信息：工号：${form.value.employee_id}，姓名：${form.value.name}`,
                data: { newData: form.value }
              })
            }
            
          }else{
            // 修改
            const myForm = {
              id: edit.value,
              ...form.value
            }
            if(myForm.password <= 6) return ElMessage.error('员工密码需大于等于6位')
            const res = await request.put('/api/employee_info', myForm);
            if(res && res.code == 200){
              ElMessage.success('修改成功');
              dialogVisible.value = false;
              fetchProductList();
              reportOperationLog({
                operationType: 'update',
                module: '员工信息',
                desc: `修改员工信息：工号：${myForm.employee_id}，姓名：${myForm.name}`,
                data: { newData: myForm }
              })
            }
          }
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
        const res = await request.delete('/api/employee_info/' + row.id);
        if(res && res.code == 200){
          ElMessage.success('删除成功');
          fetchProductList();
          reportOperationLog({
            operationType: 'delete',
            module: '员工信息',
            desc: `删除员工信息：工号：${row.employee_id}，姓名：${row.name}`,
            data: { newData: row.id }
          })
        }
      }).catch(() => {})
    }
    const handleUplate = (row) => {
      edit.value = row.id;
      dialogVisible.value = true;
      form.value = { ...row };
    }
    // 新增
    const handleAdd = () => {
      rules.password = [
        { required: true, message: '请输入员工密码', trigger: 'blur' },
      ]
      edit.value = 0;
      dialogVisible.value = true;
      resetForm()
    };
    // 取消弹窗
    const handleClose = () => {
      edit.value = 0;
      dialogVisible.value = false;
      if(rules.password && rules.password.length){
        delete rules.password
      }
      resetForm()
    }
    const resetForm = () => {
      form.value = {
        employee_id: '',
        name: '',
        password: '',
        cycle_id: '',
        cycle_name: '',
        position: '',
        salary_attribute: '',
      }
    }
    // 分页相关
    function pageSizeChange(val) {
      currentPage.value = 1;
      pageSize.value = val;
      fetchProductList()
    }
    function currentPageChange(val) {
      currentPage.value = val;
      fetchProductList();
    }

    return() => (
      <>
        <ElCard>
          {{
            header: () => (
              <div class="clearfix" ref={ formCard }>
                <ElButton style="margin-top: -5px" type="primary" v-permission={ 'EmployeeInfo:add' } onClick={ handleAdd } >
                  新增员工信息
                </ElButton>
              </div>
            ),
            default: () => (
              <>
                <ElTable data={ tableData.value } border stripe height={ `calc(100vh - ${formHeight.value + 224}px)` } style={{ width: "100%" }}>
                  <ElTableColumn prop="employee_id" label="员工工号" />
                  <ElTableColumn prop="name" label="姓名" />
                  <ElTableColumn prop="cycle.name" label="所属部门" />
                  <ElTableColumn prop="position" label="生产岗位" />
                  <ElTableColumn label="工资属性">
                    {({row}) => <span>{ constType.value.find(e => e.id == row.salary_attribute)?.name }</span>}
                  </ElTableColumn>
                  <ElTableColumn prop="remarks" label="备注" />
                  <ElTableColumn label="操作" width="140" fixed="right">
                    {(scope) => (
                      <>
                        <ElButton size="small" type="default" v-permission={ 'EmployeeInfo:edit' } onClick={ () => handleUplate(scope.row) }>修改</ElButton>
                        <ElButton size="small" type="danger" v-permission={ 'EmployeeInfo:delete' } onClick={ () => handleDelete(scope.row) }>删除</ElButton>
                      </>
                    )}
                  </ElTableColumn>
                </ElTable>
                <ElPagination ref={ pagin } layout="prev, pager, next, jumper, total" currentPage={ currentPage.value } pageSize={ pageSize.value } total={ total.value } defaultPageSize={ pageSize.value } style={{ justifyContent: 'center', paddingTop: '10px' }} onUpdate:currentPage={ (page) => currentPageChange(page) } onUupdate:pageSize={ (size) => pageSizeChange(size) } />
              </>
            )
          }}
        </ElCard>
        <ElDialog v-model={ dialogVisible.value } title={ edit.value ? '修改员工信息' : '新增员工信息' } onClose={ () => handleClose() }>
          {{
            default: () => (
              <ElForm model={ form.value } ref={ formRef } inline={ true } rules={ rules } label-width="110px">
                <ElFormItem label="员工工号" prop="employee_id">
                  <ElInput v-model={ form.value.employee_id } placeholder="请输入员工工号" />
                </ElFormItem>
                <ElFormItem label="姓名" prop="name">
                  <ElInput v-model={ form.value.name } placeholder="请输入姓名" />
                </ElFormItem>
                <ElFormItem label="密码" prop="password">
                  <ElInput v-model={ form.value.password } placeholder="请输入姓名" />
                </ElFormItem>
                <ElFormItem label="所属部门" prop="cycle_id">
                  <ElSelect v-model={ form.value.cycle_id } multiple={false} filterable remote remote-show-suffix clearable placeholder="请选择所属部门">
                    {processCycle.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="生产岗位" prop="position">
                  <ElInput v-model={ form.value.position } placeholder="请输入生产岗位" />
                </ElFormItem>
                <ElFormItem label="工资属性" prop="salary_attribute">
                  <ElSelect v-model={ form.value.salary_attribute } multiple={ false } filterable remote remote-show-suffix clearable placeholder="请选择工资属性">
                    {constType.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="备注" prop="remarks">
                  <ElInput v-model={ form.value.remarks } placeholder="请输入备注" />
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