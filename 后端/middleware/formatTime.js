// ceErns/后端/middleware/formatTime.js
const dayjs = require('dayjs');

const formatTime = (time, extraParam) => {
  const type = extraParam ? 'YYYY-MM-DD HH:mm:ss' : 'YYYY-MM-DD'
  return time ? dayjs(time).format(type) : '';
};

// 格式化对象中的时间字段
const formatObjectTime = (obj, extraParam) => {
  if (!obj) return obj;
  const timeStr = [ 'rece_time', 'delivery_time', 'goods_time', 'updated_at', 'created_at', 'last_in_time', 'last_out_time', 'apply_time']
  
  const result = {};
  for (const [key, value] of Object.entries(obj)) {
    if(timeStr.includes(key)){
      result[key] = formatTime(value, extraParam);
    }else{
      result[key] = value;
    }
  }
  
  return result;
};


// 格式化数组中的时间字段
const formatArrayTime = (arr, extraParam) => {
  return arr.map(item => formatObjectTime(item, extraParam));
};

module.exports = {
  formatObjectTime,
  formatArrayTime
};