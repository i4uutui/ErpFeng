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
// router.get('/production_progress', authMiddleware, async (req, res) => {
//   const { company_id } = req.user;
//   const today = dayjs().startOf('day');
  
//   const [ rows, dates ] = await Promise.all([
//     SubProductionProgress.findAll({
//       where: {
//         is_deleted: 1,
//         company_id,
//         is_finish: 1
//       },
//       attributes: ['id', 'notice_id', 'customer_abbreviation', 'product_id', 'part_id', 'bom_id', 'house_number', 'out_number', 'start_date', 'remarks', 'created_at'],
//       include: [
//         { model: SubProductCode, as: 'product', attributes: ['id', 'product_code', 'product_name', 'drawing'] },
//         { model: SubPartCode, as: 'part', attributes: ['id', 'part_code', 'part_name'] },
//         {
//           model: SubProductNotice,
//           as: 'notice',
//           attributes: ['id', 'notice', 'delivery_time'],
//           include: [
//             { model: SubSaleOrder, as: 'sale', attributes: ['id', 'order_number', 'rece_time', 'customer_order'] }
//           ]
//         },
//         {
//           model: SubProcessCycleChild,
//           as: 'cycleChild',
//           attributes: ['cycle_id', 'id', 'end_date', 'load', 'order_number', 'progress_id'],
//           order: [['cycle', 'sort', 'ASC']],
//           include: [{ model: SubProcessCycle, as: 'cycle', attributes: ['id', 'name', 'sort_date', 'sort'] }] 
//         },
//         {
//           model: SubProcessBom,
//           as: 'bom',
//           attributes: ['id', 'part_id', 'product_id'],
//           include: [
//             {
//               model: SubProcessBomChild,
//               as: 'children',
//               attributes: ['id', 'order_number', 'equipment_id', 'process_bom_id', 'process_id', 'time', 'all_time', 'all_load', 'add_finish'],
//               include: [
//                 { model: SubProcessCode, as: 'process', attributes: ['id', 'process_code', 'process_name'] },
//                 {
//                   model: SubEquipmentCode,
//                   as: 'equipment',
//                   attributes: ['id', 'equipment_name', 'equipment_code', 'working_hours', 'efficiency', 'quantity'],
//                   include: [{ model: SubProcessCycle, as: 'cycle', attributes: ['id', 'name', 'sort'], order: [['sort', 'ASC']] }]
//                 },
//               ]
//             }
//           ]
//         },
//       ],
//       order: [['created_at', 'DESC']],
//     }),
//     // 用户设置的假期
//     SubDateInfo.findAll({
//       where: { company_id },
//       attributes: ['date']
//     })
//   ])
  
//   // 缓存并处理假期数据（字符串格式）
//   const uniqueSpecialDateStrs = [...new Set(
//     dates.map(e => dayjs(e.date).format('YYYY-MM-DD'))
//   )];

//   // 处理生产进度数据
//   const fromData = rows.map(item => {
//     const data = item.toJSON();
//     const startDate = item.start_date ? dayjs(item.start_date).startOf('day') : null;
//     if (!startDate) return data;

//     // 排序cycleChild（提前提取sort值避免重复访问）
//     data.cycleChild.sort((a, b) => (a.cycle?.sort || 0) - (b.cycle?.sort || 0));

//     // 计算累计前置周期（提前提取sort_date）
//     const cumulativeSortDates = [];
//     let totalSortDate = 0;
//     data.cycleChild.forEach((cycleChild, index) => {
//       if (index > 0) {
//         totalSortDate += Number(data.cycleChild[index - 1].cycle?.sort_date) || 0;
//       }
//       cumulativeSortDates.push(totalSortDate);
//     });

//     const loadStartDate = startDate.valueOf() < today.valueOf() ? today : startDate;
//     // 提前构建bomChildren的Map索引
//     const bomChildrenMap = new Map();
//     data.bom?.children?.forEach(bomChild => {
//       const cycleId = bomChild.equipment?.cycle?.id;
//       if (cycleId) {
//         bomChildrenMap.has(cycleId) 
//           ? bomChildrenMap.get(cycleId).push(bomChild)
//           : bomChildrenMap.set(cycleId, [bomChild]);
//       }
//     });

//     data.cycleChild.forEach((cycleChild, index) => {
//       if (!cycleChild.end_date) return;
//       const currentStartDate = loadStartDate.clone().add(cumulativeSortDates[index], 'day');
//       const loadStart = currentStartDate.startOf('day');
//       const endDate = dayjs(cycleChild.end_date).startOf('day');

//       // 用时间戳计算天数差
//       const dayDiff = Math.floor((endDate.valueOf() - loadStart.valueOf()) / (1000 * 60 * 60 * 24));
//       const totalDays = dayDiff + 1;

//       // 用字符串比较筛选特殊日期
//       const loadStartStr = loadStart.format('YYYY-MM-DD');
//       const endDateStr = endDate.format('YYYY-MM-DD');
//       const specialDaysInRange = uniqueSpecialDateStrs.filter(date => {
//         return date >= loadStartStr && date <= endDateStr;
//       }).length;

//       const validDays = Math.max(totalDays - specialDaysInRange, 1);
//       const matchedBomChildren = bomChildrenMap.get(cycleChild.cycle?.id) || [];
      
//       matchedBomChildren.forEach(bomChild => {
//         if (bomChild.all_time) {
//           bomChild.all_load = Number((bomChild.all_time / validDays).toFixed(1));
//           cycleChild.load = Number((Number(cycleChild.load || 0) + bomChild.all_load).toFixed(1));
//         }
//       });
//     });

//     return data;
//   });

//   res.json({ data: formatArrayTime(fromData), code: 200 });
// });
// router.get('/production_progress', authMiddleware, async (req, res) => {
//   const { company_id } = req.user;
//   const today = dayjs().startOf('day');
  
//   const [ rows, dates, allProcessCycles, allEquipmentCodes ] = await Promise.all([
//     SubProductionProgress.findAll({
//       where: {
//         is_deleted: 1,
//         company_id,
//         is_finish: 1
//       },
//       attributes: ['id', 'notice_id', 'customer_abbreviation', 'product_id', 'part_id', 'bom_id', 'house_number', 'out_number', 'start_date', 'remarks', 'created_at'],
//       include: [
//         { model: SubProductCode, as: 'product', attributes: ['id', 'product_code', 'product_name', 'drawing'] },
//         { model: SubPartCode, as: 'part', attributes: ['id', 'part_code', 'part_name'] },
//         {
//           model: SubProductNotice,
//           as: 'notice',
//           attributes: ['id', 'notice', 'delivery_time'],
//           include: [
//             { model: SubSaleOrder, as: 'sale', attributes: ['id', 'order_number', 'rece_time', 'customer_order'] }
//           ]
//         },
//         {
//           model: SubProcessCycleChild,
//           as: 'cycleChild',
//           attributes: ['cycle_id', 'id', 'end_date', 'load', 'order_number', 'progress_id'],
//           order: [['cycle', 'sort', 'ASC']],
//         },
//         {
//           model: SubProcessBom,
//           as: 'bom',
//           attributes: ['id', 'part_id', 'product_id'],
//           include: [
//             {
//               model: SubProcessBomChild,
//               as: 'children',
//               attributes: ['id', 'order_number', 'equipment_id', 'process_bom_id', 'process_id', 'time', 'all_time', 'all_load', 'add_finish'],
//               include: [
//                 { model: SubProcessCode, as: 'process', attributes: ['id', 'process_code', 'process_name'] },
//               ]
//             }
//           ]
//         },
//       ],
//       order: [['created_at', 'DESC']],
//     }),
//     // 用户设置的假期
//     SubDateInfo.findAll({
//       where: { company_id },
//       attributes: ['date']
//     }),
//     // 查询所有工序周期
//     SubProcessCycle.findAll({
//       where: { company_id },
//       attributes: ['id', 'name', 'sort_date', 'sort'],
//       include: [
//         { model: SubEquipmentCode, as: 'equipment', attributes: ['id', 'efficiency'] }
//       ]
//     }),
//     SubEquipmentCode.findAll({
//       where: { company_id },
//       attributes: ['id', 'equipment_name', 'equipment_code', 'working_hours', 'efficiency', 'quantity', 'cycle_id']
//     })
//   ])
//   // 工序周期映射表 (id -> cycle)
//   const processCycleMap = new Map(allProcessCycles.map(cycle => [cycle.id, cycle.toJSON()]));
//   // 设备映射表 (id -> equipment)
//   const equipmentMap = new Map(allEquipmentCodes.map(equip => {
//     const equipData = equip.toJSON();
//     // 为设备添加cycle信息
//     equipData.cycle = processCycleMap.get(equipData.cycle_id) || null;
//     return [equipData.id, equipData];
//   }));
  
//   // 缓存并处理假期数据（字符串格式）
//   const uniqueSpecialDateStrs = [...new Set(
//     dates.map(e => dayjs(e.date).format('YYYY-MM-DD'))
//   )];

//   // 3. 处理生产进度数据
//   const fromData = rows.map(item => {
//     const data = item.toJSON();
//     const startDate = item.start_date ? dayjs(item.start_date).startOf('day') : null;
//     if (!startDate) return data;

//     // 为cycleChild添加cycle信息并排序
//     data.cycleChild = data.cycleChild.map(child => ({
//       ...child,
//       cycle: processCycleMap.get(child.cycle_id) || null
//     })).sort((a, b) => (a.cycle?.sort || 0) - (b.cycle?.sort || 0));

//     // 计算累计前置周期
//     const cumulativeSortDates = [];
//     let totalSortDate = 0;
//     data.cycleChild.forEach((cycleChild, index) => {
//       if (index > 0) {
//         totalSortDate += Number(data.cycleChild[index - 1].cycle?.sort_date) || 0;
//       }
//       cumulativeSortDates.push(totalSortDate);
//     });

//     const loadStartDate = startDate.valueOf() < today.valueOf() ? today : startDate;
    
//     // 构建bomChildren的Map索引（使用设备信息）
//     const bomChildrenMap = new Map();
//     data.bom?.children?.forEach(bomChild => {
//       // 为bomChild添加equipment信息
//       bomChild.equipment = equipmentMap.get(bomChild.equipment_id) || null;
      
//       const cycleId = bomChild.equipment?.cycle?.id;
//       if (cycleId) {
//         if (bomChildrenMap.has(cycleId)) {
//           bomChildrenMap.get(cycleId).push(bomChild);
//         } else {
//           bomChildrenMap.set(cycleId, [bomChild]);
//         }
//       }
//     });

//     // 计算负载
//     data.cycleChild.forEach((cycleChild, index) => {
//       if (!cycleChild.end_date) return;
      
//       const currentStartDate = loadStartDate.clone().add(cumulativeSortDates[index], 'day');
//       const loadStart = currentStartDate.startOf('day');
//       const endDate = dayjs(cycleChild.end_date).startOf('day');

//       // 计算天数差
//       const dayDiff = Math.floor((endDate.valueOf() - loadStart.valueOf()) / (1000 * 60 * 60 * 24));
//       const totalDays = dayDiff + 1;

//       // 筛选特殊日期
//       const loadStartStr = loadStart.format('YYYY-MM-DD');
//       const endDateStr = endDate.format('YYYY-MM-DD');
//       const specialDaysInRange = uniqueSpecialDateStrs.filter(date => 
//         date >= loadStartStr && date <= endDateStr
//       ).length;

//       const validDays = Math.max(totalDays - specialDaysInRange, 1);
//       const matchedBomChildren = bomChildrenMap.get(cycleChild.cycle?.id) || [];
      
//       // 计算负载
//       matchedBomChildren.forEach(bomChild => {
//         if (bomChild.all_time) {
//           bomChild.all_load = Number((bomChild.all_time / validDays).toFixed(1));
//           cycleChild.load = Number((Number(cycleChild.load || 0) + bomChild.all_load).toFixed(1));
//         }
//       });
//     });

//     return data;
//   });

//   res.json({ data: formatArrayTime(fromData), code: 200 });
// });

// 获取生产进度表列表
router.get('/production_progress', authMiddleware, async (req, res) => {
  const { company_id } = req.user;

  const [ rows, cycles ] = await Promise.all([
    SubProductionProgress.findAll({
      where: {
        company_id,
        is_finish: 1,
        is_deleted: 1
      },
      attributes: ['id', 'notice_id', 'product_id', 'sale_id', 'out_number', 'part_id', 'bom_id', 'start_date', 'house_number', 'remarks'],
      include: [
        { model: SubProductNotice, as: 'notice', attributes: ['id', 'notice', 'delivery_time'] },
        { model: SubProductCode, as: 'product', attributes: ['id', 'product_code', 'product_name', 'drawing'] },
        { model: SubPartCode, as: 'part', attributes: ['id', 'part_code', 'part_name'] },
        {
          model: SubSaleOrder,
          as: 'sale',
          attributes: ['id', 'rece_time', 'order_number', 'customer_order'],
          include: [
            { model: SubCustomerInfo, as: 'customer', attributes: ['id', 'customer_abbreviation', 'customer_code'] },
          ]
        },
        {
          model: SubProcessCycleChild,
          as: 'cycleChild',
          attributes: ['cycle_id', 'id', 'end_date', 'load', 'order_number', 'progress_id'],
          order: [['cycle', 'sort', 'ASC']],
        },
        {
          model: SubProcessBom,
          as: 'bom',
          attributes: ['id'],
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
                  include: [{ model: SubProcessCycle, as: 'cycle', attributes: ['id', 'name', 'sort'] }]
                },
              ]
            }
          ]
        }
      ]
    }),
    SubProcessCycle.findAll({
      where: {
        company_id,
        sort: { [Op.gt]: 0 }
      },
      attributes: [ 'id', 'name', 'sort', 'sort_date' ],
      order: [['sort', 'ASC']],
      include: [
        { model: SubEquipmentCode, as: 'equipment', attributes: ['id', 'efficiency'] }
      ]
    })
  ])
  // bom.children需要按制程的sort进行排序
  const processResult = rows.map(e => {
    const itemJson = e.toJSON()
    if (itemJson.bom?.children && itemJson.bom.children.length > 0) {
      itemJson.bom.children.sort((a, b) => {
        const sortA = a.equipment?.cycle?.sort || 0;
        const sortB = b.equipment?.cycle?.sort || 0;
        return sortA - sortB; // 升序排列
      });
    }
    return itemJson;
  })
  // 返回制程的数据
  const cycleResult = cycles.map(e => {
    const item = e.toJSON()
    item.maxLoad = item.equipment.reduce((total, e) => PreciseMath.add(total, e.efficiency), 0)
    const { equipment, ...newItem } = item
    return newItem
  })

  const data = {
    process: processResult,
    cycle: cycleResult
  }
  res.json({ code: 200, data })
})
router.post('/set_out_number', authMiddleware, async (req, res) => {
  const { id, house_number, order_number } = req.body
  const { id: userId, company_id } = req.user;
  
  const handleHouseNumber = house_number === undefined || house_number === null ? 0 : Number(house_number);
  if(isNaN(handleHouseNumber) || handleHouseNumber < 0){
    return res.json({ message: '委外/库存数量不能小于0', code: 401 });
  }
  const result = await SubProductionProgress.findOne({
    where: { id, company_id },
    attributes: ['id', 'company_id', 'user_id', 'out_number', 'notice_id', 'bom_id']
  })
  if(!result) return res.json({ message: '数据不存在，或已被删除', code: 401 })
  const row = result.toJSON()
  
  row.out_number = PreciseMath.sub(order_number, handleHouseNumber)
  row.house_number = handleHouseNumber
  await SubProductionProgress.update(row, { where: { id } })

  const bomChild = await SubProcessBomChild.findAll({
    where: {
      notice_id: row.notice_id,
      company_id
    },
    attributes: ['id', 'order_number', 'add_finish', 'process_bom_id']
  })
  if(bomChild && bomChild.length){
    const bomChildResult = bomChild.map(e => {
      const item = e.toJSON()
      if(row.bom_id == item.process_bom_id){
        const n = item.add_finish ? PreciseMath.sub(order_number, item.add_finish) : order_number
        item.order_number = handleHouseNumber ? PreciseMath.sub(n, handleHouseNumber) : n
      }
      return item
    })
    await SubProcessBomChild.bulkCreate(bomChildResult, {
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
      {
        model: SubProcessBom,
        as: 'parent',
        attributes: ['id', 'product_id', 'part_id'],
        include: [
          { model: SubProductionProgress, as: 'production', attributes: ['id', 'out_number', 'notice_id'], include: [{ model: SubProductNotice, as: 'notice', attributes: ['id', 'delivery_time'] }] }, 
          { model: SubProductCode, as: 'product', attributes: ['id', 'product_code', 'product_name', 'drawing'] },
          { model: SubPartCode, as: 'part', attributes: ['id', 'part_code', 'part_name'] }
        ]
      },
      { model: SubProcessCode, as: 'process', attributes: ['id', 'process_code', 'process_name'] }
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