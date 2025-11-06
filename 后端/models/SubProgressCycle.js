const { DataTypes } = require('sequelize');
const sequelize = require('../config/sequelize');

const SubProgressCycle = sequelize.define('SubProgressCycle', {
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
  notice_id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    comment: ' 生产通知单ID'
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
  modelName: 'sub_progress_cycle',
  tableName: 'sub_progress_cycle',
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: 'updated_at',
  comment: '进度表的制程子表'
})

module.exports = SubProgressCycle;