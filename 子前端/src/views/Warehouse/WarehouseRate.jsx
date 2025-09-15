import { defineComponent, onMounted, ref, reactive } from 'vue'
import request from '@/utils/request';
import '@/assets/css/WarehouseRate.scss'

export default defineComponent({
  setup() {
    const itemCode = reactive({
      1: 'material_code',
      2: 'part_code',
      3: 'product_code'
    })
    const itemName = reactive({
      1: 'material_name',
      2: 'part_name',
      3: 'product_name'
    })
    const formRef = ref(null);
    const rules = reactive({
      supplier_id: [
        { required: true, message: '请选择供应商编码', trigger: 'blur' }
      ],
    })
    let dialogVisible = ref(false)
    let form = ref({
      ware_id: '',
      house_id: '',
      item_id: '',
      code: '',
      name: '',
      mode: '',
      other_features: '',
      initial: '',
      inv_unit: '',
      price: ''
    })
    let wareType = ref([])
    let wareActive = ref('')
    let houseList = ref([])
    let tabList = ref([])
    let materialList = ref([])
    let partList = ref([])
    let productList = ref([])
    let itemList = ref([])
    
    onMounted(() => {
      getWareTypeList()
      getMaterialList()
      getPartList()
      getProductList()
    })
    
    // 获取仓库类型列表
    const getWareTypeList = async () => {
      const res = await request.get('/api/getWarehouseType')
      wareType.value = res.data
      wareActive.value = res.data[0].id
      fetchTabList()
    }
    // 获取Tab列表
    const fetchTabList = async () => {
      const res = await request.get('/api/warehouse_cycle', {
        params: {
          page: 1,
          pageSize: 100,
          ware_id: wareActive.value
        },
      });
      tabList.value = res.data;
    };
    // 初始化新增
    const handleSubmit = async (formEl) => {
      if (!formEl) return
      await formEl.validate(async (valid, fields) => {
        if (valid){
          const res = await request.post('/api/intHouseContent', form.value);
          if(res && res.code == 200){
            ElMessage.success('添加成功');
            dialogVisible.value = false;
          }
        }
      })
    }
    // 获取材料编码列表
    const getMaterialList = async () => {
      const res = await request.get('/api/getMaterialCode')
      materialList.value = res.data
    }
    // 获取部件编码列表
    const getPartList = async () => {
      const res = await request.get('/api/getPartCode')
      partList.value = res.data
    }
    // 获取产品编码列表
    const getProductList = async () => {
      const res = await request.get('/api/getProductsCode')
      productList.value = res.data
    }
    const wareChange = async (value) => {
      const res = await request.get('/api/warehouse_cycle', {
        params: {
          page: 1,
          pageSize: 100,
          ware_id: value
        },
      });
      form.value.house_id = ''
      houseList.value = res.data;
      // 初始化物料列表
      const ware = form.value.ware_id
      if(ware == 1){
        itemList.value = materialList.value
      }else if(ware == 2){
        itemList.value = partList.value
      }else if(ware == 3){
        itemList.value = productList.value
      }
    }
    const houseChange = async (value) => {

    }
    const itemChange = (value) => {
      const item = itemList.value.find(item => item.id == value)
      form.value.code = item[itemCode[form.value.ware_id]]
      form.value.name = item[itemName[form.value.ware_id]]
      form.value.mode = `${item.model} / ${item.specification}`
      form.value.other_features = item.other_features
    }
    // 添加
    const handleAdd = () => {
      dialogVisible.value = true;
      resetForm()
    };
    // 取消弹窗
    const handleClose = () => {
      dialogVisible.value = false;
      resetForm()
    }
    const resetForm = () => {
      form.value = {
        ware_id: '',
        house_id: '',
        item_id: '',
        code: '',
        name: '',
        initial: '',
        inv_unit: '',
        price: ''
      }
    }
    const menuClick = (row) => {
      wareActive.value = row.index
      fetchTabList()
    }
    const onTabClick = (pane) => {
      const row = tabList.value[pane.index]
    }
    const getitemCode = (row) => {
      return row[itemCode[form.value.ware_id]]
    }
    
    return() => (
      <>
        <ElCard bodyStyle={{ height: "calc(100vh - 144px )" }}>
          <ElForm>
            <ElFormItem>
              <ElButton type="primary" onClick={ handleAdd }>初始新增</ElButton>
            </ElFormItem>
          </ElForm>
          <div class='flex wareHouse' style={{ alignItems: 'flex-start', height: '100%' }}>
            <ElMenu default-active="1">
              {wareType.value.map((e, index) => <ElMenuItem index={ e.id.toString() } key={ index } onClick={ (row) => menuClick(row) }>{e.name}</ElMenuItem>)}
            </ElMenu>
            <div class="right" style={{ paddingLeft: '20px' }}>
              <ElTabs type="card" onTabClick={ (pane, e) => onTabClick(pane, e) }>
                {tabList.value.map((item, index) => (
                  <ElTabPane label={ item.name }></ElTabPane>
                ))}
              </ElTabs>
            </div>
          </div>
        </ElCard>
        <ElDialog v-model={ dialogVisible.value } title='初始新增' onClose={ () => handleClose() }>
          {{
            default: () => (
              <ElForm model={ form.value } ref={ formRef } inline={ true } rules={ rules } label-width="110px">
                <ElFormItem label="仓库类型" prop="ware_id">
                  <ElSelect v-model={ form.value.ware_id } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择仓库类型" onChange={ (row) => wareChange(row) }>
                    {wareType.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="仓库名称" prop="house_id">
                  <ElSelect v-model={ form.value.house_id } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择仓库名称" onChange={ (row) => houseChange(row) }>
                    {houseList.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="物料编码" prop="item_id">
                  <ElSelect v-model={ form.value.item_id } multiple={false} filterable remote remote-show-suffix valueKey="id" placeholder="请选择物料编码" onChange={ (row) => itemChange(row) }>
                    {itemList.value.map((e, index) => <ElOption value={ e.id } label={ getitemCode(e) } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="期初数量" prop="initial">
                  <ElInput v-model={ form.value.initial } placeholder="请输入期初数量" />
                </ElFormItem>
                <ElFormItem label="库存单位" prop="inv_unit">
                  <ElInput v-model={ form.value.inv_unit } placeholder="请输入库存单位" />
                </ElFormItem>
                <ElFormItem label="内部单价" prop="price">
                  <ElInput v-model={ form.value.price } placeholder="请输入内部单价" />
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