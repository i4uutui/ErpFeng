const { DataTypes } = require('sequelize');
const sequelize = require('../config/sequelize');

const SubMaterialMent = sequelize.define('SubMaterialMent', {
  id: {
    type: DataTypes.INTEGER(11),
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
  quote_id: {
    type: DataTypes.INTEGER(11),
    allowNull: true,
    comment: '报价单ID'
  },
  material_bom_id: {
    type: DataTypes.STRING(20),
    allowNull: true,
    defaultValue: null,
    comment: '材料BOM ID'
  },
  print_id: {
    type: DataTypes.INTEGER(30),
    allowNull: true,
    defaultValue: null,
    comment: '打印的id'
  },
  notice_id: {
    type: DataTypes.INTEGER(11),
    allowNull: true,
    defaultValue: null,
    comment: '生产订单ID'
  },
  notice: {
    type: DataTypes.STRING(50),
    allowNull: true,
    defaultValue: null,
    comment: '生产订单'
  },
  supplier_id: {
    type: DataTypes.INTEGER(11),
    allowNull: true,
    defaultValue: null,
    comment: '供应商ID'
  },
  supplier_code: {
    type: DataTypes.STRING(50),
    allowNull: true,
    defaultValue: null,
    comment: '供应商编码'
  },
  supplier_abbreviation: {
    type: DataTypes.STRING(50),
    allowNull: true,
    defaultValue: null,
    comment: '供应商名称'
  },
  product_id: {
    type: DataTypes.STRING(50),
    allowNull: true,
    defaultValue: null,
    comment: '产品Id'
  },
  product_code: {
    type: DataTypes.STRING(50),
    allowNull: true,
    defaultValue: null,
    comment: '产品编码'
  },
  product_name: {
    type: DataTypes.STRING(50),
    allowNull: true,
    defaultValue: null,
    comment: '产品名称'
  },
  material_id: {
    type: DataTypes.INTEGER(11),
    allowNull: true,
    defaultValue: null,
    comment: '材料ID'
  },
  material_code: {
    type: DataTypes.STRING(50),
    allowNull: true,
    defaultValue: null,
    comment: '材料编码'
  },
  material_name: {
    type: DataTypes.STRING(50),
    allowNull: true,
    defaultValue: null,
    comment: '材料名称'
  },
  model_spec: {
    type: DataTypes.STRING(50),
    allowNull: true,
    defaultValue: null,
    comment: '型号&规格'
  },
  other_features: {
    type: DataTypes.STRING(100),
    allowNull: true,
    defaultValue: null,
    comment: '其它特性'
  },
  unit: {
    type: DataTypes.STRING(20),
    allowNull: true,
    defaultValue: null,
    comment: '单位'
  },
  price: {
    type: DataTypes.STRING(10),
    allowNull: true,
    defaultValue: null,
    comment: '单价'
  },
  order_number: {
    type: DataTypes.STRING(20),
    allowNull: true,
    defaultValue: null,
    comment: '预计数量'
  },
  number: {
    type: DataTypes.STRING(20),
    allowNull: true,
    defaultValue: null,
    comment: '实际数量'
  },
  delivery_time: {
    type: DataTypes.STRING(50),
    allowNull: true,
    defaultValue: null,
    comment: '交货时间'
  },
  apply_id: {
    type: DataTypes.INTEGER(11),
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
    type: DataTypes.DATE, // timestamp对应DATE类型
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
    type: DataTypes.INTEGER(11),
    allowNull: true,
    defaultValue: 0,
    comment: '状态（0审批中/1通过/2拒绝）'
  },
  is_deleted: {
    type: DataTypes.INTEGER(1),
    allowNull: true,
    defaultValue: 1,
    comment: '是否删除：1-未删除，0-已删除'
  }
}, {
  sequelize,
  modelName: 'sub_material_ment',
  tableName: 'sub_material_ment',
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: 'updated_at',
  comment: '材料编码基础信息表'
});

module.exports = SubMaterialMent;