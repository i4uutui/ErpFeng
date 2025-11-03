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
      supplier_code: [
        { required: true, message: '请输入供应商编码', trigger: 'blur' },
      ],
      supplier_abbreviation: [
        { required: true, message: '请输入供应商简称', trigger: 'blur' },
      ],
      contact_person: [
        { required: true, message: '请输入联系人', trigger: 'blur' },
      ],
      contact_information: [
        { required: true, message: '请输入联系方式', trigger: 'blur' },
      ],
      supplier_full_name: [
        { required: true, message: '请输入供应商全名', trigger: 'blur' },
      ],
      supplier_address: [
        { required: true, message: '请输入供应商地址', trigger: 'blur' },
      ],
      supplier_category: [
        { required: true, message: '请输入供应商类别', trigger: 'blur' },
      ],
      supply_method: [
        { required: true, message: '请输入供货方式', trigger: 'blur' },
      ],
      transaction_method: [
        { required: true, message: '请输入交易方式', trigger: 'blur' },
      ],
      transaction_currency: [
        { required: true, message: '请输入交易币别', trigger: 'blur' },
      ],
    })
    let dialogVisible = ref(false)
    let form = ref({
      supplier_code: '',
      supplier_abbreviation: '',
      contact_person: '',
      contact_information: '',
      supplier_full_name: '',
      supplier_address: '',
      supplier_category: '',
      supply_method: '',
      transaction_method: '',
      transaction_currency: '',
      other_transaction_terms: '',
    })
    let method = ref([])
    let payTime = ref([])
    let tableData = ref([])
    let currentPage = ref(1);
    let pageSize = ref(20);
    let total = ref(0);
    let edit = ref(0)

    onMounted(() => {
      nextTick(async () => {
        formHeight.value = await getPageHeight([formCard.value, pagin.value]);
      })
      fetchProductList()
      getConstType()
    })

    // 获取列表
    const fetchProductList = async () => {
      const res = await request.get('/api/supplier_info', {
        params: {
          page: currentPage.value,
          pageSize: pageSize.value
        },
      });
      tableData.value = res.data;
      total.value = res.total;
    };
    // 获取常量
    const getConstType = async () => {
      const res = await request.post('/api/getConstType', { type: ['payInfo', 'payTime'] })
      if(res.code == 200){
        method.value = res.data.filter(o => o.type == 'payInfo')
        payTime.value = res.data.filter(o => o.type == 'payTime')
      }
    }
    const handleSubmit = async (formEl) => {
      if (!formEl) return
      await formEl.validate(async (valid, fields) => {
        if (valid){
          if(!edit.value){
            form.value.other_transaction_terms = form.value.other_transaction_terms ? form.value.other_transaction_terms : null
            const res = await request.post('/api/supplier_info', form.value);
            if(res && res.code == 200){
              ElMessage.success('新增成功');
              dialogVisible.value = false;
              fetchProductList();
              reportOperationLog({
                operationType: 'add',
                module: '供应商资料',
                desc: `新增供应商资料，供应商编码：${form.value.supplier_code}`,
                data: { newData: form.value }
              })
            }
            
          }else{
            // 修改
            form.value.other_transaction_terms = form.value.other_transaction_terms ? form.value.other_transaction_terms : null
            const myForm = {
              id: edit.value,
              ...form.value
            }
            const res = await request.put('/api/supplier_info', myForm);
            if(res && res.code == 200){
              ElMessage.success('修改成功');
              dialogVisible.value = false;
              fetchProductList();
              reportOperationLog({
                operationType: 'update',
                module: '供应商资料',
                desc: `修改供应商资料，供应商编码：${myForm.supplier_code}`,
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
        supplier_code: '',
        supplier_abbreviation: '',
        contact_person: '',
        contact_information: '',
        supplier_full_name: '',
        supplier_address: '',
        supplier_category: '',
        supply_method: '',
        transaction_method: '',
        transaction_currency: '',
        other_transaction_terms: '',
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
                <ElButton style="margin-top: -5px" type="primary" v-permission={ 'SupplierInfo:add' } onClick={ handleAdd } >
                  新增供应商
                </ElButton>
              </div>
            ),
            default: () => (
              <>
                <ElTable data={ tableData.value } border stripe height={ `calc(100vh - ${formHeight.value + 224}px)` } style={{ width: "100%" }}>
                  <ElTableColumn prop="supplier_code" label="供应商编码" />
                  <ElTableColumn prop="supplier_abbreviation" label="供应商简称" />
                  <ElTableColumn prop="contact_person" label="联系人" />
                  <ElTableColumn prop="contact_information" label="联系方式" width="130" />
                  <ElTableColumn prop="supplier_full_name" label="供应商全名" width="130" />
                  <ElTableColumn prop="supplier_address" label="供应商地址" width="130" />
                  <ElTableColumn prop="supplier_category" label="供应商类别" />
                  <ElTableColumn prop="supply_method" label="供货方式" />
                  <ElTableColumn label="交易方式">
                    {({row}) => <span>{ method.value.find(e => e.id == row.transaction_method)?.name }</span>}
                  </ElTableColumn>
                  <ElTableColumn prop="transaction_currency" label="交易币别" />
                  <ElTableColumn prop="other_transaction_terms" label="其它交易条件" width="120">
                    {({row}) => <span>{ payTime.value.find(e => e.id == row.other_transaction_terms)?.name }</span>}
                  </ElTableColumn>
                  <ElTableColumn prop="created_at" label="创建时间" width="110" />
                  <ElTableColumn label="操作" width="140" fixed="right">
                    {(scope) => (
                      <>
                        <ElButton size="small" type="default" v-permission={ 'SupplierInfo:edit' } onClick={ () => handleUplate(scope.row) }>修改</ElButton>
                      </>
                    )}
                  </ElTableColumn>
                </ElTable>
                <ElPagination ref={ pagin } layout="prev, pager, next, jumper, total" currentPage={ currentPage.value } pageSize={ pageSize.value } total={ total.value } defaultPageSize={ pageSize.value } style={{ justifyContent: 'center', paddingTop: '10px' }} onUpdate:currentPage={ (page) => currentPageChange(page) } onUupdate:pageSize={ (size) => pageSizeChange(size) } />
              </>
            )
          }}
        </ElCard>
        <ElDialog v-model={ dialogVisible.value } title={ edit.value ? '修改供应商信息' : '新增供应商信息' } width='795' center onClose={ () => handleClose() }>
          {{
            default: () => (
              <ElForm class="ml25" model={ form.value } ref={ formRef } inline={ true } rules={ rules } label-width="105">
                <ElFormItem label="供应商编码" prop="supplier_code">
                  <ElInput v-model={ form.value.supplier_code } placeholder="请输入供应商编码" />
                </ElFormItem>
                <ElFormItem label="供应商简称" prop="supplier_abbreviation">
                  <ElInput v-model={ form.value.supplier_abbreviation } placeholder="请输入供应商简称" />
                </ElFormItem>
                <ElFormItem label="联系人" prop="contact_person">
                  <ElInput v-model={ form.value.contact_person } placeholder="请输入联系人" />
                </ElFormItem>
                <ElFormItem label="联系方式" prop="contact_information">
                  <ElInput v-model={ form.value.contact_information } placeholder="请输入联系方式" />
                </ElFormItem>
                <ElFormItem label="供应商全名" prop="supplier_full_name">
                  <ElInput v-model={ form.value.supplier_full_name } placeholder="请输入供应商全名" />
                </ElFormItem>
                <ElFormItem label="供应商地址" prop="supplier_address">
                  <ElInput v-model={ form.value.supplier_address } placeholder="请输入供应商地址" />
                </ElFormItem>
                <ElFormItem label="供应商类别" prop="supplier_category">
                  <ElInput v-model={ form.value.supplier_category } placeholder="请输入供应商类别" />
                </ElFormItem>
                <ElFormItem label="供货方式" prop="supply_method">
                  <ElInput v-model={ form.value.supply_method } placeholder="请输入供货方式" />
                </ElFormItem>
                <ElFormItem label="交易方式" prop="transaction_method">
                  <ElSelect v-model={ form.value.transaction_method } multiple={ false } filterable remote remote-show-suffix clearable placeholder="请选择交易方式">
                    {method.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="交易币别" prop="transaction_currency">
                  <ElInput v-model={ form.value.transaction_currency } placeholder="请输入交易币别" />
                </ElFormItem>
                <ElFormItem label="其它交易条件" prop="other_transaction_terms">
                  <ElSelect v-model={ form.value.other_transaction_terms } multiple={ false } filterable remote remote-show-suffix clearable placeholder="请选择其它交易条件">
                    {payTime.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                  </ElSelect>
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