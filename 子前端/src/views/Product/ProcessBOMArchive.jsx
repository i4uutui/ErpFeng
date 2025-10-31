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
    const pagin = ref(null)
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
    let form = ref({
      product_id: '',
      part_id: '',
      children: [
        { process_id: '', equipment_id: '', time: '', price: '', points: '1' }
      ]
    })
    let tableData = ref([])
    let dialogVisible = ref(false)
    let productsList = ref([])
    let processList = ref([])
    let partList = ref([])
    let currentPage = ref(1);
    let pageSize = ref(20);
    let total = ref(0);
    let product_code = ref('')
    let product_name = ref('')
    let edit = ref('')

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
              section_points: '',
            },
            equipment: {
              equipment_code: '',
              equipment_name: '',
            },
            time: '',
            price: '',
            cycle_id: '',
          });
        }
        return newItem;
      });
    });
    
    onMounted(() => {
      nextTick(async () => {
        formHeight.value = await getPageHeight([formCard.value, pagin.value]);
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
          page: currentPage.value,
          pageSize: pageSize.value,
          archive: 0,
          product_code: product_code.value,
          product_name: product_name.value,
        },
      });
      tableData.value = res.data;
      total.value = res.total;
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
    const handleCope = (row) => {
      ElMessageBox.confirm('是否确认复制新增', '提示', {
        confirmButtonText: '确认',
        cancelButtonText: '取消',
        type: 'warning',
      }).then(async () => {
        const params = { id: row.id, type: 'process' }
        const res = await request.post('/api/cope_bom', params)
        if(res && res.code == 200){
          ElMessage.success('操作成功');
          reportOperationLog({
            operationType: 'copeAdd',
            module: '工艺BOM',
            desc: `复制新增工艺BOM，产品编码：${row.product.product_code}，部件编码：${row.part.part_code}，工艺编码：${row.children.map(e => e.process.process_code).toString()}`,
            data: { newData: row.id }
          })
        }
      }).catch(() => {})
    }
    const handleSubmit = async (formEl) => {
      if (!formEl) return
      await formEl.validate(async (valid, fields) => {
        if (valid){
          const low = { ...form.value, archive: 0 }
          low.children.forEach((e, index) => e.process_index = index + 1)
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
      })
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
    const handleUplate = ({ id, product_id, part_id, children }) => {
      edit.value = id;
      dialogVisible.value = true;
      let filtered = children.filter(item => {
        return !Object.values(item).every(isEmptyValue);
      });
      if(!filtered.length) filtered = [{ process_id: '', equipment_id: '', time: '', price: '', points: '1' }]
      form.value = { children: filtered, id, product_id, part_id };
    }
    const handledeletedJson = (index) => {
      form.value.children.splice(index, 1)
    }
    const handleAddJson = () => {
      const obj = { process_id: '', equipment_id: '', time: '', price: '', points: '1' }
      form.value.children.push(obj)
    }
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
    const goBack = () => {
      window.location.href = "/#/product/process-bom";
    }
    return() => (
      <>
        <ElCard>
          {{
            header: () => (
              <div class="flex row-between" ref={ formCard }>
                <div class='flex flex-1'>
                  <div class="flex pl10">
                    <span>产品编码：</span>
                    <ElInput v-model={ product_code.value } style="width: 240px" placeholder="请输入产品编码" />
                  </div>
                  <div class="flex pl10">
                    <span>产品名称：</span>
                    <ElInput v-model={ product_name.value } style="width: 240px" placeholder="请输入产品名称" />
                  </div>
                  <div class="pl10">
                    <ElButton style="margin-top: -5px" type="primary" onClick={ fetchProductList } >
                      查询
                    </ElButton>
                  </div>
                </div>
                <div class="pl10">
                  <ElButton style="margin-top: -5px" type="warning" onClick={ () => goBack() } >
                    返回
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
                        <ElTableColumn prop={`children[${index}].time`} label="单件工时" />
                        <ElTableColumn prop={`children[${index}].price`} label="加工单价" />
                        <ElTableColumn prop={`children[${index}].points`} label="段数点数" />
                        <ElTableColumn prop={`children[${index}].equipment.cycle.name`} label="生产制程" />
                      </ElTableColumn>
                    ))
                  }
                  <ElTableColumn label="操作" width="180" fixed="right">
                    {(scope) => (
                      <>
                        <ElButton size="small" type="primary" v-permission={ 'ProcessBOM:cope' } onClick={ () => handleCope(scope.row) }>复制新增</ElButton>
                        <ElButton size="small" type="default" v-permission={ 'ProcessBOM:edit' } onClick={ () => handleUplate(scope.row) }>修改</ElButton>
                      </>
                    )}
                  </ElTableColumn>
                </ElTable>
                <ElPagination ref={ pagin } layout="prev, pager, next, jumper, total" currentPage={ currentPage.value } pageSize={ pageSize.value } total={ total.value } defaultPageSize={ pageSize.value } style={{ justifyContent: 'center', paddingTop: '10px' }} onUpdate:currentPage={ (page) => currentPageChange(page) } onUupdate:pageSize={ (size) => pageSizeChange(size) } />
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
                <ElButton type="primary" onClick={ () => handleSubmit(formRef.value) }>确定</ElButton>
              </span>
            )
          }}
        </ElDialog>
      </>
    )
  }
})