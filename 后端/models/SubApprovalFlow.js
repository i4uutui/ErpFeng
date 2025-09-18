const { DataTypes } = require('sequelize');
const sequelize = require('../config/sequelize');

const SubApprovalFlow = sequelize.define('SubApprovalFlow', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    comment: '自增ID'
  },
  company_id: {
    type: DataTypes.INTEGER,
    allowNull: false,
    comment: '所属企业id'
  },
  source_type: {
    type: DataTypes.STRING(50),
    allowNull: true,
    defaultValue: null,
    comment: '关联业务型：purchase_order/outsourcing_order/material_warehouse/product_warehouse'
  },
  status: {
    type: DataTypes.TINYINT(1),
    allowNull: true,
    defaultValue: 1,
    comment: '状态（1启用/0禁用）'
  },
}, {
  sequelize,
  modelName: 'sub_approval_flow',
  tableName: 'sub_approval_flow',
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: 'updated_at',
  comment: '审批流程配置表'
})

module.exports = SubApprovalFlow