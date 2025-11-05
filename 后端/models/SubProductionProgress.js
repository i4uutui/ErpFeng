const { DataTypes } = require('sequelize');
const sequelize = require('../config/sequelize');

const SubProductionProgress = sequelize.define('SubProductionProgress', {
  id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    primaryKey: true,
    autoIncrement: true,
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
    comment: '发布的用户id'
  },
  notice_id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    comment: '生产通知单id'
  },
  product_id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    comment: '产品编码id'
  },
  sale_id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    comment: '销售id'
  },
  out_number: {
    type: DataTypes.INTEGER(20),
    allowNull: true,
    comment: '委外/库存数量'
  },
  part_id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    comment: '部件编码id'
  },
  bom_id: {
    type: DataTypes.INTEGER(11),
    allowNull: false,
    comment: 'Bom表的id'
  },
  start_date: {
    type: DataTypes.STRING(20),
    allowNull: true,
    comment: ' 预计起始生产时间 '
  },
  house_number: {
    type: DataTypes.INTEGER(11),
    allowNull: true,
    comment: '生产数量'
  },
  remarks: {
    type: DataTypes.TEXT,
    allowNull: true,
    comment: ' 生产特别要求 '
  },
  is_finish: {
    type: DataTypes.INTEGER(1),
    allowNull: true,
    defaultValue: 1,
    comment: ' 生产订单是否已完结：1 - 未完结，0 - 已完结 '
  },
  is_deleted: {
    type: DataTypes.INTEGER(1),
    allowNull: true,
    defaultValue: 1,
    comment: '1：未删除；0：已删除',
  }
}, {
  sequelize,
  modelName: 'sub_production_progress',
  tableName: 'sub_production_progress',
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: 'updated_at',
  comment: '生产进度表基础数据表'
})

module.exports = SubProductionProgress




// const { DataTypes } = require('sequelize');
// const sequelize = require('../config/sequelize');

// const SubProductionProgress = sequelize.define('SubProductionProgress', {
//   id: {
//     type: DataTypes.INTEGER(11),
//     allowNull: false,
//     primaryKey: true,
//     autoIncrement: true,
//     comment: '自增主键ID'
//   },
//   company_id: {
//     type: DataTypes.INTEGER(11),
//     allowNull: false,
//     comment: '企业id'
//   },
//   user_id: {
//     type: DataTypes.INTEGER(11),
//     allowNull: false,
//     comment: '发布的用户id'
//   },
//   notice_number: {
//     type: DataTypes.STRING(50),
//     allowNull: false,
//     comment: '生产通知单'
//   },
//   delivery_time: {
//     type: DataTypes.STRING(20),
//     allowNull: false,
//     comment: '客户交期'
//   },
//   customer_abbreviation: {
//     type: DataTypes.STRING(100),
//     allowNull: false,
//     comment: '客户id'
//   },
//   product_id: {
//     type: DataTypes.INTEGER(11),
//     allowNull: false,
//     comment: '产品编码id'
//   },
//   product_code: {
//     type: DataTypes.STRING(50),
//     allowNull: false,
//     comment: '产品编码'
//   },
//   product_name: {
//     type: DataTypes.STRING(50),
//     allowNull: false,
//     comment: '产品名称'
//   },
//   product_drawing: {
//     type: DataTypes.STRING(50),
//     allowNull: false,
//     comment: '产品图号'
//   },
//   part_id: {
//     type: DataTypes.INTEGER(11),
//     allowNull: false,
//     comment: '部件编码id'
//   },
//   part_code: {
//     type: DataTypes.STRING(50),
//     allowNull: false,
//     comment: '部件编码'
//   },
//   part_name: {
//     type: DataTypes.STRING(50),
//     allowNull: false,
//     comment: '部件名称'
//   },
//   bom_id: {
//     type: DataTypes.INTEGER(11),
//     allowNull: false,
//     comment: 'Bom表的id'
//   },
//   order_number: {
//     type: DataTypes.INTEGER(20),
//     allowNull: true,
//     comment: '生产数量'
//   },
//   customer_order: {
//     type: DataTypes.STRING(50),
//     allowNull: true,
//     comment: '客户订单号'
//   },
//   rece_time: {
//     type: DataTypes.STRING(20),
//     allowNull: true,
//     comment: '接单日期'
//   },
//   out_number: {
//     type: DataTypes.INTEGER(20),
//     allowNull: true,
//     comment: '委外/库存数量'
//   },
//   start_date: {
//     type: DataTypes.STRING(20),
//     allowNull: true,
//     comment: ' 预计起始生产时间 '
//   },
//   remarks: {
//     type: DataTypes.TEXT,
//     allowNull: true,
//     comment: ' 生产特别要求 '
//   },
//   is_deleted: {
//     type: DataTypes.INTEGER(1),
//     allowNull: true,
//     defaultValue: 1,
//     comment: '1：未删除；0：已删除',
//   }
// }, {
//   sequelize,
//   modelName: 'sub_production_progress',
//   tableName: 'sub_production_progress',
//   timestamps: true,
//   createdAt: 'created_at',
//   updatedAt: 'updated_at',
//   comment: '生产进度表'
// })

// module.exports = SubProductionProgress