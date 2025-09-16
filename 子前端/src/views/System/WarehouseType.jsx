import { defineComponent, ref, onMounted, reactive } from 'vue'
import request from '@/utils/request';
import { getItem } from '@/assets/js/storage';

export default defineComponent({
  setup(){
    const formRef = ref(null);
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
      fetchAdminList()
      getWareTypeList()
    })

    // 获取列表
    const fetchAdminList = async () => {
      const res = await request.get('/api/warehouse_cycle');
      tableData.value = res.data;
    };
    const getWareTypeList = async () => {
      const res = await request.get('/api/getConstType', { params: { type: 'house' } })
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
              ElMessage.success('添加成功');
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
    // 添加管理员
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
              <div class="clearfix">
                <ElButton style="margin-top: -5px" type="primary" v-permission={ 'Warehouse:add' } onClick={ handleAdd } >
                  新增仓库
                </ElButton>
              </div>
            ),
            default: () => (
              <>
                <ElTable data={ tableData.value } border stripe style={{ width: "100%" }}>
                  <ElTableColumn prop="name" label="仓库名称" />
                  <ElTableColumn prop="ware.name" label="仓库类型" />
                  <ElTableColumn prop="created_at" label="创建时间" />
                  <ElTableColumn label="操作">
                    {(scope) => (
                      <>
                        <ElButton size="small" type="default" v-permission={ 'Warehouse:edit' } onClick={ () => handleUplate(scope.row) }>修改</ElButton>
                      </>
                    )}
                  </ElTableColumn>
                </ElTable>
              </>
            )
          }}
        </ElCard>
        <ElDialog v-model={ dialogVisible.value } title={ edit.value ? '修改仓库' : '添加仓库' } onClose={ () => handleClose() }>
          {{
            default: () => (
              <ElForm model={ form.value } ref={ formRef } rules={ rules } label-width="80px">
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