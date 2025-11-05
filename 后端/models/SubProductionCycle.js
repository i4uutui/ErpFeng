const { DataTypes } = require('sequelize');
const sequelize = require('../config/sequelize');

const SubProductionCycle = sequelize.define('SubProductionCycle', {
  id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    primaryKey: true,
    autoIncrement: true,
    comment: ' 自增主键 ID'
  },
  cycle_id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    comment: ' 生产制程ID'
  },
  progress_id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    comment: ' 进度表ID'
  },
  end_date: {
    type: DataTypes.STRING(20),
    allowNull: false,
    comment: ' 预排交期 '
  },
  load: {
    type: DataTypes.STRING(20),
    allowNull: false,
    comment: ' 制程日总负荷 '
  },
  order_number: {
    type: DataTypes.INTEGER(20),
    allowNull: false,
    comment: ' 完成数量 '
  }
}, {
  sequelize,
  modelName: 'sub_production_cycle',
  tableName: 'sub_production_cycle',
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: 'updated_at',
  comment: '制程的子表'
})

module.exports = SubProductionCycle;