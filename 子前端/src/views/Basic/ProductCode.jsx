import { defineComponent, ref, onMounted, reactive, nextTick } from 'vue'
import { reportOperationLog } from '@/utils/log';
import request from '@/utils/request';
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
      product_code: [
        { required: true, message: '请输入产品编码', trigger: 'blur' },
      ],
      product_name: [
        { required: true, message: '请输入产品名称', trigger: 'blur' },
      ],
      drawing: [
        { required: true, message: '请输入工程图号', trigger: 'blur' },
      ],
      model: [
        { required: true, message: '请输入型号', trigger: 'blur' },
      ],
      specification: [
        { required: true, message: '请输入规格', trigger: 'blur' },
      ],
      other_features: [
        { required: true, message: '请输入其它特性', trigger: 'blur' },
      ],
      component_structure: [
        { required: true, message: '请输入部件结构', trigger: 'blur' },
      ],
      unit: [
        { required: true, message: '请输入单位', trigger: 'blur' },
      ],
      production_requirements: [
        { required: true, message: '请输入生产要求', trigger: 'blur' },
      ],
    })
    let dialogVisible = ref(false)
    let form = ref({
      product_code: '',
      product_name: '',
      drawing: '',
      model: '',
      specification: '',
      other_features: '',
      component_structure: '',
      unit: '',
      production_requirements: '',
    })
    let tableData = ref([])
    let currentPage = ref(1);
    let pageSize = ref(20);
    let total = ref(0);
    let edit = ref(0)
    let search = ref({
      code: '',
      name: '',
      drawing: ''
    })

    onMounted(() => {
      nextTick(async () => {
        formHeight.value = await getPageHeight([formCard.value, pagin.value]);
      })

      fetchProductList()
    })

    // 获取列表
    const fetchProductList = async () => {
      const res = await request.get('/api/products_code', {
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
            const res = await request.post('/api/products_code', form.value);
            if(res && res.code == 200){
              ElMessage.success('新增成功');
              dialogVisible.value = false;
              fetchProductList();
              reportOperationLog({
                operationType: 'add',
                module: '产品编码',
                desc: `新增产品编码：${form.value.product_code}`,
                data: { newData: form.value }
              })
            }
            
          }else{
            // 修改
            const myForm = {
              id: edit.value,
              ...form.value
            }
            const res = await request.put('/api/products_code', myForm);
            if(res && res.code == 200){
              ElMessage.success('修改成功');
              dialogVisible.value = false;
              fetchProductList();
              reportOperationLog({
                operationType: 'update',
                module: '产品编码',
                desc: `修改产品编码：${myForm.product_code}`,
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
        const res = await request.delete('/api/products_code/' + row.id);
        if(res && res.code == 200){
          ElMessage.success('删除成功');
          fetchProductList();
          reportOperationLog({
            operationType: 'delete',
            module: '产品编码',
            desc: `删除产品编码：${row.product_code}`,
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
        product_code: '',
        product_name: '',
        drawing: '',
        model: '',
        specification: '',
        other_features: '',
        component_structure: '',
        unit: '',
        production_requirements: '',
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
                  <ElFormItem v-permission={ 'ProductCode:add' }>
                    <ElButton style="margin-top: -5px" type="primary" onClick={ handleAdd } >
                      新增产品编码
                    </ElButton>
                  </ElFormItem>
                </ElForm>
                <ElForm inline={ true } class="cardHeaderFrom">
                  <ElFormItem label="产品编码：">
                    <ElInput v-model={ search.value.code } placeholder="请输入产品编码" />
                  </ElFormItem>
                  <ElFormItem label="产品名称：">
                    <ElInput v-model={ search.value.name } placeholder="请输入产品名称" />
                  </ElFormItem>
                  <ElFormItem label="工程图号：">
                    <ElInput v-model={ search.value.drawing } placeholder="请输入工程图号" />
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
                  <ElTableColumn prop="product_code" label="产品编码" width="120" />
                  <ElTableColumn prop="product_name" label="产品名称" />
                  <ElTableColumn prop="drawing" label="工程图号" />
                  <ElTableColumn prop="model" label="型号&规格" width="180" />
                  {/* <ElTableColumn prop="specification" label="规格" /> */}
                  <ElTableColumn prop="other_features" label="其它特性" />
                  <ElTableColumn prop="component_structure" label="产品结构" />
                  <ElTableColumn prop="unit" label="单位" width="100" />
                  <ElTableColumn prop="production_requirements" label="生产要求" />
                  <ElTableColumn label="操作" width="140" fixed="right">
                    {(scope) => (
                      <>
                        <ElButton size="small" type="default" v-permission={ 'ProductCode:edit' } onClick={ () => handleUplate(scope.row) }>修改</ElButton>
                        {/* <ElButton size="small" type="danger" v-permission={ 'ProductCode:delete' } onClick={ () => handleDelete(scope.row) }>删除</ElButton> */}
                      </>
                    )}
                  </ElTableColumn>
                </ElTable>
                <ElPagination ref={ pagin } layout="prev, pager, next, jumper, total" currentPage={ currentPage.value } pageSize={ pageSize.value } total={ total.value } defaultPageSize={ pageSize.value } style={{ justifyContent: 'center', paddingTop: '10px' }} onUpdate:currentPage={ (page) => currentPageChange(page) } onUupdate:pageSize={ (size) => pageSizeChange(size) } />
              </>
            )
          }}
        </ElCard>
        <ElDialog v-model={ dialogVisible.value } title={ edit.value ? '修改产品编码' : '新增产品编码' } width='785' center onClose={ () => handleClose() }>
          {{
            default: () => (
              <ElForm class="ml30" model={ form.value } ref={ formRef } inline={ true } rules={ rules } label-width="95px">
                <ElFormItem label="产品编码" prop="product_code">
                  <ElInput v-model={ form.value.product_code } placeholder="请输入产品编码" disabled={ !(edit.value == 0 || user.type == 1) } />
                </ElFormItem>
                <ElFormItem label="产品名称" prop="product_name">
                  <ElInput v-model={ form.value.product_name } placeholder="请输入产品名称" />
                </ElFormItem>
                <ElFormItem label="工程图号" prop="drawing">
                  <ElInput v-model={ form.value.drawing } placeholder="请输入工程图号" />
                </ElFormItem>
                <ElFormItem label="型号&规格" prop="model">
                  <ElInput v-model={ form.value.model } placeholder="请输入型号&规格" />
                </ElFormItem>
                {/* <ElFormItem label="规格" prop="specification">
                  <ElInput v-model={ form.value.specification } placeholder="请输入规格" />
                </ElFormItem> */}
                <ElFormItem label="单位" prop="unit">
                  <ElInput v-model={ form.value.unit } placeholder="请输入单位" />
                </ElFormItem>
                <ElFormItem label="其它特性" prop="other_features">
                  <ElInput v-model={ form.value.other_features } placeholder="请输入其它特性" />
                </ElFormItem>
                <ElFormItem label="产品结构" prop="component_structure">
                  <ElInput v-model={ form.value.component_structure } placeholder="请输入产品结构" />
                </ElFormItem>
                <ElFormItem label="生产要求" prop="production_requirements">
                  <ElInput v-model={ form.value.production_requirements } placeholder="请输入生产要求" />
                </ElFormItem>
              </ElForm>
            ),
            footer: () => (
              <span class="dialog-footer">
                <ElButton type="warning" onClick={ handleClose }>取消</ElButton>
                <ElButton type="primary" onClick={ () => handleSubmit(formRef.value) }>确定</ElButton>
              </span>
            )
          }}
        </ElDialog>
      </>
    )
  }
})