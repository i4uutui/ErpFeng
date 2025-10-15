const { DataTypes } = require('sequelize');
const sequelize = require('../config/sequelize');

const SubDateInfo = sequelize.define('SubDateInfo', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    allowNull: false
  },
  company_id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    comment: '所属企业id'
  },
  date: {
    type: DataTypes.STRING(20),
    allowNull: false,
    unique: true,
    comment: ' 日期 '
  }
}, {
  sequelize,
  modelName: 'sub_date_info',
  tableName: 'sub_date_info',
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: 'updated_at',
  comment: '日历记录的表'
})

module.exports = SubDateInfo