const express = require('express');
const router = express.Router();
const dayjs = require('dayjs')
const pool = require('../config/database');
const { AdUser, AdOrganize, SubProcessCycle, SubWarehouseApply, SubWarehouseCycle, SubApprovalUser, SubOperationHistory, SubApprovalStep, SubWarehouseContent, Op, SubWarehouseType } = require('../models')
const authMiddleware = require('../middleware/auth');
const bcrypt = require('bcrypt');
const { formatArrayTime } = require('../middleware/formatTime');
const { PreciseMath } = require('../middleware/tool');
const { default: Decimal } = require('decimal.js');

/**
 * @swagger
 * /api/user:
 *   get:
 *     summary: 获取后台用户列表（分页）
 *     tags:
 *       - 系统管理(User)
 *     parameters:
 *       - name: page
 *         schema:
 *           type: integer
 *           default: 1
 *       - name: pageSize
 *         schema:
 *           type: integer
 *           default: 10
 */
router.get('/user', authMiddleware, async (req, res) => {
  const { page = 1, pageSize = 10 } = req.query;
  const offset = (page - 1) * pageSize;
  const { company_id, id: userId } = req.user;
  // 查询当前页的数据，排除当前登录用户，只显示其创建的用户
  const { count, rows } = await AdUser.findAndCountAll({
    where: {
      is_deleted: 1,
      type: { [Op.ne]: 1 },
      id: { [Op.not]: userId },
      company_id,
    },
    attributes: ['id', 'name', 'cycle_id', 'parent_id', 'username', 'parent_id', 'status', 'power', 'created_at'],
    include: [
      { model: AdOrganize, as: 'organize', where: { is_deleted: 1 }, required: false },
      { model: SubProcessCycle, as: 'cycle', attributes: ['id', 'name'] }
    ],
    order: [['created_at', 'DESC']],
    distinct: true,
    limit: parseInt(pageSize),
    offset
  })
  const totalPages = Math.ceil(count / pageSize)

  const result = rows.map(user => {
    const data = user.toJSON()
    const organizeNames = data.organize?.map(pos => pos.label);
    return {
      ...data,
      organizeNames,
    };
  })

  // 返回所需信息
  res.json({ 
    data: formatArrayTime(result), 
    total: count, 
    totalPages, 
    currentPage: parseInt(page), 
    pageSize: parseInt(pageSize),
    code: 200
  });
});

/**
 * @swagger
 * /api/user:
 *   post:
 *     summary: 新增用户
 *     tags:
 *       - 系统管理(User)
 *     parameters:
 *       - name: username
 *         schema:
 *           type: string
 *       - name: password
 *         schema:
 *           type: string
 *       - name: name
 *         schema:
 *           type: string
 *       - name: power
 *         schema:
 *           type: string
 *       - name: status
 *         schema:
 *           type: int
 */
router.post('/user', authMiddleware, async (req, res) => {
  const { username, password, name,cycle_id, power, status } = req.body;
  
  const { id: parent_id, company_id } = req.user

  if(password.length < 6){
    return res.json({ message: '密码长度需大于等于6位，请重新输入', code: 401 })
  }
  const rows = await AdUser.findAll({
    where: {
      username,
      company_id,
      is_deleted: 1
    }
  })
  if(rows.length != 0){
    return res.json({ message: '用户名已被使用，请输入其他用户名', code: 401 })
  }
  
  const hashedPassword = await bcrypt.hash(password, 10);
  const type = 2
  
  AdUser.create({
    username, name, cycle_id, power, status, parent_id, company_id, type,
    password: hashedPassword
  })
  
  res.json({ message: '添加成功', code: 200 });
});

/**
 * @swagger
 * /api/user:
 *   put:
 *     summary: 更新用户
 *     tags:
 *       - 系统管理(User)
 *     parameters:
 *       - name: id
 *         schema:
 *           type: int
 *       - name: username
 *         schema:
 *           type: string
 *       - name: password
 *         schema:
 *           type: string
 *       - name: name
 *         schema:
 *           type: string
 *       - name: power
 *         schema:
 *           type: string
 *       - name: status
 *         schema:
 *           type: int
 */
router.put('/user', authMiddleware, async (req, res) => {
  const { username, password, name, cycle_id, power, status, id } = req.body;
  
  const { id: parent_id, company_id } = req.user
  
  // 检查新用户名是否已被其他用户使用
  const rows = await AdUser.findAll({
    where: {
      username, 
      company_id,
      is_deleted: 1,
      id: {
        [Op.ne]: id
      }
    }
  })
  if(rows.length != 0){
    return res.json({ message: '用户名已被使用，请输入其他用户名', code: 401 })
  }

  // 先查询原始密码
  const adminRows = await AdUser.findOne({
    where: { id, company_id }
  })
  
  // 如果密码字段存在且不为空，则加密新密码
  // 否则使用原始密码
  const passwordToUpdate = password ? await bcrypt.hash(password, 10) : adminRows.password;
  const type = 2

  // 更新管理员信息
  await AdUser.update({
    username, name, cycle_id, power, type, company_id, parent_id, status,
    password: passwordToUpdate
  }, { where: { id } })
  
  res.json({ message: "修改成功", code: 200 });
});

// 删除子后台用户
/**
 * @swagger
 * /api/user:
 *   delete:
 *     summary: 删除用户
 *     tags:
 *       - 系统管理(User)
 *     parameters:
 *       - name: id
 *         schema:
 *           type: int
 */
router.delete('/user/:id', authMiddleware, async (req, res) => {
  const { id } = req.params;
  
  const result = await AdUser.update({
    is_deleted: 0
  }, { where: { id, is_deleted: 1 } })
  
  if (result.affectedRows === 0) {
    return res.json({ message: '用户不存在或已被删除', code: 401 });
  }
  
  await AdUser.update({
    is_deleted: 0
  }, { where: { parent_id: id, is_deleted: 1 } })
  
  res.json({ message: '删除成功', code: 200 });
});





/**
 * 将扁平的组织节点数组转换为树形结构
 * @param {Array} nodes - 扁平的组织节点数组
 * @returns {Array} 树形结构数组
 */
function buildOrgTree(nodes) {
  const nodeMap = {};
  
  // 构建节点映射并初始化children
  nodes.forEach(node => {
    nodeMap[node.id] = {
      ...node,
      children: []
    };
  });

  // 构建树形结构
  const tree = [];
  nodes.forEach(node => {
    const currentNode = nodeMap[node.id];
    if (node.pid === 0) {
      tree.push(currentNode);
    } else if (nodeMap[node.pid]) {
      nodeMap[node.pid].children.push(currentNode);
    }
  });

  // 按sort排序并递归处理子节点
  // function sortChildren(node) {
  //   if (node.children && node.children.length > 0) {
  //     node.children.sort((a, b) => a.sort - b.sort);
  //     node.children.forEach(child => sortChildren(child));
  //   }
  // }
  
  // tree.forEach(rootNode => sortChildren(rootNode));
  return tree;
}
/**
 * @swagger
 * /api/organize:
 *   get:
 *     summary: 组织结构
 *     description: 本接口不需要传参数，直接调用即可
 *     tags:
 *       - 系统管理(User)
 */
router.get('/organize', authMiddleware, async (req, res) => {
  const { company_id } = req.user;
  
  const nodes = await AdOrganize.findAll({
    where: {
      is_deleted: 1,
      company_id,
    },
    include: [
      { model: AdUser, as: 'menber' }
    ],
  });
  const nodeList = nodes.map(node => {
    const data = node.toJSON()
    return {
      id: data.id,
      pid: data.pid,
      label: { label: data.label, menberName: data.menber?.name },
      menber_id: data.menber?.id
    }
  });
  // 构建树形结构
  const tree = buildOrgTree(nodeList);

  res.json({ 
    data: formatArrayTime(tree), 
    code: 200
  });
})
/**
 * @swagger
 * /api/organize:
 *   post:
 *     summary: 新增组织节点
 *     tags:
 *       - 系统管理(User)
 *     parameters:
 *       - name: pid
 *         schema:
 *           type: int
 *         description: 父节点ID，如果没有则填0
 *       - name: label
 *         schema:
 *           type: string
 *         description: 节点名称
 *       - name: menber_id
 *         schema:
 *           type: string
 *         description: 关联的用户ID
 */
router.post('/organize', authMiddleware, async (req, res) => {
  const { label, pid = 0, menber_id } = req.body;
  // menber_id所选择的用户id，pid父节点id
  const { company_id, id: user_id } = req.user;

  // 验证父节点是否存在
  if (pid != 0) {
    const parentNode = await AdOrganize.findByPk(pid);
    if (!parentNode) {
      return res.json({ message: '父节点不存在', code: 401})
    }
  }
  // 验证用户是否存在
  if (menber_id) {
    const userExists = await AdUser.findByPk(menber_id);
    if (!userExists) {
      return res.json({ message: '用户不存在', code: 401 });
    }
  }
  AdOrganize.create({ label, pid, menber_id, user_id, company_id })

  res.json({ message: '添加成功', code: 200 });
})
/**
 * @swagger
 * /api/organize:
 *   put:
 *     summary: 修改组织节点
 *     tags:
 *       - 系统管理(User)
 *     parameters:
 *       - name: id
 *         schema:
 *           type: int
 *         description: 当前节点ID
 *       - name: pid
 *         schema:
 *           type: int
 *         description: 父节点ID，如果没有则填0
 *       - name: label
 *         schema:
 *           type: string
 *         description: 节点名称
 *       - name: menber_id
 *         schema:
 *           type: string
 *         description: 关联的用户ID
 */
router.put('/organize', authMiddleware, async (req, res) => {
  const { label, pid = 0, menber_id, id } = req.body;
  // menber_id所选择的用户id，pid父节点id
  const { company_id, id: user_id } = req.user;

  const node = await AdOrganize.findByPk(id);
  if (!node) {
    return res.json({ message: '组织节点不存在', code: 401 });
  }
  if (menber_id !== undefined && menber_id !== null) {
    const userExists = await AdUser.findByPk(menber_id);
    if (!userExists) {
      return res.json({ message: '关联的用户不存在', code: 401 });
    }
  }
  await AdOrganize.update({
    label, pid, menber_id, company_id, user_id
  }, {
    where: { id }
  })

  res.json({ message: '修改成功', code: 200 });
})
/**
 * @swagger
 * /api/organize:
 *   delete:
 *     summary: 删除组织节点
 *     tags:
 *       - 系统管理(User)
 *     parameters:
 *       - name: id
 *         schema:
 *           type: int
 *         description: 当前节点ID
 */
router.delete('/organize', authMiddleware, async (req, res) => {
  const { id } = req.query;

  const node = await AdOrganize.findByPk(id);
  if (!node) {
    return res.json({ message: '组织节点不存在', code: 401 });
  }
  
  await AdOrganize.update({
    is_deleted: 0
  }, {
    where: { id }
  })

  res.json({ message: '删除成功', code: 200 });
})

/**
 * @swagger
 * /api/process_cycle:
 *   get:
 *     summary: 获取生产制程列表（分页）
 *     tags:
 *       - 系统管理(User)
 *     parameters:
 *       - name: page
 *         schema:
 *           type: integer
 *           default: 1
 *       - name: pageSize
 *         schema:
 *           type: integer
 *           default: 10
 */
router.get('/process_cycle', authMiddleware, async (req, res) => {
  const { page = 1, pageSize = 10 } = req.query;
  const offset = (page - 1) * pageSize;
  const { company_id } = req.user;
  
  const { count, rows } = await SubProcessCycle.findAndCountAll({
    where: {
      is_deleted: 1,
      company_id
    },
    attributes: ['id', 'name', 'sort', 'created_at'],
    order: [['sort', 'ASC']],
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
})
/**
 * @swagger
 * /api/process_cycle:
 *   post:
 *     summary: 新增生产制程
 *     tags:
 *       - 系统管理(User)
 *     parameters:
 *       - name: name
 *         schema:
 *           type: string
 */
router.post('/process_cycle', authMiddleware, async (req, res) => {
  const { name, sort } = req.body;
  const { id: userId, company_id } = req.user;
  
  const number = sort ? sort : 0
  await SubProcessCycle.create({
    name,
    user_id: userId,
    sort: number,
    company_id
  })
  
  res.json({ msg: '添加成功', code: 200 });
})
/**
 * @swagger
 * /api/process_cycle:
 *   put:
 *     summary: 修改生产制程
 *     tags:
 *       - 系统管理(User)
 *     parameters:
 *       - name: id
 *         schema:
 *           type: int
 *       - name: name
 *         schema:
 *           type: string
 */
router.put('/process_cycle', authMiddleware, async (req, res) => {
  const { name, sort_date, sort, id } = req.body;
  const { id: userId, company_id } = req.user;
  // 验证是否存在
  const processCycle = await SubProcessCycle.findByPk(id);
  if (!processCycle) {
    return res.json({ message: '生产制程不存在', code: 401 });
  }
  
  let cycleWhere = {}
  if(name) cycleWhere.name = name
  if(sort_date || sort_date == '' || sort_date == 0){
    if(sort_date == ''){
      cycleWhere.sort_date = null
    }else{
      cycleWhere.sort_date = sort_date
    }
  }
  await processCycle.update({
    ...cycleWhere,
    user_id: userId,
    sort
  }, { where: { id } })
  
  res.json({ msg: "修改成功", code: 200 });
})




/**
 * @swagger
 * /api/warehouse_cycle:
 *   get:
 *     summary: 仓库名列表
 *     tags:
 *       - 系统管理(User)
 *     parameters:
 *       - name: ware_id
 *         schema:
 *           type: int
 */
router.get('/warehouse_cycle', authMiddleware, async (req, res) => {
  const { ware_id } = req.query;
  const { company_id } = req.user;
  
  let whereQuery = {}
  if(ware_id) whereQuery.ware_id = ware_id
  const rows = await SubWarehouseCycle.findAll({
    where: {
      is_deleted: 1,
      company_id,
      ...whereQuery
    },
    attributes: ['id', 'name', 'ware_id', 'created_at'],
    include: [
      { model: SubWarehouseType, as: 'ware', attributes: ['id', 'name'], where: { type: 'house' } }
    ],
    order: [['created_at', 'DESC']],
  })
  const data = rows.map(e => e.toJSON())
  
  // 返回所需信息
  res.json({ 
    data: formatArrayTime(data), 
    code: 200 
  });
})
/**
 * @swagger
 * /api/warehouse_cycle:
 *   post:
 *     summary: 新增仓库
 *     tags:
 *       - 系统管理(User)
 *     parameters:
 *       - name: name
 *         schema:
 *           type: string
 *       - name: ware_id
 *         schema:
 *           type: int
 */
router.post('/warehouse_cycle', authMiddleware, async (req, res) => {
  const { name, ware_id } = req.body;
  const { id: userId, company_id } = req.user;
  
  await SubWarehouseCycle.create({
    name, company_id, ware_id,
    user_id: userId
  })
  
  res.json({ msg: '添加成功', code: 200 });
})
/**
 * @swagger
 * /api/warehouse_cycle:
 *   put:
 *     summary: 修改仓库
 *     tags:
 *       - 系统管理(User)
 *     parameters:
 *       - name: id
 *         schema:
 *           type: int
 *       - name: name
 *         schema:
 *           type: string
 *       - name: ware_id
 *         schema:
 *           type: int
 */
router.put('/warehouse_cycle', authMiddleware, async (req, res) => {
  const { name, ware_id, id } = req.body;
  const { id: userId, company_id } = req.user;
  
  // 验证是否存在
  const warehouse = await SubWarehouseCycle.findByPk(id);
  if (!warehouse) {
    return res.json({ message: '仓库类型不存在', code: 401 });
  }
  
  await warehouse.update({
    name, company_id, ware_id,
    user_id: userId
  }, { where: { id } })
  
  res.json({ msg: "修改成功", code: 200 });
})
/**
 * @swagger
 * /api/get_approval_flow:
 *   get:
 *     summary: 获取审批流程
 *     tags:
 *       - 系统管理(User)
 */
router.get('/get_approval_flow', authMiddleware, async (req, res) => {
  const { id: userId, company_id } = req.user;

  const step = await SubApprovalStep.findAll({
    where: { company_id, is_deleted: 1 },
    attributes: ['id', 'step', 'type', 'user_id', 'user_name'],
    order: [
      ['type', 'DESC'],
      ['step', 'ASC']
    ],
  })
  const fromData = step.map(e => e.toJSON())
  res.json({ code: 200, data: formatArrayTime(fromData) });
})
/**
 * @swagger
 * /api/approval_flow:
 *   post:
 *     summary: 保存审批流程
 *     tags:
 *       - 系统管理(User)
 *     parameters:
 *       - name: steps
 *         schema:
 *           type: array
 */
router.post('/approval_flow', authMiddleware, async (req, res) => {
  const { steps } = req.body;
  const { id: userId, company_id } = req.user;
  
  // 将数据库中存在但前端未传过来的数据的is_deleted设为0
  const stepIds = steps.filter(step => step.id).map(o => o.id); // 提取前端数据中的所有id
  const step = await SubApprovalStep.findAll({
    where: {
      company_id,
      is_deleted: 1,
      id: {
        [Op.notIn]: stepIds
      }
    },
    attributes: ['id', 'is_deleted', 'type', 'step', 'company_id']
  })
  const result = step.map(e => {
    const item = e.toJSON()
    item.is_deleted = 0
    return item
  })
  if(result.length){
    await SubApprovalStep.bulkCreate(result, {
      updateOnDuplicate: ['is_deleted', 'type', 'step', 'company_id']
    });
  }
  // 批量更新有ID和无ID的的数据
  const base = steps.map(o => {
    o.company_id = company_id
    return o
  })
  if(base.length){
    await SubApprovalStep.bulkCreate(base, {
      updateOnDuplicate: ['is_deleted', 'type', 'step', 'company_id', 'user_id', 'user_name']
    });
  }
  res.json({ code: 200, data: null });
});

// Decimal数字相加/减
function precise(a, b, value) {
  // 处理空值，默认视为 0
  const validA = a ?? 0;
  const validB = b ?? 0;

  // 确保传入的参数被转换为 Decimal 实例
  const decimalA = new Decimal(validA);
  const decimalB = new Decimal(validB);
  
  // 相加并返回结果
  if(value == 'add'){
    return decimalA.add(decimalB).toNumber();
  }
  if(value == 'sub'){
    return decimalA.sub(decimalB).toNumber();
  }
}

/**
 * @swagger
 * /api/approval_flow:
 *   post:
 *     summary: 处理审批流程
 *     tags:
 *       - 系统管理(User)
 *     parameters:
 *       - name: data
 *         schema:
 *           type: array
 *       - name: action
 *         schema:
 *           type: int
 *       - name: type
 *         schema:
 *           type: string
 */
router.post('/handleApproval', authMiddleware, async (req, res) => {
  const { data, action, ware_id, source_type } = req.body;
  const { id: userId, company_id, name } = req.user;

  if(data.length == 0) return res.json({ code: 401, message: '请选择需要审批的数据' })
  const result = await SubWarehouseApply.findAll({
    where: {
      id: data,
      company_id,
      status: 0,
    },
    include: [
      { model: SubApprovalUser, as: 'approval', attributes: [ 'user_id', 'user_name', 'type', 'step', 'company_id', 'source_id', 'user_time', 'status', 'id' ], order: [['step', 'ASC']], where: { type: 'material_warehouse', company_id, type: source_type }, separate: true, }
    ],
    order: [
      ['created_at', 'DESC']
    ],
  })
  const warehouse = result.map(e => e.toJSON())

  let approval = []
  let approvalData = [] // 储存需要放入库存的数据
  const dataValue = warehouse.map(e => {
    const item = e.approval[e.step]
    if(item.user_id == userId){
      item.status = action
      if(action == 1){
        e.step++
        if(e.step == e.approval.length){
          e.status = 1
          approvalData.push(e)
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
  // 处理将数据放入仓库中
  if(approvalData.length){
    // 获取仓库列表数据
    const wareData = await SubWarehouseContent.findAll({
      where: {
        company_id,
        ware_id
      }
    })
    const wareValue = wareData.map(e => e.toJSON())
    // 临时储存仓库中没有的数据，单独处理仓库的没有的数据
    let dataArr = []
    // 仓库中的有的数据，使用wareList保存起来
    let wareList = []
    approvalData.forEach(async e => {
      const wareItem = wareValue.find(o => o.item_id == e.item_id)
      if(wareItem){ // 仓库里面有数据
        const setWareItem = (value) => e[value] ? e[value] : wareItem[value] ? wareItem[value] : null
        // 内部单价
        wareItem.price = setWareItem('price')
        // 采购/销售单价
        wareItem.buy_price = setWareItem('buy_price')
        // 采购/销售单位
        wareItem.unit = setWareItem('unit')
        // 库存单位
        wareItem.inv_unit = setWareItem('inv_unit')

        const quantitys = (value) => {
          wareItem.quantity = wareItem.quantity ? precise(wareItem.quantity, e.quantity, value) : e.quantity ? e.quantity : 0
          const type = {
            'add': 'last_in_time',
            'sub': 'last_out_time'
          }
          wareItem[type] = dayjs().toDate()
        }
        // 材料 - 采购入库 || 期初入库 || 盘盈入库
        // 成品 - 生产入库 || 期初入库 || 盘盈入库 || 退货入库
        if([4, 5, 6, 10, 11, 12, 13].includes(e.type)){
          quantitys('add')
        }
        // 材料 - 生产领料 || 委外领料 || 盘亏出库
        // 成品 - 成品出货 || 报废出库 || 盘亏出库
        if([7, 8, 9, 14, 15, 16].includes(e.type)){
          quantitys('sub')
        }
        wareList.push(wareItem)
      }else{ // 仓库没有数据，暂时先保存起来，待会再处理
        dataArr.push(e)
      }
    })
    const processArray = (arr) => {
      if(!arr.length) return []
      const grouped = {};
      arr.forEach(item => {
        const { item_id, quantity, type } = item;
        
        // 如果该item_id还没有分组，初始化
        if (!grouped[item_id]) {
          grouped[item_id] = {
            user_id: userId,
            company_id,
            ware_id: item.ware_id,
            house_id: item.house_id,
            item_id,
            code: item.code,
            name: item.name,
            model_spec: item.model_spec,
            other_features: item.other_features,
            buy_price: Number(item.buy_price),
            price: Number(item.price),
            quantity: Number(item.quantity),
            unit: item.unit,
            inv_unit: item.unit,
            last_in_time: dayjs().toDate(),
            last_out_time: null
          };
        }
        
        // 判断type属于哪一组
        if ([5, 11].includes(type)) {
          // type等于5或11
          grouped[item_id].initial = precise(grouped[item_id].initial, quantity, 'add');
        } else if ([4, 10, 13, 6, 12].includes(type)) {
          // type等于4或10或13或6或12
          grouped[item_id].number_in = precise(grouped[item_id].number_in, quantity, 'add');
        }
      });
      return Object.values(grouped).map(item => {
        if (item.initial > 0 || item.number_in > 0) {
          // 最新库存
          item.number_new = precise(item.initial, item.number_in, 'add');
        }
        return item;
      });
    }
    const regend = [...processArray(dataArr), ...wareList]
    await SubWarehouseContent.bulkCreate(regend, {
      updateOnDuplicate: [ 'user_id', 'company_id', 'ware_id', 'house_id', 'item_id', 'code', 'name', 'model_spec', 'other_features', 'buy_price', 'price', 'quantity', 'inv_unit', 'unit', 'last_in_time', 'last_out_time' ]
    })
  }
  if(!approval.length) return res.json({ message: '暂无可审核的数据', code: 401 })
  await SubApprovalUser.bulkCreate(approval, {
    updateOnDuplicate: ['user_id', 'user_name', 'type', 'step', 'company_id', 'source_id', 'user_time', 'status']
  })
  await SubWarehouseApply.bulkCreate(dataValue, {
    updateOnDuplicate: ['status', 'step']
  })
  res.json({ message: '审核成功', code: 200 })
})

/**
 * @swagger
 * /api/approval_backFlow:
 *   post:
 *     summary: 反审核
 *     tags:
 *       - 系统管理(User)
 *     parameters:
 *       - name: id
 *         schema:
 *           type: int
 */
router.post('/approval_backFlow', authMiddleware, async (req, res) => {
  const { id } = req.body;
  const { id: userId, company_id } = req.user;

  const result = await SubWarehouseApply.findByPk(id)
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

  const ware = await SubWarehouseContent.findOne({
    where: {
      item_id: dataValue.item_id
    }
  })
  const wareData = ware.toJSON()
  wareData.quantity = PreciseMath.sub(wareData.quantity, dataValue.quantity)

  await SubWarehouseApply.update({
    user_id: dataValue.user_id,
    company_id: dataValue.company_id,
    status: 3,
    step: 0
  },{
    where: {
      id: dataValue.id
    }
  })
  await SubApprovalUser.bulkCreate(approvalValue, {
    updateOnDuplicate: ['company_id', 'status']
  })
  await SubWarehouseContent.update({
    quantity: wareData.quantity,
    company_id: wareData.company_id,
  }, {
    where: {
      id: wareData.id
    }
  })

  res.json({ code: 200, message: '操作成功' })
})
/**
 * @swagger
 * /api/operation_history:
 *   get:
 *     summary: 获取用户操作记录
 *     tags:
 *       - 系统管理(User)
 *     parameters:
 *       - name: page
 *         schema:
 *           type: int
 *       - name: pageSize
 *         schema:
 *           type: int
 */
router.get('/operation_history', authMiddleware, async (req, res) => {
  const { page = 1, pageSize = 10, user_id, operation_type, module } = req.query;
  const offset = (page - 1) * pageSize;
  const { company_id } = req.user;

  const whereHistory = {}
  if(user_id) whereHistory.user_id = user_id
  if(operation_type) whereHistory.operation_type = operation_type
  if(module) whereHistory.module = module
  const { count, rows } = await SubOperationHistory.findAndCountAll({
    where: {
      company_id,
      ...whereHistory
    },
    order: [['created_at', 'DESC']],
    distinct: true,
    limit: parseInt(pageSize),
    offset
  })
  const totalPages = Math.ceil(count / pageSize);
  const row = rows.map(e => e.toJSON())
  // 返回所需信息
  res.json({ 
    data: formatArrayTime(row, 'timer'), 
    total: count, 
    totalPages, 
    currentPage: parseInt(page), 
    pageSize: parseInt(pageSize),
    code: 200 
  });
})

module.exports = router;   