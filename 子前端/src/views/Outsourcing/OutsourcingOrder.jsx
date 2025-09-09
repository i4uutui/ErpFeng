import { defineComponent, ref, onMounted, reactive } from 'vue';
import { getItem } from "@/assets/js/storage";
import request from '@/utils/request';
import dayjs from "dayjs"
import "@/assets/css/print.scss"
import MySelect from '@/components/tables/mySelect.vue';

export default defineComponent({
  setup() {
    const user = ref()
    const nowDate = ref()
    const formRef = ref(null);
    const rules = reactive({
      supplier_id: [
        { required: true, message: '请选择供应商编码', trigger: 'blur' }
      ],
      process_bom_id: [
        { required: true, message: '请选择工艺BOM表', trigger: 'blur' }
      ],
      process_index: [
        { required: true, message: '请选择工序', trigger: 'blur' }
      ],
      // transaction_currency: [
      //   { required: true, message: '请输入交易币别', trigger: 'blur' }
      // ],
      // other_transaction_terms: [
      //   { required: true, message: '请输入交易条件', trigger: 'blur' }
      // ],
    })
    let dialogVisible = ref(false)
    let form = ref({
      notice_id: '',
      supplier_id: '',
      process_bom_id: '',
      process_index: '',
      price: '',
      number: '',
      ment: '',
      transaction_currency: '',
      other_transaction_terms: '',
      remarks: ''
    })
    let tableData = ref([])
    let currentPage = ref(1);
    let pageSize = ref(30);
    let total = ref(0);
    let isPrint = ref(false)
    let allSelect = ref([])
    let edit = ref(0)
    let bomList = ref([]) // 工艺Bom列表
    let procedure = ref([]) // 工序列表
    
    const printObj = ref({
      id: "printTable", // 这里是要打印元素的ID
      popTitle: "委外加工单", // 打印的标题
      // preview: true, // 是否启动预览模式，默认是false
      zIndex: 20003, // 预览窗口的z-index，默认是20002，最好比默认值更高
      previewBeforeOpenCallback() { console.log('正在加载预览窗口！'); }, // 预览窗口打开之前的callback
      previewOpenCallback() { console.log('已经加载完预览窗口，预览打开了！') }, // 预览窗口打开时的callback
      beforeOpenCallback(vue) {
        console.log('开始打印之前！')
        isPrint.value = true
      }, // 开始打印之前的callback
      openCallback(vue) {
        console.log('监听到了打印窗户弹起了！')
      }, // 调用打印时的callback
      closeCallback() {
        console.log('关闭了打印工具！')
        isPrint.value = false
      }, // 关闭打印的callback(点击弹窗的取消和打印按钮都会触发)
      clickMounted() { console.log('点击v-print绑定的按钮了！') },
    })
    
    onMounted(() => {
      user.value = getItem('user')
      nowDate.value = dayjs().format('YYYY-MM-DD HH:mm:ss')
      fetchProductList()
      getProcessBomList()
    })
    
    // 获取列表
    const fetchProductList = async () => {
      const res = await request.post('/api/outsourcing_order', {
        page: currentPage.value,
        pageSize: pageSize.value,
      });
      tableData.value = res.data;
      total.value = res.total;
    };
    const getProcessBomList = async () => {
      const res = await request.get('/api/getProcessBom')
      bomList.value = res.data
    }
    const getProcessBomChildren = async (value) => {
      const res = await request.get(`/api/getProcessBomChildren?process_bom_id=${value}`)
      procedure.value = res.data
    }
    const handleSubmit = async (formEl) => {
      if (!formEl) return
      await formEl.validate(async (valid, fields) => {
        if (valid){
          if(!edit.value){
            const res = await request.post('/api/add_outsourcing_order', form.value);
            if(res && res.code == 200){
              ElMessage.success('添加成功');
              dialogVisible.value = false;
              fetchProductList();
            }
            
          }else{
            // 修改
            const myForm = {
              id: edit.value,
              ...form.value
            }
            const res = await request.put('/api/outsourcing_order', myForm);
            if(res && res.code == 200){
              ElMessage.success('修改成功');
              dialogVisible.value = false;
              fetchProductList();
            }
          }
        }
      })
    }
    const changeBomSelect = (value) => {
      procedure.value = []
      form.value.process_bom_children_id = ''
      getProcessBomChildren(value)
    }
    const handleUplate = (row) => {
      edit.value = row.id;
      dialogVisible.value = true;
      form.value = { ...row };
      getProcessBomChildren(row.process_bom_id)
    }
    // 用户主动多选，然后保存到allSelect
    const handleSelectionChange = (select) => {
      allSelect.value = select.map(e => e.id)
    }
    // 筛选
    const search = () => {
      fetchProductList()
    }
    // 新增委外加工
    const addOutSourcing = () => {
      edit.value = 0;
      dialogVisible.value = true;
      resetForm()
    }
    // 取消弹窗
    const handleClose = () => {
      edit.value = 0;
      dialogVisible.value = false;
      resetForm()
    }
    const resetForm = () => {
      form.value = {
        notice_id: '',
        supplier_id: '',
        process_bom_id: '',
        process_index: '',
        price: '',
        number: '',
        ment: '',
        transaction_currency: '',
        other_transaction_terms: '',
        remarks: ''
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
              <div class="flex flex-wrap">
                <div class="pr10 flex">
                  <ElButton style="margin-top: -5px" type="primary" onClick={ addOutSourcing }>
                    新增委外加工
                  </ElButton>
                  {/* <ElButton style="margin-top: -5px" type="primary" v-permission={ 'OutsourcingOrder:print' } v-print={ printObj.value }>
                    委外加工单打印
                  </ElButton> */}
                </div>
              </div>
            ),
            default: () => (
              <>
                <ElTable data={ tableData.value } border stripe onSelectionChange={ (select) => handleSelectionChange(select) }>
                  <ElTableColumn type="selection" width="55" />
                  <ElTableColumn prop="processBom.part.part_code" label="部位编码" />
                  <ElTableColumn prop="processBom.part.part_name" label="部位名称" />
                  <ElTableColumn prop="processChildren.process.process_code" label="工艺编码" />
                  <ElTableColumn prop="processChildren.process.process_name" label="工艺名称" />
                  <ElTableColumn prop="ment" label="加工要求" />
                  <ElTableColumn prop="notice.sale.unit" label="单位" />
                  <ElTableColumn prop="number" label="委外数量" />
                  <ElTableColumn prop="price" label="加工单价" />
                  <ElTableColumn prop="transaction_currency" label="交易币别" />
                  <ElTableColumn prop="other_transaction_terms" label="交易条件" />
                  <ElTableColumn prop="delivery_time" label="要求交期" />
                  <ElTableColumn prop="remarks" label="备注" />
                  <ElTableColumn label="操作" width="100" fixed="right">
                    {(scope) => (
                      <>
                        <ElButton size="small" type="default" onClick={ () => handleUplate(scope.row) } v-permission={ 'OutsourcingQuote:edit' }>修改</ElButton>
                      </>
                    )}
                  </ElTableColumn>
                </ElTable>
                <ElPagination layout="prev, pager, next, jumper, total" currentPage={ currentPage.value } pageSize={ pageSize.value } total={ total.value } defaultPageSize={ pageSize.value } style={{ justifyContent: 'center', paddingTop: '10px' }} onUpdate:currentPage={ (page) => currentPageChange(page) } onUupdate:pageSize={ (size) => pageSizeChange(size) } />


                {/* <div class="printTable" id='totalTable2'>
                  <div id="printTable">
                    <div class="flex row-between" style="padding: 20px;width: 640px;">
                      <div>
                        供应商:{ supplier_abbreviation.value }
                      </div>
                      <div>
                        产品编码:{ product_code.value }
                      </div>
                      <div>
                        产品名称:{ product_name.value }
                      </div>
                      <div>
                        生产订单:{ notice.value }
                      </div>
                    </div>
                    <ElTable data={ tableData.value } border stripe style={{ width: "780px" }}>
                      <ElTableColumn prop="processBom.part.part_code" label="部位编码" width="80" />
                      <ElTableColumn prop="processBom.part.part_name" label="部位名称" width="80" />
                      <ElTableColumn prop="processChildren.process.process_code" label="工艺编码" width="80" />
                      <ElTableColumn prop="processChildren.process.process_name" label="工艺名称" width="80" />
                      <ElTableColumn prop="ment" label="加工要求" width="100" />
                      <ElTableColumn prop="notice.sale.unit" label="单位" width="80" />
                      <ElTableColumn prop="number" label="委外数量" width="100" />
                      <ElTableColumn prop="price" label="加工单价" width="80" />
                      <ElTableColumn prop="notice.sale.delivery_time" label="要求交期" width="100" />
                    </ElTable>
                    <div id="extraPrintContent" class="flex" style="justify-content: space-between; padding-top: 6px;width: 780px">
                      <div>核准：</div>
                      <div>审查：</div>
                      <div>制表：{ user.value?.name }</div>
                      <div>日期：{ nowDate.value }</div>
                    </div>
                  </div>
                </div> */}
              </>
            )
          }}
        </ElCard>
        <ElDialog v-model={ dialogVisible.value } title={ edit.value ? '修改委外加工' : '添加委外加工' } onClose={ () => handleClose() }>
          {{
            default: () => (
              <ElForm model={ form.value } ref={ formRef } inline={ true } rules={ rules } label-width="110px">
                <ElFormItem label="供应商编码" prop="supplier_id">
                  <MySelect v-model={ form.value.supplier_id } apiUrl="/api/getSupplierInfo" query="supplier_code" itemValue="supplier_code" placeholder="请选择供应商编码" />
                </ElFormItem>
                <ElFormItem label="生产订单" prop="notice_id">
                  <MySelect v-model={ form.value.notice_id } apiUrl="/api/getProductNotice" query="notice" itemValue="notice" placeholder="请选择生产订单" />
                </ElFormItem>
                <ElFormItem label="工艺BOM" prop="process_bom_id">
                  <ElSelect v-model={ form.value.process_bom_id } multiple={ false } filterable remote remote-show-suffix valueKey="id" placeholder="请选择工艺BOM" onChange={ (value) => changeBomSelect(value) }>
                    {bomList.value.map((e, index) => {
                      return <ElOption value={ e.id } label={ e.name } key={ index } />
                    })}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="工艺工序" prop="process_bom_children_id">
                  <ElSelect v-model={ form.value.process_bom_children_id } multiple={ false } filterable remote remote-show-suffix valueKey="id" placeholder="请选择工艺工序">
                    {procedure.value.map((e, index) => {
                      return <ElOption value={ e.id } label={ e.name } key={ index } />
                    })}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="加工单价" prop="price">
                  <ElInput v-model={ form.value.price } placeholder="请输入加工单价" />
                </ElFormItem>
                <ElFormItem label="委外数量" prop="number">
                  <ElInput v-model={ form.value.number } placeholder="请输入委外数量" />
                </ElFormItem>
                <ElFormItem label="加工要求" prop="ment">
                  <ElInput v-model={ form.value.ment } placeholder="请输入加工要求" />
                </ElFormItem>
                <ElFormItem label="交易币别" prop="transaction_currency">
                  <ElInput v-model={ form.value.transaction_currency } placeholder="请输入交易币别" />
                </ElFormItem>
                <ElFormItem label="交易条件" prop="other_transaction_terms">
                  <ElInput v-model={ form.value.other_transaction_terms } placeholder="请输入交易条件" />
                </ElFormItem>
                <ElFormItem label="要求交期" prop="delivery_time">
                  <ElDatePicker v-model={ form.value.delivery_time } type="date" placeholder="请选择交期" clearable={ false } />
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
});