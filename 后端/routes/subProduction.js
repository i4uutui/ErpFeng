const express = require('express');
const dayjs = require('dayjs')
const router = express.Router();
const { SubProductionProgress, SubProductNotice, SubProductCode, SubCustomerInfo, SubSaleOrder, SubPartCode, SubProcessBomChild, SubProcessCode, SubEquipmentCode, SubProcessCycle, SubProcessBom, SubProcessCycleChild, Op } = require('../models');
const authMiddleware = require('../middleware/auth');
const { formatArrayTime, formatObjectTime } = require('../middleware/formatTime');

// 获取生产进度表列表
router.get('/production_progress', authMiddleware, async (req, res) => {
  const { company_id } = req.user;
  
  const rows = await SubProductionProgress.findAll({
    where: {
      is_deleted: 1,
      company_id,
    },
    attributes: ['id', 'notice_number', 'delivery_time', 'customer_abbreviation', 'product_id', 'product_code', 'product_name', 'product_drawing', 'part_id', 'part_code', 'part_name', 'bom_id', 'order_number', 'customer_order', 'rece_time', 'out_number', 'start_date', 'remarks', 'created_at'],
    include: [
      { model: SubProcessCycleChild, as: 'cycleChild', attributes: ['cycle_id', 'id', 'end_date', 'load', 'order_number', 'progress_id'], include: [{ model: SubProcessCycle, as: 'cycle', attributes: ['id', 'name', 'sort_date'] }] },
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
                attributes: ['id', 'equipment_name', 'equipment_code', 'working_hours', 'equipment_efficiency', 'equipment_quantity'],
                include: [{ model: SubProcessCycle, as: 'cycle', attributes: ['id', 'name'] }]
              },
            ]
          }
        ]
      },
    ],
    order: [['created_at', 'DESC']],
    limit: 20
  })
  const today = dayjs();
  const fromData = rows.map((item, idx) => {
    const data = item.toJSON()
    const startDate = item.start_date ? dayjs(item.start_date) : null;
    if (!startDate) return data;

    if (item.start_date){
      // 起始时间
      const loadStartDate = startDate.isBefore(today) ? today : startDate;
      data.cycleChild.forEach((cycleChild, index) => {
        if (!cycleChild.end_date) return;
        // 最短周期
        const sort_date = index > 0 ? data.cycleChild[index - 1].cycle.sort_date : ''
        // 预计生产起始时间 + 最短周期 ：使用原始的起始时间
        const load_startDate = index > 0 ? loadStartDate.add(sort_date, 'day') : loadStartDate
        // 预交排期
        const endDate = dayjs(cycleChild.end_date);
        // 计算日期差（天数）
        const dayDiff = endDate.diff(load_startDate, 'day');
        const matchedBomChildren = data.bom?.children?.filter(
          bomChild => bomChild.equipment?.cycle?.id === cycleChild.cycle?.id
        );
        if(matchedBomChildren && matchedBomChildren.length > 0){
          // 计算bom.children.all_load和cycleChild.load
          matchedBomChildren.forEach(bomChild => {
            if (bomChild.all_time) {
              const d = dayDiff + 1 > 0 ? dayDiff + 1 : 1
              bomChild.all_load = parseFloat((bomChild.all_time / d).toFixed(1));
              cycleChild.load = cycleChild.load + bomChild.all_load
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
router.put('/production_progress', authMiddleware, async (req, res) => {
  const { id, part_id, out_number, order_number, remarks } = req.body
  const { id: userId, company_id } = req.user;
  
  const row = await SubProductionProgress.findAll({
    where: { id }
  })
  if(row.length == 0){
    return res.json({ message: '数据不存在，或已被删除', code: 401 })
  }
  await SubProductionProgress.update({
    part_id, out_number, order_number, remarks
  }, {
    where: { id, company_id }
  })
  
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

module.exports = router;