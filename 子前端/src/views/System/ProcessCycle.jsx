import { defineComponent, ref, onMounted, reactive, nextTick } from 'vue'
import request from '@/utils/request';
import router from '@/router';
import { getItem } from '@/assets/js/storage';
import { reportOperationLog } from '@/utils/log';
import { getPageHeight } from '@/utils/tool';

export default defineComponent({
  setup(){
    const formRef = ref(null);
    const formCard = ref(null)
    const pagin = ref(null)
    const formHeight = ref(0);
    const rules = reactive({
      name: [
        { required: true, message: '请输入制程名称', trigger: 'blur' },
      ],
    })
    let dialogVisible = ref(false)
    let form = ref({
      name: '',
      sort: ''
    })
    let tableData = ref([])
    let currentPage = ref(1);
    let pageSize = ref(20);
    let total = ref(0);
    let edit = ref(0)

    onMounted(() => {
      nextTick(async () => {
        formHeight.value = await getPageHeight([formCard.value, pagin.value]);
      })

      fetchAdminList()
    })

    // 获取列表
    const fetchAdminList = async () => {
      const res = await request.get('/api/process_cycle', {
        params: {
          page: currentPage.value,
          pageSize: pageSize.value
        },
      });
      tableData.value = res.data;
      total.value = res.total;
    };
    const handleSubmit = async (formEl) => {
      if (!formEl) return
      await formEl.validate(async (valid, fields) => {
        if (valid){
          if(!edit.value){
            const formValue = {
              ...form.value,
            }
            const res = await request.post('/api/process_cycle', formValue);
            if(res && res.code == 200){
              ElMessage.success('新增成功');

              reportOperationLog({
                operationType: 'add',
                module: '生产制程',
                desc: `新增生产制程：名称：${formValue.name}`,
                data: { newData: formValue }
              })
            }
            
          }else{
            // 修改
            const myForm = {
              id: edit.value,
              name: form.value.name,
              sort: form.value.sort
            }
            const res = await request.put('/api/process_cycle', myForm);
            if(res && res.code == 200){
              ElMessage.success('修改成功');

              reportOperationLog({
                operationType: 'update',
                module: '生产制程',
                desc: `修改生产制程：名称：${myForm.name}`,
                data: { newData: myForm }
              })
            }
          }
          
          dialogVisible.value = false;
          fetchAdminList();
        }
      })
    }
    const handleUplate = (row) => {
      edit.value = row.id;
      form.value.name = row.name;
      form.value.sort = row.sort;
      dialogVisible.value = true;
    }
    // 新增管理员
    const handleAdd = () => {
      edit.value = 0;
      form.value.name = '';
      form.value.sort = '';
      dialogVisible.value = true;
    };
    // 取消弹窗
    const handleClose = () => {
      edit.value = 0;
      form.value.name = '';
      form.value.sort = '';
      dialogVisible.value = false;
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
                <ElButton style="margin-top: -5px" type="primary" v-permission={ 'ProcessCycle:add' } onClick={ handleAdd } >
                  新增生产制程
                </ElButton>
              </div>
            ),
            default: () => (
              <>
                <ElTable data={ tableData.value } border stripe height={ `calc(100vh - ${formHeight.value + 224}px)` } style={{ width: "100%" }}>
                  <ElTableColumn prop="name" label="名称" />
                  <ElTableColumn prop="sort" label="排序" />
                  <ElTableColumn prop="created_at" label="创建时间" />
                  <ElTableColumn label="操作">
                    {(scope) => (
                      <>
                        <ElButton size="small" type="default" v-permission={ 'ProcessCycle:edit' } onClick={ () => handleUplate(scope.row) }>修改</ElButton>
                      </>
                    )}
                  </ElTableColumn>
                </ElTable>
                <ElPagination ref={ pagin } layout="prev, pager, next, jumper, total" currentPage={ currentPage.value } pageSize={ pageSize.value } total={ total.value } defaultPageSize={ pageSize.value } style={{ justifyContent: 'center', paddingTop: '10px' }} onUpdate:currentPage={ (page) => currentPageChange(page) } onUupdate:pageSize={ (size) => pageSizeChange(size) } />
              </>
            )
          }}
        </ElCard>
        <ElDialog v-model={ dialogVisible.value } title={ edit.value ? '修改生产制程' : '新增生产制程' } width='715' center draggable onClose={ () => handleClose() }>
          {{
            default: () => (
              <ElForm class="ml30" model={ form.value } ref={ formRef } inline={ true } rules={ rules } label-width="60">
                <ElFormItem label="名称" prop="name">
                  <ElInput v-model={ form.value.name } placeholder="请输入名称" />
                </ElFormItem>
                <ElFormItem label="排序" prop="sort">
                  <ElInput v-model={ form.value.sort } placeholder="请输入排序" />
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