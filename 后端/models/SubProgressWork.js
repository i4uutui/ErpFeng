const { DataTypes } = require('sequelize');
const sequelize = require('../config/sequelize');

const SubProgressWork = sequelize.define('SubProgressWork', {
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
  progress_id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    comment: ' 进度表ID'
  },
  notice_id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    comment: ' 生产订单ID'
  },
  bom_id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    comment: ' BOM表ID'
  },
  child_id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    comment: ' BOM表工序ID '
  },
  process_index: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    comment: ' BOM表工序排序号 '
  },
  all_work_time: {
    type: DataTypes.STRING(20),
    allowNull: false,
    comment: ' 全部工时(H) '
  },
  load: {
    type: DataTypes.STRING(20),
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
  modelName: 'sub_progress_work',
  tableName: 'sub_progress_work',
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: 'updated_at',
  comment: '进度表工序子表'
})

module.exports = SubProgressWork;