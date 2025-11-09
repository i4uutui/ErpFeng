import { defineComponent, ref, onMounted, reactive, nextTick } from 'vue'
import request from '@/utils/request';
import { reportOperationLog } from '@/utils/log';
import { getPageHeight } from '@/utils/tool';
import HeadForm from '@/components/form/HeadForm';

export default defineComponent({
  setup(){
    const formRef = ref(null);
    const formCard = ref(null)
    const pagin = ref(null)
    const formHeight = ref(0);
    const rules = reactive({
      customer_code: [
        { required: true, message: '请输入客户编码', trigger: 'blur' },
      ],
      customer_abbreviation: [
        { required: true, message: '请输入客户名称', trigger: 'blur' },
      ],
      contact_person: [
        { required: true, message: '请输入联系人', trigger: 'blur' },
      ],
      contact_information: [
        { required: true, message: '请输入联系方式', trigger: 'blur' },
      ],
      company_full_name: [
        { required: true, message: '请输入公司全名', trigger: 'blur' },
      ],
      company_address: [
        { required: true, message: '请输入公司地址', trigger: 'blur' },
      ],
      delivery_address: [
        { required: true, message: '请输入交货地址', trigger: 'blur' },
      ],
      tax_registration_number: [
        { required: true, message: '请输入税务登记号', trigger: 'blur' },
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
      customer_code: '',
      customer_abbreviation: '',
      contact_person: '',
      contact_information: '',
      company_full_name: '',
      company_address: '',
      delivery_address: '',
      tax_registration_number: '',
      transaction_method: '',
      transaction_currency: '',
      other_transaction_terms: '',
      other_text: ''
    })
    let tableData = ref([])
    let currentPage = ref(1);
    let pageSize = ref(20);
    let total = ref(0);
    let edit = ref(0)
    let method = ref([])
    let payTime = ref([])
    let search = ref({
      customer_code: '',
      customer_abbreviation: ''
    })

    onMounted(() => {
      nextTick(async () => {
        formHeight.value = await getPageHeight([formCard.value, pagin.value]);
      })
      fetchProductList()
      getConstType()
    })

    // 获取列表
    const fetchProductList = async () => {
      const res = await request.get('/api/customer_info', {
        params: {
          page: currentPage.value,
          pageSize: pageSize.value,
          ...search.value
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
            const res = await request.post('/api/customer_info', form.value);
            if(res && res.code == 200){
              ElMessage.success('新增成功');
              dialogVisible.value = false;
              fetchProductList();
              reportOperationLog({
                operationType: 'add',
                module: '客户信息',
                desc: `新增客户编码：${form.value.customer_code}`,
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
            const res = await request.put('/api/customer_info', myForm);
            if(res && res.code == 200){
              ElMessage.success('修改成功');
              dialogVisible.value = false;
              fetchProductList();
              reportOperationLog({
                operationType: 'update',
                module: '客户信息',
                desc: `修改客户编码：${myForm.customer_code}`,
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
        const res = await request.delete('/api/customer_info/' + row.id);
        if(res && res.code == 200){
          ElMessage.success('删除成功');
          fetchProductList();
          reportOperationLog({
            operationType: 'delete',
            module: '客户信息',
            desc: `修改客户编码：${row.customer_code}`,
            data: { newData: row.id }
          })
        }
      }).catch(() => {})
    }
    const handleUplate = (row) => {
      edit.value = row.id;
      dialogVisible.value = true;
      row.other_transaction_terms = Number(row.other_transaction_terms)
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
        customer_code: '',
        customer_abbreviation: '',
        contact_person: '',
        contact_information: '',
        company_full_name: '',
        company_address: '',
        delivery_address: '',
        tax_registration_number: '',
        transaction_method: '',
        transaction_currency: '',
        other_transaction_terms: '',
        other_text: ''
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
                    <ElFormItem v-permission={ 'CustomerInfo:add' }>
                      <ElButton type="primary" onClick={ handleAdd }>新增客户</ElButton>
                    </ElFormItem>
                  ),
                  center: () => (
                    <>
                      <ElFormItem label="客户编码：">
                        <ElInput v-model={ search.value.customer_code } placeholder="请输入客户编码" />
                      </ElFormItem>
                      <ElFormItem label="客户名称：">
                        <ElInput v-model={ search.value.customer_abbreviation } placeholder="请输入客户名称" />
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
                  <ElTableColumn prop="customer_code" label="客户编码" />
                  <ElTableColumn prop="customer_abbreviation" label="客户名称" />
                  <ElTableColumn prop="contact_person" label="联系人" />
                  <ElTableColumn prop="contact_information" label="联系方式" />
                  <ElTableColumn prop="company_full_name" label="公司全名" />
                  <ElTableColumn prop="company_address" label="公司地址" />
                  <ElTableColumn prop="delivery_address" label="交货地址" />
                  <ElTableColumn prop="tax_registration_number" label="税务登记号" />
                  <ElTableColumn label="交易方式">
                    {({row}) => <span>{ method.value.find(e => e.id == row.transaction_method)?.name }</span>}
                  </ElTableColumn>
                  <ElTableColumn prop="transaction_currency" label="交易币别" />
                  <ElTableColumn label="结算周期">
                    {({row}) => {
                      const rowId = row.other_transaction_terms
                      if(rowId == 28){
                        return <span>{ row.other_text }</span>
                      }
                      return <span>{ payTime.value.find(e => e.id == row.other_transaction_terms)?.name }</span>
                    }}
                  </ElTableColumn>
                  <ElTableColumn label="操作" width="140" fixed="right">
                    {(scope) => (
                      <>
                        <ElButton size="small" type="warning" v-permission={ 'CustomerInfo:edit' } onClick={ () => handleUplate(scope.row) }>修改</ElButton>
                        {/* <ElButton size="small" type="danger" v-permission={ 'CustomerInfo:delete' } onClick={ () => handleDelete(scope.row) }>删除</ElButton> */}
                      </>
                    )}
                  </ElTableColumn>
                </ElTable>
                <ElPagination ref={ pagin } layout="prev, pager, next, jumper, total" currentPage={ currentPage.value } pageSize={ pageSize.value } total={ total.value } defaultPageSize={ pageSize.value } style={{ justifyContent: 'center', paddingTop: '10px' }} onUpdate:currentPage={ (page) => currentPageChange(page) } onUupdate:pageSize={ (size) => pageSizeChange(size) } />
              </>
            )
          }}
        </ElCard>
        <ElDialog v-model={ dialogVisible.value } title={ edit.value ? '修改客户信息' : '新增客户信息' } width='790' center draggable onClose={ () => handleClose() }>
          {{
            default: () => (
              <ElForm class="ml30" model={ form.value } ref={ formRef } inline={ true } rules={ rules } label-width="100">
                <ElFormItem label="客户编码" prop="customer_code">
                  <ElInput v-model={ form.value.customer_code } placeholder="请输入客户编码" />
                </ElFormItem>
                <ElFormItem label="客户简称" prop="customer_abbreviation">
                  <ElInput v-model={ form.value.customer_abbreviation } placeholder="请输入客户名称" />
                </ElFormItem>
                <ElFormItem label="联系人" prop="contact_person">
                  <ElInput v-model={ form.value.contact_person } placeholder="请输入联系人" />
                </ElFormItem>
                <ElFormItem label="联系方式" prop="contact_information">
                  <ElInput v-model={ form.value.contact_information } placeholder="请输入联系方式" />
                </ElFormItem>
                <ElFormItem label="公司全名" prop="company_full_name">
                  <ElInput v-model={ form.value.company_full_name } placeholder="请输入公司全名" />
                </ElFormItem>
                <ElFormItem label="公司地址" prop="company_address">
                  <ElInput v-model={ form.value.company_address } placeholder="请输入公司地址" />
                </ElFormItem>
                <ElFormItem label="交货地址" prop="delivery_address">
                  <ElInput v-model={ form.value.delivery_address } placeholder="请输入交货地址" />
                </ElFormItem>
                <ElFormItem label="税务登记号" prop="tax_registration_number">
                  <ElInput v-model={ form.value.tax_registration_number } placeholder="请输入税务登记号" />
                </ElFormItem>
                <ElFormItem label="交易方式" prop="transaction_method">
                  <ElSelect v-model={ form.value.transaction_method } multiple={ false } filterable remote remote-show-suffix placeholder="请选择交易方式">
                    {method.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="交易币别" prop="transaction_currency">
                  <ElInput v-model={ form.value.transaction_currency } placeholder="请输入交易币别" />
                </ElFormItem>
                <ElFormItem label="结算周期" prop="other_transaction_terms">
                  <ElSelect v-model={ form.value.other_transaction_terms } multiple={ false } filterable remote remote-show-suffix placeholder="请选择结算周期">
                    {payTime.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                { form.value.other_transaction_terms == 28 ? <ElFormItem label="其他" prop="other_text">
                  <ElInput v-model={ form.value.other_text } placeholder="请输入结算周期" />
                </ElFormItem> : '' }
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