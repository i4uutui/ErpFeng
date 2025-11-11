const express = require('express');
const router = express.Router();
const { SubRateWage, Op, SubProductCode, SubPartCode, SubProcessCode, SubProcessBomChild, SubEmployeeInfo, SubWarehouseApply, SubNoEncoding, SubMaterialMent, SubSaleOrder, SubOutsourcingOrder, SubProductNotice, SubProcessBom, SubProcessCycle, SubSupplierInfo, SubCustomerInfo, SubProgressBase, SubProgressWork } = require('../models')
const authMiddleware = require('../middleware/auth');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const { formatArrayTime, formatObjectTime } = require('../middleware/formatTime');
const { PreciseMath } = require('../middleware/tool')

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
router.post('/rate_wage', authMiddleware, async (req, res) => {
  const { page = 1, pageSize = 10, created_at, employee_id, name, cycle_id } = req.body;
  const offset = (page - 1) * pageSize;
  const { company_id } = req.user;
  
  let where = {
    company_id,
    created_at: {
      [Op.between]: [new Date(created_at[0]), new Date(created_at[1])] // 使用 between 筛选范围
    }
  }
  let whereObj = {}
  if(employee_id) where.employee_id = { [Op.like]: `%${employee_id}%` }
  if(name) where.name = { [Op.like]: `%${name}%` }
  if(cycle_id) whereObj.cycle_id = { [Op.like]: `%${cycle_id}%` }
  const { count, rows } = await SubRateWage.findAndCountAll({
    where,
    attributes: ['id', 'bom_child_id', 'product_id', 'part_id', 'process_id', 'number', 'created_at', 'notice_id', 'status', 'progress_id'],
    include: [
      { model: SubProductNotice, as: 'notice', attributes: ['id', 'notice'] },
      { model: SubProductCode, as: 'product', attributes: ['id', 'product_code', 'product_name', 'drawing'] },
      { model: SubPartCode, as: 'part', attributes: ['id', 'part_code', 'part_name'] },
      { model: SubProcessCode, as: 'process', attributes: ['id', 'process_code', 'process_name'] },
      { model: SubProcessBomChild, as: 'bomChildren', attributes: ['id', 'notice_id', 'notice', 'price'] },
      {
        model: SubEmployeeInfo,
        as: 'menber',
        where: whereObj,
        attributes: ['id', 'name', 'cycle_id', 'employee_id'],
        include: [
          { model: SubProcessCycle, as: 'cycle', attributes: ['id', 'name'] }
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
});

/**
 * @swagger
 * /api/rateWageConfirm:
 *   post:
 *     summary: 员工工资确认按钮
 *     tags:
 *       - 财务管理(Finance)
 *     parameters:
 *       - name: status
 *         schema:
 *           type: int
 */
router.post('/rateWageConfirm', authMiddleware, async (req, res) => {
  const { status, id } = req.body
  const { company_id } = req.user

  const result = await SubRateWage.update({ status }, { where: { id, company_id } })

  res.json({ code: 200, message: '操作成功' })
})
/**
 * @swagger
 * /api/decreaseNumber:
 *   post:
 *     summary: 修改员工递减数量
 *     tags:
 *       - 财务管理(Finance)
 *     parameters:
 *       - name: status
 *         schema:
 *           type: int
 */
router.post('/decreaseNumber', authMiddleware, async (req, res) => {
  const { id, progress_id, bom_child_id, sub_number } = req.body

  if(!sub_number) return res.json({ code: 401, message: '数量不能为空' })

  const rateWage = await SubRateWage.findByPk(id)
  const progress = await SubProgressWork.findOne({
    where: {
      progress_id,
      child_id: bom_child_id
    }
  })
  const rateWageData = rateWage.toJSON()
  const progressData = progress.toJSON()
  
  const subNumber = Number(sub_number)

  const remain = PreciseMath.sub(Number(rateWageData.number), subNumber)
  rateWage.update({ number: remain }, { where: { id } })

  const finish = PreciseMath.sub(progressData.finish, subNumber)
  const order_number = PreciseMath.add(progressData.order_number, subNumber)
  SubProgressWork.update({ finish, order_number }, { where: { progress_id, child_id: bom_child_id } })

  res.json({ code: 200, message: '修改成功' })
})

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
router.post('/getReceivablePrice', authMiddleware, async (req, res) => {
  const { page = 1, pageSize = 10, created_at, type, customer_code, customer_abbreviation, supplier_code, supplier_abbreviation } = req.body;
  const offset = (page - 1) * pageSize;
  const { company_id } = req.user;

  let where = {
    company_id,
    type: type,
    created_at: {
      [Op.between]: [new Date(created_at[0]), new Date(created_at[1])] // 使用 between 筛选范围
    },
  }
  let whereOjb = {}
  if(customer_code) whereOjb.customer_code = { [Op.like]: `%${customer_code}%` }
  if(customer_abbreviation) whereOjb.customer_abbreviation = { [Op.like]: `%${customer_abbreviation}%` }
  if(supplier_code) whereOjb.supplier_code = { [Op.like]: `%${supplier_code}%` }
  if(supplier_abbreviation) whereOjb.supplier_abbreviation = { [Op.like]: `%${supplier_abbreviation}%` }

  let includeObj = [
    { model: SubNoEncoding, as: 'print', attributes: ['id', 'no', 'print_type'] },
    { model: SubNoEncoding, as: 'buyPrint', attributes: ['id', 'no', 'print_type'] },
    { model: SubMaterialMent, as: 'buy', attributes: ['id', 'print_id'], include: [ { model: SubNoEncoding, as: 'print', attributes: ['id', 'no', 'print_type'] } ] },
    { model: SubSaleOrder, as: 'sale', attributes: ['id', 'customer_order'] },
  ]
  if(type == 14){
    includeObj.push({ model: SubCustomerInfo, as: 'customer', where: whereOjb, attributes: ['id', 'customer_code', 'customer_abbreviation'] })
  }else{
    includeObj.push({ model: SubSupplierInfo, as: 'supplier', where: whereOjb, attributes: ['id', 'supplier_code', 'supplier_abbreviation'] })
  }

  const { count, rows } = await SubWarehouseApply.findAndCountAll({
    where,
    attributes: ['id', 'print_id', 'company_id', 'buyPrint_id', 'sale_id', 'ware_id', 'house_id', 'operate', 'type', 'house_name', 'plan_id', 'plan', 'item_id', 'code', 'name', 'model_spec', 'other_features', 'quantity', 'buy_price', 'total_price', 'created_at'],
    include: includeObj,
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
router.post('/getOutSourcingPrice', authMiddleware, async (req, res) => {
  const { page = 1, pageSize = 10, created_at, type, supplier_code, supplier_abbreviation } = req.body;
  const offset = (page - 1) * pageSize;
  const { company_id } = req.user;

  let where = {
    company_id,
    type: type,
    created_at: {
      [Op.between]: [new Date(created_at[0]), new Date(created_at[1])] // 使用 between 筛选范围
    },
  }
  let whereOjb = {}
  if(supplier_code) whereOjb.supplier_code = { [Op.like]: `%${supplier_code}%` }
  if(supplier_abbreviation) whereOjb.supplier_abbreviation = { [Op.like]: `%${supplier_abbreviation}%` }

  const { count, rows } = await SubWarehouseApply.findAndCountAll({
    where,
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
      },
      { model: SubSupplierInfo, as: 'supplier', where: whereOjb, attributes: ['id', 'supplier_code', 'supplier_abbreviation'] }
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