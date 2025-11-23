const express = require('express');
const dayjs = require('dayjs')
const router = express.Router();
const { Op, SubDateInfo, SubApprovalUser, SubProductNotice, SubProductionProgress, SubSaleOrder, SubWarehouseApply, SubProgressBase } = require('../models')
const authMiddleware = require('../middleware/auth');
const { PreciseMath, getSaleCancelIds } = require('../middleware/tool');

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

  function mergeByTypeAndSourceId(data) {
    const map = new Map();
    data.forEach(item => {
      // 创建一个唯一的键，例如 "purchase_order_1"
      const key = `${item.type}_${item.source_id}`;
      // 如果 Map 中没有这个键，就添加它，并将当前项作为值
      if (!map.has(key)) {
        map.set(key, item);
      }
      // 如果已经存在，我们什么都不用做，这样就保留了第一次出现的项
    });
    // 将 Map 的值转换回数组
    return Array.from(map.values());
  }
  const mergedArr = mergeByTypeAndSourceId(data);
  
  const materialMent = mergedArr.filter(o => o.type == 'purchase_order').length
  const outsourcingOrder = mergedArr.filter(o => o.type == 'outsourcing_order').length
  const materialOrder = mergedArr.filter(o => o.type == 'material_warehouse').length
  const productOrder = data.filter(o => o.type == 'product_warehouse').length
mergedArr
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
      // is_notice: 0, // 已排产
      is_finish: 1, // 未完结
      // 结案时间 = 数据最后的修改时间
      // updated_at: {
      //   [Op.between]: [new Date(time[0]), new Date(time[1])] // 使用 between 筛选范围
      // }
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

  // 统计延期订单
  const noticeIds = await getSaleCancelIds('notice_id', { company_id })
  const Progress = await SubProgressBase.findAll({
    where: {
      company_id,
      notice_id: { [Op.notIn]: noticeIds },
      is_finish: 1,
      is_deleted: 1,
      // created_at: {
      //   [Op.between]: [new Date(time[0]), new Date(time[1])] // 使用 between 筛选范围
      // }
    },
    attributes: ['id'],
    include: [
      { model: SubProductNotice, as: 'notice', attributes: ['id', 'notice', 'delivery_time'] },
    ],
    order: [['id', 'ASC']]
  })
  let progressLeng = 0
  Progress.forEach(e => {
    const item = e.toJSON()
    const notice = item.notice

    const isDay = dayjs(notice.delivery_time).isAfter(dayjs(), 'day')
    if(!isDay){
      progressLeng++
    }
  })

  res.json({ code: 200, data: { saleLeng, noticeLeng, progressLeng, inventory } })
})
module.exports = router;