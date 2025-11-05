const { DataTypes } = require('sequelize');
const sequelize = require('../config/sequelize');

const SubSaleCancel = sequelize.define('SubSaleCancel', {
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
  sale_id: {
    type: DataTypes.INTEGER,
    allowNull: true,
    defaultValue: 1,
    comment: ' 销售ID '
  },
  notice_id: {
    type: DataTypes.INTEGER,
    allowNull: true,
    defaultValue: 1,
    comment: ' 生产订单ID '
  },
}, {
  sequelize,
  modelName: 'sub_sale_cancel',
  tableName: 'sub_sale_cancel',
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: 'updated_at',
  comment: '销售订单取消订单储存的数据'
})

module.exports = SubSaleCancel;