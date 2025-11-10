const routes = [
  {
    path: '/',
    name: 'Layout',
    component: () => import('../views/layout.jsx'),
    redirect: '/home',
    children: [
      //首页
      {
        path: '/home',
        name: 'Home',
        component: () => import('../views/home.jsx'),
        meta: {
          title: '系统首页',
          parent: '首页',
          menu: true
        }
      },
      // 版本更新
      {
        path: '/version',
        name: 'Version',
        component: () => import('../views/version/index.jsx'),
        meta: {
          title: '版本更新',
          parent: '首页',
          menu: false
        }
      },
      // 系统管理
      {
        path: '/system/employee-info',
        name: 'EmployeeInfo',
        component: () => import('@/views/system/EmployeeInfo.jsx'),
        meta: {
          title: '员工信息',
          parent: '系统管理',
          menu: true,
          buttons: [
            { code: 'EmployeeInfo:add', label: '新增' },
            { code: 'EmployeeInfo:edit', label: '修改' },
            { code: 'EmployeeInfo:delete', label: '删除' },
          ]
        }
      },
      {
        path: '/system/user',
        name: 'UserManagement',
        component: () => import('@/views/System/UserManagement.jsx'),
        meta: {
          title: '用户管理',
          parent: '系统管理',
          menu: true,
          buttons: [
            { code: 'user:add', label: '新增' },
            { code: 'user:edit', label: '修改' },
            { code: 'user:delete', label: '删除' }
          ]
        }
      },
      {
        path: '/system/trajectory',
        name: 'Trajectory',
        component: () => import('@/views/System/Trajectory.jsx'),
        meta: {
          title: '用户轨迹',
          parent: '系统管理',
          menu: true,
        }
      },
      {
        path: '/system/approval-step',
        name: 'ApprovalStep',
        component: () => import('@/views/System/ApprovalStep.jsx'),
        meta: {
          title: '审核管理',
          parent: '系统管理',
          menu: true,
        }
      },
      // {
      //   path: '/system/organize',
      //   name: 'OrganizeManagement',
      //   component: () => import('@/views/System/OrganizeManagement.jsx'),
      //   meta: {
      //     title: '组织架构',
      //     parent: '系统管理',
      //     menu: true
      //   }
      // },
      {
        path: '/system/ProcessCycle',
        name: 'ProcessCycle',
        component: () => import('@/views/System/ProcessCycle.jsx'),
        meta: {
          title: '生产制程',
          parent: '系统管理',
          menu: true,
          buttons: [
            { code: 'ProcessCycle:add', label: '新增' },
            { code: 'ProcessCycle:edit', label: '修改' },
          ]
        }
      },
      {
        path: '/system/WarehouseType',
        name: 'WarehouseType',
        component: () => import('@/views/System/WarehouseType.jsx'),
        meta: {
          title: '仓库建立',
          parent: '系统管理',
          menu: true,
          buttons: [
            { code: 'Warehouse:add', label: '新增' },
            { code: 'Warehouse:edit', label: '修改' },
          ]
        }
      },
      // 基础资料
      {
        path: '/basic/product-code',
        name: 'ProductCode',
        component: () => import('@/views/Basic/ProductCode.jsx'),
        meta: {
          title: '产品编码',
          parent: '基础资料',
          menu: true,
          buttons: [
            { code: 'ProductCode:add', label: '新增' },
            { code: 'ProductCode:edit', label: '修改' },
            // { code: 'ProductCode:delete', label: '删除' },
          ]
        }
      },
      {
        path: '/basic/part-code',
        name: 'PartCode',
        component: () => import('@/views/Basic/PartCode.jsx'),
        meta: {
          title: '部位编码',
          parent: '基础资料',
          menu: true,
          buttons: [
            { code: 'PartCode:add', label: '新增' },
            { code: 'PartCode:edit', label: '修改' },
            // { code: 'PartCode:delete', label: '删除' },
          ]
        }
      },
      {
        path: '/basic/material-code',
        name: 'MaterialCode',
        component: () => import('@/views/Basic/MaterialCode.jsx'),
        meta: {
          title: '材料编码',
          parent: '基础资料',
          menu: true,
          buttons: [
            { code: 'MaterialCode:add', label: '新增' },
            { code: 'MaterialCode:edit', label: '修改' },
            // { code: 'MaterialCode:delete', label: '删除' },
          ]
        }
      },
      {
        path: '/basic/process-code',
        name: 'ProcessCode',
        component: () => import('@/views/Basic/ProcessCode.jsx'),
        meta: {
          title: '工艺编码',
          parent: '基础资料',
          menu: true,
          buttons: [
            { code: 'ProcessCode:add', label: '新增' },
            { code: 'ProcessCode:edit', label: '修改' },
            // { code: 'ProcessCode:delete', label: '删除' },
          ]
        }
      },
      {
        path: '/basic/equipment-code',
        name: 'EquipmentCode',
        component: () => import('@/views/Basic/EquipmentCode.jsx'),
        meta: {
          title: '设备编码',
          parent: '基础资料',
          menu: true,
          buttons: [
            { code: 'EquipmentCode:add', label: '新增' },
            { code: 'EquipmentCode:edit', label: '修改' },
            // { code: 'EquipmentCode:delete', label: '删除' },
          ]
        }
      },
      // 订单管理
      {
        path: '/order/customer-info',
        name: 'CustomerInfo',
        component: () => import('@/views/Order/CustomerInfo.jsx'),
        meta: {
          title: '客户资料',
          parent: '订单管理',
          menu: true,
          buttons: [
            { code: 'CustomerInfo:add', label: '新增' },
            { code: 'CustomerInfo:edit', label: '修改' },
            // { code: 'CustomerInfo:delete', label: '删除' },
          ]
        }
      },
      {
        path: '/order/sales-order',
        name: 'SalesOrder',
        component: () => import('@/views/Order/SalesOrder.jsx'),
        meta: {
          title: '销售订单',
          parent: '订单管理',
          menu: true,
          buttons: [
            { code: 'SalesOrder:add', label: '新增' },
            { code: 'SalesOrder:edit', label: '修改' },
            { code: 'SalesOrder:cancel', label: '取消订单' },
          ]
        }
      },
      {
        path: '/order/product-quote',
        name: 'ProductQuote',
        component: () => import('@/views/Order/ProductQuote.jsx'),
        meta: {
          title: '产品报价',
          parent: '订单管理',
          menu: true,
          buttons: [
            { code: 'ProductQuote:add', label: '新增' },
            { code: 'ProductQuote:edit', label: '修改' },
          ]
        }
      },
      {
        path: '/order/product-notice',
        name: 'ProductNotice',
        component: () => import('@/views/Order/ProductNotice.jsx'),
        meta: {
          title: '生产通知单',
          parent: '订单管理',
          menu: true,
          buttons: [
            { code: 'ProductNotice:add', label: '新增' },
            { code: 'ProductNotice:edit', label: '修改' },
            { code: 'ProductNotice:date', label: '排期' },
            { code: 'ProductNotice:finish', label: '订单完结' },
          ]
        }
      },
      {
        path: '/order/finish-notice',
        name: 'FinishNotice',
        component: () => import('@/views/Order/FinishNotice.jsx'),
        meta: {
          title: '结案订单',
          parent: '订单管理',
          menu: true,
        }
      },
      {
        path: '/product/material-bom',
        name: 'MaterialBOM',
        component: () => import('@/views/Product/MaterialBOM.jsx'),
        meta: {
          title: '材料BOM',
          parent: '产品工程',
          menu: true,
          buttons: [
            { code: 'MaterialBOM:add', label: '新增' },
            { code: 'MaterialBOM:edit', label: '修改' },
            { code: 'MaterialBOM:delete', label: '删除' },
            { code: 'MaterialBOM:archive', label: '存档' },
            { code: 'MaterialBOM:newPage', label: '材料BOM库' },
          ]
        }
      },
      {
        path: '/product/material-bom-archive',
        name: 'MaterialBOMArchive',
        component: () => import('@/views/Product/MaterialBOMArchive.jsx'),
        meta: {
          title: '材料BOM存档库',
          parent: '产品工程',
          menu: false,
          buttons: [
            { code: 'MaterialBOM:cope', label: '复制新增' },
          ]
        }
      },
      {
        path: '/product/process-bom',
        name: 'ProcessBOM',
        component: () => import('@/views/Product/ProcessBOM.jsx'),
        meta: {
          title: '工艺BOM',
          parent: '产品工程',
          menu: true,
          buttons: [
            { code: 'ProcessBOM:add', label: '新增' },
            { code: 'ProcessBOM:edit', label: '修改' },
            { code: 'ProcessBOM:delete', label: '删除' },
            { code: 'ProcessBOM:archive', label: '存档' },
            { code: 'ProcessBOM:newPage', label: '工艺BOM库' },
          ]
        }
      },
      {
        path: '/product/process-bom-archive',
        name: 'ProcessBOMArchive',
        component: () => import('@/views/Product/ProcessBOMArchive.jsx'),
        meta: {
          title: '工艺BOM存档库',
          parent: '产品工程',
          menu: false,
          buttons: [
            { code: 'ProcessBOM:cope', label: '复制新增' },
          ]
        }
      },
      // // 采购管理
      {
        path: '/purchase/supplier-info',
        name: 'SupplierInfo',
        component: () => import('@/views/Purchase/SupplierInfo.jsx'),
        meta: {
          title: '供应商资料',
          parent: '采购管理',
          menu: true,
          buttons: [
            { code: 'SupplierInfo:add', label: '新增' },
            { code: 'SupplierInfo:edit', label: '修改' },
          ]
        }
      },
      {
        path: '/purchase/material-quote',
        name: 'MaterialQuote',
        component: () => import('@/views/Purchase/MaterialQuote.jsx'),
        meta: {
          title: '原材料报价',
          parent: '采购管理',
          menu: true,
          buttons: [
            { code: 'MaterialQuote:add', label: '新增' },
            { code: 'MaterialQuote:archive', label: '存档' },
            { code: 'MaterialQuote:newPage', label: '材料报价库' },
          ]
        }
      },
      {
        path: '/purchase/material-quote-archive',
        name: 'MaterialQuoteArchive',
        component: () => import('@/views/Purchase/MaterialQuoteArchive.jsx'),
        meta: {
          title: '原材料报价存档库',
          parent: '采购管理',
          menu: false,
        }
      },
      {
        path: '/purchase/purchase-order',
        name: 'PurchaseOrder',
        component: () => import('@/views/Purchase/PurchaseOrder.jsx'),
        meta: {
          title: '采购单',
          parent: '采购管理',
          menu: true,
          buttons: [
            { code: 'PurchaseOrder:add', label: '新增' },
            { code: 'PurchaseOrder:edit', label: '修改' },
            { code: 'PurchaseOrder:set', label: '采购单提交' },
            { code: 'PurchaseOrder:print', label: '打印' },
          ]
        }
      },
      // // 委外管理
      {
        path: '/outsourcing/outsourcing-quote',
        name: 'OutsourcingQuote',
        component: () => import('@/views/Outsourcing/OutsourcingQuote.jsx'),
        meta: {
          title: '委外报价',
          parent: '委外管理',
          menu: true,
          buttons: [
            { code: 'OutsourcingQuote:add', label: '添加委外报价' },
            { code: 'OutsourcingQuote:edit', label: '修改' },
          ]
        }
      },
      {
        path: '/outsourcing/outsourcing-order',
        name: 'OutsourcingOrder',
        component: () => import('@/views/Outsourcing/OutsourcingOrder.jsx'),
        meta: {
          title: '委外加工单',
          parent: '委外管理',
          menu: true,
          buttons: [
            { code: 'OutsourcingOrder:add', label: '新增' },
            { code: 'OutsourcingOrder:edit', label: '修改' },
            { code: 'OutsourcingOrder:set', label: '采购单提交' },
            { code: 'OutsourcingOrder:print', label: '打印' },
          ]
        }
      },
      // 生产管理
      {
        path: '/production/production-progress',
        name: 'ProductionProgress',
        component: () => import('@/views/Production/ProductionProgress.jsx'),
        meta: {
          title: '生产进度表',
          parent: '生产管理',
          menu: true
        }
      },
      {
        path: '/production/work-order',
        name: 'WorkOrder',
        component: () => import('@/views/Production/WorkOrder.jsx'),
        meta: {
          title: '派(报)工单',
          parent: '生产管理',
          menu: true,
          buttons: [
            { code: 'WorkOrder:print', label: '打印' },
          ]
        }
      },
      // {
      //   path: '/production/report-order',
      //   name: 'ReportOrder',
      //   component: () => import('@/views/Production/ReportOrder.vue'),
      //   meta: {
      //     title: '报工单',
      //     parent: '生产管理',
      //     menu: true
      //   }
      // },
      // {
      //   path: '/production/production-material',
      //   name: 'ProductionMaterial',
      //   component: () => import('@/views/Production/ProductionMaterial.vue'),
      //   meta: {
      //     title: '生产领料',
      //     parent: '生产管理',
      //     menu: true
      //   }
      // },
      {
        path: '/warehouse/warehouse-rate',
        name: 'WarehouseRate',
        component: () => import('@/views/Warehouse/WarehouseRate.jsx'),
        meta: {
          title: '仓库进出存',
          parent: '仓库管理',
          menu: true,
          buttons: [
            { code: 'WarehouseRate:edit', label: '修改' },
          ]
        }
      },
      {
        path: '/warehouse/material-house',
        name: 'MaterialHouse',
        component: () => import('@/views/Warehouse/MaterialHouse.jsx'),
        meta: {
          title: '材料出入库',
          parent: '仓库管理',
          menu: true,
          buttons: [
            { code: 'MaterialHouse:addIn', label: '新增入库单' },
            { code: 'MaterialHouse:addOut', label: '新增出库单' },
            { code: 'MaterialHouse:edit', label: '修改' },
            { code: 'MaterialHouse:set', label: '出入库提交' },
            { code: 'MaterialHouse:print', label: '打印' },
          ]
        }
      },
      {
        path: '/warehouse/product-house',
        name: 'ProductHouse',
        component: () => import('@/views/Warehouse/ProductHouse.jsx'),
        meta: {
          title: '成品出入库',
          parent: '仓库管理',
          menu: true,
          buttons: [
            { code: 'ProductHouse:addIn', label: '新增入库单' },
            { code: 'ProductHouse:addOut', label: '新增出库单' },
            { code: 'ProductHouse:edit', label: '修改' },
            { code: 'ProductHouse:set', label: '出入库提交' },
            { code: 'ProductHouse:print', label: '打印' },
          ]
        }
      },
      {
        path: '/finance/employee-piece-rate',
        name: 'EmployeePieceRate',
        component: () => import('@/views/finance/EmployeePieceRate.jsx'),
        meta: {
          title: '员工计件工资',
          parent: '财务管理',
          menu: true
        }
      },
      {
        path: '/finance/accounts-receivable',
        name: 'AccountsReceivable',
        component: () => import('@/views/finance/AccountsReceivable.jsx'),
        meta: {
          title: '应收货款',
          parent: '财务管理',
          menu: true
        }
      },
      {
        path: '/finance/accounts-payable',
        name: 'AccountsPayable',
        component: () => import('@/views/finance/AccountsPayable.jsx'),
        meta: {
          title: '应付货款(材料)',
          parent: '财务管理',
          menu: true
        }
      },
      {
        path: '/finance/accounts-outsourcing',
        name: 'AccountsOutsourcing',
        component: () => import('@/views/finance/AccountsOutsourcing.jsx'),
        meta: {
          title: '应付货款(委外)',
          parent: '财务管理',
          menu: true
        }
      }
    ]
  }
];

export default routes;