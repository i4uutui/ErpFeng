import { defineComponent, ref, onMounted, reactive, computed, nextTick } from 'vue'
import { CirclePlusFilled, RemoveFilled } from '@element-plus/icons-vue'
import { getPageHeight, isEmptyValue } from '@/utils/tool'
import request from '@/utils/request';
import MySelect from '@/components/tables/mySelect.vue';
import { reportOperationLog } from '@/utils/log';

export default defineComponent({
  setup(){
    const formRef = ref(null);
    const formCard = ref(null)
    const formHeight = ref(0);
    const rules = reactive({
      product_id: [
        { required: true, message: '请选择产品编码', trigger: 'blur' },
      ],
      part_id: [
        { required: true, message: '请选择部件编码', trigger: 'blur' },
      ],
      process_id: [
        { required: true, message: '请选择工艺编码', trigger: 'blur' }
      ],
      equipment_id: [
        { required: true, message: '请选择设备编码', trigger: 'blur' },
      ],
      time: [
        { required: true, message: '请输入单件工时(秒)', trigger: 'blur' },
      ],
      price: [
        { required: true, message: '请输入加工单价', trigger: 'blur' },
      ],
      points: [
        { required: true, message: '请输入段数点数', trigger: 'blur' },
      ]
    })
    let dialogVisible = ref(false)
    let form = ref({
      product_id: '',
      part_id: '',
      children: [
        { process_id: '', equipment_id: '', time: '', price: '', points: '1', sort: 1 }
      ]
    })
    let productsList = ref([])
    let partList = ref([])
    let processList = ref([])
    let tableData = ref([])
    let edit = ref(0)
    let loading = ref(false)

    const maxBomLength = computed(() => {
      if (tableData.value.length === 0) return 0;
      return Math.max(...tableData.value.map(item => item.children.length));
    });

    // 处理数据：确保每条记录的 children 长度一致（不足的补空对象）
    const processedTableData = computed(() => {
      return tableData.value.map(item => {
        const newItem = { ...item, children: [...item.children] };
        while (newItem.children.length < maxBomLength.value) {
          newItem.children.push({
            process: {
              process_code: '',
              process_name: '',
            },
            equipment: {
              equipment_code: '',
              equipment_name: '',
            },
            time: '',
            price: '',
            points: '1'
          });
        }
        return newItem;
      });
    });
    
    onMounted(() => {
      nextTick(async () => {
        formHeight.value = await getPageHeight([formCard.value]);
      })
      fetchProductList()
      getProductsCode()
      getPartCode()
      getProcessCode()
    })
    
    // 获取列表
    const fetchProductList = async () => {
      const res = await request.get('/api/process_bom', {
        params: {
          page: 1,
          pageSize: 100,
          archive: 1
        },
      });
      tableData.value = res.data;
    };
    const getProductsCode = async () => {
      const res = await request.get('/api/getProductsCode')
      if(res.code == 200){
        productsList.value = res.data
      }
    }
    const getPartCode = async () => {
      const res = await request.get('/api/getPartCode')
      if(res.code == 200){
        partList.value = res.data
      }
    }
    const getProcessCode = async () => {
      const res = await request.get('/api/getProcessCode')
      if(res.code == 200){
        processList.value = res.data
      }
    }
    const handleSubmit = async (formEl) => {
      if (!formEl) return
      await formEl.validate(async (valid, fields) => {
        if (valid){
          loading.value = true
          const low = { ...form.value, archive: 1 }
          low.children.forEach((e, index) => e.process_index = index + 1)
          if(!edit.value){
            const res = await request.post('/api/process_bom', low);
            if(res && res.code == 200){
              ElMessage.success('新增成功');
              dialogVisible.value = false;
              fetchProductList();

              const product = productsList.value.find(o => o.id == low.product_id)
              const part = partList.value.find(o => o.id == low.part_id)
              const process = low.children.map(e => {
                const obj = processList.value.find(o => o.id == e.process_id)
                return obj.process_code
              })
              reportOperationLog({
                operationType: 'add',
                module: '工艺BOM',
                desc: `新增工艺BOM，产品编码：${product.product_code}，部件编码：${part.part_code}，工艺编码：${process.toString()}`,
                data: { newData: low }
              })
            }
            
          }else{
            // 修改
            low.children.forEach(e => e.process_bom_id = edit.value)
            const myForm = {
              id: edit.value,
              ...low
            }
            const res = await request.put('/api/process_bom', myForm);
            if(res && res.code == 200){
              ElMessage.success('修改成功');
              dialogVisible.value = false;
              fetchProductList();

              const product = productsList.value.find(o => o.id == myForm.product_id)
              const part = partList.value.find(o => o.id == myForm.part_id)
              const process = low.children.map(e => {
                const obj = processList.value.find(o => o.id == e.process_id)
                return obj.process_code
              })
              reportOperationLog({
                operationType: 'update',
                module: '工艺BOM',
                desc: `修改工艺BOM，产品编码：${product.product_code}，部件编码：${part.part_code}，工艺编码：${process.toString()}`,
                data: { newData: myForm }
              })
            }
          }
          loading.value = false
        }
      })
    }
    const handleArchive = () => {
      if(tableData.value.length){
        ElMessageBox.confirm('是否确认存档', '提示', {
          confirmButtonText: '确认',
          cancelButtonText: '取消',
          type: 'warning',
        }).then(async () => {
          const ids = tableData.value.map(row => row.id)
          const res = await request.put('/api/process_bom_archive', { ids, archive: 0 });
          if(res && res.code == 200){
            ElMessage.success('修改成功');
            dialogVisible.value = false;
            fetchProductList();

            let str = ''
            tableData.value.forEach((e, index) => {
              const obj = `产品编码：${e.product.product_code}，部件编码：${e.part.part_code}，材料编码：${e.children.map(e => e.process.process_code).toString()}；`
              str += obj
              if(index < tableData.value.length - 1){
                str += '\r\n'
              }
            })
            reportOperationLog({
              operationType: 'keyup',
              module: '工艺BOM',
              desc: `存档工艺BOM，${str}`,
              data: { newData: { ids, archive: 0 } }
            })
          }
        }).catch(() => {})
      }else{
        ElMessage.error('暂无数据可存档！');
      }
    }
    const handleDelete = ({ id }) => {
      ElMessageBox.confirm('是否确认删除', '提示', {
          confirmButtonText: '确认',
          cancelButtonText: '取消',
          type: 'warning',
        }).then(async () => {
          const res = await request.delete('/api/process_bom', { params: { id } });
          if(res && res.code == 200){
            ElMessage.success('删除成功');
            dialogVisible.value = false;
            fetchProductList();
            reportOperationLog({
            operationType: 'delete',
            module: '工艺BOM',
            desc: `删除工艺BOM，产品编码：${row.product.product_code}，部件编码：${row.part.part_code}，工艺编码：${row.children.map(e => e.process.process_code).toString()}`,
            data: { newData: row.id }
          })
          }
        }).catch(() => {})
    }
    const handleUplate = ({ id, product_id, part_id, children }) => {
      edit.value = id;
      dialogVisible.value = true;
      let filtered = children.filter(item => {
        return !Object.values(item).every(isEmptyValue);
      });
      if(!filtered.length) filtered = [{ process_id: '', equipment_id: '', time: '', price: '', points: '1' }]
      form.value = { children: filtered, id, product_id, part_id };
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
        product_id: '',
        part_id: '',
        children: [
          { process_id: '', equipment_id: '', time: '', price: '', points: '1' }
        ]
      }
    }
    const handleAddJson = () => {
      const obj = { process_id: '', equipment_id: '', time: '', price: '', points: '1' }
      form.value.children.push(obj)
    }
    const handledeletedJson = (index) => {
      form.value.children.splice(index, 1)
    }
    const headerCellStyle = ({ columnIndex, rowIndex, column }) => {
      if(rowIndex >= 1 || columnIndex >= 5 && column.label != '操作'){
        return { backgroundColor: '#fbe1e5' }
      }
    }
    const cellStyle = ({ columnIndex, rowIndex, column }) => {
      if(columnIndex >= 5 && column.label != '操作'){
        return { backgroundColor: '#fbe1e5' }
      }
    }
    const goArchive = () => {
      window.open('/#/product/process-bom-archive', '_blank')
    }
    return() => (
      <>
        <ElCard>
          {{
            header: () => (
              <div class="flex row-between" ref={ formCard }>
                <div>
                  <ElButton style="margin-top: -5px" type="primary" v-permission={ 'ProcessBOM:add' } onClick={ handleAdd } >
                    新增工艺BOM
                  </ElButton>
                  <ElButton style="margin-top: -5px" type="primary" v-permission={ 'ProcessBOM:archive' } onClick={ handleArchive } >
                    存档
                  </ElButton>
                </div>
                <div>
                  <ElButton style="margin-top: -5px" type="warning" v-permission={ 'ProcessBOM:newPage' } onClick={ goArchive } >
                    工艺BOM库
                  </ElButton>
                </div>
              </div>
            ),
            default: () => (
              <>
                <ElTable data={ processedTableData.value } border stripe height={ `calc(100vh - ${formHeight.value + 224}px)` } style={{ width: "100%" }} headerCellStyle={ headerCellStyle } cellStyle={ cellStyle }>
                  <ElTableColumn prop="product.product_code" label="产品编码" fixed="left" />
                  <ElTableColumn prop="product.product_name" label="产品名称" fixed="left" />
                  <ElTableColumn prop="product.drawing" label="工程图号" fixed="left" />
                  <ElTableColumn prop="part.part_code" label="部位编码" fixed="left" />
                  <ElTableColumn prop="part.part_name" label="部位名称" fixed="left" />
                  {
                    Array.from({ length: maxBomLength.value }).map((_, index) => (
                      <ElTableColumn label={`工序-${index + 1}`} key={index}>
                        <ElTableColumn prop={`children[${index}].process.process_code`} label="工艺编码" />
                        <ElTableColumn prop={`children[${index}].process.process_name`} label="工艺名称" />
                        <ElTableColumn prop={`children[${index}].equipment.equipment_code`} label="设备编码" />
                        <ElTableColumn prop={`children[${index}].equipment.equipment_name`} label="设备名称" />
                        <ElTableColumn prop={`children[${index}].time`} label="单件工时(秒)" />
                        <ElTableColumn prop={`children[${index}].price`} label="加工单价" />
                        <ElTableColumn prop={`children[${index}].points`} label="段数点数" />
                        <ElTableColumn prop={`children[${index}].equipment.cycle.name`} label="生产制程" />
                      </ElTableColumn>
                    ))
                  }
                  <ElTableColumn label="操作" width="140" fixed="right">
                    {(scope) => (
                      <>
                        <ElButton size="small" type="default" v-permission={ 'ProcessBOM:edit' } onClick={ () => handleUplate(scope.row) }>修改</ElButton>
                        <ElButton size="small" type="danger" v-permission={ 'ProcessBOM:delete' } onClick={ () => handleDelete(scope.row) }>删除</ElButton>
                      </>
                    )}
                  </ElTableColumn>
                </ElTable>
              </>
            )
          }}
        </ElCard>
        <ElDialog v-model={ dialogVisible.value } title={ edit.value ? '修改工艺BOM信息' : '新增工艺BOM信息' } bodyClass="dialogBodyStyle" onClose={ () => handleClose() }>
          {{
            default: () => (
              <ElForm model={ form.value } ref={ formRef } inline={ true } rules={ rules } label-width="110px">
                <ElFormItem label="产品编码" prop="product_id">
                  <MySelect v-model={ form.value.product_id } apiUrl="/api/getProductsCode" query="product_code" itemValue="product_code" placeholder="请选择产品编码" />
                </ElFormItem>
                <ElFormItem label="部件编码" prop="part_id">
                  <MySelect v-model={ form.value.part_id } apiUrl="/api/getPartCode" query="part_code" itemValue="part_code" placeholder="请选择部件编码" />
                </ElFormItem>
                <div>
                  {
                    form.value.children.map((e, index) => (
                      <>
                        <div class="pl20">{ index + 1 }.</div>
                        <div key={ index }>
                          <ElFormItem label="工艺编码" prop={ `children[${index}].process_id` } rules={ rules.process_id }>
                            <MySelect v-model={ e.process_id } apiUrl="/api/getProcessCode" query="process_code" itemValue="process_code" placeholder="请选择工艺编码" />
                          </ElFormItem>
                          <ElFormItem label="设备编码" prop={ `children[${index}].equipment_id` } rules={ rules.equipment_id }>
                            <MySelect v-model={ e.equipment_id } apiUrl="/api/getEquipmentCode" query="equipment_code" itemValue="equipment_code" placeholder="请选择设备编码" />
                          </ElFormItem>
                          <ElFormItem label="单件工时(秒)" prop={ `children[${index}].time` } rules={ rules.time }>
                            <ElInput v-model={ e.time } placeholder="请输入单件工时(秒)" />
                          </ElFormItem>
                          <ElFormItem label="加工单价" prop={ `children[${index}].price` } rules={ rules.price }>
                            <ElInput v-model={ e.price } placeholder="请输入加工单价" />
                          </ElFormItem>
                          <ElFormItem label="段数点数" prop={ `children[${index}].points` } rules={ rules.points }>
                            <div class="flex">
                              <ElInput v-model={ e.points } placeholder="请输入段数点数" />
                              <div class="flex">
                                {{
                                  default: () => {
                                    let dom = []
                                    if(index == form.value.children.length - 1 && index < 20){
                                      dom.push(<ElIcon style={{ fontSize: '26px', color: '#409eff', cursor: "pointer" }} onClick={ handleAddJson }><CirclePlusFilled /></ElIcon>)
                                    }
                                    if(form.value.children.length > 1){
                                      dom.push(<ElIcon style={{ fontSize: '26px', color: 'red', cursor: "pointer" }} onClick={ () => handledeletedJson(index) }><RemoveFilled /></ElIcon>)
                                    }
                                    return dom
                                  }
                                }}
                              </div>
                            </div>
                          </ElFormItem>
                        </div>
                      </>
                    ))
                  }
                </div>
              </ElForm>
            ),
            footer: () => (
              <span class="dialog-footer">
                <ElButton onClick={ handleClose }>取消</ElButton>
                <ElButton type="primary" loading={ loading.value } onClick={ () => handleSubmit(formRef.value) }>确定</ElButton>
              </span>
            )
          }}
        </ElDialog>
      </>
    )
  }
})