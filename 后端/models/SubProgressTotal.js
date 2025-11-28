const { DataTypes } = require('sequelize');
const sequelize = require('../config/sequelize');

const SubProgressTotal = sequelize.define('SubProgressTotal', {
  id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    primaryKey: true,
    autoIncrement: true,
    comment: ' 自增主键 ID'
  },
  company_id: {
    type: DataTypes.INTEGER(11),
    allowNull: true,
    defaultValue: null,
    comment: '企业ID'
  },
  number: {
    type: DataTypes.INTEGER(11),
    allowNull: true,
    comment: '数量'
  },
}, {
  sequelize,
  modelName: 'sub_progress_total',
  tableName: 'sub_progress_total',
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: 'updated_at',
  comment: '用来统计进度表首页的延期预警'
})

module.exports = SubProgressTotal;