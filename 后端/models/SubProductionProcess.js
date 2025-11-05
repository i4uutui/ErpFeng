const { DataTypes } = require('sequelize');
const sequelize = require('../config/sequelize');

const SubProductionProcess = sequelize.define('SubProductionProcess', {
  id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    primaryKey: true,
    autoIncrement: true,
    comment: ' 自增主键 ID'
  },
  notice_id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    comment: ' 生产订单ID'
  },
  progress_id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    comment: ' 进度表ID'
  },
  parent_id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    comment: ' 工序ID '
  },
  all_work_time: {
    type: DataTypes.STRING(10),
    allowNull: false,
    comment: ' 全部工时(H) '
  },
  load: {
    type: DataTypes.STRING(10),
    allowNull: false,
    comment: ' 每日负荷 '
  },
  finish: {
    type: DataTypes.STRING(20),
    allowNull: false,
    comment: ' 累计完成 '
  },
  order_number: {
    type: DataTypes.STRING(20),
    allowNull: false,
    comment: ' 订单尾数 '
  }
}, {
  sequelize,
  modelName: 'sub_production_process',
  tableName: 'sub_production_process',
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: 'updated_at',
  comment: '工艺BOM表工序下进度表的子表'
})

module.exports = SubProductionProcess;