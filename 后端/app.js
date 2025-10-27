const express = require('express');
const app = express();
const cors = require('cors');
const bodyParser = require('body-parser');
require('dotenv').config();

const swaggerUi = require('swagger-ui-express');
const swaggerDocs = require('./config/swagger.js');

app.use(cors({
  origin: [
    "https://admin.yuanfangzixun.com.cn",
    "https://feng.yuanfangzixun.com.cn",
    "http://localhost:9998",
    "http://localhost:9999",
    "http://localhost:52330"
  ],
  methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
  allowedHeaders: ["Content-Type", "Authorization"],  // 允许前端传递的头信息
  credentials: true  // 允许跨域携带 Cookie（如果需要）
}));
app.use(bodyParser.json());

// 配置 Swagger 文档路由
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocs));

// 路由
app.use('/admin', require('./routes/admin'));
app.use('/api', require('./routes/home')); // 首页
app.use('/api', require('./routes/finance')); // 财务管理
app.use('/api', require('./routes/operationLog')); // 操作日志
app.use('/api', require('./routes/subAdmin'));
app.use('/api', require('./routes/subUser')); // 用户管理
app.use('/api', require('./routes/subBasic')); // 基础资料
app.use('/api', require('./routes/subOrder')); // 订单管理
app.use('/api', require('./routes/subPurchase')); // 采购管理
app.use('/api', require('./routes/subProduct')); // bom表管理
app.use('/api', require('./routes/subOutSourcing')); // 委外管理
app.use('/api', require('./routes/subProduction')); // 生产管理
app.use('/api', require('./routes/subWareHouse')); // 仓库管理
app.use('/api', require('./routes/subGetList')); // 获取其他列表相关的接口
app.use('/upload', require('./routes/upload'));

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`端口 ${PORT}`);
  console.log(`文档地址: http://localhost:${PORT}/api-docs`);
});


// https://github.com/i4uutui/ceErns.git