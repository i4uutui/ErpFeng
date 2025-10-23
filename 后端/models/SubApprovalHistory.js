const { DataTypes } = require('sequelize');
const sequelize = require('../config/sequelize');

const SubApprovalHistory = sequelize.define('SubApprovalHistory', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    comment: '历史ID'
  },
  company_id: {
    type: DataTypes.INTEGER,
    allowNull: false,
    comment: '所属企业id'
  },
  record_id: {
    type: DataTypes.INTEGER,
    allowNull: false,
    comment: '关联审批记录ID'
  },
  step: {
    type: DataTypes.INTEGER,
    allowNull: false,
    comment: '操作步骤'
  },
  user_id: {
    type: DataTypes.INTEGER,
    allowNull: false,
    comment: '操作人ID'
  },
  user_name: {
    type: DataTypes.STRING(30),
    allowNull: false,
    comment: '操作人名称'
  },
  action: {
    type: DataTypes.TINYINT(1),
    allowNull: false,
    comment: '操作（1通过/2拒绝）'
  },
  remark: {
    type: DataTypes.TEXT,
    allowNull: true,
    comment: '备注'
  },
}, {
  sequelize,
  modelName: 'sub_approval_history',
  tableName: 'sub_approval_history',
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: 'updated_at',
  comment: '审批操作历史表'
})

module.exports = SubApprovalHistory