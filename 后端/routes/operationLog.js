const express = require('express');
const router = express.Router();
const { SubOperationHistory } = require('../models');
const authMiddleware = require('../middleware/auth'); // 验证登录态

/**
 * 接收前端上报的操作日志
 */
router.post('/operation_log', authMiddleware, async (req, res) => {
  try {
    const { userId, userName, companyId, operationType, module, desc, data } = req.body;

    // 存储日志到数据库
    await SubOperationHistory.create({
      user_id: userId,
      user_name: userName,
      company_id: companyId,
      operation_type: operationType,
      module: module,
      desc,
      data,
    });

    res.json({ code: 200, message: '日志记录成功' });
  } catch (error) {
    console.error('日志存储失败：', error);
    res.json({ code: 500, message: '日志记录失败' });
  }
});

module.exports = router;