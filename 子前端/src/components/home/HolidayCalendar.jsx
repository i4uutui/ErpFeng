import { defineComponent, ref, watch, onMounted } from 'vue';
import request from '@/utils/request'
import dayjs from 'dayjs';
import { getItem } from '@/assets/js/storage';

export default defineComponent({
  setup() {
    const user = getItem('user')
    const hasPermission = user.type === 1; // 判断用户是否有权限操作日历
    // 当前选中日期，初始化为Date对象
    const selectedDate = ref(new Date());
    // 年份和月份状态
    const selectedYear = ref(dayjs().year());
    const selectedMonth = ref(dayjs().month() + 1);
    // 定义选中的日期（格式：YYYY-MM-DD）
    const specialDates = ref([]);
    const loading = ref(false);

    onMounted(() => {
      // 初始化时从后端加载数据
      fetchSpecialDates();
    })
    
    // 监听年份或月份变化，自动更新日历
    watch([selectedYear, selectedMonth], () => {
      changeDate();
    });
    // 监听选中日期变化，同步更新年份和月份
    watch(selectedDate, (newDate) => {
      if (selectedYear.value !== dayjs(newDate).year()) {
        selectedYear.value = dayjs(newDate).year();
      }
      if (selectedMonth.value !== dayjs(newDate).month() + 1) {
        selectedMonth.value = dayjs(newDate).month() + 1;
      }
    });

    // 初始化：从后端获取已保存的特殊日期
    const fetchSpecialDates = async () => {
      const res = await request.get('/api/special-dates');
      if (res.data && Array.isArray(res.data)) {
        specialDates.value = res.data;
      }
    };
    // 将数据提交给后端
    const onHandleForm = async () => {
      // 仅提交date字段数组
      const datesToSubmit = specialDates.value.map(item => ({ date: item.date }));
      
      const res = await request.post('/api/special-dates', { dates: datesToSubmit });
      if (res.code == 200) {
        ElMessage.success('保存成功');
      } else {
        ElMessage.warning('保存失败，请联系管理员');
      }
    };
    // 生成年份选项（当前年份前后30年）
    const generateYears = () => {
      const currentYear = dayjs().year();
      return Array.from({ length: 61 }, (_, i) => currentYear - 30 + i);
    };
    // 生成月份选项
    const generateMonths = () => {
      return Array.from({ length: 12 }, (_, i) => i + 1);
    };
    // 年份和月份列表
    const years = generateYears();
    const months = generateMonths();
    // 切换日期
    const changeDate = () => {
      selectedDate.value = new Date(selectedYear.value, selectedMonth.value - 1, 1);
    };
    // 格式化日期为 YYYY-MM-DD 字符串
    const formatDate = (date) => {
      return dayjs(date).format('YYYY-MM-DD');
    };
    const handleDateClick = (dateString) => {
      if (!hasPermission) return

      const date = new Date(dateString);
      selectedDate.value = date;
      const formattedDate = formatDate(date);
      
      // 检查是否已为特殊日期
      const existingIndex = specialDates.value.findIndex(item => item.date === formattedDate);
      
      if (existingIndex > -1) {
        // 已存在则移除
        specialDates.value.splice(existingIndex, 1);
      } else {
        // 不存在则添加
        specialDates.value.push({ date: formattedDate });
      }
    };
    // 头部渲染函数
    const renderHeader = () => (
      <div style={{ display: 'flex', alignItems: 'center', gap: '12px', padding: '0 16px' }}>
        <div>年份：</div>
        <ElSelect v-model={selectedYear.value} placeholder="选择年份" style={{ width: '120px' }} >
          {years.map(year => ( <ElOption key={year} label={`${year}年`} value={year} /> ))}
        </ElSelect>
        <div style={{ paddingLeft: '10px' }}>月份：</div>
        <ElSelect v-model={selectedMonth.value} placeholder="选择月份" style={{ width: '100px' }} >
          {months.map(month => ( <ElOption key={month} label={`${month}月`} value={month} /> ))}
        </ElSelect>
        {hasPermission ? 
          <ElButton type="primary" style={{ marginLeft: '10px' }} loading={loading.value} onClick={() => onHandleForm()}>
            提交
          </ElButton> : ''
        }
        
      </div>
    );
    
    return () => (
      // 假期预排
      <ElCard shadow="always" bodyStyle={{ width: '100%', height: '500px' }}>
        <ElCalendar v-model={selectedDate.value}>
          {{
            header: () => renderHeader(),
            'date-cell': ({ data }) => {
              const cellDate = formatDate(new Date(data.day));
              const specialDate = specialDates.value.find(item => item.date === cellDate);
              
              const baseStyle = {
                width: "100%",
                height: '100%',
                padding: '8px 0',
                textAlign: 'center',
                boxSizing: 'border-box'
              };
              const activeStyle = { backgroundColor: '#4cd964', color: 'white' }
              const rest = { position: 'relative' }
              
              const cellStyle = specialDate ? { ...baseStyle, ...activeStyle } : baseStyle;
              
              return (
                <div style={{ ...cellStyle, ...rest }} onClick={() => hasPermission && handleDateClick(data.day)}>
                  {
                    <>
                      <div>{ dayjs(data.day).date() }</div>
                      { specialDate ? <div style={{ paddingTop: '5px' }}>休</div> : '' }
                    </>
                  }
                </div>
              );
            }
          }}
        </ElCalendar>
      </ElCard>
    );
  }
});
