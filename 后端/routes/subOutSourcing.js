const express = require('express');
const router = express.Router();
const { SubOutsourcingQuote, SubSupplierInfo, SubProcessBom, SubProcessBomChild, SubProcessCode, SubEquipmentCode, SubProductCode, SubPartCode, SubProductNotice, SubSaleOrder, SubOutsourcingOrder, Op } = require('../models');
const authMiddleware = require('../middleware/auth');
const { formatArrayTime, formatObjectTime } = require('../middleware/formatTime');

// 委外报价
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


// 委外加工
router.post('/outsourcing_order', authMiddleware, async (req, res) => {
  const { page = 1, pageSize = 10 } = req.body;
  const offset = (page - 1) * pageSize;
  const { company_id } = req.user;
  
  const { count, rows } = await SubOutsourcingOrder.findAndCountAll({
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
router.post('/add_outsourcing_order', authMiddleware, async (req, res) => {
  const { notice_id, supplier_id, process_bom_id, process_bom_children_id, price, number, transaction_currency, other_transaction_terms, ment, delivery_time, remarks } = req.body;
  const { id: userId, company_id } = req.user;
  
  const notice = await SubProductNotice.findOne({
    where: {
      id: notice_id,
      is_deleted: 1
    }
  })
  if(!notice) return res.json({ message: '该生产订单不存在或已删除', code: 401 })
  
  await SubOutsourcingOrder.create({
    notice_id, supplier_id, process_bom_id, process_bom_children_id, price, number, transaction_currency, other_transaction_terms, ment, delivery_time, remarks, company_id,
    user_id: userId,
  })
  
  res.json({ message: '添加成功', code: 200 });
})
router.put('/outsourcing_order', authMiddleware, async (req, res) => {
  const { notice_id, supplier_id, process_bom_id, process_bom_children_id, price, number, transaction_currency, other_transaction_terms, ment, remarks, status, delivery_time, id } = req.body;
  const { id: userId, company_id } = req.user;

  const result = await SubOutsourcingOrder.findByPk(id)
  if(!result) res.json({ message: '未找到该委外加工信息', code: 401 })
  
  const obj = {
    notice_id, supplier_id, process_bom_id, process_bom_children_id, price, number, transaction_currency, other_transaction_terms, ment, remarks, status, delivery_time, company_id,
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




module.exports = router;