const { DataTypes } = require('sequelize');
const sequelize = require('../config/sequelize');

const SubOperationHistory = sequelize.define('SubOperationHistory', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    comment: '自增ID'
  },
  user_id: {
    type: DataTypes.INTEGER,
    allowNull: false,
    comment: '操作用户ID'
  },
  user_name: {
    type: DataTypes.STRING(50),
    allowNull: false,
    comment: '操作用户名称'
  },
  company_id: {
    type: DataTypes.INTEGER,
    allowNull: false,
    comment: '企业ID'
  },
  operation_type: {
    type: DataTypes.STRING(20),
    allowNull: false,
    comment: '操作类型（add/update/delete/query等）'
  },
  module: {
    type: DataTypes.STRING(50),
    allowNull: false,
    comment: '操作模块'
  },
  desc: {
    type: DataTypes.TEXT,
    allowNull: true,
    comment: '操作描述'
  },
  data: {
    type: DataTypes.TEXT,
    allowNull: true,
    comment: '操作数据（JSON格式）'
  }
}, {
  sequelize,
  modelName: 'sub_operation_history',
  tableName: 'sub_operation_history',
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: false, // 日志无需更新
  comment: '用户操作日志表'
});

module.exports = SubOperationHistory;