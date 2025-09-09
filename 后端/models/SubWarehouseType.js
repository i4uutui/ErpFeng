const { DataTypes } = require('sequelize');
const sequelize = require('../config/sequelize');

const SubWarehouseType = sequelize.define('SubWarehouseType', {
  id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    primaryKey: true,
    autoIncrement: true,
    comment: '自增主键ID'
  },
  name: {
    type: DataTypes.STRING(50),
    allowNull: false,
    comment: '仓库类型'
  },
}, {
  sequelize,
  modelName: 'sub_warehouse_type',
  tableName: 'sub_warehouse_type',
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: 'updated_at',
  comment: '仓库类型表'
})

module.exports = SubWarehouseType;