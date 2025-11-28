const { DataTypes } = require('sequelize');
const sequelize = require('../config/sequelize');

const SubWarehouseApply = sequelize.define('SubWarehouseApply', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    comment: '自增ID'
  },
  user_id: {
    type: DataTypes.INTEGER,
    allowNull: true,
    comment: '发布的用户id'
  },
  company_id: {
    type: DataTypes.INTEGER,
    allowNull: true,
    comment: '所属企业id'
  },
  print_id: {
    type: DataTypes.INTEGER(30),
    allowNull: true,
    comment: '打印的id'
  },
  procure_id: {
    type: DataTypes.INTEGER(30),
    allowNull: true,
    comment: '采购单号ID'
  },
  sale_id: {
    type: DataTypes.INTEGER(11),
    allowNull: true,
    comment: '销售订单ID'
  },
  ware_id: {
    type: DataTypes.INTEGER,
    allowNull: true,
    defaultValue: null,
    comment: '仓库类型ID'
  },
  house_id: {
    type: DataTypes.INTEGER,
    allowNull: true,
    defaultValue: null,
    comment: '仓库ID'
  },
  operate: {
    type: DataTypes.INTEGER(1),
    allowNull: true,
    defaultValue: null,
    comment: '1:入库 2:出库'
  },
  type: {
    type: DataTypes.INTEGER(2),
    allowNull: true,
    defaultValue: null,
    comment: '出入库类型(常量)'
  },
  house_name: {
    type: DataTypes.STRING(100),
    allowNull: true,
    defaultValue: null,
    comment: '仓库名称'
  },
  plan_id: {
    type: DataTypes.INTEGER,
    allowNull: true,
    defaultValue: null,
    comment: '供应商id or 制程id'
  },
  plan: {
    type: DataTypes.STRING(100),
    allowNull: true,
    defaultValue: null,
    comment: '供应商 or 制程'
  },
  notice_id: {
    type: DataTypes.INTEGER,
    allowNull: true,
    defaultValue: null,
    comment: '生产通知单id'
  },
  item_id: {
    type: DataTypes.INTEGER,
    allowNull: true,
    defaultValue: null,
    comment: '物料ID'
  },
  code: {
    type: DataTypes.STRING(20),
    allowNull: true,
    defaultValue: null,
    comment: '物料编码'
  },
  name: {
    type: DataTypes.STRING(50),
    allowNull: true,
    defaultValue: null,
    comment: '物料名称'
  },
  model_spec: {
    type: DataTypes.STRING(100),
    allowNull: true,
    defaultValue: null,
    comment: '规格型号'
  },
  other_features: {
    type: DataTypes.STRING(100),
    allowNull: true,
    defaultValue: null,
    comment: '其他特性'
  },
  quantity: {
    type: DataTypes.INTEGER(20),
    allowNull: true,
    defaultValue: null,
    comment: '数量'
  },
  buy_price: {
    type: DataTypes.DECIMAL(10, 1),
    allowNull: true,
    defaultValue: null,
    comment: '采购/销售单价'
  },
  price: {
    type: DataTypes.DECIMAL(10, 1),
    allowNull: true,
    defaultValue: null,
    comment: '内部单价'
  },
  total_price: {
    type: DataTypes.DECIMAL(10, 1),
    allowNull: true,
    defaultValue: null,
    comment: '总价'
  },
  order_id: {
    type: DataTypes.INTEGER(11),
    allowNull: true,
    defaultValue: 1,
    comment: '出入库单ID'
  },
  is_buying: {
    type: DataTypes.INTEGER(1),
    allowNull: true,
    defaultValue: 1,
    comment: '是否已生成出入库单：1未生成，0已生成'
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
    comment: '状态（0审批中/1通过/2拒绝）'
  },
  is_deleted: {
    type: DataTypes.INTEGER(1),
    allowNull: true,
    defaultValue: 1,
    comment: '1：未删除；0：已删除'
  },
}, {
  sequelize,
  modelName: 'sub_warehouse_apply',
  tableName: 'sub_warehouse_apply',
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: 'updated_at',
  comment: '出库入库申请表'
})

module.exports = SubWarehouseApply;