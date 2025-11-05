const { SubSaleCancel } = require("../models");

/**
 * 处理精确计算
 * @returns {string} 返回最后的计算结果
 */
const PreciseMath = {
  getDecimalLength(num) {
    const parts = num.toString().split('.');
    return parts[1] ? parts[1].length : 0;
  },
  // 加
  add(a, b) {
    const maxDecimals = Math.max(this.getDecimalLength(a), this.getDecimalLength(b));
    const factor = Math.pow(10, maxDecimals);
    return (Math.round(a * factor) + Math.round(b * factor)) / factor;
  },
  // 减
  sub(a, b) {
    const maxDecimals = Math.max(this.getDecimalLength(a), this.getDecimalLength(b));
    const factor = Math.pow(10, maxDecimals);
    return (Math.round(a * factor) - Math.round(b * factor)) / factor;
  },
  // 乘
  mul(a, b) {
    const aDecimals = this.getDecimalLength(a);
    const bDecimals = this.getDecimalLength(b);
    const factor = Math.pow(10, aDecimals + bDecimals);
    return (Math.round(a * Math.pow(10, aDecimals)) * Math.round(b * Math.pow(10, bDecimals))) / factor;
  },
  // 除
  div(a, b) {
    const aDecimals = this.getDecimalLength(a);
    const bDecimals = this.getDecimalLength(b);
    const factorA = Math.pow(10, aDecimals);
    const factorB = Math.pow(10, bDecimals);
    return (Math.round(a * factorA) / Math.round(b * factorB)) * Math.pow(10, bDecimals - aDecimals);
  }
};

const isInteger = (value) => {
  // 检查是否为数字且是整数
  if (typeof value === 'number') {
    return Number.isInteger(value);
  }
  
  // 检查是否为字符串
  if (typeof value === 'string') {
    // 去除可能的前后空格
    const trimmed = value.trim();
    // 正则匹配整数格式（包括正负号）
    const integerRegex = /^[-+]?\d+$/;
    return integerRegex.test(trimmed);
  }
  
  // 其他类型直接返回false
  return false;
}
/**
 * 2. 出库核心函数
 * @param {Object} stockData - 当前库存数据（包含 number_in 和 initial）
 * @param {number} outQuantity - 待出库数量（必须为正整数）
 * @returns {Object} - 出库成功后的最新库存数据
 * @throws {Error} - 出库量非法或库存不足时抛出错误
 */
const processStockOut = (stockData, outQuantity) => {
  const newStock = { ...stockData };
  let remainingOut = outQuantity;
  // 先减正常库存
  if (newStock.number_in > 0){
    if (newStock.number_in >= remainingOut) {
      newStock.number_in = PreciseMath.sub(newStock.number_in, remainingOut);
      remainingOut = 0; // 剩余出库量清零
    }else {
      remainingOut = PreciseMath.sub(remainingOut, newStock.number_in);
      newStock.number_in = 0;
    }
  }
  // 正常库存已空，减期初库存
  if (remainingOut > 0 && newStock.initial > 0){
    if (newStock.initial >= remainingOut) {
      newStock.initial = PreciseMath.sub(newStock.initial, remainingOut);
      remainingOut = 0;
    } else {
      console.log(`库存不足！正常库存${newStock.number_in}，期初库存${newStock.initial}，需出库${outQuantity}，缺口${remainingOut}`);
      return false
    }
  }
  // 若剩余出库量仍大于0（说明正常+期初库存都不足）
  if (remainingOut > 0){
    console.log(`库存不足！正常库存${newStock.number_in}，期初库存${newStock.initial}，需出库${outQuantity}，缺口${remainingOut}`);
    return false
  }
  // 出库成功：返回最新库存
  return newStock;
}

/**
 * 获取所有销售取消记录的列表
 * @returns {Promise<number[]>} 数组
 */
const getSaleCancelIds = async (value) => {
  const saleCancel = await SubSaleCancel.findAll({ 
    attributes: ['sale_id', 'notice_id'] 
  });
  return saleCancel.length ? saleCancel.map(e => e[value]) : [];
};

module.exports = {
  PreciseMath,
  isInteger,
  processStockOut,
  getSaleCancelIds
};