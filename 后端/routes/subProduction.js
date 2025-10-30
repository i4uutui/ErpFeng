const express = require('express');
const dayjs = require('dayjs')
const isSameOrAfter = require('dayjs/plugin/isSameOrAfter')
const isSameOrBefore = require('dayjs/plugin/isSameOrBefore');
dayjs.extend(isSameOrAfter);
dayjs.extend(isSameOrBefore);
const router = express.Router();
const { SubProductionProgress, SubProductNotice, SubProductCode, SubCustomerInfo, SubSaleOrder, SubPartCode, SubProcessBomChild, SubProcessCode, SubEquipmentCode, SubProcessCycle, SubProcessBom, SubProcessCycleChild, SubOperationHistory, SubRateWage, Op, SubProductionNotice, SubDateInfo } = require('../models');
const authMiddleware = require('../middleware/auth');
const EmployeeAuth = require('../middleware/EmployeeAuth');
const { formatArrayTime, formatObjectTime } = require('../middleware/formatTime');
const { PreciseMath } = require('../middleware/tool');

// 获取生产进度表列表
router.get('/production_progress', authMiddleware, async (req, res) => {
  const { company_id } = req.user;
  
  const rows = await SubProductionProgress.findAll({
    where: {
      is_deleted: 1,
      company_id,
      is_finish: 1
    },
    attributes: ['id', 'notice_number', 'delivery_time', 'customer_abbreviation', 'product_id', 'product_code', 'product_name', 'product_drawing', 'part_id', 'part_code', 'part_name', 'bom_id', 'order_number', 'customer_order', 'rece_time', 'out_number', 'start_date', 'remarks', 'created_at'],
    include: [
      {
        model: SubProcessCycleChild,
        as: 'cycleChild',
        attributes: ['cycle_id', 'id', 'end_date', 'load', 'order_number', 'progress_id'],
        order: [['cycle', 'sort', 'ASC']],
        include: [{ model: SubProcessCycle, as: 'cycle', attributes: ['id', 'name', 'sort_date', 'sort'] }] },
      {
        model: SubProcessBom,
        as: 'bom',
        attributes: ['id', 'part_id', 'product_id'],
        include: [
          {
            model: SubProcessBomChild,
            as: 'children',
            attributes: ['id', 'order_number', 'equipment_id', 'process_bom_id', 'process_id', 'time', 'all_time', 'all_load', 'add_finish'],
            include: [
              { model: SubProcessCode, as: 'process', attributes: ['id', 'process_code', 'process_name'] },
              {
                model: SubEquipmentCode,
                as: 'equipment',
                attributes: ['id', 'equipment_name', 'equipment_code', 'working_hours', 'efficiency', 'quantity'],
                include: [{ model: SubProcessCycle, as: 'cycle', attributes: ['id', 'name', 'sort'], order: [['sort', 'ASC']] }]
              },
            ]
          }
        ]
      },
    ],
    order: [['created_at', 'DESC']],
  })
  // 用户设置的假期
  const dates = await SubDateInfo.findAll({
    where: {
      company_id
    },
    attributes: ['date']
  })
  const specialDates = dates.map(e => {
    const item = e.toJSON()
    return dayjs(item.date).startOf('day')
  })
  const uniqueSpecialDates = [...new Set(specialDates.map(d => d.format('YYYY-MM-DD')))].map(d => dayjs(d));

  const today = dayjs();
  const fromData = rows.map((item, idx) => {
    const data = item.toJSON()
    const startDate = item.start_date ? dayjs(item.start_date).startOf('day') : null;
    if (!startDate) return data;

    // 按sort排序当前进度的所有制程子项
    data.cycleChild.sort((a, b) => {
      return (Number(a.cycle.sort) || 0) - (Number(b.cycle.sort) || 0);
    });
    // 计算每个制程的累计前置最短周期
    const cumulativeSortDates = [];
    let totalSortDate = 0;
    data.cycleChild.forEach((cycleChild, index) => {
      if (index > 0) {
        // 累加前序制程的最短周期
        const prevCycle = data.cycleChild[index - 1];
        totalSortDate += Number(prevCycle.cycle.sort_date) || 0;
      }
      cumulativeSortDates.push(totalSortDate);
    });
    if (item.start_date){
      // 如果起始日期早于今天，则用今天作为实际起始日期
      const loadStartDate = startDate.isBefore(today) ? today.startOf('day') : startDate;
      data.cycleChild.forEach((cycleChild, index) => {
        // 如果当前周期子项没有结束日期，跳过（无法计算周期长度）
        if (!cycleChild.end_date) return;
        // 计算当前制程的预计起始时间 = 原始起始时间 + 前置最短周期总和
        const currentStartDate = loadStartDate.clone().add(cumulativeSortDates[index], 'day');
        // 预计生产起始时间 + 最短周期 ：使用计算后的起始时间
        const load_startDate = currentStartDate.startOf('day');
        // 预交排期
        const endDate = dayjs(cycleChild.end_date).startOf('day');

        // 计算起始日期到结束日期的天数差（endDate - load_startDate）
        const dayDiff = endDate.diff(load_startDate, 'day');
        const totalDays = dayDiff + 1; // 包含起始日和结束日

        // 计算区间内的特殊日期数量（需要跳过的天数）
        const specialDaysInRange = uniqueSpecialDates.filter(specialDate => {
          // 特殊日期是否在 [currentLoadStartDate, endDate] 区间内
          return specialDate.isSameOrAfter(load_startDate) && specialDate.isSameOrBefore(endDate);
        }).length;
        // 有效天数 = 总日历天数 - 特殊日期数量（至少为1）
        const validDays = Math.max(totalDays - specialDaysInRange, 1);
        // 匹配对应的BOM子项
        const matchedBomChildren = data.bom?.children?.filter(
          bomChild => bomChild.equipment?.cycle?.id === cycleChild.cycle?.id
        );
        if(matchedBomChildren && matchedBomChildren.length > 0){
          // 计算bom.children.all_load和cycleChild.load
          matchedBomChildren.forEach(bomChild => {
            if (bomChild.all_time) {
              // 日均负载 = 总耗时 / 周期总天数（d），保留1位小数
              bomChild.all_load = parseFloat((bomChild.all_time / validDays).toFixed(1));
              // 同时将该设备的日均负载累加到当前周期的总负载中
              cycleChild.load = (parseFloat(cycleChild.load || '0') + bomChild.all_load).toFixed(1);
            }
          });
          cycleChild.load = parseFloat(cycleChild.load).toFixed(1)
        }
      })
    }
    return data
  })
  
  // 返回所需信息
  res.json({ data: formatArrayTime(fromData), code: 200 });
});
// router.put('/production_progress', authMiddleware, async (req, res) => {
//   const { id, part_id, out_number, order_number, remarks } = req.body
//   const { id: userId, company_id } = req.user;
  
//   const row = await SubProductionProgress.findAll({
//     where: { id }
//   })
//   if(row.length == 0){
//     return res.json({ message: '数据不存在，或已被删除', code: 401 })
//   }
//   await SubProductionProgress.update({
//     part_id, out_number, order_number, remarks
//   }, {
//     where: { id, company_id }
//   })
  
//   res.json({ message: '修改成功', code: 200 });
// })
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
    row = await SubProductionProgress.findAll({
      where: { id: ids }
    })
  }
  if(type == 'end_date'){
    row = await SubProcessCycleChild.findAll({
      where: { id: ids }
    })
  }
  if(row.length != params.length){
    return res.json({ message: '部分数据不存在，或已被删除，请刷新页面', code: 401 })
  }
  const setting = {
    updateOnDuplicate: [type],
    ignoreDuplicates: false
  }
  if(type == 'start_date'){
    const dataValue = params.map(o => ({ ...o, user_id: userId, company_id }))
    await SubProductionProgress.bulkCreate(dataValue, setting)
  }
  if(type == 'end_date'){
    await SubProcessCycleChild.bulkCreate(params, setting)
  }
  
  res.json({ message: '修改成功', code: 200 });
})

router.get('/workOrder', authMiddleware, async (req, res) => {
  const { notice_number } = req.query;
  const { company_id } = req.user;
  
  let wheres = {}
  if(notice_number) wheres.notice_number = notice_number
  const rows = await SubProductionProgress.findAll({
    where: {
      is_deleted: 1,
      company_id,
      ...wheres
    },
    attributes: ['id', 'notice_number', 'delivery_time', 'product_id', 'product_code', 'product_name', 'product_drawing', 'part_id', 'part_code', 'part_name', 'bom_id', 'out_number'],
    include: [
      // { model: SubProcessCycleChild, as: 'cycleChild', attributes: ['cycle_id', 'id', 'end_date'], include: [{ model: SubProcessCycle, as: 'cycle', attributes: ['id', 'name'] }] },
      {
        model: SubProcessBom,
        as: 'bom',
        attributes: ['id'],
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
    order: [['created_at', 'DESC']],
  })
  const fromData = rows.map(e => e.toJSON())

  res.json({ data: formatArrayTime(fromData), code: 200 });
})

// 移动端移动端报工单获取数据
router.get('/mobile_process_bom', EmployeeAuth, async (req, res) => {
  const { id, company_id } = req.query;
  const { company_id: companyId } = req.user
  if(company_id != companyId) return res.json({ message: '数据出错，请检查正确的地址或二维码', code: 401 })

  const result = await SubProcessBomChild.findByPk(id, {
    include: [
      { model: SubProcessBom, as: 'parent', include: [{ model: SubProductionProgress, as: 'production' }] },
      { model: SubProcessCode, as: 'process' }
    ]
  })
  if(!result) return res.json({ message: '数据出错，请检查正确的地址或二维码', code: 401 })
  const dataValue = result.toJSON()

  res.json({ data: formatObjectTime(dataValue), code: 200 });
})
// 移动端报工单
router.post('/mobile_work_order', EmployeeAuth, async (req, res) => {
  const { number, id, company_id, product_id, part_id, process_id } = req.body
  const { company_id: companyId, id: userId, name } = req.user
  if(company_id != companyId) return res.json({ message: '数据出错，请检查正确的地址或二维码', code: 401 })

  const quantity = Number(number)

  if(!quantity || quantity <= 0) return res.json({ message: '数量输入错误，请重新输入', code: 401 })

  const result = await SubProcessBomChild.findByPk(id)
  const dataValue = result.toJSON()

  dataValue.add_finish = dataValue.add_finish ? PreciseMath.add(dataValue.add_finish, quantity) : quantity
  dataValue.order_number = PreciseMath.sub(dataValue.order_number, quantity)
  dataValue.all_time = (dataValue.order_number * dataValue.time).toFixed(1)

  await SubRateWage.create({ 
    company_id: companyId,
    user_id: userId, 
    number, 
    bom_child_id: id, 
    product_id, 
    part_id, 
    process_id 
  })

  const resData = await SubProcessBomChild.update({
    add_finish: dataValue.add_finish,
    order_number: dataValue.order_number,
    all_time: dataValue.all_time
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