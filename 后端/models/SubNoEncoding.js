const { DataTypes } = require('sequelize');
const sequelize = require('../config/sequelize');

const SubNoEncoding = sequelize.define("SubNoEncoding", {
  id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    primaryKey: true,
    autoIncrement: true
  },
  company_id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    comment: ' 所属企业 id'
  },
  no: {
    type: DataTypes.STRING(30),
    allowNull: false,
    comment: ' 编号 '
  },
  print_type: {
    type: DataTypes.STRING(5),
    allowNull: false,
    comment: ' 业务类型 '
  },
}, {
  sequelize,
  modelName: 'sub_no_encoding',
  tableName: 'sub_no_encoding',
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: 'updated_at',
  comment: '子后台用户表'
})

module.exports = SubNoEncoding