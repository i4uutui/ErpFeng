const express = require('express');
const router = express.Router();
const dayjs = require('dayjs')
const { SubWarehouseContent, SubWarehouseApply, Op, sequelize } = require('../models')
const authMiddleware = require('../middleware/auth');
const { formatArrayTime, formatObjectTime } = require('../middleware/formatTime');

function isInteger(value) {
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
// 临时查询仓库是否有数据，数量等等
router.post('/queryWarehouse', authMiddleware, async (req, res) => {
  const { ware_id, house_id, house_name, operate, type, plan_id, plan, item_id, code, name, quantity, buy_price } = req.body
  const { id: userId, company_id } = req.user;

  if(!item_id) return res.json({ message: '请选择物料', code: 401 })
  if(!house_id) return res.json({ message: '请选择仓库', code: 401 })
  const itemValue = await SubWarehouseContent.findOne({
    where: {
      company_id,
      item_id,
      house_id
    }
  })
  if((operate == 1 && type == 6) || operate == 2){ // 如果入库且为盘银入库或者出库
    if(!itemValue) return res.json({ message: '仓库中并无此物料，请检查后再操作', code: 401 })
  }
  if(operate == 2 && itemValue){  // 如果出库且有数据
    const items = itemValue.toJSON()
    const num = Number(items.number_new)
    if(num <= 0) return res.json({ message: '此物料已无库存，请检查后再操作', code: 401 })
    if(!isInteger(quantity) && Number(quantity) <= 0) return res.json({ message: '请输入大于0数字', code: 401 })
    if(Number(quantity) > num) return res.json({ message: '库存不足，请检查后再操作', code: 401 })
  }
  return res.json({ data: null, code: 200 })
})

// 材料出入库列表
router.post('/warehouse_apply', authMiddleware, async (req, res) => {
  const { house_id, operate, type, plan_id, item_id, status } = req.body
  const { id: userId, company_id } = req.user;

  let whereObj = {}
  if(house_id) whereObj.house_id = house_id
  if(operate) whereObj.operate = operate
  if(type) whereObj.type = type
  if(plan_id) whereObj.plan_id = plan_id
  if(item_id) whereObj.item_id = item_id
  if(status) whereObj.status = status == '' ? 0 : status

  const hasWhereData = Object.keys(whereObj).length > 0;
  if(!hasWhereData) return res.json({ message: '请至少选择一个筛选条件', code: 401 })
  const result = await SubWarehouseApply.findAll({
    where: {
      company_id,
      ...whereObj
    },
    order: [['created_at', 'DESC']],
  })
  const fromData = result.map(e => e.toJSON())

  res.json({ 
    data: formatArrayTime(fromData), 
    length: fromData.length, 
    code: 200 
  });
})
router.post('/add_wareHouse_order', authMiddleware, async (req, res) => {
  const { data } = req.body;
  const { id: userId, company_id, username } = req.user;
  
  const dataValue = data.map(e => {
    e.company_id = company_id
    e.user_id = userId
    e.total_price = PreciseMath.mul(e.quantity, e.buy_price)
    e.apply_id = userId
    e.apply_name = username
    e.apply_time = dayjs().format('YYYY-MM-DD')
    e.plan_id = e.plan_id ? e.plan_id : null
    return e
  })
  
  try {
    await SubWarehouseApply.bulkCreate(dataValue)
  
  res.json({ message: '提交成功', code: 200 });
  } catch (error) {
    console.log(error);
  }
})
router.put('/wareHouse_order', authMiddleware, async (req, res) => {
  const { id, ware_id, house_id, house_name, operate, type, plan_id, plan, item_id, code, name, model_spec, quantity, buy_price } = req.body;
  const { id: userId, company_id } = req.user;

  const result = await SubWarehouseApply.findByPk(id)
  const operateName = operate == 1 ? '入库' : '出库'
  if(!result) res.json({ message: `未找到该${operateName}信息`, code: 401 })
  
  const total_price = PreciseMath.mul(quantity, buy_price)
  const obj = {
    ware_id, house_id, house_name, operate, type, plan_id, plan, item_id, code, name, model_spec, quantity, buy_price, total_price, company_id,
    user_id: userId
  }
  console.log(obj);
  const updateResult = await SubWarehouseApply.update(obj, {
    where: {
      id
    }
  })
  if(updateResult.length == 0) return res.json({ message: '数据不存在，或已被删除', code: 401})
  
  res.json({ message: '修改成功', code: 200 });
})

module.exports = router;