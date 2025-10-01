const jwt = require('jsonwebtoken');
const { AdUser, Op } = require('../models')

const authMiddleware = async (req, res, next) => {
  const token = req.headers['authorization'];
  if (!token) return res.json({ message: '认证失败', code: 402 });
  
  jwt.verify(token, process.env.JWT_SECRET, async (err, decoded) => {
    if (err) return res.json({ message: '认证失败', code: 402 });
    req.user = decoded;
    next();
  });
};

module.exports = authMiddleware;    