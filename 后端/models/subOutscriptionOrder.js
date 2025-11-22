const { DataTypes } = require('sequelize');
const sequelize = require('../config/sequelize');

const subOutscriptionOrder = sequelize.define('subOutscriptionOrder', {
  id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    primaryKey: true,
    autoIncrement: true,
    comment: '自增主键ID'
  },
  company_id: {
    type: DataTypes.INTEGER(11),
    allowNull: true,
    comment: '企业id'
  },
  user_id: {
    type: DataTypes.INTEGER(11),
    allowNull: true,
    comment: '发布的用户id'
  },
  print_id: {
    type: DataTypes.INTEGER(30),
    allowNull: true,
    comment: '打印的id'
  },
  notice_id: {
    type: DataTypes.INTEGER(10),
    allowNull: false,
    comment: ' 生产通知单ID'
  },
  quote_id: {
    type: DataTypes.STRING(20),
    allowNull: true,
    comment: ' 委外报价ID '
  },
  supplier_id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    comment: ' 供应商 ID'
  },
  process_bom_id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    comment: ' 工艺BOM ID '
  },
  process_bom_children_id: {
    type: DataTypes.INTEGER(5),
    allowNull: false,
    comment: ' 工艺BOM副表的id '
  },
  unit: {
    type: DataTypes.STRING(20),
    allowNull: true,
    comment: ' 单位 '
  },
  price: {
    type: DataTypes.STRING(50),
    allowNull: true,
    defaultValue: null,
    comment: ' 加工单价 '
  },
  number: {
    type: DataTypes.STRING(50),
    allowNull: true,
    defaultValue: null,
    comment: ' 委外数量 '
  },
  transaction_currency: {
    type: DataTypes.STRING(10),
    allowNull: true,
    comment: ' 交易币别 '
  },
  transaction_terms: {
    type: DataTypes.TEXT,
    allowNull: true,
    comment: ' 交易条件 '
  },
  ment: {
    type: DataTypes.STRING(255),
    allowNull: true,
    comment: ' 加工要求 '
  },
  delivery_time: {
    type: DataTypes.STRING(50),
    allowNull: true,
    comment: ' 要求交期 '
  },
  remarks: {
    type: DataTypes.TEXT,
    allowNull: true,
    comment: ' 备注 '
  },
  apply_id: {
    type: DataTypes.INTEGER,
    allowNull: true,
    defaultValue: null,
    comment: '申请人ID'
  },
  apply_name: {
    type: DataTypes.STRING(50),
    allowNull: true,
    defaultValue: null,
    comment: '申请人名称'
  },
  apply_time: {
    type: DataTypes.DATE,
    allowNull: true,
    defaultValue: null,
    comment: '申请时间'
  },
  step: {
    type: DataTypes.INTEGER(2),
    allowNull: true,
    defaultValue: 0,
    comment: '审核当前在第几步，默认0，每审核一步加1'
  },
  status: {
    type: DataTypes.INTEGER(1),
    allowNull: true,
    defaultValue: 0,
    comment: '状态（0审批中/1通过/2拒绝/3反审核）'
  },
  is_buying: {
    type: DataTypes.INTEGER(1),
    allowNull: true,
    defaultValue: 1,
    comment: '是否已生成委外加工单：1未生成，0已生成'
  },
  order_id: {
    type: DataTypes.INTEGER(11),
    allowNull: true,
    defaultValue: 1,
    comment: '委外加工单ID'
  },
  is_deleted: {
    type: DataTypes.INTEGER(1),
    allowNull: true,
    defaultValue: 1,
    comment: ' 是否删除：1 - 未删除，0 - 已删除 '
  },
}, {
  sequelize,
  modelName: 'sub_outscription_order',
  tableName: 'sub_outscription_order',
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: 'updated_at',
  comment: '委外加工单'
})

module.exports = subOutscriptionOrder;