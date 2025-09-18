import { defineComponent, ref, reactive, onMounted } from 'vue'
import request from '@/utils/request';

export default defineComponent({
  setup(){
    const formRef = ref(null);
    const rules = reactive({})
    const form = ref({
      source_type: '',
      steps: [] // 审批步骤列表
    });
    const users = ref([]); // 用户列表
    
    onMounted(() => {
      getUser()
    })

    const getUser = async () => {
      const res = await request.get('/api/user', { params: { page: 1, pageSize: 100 } })
      users.value = res.data;
    }
    // 添加步骤
    const addStep = () => {
      const obj = {
        step: form.value.steps.length + 1,
        type: form.value.source_type,
        user_id: null,
      }
      form.value.steps.push(obj);
    };
    // 删除步骤
    const removeStep = (index) => {
      form.value.steps.splice(index, 1);
      // 重新排序
      form.value.steps.forEach((step, i) => step.step = i + 1);
    };
    // 提交表单
    const submitForm = async () => {
      const res = await request.post('/api/approval/flow', form.value);
      if (res.code === 200) {
        ElMessage.success('配置成功');
      }
    };
    const typeValue = reactive({
      purchase_order: '采购单',
      outsourcing_order: '委外加工单',
      material_warehouse: '材料出入库',
      product_warehouse: '成品出入库'
    })

    return() => (
      <>
        <ElCard bodyStyle={{ height: "calc(100vh - 144px )" }}>
          {{
            default: () => (
              <ElCard>
                <ElForm ref="formRef" model={ form.value } label-width="120px">
                  <ElFormItem label="业务类型" prop="source_type">
                    <ElSelect v-model={ form.value.source_type }>
                      <ElOption label="采购单" value="purchase_order" />
                      <ElOption label="委外加工单" value="outsourcing_order" />
                      <ElOption label="材料出入库" value="material_warehouse" />
                      <ElOption label="成品出入库" value="product_warehouse" />
                    </ElSelect>
                  </ElFormItem>

                  <ElFormItem label="审批步骤">
                    <ElButton onClick={ addStep } type="primary" size="small">添加步骤</ElButton>
                    <ElTable data={ form.value.steps } border style={{ marginTop: "10px" }}>
                      <ElTableColumn prop="step" label="步骤" width="80" />
                      <ElTableColumn label="类型" width="120">
                        {({row}) => <span>{ typeValue[row.type] }</span>}
                      </ElTableColumn>
                      <ElTableColumn label="指定审批人">
                        {{
                          default: ({ row }) => (
                            <ElSelect v-model={ row.user_id } clearable>
                              { users.value.map(user => <ElOption key={ user.id } label={ user.name } value={ user.id } />) }
                            </ElSelect>
                          )
                        }}
                      </ElTableColumn>
                      <ElTableColumn label="操作">
                        {{
                          default: (scope) => (
                            <ElButton onClick={ () => removeStep(scope.$index) } type="text" danger>删除</ElButton>
                          )
                        }}
                      </ElTableColumn>
                    </ElTable>
                  </ElFormItem>

                  <ElFormItem>
                    <ElButton type="primary" onClick={ () => submitForm() }>保存配置</ElButton>
                  </ElFormItem>
                </ElForm>
              </ElCard>
            )
          }}
        </ElCard>
      </>
    )
  }
})