const express = require('express');
const router = express.Router();
const dayjs = require('dayjs')
const { SubSupplierInfo, SubMaterialQuote, SubMaterialCode, SubProductNotice, SubProductCode, SubMaterialMent, SubApprovalUser, SubApprovalStep, SubNoEncoding, Op, subOutscriptionOrder, SubWarehouseApply, SubMaterialBomChild, SubMaterialOrder, sequelize, SubMaterialBom, SubPartCode, SubSaleOrder } = require('../models')
const authMiddleware = require('../middleware/auth');
const { formatArrayTime, formatObjectTime } = require('../middleware/formatTime');
const { print, getPrinters, getDefaultPrinter } = require("pdf-to-printer");
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const { getSaleCancelIds, PreciseMath } = require('../middleware/tool');

// 配置 multer
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    // 指定图片存储的文件夹
    cb(null, path.join(__dirname, '../public/temp'));
  },
  filename: function (req, file, cb) {
    // 生成唯一的文件名
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, file.fieldname + '-' + uniqueSuffix + path.extname(file.originalname));
  }
});

const upload = multer({ storage: storage });


/**
 * @swagger
 * /api/material_quote:
 *   get:
 *     summary: 材料报价
 *     tags:
 *       - 采购单(Purchase)
 *     parameters:
 *       - name: page
 *         schema:
 *           type: array
 *       - name: pageSize
 *         schema:
 *           type: string
 */
router.get('/material_quote', authMiddleware, async (req, res) => {
  const { page = 1, pageSize = 10, supplier_code, supplier_abbreviation, material_code, material_name } = req.query;
  const offset = (page - 1) * pageSize;
  const { company_id } = req.user;
  
  let materialWhere = {}
  let supplierWhere = {}
  if(supplier_code) supplierWhere.supplier_code = supplier_code
  if(supplier_abbreviation) supplierWhere.supplier_abbreviation = supplier_abbreviation
  if(material_code) materialWhere.material_code = material_code
  if(material_name) materialWhere.material_name = material_name
  const { count, rows } = await SubMaterialQuote.findAndCountAll({
    where: {
      is_deleted: 1,
      company_id,
    },
    attributes: ['id', 'price', 'transaction_currency', 'unit', 'delivery', 'packaging', 'transaction_method', 'other_transaction_terms', 'other_text', 'invoice', 'created_at'],
    include: [
      { model: SubMaterialCode, as: 'material', attributes: ['id', 'material_code', 'material_name', 'model', 'specification', 'other_features'], where: materialWhere },
      { model: SubSupplierInfo, as: 'supplier', attributes: ['id', 'supplier_code', 'supplier_abbreviation'], where: supplierWhere },
    ],
    order: [['created_at', 'DESC']],
    distinct: true,
    limit: parseInt(pageSize),
    offset
  })
  const totalPages = Math.ceil(count / pageSize)
  const fromData = rows.map(e => {
    const item = e.toJSON()
    item.notice = formatObjectTime(item.notice)
    return item
  })
  
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
 * /api/material_quote:
 *   post:
 *     summary: 新增材料报价
 *     tags:
 *       - 采购单(Purchase)
 *     parameters:
 *       - name: supplier_id
 *         schema:
 *           type: int
 *       - name: notice_id
 *         schema:
 *           type: int
 *       - name: material_id
 *         schema:
 *           type: int
 *       - name: price
 *         schema:
 *           type: int
 *       - name: delivery
 *         schema:
 *           type: string
 *       - name: packaging
 *         schema:
 *           type: string
 *       - name: transaction_currency
 *         schema:
 *           type: string
 *       - name: other_transaction_terms
 *         schema:
 *           type: string
 *       - name: remarks
 *         schema:
 *           type: string
 */
router.post('/material_quote', authMiddleware, async (req, res) => {
  const { data } = req.body;
  const { id: userId, company_id } = req.user;
  
  if(!data.length) return res.json({ code: 401, message: '暂无数据可存档！' })
  
  const updateData = data.map(e => ({ ...e, company_id, user_id: userId }))
  try {
    await SubMaterialQuote.bulkCreate(updateData, {
      updateOnDuplicate: ['supplier_id', 'material_id', 'price', 'unit', 'delivery', 'packaging', 'transaction_currency', 'transaction_method', 'other_transaction_terms', 'other_text', 'invoice']
    })

    res.json({ message: "添加成功", code: 200 });
  } catch (error) {
    console.log(error);
  }
});
/**
 * @swagger
 * /api/material_quote:
 *   put:
 *     summary: 修改材料报价（废弃）
 *     tags:
 *       - 采购单(Purchase)
 *     parameters:
 *       - name: id
 *         schema:
 *           type: int
 *       - name: supplier_id
 *         schema:
 *           type: int
 *       - name: notice_id
 *         schema:
 *           type: int
 *       - name: material_id
 *         schema:
 *           type: int
 *       - name: price
 *         schema:
 *           type: int
 *       - name: delivery
 *         schema:
 *           type: string
 *       - name: packaging
 *         schema:
 *           type: string
 *       - name: transaction_currency
 *         schema:
 *           type: string
 *       - name: other_transaction_terms
 *         schema:
 *           type: string
 *       - name: remarks
 *         schema:
 *           type: string
 */
router.put('/material_quote', authMiddleware, async (req, res) => {
  const { supplier_id, material_id, price, delivery, packaging, transaction_currency, unit, other_transaction_terms, other_text, invoice, id } = req.body;
  
  const { id: userId, company_id } = req.user;
  
  let product_id = ''
  const quote = await SubProductNotice.findOne({
    where: { id: notice_id },
    raw: true
  })
  if(quote){
    product_id = quote.product_id
  }else{
    return res.json({ code: 401, message: '数据出错，请联系管理员' })
  }
  const updateResult = await SubMaterialQuote.update({
    supplier_id, material_id, price, delivery, packaging, transaction_currency, unit, transaction_method, other_transaction_terms, other_text, invoice, company_id,
    user_id: userId
  }, {
    where: { id }
  })
  if (updateResult.length == 0) {
    return res.json({ message: '未找到该材料报价信息', code: 404 });
  }
  
  res.json({ message: "修改成功", code: 200 });
});



/**
 * @swagger
 * /api/material_ment:
 *   post:
 *     summary: 获取采购作业的列表
 *     tags:
 *       - 采购单(Purchase)
 *     parameters:
 *       - name: page
 *         schema:
 *           type: array
 *       - name: pageSize
 *         schema:
 *           type: string
 *       - name: notice
 *         schema:
 *           type: string
 *       - name: supplier_code
 *         schema:
 *           type: string
 *       - name: product_code
 *         schema:
 *           type: string
 */
router.get('/material_ment', authMiddleware, async (req, res) => {
  const { notice, supplier_code, supplier_abbreviation, product_code, product_name, status } = req.query;
  const { id: userId, company_id } = req.user;

  const noticeIds = await getSaleCancelIds('notice_id', { company_id })
  
  let whereMent = {};
  if (notice) whereMent.notice = { [Op.like]: `%${notice}%` };
  if (supplier_code) whereMent.supplier_code = { [Op.like]: `%${supplier_code}%` };
  if (supplier_abbreviation) whereMent.supplier_abbreviation = { [Op.like]: `%${supplier_abbreviation}%` };
  if (product_code) whereMent.product_code = { [Op.like]: `%${product_code}%` };
  if (product_name) whereMent.product_name = { [Op.like]: `%${product_name}%` };
  
  const otherFields = [notice, supplier_code, supplier_abbreviation, product_code, product_name];
  const hasOtherValues = otherFields.some(field => field !== undefined && field !== '');
  
  if (status !== undefined && status !== '') {
    // 前端指定了status值
    if (status == 4) {
      // 查status=4时，仅能查自己提交的
      whereMent.status = 4;
      whereMent.apply_id = userId;
    } else {
      // 查其他status（0/1/2/3），正常过滤
      whereMent.status = status;
    }
  } else {
    // 前端未指定status
    if (!hasOtherValues) {
      // 无其他查询条件时，默认查 [0,2,3] + 自己的4
      whereMent[Op.or] = [
        { status: [0, 2, 3] },
        { status: 4, apply_id: userId }
      ];
    } else {
      // 有其他查询条件时，查「所有非4状态」 + 自己的4
      whereMent[Op.or] = [
        { status: { [Op.ne]: 4 } },
        { status: 4, apply_id: userId }
      ];
    }
  }

  let transaction = await sequelize.transaction()
  const rows = await SubMaterialMent.findAll({
    where: {
      is_deleted: 1,
      company_id,
      notice_id: { [Op.notIn]: noticeIds },
      ...whereMent
    },
    attributes: ['id', 'notice_id', 'material_bom_id', 'seq_id', 'quote_id', 'delivery_time', 'product_id', 'material_id', 'material_code', 'material_name', 'supplier_id', 'model_spec', 'other_features', 'price', 'unit', 'usage_unit', 'number', 'is_buying', 'apply_id', 'apply_name', 'apply_time', 'status', 'step'],
    include: [
      { model: SubApprovalUser, as: 'approval', attributes: [ 'user_id', 'user_name', 'type', 'step', 'company_id', 'source_id', 'user_time', 'status', 'id' ], order: [['step', 'ASC']], where: { type: 'purchase_order', company_id }, separate: true, },
      { model: SubProductCode, as: 'product', attributes: ['id', 'product_code', 'product_name', 'drawing'] },
      { model: SubProductNotice, as: 'notice', attributes: ['id', 'notice'] },
      { model: SubSupplierInfo, as: 'supplier', attributes: ['id', 'supplier_code', 'supplier_abbreviation'] }
    ],
    order: [['created_at', 'DESC']],
    transaction
  })
  await transaction.commit()
  const fromData = rows.map(item => item.toJSON());
  
  // 返回所需信息
  res.json({ 
    data: formatArrayTime(fromData), 
    code: 200 
  });
});
/**
 * @swagger
 * /api/add_material_row:
 *   post:
 *     summary: 新增采购单作业
 *     tags:
 *       - 采购单(Purchase)
 */
router.post('/add_material_row', authMiddleware, async (req, res) => {
  const { notice_id, material_bom_id, seq_id = null, quote_id = null, delivery_time = null, product_id = null, material_id = null, material_code, material_name, supplier_id = null, model_spec, other_features, price = null, unit = null, usage_unit = null, number = null } = req.body
  const { id: userId, company_id, name } = req.user;

  const transaction = await sequelize.transaction()
  const childData = {
    material_bom_id: material_bom_id || null,
    seq_id: seq_id || null,
    material_id: material_id || null,
  }
  const submitData = {
    notice_id: notice_id || null,
    quote_id: quote_id || null,
    delivery_time: delivery_time || null,
    product_id: product_id || null,
    supplier_id: supplier_id || null,
    model_spec,
    other_features,
    material_code,
    material_name,
    price: price || null,
    unit: unit || null,
    usage_unit: usage_unit || null,
    number: number || null,
    company_id,
    user_id: userId,
    apply_id: userId,
    apply_name: name,
    apply_time: null,
    status: 4,
    step: 0,
    ...childData
  };
  await SubMaterialMent.create(submitData, { transaction })
  await SubMaterialBomChild.update({
    is_buy: 1,
    ...childData
  }, { where: { id: seq_id }, transaction })
  await transaction.commit();

  res.json({ code: 200, message: '新增成功' })
})
/**
 * @swagger
 * /api/add_material_more:
 *   post:
 *     summary: 新增采购单作业2.0
 *     tags:
 *       - 采购单(Purchase)
 */
router.post('/add_material_more', authMiddleware, async (req, res) => {
  const { notice_id, material_bom_id, seq_id = null, quote_id = null, delivery_time = null, product_id = null, material_id = null, material_code, material_name, supplier_id = null, model_spec, other_features, price = null, unit = null, usage_unit = null, number = null } = req.body
  const { id: userId, company_id, name } = req.user;

  const transaction = await sequelize.transaction()
  if(notice_id != 0){
    const product = await SubMaterialBom.findByPk(material_bom_id)
    const boms = await SubMaterialBom.findAll({
      where: { company_id, product_id: product.product_id },
      attributes: ['id', 'product_id', 'part_id'],
      include: [
        { model: SubProductCode, as: 'product', attributes: ['id', 'product_code', 'product_name'] },
        { model: SubPartCode, as: 'part', attributes: ['id', 'part_code', 'part_name'] },
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
    const notice = await SubProductNotice.findOne({
      where: {
        company_id,
        id: notice_id
      },
      attributes: ['delivery_time', 'sale_id'],
      include: [
        { model: SubSaleOrder, as: 'sale', attributes: ['order_number'] }
      ]
    })

    const data = boms.flatMap(e => {
      const item = e.toJSON()
      return item.children.map(child => {
        return {
          notice_id,
          material_bom_id,
          seq_id: child.id,
          quote_id: null,
          delivery_time: null,
          product_id: item.product_id,
          material_id: child.material_id,
          material_code: child.material.material_code,
          material_name: child.material.material_name,
          supplier_id: null,
          model_spec: child.material.model,
          other_features: child.material.other_features,
          price: null,
          unit: child.material.purchase_unit,
          usage_unit: child.material.usage_unit,
          number: PreciseMath.mul(child.number, notice.sale.order_number),
          company_id,
          user_id: userId,
          apply_id: userId,
          apply_name: name,
          apply_time: null,
          status: 4,
          step: 0,
        }
      })
    })
    const result = Object.values(
      data.reduce((acc, curr) => {
        const key = curr.material_id;
        if (!acc[key]) {
          acc[key] = { ...curr };
        } else {
          acc[key].number += curr.number;
        }
        return acc;
      }, {})
    );
    try {
      const seqIds = result.map(e => e.seq_id)
      const updataArr = ['notice_id', 'material_bom_id', 'seq_id', 'quote_id', 'delivery_time', 'product_id', 'material_id', 'material_code', 'material_name', 'supplier_id', 'model_spec', 'other_features', 'price', 'unit', 'usage_unit', 'number', 'company_id', 'user_id', 'apply_id', 'apply_name', 'apply_time', 'status', 'step']
      await SubMaterialMent.bulkCreate(result, { updateOnDuplicate: updataArr, transaction })
      await SubMaterialBomChild.update({
        is_buy: 1
      }, { where: { id: { [Op.in]: seqIds } }, transaction })
      await transaction.commit();

      res.json({ code: 200, message: '新增成功' })
    } catch (error) {
      if(transaction) await transaction.rollback();
      console.log(error);
    }
  }else{
    const childData = {
      material_bom_id: material_bom_id || null,
      seq_id: seq_id || null,
      material_id: material_id || null,
    }
    const submitData = {
      notice_id: notice_id || null,
      quote_id: quote_id || null,
      delivery_time: delivery_time || null,
      product_id: product_id || null,
      supplier_id: supplier_id || null,
      model_spec,
      other_features,
      material_code,
      material_name,
      price: price || null,
      unit: unit || null,
      usage_unit: usage_unit || null,
      number: number || null,
      company_id,
      user_id: userId,
      apply_id: userId,
      apply_name: name,
      apply_time: null,
      status: 4,
      step: 0,
      ...childData
    };
    await SubMaterialMent.create(submitData, { transaction })
    await SubMaterialBomChild.update({
      is_buy: 1,
      ...childData
    }, { where: { id: seq_id }, transaction })
    await transaction.commit();

    res.json({ code: 200, message: '新增成功' })
  }
})
/**
 * @swagger
 * /api/material_ment:
 *   put:
 *     summary: 修改采购单
 *     tags:
 *       - 采购单(Purchase)
 */
router.put('/material_ment', authMiddleware, async (req, res) => {
  const { notice_id, material_bom_id, seq_id = null, quote_id = null, delivery_time = null, product_id = null, material_id = null, material_code, material_name, supplier_id = null, model_spec, other_features, price = null, unit = null, usage_unit = null, number = null, id } = req.body;
  const { id: userId, company_id } = req.user;

  const result = await SubMaterialMent.findByPk(id)
  if(!result) res.json({ message: '未找到该采购单信息', code: 401 })
  
  const obj = {
    notice_id: notice_id || null,
    quote_id: quote_id || null,
    material_bom_id: material_bom_id || null,
    seq_id: seq_id || null,
    material_id: material_id || null,
    delivery_time: delivery_time || null,
    product_id: product_id || null,
    supplier_id: supplier_id || null,
    model_spec,
    other_features,
    material_code,
    material_name,
    price: price || null,
    unit: unit || null,
    usage_unit: usage_unit || null,
    number: number || null,
    user_id: userId,
    apply_time: result.apply_time,
  }
  const transaction = await sequelize.transaction()
  try {
    if(result.seq_id != seq_id){
      const isBuyArr = [{ is_buy: 0, id: result.seq_id }, { is_buy: 1, id: seq_id }]
      await SubMaterialBomChild.bulkCreate(isBuyArr, { updateOnDuplicate: ['is_buy'], transaction })
    }
    await SubMaterialMent.update(obj, {
      where: { id },
      transaction
    })
    await transaction.commit()
  } catch (error) {
    if(transaction) await transaction.rollback();
    console.log(error);
  }

  res.json({ message: '修改成功', code: 200 });
})
/**
 * @swagger
 * /api/material_ment:
 *   delete:
 *     summary: 删除采购单
 *     tags:
 *       - 采购单(Purchase)
 */
router.delete('/del_material_row', authMiddleware, async (req, res) => {
  const { id } = req.params;
  const { company_id } = req.user

  const transaction = await sequelize.transaction()

  // 验证产品是否存在
  const ment = await SubMaterialMent.findByPk(id);
  if (!ment) {
    return res.json({ message: '采购作业不存在', code: 401 });
  }
  try {
    await SubMaterialMent.update({
      is_deleted: 0
    }, { where: { id, is_deleted: 1, company_id }, transaction })

    await SubMaterialBomChild.update({
      is_buy: 0
    }, { where: { id: ment.seq_id }, transaction })
    await transaction.commit()
    res.json({ message: '删除成功', code: 200 });
  } catch (error) {
    if(transaction) await transaction.rollback();
    console.log(error);
  }
})

/**
 * @swagger
 * /api/add_material_ment:
 *   post:
 *     summary: 创建申购单审批
 *     tags:
 *       - 采购单(Purchase)
 *     parameters:
 *       - name: data
 *         schema:
 *           type: array
 *       - name: type
 *         schema:
 *           type: string
 */
router.post('/add_material_ment', authMiddleware, async (req, res) => {
  const { data, type } = req.body;
  const { id: userId, company_id } = req.user;

  if(!data.length) return res.json({ code: 401, message: '请选择采购作业' })

  const stepList = await SubApprovalStep.findAll({
    where: { is_deleted: 1, company_id, type },
    attributes: ['id', 'user_id', 'user_name', 'type', 'step', 'company_id'],
    raw: true,
  })
  if(!stepList.length) return res.json({ code: 401, message: '未配置审批流程，请先联系管理员' })
  
  const now = dayjs().toDate();
  const mentResult = await SubMaterialMent.findAll({
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
    await SubMaterialMent.bulkCreate(mentData, { updateOnDuplicate: ['status', 'apply_time'], transaction })

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
      await SubApprovalUser.bulkCreate(statusData, {
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
 * /api/handlePurchaseApproval:
 *   post:
 *     summary: 采购单处理审批的功能
 *     tags:
 *       - 采购单(Purchase)
 *     parameters:
 *       - name: data
 *         schema:
 *           type: array
 *       - name: action
 *         schema:
 *           type: int
 */
router.post('/handlePurchaseApproval', authMiddleware, async (req, res) => {
  const { data, action } = req.body;
  const { id: userId, company_id } = req.user;

  if(data.length == 0) return res.json({ code: 401, message: '请选择需要审批的数据' })
  const result = await SubMaterialMent.findAll({
    where: {
      id: data,
      company_id,
      status: 0,
    },
    include: [
      { model: SubApprovalUser, as: 'approval', attributes: [ 'user_id', 'user_name', 'type', 'step', 'company_id', 'source_id', 'user_time', 'status', 'id' ], order: [['step', 'ASC']], where: { type: 'purchase_order', company_id }, separate: true, }
    ],
    order: [
      ['created_at', 'DESC']
    ],
  })
  const purchase = result.map(e => e.toJSON())
  let approval = []
  const dataValue = purchase.map(e => {
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
  await SubMaterialMent.bulkCreate(dataValue, {
    updateOnDuplicate: ['status', 'step']
  })
  res.json({ data: null, code: 200 })
})
/**
 * @swagger
 * /api/handlePurchaseIsBuying:
 *   post:
 *     summary: 采购单确认
 *     tags:
 *       - 采购单(Purchase)
 *     parameters:
 *       - name: id
 *         schema:
 *           type: int
 */
router.post('/handlePurchaseIsBuying', authMiddleware, async (req, res) => {
  const { data } = req.body
  const { id: userId, company_id } = req.user;

  if(!data.length) return res.json({ code: 401, message: '请选择采购作业' })

  const subMaterialMents = await SubMaterialMent.findAll({
    where: { id: data, company_id, is_buying: 1 },
    raw: true
  })
  // 校验：选中的采购作业是否存在（避免无效ID）
  if (subMaterialMents.length !== data.length) {
    const validIds = subMaterialMents.map(item => item.id);
    const invalidIds = data.filter(id => !validIds.includes(id));
    return res.json({ 
      code: 401, 
      message: `部分采购作业不存在或已生成采购单，请检查` 
    });
  }

  const supplierGroups = subMaterialMents.reduce((result, item) => {
    const groupKey = item.supplier_id;
    if (!result[groupKey]) {
      // 初始化分组：存储供应商信息 + 关联的采购作业IDs
      result[groupKey] = {
        notice_id: item.notice_id,
        supplier_id: item.supplier_id,
        product_id: item.product_id,
        subMaterialIds: [item.id], // 关联的采购作业ID数组
        company_id,
        user_id: userId,
      };
    } else {
      // 同一供应商：追加采购作业ID
      result[groupKey].subMaterialIds.push(item.id);
    }
    return result;
  }, {});
  const groups = Object.values(supplierGroups);
  // 批量创建采购单
  const purchaseOrders = await SubMaterialOrder.bulkCreate(groups,
    { returning: true } // 返回创建后的完整数据（包含自动生成的id）
  );

  const orderSubMaterialMap = purchaseOrders.map((order, index) => ({
    orderId: order.id,
    subMaterialIds: groups[index].subMaterialIds // 一一对应分组的采购作业IDs
  }));

  // 批量更新采购作业状态
  const updateTasks = orderSubMaterialMap.map(({ orderId, subMaterialIds }) =>
    SubMaterialMent.update(
      { is_buying: 0, order_id: orderId },
      { where: { id: subMaterialIds, company_id } }
    )
  );

  await Promise.all(updateTasks);

  res.json({ code: 200, message: '采购单确认成功' })
})
/**
 * @swagger
 * /api/handlePurchaseBackFlow:
 *   post:
 *     summary: 采购单反审核
 *     tags:
 *       - 采购单(Purchase)
 *     parameters:
 *       - name: id
 *         schema:
 *           type: int
 */
router.post('/handlePurchaseBackFlow', authMiddleware, async (req, res) => {
  const { id } = req.body;
  const { id: userId, company_id } = req.user;

  const result = await SubMaterialMent.findByPk(id)
  if(!result) return res.json({ message: '数据出错，请联系管理员', code: 401 })
  // if(result.status != 1) return res.json({ message: '此数据未审核通过，不能进行反审核' })
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

  await SubMaterialMent.update({
    user_id: dataValue.user_id,
    company_id: dataValue.company_id,
    status: 3,
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
/**
 * @swagger
 * /api/get_gurchase_order:
 *   get:
 *     summary: 获取采购单
 *     tags:
 *       - 采购单(Purchase)
 */
router.get('/get_gurchase_order', authMiddleware, async (req, res) => {
  const { page = 1, pageSize = 10 } = req.query;
  const offset = (page - 1) * pageSize;
  const { id: userId, company_id } = req.user;

  const { count, rows } = await SubMaterialOrder.findAndCountAll({
    where: { company_id },
    attributes: ['id', 'notice_id', 'supplier_id', 'product_id', 'no', 'created_at'],
    include: [
      { model: SubMaterialMent, as: 'order', attributes: ['id', 'material_id', 'material_code', 'material_name', 'model_spec', 'other_features', 'unit', 'usage_unit', 'price', 'order_number', 'number', 'delivery_time', 'order_id', 'apply_id', 'apply_name', 'apply_time'] },
      { model: SubSupplierInfo, as: 'supplier', attributes: ['id', 'supplier_code', 'supplier_abbreviation'] },
      { model: SubProductNotice, as: 'notice', attributes: ['id', 'notice'] },
      { model: SubProductCode, as: 'product', attributes: ['id', 'product_code', 'product_name'] }
    ],
    order: [['id', 'ASC']],
    distinct: true,
    // raw: true,
    limit: parseInt(pageSize),
    offset
  })
  const totalPages = Math.ceil(count / pageSize);
  const result = rows.map(e => {
    const item = e.toJSON()
    if(item.order.length){
      item.order = formatArrayTime(item.order)
    }
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

module.exports = router;