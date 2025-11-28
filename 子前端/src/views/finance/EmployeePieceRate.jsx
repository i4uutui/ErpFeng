import { defineComponent, nextTick, onMounted, reactive, ref } from 'vue'
import { getPageHeight, PreciseMath } from '@/utils/tool'
import request from '@/utils/request';
import dayjs from "dayjs"
import HeadForm from '@/components/form/HeadForm';
import { reportOperationLog } from '@/utils/log';

export default defineComponent({
  setup() {
    const checkSubNumber = (rule, value, callback) => {
      if (!value){
        return callback(new Error('请输入递减数量'))
      }
      const number = Number(value)
      if(number > Number(form.value.number)){
        return callback(new Error('递减数量不能大于完成数量'))
      }else{
        callback()
      }
    }
    const formRef = ref(null);
    const formCard = ref(null)
    const pagin = ref(null)
    const formHeight = ref(0);
    const rules = reactive({
      sub_number: [
        { required: true, message: '请输入递减数量', trigger: 'blur' },
        { validator: checkSubNumber, trigger: 'blur' }
      ]
    })
    let dialogVisible = ref(false)
    let form = ref({
      employee_id: '',
      name: '',
      cycle_name: '',
      date: '',
      product_code: '',
      product_name: '',
      part_code: '',
      part_name: '',
      process_code: '',
      process_name: '',
      number: '',
      sub_number: '',
    })
    let processCycle = ref([])
    let tableData = ref([])
    let currentPage = ref(1);
    let pageSize = ref(20);
    let total = ref(0);
    let search = ref({
      created_at: [],
      employee_id: '',
      name: '',
      cycle_id: ''
    })

    onMounted(() => {
      nextTick(async () => {
        formHeight.value = await getPageHeight([formCard.value, pagin.value]);
      })
      const currentDate = dayjs();
      const firstDay = currentDate.startOf('month').format('YYYY-MM-DD HH:mm:ss');
      const lastDay = currentDate.endOf('month').format('YYYY-MM-DD HH:mm:ss');
      search.value.created_at = [firstDay, lastDay]
      getList()
      getProcessCycle()
    })

    const getList = async () => {
      const res = await request.post('/api/rate_wage', {
        page: 1,
        pageSize: 10,
        ...search.value
      })
      tableData.value = res.data;
      total.value = res.total;
    }
    // 获取制程
    const getProcessCycle = async () => {
      const res = await request.get('/api/getProcessCycle')
      if(res.code == 200){
        processCycle.value = res.data
      }
    }
    const handleConfirm = (row) => {
      ElMessageBox.confirm('是否确认操作？', '提示', {
        confirmButtonText: '确认',
        cancelButtonText: '取消',
        type: 'warning',
      }).then(async () => {
        const res = await request.post("/api/rateWageConfirm", { status: 1, id: row.id })
        if(res.code == 200){
          ElMessage.success('操作成功')
          getList()
        }
      })
    }
    const dateChange = (value) => {
      const startTime = `${value[0]} 00:00:00`
      const endTime = `${value[1]} 23:59:59`
      search.value.created_at = [startTime, endTime]
    }
    // 修改按钮
    const handleUplate = (row) => {
      form.value = {
        employee_id: row.menber.employee_id,
        name: row.menber.name,
        cycle_name: row.menber.cycle.name,
        date: row.created_at,
        product_code: row.product.product_code,
        product_name: row.product.product_name,
        part_code: row.part.part_code,
        part_name: row.part.part_name,
        process_code: row.process.process_code,
        process_name: row.process.process_name,
        number: row.number,
        sub_number: '',
        id: row.id,
        progress_id: row.progress_id,
        bom_child_id: row.bom_child_id
      }
      dialogVisible.value = true;
    }
    const handleSubmit = async (formEl) => {
      if (!formEl) return
      await formEl.validate(async (valid, fields) => {
        if (valid){
          const params = {
            id: form.value.id,
            progress_id: form.value.progress_id,
            bom_child_id: form.value.bom_child_id,
            sub_number: form.value.sub_number
          }
          const res = await request.post('/api/decreaseNumber', params);
          if(res && res.code == 200){
            ElMessage.success('修改成功');
            dialogVisible.value = false;
            getList();
            reportOperationLog({
              operationType: 'update',
              module: '员工计件工资',
              desc: `修改员工计件工资，员工编码：${form.value.employee_id}，员工姓名：${form.value.name}`,
              data: { newData: params }
            })
          }
        }
      })
    }
    // 取消弹窗
    const handleClose = () => {
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
              <HeadForm headerWidth="150px" labelWidth="60" ref={ formCard }>
                {{
                  center: () => (
                    <>
                      <ElFormItem label="周期：">
                        <el-date-picker v-model={ search.value.created_at } type="daterange" clearable={ false } range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期" value-format="YYYY-MM-DD" onChange={ (row) => dateChange(row) } />
                      </ElFormItem>
                      <ElFormItem label="工号：">
                        <ElInput v-model={ search.value.employee_id } placeholder="请输入工号" />
                      </ElFormItem>
                      <ElFormItem label="姓名：">
                        <ElInput v-model={ search.value.name } placeholder="请输入姓名" />
                      </ElFormItem>
                      <ElFormItem label="部门：">
                        <ElSelect v-model={ search.value.cycle_id } multiple={false} filterable remote remote-show-suffix placeholder="请选择制程组">
                          {processCycle.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                        </ElSelect>
                      </ElFormItem>
                    </>
                  ),
                  right: () => (
                    <>
                      <ElFormItem>
                        <ElButton type="primary" onClick={ () => getList() }>查询</ElButton>
                      </ElFormItem>
                    </>
                  )
                }}
              </HeadForm>
            ),
            default: () => (
              <>
                <ElTable data={ tableData.value } border stripe height={ `calc(100vh - ${formHeight.value + 224}px)` } style={{ width: "100%" }}>
                  <ElTableColumn label="状态">
                    {({row}) => row.status == 0 ? <span style={{ color: 'red' }}>未确认</span> : <span>已确认</span>}
                  </ElTableColumn>
                  <ElTableColumn prop="menber.employee_id" label="员工工号" width="90" />
                  <ElTableColumn prop="menber.name" label="员工姓名" width="90" />
                  <ElTableColumn prop="menber.cycle.name" label="所属部门" width="90" />
                  <ElTableColumn prop="created_at" label="生产日期" width="110" />
                  <ElTableColumn prop="notice.notice" label="生产单号" width="120" />
                  <ElTableColumn prop="product.product_code" label="产品编码" width="120" />
                  <ElTableColumn prop="product.product_name" label="产品名称" width="120" />
                  <ElTableColumn prop="part.part_code" label="部件编码" width="100" />
                  <ElTableColumn prop="part.part_name" label="部件名称" width="100" />
                  <ElTableColumn prop="process.process_code" label="工艺编码" width="100" />
                  <ElTableColumn prop="process.process_name" label="工艺名称" width="100" />
                  <ElTableColumn prop="number" label="完成数量" width="90" />
                  <ElTableColumn prop="bomChildren.price" label="加工单价" width="90" />
                  <ElTableColumn label="计件工资" width="90">
                    {({row}) => <span>{ row.bomChildren ? PreciseMath.mul(row.number, row.bomChildren.price) : '' }</span>}
                  </ElTableColumn>
                  <ElTableColumn label="操作" width="140" fixed="right">
                    {({ row }) => (
                      <>
                        { row.status == 0 ? <ElButton size="small" type="primary" v-permission={ 'pieceRate:confirm' } onClick={ () => handleConfirm(row) }>确认</ElButton> : '' }
                        { row.status == 0 ? <ElButton size="small" type="warning" v-permission={ 'pieceRate:edit' } onClick={ () => handleUplate(row) }>修改</ElButton> : '' }
                      </>
                    )}
                  </ElTableColumn>
                </ElTable>
                <ElPagination ref={ pagin } layout="prev, pager, next, jumper, total" currentPage={ currentPage.value } pageSize={ pageSize.value } total={ total.value } defaultPageSize={ pageSize.value } style={{ justifyContent: 'center', paddingTop: '10px' }} onUpdate:currentPage={ (page) => currentPageChange(page) } onUupdate:pageSize={ (size) => pageSizeChange(size) } />
              </>
            )
          }}
        </ElCard>
        <ElDialog v-model={ dialogVisible.value } title='修改员工计件' width='775' center draggable onClose={ () => handleClose() }>
          {{
            default: () => (
              <ElForm class="ml30" model={ form.value } ref={ formRef } inline={ true } rules={ rules } label-width="85px">
                <ElFormItem label="员工工号">
                  <ElInput v-model={ form.value.employee_id } placeholder="请输入员工工号" disabled />
                </ElFormItem>
                <ElFormItem label="员工姓名">
                  <ElInput v-model={ form.value.name } placeholder="请输入员工姓名" disabled />
                </ElFormItem>
                <ElFormItem label="所属部门">
                  <ElInput v-model={ form.value.cycle_name } placeholder="请输入所属部门" disabled />
                </ElFormItem>
                <ElFormItem label="生产日期">
                  <ElInput v-model={ form.value.date } placeholder="请输入生产日期" disabled />
                </ElFormItem>
                <ElFormItem label="产品编码">
                  <ElInput v-model={ form.value.product_code } placeholder="请输入产品编码" disabled />
                </ElFormItem>
                <ElFormItem label="产品名称">
                  <ElInput v-model={ form.value.product_name } placeholder="请输入产品名称" disabled />
                </ElFormItem>
                <ElFormItem label="部件编码">
                  <ElInput v-model={ form.value.part_code } placeholder="请输入部件编码" disabled />
                </ElFormItem>
                <ElFormItem label="部件名称">
                  <ElInput v-model={ form.value.part_name } placeholder="请输入部件名称" disabled />
                </ElFormItem>
                <ElFormItem label="工艺编码">
                  <ElInput v-model={ form.value.process_code } placeholder="请输入工艺编码" disabled />
                </ElFormItem>
                <ElFormItem label="工艺名称">
                  <ElInput v-model={ form.value.process_name } placeholder="请输入工艺名称" disabled />
                </ElFormItem>
                <ElFormItem label="完成数量">
                  <ElInput v-model={ form.value.number } placeholder="请输入完成数量" disabled />
                </ElFormItem>
                <ElFormItem label="递减数量" prop="sub_number">
                  <ElInput v-model={ form.value.sub_number } type="number" placeholder="请输入递减数量" />
                  <span class="f12, pt5" style={{ lineHeight: 1 }}>即：如需减<span style={{ color: 'red' }}>500</span>，请填写<span style={{ color: 'red' }}>500</span>即可</span>
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