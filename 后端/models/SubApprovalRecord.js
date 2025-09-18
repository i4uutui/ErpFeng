const { DataTypes } = require('sequelize');
const sequelize = require('../config/sequelize');

const SubApprovalRecord = sequelize.define('SubApprovalRecord', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    comment: '记录ID'
  },
  company_id: {
    type: DataTypes.INTEGER,
    allowNull: false,
    comment: '所属企业id'
  },
  source_type: {
    type: DataTypes.STRING(50),
    allowNull: false,
    comment: '业务类型'
  },
  source_id: {
    type: DataTypes.INTEGER,
    allowNull: false,
    comment: '业务ID'
  },
  flow_id: {
    type: DataTypes.INTEGER,
    allowNull: false,
    comment: '流程ID'
  },
  current_step: {
    type: DataTypes.INTEGER,
    allowNull: true,
    defaultValue: 1,
    comment: '当前步骤'
  },
  status: {
    type: DataTypes.TINYINT(1),
    allowNull: true,
    defaultValue: 0,
    comment: '状态（0审批中/1通过/2拒绝）'
  },
  approver_id: {
    type: DataTypes.INTEGER,
    allowNull: true,
    defaultValue: null,
    comment: '当前审批人ID'
  },
  approve_time: {
    type: DataTypes.DATE,
    allowNull: true,
    defaultValue: null,
    comment: '审批时间'
  },
  remark: {
    type: DataTypes.TEXT,
    allowNull: true,
    comment: '审批备注'
  },
}, {
  sequelize,
  modelName: 'sub_approval_record',
  tableName: 'sub_approval_record',
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: 'updated_at',
  comment: '审批记录表'
})

module.exports = SubApprovalRecord