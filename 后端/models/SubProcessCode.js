const { DataTypes } = require('sequelize');
const sequelize = require('../config/sequelize');

const SubProcessCode = sequelize.define('SubProcessCode', {
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
  user_id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    comment: '发布的用户id'
  },
  equipment_id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    comment: '设备编码id'
  },
  process_code: {
    type: DataTypes.STRING(50),
    allowNull: false,
    comment: '工艺编码'
  },
  process_name: {
    type: DataTypes.STRING(100),
    allowNull: false,
    comment: '工艺名称'
  },
  remarks: {
    type: DataTypes.TEXT,
    allowNull: true,
    comment: '备注'
  },
  is_deleted: {
    type: DataTypes.INTEGER(1),
    allowNull: true,
    defaultValue: 1,
    comment: '1：未删除；0：已删除'
  },
}, {
  sequelize,
  modelName: 'sub_process_code',
  tableName: 'sub_process_code',
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: 'updated_at',
  comment: '工艺编码基础信息表'
})

module.exports = SubProcessCode;