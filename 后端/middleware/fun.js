const dayjs = require("dayjs");

const setProgressLoad = (base, cycles, works) => {
  // 预处理base数据，计算每个progress_id对应的起始时间
  const baseStartDateMap = base.reduce((map, item) => {
    const today = dayjs();
    const baseDate = dayjs(item.start_date);
    // 判断base日期是否在今天之后，否则使用今天
    const startDate = baseDate.isAfter(today) ? baseDate : today;
    map[item.id] = startDate;
    return map;
  }, {});

  // 处理cycles，按sort_date排序后计算累计最短周期（首次不叠加）
  // 复制cycles数组并转换sort_date为数字（避免字符串排序问题）
  const sortedCycles = [...cycles].map(cycle => ({
    ...cycle,
    sort_date_num: Number(cycle.sort_date) || 0
  })).sort((a, b) => a.sort_date_num - b.sort_date_num);

  // 计算每个cycle的累计最短周期（sumCycle）
  let accumulatedCycle = 0; // 累计周期，首次为0（不叠加）
  const cycleSumMap = sortedCycles.reduce((map, cycle, index) => {
    if (index > 0) { // 从第二个cycle开始叠加sort_date
      accumulatedCycle += cycle.sort_date_num;
    }
    map[cycle.id] = accumulatedCycle; // 以cycle.id作为key
    return map;
  }, {});

  // 步骤3：关联works、base、cycles数据，计算load值
  const resultWorks = works.map(work => {
    const progressId = work.progress_id;
    // 获取当前work对应的起始时间（base数据）
    const startDate = baseStartDateMap[progressId];
    if (!startDate) {
      console.warn(`未找到progress_id=${progressId}对应的base起始时间`);
      return { ...work, load: null };
    }

    // 找到当前work对应的cycle项（通过progress_id关联cycles.cycle）
    let targetCycle = null;
    for (const cycleGroup of cycles) {
      const found = cycleGroup.cycle.find(c => c.progress_id === progressId);
      if (found) {
        targetCycle = found;
        break;
      }
    }

    if (!targetCycle) {
      console.warn(`未找到progress_id=${progressId}对应的cycle数据`);
      return { ...work, load: null };
    }

    // 获取当前cycle的累计最短周期
    const sumCycle = cycleSumMap[targetCycle.cycle_id] || 0;

    // 计算总天数 = 起始时间到结束时间的天数差 + 累计最短周期
    // 注意：起始时间是日期对象，需要计算"起始时间 + sumCycle天"对应的总天数差（这里sumCycle是天数）
    const endDate = startDate.add(sumCycle, 'day');
    const totalDays = endDate.diff(startDate, 'day'); // 实际总天数 = sumCycle（因为startDate到startDate+sumCycle天的差就是sumCycle）

    // 避免除数为0（如果总天数为0，设为1天避免报错）
    const validTotalDays = totalDays > 0 ? totalDays : 1;

    // 计算load：all_work_time / 总天数
    const allWorkTime = Number(work.all_work_time) || 0;
    const load = allWorkTime / validTotalDays;

    return {
      ...work,
      load: load.toFixed(1)
    };
  });
  return resultWorks
}

module.exports = {
  setProgressLoad,
};