const { DataTypes } = require('sequelize');
const sequelize = require('../config/sequelize');

const SubWarehouseApply = sequelize.define('SubWarehouseApply', {
  id: {
    type: DataTypes.INTEGER(11),
    primaryKey: true,
    autoIncrement: true,
    comment: '自增ID'
  },
  user_id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    comment: '发布的用户id'
  },
  company_id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    comment: '所属企业id'
  },
  ware_id: {
    type: DataTypes.INTEGER(11),
    allowNull: true,
    defaultValue: null,
    comment: '仓库类型ID'
  },
  house_id: {
    type: DataTypes.INTEGER(11),
    allowNull: true,
    defaultValue: null,
    comment: '仓库ID'
  },
  item_id: {
    type: DataTypes.INTEGER(11),
    allowNull: true,
    defaultValue: null,
    comment: '物料ID'
  },
  code: {
    type: DataTypes.STRING(20),
    allowNull: true,
    defaultValue: null,
    comment: '物料编码'
  },
  name: {
    type: DataTypes.STRING(50),
    allowNull: true,
    defaultValue: null,
    comment: '物料名称'
  },
  mode: {
    type: DataTypes.STRING(100),
    allowNull: true,
    defaultValue: null,
    comment: '规格型号'
  },
  quantity: {
    type: DataTypes.INTEGER(20),
    allowNull: true,
    defaultValue: null,
    comment: '数量'
  },
  operate: {
    type: DataTypes.INTEGER(1),
    allowNull: true,
    defaultValue: null,
    comment: '1:入库 2:出库'
  },
  type: {
    type: DataTypes.INTEGER(2),
    allowNull: true,
    defaultValue: null,
    comment: '出入库类型(常量)'
  },
  status: {
    type: DataTypes.INTEGER(1),
    allowNull: true,
    defaultValue: 0,
    comment: '0:待审核 1:已通过 2:已拒绝'
  },
  apply_id: {
    type: DataTypes.INTEGER(11),
    allowNull: true,
    defaultValue: null,
    comment: '申请人ID'
  },
  apply_time: {
    type: DataTypes.DATE,
    allowNull: true,
    defaultValue: DataTypes.NOW,
    comment: '申请时间'
  },
  approve_id: {
    type: DataTypes.INTEGER(11),
    allowNull: true,
    defaultValue: null,
    comment: '审核人ID'
  },
  approve_time: {
    type: DataTypes.DATE,
    allowNull: true,
    defaultValue: null,
    comment: '审核时间'
  },
  is_deleted: {
    type: DataTypes.INTEGER(1),
    allowNull: true,
    defaultValue: 1,
    comment: '是否删除：1-未删除，0-已删除'
  }
}, {
  sequelize,
  modelName: 'sub_warehouse_apply',
  tableName: 'sub_warehouse_apply',
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: 'updated_at',
  comment: '出库入库申请表'
})

module.exports = SubWarehouseApply;