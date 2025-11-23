const express = require('express');
const router = express.Router();
const authMiddleware = require('../middleware/auth');
const { SubMaterialOrder, SubOutsourcingOrder, SubWarehouseOrder, SubNoEncoding } = require('../models');

/**
 * @swagger
 * /api/sub_no_encoding:
 *   get:
 *     summary: 获取no编码
 *     tags:
 *       - 编码配置(NoCode)
 */
router.get('/sub_no_encoding', authMiddleware, async (req, res) => {
  const { printType } = req.query;
  const { company_id } = req.user;

  const lastRecord = await SubNoEncoding.findOne({
    where: {
      print_type: printType,
      company_id
    },
    attributes: ['id', 'no', 'print_type'],
    order: [['id', 'DESC']],
    limit: 1
  })
  res.json({ code: 200, data: lastRecord })
})

/**
 * @swagger
 * /api/setOrderNoCode:
 *   get:
 *     summary: 设置数据的no编码
 *     tags:
 *       - 编码配置(NoCode)
 */
router.post('/setOrderNoCode', authMiddleware, async (req, res) => {
  const { no, id, printType, typeIndex } = req.body
  const { id: userId, company_id } = req.user;

  const sqlModel = {
    1: SubMaterialOrder,
    2: SubOutsourcingOrder,
    3: SubWarehouseOrder
  }

  await sqlModel[typeIndex].update({ no }, { where: { id } })
  await SubNoEncoding.create({ company_id, no, print_type: printType })

  res.json({ code: 200, message: '编码配置成功' })
})

module.exports = router;