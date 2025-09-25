const express = require('express');
const router = express.Router();
const dayjs = require('dayjs')
const { SubOutsourcingQuote, SubSupplierInfo, SubProcessBom, SubProcessBomChild, SubProcessCode, SubEquipmentCode, SubProductCode, SubPartCode, SubProductNotice, SubSaleOrder, SubOutsourcingOrder, SubApprovalUser, SubApprovalStep, Op } = require('../models');
const authMiddleware = require('../middleware/auth');
const { formatArrayTime, formatObjectTime } = require('../middleware/formatTime');

/**
 * @swagger
 * /api/outsourcing_quote:
 *   post:
 *     summary: 委外报价列表
 *     tags:
 *       - 委外管理(Outsourcing)
 *     parameters:
 *       - name: page
 *         schema:
 *           type: int
 *       - name: pageSize
 *         schema:
 *           type: int
 */
router.post('/outsourcing_quote', authMiddleware, async (req, res) => {
  const { page = 1, pageSize = 10 } = req.body;
  const offset = (page - 1) * pageSize;
  const { company_id } = req.user;
  
  const { count, rows } = await SubOutsourcingQuote.findAndCountAll({
    where: {
      is_deleted: 1,
      company_id,
    },
    include: [
      { model: SubSupplierInfo, as: 'supplier', attributes: ['id', 'supplier_abbreviation', 'supplier_code'] },
      { model: SubProductNotice, as: 'notice', attributes: ['id', 'notice', 'sale_id'], include: [{ model: SubSaleOrder, as: 'sale', attributes: ['id', 'order_number', 'unit', 'delivery_time'] }] },
      {
        model: SubProcessBom,
        as: 'processBom',
        attributes: ['id', 'product_id', 'part_id', 'archive'],
        include: [
          { model: SubProductCode, as: 'product', attributes: ['id', 'product_name', 'product_code', 'drawing', 'model', 'specification'] },
          { model: SubPartCode, as: 'part', attributes: ['id', 'part_name', 'part_code'] },
        ]
      },
      {
        model: SubProcessBomChild,
        as: 'processChildren',
        attributes: ['id', 'process_bom_id', 'process_id', 'equipment_id', 'time', 'price'],
        include: [
          { model: SubProcessCode, as: 'process', attributes: ['id', 'process_code', 'process_name', 'section_points'] },
          { model: SubEquipmentCode, as: 'equipment', attributes: ['id', 'equipment_code', 'equipment_name'] }
        ]
      }
    ],
    order: [['created_at', 'DESC']],
    limit: parseInt(pageSize),
    offset
  })
  const totalPages = Math.ceil(count / pageSize)
  const fromData = rows.map(item => item.toJSON())
  
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
 * /api/add_outsourcing_quote:
 *   post:
 *     summary: 新增委外报价
 *     tags:
 *       - 委外管理(Outsourcing)
 *     parameters:
 *       - name: notice_id
 *         schema:
 *           type: int
 *       - name: supplier_id
 *         schema:
 *           type: int
 *       - name: process_bom_id
 *         schema:
 *           type: int
 *       - name: process_bom_children_id
 *         schema:
 *           type: int
 *       - name: process_index
 *         schema:
 *           type: int
 *       - name: price
 *         schema:
 *           type: int
 *       - name: transaction_currency
 *         schema:
 *           type: int
 *       - name: other_transaction_terms
 *         schema:
 *           type: int
 *       - name: ment
 *         schema:
 *           type: int
 *       - name: remarks
 *         schema:
 *           type: int
 */
router.post('/add_outsourcing_quote', authMiddleware, async (req, res) => {
  const { notice_id, supplier_id, process_bom_id, process_bom_children_id, process_index, price, transaction_currency, other_transaction_terms, ment, remarks } = req.body;
  const { id: userId, company_id } = req.user;
  
  const notice = await SubProductNotice.findOne({
    where: {
      id: notice_id,
      is_deleted: 1
    },
    include:[
      { model: SubSaleOrder, as: 'sale', attributes: ['id', 'order_number', 'unit', 'delivery_time'] }
    ]
  })
  if(!notice) return res.json({ message: '该生产订单不存在或已删除', code: 401 })
  const noticeJson = notice.toJSON()
  const number = noticeJson.sale.order_number
  
  await SubOutsourcingQuote.create({
    notice_id, supplier_id, process_bom_id, process_bom_children_id, process_index, price, number, transaction_currency, other_transaction_terms, ment, remarks, company_id,
    user_id: userId,
    now_price: price,
  })
  
  res.json({ message: '添加成功', code: 200 });
})
/**
 * @swagger
 * /api/outsourcing_quote:
 *   put:
 *     summary: 修改委外报价
 *     tags:
 *       - 委外管理(Outsourcing)
 *     parameters:
 *       - name: id
 *         schema:
 *           type: int
 *       - name: notice_id
 *         schema:
 *           type: int
 *       - name: supplier_id
 *         schema:
 *           type: int
 *       - name: process_bom_id
 *         schema:
 *           type: int
 *       - name: process_bom_children_id
 *         schema:
 *           type: int
 *       - name: process_index
 *         schema:
 *           type: int
 *       - name: price
 *         schema:
 *           type: int
 *       - name: transaction_currency
 *         schema:
 *           type: int
 *       - name: other_transaction_terms
 *         schema:
 *           type: int
 *       - name: ment
 *         schema:
 *           type: int
 *       - name: remarks
 *         schema:
 *           type: int
 */
router.put('/outsourcing_quote', authMiddleware, async (req, res) => {
  const { notice_id, supplier_id, process_bom_id, process_bom_children_id, process_index, price, transaction_currency, other_transaction_terms, ment, remarks, status, now_price, id } = req.body;
  const { id: userId, company_id } = req.user;
  
  const updateResult = await SubOutsourcingQuote.update({
    notice_id, supplier_id, process_bom_id, process_bom_children_id, process_index, price, transaction_currency, other_transaction_terms, ment, remarks, status, now_price, company_id,
    user_id: userId
  }, {
    where: {
      id
    }
  })
  if(updateResult.length == 0) return res.json({ message: '数据不存在，或已被删除', code: 401})
  
  res.json({ message: '修改成功', code: 200 });
})


/**
 * @swagger
 * /api/outsourcing_order:
 *   post:
 *     summary: 委外加工列表
 *     tags:
 *       - 委外管理(Outsourcing)
 *     parameters:
 *       - name: notice
 *         schema:
 *           type: string
 *       - name: supplier_code
 *         schema:
 *           type: string
 *       - name: status
 *         schema:
 *           type: int
 */
router.post('/outsourcing_order', authMiddleware, async (req, res) => {
  const { notice, supplier_code, status } = req.body;
  const { company_id } = req.user;
  
  const whereNotice = {}
  const whereSupplier = {}
  let whereOrder = {}
  if(notice) whereNotice.notice = notice
  if(supplier_code) whereSupplier.supplier_code = supplier_code
  whereOrder.status = status ? status : [0, 2]
  const rows = await SubOutsourcingOrder.findAll({
    where: {
      is_deleted: 1,
      company_id,
      ...whereOrder
    },
    attributes: ['id', 'notice_id', 'supplier_id', 'process_bom_id', 'process_bom_children_id', 'ment', 'unit', 'number', 'price', 'transaction_currency', 'other_transaction_terms', 'delivery_time', 'remarks', 'status', 'apply_id', 'apply_name', 'apply_time', 'step'],
    include: [
      { model: SubApprovalUser, as: 'approval', attributes: [ 'user_id', 'user_name', 'type', 'step', 'company_id', 'source_id', 'user_time', 'status', 'id' ], order: [['step', 'ASC']], separate: true, },
      { model: SubSupplierInfo, as: 'supplier', attributes: ['id', 'supplier_abbreviation', 'supplier_code'], where: { ...whereSupplier } },
      { model: SubProductNotice, as: 'notice', attributes: ['id', 'notice', 'sale_id'], where: { ...whereNotice }, include: [{ model: SubSaleOrder, as: 'sale', attributes: ['id', 'order_number', 'unit', 'delivery_time'] }] },
      {
        model: SubProcessBom,
        as: 'processBom',
        attributes: ['id', 'product_id', 'part_id', 'archive'],
        include: [
          { model: SubProductCode, as: 'product', attributes: ['id', 'product_name', 'product_code', 'drawing', 'model', 'specification'] },
          { model: SubPartCode, as: 'part', attributes: ['id', 'part_name', 'part_code'] },
        ]
      },
      {
        model: SubProcessBomChild,
        as: 'processChildren',
        attributes: ['id', 'process_bom_id', 'process_id', 'equipment_id', 'time', 'price'],
        include: [
          { model: SubProcessCode, as: 'process', attributes: ['id', 'process_code', 'process_name', 'section_points'] },
          { model: SubEquipmentCode, as: 'equipment', attributes: ['id', 'equipment_code', 'equipment_name'] }
        ]
      }
    ],
    order: [['created_at', 'DESC']],
  })
  const fromData = rows.map(item => item.dataValues)
  
  // 返回所需信息
  res.json({ 
    data: formatArrayTime(fromData), 
    code: 200 
  });
});
/**
 * @swagger
 * /api/add_outsourcing_order:
 *   post:
 *     summary: 新增委外加工且提交审批
 *     tags:
 *       - 委外管理(Outsourcing)
 *     parameters:
 *       - name: data
 *         schema:
 *           type: array
 *       - name: type
 *         schema:
 *           type: string
 */
router.post('/add_outsourcing_order', authMiddleware, async (req, res) => {
  const { data, type } = req.body;
  const { id: userId, company_id, name } = req.user;

  if(!data.length) return res.json({ code: 401, message: '请选择订单数据' })
  const step = await SubApprovalStep.findAll({
    where: {
      is_deleted: 1,
      company_id,
      type
    },
    attributes: ['id', 'user_id', 'user_name', 'type', 'step', 'company_id']
  })
  if(!step.length) return res.json({ code: 401, message: '未配置审批流程，请先联系管理员' })
  const steps = step.map(e => e.toJSON())

  const dataValue = data.map(e => {
    e.company_id = company_id
    e.user_id = userId
    e.apply_id = userId,
    e.apply_name = name,
    e.apply_time = dayjs().toDate(),
    e.status = 0
    return e
  })
  const result = await SubOutsourcingOrder.bulkCreate(dataValue, {
    updateOnDuplicate: ['company_id', 'user_id', 'notice_id', 'supplier_id', 'process_bom_id', 'process_bom_children_id', 'ment', 'unit', 'number', 'price', 'transaction_currency', 'other_transaction_terms', 'delivery_time', 'remarks', 'status', 'apply_id', 'apply_name', 'apply_time', 'step']
  })

  // 创建审批流程
  const resData = result.flatMap(e => {
    const item = e.toJSON()
    return steps.map(o => {
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
})
/**
 * @swagger
 * /api/outsourcing_order:
 *   put:
 *     summary: 修改委外加工
 *     tags:
 *       - 委外管理(Outsourcing)
 *     parameters:
 *       - name: data
 *         schema:
 *           type: array
 *       - name: type
 *         schema:
 *           type: string
 */
router.put('/outsourcing_order', authMiddleware, async (req, res) => {
  const { notice_id, supplier_id, process_bom_id, process_bom_children_id, unit, price, number, transaction_currency, other_transaction_terms, ment, remarks, status, delivery_time, id } = req.body;
  const { id: userId, company_id } = req.user;

  const result = await SubOutsourcingOrder.findByPk(id)
  if(!result) res.json({ message: '未找到该委外加工信息', code: 401 })
  
  const obj = {
    notice_id, supplier_id, process_bom_id, process_bom_children_id, unit, price, number, transaction_currency, other_transaction_terms, ment, remarks, status, delivery_time, company_id,
    user_id: userId
  }
  const updateResult = await SubOutsourcingOrder.update(obj, {
    where: {
      id
    }
  })
  if(updateResult.length == 0) return res.json({ message: '数据不存在，或已被删除', code: 401})
  
  res.json({ message: '修改成功', code: 200 });
})
/**
 * @swagger
 * /api/handleOutsourcingApproval:
 *   post:
 *     summary: 委外加工单处理审批的功能
 *     tags:
 *       - 委外管理(Outsourcing)
 *     parameters:
 *       - name: data
 *         schema:
 *           type: array
 *       - name: action
 *         schema:
 *           type: int
 */
router.post('/handleOutsourcingApproval', authMiddleware, async (req, res) => {
  const { data, action } = req.body;
  const { id: userId, company_id } = req.user;

  if(data.length == 0) return res.json({ code: 401, message: '请选择需要审批的数据' })
  const result = await SubOutsourcingOrder.findAll({
    where: {
      id: data,
      company_id,
      status: 0,
    },
    include: [
      { model: SubApprovalUser, as: 'approval', attributes: [ 'user_id', 'user_name', 'type', 'step', 'company_id', 'source_id', 'user_time', 'status', 'id' ], order: [['step', 'ASC']], separate: true, }
    ],
    order: [
      ['created_at', 'DESC']
    ],
  })
  const outsourcing = result.map(e => e.toJSON())
  let approval = []
  const dataValue = outsourcing.map(e => {
    const item = e.approval[e.step]
    if(item.user_id == userId){
      item.status = action
      if(action == 1){
        e.step++
        if(e.step == e.approval.length){
          e.status = 1
        }
      }
      if(action == 2){
        e.step = 0
        e.status = 2
      }
      approval.push(item)
    }
    return e
  })
  if(!approval.length) return res.json({ message: '暂无可审核的数据', code: 401 })
  await SubApprovalUser.bulkCreate(approval, {
    updateOnDuplicate: ['user_id', 'user_name', 'type', 'step', 'company_id', 'source_id', 'user_time', 'status']
  })
  await SubOutsourcingOrder.bulkCreate(dataValue, {
    updateOnDuplicate: ['status', 'step']
  })
  res.json({ data: null, code: 200 })
})
/**
 * @swagger
 * /api/handleOutsourcingBackFlow:
 *   post:
 *     summary: 委外加工单反审核
 *     tags:
 *       - 委外管理(Outsourcing)
 *     parameters:
 *       - name: id
 *         schema:
 *           type: int
 */
router.post('/handleOutsourcingBackFlow', authMiddleware, async (req, res) => {
  const { id } = req.body;
  const { id: userId, company_id } = req.user;

  const result = await SubOutsourcingOrder.findByPk(id)
  if(!result) return res.json({ message: '数据出错，请联系管理员', code: 401 })
  if(result.status != 1) return res.json({ message: '此数据未审核通过，不能进行反审核' })
  const dataValue = result.toJSON()

  const approval = await SubApprovalUser.findAll({
    where: {
      company_id,
      source_id: id
    }
  })
  const approvalValue = approval.map(e => {
    const item = e.toJSON()
    item.status = 0
    return item
  })

  await SubOutsourcingOrder.update({
    user_id: dataValue.user_id,
    company_id: dataValue.company_id,
    status: 0,
    step: 0
  },{
    where: {
      id: dataValue.id
    }
  })
  await SubApprovalUser.bulkCreate(approvalValue, {
    updateOnDuplicate: ['company_id', 'status']
  })

  res.json({ code: 200, message: '操作成功' })
})



module.exports = router;