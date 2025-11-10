const express = require('express');
const dayjs = require('dayjs')
const isSameOrAfter = require('dayjs/plugin/isSameOrAfter')
const isSameOrBefore = require('dayjs/plugin/isSameOrBefore');
dayjs.extend(isSameOrAfter);
dayjs.extend(isSameOrBefore);
const router = express.Router();
const { SubProductionProgress, SubProductNotice, SubProductCode, SubSaleOrder, SubPartCode, SubProcessBomChild, SubProcessCode, SubEquipmentCode, SubProcessCycle, SubProcessBom, SubOperationHistory, SubRateWage, Op, SubProductionCycle, SubProductionProcess, SubProcessCycleChild, SubDateInfo, SubCustomerInfo, SubProgressBase, SubProgressCycle, SubProgressWork } = require('../models');
const authMiddleware = require('../middleware/auth');
const EmployeeAuth = require('../middleware/EmployeeAuth');
const { formatArrayTime, formatObjectTime } = require('../middleware/formatTime');
const { PreciseMath, getSaleCancelIds } = require('../middleware/tool');
const { setProgressLoad, setCycleLoad, setDateMore, getDateInfo } = require('../middleware/fun');

// 获取进度表基础数据
router.get('/get_progress_base', authMiddleware, async (req, res) => {
  const { company_id } = req.user;

  const noticeIds = await getSaleCancelIds('notice_id', { company_id })

  const result = await SubProgressBase.findAll({
    where: {
      company_id,
      notice_id: { [Op.notIn]: noticeIds },
      is_finish: 1,
      is_deleted: 1
    },
    attributes: ['id', 'notice_id', 'sale_id', 'product_id', 'product_code', 'product_name', 'drawing', 'part_id', 'part_code', 'part_name', 'bom_id', 'house_number', 'out_number', 'start_date', 'remarks'],
    include: [
      { model: SubProductNotice, as: 'notice', attributes: ['id', 'notice', 'delivery_time'] },
      {
        model: SubSaleOrder,
        as: 'sale',
        attributes: ['id', 'order_number', 'customer_order', 'rece_time'],
        include: [
          { model: SubCustomerInfo, as: 'customer', attributes: ['id', 'customer_abbreviation'] }
        ]
      }
    ],
    order: [['id', 'ASC']]
  })
  const data = result.map(e => e.toJSON())

  res.json({ code: 200, data })
})

// 获取进度表制程和工序的数据
router.post('/get_progress_cycle', authMiddleware, async (req, res) => {
  const { base } = req.body
  const { company_id } = req.user;

  if(!base.length) return res.json({ code: 401, message: '数据出错' })

  const progress_id = base.map(e => e.id)
  const [ cycle, work, dates ] = await Promise.all([
    SubProcessCycle.findAll({
      where: {
        company_id,
        sort: { [Op.gt]: 0 }
      },
      attributes: ['id', 'name', 'sort', 'sort_date'],
      order: [['sort', 'ASC'], ['cycle', 'progress_id', 'ASC']],
      include: [
        { model: SubProgressCycle, as: 'cycle', attributes: ['id', 'notice_id', 'progress_id', 'cycle_id', 'end_date', 'load', 'order_number'], where: { progress_id } },
        { model: SubEquipmentCode, as: 'equipment', attributes: ['id', 'efficiency'], }
      ]
    }),
    SubProgressWork.findAll({
      where: {
        company_id,
        progress_id
      },
      attributes: ['id', 'progress_id', 'notice_id', 'bom_id', 'child_id', 'all_work_time', 'load', 'finish', 'order_number'],
      include: [
        {
          model: SubProcessBomChild,
          as: 'children',
          attributes: ['id', 'process_index', 'process_id', 'time', 'price', 'points', 'equipment_id'],
          include: [
            { model: SubProcessCode, as: 'process', attributes: ['id', 'process_code', 'process_name'] },
            {
              model: SubEquipmentCode,
              as: 'equipment',
              attributes: ['id', 'equipment_code', 'equipment_name'],
              include: [
                { model: SubProcessCycle, as: 'cycle', attributes: ['id', 'name'] }
              ]
            }
          ]
        }
      ],
      order: [
        ['progress_id', 'ASC'],
        ['children', 'process_index', 'ASC']
      ]
    }),
    // 用户设置的假期
    SubDateInfo.findAll({
      where: { company_id },
      attributes: ['date']
    })
  ])
  const dateInfo = dates.map(e => {
    const item = e.toJSON()
    return item.date
  })
  const cycles = cycle.map(e => {
    const item = e.toJSON()
    item.maxLoad = e.equipment.reduce((total, current) => {
      const value = current.efficiency && typeof current.efficiency === 'number' ? current.efficiency : 0;
      return total + value;
    }, 0)
    return item
  })

  const works = work.map(e => e.toJSON())
  works.forEach(item => {
    item.all_work_time = (PreciseMath.mul(Number(item.order_number), Number(item.children.time)) / 60 / 60).toFixed(1)
  })
  // 获取日期列表(deliveryTimes先获取客户交期的数组)
  const deliveryTimes = [...new Set(base.map(e => e.delivery_time))]
  const date_more = getDateInfo(deliveryTimes)
  // 处理工序的每日负荷
  const cased = setProgressLoad(base, cycles, works, dateInfo)
  // 处理制程日总负荷
  const callLoad = setCycleLoad(cycles, cased)
  // 处理页面头部的日期
  const newCycles = setDateMore(base, callLoad, dateInfo, date_more)

  res.json({ code: 200, data: { cycles: newCycles, works: cased, date_more } })
})
// 获取进度表工序数据
router.post('/get_progress_work', authMiddleware, async (req, res) => {
  const data = work.map(e => e.toJSON())
  data.forEach(item => {
    item.all_work_time = (PreciseMath.mul(Number(item.order_number), Number(item.children.time)) / 60 / 60).toFixed(1)
  })
  base.forEach(e => {
    if(!e.start_date) return

  })

  res.json({ code: 200, data })
})
// 进度表页面刷新数据接口
// router.post('/set_progress_refresh', authMiddleware, async (req, res) => {
//   const { company_id } = req.user;

//   const noticeIds = await getSaleCancelIds('notice_id', { company_id })

//   const result = await SubProgressWork.findAll({
//     where: {
//       company_id,
//       notice_id: { [Op.notIn]: noticeIds },
//     }
//   })
// })

router.post('/set_out_number', authMiddleware, async (req, res) => {
  const { id, house_number, order_number } = req.body
  const { id: userId, company_id } = req.user;
  
  const handleHouseNumber = house_number === undefined || house_number === null ? 0 : Number(house_number);
  if(isNaN(handleHouseNumber) || handleHouseNumber < 0){
    return res.json({ message: '委外/库存数量不能小于0', code: 401 });
  }
  const result = await SubProgressBase.findOne({
    where: { id, company_id },
    attributes: ['id', 'company_id', 'user_id', 'out_number', 'notice_id', 'bom_id']
  })
  if(!result) return res.json({ message: '数据不存在，或已被删除', code: 401 })
  const row = result.toJSON()
  
  row.out_number = PreciseMath.sub(order_number, handleHouseNumber)
  row.house_number = handleHouseNumber
  await SubProgressBase.update(row, { where: { id } })

  const bomChild = await SubProgressWork.findAll({
    where: {
      notice_id: row.notice_id,
      progress_id: id,
      company_id
    },
    attributes: ['id', 'order_number', 'finish', 'bom_id']
  })
  if(bomChild && bomChild.length){
    const bomChildResult = bomChild.map(e => {
      const item = e.toJSON()
      console.log(item);
      console.log(row);
      if(row.bom_id == item.bom_id){
        const n = item.finish ? PreciseMath.sub(order_number, item.finish) : order_number
        item.order_number = handleHouseNumber ? PreciseMath.sub(n, handleHouseNumber) : n
      }
      return item
    })
    await SubProgressWork.bulkCreate(bomChildResult, {
      updateOnDuplicate: ['order_number']
    })
  }

  res.json({ message: '修改成功', code: 200 });
})
router.put('/set_production_date', authMiddleware, async (req, res) => {
  const { params, type } = req.body
  const { id: userId, company_id } = req.user;

  if(!(type == 'start_date' || type == 'end_date')) return res.json({ message: 'type参数错误', code: 401 })
  if(!Array.isArray(params) || params.length === 0) return res.json({ message: '数据格式错误', code: 401 })
  const invalidItems = params.filter(item => 
    !item.id || item[type] === undefined
  );
  if (invalidItems.length > 0) {
    return res.json({ message: '更新数据格式错误，每个元素必须包含id和start_date或end_date', code: 401 });
  }

  const ids = params.map(e => e.id)
  let row = null
  if(type == 'start_date'){
    row = await SubProgressBase.findAll({
      where: { id: ids },
      attributes: ['id']
    })
  }
  if(type == 'end_date'){
    row = await SubProgressCycle.findAll({
      where: { id: ids },
      attributes: ['id']
    })
  }
  if(row.length != params.length){
    return res.json({ message: '部分数据不存在，请刷新页面', code: 401 })
  }
  const setting = {
    updateOnDuplicate: [type],
    ignoreDuplicates: false
  }
  if(type == 'start_date'){
    await SubProgressBase.bulkCreate(params, setting)
  }
  if(type == 'end_date'){
    await SubProgressCycle.bulkCreate(params, setting)
  }
  
  res.json({ message: '修改成功', code: 200 });
})

router.get('/workOrder', authMiddleware, async (req, res) => {
  const { company_id } = req.user;

  const noticeIds = await getSaleCancelIds('notice_id', { company_id })
  
  let where = {
    is_deleted: 1,
    notice_id: { [Op.notIn]: noticeIds },
    is_notice: 0,
    is_finish: 1,
    company_id,
  }
  const rows = await SubProductNotice.findAll({
    where,
    attributes: ['id', 'notice'],
    order: [['id', 'ASC']]
  })
  const fromData = rows.map(e => e.toJSON())

  res.json({ data: formatArrayTime(fromData), code: 200 });
})
router.get('/workQrCode', authMiddleware, async (req, res) => {
  const { notice_id } = req.query;
  const { company_id } = req.user;

  const notice = await SubProductNotice.findByPk(notice_id)
  if(!notice) return res.json({ code: 401, message: '订单完结或其他未知情况，请检查！' })

  const rows = await SubProgressBase.findAll({
    where: {
      is_deleted: 1,
      notice_id,
      company_id,
    },
    attributes: ['id', 'notice_id', 'out_number', 'product_id', 'product_code', 'product_name', 'drawing', 'part_id', 'part_code', 'part_name', 'bom_id'],
    include: [
      { model: SubProductNotice, as: 'notice', attributes: ['id', 'notice', 'delivery_time'] },
      {
        model: SubProcessBom,
        as: 'bom',
        attributes: ['id', 'sort'],
        include: [
          {
            model: SubProcessBomChild,
            as: 'children',
            attributes: ['id', 'qr_code'],
            include: [
              { model: SubProcessCode, as: 'process', attributes: ['id', 'process_code', 'process_name'] },
              {
                model: SubEquipmentCode,
                as: 'equipment',
                attributes: ['id', 'equipment_name', 'equipment_code'],
                include: [{ model: SubProcessCycle, as: 'cycle', attributes: ['id', 'name'] }]
              },
            ]
          }
        ]
      },
    ],
    order: [['bom', 'sort', 'ASC']],
  })
  const fromData = rows.map(e => e.toJSON())

  res.json({ code: 200, data: fromData })
})

// 移动端移动端报工单获取数据
router.get('/mobile_process_bom', EmployeeAuth, async (req, res) => {
  const { id, company_id } = req.query;
  const { company_id: companyId } = req.user
  if(company_id != companyId) return res.json({ message: '数据出错，请检查正确的地址或二维码', code: 401 })

  const work = await SubProgressWork.findOne({
    where: {
      child_id: id,
      company_id
    },
    attributes: ['id', 'progress_id', 'notice_id', 'bom_id', 'child_id', 'all_work_time', 'load', 'finish', 'order_number'],
    include: [
      {
        model: SubProcessBomChild,
        as: 'children',
        attributes: ['id', 'process_id', 'time', 'price', 'points'],
        include: [
          { model: SubProcessCode, as: 'process', attributes: ['id', 'process_code', 'process_name'] },
        ]
      },
    ]
  })
  if(!work) return res.json({ code: 401, message: '数据出错，请联系管理员' })
  const workResult = work.toJSON()

  const progress = await SubProgressBase.findOne({
    where: {
      id: workResult.progress_id
    },
    attributes: ['id', 'product_id', 'product_code', 'product_name', 'drawing', 'notice_id', 'sale_id', 'part_id', 'part_code', 'part_name', 'bom_id', 'out_number'],
    include: [
      { model: SubProductNotice, as: 'notice', attributes: ['id', 'delivery_time'] }
    ]
  })
  const progressResult = progress.toJSON()

  res.json({ code: 200, data: { work: workResult, progress: progressResult } })
})
// 移动端报工单
router.post('/mobile_work_order', EmployeeAuth, async (req, res) => {
  const { number, id, company_id, product_id, part_id, process_id, bom_child_id, notice_id } = req.body
  const { company_id: companyId, id: userId, name } = req.user
  if(company_id != companyId) return res.json({ message: '数据出错，请检查正确的地址或二维码', code: 401 })

  const quantity = Number(number)

  if(!quantity || quantity <= 0) return res.json({ message: '数量输入错误，请重新输入', code: 401 })

  const dataValue = await SubProgressWork.findByPk(id)

  dataValue.finish = dataValue.finish ? PreciseMath.add(dataValue.finish, quantity) : quantity
  dataValue.order_number = PreciseMath.sub(dataValue.order_number, quantity)
  dataValue.all_work_time = (dataValue.order_number * dataValue.time).toFixed(1)

  await SubRateWage.create({ 
    company_id: companyId,
    user_id: userId, 
    number, 
    bom_child_id: bom_child_id, 
    product_id, 
    part_id, 
    process_id,
    notice_id
  })

  const resData = await SubProgressWork.update({
    finish: dataValue.finish,
    order_number: dataValue.order_number,
    all_work_time: dataValue.all_work_time
  }, { where: { id } })

  await SubOperationHistory.create({
    user_id: userId,
    user_name: name,
    company_id: company_id,
    operation_type: 'add',
    module: "移动端",
    desc: `员工{ ${ name } }报工数量：${ quantity }`,
    data: JSON.stringify({ newData: { number: quantity, id, company_id } }),
  });

  res.json({ message: '操作成功', code: 200 })
})

module.exports = router;