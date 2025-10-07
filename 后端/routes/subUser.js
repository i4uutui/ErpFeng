const express = require('express');
const router = express.Router();
const dayjs = require('dayjs')
const pool = require('../config/database');
const { AdUser, AdOrganize, SubProcessCycle, SubWarehouseApply, SubWarehouseCycle, SubApprovalUser, SubOperationHistory, SubApprovalStep, SubWarehouseContent, Op, SubConstType } = require('../models')
const authMiddleware = require('../middleware/auth');
const bcrypt = require('bcrypt');
const { formatArrayTime, formatObjectTime } = require('../middleware/formatTime');
const { PreciseMath, processStockOut } = require('../middleware/tool')

// 获取后台用户列表（分页）
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
  try {
    const { count, rows } = await AdUser.findAndCountAll({
      where: {
        is_deleted: 1,
        parent_id: userId,
        company_id,
      },
      attributes: ['id', 'name', 'parent_id', 'username', 'parent_id', 'status', 'power', 'created_at'],
      include: [{
        model: AdOrganize,
        as: 'organize',
        where: { is_deleted: 1 },
        required: false
      }],
      order: [['created_at', 'DESC']],
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
  } catch (error) {
    console.log(error);
  }
});

// 添加用户
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
  const { username, password, name, power, status } = req.body;
  
  const { id: parent_id, company_id } = req.user

  if(password.length < 6){
    return res.json({ message: '密码长度需大于等于6位，请重新输入', code: 401 })
  }
  const rows = await AdUser.findAll({
    where: {
      username,
      company_id
    }
  })
  if(rows.length != 0){
    return res.json({ message: '用户名已被使用，请输入其他用户名', code: 401 })
  }
  
  const hashedPassword = await bcrypt.hash(password, 10);
  const type = 2
  
  AdUser.create({
    username, name, power, status, parent_id, company_id, type,
    password: hashedPassword
  })
  
  res.json({ message: '添加成功', code: 200 });
});

// 更新子管理员接口
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
  const { username, password, name, power, status, id } = req.body;
  
  const { id: parent_id, company_id } = req.user
  
  // 检查新用户名是否已被其他用户使用
  const rows = await AdUser.findAll({
    where: {
      username, 
      company_id,
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
    username, name, power, type, company_id, parent_id, status,
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



// 生产制程
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
    attributes: ['id', 'name', 'created_at'],
    order: [['created_at', 'DESC']],
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
  const { name } = req.body;
  const { id: userId, company_id } = req.user;
  
  const processCycle = await SubProcessCycle.create({
    name,
    user_id: userId
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
  const { name, sort_date, id } = req.body;
  const { id: userId, company_id } = req.user;
  
  // 验证是否存在
  const processCycle = await SubProcessCycle.findByPk(id);
  if (!processCycle) {
    return res.json({ message: '生产制程不存在', code: 401 });
  }
  
  let cycleWhere = {}
  if(name) cycleWhere.name = name
  if(sort_date) cycleWhere.sort_date = sort_date
  await processCycle.update({
    ...cycleWhere,
    user_id: userId
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
      { model: SubConstType, as: 'ware', attributes: ['id', 'name'], where: { type: 'house' } }
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
 *     parameters:
 *       - name: source_type
 *         schema:
 *           type: string
 *       - name: steps
 *         schema:
 *           type: array
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
 *       - name: source_type
 *         schema:
 *           type: string
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
  const { data, action, ware_id } = req.body;
  const { id: userId, company_id, name } = req.user;

  if(data.length == 0) return res.json({ code: 401, message: '请选择需要审批的数据' })
  const result = await SubWarehouseApply.findAll({
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
        // 期初入库（非正常入库）
        if(e.type == 5 || e.type == 11){
          wareItem.initial = PreciseMath.add(wareItem.initial, e.quantity)
          // 最新库存
          wareItem.number_new = PreciseMath.add(wareItem.initial, wareItem.number_in)
          // 存货金额
          wareItem.price_total = wareItem.price ? PreciseMath.mul(wareItem.price, wareItem.number_new) : 0
          wareItem.last_in_time = dayjs().toDate()
        }
        // 4采购入库/10生产入库13退货入库 /6 and 12盘银入库（加）
        if(e.type == 4 || e.type == 10 || e.type == 13 || e.type == 6 || e.type == 12){
          wareItem.number_in = PreciseMath.add(wareItem.number_in, e.quantity)
          // 最新库存
          wareItem.number_new = PreciseMath.add(wareItem.initial, wareItem.number_in)
          // 存货金额
          wareItem.price_total = wareItem.price ? PreciseMath.mul(wareItem.price, wareItem.number_new) : 0
          wareItem.last_in_time = dayjs().toDate()
        }
        // 出库
        if(e.type == 7 || e.type == 8 || e.type == 9 || e.type == 14 || e.type == 15 || e.type == 16){
          // 出库减库存
          const stock = await processStockOut({ number_in: wareItem.number_in, initial: wareItem.initial }, e.quantity)
          if(stock == false) return res.json({ code: 401, message: '库存不足' })
          wareItem.number_in = stock.number_in
          wareItem.initial = stock.initial
          // 减掉库存后最新库存
          wareItem.number_new = PreciseMath.add(wareItem.initial, wareItem.number_in)
          // 最新出库数量
          wareItem.number_out = PreciseMath.add(wareItem.number_out, e.quantity)
          // 出库后存货金额
          wareItem.price_total = wareItem.price ? PreciseMath.mul(wareItem.price, wareItem.number_new) : 0
          wareItem.price_out = wareItem.price ? PreciseMath.sub(wareItem.price, wareItem.number_out) : 0
          wareItem.last_out_time = dayjs().toDate()
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
            unit: '',
            inv_unit: '',
            initial: 0,
            number_in: 0,
            number_out: 0,
            price_total: 0,
            price: 0,
            number_new: 0,
            price_in: 0,
            price_out: 0,
            last_in_time: dayjs().toDate(),
            last_out_time: null
          };
        }
        
        // 判断type属于哪一组
        if ([5, 11].includes(type)) {
          // type等于5或11
          grouped[item_id].initial = PreciseMath.add(grouped[item_id].initial, quantity);
        } else if ([4, 10, 13, 6, 12].includes(type)) {
          // type等于4或10或13或6或12
          grouped[item_id].number_in = PreciseMath.add(grouped[item_id].number_in, quantity);
        }
      });
      return Object.values(grouped).map(item => {
        if (item.initial > 0 || item.number_in > 0) {
          // 最新库存
          item.number_new = PreciseMath.add(item.initial, item.number_in);
        }
        return item;
      });
    }
    const regend = [...processArray(dataArr), ...wareList]

    await SubWarehouseContent.bulkCreate(regend, {
      updateOnDuplicate: [ 'user_id', 'company_id', 'ware_id', 'house_id', 'item_id', 'code', 'name', 'model_spec', 'other_features', 'unit', 'inv_unit', 'initial', 'number_in', 'number_out', 'price_total', 'price', 'number_new', 'price_in', 'price_out', 'last_in_time', 'last_out_time' ]
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

  const ware = await SubWarehouseContent.findByPk(dataValue.item_id)
  const wareData = ware.toJSON()
  // 期初入库（非正常入库）
  if(dataValue.type == 5 || dataValue.type == 11){
    wareData.initial = PreciseMath.sub(wareData.initial, dataValue.quantity)
    // 最新库存
    wareData.number_new = PreciseMath.add(wareData.initial, wareData.number_in)
    // 存货金额
    wareData.price_total = wareData.price ? PreciseMath.mul(wareData.price, wareData.number_new) : 0
  }
  // 4采购入库/10生产入库13退货入库 /6 and 12盘银入库（加）
  if(dataValue.type == 4 || dataValue.type == 10 || dataValue.type == 13 || dataValue.type == 6 || dataValue.type == 12){
    wareData.number_in = PreciseMath.sub(wareData.number_in, dataValue.quantity)
    // 最新库存
    wareData.number_new = PreciseMath.add(wareData.initial, wareData.number_in)
    // 存货金额
    wareData.price_total = wareData.price ? PreciseMath.mul(wareData.price, wareData.number_new) : 0
  }
  // 出库
  if(dataValue.type == 7 || dataValue.type == 8 || dataValue.type == 9 || dataValue.type == 14 || dataValue.type == 15 || dataValue.type == 16){
    wareData.number_in = PreciseMath.add(wareData.number_in, dataValue.quantity)
    // 最新库存
    wareData.number_new = PreciseMath.add(wareData.initial, wareData.number_in)
    // 存货金额
    wareData.price_total = wareData.price ? PreciseMath.mul(wareData.price, wareData.number_new) : 0
  }

  await SubWarehouseApply.update({
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
  await SubWarehouseContent.update({
    initial: wareData.initial,
    number_new: wareData.number_new,
    number_in: wareData.number_in,
    price_total: wareData.price_total,
    company_id: wareData.company_id,
    user_id: wareData.user_id
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

module.exports = router;   