const express = require('express');
const router = express.Router();
const { AdUser, AdCompanyInfo, Op } = require('../models')
const authMiddleware = require('../middleware/auth');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const { formatArrayTime, formatObjectTime } = require('../middleware/formatTime');

/**
 * @swagger
 * /api/login:
 *   post:
 *     summary: 子后台登录
 *     tags:
 *       - 登录(Admin)
 *     parameters:
 *       - name: username
 *         schema:
 *           type: string
 *       - name: password
 *         schema:
 *           type: string
 */
router.post('/login', async (req, res) => {
  const { username, password } = req.body;
  
  const rows = await AdUser.findOne({
    where: {
      username,
      is_deleted: 1,
      status: 1
    },
    attributes: ['id', 'company_id', 'username', 'password', 'name', 'cycle_id', 'power', 'type', 'parent_id', 'status', 'purchase_v']
  })
  if(!rows) return res.json({ message: '账号或密码错误', code: 401 });
  const data = rows.toJSON()

  if(data.status == 0){
    return res.json({ message: '账号已被禁用，请联系管理员', code: 401 });
  }
  
  const isPasswordValid = await bcrypt.compare(password, data.password);
  if (!isPasswordValid) {
    return res.json({ message: '账号或密码错误', code: 401 });
  }

  const companyRows = await AdCompanyInfo.findAll({ where: { id: data.company_id }, raw: true });
  
  const token = jwt.sign({ ...data }, process.env.JWT_SECRET, { expiresIn: '6d' });

  const { password: _, ...newData } = data;
  
  res.json({ 
    token, 
    user: formatObjectTime(newData), 
    company: companyRows.length > 0 ? formatObjectTime(companyRows[0]) : null, 
    code: 200 
  });
});

module.exports = router;    