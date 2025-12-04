<style scoped lang="scss">
.headContainer{
  position: relative;
  display: flex;
  justify-content: center;
  align-items: center;
  .left-button{
    position: absolute;
    left: 0;
    top: 50%;
    transform: translateY(-50%);
  }
}
</style>

<template>
  <ElDialog v-model='dialogVisible' title='盘点数据' fullscreen center draggable @close='handleClose'>
    <template #header>
      <div class="headContainer">
        <div class="left-button">
          <el-button type="primary" @click="exportDataToExcel">下载excel</el-button>
        </div>
        <div class="center-title">盘点</div>
      </div>
    </template>
    <ElTable :data='tableData' border stripe show-summary :summaryMethod="getSummaries" maxHeight="calc(100vh - 80px)" style="width: 100%">
      <ElTableColumn prop="house_name" label="仓库名称" />
      <ElTableColumn prop="code" label="材料编码" />
      <ElTableColumn prop="name" label="材料名称" />
      <ElTableColumn label="出入库方式">
        <template #default="scope">
          <span>{{ scope.row.type ? typeSelectList.find(e => e.id == scope.row.type)?.name : '' }}</span>
        </template>
      </ElTableColumn>
      <ElTableColumn prop="price" label="内部单价" />
      <ElTableColumn prop="quantity_in" label="入库数量" />
      <ElTableColumn prop="price_in" label="入库金额" />
      <ElTableColumn prop="quantity_out" label="出库数量" />
      <ElTableColumn prop="price_out" label="出库金额" />
      <ElTableColumn prop="total_quantity" label="库存数量" />
      <ElTableColumn prop="total_price" label="库存金额" />
      <ElTableColumn label="盘点数量">
        <template #default="scope">
          <ElInput type="number" v-model="scope.row.pan" size="small" />
        </template>
      </ElTableColumn>
      <ElTableColumn label="盈亏金额">
        <template #default="{ row }">
          <span :style="`color: ${ getMapMul(row) >= 0 ? 'green' : 'red' }`">{{ getMapMul(row) }}</span>
        </template>
      </ElTableColumn>
      <ElTableColumn label="备注">
        <template #default="scope">
          <ElInput type="text" v-model="scope.row.remark" size="small" />
        </template>
      </ElTableColumn>
    </ElTable>
  </ElDialog>
</template>

<script setup>
import { ref } from 'vue';
import { PreciseMath } from '@/utils/tool'
import request from '@/utils/request';
import  * as XLSX from 'xlsx';
// file-saver优化下载
import { saveAs } from 'file-saver';

let dialogVisible = ref(false)
let tableData = ref([])
let typeSelectList = ref([])

const fetchList = async (obj) => {
  const res = await request.post('/api/getWareHouseInventory', obj)
  if(res.code == 200){
    tableData.value = res.data.map(e => {
      e.remark = ''
      e.price_in = PreciseMath.mul(e.price, e.quantity_in)
      e.price_out = PreciseMath.mul(e.price, e.quantity_out)
      e.total_quantity = PreciseMath.sub(e.quantity_in, e.quantity_out)
      e.total_price = PreciseMath.mul(e.total_quantity, e.price)
      return e
    })
  }
}
const getMapMul = (row) => {
  const stock = PreciseMath.sub(row.quantity_in, row.quantity_out)
  const total = PreciseMath.sub(row.pan, stock)
  return PreciseMath.mul(total, row.price)
}
const getSummaries = (param) => {
  const { columns, data } = param
  const sums = []
  columns.forEach((column, index) => {
    if(index == 0) return sums[index] = '合计'

    const values = data.map((item) => Number(item[column.property]))
    if(index != 4 && !values.every((value) => Number.isNaN(value))){
      sums[index] = values.reduce((prev, curr) => {
        const value = Number(curr)
        if (!Number.isNaN(value)) {
          return PreciseMath.add(prev, curr)
        } else {
          return prev
        }
      }, 0)
    }else{
      sums[index] = ''
    }
  })
  return sums
}
const exportDataToExcel = () => {
  // 1. 处理导出数据：过滤不需要的字段（如操作列）、重命名字段
  const exportData = tableData.value.map(item => ({
    "仓库名称": item.house_name || '',
    "材料编码": item.code || '',
    "材料名称": item.name || '',
    "出入库方式": item.type ? typeSelectList.value.find(e => e.id == item.type)?.name : '',
    "内部单价": item.price || 0,
    "入库数量": item.quantity_in || 0,
    "入库金额": item.price_in || 0,
    "出库数量": item.quantity_out || 0,
    "出库金额": item.price_out || 0,
    "库存数量": item.total_quantity || 0,
    "库存金额": item.total_price || 0,
    "盘点数量": item.pan || 0,
    "盈亏金额": getMapMul(item) || 0,
    "备注": item.remark,
  }));
  const totalNumber = (field) => {
    return exportData.reduce((prev, curr) => {
      const currValue = Number(curr[field]) || 0;
      return PreciseMath.add(prev, currValue);
    }, 0);
  };
  const totalProfitLoss = exportData.reduce((prev, curr) => {
    const currValue = Number(curr['盈亏金额']) || 0;
    return PreciseMath.add(prev, currValue);
  }, 0);
  exportData.push({
    "仓库名称": '合计',
    "材料编码": '',
    "材料名称": '',
    "出入库方式": '',
    "内部单价": '',
    "入库数量": totalNumber('入库数量'),
    "入库金额": totalNumber('入库金额'),
    "出库数量": totalNumber('出库数量'),
    "出库金额": totalNumber('出库金额'),
    "库存数量": totalNumber('库存数量'),
    "库存金额": totalNumber('库存金额'),
    "盘点数量": totalNumber('盘点数量'),
    "盈亏金额": totalProfitLoss,
    "备注": '',
  })

  // 2. 将数据转为工作表
  const ws = XLSX.utils.json_to_sheet(exportData);

  // 3. 创建工作簿并添加工作表
  const wb = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(wb, ws, '盘点数据');

  // 4. 生成并下载文件（两种方式二选一）
  // 方式A：原生xlsx.writeFile
  // XLSX.writeFile(wb, '盘点数据_' + new Date().getTime() + '.xlsx');

  // 方式B：用file-saver（兼容更多浏览器）
  const wbout = XLSX.write(wb, { bookType: 'xlsx', type: 'array' });
  saveAs(new Blob([wbout], { type: 'application/octet-stream' }), '盘点数据.xlsx');
};
const handleClose = () => {

}
defineExpose({
  dialogVisible,
  typeSelectList,
  fetchList
})
</script>