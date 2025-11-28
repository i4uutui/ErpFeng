const { DataTypes } = require('sequelize');
const sequelize = require('../config/sequelize');

const SubConstUser = sequelize.define('SubConstUser', {
  id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    primaryKey: true,
    autoIncrement: true,
    comment: '自增主键ID'
  },
  company_id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    comment: '企业id'
  },
  user_id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    comment: '发布的用户id'
  },
  type: {
    type: DataTypes.STRING(25),
    allowNull: false,
    comment: '类型编码'
  },
  name: {
    type: DataTypes.STRING(50),
    allowNull: false,
    comment: '类型名称'
  },
  status: {
    type: DataTypes.INTEGER(1),
    allowNull: false,
    comment: '是否开启：1开启，0关闭'
  },
}, {
  sequelize,
  modelName: 'sub_const_user',
  tableName: 'sub_const_user',
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: 'updated_at',
  comment: '用户设置的变量表'
})

module.exports = SubConstUser;