import { defineComponent, ref, onMounted, reactive, nextTick } from 'vue'
import request from '@/utils/request';
import { reportOperationLog } from '@/utils/log';
import { getItem } from '@/assets/js/storage';
import { getPageHeight } from '@/utils/tool';

export default defineComponent({
  setup(){
    const formRef = ref(null);
    const formCard = ref(null)
    const pagin = ref(null)
    const formHeight = ref(0);
    const user = reactive(getItem('user'))
    const rules = reactive({
      part_code: [
        { required: true, message: '请输入部件编码', trigger: 'blur' },
      ],
      part_name: [
        { required: true, message: '请输入部件名称', trigger: 'blur' },
      ],
      model: [
        { required: true, message: '请输入型号', trigger: 'blur' },
      ],
      specification: [
        { required: true, message: '请输入规格', trigger: 'blur' },
      ],
      unit: [
        { required: true, message: '请输入单位', trigger: 'blur' },
      ],
    })
    let dialogVisible = ref(false)
    let form = ref({
      part_code: '',
      part_name: '',
      model: '',
      specification: '',
      other_features: '',
      unit: '',
      production_requirements: '',
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
      const res = await request.get('/api/part_code', {
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
            const res = await request.post('/api/part_code', form.value);
            if(res && res.code == 200){
              ElMessage.success('新增成功');
              dialogVisible.value = false;
              fetchProductList();
              reportOperationLog({
                operationType: 'add',
                module: '部件编码',
                desc: `新增部件编码：${form.value.part_code}`,
                data: { newData: form.value }
              })
            }
            
          }else{
            // 修改
            const myForm = {
              id: edit.value,
              ...form.value
            }
            const res = await request.put('/api/part_code', myForm);
            if(res && res.code == 200){
              ElMessage.success('修改成功');
              dialogVisible.value = false;
              fetchProductList();
              reportOperationLog({
                operationType: 'update',
                module: '部件编码',
                desc: `修改部件编码：${myForm.part_code}`,
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
        const res = await request.delete('/api/part_code/' + row.id);
        if(res && res.code == 200){
          ElMessage.success('删除成功');
          fetchProductList();
          reportOperationLog({
            operationType: 'delete',
            module: '部件编码',
            desc: `删除部件编码：${row.part_code}`,
            data: { newData: row.id }
          })
        }
      }).catch(() => {})
    }
    const handleUplate = (row) => {
      edit.value = row.id;
      dialogVisible.value = true;
      const rows = { ...row }
      form.value = rows;
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
        part_code: '',
        part_name: '',
        model: '',
        specification: '',
        other_features: '',
        unit: '',
        production_requirements: '',
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
              <div class="flex" ref={ formCard }>
                <ElForm inline={ true } class="cardHeaderFrom">
                  <ElFormItem v-permission={ 'PartCode:add' }>
                    <ElButton style="margin-top: -5px" type="primary" onClick={ handleAdd } >
                      新增部件编码
                    </ElButton>
                  </ElFormItem>
                </ElForm>
                <ElForm inline={ true } class="cardHeaderFrom">
                  <ElFormItem label="部件编码">
                    <ElInput v-model={ search.value.code } placeholder="请输入部件编码" />
                  </ElFormItem>
                  <ElFormItem label="部件名称">
                    <ElInput v-model={ search.value.name } placeholder="请输入部件名称" />
                  </ElFormItem>
                  <ElFormItem>
                    <ElButton style="margin-top: -5px" type="primary" onClick={ fetchProductList }>查询</ElButton>
                  </ElFormItem>
                </ElForm>
              </div>
            ),
            default: () => (
              <>
                <ElTable data={ tableData.value } border stripe height={ `calc(100vh - ${formHeight.value + 224}px)` } style={{ width: "100%" }}>
                  <ElTableColumn prop="part_code" label="部件编码" />
                  <ElTableColumn prop="part_name" label="部件名称" />
                  <ElTableColumn prop="model" label="型号" />
                  <ElTableColumn prop="specification" label="规格" />
                  <ElTableColumn prop="other_features" label="其它特性" />
                  <ElTableColumn prop="unit" label="单位" width="100" />
                  <ElTableColumn prop="production_requirements" label="生产要求" />
                  <ElTableColumn prop="remarks" label="备注" />
                  <ElTableColumn label="操作" width="140" fixed="right">
                    {(scope) => (
                      <>
                        <ElButton size="small" type="default" v-permission={ 'PartCode:edit' } onClick={ () => handleUplate(scope.row) }>修改</ElButton>
                        {/* <ElButton size="small" type="danger" v-permission={ 'PartCode:delete' } onClick={ () => handleDelete(scope.row) }>删除</ElButton> */}
                      </>
                    )}
                  </ElTableColumn>
                </ElTable>
                <ElPagination ref={ pagin } layout="prev, pager, next, jumper, total" currentPage={ currentPage.value } pageSize={ pageSize.value } total={ total.value } defaultPageSize={ pageSize.value } style={{ justifyContent: 'center', paddingTop: '10px' }} onUpdate:currentPage={ (page) => currentPageChange(page) } onUupdate:pageSize={ (size) => pageSizeChange(size) } />
              </>
            )
          }}
        </ElCard>
        <ElDialog v-model={ dialogVisible.value } title={ edit.value ? '修改部件编码' : '新增部件编码' } onClose={ () => handleClose() }>
          {{
            default: () => (
              <ElForm model={ form.value } ref={ formRef } inline={ true } rules={ rules } label-width="80px">
                <ElFormItem label="部件编码" prop="part_code">
                  <ElInput v-model={ form.value.part_code } placeholder="请输入部件编码" disabled={ !(edit.value == 0 || user.type == 1) } />
                </ElFormItem>
                <ElFormItem label="部件名称" prop="part_name">
                  <ElInput v-model={ form.value.part_name } placeholder="请输入部件名称" />
                </ElFormItem>
                <ElFormItem label="型号" prop="model">
                  <ElInput v-model={ form.value.model } placeholder="请输入型号" />
                </ElFormItem>
                <ElFormItem label="规格" prop="specification">
                  <ElInput v-model={ form.value.specification } placeholder="请输入规格" />
                </ElFormItem>
                <ElFormItem label="单位" prop="unit">
                  <ElInput v-model={ form.value.unit } placeholder="请输入单位" />
                </ElFormItem>
                <ElFormItem label="其它特性" prop="other_features">
                  <ElInput v-model={ form.value.other_features } placeholder="请输入其它特性" />
                </ElFormItem>
                <ElFormItem label="生产要求" prop="production_requirements">
                  <ElInput v-model={ form.value.production_requirements } placeholder="请输入生产要求" />
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