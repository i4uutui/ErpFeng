const express = require('express');
const router = express.Router();
const { SubRateWage, Op, SubProductCode, SubPartCode, SubProcessCode, SubProcessBomChild, SubEmployeeInfo } = require('../models')
const authMiddleware = require('../middleware/auth');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const { formatArrayTime, formatObjectTime } = require('../middleware/formatTime');

router.post('/rate_wage', authMiddleware, async (req, res) => {
  const { page = 1, pageSize = 10, created_at } = req.body;
  const offset = (page - 1) * pageSize;
  const { company_id } = req.user;
  
  const { count, rows } = await SubRateWage.findAndCountAll({
    where: {
      company_id,
      created_at: {
        [Op.between]: [new Date(created_at[0]), new Date(created_at[1])] // 使用 between 筛选范围
      }
    },
    include: [
      { model: SubProductCode, as: 'product', attributes: ['id', 'product_code', 'product_name', 'drawing'] },
      { model: SubPartCode, as: 'part', attributes: ['id', 'part_code', 'part_name'] },
      { model: SubProcessCode, as: 'process', attributes: ['id', 'process_code', 'process_name'] },
      { model: SubProcessBomChild, as: 'bomChildren', attributes: ['id', 'notice_id', 'notice', 'price'] },
      { model: SubEmployeeInfo, as: 'menber', attributes: ['id', 'name', 'cycle_id', 'cycle_name', 'employee_id'] }
    ],
    order: [['created_at', 'DESC']],
    limit: parseInt(pageSize),
    offset
  })

  const totalPages = Math.ceil(count / pageSize);
  const row = rows.map(e => e.toJSON())
  // 返回所需信息
  res.json({ 
    data: formatArrayTime(row), 
    total: count, 
    totalPages, 
    currentPage: parseInt(page), 
    pageSize: parseInt(pageSize),
    code: 200 
  });
});

module.exports = router;    