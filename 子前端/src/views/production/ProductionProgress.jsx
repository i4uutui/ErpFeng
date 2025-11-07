import { defineComponent, onMounted, ref, reactive, computed, nextTick } from 'vue'
import dayjs from 'dayjs';
import request from '@/utils/request';
import "@/assets/css/production.scss"
import { getPageHeight } from '@/utils/tool';

export default defineComponent({
  setup(){
    const formCard = ref(null)
    const formHeight = ref(0);
    let tableData = ref([])
    let cycleList = ref([])
    let date_more = ref([])
    let specialDates = ref(new Set());
    // 查询tableData下的工序长度，确定表格中的工序显示的数量
    const maxBomLength = computed(() => {
      if (tableData.value.length === 0) return 0;
      const list = tableData.value.map(item => item.items?.length || 0)
      return Math.max(...list);
    });
    
    onMounted(async () => {
      nextTick(async () => {
        // 无效果，待以后优化本页面
        formHeight.value = await getPageHeight([formCard.value]);
      })
      await getProgressBase(); //// 获取进度表基础数据
      await fetchSpecialDates();
    })
    
    // 获取进度表基础数据
    const getProgressBase = async () => {
      const res = await request.get('/api/get_progress_base');
      if(res.code == 200){
        tableData.value = res.data
        if(res.data.length){
          const base = res.data.map(item => ({ id: item.id, start_date: item.start_date, delivery_time: item.notice.delivery_time }))
          getProgressCycle(base)
        }
      }
    };
    // 获取进度表进程的数据
    const getProgressCycle = async (base) => {
      const res = await request.post('/api/get_progress_cycle', { base })
      if(res.code == 200){
        // 制程的数据
        const cycles = res.data.cycles
        date_more.value = res.data.date_more
        cycleList.value = cycles
        // 工序的数据
        const works = res.data.works
        const groupedData = {};
        works.forEach(item => {
          const key = item.progress_id;
          if (!groupedData[key]) {
            groupedData[key] = [];
          }
          groupedData[key].push(item);
        })
        // 对每个分组按 process_index 排序（升序，确保顺序正确）
        Object.keys(groupedData).forEach(key => {
          groupedData[key].sort((a, b) => a.children.process_index - b.children.process_index);
        });

        // 遍历 tableData，匹配分组数据并合并
        tableData.value = tableData.value.map(tableItem => ({
          ...tableItem,
          // 匹配 progress_id = tableItem.id 的分组，无匹配则设为空数组
          items: groupedData[tableItem.id] || []
        }));
      }
    }
    // 获取特殊日期
    const fetchSpecialDates = async () => {
      const res = await request.get('/api/special-dates');
      if (res.data && Array.isArray(res.data)) {
        // 将特殊日期存储在Set中，便于快速查找
        specialDates.value = new Set(res.data.map(item => item.date));
      }
    }
    // 检查日期是否为特殊日期
    const isSpecialDate = (date) => {
      if (!date) return false;
      return specialDates.value.has(dayjs(date).format('YYYY-MM-DD'));
    };
    // 修改：委外/库存数量
    const houseBlur = async (row) => {
      const res = await request.post('/api/set_out_number', {
        id: row.id,
        house_number: row.house_number,
        order_number: row.sale.order_number
      })
      if(res.code == 200){
        getProgressBase()
      }
    }
    // 更新制程组的最短交货时间
    const sortDateBlur = async ({ id, sort_date }) => {
      const params = {
        id,
        sort_date
      }
      await request.put('/api/process_cycle', params);
      getProgressBase();
    }
    // 批量更新起始生产时间/预排交期
    const set_production_date = async (params, type) => {
      const res = await request.put('/api/set_production_date', { params, type });
      if(res && res.code == 200){
        ElMessage.success('修改成功');
        getProgressBase();
      }
    }
    // 选择预排交期的时间
    const paiChange = (value, row, param) => {
      if(!param.start_date) {
        ElMessage.error('请先选择起始生产日期')
        row.end_date = ''
        return
      }
      const time = row.end_date
      // 检查是否是特殊日期
      if (isSpecialDate(time)) {
        ElMessage.warning('请注意，你所选择的日期为节假日');
      }
      
      if(dayjs(time).isBefore(dayjs(param.start_date))){
        ElMessage.error('请选择大于或等于起始生产的日期')
        row.end_date = ''
        return
      }

      ElMessageBox.confirm('是否同步更新相同订单相同制程组的预排交期？', '提示', {
        confirmButtonText: '同步更新',
        cancelButtonText: '不同步',
        type: 'warning',
        closeOnClickModal: false,
        closeOnPressEscape: false,
        distinguishCancelAndClose: true
      }).then(() => {
        let params = []
        const item = cycleList.value.find(o => o.id == row.cycle_id)?.cycle
        if(item && item.length){
          item.forEach(e => {
            if(e.cycle_id == row.cycle_id && e.notice_id == param.notice_id){
              params.push({
                id: e.id,
                end_date: time,
                cycle_id: e.cycle_id,
                notice_id: e.notice_id
              })
            }
          })
        }
        if(params.length){
          set_production_date(params, 'end_date')
        }
      }).catch((action) => {
        if(action == 'cancel'){
          const params = [{
            id: row.id,
            end_date: time,
            cycle_id: row.cycle_id,
            notice_id: row.notice_id
          }]
          set_production_date(params, 'end_date')
        }
      })
    }
    // 选择生产起始时间
    const dateChange = async (value, row) => {
      if (isSpecialDate(row.start_date)) {
        ElMessage.warning('请注意，你所选择的日期为节假日');
      }

      const time = row.start_date
      ElMessageBox.confirm('是否同步更新相同订单的生产起始日期？', '提示', {
        confirmButtonText: '同步更新',
        cancelButtonText: '不同步',
        type: 'warning',
        closeOnClickModal: false,
        closeOnPressEscape: false,
        distinguishCancelAndClose: true
      }).then(() => {
        const table  = tableData.value.filter(e => e.notice_id == row.notice_id)
        let params = []
        table.forEach(e => {
          params.push({
            id: e.id,
            start_date: time
          })
        })
        set_production_date(params, 'start_date')
      }).catch((action) => {
        if(action == 'cancel'){
          const params = [{ id: row.id, start_date: time }]
          set_production_date(params, 'start_date')
        }
      })
    }
    // 表格中的表头的颜色
    const columnLength = 15 // 表示前面不需要颜色的列数
    const headerCellStyle = ({ rowIndex, columnIndex, column, row }) => {
      if(!tableData.value.length) return
      const cycleLength = cycleList.value.length * 3
      const start = columnLength + cycleLength;
      if(rowIndex == 1 && columnIndex >= 0 && columnIndex < cycleLength || rowIndex == 0 && columnIndex >= columnLength && columnIndex < start){
        if(rowIndex == 0){
          return { backgroundColor: getColumnStyle(columnIndex, columnLength, 3) }
        }else{
          return { backgroundColor: getColumnStyle(columnIndex, 0, 3) }
        }
      }
      if(rowIndex == 0 && columnIndex == columnLength - 1){
        return { backgroundColor: '#A8EAE4' }
      }
      if(rowIndex == 0 && columnIndex >= start && Math.floor(columnIndex - start) % 2 == 0){
        return { backgroundColor: '#fbe1e5' }
      }
      if(rowIndex == 1 && Math.floor((columnIndex - cycleLength) / 8) % 2 == 0){
        return { backgroundColor: '#fbe1e5' }
      }
    }
    // 表格中的格子颜色
    const cellStyle = ({ columnIndex, rowIndex, column, row }) => {
      if(!tableData.value.length) return
      const cycleLength = cycleList.value.length * 3
      const start = columnLength + cycleLength;
      // 制程的背景色之一
      if(columnIndex >= columnLength && columnIndex < start){
        return { backgroundColor: getColumnStyle(columnIndex, columnLength, 3) }
      }
      // 制程的背景色之一
      if(columnIndex == columnLength - 1){
        return { backgroundColor: '#A8EAE4' }
      }
      // 工序的背景色
      if (columnIndex >= start) {
        const offset = columnIndex - start; 
        if (Math.floor(offset / 8) % 2 === 0) {
          return { backgroundColor: '#fbe1e5' };
        }
      }
    }
    // 制程的背景色之一
    const getColumnStyle = (columnNumber, startNumber, number) => {
      const offset = columnNumber - startNumber;
      const group = Math.floor(offset / number);
      return group % 2 === 0 ? '#C9E4B4' : '#A8EAE4';
    }
    // 头部的警告背景色
    const loadCellStyle = ({ row, column }) => {
      if (column.label && date_more.value.includes(column.label)) {
        const currentLoad = Number(row.dateData[column.label]);
        const maxLoad = Number(row.maxLoad);
        if (currentLoad > maxLoad) {
          return { 
            backgroundColor: '#ff4d4f', 
            color: '#fff',
            fontWeight: 'bold'
          };
        }
      }
    }
    
    return() => (
      <>
        <ElCard>
          {{
            header: () => {
              return cycleList.value.length ? <ElTable data={cycleList.value} border ref={ formCard } style={{ width: "100%" }} size="small" cellStyle={ loadCellStyle }>
                <ElTableColumn prop="name" label="制程" width="100" align="center" />
                <ElTableColumn prop="maxLoad" label="极限负荷" width="90" align="center" />
                { date_more.value.map(date => (
                  <ElTableColumn label={ date } width="90" align="center">
                    {{
                      default: ({ row }) => {
                        return row.dateData[date]
                      }
                    }}
                  </ElTableColumn>
                )) }
              </ElTable> : ''
            },
            default: () => (
              <>
                <ElTable class="production" data={ tableData.value } border stripe height={ `calc(100vh - ${formHeight.value + 224}px)` } style={{ width: "100%", height: '400px' }} headerCellStyle={ headerCellStyle } cellStyle={ cellStyle }>
                  <ElTableColumn label="生产订单号" width="120">
                    { ({row}) => <div class="myCell">{row.notice.notice}</div> }
                  </ElTableColumn>
                  <ElTableColumn label="客户名称" width="120">
                    { ({row}) => <div class="myCell">{row.sale.customer.customer_abbreviation}</div> }
                  </ElTableColumn>
                  <ElTableColumn label="客户订单号" width="120">
                    { ({row}) => <div class="myCell">{row.sale.customer_order}</div> }
                  </ElTableColumn>
                  <ElTableColumn label="接单日期" width="110">
                    { ({row}) => <div class="myCell">{row.sale.rece_time}</div> }
                  </ElTableColumn>
                  <ElTableColumn label="产品编码" width="120">
                    { ({row}) => <div class="myCell">{row.product_code}</div> }
                  </ElTableColumn>
                  <ElTableColumn label="产品名称" width="100">
                    { ({row}) => <div class="myCell">{row.product_name}</div> }
                  </ElTableColumn>
                  <ElTableColumn label="工程图号" width="100">
                    { ({row}) => <div class="myCell">{row.drawing}</div> }
                  </ElTableColumn>
                  <ElTableColumn label="生产特别要求" width="170">
                    { ({row}) => <div class="myCell">{row.remarks}</div> }
                  </ElTableColumn>
                  <ElTableColumn label="订单数量" width="100">
                    { ({row}) => <div class="myCell">{row.sale.order_number}</div> }
                  </ElTableColumn>
                  <ElTableColumn label="委外/库存数量" width="100">
                    { ({row}) => (
                      <div class="myCell">
                        <ElInput v-model={ row.house_number } type="number" placeholder="请输入" onBlur={ () => houseBlur(row) } />
                      </div>
                    ) }
                  </ElTableColumn>
                  <ElTableColumn label="生产数量" width="100">
                    { ({row}) => <div class="myCell">{row.out_number}</div> }
                  </ElTableColumn>
                  <ElTableColumn label="客户交期" width="110">
                    { ({row}) => <div class="myCell">{row.notice.delivery_time}</div> }
                  </ElTableColumn>
                  <ElTableColumn label="部件编码" width="110">
                    { ({row}) => <div class="myCell">{row.part_code}</div> }
                  </ElTableColumn>
                  <ElTableColumn label="部件名称" width="110">
                    { ({row}) => <div class="myCell">{row.part_name}</div> }
                  </ElTableColumn>
                  <ElTableColumn label="预计生产起始时间" width="170">
                    {({row}) => <div class="myCell"><ElDatePicker v-model={ row.start_date } clearable={ false } value-format="YYYY-MM-DD" type="date" placeholder="选择日期" style="width: 140px" onBlur={ (value) => dateChange(value, row) }></ElDatePicker></div>}
                  </ElTableColumn>
                  { cycleList.value.map((e, index) => (
                    <>
                      <ElTableColumn label={ e.name } width="90" align="center">
                        <ElTableColumn label="预排交期" width="130" align="center">
                          {{
                            default: ({ row, $index }) => {
                              const data = e.cycle[$index]
                              const isOverdue = data.end_date && dayjs(data.end_date).isBefore(dayjs().startOf('day')) && Number(data.load || 0) > 0;

                              return (
                                <div class="myCell" style={{ backgroundColor: isOverdue ? '#ff4d4f' : '', color: isOverdue ? '#fff' : '' }}>
                                  <ElDatePicker v-model={ data.end_date } clearable={ false } value-format="YYYY-MM-DD" type="date" placeholder="选择日期" style="width: 100px" onBlur={ (value) => paiChange(value, data, row) }></ElDatePicker>
                                </div>
                              )
                            }
                          }}
                        </ElTableColumn>
                      </ElTableColumn>
                      <ElTableColumn label="最短周期" width="90" align="center">
                        <ElTableColumn label="制程日总负荷" width="90" align="center">
                          {{
                            default: ({ row, $index }) => {
                              return <div class='myCell'>{ e.cycle[$index].load }</div>
                            }
                          }}
                        </ElTableColumn>
                      </ElTableColumn>
                      <ElTableColumn width="90" align="center">
                        {{
                          header: () => {
                            return <ElInput v-model={ e.sort_date } style="width: 70px" onBlur={ () => sortDateBlur(e) } />
                          },
                          default: () => <ElTableColumn label="完成数量" width="100" align="center" />
                        }}
                      </ElTableColumn>
                    </>
                  )) }
                  { Array.from({ length: maxBomLength.value }).map((_, index) => (
                    <ElTableColumn label={`工序-${index + 1}`} key={index} align="center">
                      <ElTableColumn label="工艺编码">
                        {({row}) => {
                          const data = row.items[index] ? row.items[index].children.process.process_code: ''
                          return <div class="myCell">{ data }</div>
                        }}
                      </ElTableColumn>
                      <ElTableColumn label="工艺名称">
                        {({row}) => {
                          const data = row.items[index] ? row.items[index].children.process.process_name: ''
                          return <div class="myCell">{ data }</div>
                        }}
                      </ElTableColumn>
                      <ElTableColumn label="设备名称">
                        {({row}) => {
                          const data = row.items[index] ? row.items[index].children.equipment.equipment_name: ''
                          return <div class="myCell">{ data }</div>
                        }}
                      </ElTableColumn>
                      <ElTableColumn label="生产制程">
                        {({row}) => {
                          const data = row.items[index] ? row.items[index].children.equipment.cycle.name: ''
                          return <div class="myCell">{ data }</div>
                        }}
                      </ElTableColumn>
                      <ElTableColumn label="全部工时(H)">
                        {({row}) => {
                          const data = row.items[index] ? row.items[index].all_work_time: ''
                          return <div class="myCell">{ data }</div>
                        }}
                      </ElTableColumn>
                      <ElTableColumn label="每日负荷(H)">
                        {({row}) => {
                          const data = row.items[index] ? row.items[index].load: ''
                          return <div class="myCell">{ data }</div>
                        }}
                      </ElTableColumn>
                      <ElTableColumn label="累计完成">
                        {({row}) => {
                          const data = row.items[index] ? row.items[index].finish: ''
                          return <div class="myCell">{ data }</div>
                        }}
                      </ElTableColumn>
                      <ElTableColumn label="订单尾数">
                        {({row}) => {
                          const data = row.items[index] ? row.items[index].order_number: ''
                          return <div class="myCell">{ data }</div>
                        }}
                      </ElTableColumn>
                    </ElTableColumn>
                  )) }
                </ElTable>
              </>
            )
          }}
        </ElCard>
      </>
    )
  }
})