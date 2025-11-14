const { DataTypes } = require('sequelize');
const sequelize = require('../config/sequelize');

const SubApprovalUser = sequelize.define('SubApprovalUser', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    comment: '自增id'
  },
  company_id: {
    type: DataTypes.INTEGER,
    allowNull: true,
    comment: '企业id'
  },
  type: {
    type: DataTypes.STRING(50),
    allowNull: true,
    defaultValue: null,
    comment: '业务类型',
  },
  source_id: {
    type: DataTypes.INTEGER,
    allowNull: true,
    defaultValue: null,
    comment: '项目id'
  },
  user_id: {
    type: DataTypes.INTEGER,
    allowNull: true,
    defaultValue: null,
    comment: '审核人id'
  },
  user_name: {
    type: DataTypes.STRING(30),
    allowNull: true,
    defaultValue: null,
    comment: '审核人名称',
  },
  user_time: {
    type: DataTypes.DATE,
    allowNull: true,
    defaultValue: null,
    comment: '审核时间'
  },
  step: {
    type: DataTypes.INTEGER(2),
    allowNull: true,
    defaultValue: null,
    comment: '第几步骤'
  },
  status: {
    type: DataTypes.INTEGER(1),
    allowNull: true,
    defaultValue: 0,
    comment: '状态（0审批中/1通过/2拒绝）'
  },
}, {
  sequelize,
  modelName: 'sub_approval_user',
  tableName: 'sub_approval_user',
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: 'updated_at',
  comment: '流程控制用户表'
})

module.exports = SubApprovalUser