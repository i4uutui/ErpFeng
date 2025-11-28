import { defineComponent, ref, onMounted, reactive, nextTick } from 'vue'
import request from '@/utils/request';
import { reportOperationLog } from '@/utils/log';
import { getPageHeight } from '@/utils/tool';

export default defineComponent({
  setup(){
    const formRef = ref(null);
    const formCard = ref(null)
    const formHeight = ref(0);
    const rules = reactive({
      ware_id: [
        { required: true, message: '请选择仓库类型', trigger: 'blur' },
      ],
      name: [
        { required: true, message: '请输入仓库名称', trigger: 'blur' },
      ],
    })
    let dialogVisible = ref(false)
    let form = ref({
      ware_id: '',
      name: '',
    })
    let wareType = ref([])
    let tableData = ref([])
    let edit = ref(0)

    onMounted(() => {
      nextTick(async () => {
        formHeight.value = await getPageHeight([formCard.value]);
      })

      fetchAdminList()
      getWareTypeList()
    })

    // 获取列表
    const fetchAdminList = async () => {
      const res = await request.get('/api/warehouse_cycle');
      tableData.value = res.data;
    };
    const getWareTypeList = async () => {
      const res = await request.post('/api/get_warehouse_type', { type: 'house' })
      wareType.value = res.data
    }
    const handleSubmit = async (formEl) => {
      if (!formEl) return
      await formEl.validate(async (valid, fields) => {
        if (valid){
          if(!edit.value){
            const formValue = {
              ...form.value,
            }
            const res = await request.post('/api/warehouse_cycle', formValue);
            if(res && res.code == 200){
              ElMessage.success('新增成功');

              reportOperationLog({
                operationType: 'add',
                module: '仓库建立',
                desc: `新增仓库：名称：${formValue.name}`,
                data: { newData: formValue }
              })
            }
            
          }else{
            // 修改
            const myForm = {
              id: edit.value,
              ware_id: form.value.ware_id,
              name: form.value.name,
            }
            const res = await request.put('/api/warehouse_cycle', myForm);
            if(res && res.code == 200){
              ElMessage.success('修改成功');

              reportOperationLog({
                operationType: 'update',
                module: '仓库建立',
                desc: `修改仓库：名称：${myForm.name}`,
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
      form.value.ware_id = row.ware_id
      dialogVisible.value = true;
    }
    // 新增管理员
    const handleAdd = () => {
      edit.value = 0;
      form.value.name = '';
      form.value.ware_id = '';
      dialogVisible.value = true;
    };
    // 取消弹窗
    const handleClose = () => {
      edit.value = 0;
      form.value.name = '';
      form.value.ware_id = '';
      dialogVisible.value = false;
    }

    return() => (
      <>
        <ElCard>
          {{
            header: () => (
              <div class="clearfix" ref={ formCard }>
                <ElButton style="margin-top: -5px" type="primary" v-permission={ 'Warehouse:add' } onClick={ handleAdd } >
                  新增仓库
                </ElButton>
              </div>
            ),
            default: () => (
              <>
                <ElTable data={ tableData.value } border stripe height={ `calc(100vh - ${formHeight.value + 224}px)` } style={{ width: "100%" }}>
                  <ElTableColumn prop="name" label="仓库名称" />
                  <ElTableColumn prop="ware.name" label="仓库类型" />
                  <ElTableColumn prop="created_at" label="创建日期" />
                  <ElTableColumn label="操作">
                    {(scope) => (
                      <>
                        <ElButton size="small" type="warning" v-permission={ 'Warehouse:edit' } onClick={ () => handleUplate(scope.row) }>修改</ElButton>
                      </>
                    )}
                  </ElTableColumn>
                </ElTable>
              </>
            )
          }}
        </ElCard>
        <ElDialog v-model={ dialogVisible.value } title={ edit.value ? '修改仓库' : '新增仓库' } width='750' center draggable onClose={ () => handleClose() }>
          {{
            default: () => (
              <ElForm class="ml30" model={ form.value } ref={ formRef } inline={ true } rules={ rules } label-width="80">
                <ElFormItem label="仓库类型" prop='ware_id' rules={ rules.process_id }>
                  <ElSelect v-model={ form.value.ware_id } multiple={ false } filterable remote remote-show-suffix valueKey="id" placeholder="请选择仓库类型">
                    {{
                      default: () => wareType.value.map((e, index) => <ElOption key={ index } label={ e.name } value={ e.id } />)
                    }}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="名称" prop="name">
                  <ElInput v-model={ form.value.name } placeholder="请输入名称" />
                </ElFormItem>
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