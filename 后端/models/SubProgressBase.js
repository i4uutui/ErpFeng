const { DataTypes } = require('sequelize');
const sequelize = require('../config/sequelize');

const SubProgressBase = sequelize.define('SubProgressBase', {
  id: {
    type: DataTypes.INTEGER(11),
    primaryKey: true,
    autoIncrement: true,
    comment: '自增ID'
  },
  company_id: {
    type: DataTypes.INTEGER(11),
    allowNull: true,
    defaultValue: null,
    comment: '企业ID'
  },
  user_id: {
    type: DataTypes.INTEGER(11),
    allowNull: true,
    defaultValue: null,
    comment: '用户发布的ID'
  },
  notice_id: {
    type: DataTypes.INTEGER(11),
    allowNull: true,
    defaultValue: null,
    comment: '生产订单ID'
  },
  sale_id: {
    type: DataTypes.INTEGER(11),
    allowNull: true,
    defaultValue: null,
    comment: '销售订单ID'
  },
  product_id: {
    type: DataTypes.INTEGER(11),
    allowNull: true,
    defaultValue: null,
    comment: '产品id'
  },
  product_code: {
    type: DataTypes.STRING(50),
    allowNull: true,
    defaultValue: null,
    comment: '产品编码',
  },
  product_name: {
    type: DataTypes.STRING(50),
    allowNull: true,
    defaultValue: null,
    comment: '产品名称',
  },
  drawing: {
    type: DataTypes.STRING(50),
    allowNull: true,
    defaultValue: null,
    comment: '产品图号',
  },
  part_id: {
    type: DataTypes.INTEGER(11),
    allowNull: true,
    defaultValue: null,
    comment: '部件id'
  },
  part_code: {
    type: DataTypes.STRING(50),
    allowNull: true,
    defaultValue: null,
    comment: '部件编码',
  },
  part_name: {
    type: DataTypes.STRING(50),
    allowNull: true,
    defaultValue: null,
    comment: '部件名称',
  },
  bom_id: {
    type: DataTypes.INTEGER(11),
    allowNull: true,
    defaultValue: null,
    comment: 'bom表的id'
  },
  house_number: {
    type: DataTypes.INTEGER(11),
    allowNull: true,
    defaultValue: null,
    comment: '委外/库存数量'
  },
  out_number: {
    type: DataTypes.INTEGER(11),
    allowNull: true,
    defaultValue: null,
    comment: '生产数量'
  },
  start_date: {
    type: DataTypes.STRING(20),
    allowNull: true,
    defaultValue: null,
    comment: '预计起始生产时间',
  },
  remarks: {
    type: DataTypes.TEXT,
    allowNull: true,
    defaultValue: null,
    comment: '生产特别要求',
  },
  is_finish: {
    type: DataTypes.INTEGER(1),
    allowNull: true,
    defaultValue: 1,
    comment: '生产订单是否已完结：1 - 未完结，0 - 已完结'
  },
  is_deleted: {
    type: DataTypes.INTEGER(1),
    allowNull: true,
    defaultValue: 1,
    comment: '是否删除：1-未删除，0-已删除'
  },
}, {
  sequelize,
  modelName: 'sub_progress_base',
  tableName: 'sub_progress_base',
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: 'updated_at',
  comment: '进度表的基础数据表'
})

module.exports = SubProgressBase;