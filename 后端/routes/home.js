const express = require('express');
const router = express.Router();
const { Op, SubDateInfo, SubApprovalUser, SubProductNotice, SubProductionProgress, SubSaleOrder, SubWarehouseApply } = require('../models')
const authMiddleware = require('../middleware/auth');
const { PreciseMath } = require('../middleware/tool');

/**
 * @swagger
 * /admin/special-dates:
 *   get:
 *     summary: 获取所有特殊日期
 *     tags:
 *       - 首页接口(Home)
 */
router.get('/special-dates', authMiddleware, async (req, res) => {
  const { company_id } = req.user;

  const dates = await SubDateInfo.findAll({
    where: { company_id },
    attributes: ['id', 'date'],
    order: [['date', 'ASC']]
  });
  
  // 转换为前端需要的格式
  const formattedDates = dates.map(date => ({
    id: date.id,
    date: date.date
  }));
  
  res.json({ data: formattedDates, code: 200 });
})

/**
 * @swagger
 * /admin/special-dates:
 *   post:
 *     summary: 日历保存日期
 *     tags:
 *       - 首页接口(Home)
 *     parameters:
 *       - name: dates
 *         schema:
 *           type: Array
 */
router.post('/special-dates', authMiddleware, async (req, res) => {
  const { dates } = req.body;
  const { company_id } = req.user;
  
  if (!dates || !Array.isArray(dates)) return res.json({ code: 401, message: '请选择日期' });

  const result = await SubDateInfo.findAll({
    where: { company_id },
  });
  // 先删除现有
  if(result.length){
    await SubDateInfo.destroy({ where: { company_id } });
  }
  // 再添加新的
  const data = dates.map(item => ({ date: item.date, company_id }))
  await SubDateInfo.bulkCreate(data, {
    updateOnDuplicate: ['date', 'company_id']
  });

  res.json({ msg: '添加成功', code: 200 });
})

/**
 * @swagger
 * /admin/statistics:
 *   get:
 *     summary: 待办事项
 *     tags:
 *       - 首页接口(Home)
 */
router.get('/statistics', authMiddleware, async (req, res) => {
  const { id: userId, company_id, type } = req.user;

  const where = {
    company_id, 
    status: 0,
  }
  if(type == 2) where.user_id = userId
  const result = await SubApprovalUser.findAll({ where })
  const data = result.map(o => o.toJSON())

  const materialMent = data.filter(o => o.type == 'purchase_order').length
  const outsourcingOrder = data.filter(o => o.type == 'outsourcing_order').length
  const materialOrder = data.filter(o => o.type == 'material_warehouse').length
  const productOrder = data.filter(o => o.type == 'product_warehouse').length

  res.json({ data: { materialMent, outsourcingOrder, materialOrder, productOrder }, code: 200 })
})

/**
 * @swagger
 * /admin/order_total:
 *   get:
 *     summary: 订单统计
 *     tags:
 *       - 首页接口(Home)
 */
router.post('/order_total', authMiddleware, async (req, res) => {
  const { time } = req.body
  const { company_id } = req.user;

  // 统计在线订单
  const saleOrder = await SubSaleOrder.findAll({
    where: {
      company_id,
      delivery_time: {
        [Op.between]: [new Date(time[0]), new Date(time[1])] // 使用 between 筛选范围
      }
    },
    attributes: ['id']
  })
  const saleLeng = saleOrder.length ? saleOrder.length : 0

  // 完成订单
  const notice = await SubProductNotice.findAll({
    where: {
      company_id,
      is_finish: 0,
      // 结案时间 = 数据最后的修改时间
      updated_at: {
        [Op.between]: [new Date(time[0]), new Date(time[1])] // 使用 between 筛选范围
      }
    },
    attributes: ['id']
  })
  const noticeLeng = notice.length ? notice.length : 0

  // 统计订单存量，进度表的总订单数量 - 已出库的数量
  // 先找到进度表里的订单数量，注意，是订单数量，不是进度条数量
  const notice2 = await SubProductNotice.findAll({
    where: {
      company_id,
      is_notice: 0, // 已排产
      is_finish: 1, // 未完结
      // 结案时间 = 数据最后的修改时间
      updated_at: {
        [Op.between]: [new Date(time[0]), new Date(time[1])] // 使用 between 筛选范围
      }
    },
    attributes: ['id', 'sale_id'],
    include: [{ model: SubSaleOrder, as: 'sale', attributes: ['id', 'order_number'], required: true }]
  })
  const noticeResult = notice2.map(item => item.toJSON());
  // 统计总订单量
  const totalOrderNumber = noticeResult.reduce((sum, item) => {
    const orderNum = Number(item.sale?.order_number);
    return isNaN(orderNum) ? sum : PreciseMath.add(sum, orderNum);
  }, 0);
  // 提取销售ID
  const saleIds = noticeResult.map(item => item.sale_id).filter(Boolean); // 过滤无效 sale_id
  let inventory = 0;
  if(saleIds.length){
    const warehouseApplies = await SubWarehouseApply.findAll({
      where: {
        sale_id: saleIds,
        company_id,
        type: 14
      },
      attributes: ['quantity']
    })
    const totalOutQuantity = warehouseApplies.reduce((sum, apply) => {
      const quantity = Number(apply.quantity);
      return isNaN(quantity) ? sum : PreciseMath.add(sum, quantity);
    }, 0);
    inventory = PreciseMath.sub(totalOrderNumber, totalOutQuantity)
  }

  res.json({ code: 200, data: { saleLeng, noticeLeng, inventory } })
})
module.exports = router;