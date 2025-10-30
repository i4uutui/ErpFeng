const express = require('express');
const router = express.Router();
const { SubRateWage, Op, SubProductCode, SubPartCode, SubProcessCode, SubProcessBomChild, SubEmployeeInfo, SubWarehouseApply, SubNoEncoding, SubMaterialMent, SubSaleOrder, SubOutsourcingOrder, SubProductNotice, SubProcessBom } = require('../models')
const authMiddleware = require('../middleware/auth');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const { formatArrayTime, formatObjectTime } = require('../middleware/formatTime');

/**
 * @swagger
 * /api/rate_wage:
 *   get:
 *     summary: 员工计件工资
 *     tags:
 *       - 财务管理(Finance)
 *     parameters:
 *       - name: page
 *         schema:
 *           type: int
 *       - name: pageSize
 *         schema:
 *           type: int
 *       - name: created_at
 *         schema:
 *           type: array
 */
router.get('/rate_wage', authMiddleware, async (req, res) => {
  const { page = 1, pageSize = 10 } = req.query;
  const offset = (page - 1) * pageSize;
  const { company_id } = req.user;
  const created_at = req.query['created_at[]']
  
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
    distinct: true,
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

/**
 * @swagger
 * /api/getReceivablePrice:
 *   get:
 *     summary: 应收货款/应付货款(材料)
 *     tags:
 *       - 财务管理(Finance)
 *     parameters:
 *       - name: page
 *         schema:
 *           type: int
 *       - name: pageSize
 *         schema:
 *           type: int
 *       - name: created_at
 *         schema:
 *           type: array
 */
router.get('/getReceivablePrice', authMiddleware, async (req, res) => {
  const { page = 1, pageSize = 10, type } = req.query;
  const offset = (page - 1) * pageSize;
  const { company_id } = req.user;
  const created_at = req.query['created_at[]']

  let whereObj = {}
  if(type) whereObj.type = type
  const { count, rows } = await SubWarehouseApply.findAndCountAll({
    where: {
      company_id,
      created_at: {
        [Op.between]: [new Date(created_at[0]), new Date(created_at[1])] // 使用 between 筛选范围
      },
      ...whereObj
    },
    attributes: ['id', 'print_id', 'company_id', 'buyPrint_id', 'sale_id', 'ware_id', 'house_id', 'operate', 'type', 'house_name', 'plan_id', 'plan', 'item_id', 'code', 'name', 'model_spec', 'other_features', 'quantity', 'buy_price', 'total_price', 'created_at'],
    include: [
      { model: SubNoEncoding, as: 'print', attributes: ['id', 'no', 'print_type'] },
      { model: SubNoEncoding, as: 'buyPrint', attributes: ['id', 'no', 'print_type'] },
      { model: SubMaterialMent, as: 'buy', attributes: ['id', 'print_id'], include: [ { model: SubNoEncoding, as: 'print', attributes: ['id', 'no', 'print_type'] } ] },
      { model: SubSaleOrder, as: 'sale', attributes: ['id', 'customer_order'] }
    ],
    order: [['created_at', 'DESC']],
    distinct: true,
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
})

/**
 * @swagger
 * /api/getOutSourcingPrice:
 *   get:
 *     summary: 应该付货款(委外)
 *     tags:
 *       - 财务管理(Finance)
 *     parameters:
 *       - name: page
 *         schema:
 *           type: int
 *       - name: pageSize
 *         schema:
 *           type: int
 *       - name: created_at
 *         schema:
 *           type: array
 */
router.get('/getOutSourcingPrice', authMiddleware, async (req, res) => {
  const { page = 1, pageSize = 10, type } = req.query;
  const offset = (page - 1) * pageSize;
  const { company_id } = req.user;
  const created_at = req.query['created_at[]']

  let whereObj = {}
  if(type) whereObj.type = type
  const { count, rows } = await SubWarehouseApply.findAndCountAll({
    where: {
      company_id,
      created_at: {
        [Op.between]: [new Date(created_at[0]), new Date(created_at[1])] // 使用 between 筛选范围
      },
      ...whereObj
    },
    attributes: ['id', 'print_id', 'company_id', 'buyPrint_id', 'sale_id', 'ware_id', 'house_id', 'operate', 'type', 'house_name', 'plan_id', 'plan', 'item_id', 'code', 'name', 'model_spec', 'other_features', 'quantity', 'buy_price', 'total_price', 'created_at'],
    include: [
      { model: SubNoEncoding, as: 'print', attributes: ['id', 'no', 'print_type'] },
      { model: SubNoEncoding, as: 'buyPrint', attributes: ['id', 'no', 'print_type'] },
      {
        model: SubOutsourcingOrder,
        as: 'sourcing',
        attributes: ['id', 'print_id', 'ment'],
        include: [
          { model: SubProductNotice, as: 'notice', attributes: ['id', 'notice'] },
          {
            model: SubProcessBom,
            as: 'processBom',
            attributes: ['id', 'product_id', 'part_id'],
            include: [
              { model: SubPartCode, as: 'part', attributes: ['id', 'part_name', 'part_code'] },
            ]
          },
          {
            model: SubProcessBomChild,
            as: 'processChildren',
            attributes: ['id', 'process_bom_id', 'process_id', 'equipment_id'],
            include: [
              { model: SubProcessCode, as: 'process', attributes: ['id', 'process_code', 'process_name'] },
            ]
          }
        ]
      }
    ],
    order: [['created_at', 'DESC']],
    distinct: true,
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
})

module.exports = router;    