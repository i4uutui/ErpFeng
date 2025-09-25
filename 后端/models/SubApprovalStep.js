const { DataTypes } = require('sequelize');
const sequelize = require('../config/sequelize');

const SubApprovalStep = sequelize.define('SubApprovalStep', {
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
  type: {
    type: DataTypes.STRING(50),
    allowNull: false,
    comment: ' 业务类型 '
  },
  step: {
    type: DataTypes.INTEGER,
    allowNull: false,
    comment: '步骤序号（从1开始）'
  },
  user_id: {
    type: DataTypes.INTEGER,
    allowNull: true,
    defaultValue: null,
    comment: '指定审批人ID（为空则角色内任意人可批）'
  },
  user_name: {
    type: DataTypes.STRING(30),
    allowNull: false,
    comment: ' 指定审批人名称 '
  },
  is_deleted: {
    type: DataTypes.INTEGER(1),
    allowNull: true,
    defaultValue: 1,
    comment: '是否删除：1-未删除，0-已删除'
  }
}, {
  sequelize,
  modelName: 'sub_approval_step',
  tableName: 'sub_approval_step',
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: 'updated_at',
  comment: '审批步骤配置表'
})

module.exports = SubApprovalStep