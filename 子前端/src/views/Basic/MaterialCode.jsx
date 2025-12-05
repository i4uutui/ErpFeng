import { defineComponent, ref, onMounted, reactive, nextTick } from 'vue'
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
    const materialType = ref(getItem('constant').filter(o => o.type == 'materialType'))
    const calcUnit = ref(getItem('constant').filter(o => o.type == 'calcUnit'))
    const user = reactive(getItem('user'))
    const rules = reactive({
      material_code: [
        { required: true, message: '请输入材料编码', trigger: 'blur' },
      ],
      material_name: [
        { required: true, message: '请输入材料名称', trigger: 'blur' },
      ],
      category: [
        { required: true, message: '请选择材料类别', trigger: 'blur' },
      ],
      model: [
        { required: true, message: '请输入型号', trigger: 'blur' },
      ],
      specification: [
        { required: true, message: '请输入规格', trigger: 'blur' },
      ],
      usage_unit: [
        { required: true, message: '请输入使用单位', trigger: 'blur' },
      ],
      purchase_unit: [
        { required: true, message: '请输入交易单位', trigger: 'blur' },
      ],
    })
    let dialogVisible = ref(false)
    let form = ref({
      material_code: '',
      material_name: '',
      model: '',
      specification: '',
      other_features: '',
      usage_unit: '',
      purchase_unit: '',
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
      const res = await request.get('/api/material_code', {
        params: {
          page: currentPage.value,
          pageSize: pageSize.value,
          ...search.value
        },
      });
      tableData.value = res.data.map(e => {
        e.category = e.category ? Number(e.category) : ''
        e.usage_unit = e.usage_unit ? Number(e.usage_unit) : ''
        e.purchase_unit = e.purchase_unit ? Number(e.purchase_unit) : ''
        return e
      });
      total.value = res.total;
    };
    const handleSubmit = async (formEl) => {
      if (!formEl) return
      await formEl.validate(async (valid, fields) => {
        if (valid){
          if(!edit.value){
            const res = await request.post('/api/material_code', form.value);
            if(res && res.code == 200){
              ElMessage.success('新增成功');
              dialogVisible.value = false;
              fetchProductList();
              reportOperationLog({
                operationType: 'add',
                module: '原材料编码',
                desc: `新增原材料编码：${form.value.material_code}`,
                data: { newData: form.value }
              })
            }
            
          }else{
            // 修改
            const myForm = {
              id: edit.value,
              ...form.value
            }
            const res = await request.put('/api/material_code', myForm);
            if(res && res.code == 200){
              ElMessage.success('修改成功');
              dialogVisible.value = false;
              fetchProductList();
              reportOperationLog({
                operationType: 'update',
                module: '原材料编码',
                desc: `修改原材料编码：${myForm.material_code}`,
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
        const res = await request.delete('/api/material_code/' + row.id);
        if(res && res.code == 200){
          ElMessage.success('删除成功');
          fetchProductList();
          reportOperationLog({
            operationType: 'delete',
            module: '原材料编码',
            desc: `删除原材料编码：${row.material_code}`,
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
        material_code: '',
        material_name: '',
        model: '',
        specification: '',
        other_features: '',
        usage_unit: '',
        purchase_unit: '',
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
                    <ElFormItem v-permission={ 'MaterialCode:add' }>
                      <ElButton type="primary" onClick={ handleAdd }>新增材料编码</ElButton>
                    </ElFormItem>
                  ),
                  center: () => (
                    <>
                      <ElFormItem label="材料编码：">
                        <ElInput v-model={ search.value.code } placeholder="请输入材料编码" />
                      </ElFormItem>
                      <ElFormItem label="材料名称：">
                        <ElInput v-model={ search.value.name } placeholder="请输入材料名称" />
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
                  <ElTableColumn prop="material_code" label="材料编码" width="120" />
                  <ElTableColumn prop="material_name" label="材料名称" />
                  <ElTableColumn label="材料类别">
                    {({row}) => <span>{ materialType.value.find(e => e.id == row.category)?.name }</span>}
                  </ElTableColumn>
                  <ElTableColumn prop="model" label="型号&规格" width="180" />
                  {/* <ElTableColumn prop="specification" label="规格" /> */}
                  <ElTableColumn prop="other_features" label="其它特性" />
                  <ElTableColumn label="使用单位">
                    {({row}) => <span>{ calcUnit.value.find(e => e.id == row.usage_unit)?.name }</span>}
                  </ElTableColumn>
                  <ElTableColumn label="交易单位">
                    {({row}) => <span>{ calcUnit.value.find(e => e.id == row.purchase_unit)?.name }</span>}
                  </ElTableColumn>
                  <ElTableColumn label="操作" width="140" fixed="right">
                    {(scope) => (
                      <>
                        <ElButton size="small" type="warning" v-permission={ 'MaterialCode:edit' } onClick={ () => handleUplate(scope.row) }>修改</ElButton>
                        {/* <ElButton size="small" type="danger" v-permission={ 'MaterialCode:delete' } onClick={ () => handleDelete(scope.row) }>删除</ElButton> */}
                      </>
                    )}
                  </ElTableColumn>
                </ElTable>
                <ElPagination ref={ pagin } layout="prev, pager, next, jumper, total" currentPage={ currentPage.value } pageSize={ pageSize.value } total={ total.value } defaultPageSize={ pageSize.value } style={{ justifyContent: 'center', paddingTop: '10px' }} onUpdate:currentPage={ (page) => currentPageChange(page) } onUupdate:pageSize={ (size) => pageSizeChange(size) } />
              </>
            )
          }}
        </ElCard>
        <ElDialog v-model={ dialogVisible.value } title={ edit.value ? '修改材料编码' : '新增材料编码' } width='785' center draggable onClose={ () => handleClose() }>
          {{
            default: () => (
              <ElForm class="ml30" model={ form.value } ref={ formRef } inline={ true } rules={ rules } label-width="95px">
                <ElFormItem label="材料编码" prop="material_code">
                  <ElInput v-model={ form.value.material_code } placeholder="请输入材料编码" disabled={ !(edit.value == 0 || user.type == 1) } />
                </ElFormItem>
                <ElFormItem label="材料名称" prop="material_name">
                  <ElInput v-model={ form.value.material_name } placeholder="请输入材料名称" />
                </ElFormItem>
                <ElFormItem label="材料类别" prop="category">
                  <ElSelect v-model={ form.value.category } multiple={ false } filterable remote remote-show-suffix placeholder="请选择材料类别">
                    {materialType.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="型号&规格" prop="model">
                  <ElInput v-model={ form.value.model } placeholder="请输入型号&规格" />
                </ElFormItem>
                {/* <ElFormItem label="规格" prop="specification">
                  <ElInput v-model={ form.value.specification } placeholder="请输入规格" />
                </ElFormItem> */}
                <ElFormItem label="使用单位" prop="usage_unit">
                  <ElSelect v-model={ form.value.usage_unit } multiple={ false } filterable remote remote-show-suffix placeholder="请选择使用单位">
                    {calcUnit.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="交易单位" prop="purchase_unit">
                  <ElSelect v-model={ form.value.purchase_unit } multiple={ false } filterable remote remote-show-suffix placeholder="请选择交易单位">
                    {calcUnit.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="其它特性" prop="other_features">
                  <ElInput v-model={ form.value.other_features } placeholder="请输入其它特性" />
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