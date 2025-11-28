import { defineComponent, ref, onMounted, nextTick } from 'vue'
import request from '@/utils/request';
import { getPageHeight } from '@/utils/tool';
import { setItem } from '@/assets/js/storage';
import HeadForm from '@/components/form/HeadForm';

export default defineComponent({
  setup(){
    const formRef = ref(null)
    const formCard = ref(null)
    const pagin = ref(null)
    const formHeight = ref(0);
    const rules = ref({
      name: [
        { required: true, message: '请输入名称', trigger: 'blur' },
      ]
    })
    let edit = ref(0)
    let currentPage = ref(1);
    let pageSize = ref(20);
    let total = ref(0);
    let typeList = ref([])
    let tableData = ref([])
    let dialogVisible = ref(false)
    let search = ref({
      name: ''
    })
    let form = ref({
      name: '',
      type: '',
      status: 1
    })

    onMounted(() => {
      nextTick(async () => {
        formHeight.value = await getPageHeight([formCard.value, pagin.value]);
      })
      getConstType()
    })

    // 获取常量
    const getConstType = async () => {
      const res = await request.get('/api/get_const_type')
      if(res.code == 200){
        typeList.value = res.data
        getFetchList()
      }
    }
    // 获取常量分页列表
    const getFetchList = async () => {
      const res = await request.get('/api/const_user', {
        params: {
          page: currentPage.value,
          pageSize: pageSize.value,
          ...search.value
        }
      })
      if(res.code == 200){
        tableData.value = res.data
        total.value = res.total;
      }
    }
    // 获取常量所有列表数据
    const getConstUser = async () => {
      const res = await request.get('/api/getConstUser')
      if(res.code == 200){
        setItem('constant', res.data)
      }
    }
    const switchChange = async (value, row) => {
      const { constType, ...params } = row
      params.status = value
      const res = await request.put('/api/const_user', params)
      if(res.code == 200){
        ElMessage.success('操作成功')
      }
    }
    const handleSubmit = async (formEl) => {
      if (!formEl) return
      await formEl.validate(async (valid, fields) => {
        if (valid){
          if(!edit.value){
            const res = await request.post('/api/const_user', form.value);
            if(res && res.code == 200){
              ElMessage.success('新增成功');
              dialogVisible.value = false;
              getFetchList();
              getConstUser()
              reportOperationLog({
                operationType: 'add',
                module: '系统设置',
                desc: `新增常量名称：${form.value.name}`,
                data: { newData: form.value }
              })
            }
            
          }else{
            // 修改
            const myForm = {
              id: edit.value,
              ...form.value
            }
            const res = await request.put('/api/const_user', myForm);
            if(res && res.code == 200){
              ElMessage.success('修改成功');
              dialogVisible.value = false;
              getFetchList();
              getConstUser()
              reportOperationLog({
                operationType: 'update',
                module: '系统设置',
                desc: `修改常量名称：${myForm.name}`,
                data: { newData: myForm }
              })
            }
          }
        }
      })
    }
    const handleUplate = (row) => {
      edit.value = row.id;
      dialogVisible.value = true;
      form.value = { ...row };
    }
    const handleAdd = async () => {
      edit.value = 0
      resetForm()
      dialogVisible.value = true;
    }
    // 取消弹窗
    const handleClose = () => {
      edit.value = 0;
      dialogVisible.value = false;
      resetForm()
    }
    const resetForm = () => {
      form.value = {
        name: '',
        type: '',
        status: 1
      }
    }
    // 分页相关
    function pageSizeChange(val) {
      currentPage.value = 1;
      pageSize.value = val;
      getFetchList()
    }
    function currentPageChange(val) {
      currentPage.value = val;
      getFetchList();
    }
    
    return () => (
      <>
        <ElCard>
          {{
            header: () => (
              <HeadForm headerWidth="150px" ref={ formCard }>
                {{
                  left: () => (
                    <ElFormItem v-permission={ 'constact:add' }>
                      <ElButton type="primary" onClick={ handleAdd } >
                        新增常量
                      </ElButton>
                    </ElFormItem>
                  ),
                  center: () => (
                    <>
                      <ElFormItem label="常量名称：">
                        <ElInput v-model={ search.value.name } placeholder="请输入常量名称" />
                      </ElFormItem>
                    </>
                  ),
                  right: () => (
                    <ElFormItem>
                      <ElButton type="primary" onClick={ getFetchList }>查询</ElButton>
                    </ElFormItem>
                  )
                }}
              </HeadForm>
            ),
            default: () => (
              <>
                <ElTable data={ tableData.value } border stripe height={`calc(100vh - 304px)`} style={{ width: "100%" }}>
                  <ElTableColumn prop="constType.name" label="常量类型" />
                  <ElTableColumn prop="name" label="常量名称" />
                  {/* <ElTableColumn label="是否开启">
                    {({row}) => {
                      return <ElSwitch v-model={ row.status } active-value={ 1 } inactive-value={ 0 } onChange={ (value) => switchChange(value, row) } />
                    }}
                  </ElTableColumn> */}
                  <ElTableColumn label="操作" width="100">
                    {(scope) => (
                      <>
                        <ElButton size="small" type="warning" v-permission={ 'constact:edit' } onClick={ () => handleUplate(scope.row) }>修改</ElButton>
                      </>
                    )}
                  </ElTableColumn>
                </ElTable>
                <ElPagination ref={ pagin } layout="prev, pager, next, jumper, total" currentPage={ currentPage.value } pageSize={ pageSize.value } total={ total.value } defaultPageSize={ pageSize.value } style={{ justifyContent: 'center', paddingTop: '10px' }} onUpdate:currentPage={ (page) => currentPageChange(page) } onUupdate:pageSize={ (size) => pageSizeChange(size) } />
              </>
            )
          }}
        </ElCard>
        <ElDialog v-model={ dialogVisible.value } title={ edit.value ? '修改常量名称' : '新增常量名称' } width='745' center draggable onClose={ () => handleClose() }>
          {{
            default: () => (
              <ElForm class="ml25" model={ form.value } ref={ formRef } inline={ true } rules={ rules } label-width="80">
                <ElFormItem label="常量类型">
                  <ElSelect v-model={ form.value.type } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择材料编码">
                    {typeList.value.map((e, index) => e && (
                      <ElOption value={ e.type } label={ e.name } key={ index } />
                    ))}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="常量名称">
                  <ElInput v-model={ form.value.name } />
                </ElFormItem>
                {/* <ElFormItem label="是否开启">
                  <ElSwitch v-model={ form.value.status } active-value={ 1 } inactive-value={ 0 } />
                </ElFormItem> */}
              </ElForm>
            ),
            footer: () => (
              <span class="dialog-footer">
                <ElButton onClick={ handleClose } type="warning">取消</ElButton>
                <ElButton type="primary" onClick={ () => handleSubmit(formRef.value) }>确定</ElButton>
              </span>
            )
          }}
        </ElDialog>
      </>
    )
  }
})