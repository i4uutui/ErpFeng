const { DataTypes } = require('sequelize');
const sequelize = require('../config/sequelize');

const SubRateWage = sequelize.define('SubRateWage', {
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
    comment: '员工id'
  },
  bom_child_id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    comment: '工艺bom子表ID'
  },
  product_id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    comment: '产品id'
  },
  part_id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    comment: '部件id'
  },
  process_id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    comment: '工艺id'
  },
  number: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    comment: '完成数量'
  },
}, {
  sequelize,
  modelName: 'sub_rate_wage',
  tableName: 'sub_rate_wage',
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: 'updated_at',
  comment: '员工计件工资表'
})

module.exports = SubRateWage;