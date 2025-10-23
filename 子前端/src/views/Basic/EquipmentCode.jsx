import { defineComponent, ref, onMounted, reactive, watch } from 'vue'
import { reportOperationLog } from '@/utils/log';
import { PreciseMath } from '@/utils/tool'
import request from '@/utils/request';
import MySelect from '@/components/tables/mySelect.vue';

export default defineComponent({
  setup(){
    const formRef = ref(null);
    const rules = reactive({
      equipment_code: [
        { required: true, message: '请输入设备编码', trigger: 'blur' },
      ],
      equipment_name: [
        { required: true, message: '请输入设备名称', trigger: 'blur' },
      ],
      quantity: [
        { required: true, message: '请输入设备总数量', trigger: 'blur' },
      ],
      cycle_id: [
        { required: true, message: '请选择制程组', trigger: 'blur' },
      ],
      working_hours: [
        { required: true, message: '请输入工作时长(时)', trigger: 'blur' },
      ],
      efficiency: [
        { required: true, message: '请输入设备效能', trigger: 'blur' },
      ],
      available: [
        { required: true, message: '请输入可用设备数量', trigger: 'blur' },
      ],
    })
    let dialogVisible = ref(false)
    let form = ref({
      equipment_code: '',
      equipment_name: '',
      quantity: '',
      cycle_id: '',
      working_hours: '',
      efficiency: '',
      available: '',
      remarks: '',
    })
    let tableData = ref([])
    let currentPage = ref(1);
    let pageSize = ref(10);
    let total = ref(0);
    let edit = ref(0)

    onMounted(() => {
      fetchProductList()
    })
    watch(() => [form.value.available, form.value.working_hours], ([newAvailable, newWorkingHours]) => {
      // 转换为数字（处理空字符串或非数字情况）
      const availableNum = Number(newAvailable) || 0;
      const hoursNum = Number(newWorkingHours) || 0;

      // 若任一为空或非有效数字，清空效能
      if (!newAvailable || !newWorkingHours || isNaN(availableNum) || isNaN(hoursNum)) {
        form.value.efficiency = '';
      } else {
        // 两者都有值时，计算乘积并赋值给效能
        form.value.efficiency = PreciseMath.mul(availableNum, hoursNum);
      }
    }, { immediate: true });

    // 获取列表
    const fetchProductList = async () => {
      const res = await request.get('/api/equipment_code', {
        params: {
          page: currentPage.value,
          pageSize: pageSize.value
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
            const res = await request.post('/api/equipment_code', form.value);
            if(res && res.code == 200){
              ElMessage.success('新增成功');
              dialogVisible.value = false;
              fetchProductList();
              reportOperationLog({
                operationType: 'add',
                module: '设备编码',
                desc: `新增设备编码：${form.value.equipment_code}`,
                data: { newData: form.value }
              })
            }
            
          }else{
            // 修改
            const myForm = {
              id: edit.value,
              ...form.value
            }
            const res = await request.put('/api/equipment_code', myForm);
            if(res && res.code == 200){
              ElMessage.success('修改成功');
              dialogVisible.value = false;
              fetchProductList();
              reportOperationLog({
                operationType: 'update',
                module: '设备编码',
                desc: `修改设备编码：${myForm.equipment_code}`,
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
        const res = await request.delete('/api/equipment_code/' + row.id);
        if(res && res.code == 200){
          ElMessage.success('删除成功');
          fetchProductList();
          reportOperationLog({
            operationType: 'delete',
            module: '设备编码',
            desc: `删除设备编码：${row.equipment_code}`,
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
        equipment_code: '',
        equipment_name: '',
        quantity: '',
        cycle_id: '',
        working_hours: '',
        efficiency: '',
        available: '',
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
              <div class="clearfix">
                <ElButton style="margin-top: -5px" type="primary" v-permission={ 'EquipmentCode:add' } onClick={ handleAdd } >
                  新增设备编码
                </ElButton>
              </div>
            ),
            default: () => (
              <>
                <ElTable data={ tableData.value } border stripe style={{ width: "100%" }}>
                  <ElTableColumn prop="equipment_code" label="设备编码" />
                  <ElTableColumn prop="equipment_name" label="设备名称" />
                  <ElTableColumn prop="cycle.name" label="所属部门" />
                  <ElTableColumn prop="quantity" label="设备总数量" />
                  <ElTableColumn prop="working_hours" label="工作时长(时)" />
                  <ElTableColumn prop="available" label="可用设备数量" />
                  <ElTableColumn prop="efficiency" label="设备效能" />
                  <ElTableColumn prop="remarks" label="异常设备说明" />
                  <ElTableColumn label="操作" width='140' fixed="right">
                    {(scope) => (
                      <>
                        <ElButton size="small" type="default" v-permission={ 'EquipmentCode:edit' } onClick={ () => handleUplate(scope.row) }>修改</ElButton>
                        <ElButton size="small" type="danger" v-permission={ 'EquipmentCode:delete' } onClick={ () => handleDelete(scope.row) }>删除</ElButton>
                      </>
                    )}
                  </ElTableColumn>
                </ElTable>
                <ElPagination layout="prev, pager, next, jumper, total" currentPage={ currentPage.value } pageSize={ pageSize.value } total={ total.value } defaultPageSize={ pageSize.value } style={{ justifyContent: 'center', paddingTop: '10px' }} onUpdate:currentPage={ (page) => currentPageChange(page) } onUupdate:pageSize={ (size) => pageSizeChange(size) } />
              </>
            )
          }}
        </ElCard>
        <ElDialog v-model={ dialogVisible.value } title={ edit.value ? '修改设备信息' : '新增设备信息' } onClose={ () => handleClose() }>
          {{
            default: () => (
              <ElForm model={ form.value } ref={ formRef } inline={ true } rules={ rules } label-width="110px">
                <ElFormItem label="设备编码" prop="equipment_code">
                  <ElInput v-model={ form.value.equipment_code } placeholder="请输入设备编码" />
                </ElFormItem>
                <ElFormItem label="设备名称" prop="equipment_name">
                  <ElInput v-model={ form.value.equipment_name } placeholder="请输入设备名称" />
                </ElFormItem>
                <ElFormItem label="制程组" prop="cycle_id">
                  <MySelect v-model={ form.value.cycle_id } apiUrl="/api/getProcessCycle" query="name" itemValue="name" placeholder="请选择制程组" />
                </ElFormItem>
                <ElFormItem label="设备总数量" prop="quantity">
                  <ElInput v-model={ form.value.quantity } type="number" placeholder="请输入设备数量" />
                </ElFormItem>
                <ElFormItem label="工作时长(H)" prop="working_hours">
                  <ElInput v-model={ form.value.working_hours } type="number" placeholder="请输入工作时长(H)" />
                </ElFormItem>
                <ElFormItem label="可用设备数量" prop="available">
                  <ElInput v-model={ form.value.available } placeholder="请输入可用设备数量" />
                </ElFormItem>
                <ElFormItem label="设备效能" prop="efficiency">
                  <ElInput v-model={ form.value.efficiency } placeholder="请输入设备效能" />
                </ElFormItem>
                <ElFormItem label="异常设备说明" prop="remarks">
                  <ElInput v-model={ form.value.remarks } placeholder="请输入异常设备说明" />
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