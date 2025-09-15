const express = require('express');
const router = express.Router();
const { SubWarehouseContent, SubWarehouseApply, Op, sequelize } = require('../models')
const authMiddleware = require('../middleware/auth');
const { formatArrayTime, formatObjectTime } = require('../middleware/formatTime');

// 仓库列表
router.get('/getWarehouseStats', authMiddleware, async (req, res) => {
  const { house_id, start_date, end_date, page = 1, pageSize = 10 } = req.query
  const offset = (page - 1) * pageSize;
  const { id: userId, company_id } = req.user;

  const where = {
    company_id,
    is_deleted: 1
  };
  if (house_id) where.house_id = house_id;

  const { count, rows } = await SubWarehouseContent.findAndCountAll({
    where: whereCondition,
    attributes: [
      'id', 'ware_id', 'house_id', 'item_id', 'code', 'name', 'mode', 'other_features', 'unit', 'inv_unit', 'initial', 'number_in', 'number_out', 'number_new', 'price', 'price_total', 'price_in', 'price_out', 'last_in_time', 'last_out_time'
    ],
    limit: parseInt(pageSize),
    offset: parseInt(offset),
    order: [['created_at', 'DESC']]
  });
  // 如果没有指定时间范围，直接返回基础数据
  const dataWare = rows.map(e => e.toJSON())
  if (!start_date || !end_date) {
    return res.json({ 
      data: formatArrayTime(dataWare), 
      total: count, 
      totalPages, 
      currentPage: parseInt(page), 
      pageSize: parseInt(pageSize),
      code: 200 
    });
  }

  const warehouseApply = await SubWarehouseApply.findAll({
    where: {
      company_id,
      house_id,
      status: 1,
      type: [1, 2],
      apply_time: {
        [Op.between]: [new Date(start_date), new Date(end_date)]
      }
    },
    attributes: ['id', 'item_id', 'code', 'name', 'quantity', 'type', 'status'],
  })

  // 将统计数据转换为map
  const statsMap = {};
  warehouseApply.forEach(stat => {
    const mp = stat.toJSON()
    statsMap[mp.item_id] = mp;
  });

  const resultList = dataWare.map(item => {
    const stats = statsMap[item.item_id]
    
    return {
      ...item.toJSON(),
      ...stats
    };
  });
  res.json({
    data: formatArrayTime(resultList), 
    total: count, 
    totalPages, 
    currentPage: parseInt(page), 
    pageSize: parseInt(pageSize),
    code: 200 
  });
})
// 添加初始化仓库数据
router.post('/intHouseContent', authMiddleware, async (req, res) => {
  const { ware_id, house_id, item_id, code, name, mode, other_features, initial, inv_unit, price } = req.body
  const { id: userId, company_id } = req.user;

  await SubWarehouseContent.create({
    ware_id, house_id, item_id, code, name, mode, other_features, initial, inv_unit, price, company_id,
    user_id: userId
  })

  res.json({ message: "添加成功", code: 200 });
})

module.exports = router;