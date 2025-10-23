import { defineComponent, onMounted, ref, reactive, computed } from 'vue'
import dayjs from 'dayjs';
import request from '@/utils/request';
import "@/assets/css/production.scss"

export default defineComponent({
  props: {
    notice: {
      type: String,
      default: ''
    }
  },
  setup(props){
    let tableData = ref([])
    let endDate = ref('')
    let uniqueEquipments = ref([])
    
    const maxBomLength = computed(() => {
      if (tableData.value.length === 0) return 0;
      return Math.max(...tableData.value.map(item => item.bom?.children?.length || 0));
    });
    // 计算负荷统计数据
    const loadStats = computed(() => {
      if (!tableData.value.length) return { stats: [], dates: [] };
      
      // 收集所有唯一制程
      const cycleMap = new Map();
      tableData.value.forEach(item => {
        item.cycleChild.forEach(cycleChild => {
          const { id, name } = cycleChild.cycle;
          if (!cycleMap.has(id)) {
            cycleMap.set(id, {
              id,
              name,
              maxLoad: 0, // 极限负荷
              dateData: {} // 日期数据
            });
          }
        });
      });
      // 计算极限负荷
      const equipmentMap = new Map(); // 去重
      tableData.value.forEach(item => {
        item.bom?.children?.forEach(child => {
          const { equipment } = child;
          if (equipment && equipment.id) {
            const key = `${equipment.id}`;
            if (!equipmentMap.has(key)) {
              equipmentMap.set(key, true);
              const cycleData = cycleMap.get(equipment.cycle.id);
              if (cycleData) {
                cycleData.maxLoad += Number(equipment.efficiency || 0);
              }
            }
          }
        });
      });

      // 生成日期列表
      const today = dayjs().startOf('day');
      const end = dayjs(endDate.value).startOf('day');
      const dateList = [];
      
      if (today.isAfter(end)) {
        dateList.push(end.format('YYYY-MM-DD'));
      } else {
        let current = today;
        while (current.isSameOrBefore(end)) {
          dateList.push(current.format('YYYY-MM-DD'));
          current = current.add(1, 'day');
        }
      }

      // 初始化日期数据
      cycleMap.forEach(data => {
        dateList.forEach(date => {
          data.dateData[date] = 0;
        });
      });

      // 计算日期对应的负荷数据
      dateList.forEach(targetDate => {
        tableData.value.forEach(item => {
          // 获取当前行的生产起始日期
          const startDate = dayjs(item.start_date).startOf('day');
          if (!startDate.isValid()) return; // 跳过无效的起始日期
          
          item.cycleChild.forEach(cycleChild => {
            const cycleData = cycleMap.get(cycleChild.cycle.id);
            if (!cycleData) return;
            const endDate = dayjs(cycleChild.end_date).startOf('day');
            if (!endDate.isValid()) return; // 跳过无效的结束日期
            
            // 转换目标日期为dayjs对象
            const currentDate = dayjs(targetDate).startOf('day');
            
            // 仅当目标日期在start_date和end_date之间（包含首尾）时才累加负荷
            if (currentDate.isSameOrAfter(startDate) && currentDate.isSameOrBefore(endDate)) {
              cycleData.dateData[targetDate] += Number(cycleChild.load);
            }
          });
        });
      });

      // 格式化结果
      return {
        stats: Array.from(cycleMap.values()).map(stat => ({
          ...stat,
          maxLoad: stat.maxLoad.toFixed(1) // 保留一位小数
        })),
        dates: dateList
      };
    });
    
    onMounted(async () => {
      await fetchProductList()
    })
    
    // 获取列表
    const fetchProductList = async () => {
      const res = await request.get('/api/production_progress', {
        params: {
          notice: props.notice
        }
      });
      tableData.value = res.data;
      endDate.value = tableData.value[0].delivery_time
      // 集合equipment并且去重
      uniqueEquipments.value = [...res.data
        .flatMap(item => item?.bom?.children ?? [])
        .map(child => child.equipment)
        .filter(Boolean)
        .reduce((map, equip) => map.set(equip.id, equip), new Map())
        .values()
      ];
    };
    // 更新制程组的最短交货时间
    const sortDateBlur = async ({ id, sort_date }) => {
      const params = {
        id,
        sort_date
      }
      await request.put('/api/process_cycle', params);
      fetchProductList();
    }
    // 批量更新起始生产时间
    const set_production_date = async (params, type) => {
      const res = await request.put('/api/set_production_date', { params, type });
      if(res && res.code == 200){
        ElMessage.success('修改成功');
        fetchProductList();
      }
    }
    // 选择生产起始时间
    const dateChange = async (value, row) => {
      const time = row.start_date
      ElMessageBox.confirm('是否同步更新相同订单的生产起始日期？', '提示', {
        confirmButtonText: '同步更新',
        cancelButtonText: '不同步',
        type: 'warning',
        closeOnClickModal: false,
        closeOnPressEscape: false,
        distinguishCancelAndClose: true
      }).then(() => {
        const table  = tableData.value.filter(e => e.notice_number == row.notice_number)
        let params = []
        table.forEach(e => {
          params.push({
            id: e.id,
            start_date: time
          })
        })
        set_production_date(params, 'start_date')
      }).catch((action) => {
        if(action == 'close') return
        const params = [{ id: row.id, start_date: time }]
        set_production_date(params, 'start_date')
      })
    }
    const paiChange = (value, row, param) => {
      if(param.start_date == null) {
        ElMessage.error('请先选择起始生产日期')
        row.end_date = ''
        return
      }
      const time = row.end_date
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
        let arr = []
        tableData.value.forEach(e => {
          if(e.notice_number == param.notice_number){
            e.cycleChild.forEach(o => {
              if(o.cycle.id == row.cycle.id){
                arr.push(o)
              }
            })
            return arr
          }
        })
        
        let params = []
        arr.forEach(e => {
          params.push({
            id: e.id,
            end_date: time
          })
        })
        set_production_date(params, 'end_date')
      }).catch((action) => {
        if(action == 'close') return
        const params = [{ id: row.id, end_date: time }]
        set_production_date(params, 'end_date')
      })
    }
    const columnLength = 15 // 表示前面不需要颜色的列数
    const headerCellStyle = ({ rowIndex, columnIndex, column, row }) => {
      if(!tableData.value.length) return
      let cycleLength = tableData.value[0].cycleChild.length * 3
      if(rowIndex == 1 && columnIndex >= 0 && columnIndex < cycleLength || rowIndex == 0 && columnIndex >= columnLength && columnIndex < columnLength + cycleLength){
        if(rowIndex == 0){
          return { backgroundColor: getColumnStyle(columnIndex, columnLength, 3) }
        }else{
          return { backgroundColor: getColumnStyle(columnIndex, 0, 3) }
        }
      }
      if(rowIndex == 0 && columnIndex == columnLength - 1){
        return { backgroundColor: '#A8EAE4' }
      }
      if(rowIndex == 0 && columnIndex >= columnLength + cycleLength && columnIndex <= row.length - 1 && columnIndex % 2 == 1 || rowIndex == 1 && Math.floor((columnIndex - 1) / 8) % 2 == 0){
        return { backgroundColor: '#fbe1e5' }
      }
    }
    const cellStyle = ({ columnIndex, rowIndex, column, row }) => {
      if(!tableData.value.length) return
      let cycleLength = tableData.value[0].cycleChild.length * 3
      if(columnIndex >= columnLength && columnIndex < columnLength + cycleLength){
        return { backgroundColor: getColumnStyle(columnIndex, columnLength, 3) }
      }
      if(columnIndex == columnLength - 1){
        return { backgroundColor: '#A8EAE4' }
      }
      if(columnIndex >= columnLength + cycleLength && Math.floor((columnIndex) / 8) % 2 == 0){
        return { backgroundColor: '#fbe1e5' }
      }
    }
    const loadCellStyle = ({ row, column }) => {
      if (column.label && loadStats.value.dates.includes(column.label)) {
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
    const getColumnStyle = (columnNumber, startNumber, number) => {
      const offset = columnNumber - startNumber;
      const group = Math.floor(offset / number);
      return group % 2 === 0 ? '#C9E4B4' : '#A8EAE4';
    }
    const getCycleChildren = () => {
      return tableData.value[0]?.cycleChild || [];
    };
    const getCycleItem = (row, index) => {
      return row.cycleChild[index] || {};
    };
    const getLoadCellStyle = (row, cycle) => {
      const data = loadStats.value.stats.find(e => e.id == cycle.cycle_id)
      const maxLoad = Number(data.maxLoad)
      if(maxLoad && row.start_date && cycle.end_date){
        const dateData = {}
        for(const key in data.dateData){
          const value = data.dateData[key]
          if(value > Number(data.maxLoad)){
            dateData[key] = data.dateData[key]
          }
        }
        if(row.start_date && cycle.end_date && dateData[row.start_date] && dateData[cycle.end_date] && cycle.load){
          return {
            backgroundColor: 'red',
            color: '#FFFFFF'
          }
        }
      }
    };
    return() => (
      <>
        <ElCard>
          {{
            header: () => {
              if(loadStats.value?.dates?.length && loadStats.value?.stats?.length){
                return <ElTable data={loadStats.value.stats} border style={{ width: "100%" }} size="small" cellStyle={ loadCellStyle }>
                  <ElTableColumn prop="name" label="制程" width="100" align="center" />
                  <ElTableColumn label="极限负荷" width="90" align="center" >
                    {{
                      default: ({ row }) => row.maxLoad
                    }}
                  </ElTableColumn>
                  {loadStats.value.dates.map(date => (
                    <ElTableColumn key={date} label={date} width="90" align="center" >
                      {{
                        default: ({ row }) => {
                          const value = row.dateData[date];
                          return value === 0 ? '-' : value.toFixed(1);
                        }
                      }}
                    </ElTableColumn>
                  ))}
                </ElTable>
              }
            },
            default: () => (
              <>
                <ElTable data={ tableData.value } border stripe style={{ width: "100%", height: '400px' }} headerCellStyle={ headerCellStyle } cellStyle={ cellStyle } class="production">
                  <ElTableColumn label="生产订单号" width="100">
                    { ({row}) => <div class="myCell">{row.notice_number}</div> }
                  </ElTableColumn>
                  <ElTableColumn label="客户名称" width="120">
                    { ({row}) => <div class="myCell">{row.customer_abbreviation}</div> }
                  </ElTableColumn>
                  <ElTableColumn label="客户订单号" width="120">
                    { ({row}) => <div class="myCell">{row.customer_order}</div> }
                  </ElTableColumn>
                  <ElTableColumn label="接单日期" width="110">
                    { ({row}) => <div class="myCell">{row.rece_time}</div> }
                  </ElTableColumn>
                  <ElTableColumn label="产品编码" width="100">
                    { ({row}) => <div class="myCell">{row.product_code}</div> }
                  </ElTableColumn>
                  <ElTableColumn label="产品名称" width="100">
                    { ({row}) => <div class="myCell">{row.product_name}</div> }
                  </ElTableColumn>
                  <ElTableColumn label="工程图号" width="100">
                    { ({row}) => <div class="myCell">{row.product_drawing}</div> }
                  </ElTableColumn>
                  <ElTableColumn label="生产特别要求" width="170">
                    { ({row}) => <div class="myCell">{row.remarks}</div> }
                  </ElTableColumn>
                  <ElTableColumn label="订单数量" width="100">
                    { ({row}) => <div class="myCell">{row.out_number}</div> }
                  </ElTableColumn>
                  <ElTableColumn label="委外/库存数量" width="100">
                    { ({row}) => <div class="myCell"></div> }
                  </ElTableColumn>
                  <ElTableColumn label="生产数量" width="100">
                    { ({row}) => <div class="myCell">{row.out_number}</div> }
                  </ElTableColumn>
                  <ElTableColumn label="客户交期" width="110">
                    { ({row}) => <div class="myCell">{row.delivery_time}</div> }
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
                  {getCycleChildren().map((cycle, index) => (
                    <>
                      <ElTableColumn label={ cycle.cycle.name } width="90" align="center">
                        <ElTableColumn label="预排交期" width="130" align="center">
                          {{
                            default: ({ row }) => {
                              const cycleData = getCycleItem(row, index);
                              const isOverdue = cycleData.end_date && dayjs(cycleData.end_date).isBefore(dayjs().startOf('day')) && Number(cycleData.load || 0) > 0;

                              return (
                                <div class="myCell" style={{ backgroundColor: isOverdue ? '#ff4d4f' : '', color: isOverdue ? '#fff' : '' }}>
                                  <ElDatePicker v-model={ cycleData.end_date } clearable={ false } value-format="YYYY-MM-DD" type="date" placeholder="选择日期" style="width: 100px" onBlur={ (value) => paiChange(value, cycleData, row) }></ElDatePicker>
                                </div>
                              )
                            }
                          }}
                        </ElTableColumn>
                      </ElTableColumn>
                      <ElTableColumn label="最短周期" width="90" align="center">
                        <ElTableColumn label="制程日总负荷" width="90" align="center">
                          {{
                            default: ({ row }) => {
                              const cycleData = getCycleItem(row, index);
                              return <div class='myCell' style={ getLoadCellStyle(row, cycleData) }>{ cycleData.load }</div>
                            }
                          }}
                        </ElTableColumn>
                      </ElTableColumn>
                      <ElTableColumn width="90" align="center">
                        {{
                          header: () => {
                            return <ElInput v-model={ cycle.cycle.sort_date } style="width: 70px" onBlur={ () => sortDateBlur(cycle.cycle) } />
                          },
                          default: () => <ElTableColumn label="完成数量" width="100" align="center" />
                        }}
                      </ElTableColumn>
                    </>
                  ))}
                  {
                    Array.from({ length: maxBomLength.value }).map((_, index) => (
                      <ElTableColumn label={`工序-${index + 1}`} key={index} align="center">
                        <ElTableColumn label="工艺编码">
                          {({row}) => {
                            const data = row.bom.children[index] ? row.bom.children[index].process.process_code: ''
                            return <div class="myCell">{ data }</div>
                          }}
                        </ElTableColumn>
                        <ElTableColumn label="工艺名称">
                          {({row}) => {
                            const data = row.bom.children[index] ? row.bom.children[index].process.process_name: ''
                            return <div class="myCell">{ data }</div>
                          }}
                        </ElTableColumn>
                        <ElTableColumn label="设备名称">
                          {({row}) => {
                            const data = row.bom.children[index] ? row.bom.children[index].equipment.equipment_name: ''
                            return <div class="myCell">{ data }</div>
                          }}
                        </ElTableColumn>
                        <ElTableColumn label="生产制程">
                          {({row}) => {
                            const data = row.bom.children[index] ? row.bom.children[index].equipment.cycle.name: ''
                            return <div class="myCell">{ data }</div>
                          }}
                        </ElTableColumn>
                        <ElTableColumn label="全部工时(H)">
                          {({row}) => {
                            const data = row.bom.children[index] ? row.bom.children[index].all_time: ''
                            return <div class="myCell">{ data }</div>
                          }}
                        </ElTableColumn>
                        <ElTableColumn label="每日负荷(H)">
                          {({row}) => {
                            const data = row.bom.children[index] ? row.bom.children[index].all_load: ''
                            return <div class="myCell">{ data }</div>
                          }}
                        </ElTableColumn>
                        <ElTableColumn label="累计完成">
                          {({row}) => {
                            const data = row.bom.children[index] ? row.bom.children[index].add_finish: ''
                            return <div class="myCell">{ data }</div>
                          }}
                        </ElTableColumn>
                        <ElTableColumn label="订单尾数">
                          {({row}) => {
                            const data = row.bom.children[index] ? row.bom.children[index].order_number: ''
                            return <div class="myCell">{ data }</div>
                          }}
                        </ElTableColumn>
                      </ElTableColumn>
                    ))
                  }
                </ElTable>
              </>
            )
          }}
        </ElCard>
      </>
    )
  }
})