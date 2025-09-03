<template>
  <div class="equipment-table-container">
      <div class="table-wrapper">
        <table class="equipment-table">
          <thead>
            <tr>
              <th class="process-column">制程</th>
              <th class="total-column">负荷极限</th>
              <th class="date-column" v-for="date in dateList" :key="date.dateStr">{{ date.dateStr }}</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(group, groupIndex) in groupedData" :key="groupIndex">
              <td class="process-column">{{ group.processName }}</td>
              
              <td class="total-column">
                {{ calculateTotalEfficiency(group.equipments) }}
              </td>
              <td class="date-column" v-for="date in dateList" :key="date.dateStr">
                {{ getDateData(group, date.dateStr) }}
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
</template>

<script setup>
import { ref, computed } from 'vue';

const props = defineProps({
  dataValue: Array,
  // 接收指定结束日期，格式建议为 'YYYY-MM-DD' 字符串
  endDate: String
})

const groupedData = computed(() => {
  const groups = {};
  props.dataValue.forEach(equipment => {
    const processName = equipment.cycle.name;
    if (!groups[processName]) {
      groups[processName] = {
        processName,
        equipments: []
      };
    }
    groups[processName].equipments.push(equipment);
  });
  console.log(Object.values(groups).sort((a, b) => a.processName.localeCompare(b.processName)));
  return Object.values(groups).sort((a, b) => a.processName.localeCompare(b.processName));
});

const calculateTotalEfficiency = (equipments) => {
  return equipments.reduce((total, equipment) => {
    const efficiency = Number(equipment.equipment_efficiency) || 0;
    return total + efficiency;
  }, 0);
};

// 生成从今天到指定结束日期的日期列表
const dateList = computed(() => {
  const dates = [];
  const today = new Date();
  // 将传入的结束日期字符串转换为Date对象
  const endDate = new Date(props.endDate);
  
  // 验证结束日期是否有效且不早于今天
  if (isNaN(endDate.getTime()) || endDate < today) {
    // console.warn('结束日期无效或早于今天，将使用今天作为结束日期');
    endDate.setTime(today.getTime());
  }
  
  // 从今天开始往后推，直到结束日期
  let currentDate = new Date(today);
  while (currentDate <= endDate) {
    const year = currentDate.getFullYear();
    const month = String(currentDate.getMonth() + 1).padStart(2, '0');
    const day = String(currentDate.getDate()).padStart(2, '0');
    dates.push({
      date: new Date(currentDate),
      dateStr: `${year}/${month}/${day}`
    });
    
    // 向后推一天
    currentDate.setDate(currentDate.getDate() + 1);
  }
  
  return dates;
});

const getDateData = (group, dateStr) => {
  return '/';
};
</script>

<style scoped lang="scss">
.equipment-table-container {
  overflow-x: auto;
  .table-wrapper {
    min-width: 800px;
    overflow-x: auto;
    .equipment-table {
      width: 100%;
      border-collapse: collapse;
      border: 1px solid #e5e7eb;
      background-color: #fff;
      tr:hover td {
        background-color: #f1f5f9;
      }
      th, td{
        padding: 6px 6px;
        border: 1px solid #e5e7eb;
        text-align: left;
        font-size: 14px;
        width: 350px;
      }
      th {
        font-weight: 600;
        color: #334155;
        white-space: nowrap;
      }
      .device-group-1 {
        background-color: #F3F3F3;
      }
      .device-group-2 {
        background-color: #ffffff;
      }
      .process-column {
        background-color: #f0fdfa;
        font-weight: 600;
        min-width: 100px;
      }
      .total-column {
        background-color: #fff3cd;
        font-weight: bold;
        color: #856404;
        min-width: 120px;
      }
    }
  }
}
@media (max-width: 768px) {
  .equipment-table-container {
    padding: 10px;
    .table-wrapper {
      min-width: 700px;
      .equipment-table{
        th, td{
          padding: 8px 10px;
          font-size: 14px;
        }
      }
    }
  }
}
</style>