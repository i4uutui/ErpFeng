const { DataTypes } = require('sequelize');
const sequelize = require('../config/sequelize');

const SubProductionNotice = sequelize.define('SubProductionNotice', {
  id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    autoIncrement: true,
    primaryKey: true,
    comment: '自增主键ID'
  },
  company_id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    comment: '企业id'
  },
  notice_id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    comment: '员工id'
  },
  notice: {
    type: DataTypes.STRING(50),
    allowNull: false,
    comment: '生产通知单号'
  },
  customer_id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    comment: '客户id'
  },
  product_id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    comment: '产品id'
  },
  rece_time: {
    type: DataTypes.STRING(50),
    allowNull: false,
    comment: '接单日期'
  }
}, {
  sequelize,
  modelName: 'sub_production_notice',
  tableName: 'sub_production_notice',
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: 'updated_at',
  comment: '进度表列表'
})

module.exports = SubProductionNotice;