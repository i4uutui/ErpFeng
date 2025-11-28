const express = require('express');
const router = express.Router();
const dayjs = require('dayjs')
const Decimal = require('decimal.js');
const { SubWarehouseContent, SubWarehouseApply, SubApprovalStep, SubApprovalUser, Op, SubProductNotice, SubWarehouseOrder, SubWarehouseCycle, SubWarehouseType } = require('../models')
const authMiddleware = require('../middleware/auth');
const { formatArrayTime, formatObjectTime } = require('../middleware/formatTime');
const { isInteger, PreciseMath } = require('../middleware/tool')

/**
 * @swagger
 * /api/get_warehouse_type:
 *   post:
 *     summary: 获取仓库类型或出入库类型
 *     tags:
 *       - 仓库管理(WareHouse)
 */
router.post('/get_warehouse_type', authMiddleware, async (req, res) => {
  const { type } = req.body
  const { id: userId, company_id } = req.user;

  const where = {}
  if(type) where.type = type
  const result = await SubWarehouseType.findAll({ where, raw: true })

  res.json({ code: 200, data: result })
})

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
  try {
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
      const houseQuantity = items.quantity ? Number(items.quantity) : 0
      
      if(houseQuantity <= 0) return res.json({ message: '此物料已无库存，请检查后再操作', code: 401 })
      if(!isInteger(quantity) && Number(quantity) <= 0) return res.json({ message: '请输入大于0数量', code: 401 })
      if(Number(quantity) > houseQuantity) return res.json({ message: '库存不足，请检查后再操作', code: 401 })
    }
    return res.json({ data: null, code: 200 })
  } catch (error) {
    console.log(error);
  }
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
  const { ware_id, house_id, operate, type, plan_id, item_id, status, apply_time, source_type } = req.body
  const { id: userId, company_id } = req.user;

  let whereObj = {}
  if(house_id) whereObj.house_id = house_id
  if(operate) whereObj.operate = operate
  if(type) whereObj.type = type
  if(plan_id) whereObj.plan_id = plan_id
  if(item_id) whereObj.item_id = item_id
  if(status === '' || status === undefined) whereObj.status = [0, 2, 3]
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
      { model: SubApprovalUser, as: 'approval', attributes: [ 'user_id', 'user_name', 'type', 'step', 'company_id', 'source_id', 'user_time', 'status', 'id' ], order: [['step', 'ASC']], where: { type: 'material_warehouse', company_id, type: source_type }, separate: true, },
      { model: SubProductNotice, as: 'notice', attributes: ['id', 'notice'] }
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

  if(!data.length) return res.json({ code: 401, message: '请选择订单数据' })

  const stepList = await SubApprovalStep.findAll({
    where: { is_deleted: 1, company_id, type },
    attributes: ['id', 'user_id', 'user_name', 'type', 'step', 'company_id'],
    raw: true,
  })
  if(!stepList.length) return res.json({ code: 401, message: '未配置审批流程，请先联系管理员' })
  
  const now = dayjs().toDate()
  const noIdList = [];
  const yesIdList = [];

  const dataValue = data.map(e => {
    const { id, buy_price = 0, price = 0, quantity = 0, plan_id = null, procure_id = null, sale_id = null, notice_id = null, ...rest } = e
    const total_price = buy_price && quantity ? PreciseMath.mul(quantity, buy_price) : 0

    const record = {
      ...rest,
      id,
      company_id,
      user_id: userId,
      total_price,
      plan_id: plan_id ? plan_id : null,
      notice_id: notice_id,
      buy_price: buy_price ? buy_price : 0,
      quantity: quantity ? quantity : 0,
      procure_id,
      sale_id: sale_id ? sale_id : null,
      apply_id: userId,
      apply_name: name,
      apply_time: now,
      status: 0
    }
    
    if (id){
      yesIdList.push(record)
    }else{
      noIdList.push(record)
    }
    return record
  })
  
  const updateFields = ['company_id', 'user_id', 'total_price', 'plan_id', 'notice_id', 'buy_price', 'quantity', 'procure_id', 'sale_id', 'apply_id', 'apply_name', 'apply_time', 'status']
  try {
    const [noResult, yesResult] = await Promise.all([
      noIdList.length
        ? SubWarehouseApply.bulkCreate(noIdList, { updateOnDuplicate: updateFields })
        : [],
      yesIdList.length
        ? SubWarehouseApply.bulkCreate(yesIdList, { updateOnDuplicate: updateFields })
        : []
    ]);

    // 因为步骤有id，所以先修改有id的数据
    const yesApprovalList = yesIdList.flatMap(item => item.approval || []).map(id => ({
      id, status: 0
    }));
    if(yesApprovalList.length){
      await SubApprovalUser.bulkCreate(yesApprovalList, { updateOnDuplicate: ['status'] })
    }

    // 创建审批流程
    const resData = noResult.flatMap(e => {
      const item = e.toJSON()
      return stepList.map(o => {
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
  } catch (error) {
    console.log(error);
  }
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
  const { id, ware_id, house_id, house_name, operate, type, plan_id, plan, item_id, code, name, model_spec, other_features, quantity, buy_price, procure_id, sale_id } = req.body;
  const { id: userId, company_id } = req.user;

  const result = await SubWarehouseApply.findByPk(id)
  const operateName = operate == 1 ? '入库' : '出库'
  if(!result) res.json({ message: `未找到该${operateName}信息`, code: 401 })
  
  const total_price = PreciseMath.mul(quantity, buy_price)
  const obj = {
    ware_id, house_id, house_name, operate, type, plan_id, plan, item_id, code, name, model_spec, other_features, quantity, buy_price, total_price, procure_id, sale_id, company_id,
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
    attributes: ['id', 'user_id', 'company_id', 'ware_id', 'house_id', 'item_id', 'code', 'name', 'model_spec', 'other_features', 'buy_price', 'price', 'quantity', 'inv_unit', 'unit', 'last_in_time', 'last_out_time'],
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
  const { inv_unit, unit, price, buy_price, id } = req.body;
  const { id: userId, company_id } = req.user;

  // 验证物料是否存在
  const product = await SubWarehouseContent.findByPk(id);
  if (!product) {
    return res.json({ message: '物料不存在', code: 401 });
  }
  await product.update({
    inv_unit, unit, price, buy_price, company_id,
    user_id: userId
  }, { where: { id } })
  
  res.json({ msg: "修改成功", code: 200 });
})

/**
 * @swagger
 * /api/handleMaterialIsBuying:
 *   post:
 *     summary: 出入库单确认
 *     tags:
 *       - 仓库管理(WareHouse)
 *     parameters:
 *       - name: id
 *         schema:
 *           type: int
 */
router.post('/handleMaterialIsBuying', authMiddleware, async (req, res) => {
  const { ids } = req.body
  const { id: userId, company_id } = req.user;

  if(!ids.length) return res.json({ code: 401, message: '请选择出入库作业' })

  const subMaterialMents = await SubWarehouseApply.findAll({
    where: { id: ids, company_id, is_buying: 1 },
    raw: true
  })
  // 校验：选中的出入库作业是否存在（避免无效ID）
  if (subMaterialMents.length !== ids.length) {
    const validIds = subMaterialMents.map(item => item.id);
    const invalidIds = ids.filter(id => !validIds.includes(id));
    return res.json({ code: 401, message: `部分出入库作业不存在或已生成采购单，请检查` });
  }

  function isAllTypesSame(array) {
    const firstType = array[0].operate;
    return array.every(item => item.operate === firstType);
  }
  if(!isAllTypesSame(subMaterialMents)) return res.json({ code: 401, message: `请将出/入库单分开确认` });

  const supplierGroups = subMaterialMents.reduce((result, item) => {
    const groupKey = item.house_id;
    if (!result[groupKey]) {
      // 初始化分组：存储仓库信息 + 关联的出入库作业IDs
      result[groupKey] = {
        operate: item.operate,
        ware_id: item.ware_id,
        house_id: item.house_id,
        subMaterialIds: [item.id], // 关联的出入库作业ID数组
        company_id,
        user_id: userId,
      };
    } else {
      // 同一仓库ID：追加出入库作业ID
      result[groupKey].subMaterialIds.push(item.id);
    }
    return result;
  }, {});
  const groups = Object.values(supplierGroups);

  // 批量创建出入库单
  const purchaseOrders = await SubWarehouseOrder.bulkCreate(groups,
    { returning: true } // 返回创建后的完整数据（包含自动生成的id）
  );

  const orderSubMaterialMap = purchaseOrders.map((order, index) => ({
    orderId: order.id,
    subMaterialIds: groups[index].subMaterialIds // 一一对应分组的采购作业IDs
  }));

  // 批量更新采购作业状态
  const updateTasks = orderSubMaterialMap.map(({ orderId, subMaterialIds }) =>
    SubWarehouseApply.update(
      { is_buying: 0, order_id: orderId },
      { where: { id: subMaterialIds, company_id } }
    )
  );
  await Promise.all(updateTasks);

  res.json({ code: 200, message: '出入库单确认成功' })
})

/**
 * @swagger
 * /api/getWareHouseList:
 *   post:
 *     summary: 获取材料/部件/成品出入库单
 *     tags:
 *       - 仓库管理(WareHouse)
 *     parameters:
 *       - name: id
 *         schema:
 *           type: int
 */
router.get('/getWareHouseList', authMiddleware, async (req, res) => {
  const { page = 1, pageSize = 10, ware_id } = req.query;
  const offset = (page - 1) * pageSize;
  const { id: userId, company_id } = req.user;

  const { count, rows } = await SubWarehouseOrder.findAndCountAll({
    where: {
      company_id,
      ware_id
    },
    attributes: ['id', 'operate', 'ware_id', 'house_id', 'no', 'created_at'],
    include: [
      { model: SubWarehouseCycle, as: 'house', attributes: ['id', 'ware_id', 'name'] },
      { model: SubWarehouseApply, as: 'order', attributes: ['id', 'procure_id', 'operate', 'type', 'plan', 'code', 'name', 'quantity', 'model_spec', 'other_features', 'buy_price', 'total_price', 'apply_name', 'apply_time', 'order_id'] }
    ],
    order: [['no', 'ASC']],
    distinct: true,
    limit: parseInt(pageSize),
    offset
  })

  const totalPages = Math.ceil(count / pageSize);
  const result = rows.map(e => {
    const item = e.toJSON()
    item.order = formatArrayTime(item.order)
    return item
  })

  res.json({ 
    data: formatArrayTime(result), 
    total: count, 
    totalPages, 
    currentPage: parseInt(page), 
    pageSize: parseInt(pageSize),
    code: 200 
  });
})

/**
 * @swagger
 * /api/getWareHouseMaterialPrice:
 *   post:
 *     summary: 获取仓库中某个材料的内部价格
 *     tags:
 *       - 仓库管理(WareHouse)
 *     parameters:
 *       - name: id
 *         schema:
 *           type: int
 */
router.get('/getWareHouseMaterialPrice', authMiddleware, async (req, res) => {
  const { id } = req.query
  const { id: userId, company_id } = req.user;

  const result = await SubWarehouseContent.findOne({
    where: { item_id: id, company_id },
    attributes: ['price', 'buy_price'],
    raw: true
  })
  if(result){
    res.json({ code: 200, data: { price: Number(result.price), buy_price: Number(result.buy_price) } })
  }else{
    res.json({ code: 200, data: null })
  }
})

module.exports = router;