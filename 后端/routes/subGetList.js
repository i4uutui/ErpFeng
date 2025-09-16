const express = require('express');
const router = express.Router();
const { SubProductCode, SubCustomerInfo, SubPartCode, SubMaterialCode, SubSaleOrder, SubProductQuotation, SubProcessCode, SubEquipmentCode, SubSupplierInfo, SubProductNotice, SubProcessBom, SubProcessBomChild, SubProcessCycle, SubConstType, SubOutsourcingOrder, SubMaterialMent, Op } = require('../models');
const authMiddleware = require('../middleware/auth');
const { formatArrayTime, formatObjectTime } = require('../middleware/formatTime');

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
  const { customer_order } = req.query;
  const { company_id } = req.user;
  
  const config = {
    where: { is_deleted: 1, company_id, customer_order: {
      [Op.like]: `%${customer_order}%`
    } },
    include: [
      { model: SubProductCode, as: 'product' },
      { model: SubCustomerInfo, as: 'customer'}
    ],
    order: [['created_at', 'DESC']],
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
  
  const config = {
    where: { is_deleted: 1, company_id, customer_abbreviation: {
      [Op.like]: `%${customer_abbreviation}%`
    } },
    order: [['created_at', 'DESC']],
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
  const { product_code } = req.query;
  const { company_id } = req.user;
  
  let productWhere = {}
  if(product_code) productWhere.product_code = { [Op.like]: `%${product_code}%` }
  const config = {
    where: { is_deleted: 1, company_id, ...productWhere },
    order: [['created_at', 'DESC']],
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
    order: [['created_at', 'DESC']],
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
  const { material_code } = req.query;
  const { company_id } = req.user;
  
  let materialWhere = {}
  if(material_code) productWhere.material_code = { [Op.like]: `%${material_code}%` }
  const config = {
    where: { is_deleted: 1, company_id, ...materialWhere },
    order: [['created_at', 'DESC']],
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
  
  const config = {
    where: { is_deleted: 1, company_id, process_code: {
      [Op.like]: `%${process_code}%`
    } },
    order: [['created_at', 'DESC']],
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
  
  const config = {
    where: { is_deleted: 1, company_id, equipment_code: {
      [Op.like]: `%${equipment_code}%`
    } },
    order: [['created_at', 'DESC']],
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
  const { supplier_code } = req.query;
  
  const { company_id } = req.user;
  
  let supplierWhere = {}
  if(supplier_code) supplierWhere.supplier_code = { [Op.like]: `%${supplier_code}%` }
  const config = {
    where: { is_deleted: 1, company_id, ...supplierWhere },
    order: [['created_at', 'DESC']],
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
  const { notice } = req.query;
  
  const { company_id } = req.user;
  
  let noticeWhere = {}
  if(notice) noticeWhere.notice = { [Op.like]: `%${notice}%` }
  const config = {
    where: { is_deleted: 1, company_id, ...noticeWhere },
    order: [['created_at', 'DESC']],
    include: [
      { model: SubProductCode, as: 'product', attributes: ['id', 'product_code', 'product_name'] },
      { model: SubSaleOrder, as: 'sale', attributes: ['id', 'order_number', 'delivery_time'] },
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
  const { company_id } = req.user;
  
  const rows = await SubProcessBom.findAll({
    where: {
      archive: 0,
      company_id
    },
    attributes: ['id', 'archive', 'product_id', 'part_id'],
    include: [
      { model: SubProductCode, as: 'product', attributes: ['id', 'product_name', 'product_code', 'drawing'] },
      { model: SubPartCode, as: 'part', attributes: ['id', 'part_name', 'part_code'] },
    ],
    order: [
      ['id', 'DESC'],
    ],
  })
  const bom = rows.map(e => {
    const obj = e.toJSON()
    obj.name = `${obj.product.product_code}:${obj.product.product_name} - ${obj.part.part_code}:${obj.part.part_name}`
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
    attributes: ['id', 'process_bom_id', 'process_id', 'equipment_id', 'process_index', 'time', 'price'],
    include: [
      { model: SubProcessCode, as: 'process', attributes: ['id', 'process_code', 'process_name', 'section_points'] },
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
  const { company_id } = req.user;
  
  const rows = await SubProcessCycle.findAll({
    where: {
      company_id
    }
  })
  const cycleRows = rows.map(e => e.toJSON())
  res.json({ data: cycleRows, code: 200 })
})
/**
 * @swagger
 * /api/getConstType:
 *   get:
 *     summary: 获取常量
 *     tags:
 *       - 常用列表(GetList)
 *     parameters:
 *       - name: type
 *         schema:
 *           type: string
 */
router.get('/getConstType', authMiddleware, async (req, res) => {
  const { type } = req.query
  const { company_id } = req.user;
  
  if(!type) return res.json({ message: '缺少常量类型', code: 401 })

  const rows = await SubConstType.findAll({
    where: {
      type
    },
    attributes: ['id', 'name']
  })
  const typeRows = rows.map(e => e.toJSON())
  res.json({ data: typeRows, code: 200 })
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
  const { company_id } = req.user;
  
  const rows = await SubOutsourcingOrder.findAll({
    where: {
      is_deleted: 1,
      company_id,
    },
    attributes: ['id', 'supplier_id', 'notice_id'],
    include: [
      { model: SubSupplierInfo, as: 'supplier', attributes: ['id', 'supplier_abbreviation', 'supplier_code'] },
      { model: SubProductNotice, as: 'notice', attributes: ['id', 'notice'] },
      {
        model: SubProcessBom,
        as: 'processBom',
        attributes: ['id', 'product_id'],
        include: [
          { model: SubProductCode, as: 'product', attributes: ['id', 'product_name', 'product_code'] },
        ]
      },
    ],
    order: [['created_at', 'DESC']],
  })
  const fromData = rows.map(item => item.toJSON())
  
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
  const { company_id } = req.user;
  
  const rows = await SubMaterialMent.findAll({
    where: {
      is_deleted: 1,
      company_id,
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

module.exports = router;  