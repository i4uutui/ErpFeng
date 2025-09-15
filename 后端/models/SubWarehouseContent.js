const { DataTypes } = require('sequelize');
const sequelize = require('../config/sequelize');

const SubWarehouseContent = sequelize.define('SubWarehouseContent', {
  id: {
    type: DataTypes.INTEGER(11),
    primaryKey: true,
    autoIncrement: true,
    comment: '自增ID'
  },
  company_id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    comment: '企业id'
  },
  user_id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    comment: '发布的用户id'
  },
  ware_id: {
    type: DataTypes.INTEGER(11),
    allowNull: true,
    comment: '仓库类型ID'
  },
  house_id: {
    type: DataTypes.INTEGER(11),
    allowNull: true,
    comment: '仓库ID'
  },
  item_id: {
    type: DataTypes.INTEGER(11),
    allowNull: true,
    comment: '物料ID'
  },
  code: {
    type: DataTypes.STRING(20),
    allowNull: true,
    comment: '物料编码'
  },
  name: {
    type: DataTypes.STRING(50),
    allowNull: true,
    comment: '物料名称'
  },
  mode: {
    type: DataTypes.STRING(100),
    allowNull: true,
    comment: '规格型号'
  },
  other_features: {
    type: DataTypes.STRING(100),
    allowNull: true,
    comment: '其他特性'
  },
  unit: {
    type: DataTypes.STRING(20),
    allowNull: true,
    comment: '采购单位'
  },
  inv_unit: {
    type: DataTypes.STRING(20),
    allowNull: true,
    comment: '库存单位'
  },
  initial: {
    type: DataTypes.INTEGER(20),
    allowNull: true,
    comment: '期初数量'
  },
  number_in: {
    type: DataTypes.INTEGER(20),
    allowNull: true,
    comment: '入库数量'
  },
  number_out: {
    type: DataTypes.INTEGER(20),
    allowNull: true,
    comment: '出库数量'
  },
  number_new: {
    type: DataTypes.INTEGER(20),
    allowNull: true,
    comment: '最新库存'
  },
  price: {
    type: DataTypes.DECIMAL(10, 1),
    allowNull: true,
    comment: '内部单价'
  },
  price_total: {
    type: DataTypes.DECIMAL(20, 1),
    allowNull: true,
    comment: '存货金额'
  },
  price_in: {
    type: DataTypes.DECIMAL(20, 1),
    allowNull: true,
    comment: '入库金额'
  },
  price_out: {
    type: DataTypes.DECIMAL(10, 1),
    allowNull: true,
    comment: '出库金额'
  },
  last_in_time: {
    type: DataTypes.DATE,
    allowNull: true,
    comment: '最后入库时间'
  },
  last_out_time: {
    type: DataTypes.DATE,
    allowNull: true,
    comment: '最后出库时间'
  },
  is_deleted: {
    type: DataTypes.INTEGER(1).UNSIGNED.ZEROFILL,
    allowNull: true,
    defaultValue: 1,
    comment: '1：未删除；0：已删除'
  }
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