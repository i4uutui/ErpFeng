const express = require('express');
const router = express.Router();
const dayjs = require('dayjs')
const { SubSupplierInfo, SubMaterialQuote, SubMaterialCode, SubProductNotice, SubProductCode, SubMaterialMent, SubApprovalUser, SubApprovalStep, Op } = require('../models')
const authMiddleware = require('../middleware/auth');
const { formatArrayTime, formatObjectTime } = require('../middleware/formatTime');


const multer = require('multer');
const path = require('path');
const printer = require('node-printer');
const fs = require('fs');
const { exec } = require('child_process');

/**
 * @swagger
 * /api/supplier_info:
 *   get:
 *     summary: 获取供应商列表（分页）
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
router.get('/supplier_info', authMiddleware, async (req, res) => {
  const { page = 1, pageSize = 10 } = req.query;
  const offset = (page - 1) * pageSize;
  
  const { company_id } = req.user;
  
  const { count, rows } = await SubSupplierInfo.findAndCountAll({
    where: {
      is_deleted: 1,
      company_id,
    },
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

/**
 * @swagger
 * /api/supplier_info:
 *   post:
 *     summary: 添加供应商信息
 *     tags:
 *       - 采购单(Purchase)
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
  const { supplier_code, supplier_abbreviation, contact_person, contact_information, supplier_full_name, supplier_address, supplier_category, supply_method, transaction_method, transaction_currency, other_transaction_terms } = req.body;
  
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
    supplier_code, supplier_abbreviation, contact_person, contact_information, supplier_full_name, supplier_address, supplier_category, supply_method, transaction_method, transaction_currency, other_transaction_terms, company_id,
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
 *       - 采购单(Purchase)
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
  const { supplier_code, supplier_abbreviation, contact_person, contact_information, supplier_full_name, supplier_address, supplier_category, supply_method, transaction_method, transaction_currency, other_transaction_terms, id } = req.body;
  
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
    supplier_code, supplier_abbreviation, contact_person, contact_information, supplier_full_name, supplier_address, supplier_category, supply_method, transaction_method, transaction_currency, other_transaction_terms, company_id,
    user_id: userId
  }, {
    where: { id }
  })
  if (updateResult.length == 0) {
    return res.json({ message: '未找到该供应商信息', code: 404 });
  }
  
  res.json({ message: "修改成功", code: 200 });
});




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
  const { page = 1, pageSize = 10 } = req.query;
  const offset = (page - 1) * pageSize;
  const { company_id } = req.user;
  
  const { count, rows } = await SubMaterialQuote.findAndCountAll({
    where: {
      is_deleted: 1,
      company_id,
    },
    include: [
      { model: SubMaterialCode, as: 'material' },
      { model: SubSupplierInfo, as: 'supplier' },
      { model: SubProductNotice, as: 'notice' },
      { model: SubProductCode, as: 'product' }
    ],
    order: [['created_at', 'DESC']],
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
  const { supplier_id, notice_id, material_id, price, delivery, packaging, transaction_currency, other_transaction_terms, remarks } = req.body;
  
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
  const result = await SubMaterialQuote.create({
    supplier_id, notice_id, material_id, product_id, price, delivery, packaging, transaction_currency, other_transaction_terms, remarks, company_id,
    user_id: userId
  })

  res.json({ message: "添加成功", code: 200 });
});
/**
 * @swagger
 * /api/material_quote:
 *   put:
 *     summary: 修改材料报价
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
  const { supplier_id, notice_id, material_id, price, delivery, packaging, transaction_currency, other_transaction_terms, remarks, id } = req.body;
  
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
    supplier_id, notice_id, material_id, product_id, price, delivery, packaging, transaction_currency, other_transaction_terms, remarks, company_id,
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
 *     summary: 获取采购单的列表
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
router.post('/material_ment', authMiddleware, async (req, res) => {
  const { notice, supplier_code, product_code, status } = req.body;
  const { company_id } = req.user;
  
  let whereMent = {}
  if(notice) whereMent.notice = notice
  if(supplier_code) whereMent.supplier_code = supplier_code
  if(product_code) whereMent.product_code = product_code
  whereMent.status = status ? status : [0, 2]
  const rows = await SubMaterialMent.findAll({
    where: {
      is_deleted: 1,
      company_id,
      ...whereMent
    },
    include: [
      { model: SubApprovalUser, as: 'approval', attributes: [ 'user_id', 'user_name', 'type', 'step', 'company_id', 'source_id', 'user_time', 'status', 'id' ], order: [['step', 'ASC']], separate: true, }
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
 * /api/add_material_ment:
 *   post:
 *     summary: 创建采购单审批
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
  const result = await SubMaterialMent.bulkCreate(dataValue, {
    updateOnDuplicate: ['company_id', 'user_id', 'apply_id', 'apply_name', 'apply_time', 'status', 'notice_id', 'notice', 'supplier_id', 'supplier_code', 'supplier_abbreviation', 'product_id', 'product_code', 'product_name', 'material_id', 'material_code', 'material_name', 'model_spec', 'other_features', 'unit', 'price', 'order_number', 'number', 'delivery_time']
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
      { model: SubApprovalUser, as: 'approval', attributes: [ 'user_id', 'user_name', 'type', 'step', 'company_id', 'source_id', 'user_time', 'status', 'id' ], order: [['step', 'ASC']], separate: true, }
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

  await SubMaterialMent.update({
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
/**
 * @swagger
 * /api/material_ment:
 *   put:
 *     summary: 修改采购单
 *     tags:
 *       - 采购单(Purchase)
 */
router.put('/material_ment', authMiddleware, async (req, res) => {
  const { notice_id, notice, supplier_id, supplier_code, supplier_abbreviation, product_id, product_code, product_name, material_id, material_code, material_name, model_spec, other_features, unit, price, order_number, number, delivery_time, id } = req.body;
  const { id: userId, company_id } = req.user;

  const result = await SubMaterialMent.findByPk(id)
  if(!result) res.json({ message: '未找到该采购单信息', code: 401 })
  
  const obj = {
    notice_id, notice, supplier_id, supplier_code, supplier_abbreviation, product_id, product_code, product_name, material_id, material_code, material_name, model_spec, other_features, unit, price, order_number, number, delivery_time, company_id,
    user_id: userId
  }
  const updateResult = await SubMaterialMent.update(obj, {
    where: {
      id
    }
  })
  if(updateResult.length == 0) return res.json({ message: '数据不存在，或已被删除', code: 401})
  
  res.json({ message: '修改成功', code: 200 });
})

router.get('/printers', authMiddleware, async (req, res) => {
  exec('wmic printer get name, status', (err, stdout, stderr) => {
    if (err) {
      reject(new Error(`执行命令失败: ${err.message}`));
      return;
    }
    if (stderr) {
      reject(new Error(`命令错误输出: ${stderr}`));
      return;
    }

    // 清理输出（去除空行、标题行和状态列）
    const lines = stdout .split('\n') .map(line => line.trim()) .filter(line => line.length > 0) .slice(1);

    // 提取打印机名称（处理名称中包含空格的情况）
    const printerNames = lines.map(line => {
      // 打印机状态通常是"空闲"、"离线"等短词，从末尾截取状态部分
      // 状态与名称之间至少有两个空格分隔
      const statusMatch = line.match(/\s{2,}(.+)$/);
      if (statusMatch) {
        // 去除状态部分，剩余的即为打印机名称
        return line.replace(statusMatch[0], '').trim();
      }
      // 没有状态信息时，整行都是名称
      return line;
    });
    res.json({ code: 200, data: printerNames })
  })
})

// 配置 multer
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    // 指定图片存储的文件夹
    cb(null, path.join(__dirname, '../public/uploads'));
  },
  filename: function (req, file, cb) {
    // 生成唯一的文件名
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, file.fieldname + '-' + uniqueSuffix + path.extname(file.originalname));
  }
});
const upload = multer({ storage: storage });

router.post('/printers', authMiddleware, upload.single('pdfFile'), async (req, res) => {
  const printerName = req.body.printerName; // 从表单字段获取
  const pdfTempPath = req.file.path;

  if (!printerName) {
    return res.json({ code: 400, message: '缺少打印机名称' });
  }
  if (!pdfTempPath || !fs.existsSync(pdfTempPath)) {
    return res.json({ code: 400, message: '未接收到 PDF 文件' });
  }
  const imagePath = `public/uploads/${req.file.filename}`;
  console.log(imagePath);

  const pdfData = fs.readFileSync(pdfTempPath);
  // 构造打印参数
  const printOptions = {
    printer: printerName,       // 打印机名称
    filename: pdfData,           // 打印数据（Buffer）
    success: jobId => console.log(jobId),
    error: err => console.log(err)
  };
  console.log(printer);
  // 执行打印
  const jobId = printer.print(printOptions);
  console.log(jobId);

  // 打印成功后删除临时文件
  fs.unlinkSync(pdfTempPath);

  res.json({
    code: 200,
    message: '打印任务提交成功',
    jobId: jobId.toString() // jobId返回的是数字类型
  });
})


module.exports = router;