const { DataTypes } = require('sequelize');
const sequelize = require('../config/sequelize');

const SubWarehouseOrder = sequelize.define('SubWarehouseOrder', {
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
  ware_id: {
    type: DataTypes.INTEGER,
    allowNull: true,
    defaultValue: null,
    comment: '仓库类型ID'
  },
  house_id: {
    type: DataTypes.INTEGER,
    allowNull: true,
    defaultValue: null,
    comment: '仓库ID'
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
  modelName: 'sub_warehouse_order',
  tableName: 'sub_warehouse_order',
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: 'updated_at',
  comment: '仓库出入库单'
})

module.exports = SubWarehouseOrder;