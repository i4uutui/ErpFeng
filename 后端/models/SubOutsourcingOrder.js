const { DataTypes } = require('sequelize');
const sequelize = require('../config/sequelize');

const SubOutsourcingOrder = sequelize.define('SubOutsourcingOrder', {
  id: {
    type: DataTypes.INTEGER,
    allowNull: false,
    primaryKey: true,
    autoIncrement: true,
    comment: ' 自增主键 ID'
  },
  company_id: {
    type: DataTypes.INTEGER,
    allowNull: true,
    comment: ' 企业 id'
  },
  user_id: {
    type: DataTypes.INTEGER,
    allowNull: true,
    comment: ' 发布的用户 id'
  },
  notice_id: {
    type: DataTypes.INTEGER,
    allowNull: true,
    comment: ' 生产订单ID'
  },
  notice: {
    type: DataTypes.STRING(20),
    allowNull: true,
    comment: ' 生产订单号'
  },
  supplier_id: {
    type: DataTypes.INTEGER,
    allowNull: true,
    comment: ' 供应商ID'
  },
  supplier_code: {
    type: DataTypes.STRING(20),
    allowNull: true,
    defaultValue: null,
    comment: '供应商编码'
  },
  supplier_abbreviation: {
    type: DataTypes.STRING(50),
    allowNull: true,
    defaultValue: null,
    comment: '供应商名称'
  },
  product_id: {
    type: DataTypes.INTEGER,
    allowNull: true,
    comment: ' 产品ID'
  },
  product_code: {
    type: DataTypes.STRING(20),
    allowNull: true,
    defaultValue: null,
    comment: '产品编码'
  },
  product_name: {
    type: DataTypes.STRING(50),
    allowNull: true,
    defaultValue: null,
    comment: '产品名称'
  },
  no: {
    type: DataTypes.STRING(50),
    allowNull: true,
    defaultValue: null,
    comment: '订单编号'
  },
  is_deleted: {
    type: DataTypes.INTEGER(1),
    allowNull: true,
    defaultValue: 1,
    comment: '是否删除：1-未删除，0-已删除'
  }
}, {
  sequelize,
  modelName: 'sub_outsourcing_order',
  tableName: 'sub_outsourcing_order',
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: 'updated_at',
  comment: '委外加工单'
})

module.exports = SubOutsourcingOrder;