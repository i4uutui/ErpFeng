const express = require('express');
const router = express.Router();
const dayjs = require('dayjs')
const Decimal = require('decimal.js');
const { SubWarehouseContent, SubWarehouseApply, SubApprovalStep, SubApprovalUser, Op, SubProductNotice, SubWarehouseOrder, SubWarehouseCycle, SubWarehouseType, SubMaterialBom, SubMaterialBomChild, SubMaterialCode, sequelize } = require('../models')
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
  const result = await SubWarehouseType.findAll({
    where,
    attributes: ['id', 'type', 'name', 'sort'],
    order: [[ 'sort', 'ASC' ]]
  })

  res.json({ code: 200, data: result })
})

/**
 * @swagger
 * /api/get_warehouseList:
 *   get:
 *     summary: 获取仓库列表
 *     tags:
 *       - 仓库管理(WareHouse)
 */
router.get('/get_warehouseList', authMiddleware, async (req, res) => {
  const { type } = req.query
  const { id: userId, company_id } = req.user;

  const where = {}
  if(type) where.type = type
  const result = await SubWarehouseType.findAll({
    where,
    attributes: ['id', 'type', 'name'],
    include: [
      { model: SubWarehouseCycle, as: 'cycle', where: { company_id }, attributes: ['id', 'ware_id', 'name'] }
    ]
  })

  res.json({ code: 200, data: result })
})

/**
 * @swagger
 * /api/queryWarehouse:
 *   post:
 *     summary: 临时查询仓库是否有数据，数量等等
 *     tags:
 *       - 仓库管理(WareHouse)
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
 */
router.post('/warehouse_apply', authMiddleware, async (req, res) => {
  const { ware_id, house_id, operate, type, plan_id, item_id, status, apply_time, source_type } = req.body
  const { id: userId, company_id } = req.user;

  let whereObj = {}
  if(house_id) whereObj.house_id = house_id
  if(operate) whereObj.operate = operate
  if(type && type.length) whereObj.type = type
  if(plan_id) whereObj.plan_id = plan_id
  if(item_id) whereObj.item_id = item_id

  const otherFields = [house_id, operate, plan_id, item_id];
  const hasOtherValues = otherFields.some(field => field !== undefined && field !== '');

  if (status !== undefined && status !== '') {
    // 前端指定了status值
    if (status == 4) {
      // 查status=4时，仅能查自己提交的
      whereObj.status = 4;
      whereObj.apply_id = userId;
    } else {
      // 查其他status（0/1/2/3），正常过滤
      whereObj.status = status;
    }
  } else {
    // 前端未指定status
    if (!hasOtherValues) {
      // 无其他查询条件时，默认查 [0,2,3] + 自己的4
      whereObj[Op.or] = [
        { status: [0, 2, 3] },
        { status: 4, apply_id: userId }
      ];
    } else {
      // 有其他查询条件时，查「所有非4状态」 + 自己的4
      whereObj[Op.or] = [
        { status: { [Op.ne]: 4 } },
        { status: 4, apply_id: userId }
      ];
    }
  }

  const where = {
    company_id,
    ware_id,
    ...whereObj,
    created_at: {
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
 * /api/add_ware_data:
 *   post:
 *     summary: 新增出入库作业数据
 *     tags:
 *       - 仓库管理(WareHouse)
 */
router.post('/add_ware_data', authMiddleware, async (req, res) => {
  const { procure_id = null, sale_id = null, ware_id = null, house_id = null, operate = null, type = null, material_bom_id = null, house_name = null, plan_id = null, plan = null, notice_id = null, item_id = null, code = null, name = null, model_spec = null, other_features = null, quantity = null, pay_quantity = null, bom_quantity = null, sen_quantity = null, shi_quantity = null, buy_price = null, price = null, inv_unit = null, unit = null } = req.body
  const { id: userId, company_id, name: userName } = req.user;

  const transaction = await sequelize.transaction()
  if(type == 18){
    const product = await SubMaterialBom.findByPk(material_bom_id)
    if(!product) return res.json({ code: 401, message: '该材料bom不存在，请检查' })
    const boms = await SubMaterialBom.findAll({
      where: { company_id, product_id: product.product_id },
      attributes: ['id', 'product_id', 'part_id'],
      include: [
        {
          model: SubMaterialBomChild,
          as: 'children',
          attributes: ['id', 'material_bom_id', 'material_id', 'number', 'is_buy'],
          include: [
            { model: SubMaterialCode, as: 'material', attributes: ['id', 'material_code', 'material_name', 'model', 'other_features', 'usage_unit', 'purchase_unit'] }
          ]
        }
      ],
      order: [['created_at', 'DESC']],
    })
    const bomResult = boms.map(e => e.toJSON())
    const itemIds = bomResult.flatMap(e => {
      return e.children.map(e => e.material_id)
    })
    const children = bomResult.flatMap(e => e.children.map(child => child))
    const content = await SubWarehouseContent.findAll({
      where: { item_id: itemIds, ware_id: 1, house_id, company_id },
      raw: true
    })
    const contentMap = new Map();
    content.forEach(item => {
      contentMap.set(item.item_id, {
        buy_price: Number(item.buy_price || 0),
        price: Number(item.price || 0),
        quantity: Number(item.quantity || 0)
      });
    });
    const data = children.filter(e => contentMap.has(e.material_id)).map(e => {
      const contItem = contentMap.get(e.material_id);
      const totalPrice = PreciseMath.mul(contItem.quantity, contItem.buy_price);
      return {
        company_id,
        user_id: userId,
        procure_id: procure_id || null,
        sale_id: sale_id || null,
        ware_id: ware_id || null,
        house_id: house_id || null,
        operate: operate || null,
        type: 17,
        house_name,
        plan_id: plan_id || null,
        plan,
        notice_id: notice_id || null,
        item_id: e.material_id || null,
        code: e.material?.material_code,
        name: e.material?.material_name,
        model_spec: e.material?.model,
        other_features: e.material?.other_features,
        quantity: contItem.quantity || null,
        pay_quantity: pay_quantity || null,
        bom_quantity: e.number,
        sen_quantity:  contItem.quantity || null,
        shi_quantity: type == 18 ? PreciseMath.mul(contItem.quantity, e.number) : null,
        buy_price: contItem.buy_price || null,
        price: contItem.price || null,
        total_price: totalPrice || null,
        inv_unit: e.material?.usage_unit ? Number(e.material.usage_unit) : null,
        unit: e.material?.purchase_unit ? Number(e.material.purchase_unit) : null,
        is_buying: 1,
        apply_id: userId,
        apply_name: userName,
        step: 0,
        status: 4,
      };
    })
    const applyWhere = { company_id, ware_id, house_id, operate, type: [17, 18], apply_id: userId, status: 4 }
    const applyList = await SubWarehouseApply.findAll({
      where: applyWhere,
      raw: true
    })

    if(applyList.length){
      const result = data.map(item => {
        const matchArr2 = applyList.find(i => i.item_id === item.item_id);
        if(matchArr2?.id){
          return {
            item_id: item.item_id,
            quantity: matchArr2.quantity,
            shi_quantity: type == 18 ? PreciseMath.mul(matchArr2.quantity, matchArr2.bom_quantity) : null,
            id: matchArr2.id,
            ...item
          };
        }else{
          return item
        }
      });
    }

    try {
      const updata = ['company_id', 'user_id', 'procure_id', 'sale_id', 'ware_id', 'house_id', 'operate', 'type', 'house_name', 'plan_id', 'plan', 'notice_id', 'item_id', 'code', 'name', 'model_spec', 'other_features', 'quantity', 'pay_quantity', 'bom_quantity', 'sen_quantity', 'shi_quantity', 'buy_price', 'price', 'total_price', 'inv_unit', 'unit', 'is_buying', 'apply_id', 'apply_name', 'step', 'status']
      await SubWarehouseApply.bulkCreate(data, { updateOnDuplicate: updata, transaction })
      await transaction.commit();

      res.json({ code: 200, message: '新增成功' })
    } catch (error) {
      if(transaction) await transaction.rollback();
      console.log(error);
    }
  }else{
    const isType = Number(type)
    // 入库操作
    if([4,5,6,10,11,12,13].includes(isType)){
      const total_price = buy_price && quantity ? PreciseMath.mul(quantity, buy_price) : 0
      const obj = {
        company_id,
        user_id: userId,
        procure_id: procure_id || null,
        sale_id: sale_id || null,
        ware_id: ware_id || null,
        house_id: house_id || null,
        operate: operate || null,
        type: type || null,
        house_name,
        plan_id: plan_id || null,
        plan,
        notice_id: notice_id || null,
        item_id: item_id || null,
        code,
        name,
        model_spec,
        other_features,
        quantity: quantity || null,
        pay_quantity: pay_quantity || null,
        bom_quantity: bom_quantity || null,
        sen_quantity: null,
        shi_quantity: null,
        buy_price: buy_price || null,
        price: price || null,
        total_price: total_price || null,
        inv_unit: inv_unit || null,
        unit: unit || null,
        is_buying: 1,
        apply_id: userId,
        apply_name: userName,
        step: 0,
        status: 4
      }
      try {
        await SubWarehouseApply.create(obj, { transaction })
        await transaction.commit();

        res.json({ code: 200, message: '新增成功' })
      } catch (error) {
        if(transaction) await transaction.rollback();
        console.log(error);
      }
    }else{
      const content = await SubWarehouseContent.findOne({
        where: { item_id, company_id },
        raw: true
      })
      if(!content && content.quantity <= 0) return res.json({ code: 401, message: '库存不足，请检查后再操作' })

      const obj = {
        company_id,
        user_id: userId,
        procure_id: procure_id || null,
        sale_id: sale_id || null,
        ware_id: ware_id || null,
        house_id: house_id || null,
        operate: operate || null,
        type: type || null,
        house_name,
        plan_id: plan_id || null,
        plan,
        notice_id: notice_id || null,
        item_id: item_id || null,
        code,
        name,
        model_spec,
        other_features,
        quantity: quantity || null,
        pay_quantity: pay_quantity || content.pay_quantity || null,
        bom_quantity: bom_quantity || content.bom_quantity || null,
        sen_quantity: null,
        shi_quantity: null,
        buy_price: buy_price || content.buy_price || null,
        price: price || content.price || null,
        inv_unit: inv_unit || content.inv_unit || null,
        unit: unit || content.unit || null,
        is_buying: 1,
        apply_id: userId,
        apply_name: userName,
        step: 0,
        status: 4
      }
      obj.total_price = obj.buy_price && obj.quantity ? PreciseMath.mul(obj.quantity, obj.buy_price) : 0
      try {
        await SubWarehouseApply.create(obj, { transaction })
        await transaction.commit();

        res.json({ code: 200, message: '新增成功' })
      } catch (error) {
        if(transaction) await transaction.rollback();
        console.log(error);
      }
    }
  }
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
  const mentResult = await SubWarehouseApply.findAll({
    where: {
      id: data,
      company_id
    },
    attributes: ['id', 'status', 'apply_time']
  })
  const mentData = mentResult.map(e => {
    const item = e.toJSON()
    item.status = 0
    item.apply_time = now
    return item
  })
  let transaction
  try {
    transaction = await sequelize.transaction()
    await SubWarehouseApply.bulkCreate(mentData, { updateOnDuplicate: ['status', 'apply_time'], transaction })

    const resData = data.flatMap(e => {
      return stepList.map(o => {
        const { id, ...newData } = o;
        return {
          ...newData,
          source_id: e,
          user_time: null,
          status: 0,
        }
      })
    })
    const statusData = resData.filter(o => o.status == 4)
    if(statusData.length){
      await SubApprovalUser.bulkCreate(resData, {
        updateOnDuplicate: ['user_id', 'user_name', 'type', 'step', 'company_id', 'source_id', 'user_time', 'status'],
        transaction
      })
    }
    await transaction.commit()
    res.json({ message: '提交成功', code: 200 });
  } catch (error) {
    if(transaction) await transaction.rollback();
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
  const { id, ware_id, house_id, house_name, operate, type, plan_id, plan, item_id, code, name, model_spec, other_features, quantity, pay_quantity, buy_price, unit, inv_unit, procure_id, sale_id } = req.body;
  const { id: userId, company_id } = req.user;

  const result = await SubWarehouseApply.findByPk(id)
  const operateName = operate == 1 ? '入库' : '出库'
  if(!result) res.json({ message: `未找到该${operateName}信息`, code: 401 })
  
  const total_price = PreciseMath.mul(quantity, buy_price)
  const obj = {
    ware_id, house_id, house_name, operate, type, plan_id, plan, item_id, code, name, model_spec, other_features, quantity, pay_quantity, buy_price, unit, inv_unit, total_price, procure_id, sale_id, company_id,
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
    offset,
  })
  const totalPages = Math.ceil(count / pageSize)
  const fromData = rows.map(e => e.toJSON())
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
      { model: SubWarehouseApply, as: 'order', attributes: ['id', 'procure_id', 'operate', 'type', 'plan', 'code', 'name', 'quantity', 'pay_quantity', 'model_spec', 'other_features', 'buy_price', 'total_price', 'apply_name', 'apply_time', 'order_id', 'unit', 'inv_unit'] }
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

/**
 * @swagger
 * /api/getWareHouseMaterialUnit:
 *   post:
 *     summary: 获取仓库中某个材料的单位
 *     tags:
 *       - 仓库管理(WareHouse)
 *     parameters:
 *       - name: id
 *         schema:
 *           type: int
 */
router.get('/getWareHouseMaterialUnit', authMiddleware, async (req, res) => {
  const { id } = req.query
  const { id: userId, company_id } = req.user;

  const result = await SubWarehouseContent.findOne({
    where: { item_id: id, company_id },
    attributes: ['unit', 'inv_unit'],
    raw: true
  })
  if(result){
    res.json({ code: 200, data: { unit: Number(result.unit), inv_unit: Number(result.inv_unit) } })
  }else{
    res.json({ code: 200, data: null })
  }
})

/**
 * @swagger
 * /api/getWareHouseInventory:
 *   post:
 *     summary: 仓库盘点
 *     tags:
 *       - 仓库管理(WareHouse)
 *     parameters:
 *       - name: id
 *         schema:
 *           type: int
 */
router.post('/getWareHouseInventory', authMiddleware, async (req, res) => {
  const { ware_id, house_id, operateId, typeId, item_id, dateTime } = req.body
  const { id: userId, company_id } = req.user;

  const where = {
    company_id,
    house_id,
  }
  if(ware_id) where.ware_id = ware_id
  if(operateId) where.operate = operateId
  if(typeId) where.type = typeId
  if(item_id) where.item_id = item_id
  const [houseApply, houseContent] = await Promise.all([
    SubWarehouseApply.findAll({
      where: {
        ...where,
        created_at: {
          [Op.between]: [new Date(dateTime[0]), new Date(dateTime[1])]
        }
      },
      attributes: ['id', 'house_id', 'ware_id', 'operate', 'type', 'house_name', 'plan_id', 'plan', 'notice_id', 'item_id', 'code', 'name', 'model_spec', 'other_features', 'quantity', 'price', 'inv_unit']
    }),
    SubWarehouseContent.findAll({
      where,
      attributes: ['id', 'house_id', 'item_id', 'quantity']
    })
  ])
  const data = houseApply.map(e => e.toJSON())
  const data2 = houseContent.map(e => e.toJSON())

  const quantityMap = data2.reduce((map, item) => {
    map[item.item_id] = item.quantity;
    return map;
  }, {});
  const resultArr = data.map(item => {
    return {
      ...item, // 保留原字段
      pan: quantityMap[item.item_id] ?? null // 无匹配则赋值null，可改为0/''等
    };
  });

  const grouped = resultArr.reduce((acc, curr) => {
    const key = curr.item_id;
    if (!acc[key]) {
      acc[key] = {...curr, quantity_in: 0, quantity_out: 0};
    }

    if (curr.operate === 1) {
      acc[key].quantity_in += curr.quantity;
    } else if (curr.operate === 2) {
      acc[key].quantity_out += curr.quantity;
    }
    if(!typeId){
      acc[key].type = ''
    }

    acc[key].price = curr.price;

    return acc;
  }, {});
  const dataValue = Object.values(grouped);

  res.json({ code: 200, data: dataValue })
})

module.exports = router;