const { DataTypes } = require('sequelize');
const sequelize = require('../config/sequelize');

const SubWarehouseContent = sequelize.define('SubWarehouseContent', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    comment: '自增ID'
  },
  user_id: {
    type: DataTypes.INTEGER,
    allowNull: false,
    comment: '发布的用户id'
  },
  company_id: {
    type: DataTypes.INTEGER,
    allowNull: false,
    comment: '所属企业id'
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
  buy_price: {
    type: DataTypes.DECIMAL(10, 1),
    allowNull: true,
    defaultValue: null,
    comment: '采购/销售单价'
  },
  price: {
    type: DataTypes.DECIMAL(10, 1),
    allowNull: false,
    defaultValue: 0.0,
    comment: '内部单价'
  },
  quantity: {
    type: DataTypes.INTEGER,
    allowNull: false,
    defaultValue: 0,
    comment: '最新库存'
  },
  unit: {
    type: DataTypes.STRING(20),
    allowNull: true,
    defaultValue: null,
    comment: '采购/销售单位'
  },
  inv_unit: {
    type: DataTypes.STRING(20),
    allowNull: true,
    defaultValue: null,
    comment: '库存单位'
  },
  last_in_time: {
    type: DataTypes.DATE,
    allowNull: true,
    defaultValue: null,
    comment: '最后入库时间'
  },
  last_out_time: {
    type: DataTypes.DATE,
    allowNull: true,
    defaultValue: null,
    comment: '最后出库时间'
  },
  is_deleted: {
    type: DataTypes.INTEGER,
    allowNull: false,
    defaultValue: 1,
    comment: '1：未删除；0：已删除'
  },
}, {
  sequelize,
  modelName: 'sub_warehouse_content',
  tableName: 'sub_warehouse_content',
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: 'updated_at',
  comment: '仓库列表数据表'
})

module.exports = SubWarehouseContent;