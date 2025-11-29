const express = require('express');
const dayjs = require('dayjs')
const isSameOrAfter = require('dayjs/plugin/isSameOrAfter')
const isSameOrBefore = require('dayjs/plugin/isSameOrBefore');
dayjs.extend(isSameOrAfter);
dayjs.extend(isSameOrBefore);
const router = express.Router();
const { SubProductionProgress, SubProductNotice, SubProductCode, SubSaleOrder, SubPartCode, SubProcessBomChild, SubProcessCode, SubEquipmentCode, SubProcessCycle, SubProcessBom, SubOperationHistory, SubRateWage, Op, SubProductionCycle, SubProductionProcess, SubProcessCycleChild, SubDateInfo, SubCustomerInfo, SubProgressBase, SubProgressCycle, SubProgressWork, SubProgressTotal } = require('../models');
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
  try {
    const { base: baseStr } = req.body;
    const { company_id } = req.user;

    // 基础参数校验与解析优化
    if (!baseStr) return res.json({ code: 401, message: '数据出错' });
    const baseJSON = JSON.parse(baseStr);
    if (!baseJSON.length) return res.json({ code: 401, message: '数据出错' });

    const progressIds = baseJSON.map(e => e.id);
    if (!progressIds.length) return res.json({ code: 200, data: { cycles: [], works: [], date_more: [] } });

    // 1. 数据库查询优化
    // 1.1 并行查询改为顺序+批量，减少连接竞争
    // 1.2 增加必要索引条件，减少返回字段
    const [cycles, work] = await Promise.all([
      // 制程数据查询优化
      SubProcessCycle.findAll({
        where: {
          company_id,
          sort: { [Op.gt]: 0 }
        },
        attributes: ['id', 'name', 'sort', 'sort_date'],
        // 优化关联查询条件，只查需要的progress_id
        include: [
          { 
            model: SubProgressCycle, 
            as: 'cycle', 
            attributes: ['id', 'notice_id', 'progress_id', 'cycle_id', 'end_date', 'load', 'order_number'], 
            where: { progress_id: progressIds },
            required: false, // 允许没有关联数据的制程也返回
          },
          { 
            model: SubEquipmentCode, 
            as: 'equipment', 
            attributes: ['id', 'efficiency'],
            required: false
          }
        ],
        order: [['sort', 'ASC'], ['cycle', 'progress_id', 'ASC']],
        // 强制索引（如果存在）
        // indexHints: [{ type: 'USE', values: ['idx_sub_process_cycle_company_sort'] }]
      }),

      // 工序数据查询优化
      SubProgressWork.findAll({
        where: {
          company_id,
          progress_id: progressIds
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
        ],
        // 强制索引（如果存在）
        // indexHints: [{ type: 'USE', values: ['idx_sub_progress_work_company_progress'] }]
      })
    ]);
    // 单独查询假期（数据量通常较小，可缓存）
    const dates = await SubDateInfo.findAll({
      where: { company_id },
      attributes: ['date'],
      raw: true // 直接返回原始数据，减少序列化开销
    });

    // 2. 数据处理优化
    // 2.1 假期数据处理
    const dateInfo = dates.map(item => item.date);

    // 2.2 制程数据处理 - 使用Map加速查找
    const cyclesMap = new Map();
    const processedCycles = cycles.map(cycle => {
      const item = cycle.toJSON();
      // 计算maxLoad时过滤无效数据
      item.maxLoad = (item.equipment || []).reduce((total, eq) => {
        const eff = Number(eq.efficiency) || 0;
        return total + eff;
      }, 0);
      cyclesMap.set(item.id, item);
      return item;
    });

    // 2.3 工序数据处理 - 预计算并缓存
    const worksMap = new Map();
    (work || []).forEach(workItem => {
      const item = workItem.toJSON();
      // 提前计算工时（避免重复解析）
      const orderNum = Number(item.order_number) || 0;
      const time = Number(item.children?.time) || 0;
      item.all_work_time = (orderNum * time / 3600).toFixed(1);
      
      // 按progress_id分组缓存
      const key = item.progress_id;
      if (!worksMap.has(key)) worksMap.set(key, []);
      worksMap.get(key).push(item);
    });

    // 3. 日期相关处理优化
    const deliveryTimes = [...new Set(baseJSON.map(e => e.delivery_time).filter(Boolean))];
    const date_more = getDateInfo(deliveryTimes);

    // 4. 负荷计算优化 - 传入缓存的Map而非数组
    const cased = setProgressLoad(
      baseJSON, 
      processedCycles, 
      Array.from(worksMap.values()).flat(), 
      dateInfo
    );
    
    // 5. 制程总负荷计算优化
    const callLoad = setCycleLoad(processedCycles, cased);
    const newCycles = setDateMore(baseJSON, callLoad, dateInfo, date_more);

    let cyclesBigs = 0
    newCycles.forEach(item => {
      const { maxLoad, cycle } = item;
      if (maxLoad == null || isNaN(Number(maxLoad))) return;
      
      // 遍历当前对象的cycle数组
      cycle.forEach(cycleItem => {
        const { load } = cycleItem;
        // 处理load为null/空的情况，直接跳过
        if (load == null || load === '') return;
        
        const loadNum = Number(load);
        if (isNaN(loadNum)) return;
        
        // 判断load是否大于maxLoad
        if (loadNum > maxLoad) {
          cyclesBigs++;
        }
      });
    });
    const total = await SubProgressTotal.findOne({ where: { company_id }, raw: true })
    
    if(total){
      if(total.number != cyclesBigs){
        await SubProgressTotal.update({ number: cyclesBigs, company_id }, { where: { id: total.id } })
      }
    }else{
      await SubProgressTotal.create({ number: cyclesBigs, company_id })
    }

    // 6. 响应数据精简
    res.json({ 
      code: 200, 
      data: { 
        cycles: newCycles, 
        works: cased, 
        date_more 
      } 
    });
  } catch (error) {
    console.error('get_progress_cycle error:', error);
    res.json({ code: 500, message: '服务器内部错误' });
  }
});

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
                include: [{ model: SubProcessCycle, as: 'cycle', attributes: ['id', 'name', 'sort'] }]
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
      { model: SubProductNotice, as: 'notice', attributes: ['id', 'delivery_time', 'notice'] }
    ]
  })
  const progressResult = progress.toJSON()

  res.json({ code: 200, data: { work: workResult, progress: progressResult } })
})
// 移动端报工单
router.post('/mobile_work_order', EmployeeAuth, async (req, res) => {
  const { number, id, company_id, product_id, part_id, process_id, bom_child_id, notice_id, progress_id } = req.body
  const { company_id: companyId, id: userId, name } = req.user
  if(company_id != companyId) return res.json({ message: '数据出错，请检查正确的地址或二维码', code: 401 })

  const quantity = Number(number)

  if(!quantity || quantity <= 0) return res.json({ message: '数量输入错误，请重新输入', code: 401 })

  const result = await SubProgressWork.findOne({
    where: { id },
    include: [
      {
        model: SubProcessBomChild,
        as: 'children',
        attributes: ['id', 'time'],
      },
    ]
  })
  const dataValue = result.toJSON()

  dataValue.finish = dataValue.finish ? PreciseMath.add(dataValue.finish, quantity) : quantity
  dataValue.order_number = PreciseMath.sub(dataValue.order_number, quantity)
  dataValue.all_work_time = (PreciseMath.mul(Number(dataValue.order_number), Number(dataValue.children.time)) / 60 / 60).toFixed(1)
  
  await SubRateWage.create({ 
    company_id: companyId,
    user_id: userId, 
    number, 
    bom_child_id: bom_child_id, 
    product_id, 
    part_id, 
    process_id,
    notice_id,
    progress_id
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