import { defineComponent, ref, reactive, onMounted } from 'vue'
import request from '@/utils/request';

export default defineComponent({
  setup(){
    const typeValue = reactive({
      purchase_order: '采购单',
      outsourcing_order: '委外加工单',
      material_warehouse: '材料出入库',
      product_warehouse: '成品出入库'
    })
    const formRef = ref(null);
    const rules = reactive({})
    const form = ref({
      source_type: '',
      steps: [] // 审批步骤列表
    });
    const users = ref([]); // 用户列表
    let step = ref(0)
    
    onMounted(async () => {
      await getUser()
      await getApprovalFlow()
    })

    const getApprovalFlow = async () => {
      const res = await request.get('/api/get_approval_flow')
      form.value.steps = res.data
    }
    const getUser = async () => {
      const res = await request.get('/api/user', { params: { page: 1, pageSize: 100 } })
      users.value = res.data;
    }
    // 新增步骤
    const addStep = () => {
      if(!form.value.source_type) return ElMessage.error('请选择业务类型')
      
      step.value++
      const obj = {
        step: step.value,
        type: form.value.source_type,
        user_id: null,
        user_name: null
      }
      form.value.steps.push(obj);
    };
    // 删除步骤
    const removeStep = (index) => {
      const stepObj = form.value.steps
      const stepArr = stepObj.filter(o => o.type == stepObj[index].type)
      if(stepObj[index].step < stepArr.length){
        ElMessage.error(`请先删除第${stepArr.length}步`)
        return
      }
      form.value.steps.splice(index, 1);
    };
    // 提交表单
    const submitForm = async () => {
      const res = await request.post('/api/approval_flow', { steps: form.value.steps });
      if (res.code === 200) {
        ElMessage.success('配置成功');
      }
    };
    // 选择审批人，相同的业务类型不能选择相同的用户
    const userSelect = (value, index) => {
      const stepObj = form.value.steps
      const stepArr = stepObj.filter(o => o.type == stepObj[index].type && o.user_id == stepObj[index].user_id)
      if(stepArr.length >= 2){
        stepObj[index].user_id = ''
        return ElMessage.error('该业务类型已有此相同用户，不能重复选择')
      }
      stepObj[index].user_name = users.value.find(e => e.id == value).name
    }
    // 每次选择业务类型，都需要根据已新增的业务步骤来计算step
    const sourceChange = (value) => {
      const sourceLength = form.value.steps.filter(o => o.type == value).length
      step.value = sourceLength
    }

    return() => (
      <>
        <ElCard bodyStyle={{ height: "calc(100vh - 158px )" }}>
          {{
            default: () => (
              <ElCard bodyStyle={{ height: "calc(100vh - 198px)" }}>
                <ElForm ref="formRef" model={ form.value } label-width="120px" style={{ height: '100%' }}>
                  <ElFormItem label="业务类型" prop="source_type">
                    <ElSelect v-model={ form.value.source_type } style={{ width: '150px' }} onChange={ (row) => sourceChange(row) }>
                      <ElOption label="采购单" value="purchase_order" />
                      <ElOption label="委外加工单" value="outsourcing_order" />
                      <ElOption label="材料出入库" value="material_warehouse" />
                      <ElOption label="成品出入库" value="product_warehouse" />
                    </ElSelect>
                    <ElButton onClick={ addStep } type="primary" style={{ marginLeft: '10px' }}>新增步骤</ElButton>
                    <ElButton type="primary" onClick={ () => submitForm() }>保存配置</ElButton>
                  </ElFormItem>

                  <ElFormItem label="审批步骤" style={{ height: 'calc(100% - 50px)' }}>
                    <ElTable data={ form.value.steps } border height="100%" style={{ marginTop: "10px" }}>
                      <ElTableColumn prop="step" label="步骤" width="80" />
                      <ElTableColumn label="类型" width="120">
                        {({row}) => <span>{ typeValue[row.type] }</span>}
                      </ElTableColumn>
                      <ElTableColumn label="指定审批人">
                        {{
                          default: ({ row, $index }) => (
                            <ElSelect v-model={ row.user_id } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择审批人" onChange={ (row) => userSelect(row, $index) }>
                              { users.value.map((user, index) => <ElOption key={ user.id } label={ user.name } value={ user.id } />) }
                            </ElSelect>
                          )
                        }}
                      </ElTableColumn>
                      <ElTableColumn label="操作">
                        {{
                          default: (scope) => (
                            <ElButton class="textButton" onClick={ () => removeStep(scope.$index) } type="text" danger>删除</ElButton>
                          )
                        }}
                      </ElTableColumn>
                    </ElTable>
                  </ElFormItem>

                  {/* <ElFormItem>
                    <ElButton type="primary" onClick={ () => submitForm() }>保存配置</ElButton>
                  </ElFormItem> */}
                </ElForm>
              </ElCard>
            )
          }}
        </ElCard>
      </>
    )
  }
})