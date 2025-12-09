const express = require('express');
const router = express.Router();
const { SubProductCode, SubCustomerInfo, SubPartCode, SubMaterialCode, SubSaleOrder, SubProductQuotation, SubProcessCode, SubEquipmentCode, SubSupplierInfo, SubProductNotice, SubProcessBom, SubProcessBomChild, SubProcessCycle, SubConstType, subOutscriptionOrder, SubMaterialMent, Op, SubNoEncoding, SubMaterialBom, SubMaterialBomChild, SubMaterialQuote, SubOutsourcingQuote, SubMaterialOrder, SubConstUser, AdUser, SubOutsourcingOrder } = require('../models');
const authMiddleware = require('../middleware/auth');
const { formatArrayTime, formatObjectTime } = require('../middleware/formatTime');
const { getSaleCancelIds } = require('../middleware/tool');

/**
 * @swagger
 * /api/getSaleOrder:
 *   get:
 *     summary: 获取获取销售订单列表
 *     tags:
 *       - 常用列表(GetList)
 *     parameters:
 *       - name: customer_order
 *         schema:
 *           type: string
 */
router.get('/getSaleOrder', authMiddleware, async (req, res) => {
  const { customer_order, is_sale, my_id, sale_id, id } = req.query;
  const { company_id } = req.user;

  const saleIds = await getSaleCancelIds('sale_id', { company_id })

  const whereObj = {
    is_deleted: 1,
    company_id,
    id: { [Op.notIn]: saleIds }
  }
  if(customer_order) whereObj.customer_order = { [Op.like]: `%${customer_order}%` }
  if(id) whereObj.id = id
  if(is_sale != undefined && is_sale != null){
    const orConditions = [];
    // 支持 0/1 等合法值
    orConditions.push({ is_sale: is_sale });
    if(my_id !== undefined && my_id !== null){
      orConditions.push({ id: my_id });
    }
    whereObj[Op.or] = orConditions;
  }
  if(sale_id) whereObj.sale_id = sale_id
  const config = {
    where: whereObj,
    include: [
      { model: SubProductCode, as: 'product' },
      { model: SubCustomerInfo, as: 'customer'},
      { model: SubProductQuotation, as: 'quot', attributes: ['id', 'product_price'] }
    ],
    order: [['created_at', 'DESC']],
    distinct: true,
  }
  const { count, rows } = await SubSaleOrder.findAndCountAll(config);
  const row = rows.map(e => e.toJSON())
  
  res.json({ data: formatArrayTime(row), code: 200 });
});
/**
 * @swagger
 * /api/getProductQuotation:
 *   get:
 *     summary: 获取报价单列表
 *     tags:
 *       - 常用列表(GetList)
 *     parameters:
 *       - name: notice
 *         schema:
 *           type: string
 */
router.get('/getProductQuotation', authMiddleware, async (req, res) => {
  const { notice } = req.query;
  const { company_id } = req.user;
  
  const config = {
    where: { is_deleted: 1, company_id, notice: {
      [Op.like]: `%${notice}%`
    } },
    order: [['created_at', 'DESC']],
    distinct: true,
  }
  const { count, rows } = await SubProductQuotation.findAndCountAll(config);
  const row = rows.map(e => e.toJSON())
  
  res.json({ data: formatArrayTime(row), code: 200 });
});
/**
 * @swagger
 * /api/getCustomerInfo:
 *   get:
 *     summary: 获取客户列表
 *     tags:
 *       - 常用列表(GetList)
 *     parameters:
 *       - name: customer_abbreviation
 *         schema:
 *           type: string
 */
router.get('/getCustomerInfo', authMiddleware, async (req, res) => {
  const { customer_abbreviation } = req.query;
  const { company_id } = req.user;
  
  let customerWhere = {}
  if(customer_abbreviation) customerWhere.customer_abbreviation = { [Op.like]: `%${customer_abbreviation}%` }

  const config = {
    where: { is_deleted: 1, company_id, ...customerWhere },
    order: [['customer_code', 'ASC']],
    distinct: true,
  }
  const { count, rows } = await SubCustomerInfo.findAndCountAll(config);
  const row = rows.map(e => e.toJSON())
  
  res.json({ data: formatArrayTime(row), code: 200 });
});
/**
 * @swagger
 * /api/getProductsCode:
 *   get:
 *     summary: 获取产品编码列表
 *     tags:
 *       - 常用列表(GetList)
 *     parameters:
 *       - name: product_code
 *         schema:
 *           type: string
 */
router.get('/getProductsCode', authMiddleware, async (req, res) => {
  const { product_code, id } = req.query;
  const { company_id } = req.user;
  
  let productWhere = {}
  if(product_code) productWhere.product_code = { [Op.like]: `%${product_code}%` }
  if(id) productWhere.id = id
  const config = {
    where: { is_deleted: 1, company_id, ...productWhere },
    order: [['product_code', 'ASC']],
    distinct: true,
  }
  const { count, rows } = await SubProductCode.findAndCountAll(config);
  const row = rows.map(e => e.toJSON())
  
  res.json({ data: formatArrayTime(row), code: 200 });
});
/**
 * @swagger
 * /api/getPartCode:
 *   get:
 *     summary: 获取部件编码列表
 *     tags:
 *       - 常用列表(GetList)
 *     parameters:
 *       - name: part_code
 *         schema:
 *           type: string
 */
router.get('/getPartCode', authMiddleware, async (req, res) => {
  const { part_code } = req.query;
  const { company_id } = req.user;
  
  let partWhere = {}
  if(part_code) partWhere.part_code = { [Op.like]: `%${part_code}%` }
  const config = {
    where: { is_deleted: 1, company_id, ...partWhere },
    order: [['part_code', 'ASC']],
    distinct: true,
  }
  const { count, rows } = await SubPartCode.findAndCountAll(config);
  const row = rows.map(e => e.toJSON())
  
  res.json({ data: formatArrayTime(row), code: 200 });
});
/**
 * @swagger
 * /api/getMaterialCode:
 *   get:
 *     summary: 获取材料编码列表
 *     tags:
 *       - 常用列表(GetList)
 *     parameters:
 *       - name: material_code
 *         schema:
 *           type: string
 */
router.get('/getMaterialCode', authMiddleware, async (req, res) => {
  const { material_code, id } = req.query;
  const idsArray = req.query['ids[]'];
  const { company_id } = req.user;

  let materialWhere = {}
  if(material_code) materialWhere.material_code = { [Op.like]: `%${material_code}%` }
  if(id) materialWhere.id = id
  if(idsArray){
    const validIds = Array.isArray(idsArray) ? idsArray.filter(id => id !== '' && id !== undefined) : [];
    if (validIds.length > 0) {
      materialWhere.id = { [Op.in]: validIds };
    }
  }
  
  const config = {
    where: { is_deleted: 1, company_id, ...materialWhere },
    order: [['material_code', 'ASC']],
    distinct: true,
  }
  const { count, rows } = await SubMaterialCode.findAndCountAll(config);
  const row = rows.map(e => e.toJSON())
  
  res.json({ data: formatArrayTime(row), code: 200 });
});
/**
 * @swagger
 * /api/getProcessCode:
 *   get:
 *     summary: 获取工艺编码列表
 *     tags:
 *       - 常用列表(GetList)
 *     parameters:
 *       - name: process_code
 *         schema:
 *           type: string
 */
router.get('/getProcessCode', authMiddleware, async (req, res) => {
  const { process_code } = req.query;
  const { company_id } = req.user;
  
  let processWhere = {}
  if(process_code) processWhere.process_code = { [Op.like]: `%${process_code}%` }
  const config = {
    where: { is_deleted: 1, company_id, ...processWhere },
    order: [['process_code', 'ASC']],
  }
  const rows = await SubProcessCode.findAll(config);
  const row = rows.map(e => e.toJSON())
  
  res.json({ data: formatArrayTime(row), code: 200 });
});
/**
 * @swagger
 * /api/getEquipmentCode:
 *   get:
 *     summary: 获取设备编码列表
 *     tags:
 *       - 常用列表(GetList)
 *     parameters:
 *       - name: equipment_code
 *         schema:
 *           type: string
 */
router.get('/getEquipmentCode', authMiddleware, async (req, res) => {
  const { equipment_code } = req.query;
  const { company_id } = req.user;
  
  const where = {
    is_deleted: 1,
    company_id
  }
  if(equipment_code) where.equipment_code = { [Op.like]: `%${equipment_code}%` }
  const config = {
    where,
    order: [['equipment_code', 'ASC']],
    distinct: true,
  }
  const { count, rows } = await SubEquipmentCode.findAndCountAll(config);
  const row = rows.map(e => e.toJSON())
  
  res.json({ data: formatArrayTime(row), code: 200 });
});


/**
 * @swagger
 * /api/getSupplierInfo:
 *   get:
 *     summary: 获取供应商列表（分页）
 *     tags:
 *       - 常用列表(GetList)
 *     parameters:
 *       - name: supplier_code
 *         schema:
 *           type: string
 */
router.get('/getSupplierInfo', authMiddleware, async (req, res) => {
  const { supplier_code, id } = req.query;
  
  const { company_id } = req.user;
  
  let supplierWhere = {}
  if(supplier_code) supplierWhere.supplier_code = { [Op.like]: `%${supplier_code}%` }
  if(id) supplierWhere.id = id
  const config = {
    where: { is_deleted: 1, company_id, ...supplierWhere },
    order: [['supplier_code', 'ASC']],
    distinct: true,
  }
  const { count, rows } = await SubSupplierInfo.findAndCountAll(config);
  const row = rows.map(e => e.toJSON())
  
  res.json({ data: formatArrayTime(row), code: 200 });
});

/**
 * @swagger
 * /api/getProductNotice:
 *   get:
 *     summary: 获取生产通知单列表
 *     tags:
 *       - 常用列表(GetList)
 *     parameters:
 *       - name: notice
 *         schema:
 *           type: string
 */
router.get('/getProductNotice', authMiddleware, async (req, res) => {
  const { notice, id } = req.query;
  const { company_id } = req.user;

  const saleIds = await getSaleCancelIds('sale_id', { company_id })
  
  let noticeWhere = {}
  if(notice) noticeWhere.notice = { [Op.like]: `%${notice}%` }
  if(id) noticeWhere.id = id
  const config = {
    where: {
      is_deleted: 1,
      is_finish: 1,
      company_id,
      sale_id: { [Op.notIn]: saleIds },
      ...noticeWhere
    },
    order: [['created_at', 'DESC']],
    include: [
      { model: SubProductCode, as: 'product', attributes: ['id', 'product_code', 'product_name', 'drawing', 'model', 'specification', 'other_features', 'component_structure', 'unit', 'production_requirements'] },
      {
        model: SubSaleOrder,
        as: 'sale',
        attributes: ['id', 'order_number', 'delivery_time', 'unit'],
        include: [
          { model: SubProductQuotation, as: 'quot', attributes: ['id', 'sale_id', 'customer_id', 'product_id', 'notice', 'product_price', 'transaction_currency', 'transaction_method', 'other_transaction_terms', 'other_text'] }
        ]
      },
      { model: SubCustomerInfo, as: 'customer', attributes: ['id', 'customer_code', 'customer_abbreviation'] }
    ]
  }
  const rows = await SubProductNotice.findAll(config);
  const row = rows.map(e => e.toJSON())
  
  res.json({ data: formatArrayTime(row), code: 200 });
});

/**
 * @swagger
 * /api/getProcessBom:
 *   get:
 *     summary: 获取工艺bom列表
 *     tags:
 *       - 常用列表(GetList)
 */
router.get('/getProcessBom', authMiddleware, async (req, res) => {
  const { product_id } = req.query
  const { company_id } = req.user;
  
  let whereObj = {}
  if(product_id) whereObj.product_id = product_id
  const rows = await SubProcessBom.findAll({
    where: {
      archive: 0,
      company_id,
      ...whereObj
    },
    attributes: ['id', 'archive', 'product_id', 'part_id'],
    include: [
      { model: SubProductCode, as: 'product', attributes: ['id', 'product_name', 'product_code', 'drawing'] },
      { model: SubPartCode, as: 'part', attributes: ['id', 'part_name', 'part_code', 'unit'] },
    ],
    order: [
      ['id', 'DESC'],
    ],
  })
  const bom = rows.map(e => {
    const obj = e.toJSON()
    obj.name = `${obj.part.part_code}:${obj.part.part_name}`
    return obj
  })
  
  res.json({ data: bom, code: 200 })
})
/**
 * @swagger
 * /api/getProcessBomChildren:
 *   get:
 *     summary: 获取工艺bom子表的列表
 *     tags:
 *       - 常用列表(GetList)
 *     parameters:
 *       - name: process_bom_id
 *         schema:
 *           type: string
 */
router.get('/getProcessBomChildren', authMiddleware, async (req, res) => {
  const { process_bom_id } = req.query;
  const { company_id } = req.user;
  
  const whereQuery = {
    process_bom_id,
  }
  const rows = await SubProcessBomChild.findAll({
    where: whereQuery,
    attributes: ['id', 'process_bom_id', 'process_id', 'equipment_id', 'process_index', 'time', 'price', 'points'],
    include: [
      { model: SubProcessCode, as: 'process', attributes: ['id', 'process_code', 'process_name'] },
      { model: SubEquipmentCode, as: 'equipment', attributes: ['id', 'equipment_code', 'equipment_name'] }
    ],
    order: [
      ['id', 'DESC'],
    ]
  })
  const bom = rows.map(e => {
    const obj = e.toJSON()
    obj.name = `${obj.process.process_code}:${obj.process.process_name} - ${obj.equipment.equipment_code}:${obj.equipment.equipment_name}`
    return obj
  })
  
  res.json({ data: bom, code: 200 })
})
/**
 * @swagger
 * /api/getProcessCycle:
 *   get:
 *     summary: 制程组列表
 *     tags:
 *       - 常用列表(GetList)
 */
router.get('/getProcessCycle', authMiddleware, async (req, res) => {
  const { type } = req.query
  const { company_id } = req.user;
  
  const where = { company_id };
  if(type === 'sort') where.sort = { [Op.gt]: 0 };
  const rows = await SubProcessCycle.findAll({
    where
  })
  const cycleRows = rows.map(e => e.toJSON())
  res.json({ data: cycleRows, code: 200 })
})
/**
 * @swagger
 * /api/getOutsourcingQuote:
 *   get:
 *     summary: 委外报价列表
 *     tags:
 *       - 常用列表(GetList)
 */
router.get('/getOutsourcingQuote', authMiddleware, async (req, res) => {
  const { notice_id } = req.query
  const { company_id } = req.user;
  
  let where = {
    is_deleted: 1,
    company_id,
  }
  if(notice_id) where.notice_id = notice_id
  const rows = await SubOutsourcingQuote.findAll({
    where,
    attributes: ['id', 'supplier_id', 'notice_id', 'price', 'transaction_currency', 'other_transaction_terms'],
    include: [
      { model: SubSupplierInfo, as: 'supplier', attributes: ['id', 'supplier_abbreviation', 'supplier_code'] },
      { model: SubProductNotice, as: 'notice', attributes: ['id', 'notice', 'sale_id'], include: [{ model: SubSaleOrder, as: 'sale', attributes: ['id', 'order_number', 'unit', 'delivery_time'] }] },
      {
        model: SubProcessBom,
        as: 'processBom',
        attributes: ['id', 'product_id', 'part_id', 'archive'],
        include: [
          { model: SubProductCode, as: 'product', attributes: ['id', 'product_name', 'product_code', 'drawing', 'model', 'specification'] },
          { model: SubPartCode, as: 'part', attributes: ['id', 'part_name', 'part_code', 'unit'] },
        ]
      },
      {
        model: SubProcessBomChild,
        as: 'processChildren',
        attributes: ['id', 'process_bom_id', 'process_id', 'equipment_id', 'time', 'price', 'points'],
        include: [
          { model: SubProcessCode, as: 'process', attributes: ['id', 'process_code', 'process_name'] },
          { model: SubEquipmentCode, as: 'equipment', attributes: ['id', 'equipment_code', 'equipment_name'] }
        ]
      }
    ],
    order: [['created_at', 'DESC']],
  })
  const fromData = rows.map(e => {
    const item = e.toJSON()
    const product = item.processBom.product
    item.name = `${product.product_code}:${product.product_name}`
    return item
  })
  
  // 返回所需信息
  res.json({ 
    data: formatArrayTime(fromData), 
    code: 200 
  });
});
/**
 * @swagger
 * /api/getMaterialMent:
 *   get:
 *     summary: 材料报价列表
 *     tags:
 *       - 常用列表(GetList)
 */
router.get('/getMaterialMent', authMiddleware, async (req, res) => {
  const { company_id, print_id, id } = req.user;
  
  const whereObj = {}
  if(print_id) whereObj.print_id = print_id
  if(id) whereObj.id = id
  const rows = await SubMaterialMent.findAll({
    where: {
      is_deleted: 1,
      company_id,
      ...whereObj
    },
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
 * /api/getNoEncoding:
 *   get:
 *     summary: 获取打印单号
 *     tags:
 *       - 常用列表(GetList)
 */
router.get('/getNoEncoding', authMiddleware, async (req, res) => {
  const { no } = req.query
  const { company_id } = req.user;
  const printType = req.query['printType[]']

  const rows = await SubNoEncoding.findAll({
    where: {
      company_id,
      print_type: printType
    },
    attributes: ['id', 'no', 'print_type'],
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
 * /api/getMaterialBom:
 *   get:
 *     summary: 获取材料BOM列表
 *     tags:
 *       - 常用列表(GetList)
 */
router.get('/getMaterialBom', authMiddleware, async (req, res) => {
  const { product_id } = req.query;
  const { company_id } = req.user;

  const where = {
    company_id,
    archive: 0,
    is_deleted: 1,
  }
  if(product_id) where.product_id = product_id
  const rows = await SubMaterialBom.findAll({
    where,
    attributes: ['id', 'product_id', 'part_id'],
    include: [
      { model: SubProductCode, as: 'product', attributes: ['id', 'product_code', 'product_name'] },
      { model: SubPartCode, as: 'part', attributes: ['id', 'part_code', 'part_name'] },
    ],
    order: [['created_at', 'DESC']],
  })
  const result = rows.map(e => {
    const item = e.toJSON()
    item.name = `${item.product.product_code}:${item.product.product_name} - ${item.part.part_code}:${item.part.part_name}`
    return item
  })
  const data = result.map(item => {
    const { part, product, ...newData } = item
    return newData
  })
  res.json({ code: 200, data })
})
/**
 * @swagger
 * /api/getMaterialBom2:
 *   get:
 *     summary: 获取材料BOM列表2.0
 *     tags:
 *       - 常用列表(GetList)
 */
router.get('/getMaterialBom2', authMiddleware, async (req, res) => {
  const { product_id } = req.query;
  const { company_id } = req.user;

  const where = {
    company_id,
    archive: 0,
    is_deleted: 1,
  }
  if(product_id) where.product_id = product_id
  const rows = await SubMaterialBom.findAll({
    where,
    attributes: ['id', 'product_id', 'part_id'],
    include: [
      { model: SubProductCode, as: 'product', attributes: ['id', 'product_code', 'product_name'] },
      { model: SubPartCode, as: 'part', attributes: ['id', 'part_code', 'part_name'] },
    ],
    order: [['created_at', 'DESC']],
  })

  const resultObj = {};
  rows.forEach(e => {
    const item = e.toJSON()
    const { product_id } = item;
    if(!resultObj[product_id]){
      resultObj[product_id] = item;
      resultObj[product_id].name = `${item.product.product_code}:${item.product.product_name}`
    }
  });
  const data = Object.values(resultObj)
  res.json({ code: 200, data })
})
/**
 * @swagger
 * /api/getMaterialBomChildren:
 *   get:
 *     summary: 获取材料BOM子数据
 *     tags:
 *       - 常用列表(GetList)
 */
router.get('/getMaterialBomChildren', authMiddleware, async (req, res) => {
  const { id } = req.query

  const rows = await SubMaterialBomChild.findAll({
    where: {
      material_bom_id: id
    },
    attributes: ['id', 'material_bom_id', 'material_id', 'is_buy'],
    include: [
      { model: SubMaterialCode, as: 'material', attributes: ['id', 'material_code', 'material_name', 'model', 'specification', 'other_features', 'usage_unit', 'purchase_unit'] }
    ]
  })
  const data = rows.map(e => e.toJSON())
  
  res.json({ code: 200, data })
})
/**
 * @swagger
 * /api/getMaterialQuote:
 *   get:
 *     summary: 获取报价单列表
 *     tags:
 *       - 常用列表(GetList)
 */
router.get('/getMaterialQuote', authMiddleware, async (req, res) => {
  const { company_id } = req.user;

  const rows = await SubMaterialQuote.findAll({
    where: {
      company_id,
    },
    attributes: ['id', 'supplier_id', 'material_id', 'price', 'unit', 'delivery', 'packaging', 'transaction_currency', 'other_transaction_terms', 'invoice'],
    include: [
      { model: SubSupplierInfo, as: 'supplier', attributes: ['id', 'supplier_code', 'supplier_abbreviation'] },
      { model: SubMaterialCode, as: 'material', attributes: ['id', 'material_code', 'material_name', 'usage_unit'] }
    ],
    order: [['created_at', 'DESC']],
  })
  const data = rows.map(e => {
    const item = e.toJSON()
    item.name = `${item.supplier.supplier_code}:${item.supplier.supplier_abbreviation} - ${item.material.material_code}:${item.material.material_name}`
    return item
  })

  res.json({ code: 200, data })
})

/**
 * @swagger
 * /api/getMaterialOrderList:
 *   get:
 *     summary: 获取采购单列表
 *     tags:
 *       - 常用列表(GetList)
 */
router.get('/getMaterialOrderList', authMiddleware, async (req, res) => {
  const { id } = req.query
  const { company_id } = req.user;

  const whereObj = {}
  if(id) whereObj.id = id
  const result = await SubMaterialOrder.findAll({
    where: {
      company_id,
      ...whereObj,
      no: {
        [Op.ne]: null,
        [Op.ne]: ''
      }
    },
    attributes: ['id', 'notice_id', 'supplier_id', 'product_id', 'no', 'created_at'],
    include: [
      { model: SubMaterialMent, as: 'order', attributes: ['id', 'material_id', 'material_code', 'material_name', 'model_spec', 'other_features', 'unit', 'usage_unit', 'price', 'order_number', 'number', 'delivery_time', 'order_id', 'is_houser'] },
      { model: SubSupplierInfo, as: 'supplier', attributes: ['id', 'supplier_code', 'supplier_abbreviation'] },
      { model: SubProductNotice, as: 'notice', attributes: ['id', 'notice'] },
      { model: SubProductCode, as: 'product', attributes: ['id', 'product_code', 'product_name'] }
    ],
    order: [['id', 'ASC']],
  })
  const data = result.map(e => e.toJSON())

  res.json({ code: 200, data })
})

/**
 * @swagger
 * /api/getConstUser:
 *   get:
 *     summary: 获取常量列表(所有)
 *     tags:
 *       - 常用列表(GetList)
 */
router.get('/getConstUser', authMiddleware, async (req, res) => {
  const { company_id } = req.user;

  const result = await SubConstUser.findAll({ where: { company_id, status: 1 }, raw: true })

  res.json({ code: 200, data: result })
})

/**
 * @swagger
 * /api/user:
 *   get:
 *     summary: 获取后台所有用户列表
 *     tags:
 *       - 常用列表(GetList)
 *     parameters:
 *       - name: page
 *         schema:
 *           type: integer
 *           default: 1
 *       - name: pageSize
 *         schema:
 *           type: integer
 *           default: 10
 */
router.get('/getUser', authMiddleware, async (req, res) => {
  const { company_id, id: userId } = req.user;
  // 查询当前页的数据
  const rows = await AdUser.findAll({
    where: {
      is_deleted: 1,
      type: { [Op.ne]: 1 },
      company_id,
    },
    attributes: ['id', 'name', 'cycle_id', 'parent_id', 'username', 'parent_id', 'status', 'power', 'created_at'],
    order: [['created_at', 'DESC']],
    raw: true,
  })


  // 返回所需信息
  res.json({ 
    data: formatArrayTime(rows), 
    code: 200
  });
});

/**
 * @swagger
 * /api/getOutList:
 *   get:
 *     summary: 获取委外加工单列表
 *     tags:
 *       - 常用列表(GetList)
 */
router.get('/getOutList', authMiddleware, async (req, res) => {
  const { company_id, id: userId } = req.user;

  const result = await SubOutsourcingOrder.findAll({
    where: {
      company_id,
      no: {
        [Op.ne]: null,
        [Op.ne]: ''
      }
    },
    attributes: ['id', 'notice_id', 'notice', 'supplier_id', 'supplier_code', 'supplier_abbreviation', 'product_id', 'product_code', 'product_name', 'no'],
    include: [
      { model: subOutscriptionOrder, as: 'order', attributes: ['id', 'notice_id', 'quote_id', 'supplier_id', 'process_bom_id', 'process_bom_children_id', 'unit', 'price', 'number', 'transaction_currency', 'ment', 'delivery_time', 'transaction_terms'] }
    ]
  })

  const data = result.map(e => e.toJSON())

  res.json({ code: 200, data })
})


module.exports = router;  