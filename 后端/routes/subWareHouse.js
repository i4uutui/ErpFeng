const express = require('express');
const router = express.Router();
const dayjs = require('dayjs')
const { SubWarehouseContent, SubWarehouseApply, SubApprovalStep, SubApprovalUser, Op } = require('../models')
const authMiddleware = require('../middleware/auth');
const { formatArrayTime, formatObjectTime } = require('../middleware/formatTime');
const { isInteger, PreciseMath } = require('../middleware/tool')

/**
 * @swagger
 * /api/queryWarehouse:
 *   post:
 *     summary: 临时查询仓库是否有数据，数量等等
 *     tags:
 *       - 仓库管理(WareHouse)
 *     parameters:
 *       - name: house_id
 *         schema:
 *           type: int
 *       - name: operate
 *         schema:
 *           type: int
 *       - name: type
 *         schema:
 *           type: int
 *       - name: item_id
 *         schema:
 *           type: int
 *       - name: quantity
 *         schema:
 *           type: int
 */
router.post('/queryWarehouse', authMiddleware, async (req, res) => {
  const { house_id, operate, type, item_id, quantity } = req.body
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

/**
 * @swagger
 * /api/warehouse_apply:
 *   post:
 *     summary: 出入库列表
 *     tags:
 *       - 仓库管理(WareHouse)
 *     parameters:
 *       - name: house_id
 *         schema:
 *           type: int
 *       - name: operate
 *         schema:
 *           type: int
 *       - name: type
 *         schema:
 *           type: int
 *       - name: item_id
 *         schema:
 *           type: int
 *       - name: plan_id
 *         schema:
 *           type: int
 *       - name: status
 *         schema:
 *           type: int
 *       - name: apply_time
 *         schema:
 *           type: array
 */
router.post('/warehouse_apply', authMiddleware, async (req, res) => {
  const { ware_id, house_id, operate, type, plan_id, item_id, status, apply_time } = req.body
  const { id: userId, company_id } = req.user;

  let whereObj = {}
  if(house_id) whereObj.house_id = house_id
  if(operate) whereObj.operate = operate
  if(type) whereObj.type = type
  if(plan_id) whereObj.plan_id = plan_id
  if(item_id) whereObj.item_id = item_id
  if(status === '' || status === undefined) whereObj.status = [0, 2]
  if(house_id || operate || plan_id || item_id){
    delete whereObj.status
  }
  if(status !== '' && status !== undefined) whereObj.status = status
  
  const hasWhereData = Object.keys(whereObj).length > 0;
  if(!hasWhereData) return res.json({ message: '请至少选择一个筛选条件', code: 401 })

  const where = {
    company_id,
    ware_id,
    ...whereObj,
    apply_time: {
      [Op.between]: [new Date(apply_time[0]), new Date(apply_time[1])] // 使用 between 筛选范围
    }
  }
  const result = await SubWarehouseApply.findAll({
    where: where,
    include: [
      { model: SubApprovalUser, as: 'approval', attributes: [ 'user_id', 'user_name', 'type', 'step', 'company_id', 'source_id', 'user_time', 'status', 'id' ], order: [['step', 'ASC']], separate: true, }
    ],
    order: [
      ['created_at', 'DESC']
    ],
  })
  const fromData = result.map(e => e.toJSON());

  res.json({ 
    data: formatArrayTime(fromData), 
    length: fromData.length, 
    code: 200 
  });
})
/**
 * @swagger
 * /api/add_wareHouse_order:
 *   post:
 *     summary: 提交审批
 *     tags:
 *       - 仓库管理(WareHouse)
 *     parameters:
 *       - name: data
 *         schema:
 *           type: array
 *       - name: type
 *         schema:
 *           type: int
 */
router.post('/add_wareHouse_order', authMiddleware, async (req, res) => {
  const { data, type } = req.body;
  const { id: userId, company_id, name } = req.user;

  const step = await SubApprovalStep.findAll({
    where: {
      is_deleted: 1,
      company_id,
      type
    },
    attributes: ['id', 'user_id', 'user_name', 'type', 'step', 'company_id']
  })
  if(!step.length) return res.json({ code: 401, message: '未配置审批流程，请先联系管理员' })
  const steps = step.map(e => e.toJSON())
  
  const dataValue = data.map(e => {
    e.company_id = company_id
    e.user_id = userId
    e.total_price = e.buy_price && e.quantity ? PreciseMath.mul(e.quantity, e.buy_price) : 0
    e.plan_id = e.plan_id ? e.plan_id : null
    e.buy_price = e.buy_price ? e.buy_price : 0
    e.quantity = e.quantity ? e.quantity : 0
    e.buyPrint_id = e.buyPrint_id
    e.sale_id = e.sale_id
    e.apply_id = userId
    e.apply_name = name
    e.apply_time = dayjs().toDate()
    e.status = 0
    return e
  })
  const result = await SubWarehouseApply.bulkCreate(dataValue, {
    updateOnDuplicate: ['company_id', 'user_id', 'total_price', 'plan_id', 'buy_price', 'quantity', 'apply_id', 'apply_name', 'apply_time', 'status']
  })
  // 创建审批流程
  const resData = result.flatMap(e => {
    const item = e.toJSON()
    return steps.map(o => {
      const { id, ...newData } = o;
      return {
        ...newData,
        source_id: item.id, 
        user_time: null,
        status: 0,
      };
    })
  })
  await SubApprovalUser.bulkCreate(resData, {
    updateOnDuplicate: ['user_id', 'user_name', 'type', 'step', 'company_id', 'source_id', 'user_time', 'status']
  })
  res.json({ message: '提交成功', code: 200 });
})
/**
 * @swagger
 * /api/wareHouse_order:
 *   put:
 *     summary: 修改出入库信息
 *     tags:
 *       - 仓库管理(WareHouse)
 *     parameters:
 *       - name: id
 *         schema:
 *           type: int
 *       - name: ware_id
 *         schema:
 *           type: int
 *       - name: house_id
 *         schema:
 *           type: int
 *       - name: house_name
 *         schema:
 *           type: string
 *       - name: operate
 *         schema:
 *           type: int
 *       - name: type
 *         schema:
 *           type: int
 *       - name: plan_id
 *         schema:
 *           type: int
 *       - name: plan
 *         schema:
 *           type: string
 *       - name: item_id
 *         schema:
 *           type: int
 *       - name: code
 *         schema:
 *           type: string
 *       - name: name
 *         schema:
 *           type: string
 *       - name: model_spec
 *         schema:
 *           type: string
 *       - name: other_features
 *         schema:
 *           type: string
 *       - name: quantity
 *         schema:
 *           type: int
 *       - name: buy_price
 *         schema:
 *           type: int
 */
router.put('/wareHouse_order', authMiddleware, async (req, res) => {
  const { id, ware_id, house_id, house_name, operate, type, plan_id, plan, item_id, code, name, model_spec, other_features, quantity, buy_price, buyPrint_id, sale_id } = req.body;
  const { id: userId, company_id } = req.user;

  const result = await SubWarehouseApply.findByPk(id)
  const operateName = operate == 1 ? '入库' : '出库'
  if(!result) res.json({ message: `未找到该${operateName}信息`, code: 401 })
  
  const total_price = PreciseMath.mul(quantity, buy_price)
  const obj = {
    ware_id, house_id, house_name, operate, type, plan_id, plan, item_id, code, name, model_spec, other_features, quantity, buy_price, total_price, buyPrint_id, sale_id, company_id,
    user_id: userId
  }
  const updateResult = await SubWarehouseApply.update(obj, {
    where: {
      id
    }
  })
  if(updateResult.length == 0) return res.json({ message: '数据不存在，或已被删除', code: 401})
  
  res.json({ message: '修改成功', code: 200 });
})
/**
 * @swagger
 * /api/get_wareHouser:
 *   post:
 *     summary: 仓库列表
 *     tags:
 *       - 仓库管理(WareHouse)
 *     parameters:
 *       - name: page
 *         schema:
 *           type: int
 *       - name: pageSize
 *         schema:
 *           type: int
 *       - name: house_id
 *         schema:
 *           type: int
 */
router.get('/get_wareHouser', authMiddleware, async (req, res) => {
  const { page = 1, pageSize = 10, house_id } = req.query;
  const offset = (page - 1) * pageSize;
  const { id: userId, company_id } = req.user;

  const { count, rows } = await SubWarehouseContent.findAndCountAll({
    where: {
      company_id,
      house_id,
      is_deleted: 1
    },
    attributes: ['id', 'code', 'name', 'model_spec', 'other_features', 'ware_id', 'house_id', 'item_id', 'unit', 'inv_unit', 'initial', 'number_in', 'number_out', 'number_new', 'price', 'price_total', 'price_in', 'price_out', 'last_in_time', 'last_out_time'],
    order: [
      ['id', 'DESC'],
    ],
    distinct: true,
    limit: parseInt(pageSize),
    offset
  })
  const totalPages = Math.ceil(count / pageSize)
  const fromData = rows.map(e => {
    const item = e.toJSON()
    item.price = Number(item.price)
    item.price_total = Number(item.price_total)
    item.price_in = Number(item.price_in)
    item.price_out = Number(item.price_out)
    return item
  })
  // 返回所需信息
  res.json({ 
    data: formatArrayTime(fromData), 
    total: count, 
    totalPages, 
    currentPage: parseInt(page), 
    pageSize: parseInt(pageSize),
    code: 200 
  });
})
/**
 * @swagger
 * /api/set_wareHouser:
 *   put:
 *     summary: 修改仓库物料信息
 *     tags:
 *       - 仓库管理(WareHouse)
 *     parameters:
 *       - name: id
 *         schema:
 *           type: int
 *       - name: inv_unit
 *         schema:
 *           type: string
 *       - name: price
 *         schema:
 *           type: int
 */
router.put('/set_wareHouser', authMiddleware, async (req, res) => {
  const { inv_unit, price, id } = req.body;
  const { id: userId, company_id } = req.user;

  // 验证物料是否存在
  const product = await SubWarehouseContent.findByPk(id);
  if (!product) {
    return res.json({ message: '物料不存在', code: 401 });
  }
  const result = product.toJSON()
  const price_total = price ? PreciseMath.mul(price, result.number_new) : 0
  const price_out = price ? PreciseMath.mul(price, result.number_out) : 0

  await product.update({
    inv_unit, price, price_total, price_out, company_id,
    user_id: userId
  }, { where: { id } })
  
  res.json({ msg: "修改成功", code: 200 });
})

module.exports = router;