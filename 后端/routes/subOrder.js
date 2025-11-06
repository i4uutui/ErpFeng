const express = require('express');
const router = express.Router();
const { SubCustomerInfo, SubProductQuotation, SubProductCode, SubPartCode, SubSaleOrder, SubProductNotice, SubProductionProgress, SubProcessBom, SubProcessBomChild, SubProcessCycle, Op, SubSaleCancel, SubProgressBase, SubProgressCycle, SubProgressWork } = require('../models')
const authMiddleware = require('../middleware/auth');
const { formatArrayTime, formatObjectTime } = require('../middleware/formatTime');
const { PreciseMath, getSaleCancelIds } = require('../middleware/tool');

// 获取客户信息列表（分页）
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
    attributes: ['id', "customer_code", "customer_abbreviation", "contact_person", "contact_information", "company_full_name", "company_address", "delivery_address", "tax_registration_number", "transaction_method", "transaction_currency", "other_transaction_terms"],
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

// 添加客户信息
router.post('/customer_info', authMiddleware, async (req, res) => {
  const { customer_code, customer_abbreviation, contact_person, contact_information, company_full_name, company_address, delivery_address, tax_registration_number, transaction_method, transaction_currency, other_transaction_terms } = req.body;
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
    customer_code, customer_abbreviation, contact_person, contact_information, company_full_name, company_address, delivery_address, tax_registration_number, transaction_method, transaction_currency, other_transaction_terms, company_id,
    user_id: userId
  })

  res.json({ message: "添加成功", code: 200 });
});

// 更新客户信息接口
router.put('/customer_info', authMiddleware, async (req, res) => {
  const { customer_code, customer_abbreviation, contact_person, contact_information, company_full_name, company_address, delivery_address, tax_registration_number, transaction_method, transaction_currency, other_transaction_terms, id } = req.body;
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
    customer_code, customer_abbreviation, contact_person, contact_information, company_full_name, company_address, delivery_address, tax_registration_number, transaction_method, transaction_currency, other_transaction_terms, company_id,
    user_id: userId
  }, {
    where: { id }
  })
  if (updateResult.length == 0) {
    return res.json({ message: '未找到该客户信息', code: 404 });
  }
  
  res.json({ message: "修改成功", code: 200 });
});
// 删除客户信息
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




// 获取销售订单列表（分页）
router.get('/sale_order', authMiddleware, async (req, res) => {
  const { page = 1, pageSize = 10, customer_code, customer_abbreviation, customer_order, product_code, product_name, drawing } = req.query;
  const offset = (page - 1) * pageSize;
  const { company_id } = req.user;

  let whereCustomer = {}
  let whereProduct = {}
  let whereSale = {}
  if(customer_code) whereCustomer.customer_code = { [Op.like]: `%${customer_code}%` }
  if(customer_abbreviation) whereCustomer.customer_abbreviation = { [Op.like]: `%${customer_abbreviation}%` }
  if(product_code) whereProduct.product_code = { [Op.like]: `%${product_code}%` }
  if(product_name) whereProduct.product_name = { [Op.like]: `%${product_name}%` }
  if(drawing) whereProduct.drawing = { [Op.like]: `%${drawing}%` }
  if(customer_order) whereSale.customer_order = { [Op.like]: `%${customer_order}%` }
  const { count, rows } = await SubSaleOrder.findAndCountAll({
    where: {
      is_deleted: 1,
      company_id,
      ...whereSale
    },
    attributes: ['id', 'rece_time', 'customer_order', 'product_req', 'order_number', 'unit', 'delivery_time', 'goods_time', 'goods_address', 'is_sale', 'created_at'],
    include: [
      { model: SubCustomerInfo, as: 'customer', attributes: ['id', 'customer_code', 'customer_abbreviation'], where: whereCustomer},
      { model: SubProductCode, as: 'product', attributes: ['id', 'product_code', 'product_name', 'drawing', 'component_structure', 'model', 'specification', 'other_features'], where: whereProduct },
      { model: SubProductNotice, as: 'notice', attributes: ['id'] },
      { model: SubSaleCancel, as: 'saleCancel', attributes: ['id', 'sale_id'] }
    ],
    order: [
      ['product', 'product_name', 'DESC'],
      ['created_at', 'DESC']
    ],
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

// 添加销售订单
router.post('/sale_order', authMiddleware, async (req, res) => {
  const { customer_id, product_id, rece_time, customer_order, product_req, order_number, unit, delivery_time, goods_time, goods_address } = req.body;
  
  const { id: userId, company_id } = req.user;
  
  await SubSaleOrder.create({
    customer_id, product_id, rece_time, customer_order, product_req, order_number, unit, delivery_time, goods_time, goods_address, company_id,
    user_id: userId,
    actual_number: order_number
  })
  
  res.json({ message: '添加成功', code: 200 });
});

// 更新销售订单
router.put('/sale_order', authMiddleware, async (req, res) => {
  const { customer_id, product_id, rece_time, customer_order, product_req, order_number, unit, delivery_time, goods_time, goods_address, actual_number, id } = req.body;
  const { id: userId, company_id } = req.user;

  const result = await SubSaleOrder.findByPk(id)
  if(!result) return res.json({ message: '订单不存在，或已被删除', code: 401})
  
  if(order_number != result.order_number){
    const progress = await SubProgressBase.findAll({
      where: {
        sale_id: id,
        company_id
      },
      attributes: ['id', 'out_number', 'house_number', 'bom_id', 'company_id', 'user_id']
    })
    const progressResult = progress.map(e => {
      const item = e.toJSON()
      item.out_number = item.house_number ? PreciseMath.sub(order_number, item.house_number) : order_number
      return item
    })
    const work = await SubProgressWork.findAll({
      where: {
        progress_id: progress.map(e => e.id),
        company_id
      },
      attributes: ['id', 'order_number', 'finish', 'bom_id']
    })
    if(work && work.length){
      const bomChildResult = work.map(e => {
        const item = e.toJSON()
        progressResult.forEach(o => {
          if(o.bom_id == item.bom_id){
            const n = item.finish ? PreciseMath.sub(order_number, item.finish) : order_number
            item.order_number = o.house_number ? PreciseMath.sub(n, o.house_number) : n
          }
        })
        return item
      })
      if(progress && progress.length){
        await SubProgressBase.bulkCreate(progressResult, {
          updateOnDuplicate: ['out_number', 'company_id', 'user_id']
        })
      }
      await SubProgressWork.bulkCreate(bomChildResult, {
        updateOnDuplicate: ['order_number']
      })
    }
  }

  await result.update({
    customer_id, product_id, rece_time, customer_order, product_req, order_number, unit, delivery_time, goods_time, goods_address, actual_number, company_id,
    user_id: userId,
  }, {
    where: {
      id
    }
  })
  
  res.json({ message: '修改成功', code: 200 });
});
// 取消销售订单
router.post('/sale_cancel', authMiddleware, async (req, res) => {
  const { id, notice_id } = req.body
  const { id: userId, company_id } = req.user;

  const result = await SubSaleOrder.findByPk(id)
  if(!result) return res.json({ code: 401, message: '销售订单不存在' })
  
  const body = {
    sale_id: id,
    company_id,
    user_id: userId
  }
  if(notice_id) body.notice_id = notice_id
  await SubSaleCancel.create(body)

  res.json({ code: 200, message: '取消成功' })
})





// 获取产品报价列表（分页）
router.get('/product_quotation', authMiddleware, async (req, res) => {
  const { page = 1, pageSize = 10, customer_code, customer_abbreviation, notice, product_code, product_name, drawing } = req.query;
  const offset = (page - 1) * pageSize;
  const { company_id } = req.user;

  const saleIds = await getSaleCancelIds('sale_id', { company_id })
  
  let whereCustomer = {}
  let whereProduct = {}
  let whereNotice = {}
  if(customer_code) whereCustomer.customer_code = { [Op.like]: `%${customer_code}%` }
  if(customer_abbreviation) whereCustomer.customer_abbreviation = { [Op.like]: `%${customer_abbreviation}%` }
  if(product_code) whereProduct.product_code = { [Op.like]: `%${product_code}%` }
  if(product_name) whereProduct.product_name = { [Op.like]: `%${product_name}%` }
  if(drawing) whereProduct.drawing = { [Op.like]: `%${drawing}%` }
  if(notice) whereNotice.notice = { [Op.like]: `%${notice}%` }
  const { count, rows } = await SubProductQuotation.findAndCountAll({
    where: {
      is_deleted: 1,
      company_id,
      sale_id: { [Op.notIn]: saleIds },
      ...whereNotice
    },
    attributes: ['id', 'notice', 'product_price', 'transaction_currency', 'other_transaction_terms', 'created_at'],
    include: [
      { model: SubSaleOrder, as: 'sale', attributes: ['id', 'customer_order', 'order_number', 'unit'] },
      { model: SubCustomerInfo, as: 'customer', attributes: ['id', 'customer_code', 'customer_abbreviation'], where: whereCustomer },
      { model: SubProductCode, as: 'product', attributes: ['id', 'product_code', 'product_name', 'model', 'specification', 'other_features', 'drawing'], where: whereProduct }
    ],
    order: [
      ['product', 'product_name', 'DESC'],
      ['created_at', 'DESC']
    ],
    distinct: true,
    limit: parseInt(pageSize),
    offset
  })
  
  const totalPages = Math.ceil(count / pageSize);
  
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
// 添加产品报价
router.post('/product_quotation', authMiddleware, async (req, res) => {
  const { sale_id, notice, product_price, transaction_currency, other_transaction_terms } = req.body;
  
  const { id: userId, company_id } = req.user;
  
  let customer_id = ''
  let product_id = ''
  const saleOrder = await SubSaleOrder.findOne({
    where: { id: sale_id },
    raw: true
  })
  if(saleOrder){
    customer_id = saleOrder.customer_id
    product_id = saleOrder.product_id
  }else{
    return res.json({ code: 401, message: '数据出错，请联系管理员' })
  }
  const create = {
    sale_id, customer_id, product_id, notice, product_price, transaction_currency, other_transaction_terms, company_id,
    user_id: userId
  }
  await SubProductQuotation.create(create)
  
  res.json({ message: '添加成功', code: 200 });
});
// 更新产品报价
router.put('/product_quotation', authMiddleware, async (req, res) => {
  const { sale_id, notice, product_price, transaction_currency, other_transaction_terms, id } = req.body;
  
  const { id: userId, company_id } = req.user;

  let customer_id = ''
  let product_id = ''
  const saleOrder = await SubSaleOrder.findOne({
    where: { id: sale_id },
    raw: true
  })
  if(saleOrder){
    customer_id = saleOrder.customer_id
    product_id = saleOrder.product_id
  }else{
    return res.json({ code: 401, message: '数据出错，请联系管理员' })
  }
  
  const updateResult = await SubProductQuotation.update({
    sale_id, customer_id, product_id, notice, product_price, transaction_currency, other_transaction_terms, company_id,
    user_id: userId
  }, {
    where: { id }
  })
  if(updateResult.length == 0) return res.json({ message: '数据不存在，或已被删除', code: 401})
  
  res.json({ message: '修改成功', code: 200 });
});



// 生产通知单
router.get('/product_notice', authMiddleware, async (req, res) => {
  const { page = 1, pageSize = 10, notice, customer_code, customer_abbreviation, product_code, product_name, drawing, customer_order, goods_address, is_finish } = req.query;
  const offset = (page - 1) * pageSize;
  const { company_id } = req.user;

  const saleIds = await getSaleCancelIds('sale_id', { company_id })

  let saleOrderWhere = {}
  let customerInfoWhere = {}
  let whereObj = {}
  let whereProduct = {}
  if(customer_order) saleOrderWhere.customer_order = { [Op.like]: `%${customer_order}%` }
  if(goods_address) saleOrderWhere.goods_address = { [Op.like]: `%${goods_address}%` }
  if(customer_code) customerInfoWhere.customer_code = { [Op.like]: `%${customer_code}%` }
  if(customer_abbreviation) customerInfoWhere.customer_abbreviation = { [Op.like]: `%${customer_abbreviation}%` }
  if(notice) whereObj.notice = { [Op.like]: `%${notice}%` }
  if(product_code) whereProduct.product_code = { [Op.like]: `%${product_code}%` }
  if(product_name) whereProduct.product_name = { [Op.like]: `%${product_name}%` }
  if(drawing) whereProduct.drawing = { [Op.like]: `%${drawing}%` }
  const { count, rows } = await SubProductNotice.findAndCountAll({
    where: {
      is_deleted: 1,
      company_id,
      sale_id: { [Op.notIn]: saleIds },
      is_finish,
      ...whereObj
    },
    include: [
      { model: SubSaleOrder, as: 'sale', where: saleOrderWhere },
      { model: SubCustomerInfo, as: 'customer', where: customerInfoWhere },
      { model: SubProductCode, as: 'product', where: whereProduct }
    ],
    order: [
      ['created_at', 'DESC']
    ],
    distinct: true,
    limit: parseInt(pageSize),
    offset,
    nest: true,
  })
  const totalPages = Math.ceil(count / pageSize);
  
  const fromData = rows.map(item => item.dataValues)
  
  res.json({ 
    data: formatArrayTime(fromData), 
    total: count, 
    totalPages, 
    currentPage: parseInt(page), 
    pageSize: parseInt(pageSize),
    code: 200 
  });
})
// 生产订单操作完结
router.post('/finish_production_notice', authMiddleware, async (req, res) => {
  const { id } = req.body

  const notice = await SubProductNotice.findByPk(id)
  if(!notice) return res.json({ message: '数据不存在，或已被删除', code: 401 });

  await notice.update({ is_finish: 0 },{ where: { id } })
  await SubProductionProgress.update({ is_finish: 0 }, { where: { notice_id: id } })

  res.json({ message: '操作成功', code: 200 });
})
// 新增生产通知单
router.post('/product_notice', authMiddleware, async (req, res) => {
  const { sale_id, notice, delivery_time } = req.body;
  const { id: userId, company_id } = req.user;

  let customer_id = ''
  let product_id = ''
  const quote = await SubSaleOrder.findOne({
    where: { id: sale_id, company_id },
    raw: true
  })
  if(quote){
    customer_id = quote.customer_id
    product_id = quote.product_id
  }else{
    return res.json({ code: 401, message: '销售订单不存在' })
  }

  await SubSaleOrder.update({ is_sale: 0 }, { where: { id: sale_id } })
  
  await SubProductNotice.create({
    notice, customer_id, product_id, sale_id, delivery_time, company_id,
    user_id: userId
  })
  await SubSaleOrder.update({ is_sale: 0 }, { where: { id: sale_id } })
  res.json({ message: '添加成功', code: 200 });
});
// 修改生产通知单
router.put('/product_notice', authMiddleware, async (req, res) => {
  const { notice, sale_id, delivery_time, id } = req.body;
  const { id: userId, company_id } = req.user;

  let customer_id = ''
  let product_id = ''
  const quote = await SubSaleOrder.findOne({
    where: { id: sale_id, company_id },
    raw: true
  })
  if(quote){
    customer_id = quote.customer_id
    product_id = quote.product_id
  }else{
    return res.json({ code: 401, message: '销售订单不存在' })
  }

  const noticeRow = await SubProductNotice.findByPk(id)
  if(!noticeRow) return res.json({ code: 401, message: '生产订单不存在' })
  const noticeResult = noticeRow.toJSON()
  if(noticeResult.sale_id != sale_id){ // 如果修改生产订单后，销售订单更换了
    const saleArr = [
      { is_sale: 1, id: noticeResult.sale_id }, // 旧数据的销售订单变成未创建
      { is_sale: 0, id: sale_id }, // 新绑定的数据变成已创建
    ]
    await SubSaleOrder.bulkCreate(saleArr, {
      updateOnDuplicate: ['is_sale']
    })
  }
  
  const updateResult = await SubProductNotice.update({
    notice, customer_id, product_id, sale_id, delivery_time, company_id,
    user_id: userId
  }, {
    where: {
      id
    }
  })
  if(updateResult.length == 0) return res.json({ message: '数据不存在，或已被删除', code: 401})
  
  res.json({ message: '修改成功', code: 200 });
});

// 通知单排产
router.post('/set_production_progress', authMiddleware, async (req, res) => {
  const { id } = req.body;
  const { id: userId, company_id } = req.user;
  
  // 验证数据是否存在
  const notice = await SubProductNotice.findOne({
    where: { id },
    attributes: ['id', 'product_id', 'sale_id', 'customer_id', 'is_notice', 'notice', 'delivery_time'],
    include: [
      { model: SubProductCode, as: 'product', attributes: ['id', 'product_code', 'product_name', 'drawing'] },
      { model: SubSaleOrder, as: 'sale', attributes: ['id', 'order_number'] }
    ]
  });
  if (!notice) return res.json({ message: '数据不存在，或已被删除', code: 401 });
  const noticeRow = notice.toJSON()
  if (!notice.is_notice) return res.json({ message: '订单不能重复排产', code: 401 });


  const allCycles = await SubProcessCycle.findAll({
    where: {
      company_id,
      sort: { [Op.gt]: 0 }
    },
    attributes: ['id'],
    order: [['sort', 'ASC']]
  })
  if(allCycles.length == 0) return res.json({ message: '未配置制程组，请先配置生产制程组', code: 401 })
  const cycles = allCycles.map(o => o.toJSON())

  // 通过产品id查找工艺BOM中相同的产品id数据
  const bom = await SubProcessBom.findAll({
    where: {
      product_id: noticeRow.product_id,
      archive: 0
    },
    attributes: ['id', 'archive', 'product_id', 'part_id', 'sort'],
    include: [
      { model: SubProcessBomChild, as: 'children', attributes: ['id', 'time', 'process_index'] },
      { model: SubPartCode, as: 'part', attributes: ['id', 'part_code', 'part_name'] }
    ],
    order: [
      ['sort', 'ASC'],
      ['children', 'process_index', 'ASC']
    ],
  })
  const bomResult =  bom.map(e => e.toJSON())
  if(bomResult.length == 0) return res.json({ message: '该订单无工艺BOM，或工艺BOM未存档，暂时无法排产', code: 401 })
  

  
  let progress = []
  let childProgress = []
  bomResult.forEach(item => {
    // 这是进度表的基础数据
    const obj = {
      company_id,
      user_id: userId,
      notice_id: noticeRow.id,
      sale_id: noticeRow.sale_id,
      product_id: noticeRow.product.id,
      product_code: noticeRow.product.product_code,
      product_name: noticeRow.product.product_name,
      drawing: noticeRow.product.drawing,
      part_id: item.part.id,
      part_code: item.part.part_code,
      part_name: item.part.part_name,
      bom_id: item.id,
      out_number: noticeRow.sale.order_number,
      house_number: null,
      start_date: '',
      remarks: ''
    }
    progress.push(obj)
    // 工序
    item.children.forEach(child => {
      const tk = {
        company_id,
        progress_id: null,
        notice_id: noticeRow.id,
        bom_id: item.id,
        child_id: child.id,
        process_index: child.process_index,
        all_work_time: (PreciseMath.mul(noticeRow.sale.order_number, child.time) / 60 / 60).toFixed(1),
        order_number: noticeRow.sale.order_number,
      }
      childProgress.push(tk)
    })
  })
  const progressArr = ['company_id', 'user_id', 'notice_id', 'sale_id', 'product_id', 'product_code', 'product_name', 'drawing', 'part_id', 'part_code', 'part_name', 'bom_id', 'out_number', 'house_number', 'start_date', 'remarks']
  const progressResult = await SubProgressBase.bulkCreate(progress, { updateOnDuplicate: progressArr })
  // 遍历每条新创建的进度
  const cycleChildData = [];
  progressResult.forEach(e => {
    const item = e.toJSON()
    // 处理制程的事务
    const cycleChildDataForProgress = cycles.map(cycle => ({
      notice_id: noticeRow.id,
      cycle_id: cycle.id,
      progress_id: item.id,
      company_id
    }))
    cycleChildData.push(...cycleChildDataForProgress);
    // 处理工序，加上进度ID
    childProgress.forEach(child => {
      if(child.bom_id == item.bom_id){
        child.progress_id = item.id
      }
    })
  })
  // 制程子数据批量插入
  await SubProgressCycle.bulkCreate(cycleChildData)
  // 工序数据批量插入
  await SubProgressWork.bulkCreate(childProgress, { updateOnDuplicate: ['company_id', 'progress_id', 'notice_id', 'bom_id', 'child_id', 'all_work_time', 'order_number'] }) 

  if(progress.length){
    // 设置此数据为已排产
    await SubProductNotice.update({
      is_notice: 0
    }, { where: { id } })
  }
  
  res.json({ message: '操作成功', code: 200 });
})
module.exports = router;


