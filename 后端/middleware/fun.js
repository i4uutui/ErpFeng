const dayjs = require("dayjs");
const { PreciseMath } = require("./tool");

const setProgressLoad = (base, cycles, works, dateInfo) => {
  console.log(dateInfo);
	// 转为Set，提高查询效率
	const specialDateSet = new Set(dateInfo.map(date => dayjs(date).format("YYYY-MM-DD")));
	// 步骤1：预处理数据 - 创建映射关系，提高查询效率
	// 1.1 base映射：key=progress_id（即base.id），value=base对象
	const baseMap = new Map(base.map(item => [item.id, item]));

	// 1.2 cycles映射：key=cycle_id（cycles.id），value=cycle对象
	const cycleGroupMap = new Map(cycles.map(cycleGroup => [cycleGroup.id, cycleGroup]));

	// 1.3 cycle明细映射：key=cycle_id-progress_id，value=cycle明细对象
	const cycleItemMap = new Map();
	cycles.forEach(cycleGroup => {
		cycleGroup.cycle.forEach(cycleItem => {
			const key = `${cycleItem.cycle_id}-${cycleItem.progress_id}`;
			cycleItemMap.set(key, cycleItem);
		});
	});

	// 工具函数：计算两个日期之间的有效天数（剔除特殊日期）
	const getValidDays = (start, end) => {
		let validDays = 0;
		let current = dayjs(start).clone();
		const endDate = dayjs(end);

		// 遍历从start到end的所有日期
		while (current.isBefore(endDate) || current.isSame(endDate)) {
			const dateStr = current.format("YYYY-MM-DD");
			// 不是特殊日期则计入有效天数
			if (!specialDateSet.has(dateStr)) {
				validDays++;
			}
			current = current.add(1, "day");
		}
		return validDays;
	};

	// 步骤2：计算每个work的load值
	const resultWorks = works.map(work => {
		try {
			// 2.1 获取关联的基础数据
			const progressId = work.progress_id;
			const cycleId = work.children.equipment.cycle.id;

			// 获取对应的base对象（起始时间来源）
			const baseItem = baseMap.get(progressId);
			if (!baseItem) return;

			// 获取对应的cycle组（sort_date来源）
			const cycleGroup = cycleGroupMap.get(cycleId);
			if (!cycleGroup) return;

			// 获取对应的cycle明细（end_date来源）
			const cycleItemKey = `${cycleId}-${progressId}`;
			const cycleItem = cycleItemMap.get(cycleItemKey);
			if (!cycleItem) return;

			// 2.2 处理起始时间（规则：base.start_date在今天之后则用base.start_date，否则用今天）
			const today = dayjs().startOf("day"); // 今天0点
			const baseStartDate = dayjs(baseItem.start_date).startOf("day");
			const startDate = baseStartDate.isAfter(today) ? baseStartDate : today;

			// 2.3 计算最短周期之和（规则：循环cycles，累加之前的sort_date，end_date为空则跳过，首次不加）
			let totalSortDate = 0;
      for (let i = 0; i < cycles.length; i++) {
        const currentCycleGroup = cycles[i];
        if (currentCycleGroup.id === cycleId) break;
        const hasValidEndDate = currentCycleGroup.cycle.some(item => item.end_date);
        if (hasValidEndDate) {
          totalSortDate += Number(currentCycleGroup.sort_date) || 0;
        }
      }

			// 2.4 检查cycle明细的end_date是否有效
			if (!cycleItem.end_date) {
				// console.log(`work.id=${work.id}：cycle明细end_date为空，跳过计算`);
				return { ...work, load: null };
			}

			// 2.5 计算实际开始日期 = 起始时间 + 最短周期之和
			const actualStartDate = startDate.add(totalSortDate, 'day');
      const endDate = dayjs(cycleItem.end_date).startOf('day');
      
      // 计算有效天数（剔除特殊日期）
      const validDays = getValidDays(actualStartDate, endDate) - 1;
      console.log(actualStartDate.format('YYYY-MM-DD'), endDate.format('YYYY-MM-DD'), validDays);

			// 2.6 计算load（避免除以0）
			if (validDays <= 0) {
				// console.log(`work.id=${work.id}：有效天数${validDays}不合法，无法计算load`);
				return { ...work, load: null };
			}

			const allWorkTime = Number(work.all_work_time) || 0;
			const load = allWorkTime / validDays;

			// 返回更新后的数据（保留原始结构，只更新load）
			return { ...work, load: load.toFixed(1) }; // 保留2位小数，可根据需求调整
		} catch (error) {
			// console.error(`work.id=${work.id}计算失败：`, error.message);
			return { ...work, load: null }; // 异常时load设为null
		}
	});
	return resultWorks;
};


const setCycleLoad = (cycles, works) => {
	// 遍历每个大循环（备料组、热处理等）
	cycles.forEach(cycleGroup => {
		// 遍历每个大循环下的具体循环项
		cycleGroup.cycle.forEach(cycleItem => {
			let totalLoad = 0;

			// 遍历所有工作项，找到匹配的进行累加
			works.forEach(work => {
				// 匹配条件：
				// 1. work.progress_id === cycleItem.progress_id
				// 2. work.children.equipment.cycle.id === cycleItem.cycle_id
				// 3. work.load 有值（非null/undefined）
				if (work.progress_id === cycleItem.progress_id && work.children?.equipment?.cycle?.id === cycleItem.cycle_id && work.load !== null && work.load !== undefined) {
					// 将 work.load 转为数字后累加（处理字符串格式的数字）
					// totalLoad += parseFloat() || 0;
					totalLoad = PreciseMath.add(totalLoad, Number(work.load));
				}
			});
			// console.log(totalLoad);
			// 如果有累加结果，赋值给 cycleItem.load；否则保持 null
			cycleItem.load = totalLoad > 0 ? totalLoad.toFixed(1) : null;
		});
	});

	return cycles;
};
const setDateMore = () => {
  
}

module.exports = {
	setProgressLoad,
	setCycleLoad,
  setDateMore
};
