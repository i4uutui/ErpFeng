import { computed, defineComponent, markRaw, nextTick, onMounted, ref, shallowRef } from 'vue'
import { VxeTable, VxeColumn, VxeColgroup } from 'vxe-table'
import request from '@/utils/request';
import deepClone from '@/utils/deepClone';
import "@/assets/css/production.scss"
import { getPageHeight, isEmptyValue } from '@/utils/tool';
import dayjs from 'dayjs';

export default defineComponent({
  setup(){
    const cardRef = ref(null)
    const formCard = ref(null)
    const formHeight = ref(0);
    let tableData = shallowRef([])
    let cycleList = shallowRef([])
    let date_more = ref([])
    let temCycleList = ref([]) // 这个制程的数据是临时存的,用来修改预排交期时,做比对
    let specialDates = ref(new Set());
    let loading = ref(false)

    // 查询tableData下的工序长度，确定表格中的工序显示的数量
    const maxBomLength = computed(() => {
      const data = tableData.value;
      if (data.length === 0) return 0;
      let max = 0;
      for (let i = 0; i < data.length; i++) {
        const len = data[i].items?.length || 0;
        if (len > max) max = len;
      }
      return max;
    });

    onMounted(async () => {
      await getProgressBase();
    })

    const getProgressBase = async () => {
      loading.value = true
      try {
        const res = await request.get('/api/get_progress_base');
        if(res.code == 200){
          tableData.value = markRaw(res.data);
          if(res.data.length){
            const base = res.data.map(item => ({
              id: item.id,
              start_date: item.start_date,
              delivery_time: item.notice?.delivery_time || ''
            }))
            await getProgressCycle(base)
          }else{
            loading.value = false
          }
        }
      } catch (error) {
        ElMessage.error('获取基础数据失败');
      } finally {
        if (!tableData.value.length) loading.value = false;
      }
    }
    const getProgressCycle = async (base) => {
      const jsonStr = JSON.stringify(base)
      try {
        const res = await request.post('/api/get_progress_cycle', { base: jsonStr })
        if(res.code == 200){
          loading.value = false
          const { cycles, works, date_more: dateMore } = res.data;
          date_more.value = dateMore;

          temCycleList.value = deepClone(cycles); // 保留原逻辑但确保深拷贝函数高效
          const groupedData = Object.create(null);
          for (let i = 0; i < works.length; i++) {
            const item = works[i];
            const key = item.progress_id;
            if (!groupedData[key]) {
              groupedData[key] = [];
            }
            groupedData[key].push(item);
          }

          // 提前提取排序字段，减少属性访问
          Object.keys(groupedData).forEach(key => {
            const list = groupedData[key];
            list.sort((a, b) => {
              // 缓存排序字段
              const aIdx = a.children.process_index;
              const bIdx = b.children.process_index;
              return aIdx - bIdx;
            });
          });

          const newTableData = [];
          const rawTableData = tableData.value;
          for (let i = 0; i < rawTableData.length; i++) {
            const tableItem = rawTableData[i];
            // 直接构造新对象
            newTableData.push({
              id: tableItem.id,
              notice_id: tableItem.notice_id,
              sale_id: tableItem.sale_id,
              notice: tableItem.notice,
              sale: tableItem.sale,
              product_code: tableItem.product_code,
              product_name: tableItem.product_name,
              drawing: tableItem.drawing,
              remarks: tableItem.remarks,
              house_number: tableItem.house_number,
              out_number: tableItem.out_number,
              part_code: tableItem.part_code,
              part_name: tableItem.part_name,
              start_date: tableItem.start_date,
              // 只保留必要字段
              items: groupedData[tableItem.id] || []
            });
          }
          tableData.value = markRaw(newTableData);

          cycleList.value = markRaw(cycles.map(cycle => ({
            ...cycle,
            // 扁平化嵌套属性，方便表格渲染时访问
            maxLoad: cycle.equipment.reduce((total, eq) => {
              return total + (Number(eq.efficiency) || 0);
            }, 0)
          })));

          nextTick(async () => {
            const h = await getPageHeight([formCard.value]);
            const cardH = await getPageHeight([cardRef.value])
            formHeight.value = cardH - h - 80
          }),
          fetchSpecialDates()
        }else{
          loading.value = false
        }
      } catch (error) {
        loading.value = false
      }
    }
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
    // 获取特殊日期
    const fetchSpecialDates = async () => {
      const res = await request.get('/api/special-dates');
      if (res.data && Array.isArray(res.data)) {
        // 将特殊日期存储在Set中，便于快速查找
        specialDates.value = new Set(res.data.map(item => item.date));
      }
    }
    // 批量更新起始生产时间/预排交期
    const set_production_date = async (params, type) => {
      const res = await request.put('/api/set_production_date', { params, type });
      if(res && res.code == 200){
        ElMessage.success('修改成功');
        getProgressBase();
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
    // 检查日期是否为特殊日期
    const isSpecialDate = (date) => {
      if (!date) return false;
      return specialDates.value.has(dayjs(date).format('YYYY-MM-DD'));
    };
    // 选择预排交期的时间
    const paiChange = (value, row, param, colIndex, rowIndex) => {
      // 原始的预排交期
      const oldTime = temCycleList.value[colIndex].cycle[rowIndex].end_date
      // 用户所选日期
      const time = row.end_date
      if(!param.start_date) {
        ElMessage.error('起始生产日期不能为空')
        row.end_date = ''
        return
      }
      // 检查是否是特殊日期
      if (isSpecialDate(time)) {
        ElMessage.warning('请注意，你所选择的日期为节假日');
      }
      if(dayjs(time).isAfter(dayjs(param.notice.delivery_time))){
        ElMessage.error('所选日期不能比客户交期还要晚')
        row.end_date = oldTime ? oldTime : ''
        return
      }
      if(dayjs(time).isBefore(dayjs(param.start_date))){
        ElMessage.error('所选日期不能早于起始生产日期')
        row.end_date = oldTime ? oldTime : ''
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
    // 头部的警告背景色
    const headerCellStyle = ({ row, column, rowIndex, columnIndex }) => {
      if (column.title && date_more.value.includes(column.title)) {
        const currentLoad = row.dateData[column.title].big
        if(currentLoad){
          return {
            backgroundColor: '#f1c40f',
            color: '#fff',
            fontWeight: 'bold'
          }
        }
      }
    }
    // 表格中的格子颜色
    const columnLength = 15 // 表示前面不需要颜色的列数
    const tableCellStyle = ({ columnIndex, $columnIndex, rowIndex, $rowIndex, column, row }) => {
      // if(column.title == '制程日总负荷'){
      //   console.log(column);
      //   console.log(row);
      // }
      // console.log(columnIndex, $columnIndex, rowIndex, $rowIndex, column.title);
      // if(!tableData.value.length) return
      // const cycleLength = cycleList.value.length * 3
      // const start = columnLength + cycleLength;
      // if(column.title == '预排交期' || column.title == '制程日总负荷' || column.title == '完成数量'){
      //   console.log(columnIndex, $columnIndex, rowIndex, $rowIndex, column.title);
      // }
      // if($columnIndex == 1 && rowIndex == 0){
      //   console.log(columnIndex, $columnIndex, rowIndex, $rowIndex, column.title);
      // }
      // 制程的背景色之一
      // if($columnIndex >= columnLength && $columnIndex < start){
        
      //   return { backgroundColor: getColumnStyle($columnIndex, columnLength, 3) }
      // }
      // 起始生产时间的背景色之一
      // if(columnIndex == columnLength - 1){
      //   return { backgroundColor: 'rgba(168, 234, 228, .3)' }
      // }
      // 工序的背景色
      // if (columnIndex >= start) {
      //   const offset = columnIndex - start; 
      //   if (Math.floor(offset / 8) % 2 === 0) {
      //     return { backgroundColor: '#fbe1e5' };
      //   }
      // }
    }
    // 表格中的表头的颜色
    const tableHeaderCellStyle = ({ $rowIndex, column, columnIndex, $columnIndex }) => {
      if(!tableData.value.length) return
      const cycleLength = cycleList.value.length * 3
      const start = columnLength + cycleLength;
      if($rowIndex == 1){
        if($columnIndex < cycleLength){
          if(!(columnIndex == 0 && Math.floor($columnIndex / 3) % 2 === 0)){
            return { backgroundColor: 'rgba(168, 234, 228, .3)' }
          }
        }else{
          if(Math.floor(($columnIndex - cycleLength) / 8) % 2 === 0){
            return { backgroundColor: '#fbe1e5' }
          }
        }
      }
      if($rowIndex == 0){
        if(columnIndex >= columnLength && columnIndex < start){
          return { backgroundColor: getColumnStyle(columnIndex, columnLength, 3) }
        }
        if(columnIndex == columnLength - 1){
          return { backgroundColor: 'rgba(168, 234, 228, .3)' }
        }
        if(columnIndex >= start && Math.floor(columnIndex - start) % 2 == 0){
          return { backgroundColor: '#fbe1e5' }
        }
      }
    }
    // 制程的背景色之一
    const getColumnStyle = (columnNumber, startNumber, number) => {
      const offset = columnNumber - startNumber;
      const group = Math.floor(offset / number);
      return group % 2 === 0 ? '' : 'rgba(168, 234, 228, .3)';
    }

    return () => (
      <>
        <ElCard style={{ height: 'calc(100vh - 154px)' }} ref={ cardRef } v-loading={ loading.value }>
          {{
            header: () => {
              return <VxeTable ref={ formCard } data={ cycleList.value } class="production" align="center" size="mini" border show-overflow keep-source show-header-overflow show-footer-overflow header-cell-config={{ height: 32 }} cell-config={{ height: 32 }} virtual-x-config={{ enabled: true, gt: 0 }} cell-style={ (scope) => headerCellStyle(scope) }>
                <VxeColumn field="name" title="制程" width="90"></VxeColumn>
                <VxeColumn field="maxLoad" title="极限负荷" width="90"></VxeColumn>
                { date_more.value.map(date => (
                  <VxeColumn title={ date } width="90" align="center">
                    {{
                      default: ({ row }) => {
                        const value = row.dateData[date].maxLong;
                        if(value == '休') return <span style={{ color: 'red' }}>{ value }</span>
                        if(value == '-') return '-'
                        return Number(value).toFixed(1)
                      }
                    }}
                  </VxeColumn>
                )) }
              </VxeTable>
            },
            default: () => (
              <>
                { formHeight.value ?
                  <VxeTable data={ tableData.value } class="production" border show-overflow keep-source align="center" header-align="center" size="small" show-header-overflow show-footer-overflow header-cell-config={{ height: 32 }} cell-config={{ height: 42, verticalAlign: 'center' }} virtual-y-config={{ enabled: true, gt: 0 }} virtual-x-config={{ enabled: true, gt: 0, immediate: true }} height={ formHeight.value } headerCellStyle={ (scope) => tableHeaderCellStyle(scope) } cell-style={ (scope) => tableCellStyle(scope) }>
                    <VxeColumn field="notice.notice" title="生产订单号" width="120"></VxeColumn>
                    <VxeColumn field="sale.customer.customer_abbreviation" title="客户名称" width="120"></VxeColumn>
                    <VxeColumn field="sale.customer_order" title="客户订单号" width="120"></VxeColumn>
                    <VxeColumn field="sale.rece_time" title="接单日期" width="110"></VxeColumn>
                    <VxeColumn field="product_code" title="产品编码" width="120"></VxeColumn>
                    <VxeColumn field="product_name" title="产品名称" width="100"></VxeColumn>
                    <VxeColumn field="drawing" title="工程图号" width="100"></VxeColumn>
                    <VxeColumn field="remarks" title="生产特别要求" width="170"></VxeColumn>
                    <VxeColumn field="sale.order_number" title="订单数量" width="100"></VxeColumn>
                    <VxeColumn title="委外/库存数量" width="100">
                      {{
                        default: ({ row, rowIndex }) => <ElInput v-model={ row.house_number } type="number" placeholder="请输入" onBlur={ () => houseBlur(row) } />
                      }}
                    </VxeColumn>
                    <VxeColumn field="out_number" title="生产数量" width="100"></VxeColumn>
                    <VxeColumn field="notice.delivery_time" title="客户交期" width="110"></VxeColumn>
                    <VxeColumn field="part_code" title="部件编码" width="110"></VxeColumn>
                    <VxeColumn field="part_name" title="部件名称" width="110"></VxeColumn>
                    <VxeColumn title="预计生产起始时间" width="170">
                      {{
                        default: ({ row }) => <ElDatePicker v-model={ row.start_date } clearable={ false } value-format="YYYY-MM-DD" type="date" placeholder="选择日期" style="width: 140px" onBlur={ (value) => dateChange(value, row) }></ElDatePicker>
                      }}
                    </VxeColumn>
                    {cycleList.value.map((e, index) => (
                      <>
                        <VxeColgroup title={ e.name }>
                          <VxeColumn title="预排交期" width="120">
                            {{
                              default: ({ row, rowIndex }) => {
                                if(!isEmptyValue(row)){
                                  const data = ref(e.cycle[rowIndex])
                                  const dateObj = e.dateData[data.end_date]
                                  return (
                                    <ElDatePicker v-model={ data.value.end_date } clearable={ false } value-format="YYYY-MM-DD" type="date" placeholder="选择日期" style="width: 100px" onBlur={ (value) => paiChange(value, data.value, row, index, rowIndex) }></ElDatePicker>
                                  )
                                }
                              }
                            }}
                          </VxeColumn>
                        </VxeColgroup>
                        <VxeColgroup title='最短周期'>
                          <VxeColumn title="制程日总负荷" width="120" class-name={({ rowIndex }) => {
                            const data = e.cycle[rowIndex]
                            const dateObj = e.dateData[data.end_date]
                            if(data.load != undefined && data.load != null && data.load > 0){
                              return dateObj?.big ? 'orange': ''
                            }
                            if(data.load == 0){
                              return 'green'
                            }
                          }}>
                            {{
                              default: ({ row, rowIndex }) => {
                                if(!isEmptyValue(row)){
                                  const data = e.cycle[rowIndex]
                                  return data.load
                                }
                              }
                            }}
                          </VxeColumn>
                        </VxeColgroup>
                        <VxeColgroup>
                          {{
                            header: () => <ElInput v-model={ e.sort_date } style="width: 70px" onBlur={ () => sortDateBlur(e) } />,
                            default: () => <VxeColumn title="完成数量" width="120" />
                          }}
                        </VxeColgroup>
                      </>
                    ))}
                    {Array.from({ length: maxBomLength.value }).map((_, index) => (
                      <VxeColgroup title={ `工序-${index + 1}` }>
                        <VxeColumn title="工艺编码" width="100">
                          {({row}) => {
                            const data = row.items[index] ? row.items[index].children.process.process_code: ''
                            return <div class="myCell">{ data }</div>
                          }}
                        </VxeColumn>
                        <VxeColumn title="工艺名称" width="100">
                          {({row}) => {
                            const data = row.items[index] ? row.items[index].children.process.process_name: ''
                            return <div class="myCell">{ data }</div>
                          }}
                        </VxeColumn>
                        <VxeColumn title="设备名称" width="100">
                          {({row}) => {
                            const data = row.items[index] ? row.items[index].children.equipment.equipment_name: ''
                            return <div class="myCell">{ data }</div>
                          }}
                        </VxeColumn>
                        <VxeColumn title="生产制程" width="100">
                          {({row}) => {
                            const data = row.items[index] ? row.items[index].children.equipment.cycle.name: ''
                            return <div class="myCell">{ data }</div>
                          }}
                        </VxeColumn>
                        <VxeColumn title="全部工时(H)" width="100">
                          {({row}) => {
                            const data = row.items[index] ? row.items[index].all_work_time: ''
                            return <div class="myCell">{ data }</div>
                          }}
                        </VxeColumn>
                        <VxeColumn title="每日负荷(H)" width="100">
                          {({row}) => {
                            const data = row.items[index] ? row.items[index].load: ''
                            return <div class="myCell">{ data }</div>
                          }}
                        </VxeColumn>
                        <VxeColumn title="累计完成" width="100">
                          {({row}) => {
                            const data = row.items[index] ? row.items[index].finish: ''
                            return <div class="myCell">{ data }</div>
                          }}
                        </VxeColumn>
                        <VxeColumn title="订单尾数" width="100">
                          {({row}) => {
                            const data = row.items[index] ? row.items[index].order_number: ''
                            return <div class="myCell">{ data }</div>
                          }}
                        </VxeColumn>
                      </VxeColgroup>
                    ))}
                  </VxeTable> : ''
                }
              </>
            )
          }}
        </ElCard>
      </>
    )
  }
})