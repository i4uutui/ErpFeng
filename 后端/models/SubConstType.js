const { DataTypes } = require('sequelize');
const sequelize = require('../config/sequelize');

const SubConstType = sequelize.define('SubConstType', {
  id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    primaryKey: true,
    autoIncrement: true,
    comment: '自增主键ID'
  },
  type: {
    type: DataTypes.STRING(20),
    allowNull: false,
    unique: true,
    comment: ' 常量类型 '
  },
  name: {
    type: DataTypes.STRING(50),
    allowNull: false,
    comment: '仓库类型'
  },
}, {
  sequelize,
  modelName: 'sub_const_type',
  tableName: 'sub_const_type',
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: 'updated_at',
  comment: '仓库类型表'
})

module.exports = SubConstType;