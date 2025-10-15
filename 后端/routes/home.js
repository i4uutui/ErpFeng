const express = require('express');
const router = express.Router();
const { Op, SubDateInfo, SubApprovalUser, SubSaleOrder, SubProductQuotation, SubProductNotice } = require('../models')
const authMiddleware = require('../middleware/auth');

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
 *     summary: 保存日期
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

router.get('/order_total', authMiddleware, async (req, res) => {
  const { company_id } = req.user;
  const created_at = req.query['created_at[]']

  const [saleOrder, productQuotation, productNotice] = await Promise.all([
    SubSaleOrder.count({ 
      where: { company_id, created_at: { [Op.between]: [new Date(created_at[0]), new Date(created_at[1])] } }
    }),
    SubProductQuotation.count({ 
      where: { company_id, created_at: { [Op.between]: [new Date(created_at[0]), new Date(created_at[1])] } }
    }),
    SubProductNotice.findAll({ 
      where: { company_id, created_at: { [Op.between]: [new Date(created_at[0]), new Date(created_at[1])] } }
    })
  ])
  const result = productNotice.map(e => e.toJSON())
  const noticeFinish = result.filter(e => e.isFinish == 0)
  res.json({ code: 200, data: { saleOrder, productQuotation, notice: result.length, noticeFinish: noticeFinish.length } })
})
module.exports = router;