import { defineComponent, ref, onMounted, reactive, nextTick } from 'vue'
import request from '@/utils/request';
import router from '@/router';
import { filterMenu, getPageHeight } from '@/utils/tool';

export default defineComponent({
  setup(){
    const formCard = ref(null)
    const pagin = ref(null)
    const formHeight = ref(0);
    const typeValue = reactive({
      add: '新增',
      update: '修改',
      delete: '删除',
      paichang: '通知单排序',
      keyup: '工艺/材料BOM存档',
      approval: '审批',
      keyApproval: '新增审批',
      backApproval: '反审批',
      login: '登录'
    })
    const props = reactive({
      value: 'label'
    })
    let type = ref('')
    let module = ref('')
    let user_id = ref('')
    let options = ref([])
    let userList = ref([])
    let tableData = ref([])
    let currentPage = ref(1);
    let pageSize = ref(20);
    let total = ref(0);

    onMounted(() => {
      nextTick(async () => {
        formHeight.value = await getPageHeight([formCard.value, pagin.value]);
      })

      fetchAdminList()
      fetchUserList()
      generateCascaderOptions()
    })

    // 获取子管理员列表
    const fetchAdminList = async () => {
      const res = await request.get('/api/operation_history', {
        params: {
          page: currentPage.value,
          pageSize: pageSize.value,
          user_id: user_id.value,
          operation_type: type.value,
          module: module.value[1]
        },
      });
      tableData.value = res.data;
      total.value = res.total;
    };
    // 获取子管理员列表
    const fetchUserList = async () => {
      const res = await request.get('/api/user', {
        params: {
          page: 1,
          pageSize: 100
        },
      });
      userList.value = res.data;
    };
    const generateCascaderOptions = () => {
      const { children } = router.options.routes.find(route => route.name === 'Layout');
      const groupedRoutes = {};
      children.forEach(route => {
        const { parent } = route.meta;
        if (!groupedRoutes[parent]) {
          groupedRoutes[parent] = [];
        }
        const menuItem = {
          value: route.name, // 菜单权限标识
          label: route.meta.title,
        };
        groupedRoutes[parent].push(menuItem);
      });
      let filtered = Object.fromEntries(
        Object.entries(filterMenu(groupedRoutes, ['ApprovalStep', 'Trajectory', 'Home', 'MaterialBOMArchive', 'ProcessBOMArchive'])).filter(([_, routes]) => routes.length > 0)
      );
      const menu = Object.entries(filtered).map(([key, value]) => ({
        value: key,
        label: key,
        children: value
      }));
      options.value = menu
    }
    const changeCascader = (value) => {
      console.log(value);
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
              <ElForm inline={ true } ref={ formCard }>
                <ElFormItem label="操作人名称">
                  <ElSelect v-model={ user_id.value } multiple={false} filterable remote remote-show-suffix clearable valueKey="id" placeholder="请选择操作类型">
                    {userList.value.map((e, index) => <ElOption value={ e.id } label={ e.name } key={ index } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="操作类型">
                  <ElSelect v-model={ type.value } multiple={false} filterable remote remote-show-suffix clearable valueKey="id" placeholder="请选择操作类型">
                    {Object.entries(typeValue).map(([key, value]) => <ElOption value={ key } label={ value } key={ key } />)}
                  </ElSelect>
                </ElFormItem>
                <ElFormItem label="操作模块">
                  <ElCascader v-model={ module.value } options={ options.value } props={ props } placeholder="请选择操作类型" clearable show-all-levels={ false } filterable onChange={ (value) => changeCascader(value) }></ElCascader>
                </ElFormItem>
                <ElFormItem>
                  <ElButton type="primary" onClick={ () => fetchAdminList() }>查询</ElButton>
                </ElFormItem>
              </ElForm>
            ),
            default: () => (
              <>
                <ElTable data={ tableData.value } border stripe height={ `calc(100vh - ${formHeight.value + 224}px)` } style={{ width: "100%" }}>
                  {/* <ElTableColumn prop="id" label="ID" width="180" /> */}
                  <ElTableColumn prop="user_name" label="操作人名称" width="180" />
                  <ElTableColumn label="操作类型" width="180">
                    {({row}) => <span>{ typeValue[row.operation_type] }</span>}
                  </ElTableColumn>
                  <ElTableColumn prop="module" label="操作模块" width="180" />
                  <ElTableColumn prop="desc" label="操作描述" />
                  <ElTableColumn prop="created_at" label="操作时间" width="180" />
                </ElTable>
                <ElPagination ref={ pagin } layout="prev, pager, next, jumper, total" currentPage={ currentPage.value } pageSize={ pageSize.value } total={ total.value } defaultPageSize={ pageSize.value } style={{ justifyContent: 'center', paddingTop: '10px' }} onUpdate:currentPage={ (page) => currentPageChange(page) } onUupdate:pageSize={ (size) => pageSizeChange(size) } />
              </>
            )
          }}
        </ElCard>
      </>
    )
  }
})