import { defineComponent, ref, reactive, onMounted, nextTick } from 'vue';
import * as echarts from 'echarts/core';
import { GridComponent } from 'echarts/components';
import { BarChart } from 'echarts/charts';
import { CanvasRenderer } from 'echarts/renderers';
import request from '@/utils/request'
import dayjs from 'dayjs';

echarts.use([GridComponent, BarChart, CanvasRenderer]);

export default defineComponent({
  setup() {
    const chartRef = ref(null);
    const option = ref({
      grid: {
        left: '16px',
        right: '16px',
        bottom: '0px',
        top: '5%',
        containLabel: true
      },
      xAxis: [
        {
          type: 'category',
          data: ['销售订单', '报价单', '生产订单', '生产订单(完结)'],
          axisTick: {
            alignWithLabel: true
          },
          axisLabel: {
            formatter: (value) => {
              if(value === '生产订单(完结)'){
                return ' 生产订单 \n (完结)';
              }
              return value;
            },
            fontSize: 12,
            lineHeight: 16,
            align: 'center'
          }
        }
      ],
      yAxis: [
        {
          type: 'value',
          max: (value) => {
            return Math.ceil (value.max * 1.1);
          },
        }
      ],
      series: [
        {
          name: '订单数量',
          type: 'bar',
          barWidth: '60%',
          data: [],
          label: {
            show: true, // 显示标签
            position: 'top', // 标签位置：顶部
            align: 'center', // 水平居中
            verticalAlign: 'bottom', // 垂直对齐
            fontSize: 12, // 字体大小
            color: '#333' // 字体颜色
          }
        }
      ]
    });
    let myChart = null
    let dateTime = ref([])

    onMounted(async () => {
      // 获取最近一年的日期
      const today = dayjs()
      const lastYearStart = today.subtract(1, 'year').startOf('day').format('YYYY-MM-DD HH:mm:ss')
      const lastYearEnd = today.endOf('day').format('YYYY-MM-DD HH:mm:ss')
      dateTime.value = [lastYearStart, lastYearEnd]

      await nextTick()
      myChart = echarts.init(chartRef.value);
      getOrderTotal()
    });

    const getOrderTotal = async () => {
      const res = await request.get('/api/order_total', { params: { created_at: dateTime.value } })
      if(res.code == 200){
        const { saleOrder, productQuotation, notice, noticeFinish } = res.data
        const arr = [ saleOrder, productQuotation, notice, noticeFinish ]
        option.value.series[0].data = arr
        
        myChart.setOption(option.value);
      }
    }
    const dateChange = (value) => {
      const startTime = `${value[0]} 00:00:00`
      const endTime = `${value[1]} 23:59:59`
      dateTime.value = [startTime, endTime]
      getOrderTotal()
    }
    
    return () => (
      <ElCard shadow="always" bodyStyle={{ width: '100%', height: '500px', display: 'flex', flexDirection: 'column' }}>
        <div style={{ display: 'flex', justifyContent: 'space-between' }}>
          <div style={{ fontSize: '16px', paddingTop: '10px' }}>订单统计</div>
          <div style={{ width: '70%', marginRight: '0' }}>
            <ElDatePicker v-model={ dateTime.value } type="daterange" clearable={ false } range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期" value-format="YYYY-MM-DD" onChange={ (row) => dateChange(row) } style={{ width: '100%' }} />
          </div>
        </div>
        <div style={{ width: '100%', flex: 1 }}>
          <div ref={ chartRef } style={{ width: '100%', height: '100%', }} ></div>
        </div>
      </ElCard>
    );
  }
});
