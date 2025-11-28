const express = require('express');
const { SubCustomerInfo, Op, SubSupplierInfo, SubConstUser, SubConstType } = require('../models');
const { formatArrayTime } = require('../middleware/formatTime');
const authMiddleware = require('../middleware/auth');
const router = express.Router();

/**
 * @swagger
 * /api/get_const_type:
 *   get:
 *     summary: 获取常量类型列表
 *     tags:
 *       - 系统设置(Setting)
 */
router.get('/get_const_type', authMiddleware, async (req, res) => {
  const result = await SubConstType.findAll({ raw: true, order: [['type', 'ASC']] })

  res.json({ code: 200, data: result })
})

/**
 * @swagger
 * /api/const_user:
 *   get:
 *     summary: 获取用户新增的常量列表
 *     tags:
 *       - 系统设置(Setting)
 */
router.get('/const_user', authMiddleware, async (req, res) => {
  const { page = 1, pageSize = 10, name } = req.query
  const offset = (page - 1) * pageSize;
  const { company_id } = req.user;

  let where = { company_id }
  if(name) where.name = { [Op.like]: `%${name}%` }

  const { count, rows } = await SubConstUser.findAndCountAll({
    where,
    attributes: ['id', 'type', 'name', 'status'],
    order: [
      ['constType', 'type', 'ASC'],
      ['constType', 'id', 'ASC'],
      ['id', 'ASC'],
    ],
    include: [
      { model: SubConstType, as: 'constType', attributes: ['id', 'type', 'name'] }
    ],
    limit: parseInt(pageSize),
    offset
  })

  const totalPages = Math.ceil(count / pageSize);

  res.json({ 
    data: rows && rows.length ? rows : [],
    total: count, 
    totalPages, 
    currentPage: parseInt(page), 
    pageSize: parseInt(pageSize),
    code: 200
  })
})

/**
 * @swagger
 * /api/const_user:
 *   post:
 *     summary: 用户新增的常量
 *     tags:
 *       - 系统设置(Setting)
 */
router.post('/const_user', authMiddleware, async (req, res) => {
  const { type, name, status } = req.body;
  const { id: userId, company_id } = req.user

  const required = ['type', 'name'];
  const empty = required.filter(key => !req.body[key]);
  if (empty.length > 0) {
    return res.json({ code: 401, message: '必填项缺失' });
  }

  const exist = await SubConstUser.findOne({
    where: { company_id, type, name }
  });
  if (exist) {
    return res.json({ code: 401, message: '该常量名称已存在' });
  }

  await SubConstUser.create({ type, name, status, company_id, user_id: userId })

  res.json({ code: 200, message: '新增成功' });
})

/**
 * @swagger
 * /api/const_user:
 *   put:
 *     summary: 修改用户的常量
 *     tags:
 *       - 系统设置(Setting)
 */
router.put('/const_user', authMiddleware, async (req, res) => {
  const { id, type, name, status } = req.body;

  if(!id){
    return res.json({ code: 401, message: 'ID不能为空' });
  }
  const required = ['type', 'name'];
  const empty = required.filter(key => !req.body[key]);
  if (empty.length > 0) {
    return res.json({ code: 401, message: '必填项缺失' });
  }

  await SubConstUser.update({ type, name, status }, { where: { id } });
  res.json({ code: 200, msg: '编辑成功' });
})

/**
 * @swagger
 * /api/customer_info:
 *   get:
 *     summary: 获取客户信息列表（分页）
 *     tags:
 *       - 系统设置(Setting)
 */
router.get('/customer_info', authMiddleware, async (req, res) => {
  const { page = 1, pageSize = 10, customer_code, customer_abbreviation } = req.query;
  const offset = (page - 1) * pageSize;
  const { company_id } = req.user;
  
  let whereObj = {}
  if(customer_code) whereObj.customer_code = { [Op.like]: `%${customer_code}%` }
  if(customer_abbreviation) whereObj.customer_abbreviation = { [Op.like]: `%${customer_abbreviation}%` }
  const { count, rows } = await SubCustomerInfo.findAndCountAll({
    where: {
      is_deleted: 1,
      company_id,
    },
    attributes: ['id', "customer_code", "customer_abbreviation", "contact_person", "contact_information", "company_full_name", "company_address", "delivery_address", "tax_registration_number", "transaction_method", "transaction_currency", "other_transaction_terms", 'other_text'],
    order: [['customer_code', 'ASC']],
    distinct: true,
    limit: parseInt(pageSize),
    offset
  })
  const totalPages = Math.ceil(count / pageSize)
  
  const fromData = rows.map(item => item.dataValues)
  
  // 返回所需信息
  res.json({ 
    data: formatArrayTime(fromData), 
    total: count, 
    totalPages, 
    currentPage: parseInt(page), 
    pageSize: parseInt(pageSize),
    code: 200 
  });
});

/**
 * @swagger
 * /api/customer_info:
 *   post:
 *     summary: 添加客户信息
 *     tags:
 *       - 系统设置(Setting)
 */
router.post('/customer_info', authMiddleware, async (req, res) => {
  const { customer_code, customer_abbreviation, contact_person, contact_information, company_full_name, company_address, delivery_address, tax_registration_number, transaction_method, transaction_currency, other_transaction_terms, other_text } = req.body;
  const { id: userId, company_id } = req.user;
  
  const rows = await SubCustomerInfo.findAll({
    where: {
      customer_code,
      company_id
    }
  })
  if(rows.length != 0){
    return res.json({ message: '编码不能重复', code: 401 })
  }
  
  const result = await SubCustomerInfo.create({
    customer_code, customer_abbreviation, contact_person, contact_information, company_full_name, company_address, delivery_address, tax_registration_number, transaction_method, transaction_currency, other_transaction_terms, other_text, company_id,
    user_id: userId
  })

  res.json({ message: "添加成功", code: 200 });
});

/**
 * @swagger
 * /api/customer_info:
 *   put:
 *     summary: 更新客户信息接口
 *     tags:
 *       - 系统设置(Setting)
 */
router.put('/customer_info', authMiddleware, async (req, res) => {
  const { customer_code, customer_abbreviation, contact_person, contact_information, company_full_name, company_address, delivery_address, tax_registration_number, transaction_method, transaction_currency, other_transaction_terms, other_text, id } = req.body;
  const { id: userId, company_id } = req.user;
  
  const rows = await SubCustomerInfo.findAll({
    where: {
      customer_code,
      company_id,
      id: {
        [Op.ne]: id
      }
    }
  })
  if(rows.length != 0){
    return res.json({ message: '编码不能重复', code: 401 })
  }
  
  // 更新客户信息
  const updateResult = await SubCustomerInfo.update({
    customer_code, customer_abbreviation, contact_person, contact_information, company_full_name, company_address, delivery_address, tax_registration_number, transaction_method, transaction_currency, other_transaction_terms, other_text, company_id,
    user_id: userId
  }, {
    where: { id }
  })
  if (updateResult.length == 0) {
    return res.json({ message: '未找到该客户信息', code: 404 });
  }
  
  res.json({ message: "修改成功", code: 200 });
});
/**
 * @swagger
 * /api/customer_info/id:
 *   delete:
 *     summary: 删除客户信息
 *     tags:
 *       - 系统设置(Setting)
 */
router.delete('/customer_info/:id', authMiddleware, async (req, res) => {
  const { id } = req.params;
  const { company_id } = req.user
  
  const updateResult = await SubCustomerInfo.update({
    is_deleted: 0
  }, {
    where: {
      is_deleted: 1,
      id,
      company_id
    }
  })
  
  if (updateResult.length == 0) {
    return res.json({ message: '客户信息不存在或已被删除', code: 401 });
  }
  
  res.json({ message: '删除成功', code: 200 });
});


/**
 * @swagger
 * /api/supplier_info:
 *   get:
 *     summary: 获取供应商列表（分页）
 *     tags:
 *       - 系统设置(Setting)
 *     parameters:
 *       - name: page
 *         schema:
 *           type: array
 *       - name: pageSize
 *         schema:
 *           type: string
 */
router.get('/supplier_info', authMiddleware, async (req, res) => {
  const { page = 1, pageSize = 10 } = req.query;
  const offset = (page - 1) * pageSize;
  
  const { company_id } = req.user;
  
  const { count, rows } = await SubSupplierInfo.findAndCountAll({
    where: {
      is_deleted: 1,
      company_id,
    },
    order: [['supplier_code', 'ASC']],
    distinct: true,
    limit: parseInt(pageSize),
    offset
  })
  const totalPages = Math.ceil(count / pageSize)
  
  const fromData = rows.map(item => item.dataValues)
  
  // 返回所需信息
  res.json({ 
    data: formatArrayTime(fromData), 
    total: count, 
    totalPages, 
    currentPage: parseInt(page), 
    pageSize: parseInt(pageSize),
    code: 200 
  });
});

/**
 * @swagger
 * /api/supplier_info:
 *   post:
 *     summary: 添加供应商信息
 *     tags:
 *       - 系统设置(Setting)
 *     parameters:
 *       - name: supplier_code
 *         schema:
 *           type: string
 *       - name: supplier_abbreviation
 *         schema:
 *           type: string
 *       - name: contact_person
 *         schema:
 *           type: string
 *       - name: contact_information
 *         schema:
 *           type: string
 *       - name: supplier_full_name
 *         schema:
 *           type: string
 *       - name: supplier_address
 *         schema:
 *           type: string
 *       - name: supplier_category
 *         schema:
 *           type: string
 *       - name: supply_method
 *         schema:
 *           type: string
 *       - name: transaction_method
 *         schema:
 *           type: string
 *       - name: transaction_currency
 *         schema:
 *           type: string
 *       - name: other_transaction_terms
 *         schema:
 *           type: string
 */
router.post('/supplier_info', authMiddleware, async (req, res) => {
  const { supplier_code, supplier_abbreviation, contact_person, contact_information, supplier_full_name, supplier_address, supplier_category, supply_method, transaction_method, transaction_currency, other_transaction_terms, other_text } = req.body;
  
  const { id: userId, company_id } = req.user;
  
  const rows = await SubSupplierInfo.findAll({
    where: {
      supplier_code,
      company_id
    }
  })
  if(rows.length != 0){
    return res.json({ message: '编码不能重复', code: 401 })
  }
  
  const result = await SubSupplierInfo.create({
    supplier_code, supplier_abbreviation, contact_person, contact_information, supplier_full_name, supplier_address, supplier_category, supply_method, transaction_method, transaction_currency, other_transaction_terms, other_text, company_id,
    user_id: userId
  })

  res.json({ message: "添加成功", code: 200 });
});

/**
 * @swagger
 * /api/supplier_info:
 *   put:
 *     summary: 更新供应商信息接口
 *     tags:
 *       - 系统设置(Setting)
 *     parameters:
 *       - name: id
 *         schema:
 *           type: int
 *       - name: supplier_code
 *         schema:
 *           type: string
 *       - name: supplier_abbreviation
 *         schema:
 *           type: string
 *       - name: contact_person
 *         schema:
 *           type: string
 *       - name: contact_information
 *         schema:
 *           type: string
 *       - name: supplier_full_name
 *         schema:
 *           type: string
 *       - name: supplier_address
 *         schema:
 *           type: string
 *       - name: supplier_category
 *         schema:
 *           type: string
 *       - name: supply_method
 *         schema:
 *           type: string
 *       - name: transaction_method
 *         schema:
 *           type: string
 *       - name: transaction_currency
 *         schema:
 *           type: string
 *       - name: other_transaction_terms
 *         schema:
 *           type: string
 */
router.put('/supplier_info', authMiddleware, async (req, res) => {
  const { supplier_code, supplier_abbreviation, contact_person, contact_information, supplier_full_name, supplier_address, supplier_category, supply_method, transaction_method, transaction_currency, other_transaction_terms, other_text, id } = req.body;
  
  const { id: userId, company_id } = req.user;
  
  const rows = await SubSupplierInfo.findAll({
    where: {
      supplier_code,
      company_id,
      id: {
        [Op.ne]: id
      }
    }
  })
  if(rows.length != 0){
    return res.json({ message: '编码不能重复', code: 401 })
  }
  
  const updateResult = await SubSupplierInfo.update({
    supplier_code, supplier_abbreviation, contact_person, contact_information, supplier_full_name, supplier_address, supplier_category, supply_method, transaction_method, transaction_currency, other_transaction_terms, other_text, company_id,
    user_id: userId
  }, {
    where: { id }
  })
  if (updateResult.length == 0) {
    return res.json({ message: '未找到该供应商信息', code: 404 });
  }
  
  res.json({ message: "修改成功", code: 200 });
});


module.exports = router;