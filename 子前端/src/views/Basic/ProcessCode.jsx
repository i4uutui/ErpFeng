import { defineComponent, ref, onMounted, reactive, nextTick } from 'vue'
import MySelect from '@/components/tables/mySelect.vue';
import request from '@/utils/request';
import { reportOperationLog } from '@/utils/log';
import { getItem } from '@/assets/js/storage';
import { getPageHeight } from '@/utils/tool';
import HeadForm from '@/components/form/HeadForm';

export default defineComponent({
  setup(){
    const formRef = ref(null);
    const formCard = ref(null)
    const pagin = ref(null)
    const formHeight = ref(0);
    const user = reactive(getItem('user'))
    const rules = reactive({
      process_code: [
        { required: true, message: '请输入工艺编码', trigger: 'blur' },
      ],
      process_name: [
        { required: true, message: '请输入工艺名称', trigger: 'blur' },
      ],
      equipment_id: [
        { required: true, message: '请选择设备', trigger: 'blur' },
      ]
    })
    let dialogVisible = ref(false)
    let form = ref({
      equipment_id: '',
      process_code: '',
      process_name: '',
      remarks: '',
    })
    let tableData = ref([])
    let currentPage = ref(1);
    let pageSize = ref(20);
    let total = ref(0);
    let edit = ref(0)
    let search = ref({
      code: '',
      name: ''
    })

    onMounted(() => {
      nextTick(async () => {
        formHeight.value = await getPageHeight([formCard.value, pagin.value]);
      })
      fetchProductList()
    })

    // 获取列表
    const fetchProductList = async () => {
      const res = await request.get('/api/process_code', {
        params: {
          page: currentPage.value,
          pageSize: pageSize.value,
          ...search.value
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
            const res = await request.post('/api/process_code', form.value);
            if(res && res.code == 200){
              ElMessage.success('新增成功');
              dialogVisible.value = false;
              fetchProductList();
              reportOperationLog({
                operationType: 'add',
                module: '工艺编码',
                desc: `新增工艺编码：${form.value.process_code}`,
                data: { newData: form.value }
              })
            }
            
          }else{
            // 修改
            const myForm = {
              id: edit.value,
              ...form.value
            }
            const res = await request.put('/api/process_code', myForm);
            if(res && res.code == 200){
              ElMessage.success('修改成功');
              dialogVisible.value = false;
              fetchProductList();
              reportOperationLog({
                operationType: 'update',
                module: '工艺编码',
                desc: `修改工艺编码：${myForm.process_code}`,
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
        const res = await request.delete('/api/process_code/' + row.id);
        if(res && res.code == 200){
          ElMessage.success('删除成功');
          fetchProductList();
          reportOperationLog({
            operationType: 'delete',
            module: '工艺编码',
            desc: `删除工艺编码：${row.process_code}`,
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
      edit.value = 0;
      dialogVisible.value = true;
      resetForm()
    };
    // 取消弹窗
    const handleClose = () => {
      edit.value = 0;
      dialogVisible.value = false;
      resetForm()
    }
    const resetForm = () => {
      form.value = {
        equipment_id: '',
        process_code: '',
        process_name: '',
        remarks: '',
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
              <HeadForm headerWidth="150px" ref={ formCard }>
                {{
                  left: () => (
                    <ElFormItem v-permission={ 'ProcessCode:add' }>
                      <ElButton type="primary" onClick={ handleAdd }>新增工艺编码</ElButton>
                    </ElFormItem>
                  ),
                  center: () => (
                    <>
                      <ElFormItem label="工艺编码：">
                        <ElInput v-model={ search.value.code } placeholder="请输入工艺编码" />
                      </ElFormItem>
                      <ElFormItem label="工艺名称：">
                        <ElInput v-model={ search.value.name } placeholder="请输入工艺名称" />
                      </ElFormItem>
                    </>
                  ),
                  right: () => (
                    <ElFormItem>
                      <ElButton type="primary" onClick={ fetchProductList }>查询</ElButton>
                    </ElFormItem>
                  )
                }}
              </HeadForm>
            ),
            default: () => (
              <>
                <ElTable data={ tableData.value } border stripe height={ `calc(100vh - ${formHeight.value + 224}px)` } style={{ width: "100%" }}>
                  <ElTableColumn prop="process_code" label="工艺编码" width="120" />
                  <ElTableColumn prop="process_name" label="工艺名称" />
                  <ElTableColumn prop="equipment.equipment_code" label="设备编码" />
                  <ElTableColumn prop="equipment.equipment_name" label="设备名称" />
                  <ElTableColumn prop="remarks" label="备注" />
                  <ElTableColumn label="操作" width="140" fixed="right">
                    {(scope) => (
                      <>
                        <ElButton size="small" type="warning" v-permission={ 'ProcessCode:edit' } onClick={ () => handleUplate(scope.row) }>修改</ElButton>
                        {/* <ElButton size="small" type="danger" v-permission={ 'ProcessCode:delete' } onClick={ () => handleDelete(scope.row) }>删除</ElButton> */}
                      </>
                    )}
                  </ElTableColumn>
                </ElTable>
                <ElPagination ref={ pagin } layout="prev, pager, next, jumper, total" currentPage={ currentPage.value } pageSize={ pageSize.value } total={ total.value } defaultPageSize={ pageSize.value } style={{ justifyContent: 'center', paddingTop: '10px' }} onUpdate:currentPage={ (page) => currentPageChange(page) } onUupdate:pageSize={ (size) => pageSizeChange(size) } />
              </>
            )
          }}
        </ElCard>
        <ElDialog v-model={ dialogVisible.value } title={ edit.value ? '修改工艺编码' : '新增工艺编码' } width='785' center draggable onClose={ () => handleClose() }>
          {{
            default: () => (
              <ElForm class="ml30" model={ form.value } ref={ formRef } inline={ true } rules={ rules } label-width="95px">
                <ElFormItem label="工艺编码" prop="process_code">
                  <ElInput v-model={ form.value.process_code } placeholder="请输入工艺编码" disabled={ !(edit.value == 0 || user.type == 1) } />
                </ElFormItem>
                <ElFormItem label="工艺名称" prop="process_name">
                  <ElInput v-model={ form.value.process_name } placeholder="请输入工艺名称" />
                </ElFormItem>
                <ElFormItem label="使用设备" prop="equipment_id">
                  <MySelect v-model={ form.value.equipment_id } apiUrl="/api/getEquipmentCode" query="equipment_code" itemValue="equipment_code" placeholder="请选择设备" />
                </ElFormItem>
                <ElFormItem label="备注" prop="remarks">
                  <ElInput v-model={ form.value.remarks } placeholder="请输入备注" />
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