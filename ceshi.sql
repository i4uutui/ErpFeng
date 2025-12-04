/*
 Navicat MySQL Data Transfer

 Source Server         : thinkphp_demo
 Source Server Type    : MySQL
 Source Server Version : 50722 (5.7.22)
 Source Host           : localhost:3306
 Source Schema         : ceshi

 Target Server Type    : MySQL
 Target Server Version : 50722 (5.7.22)
 File Encoding         : 65001

 Date: 04/12/2025 23:02:24
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for ad_admin
-- ----------------------------
DROP TABLE IF EXISTS `ad_admin`;
CREATE TABLE `ad_admin`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '用户名',
  `password` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '密码哈希',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ad_admin
-- ----------------------------
INSERT INTO `ad_admin` VALUES (1, 'admin', '$2b$10$K7.4Gl6jHarcam6M5hGmSefgqtPOQsxzhux/8o6hK3H38f1PrFjs2', '2025-07-07 11:14:53', '2025-07-07 11:14:53');

-- ----------------------------
-- Table structure for ad_company_info
-- ----------------------------
DROP TABLE IF EXISTS `ad_company_info`;
CREATE TABLE `ad_company_info`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键ID',
  `logo` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '企业logo',
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '公司名称',
  `person` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系人',
  `contact` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系方式',
  `address` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '公司地址',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '客户企业信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ad_company_info
-- ----------------------------
INSERT INTO `ad_company_info` VALUES (1, NULL, '东莞企业', '梁工', '13800138000', '东莞市寮步镇', '2025-07-07 11:54:18', '2025-07-07 11:55:10');
INSERT INTO `ad_company_info` VALUES (2, NULL, '东坑企业', '刘工1', '13800138000', '东坑镇', '2025-07-07 13:59:43', '2025-07-12 15:29:04');
INSERT INTO `ad_company_info` VALUES (3, '', '东莞元方企业管理咨询有限公司', '徐庆华', '18666885858', '东莞市石碣镇某某某XX号', '2025-10-16 00:02:56', '2025-10-16 00:02:56');

-- ----------------------------
-- Table structure for ad_organize
-- ----------------------------
DROP TABLE IF EXISTS `ad_organize`;
CREATE TABLE `ad_organize`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键ID',
  `company_id` int(11) NOT NULL COMMENT '企业id',
  `user_id` int(11) NOT NULL COMMENT '发布的用户id',
  `pid` int(11) NULL DEFAULT NULL COMMENT '上级ID，用于构建组织层级关系',
  `label` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '节点名称，如部门名称',
  `menber_id` int(11) NULL DEFAULT NULL COMMENT '关联的用户ID，关联员工信息表',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '组织架构信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ad_organize
-- ----------------------------
INSERT INTO `ad_organize` VALUES (1, 1, 1, 0, '企业名称11', 4, 1, '2025-08-01 14:55:42', '2025-08-01 17:12:20');
INSERT INTO `ad_organize` VALUES (2, 1, 1, 1, '业务部', 1, 0, '2025-08-01 14:56:50', '2025-08-01 17:11:17');
INSERT INTO `ad_organize` VALUES (3, 1, 1, 0, '前端工程师', 4, 1, '2025-08-01 15:56:01', '2025-08-01 15:56:01');
INSERT INTO `ad_organize` VALUES (4, 1, 1, 1, '221', 5, 0, '2025-08-01 17:11:46', '2025-08-01 17:11:50');
INSERT INTO `ad_organize` VALUES (5, 1, 1, 1, '后端', 4, 1, '2025-09-26 16:02:14', '2025-09-26 16:02:14');
INSERT INTO `ad_organize` VALUES (6, 3, 6, 0, '行政部', 12, 1, '2025-10-28 13:51:48', '2025-10-28 13:51:48');

-- ----------------------------
-- Table structure for ad_user
-- ----------------------------
DROP TABLE IF EXISTS `ad_user`;
CREATE TABLE `ad_user`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL COMMENT '所属企业id',
  `username` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '用户名',
  `password` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '密码',
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '姓名',
  `cycle_id` int(11) NULL DEFAULT NULL COMMENT '制程ID',
  `power` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '权限字符串',
  `type` int(1) NULL DEFAULT NULL COMMENT '账号类型：1-子管理员账号，2-普通子账号',
  `parent_id` int(11) NOT NULL COMMENT '上级的id',
  `status` int(1) NULL DEFAULT 1 COMMENT '账户状态：1-正常，0-禁用',
  `purchase_v` int(2) NULL DEFAULT 1 COMMENT '采购单的版本号：1基础版，2bom表版',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ad_user
-- ----------------------------
INSERT INTO `ad_user` VALUES (1, 1, 'admin1', '$2b$10$qJOWecY5nOd6ICarLgePce3XPyVtXXrp1dkbB9ZQvtydVrKLz8uGG', '我是名字', NULL, NULL, 1, 0, 1, 1, 1, '2025-07-07 13:56:55', '2025-07-21 17:26:05');
INSERT INTO `ad_user` VALUES (2, 2, 'admin99', '$2b$10$Ukc2Byd6TFsl0u2p68J0leC7tVgwp4LDWr7s6YV0EWpc6xR3dZyMm', NULL, NULL, NULL, 1, 0, 1, 1, 1, '2025-07-07 14:00:05', '2025-07-08 14:21:48');
INSERT INTO `ad_user` VALUES (3, 1, '2121', '$2b$10$EpPaXdgc4ugWWT1Qi.DFSeRoz9XyBa3N7mKkNGuXEBvmy.pe8HEWq', NULL, NULL, NULL, 1, 0, 1, 1, 1, '2025-07-08 10:35:09', '2025-07-08 14:21:49');
INSERT INTO `ad_user` VALUES (4, 1, '121', '$2b$10$qJOWecY5nOd6ICarLgePce3XPyVtXXrp1dkbB9ZQvtydVrKLz8uGG', '2132', NULL, '[[\"基础资料\",\"ProductCode\"],[\"基础资料\",\"PartCode\"],[\"基础资料\",\"MaterialCode\"],[\"基础资料\",\"ProcessCode\"],[\"基础资料\",\"EquipmentCode\"],[\"基础资料\",\"EmployeeInfo\"],[\"订单管理\",\"CustomerInfo\"],[\"订单管理\",\"ProductQuote\"],[\"订单管理\",\"SalesOrder\"],[\"仓库管理\"],[\"仓库管理\",\"ProductHouse\"],[\"仓库管理\",\"MaterialHouse\"],[\"仓库管理\",\"WarehouseRate\"],[\"采购管理\"],[\"委外管理\"],[\"采购管理\",\"PurchaseOrder\"],[\"采购管理\",\"MaterialQuote\"],[\"采购管理\",\"SupplierInfo\"],[\"委外管理\",\"OutsourcingQuote\"],[\"委外管理\",\"OutsourcingOrder\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:add\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:print\"]]', 2, 1, 1, 1, 1, '2025-07-08 14:10:45', '2025-09-23 16:45:29');
INSERT INTO `ad_user` VALUES (5, 1, 'admin2', '$2b$10$qJOWecY5nOd6ICarLgePce3XPyVtXXrp1dkbB9ZQvtydVrKLz8uGG', '哈哈', NULL, '[[\"系统管理\"],[\"系统管理\",\"OrganizeManagement\"],[\"系统管理\",\"ProcessCycle\"],[\"系统管理\",\"ProcessCycle\",\"ProcessCycle:edit\"],[\"系统管理\",\"WarehouseType\"],[\"基础资料\"],[\"基础资料\",\"MaterialCode\"],[\"基础资料\",\"PartCode\"],[\"基础资料\",\"ProductCode\"],[\"基础资料\",\"ProductCode\",\"ProductCode:add\"],[\"基础资料\",\"ProductCode\",\"ProductCode:edit\"],[\"基础资料\",\"PartCode\",\"PartCode:edit\"],[\"基础资料\",\"PartCode\",\"PartCode:delete\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:edit\"],[\"基础资料\",\"ProcessCode\"],[\"基础资料\",\"EquipmentCode\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:edit\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:add\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:delete\"],[\"基础资料\",\"EmployeeInfo\",\"EmployeeInfo:delete\"],[\"基础资料\",\"EmployeeInfo\",\"EmployeeInfo:edit\"],[\"基础资料\",\"EmployeeInfo\"],[\"订单管理\"],[\"订单管理\",\"CustomerInfo\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:add\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:edit\"],[\"订单管理\",\"SalesOrder\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:edit\"],[\"订单管理\",\"ProductQuote\"],[\"订单管理\",\"ProductQuote\",\"ProductQuote:add\"],[\"订单管理\",\"ProductNotice\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:edit\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:add\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:date\"],[\"产品信息\"],[\"产品信息\",\"MaterialBOM\"],[\"产品信息\",\"MaterialBOM\",\"MaterialBOM:add\"],[\"产品信息\",\"MaterialBOM\",\"MaterialBOM:edit\"],[\"产品信息\",\"MaterialBOM\",\"MaterialBOM:archive\"],[\"产品信息\",\"MaterialBOM\",\"MaterialBOM:newPage\"],[\"产品信息\",\"MaterialBOMArchive\"],[\"产品信息\",\"ProcessBOM\"],[\"产品信息\",\"ProcessBOM\",\"ProcessBOM:archive\"],[\"产品信息\",\"ProcessBOM\",\"ProcessBOM:newPage\"],[\"产品信息\",\"ProcessBOMArchive\"],[\"委外管理\"],[\"委外管理\",\"OutsourcingOrder\"],[\"委外管理\",\"OutsourcingQuote\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:add\"],[\"仓库管理\"],[\"仓库管理\",\"ProductHouse\"],[\"仓库管理\",\"MaterialHouse\"],[\"仓库管理\",\"WarehouseRate\"],[\"采购管理\"],[\"采购管理\",\"SupplierInfo\"],[\"采购管理\",\"MaterialQuote\"],[\"采购管理\",\"PurchaseOrder\"],[\"首页\"],[\"首页\",\"Home\"]]', 2, 1, 1, 1, 1, '2025-07-08 14:20:13', '2025-10-14 14:41:54');
INSERT INTO `ad_user` VALUES (6, 3, 'xuqinghua', '$2b$10$MUd.2TTjcfV8u2o0DRY.5OPdroD0SgSZaLr/xKnpnXXB.VkcIz27C', '徐庆华', NULL, NULL, 1, 0, 1, 2, 1, '2025-10-16 00:03:16', '2025-12-03 20:24:08');
INSERT INTO `ad_user` VALUES (7, 3, 'xufurong', '$2b$10$6nBULA3lrE67GJgCSHHd8Of9H24WkaXNSGRPpvadq7ZTOBSuqCoWG', '徐芙蓉', NULL, '[[\"基础资料\"],[\"基础资料\",\"ProductCode\"],[\"基础资料\",\"ProductCode\",\"ProductCode:add\"],[\"基础资料\",\"ProductCode\",\"ProductCode:edit\"],[\"基础资料\",\"PartCode\"],[\"基础资料\",\"PartCode\",\"PartCode:add\"],[\"基础资料\",\"PartCode\",\"PartCode:edit\"],[\"基础资料\",\"MaterialCode\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:add\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:edit\"],[\"订单管理\"],[\"订单管理\",\"CustomerInfo\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:add\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:edit\"]]', 2, 6, 0, 1, 0, '2025-10-16 14:45:16', '2025-10-16 14:50:42');
INSERT INTO `ad_user` VALUES (8, 1, '1231', '$2b$10$SNysIqFfTVzbYdYilDmMwOt0zF0O5rkfXbZETcW/4.4Gc.8dIN.uK', '2121', NULL, '[[\"产品信息\"],[\"产品信息\",\"ProcessBOMArchive\"],[\"产品信息\",\"ProcessBOM\"],[\"产品信息\",\"MaterialBOMArchive\"],[\"产品信息\",\"MaterialBOM\"]]', 2, 1, 1, 1, 1, '2025-10-16 14:48:37', '2025-10-16 14:48:45');
INSERT INTO `ad_user` VALUES (9, 1, '312121', '$2b$10$d5SvhAYPngTVFoyT0RZzYOrgX.9QzeCxcddQ2wUMnsE6Kl14rRdHW', '21213131', NULL, '[[\"采购管理\"],[\"采购管理\",\"MaterialQuote\"],[\"采购管理\",\"PurchaseOrder\"]]', 2, 1, 0, 1, 1, '2025-10-16 14:48:59', '2025-10-21 12:45:08');
INSERT INTO `ad_user` VALUES (10, 3, 'liang', '$2b$10$zkLfaAwf0gbLrsGcXv.fjebNp4OllOlRfQkpsoP3X8eb1ci6H3HDW', '梁伟锋', NULL, '[[\"系统管理\"],[\"基础资料\"],[\"基础资料\",\"PartCode\"],[\"基础资料\",\"MaterialCode\"],[\"系统管理\",\"OrganizeManagement\"]]', 2, 6, 1, 1, 0, '2025-10-16 14:49:57', '2025-10-16 14:50:40');
INSERT INTO `ad_user` VALUES (11, 3, 'lupeisen', '$2b$10$AfLUeYHX4zV7k9IQRtFXr.mtSMVEfsEopPbPHWPFrpBn3ta4j4uVy', 'lupeisen', NULL, '[[\"系统管理\"],[\"系统管理\",\"OrganizeManagement\"],[\"系统管理\",\"ProcessCycle\"]]', 2, 6, 0, 1, 0, '2025-10-16 14:50:25', '2025-10-16 14:50:38');
INSERT INTO `ad_user` VALUES (12, 3, 'xuchudong', '$2b$10$bDucRLeOiNHFFXRtbW10lutWWBcXItwYf3jSzomDePYbjmBbWDXD6', '徐楚东', 12, '[[\"基础资料\",\"ProductCode\",\"ProductCode:add\"],[\"基础资料\",\"ProductCode\",\"ProductCode:edit\"],[\"系统管理\",\"ProcessCycle\",\"ProcessCycle:add\"],[\"系统管理\",\"ProcessCycle\",\"ProcessCycle:edit\"],[\"系统管理\",\"WarehouseType\",\"Warehouse:add\"],[\"系统管理\",\"WarehouseType\",\"Warehouse:edit\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:add\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:edit\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:add\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:edit\"],[\"订单管理\",\"ProductQuote\",\"ProductQuote:add\"],[\"订单管理\",\"ProductQuote\",\"ProductQuote:edit\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:add\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:edit\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:date\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:finish\"],[\"订单管理\",\"FinishNotice\"],[\"委外管理\",\"OutsourcingQuote\",\"OutsourcingQuote:add\"],[\"委外管理\",\"OutsourcingQuote\",\"OutsourcingQuote:edit\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:add\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:edit\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:set\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:print\"],[\"生产管理\",\"ProductionProgress\"],[\"生产管理\",\"WorkOrder\",\"WorkOrder:print\"],[\"仓库管理\",\"WarehouseRate\",\"WarehouseRate:edit\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:print\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:print\"],[\"财务管理\",\"AccountsReceivable\"],[\"财务管理\",\"AccountsPayable\"],[\"财务管理\",\"AccountsOutsourcing\"],[\"基础资料\",\"PartCode\",\"PartCode:add\"],[\"基础资料\",\"PartCode\",\"PartCode:edit\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:add\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:edit\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:add\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:edit\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:add\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:edit\"],[\"采购管理\",\"SupplierInfo\",\"SupplierInfo:add\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:add\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:edit\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:archive\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:newPage\"],[\"产品工程\",\"MaterialBOMArchive\",\"MaterialBOM:cope\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:add\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:edit\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:archive\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:newPage\"],[\"产品工程\",\"ProcessBOMArchive\",\"ProcessBOM:cope\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:delete\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:delete\"],[\"采购管理\",\"SupplierInfo\",\"SupplierInfo:edit\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:add\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:archive\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:newPage\"],[\"采购管理\",\"MaterialQuoteArchive\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:print\"],[\"系统管理\",\"EmployeeInfo\",\"EmployeeInfo:add\"],[\"系统管理\",\"EmployeeInfo\",\"EmployeeInfo:edit\"],[\"系统管理\",\"EmployeeInfo\",\"EmployeeInfo:delete\"],[\"系统管理\",\"UserManagement\"],[\"系统管理\",\"Trajectory\"],[\"系统管理\",\"ApprovalStep\",\"ApprovalStep:add\"],[\"系统管理\",\"ApprovalStep\",\"ApprovalStep:delete\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:cancel\"],[\"财务管理\",\"EmployeePieceRate\",\"pieceRate:confirm\"],[\"财务管理\",\"EmployeePieceRate\",\"pieceRate:edit\"],[\"采购管理\",\"ScriptionOrder\",\"ScriptionOrder:add\"],[\"采购管理\",\"ScriptionOrder\",\"ScriptionOrder:edit\"],[\"采购管理\",\"ScriptionOrder\",\"ScriptionOrder:set\"],[\"采购管理\",\"ScriptionOrder\",\"ScriptionOrder:buy\"],[\"委外管理\",\"OutscriptionOrder\",\"OutscriptionOrder:add\"],[\"委外管理\",\"OutscriptionOrder\",\"OutscriptionOrder:edit\"],[\"委外管理\",\"OutscriptionOrder\",\"OutscriptionOrder:set\"],[\"委外管理\",\"OutscriptionOrder\",\"OutscriptionOrder:buy\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:addIn\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:addOut\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:edit\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:set\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:buy\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:addIn\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:addOut\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:edit\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:set\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:buy\"]]', 2, 6, 1, 1, 1, '2025-10-16 14:55:08', '2025-11-24 10:31:06');
INSERT INTO `ad_user` VALUES (15, 3, 'suyun', '$2b$10$3giSn6u0TSPgXQTMQxOhjeBlyIByKkV9KTXVtQFFFw.gyQN9y/xyC', '粟云', 16, '[[\"系统管理\",\"ProcessCycle\",\"ProcessCycle:add\"],[\"系统管理\",\"ProcessCycle\",\"ProcessCycle:edit\"],[\"系统管理\",\"WarehouseType\",\"Warehouse:add\"],[\"系统管理\",\"WarehouseType\",\"Warehouse:edit\"],[\"基础资料\",\"ProductCode\",\"ProductCode:add\"],[\"基础资料\",\"ProductCode\",\"ProductCode:edit\"],[\"基础资料\",\"PartCode\",\"PartCode:add\"],[\"基础资料\",\"PartCode\",\"PartCode:edit\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:add\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:edit\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:add\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:edit\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:add\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:edit\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:add\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:edit\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:add\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:edit\"],[\"订单管理\",\"ProductQuote\",\"ProductQuote:add\"],[\"订单管理\",\"ProductQuote\",\"ProductQuote:edit\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:add\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:edit\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:date\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:finish\"],[\"订单管理\",\"FinishNotice\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:add\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:edit\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:delete\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:archive\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:newPage\"],[\"产品工程\",\"MaterialBOMArchive\",\"MaterialBOM:cope\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:add\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:edit\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:delete\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:archive\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:newPage\"],[\"产品工程\",\"ProcessBOMArchive\",\"ProcessBOM:cope\"],[\"采购管理\",\"SupplierInfo\",\"SupplierInfo:add\"],[\"采购管理\",\"SupplierInfo\",\"SupplierInfo:edit\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:add\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:archive\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:newPage\"],[\"采购管理\",\"MaterialQuoteArchive\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:print\"],[\"委外管理\",\"OutsourcingQuote\",\"OutsourcingQuote:add\"],[\"委外管理\",\"OutsourcingQuote\",\"OutsourcingQuote:edit\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:add\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:edit\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:set\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:print\"],[\"生产管理\",\"ProductionProgress\"],[\"生产管理\",\"WorkOrder\",\"WorkOrder:print\"],[\"仓库管理\",\"WarehouseRate\",\"WarehouseRate:edit\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:print\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:print\"],[\"财务管理\",\"AccountsReceivable\"],[\"财务管理\",\"AccountsPayable\"],[\"财务管理\",\"AccountsOutsourcing\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:cancel\"],[\"财务管理\",\"EmployeePieceRate\",\"pieceRate:confirm\"],[\"财务管理\",\"EmployeePieceRate\",\"pieceRate:edit\"],[\"系统管理\",\"EmployeeInfo\",\"EmployeeInfo:add\"],[\"系统管理\",\"EmployeeInfo\",\"EmployeeInfo:edit\"],[\"系统管理\",\"EmployeeInfo\",\"EmployeeInfo:delete\"],[\"系统管理\",\"UserManagement\"],[\"系统管理\",\"Trajectory\"],[\"系统管理\",\"ApprovalStep\",\"ApprovalStep:add\"],[\"系统管理\",\"ApprovalStep\",\"ApprovalStep:delete\"],[\"采购管理\",\"ScriptionOrder\",\"ScriptionOrder:add\"],[\"采购管理\",\"ScriptionOrder\",\"ScriptionOrder:edit\"],[\"采购管理\",\"ScriptionOrder\",\"ScriptionOrder:set\"],[\"采购管理\",\"ScriptionOrder\",\"ScriptionOrder:buy\"],[\"委外管理\",\"OutscriptionOrder\",\"OutscriptionOrder:add\"],[\"委外管理\",\"OutscriptionOrder\",\"OutscriptionOrder:edit\"],[\"委外管理\",\"OutscriptionOrder\",\"OutscriptionOrder:set\"],[\"委外管理\",\"OutscriptionOrder\",\"OutscriptionOrder:buy\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:addIn\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:addOut\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:edit\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:set\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:buy\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:addIn\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:addOut\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:edit\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:set\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:buy\"]]', 2, 6, 1, 1, 1, '2025-10-19 16:00:54', '2025-11-24 10:30:50');
INSERT INTO `ad_user` VALUES (16, 3, 'lengbing', '$2b$10$7ndhZpR5StJSxEy7Oe7ByOo7NpyWNr2n9SHgnvcdAEaJfPihG0hN2', '冷冰', 14, '[[\"系统管理\",\"ProcessCycle\",\"ProcessCycle:add\"],[\"系统管理\",\"ProcessCycle\",\"ProcessCycle:edit\"],[\"系统管理\",\"WarehouseType\",\"Warehouse:add\"],[\"系统管理\",\"WarehouseType\",\"Warehouse:edit\"],[\"基础资料\",\"ProductCode\",\"ProductCode:add\"],[\"基础资料\",\"ProductCode\",\"ProductCode:edit\"],[\"基础资料\",\"PartCode\",\"PartCode:add\"],[\"基础资料\",\"PartCode\",\"PartCode:edit\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:add\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:edit\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:add\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:edit\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:add\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:edit\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:add\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:edit\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:add\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:edit\"],[\"订单管理\",\"ProductQuote\",\"ProductQuote:add\"],[\"订单管理\",\"ProductQuote\",\"ProductQuote:edit\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:add\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:edit\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:date\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:finish\"],[\"订单管理\",\"FinishNotice\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:add\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:edit\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:delete\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:archive\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:newPage\"],[\"产品工程\",\"MaterialBOMArchive\",\"MaterialBOM:cope\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:add\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:edit\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:delete\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:archive\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:newPage\"],[\"产品工程\",\"ProcessBOMArchive\",\"ProcessBOM:cope\"],[\"采购管理\",\"SupplierInfo\",\"SupplierInfo:add\"],[\"采购管理\",\"SupplierInfo\",\"SupplierInfo:edit\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:add\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:archive\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:newPage\"],[\"采购管理\",\"MaterialQuoteArchive\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:print\"],[\"委外管理\",\"OutsourcingQuote\",\"OutsourcingQuote:add\"],[\"委外管理\",\"OutsourcingQuote\",\"OutsourcingQuote:edit\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:add\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:edit\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:set\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:print\"],[\"生产管理\",\"ProductionProgress\"],[\"生产管理\",\"WorkOrder\",\"WorkOrder:print\"],[\"仓库管理\",\"WarehouseRate\",\"WarehouseRate:edit\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:print\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:print\"],[\"财务管理\",\"AccountsReceivable\"],[\"财务管理\",\"AccountsPayable\"],[\"财务管理\",\"AccountsOutsourcing\"],[\"系统管理\",\"EmployeeInfo\",\"EmployeeInfo:add\"],[\"系统管理\",\"EmployeeInfo\",\"EmployeeInfo:edit\"],[\"系统管理\",\"EmployeeInfo\",\"EmployeeInfo:delete\"],[\"系统管理\",\"UserManagement\"],[\"系统管理\",\"Trajectory\"],[\"系统管理\",\"ApprovalStep\",\"ApprovalStep:add\"],[\"系统管理\",\"ApprovalStep\",\"ApprovalStep:delete\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:cancel\"],[\"财务管理\",\"EmployeePieceRate\",\"pieceRate:confirm\"],[\"财务管理\",\"EmployeePieceRate\",\"pieceRate:edit\"],[\"采购管理\",\"ScriptionOrder\",\"ScriptionOrder:add\"],[\"采购管理\",\"ScriptionOrder\",\"ScriptionOrder:edit\"],[\"采购管理\",\"ScriptionOrder\",\"ScriptionOrder:set\"],[\"采购管理\",\"ScriptionOrder\",\"ScriptionOrder:buy\"],[\"委外管理\",\"OutscriptionOrder\",\"OutscriptionOrder:add\"],[\"委外管理\",\"OutscriptionOrder\",\"OutscriptionOrder:edit\"],[\"委外管理\",\"OutscriptionOrder\",\"OutscriptionOrder:set\"],[\"委外管理\",\"OutscriptionOrder\",\"OutscriptionOrder:buy\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:addIn\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:addOut\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:edit\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:set\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:buy\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:addIn\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:addOut\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:edit\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:set\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:buy\"]]', 2, 6, 1, 1, 1, '2025-10-27 20:21:26', '2025-11-24 10:33:09');
INSERT INTO `ad_user` VALUES (17, 3, 'hexiongming', '$2b$10$aJ2gjfgqhWKFNhA7jv8rVef1AkKhUgd3mq.owmEVJ3WpU935Yklci', '何雄明', 13, '[[\"系统管理\",\"ProcessCycle\",\"ProcessCycle:add\"],[\"系统管理\",\"ProcessCycle\",\"ProcessCycle:edit\"],[\"系统管理\",\"WarehouseType\",\"Warehouse:add\"],[\"系统管理\",\"WarehouseType\",\"Warehouse:edit\"],[\"基础资料\",\"ProductCode\",\"ProductCode:add\"],[\"基础资料\",\"ProductCode\",\"ProductCode:edit\"],[\"基础资料\",\"PartCode\",\"PartCode:add\"],[\"基础资料\",\"PartCode\",\"PartCode:edit\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:add\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:edit\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:add\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:edit\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:add\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:edit\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:add\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:edit\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:add\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:edit\"],[\"订单管理\",\"ProductQuote\",\"ProductQuote:add\"],[\"订单管理\",\"ProductQuote\",\"ProductQuote:edit\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:add\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:edit\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:date\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:finish\"],[\"订单管理\",\"FinishNotice\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:add\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:edit\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:delete\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:archive\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:newPage\"],[\"产品工程\",\"MaterialBOMArchive\",\"MaterialBOM:cope\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:add\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:edit\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:delete\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:archive\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:newPage\"],[\"产品工程\",\"ProcessBOMArchive\",\"ProcessBOM:cope\"],[\"采购管理\",\"SupplierInfo\",\"SupplierInfo:add\"],[\"采购管理\",\"SupplierInfo\",\"SupplierInfo:edit\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:add\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:archive\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:newPage\"],[\"采购管理\",\"MaterialQuoteArchive\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:print\"],[\"委外管理\",\"OutsourcingQuote\",\"OutsourcingQuote:add\"],[\"委外管理\",\"OutsourcingQuote\",\"OutsourcingQuote:edit\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:add\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:edit\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:set\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:print\"],[\"生产管理\",\"ProductionProgress\"],[\"生产管理\",\"WorkOrder\",\"WorkOrder:print\"],[\"仓库管理\",\"WarehouseRate\",\"WarehouseRate:edit\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:print\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:print\"],[\"财务管理\",\"AccountsReceivable\"],[\"财务管理\",\"AccountsPayable\"],[\"财务管理\",\"AccountsOutsourcing\"],[\"系统管理\",\"EmployeeInfo\",\"EmployeeInfo:add\"],[\"系统管理\",\"EmployeeInfo\",\"EmployeeInfo:edit\"],[\"系统管理\",\"EmployeeInfo\",\"EmployeeInfo:delete\"],[\"系统管理\",\"UserManagement\"],[\"系统管理\",\"Trajectory\"],[\"系统管理\",\"ApprovalStep\",\"ApprovalStep:add\"],[\"系统管理\",\"ApprovalStep\",\"ApprovalStep:delete\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:cancel\"],[\"财务管理\",\"EmployeePieceRate\",\"pieceRate:confirm\"],[\"财务管理\",\"EmployeePieceRate\",\"pieceRate:edit\"],[\"采购管理\",\"ScriptionOrder\",\"ScriptionOrder:add\"],[\"采购管理\",\"ScriptionOrder\",\"ScriptionOrder:edit\"],[\"采购管理\",\"ScriptionOrder\",\"ScriptionOrder:set\"],[\"采购管理\",\"ScriptionOrder\",\"ScriptionOrder:buy\"],[\"委外管理\",\"OutscriptionOrder\",\"OutscriptionOrder:add\"],[\"委外管理\",\"OutscriptionOrder\",\"OutscriptionOrder:edit\"],[\"委外管理\",\"OutscriptionOrder\",\"OutscriptionOrder:set\"],[\"委外管理\",\"OutscriptionOrder\",\"OutscriptionOrder:buy\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:addIn\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:addOut\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:edit\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:set\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:buy\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:addIn\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:addOut\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:edit\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:set\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:buy\"]]', 2, 6, 1, 1, 1, '2025-10-27 20:22:48', '2025-11-24 10:31:18');
INSERT INTO `ad_user` VALUES (18, 3, 'liuzhuangzhen', '$2b$10$NvGQRP/WXXZdTXGH9ZKHJO3fz5BerSYTPXaNSirPxAmqTI0zJCk/m', '刘庄震', 15, '[[\"系统管理\",\"EmployeeInfo\",\"EmployeeInfo:add\"],[\"系统管理\",\"EmployeeInfo\",\"EmployeeInfo:edit\"],[\"系统管理\",\"EmployeeInfo\",\"EmployeeInfo:delete\"],[\"系统管理\",\"ProcessCycle\",\"ProcessCycle:add\"],[\"系统管理\",\"ProcessCycle\",\"ProcessCycle:edit\"],[\"系统管理\",\"WarehouseType\",\"Warehouse:add\"],[\"系统管理\",\"WarehouseType\",\"Warehouse:edit\"],[\"基础资料\",\"ProductCode\",\"ProductCode:add\"],[\"基础资料\",\"ProductCode\",\"ProductCode:edit\"],[\"基础资料\",\"PartCode\",\"PartCode:add\"],[\"基础资料\",\"PartCode\",\"PartCode:edit\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:add\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:edit\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:add\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:edit\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:add\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:edit\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:add\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:edit\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:add\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:edit\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:cancel\"],[\"订单管理\",\"ProductQuote\",\"ProductQuote:add\"],[\"订单管理\",\"ProductQuote\",\"ProductQuote:edit\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:add\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:edit\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:date\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:finish\"],[\"订单管理\",\"FinishNotice\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:add\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:edit\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:delete\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:archive\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:newPage\"],[\"产品工程\",\"MaterialBOMArchive\",\"MaterialBOM:cope\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:add\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:edit\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:delete\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:archive\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:newPage\"],[\"产品工程\",\"ProcessBOMArchive\",\"ProcessBOM:cope\"],[\"采购管理\",\"SupplierInfo\",\"SupplierInfo:add\"],[\"采购管理\",\"SupplierInfo\",\"SupplierInfo:edit\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:add\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:archive\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:newPage\"],[\"采购管理\",\"MaterialQuoteArchive\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:print\"],[\"委外管理\",\"OutsourcingQuote\",\"OutsourcingQuote:add\"],[\"委外管理\",\"OutsourcingQuote\",\"OutsourcingQuote:edit\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:add\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:edit\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:set\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:print\"],[\"生产管理\",\"ProductionProgress\"],[\"生产管理\",\"WorkOrder\",\"WorkOrder:print\"],[\"仓库管理\",\"WarehouseRate\",\"WarehouseRate:edit\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:print\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:print\"],[\"财务管理\",\"AccountsReceivable\"],[\"财务管理\",\"AccountsPayable\"],[\"财务管理\",\"AccountsOutsourcing\"],[\"系统管理\",\"UserManagement\"],[\"系统管理\",\"Trajectory\"],[\"系统管理\",\"ApprovalStep\",\"ApprovalStep:add\"],[\"系统管理\",\"ApprovalStep\",\"ApprovalStep:delete\"],[\"财务管理\",\"EmployeePieceRate\",\"pieceRate:confirm\"],[\"财务管理\",\"EmployeePieceRate\",\"pieceRate:edit\"],[\"采购管理\",\"ScriptionOrder\",\"ScriptionOrder:add\"],[\"采购管理\",\"ScriptionOrder\",\"ScriptionOrder:edit\"],[\"采购管理\",\"ScriptionOrder\",\"ScriptionOrder:set\"],[\"采购管理\",\"ScriptionOrder\",\"ScriptionOrder:buy\"],[\"委外管理\",\"OutscriptionOrder\",\"OutscriptionOrder:add\"],[\"委外管理\",\"OutscriptionOrder\",\"OutscriptionOrder:edit\"],[\"委外管理\",\"OutscriptionOrder\",\"OutscriptionOrder:set\"],[\"委外管理\",\"OutscriptionOrder\",\"OutscriptionOrder:buy\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:addIn\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:addOut\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:edit\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:set\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:buy\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:addIn\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:addOut\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:edit\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:set\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:buy\"]]', 2, 6, 1, 1, 1, '2025-11-11 02:05:06', '2025-11-24 10:31:33');
INSERT INTO `ad_user` VALUES (19, 3, 'lubinquan', '$2b$10$xmbsTITiq5snchyIAxfSN.r1haH4ofI9wPa3.R5n3Isp0pR.h.mYK', '陆斌权', 12, '[[\"系统管理\",\"EmployeeInfo\",\"EmployeeInfo:add\"],[\"系统管理\",\"EmployeeInfo\",\"EmployeeInfo:edit\"],[\"系统管理\",\"EmployeeInfo\",\"EmployeeInfo:delete\"],[\"系统管理\",\"ProcessCycle\",\"ProcessCycle:add\"],[\"系统管理\",\"ProcessCycle\",\"ProcessCycle:edit\"],[\"系统管理\",\"WarehouseType\",\"Warehouse:add\"],[\"系统管理\",\"WarehouseType\",\"Warehouse:edit\"],[\"基础资料\",\"ProductCode\",\"ProductCode:add\"],[\"基础资料\",\"ProductCode\",\"ProductCode:edit\"],[\"基础资料\",\"PartCode\",\"PartCode:add\"],[\"基础资料\",\"PartCode\",\"PartCode:edit\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:add\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:edit\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:add\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:edit\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:add\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:edit\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:add\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:edit\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:add\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:edit\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:cancel\"],[\"订单管理\",\"ProductQuote\",\"ProductQuote:add\"],[\"订单管理\",\"ProductQuote\",\"ProductQuote:edit\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:add\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:edit\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:date\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:finish\"],[\"订单管理\",\"FinishNotice\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:add\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:edit\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:delete\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:archive\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:newPage\"],[\"产品工程\",\"MaterialBOMArchive\",\"MaterialBOM:cope\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:add\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:edit\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:delete\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:archive\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:newPage\"],[\"产品工程\",\"ProcessBOMArchive\",\"ProcessBOM:cope\"],[\"采购管理\",\"SupplierInfo\",\"SupplierInfo:add\"],[\"采购管理\",\"SupplierInfo\",\"SupplierInfo:edit\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:add\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:archive\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:newPage\"],[\"采购管理\",\"MaterialQuoteArchive\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:print\"],[\"委外管理\",\"OutsourcingQuote\",\"OutsourcingQuote:add\"],[\"委外管理\",\"OutsourcingQuote\",\"OutsourcingQuote:edit\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:add\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:edit\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:set\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:print\"],[\"系统管理\",\"UserManagement\"],[\"系统管理\",\"Trajectory\"],[\"系统管理\",\"ApprovalStep\",\"ApprovalStep:add\"],[\"系统管理\",\"ApprovalStep\",\"ApprovalStep:delete\"],[\"生产管理\",\"ProductionProgress\"],[\"生产管理\",\"WorkOrder\",\"WorkOrder:print\"],[\"仓库管理\",\"WarehouseRate\",\"WarehouseRate:edit\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:print\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:print\"],[\"财务管理\",\"EmployeePieceRate\",\"pieceRate:confirm\"],[\"财务管理\",\"EmployeePieceRate\",\"pieceRate:edit\"],[\"财务管理\",\"AccountsReceivable\"],[\"财务管理\",\"AccountsPayable\"],[\"财务管理\",\"AccountsOutsourcing\"],[\"采购管理\",\"ScriptionOrder\",\"ScriptionOrder:add\"],[\"采购管理\",\"ScriptionOrder\",\"ScriptionOrder:edit\"],[\"采购管理\",\"ScriptionOrder\",\"ScriptionOrder:set\"],[\"采购管理\",\"ScriptionOrder\",\"ScriptionOrder:buy\"],[\"委外管理\",\"OutscriptionOrder\",\"OutscriptionOrder:add\"],[\"委外管理\",\"OutscriptionOrder\",\"OutscriptionOrder:edit\"],[\"委外管理\",\"OutscriptionOrder\",\"OutscriptionOrder:set\"],[\"委外管理\",\"OutscriptionOrder\",\"OutscriptionOrder:buy\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:addIn\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:addOut\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:edit\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:set\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:buy\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:addIn\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:addOut\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:edit\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:set\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:buy\"]]', 2, 6, 1, 1, 1, '2025-11-11 02:06:49', '2025-11-24 10:31:42');
INSERT INTO `ad_user` VALUES (20, 3, 'liuxia', '$2b$10$qkpLTrU/K3Ruk9hBevF5ruqnHQ3UOiElhKIrZx.2WvSyATWtroxae', '刘霞', 15, '[[\"系统管理\",\"EmployeeInfo\",\"EmployeeInfo:add\"],[\"系统管理\",\"EmployeeInfo\",\"EmployeeInfo:edit\"],[\"系统管理\",\"EmployeeInfo\",\"EmployeeInfo:delete\"],[\"系统管理\",\"ProcessCycle\",\"ProcessCycle:add\"],[\"系统管理\",\"ProcessCycle\",\"ProcessCycle:edit\"],[\"系统管理\",\"WarehouseType\",\"Warehouse:add\"],[\"系统管理\",\"WarehouseType\",\"Warehouse:edit\"],[\"基础资料\",\"ProductCode\",\"ProductCode:add\"],[\"基础资料\",\"ProductCode\",\"ProductCode:edit\"],[\"基础资料\",\"PartCode\",\"PartCode:add\"],[\"基础资料\",\"PartCode\",\"PartCode:edit\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:add\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:edit\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:add\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:edit\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:add\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:edit\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:add\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:edit\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:add\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:edit\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:cancel\"],[\"订单管理\",\"ProductQuote\",\"ProductQuote:add\"],[\"订单管理\",\"ProductQuote\",\"ProductQuote:edit\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:add\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:edit\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:date\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:finish\"],[\"订单管理\",\"FinishNotice\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:add\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:edit\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:delete\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:archive\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:newPage\"],[\"产品工程\",\"MaterialBOMArchive\",\"MaterialBOM:cope\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:add\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:edit\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:delete\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:archive\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:newPage\"],[\"产品工程\",\"ProcessBOMArchive\",\"ProcessBOM:cope\"],[\"采购管理\",\"SupplierInfo\",\"SupplierInfo:add\"],[\"采购管理\",\"SupplierInfo\",\"SupplierInfo:edit\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:add\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:archive\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:newPage\"],[\"采购管理\",\"MaterialQuoteArchive\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:print\"],[\"委外管理\",\"OutsourcingQuote\",\"OutsourcingQuote:add\"],[\"委外管理\",\"OutsourcingQuote\",\"OutsourcingQuote:edit\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:add\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:edit\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:set\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:print\"],[\"生产管理\",\"ProductionProgress\"],[\"生产管理\",\"WorkOrder\",\"WorkOrder:print\"],[\"仓库管理\",\"WarehouseRate\",\"WarehouseRate:edit\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:print\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:print\"],[\"财务管理\",\"AccountsReceivable\"],[\"财务管理\",\"AccountsPayable\"],[\"财务管理\",\"AccountsOutsourcing\"],[\"系统管理\",\"UserManagement\"],[\"系统管理\",\"Trajectory\"],[\"系统管理\",\"ApprovalStep\",\"ApprovalStep:add\"],[\"系统管理\",\"ApprovalStep\",\"ApprovalStep:delete\"],[\"财务管理\",\"EmployeePieceRate\",\"pieceRate:confirm\"],[\"财务管理\",\"EmployeePieceRate\",\"pieceRate:edit\"],[\"采购管理\",\"ScriptionOrder\",\"ScriptionOrder:add\"],[\"采购管理\",\"ScriptionOrder\",\"ScriptionOrder:edit\"],[\"采购管理\",\"ScriptionOrder\",\"ScriptionOrder:set\"],[\"采购管理\",\"ScriptionOrder\",\"ScriptionOrder:buy\"],[\"委外管理\",\"OutscriptionOrder\",\"OutscriptionOrder:add\"],[\"委外管理\",\"OutscriptionOrder\",\"OutscriptionOrder:edit\"],[\"委外管理\",\"OutscriptionOrder\",\"OutscriptionOrder:set\"],[\"委外管理\",\"OutscriptionOrder\",\"OutscriptionOrder:buy\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:addIn\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:addOut\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:edit\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:set\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:buy\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:addIn\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:addOut\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:edit\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:set\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:buy\"]]', 2, 6, 1, 1, 1, '2025-11-11 02:08:42', '2025-11-24 10:31:51');
INSERT INTO `ad_user` VALUES (21, 3, 'gelianwu', '$2b$10$Pak6OlGbswYtzvSVEgxTXedl5suRXLfdGjFJUuO/Vh8auKY46I6FC', '葛练武', 17, '[[\"系统管理\",\"EmployeeInfo\",\"EmployeeInfo:add\"],[\"系统管理\",\"EmployeeInfo\",\"EmployeeInfo:edit\"],[\"系统管理\",\"EmployeeInfo\",\"EmployeeInfo:delete\"],[\"系统管理\",\"ProcessCycle\",\"ProcessCycle:add\"],[\"系统管理\",\"ProcessCycle\",\"ProcessCycle:edit\"],[\"系统管理\",\"WarehouseType\",\"Warehouse:add\"],[\"系统管理\",\"WarehouseType\",\"Warehouse:edit\"],[\"基础资料\",\"ProductCode\",\"ProductCode:add\"],[\"基础资料\",\"ProductCode\",\"ProductCode:edit\"],[\"基础资料\",\"PartCode\",\"PartCode:add\"],[\"基础资料\",\"PartCode\",\"PartCode:edit\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:add\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:edit\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:add\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:edit\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:add\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:edit\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:add\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:edit\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:add\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:edit\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:cancel\"],[\"订单管理\",\"ProductQuote\",\"ProductQuote:add\"],[\"订单管理\",\"ProductQuote\",\"ProductQuote:edit\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:add\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:edit\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:date\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:finish\"],[\"订单管理\",\"FinishNotice\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:add\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:edit\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:delete\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:archive\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:newPage\"],[\"产品工程\",\"MaterialBOMArchive\",\"MaterialBOM:cope\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:add\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:edit\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:delete\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:archive\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:newPage\"],[\"产品工程\",\"ProcessBOMArchive\",\"ProcessBOM:cope\"],[\"采购管理\",\"SupplierInfo\",\"SupplierInfo:add\"],[\"采购管理\",\"SupplierInfo\",\"SupplierInfo:edit\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:add\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:archive\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:newPage\"],[\"采购管理\",\"MaterialQuoteArchive\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:print\"],[\"委外管理\",\"OutsourcingQuote\",\"OutsourcingQuote:add\"],[\"委外管理\",\"OutsourcingQuote\",\"OutsourcingQuote:edit\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:add\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:edit\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:set\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:print\"],[\"生产管理\",\"ProductionProgress\"],[\"生产管理\",\"WorkOrder\",\"WorkOrder:print\"],[\"仓库管理\",\"WarehouseRate\",\"WarehouseRate:edit\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:print\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:print\"],[\"财务管理\",\"AccountsReceivable\"],[\"财务管理\",\"AccountsPayable\"],[\"财务管理\",\"AccountsOutsourcing\"],[\"系统管理\",\"UserManagement\"],[\"系统管理\",\"Trajectory\"],[\"系统管理\",\"ApprovalStep\",\"ApprovalStep:add\"],[\"系统管理\",\"ApprovalStep\",\"ApprovalStep:delete\"],[\"财务管理\",\"EmployeePieceRate\",\"pieceRate:confirm\"],[\"财务管理\",\"EmployeePieceRate\",\"pieceRate:edit\"],[\"采购管理\",\"ScriptionOrder\",\"ScriptionOrder:add\"],[\"采购管理\",\"ScriptionOrder\",\"ScriptionOrder:edit\"],[\"采购管理\",\"ScriptionOrder\",\"ScriptionOrder:set\"],[\"采购管理\",\"ScriptionOrder\",\"ScriptionOrder:buy\"],[\"委外管理\",\"OutscriptionOrder\",\"OutscriptionOrder:add\"],[\"委外管理\",\"OutscriptionOrder\",\"OutscriptionOrder:edit\"],[\"委外管理\",\"OutscriptionOrder\",\"OutscriptionOrder:set\"],[\"委外管理\",\"OutscriptionOrder\",\"OutscriptionOrder:buy\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:addIn\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:addOut\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:edit\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:set\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:buy\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:addIn\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:addOut\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:edit\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:set\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:buy\"]]', 2, 6, 1, 1, 1, '2025-11-11 02:10:42', '2025-11-24 10:32:02');
INSERT INTO `ad_user` VALUES (22, 3, 'xuxuehui', '$2b$10$m8Sl/yMaYpuu.mBZlq.ZH.84C5x/CDHjin4lKnxPMJpZcwizZJ6d.', '徐雪辉', 16, '[[\"系统管理\",\"EmployeeInfo\",\"EmployeeInfo:add\"],[\"系统管理\",\"EmployeeInfo\",\"EmployeeInfo:edit\"],[\"系统管理\",\"EmployeeInfo\",\"EmployeeInfo:delete\"],[\"系统管理\",\"ProcessCycle\",\"ProcessCycle:add\"],[\"系统管理\",\"ProcessCycle\",\"ProcessCycle:edit\"],[\"系统管理\",\"WarehouseType\",\"Warehouse:add\"],[\"系统管理\",\"WarehouseType\",\"Warehouse:edit\"],[\"基础资料\",\"ProductCode\",\"ProductCode:add\"],[\"基础资料\",\"ProductCode\",\"ProductCode:edit\"],[\"基础资料\",\"PartCode\",\"PartCode:add\"],[\"基础资料\",\"PartCode\",\"PartCode:edit\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:add\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:edit\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:add\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:edit\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:add\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:edit\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:add\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:edit\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:add\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:edit\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:cancel\"],[\"订单管理\",\"ProductQuote\",\"ProductQuote:add\"],[\"订单管理\",\"ProductQuote\",\"ProductQuote:edit\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:add\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:edit\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:date\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:finish\"],[\"订单管理\",\"FinishNotice\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:add\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:edit\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:delete\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:archive\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:newPage\"],[\"产品工程\",\"MaterialBOMArchive\",\"MaterialBOM:cope\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:add\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:edit\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:delete\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:archive\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:newPage\"],[\"产品工程\",\"ProcessBOMArchive\",\"ProcessBOM:cope\"],[\"采购管理\",\"SupplierInfo\",\"SupplierInfo:add\"],[\"采购管理\",\"SupplierInfo\",\"SupplierInfo:edit\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:add\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:archive\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:newPage\"],[\"采购管理\",\"MaterialQuoteArchive\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:print\"],[\"委外管理\",\"OutsourcingQuote\",\"OutsourcingQuote:add\"],[\"委外管理\",\"OutsourcingQuote\",\"OutsourcingQuote:edit\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:add\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:edit\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:set\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:print\"],[\"生产管理\",\"ProductionProgress\"],[\"生产管理\",\"WorkOrder\",\"WorkOrder:print\"],[\"仓库管理\",\"WarehouseRate\",\"WarehouseRate:edit\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:print\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:print\"],[\"财务管理\",\"AccountsReceivable\"],[\"财务管理\",\"AccountsPayable\"],[\"财务管理\",\"AccountsOutsourcing\"],[\"系统管理\",\"UserManagement\"],[\"系统管理\",\"Trajectory\"],[\"系统管理\",\"ApprovalStep\",\"ApprovalStep:add\"],[\"系统管理\",\"ApprovalStep\",\"ApprovalStep:delete\"],[\"财务管理\",\"EmployeePieceRate\",\"pieceRate:confirm\"],[\"财务管理\",\"EmployeePieceRate\",\"pieceRate:edit\"],[\"采购管理\",\"ScriptionOrder\",\"ScriptionOrder:add\"],[\"采购管理\",\"ScriptionOrder\",\"ScriptionOrder:edit\"],[\"采购管理\",\"ScriptionOrder\",\"ScriptionOrder:set\"],[\"采购管理\",\"ScriptionOrder\",\"ScriptionOrder:buy\"],[\"委外管理\",\"OutscriptionOrder\",\"OutscriptionOrder:add\"],[\"委外管理\",\"OutscriptionOrder\",\"OutscriptionOrder:edit\"],[\"委外管理\",\"OutscriptionOrder\",\"OutscriptionOrder:set\"],[\"委外管理\",\"OutscriptionOrder\",\"OutscriptionOrder:buy\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:addIn\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:addOut\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:edit\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:set\"],[\"仓库管理\",\"MaterialHouseScription\",\"MaterialHouseScription:buy\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:addIn\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:addOut\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:edit\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:set\"],[\"仓库管理\",\"ProductHouseScription\",\"ProductHouseScription:buy\"]]', 2, 6, 1, 1, 1, '2025-11-11 02:12:01', '2025-12-03 16:55:54');

-- ----------------------------
-- Table structure for sub_approval_step
-- ----------------------------
DROP TABLE IF EXISTS `sub_approval_step`;
CREATE TABLE `sub_approval_step`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `company_id` int(11) NOT NULL COMMENT '所属企业id',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT ' 业务类型 ',
  `step` int(11) NULL DEFAULT NULL COMMENT '步骤序号（从1开始）',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '指定审批人ID（为空则角色内任意人可批）',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT ' 指定审批人名称 ',
  `is_deleted` tinyint(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 24 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '审批步骤配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_approval_step
-- ----------------------------
INSERT INTO `sub_approval_step` VALUES (1, 1, 'purchase_order', 1, 5, '哈哈', 1, '2025-09-23 06:08:06', '2025-09-23 06:08:06');
INSERT INTO `sub_approval_step` VALUES (2, 1, 'outsourcing_order', 1, 4, '2132', 1, '2025-09-23 06:08:55', '2025-09-23 06:08:55');
INSERT INTO `sub_approval_step` VALUES (3, 1, 'purchase_order', 2, 4, '2132', 1, '2025-09-23 06:08:55', '2025-09-23 06:08:55');
INSERT INTO `sub_approval_step` VALUES (4, 1, 'outsourcing_order', 2, 5, '哈哈', 1, '2025-09-23 06:08:55', '2025-09-23 06:08:55');
INSERT INTO `sub_approval_step` VALUES (5, 1, 'material_warehouse', 1, 5, '哈哈', 1, '2025-09-23 06:08:55', '2025-09-23 06:08:55');
INSERT INTO `sub_approval_step` VALUES (6, 1, 'material_warehouse', 2, 4, '2132', 1, '2025-09-23 06:08:55', '2025-09-23 06:08:55');
INSERT INTO `sub_approval_step` VALUES (7, 1, 'product_warehouse', 1, 5, '哈哈', 1, '2025-09-23 06:08:55', '2025-09-23 06:08:55');
INSERT INTO `sub_approval_step` VALUES (8, 1, 'product_warehouse', 2, 4, '2132', 1, '2025-09-23 06:08:55', '2025-09-23 06:08:55');
INSERT INTO `sub_approval_step` VALUES (9, 3, 'purchase_order', 1, 16, '冷冰', 0, '2025-10-31 01:22:37', '2025-10-31 01:23:28');
INSERT INTO `sub_approval_step` VALUES (10, 3, 'outsourcing_order', 1, 15, '粟云', 1, '2025-10-31 01:23:28', '2025-10-31 01:23:28');
INSERT INTO `sub_approval_step` VALUES (11, 3, 'outsourcing_order', 2, 16, '冷冰', 1, '2025-10-31 01:23:28', '2025-10-31 01:23:28');
INSERT INTO `sub_approval_step` VALUES (12, 3, 'purchase_order', 1, 15, '粟云', 1, '2025-11-02 03:42:26', '2025-11-24 02:16:37');
INSERT INTO `sub_approval_step` VALUES (13, 3, 'purchase_order', 2, 16, '冷冰', 1, '2025-11-02 03:42:26', '2025-11-24 02:16:37');
INSERT INTO `sub_approval_step` VALUES (16, 3, 'material_warehouse', 1, 15, '粟云', 0, '2025-11-24 02:15:37', '2025-11-24 02:16:37');
INSERT INTO `sub_approval_step` VALUES (17, 3, 'product_warehouse', 1, 15, '粟云', 0, '2025-11-24 02:15:37', '2025-11-24 02:16:37');
INSERT INTO `sub_approval_step` VALUES (22, 3, 'material_warehouse', 1, 15, '粟云', 1, '2025-11-24 02:16:37', '2025-11-24 02:16:37');
INSERT INTO `sub_approval_step` VALUES (23, 3, 'product_warehouse', 1, 15, '粟云', 1, '2025-11-24 02:16:37', '2025-11-24 02:16:37');

-- ----------------------------
-- Table structure for sub_approval_user
-- ----------------------------
DROP TABLE IF EXISTS `sub_approval_user`;
CREATE TABLE `sub_approval_user`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `company_id` int(11) NULL DEFAULT NULL COMMENT '企业id',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '业务类型',
  `source_id` int(11) NULL DEFAULT NULL COMMENT '项目id',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '审核人id',
  `user_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '审核人名称',
  `user_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `step` int(2) NULL DEFAULT NULL COMMENT '第几步骤',
  `status` int(1) NULL DEFAULT 0 COMMENT '状态（0审批中/1通过/2拒绝）',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '记录创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '记录最后更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 24 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '流程控制用户表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_approval_user
-- ----------------------------
INSERT INTO `sub_approval_user` VALUES (9, 3, 'purchase_order', 2, 15, '粟云', NULL, 1, 1, '2025-11-29 16:19:07', '2025-11-29 16:19:24');
INSERT INTO `sub_approval_user` VALUES (10, 3, 'purchase_order', 2, 16, '冷冰', NULL, 2, 1, '2025-11-29 16:19:07', '2025-11-29 16:19:53');
INSERT INTO `sub_approval_user` VALUES (11, 3, 'outsourcing_order', 2, 15, '粟云', NULL, 1, 1, '2025-11-29 16:30:21', '2025-11-29 16:30:27');
INSERT INTO `sub_approval_user` VALUES (12, 3, 'outsourcing_order', 2, 16, '冷冰', NULL, 2, 1, '2025-11-29 16:30:21', '2025-11-29 16:30:33');
INSERT INTO `sub_approval_user` VALUES (14, 3, 'material_warehouse', 10, 15, '粟云', NULL, 1, 1, '2025-11-29 16:43:26', '2025-11-29 16:45:59');
INSERT INTO `sub_approval_user` VALUES (15, 3, 'material_warehouse', 11, 15, '粟云', NULL, 1, 1, '2025-11-29 16:50:32', '2025-11-29 16:50:52');
INSERT INTO `sub_approval_user` VALUES (16, 3, 'product_warehouse', 12, 15, '粟云', NULL, 1, 1, '2025-11-29 17:01:17', '2025-11-29 17:01:51');
INSERT INTO `sub_approval_user` VALUES (17, 3, 'product_warehouse', 13, 15, '粟云', NULL, 1, 1, '2025-12-01 10:29:22', '2025-12-01 10:29:46');
INSERT INTO `sub_approval_user` VALUES (18, 3, 'purchase_order', 3, 15, '粟云', NULL, 1, 1, '2025-12-01 15:59:12', '2025-12-01 15:59:15');
INSERT INTO `sub_approval_user` VALUES (19, 3, 'purchase_order', 3, 16, '冷冰', NULL, 2, 1, '2025-12-01 15:59:12', '2025-12-01 15:59:39');
INSERT INTO `sub_approval_user` VALUES (20, 3, 'material_warehouse', 14, 15, '粟云', NULL, 1, 1, '2025-12-01 16:05:35', '2025-12-01 16:05:38');
INSERT INTO `sub_approval_user` VALUES (21, 3, 'material_warehouse', 15, 15, '粟云', NULL, 1, 1, '2025-12-01 16:23:05', '2025-12-01 16:23:10');
INSERT INTO `sub_approval_user` VALUES (22, 3, 'purchase_order', 8, 15, '粟云', NULL, 1, 0, '2025-12-03 13:43:05', '2025-12-03 13:43:05');
INSERT INTO `sub_approval_user` VALUES (23, 3, 'purchase_order', 8, 16, '冷冰', NULL, 2, 0, '2025-12-03 13:43:05', '2025-12-03 13:43:05');

-- ----------------------------
-- Table structure for sub_const_type
-- ----------------------------
DROP TABLE IF EXISTS `sub_const_type`;
CREATE TABLE `sub_const_type`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `type` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '常量类型编码',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '常量类型名称',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_const_type
-- ----------------------------
INSERT INTO `sub_const_type` VALUES (1, 'employeeInfo', '工资属性', '2025-11-27 20:40:29', '2025-11-27 20:40:29');
INSERT INTO `sub_const_type` VALUES (2, 'payInfo', '交易方式', '2025-11-27 20:40:51', '2025-11-27 20:40:51');
INSERT INTO `sub_const_type` VALUES (3, 'payTime', '结算周期', '2025-11-27 20:40:59', '2025-11-27 20:40:59');
INSERT INTO `sub_const_type` VALUES (4, 'supplyMethod', '送货方式', '2025-11-27 20:41:09', '2025-11-27 20:41:09');
INSERT INTO `sub_const_type` VALUES (5, 'supplierType', '供应商类别', '2025-11-27 20:41:21', '2025-11-27 20:41:21');
INSERT INTO `sub_const_type` VALUES (6, 'invoice', '税票要求', '2025-11-27 20:41:28', '2025-11-27 20:41:36');
INSERT INTO `sub_const_type` VALUES (7, 'calcUnit', '计量单位', '2025-11-27 22:07:05', '2025-11-27 22:07:05');
INSERT INTO `sub_const_type` VALUES (8, 'materialType', '材料类别', '2025-11-27 22:28:35', '2025-11-27 22:28:35');

-- ----------------------------
-- Table structure for sub_const_user
-- ----------------------------
DROP TABLE IF EXISTS `sub_const_user`;
CREATE TABLE `sub_const_user`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `company_id` int(11) NULL DEFAULT NULL COMMENT '企业ID',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '用户ID',
  `type` varchar(25) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '类型编码',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '类型名称',
  `status` int(1) NULL DEFAULT 1 COMMENT '是否开启：1开启，0关闭',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 58 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_const_user
-- ----------------------------
INSERT INTO `sub_const_user` VALUES (1, 1, NULL, 'employeeInfo', '个人计件', 1, '2025-11-27 20:30:37', '2025-11-27 20:30:37');
INSERT INTO `sub_const_user` VALUES (2, 1, NULL, 'employeeInfo', '团体计件', 1, '2025-11-27 20:30:37', '2025-11-27 20:30:37');
INSERT INTO `sub_const_user` VALUES (3, 1, NULL, 'employeeInfo', '计时', 1, '2025-11-27 20:30:37', '2025-11-27 20:30:37');
INSERT INTO `sub_const_user` VALUES (4, 1, NULL, 'employeeInfo', '月薪', 1, '2025-11-27 20:30:37', '2025-11-27 20:30:37');
INSERT INTO `sub_const_user` VALUES (5, 1, NULL, 'payInfo', '现金', 1, '2025-11-27 20:30:37', '2025-11-27 20:30:37');
INSERT INTO `sub_const_user` VALUES (6, 1, NULL, 'payInfo', '支票', 1, '2025-11-27 20:30:37', '2025-11-27 20:30:37');
INSERT INTO `sub_const_user` VALUES (7, 1, NULL, 'payInfo', '存兑', 1, '2025-11-27 20:30:37', '2025-11-27 20:30:37');
INSERT INTO `sub_const_user` VALUES (8, 1, NULL, 'payTime', '货到付款', 1, '2025-11-27 20:30:37', '2025-11-27 20:30:37');
INSERT INTO `sub_const_user` VALUES (9, 1, NULL, 'payTime', '月结30天', 1, '2025-11-27 20:30:37', '2025-11-27 20:30:37');
INSERT INTO `sub_const_user` VALUES (10, 1, NULL, 'payTime', '月结60天', 1, '2025-11-27 20:30:37', '2025-11-27 20:30:37');
INSERT INTO `sub_const_user` VALUES (11, 1, NULL, 'payTime', '月结90天', 1, '2025-11-27 20:30:37', '2025-11-27 20:30:37');
INSERT INTO `sub_const_user` VALUES (12, 1, NULL, 'payTime', '其他', 1, '2025-11-27 20:30:37', '2025-11-27 20:30:37');
INSERT INTO `sub_const_user` VALUES (13, 1, NULL, 'supplyMethod', '送货上门', 1, '2025-11-27 20:30:37', '2025-11-27 20:30:37');
INSERT INTO `sub_const_user` VALUES (14, 1, NULL, 'supplyMethod', '自提取货', 1, '2025-11-27 20:30:37', '2025-11-27 20:30:37');
INSERT INTO `sub_const_user` VALUES (15, 1, NULL, 'supplyMethod', '三方物流', 1, '2025-11-27 20:30:37', '2025-11-27 20:30:37');
INSERT INTO `sub_const_user` VALUES (16, 1, NULL, 'supplierType', '原材料供应', 1, '2025-11-27 20:30:37', '2025-11-27 20:30:37');
INSERT INTO `sub_const_user` VALUES (17, 1, NULL, 'supplierType', '易耗材供应', 1, '2025-11-27 20:30:37', '2025-11-27 20:30:37');
INSERT INTO `sub_const_user` VALUES (18, 1, NULL, 'supplierType', '设备供应', 1, '2025-11-27 20:30:37', '2025-11-27 20:30:37');
INSERT INTO `sub_const_user` VALUES (19, 1, NULL, 'supplierType', '委外加工', 1, '2025-11-27 20:30:37', '2025-11-27 20:30:37');
INSERT INTO `sub_const_user` VALUES (20, 1, NULL, 'invoice', '不含税', 1, '2025-11-27 20:30:37', '2025-11-27 20:30:37');
INSERT INTO `sub_const_user` VALUES (21, 1, NULL, 'invoice', '普通发票', 1, '2025-11-27 20:30:37', '2025-11-27 20:30:37');
INSERT INTO `sub_const_user` VALUES (22, 1, NULL, 'invoice', '增值发票', 1, '2025-11-27 20:30:37', '2025-11-27 20:30:37');
INSERT INTO `sub_const_user` VALUES (23, 3, NULL, 'employeeInfo', '个人计件', 1, '2025-11-27 20:30:57', '2025-11-27 21:26:52');
INSERT INTO `sub_const_user` VALUES (24, 3, NULL, 'employeeInfo', '团体计件', 1, '2025-11-27 20:30:57', '2025-11-27 20:30:57');
INSERT INTO `sub_const_user` VALUES (25, 3, NULL, 'employeeInfo', '计时', 1, '2025-11-27 20:30:57', '2025-11-27 20:30:57');
INSERT INTO `sub_const_user` VALUES (26, 3, NULL, 'employeeInfo', '月薪', 1, '2025-11-27 20:30:57', '2025-11-27 20:30:57');
INSERT INTO `sub_const_user` VALUES (27, 3, NULL, 'payInfo', '现金', 1, '2025-11-27 20:30:57', '2025-11-27 20:30:57');
INSERT INTO `sub_const_user` VALUES (28, 3, NULL, 'payInfo', '支票', 1, '2025-11-27 20:30:57', '2025-11-27 20:30:57');
INSERT INTO `sub_const_user` VALUES (29, 3, NULL, 'payInfo', '存兑', 1, '2025-11-27 20:30:57', '2025-11-27 20:30:57');
INSERT INTO `sub_const_user` VALUES (30, 3, NULL, 'payTime', '货到付款', 1, '2025-11-27 20:30:57', '2025-11-27 20:30:57');
INSERT INTO `sub_const_user` VALUES (31, 3, NULL, 'payTime', '月结30天', 1, '2025-11-27 20:30:57', '2025-11-27 20:30:57');
INSERT INTO `sub_const_user` VALUES (32, 3, NULL, 'payTime', '月结60天', 1, '2025-11-27 20:30:57', '2025-11-27 20:30:57');
INSERT INTO `sub_const_user` VALUES (33, 3, NULL, 'payTime', '月结90天', 1, '2025-11-27 20:30:57', '2025-11-27 20:30:57');
INSERT INTO `sub_const_user` VALUES (34, 3, NULL, 'payTime', '其它', 1, '2025-11-27 20:30:57', '2025-11-28 15:17:23');
INSERT INTO `sub_const_user` VALUES (35, 3, NULL, 'supplyMethod', '送货上门', 1, '2025-11-27 20:30:57', '2025-11-27 20:30:57');
INSERT INTO `sub_const_user` VALUES (36, 3, NULL, 'supplyMethod', '自提取货', 1, '2025-11-27 20:30:57', '2025-11-27 20:30:57');
INSERT INTO `sub_const_user` VALUES (37, 3, NULL, 'supplyMethod', '三方物流', 1, '2025-11-27 20:30:57', '2025-11-27 20:30:57');
INSERT INTO `sub_const_user` VALUES (38, 3, NULL, 'supplierType', '原材料供应', 1, '2025-11-27 20:30:57', '2025-11-27 20:30:57');
INSERT INTO `sub_const_user` VALUES (39, 3, NULL, 'supplierType', '易耗材供应', 1, '2025-11-27 20:30:57', '2025-11-27 20:30:57');
INSERT INTO `sub_const_user` VALUES (40, 3, NULL, 'supplierType', '设备供应', 1, '2025-11-27 20:30:57', '2025-11-27 20:30:57');
INSERT INTO `sub_const_user` VALUES (41, 3, NULL, 'supplierType', '委外加工', 1, '2025-11-27 20:30:57', '2025-11-27 20:30:57');
INSERT INTO `sub_const_user` VALUES (42, 3, NULL, 'invoice', '不含税', 1, '2025-11-27 20:30:57', '2025-11-27 20:30:57');
INSERT INTO `sub_const_user` VALUES (43, 3, NULL, 'invoice', '普通发票', 1, '2025-11-27 20:30:57', '2025-11-27 20:30:57');
INSERT INTO `sub_const_user` VALUES (44, 3, NULL, 'invoice', '增值发票', 1, '2025-11-27 20:30:57', '2025-11-27 20:30:57');
INSERT INTO `sub_const_user` VALUES (47, 3, 6, 'calcUnit', '个', 1, '2025-11-27 22:07:24', '2025-11-27 22:07:24');
INSERT INTO `sub_const_user` VALUES (48, 3, 6, 'calcUnit', '件', 1, '2025-11-27 22:07:33', '2025-11-27 22:17:24');
INSERT INTO `sub_const_user` VALUES (49, 3, 6, 'materialType', '铝架配件', 1, '2025-11-28 11:03:57', '2025-11-28 11:03:57');
INSERT INTO `sub_const_user` VALUES (50, 3, 6, 'materialType', '铝管材', 1, '2025-11-28 11:04:08', '2025-11-28 11:04:08');
INSERT INTO `sub_const_user` VALUES (51, 3, 6, 'calcUnit', 'PCS', 1, '2025-11-28 14:46:13', '2025-11-28 14:46:13');
INSERT INTO `sub_const_user` VALUES (52, 3, 6, 'calcUnit', '台', 1, '2025-11-28 15:41:32', '2025-11-28 15:41:32');
INSERT INTO `sub_const_user` VALUES (53, 3, 6, 'calcUnit', '套', 1, '2025-11-28 16:39:07', '2025-11-28 16:39:07');
INSERT INTO `sub_const_user` VALUES (54, 3, 6, 'calcUnit', '公斤', 1, '2025-11-28 16:39:35', '2025-11-28 16:39:35');
INSERT INTO `sub_const_user` VALUES (55, 3, 6, 'calcUnit', '盒', 1, '2025-11-28 16:49:21', '2025-11-28 16:49:21');
INSERT INTO `sub_const_user` VALUES (56, 3, 6, 'calcUnit', '包', 1, '2025-11-28 16:49:34', '2025-11-28 16:49:34');
INSERT INTO `sub_const_user` VALUES (57, 3, 6, 'calcUnit', '支', 1, '2025-12-01 09:04:52', '2025-12-01 09:04:52');

-- ----------------------------
-- Table structure for sub_customer_info
-- ----------------------------
DROP TABLE IF EXISTS `sub_customer_info`;
CREATE TABLE `sub_customer_info`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键ID',
  `user_id` int(5) NULL DEFAULT NULL COMMENT '发布用户id',
  `company_id` int(11) NOT NULL COMMENT '所属企业id',
  `customer_code` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '客户编码',
  `customer_abbreviation` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '客户简称',
  `contact_person` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系人',
  `contact_information` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系方式',
  `company_full_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '公司全名',
  `company_address` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '公司地址',
  `delivery_address` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '交货地址',
  `tax_registration_number` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '税务登记号',
  `transaction_currency` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '交易币别',
  `transaction_method` int(5) NULL DEFAULT NULL COMMENT '交易方式',
  `other_transaction_terms` varchar(5) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '结算周期',
  `other_text` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '其他结算周期',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '客户信息基础信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_customer_info
-- ----------------------------
INSERT INTO `sub_customer_info` VALUES (1, 1, 1, '123223', '石龙佳洁士', '1', '1', '1', '1', '1', '1', '1', 22, '1', NULL, 1, '2025-07-08 19:29:21', '2025-10-22 13:14:26');
INSERT INTO `sub_customer_info` VALUES (2, 1, 1, '1234', '惠州饮料厂', '212', '121', '21', '121', '2121', '21', '2121', 21, '2121', NULL, 1, '2025-07-09 00:58:19', '2025-10-22 13:18:16');
INSERT INTO `sub_customer_info` VALUES (3, 1, 1, '12311', '东莞鞋厂', '12', '1', '15', '155', '15', '15', '55', 23, '11', NULL, 1, '2025-07-09 15:04:51', '2025-10-22 13:18:08');
INSERT INTO `sub_customer_info` VALUES (4, 6, 3, 'KA001', '旭欧', '潘总', '13812345678', '东莞市旭欧精密五金有限公司', '东莞市石碣镇单屋村', '公司材料仓', 'SJ123456', '人民币', 27, '31', NULL, 1, '2025-10-18 11:09:32', '2025-11-28 15:36:08');
INSERT INTO `sub_customer_info` VALUES (5, 6, 3, 'KA002', '鑫宇', '王总', '13712345678', '东莞市鑫宇五金制品厂', '东莞市万江区官桥窖村', '高埗镇合鑫喷漆厂', 'WJ123456', '人民币', 29, '31', NULL, 1, '2025-10-30 15:52:21', '2025-11-28 15:36:21');

-- ----------------------------
-- Table structure for sub_date_info
-- ----------------------------
DROP TABLE IF EXISTS `sub_date_info`;
CREATE TABLE `sub_date_info`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `company_id` int(11) NULL DEFAULT NULL COMMENT '公司ID',
  `date` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '日期',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 41 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '日历记录的表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_date_info
-- ----------------------------
INSERT INTO `sub_date_info` VALUES (37, 3, '2025-11-09', '2025-11-29 09:53:36', '2025-11-29 09:53:36');
INSERT INTO `sub_date_info` VALUES (38, 3, '2025-11-23', '2025-11-29 09:53:36', '2025-11-29 09:53:36');
INSERT INTO `sub_date_info` VALUES (39, 3, '2025-12-07', '2025-11-29 09:53:36', '2025-11-29 09:53:36');
INSERT INTO `sub_date_info` VALUES (40, 3, '2025-12-21', '2025-11-29 09:53:36', '2025-11-29 09:53:36');

-- ----------------------------
-- Table structure for sub_employee_info
-- ----------------------------
DROP TABLE IF EXISTS `sub_employee_info`;
CREATE TABLE `sub_employee_info`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键ID',
  `user_id` int(5) NOT NULL COMMENT '发布的用户id',
  `company_id` int(5) NOT NULL COMMENT '企业id',
  `employee_id` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '员工工号',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '姓名',
  `account` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '员工账号',
  `password` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '员工密码',
  `cycle_id` int(11) NULL DEFAULT NULL COMMENT '所属制程id',
  `position` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生产岗位',
  `salary_attribute` int(5) NULL DEFAULT NULL COMMENT '工资属性',
  `remarks` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '备注',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '员工信息基础信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_employee_info
-- ----------------------------
INSERT INTO `sub_employee_info` VALUES (1, 1, 1, '1', '1', NULL, NULL, 3, '1', 17, '1', 1, '2025-07-08 16:39:58', '2025-10-22 13:10:15');
INSERT INTO `sub_employee_info` VALUES (2, 1, 1, '2', '2', 'base2', '$2b$10$mHXkEoWarhWYGisAwOnZ9Oghb6wEcnG0NOH8WdevQwS7HKLlET/Ja', 2, '23', 18, '3', 1, '2025-07-08 16:40:09', '2025-10-22 13:10:16');
INSERT INTO `sub_employee_info` VALUES (3, 1, 1, '21', '2121', 'base1', '$2b$10$K0JSC.MSvQbD6mkRHjvjC.gpS4XvjatLgIf/yw0wjSs.N3FHt9aCe', 2, '21', 19, '211', 1, '2025-10-01 14:42:30', '2025-10-22 13:11:01');
INSERT INTO `sub_employee_info` VALUES (4, 1, 1, '22', '5445', 'base3', '$2b$10$7DtT7oDcCGxZaLYfiJTPd.mywJj.yYGwC7di.3HLUfD.JBtP3wv0y', 2, '2121', 20, '21', 1, '2025-10-01 15:05:57', '2025-10-22 13:10:19');
INSERT INTO `sub_employee_info` VALUES (5, 6, 3, 'GL0002', '冷冰', 'SC0001', '$2b$10$1fJx1ONLKdN8t7dmcuQ.KODgtQ1ff5bFVVC0tUk4IQbkkXUX3k7pm', 14, '业务一部副总', 20, NULL, 1, '2025-10-18 10:54:01', '2025-11-11 14:01:43');
INSERT INTO `sub_employee_info` VALUES (6, 6, 3, 'GL0001', '徐庆华', 'GL0002', '$2b$10$vqlF5BJP4DLhCjIc3rIS8.7j02OmX7NWxUQYBjScbdnUiZ49rT63C', 15, '公司创始人', 20, NULL, 1, '2025-10-18 11:00:50', '2025-10-28 15:04:40');
INSERT INTO `sub_employee_info` VALUES (7, 6, 3, 'GL0003', '何雄明', NULL, '$2b$10$1zaoOimS5ZBJDnocBe5isuXqsA2RiW2/y1lmfm3YpnxhCCSBB4PQm', 13, '技术部副总', 20, NULL, 1, '2025-10-27 20:45:10', '2025-11-03 11:28:12');
INSERT INTO `sub_employee_info` VALUES (8, 6, 3, 'GL0004', '粟云', NULL, '$2b$10$vIxMD.gzhk7SKu4nSAMSoeb8LMRr.w.MGYSM1axo1CztZSVfNbgtm', 16, '生产部副总', 20, NULL, 1, '2025-10-27 20:49:12', '2025-11-09 01:10:00');
INSERT INTO `sub_employee_info` VALUES (9, 6, 3, 'GL0005', '徐楚东', NULL, '$2b$10$I2QbpPtCfgs6e.XcCVPASOkbCuL3Pjnaa82yrFLkw9OxUGmbJhQ6m', 12, '行政部专员', 23, NULL, 1, '2025-10-31 10:01:52', '2025-11-27 22:29:59');
INSERT INTO `sub_employee_info` VALUES (10, 6, 3, 'GL0006', '刘庄震', NULL, '$2b$10$OKf/.VGPVa8pYLwaVnvIF.I8pXjJRYXmbQoMZtzVhJXzEdMcPfUbe', 15, '质量体系认证师', 20, NULL, 1, '2025-11-11 02:17:09', '2025-11-11 02:17:09');
INSERT INTO `sub_employee_info` VALUES (11, 6, 3, 'GL0007', '陆斌权', NULL, '$2b$10$w4AQL.ACQ5xcW2uyTHDXruKX7PXpKue.IvbLRUo0EtepBmFlLk9B.', 12, '行政部主管', 20, NULL, 1, '2025-11-11 02:18:37', '2025-11-11 02:18:37');
INSERT INTO `sub_employee_info` VALUES (12, 6, 3, 'GL0008', '刘霞', NULL, '$2b$10$Uiusw6BYPFPqaYFKkeuMduidYcBubjjHTPFDlr0gpuIcn.c5l7Cbu', 14, '业务二部副总', 20, NULL, 1, '2025-11-11 02:20:26', '2025-11-11 14:01:52');
INSERT INTO `sub_employee_info` VALUES (13, 6, 3, 'GL0009', '葛练武', NULL, '$2b$10$wX0m4sE.ix2Jh.dqAJ2Sr.qdXF3B1ggH0S7SUSrrgca0XGGPA.og2', 17, '财务部副总', 20, NULL, 1, '2025-11-11 02:22:52', '2025-11-11 02:22:52');
INSERT INTO `sub_employee_info` VALUES (14, 6, 3, 'GL0010', '徐雪辉', NULL, '$2b$10$27JT9DZOu/FFdDfh3n/gO.m553c1YR79kdOnxDsfPOj0nS/v3mGaa', 16, '生产部主管', 20, NULL, 1, '2025-11-11 02:24:24', '2025-11-11 02:24:24');

-- ----------------------------
-- Table structure for sub_equipment_code
-- ----------------------------
DROP TABLE IF EXISTS `sub_equipment_code`;
CREATE TABLE `sub_equipment_code`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键ID',
  `user_id` int(5) NULL DEFAULT NULL COMMENT '用户id',
  `company_id` int(5) NULL DEFAULT NULL COMMENT '企业id',
  `equipment_code` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '设备编码',
  `equipment_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '设备名称',
  `quantity` int(11) NULL DEFAULT 2 COMMENT '设备总数量',
  `cycle_id` int(11) NULL DEFAULT NULL COMMENT '所属制程组',
  `working_hours` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '工作时长(小时)',
  `efficiency` int(10) NULL DEFAULT NULL COMMENT '设备效能',
  `available` int(20) NULL DEFAULT NULL COMMENT '可用设备数量',
  `remarks` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '备注',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '1：未删除；0：已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '记录创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '记录最后更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 50 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '设备信息基础信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_equipment_code
-- ----------------------------
INSERT INTO `sub_equipment_code` VALUES (3, 1, 1, '123', '钻床', 12, 3, '7', 56, 8, '无', 1, '2025-07-08 16:06:29', '2025-10-22 11:39:46');
INSERT INTO `sub_equipment_code` VALUES (4, 1, 1, '122', '退火炉', 22, 1, '10', 40, 4, '无', 1, '2025-08-09 16:06:56', '2025-10-22 11:39:41');
INSERT INTO `sub_equipment_code` VALUES (5, 1, 1, '124', '激光机', 5, 1, '8', 40, 5, '无', 1, '2025-08-29 09:33:14', '2025-10-22 11:39:35');
INSERT INTO `sub_equipment_code` VALUES (6, 6, 3, 'JX01', '打字机', 2, 6, '10', 20, 2, '', 1, '2025-10-18 10:17:12', '2025-11-02 09:14:56');
INSERT INTO `sub_equipment_code` VALUES (7, 6, 3, 'JX02', '16T冲床', 8, 6, '10', 80, 8, '', 1, '2025-10-18 10:21:33', '2025-10-23 23:51:20');
INSERT INTO `sub_equipment_code` VALUES (8, 6, 3, 'JX03', '钻床-A', 5, 6, '10', 50, 5, '', 1, '2025-10-18 10:24:42', '2025-10-23 23:51:15');
INSERT INTO `sub_equipment_code` VALUES (9, 6, 3, 'JX04', '手动研磨机', 8, 9, '10', 80, 8, '', 1, '2025-10-18 10:38:09', '2025-11-10 10:57:54');
INSERT INTO `sub_equipment_code` VALUES (10, 6, 3, 'JX05', '卧冲', 2, 6, '10', 20, 2, '', 1, '2025-10-28 13:17:08', '2025-10-29 15:00:24');
INSERT INTO `sub_equipment_code` VALUES (11, 6, 3, 'JX06', '切料机', 3, 6, '10', 30, 3, '', 1, '2025-10-28 13:18:23', '2025-10-28 13:18:23');
INSERT INTO `sub_equipment_code` VALUES (12, 6, 3, 'JX07', '双头钻', 1, 6, '10', 10, 1, '', 1, '2025-10-28 13:20:21', '2025-10-28 13:20:21');
INSERT INTO `sub_equipment_code` VALUES (13, 6, 3, 'JX08', '开槽机', 1, 6, '10', 10, 1, '', 1, '2025-10-28 13:20:57', '2025-10-28 13:20:57');
INSERT INTO `sub_equipment_code` VALUES (14, 6, 3, 'JX09', '大弯管机', 1, 6, '10', 10, 1, '', 1, '2025-10-28 13:21:31', '2025-10-28 13:21:31');
INSERT INTO `sub_equipment_code` VALUES (15, 6, 3, 'JX10', '小弯管机', 1, 6, '10', 10, 1, '', 1, '2025-10-28 13:22:06', '2025-10-28 13:22:06');
INSERT INTO `sub_equipment_code` VALUES (16, 6, 3, 'JX11', '60T油压机', 1, 6, '10', 10, 1, '', 1, '2025-10-28 13:22:45', '2025-10-28 13:22:45');
INSERT INTO `sub_equipment_code` VALUES (17, 6, 3, 'JX12', '缩管机', 1, 6, '10', 10, 1, '', 1, '2025-10-28 13:23:27', '2025-10-28 13:23:27');
INSERT INTO `sub_equipment_code` VALUES (18, 6, 3, 'JX13', '铣上叉弧机', 1, 6, '10', 10, 1, '', 1, '2025-10-28 13:25:42', '2025-10-28 13:25:42');
INSERT INTO `sub_equipment_code` VALUES (19, 6, 3, 'JX14', '铣下叉弧机', 1, 6, '10', 10, 1, '', 1, '2025-10-28 13:28:57', '2025-10-28 13:28:57');
INSERT INTO `sub_equipment_code` VALUES (20, 6, 3, 'JX15', '退火炉', 1, 6, '10', 10, 1, '', 1, '2025-10-28 13:29:38', '2025-10-28 13:29:38');
INSERT INTO `sub_equipment_code` VALUES (21, 6, 3, 'JX16', '钻床-B', 3, 11, '10', 30, 3, '', 1, '2025-10-28 13:31:50', '2025-10-28 13:31:50');
INSERT INTO `sub_equipment_code` VALUES (22, 6, 3, 'JX17', '人工-硬焊', 5, 6, '10', 50, 5, '', 1, '2025-10-28 13:32:44', '2025-10-28 13:32:44');
INSERT INTO `sub_equipment_code` VALUES (23, 6, 3, 'JX18', '万能铣弧机', 1, 6, '10', 10, 1, '', 1, '2025-10-28 13:34:21', '2025-10-28 13:34:21');
INSERT INTO `sub_equipment_code` VALUES (24, 6, 3, 'JX19', '数控铣弧机', 1, 6, '10', 10, 1, '', 1, '2025-10-28 13:35:06', '2025-10-28 13:35:06');
INSERT INTO `sub_equipment_code` VALUES (25, 6, 3, 'JX20', '40T冲床', 1, 6, '10', 10, 1, '', 1, '2025-10-28 13:35:41', '2025-10-28 13:35:41');
INSERT INTO `sub_equipment_code` VALUES (26, 6, 3, 'JX21', '攻牙机', 1, 6, '10', 10, 1, '', 1, '2025-10-28 13:36:12', '2025-10-28 13:36:12');
INSERT INTO `sub_equipment_code` VALUES (27, 6, 3, 'JX22', '上叉冲弧机', 1, 6, '10', 10, 1, '', 1, '2025-10-28 13:36:45', '2025-10-28 13:36:45');
INSERT INTO `sub_equipment_code` VALUES (28, 6, 3, 'JX23', '自动研磨机', 1, 6, '10', 10, 1, '', 1, '2025-10-28 13:37:12', '2025-10-28 13:37:12');
INSERT INTO `sub_equipment_code` VALUES (29, 6, 3, 'JX24', '氩焊机', 49, 7, '10', 490, 49, '', 1, '2025-10-28 13:37:55', '2025-11-14 14:41:30');
INSERT INTO `sub_equipment_code` VALUES (30, 6, 3, 'JX25', '激光机', 1, 7, '10', 10, 1, '', 1, '2025-10-28 13:38:43', '2025-10-28 13:38:43');
INSERT INTO `sub_equipment_code` VALUES (31, 6, 3, 'JX26', '前三角组立台', 3, 7, '10', 30, 3, '', 1, '2025-10-28 14:30:44', '2025-10-28 14:30:44');
INSERT INTO `sub_equipment_code` VALUES (32, 6, 3, 'JX27', '后三角组立台', 3, 7, '10', 30, 3, '', 1, '2025-10-28 14:31:18', '2025-10-28 14:31:18');
INSERT INTO `sub_equipment_code` VALUES (33, 6, 3, 'JX28', '切折叠器机', 1, 7, '10', 10, 1, '', 1, '2025-10-28 14:36:02', '2025-10-28 14:36:02');
INSERT INTO `sub_equipment_code` VALUES (34, 6, 3, 'JX29', '校正台-A', 6, 8, '10', 60, 6, '', 1, '2025-10-28 14:40:06', '2025-10-28 14:40:06');
INSERT INTO `sub_equipment_code` VALUES (35, 6, 3, 'JX30', 'T4炉', 60, 8, '10', 600, 60, '', 1, '2025-10-28 14:41:49', '2025-10-30 21:33:51');
INSERT INTO `sub_equipment_code` VALUES (36, 6, 3, 'JX31', '对眼机', 1, 8, '10', 10, 1, '', 1, '2025-10-28 14:42:22', '2025-10-28 14:42:22');
INSERT INTO `sub_equipment_code` VALUES (37, 6, 3, 'JX32', 'T6炉', 200, 8, '20', 4000, 200, '', 1, '2025-10-28 14:43:32', '2025-10-28 14:43:32');
INSERT INTO `sub_equipment_code` VALUES (38, 6, 3, 'JX33', '铰孔机', 2, 8, '10', 20, 2, '', 1, '2025-10-28 14:48:59', '2025-10-28 14:56:19');
INSERT INTO `sub_equipment_code` VALUES (39, 6, 3, 'JX34', '铣头管机', 2, 8, '10', 20, 2, '', 1, '2025-10-28 14:49:41', '2025-10-28 14:49:41');
INSERT INTO `sub_equipment_code` VALUES (40, 6, 3, 'JX35', '铣五通机', 1, 8, '10', 10, 1, '', 1, '2025-10-28 14:56:06', '2025-10-28 14:56:06');
INSERT INTO `sub_equipment_code` VALUES (41, 6, 3, 'JX36', '铣碟刹机', 2, 8, '10', 20, 2, '', 1, '2025-10-28 14:57:11', '2025-10-28 14:57:11');
INSERT INTO `sub_equipment_code` VALUES (42, 6, 3, 'JX37', '皮膜槽', 4, 11, '10', 40, 4, '', 1, '2025-10-28 14:58:03', '2025-10-28 14:58:03');
INSERT INTO `sub_equipment_code` VALUES (43, 6, 3, 'JX38', '人工-补土', 10, 10, '10', 100, 10, '', 1, '2025-10-28 14:58:39', '2025-10-28 14:58:39');
INSERT INTO `sub_equipment_code` VALUES (44, 6, 3, 'JX39', 'QC全检', 2, 11, '10', 20, 2, '', 1, '2025-10-28 14:59:13', '2025-10-28 14:59:13');
INSERT INTO `sub_equipment_code` VALUES (45, 6, 3, 'JX40', '包装', 2, 11, '10', 20, 2, '', 1, '2025-10-28 14:59:45', '2025-10-28 14:59:45');
INSERT INTO `sub_equipment_code` VALUES (46, 6, 3, 'JX41', '校正台-B', 2, 7, '10', 20, 2, '', 1, '2025-10-28 15:00:40', '2025-10-28 15:00:40');
INSERT INTO `sub_equipment_code` VALUES (47, 6, 3, 'JX42', '打磨毛刺校正', 3, 6, '10', 30, 3, '', 1, '2025-10-28 15:01:16', '2025-10-28 15:01:16');
INSERT INTO `sub_equipment_code` VALUES (48, 6, 3, 'JX43', '焊接清洗工', 1, 7, '10', 10, 1, '', 1, '2025-10-28 15:02:27', '2025-10-28 15:02:27');
INSERT INTO `sub_equipment_code` VALUES (49, 15, 3, 'WX01', '电脑锣', 3, 18, '10', 0, 0, '', 1, '2025-11-29 10:52:52', '2025-12-01 16:27:24');

-- ----------------------------
-- Table structure for sub_material_bom
-- ----------------------------
DROP TABLE IF EXISTS `sub_material_bom`;
CREATE TABLE `sub_material_bom`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键ID',
  `company_id` int(11) NOT NULL COMMENT '企业id',
  `user_id` int(11) NOT NULL COMMENT '发布的用户id',
  `product_id` int(11) NOT NULL COMMENT '产品编码id',
  `part_id` int(11) NOT NULL COMMENT '部件编码id',
  `sort` int(20) NULL DEFAULT 0 COMMENT '排序',
  `archive` int(11) NULL DEFAULT NULL COMMENT '是否已存档，1未存，0已存',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 42 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '材料BOM表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_material_bom
-- ----------------------------
INSERT INTO `sub_material_bom` VALUES (5, 1, 1, 11, 6, 0, 0, 1, '2025-07-27 11:10:29', '2025-08-03 11:04:19');
INSERT INTO `sub_material_bom` VALUES (6, 1, 1, 10, 5, 0, 0, 1, '2025-07-27 11:22:56', '2025-08-03 11:04:19');
INSERT INTO `sub_material_bom` VALUES (7, 1, 1, 9, 6, 0, 0, 1, '2025-07-27 11:50:06', '2025-08-03 11:04:19');
INSERT INTO `sub_material_bom` VALUES (8, 1, 1, 10, 6, 0, 0, 1, '2025-08-02 11:04:51', '2025-08-03 11:04:19');
INSERT INTO `sub_material_bom` VALUES (9, 1, 1, 19, 5, 0, 0, 1, '2025-08-11 10:19:02', '2025-08-13 14:40:29');
INSERT INTO `sub_material_bom` VALUES (10, 1, 1, 19, 6, 0, 0, 1, '2025-08-11 10:19:02', '2025-08-13 14:40:29');
INSERT INTO `sub_material_bom` VALUES (11, 1, 1, 19, 10, 0, 0, 1, '2025-08-11 10:19:02', '2025-08-13 14:40:29');
INSERT INTO `sub_material_bom` VALUES (12, 1, 1, 17, 7, 0, 0, 1, '2025-08-13 10:38:41', '2025-08-13 14:40:29');
INSERT INTO `sub_material_bom` VALUES (13, 1, 1, 19, 6, 0, 0, 1, '2025-08-13 14:41:35', '2025-08-17 09:48:46');
INSERT INTO `sub_material_bom` VALUES (14, 1, 1, 17, 7, 0, 0, 1, '2025-08-13 14:41:55', '2025-08-17 09:48:46');
INSERT INTO `sub_material_bom` VALUES (15, 1, 1, 19, 10, 0, 0, 1, '2025-08-13 14:42:03', '2025-08-17 09:48:46');
INSERT INTO `sub_material_bom` VALUES (16, 1, 1, 17, 7, 0, 0, 1, '2025-08-21 09:35:05', '2025-09-25 14:39:53');
INSERT INTO `sub_material_bom` VALUES (17, 1, 1, 16, 8, 0, 0, 1, '2025-09-25 14:38:28', '2025-09-25 14:39:53');
INSERT INTO `sub_material_bom` VALUES (18, 1, 1, 11, 9, 0, 0, 1, '2025-09-25 14:39:31', '2025-09-25 14:39:53');
INSERT INTO `sub_material_bom` VALUES (19, 1, 1, 14, 10, 0, 0, 1, '2025-09-25 14:39:45', '2025-09-25 14:39:53');
INSERT INTO `sub_material_bom` VALUES (20, 1, 1, 14, 13, 0, 0, 1, '2025-09-25 14:44:26', '2025-09-25 14:44:42');
INSERT INTO `sub_material_bom` VALUES (21, 1, 1, 14, 10, 0, 0, 1, '2025-09-25 14:44:36', '2025-09-25 14:44:42');
INSERT INTO `sub_material_bom` VALUES (22, 3, 12, 20, 21, 0, 1, 0, '2025-10-18 14:29:06', '2025-10-18 15:10:13');
INSERT INTO `sub_material_bom` VALUES (23, 3, 6, 20, 21, 1, 0, 1, '2025-10-18 14:30:01', '2025-11-28 15:19:41');
INSERT INTO `sub_material_bom` VALUES (24, 3, 6, 20, 27, 2, 0, 1, '2025-10-18 15:08:30', '2025-11-28 14:42:12');
INSERT INTO `sub_material_bom` VALUES (25, 1, 1, 15, 8, 0, 1, 1, '2025-10-21 21:04:49', '2025-10-21 21:23:26');
INSERT INTO `sub_material_bom` VALUES (26, 3, 6, 20, 34, 3, 0, 1, '2025-10-30 16:49:20', '2025-11-28 14:42:31');
INSERT INTO `sub_material_bom` VALUES (27, 3, 6, 20, 33, 4, 0, 1, '2025-10-30 16:49:58', '2025-11-28 15:19:57');
INSERT INTO `sub_material_bom` VALUES (28, 3, 6, 20, 25, 5, 0, 1, '2025-10-30 16:54:25', '2025-11-28 15:20:43');
INSERT INTO `sub_material_bom` VALUES (29, 3, 6, 20, 38, 6, 0, 1, '2025-10-30 16:55:14', '2025-11-28 15:21:13');
INSERT INTO `sub_material_bom` VALUES (30, 3, 6, 20, 22, 7, 0, 1, '2025-10-30 16:58:07', '2025-11-28 15:21:23');
INSERT INTO `sub_material_bom` VALUES (31, 3, 6, 20, 29, 8, 0, 1, '2025-10-30 16:59:47', '2025-11-28 15:21:32');
INSERT INTO `sub_material_bom` VALUES (32, 3, 6, 20, 28, 9, 0, 1, '2025-10-30 17:01:11', '2025-11-28 15:22:11');
INSERT INTO `sub_material_bom` VALUES (33, 3, 6, 20, 35, 10, 0, 1, '2025-10-30 17:01:55', '2025-11-28 15:22:25');
INSERT INTO `sub_material_bom` VALUES (34, 3, 6, 20, 36, 11, 0, 1, '2025-10-30 17:02:54', '2025-11-28 15:22:34');
INSERT INTO `sub_material_bom` VALUES (35, 3, 6, 20, 30, 12, 0, 1, '2025-10-30 17:04:53', '2025-11-29 10:14:54');
INSERT INTO `sub_material_bom` VALUES (36, 3, 6, 20, 31, 13, 0, 1, '2025-10-30 17:05:52', '2025-11-29 10:15:06');
INSERT INTO `sub_material_bom` VALUES (37, 3, 6, 20, 40, 14, 0, 1, '2025-10-30 17:07:19', '2025-11-29 10:18:16');
INSERT INTO `sub_material_bom` VALUES (38, 3, 6, 20, 41, 15, 0, 1, '2025-10-30 17:07:53', '2025-11-29 10:18:23');
INSERT INTO `sub_material_bom` VALUES (39, 3, 6, 20, 42, 16, 0, 1, '2025-10-30 17:12:29', '2025-11-29 10:18:37');
INSERT INTO `sub_material_bom` VALUES (40, 3, 6, 20, 43, 17, 0, 1, '2025-10-30 17:12:55', '2025-11-29 10:24:20');
INSERT INTO `sub_material_bom` VALUES (41, 3, 6, 20, 44, 18, 0, 1, '2025-10-30 17:13:58', '2025-11-29 10:25:45');

-- ----------------------------
-- Table structure for sub_material_bom_child
-- ----------------------------
DROP TABLE IF EXISTS `sub_material_bom_child`;
CREATE TABLE `sub_material_bom_child`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键ID',
  `company_id` int(11) NULL DEFAULT NULL COMMENT '企业id',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '发布的用户id',
  `material_bom_id` int(11) NULL DEFAULT NULL COMMENT '材料BOM的父表id',
  `material_id` int(11) NULL DEFAULT NULL COMMENT '材料编码ID，关联材料编码表',
  `number` int(20) NULL DEFAULT NULL COMMENT '数量',
  `process_index` int(5) NULL DEFAULT NULL COMMENT '工序下标',
  `is_buy` int(11) NULL DEFAULT 0 COMMENT '是否已采购，0未采购1已采购',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 69 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '材料BOM表子表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_material_bom_child
-- ----------------------------
INSERT INTO `sub_material_bom_child` VALUES (6, NULL, NULL, 12, 2, 12, 1, 0, '2025-08-13 10:38:41', '2025-10-31 10:23:14');
INSERT INTO `sub_material_bom_child` VALUES (7, NULL, NULL, 12, 2, 22, 2, 0, '2025-08-13 10:38:41', '2025-10-31 10:23:14');
INSERT INTO `sub_material_bom_child` VALUES (8, NULL, NULL, 12, 2, 24, 3, 0, '2025-08-13 10:38:41', '2025-10-31 10:23:16');
INSERT INTO `sub_material_bom_child` VALUES (9, NULL, NULL, 11, 2, 23, 1, 0, '2025-08-13 10:59:47', '2025-10-31 10:23:17');
INSERT INTO `sub_material_bom_child` VALUES (10, NULL, NULL, 11, 2, 34, 2, 0, '2025-08-13 10:59:47', '2025-10-31 10:23:17');
INSERT INTO `sub_material_bom_child` VALUES (11, NULL, NULL, 10, 2, 12, 1, 0, '2025-08-13 10:59:52', '2025-10-31 10:23:18');
INSERT INTO `sub_material_bom_child` VALUES (12, NULL, NULL, 13, 3, 12, 1, 0, '2025-08-13 14:41:35', '2025-10-31 10:22:59');
INSERT INTO `sub_material_bom_child` VALUES (13, NULL, NULL, 14, 2, 12, 1, 0, '2025-08-13 14:41:55', '2025-10-31 10:22:57');
INSERT INTO `sub_material_bom_child` VALUES (14, NULL, NULL, 14, 2, 22, 2, 0, '2025-08-13 14:41:55', '2025-10-31 10:23:23');
INSERT INTO `sub_material_bom_child` VALUES (15, NULL, NULL, 14, 3, 24, 3, 0, '2025-08-13 14:41:55', '2025-10-31 10:23:27');
INSERT INTO `sub_material_bom_child` VALUES (16, NULL, NULL, 15, 2, 23, 1, 0, '2025-08-13 14:42:03', '2025-10-31 10:22:52');
INSERT INTO `sub_material_bom_child` VALUES (17, NULL, NULL, 15, 2, 34, 2, 0, '2025-08-13 14:42:03', '2025-10-31 10:22:51');
INSERT INTO `sub_material_bom_child` VALUES (18, NULL, NULL, 16, 3, 12, 1, 0, '2025-08-21 09:35:05', '2025-10-31 10:22:47');
INSERT INTO `sub_material_bom_child` VALUES (19, NULL, NULL, 17, 2, 600, 1, 0, '2025-09-25 14:38:28', '2025-10-31 10:22:45');
INSERT INTO `sub_material_bom_child` VALUES (20, NULL, NULL, 17, 3, 400, 2, 0, '2025-09-25 14:38:28', '2025-10-31 10:22:46');
INSERT INTO `sub_material_bom_child` VALUES (21, NULL, NULL, 18, 3, 900, 1, 0, '2025-09-25 14:39:31', '2025-10-31 10:22:44');
INSERT INTO `sub_material_bom_child` VALUES (22, NULL, NULL, 19, 2, 600, 1, 0, '2025-09-25 14:39:45', '2025-10-31 10:22:41');
INSERT INTO `sub_material_bom_child` VALUES (23, NULL, NULL, 19, 3, 700, 2, 0, '2025-09-25 14:39:45', '2025-10-31 10:22:43');
INSERT INTO `sub_material_bom_child` VALUES (24, NULL, NULL, 20, 2, 198, 1, 0, '2025-09-25 14:44:26', '2025-10-31 10:22:39');
INSERT INTO `sub_material_bom_child` VALUES (25, NULL, NULL, 20, 2, 158, 2, 0, '2025-09-25 14:44:26', '2025-10-31 10:22:41');
INSERT INTO `sub_material_bom_child` VALUES (26, NULL, NULL, 21, 2, 485, 1, 0, '2025-09-25 14:44:36', '2025-10-31 10:22:38');
INSERT INTO `sub_material_bom_child` VALUES (27, NULL, NULL, 22, 4, 5, 1, 0, '2025-10-18 14:29:06', '2025-10-31 10:22:37');
INSERT INTO `sub_material_bom_child` VALUES (29, NULL, NULL, 24, 5, 1, 1, 0, '2025-10-18 15:08:30', '2025-10-31 10:22:35');
INSERT INTO `sub_material_bom_child` VALUES (31, NULL, NULL, 23, 4, 1, 1, 0, '2025-10-19 15:37:50', '2025-12-03 09:06:33');
INSERT INTO `sub_material_bom_child` VALUES (34, NULL, NULL, 25, 3, 30, 1, 0, '2025-10-21 21:04:49', '2025-10-31 10:22:25');
INSERT INTO `sub_material_bom_child` VALUES (36, NULL, NULL, 25, 2, 60, 2, 0, '2025-10-21 21:04:49', '2025-10-31 10:22:25');
INSERT INTO `sub_material_bom_child` VALUES (37, NULL, NULL, 25, 3, 40, 3, 0, '2025-10-21 21:23:26', '2025-10-31 10:22:26');
INSERT INTO `sub_material_bom_child` VALUES (38, NULL, NULL, 25, 2, 50, 4, 0, '2025-10-21 21:23:26', '2025-10-31 10:22:33');
INSERT INTO `sub_material_bom_child` VALUES (39, NULL, NULL, 26, 6, 1, 1, 0, '2025-10-30 16:49:20', '2025-10-31 10:22:24');
INSERT INTO `sub_material_bom_child` VALUES (40, NULL, NULL, 27, 7, 1, 1, 0, '2025-10-30 16:49:58', '2025-10-31 10:22:22');
INSERT INTO `sub_material_bom_child` VALUES (41, NULL, NULL, 28, 8, 1, 1, 0, '2025-10-30 16:54:25', '2025-10-31 10:22:19');
INSERT INTO `sub_material_bom_child` VALUES (42, NULL, NULL, 28, 9, 1, 2, 0, '2025-10-30 16:54:25', '2025-10-31 10:22:20');
INSERT INTO `sub_material_bom_child` VALUES (43, NULL, NULL, 29, 9, 3, 1, 0, '2025-10-30 16:55:14', '2025-10-31 10:22:18');
INSERT INTO `sub_material_bom_child` VALUES (44, NULL, NULL, 30, 10, 1, 1, 0, '2025-10-30 16:58:07', '2025-12-03 10:33:36');
INSERT INTO `sub_material_bom_child` VALUES (45, NULL, NULL, 30, 9, 2, 2, 0, '2025-10-30 16:58:07', '2025-10-31 10:22:07');
INSERT INTO `sub_material_bom_child` VALUES (46, NULL, NULL, 30, 11, 1, 3, 0, '2025-10-30 16:58:07', '2025-10-31 10:22:08');
INSERT INTO `sub_material_bom_child` VALUES (47, NULL, NULL, 30, 12, 1, 4, 0, '2025-10-30 16:58:07', '2025-10-31 10:22:11');
INSERT INTO `sub_material_bom_child` VALUES (48, NULL, NULL, 31, 13, 1, 1, 0, '2025-10-30 16:59:47', '2025-10-31 10:22:03');
INSERT INTO `sub_material_bom_child` VALUES (49, NULL, NULL, 31, 12, 1, 2, 0, '2025-10-30 16:59:47', '2025-10-31 10:22:06');
INSERT INTO `sub_material_bom_child` VALUES (50, NULL, NULL, 32, 14, 1, 1, 0, '2025-10-30 17:01:11', '2025-10-31 10:22:01');
INSERT INTO `sub_material_bom_child` VALUES (51, NULL, NULL, 33, 15, 1, 1, 0, '2025-10-30 17:01:55', '2025-10-31 10:22:00');
INSERT INTO `sub_material_bom_child` VALUES (52, NULL, NULL, 34, 16, 1, 1, 0, '2025-10-30 17:02:54', '2025-10-31 10:21:54');
INSERT INTO `sub_material_bom_child` VALUES (53, NULL, NULL, 34, 17, 1, 2, 0, '2025-10-30 17:02:54', '2025-10-31 10:22:00');
INSERT INTO `sub_material_bom_child` VALUES (54, NULL, NULL, 35, 18, 1, 1, 0, '2025-10-30 17:04:53', '2025-10-31 10:21:50');
INSERT INTO `sub_material_bom_child` VALUES (55, NULL, NULL, 35, 12, 3, 2, 0, '2025-10-30 17:04:53', '2025-10-31 10:21:51');
INSERT INTO `sub_material_bom_child` VALUES (56, NULL, NULL, 35, 20, 2, 3, 0, '2025-10-30 17:04:53', '2025-10-31 10:21:53');
INSERT INTO `sub_material_bom_child` VALUES (57, NULL, NULL, 36, 19, 1, 1, 0, '2025-10-30 17:05:52', '2025-12-03 09:06:40');
INSERT INTO `sub_material_bom_child` VALUES (58, NULL, NULL, 37, 21, 1, 1, 0, '2025-10-30 17:07:19', '2025-12-03 09:06:41');
INSERT INTO `sub_material_bom_child` VALUES (59, NULL, NULL, 37, 23, 1, 2, 0, '2025-10-30 17:07:19', '2025-10-31 10:21:45');
INSERT INTO `sub_material_bom_child` VALUES (60, NULL, NULL, 38, 22, 1, 1, 0, '2025-10-30 17:07:53', '2025-12-03 10:33:35');
INSERT INTO `sub_material_bom_child` VALUES (61, NULL, NULL, 39, 27, 2, 1, 1, '2025-10-30 17:12:29', '2025-12-03 09:50:51');
INSERT INTO `sub_material_bom_child` VALUES (62, NULL, NULL, 40, 24, 1, 3, 0, '2025-10-30 17:12:55', '2025-12-03 09:06:43');
INSERT INTO `sub_material_bom_child` VALUES (63, NULL, NULL, 41, 25, 1, 3, 0, '2025-10-30 17:13:58', '2025-12-03 09:06:43');
INSERT INTO `sub_material_bom_child` VALUES (64, NULL, NULL, 41, 26, 1, 4, 0, '2025-10-30 17:13:58', '2025-12-03 09:06:44');
INSERT INTO `sub_material_bom_child` VALUES (65, NULL, NULL, 41, 25, 1, 1, 0, '2025-11-11 12:30:55', '2025-12-03 09:06:45');
INSERT INTO `sub_material_bom_child` VALUES (66, NULL, NULL, 41, 26, 1, 2, 0, '2025-11-13 10:31:41', '2025-12-03 09:06:45');
INSERT INTO `sub_material_bom_child` VALUES (67, NULL, NULL, 40, 24, 1, 1, 0, '2025-11-14 14:44:48', '2025-12-03 09:06:46');
INSERT INTO `sub_material_bom_child` VALUES (68, NULL, NULL, 40, 24, 1, 2, 0, '2025-11-14 14:51:26', '2025-12-03 09:06:47');

-- ----------------------------
-- Table structure for sub_material_code
-- ----------------------------
DROP TABLE IF EXISTS `sub_material_code`;
CREATE TABLE `sub_material_code`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键ID',
  `user_id` int(5) NULL DEFAULT NULL COMMENT '发布用户id',
  `company_id` int(5) NULL DEFAULT NULL COMMENT '企业id',
  `material_code` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '材料编码',
  `material_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '材料名称',
  `category` varchar(5) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '材料类别',
  `model` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '型号',
  `specification` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '规格',
  `other_features` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '其它特性',
  `usage_unit` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '使用单位',
  `purchase_unit` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '采购单位',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '1：未删除；0：已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '记录创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '记录最后更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 28 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '材料编码基础信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_material_code
-- ----------------------------
INSERT INTO `sub_material_code` VALUES (2, 1, 1, '123', '121', '', '2121', '21', '2121', '', '', 1, '2025-07-08 15:36:33', '2025-11-28 11:15:01');
INSERT INTO `sub_material_code` VALUES (3, 1, 1, '789', '555', '', '5356', '35353', '353', '', '', 1, '2025-08-17 09:38:16', '2025-11-28 11:15:03');
INSERT INTO `sub_material_code` VALUES (4, 6, 3, 'H0101-0089', '车首管', '50', 'JHD-AT-0074*146L', 'JHD-AT-0074*146L', '', '51', '54', 1, '2025-10-18 05:10:39', '2025-12-01 08:59:21');
INSERT INTO `sub_material_code` VALUES (5, 6, 3, 'H0201-0053', '五通', '50', 'φ43*4.6T*100L JHD-AK-002G偏心铣弧口', 'φ43*4.6T*100L JHD-AK-002G偏心铣弧口', '', '51', '54', 1, '2025-10-18 14:27:16', '2025-12-01 08:59:48');
INSERT INTO `sub_material_code` VALUES (6, 6, 3, 'M0101-0668', '中管', '50', 'φ40.8*2.2T*410L', 'φ40.8*2.2T*410L', '', '51', '54', 1, '2025-10-18 14:35:20', '2025-12-01 09:08:42');
INSERT INTO `sub_material_code` VALUES (7, 6, 3, 'M0101-1123', '手提管', '50', 'φ22.2*2.0T*200L', 'φ22.2*2.0T*200L', '', '51', '54', 1, '2025-10-27 16:17:44', '2025-12-01 09:08:54');
INSERT INTO `sub_material_code` VALUES (8, 6, 3, 'M0101-0565', '下管', '50', 'φ28.6*2.0T*220L', 'φ28.6*2.0T*220L', '', '51', '54', 1, '2025-10-27 16:19:44', '2025-12-01 09:07:00');
INSERT INTO `sub_material_code` VALUES (9, 6, 3, 'M0103-0015', '过线管', '50', '方27*17*2000L(CM-15114)(成品15L,一分百)', '方27*17*2000L(CM-15114)(成品15L,一分百)', '', '51', '54', 1, '2025-10-27 16:21:05', '2025-12-01 09:09:07');
INSERT INTO `sub_material_code` VALUES (10, 6, 3, 'M0103-0234', '主梁管', '50', '方121*65*600L', '方121*65*600L', '', '51', '54', 1, '2025-10-27 16:23:05', '2025-12-01 09:09:19');
INSERT INTO `sub_material_code` VALUES (11, 6, 3, 'H0801-0004', '水壶螺母', '49', 'YD008-044（M4）', 'YD008-044（M4）', '20个/盒', '47', '55', 1, '2025-10-27 16:28:28', '2025-12-01 09:02:54');
INSERT INTO `sub_material_code` VALUES (12, 6, 3, 'H0703-0001', '油压线扣', '49', 'YD007-004', 'YD007-004', '100个/盒', '47', '55', 1, '2025-10-27 16:29:45', '2025-12-01 09:02:02');
INSERT INTO `sub_material_code` VALUES (13, 6, 3, 'M0101-0635', '后上叉L', '50', 'φ19*2.0T*455L', 'φ19*2.0T*455L', '', '51', '54', 1, '2025-10-28 10:43:21', '2025-12-01 09:08:17');
INSERT INTO `sub_material_code` VALUES (14, 6, 3, 'M0101-0636', '后上叉R', '50', 'φ19*2.0T*455L', 'φ19*2.0T*455L', '', '51', '54', 1, '2025-10-28 10:44:33', '2025-12-01 09:08:29');
INSERT INTO `sub_material_code` VALUES (15, 6, 3, 'M0101-0019', '上枝杆', '49', 'φ19*1.8T*105L（±1MM)', 'φ19*1.8T*105L（±1MM)', '', '51', '54', 1, '2025-10-28 10:45:38', '2025-12-01 09:07:21');
INSERT INTO `sub_material_code` VALUES (16, 6, 3, 'M0101-0020', '下枝杆', '50', 'φ19*1.8T*105L（±1MM)', 'φ19*1.8T*105L（±1MM)', '', '51', '54', 1, '2025-10-28 10:46:52', '2025-12-01 09:07:34');
INSERT INTO `sub_material_code` VALUES (17, 6, 3, 'H0801-0001', '硬焊螺母', '49', 'YD008-006 M5*9L普通', 'YD008-006 M5*9L普通', '20个/盒', '47', '55', 1, '2025-10-28 10:50:20', '2025-12-01 09:02:34');
INSERT INTO `sub_material_code` VALUES (18, 6, 3, 'M0101-0444', '后下叉R', '50', 'φ22.2*2.0*420L', 'φ22.2*2.0*420L', '', '51', '54', 1, '2025-10-28 10:51:34', '2025-12-01 09:07:52');
INSERT INTO `sub_material_code` VALUES (19, 6, 3, 'M0101-0445', '后下叉L', '50', 'φ22.2*2.0*420L', 'φ22.2*2.0*420L', '', '51', '54', 1, '2025-10-28 10:52:42', '2025-12-01 09:08:04');
INSERT INTO `sub_material_code` VALUES (20, 6, 3, 'H0702-0001', '止栓', '49', 'YD004-026', 'YD004-026', '50个/盒', '47', '55', 1, '2025-10-28 10:53:46', '2025-12-01 09:01:36');
INSERT INTO `sub_material_code` VALUES (21, 6, 3, 'H0302-0013', '左勾爪', '50', 'YD001-003DS-45度', 'YD001-003DS-45度', '', '51', '54', 1, '2025-10-28 11:01:29', '2025-12-01 09:00:03');
INSERT INTO `sub_material_code` VALUES (22, 6, 3, 'H0302-0014', '右勾爪', '50', 'YD001-003DS-45度', 'YD001-003DS-45度', '', '51', '54', 1, '2025-10-28 11:02:37', '2025-12-01 09:00:21');
INSERT INTO `sub_material_code` VALUES (23, 6, 3, 'H1202-0012', '边支撑', '49', 'JHD-TC18', 'JHD-TC18', '', '57', '57', 1, '2025-10-28 11:03:49', '2025-12-01 09:06:12');
INSERT INTO `sub_material_code` VALUES (24, 6, 3, 'H0401-0036', '折叠器', '49', 'ZHD-DX160-T01/02-Z', 'ZHD-DX160-T01/02-Z', '', '51', '51', 1, '2025-10-28 11:05:05', '2025-12-01 09:00:38');
INSERT INTO `sub_material_code` VALUES (25, 6, 3, 'H1102-0099', '加强片', '49', 'JHD-BQ-211', 'JHD-BQ-211', '10个/包', '47', '56', 1, '2025-10-28 11:06:14', '2025-12-01 09:03:53');
INSERT INTO `sub_material_code` VALUES (26, 6, 3, 'H1201-0001', '支撑棒', '49', 'JS-ZJ-001*120L', 'JS-ZJ-001*120L', '', '57', '57', 1, '2025-10-28 11:07:19', '2025-12-01 09:05:32');
INSERT INTO `sub_material_code` VALUES (27, 6, 3, 'H0802-0001', '货架螺母', '49', 'YD008-021 M5', 'YD008-021 M5', '20个/盒', '47', '55', 1, '2025-10-30 17:11:30', '2025-12-01 09:03:15');

-- ----------------------------
-- Table structure for sub_material_ment
-- ----------------------------
DROP TABLE IF EXISTS `sub_material_ment`;
CREATE TABLE `sub_material_ment`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键ID',
  `company_id` int(11) NULL DEFAULT NULL COMMENT '企业id',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '发布的用户id',
  `quote_id` int(11) NULL DEFAULT NULL COMMENT '报价单ID',
  `material_bom_id` int(11) NULL DEFAULT NULL COMMENT '材料BOM ID',
  `seq_id` int(11) NULL DEFAULT NULL COMMENT '工序ID',
  `print_id` int(11) NULL DEFAULT NULL COMMENT '打印的id',
  `notice_id` int(11) NULL DEFAULT NULL COMMENT '生产订单ID',
  `supplier_id` int(11) NULL DEFAULT NULL COMMENT '供应商ID',
  `supplier_code` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商编码',
  `supplier_abbreviation` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商名称',
  `product_id` int(11) NULL DEFAULT NULL COMMENT '产品Id',
  `product_code` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '产品编码',
  `product_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '产品名称',
  `material_id` int(11) NULL DEFAULT NULL COMMENT '材料ID',
  `material_code` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '材料编码',
  `material_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '材料名称',
  `model_spec` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '型号&规格',
  `other_features` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '其它特性',
  `unit` int(11) NULL DEFAULT NULL COMMENT '单位',
  `usage_unit` int(11) NULL DEFAULT NULL COMMENT '使用单位',
  `price` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '单价',
  `order_number` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '预计数量',
  `number` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '实际数量',
  `delivery_time` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '交货时间',
  `order_id` int(11) NULL DEFAULT NULL COMMENT '采购单ID',
  `is_buying` int(1) NULL DEFAULT 1 COMMENT '是否已生成采购单：1未生成，0已生成',
  `is_houser` int(1) NULL DEFAULT 1 COMMENT '是否已入库：1未入库，0已入库',
  `apply_id` int(11) NULL DEFAULT NULL COMMENT '申请人ID',
  `apply_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '申请人名称',
  `apply_time` timestamp NULL DEFAULT NULL COMMENT '申请时间',
  `step` int(2) NULL DEFAULT 0 COMMENT '审核当前在第几步，默认0，每审核一步加1',
  `status` int(11) NULL DEFAULT 0 COMMENT '状态（0审批中/1通过/2拒绝/3反审核/4待提交）',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '采购作业表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_material_ment
-- ----------------------------
INSERT INTO `sub_material_ment` VALUES (2, 3, 15, 4, 37, NULL, NULL, 11, 6, 'GA001', '晶鑫昌', 20, 'WA-A00001', '0611铝车架', 21, 'H0302-0013', '左勾爪', 'YD001-003DS-45度', NULL, 51, 51, '2.8', NULL, '18000', '2025-12-28', 2, 0, 1, 15, '粟云', '2025-11-29 16:19:07', 2, 1, 1, '2025-11-29 16:19:07', '2025-11-29 16:20:38');
INSERT INTO `sub_material_ment` VALUES (3, 3, 15, NULL, 30, NULL, NULL, 11, 6, 'GA001', '晶鑫昌', 20, 'WA-A00001', '0611铝车架', 10, 'M0103-0234', '主梁管', '方121*65*600L', NULL, 54, 51, '2.8', NULL, '18000', '2025-12-28', 3, 0, 1, 15, '粟云', '2025-12-01 15:59:12', 2, 1, 1, '2025-12-01 15:59:12', '2025-12-01 16:00:13');
INSERT INTO `sub_material_ment` VALUES (8, 3, 6, NULL, 39, 61, NULL, 11, 7, NULL, NULL, 20, NULL, NULL, 27, 'H0802-0001', '货架螺母', 'YD008-021 M5', '20个/盒', 55, 47, '2.9', NULL, '18000', '2025-12-28', 1, 1, 1, 6, '徐庆华', '2025-12-03 13:43:05', 0, 0, 1, '2025-12-03 09:50:50', '2025-12-03 13:43:05');

-- ----------------------------
-- Table structure for sub_material_order
-- ----------------------------
DROP TABLE IF EXISTS `sub_material_order`;
CREATE TABLE `sub_material_order`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `company_id` int(11) NULL DEFAULT NULL COMMENT '公司ID',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '用户ID',
  `notice_id` int(11) NULL DEFAULT NULL COMMENT '生产订单ID',
  `notice` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生产订单号',
  `supplier_id` int(11) NULL DEFAULT NULL COMMENT '供应商ID',
  `supplier_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商编码',
  `supplier_abbreviation` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商名称',
  `product_id` int(11) NULL DEFAULT NULL COMMENT '产品ID',
  `product_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '产品编码',
  `product_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '产品名称',
  `no` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单编号',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '申购单' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_material_order
-- ----------------------------
INSERT INTO `sub_material_order` VALUES (2, 3, 15, 11, 'DD2511001', 6, 'GA001', '晶鑫昌', 20, 'WA-A00001', '0611铝车架', 'CG032511001', 1, '2025-11-29 16:20:38', '2025-11-29 16:21:58');
INSERT INTO `sub_material_order` VALUES (3, 3, 15, 11, 'DD2511001', 6, 'GA001', '晶鑫昌', 20, 'WA-A00001', '0611铝车架', 'CG032512001', 1, '2025-12-01 16:00:13', '2025-12-01 16:01:10');

-- ----------------------------
-- Table structure for sub_material_quote
-- ----------------------------
DROP TABLE IF EXISTS `sub_material_quote`;
CREATE TABLE `sub_material_quote`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键ID',
  `company_id` int(11) NOT NULL COMMENT '企业id',
  `user_id` int(11) NOT NULL COMMENT '发布的用户id',
  `supplier_id` int(11) NULL DEFAULT NULL COMMENT '供应商id',
  `material_id` int(11) NOT NULL COMMENT '材料编码ID',
  `price` decimal(11, 1) NULL DEFAULT NULL COMMENT '单价',
  `unit` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '采购单位',
  `delivery` int(5) NULL DEFAULT NULL COMMENT '送货方式',
  `packaging` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '包装要求',
  `transaction_currency` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '交易币别',
  `transaction_method` int(5) NULL DEFAULT NULL COMMENT '交易方式',
  `other_transaction_terms` varchar(5) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '结算周期',
  `other_text` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '其他结算周期',
  `invoice` int(5) NULL DEFAULT NULL COMMENT '税票要求',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '材料报价信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_material_quote
-- ----------------------------
INSERT INTO `sub_material_quote` VALUES (4, 3, 15, 6, 21, 2.8, '51', 35, '', 'RMB', 27, '31', '', 44, 1, '2025-11-29 15:59:42', '2025-11-29 16:06:16');

-- ----------------------------
-- Table structure for sub_no_encoding
-- ----------------------------
DROP TABLE IF EXISTS `sub_no_encoding`;
CREATE TABLE `sub_no_encoding`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `company_id` int(11) NULL DEFAULT NULL COMMENT '企业ID',
  `no` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '编号',
  `print_type` varchar(5) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '业务类型',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_no_encoding
-- ----------------------------
INSERT INTO `sub_no_encoding` VALUES (8, 3, 'CG032511001', 'CG', '2025-11-29 16:21:58', '2025-11-29 16:21:58');
INSERT INTO `sub_no_encoding` VALUES (9, 3, 'WW032511001', 'WW', '2025-11-29 16:31:18', '2025-11-29 16:31:18');
INSERT INTO `sub_no_encoding` VALUES (10, 3, 'MR032511001', 'MR', '2025-11-29 16:53:11', '2025-11-29 16:53:11');
INSERT INTO `sub_no_encoding` VALUES (11, 3, 'PR032511001', 'PR', '2025-11-29 17:04:57', '2025-11-29 17:04:57');
INSERT INTO `sub_no_encoding` VALUES (12, 3, 'CG032512001', 'CG', '2025-12-01 16:01:10', '2025-12-01 16:01:10');

-- ----------------------------
-- Table structure for sub_operation_history
-- ----------------------------
DROP TABLE IF EXISTS `sub_operation_history`;
CREATE TABLE `sub_operation_history`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '历史ID',
  `company_id` int(11) NOT NULL COMMENT '所属企业id',
  `user_id` int(11) NOT NULL COMMENT '操作人ID',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作用户名称',
  `operation_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作类型（新增 / 修改 / 删除 / 查询等）',
  `module` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作模块（如 “员工管理”“客户信息”）',
  `desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '操作描述（如 “新增员工编码：EMP001”）',
  `data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '操作数据（JSON 格式，存储前后数据对比）',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 206 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户操作日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_operation_history
-- ----------------------------
INSERT INTO `sub_operation_history` VALUES (44, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-11-28 06:44:07');
INSERT INTO `sub_operation_history` VALUES (45, 3, 6, '徐庆华', 'update', '材料BOM', '修改材料BOM，产品编码：WA-A00001，部件编码：X001，材料编码：H0101-0089', '{\"newData\":{\"id\":23,\"product_id\":20,\"part_id\":21,\"children\":[{\"id\":31,\"material_bom_id\":23,\"material_id\":4,\"number\":1,\"process_index\":1,\"material\":{\"id\":4,\"material_code\":\"H0101-0089\",\"material_name\":\"车首管\",\"specification\":\"JHD-AT-0074*146L\"}}],\"sort\":\"1\",\"archive\":0}}', '2025-11-28 07:19:42');
INSERT INTO `sub_operation_history` VALUES (46, 3, 6, '徐庆华', 'update', '材料BOM', '修改材料BOM，产品编码：WA-A00001，部件编码：X013，材料编码：M0101-1123', '{\"newData\":{\"id\":27,\"product_id\":20,\"part_id\":33,\"children\":[{\"id\":40,\"material_bom_id\":27,\"material_id\":7,\"number\":1,\"process_index\":1,\"material\":{\"id\":7,\"material_code\":\"M0101-1123\",\"material_name\":\"手提管\",\"specification\":\"φ22.2*2.0T*200L\"}}],\"sort\":\"4\",\"archive\":0}}', '2025-11-28 07:19:57');
INSERT INTO `sub_operation_history` VALUES (47, 3, 6, '徐庆华', 'update', '材料BOM', '修改材料BOM，产品编码：WA-A00001，部件编码：X005，材料编码：M0101-0565,M0103-0015', '{\"newData\":{\"id\":28,\"product_id\":20,\"part_id\":25,\"children\":[{\"id\":41,\"material_bom_id\":28,\"material_id\":8,\"number\":1,\"process_index\":1,\"material\":{\"id\":8,\"material_code\":\"M0101-0565\",\"material_name\":\"下管\",\"specification\":\"φ28.6*2.0T*220L\"}},{\"id\":42,\"material_bom_id\":28,\"material_id\":9,\"number\":1,\"process_index\":2,\"material\":{\"id\":9,\"material_code\":\"M0103-0015\",\"material_name\":\"过线管\",\"specification\":\"方27*17*2000L(CM-15114)(成品15L,一分百)\"}}],\"sort\":\"5\",\"archive\":0}}', '2025-11-28 07:20:44');
INSERT INTO `sub_operation_history` VALUES (48, 3, 6, '徐庆华', 'update', '材料BOM', '修改材料BOM，产品编码：WA-A00001，部件编码：X018，材料编码：M0103-0015', '{\"newData\":{\"id\":29,\"product_id\":20,\"part_id\":38,\"children\":[{\"id\":43,\"material_bom_id\":29,\"material_id\":9,\"number\":3,\"process_index\":1,\"material\":{\"id\":9,\"material_code\":\"M0103-0015\",\"material_name\":\"过线管\",\"specification\":\"方27*17*2000L(CM-15114)(成品15L,一分百)\"}}],\"sort\":\"6\",\"archive\":0}}', '2025-11-28 07:21:13');
INSERT INTO `sub_operation_history` VALUES (49, 3, 6, '徐庆华', 'update', '材料BOM', '修改材料BOM，产品编码：WA-A00001，部件编码：X002，材料编码：M0103-0234,M0103-0015,H0801-0004,H0703-0001', '{\"newData\":{\"id\":30,\"product_id\":20,\"part_id\":22,\"children\":[{\"id\":44,\"material_bom_id\":30,\"material_id\":10,\"number\":1,\"process_index\":1,\"material\":{\"id\":10,\"material_code\":\"M0103-0234\",\"material_name\":\"主梁管\",\"specification\":\"方121*65*600L\"}},{\"id\":45,\"material_bom_id\":30,\"material_id\":9,\"number\":2,\"process_index\":2,\"material\":{\"id\":9,\"material_code\":\"M0103-0015\",\"material_name\":\"过线管\",\"specification\":\"方27*17*2000L(CM-15114)(成品15L,一分百)\"}},{\"id\":46,\"material_bom_id\":30,\"material_id\":11,\"number\":1,\"process_index\":3,\"material\":{\"id\":11,\"material_code\":\"H0801-0004\",\"material_name\":\"水壶螺母\",\"specification\":\"YD008-044（M4）\"}},{\"id\":47,\"material_bom_id\":30,\"material_id\":12,\"number\":1,\"process_index\":4,\"material\":{\"id\":12,\"material_code\":\"H0703-0001\",\"material_name\":\"油压线扣\",\"specification\":\"YD007-004\"}}],\"sort\":\"7\",\"archive\":0}}', '2025-11-28 07:21:23');
INSERT INTO `sub_operation_history` VALUES (50, 3, 6, '徐庆华', 'update', '材料BOM', '修改材料BOM，产品编码：WA-A00001，部件编码：X009，材料编码：M0101-0635,H0703-0001', '{\"newData\":{\"id\":31,\"product_id\":20,\"part_id\":29,\"children\":[{\"id\":48,\"material_bom_id\":31,\"material_id\":13,\"number\":1,\"process_index\":1,\"material\":{\"id\":13,\"material_code\":\"M0101-0635\",\"material_name\":\"后上叉L\",\"specification\":\"φ19*2.0T*455L\"}},{\"id\":49,\"material_bom_id\":31,\"material_id\":12,\"number\":1,\"process_index\":2,\"material\":{\"id\":12,\"material_code\":\"H0703-0001\",\"material_name\":\"油压线扣\",\"specification\":\"YD007-004\"}}],\"sort\":\"8\",\"archive\":0}}', '2025-11-28 07:21:32');
INSERT INTO `sub_operation_history` VALUES (51, 3, 6, '徐庆华', 'update', '材料BOM', '修改材料BOM，产品编码：WA-A00001，部件编码：X008，材料编码：M0101-0636', '{\"newData\":{\"id\":32,\"product_id\":20,\"part_id\":28,\"children\":[{\"id\":50,\"material_bom_id\":32,\"material_id\":14,\"number\":1,\"process_index\":1,\"material\":{\"id\":14,\"material_code\":\"M0101-0636\",\"material_name\":\"后上叉R\",\"specification\":\"φ19*2.0T*455L\"}}],\"sort\":\"9\",\"archive\":0}}', '2025-11-28 07:22:11');
INSERT INTO `sub_operation_history` VALUES (52, 3, 6, '徐庆华', 'update', '材料BOM', '修改材料BOM，产品编码：WA-A00001，部件编码：X015，材料编码：M0101-0019', '{\"newData\":{\"id\":33,\"product_id\":20,\"part_id\":35,\"children\":[{\"id\":51,\"material_bom_id\":33,\"material_id\":15,\"number\":1,\"process_index\":1,\"material\":{\"id\":15,\"material_code\":\"M0101-0019\",\"material_name\":\"上枝杆\",\"specification\":\"φ19*1.8T*105L（±1MM)\"}}],\"sort\":\"10\",\"archive\":0}}', '2025-11-28 07:22:25');
INSERT INTO `sub_operation_history` VALUES (53, 3, 6, '徐庆华', 'update', '材料BOM', '修改材料BOM，产品编码：WA-A00001，部件编码：X016，材料编码：M0101-0020,H0801-0001', '{\"newData\":{\"id\":34,\"product_id\":20,\"part_id\":36,\"children\":[{\"id\":52,\"material_bom_id\":34,\"material_id\":16,\"number\":1,\"process_index\":1,\"material\":{\"id\":16,\"material_code\":\"M0101-0020\",\"material_name\":\"下枝杆\",\"specification\":\"φ19*1.8T*105L（±1MM)\"}},{\"id\":53,\"material_bom_id\":34,\"material_id\":17,\"number\":1,\"process_index\":2,\"material\":{\"id\":17,\"material_code\":\"H0801-0001\",\"material_name\":\"硬焊螺母\",\"specification\":\"YD008-006 M5*9L普通\"}}],\"sort\":\"11\",\"archive\":0}}', '2025-11-28 07:22:34');
INSERT INTO `sub_operation_history` VALUES (54, 3, 6, '徐庆华', 'update', '生产制程', '修改生产制程：名称：后段组', '{\"newData\":{\"id\":11,\"name\":\"后段组\",\"sort\":\"0\"}}', '2025-11-28 07:29:45');
INSERT INTO `sub_operation_history` VALUES (55, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-11-28 07:34:21');
INSERT INTO `sub_operation_history` VALUES (56, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-11-28 07:34:57');
INSERT INTO `sub_operation_history` VALUES (57, 3, 6, '徐庆华', 'update', '客户信息', '修改客户编码：KA001', '{\"newData\":{\"id\":4,\"customer_code\":\"KA001\",\"customer_abbreviation\":\"旭欧\",\"contact_person\":\"潘总\",\"contact_information\":\"13812345678\",\"company_full_name\":\"东莞市旭欧精密五金有限公司\",\"company_address\":\"东莞市石碣镇单屋村\",\"delivery_address\":\"公司材料仓\",\"tax_registration_number\":\"SJ123456\",\"transaction_method\":27,\"transaction_currency\":\"人民币\",\"other_transaction_terms\":26,\"other_text\":null}}', '2025-11-28 07:35:06');
INSERT INTO `sub_operation_history` VALUES (58, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-11-28 07:35:36');
INSERT INTO `sub_operation_history` VALUES (59, 3, 6, '徐庆华', 'update', '客户信息', '修改客户编码：KA001', '{\"newData\":{\"id\":4,\"customer_code\":\"KA001\",\"customer_abbreviation\":\"旭欧\",\"contact_person\":\"潘总\",\"contact_information\":\"13812345678\",\"company_full_name\":\"东莞市旭欧精密五金有限公司\",\"company_address\":\"东莞市石碣镇单屋村\",\"delivery_address\":\"公司材料仓\",\"tax_registration_number\":\"SJ123456\",\"transaction_method\":27,\"transaction_currency\":\"人民币\",\"other_transaction_terms\":30,\"other_text\":null}}', '2025-11-28 07:35:44');
INSERT INTO `sub_operation_history` VALUES (60, 3, 6, '徐庆华', 'update', '客户信息', '修改客户编码：KA001', '{\"newData\":{\"id\":4,\"customer_code\":\"KA001\",\"customer_abbreviation\":\"旭欧\",\"contact_person\":\"潘总\",\"contact_information\":\"13812345678\",\"company_full_name\":\"东莞市旭欧精密五金有限公司\",\"company_address\":\"东莞市石碣镇单屋村\",\"delivery_address\":\"公司材料仓\",\"tax_registration_number\":\"SJ123456\",\"transaction_method\":27,\"transaction_currency\":\"人民币\",\"other_transaction_terms\":31,\"other_text\":null}}', '2025-11-28 07:36:08');
INSERT INTO `sub_operation_history` VALUES (61, 3, 6, '徐庆华', 'update', '客户信息', '修改客户编码：KA002', '{\"newData\":{\"id\":5,\"customer_code\":\"KA002\",\"customer_abbreviation\":\"鑫宇\",\"contact_person\":\"王总\",\"contact_information\":\"13712345678\",\"company_full_name\":\"东莞市鑫宇五金制品厂\",\"company_address\":\"东莞市万江区官桥窖村\",\"delivery_address\":\"高埗镇合鑫喷漆厂\",\"tax_registration_number\":\"WJ123456\",\"transaction_method\":29,\"transaction_currency\":\"人民币\",\"other_transaction_terms\":31,\"other_text\":null}}', '2025-11-28 07:36:21');
INSERT INTO `sub_operation_history` VALUES (62, 3, 6, '徐庆华', 'add', '销售订单', '新增销售订单，客户订单号：CGO12511001', '{\"newData\":{\"rece_time\":\"2025-11-28\",\"customer_id\":4,\"customer_order\":\"CGO12511001\",\"product_id\":20,\"product_req\":\"1.字码2510001-2510800；2.车架补土后烤漆\",\"order_number\":\"18000\",\"unit\":51,\"delivery_time\":\"2025-12-30\",\"goods_time\":\"\",\"goods_address\":\"公司材料仓\"}}', '2025-11-28 07:40:58');
INSERT INTO `sub_operation_history` VALUES (63, 3, 6, '徐庆华', 'update', '销售订单', '修改销售订单，客户订单号：CGO12511001', '{\"newData\":{\"id\":5,\"rece_time\":\"2025-11-28\",\"customer_order\":\"CGO12511001\",\"product_req\":\"1.字码2510001-2510800；2.车架补土后烤漆\",\"order_number\":\"18000\",\"unit\":52,\"delivery_time\":\"2025-12-30\",\"goods_time\":\"\",\"goods_address\":\"公司材料仓\",\"is_sale\":1,\"created_at\":\"2025-11-28\",\"customer\":{\"id\":4,\"customer_code\":\"KA001\",\"customer_abbreviation\":\"旭欧\"},\"product\":{\"id\":20,\"product_code\":\"WA-A00001\",\"product_name\":\"0611铝车架\",\"drawing\":\"0611\",\"component_structure\":\"整车结构\",\"model\":\"城市代步Q1\",\"specification\":\"36寸\",\"other_features\":\"折叠型\"},\"notice\":null,\"saleCancel\":null,\"customer_id\":4,\"product_id\":20}}', '2025-11-28 07:41:48');
INSERT INTO `sub_operation_history` VALUES (64, 3, 6, '徐庆华', 'add', '销售订单', '新增销售订单，客户订单号：CR022511005', '{\"newData\":{\"rece_time\":\"2025-11-28\",\"customer_id\":5,\"customer_order\":\"CR022511005\",\"product_id\":20,\"product_req\":\"1.字码2510001-2510800；2.车架补土后烤漆\",\"order_number\":\"7500\",\"unit\":52,\"delivery_time\":\"2025-12-28\",\"goods_time\":\"\",\"goods_address\":\"高埗镇合鑫喷漆厂\"}}', '2025-11-28 07:43:36');
INSERT INTO `sub_operation_history` VALUES (65, 3, 6, '徐庆华', 'update', '销售订单', '修改销售订单，客户订单号：CG022511005', '{\"newData\":{\"id\":6,\"rece_time\":\"2025-11-28\",\"customer_order\":\"CG022511005\",\"product_req\":\"1.字码2510001-2510800；2.车架补土后烤漆\",\"order_number\":\"7500\",\"unit\":52,\"delivery_time\":\"2025-12-28\",\"goods_time\":\"\",\"goods_address\":\"高埗镇合鑫喷漆厂\",\"is_sale\":1,\"created_at\":\"2025-11-28\",\"customer\":{\"id\":5,\"customer_code\":\"KA002\",\"customer_abbreviation\":\"鑫宇\"},\"product\":{\"id\":20,\"product_code\":\"WA-A00001\",\"product_name\":\"0611铝车架\",\"drawing\":\"0611\",\"component_structure\":\"整车结构\",\"model\":\"城市代步Q1\",\"specification\":\"36寸\",\"other_features\":\"折叠型\"},\"notice\":null,\"saleCancel\":null,\"customer_id\":5,\"product_id\":20}}', '2025-11-28 07:44:24');
INSERT INTO `sub_operation_history` VALUES (66, 3, 6, '徐庆华', 'add', '产品报价', '新增产品报价，报价单号：', '{\"newData\":{\"sale_id\":5,\"notice\":\"\",\"product_price\":\"580\",\"transaction_currency\":\"RMB\",\"transaction_method\":27,\"other_transaction_terms\":31,\"other_text\":\"\"}}', '2025-11-28 07:45:35');
INSERT INTO `sub_operation_history` VALUES (67, 3, 6, '徐庆华', 'add', '产品报价', '新增产品报价，报价单号：', '{\"newData\":{\"sale_id\":6,\"notice\":\"\",\"product_price\":\"600\",\"transaction_currency\":\"RMB\",\"transaction_method\":29,\"other_transaction_terms\":31,\"other_text\":\"\"}}', '2025-11-28 07:46:28');
INSERT INTO `sub_operation_history` VALUES (68, 3, 6, '徐庆华', 'add', '生产通知单', '新增生产通知单，订单号：DD2511001', '{\"newData\":{\"sale_id\":5,\"notice\":\"DD2511001\",\"delivery_time\":\"2025-12-28\"}}', '2025-11-28 07:54:19');
INSERT INTO `sub_operation_history` VALUES (69, 3, 6, '徐庆华', 'add', '生产通知单', '新增生产通知单，订单号：DD2511002', '{\"newData\":{\"sale_id\":6,\"notice\":\"DD2511002\",\"delivery_time\":\"2025-12-27\"}}', '2025-11-28 07:54:39');
INSERT INTO `sub_operation_history` VALUES (70, 3, 6, '徐庆华', 'paichang', '生产通知单', '执行通知单排产，订单号：DD2511002', '{\"newData\":12}', '2025-11-28 07:54:55');
INSERT INTO `sub_operation_history` VALUES (71, 3, 6, '徐庆华', 'update', '生产制程', '修改生产制程：名称：后段组', '{\"newData\":{\"id\":11,\"name\":\"后段组\",\"sort\":\"6\"}}', '2025-11-28 08:11:24');
INSERT INTO `sub_operation_history` VALUES (72, 3, 6, '徐庆华', 'update', '生产制程', '修改生产制程：名称：后段组', '{\"newData\":{\"id\":11,\"name\":\"后段组\",\"sort\":\"F\"}}', '2025-11-28 08:28:18');
INSERT INTO `sub_operation_history` VALUES (73, 3, 6, '徐庆华', 'paichang', '生产通知单', '执行通知单排产，订单号：DD2511001', '{\"newData\":11}', '2025-11-28 08:28:51');
INSERT INTO `sub_operation_history` VALUES (74, 3, 6, '徐庆华', 'update', '生产制程', '修改生产制程：名称：后段组', '{\"newData\":{\"id\":11,\"name\":\"后段组\",\"sort\":\"G\"}}', '2025-11-28 08:30:23');
INSERT INTO `sub_operation_history` VALUES (75, 3, 6, '徐庆华', 'update', '生产制程', '修改生产制程：名称：补土组', '{\"newData\":{\"id\":10,\"name\":\"补土组\",\"sort\":\"F\"}}', '2025-11-28 08:30:31');
INSERT INTO `sub_operation_history` VALUES (76, 3, 6, '徐庆华', 'update', '生产制程', '修改生产制程：名称：研磨组', '{\"newData\":{\"id\":9,\"name\":\"研磨组\",\"sort\":\"E\"}}', '2025-11-28 08:30:38');
INSERT INTO `sub_operation_history` VALUES (77, 3, 6, '徐庆华', 'update', '生产制程', '修改生产制程：名称：热处理', '{\"newData\":{\"id\":8,\"name\":\"热处理\",\"sort\":\"D\"}}', '2025-11-28 08:30:45');
INSERT INTO `sub_operation_history` VALUES (78, 3, 6, '徐庆华', 'update', '生产制程', '修改生产制程：名称：焊接组', '{\"newData\":{\"id\":7,\"name\":\"焊接组\",\"sort\":\"C\"}}', '2025-11-28 08:30:52');
INSERT INTO `sub_operation_history` VALUES (79, 3, 6, '徐庆华', 'update', '生产制程', '修改生产制程：名称：备料组', '{\"newData\":{\"id\":6,\"name\":\"备料组\",\"sort\":\"B\"}}', '2025-11-28 08:30:59');
INSERT INTO `sub_operation_history` VALUES (80, 3, 6, '徐庆华', 'add', '生产制程', '新增生产制程：名称：委外组', '{\"newData\":{\"name\":\"委外组\",\"sort\":\"A\"}}', '2025-11-28 08:31:17');
INSERT INTO `sub_operation_history` VALUES (81, 3, 6, '徐庆华', 'paichang', '生产通知单', '执行通知单排产，订单号：DD2511001', '{\"newData\":11}', '2025-11-28 08:35:41');
INSERT INTO `sub_operation_history` VALUES (82, 3, 6, '徐庆华', 'paichang', '生产通知单', '执行通知单排产，订单号：DD2511001', '{\"newData\":11}', '2025-11-28 08:58:04');
INSERT INTO `sub_operation_history` VALUES (83, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-11-29 01:48:07');
INSERT INTO `sub_operation_history` VALUES (84, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-11-29 01:59:22');
INSERT INTO `sub_operation_history` VALUES (85, 3, 15, '粟云', 'login', '登录', '用户{ 粟云 }成功登录', '{\"newData\":{\"username\":\"suyun\",\"password\":\"***\"}}', '2025-11-29 02:09:50');
INSERT INTO `sub_operation_history` VALUES (86, 3, 6, '徐庆华', 'update', '材料BOM', '修改材料BOM，产品编码：WA-A00001，部件编码：X010，材料编码：M0101-0444,H0703-0001,H0702-0001', '{\"newData\":{\"id\":35,\"product_id\":20,\"part_id\":30,\"children\":[{\"id\":54,\"material_bom_id\":35,\"material_id\":18,\"number\":1,\"process_index\":1,\"material\":{\"id\":18,\"material_code\":\"M0101-0444\",\"material_name\":\"后下叉R\",\"specification\":\"φ22.2*2.0*420L\"}},{\"id\":55,\"material_bom_id\":35,\"material_id\":12,\"number\":3,\"process_index\":2,\"material\":{\"id\":12,\"material_code\":\"H0703-0001\",\"material_name\":\"油压线扣\",\"specification\":\"YD007-004\"}},{\"id\":56,\"material_bom_id\":35,\"material_id\":20,\"number\":2,\"process_index\":3,\"material\":{\"id\":20,\"material_code\":\"H0702-0001\",\"material_name\":\"止栓\",\"specification\":\"YD004-026\"}}],\"sort\":\"12\",\"archive\":0}}', '2025-11-29 02:14:54');
INSERT INTO `sub_operation_history` VALUES (87, 3, 6, '徐庆华', 'update', '材料BOM', '修改材料BOM，产品编码：WA-A00001，部件编码：X011，材料编码：M0101-0445', '{\"newData\":{\"id\":36,\"product_id\":20,\"part_id\":31,\"children\":[{\"id\":57,\"material_bom_id\":36,\"material_id\":19,\"number\":1,\"process_index\":1,\"material\":{\"id\":19,\"material_code\":\"M0101-0445\",\"material_name\":\"后下叉L\",\"specification\":\"φ22.2*2.0*420L\"}}],\"sort\":\"13\",\"archive\":0}}', '2025-11-29 02:15:06');
INSERT INTO `sub_operation_history` VALUES (88, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-11-29 02:17:38');
INSERT INTO `sub_operation_history` VALUES (89, 3, 6, '徐庆华', 'update', '材料BOM', '修改材料BOM，产品编码：WA-A00001，部件编码：Y001，材料编码：H0302-0013,H1202-0012', '{\"newData\":{\"id\":37,\"product_id\":20,\"part_id\":40,\"children\":[{\"id\":58,\"material_bom_id\":37,\"material_id\":21,\"number\":1,\"process_index\":1,\"material\":{\"id\":21,\"material_code\":\"H0302-0013\",\"material_name\":\"左勾爪\",\"specification\":\"YD001-003DS-45度\"}},{\"id\":59,\"material_bom_id\":37,\"material_id\":23,\"number\":1,\"process_index\":2,\"material\":{\"id\":23,\"material_code\":\"H1202-0012\",\"material_name\":\"边支撑\",\"specification\":\"JHD-TC18\"}}],\"sort\":\"14\",\"archive\":0}}', '2025-11-29 02:18:16');
INSERT INTO `sub_operation_history` VALUES (90, 3, 6, '徐庆华', 'update', '材料BOM', '修改材料BOM，产品编码：WA-A00001，部件编码：Y002，材料编码：H0302-0014', '{\"newData\":{\"id\":38,\"product_id\":20,\"part_id\":41,\"children\":[{\"id\":60,\"material_bom_id\":38,\"material_id\":22,\"number\":1,\"process_index\":1,\"material\":{\"id\":22,\"material_code\":\"H0302-0014\",\"material_name\":\"右勾爪\",\"specification\":\"YD001-003DS-45度\"}}],\"sort\":\"15\",\"archive\":0}}', '2025-11-29 02:18:23');
INSERT INTO `sub_operation_history` VALUES (91, 3, 6, '徐庆华', 'update', '材料BOM', '修改材料BOM，产品编码：WA-A00001，部件编码：Y003，材料编码：H0802-0001', '{\"newData\":{\"id\":39,\"product_id\":20,\"part_id\":42,\"children\":[{\"id\":61,\"material_bom_id\":39,\"material_id\":27,\"number\":2,\"process_index\":1,\"material\":{\"id\":27,\"material_code\":\"H0802-0001\",\"material_name\":\"货架螺母\",\"specification\":\"YD008-021 M5\"}}],\"sort\":\"16\",\"archive\":0}}', '2025-11-29 02:18:37');
INSERT INTO `sub_operation_history` VALUES (92, 3, 6, '徐庆华', 'update', '材料BOM', '修改材料BOM，产品编码：WA-A00001，部件编码：Y004，材料编码：H0401-0036,H0401-0036,H0401-0036', '{\"newData\":{\"id\":40,\"product_id\":20,\"part_id\":43,\"children\":[{\"id\":67,\"material_bom_id\":40,\"material_id\":24,\"number\":\"1\",\"process_index\":1,\"material\":{\"id\":24,\"material_code\":\"H0401-0036\",\"material_name\":\"折叠器\",\"specification\":\"ZHD-DX160-T01/02-Z\"}},{\"id\":68,\"material_bom_id\":40,\"material_id\":24,\"number\":\"1\",\"process_index\":2,\"material\":{\"id\":24,\"material_code\":\"H0401-0036\",\"material_name\":\"折叠器\",\"specification\":\"ZHD-DX160-T01/02-Z\"}},{\"id\":62,\"material_bom_id\":40,\"material_id\":24,\"number\":1,\"process_index\":3,\"material\":{\"id\":24,\"material_code\":\"H0401-0036\",\"material_name\":\"折叠器\",\"specification\":\"ZHD-DX160-T01/02-Z\"}}],\"sort\":\"17\",\"archive\":0}}', '2025-11-29 02:24:21');
INSERT INTO `sub_operation_history` VALUES (93, 3, 6, '徐庆华', 'update', '材料BOM', '修改材料BOM，产品编码：WA-A00001，部件编码：Y005，材料编码：H1102-0099,H1201-0001,H1102-0099,H1201-0001', '{\"newData\":{\"id\":41,\"product_id\":20,\"part_id\":44,\"children\":[{\"id\":65,\"material_bom_id\":41,\"material_id\":25,\"number\":\"1\",\"process_index\":1,\"material\":{\"id\":25,\"material_code\":\"H1102-0099\",\"material_name\":\"加强片\",\"specification\":\"JHD-BQ-211\"}},{\"id\":66,\"material_bom_id\":41,\"material_id\":26,\"number\":\"1\",\"process_index\":2,\"material\":{\"id\":26,\"material_code\":\"H1201-0001\",\"material_name\":\"支撑棒\",\"specification\":\"JS-ZJ-001*120L\"}},{\"id\":63,\"material_bom_id\":41,\"material_id\":25,\"number\":1,\"process_index\":3,\"material\":{\"id\":25,\"material_code\":\"H1102-0099\",\"material_name\":\"加强片\",\"specification\":\"JHD-BQ-211\"}},{\"id\":64,\"material_bom_id\":41,\"material_id\":26,\"number\":1,\"process_index\":4,\"material\":{\"id\":26,\"material_code\":\"H1201-0001\",\"material_name\":\"支撑棒\",\"specification\":\"JS-ZJ-001*120L\"}}],\"sort\":\"18\",\"archive\":0}}', '2025-11-29 02:25:45');
INSERT INTO `sub_operation_history` VALUES (94, 3, 6, '徐庆华', 'copeAdd', '工艺BOM', '复制新增工艺BOM，产品编码：WA-A00001，部件编码：X007，工艺编码：PA002,PA002,PA002,PA002,,,,,,,,,,', '{\"newData\":60}', '2025-11-29 02:30:32');
INSERT INTO `sub_operation_history` VALUES (95, 3, 15, '粟云', 'add', '设备编码', '新增设备编码：WX01', '{\"newData\":{\"equipment_code\":\"WX01\",\"equipment_name\":\"电脑锣\",\"quantity\":3,\"cycle_id\":18,\"working_hours\":20,\"efficiency\":60,\"available\":3,\"remarks\":\"\"}}', '2025-11-29 02:52:52');
INSERT INTO `sub_operation_history` VALUES (96, 3, 15, '粟云', 'update', '生产制程', '修改生产制程：名称：外协组', '{\"newData\":{\"id\":18,\"name\":\"外协组\",\"sort\":\"A\"}}', '2025-11-29 02:53:49');
INSERT INTO `sub_operation_history` VALUES (97, 3, 15, '粟云', 'update', '生产制程', '修改生产制程：名称：外协组', '{\"newData\":{\"id\":18,\"name\":\"外协组\",\"sort\":\"0\"}}', '2025-11-29 02:59:28');
INSERT INTO `sub_operation_history` VALUES (98, 3, 15, '粟云', 'update', '生产制程', '修改生产制程：名称：财务部', '{\"newData\":{\"id\":17,\"name\":\"财务部\",\"sort\":\"X\"}}', '2025-11-29 02:59:42');
INSERT INTO `sub_operation_history` VALUES (99, 3, 15, '粟云', 'update', '生产制程', '修改生产制程：名称：财务部', '{\"newData\":{\"id\":17,\"name\":\"财务部\",\"sort\":\"0\"}}', '2025-11-29 03:00:19');
INSERT INTO `sub_operation_history` VALUES (100, 3, 15, '粟云', 'update', '生产制程', '修改生产制程：名称：外协组', '{\"newData\":{\"id\":18,\"name\":\"外协组\",\"sort\":\"1\"}}', '2025-11-29 03:00:39');
INSERT INTO `sub_operation_history` VALUES (101, 3, 15, '粟云', 'update', '生产制程', '修改生产制程：名称：备料组', '{\"newData\":{\"id\":6,\"name\":\"备料组\",\"sort\":\"A\"}}', '2025-11-29 03:04:38');
INSERT INTO `sub_operation_history` VALUES (102, 3, 15, '粟云', 'update', '生产制程', '修改生产制程：名称：焊接组', '{\"newData\":{\"id\":7,\"name\":\"焊接组\",\"sort\":\"B\"}}', '2025-11-29 03:04:45');
INSERT INTO `sub_operation_history` VALUES (103, 3, 15, '粟云', 'update', '生产制程', '修改生产制程：名称：热处理', '{\"newData\":{\"id\":8,\"name\":\"热处理\",\"sort\":\"C\"}}', '2025-11-29 03:04:54');
INSERT INTO `sub_operation_history` VALUES (104, 3, 15, '粟云', 'update', '生产制程', '修改生产制程：名称：研磨组', '{\"newData\":{\"id\":9,\"name\":\"研磨组\",\"sort\":\"D\"}}', '2025-11-29 03:05:01');
INSERT INTO `sub_operation_history` VALUES (105, 3, 15, '粟云', 'update', '生产制程', '修改生产制程：名称：补土组', '{\"newData\":{\"id\":10,\"name\":\"补土组\",\"sort\":\"E\"}}', '2025-11-29 03:05:08');
INSERT INTO `sub_operation_history` VALUES (106, 3, 15, '粟云', 'update', '生产制程', '修改生产制程：名称：后段组', '{\"newData\":{\"id\":11,\"name\":\"后段组\",\"sort\":\"F\"}}', '2025-11-29 03:05:15');
INSERT INTO `sub_operation_history` VALUES (107, 3, 15, '粟云', 'add', '工艺编码', '新增工艺编码：PX001', '{\"newData\":{\"equipment_id\":49,\"process_code\":\"PX001\",\"process_name\":\"铣边槽\",\"remarks\":\"\"}}', '2025-11-29 03:34:19');
INSERT INTO `sub_operation_history` VALUES (108, 3, 15, '粟云', 'add', '仓库建立', '新增仓库：名称：管料仓-铝管', '{\"newData\":{\"ware_id\":1,\"name\":\"管料仓-铝管\"}}', '2025-11-29 03:35:54');
INSERT INTO `sub_operation_history` VALUES (109, 3, 15, '粟云', 'add', '仓库建立', '新增仓库：名称：配件仓-铝合金', '{\"newData\":{\"ware_id\":1,\"name\":\"配件仓-铝合金\"}}', '2025-11-29 03:36:33');
INSERT INTO `sub_operation_history` VALUES (110, 3, 15, '粟云', 'add', '仓库建立', '新增仓库：名称：成品-铝车架', '{\"newData\":{\"ware_id\":3,\"name\":\"成品-铝车架\"}}', '2025-11-29 03:37:18');
INSERT INTO `sub_operation_history` VALUES (111, 3, 15, '粟云', 'add', '仓库建立', '新增仓库：名称：成品-铁架', '{\"newData\":{\"ware_id\":3,\"name\":\"成品-铁架\"}}', '2025-11-29 03:37:40');
INSERT INTO `sub_operation_history` VALUES (112, 3, 15, '粟云', 'update', '工艺BOM', '修改工艺BOM，产品编码：WA-A00002，部件编码：X007，工艺编码：PX001,PA002,PA002,PA002', '{\"newData\":{\"id\":83,\"children\":[{\"id\":204,\"process_bom_id\":83,\"process_id\":115,\"equipment_id\":49,\"process_index\":1,\"time\":\"40\",\"price\":\"1.8\",\"points\":\"1\",\"process\":{\"id\":8,\"process_code\":\"PA002\",\"process_name\":\"冲孔\"},\"equipment\":{\"id\":7,\"equipment_code\":\"JX02\",\"equipment_name\":\"16T冲床\",\"cycle\":{\"id\":6,\"company_id\":3,\"user_id\":15,\"name\":\"备料组\",\"sort\":\"A\",\"sort_date\":\"1\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:10:27.000Z\",\"updated_at\":\"2025-11-29T03:04:38.000Z\"}}},{\"id\":205,\"process_bom_id\":83,\"process_id\":8,\"equipment_id\":7,\"process_index\":2,\"time\":4,\"price\":\"0.05\",\"points\":\"1\",\"process\":{\"id\":8,\"process_code\":\"PA002\",\"process_name\":\"冲孔\"},\"equipment\":{\"id\":7,\"equipment_code\":\"JX02\",\"equipment_name\":\"16T冲床\",\"cycle\":{\"id\":6,\"company_id\":3,\"user_id\":15,\"name\":\"备料组\",\"sort\":\"A\",\"sort_date\":\"1\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:10:27.000Z\",\"updated_at\":\"2025-11-29T03:04:38.000Z\"}}},{\"id\":206,\"process_bom_id\":83,\"process_id\":8,\"equipment_id\":7,\"process_index\":3,\"time\":4,\"price\":\"0.05\",\"points\":\"1\",\"process\":{\"id\":8,\"process_code\":\"PA002\",\"process_name\":\"冲孔\"},\"equipment\":{\"id\":7,\"equipment_code\":\"JX02\",\"equipment_name\":\"16T冲床\",\"cycle\":{\"id\":6,\"company_id\":3,\"user_id\":15,\"name\":\"备料组\",\"sort\":\"A\",\"sort_date\":\"1\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:10:27.000Z\",\"updated_at\":\"2025-11-29T03:04:38.000Z\"}}},{\"id\":203,\"process_bom_id\":83,\"process_id\":8,\"equipment_id\":7,\"process_index\":4,\"time\":4,\"price\":\"0.05\",\"points\":\"1\",\"process\":{\"id\":8,\"process_code\":\"PA002\",\"process_name\":\"冲孔\"},\"equipment\":{\"id\":7,\"equipment_code\":\"JX02\",\"equipment_name\":\"16T冲床\",\"cycle\":{\"id\":6,\"company_id\":3,\"user_id\":15,\"name\":\"备料组\",\"sort\":\"A\",\"sort_date\":\"1\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:10:27.000Z\",\"updated_at\":\"2025-11-29T03:04:38.000Z\"}}}],\"product_id\":21,\"part_id\":27,\"sort\":\"1\",\"archive\":0}}', '2025-11-29 03:39:41');
INSERT INTO `sub_operation_history` VALUES (113, 3, 15, '粟云', 'copeAdd', '工艺BOM', '复制新增工艺BOM，产品编码：WA-A00001，部件编码：X001，工艺编码：PA001,,,,,,,,,,,,,', '{\"newData\":59}', '2025-11-29 03:41:13');
INSERT INTO `sub_operation_history` VALUES (114, 3, 15, '粟云', 'update', '工艺BOM', '修改工艺BOM，产品编码：WA-A00001，部件编码：X001，工艺编码：PA001', '{\"newData\":{\"id\":84,\"children\":[{\"id\":207,\"process_bom_id\":84,\"process_id\":7,\"equipment_id\":6,\"process_index\":1,\"time\":15,\"price\":\"0.20\",\"points\":\"1\",\"process\":{\"id\":7,\"process_code\":\"PA001\",\"process_name\":\"打字\"},\"equipment\":{\"id\":6,\"equipment_code\":\"JX01\",\"equipment_name\":\"打字机\",\"cycle\":{\"id\":6,\"company_id\":3,\"user_id\":15,\"name\":\"备料组\",\"sort\":\"A\",\"sort_date\":\"1\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:10:27.000Z\",\"updated_at\":\"2025-11-29T03:04:38.000Z\"}}}],\"product_id\":20,\"part_id\":21,\"sort\":\"19\",\"archive\":0}}', '2025-11-29 03:41:52');
INSERT INTO `sub_operation_history` VALUES (115, 3, 15, '粟云', 'copeAdd', '工艺BOM', '复制新增工艺BOM，产品编码：WA-A00002，部件编码：X007，工艺编码：PX001,PA002,PA002,PA002,,,,,,,,,,', '{\"newData\":83}', '2025-11-29 03:42:19');
INSERT INTO `sub_operation_history` VALUES (116, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-11-29 03:47:21');
INSERT INTO `sub_operation_history` VALUES (117, 3, 15, '粟云', 'add', '销售订单', '新增销售订单，客户订单号：CR022511009', '{\"newData\":{\"rece_time\":\"2025-11-29\",\"customer_id\":5,\"customer_order\":\"CR022511009\",\"product_id\":21,\"product_req\":\"1.产品表面研磨清洗；2.产品杜绝补土；3.按订单要求打字码\",\"order_number\":\"5000\",\"unit\":52,\"delivery_time\":\"2026-01-15\",\"goods_time\":\"\",\"goods_address\":\"高埗镇合鑫喷漆厂\"}}', '2025-11-29 06:13:17');
INSERT INTO `sub_operation_history` VALUES (118, 3, 15, '粟云', 'add', '产品报价', '新增产品报价，报价单号：', '{\"newData\":{\"sale_id\":7,\"notice\":\"\",\"product_price\":\"550\",\"transaction_currency\":\"RMB\",\"transaction_method\":29,\"other_transaction_terms\":31,\"other_text\":\"\"}}', '2025-11-29 06:13:54');
INSERT INTO `sub_operation_history` VALUES (119, 3, 15, '粟云', 'add', '生产通知单', '新增生产通知单，订单号：DD2511003', '{\"newData\":{\"sale_id\":7,\"notice\":\"DD2511003\",\"delivery_time\":\"2026-01-13\"}}', '2025-11-29 06:14:29');
INSERT INTO `sub_operation_history` VALUES (120, 3, 15, '粟云', 'paichang', '生产通知单', '执行通知单排产，订单号：DD2511003', '{\"newData\":13}', '2025-11-29 06:26:39');
INSERT INTO `sub_operation_history` VALUES (121, 3, 15, '粟云', 'update', '工艺BOM', '修改工艺BOM，产品编码：WA-A00002，部件编码：X006，工艺编码：PA002,PA002,PX001,PA002', '{\"newData\":{\"id\":85,\"children\":[{\"id\":211,\"process_bom_id\":85,\"process_id\":8,\"equipment_id\":7,\"process_index\":1,\"time\":4,\"price\":\"0.05\",\"points\":\"1\",\"process\":{\"id\":8,\"process_code\":\"PA002\",\"process_name\":\"冲孔\"},\"equipment\":{\"id\":7,\"equipment_code\":\"JX02\",\"equipment_name\":\"16T冲床\",\"cycle\":{\"id\":6,\"company_id\":3,\"user_id\":15,\"name\":\"备料组\",\"sort\":\"A\",\"sort_date\":\"1\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:10:27.000Z\",\"updated_at\":\"2025-11-29T03:04:38.000Z\"}}},{\"id\":208,\"process_bom_id\":85,\"process_id\":8,\"equipment_id\":7,\"process_index\":2,\"time\":4,\"price\":\"0.05\",\"points\":\"1\",\"process\":{\"id\":8,\"process_code\":\"PA002\",\"process_name\":\"冲孔\"},\"equipment\":{\"id\":7,\"equipment_code\":\"JX02\",\"equipment_name\":\"16T冲床\",\"cycle\":{\"id\":6,\"company_id\":3,\"user_id\":15,\"name\":\"备料组\",\"sort\":\"A\",\"sort_date\":\"1\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:10:27.000Z\",\"updated_at\":\"2025-11-29T03:04:38.000Z\"}}},{\"id\":209,\"process_bom_id\":85,\"process_id\":115,\"equipment_id\":49,\"process_index\":3,\"time\":40,\"price\":\"1.80\",\"points\":\"1\",\"process\":{\"id\":115,\"process_code\":\"PX001\",\"process_name\":\"铣边槽\"},\"equipment\":{\"id\":49,\"equipment_code\":\"WX01\",\"equipment_name\":\"电脑锣\",\"cycle\":{\"id\":18,\"company_id\":3,\"user_id\":15,\"name\":\"外协组\",\"sort\":\"1\",\"sort_date\":null,\"is_deleted\":1,\"created_at\":\"2025-11-28T08:31:17.000Z\",\"updated_at\":\"2025-11-29T03:00:39.000Z\"}}},{\"id\":210,\"process_bom_id\":85,\"process_id\":8,\"equipment_id\":7,\"process_index\":4,\"time\":4,\"price\":\"0.05\",\"points\":\"1\",\"process\":{\"id\":8,\"process_code\":\"PA002\",\"process_name\":\"冲孔\"},\"equipment\":{\"id\":7,\"equipment_code\":\"JX02\",\"equipment_name\":\"16T冲床\",\"cycle\":{\"id\":6,\"company_id\":3,\"user_id\":15,\"name\":\"备料组\",\"sort\":\"A\",\"sort_date\":\"1\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:10:27.000Z\",\"updated_at\":\"2025-11-29T03:04:38.000Z\"}}}],\"product_id\":21,\"part_id\":26,\"sort\":\"2\",\"archive\":0}}', '2025-11-29 06:47:14');
INSERT INTO `sub_operation_history` VALUES (122, 3, 15, '粟云', 'add', '供应商资料', '新增供应商资料，供应商编码：GA001', '{\"newData\":{\"supplier_code\":\"GA001\",\"supplier_abbreviation\":\"晶鑫昌\",\"contact_person\":\"刘总\",\"contact_information\":\"13012345678\",\"supplier_full_name\":\"深圳市晶鑫昌科技有限公司\",\"supplier_address\":\"深圳市宝安区沙井镇\",\"supplier_category\":\"[38,41]\",\"supply_method\":35,\"transaction_method\":27,\"transaction_currency\":\"RMB\",\"other_transaction_terms\":31,\"other_text\":\"\"}}', '2025-11-29 06:54:55');
INSERT INTO `sub_operation_history` VALUES (123, 3, 15, '粟云', 'add', '供应商资料', '新增供应商资料，供应商编码：GA002', '{\"newData\":{\"supplier_code\":\"GA002\",\"supplier_abbreviation\":\"城至\",\"contact_person\":\"许小姐\",\"contact_information\":\"18612345678\",\"supplier_full_name\":\"东莞市城至精密五金有限公司\",\"supplier_address\":\"东莞市万江区简沙洲工业区\",\"supplier_category\":\"[38,41,39]\",\"supply_method\":37,\"transaction_method\":28,\"transaction_currency\":\"RMB\",\"other_transaction_terms\":32,\"other_text\":\"\"}}', '2025-11-29 07:01:01');
INSERT INTO `sub_operation_history` VALUES (124, 3, 15, '粟云', 'update', '原材料编码', '修改原材料编码：H0302-0013', '{\"newData\":{\"id\":21,\"user_id\":6,\"company_id\":3,\"material_code\":\"H0302-0013\",\"material_name\":\"左勾爪\",\"model\":\"YD001-003DS-45度\",\"specification\":\"YD001-003DS-45度\",\"other_features\":\"\",\"usage_unit\":51,\"purchase_unit\":51,\"category\":50,\"is_deleted\":1,\"created_at\":\"2025-10-28\",\"updated_at\":\"2025-11-28\"}}', '2025-11-29 07:52:47');
INSERT INTO `sub_operation_history` VALUES (125, 3, 15, '粟云', 'keyup', '原材料报价', '存档原材料报价', '{\"newData\":{\"data\":[{\"supplier_id\":6,\"supplier_abbreviation\":\"晶鑫昌\",\"material_id\":21,\"price\":\"2.8\",\"delivery\":35,\"packaging\":\"\",\"transaction_currency\":\"RMB\",\"unit\":51,\"transaction_method\":27,\"other_transaction_terms\":31,\"other_text\":\"\",\"invoice\":44}]}}', '2025-11-29 07:59:42');
INSERT INTO `sub_operation_history` VALUES (126, 3, 15, '粟云', 'keyApproval', '采购作业', '采购作业提交审核：{ 供应商编码：GA001，生产订单号：DD2511001，产品编码：WA-A00001，材料编码：H0302-0013 }', '{\"newData\":{\"data\":[{\"quote_id\":4,\"material_bom_children_id\":58,\"material_bom_id\":37,\"notice_id\":11,\"notice\":\"DD2511001\",\"supplier_id\":6,\"supplier_code\":\"GA001\",\"supplier_abbreviation\":\"晶鑫昌\",\"product_id\":20,\"product_code\":\"WA-A00001\",\"product_name\":\"0611铝车架\",\"material_id\":21,\"material_code\":\"H0302-0013\",\"material_name\":\"左勾爪\",\"model_spec\":\"YD001-003DS-45度\",\"other_features\":null,\"unit\":51,\"usage_unit\":51,\"price\":\"2.8\",\"order_number\":null,\"number\":\"18000\",\"delivery_time\":\"2025-12-28\",\"approval\":[]}],\"type\":\"purchase_order\"}}', '2025-11-29 08:19:07');
INSERT INTO `sub_operation_history` VALUES (127, 3, 15, '粟云', 'approval', '采购作业', '审批通过了采购作业，它们有：{ 供应商编码：GA001，生产订单号：DD2511001，产品编码：WA-A00001，材料编码：H0302-0013 }', '{\"newData\":{\"data\":[{\"id\":2,\"company_id\":3,\"user_id\":15,\"quote_id\":4,\"material_bom_id\":\"37\",\"print_id\":null,\"notice_id\":11,\"notice\":\"DD2511001\",\"supplier_id\":6,\"supplier_code\":\"GA001\",\"supplier_abbreviation\":\"晶鑫昌\",\"product_id\":\"20\",\"product_code\":\"WA-A00001\",\"product_name\":\"0611铝车架\",\"material_id\":21,\"material_code\":\"H0302-0013\",\"material_name\":\"左勾爪\",\"model_spec\":\"YD001-003DS-45度\",\"other_features\":null,\"unit\":51,\"usage_unit\":51,\"price\":\"2.8\",\"order_number\":null,\"number\":\"18000\",\"delivery_time\":\"2025-12-28\",\"apply_id\":15,\"apply_name\":\"粟云\",\"apply_time\":\"2025-11-29\",\"step\":0,\"status\":0,\"is_buying\":1,\"is_houser\":1,\"order_id\":1,\"is_deleted\":1,\"created_at\":\"2025-11-29\",\"updated_at\":\"2025-11-29\",\"approval\":[{\"user_id\":15,\"user_name\":\"粟云\",\"type\":\"purchase_order\",\"step\":1,\"company_id\":3,\"source_id\":2,\"user_time\":null,\"status\":0,\"id\":9},{\"user_id\":16,\"user_name\":\"冷冰\",\"type\":\"purchase_order\",\"step\":2,\"company_id\":3,\"source_id\":2,\"user_time\":null,\"status\":0,\"id\":10}]}],\"type\":\"purchase_order\"}}', '2025-11-29 08:19:24');
INSERT INTO `sub_operation_history` VALUES (128, 3, 16, '冷冰', 'login', '登录', '用户{ 冷冰 }成功登录', '{\"newData\":{\"username\":\"lengbing\",\"password\":\"***\"}}', '2025-11-29 08:19:48');
INSERT INTO `sub_operation_history` VALUES (129, 3, 16, '冷冰', 'approval', '采购作业', '审批通过了采购作业，它们有：{ 供应商编码：GA001，生产订单号：DD2511001，产品编码：WA-A00001，材料编码：H0302-0013 }', '{\"newData\":{\"data\":[{\"id\":2,\"company_id\":3,\"user_id\":15,\"quote_id\":4,\"material_bom_id\":\"37\",\"print_id\":null,\"notice_id\":11,\"notice\":\"DD2511001\",\"supplier_id\":6,\"supplier_code\":\"GA001\",\"supplier_abbreviation\":\"晶鑫昌\",\"product_id\":\"20\",\"product_code\":\"WA-A00001\",\"product_name\":\"0611铝车架\",\"material_id\":21,\"material_code\":\"H0302-0013\",\"material_name\":\"左勾爪\",\"model_spec\":\"YD001-003DS-45度\",\"other_features\":null,\"unit\":51,\"usage_unit\":51,\"price\":\"2.8\",\"order_number\":null,\"number\":\"18000\",\"delivery_time\":\"2025-12-28\",\"apply_id\":15,\"apply_name\":\"粟云\",\"apply_time\":\"2025-11-29\",\"step\":1,\"status\":0,\"is_buying\":1,\"is_houser\":1,\"order_id\":1,\"is_deleted\":1,\"created_at\":\"2025-11-29\",\"updated_at\":\"2025-11-29\",\"approval\":[{\"user_id\":15,\"user_name\":\"粟云\",\"type\":\"purchase_order\",\"step\":1,\"company_id\":3,\"source_id\":2,\"user_time\":null,\"status\":1,\"id\":9},{\"user_id\":16,\"user_name\":\"冷冰\",\"type\":\"purchase_order\",\"step\":2,\"company_id\":3,\"source_id\":2,\"user_time\":null,\"status\":0,\"id\":10}]}],\"type\":\"purchase_order\"}}', '2025-11-29 08:19:53');
INSERT INTO `sub_operation_history` VALUES (130, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-11-29 08:20:00');
INSERT INTO `sub_operation_history` VALUES (131, 3, 15, '粟云', 'add', '委外报价', '新增委外报价，供应商编码：GA001，生产订单号：DD2511001，工艺BOM：Y001:左钩爪，工艺工序：PB034:点分体式下叉 - JX18:万能铣弧机', '{\"newData\":{\"notice_id\":11,\"supplier_id\":6,\"process_bom_id\":76,\"process_index\":\"\",\"price\":\"1.35\",\"transaction_currency\":\"RMB\",\"transaction_method\":27,\"other_transaction_terms\":31,\"other_text\":\"\",\"invoice\":44,\"process_bom_children_id\":180}}', '2025-11-29 08:25:00');
INSERT INTO `sub_operation_history` VALUES (132, 3, 15, '粟云', 'update', '部件编码', '修改部件编码：Y001', '{\"newData\":{\"id\":40,\"company_id\":3,\"user_id\":6,\"part_code\":\"Y001\",\"part_name\":\"左钩爪\",\"model\":\"\",\"specification\":\"\",\"other_features\":\"\",\"unit\":51,\"production_requirements\":\"\",\"remarks\":\"\",\"is_deleted\":1,\"created_at\":\"2025-10-27\",\"updated_at\":\"2025-11-28\"}}', '2025-11-29 08:29:24');
INSERT INTO `sub_operation_history` VALUES (133, 3, 15, '粟云', 'approval', '委外加工单', '审批通过了委外加工单', '{\"newData\":{\"data\":[{\"id\":2,\"notice_id\":11,\"supplier_id\":6,\"process_bom_id\":76,\"process_bom_children_id\":180,\"ment\":\"不接受漏焊\",\"unit\":\"51\",\"number\":\"18000\",\"price\":\"1.35\",\"transaction_currency\":\"RMB\",\"transaction_terms\":null,\"delivery_time\":\"2025-12-06\",\"remarks\":\"\",\"status\":0,\"is_buying\":1,\"apply_id\":15,\"apply_name\":\"粟云\",\"apply_time\":\"2025-11-29\",\"step\":0,\"supplier\":{\"id\":6,\"supplier_abbreviation\":\"晶鑫昌\",\"supplier_code\":\"GA001\"},\"notice\":{\"id\":11,\"notice\":\"DD2511001\",\"sale_id\":5,\"sale\":{\"id\":5,\"order_number\":\"18000\",\"unit\":\"52\",\"delivery_time\":\"2025-12-30\"},\"product\":{\"id\":20,\"product_name\":\"0611铝车架\",\"product_code\":\"WA-A00001\",\"drawing\":\"0611\",\"model\":\"城市代步Q1\",\"specification\":\"36寸\"}},\"processBom\":{\"id\":76,\"product_id\":20,\"part_id\":40,\"archive\":0,\"part\":{\"id\":40,\"part_name\":\"左钩爪\",\"part_code\":\"Y001\"}},\"processChildren\":{\"id\":180,\"process_bom_id\":76,\"process_id\":74,\"equipment_id\":23,\"time\":20,\"price\":\"0.18\",\"points\":\"1\",\"process\":{\"id\":74,\"process_code\":\"PB034\",\"process_name\":\"点分体式下叉\"},\"equipment\":{\"id\":23,\"equipment_code\":\"JX18\",\"equipment_name\":\"万能铣弧机\"}},\"approval\":[{\"user_id\":15,\"user_name\":\"粟云\",\"type\":\"outsourcing_order\",\"step\":1,\"company_id\":3,\"source_id\":2,\"user_time\":null,\"status\":0,\"id\":11},{\"user_id\":16,\"user_name\":\"冷冰\",\"type\":\"outsourcing_order\",\"step\":2,\"company_id\":3,\"source_id\":2,\"user_time\":null,\"status\":0,\"id\":12}]}],\"action\":1}}', '2025-11-29 08:30:28');
INSERT INTO `sub_operation_history` VALUES (134, 3, 16, '冷冰', 'approval', '委外加工单', '审批通过了委外加工单', '{\"newData\":{\"data\":[{\"id\":2,\"notice_id\":11,\"supplier_id\":6,\"process_bom_id\":76,\"process_bom_children_id\":180,\"ment\":\"不接受漏焊\",\"unit\":\"51\",\"number\":\"18000\",\"price\":\"1.35\",\"transaction_currency\":\"RMB\",\"transaction_terms\":null,\"delivery_time\":\"2025-12-06\",\"remarks\":\"\",\"status\":0,\"is_buying\":1,\"apply_id\":15,\"apply_name\":\"粟云\",\"apply_time\":\"2025-11-29\",\"step\":1,\"supplier\":{\"id\":6,\"supplier_abbreviation\":\"晶鑫昌\",\"supplier_code\":\"GA001\"},\"notice\":{\"id\":11,\"notice\":\"DD2511001\",\"sale_id\":5,\"sale\":{\"id\":5,\"order_number\":\"18000\",\"unit\":\"52\",\"delivery_time\":\"2025-12-30\"},\"product\":{\"id\":20,\"product_name\":\"0611铝车架\",\"product_code\":\"WA-A00001\",\"drawing\":\"0611\",\"model\":\"城市代步Q1\",\"specification\":\"36寸\"}},\"processBom\":{\"id\":76,\"product_id\":20,\"part_id\":40,\"archive\":0,\"part\":{\"id\":40,\"part_name\":\"左钩爪\",\"part_code\":\"Y001\"}},\"processChildren\":{\"id\":180,\"process_bom_id\":76,\"process_id\":74,\"equipment_id\":23,\"time\":20,\"price\":\"0.18\",\"points\":\"1\",\"process\":{\"id\":74,\"process_code\":\"PB034\",\"process_name\":\"点分体式下叉\"},\"equipment\":{\"id\":23,\"equipment_code\":\"JX18\",\"equipment_name\":\"万能铣弧机\"}},\"approval\":[{\"user_id\":15,\"user_name\":\"粟云\",\"type\":\"outsourcing_order\",\"step\":1,\"company_id\":3,\"source_id\":2,\"user_time\":null,\"status\":1,\"id\":11},{\"user_id\":16,\"user_name\":\"冷冰\",\"type\":\"outsourcing_order\",\"step\":2,\"company_id\":3,\"source_id\":2,\"user_time\":null,\"status\":0,\"id\":12}]}],\"action\":1}}', '2025-11-29 08:30:33');
INSERT INTO `sub_operation_history` VALUES (135, 3, 15, '粟云', 'keyApproval', '材料出入库', '出/入库单提交审核：{ 仓库：管料仓-铝管，入库方式：采购入库，物料编码：H0302-0013 }', '{\"newData\":{\"data\":[{\"ware_id\":1,\"house_id\":14,\"house_name\":\"管料仓-铝管\",\"operate\":1,\"type\":4,\"plan_id\":6,\"plan\":\"晶鑫昌\",\"procure_id\":2,\"notice_id\":null,\"item_id\":21,\"code\":\"H0302-0013\",\"name\":\"左勾爪\",\"model_spec\":\"\",\"other_features\":null,\"quantity\":\"18000\",\"buy_price\":\"2.8\",\"price\":\"3\",\"approval\":[]}],\"type\":\"material_warehouse\"}}', '2025-11-29 08:38:07');
INSERT INTO `sub_operation_history` VALUES (136, 3, 15, '粟云', 'approval', '材料出入库', '审批通过了出/入库单，它们有：{ 仓库：管料仓-铝管，入库方式：采购入库，物料编码：H0302-0013 }', '{\"newData\":{\"data\":[9],\"action\":1,\"ware_id\":1}}', '2025-11-29 08:38:20');
INSERT INTO `sub_operation_history` VALUES (137, 3, 15, '粟云', 'keyApproval', '材料出入库', '出/入库单提交审核：{ 仓库：管料仓-铝管，入库方式：采购入库，物料编码：H0302-0013 }', '{\"newData\":{\"data\":[{\"ware_id\":1,\"house_id\":14,\"house_name\":\"管料仓-铝管\",\"operate\":1,\"type\":4,\"plan_id\":6,\"plan\":\"晶鑫昌\",\"procure_id\":2,\"notice_id\":11,\"item_id\":21,\"code\":\"H0302-0013\",\"name\":\"左勾爪\",\"model_spec\":\"\",\"other_features\":null,\"quantity\":\"5000\",\"buy_price\":\"2.8\",\"price\":\"3\",\"approval\":[]}],\"type\":\"material_warehouse\"}}', '2025-11-29 08:43:26');
INSERT INTO `sub_operation_history` VALUES (138, 3, 15, '粟云', 'approval', '材料出入库', '审批通过了出/入库单，它们有：{ 仓库：管料仓-铝管，入库方式：采购入库，物料编码：H0302-0013 }', '{\"newData\":{\"data\":[10],\"action\":1,\"ware_id\":1}}', '2025-11-29 08:45:59');
INSERT INTO `sub_operation_history` VALUES (139, 3, 15, '粟云', 'update', '仓库进出存', '修改物料信息：物料编码：H0302-0013，物料名称：左勾爪', '{\"newData\":{\"id\":6,\"user_id\":15,\"company_id\":3,\"ware_id\":1,\"house_id\":14,\"item_id\":21,\"code\":\"H0302-0013\",\"name\":\"左勾爪\",\"model_spec\":\"\",\"other_features\":null,\"buy_price\":\"2.8\",\"price\":\"3\",\"quantity\":5000,\"inv_unit\":\"\",\"unit\":\"\",\"last_in_time\":\"2025-11-29\",\"last_out_time\":\"\",\"price_total\":null,\"price_in\":null,\"price_out\":null}}', '2025-11-29 08:46:27');
INSERT INTO `sub_operation_history` VALUES (140, 3, 15, '粟云', 'keyApproval', '材料出入库', '出/入库单提交审核：{ 仓库：管料仓-铝管，入库方式：采购入库，物料编码：H0302-0013 }', '{\"newData\":{\"data\":[{\"ware_id\":1,\"house_id\":14,\"house_name\":\"管料仓-铝管\",\"operate\":1,\"type\":4,\"plan_id\":6,\"plan\":\"晶鑫昌\",\"procure_id\":2,\"notice_id\":11,\"item_id\":21,\"code\":\"H0302-0013\",\"name\":\"左勾爪\",\"model_spec\":\"\",\"other_features\":null,\"quantity\":\"5000\",\"buy_price\":\"2.8\",\"price\":\"3\",\"approval\":[]}],\"type\":\"material_warehouse\"}}', '2025-11-29 08:50:32');
INSERT INTO `sub_operation_history` VALUES (141, 3, 15, '粟云', 'approval', '材料出入库', '审批通过了出/入库单，它们有：{ 仓库：管料仓-铝管，入库方式：采购入库，物料编码：H0302-0013 }', '{\"newData\":{\"data\":[11],\"action\":1,\"ware_id\":1}}', '2025-11-29 08:50:53');
INSERT INTO `sub_operation_history` VALUES (142, 3, 15, '粟云', 'keyApproval', '材料出入库', '出/入库单提交审核：{ 仓库：成品-铝车架，入库方式：生产入库，物料编码：WA-A00001 }', '{\"newData\":{\"data\":[{\"ware_id\":3,\"house_id\":16,\"house_name\":\"成品-铝车架\",\"operate\":1,\"type\":10,\"plan_id\":\"\",\"plan\":\"\",\"notice_id\":11,\"item_id\":20,\"sale_id\":\"\",\"code\":\"WA-A00001\",\"name\":\"0611铝车架\",\"model_spec\":\"城市代步Q1\",\"other_features\":\"折叠型\",\"quantity\":\"1000\",\"buy_price\":\"600\",\"price\":\"540\",\"approval\":[]}],\"type\":\"material_warehouse\"}}', '2025-11-29 09:01:17');
INSERT INTO `sub_operation_history` VALUES (143, 3, 15, '粟云', 'approval', '成品出入库', '审批通过了出/入库单，它们有：{ 仓库：成品-铝车架，入库方式：生产入库，物料编码：WA-A00001 }', '{\"newData\":{\"data\":[12],\"action\":1,\"ware_id\":3}}', '2025-11-29 09:01:51');
INSERT INTO `sub_operation_history` VALUES (144, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-11-30 12:05:19');
INSERT INTO `sub_operation_history` VALUES (145, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-11-30 12:50:29');
INSERT INTO `sub_operation_history` VALUES (146, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-11-30 13:04:55');
INSERT INTO `sub_operation_history` VALUES (147, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-11-30 13:05:52');
INSERT INTO `sub_operation_history` VALUES (148, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-11-30 13:07:05');
INSERT INTO `sub_operation_history` VALUES (149, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-11-30 13:15:39');
INSERT INTO `sub_operation_history` VALUES (150, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-11-30 13:57:19');
INSERT INTO `sub_operation_history` VALUES (151, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-11-30 14:01:18');
INSERT INTO `sub_operation_history` VALUES (152, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-12-01 00:55:01');
INSERT INTO `sub_operation_history` VALUES (153, 3, 6, '徐庆华', 'update', '原材料编码', '修改原材料编码：H0101-0089', '{\"newData\":{\"id\":4,\"user_id\":6,\"company_id\":3,\"material_code\":\"H0101-0089\",\"material_name\":\"车首管\",\"model\":\"JHD-AT-0074*146L\",\"specification\":\"JHD-AT-0074*146L\",\"other_features\":\"\",\"usage_unit\":51,\"purchase_unit\":54,\"category\":49,\"is_deleted\":1,\"created_at\":\"2025-10-18\",\"updated_at\":\"2025-11-28\"}}', '2025-12-01 00:58:49');
INSERT INTO `sub_operation_history` VALUES (154, 3, 6, '徐庆华', 'update', '原材料编码', '修改原材料编码：H0101-0089', '{\"newData\":{\"id\":4,\"user_id\":6,\"company_id\":3,\"material_code\":\"H0101-0089\",\"material_name\":\"车首管\",\"model\":\"JHD-AT-0074*146L\",\"specification\":\"JHD-AT-0074*146L\",\"other_features\":\"\",\"usage_unit\":51,\"purchase_unit\":54,\"category\":50,\"is_deleted\":1,\"created_at\":\"2025-10-18\",\"updated_at\":\"2025-12-01\"}}', '2025-12-01 00:59:21');
INSERT INTO `sub_operation_history` VALUES (155, 3, 6, '徐庆华', 'update', '原材料编码', '修改原材料编码：H0201-0053', '{\"newData\":{\"id\":5,\"user_id\":6,\"company_id\":3,\"material_code\":\"H0201-0053\",\"material_name\":\"五通\",\"model\":\"φ43*4.6T*100L JHD-AK-002G偏心铣弧口\",\"specification\":\"φ43*4.6T*100L JHD-AK-002G偏心铣弧口\",\"other_features\":\"\",\"usage_unit\":51,\"purchase_unit\":51,\"category\":50,\"is_deleted\":1,\"created_at\":\"2025-10-18\",\"updated_at\":\"2025-11-28\"}}', '2025-12-01 00:59:36');
INSERT INTO `sub_operation_history` VALUES (156, 3, 6, '徐庆华', 'update', '原材料编码', '修改原材料编码：H0201-0053', '{\"newData\":{\"id\":5,\"user_id\":6,\"company_id\":3,\"material_code\":\"H0201-0053\",\"material_name\":\"五通\",\"model\":\"φ43*4.6T*100L JHD-AK-002G偏心铣弧口\",\"specification\":\"φ43*4.6T*100L JHD-AK-002G偏心铣弧口\",\"other_features\":\"\",\"usage_unit\":51,\"purchase_unit\":54,\"category\":50,\"is_deleted\":1,\"created_at\":\"2025-10-18\",\"updated_at\":\"2025-12-01\"}}', '2025-12-01 00:59:48');
INSERT INTO `sub_operation_history` VALUES (157, 3, 6, '徐庆华', 'update', '原材料编码', '修改原材料编码：H0302-0013', '{\"newData\":{\"id\":21,\"user_id\":15,\"company_id\":3,\"material_code\":\"H0302-0013\",\"material_name\":\"左勾爪\",\"model\":\"YD001-003DS-45度\",\"specification\":\"YD001-003DS-45度\",\"other_features\":\"\",\"usage_unit\":51,\"purchase_unit\":54,\"category\":50,\"is_deleted\":1,\"created_at\":\"2025-10-28\",\"updated_at\":\"2025-11-29\"}}', '2025-12-01 01:00:03');
INSERT INTO `sub_operation_history` VALUES (158, 3, 6, '徐庆华', 'update', '原材料编码', '修改原材料编码：H0302-0014', '{\"newData\":{\"id\":22,\"user_id\":6,\"company_id\":3,\"material_code\":\"H0302-0014\",\"material_name\":\"右勾爪\",\"model\":\"YD001-003DS-45度\",\"specification\":\"YD001-003DS-45度\",\"other_features\":\"\",\"usage_unit\":51,\"purchase_unit\":54,\"category\":50,\"is_deleted\":1,\"created_at\":\"2025-10-28\",\"updated_at\":\"2025-11-28\"}}', '2025-12-01 01:00:21');
INSERT INTO `sub_operation_history` VALUES (159, 3, 6, '徐庆华', 'update', '原材料编码', '修改原材料编码：H0401-0036', '{\"newData\":{\"id\":24,\"user_id\":6,\"company_id\":3,\"material_code\":\"H0401-0036\",\"material_name\":\"折叠器\",\"model\":\"ZHD-DX160-T01/02-Z\",\"specification\":\"ZHD-DX160-T01/02-Z\",\"other_features\":\"\",\"usage_unit\":51,\"purchase_unit\":51,\"category\":49,\"is_deleted\":1,\"created_at\":\"2025-10-28\",\"updated_at\":\"2025-11-28\"}}', '2025-12-01 01:00:38');
INSERT INTO `sub_operation_history` VALUES (160, 3, 6, '徐庆华', 'update', '原材料编码', '修改原材料编码：H0702-0001', '{\"newData\":{\"id\":20,\"user_id\":6,\"company_id\":3,\"material_code\":\"H0702-0001\",\"material_name\":\"止栓\",\"model\":\"YD004-026\",\"specification\":\"YD004-026\",\"other_features\":\"50个/盒\",\"usage_unit\":47,\"purchase_unit\":55,\"category\":49,\"is_deleted\":1,\"created_at\":\"2025-10-28\",\"updated_at\":\"2025-11-28\"}}', '2025-12-01 01:01:36');
INSERT INTO `sub_operation_history` VALUES (161, 3, 6, '徐庆华', 'update', '原材料编码', '修改原材料编码：H0703-0001', '{\"newData\":{\"id\":12,\"user_id\":6,\"company_id\":3,\"material_code\":\"H0703-0001\",\"material_name\":\"油压线扣\",\"model\":\"YD007-004\",\"specification\":\"YD007-004\",\"other_features\":\"100个/盒\",\"usage_unit\":47,\"purchase_unit\":55,\"category\":49,\"is_deleted\":1,\"created_at\":\"2025-10-27\",\"updated_at\":\"2025-11-28\"}}', '2025-12-01 01:02:02');
INSERT INTO `sub_operation_history` VALUES (162, 3, 6, '徐庆华', 'update', '原材料编码', '修改原材料编码：H0801-0001', '{\"newData\":{\"id\":17,\"user_id\":6,\"company_id\":3,\"material_code\":\"H0801-0001\",\"material_name\":\"硬焊螺母\",\"model\":\"YD008-006 M5*9L普通\",\"specification\":\"YD008-006 M5*9L普通\",\"other_features\":\"20个/盒\",\"usage_unit\":47,\"purchase_unit\":55,\"category\":49,\"is_deleted\":1,\"created_at\":\"2025-10-28\",\"updated_at\":\"2025-11-28\"}}', '2025-12-01 01:02:34');
INSERT INTO `sub_operation_history` VALUES (163, 3, 6, '徐庆华', 'update', '原材料编码', '修改原材料编码：H0801-0004', '{\"newData\":{\"id\":11,\"user_id\":6,\"company_id\":3,\"material_code\":\"H0801-0004\",\"material_name\":\"水壶螺母\",\"model\":\"YD008-044（M4）\",\"specification\":\"YD008-044（M4）\",\"other_features\":\"20个/盒\",\"usage_unit\":47,\"purchase_unit\":55,\"category\":49,\"is_deleted\":1,\"created_at\":\"2025-10-27\",\"updated_at\":\"2025-11-28\"}}', '2025-12-01 01:02:54');
INSERT INTO `sub_operation_history` VALUES (164, 3, 6, '徐庆华', 'update', '原材料编码', '修改原材料编码：H0802-0001', '{\"newData\":{\"id\":27,\"user_id\":6,\"company_id\":3,\"material_code\":\"H0802-0001\",\"material_name\":\"货架螺母\",\"model\":\"YD008-021 M5\",\"specification\":\"YD008-021 M5\",\"other_features\":\"20个/盒\",\"usage_unit\":47,\"purchase_unit\":55,\"category\":49,\"is_deleted\":1,\"created_at\":\"2025-10-30\",\"updated_at\":\"2025-11-28\"}}', '2025-12-01 01:03:15');
INSERT INTO `sub_operation_history` VALUES (165, 3, 6, '徐庆华', 'update', '原材料编码', '修改原材料编码：H1102-0099', '{\"newData\":{\"id\":25,\"user_id\":6,\"company_id\":3,\"material_code\":\"H1102-0099\",\"material_name\":\"加强片\",\"model\":\"JHD-BQ-211\",\"specification\":\"JHD-BQ-211\",\"other_features\":\"10个/包\",\"usage_unit\":47,\"purchase_unit\":56,\"category\":49,\"is_deleted\":1,\"created_at\":\"2025-10-28\",\"updated_at\":\"2025-11-28\"}}', '2025-12-01 01:03:53');
INSERT INTO `sub_operation_history` VALUES (166, 3, 6, '徐庆华', 'update', '原材料编码', '修改原材料编码：H1201-0001', '{\"newData\":{\"id\":26,\"user_id\":6,\"company_id\":3,\"material_code\":\"H1201-0001\",\"material_name\":\"支撑棒\",\"model\":\"JS-ZJ-001*120L\",\"specification\":\"JS-ZJ-001*120L\",\"other_features\":\"\",\"usage_unit\":57,\"purchase_unit\":57,\"category\":49,\"is_deleted\":1,\"created_at\":\"2025-10-28\",\"updated_at\":\"2025-11-28\"}}', '2025-12-01 01:05:32');
INSERT INTO `sub_operation_history` VALUES (167, 3, 6, '徐庆华', 'update', '原材料编码', '修改原材料编码：H1202-0012', '{\"newData\":{\"id\":23,\"user_id\":6,\"company_id\":3,\"material_code\":\"H1202-0012\",\"material_name\":\"边支撑\",\"model\":\"JHD-TC18\",\"specification\":\"JHD-TC18\",\"other_features\":\"\",\"usage_unit\":57,\"purchase_unit\":57,\"category\":49,\"is_deleted\":1,\"created_at\":\"2025-10-28\",\"updated_at\":\"2025-11-28\"}}', '2025-12-01 01:06:12');
INSERT INTO `sub_operation_history` VALUES (168, 3, 6, '徐庆华', 'update', '原材料编码', '修改原材料编码：M0101-0565', '{\"newData\":{\"id\":8,\"user_id\":6,\"company_id\":3,\"material_code\":\"M0101-0565\",\"material_name\":\"下管\",\"model\":\"φ28.6*2.0T*220L\",\"specification\":\"φ28.6*2.0T*220L\",\"other_features\":\"\",\"usage_unit\":51,\"purchase_unit\":54,\"category\":50,\"is_deleted\":1,\"created_at\":\"2025-10-27\",\"updated_at\":\"2025-11-28\"}}', '2025-12-01 01:07:00');
INSERT INTO `sub_operation_history` VALUES (169, 3, 6, '徐庆华', 'update', '原材料编码', '修改原材料编码：M0101-0019', '{\"newData\":{\"id\":15,\"user_id\":6,\"company_id\":3,\"material_code\":\"M0101-0019\",\"material_name\":\"上枝杆\",\"model\":\"φ19*1.8T*105L（±1MM)\",\"specification\":\"φ19*1.8T*105L（±1MM)\",\"other_features\":\"\",\"usage_unit\":51,\"purchase_unit\":54,\"category\":49,\"is_deleted\":1,\"created_at\":\"2025-10-28\",\"updated_at\":\"2025-11-28\"}}', '2025-12-01 01:07:21');
INSERT INTO `sub_operation_history` VALUES (170, 3, 6, '徐庆华', 'update', '原材料编码', '修改原材料编码：M0101-0020', '{\"newData\":{\"id\":16,\"user_id\":6,\"company_id\":3,\"material_code\":\"M0101-0020\",\"material_name\":\"下枝杆\",\"model\":\"φ19*1.8T*105L（±1MM)\",\"specification\":\"φ19*1.8T*105L（±1MM)\",\"other_features\":\"\",\"usage_unit\":51,\"purchase_unit\":54,\"category\":50,\"is_deleted\":1,\"created_at\":\"2025-10-28\",\"updated_at\":\"2025-11-28\"}}', '2025-12-01 01:07:34');
INSERT INTO `sub_operation_history` VALUES (171, 3, 6, '徐庆华', 'update', '原材料编码', '修改原材料编码：M0101-0444', '{\"newData\":{\"id\":18,\"user_id\":6,\"company_id\":3,\"material_code\":\"M0101-0444\",\"material_name\":\"后下叉R\",\"model\":\"φ22.2*2.0*420L\",\"specification\":\"φ22.2*2.0*420L\",\"other_features\":\"\",\"usage_unit\":51,\"purchase_unit\":54,\"category\":50,\"is_deleted\":1,\"created_at\":\"2025-10-28\",\"updated_at\":\"2025-11-28\"}}', '2025-12-01 01:07:52');
INSERT INTO `sub_operation_history` VALUES (172, 3, 6, '徐庆华', 'update', '原材料编码', '修改原材料编码：M0101-0445', '{\"newData\":{\"id\":19,\"user_id\":6,\"company_id\":3,\"material_code\":\"M0101-0445\",\"material_name\":\"后下叉L\",\"model\":\"φ22.2*2.0*420L\",\"specification\":\"φ22.2*2.0*420L\",\"other_features\":\"\",\"usage_unit\":51,\"purchase_unit\":54,\"category\":50,\"is_deleted\":1,\"created_at\":\"2025-10-28\",\"updated_at\":\"2025-11-28\"}}', '2025-12-01 01:08:04');
INSERT INTO `sub_operation_history` VALUES (173, 3, 6, '徐庆华', 'update', '原材料编码', '修改原材料编码：M0101-0635', '{\"newData\":{\"id\":13,\"user_id\":6,\"company_id\":3,\"material_code\":\"M0101-0635\",\"material_name\":\"后上叉L\",\"model\":\"φ19*2.0T*455L\",\"specification\":\"φ19*2.0T*455L\",\"other_features\":\"\",\"usage_unit\":51,\"purchase_unit\":54,\"category\":50,\"is_deleted\":1,\"created_at\":\"2025-10-28\",\"updated_at\":\"2025-11-28\"}}', '2025-12-01 01:08:17');
INSERT INTO `sub_operation_history` VALUES (174, 3, 6, '徐庆华', 'update', '原材料编码', '修改原材料编码：M0101-0636', '{\"newData\":{\"id\":14,\"user_id\":6,\"company_id\":3,\"material_code\":\"M0101-0636\",\"material_name\":\"后上叉R\",\"model\":\"φ19*2.0T*455L\",\"specification\":\"φ19*2.0T*455L\",\"other_features\":\"\",\"usage_unit\":51,\"purchase_unit\":54,\"category\":50,\"is_deleted\":1,\"created_at\":\"2025-10-28\",\"updated_at\":\"2025-11-28\"}}', '2025-12-01 01:08:29');
INSERT INTO `sub_operation_history` VALUES (175, 3, 6, '徐庆华', 'update', '原材料编码', '修改原材料编码：M0101-0668', '{\"newData\":{\"id\":6,\"user_id\":6,\"company_id\":3,\"material_code\":\"M0101-0668\",\"material_name\":\"中管\",\"model\":\"φ40.8*2.2T*410L\",\"specification\":\"φ40.8*2.2T*410L\",\"other_features\":\"\",\"usage_unit\":51,\"purchase_unit\":54,\"category\":50,\"is_deleted\":1,\"created_at\":\"2025-10-18\",\"updated_at\":\"2025-11-28\"}}', '2025-12-01 01:08:43');
INSERT INTO `sub_operation_history` VALUES (176, 3, 6, '徐庆华', 'update', '原材料编码', '修改原材料编码：M0101-1123', '{\"newData\":{\"id\":7,\"user_id\":6,\"company_id\":3,\"material_code\":\"M0101-1123\",\"material_name\":\"手提管\",\"model\":\"φ22.2*2.0T*200L\",\"specification\":\"φ22.2*2.0T*200L\",\"other_features\":\"\",\"usage_unit\":51,\"purchase_unit\":54,\"category\":50,\"is_deleted\":1,\"created_at\":\"2025-10-27\",\"updated_at\":\"2025-11-28\"}}', '2025-12-01 01:08:54');
INSERT INTO `sub_operation_history` VALUES (177, 3, 6, '徐庆华', 'update', '原材料编码', '修改原材料编码：M0103-0015', '{\"newData\":{\"id\":9,\"user_id\":6,\"company_id\":3,\"material_code\":\"M0103-0015\",\"material_name\":\"过线管\",\"model\":\"方27*17*2000L(CM-15114)(成品15L,一分百)\",\"specification\":\"方27*17*2000L(CM-15114)(成品15L,一分百)\",\"other_features\":\"\",\"usage_unit\":51,\"purchase_unit\":54,\"category\":50,\"is_deleted\":1,\"created_at\":\"2025-10-27\",\"updated_at\":\"2025-11-28\"}}', '2025-12-01 01:09:07');
INSERT INTO `sub_operation_history` VALUES (178, 3, 6, '徐庆华', 'update', '原材料编码', '修改原材料编码：M0103-0234', '{\"newData\":{\"id\":10,\"user_id\":6,\"company_id\":3,\"material_code\":\"M0103-0234\",\"material_name\":\"主梁管\",\"model\":\"方121*65*600L\",\"specification\":\"方121*65*600L\",\"other_features\":\"\",\"usage_unit\":51,\"purchase_unit\":54,\"category\":50,\"is_deleted\":1,\"created_at\":\"2025-10-27\",\"updated_at\":\"2025-11-28\"}}', '2025-12-01 01:09:19');
INSERT INTO `sub_operation_history` VALUES (179, 3, 15, '粟云', 'login', '登录', '用户{ 粟云 }成功登录', '{\"newData\":{\"username\":\"suyun\",\"password\":\"***\"}}', '2025-12-01 02:03:57');
INSERT INTO `sub_operation_history` VALUES (180, 3, 15, '粟云', 'login', '登录', '用户{ 粟云 }成功登录', '{\"newData\":{\"username\":\"suyun\",\"password\":\"***\"}}', '2025-12-01 02:04:00');
INSERT INTO `sub_operation_history` VALUES (181, 3, 6, '徐庆华', 'keyApproval', '材料出入库', '出/入库单提交审核：{ 仓库：成品-铝车架，出库方式：成品出货，物料编码：WA-A00001 }', '{\"newData\":{\"data\":[{\"ware_id\":3,\"house_id\":16,\"house_name\":\"成品-铝车架\",\"operate\":2,\"type\":14,\"plan_id\":4,\"plan\":\"旭欧\",\"notice_id\":11,\"item_id\":20,\"sale_id\":5,\"code\":\"WA-A00001\",\"name\":\"0611铝车架\",\"model_spec\":\"城市代步Q1\",\"other_features\":\"折叠型\",\"quantity\":\"800\",\"buy_price\":\"580\",\"price\":540,\"unit\":52,\"inv_unit\":\"\",\"approval\":[]}],\"type\":\"material_warehouse\"}}', '2025-12-01 02:29:23');
INSERT INTO `sub_operation_history` VALUES (182, 3, 15, '粟云', 'approval', '成品出入库', '审批通过了出/入库单，它们有：{ 仓库：成品-铝车架，出库方式：成品出货，物料编码：WA-A00001 }', '{\"newData\":{\"data\":[13],\"action\":1,\"ware_id\":3}}', '2025-12-01 02:29:46');
INSERT INTO `sub_operation_history` VALUES (183, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-12-01 02:56:44');
INSERT INTO `sub_operation_history` VALUES (184, 3, 15, '粟云', 'login', '登录', '用户{ 粟云 }成功登录', '{\"newData\":{\"username\":\"suyun\",\"password\":\"***\"}}', '2025-12-01 07:46:09');
INSERT INTO `sub_operation_history` VALUES (185, 3, 15, '粟云', 'keyApproval', '采购作业', '采购作业提交审核：{ 供应商编码：GA001，生产订单号：DD2511001，产品编码：WA-A00001，材料编码：M0103-0234 }', '{\"newData\":{\"data\":[{\"quote_id\":null,\"material_bom_children_id\":44,\"material_bom_id\":30,\"notice_id\":11,\"notice\":\"DD2511001\",\"supplier_id\":6,\"supplier_code\":\"GA001\",\"supplier_abbreviation\":\"晶鑫昌\",\"product_id\":20,\"product_code\":\"WA-A00001\",\"product_name\":\"0611铝车架\",\"material_id\":10,\"material_code\":\"M0103-0234\",\"material_name\":\"主梁管\",\"model_spec\":\"方121*65*600L\",\"other_features\":null,\"unit\":54,\"usage_unit\":51,\"price\":\"2.8\",\"order_number\":null,\"number\":\"18000\",\"delivery_time\":\"2025-12-28\",\"approval\":[]}],\"type\":\"purchase_order\"}}', '2025-12-01 07:59:12');
INSERT INTO `sub_operation_history` VALUES (186, 3, 15, '粟云', 'approval', '采购作业', '审批通过了采购作业，它们有：{ 供应商编码：GA001，生产订单号：DD2511001，产品编码：WA-A00001，材料编码：M0103-0234 }', '{\"newData\":{\"data\":[{\"id\":3,\"company_id\":3,\"user_id\":15,\"quote_id\":null,\"material_bom_id\":\"30\",\"print_id\":null,\"notice_id\":11,\"notice\":\"DD2511001\",\"supplier_id\":6,\"supplier_code\":\"GA001\",\"supplier_abbreviation\":\"晶鑫昌\",\"product_id\":\"20\",\"product_code\":\"WA-A00001\",\"product_name\":\"0611铝车架\",\"material_id\":10,\"material_code\":\"M0103-0234\",\"material_name\":\"主梁管\",\"model_spec\":\"方121*65*600L\",\"other_features\":null,\"unit\":54,\"usage_unit\":51,\"price\":\"2.8\",\"order_number\":null,\"number\":\"18000\",\"delivery_time\":\"2025-12-28\",\"apply_id\":15,\"apply_name\":\"粟云\",\"apply_time\":\"2025-12-01\",\"step\":0,\"status\":0,\"is_buying\":1,\"is_houser\":1,\"order_id\":1,\"is_deleted\":1,\"created_at\":\"2025-12-01\",\"updated_at\":\"2025-12-01\",\"approval\":[{\"user_id\":15,\"user_name\":\"粟云\",\"type\":\"purchase_order\",\"step\":1,\"company_id\":3,\"source_id\":3,\"user_time\":null,\"status\":0,\"id\":18},{\"user_id\":16,\"user_name\":\"冷冰\",\"type\":\"purchase_order\",\"step\":2,\"company_id\":3,\"source_id\":3,\"user_time\":null,\"status\":0,\"id\":19}]}],\"type\":\"purchase_order\"}}', '2025-12-01 07:59:15');
INSERT INTO `sub_operation_history` VALUES (187, 3, 16, '冷冰', 'login', '登录', '用户{ 冷冰 }成功登录', '{\"newData\":{\"username\":\"lengbing\",\"password\":\"***\"}}', '2025-12-01 07:59:34');
INSERT INTO `sub_operation_history` VALUES (188, 3, 16, '冷冰', 'approval', '采购作业', '审批通过了采购作业，它们有：{ 供应商编码：GA001，生产订单号：DD2511001，产品编码：WA-A00001，材料编码：M0103-0234 }', '{\"newData\":{\"data\":[{\"id\":3,\"company_id\":3,\"user_id\":15,\"quote_id\":null,\"material_bom_id\":\"30\",\"print_id\":null,\"notice_id\":11,\"notice\":\"DD2511001\",\"supplier_id\":6,\"supplier_code\":\"GA001\",\"supplier_abbreviation\":\"晶鑫昌\",\"product_id\":\"20\",\"product_code\":\"WA-A00001\",\"product_name\":\"0611铝车架\",\"material_id\":10,\"material_code\":\"M0103-0234\",\"material_name\":\"主梁管\",\"model_spec\":\"方121*65*600L\",\"other_features\":null,\"unit\":54,\"usage_unit\":51,\"price\":\"2.8\",\"order_number\":null,\"number\":\"18000\",\"delivery_time\":\"2025-12-28\",\"apply_id\":15,\"apply_name\":\"粟云\",\"apply_time\":\"2025-12-01\",\"step\":1,\"status\":0,\"is_buying\":1,\"is_houser\":1,\"order_id\":1,\"is_deleted\":1,\"created_at\":\"2025-12-01\",\"updated_at\":\"2025-12-01\",\"approval\":[{\"user_id\":15,\"user_name\":\"粟云\",\"type\":\"purchase_order\",\"step\":1,\"company_id\":3,\"source_id\":3,\"user_time\":null,\"status\":1,\"id\":18},{\"user_id\":16,\"user_name\":\"冷冰\",\"type\":\"purchase_order\",\"step\":2,\"company_id\":3,\"source_id\":3,\"user_time\":null,\"status\":0,\"id\":19}]}],\"type\":\"purchase_order\"}}', '2025-12-01 07:59:39');
INSERT INTO `sub_operation_history` VALUES (189, 3, 15, '粟云', 'login', '登录', '用户{ 粟云 }成功登录', '{\"newData\":{\"username\":\"suyun\",\"password\":\"***\"}}', '2025-12-01 08:02:06');
INSERT INTO `sub_operation_history` VALUES (190, 3, 15, '粟云', 'login', '登录', '用户{ 粟云 }成功登录', '{\"newData\":{\"username\":\"suyun\",\"password\":\"***\"}}', '2025-12-01 08:04:13');
INSERT INTO `sub_operation_history` VALUES (191, 3, 15, '粟云', 'keyApproval', '材料出入库', '出/入库单提交审核：{ 仓库：管料仓-铝管，入库方式：采购入库，物料编码：M0103-0234 }', '{\"newData\":{\"data\":[{\"ware_id\":1,\"house_id\":14,\"house_name\":\"管料仓-铝管\",\"operate\":1,\"type\":4,\"plan_id\":6,\"plan\":\"晶鑫昌\",\"procure_id\":3,\"notice_id\":null,\"item_id\":10,\"code\":\"M0103-0234\",\"name\":\"主梁管\",\"model_spec\":\"\",\"other_features\":null,\"quantity\":\"18000\",\"pay_quantity\":\"700\",\"buy_price\":\"2.8\",\"price\":\"3.3\",\"unit\":54,\"inv_unit\":51,\"approval\":[]}],\"type\":\"material_warehouse\"}}', '2025-12-01 08:05:35');
INSERT INTO `sub_operation_history` VALUES (192, 3, 15, '粟云', 'approval', '材料出入库', '审批通过了出/入库单，它们有：{ 仓库：管料仓-铝管，入库方式：采购入库，物料编码：M0103-0234 }', '{\"newData\":{\"data\":[14],\"action\":1,\"ware_id\":1}}', '2025-12-01 08:05:38');
INSERT INTO `sub_operation_history` VALUES (193, 3, 15, '粟云', 'keyApproval', '材料出入库', '出/入库单提交审核：{ 仓库：管料仓-铝管，入库方式：采购入库，物料编码：H0302-0013 }', '{\"newData\":{\"data\":[{\"ware_id\":1,\"house_id\":14,\"house_name\":\"管料仓-铝管\",\"operate\":1,\"type\":4,\"plan_id\":6,\"plan\":\"晶鑫昌\",\"procure_id\":2,\"notice_id\":11,\"item_id\":21,\"code\":\"H0302-0013\",\"name\":\"左勾爪\",\"model_spec\":\"\",\"other_features\":null,\"quantity\":\"2000\",\"pay_quantity\":\"2000\",\"buy_price\":\"2.8\",\"price\":3,\"unit\":51,\"inv_unit\":51,\"approval\":[]}],\"type\":\"material_warehouse\"}}', '2025-12-01 08:23:05');
INSERT INTO `sub_operation_history` VALUES (194, 3, 15, '粟云', 'approval', '材料出入库', '审批通过了出/入库单，它们有：{ 仓库：管料仓-铝管，入库方式：采购入库，物料编码：H0302-0013 }', '{\"newData\":{\"data\":[15],\"action\":1,\"ware_id\":1}}', '2025-12-01 08:23:11');
INSERT INTO `sub_operation_history` VALUES (195, 3, 15, '粟云', 'update', '设备编码', '修改设备编码：WX01', '{\"newData\":{\"id\":49,\"company_id\":3,\"user_id\":15,\"equipment_code\":\"WX01\",\"equipment_name\":\"电脑锣\",\"quantity\":3,\"cycle_id\":18,\"working_hours\":10,\"efficiency\":0,\"available\":0,\"remarks\":\"\",\"is_deleted\":1,\"created_at\":\"2025-11-29\",\"updated_at\":\"2025-11-29\",\"cycle\":{\"id\":18,\"company_id\":3,\"user_id\":15,\"name\":\"外协组\",\"sort\":\"1\",\"sort_date\":\"2\",\"is_deleted\":1,\"created_at\":\"2025-11-28T08:31:17.000Z\",\"updated_at\":\"2025-11-29T07:01:39.000Z\"}}}', '2025-12-01 08:27:24');
INSERT INTO `sub_operation_history` VALUES (196, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-12-02 02:09:14');
INSERT INTO `sub_operation_history` VALUES (197, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-12-03 01:01:23');
INSERT INTO `sub_operation_history` VALUES (198, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-12-03 01:01:33');
INSERT INTO `sub_operation_history` VALUES (199, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-12-03 01:01:43');
INSERT INTO `sub_operation_history` VALUES (200, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-12-03 01:09:41');
INSERT INTO `sub_operation_history` VALUES (201, 3, 6, '徐庆华', 'keyApproval', '采购作业', '采购作业提交审核：8', '{\"newData\":{\"data\":[8],\"type\":\"purchase_order\"}}', '2025-12-03 05:43:05');
INSERT INTO `sub_operation_history` VALUES (202, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-12-03 08:49:51');
INSERT INTO `sub_operation_history` VALUES (203, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-12-03 12:24:20');
INSERT INTO `sub_operation_history` VALUES (204, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-12-04 03:47:00');
INSERT INTO `sub_operation_history` VALUES (205, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-12-04 04:46:52');

-- ----------------------------
-- Table structure for sub_outscription_order
-- ----------------------------
DROP TABLE IF EXISTS `sub_outscription_order`;
CREATE TABLE `sub_outscription_order`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键ID',
  `company_id` int(11) NULL DEFAULT NULL COMMENT '企业id',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '发布的用户id',
  `print_id` int(30) NULL DEFAULT NULL COMMENT '打印的id',
  `notice_id` int(10) NULL DEFAULT NULL COMMENT '生产通知单ID',
  `quote_id` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '委外报价ID',
  `supplier_id` int(11) NULL DEFAULT NULL COMMENT '供应商ID',
  `process_bom_id` int(11) NULL DEFAULT NULL COMMENT '工艺BOM id',
  `process_bom_children_id` int(5) NULL DEFAULT NULL COMMENT '工艺BOM副表的id',
  `unit` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '单位',
  `price` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '加工单价',
  `number` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '委外数量',
  `transaction_currency` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '交易币别',
  `ment` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '加工要求',
  `delivery_time` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '要求交期',
  `transaction_terms` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '交易方式',
  `remarks` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '备注',
  `status` int(1) NULL DEFAULT 0 COMMENT '状态（0审批中/1通过/2拒绝3反审核）',
  `order_id` int(11) NULL DEFAULT NULL COMMENT '委外加工单ID',
  `is_buying` int(1) NULL DEFAULT 1 COMMENT '是否已生成委外加工单：1未生成，0已生成',
  `apply_id` int(11) NULL DEFAULT NULL COMMENT '申请人ID',
  `apply_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '申请人名称',
  `apply_time` timestamp NULL DEFAULT NULL COMMENT '申请时间',
  `step` int(2) NULL DEFAULT 0 COMMENT '审核当前在第几步，默认0，每审核一步加1',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '委外作业表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_outscription_order
-- ----------------------------
INSERT INTO `sub_outscription_order` VALUES (2, 3, 15, NULL, 11, '2', 6, 76, 180, '51', '1.35', '18000', 'RMB', '不接受漏焊', '2025-12-06', NULL, '', 1, 2, 0, 15, '粟云', '2025-11-29 16:30:21', 2, 1, '2025-11-29 16:30:21', '2025-11-29 16:30:51');

-- ----------------------------
-- Table structure for sub_outsourcing_order
-- ----------------------------
DROP TABLE IF EXISTS `sub_outsourcing_order`;
CREATE TABLE `sub_outsourcing_order`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `company_id` int(11) NULL DEFAULT NULL COMMENT '企业ID',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '发布的用户id',
  `notice_id` int(11) NULL DEFAULT NULL COMMENT '生产订单ID',
  `notice` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生产订单号',
  `supplier_id` int(11) NULL DEFAULT NULL COMMENT '供应商ID',
  `supplier_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商编码',
  `supplier_abbreviation` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商名称',
  `product_id` int(11) NULL DEFAULT NULL COMMENT '产品ID',
  `product_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '产品编码',
  `product_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '产品名称',
  `no` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单编号',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '委外加工单' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_outsourcing_order
-- ----------------------------
INSERT INTO `sub_outsourcing_order` VALUES (2, 3, 15, 11, 'DD2511001', 6, 'GA001', '晶鑫昌', 20, 'WA-A00001', '0611铝车架', 'WW032511001', 1, '2025-11-29 16:30:51', '2025-11-29 16:31:18');

-- ----------------------------
-- Table structure for sub_outsourcing_quote
-- ----------------------------
DROP TABLE IF EXISTS `sub_outsourcing_quote`;
CREATE TABLE `sub_outsourcing_quote`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键ID',
  `company_id` int(11) NOT NULL COMMENT '企业id',
  `user_id` int(11) NOT NULL COMMENT '发布的用户id',
  `notice_id` int(10) NULL DEFAULT NULL COMMENT '生产通知单ID',
  `supplier_id` int(11) NOT NULL COMMENT '供应商ID',
  `process_bom_id` int(11) NOT NULL COMMENT '工艺BOM id',
  `process_bom_children_id` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '工艺BOM副表的id',
  `price` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '加工单价',
  `now_price` int(11) NULL DEFAULT NULL COMMENT '实际单价',
  `number` int(11) NULL DEFAULT NULL COMMENT '委外实际数量',
  `transaction_currency` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '交易币别',
  `transaction_method` int(5) NULL DEFAULT NULL COMMENT '交易方式',
  `other_transaction_terms` varchar(5) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '结算周期',
  `other_text` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '其他结算周期',
  `invoice` int(5) NULL DEFAULT NULL COMMENT '税票要求',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '委外报价信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_outsourcing_quote
-- ----------------------------
INSERT INTO `sub_outsourcing_quote` VALUES (2, 3, 15, 11, 6, 76, '180', '1.35', 1, 18000, 'RMB', 27, '31', '', 44, 1, '2025-11-29 16:25:00', '2025-11-29 16:25:00');

-- ----------------------------
-- Table structure for sub_part_code
-- ----------------------------
DROP TABLE IF EXISTS `sub_part_code`;
CREATE TABLE `sub_part_code`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键ID',
  `user_id` int(5) NULL DEFAULT NULL COMMENT '发布的用户id',
  `company_id` int(5) NULL DEFAULT NULL COMMENT '企业id',
  `part_code` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '部件编码',
  `part_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '部件名称',
  `model` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '型号',
  `specification` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '规格',
  `other_features` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '其它特性',
  `unit` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '单位',
  `production_requirements` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '生产要求',
  `remarks` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '备注',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '1：未删除；0：已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '记录创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '记录最后更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 52 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '部件编码基础信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_part_code
-- ----------------------------
INSERT INTO `sub_part_code` VALUES (5, 1, 1, 'C002', '笔芯', '212', '1212', '121', '', '3131', '3131', 1, '2025-07-08 15:35:24', '2025-11-28 11:19:04');
INSERT INTO `sub_part_code` VALUES (6, 1, 1, 'C001', '笔筒', '12', '1212', '1', '', '2121', '2121', 1, '2025-07-08 15:36:15', '2025-11-28 11:19:05');
INSERT INTO `sub_part_code` VALUES (7, 1, 1, '1234', '2124', '212', '1212', '121', '', '3131', '3131', 1, '2025-07-08 15:35:24', '2025-11-28 11:19:05');
INSERT INTO `sub_part_code` VALUES (8, 1, 1, '1238', '2128', '212', '1212', '121', '', '3131', '3131', 1, '2025-07-08 15:35:24', '2025-11-28 11:19:06');
INSERT INTO `sub_part_code` VALUES (9, 1, 1, '12310', '21210', '212', '1212', '121', '', '3131', '3131', 1, '2025-07-08 15:35:24', '2025-11-28 11:19:06');
INSERT INTO `sub_part_code` VALUES (10, 1, 1, '12311', '21211', '212', '1212', '121', '', '3131', '3131', 1, '2025-07-08 15:35:24', '2025-11-28 11:19:07');
INSERT INTO `sub_part_code` VALUES (12, 1, 1, '12312', '21212', '212', '1212', '121', '', '3131', '3131', 1, '2025-07-08 15:35:24', '2025-11-28 11:19:07');
INSERT INTO `sub_part_code` VALUES (13, 1, 1, '12313', '21213', '212', '1212', '121', '', '3131', '3131', 1, '2025-07-08 15:35:24', '2025-11-28 11:19:09');
INSERT INTO `sub_part_code` VALUES (14, 1, 1, '12314', '21214', '212', '1212', '121', '', '3131', '3131', 1, '2025-07-08 15:35:24', '2025-11-28 11:19:09');
INSERT INTO `sub_part_code` VALUES (15, 1, 1, '12315', '21215', '212', '1212', '121', '', '3131', '3131', 1, '2025-07-08 15:35:24', '2025-11-28 11:19:10');
INSERT INTO `sub_part_code` VALUES (16, 1, 1, '12316', '21216', '212', '1212', '121', '', '3131', '3131', 1, '2025-07-08 15:35:24', '2025-11-28 11:19:10');
INSERT INTO `sub_part_code` VALUES (17, 1, 1, '12317', '21217', '212', '1212', '121', '', '3131', '3131', 1, '2025-07-08 15:35:24', '2025-11-28 11:19:11');
INSERT INTO `sub_part_code` VALUES (18, 1, 1, '12318', '21218', '212', '1212', '121', '', '3131', '3131', 1, '2025-07-08 15:35:24', '2025-11-28 11:19:11');
INSERT INTO `sub_part_code` VALUES (19, 1, 1, '12319', '21219', '212', '1212', '121', '', '3131', '3131', 1, '2025-07-08 15:35:24', '2025-11-28 11:19:12');
INSERT INTO `sub_part_code` VALUES (20, 1, 1, '12320', '21220', '212', '1212', '121', '', '3131', '3131', 1, '2025-07-08 15:35:24', '2025-11-28 11:19:13');
INSERT INTO `sub_part_code` VALUES (21, 6, 3, 'X001', '车首管', '', '', '', '47', '', '', 1, '2025-10-18 04:59:23', '2025-11-28 11:19:48');
INSERT INTO `sub_part_code` VALUES (22, 6, 3, 'X002', '主梁管', '', '', '', '48', '', '', 1, '2025-10-18 15:07:26', '2025-11-28 11:19:56');
INSERT INTO `sub_part_code` VALUES (23, 6, 3, 'X003', '辅助管', '', '', '', '', '', '', 1, '2025-10-27 14:58:25', '2025-11-28 11:19:15');
INSERT INTO `sub_part_code` VALUES (24, 6, 3, 'X004', '上管', '', '', '', '', '', '', 1, '2025-10-27 15:03:56', '2025-11-28 11:19:16');
INSERT INTO `sub_part_code` VALUES (25, 6, 3, 'X005', '下管', '', '', '', '', '', '', 1, '2025-10-27 15:04:18', '2025-11-28 11:19:17');
INSERT INTO `sub_part_code` VALUES (26, 6, 3, 'X006', '座管', '', '', '', '', '', '', 1, '2025-10-27 15:04:59', '2025-11-28 11:19:17');
INSERT INTO `sub_part_code` VALUES (27, 6, 3, 'X007', '五通', '', 'X', '', '', '', '', 1, '2025-10-27 15:06:48', '2025-11-28 11:19:18');
INSERT INTO `sub_part_code` VALUES (28, 6, 3, 'X008', '后上叉R', '', '', '', '', '', '', 1, '2025-10-27 15:07:21', '2025-11-28 11:19:18');
INSERT INTO `sub_part_code` VALUES (29, 6, 3, 'X009', '后上叉L', '', '', '', '', '', '', 1, '2025-10-27 15:11:47', '2025-11-28 11:19:19');
INSERT INTO `sub_part_code` VALUES (30, 6, 3, 'X010', '后下叉R', '', '', '', '', '', '', 1, '2025-10-27 15:12:39', '2025-11-28 11:19:20');
INSERT INTO `sub_part_code` VALUES (31, 6, 3, 'X011', '后下叉L', '', '', '', '', '', '', 1, '2025-10-27 15:12:57', '2025-11-28 11:19:21');
INSERT INTO `sub_part_code` VALUES (32, 6, 3, 'X012', '电池盒板', '', '', '', '', '', '', 1, '2025-10-27 15:23:24', '2025-11-28 11:19:21');
INSERT INTO `sub_part_code` VALUES (33, 6, 3, 'X013', '手提管', '', '', '', '', '', '', 1, '2025-10-27 15:23:45', '2025-11-28 11:19:22');
INSERT INTO `sub_part_code` VALUES (34, 6, 3, 'X014', '中管', '', '', '', '', '', '', 1, '2025-10-27 15:24:25', '2025-11-28 11:19:25');
INSERT INTO `sub_part_code` VALUES (35, 6, 3, 'X015', '上支杆', '', '', '', '', '', '', 1, '2025-10-27 15:24:50', '2025-11-28 11:19:26');
INSERT INTO `sub_part_code` VALUES (36, 6, 3, 'X016', '下枝杆', '', '', '', '', '', '', 1, '2025-10-27 15:25:37', '2025-11-28 11:19:27');
INSERT INTO `sub_part_code` VALUES (37, 6, 3, 'X017', '下叉', '', '', '', '', '', '', 1, '2025-10-27 15:27:35', '2025-11-28 11:19:27');
INSERT INTO `sub_part_code` VALUES (38, 6, 3, 'X018', '过线管', '', '', '', '', '', '', 1, '2025-10-27 15:27:59', '2025-11-28 11:19:28');
INSERT INTO `sub_part_code` VALUES (39, 6, 3, 'X019', '上叉', '', '', '', '', '', '', 1, '2025-10-27 15:28:29', '2025-11-28 11:19:28');
INSERT INTO `sub_part_code` VALUES (40, 15, 3, 'Y001', '左钩爪', '', '', '', '51', '', '', 1, '2025-10-27 15:28:56', '2025-11-29 16:29:24');
INSERT INTO `sub_part_code` VALUES (41, 6, 3, 'Y002', '右钩爪', '', '', '', '', '', '', 1, '2025-10-27 15:29:16', '2025-11-28 11:19:29');
INSERT INTO `sub_part_code` VALUES (42, 6, 3, 'Y003', '上叉支杆', '', '', '', '', '', '', 1, '2025-10-27 15:30:11', '2025-11-28 11:19:30');
INSERT INTO `sub_part_code` VALUES (43, 6, 3, 'Y004', '组立折叠器', '', '', '', '', '', '', 1, '2025-10-27 15:30:34', '2025-11-28 11:19:30');
INSERT INTO `sub_part_code` VALUES (44, 6, 3, 'Y005', '组立前三角', '', '', '', '', '', '', 1, '2025-10-27 15:31:01', '2025-11-28 11:19:31');
INSERT INTO `sub_part_code` VALUES (45, 6, 3, 'Y006', '组立后三角', '', '', '', '', '', '', 1, '2025-10-27 15:31:21', '2025-11-28 11:19:31');
INSERT INTO `sub_part_code` VALUES (46, 6, 3, 'Z001', '成品车架', '', '', '', '', '', '', 1, '2025-10-27 15:32:05', '2025-11-28 11:19:32');
INSERT INTO `sub_part_code` VALUES (47, 6, 3, 'Z002', '前三角', '', '', '', '', '', '', 1, '2025-10-27 15:32:27', '2025-11-28 11:19:32');
INSERT INTO `sub_part_code` VALUES (48, 6, 3, 'Z003', '后三角', '', '', '', '', '', '', 1, '2025-10-27 15:32:48', '2025-11-28 11:19:33');
INSERT INTO `sub_part_code` VALUES (49, 6, 3, 'Z004', '上叉支杆', '', '', '', '', '', '', 1, '2025-10-27 15:33:10', '2025-11-28 11:19:34');
INSERT INTO `sub_part_code` VALUES (50, 6, 3, '019', 'X', '', '', '', '', '', '', 0, '2025-10-27 16:31:42', '2025-11-28 11:19:34');
INSERT INTO `sub_part_code` VALUES (51, 6, 3, 'X020', 'X', '', '', '', '', '', '', 1, '2025-10-27 16:33:25', '2025-11-28 11:19:36');

-- ----------------------------
-- Table structure for sub_process_bom
-- ----------------------------
DROP TABLE IF EXISTS `sub_process_bom`;
CREATE TABLE `sub_process_bom`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键ID',
  `company_id` int(11) NOT NULL COMMENT '企业id',
  `user_id` int(11) NOT NULL COMMENT '发布的用户id',
  `notice_id` int(11) NULL DEFAULT NULL COMMENT '生产订单ID',
  `notice` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生产订单号',
  `product_id` int(11) NOT NULL COMMENT '产品编码id',
  `part_id` int(11) NOT NULL COMMENT '部件编码id',
  `sort` int(20) NULL DEFAULT 0 COMMENT '排序',
  `archive` int(11) NULL DEFAULT NULL COMMENT '是否已存档，1未存，0已存',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 86 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '工艺BOM表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_process_bom
-- ----------------------------
INSERT INTO `sub_process_bom` VALUES (56, 1, 1, NULL, NULL, 19, 8, 0, 0, 1, '2025-09-24 15:58:17', '2025-09-24 16:03:21');
INSERT INTO `sub_process_bom` VALUES (57, 1, 1, NULL, NULL, 14, 12, 0, 0, 1, '2025-09-25 14:50:12', '2025-09-25 14:51:59');
INSERT INTO `sub_process_bom` VALUES (58, 1, 1, NULL, NULL, 14, 8, 0, 0, 1, '2025-09-25 14:51:50', '2025-09-25 14:51:59');
INSERT INTO `sub_process_bom` VALUES (59, 3, 6, NULL, NULL, 20, 21, 1, 0, 1, '2025-10-19 15:45:17', '2025-11-13 10:48:41');
INSERT INTO `sub_process_bom` VALUES (60, 3, 6, NULL, NULL, 20, 27, 2, 0, 1, '2025-10-19 15:49:23', '2025-11-06 02:07:56');
INSERT INTO `sub_process_bom` VALUES (61, 1, 1, NULL, NULL, 14, 8, 0, 1, 1, '2025-10-21 21:32:41', '2025-10-21 21:35:24');
INSERT INTO `sub_process_bom` VALUES (62, 3, 6, NULL, NULL, 20, 21, 0, 1, 0, '2025-10-29 09:46:29', '2025-10-30 19:10:28');
INSERT INTO `sub_process_bom` VALUES (63, 3, 6, NULL, NULL, 20, 34, 3, 0, 1, '2025-10-30 20:02:25', '2025-11-06 02:08:36');
INSERT INTO `sub_process_bom` VALUES (64, 3, 6, NULL, NULL, 20, 33, 4, 0, 1, '2025-10-30 20:16:04', '2025-11-06 02:09:42');
INSERT INTO `sub_process_bom` VALUES (65, 3, 6, NULL, NULL, 20, 25, 5, 0, 1, '2025-10-30 20:31:48', '2025-11-06 02:10:46');
INSERT INTO `sub_process_bom` VALUES (66, 3, 6, NULL, NULL, 20, 38, 6, 0, 1, '2025-10-30 21:48:54', '2025-11-06 02:11:26');
INSERT INTO `sub_process_bom` VALUES (67, 3, 6, NULL, NULL, 20, 22, 7, 0, 1, '2025-10-30 22:03:52', '2025-11-06 02:11:49');
INSERT INTO `sub_process_bom` VALUES (68, 3, 6, NULL, NULL, 20, 29, 8, 0, 1, '2025-10-30 22:21:18', '2025-11-06 02:12:17');
INSERT INTO `sub_process_bom` VALUES (69, 3, 6, NULL, NULL, 20, 28, 9, 0, 1, '2025-10-30 22:30:01', '2025-11-06 02:12:29');
INSERT INTO `sub_process_bom` VALUES (70, 3, 6, NULL, NULL, 20, 35, 10, 0, 1, '2025-10-30 22:32:06', '2025-11-06 02:12:58');
INSERT INTO `sub_process_bom` VALUES (71, 3, 6, NULL, NULL, 20, 36, 11, 0, 1, '2025-10-30 22:55:21', '2025-11-06 02:13:13');
INSERT INTO `sub_process_bom` VALUES (72, 3, 6, NULL, NULL, 20, 39, 12, 0, 1, '2025-10-30 22:56:45', '2025-11-06 02:13:45');
INSERT INTO `sub_process_bom` VALUES (73, 3, 6, NULL, NULL, 20, 30, 13, 0, 1, '2025-10-30 23:01:17', '2025-11-06 02:14:14');
INSERT INTO `sub_process_bom` VALUES (74, 3, 6, NULL, NULL, 20, 31, 14, 0, 1, '2025-10-30 23:06:50', '2025-11-06 02:14:43');
INSERT INTO `sub_process_bom` VALUES (75, 3, 6, NULL, NULL, 20, 37, 15, 0, 1, '2025-10-30 23:16:29', '2025-11-06 02:15:08');
INSERT INTO `sub_process_bom` VALUES (76, 3, 6, NULL, NULL, 20, 40, 16, 0, 1, '2025-10-30 23:24:51', '2025-11-06 02:15:59');
INSERT INTO `sub_process_bom` VALUES (77, 3, 6, NULL, NULL, 20, 41, 17, 0, 1, '2025-10-30 23:28:36', '2025-11-06 02:16:09');
INSERT INTO `sub_process_bom` VALUES (78, 3, 6, NULL, NULL, 20, 42, 18, 0, 1, '2025-10-30 23:30:00', '2025-11-06 02:16:18');
INSERT INTO `sub_process_bom` VALUES (79, 3, 6, NULL, NULL, 20, 43, 19, 0, 1, '2025-10-30 23:35:15', '2025-11-06 02:16:35');
INSERT INTO `sub_process_bom` VALUES (80, 3, 6, NULL, NULL, 20, 44, 20, 0, 1, '2025-10-30 23:36:27', '2025-11-06 02:17:07');
INSERT INTO `sub_process_bom` VALUES (81, 3, 6, NULL, NULL, 20, 45, 21, 0, 1, '2025-10-30 23:37:56', '2025-11-06 02:17:16');
INSERT INTO `sub_process_bom` VALUES (82, 3, 6, NULL, NULL, 20, 46, 22, 0, 1, '2025-10-30 23:50:10', '2025-11-06 02:17:24');
INSERT INTO `sub_process_bom` VALUES (83, 3, 15, NULL, NULL, 21, 27, 1, 0, 1, '2025-11-29 10:30:32', '2025-11-29 11:39:40');
INSERT INTO `sub_process_bom` VALUES (85, 3, 15, NULL, NULL, 21, 26, 2, 0, 1, '2025-11-29 11:42:19', '2025-11-29 14:47:13');

-- ----------------------------
-- Table structure for sub_process_bom_child
-- ----------------------------
DROP TABLE IF EXISTS `sub_process_bom_child`;
CREATE TABLE `sub_process_bom_child`  (
  `id` int(50) NOT NULL AUTO_INCREMENT COMMENT '自增主键ID',
  `company_id` int(11) NULL DEFAULT NULL COMMENT '公司ID',
  `notice` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生产订单号',
  `notice_id` int(11) NULL DEFAULT NULL COMMENT '生产订单ID',
  `process_bom_id` int(11) NULL DEFAULT NULL COMMENT '工艺BOM的父表id',
  `process_id` int(11) NULL DEFAULT NULL COMMENT '工艺编码ID，关联工艺编码表',
  `equipment_id` int(11) NULL DEFAULT NULL COMMENT '设备编码ID，关联设备信息表',
  `process_index` int(5) NULL DEFAULT NULL COMMENT '工序下标',
  `time` int(11) NULL DEFAULT NULL COMMENT '单件工时(秒)',
  `price` decimal(11, 2) NULL DEFAULT NULL COMMENT '加工单价',
  `points` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '段数点数',
  `all_time` decimal(11, 1) NULL DEFAULT NULL COMMENT '全部工时-H',
  `all_load` decimal(11, 1) NULL DEFAULT NULL COMMENT '每日负荷-H',
  `add_finish` int(11) NULL DEFAULT NULL COMMENT '累计完成',
  `order_number` int(11) NULL DEFAULT NULL COMMENT '订单尾数',
  `qr_code` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '二维码',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 212 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '工艺BOM表子表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_process_bom_child
-- ----------------------------
INSERT INTO `sub_process_bom_child` VALUES (71, 1, '1122', 8, 56, 5, 4, 1, 8, 2.00, NULL, 33.3, NULL, 50, 11920, 'http://cdn.yuanfangzixun.com.cn/qrcodes/7e081466-1421-4fcb-ad52-2164378ceb55.png', '2025-09-24 15:58:17', '2025-10-31 01:04:11');
INSERT INTO `sub_process_bom_child` VALUES (72, 1, '1122', 8, 56, 6, 3, 2, 9, 2.00, NULL, 37.5, NULL, NULL, 11970, 'http://cdn.yuanfangzixun.com.cn/qrcodes/363b2db6-40f9-4d98-b7aa-9dc97b33327a.png', '2025-09-24 15:58:17', '2025-10-31 01:04:11');
INSERT INTO `sub_process_bom_child` VALUES (73, NULL, NULL, NULL, 57, 5, 5, 1, 8, 2.00, NULL, NULL, NULL, NULL, NULL, 'http://cdn.yuanfangzixun.com.cn/qrcodes/478e261e-327e-41b5-ab9b-6e5840980e00.png', '2025-09-25 14:50:12', '2025-09-25 14:50:12');
INSERT INTO `sub_process_bom_child` VALUES (74, NULL, NULL, NULL, 57, 6, 5, 2, 6, 8.00, NULL, NULL, NULL, NULL, NULL, 'http://cdn.yuanfangzixun.com.cn/qrcodes/d48ac941-c764-49a3-9914-cc6cf9af32e6.png', '2025-09-25 14:50:12', '2025-09-25 14:50:12');
INSERT INTO `sub_process_bom_child` VALUES (75, NULL, NULL, NULL, 58, 5, 4, 1, 6, 8.00, NULL, NULL, NULL, NULL, NULL, 'http://cdn.yuanfangzixun.com.cn/qrcodes/dc9ac27b-7a9b-4f7f-8ce2-89094ae5ca61.png', '2025-09-25 14:51:50', '2025-09-25 14:51:50');
INSERT INTO `sub_process_bom_child` VALUES (77, NULL, NULL, NULL, 60, 8, 7, 1, 4, 0.05, '1', 72000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/691c887e-3de0-4afe-8b32-4e121625955b.png', '2025-10-19 15:49:23', '2025-11-06 02:07:56');
INSERT INTO `sub_process_bom_child` VALUES (78, NULL, NULL, NULL, 60, 8, 7, 2, 4, 0.05, '1', 72000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/d8f387be-9b3e-45bf-9664-acb8efd1621e.png', '2025-10-19 15:49:23', '2025-11-06 02:07:56');
INSERT INTO `sub_process_bom_child` VALUES (79, NULL, NULL, NULL, 61, 5, 4, 4, 8, 8.00, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-21 21:32:41', '2025-10-21 21:35:24');
INSERT INTO `sub_process_bom_child` VALUES (80, NULL, NULL, NULL, 61, 6, 3, 1, 7, 7.00, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-21 21:34:41', '2025-10-21 21:35:04');
INSERT INTO `sub_process_bom_child` VALUES (81, NULL, NULL, NULL, 61, 5, 5, 2, 6, 6.00, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-21 21:34:41', '2025-10-21 21:35:04');
INSERT INTO `sub_process_bom_child` VALUES (83, NULL, NULL, NULL, 61, 5, 3, 3, 4, 4.00, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-21 21:34:41', '2025-10-21 21:35:24');
INSERT INTO `sub_process_bom_child` VALUES (85, NULL, NULL, NULL, 61, 5, 3, 5, 9, 9.00, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-21 21:35:24', '2025-10-21 21:35:24');
INSERT INTO `sub_process_bom_child` VALUES (86, NULL, NULL, NULL, 59, 7, 6, 1, 15, 0.20, '1', 90000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/68825ded-1d72-4743-bb1b-aa8bb4f0a980.png', '2025-10-22 14:22:50', '2025-11-13 10:48:41');
INSERT INTO `sub_process_bom_child` VALUES (87, NULL, NULL, NULL, 62, 7, 6, 1, 3, 0.00, '1', NULL, NULL, NULL, NULL, 'http://cdn.yuanfangzixun.com.cn/qrcodes/6916e3f8-ff22-4d00-85ca-df7f952ae963.png', '2025-10-29 09:46:29', '2025-10-29 09:46:30');
INSERT INTO `sub_process_bom_child` VALUES (88, NULL, NULL, NULL, 60, 8, 7, 3, 4, 0.05, '1', 72000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/897d38e9-6232-4211-9729-9337d1f5cb58.png', '2025-10-30 20:00:52', '2025-11-06 02:07:57');
INSERT INTO `sub_process_bom_child` VALUES (89, NULL, NULL, NULL, 60, 8, 7, 4, 4, 0.05, '1', 72000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/34c800f6-73a9-4d9b-be1a-08f8b3202b08.png', '2025-10-30 20:00:52', '2025-11-06 02:07:57');
INSERT INTO `sub_process_bom_child` VALUES (92, NULL, NULL, NULL, 63, 9, 8, 3, 5, 0.05, '1', 90000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/eaf422bf-3d5a-424b-889f-e90ce2bb65a2.png', '2025-10-30 20:02:25', '2025-11-06 02:08:37');
INSERT INTO `sub_process_bom_child` VALUES (93, NULL, NULL, NULL, 63, 9, 8, 4, 5, 0.05, '1', 90000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/859cec97-156a-4f90-bb1b-2ccf7a26e19d.png', '2025-10-30 20:02:25', '2025-11-06 02:08:37');
INSERT INTO `sub_process_bom_child` VALUES (94, NULL, NULL, NULL, 63, 9, 8, 1, 5, 0.05, '1', 90000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/9803de5b-8517-439f-9531-1ce23e0bcbfe.png', '2025-10-30 20:02:25', '2025-11-06 02:08:37');
INSERT INTO `sub_process_bom_child` VALUES (95, NULL, NULL, NULL, 63, 9, 8, 2, 5, 0.05, '1', 90000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/1d563ef0-d408-4214-9bfc-c5faa608e68f.png', '2025-10-30 20:02:25', '2025-11-06 02:08:37');
INSERT INTO `sub_process_bom_child` VALUES (96, NULL, NULL, NULL, 63, 12, 10, 5, 5, 0.08, '1', 90000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/cf04c264-b836-4d00-b5e0-0ebd8dabcaae.png', '2025-10-30 20:13:30', '2025-11-06 02:08:37');
INSERT INTO `sub_process_bom_child` VALUES (97, NULL, NULL, NULL, 63, 39, 47, 6, 15, 0.10, '1', 270000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/bd48db9d-fdc3-4953-a233-0a76f1165782.png', '2025-10-30 20:13:30', '2025-11-06 02:08:37');
INSERT INTO `sub_process_bom_child` VALUES (102, NULL, NULL, NULL, 64, 11, 7, 2, 8, 0.08, '1', 144000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/79d819ff-f587-4704-9f19-4b916f639c64.png', '2025-10-30 20:16:04', '2025-11-06 02:09:42');
INSERT INTO `sub_process_bom_child` VALUES (103, NULL, NULL, NULL, 64, 13, 11, 4, 8, 0.07, '1', 144000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/4e8f3065-c99b-4d09-a477-78e68ed5547b.png', '2025-10-30 20:16:04', '2025-11-06 02:09:42');
INSERT INTO `sub_process_bom_child` VALUES (104, NULL, NULL, NULL, 64, 13, 11, 5, 8, 0.08, '1', 144000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/97f772a5-3434-4ae0-b35d-544305d5ec93.png', '2025-10-30 20:16:04', '2025-11-06 02:09:42');
INSERT INTO `sub_process_bom_child` VALUES (105, NULL, NULL, NULL, 64, 39, 47, 1, 15, 0.05, '1', 270000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/76cda8bb-c572-4595-af3c-c42f9f7b220a.png', '2025-10-30 20:16:04', '2025-11-06 02:09:42');
INSERT INTO `sub_process_bom_child` VALUES (106, NULL, NULL, NULL, 64, 12, 10, 3, 5, 0.07, '1', 90000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/5abc9af4-81b8-47d5-8215-e18f61ef10c2.png', '2025-10-30 20:21:41', '2025-11-06 02:09:42');
INSERT INTO `sub_process_bom_child` VALUES (111, NULL, NULL, NULL, 65, 39, 47, 1, 60, 0.07, '1', 1080000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/57d140af-a2be-41d1-8b28-8d48d7529121.png', '2025-10-30 20:31:48', '2025-11-06 02:10:47');
INSERT INTO `sub_process_bom_child` VALUES (112, NULL, NULL, NULL, 65, 13, 11, 3, 10, 0.08, '1', 180000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/b3485f40-78eb-41f0-b6e7-f42f96ac6839.png', '2025-10-30 20:31:48', '2025-11-06 02:10:47');
INSERT INTO `sub_process_bom_child` VALUES (113, NULL, NULL, NULL, 65, 13, 11, 4, 10, 0.08, '1', 180000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/b0b477ff-10a9-4f44-8d63-6a7582f9e55f.png', '2025-10-30 20:31:48', '2025-11-06 02:10:47');
INSERT INTO `sub_process_bom_child` VALUES (114, NULL, NULL, NULL, 65, 29, 22, 5, 20, 0.35, '1', 360000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/406f2caa-6b6c-41a2-9845-f2bfb3c92fd1.png', '2025-10-30 20:31:48', '2025-11-06 02:10:47');
INSERT INTO `sub_process_bom_child` VALUES (115, NULL, NULL, NULL, 65, 12, 10, 2, 8, 0.07, '1', 144000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/acd8ca16-d3d6-4473-ac97-1924934bb050.png', '2025-10-30 20:31:48', '2025-11-06 02:10:47');
INSERT INTO `sub_process_bom_child` VALUES (116, NULL, NULL, NULL, 66, 13, 11, 1, 5, 0.08, '1', 90000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/bcc1aced-aa25-4335-999e-41d2e6d6b1e6.png', '2025-10-30 21:48:54', '2025-11-06 02:11:26');
INSERT INTO `sub_process_bom_child` VALUES (117, NULL, NULL, NULL, 67, 13, 11, 2, 8, 0.08, '1', 144000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/c7273382-2ef8-4dbc-89c7-4b8ad05fe33b.png', '2025-10-30 22:03:52', '2025-11-06 02:11:51');
INSERT INTO `sub_process_bom_child` VALUES (118, NULL, NULL, NULL, 67, 12, 10, 4, 5, 0.08, '1', 90000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/173595b2-a6c6-4fa9-91c2-10c8856fc8cc.png', '2025-10-30 22:03:52', '2025-11-06 02:11:51');
INSERT INTO `sub_process_bom_child` VALUES (119, NULL, NULL, NULL, 67, 12, 10, 6, 5, 0.07, '1', 90000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/8784610c-1e4c-4ff2-9618-891af1d6c283.png', '2025-10-30 22:03:52', '2025-11-06 02:11:51');
INSERT INTO `sub_process_bom_child` VALUES (120, NULL, NULL, NULL, 67, 13, 11, 1, 8, 0.08, '1', 144000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/581aa08a-54f9-4e09-862d-82d8e83f6a0e.png', '2025-10-30 22:03:52', '2025-11-06 02:11:51');
INSERT INTO `sub_process_bom_child` VALUES (121, NULL, NULL, NULL, 67, 12, 10, 3, 5, 0.08, '1', 90000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/1e15bbb2-3212-454e-a7e2-f95f96ad4d0c.png', '2025-10-30 22:03:52', '2025-11-06 02:11:51');
INSERT INTO `sub_process_bom_child` VALUES (122, NULL, NULL, NULL, 67, 12, 10, 5, 5, 0.08, '1', 90000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/3c677e87-cba1-4b49-941a-ce617b45f58d.png', '2025-10-30 22:03:52', '2025-11-06 02:11:51');
INSERT INTO `sub_process_bom_child` VALUES (123, NULL, NULL, NULL, 67, 12, 10, 7, 5, 0.03, '1', 90000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/151721e6-e5a9-456c-91fc-c9715b69f8cb.png', '2025-10-30 22:16:36', '2025-11-06 02:11:51');
INSERT INTO `sub_process_bom_child` VALUES (124, NULL, NULL, NULL, 67, 28, 47, 8, 5, 0.04, '1', 90000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/72f4a745-0139-4c5a-b68a-81c6e754dedb.png', '2025-10-30 22:16:36', '2025-11-06 02:11:51');
INSERT INTO `sub_process_bom_child` VALUES (125, NULL, NULL, NULL, 67, 15, 11, 9, 10, 0.04, '1', 180000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/14df2dbd-1049-4f25-b630-f81cc02903c1.png', '2025-10-30 22:16:36', '2025-11-06 02:11:51');
INSERT INTO `sub_process_bom_child` VALUES (126, NULL, NULL, NULL, 67, 16, 8, 10, 15, 0.05, '1', 270000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/d84b3ae6-b823-4133-b8ff-55ee25323099.png', '2025-10-30 22:16:36', '2025-11-06 02:11:51');
INSERT INTO `sub_process_bom_child` VALUES (127, NULL, NULL, NULL, 67, 30, 8, 11, 8, 0.04, '1', 144000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/f9cdb772-7da5-4869-9e36-51d3f04ac60d.png', '2025-10-30 22:16:36', '2025-11-06 02:11:51');
INSERT INTO `sub_process_bom_child` VALUES (128, NULL, NULL, NULL, 67, 39, 47, 12, 8, 0.04, '1', 144000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/8596392f-aba2-4a8c-8440-a5791c3ad43a.png', '2025-10-30 22:16:36', '2025-11-06 02:11:51');
INSERT INTO `sub_process_bom_child` VALUES (129, NULL, NULL, NULL, 67, 29, 22, 13, 8, 0.05, '1', 144000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/3d884bd9-a0e2-4b2f-9807-6e68cf8c8193.png', '2025-10-30 22:16:36', '2025-11-06 02:11:51');
INSERT INTO `sub_process_bom_child` VALUES (130, NULL, NULL, NULL, 67, 29, 22, 14, 15, 0.06, '1', 270000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/26c0bf39-e418-4272-833f-3b09835de526.png', '2025-10-30 22:16:36', '2025-11-06 02:11:51');
INSERT INTO `sub_process_bom_child` VALUES (137, NULL, NULL, NULL, 68, 13, 11, 6, 10, 0.08, '1', 180000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/29fb2585-ebed-4c47-bf92-e3b24503c690.png', '2025-10-30 22:21:18', '2025-11-06 02:12:18');
INSERT INTO `sub_process_bom_child` VALUES (138, NULL, NULL, NULL, 68, 18, 13, 2, 8, 0.07, '1', 144000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/3f8e637f-cc3b-474d-ad16-5f90b3fdf8c2.png', '2025-10-30 22:21:18', '2025-11-06 02:12:18');
INSERT INTO `sub_process_bom_child` VALUES (139, NULL, NULL, NULL, 68, 30, 8, 4, 5, 0.05, '1', 90000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/14d0c351-4a2b-4bf2-9236-296e5bb0f620.png', '2025-10-30 22:21:18', '2025-11-06 02:12:18');
INSERT INTO `sub_process_bom_child` VALUES (140, NULL, NULL, NULL, 68, 11, 7, 5, 8, 0.07, '1', 144000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/f77db8ab-d036-4b04-853e-ba15e960e0c0.png', '2025-10-30 22:21:18', '2025-11-06 02:12:18');
INSERT INTO `sub_process_bom_child` VALUES (141, NULL, NULL, NULL, 68, 39, 47, 1, 10, 0.04, '1', 180000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/fceaf9ac-1a93-425b-963a-37afb5c0a579.png', '2025-10-30 22:21:18', '2025-11-06 02:12:18');
INSERT INTO `sub_process_bom_child` VALUES (142, NULL, NULL, NULL, 68, 28, 47, 3, 10, 0.10, '1', 180000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/478613db-f7f4-4fdd-aeaa-053e4745a4bf.png', '2025-10-30 22:21:18', '2025-11-06 02:12:18');
INSERT INTO `sub_process_bom_child` VALUES (143, NULL, NULL, NULL, 69, 13, 11, 2, 10, 0.08, '1', 180000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/a8a887b3-00b4-4d1c-9556-00a6755b46ce.png', '2025-10-30 22:30:01', '2025-11-06 02:12:30');
INSERT INTO `sub_process_bom_child` VALUES (144, NULL, NULL, NULL, 69, 18, 13, 4, 8, 0.07, '1', 144000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/cab2c280-e5b0-46e6-a9e0-2ea5094dcc2f.png', '2025-10-30 22:30:01', '2025-11-06 02:12:30');
INSERT INTO `sub_process_bom_child` VALUES (145, NULL, NULL, NULL, 69, 30, 8, 6, 5, 0.05, '1', 90000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/dfb44501-0fc4-4279-b3a9-722aa303032e.png', '2025-10-30 22:30:01', '2025-11-06 02:12:30');
INSERT INTO `sub_process_bom_child` VALUES (146, NULL, NULL, NULL, 69, 11, 7, 1, 8, 0.07, '1', 144000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/c31076bd-fc91-4746-95b0-41b74331c3ac.png', '2025-10-30 22:30:01', '2025-11-06 02:12:30');
INSERT INTO `sub_process_bom_child` VALUES (147, NULL, NULL, NULL, 69, 39, 47, 3, 10, 0.04, '1', 180000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/dbd9cde6-224d-4b98-81e9-b8f8b1fa79e5.png', '2025-10-30 22:30:01', '2025-11-06 02:12:30');
INSERT INTO `sub_process_bom_child` VALUES (148, NULL, NULL, NULL, 69, 28, 47, 5, 10, 0.10, '1', 180000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/0eb7bf20-32a4-4b09-ba7f-969b94936f2b.png', '2025-10-30 22:30:01', '2025-11-06 02:12:30');
INSERT INTO `sub_process_bom_child` VALUES (149, NULL, NULL, NULL, 70, 30, 8, 2, 5, 0.05, '1', 90000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/ae558a0d-7418-4e0c-a5f6-710f5199119a.png', '2025-10-30 22:32:06', '2025-11-06 02:12:59');
INSERT INTO `sub_process_bom_child` VALUES (150, NULL, NULL, NULL, 70, 12, 10, 4, 5, 0.07, '1', 90000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/f6a554f2-62b7-416c-be65-e4610435aa75.png', '2025-10-30 22:32:06', '2025-11-06 02:12:59');
INSERT INTO `sub_process_bom_child` VALUES (151, NULL, NULL, NULL, 70, 12, 10, 5, 5, 0.08, '1', 90000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/61230b46-5d50-401f-9969-3fe02ff3964b.png', '2025-10-30 22:32:06', '2025-11-06 02:12:59');
INSERT INTO `sub_process_bom_child` VALUES (152, NULL, NULL, NULL, 70, 8, 7, 1, 5, 0.08, '1', 90000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/030370f4-99dc-4d92-a036-4e6c74aa8a52.png', '2025-10-30 22:32:06', '2025-11-06 02:12:59');
INSERT INTO `sub_process_bom_child` VALUES (153, NULL, NULL, NULL, 70, 39, 47, 3, 10, 0.10, '1', 180000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/36b2580f-0eaa-4e4e-b7aa-c97b0108bf61.png', '2025-10-30 22:32:06', '2025-11-06 02:12:59');
INSERT INTO `sub_process_bom_child` VALUES (154, NULL, NULL, NULL, 71, 30, 8, 4, 5, 0.05, '1', 90000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/7632476f-2501-4488-8b55-a6361f05a9ae.png', '2025-10-30 22:55:21', '2025-11-06 02:13:14');
INSERT INTO `sub_process_bom_child` VALUES (155, NULL, NULL, NULL, 71, 12, 10, 1, 5, 0.07, '1', 90000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/4b8807e9-18b7-4494-8786-e0023f67fe3a.png', '2025-10-30 22:55:21', '2025-11-06 02:13:14');
INSERT INTO `sub_process_bom_child` VALUES (156, NULL, NULL, NULL, 71, 12, 10, 2, 5, 0.08, '1', 90000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/69bd1c76-4e31-4cf4-ab20-0f7bc662004c.png', '2025-10-30 22:55:21', '2025-11-06 02:13:14');
INSERT INTO `sub_process_bom_child` VALUES (157, NULL, NULL, NULL, 71, 8, 7, 3, 5, 0.08, '1', 90000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/d808407c-c452-4060-a5cb-69e928486605.png', '2025-10-30 22:55:21', '2025-11-06 02:13:14');
INSERT INTO `sub_process_bom_child` VALUES (158, NULL, NULL, NULL, 71, 39, 47, 5, 10, 0.10, '1', 180000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/907d7d93-4885-4fb3-92e6-180d4f56378f.png', '2025-10-30 22:55:21', '2025-11-06 02:13:14');
INSERT INTO `sub_process_bom_child` VALUES (159, NULL, NULL, NULL, 72, 39, 47, 2, 10, 0.04, '1', 180000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/5483da4b-7808-4582-b485-804b646ab183.png', '2025-10-30 22:56:45', '2025-11-06 02:13:45');
INSERT INTO `sub_process_bom_child` VALUES (160, NULL, NULL, NULL, 72, 29, 22, 3, 15, 0.35, '1', 270000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/c3007653-9978-4f18-91a4-ea53332b8a22.png', '2025-10-30 22:56:45', '2025-11-06 02:13:45');
INSERT INTO `sub_process_bom_child` VALUES (162, NULL, NULL, NULL, 72, 25, 18, 1, 20, 0.18, '1', 360000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/1a60abdd-d25c-4857-8ba9-8c397f618480.png', '2025-10-30 22:56:45', '2025-11-06 02:13:45');
INSERT INTO `sub_process_bom_child` VALUES (163, NULL, NULL, NULL, 73, 30, 8, 4, 5, 0.05, '1', 90000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/a184da20-5726-4738-b499-e9b04dbb2006.png', '2025-10-30 23:01:17', '2025-11-06 02:14:15');
INSERT INTO `sub_process_bom_child` VALUES (164, NULL, NULL, NULL, 73, 11, 7, 6, 5, 0.07, '1', 90000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/98225df8-414f-417a-9150-a5d9a2af4f75.png', '2025-10-30 23:01:17', '2025-11-06 02:14:15');
INSERT INTO `sub_process_bom_child` VALUES (165, NULL, NULL, NULL, 73, 11, 7, 2, 5, 0.05, '1', 90000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/7669f5f6-c5d5-4faa-b6ed-e9a4e8a93ec0.png', '2025-10-30 23:01:17', '2025-11-06 02:14:15');
INSERT INTO `sub_process_bom_child` VALUES (166, NULL, NULL, NULL, 73, 18, 13, 3, 8, 0.07, '1', 144000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/b96aa8d4-41f7-4361-87bf-e503101d547e.png', '2025-10-30 23:01:17', '2025-11-06 02:14:15');
INSERT INTO `sub_process_bom_child` VALUES (167, NULL, NULL, NULL, 73, 20, 7, 5, 5, 0.07, '1', 90000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/4804520c-e8be-4b34-ad04-259ff88652ed.png', '2025-10-30 23:01:17', '2025-11-06 02:14:15');
INSERT INTO `sub_process_bom_child` VALUES (168, NULL, NULL, NULL, 73, 39, 47, 1, 10, 0.04, '1', 180000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/441be92d-dd11-4e60-8464-ce97e9fba8f2.png', '2025-10-30 23:01:17', '2025-11-06 02:14:15');
INSERT INTO `sub_process_bom_child` VALUES (170, NULL, NULL, NULL, 74, 11, 7, 2, 5, 0.05, '1', 90000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/a912022a-d507-45c1-b8f0-9b0a8fb4a997.png', '2025-10-30 23:06:50', '2025-11-06 02:14:43');
INSERT INTO `sub_process_bom_child` VALUES (171, NULL, NULL, NULL, 74, 30, 8, 4, 5, 0.05, '1', 90000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/0d4c260e-8205-4573-a777-4a8f060f37d9.png', '2025-10-30 23:06:50', '2025-11-06 02:14:43');
INSERT INTO `sub_process_bom_child` VALUES (172, NULL, NULL, NULL, 74, 11, 7, 5, 5, 0.07, '1', 90000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/5a45e040-92c2-460a-a695-0b85dd6c73d3.png', '2025-10-30 23:06:50', '2025-11-06 02:14:43');
INSERT INTO `sub_process_bom_child` VALUES (173, NULL, NULL, NULL, 74, 39, 47, 1, 10, 0.04, '1', 180000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/a33c9aea-4bcc-420b-b669-2940efdf2446.png', '2025-10-30 23:06:50', '2025-11-06 02:14:43');
INSERT INTO `sub_process_bom_child` VALUES (174, NULL, NULL, NULL, 74, 18, 13, 3, 8, 0.07, '1', 144000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/f74459f2-2aa8-4ae4-bad5-28e2ad3ec6bf.png', '2025-10-30 23:06:50', '2025-11-06 02:14:43');
INSERT INTO `sub_process_bom_child` VALUES (175, NULL, NULL, NULL, 75, 20, 7, 1, 5, 0.05, '1', 90000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/64c9cb8b-117d-46ad-bca7-d9fb3224e0d0.png', '2025-10-30 23:16:29', '2025-11-06 02:15:08');
INSERT INTO `sub_process_bom_child` VALUES (176, NULL, NULL, NULL, 75, 29, 22, 2, 10, 0.35, '1', 180000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/5b7da50d-1dc2-41a7-ad3b-76f7584b779b.png', '2025-10-30 23:16:29', '2025-11-06 02:15:08');
INSERT INTO `sub_process_bom_child` VALUES (177, NULL, NULL, NULL, 75, 29, 22, 3, 10, 0.35, '1', 180000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/b0229d08-b5fc-4785-b48e-1cab55730079.png', '2025-10-30 23:16:29', '2025-11-06 02:15:08');
INSERT INTO `sub_process_bom_child` VALUES (178, NULL, NULL, NULL, 76, 41, 29, 1, 15, 0.20, '1', 270000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/65f22e24-4044-45f8-8d1e-88193837d46c.png', '2025-10-30 23:24:51', '2025-11-06 02:16:00');
INSERT INTO `sub_process_bom_child` VALUES (179, NULL, NULL, NULL, 76, 75, 22, 2, 10, 0.35, '1', 180000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/dacae4d9-95fd-4c26-b6c6-887bb5a492c4.png', '2025-10-30 23:24:51', '2025-11-06 02:16:00');
INSERT INTO `sub_process_bom_child` VALUES (180, NULL, NULL, NULL, 76, 74, 23, 3, 20, 0.18, '1', 360000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/43c5e1c4-5de1-41c1-8cbd-683c216dbe81.png', '2025-10-30 23:24:51', '2025-11-06 02:16:00');
INSERT INTO `sub_process_bom_child` VALUES (181, NULL, NULL, NULL, 77, 96, 29, 1, 15, 0.20, '1', 270000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/57f1457c-f6be-45ee-aa03-ef7c5ff11053.png', '2025-10-30 23:28:36', '2025-11-05 19:16:44');
INSERT INTO `sub_process_bom_child` VALUES (182, NULL, NULL, NULL, 78, 45, 29, 1, 15, 0.50, '1', 270000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/be61b76f-f656-48a4-8446-b9b386b1784e.png', '2025-10-30 23:30:00', '2025-11-06 02:16:18');
INSERT INTO `sub_process_bom_child` VALUES (183, NULL, NULL, NULL, 78, 97, 48, 2, 10, 0.05, '1', 180000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/bf2fe174-31a0-4aa4-aaf6-fc2b7394ebf5.png', '2025-10-30 23:31:08', '2025-11-06 02:16:19');
INSERT INTO `sub_process_bom_child` VALUES (185, NULL, NULL, NULL, 79, 98, 29, 1, 20, 0.72, '1', 360000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/14abc1a7-a11e-463e-a209-dbdb0d0712fb.png', '2025-10-30 23:35:15', '2025-11-06 02:16:35');
INSERT INTO `sub_process_bom_child` VALUES (186, NULL, NULL, NULL, 80, 90, 31, 1, 120, 1.20, '1', 2160000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/d1954167-3d9e-4041-84ea-24a58106cc59.png', '2025-10-30 23:36:27', '2025-11-06 02:17:07');
INSERT INTO `sub_process_bom_child` VALUES (187, NULL, NULL, NULL, 81, 91, 32, 1, 60, 1.10, '1', 1080000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/ed7d9e90-9ede-45b3-af93-8e322aec4d2f.png', '2025-10-30 23:37:56', '2025-11-06 02:17:16');
INSERT INTO `sub_process_bom_child` VALUES (188, NULL, NULL, NULL, 82, 100, 35, 1, 5400, 1.00, '1', 97200000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/de032772-9114-4ffe-bf2b-7132aad9b4bd.png', '2025-10-30 23:50:10', '2025-11-06 02:17:24');
INSERT INTO `sub_process_bom_child` VALUES (189, NULL, NULL, NULL, 82, 101, 34, 2, 15, 0.10, '1', 270000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/e71e4348-2b25-47cd-8e3c-ef2fa2311ae1.png', '2025-10-30 23:50:10', '2025-11-06 02:17:24');
INSERT INTO `sub_process_bom_child` VALUES (190, NULL, NULL, NULL, 82, 102, 36, 3, 15, 0.10, '1', 270000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/a1b7192d-cb4f-44e7-bef4-5787d632731a.png', '2025-10-30 23:50:10', '2025-11-06 02:17:24');
INSERT INTO `sub_process_bom_child` VALUES (191, NULL, NULL, NULL, 82, 103, 37, 4, 12600, 2.00, '1', 226800000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/79d6d53f-c258-45d9-9966-861d8ae8020b.png', '2025-10-30 23:50:10', '2025-11-06 02:17:24');
INSERT INTO `sub_process_bom_child` VALUES (192, NULL, NULL, NULL, 82, 104, 38, 5, 20, 0.15, '1', 360000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/7a9ed5ee-ffb3-41f5-afda-b79b0ae9a86e.png', '2025-10-30 23:50:10', '2025-11-06 02:17:24');
INSERT INTO `sub_process_bom_child` VALUES (193, NULL, NULL, NULL, 82, 105, 39, 6, 10, 0.10, '1', 180000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/caef18e7-bf3e-4852-9760-c6a13ab07249.png', '2025-10-30 23:50:10', '2025-11-06 02:17:24');
INSERT INTO `sub_process_bom_child` VALUES (194, NULL, NULL, NULL, 82, 106, 40, 7, 10, 0.10, '1', 180000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/6713361b-3c5f-4ada-a8fa-16cee6a2b254.png', '2025-10-30 23:50:10', '2025-11-06 02:17:24');
INSERT INTO `sub_process_bom_child` VALUES (195, NULL, NULL, NULL, 82, 107, 41, 8, 10, 0.10, '1', 180000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/aa565973-0d7d-4a66-9995-3dd52489368c.png', '2025-10-30 23:50:10', '2025-11-06 02:17:24');
INSERT INTO `sub_process_bom_child` VALUES (196, NULL, NULL, NULL, 82, 108, 9, 9, 15, 0.13, '1', 270000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/2d6a765e-db1d-42d8-8615-d7c0ac16c57f.png', '2025-10-30 23:50:10', '2025-11-06 02:17:24');
INSERT INTO `sub_process_bom_child` VALUES (197, NULL, NULL, NULL, 82, 111, 21, 10, 600, 4.50, '1', 10800000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/9a72bfa8-b9da-435c-a0ec-4de520a64ba7.png', '2025-10-30 23:50:10', '2025-11-06 02:17:24');
INSERT INTO `sub_process_bom_child` VALUES (198, NULL, NULL, NULL, 82, 109, 9, 11, 300, 2.30, '1', 5400000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/7a1c4c1d-104d-41f4-a382-e438d0a08295.png', '2025-10-30 23:50:10', '2025-11-06 02:17:24');
INSERT INTO `sub_process_bom_child` VALUES (199, NULL, NULL, NULL, 82, 112, 42, 12, 600, 1.10, '1', 10800000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/ba077b3a-262b-44b1-b4cc-a1b8fef1c8d5.png', '2025-10-30 23:50:10', '2025-11-06 02:17:24');
INSERT INTO `sub_process_bom_child` VALUES (200, NULL, NULL, NULL, 82, 110, 43, 13, 4000, 20.00, '1', 72000000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/fef45690-d985-4af4-8049-34dee160e5b4.png', '2025-10-30 23:50:10', '2025-11-06 02:17:24');
INSERT INTO `sub_process_bom_child` VALUES (201, NULL, NULL, NULL, 82, 113, 44, 14, 140, 0.65, '1', 2520000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/5df9bbd6-8ccb-4e9c-84bd-e587a7576c78.png', '2025-10-30 23:50:10', '2025-11-06 02:17:24');
INSERT INTO `sub_process_bom_child` VALUES (202, NULL, NULL, NULL, 82, 114, 45, 15, 140, 0.60, '1', 2520000.0, NULL, NULL, 18000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/c80f86a4-f1e2-4411-a80d-c2d43c9ea5de.png', '2025-10-30 23:50:10', '2025-11-06 02:17:24');
INSERT INTO `sub_process_bom_child` VALUES (203, NULL, NULL, NULL, 83, 8, 7, 4, 4, 0.05, '1', NULL, NULL, NULL, NULL, 'http://cdn.yuanfangzixun.com.cn/qrcodes/6f8e74f5-7864-489c-ba9f-b5b5339ad338.png', '2025-11-29 10:30:32', '2025-11-29 11:39:41');
INSERT INTO `sub_process_bom_child` VALUES (204, NULL, NULL, NULL, 83, 115, 49, 1, 40, 1.80, '1', NULL, NULL, NULL, NULL, 'http://cdn.yuanfangzixun.com.cn/qrcodes/13236150-6225-41ca-89e0-9d217f333d45.png', '2025-11-29 10:30:32', '2025-11-29 11:39:41');
INSERT INTO `sub_process_bom_child` VALUES (205, NULL, NULL, NULL, 83, 8, 7, 2, 4, 0.05, '1', NULL, NULL, NULL, NULL, 'http://cdn.yuanfangzixun.com.cn/qrcodes/3cd0f739-e1d0-4cbc-8ece-5c5647622667.png', '2025-11-29 10:30:32', '2025-11-29 11:39:41');
INSERT INTO `sub_process_bom_child` VALUES (206, NULL, NULL, NULL, 83, 8, 7, 3, 4, 0.05, '1', NULL, NULL, NULL, NULL, 'http://cdn.yuanfangzixun.com.cn/qrcodes/e3aaf2f8-1220-471e-9ba3-36e54c178637.png', '2025-11-29 10:30:32', '2025-11-29 11:39:41');
INSERT INTO `sub_process_bom_child` VALUES (208, NULL, NULL, NULL, 85, 8, 7, 2, 4, 0.05, '1', NULL, NULL, NULL, NULL, 'http://cdn.yuanfangzixun.com.cn/qrcodes/f8fa8c84-254b-4507-b086-7b9f768840be.png', '2025-11-29 11:42:19', '2025-11-29 14:47:14');
INSERT INTO `sub_process_bom_child` VALUES (209, NULL, NULL, NULL, 85, 115, 49, 3, 40, 1.80, '1', NULL, NULL, NULL, NULL, 'http://cdn.yuanfangzixun.com.cn/qrcodes/5240e3fe-8a8e-4bf3-a842-8dfa9efbc824.png', '2025-11-29 11:42:19', '2025-11-29 14:47:14');
INSERT INTO `sub_process_bom_child` VALUES (210, NULL, NULL, NULL, 85, 8, 7, 4, 4, 0.05, '1', NULL, NULL, NULL, NULL, 'http://cdn.yuanfangzixun.com.cn/qrcodes/6860fab6-d694-4ca6-92b9-23d055b4ef49.png', '2025-11-29 11:42:19', '2025-11-29 14:47:14');
INSERT INTO `sub_process_bom_child` VALUES (211, NULL, NULL, NULL, 85, 8, 7, 1, 4, 0.05, '1', NULL, NULL, NULL, NULL, 'http://cdn.yuanfangzixun.com.cn/qrcodes/3376c620-9681-482d-83a8-e699684c8f58.png', '2025-11-29 11:42:19', '2025-11-29 14:47:14');

-- ----------------------------
-- Table structure for sub_process_code
-- ----------------------------
DROP TABLE IF EXISTS `sub_process_code`;
CREATE TABLE `sub_process_code`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键ID',
  `user_id` int(5) NULL DEFAULT NULL COMMENT '用户id',
  `company_id` int(5) NULL DEFAULT NULL COMMENT '企业id',
  `equipment_id` int(11) NULL DEFAULT NULL COMMENT '设备编码ID',
  `process_code` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '工艺编码',
  `process_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '工艺名称',
  `remarks` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '备注',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '1：未删除；0：已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '记录创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '记录最后更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 116 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '工艺编码基础信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_process_code
-- ----------------------------
INSERT INTO `sub_process_code` VALUES (3, 1, 1, 3, '123', '212', '212', 0, '2025-07-08 15:56:54', '2025-09-24 15:45:55');
INSERT INTO `sub_process_code` VALUES (4, 1, 1, 4, '2222', '111', '3131', 0, '2025-08-09 16:07:09', '2025-09-24 15:45:54');
INSERT INTO `sub_process_code` VALUES (5, 1, 1, 5, 'T001', '钻床', '无', 1, '2025-09-24 15:48:02', '2025-09-24 15:52:18');
INSERT INTO `sub_process_code` VALUES (6, 1, 1, 4, 'T002', '打点', '', 1, '2025-09-24 15:53:42', '2025-09-24 15:53:42');
INSERT INTO `sub_process_code` VALUES (7, 6, 3, 6, 'PA001', '打字', '', 1, '2025-10-18 10:40:33', '2025-10-18 10:40:33');
INSERT INTO `sub_process_code` VALUES (8, 6, 3, 7, 'PA002', '冲孔', '', 1, '2025-10-19 15:48:05', '2025-10-19 15:48:05');
INSERT INTO `sub_process_code` VALUES (9, 6, 3, 8, 'PA003', '钻孔', '', 1, '2025-10-29 10:00:51', '2025-10-29 10:00:51');
INSERT INTO `sub_process_code` VALUES (10, 6, 3, 9, 'PA004', '研磨', '', 1, '2025-10-29 10:01:49', '2025-10-29 10:32:00');
INSERT INTO `sub_process_code` VALUES (11, 6, 3, 7, 'PA005', '打弯', '', 1, '2025-10-29 10:02:31', '2025-10-29 10:30:53');
INSERT INTO `sub_process_code` VALUES (12, 6, 3, 10, 'PA006', '冲弧', '', 1, '2025-10-29 10:34:43', '2025-10-29 10:34:43');
INSERT INTO `sub_process_code` VALUES (13, 6, 3, 11, 'PA007', '切斜', '', 1, '2025-10-29 10:35:22', '2025-10-29 10:35:22');
INSERT INTO `sub_process_code` VALUES (14, 6, 3, 11, 'PA008', '下料', '', 1, '2025-10-29 10:35:53', '2025-10-29 10:35:53');
INSERT INTO `sub_process_code` VALUES (15, 6, 3, 11, 'PA009', '切折叠器', '', 1, '2025-10-29 10:36:29', '2025-10-29 10:36:29');
INSERT INTO `sub_process_code` VALUES (16, 6, 3, 8, 'PA010', '钻防水孔', '', 1, '2025-10-29 10:36:56', '2025-10-29 10:36:56');
INSERT INTO `sub_process_code` VALUES (17, 6, 3, 12, 'PA011', '钻水壶孔', '', 1, '2025-10-29 10:37:27', '2025-10-29 10:37:27');
INSERT INTO `sub_process_code` VALUES (18, 6, 3, 13, 'PA012', '开槽', '', 1, '2025-10-29 10:38:07', '2025-10-29 10:38:07');
INSERT INTO `sub_process_code` VALUES (19, 6, 3, 11, 'PA013', '切消位', '', 1, '2025-10-29 10:38:31', '2025-10-29 10:38:31');
INSERT INTO `sub_process_code` VALUES (20, 6, 3, 7, 'PA014', '打消位', '', 1, '2025-10-29 10:39:13', '2025-10-29 10:39:13');
INSERT INTO `sub_process_code` VALUES (21, 6, 3, 14, 'PA015', '弯大管', '', 1, '2025-10-29 10:39:59', '2025-10-29 10:39:59');
INSERT INTO `sub_process_code` VALUES (22, 6, 3, 15, 'PA016', '弯小管', '', 1, '2025-10-29 10:40:32', '2025-10-29 10:40:32');
INSERT INTO `sub_process_code` VALUES (23, 6, 3, 16, 'PA017', '压弯', '', 1, '2025-10-29 10:42:04', '2025-10-29 10:42:04');
INSERT INTO `sub_process_code` VALUES (24, 6, 3, 17, 'PA018', '缩管', '', 1, '2025-10-29 10:43:00', '2025-10-29 10:43:00');
INSERT INTO `sub_process_code` VALUES (25, 6, 3, 18, 'PA019', '铣上叉弧', '', 1, '2025-10-29 10:43:46', '2025-10-29 10:43:46');
INSERT INTO `sub_process_code` VALUES (26, 6, 3, 19, 'PA020', '铣下叉弧', '', 1, '2025-10-29 10:44:25', '2025-10-29 10:44:25');
INSERT INTO `sub_process_code` VALUES (27, 6, 3, 20, 'PA021', '退火', '', 1, '2025-10-29 10:56:25', '2025-10-29 10:56:25');
INSERT INTO `sub_process_code` VALUES (28, 6, 3, 47, 'PA022', '刮毛刺', '', 1, '2025-10-29 10:56:59', '2025-10-29 10:56:59');
INSERT INTO `sub_process_code` VALUES (29, 6, 3, 22, 'PA023', '硬焊', '', 1, '2025-10-29 10:57:23', '2025-10-29 10:57:23');
INSERT INTO `sub_process_code` VALUES (30, 6, 3, 8, 'PA024', '钻消水孔', '', 1, '2025-10-29 10:57:55', '2025-10-29 10:57:55');
INSERT INTO `sub_process_code` VALUES (31, 6, 3, 23, 'PA025', '铣弧1', '', 1, '2025-10-29 10:58:24', '2025-10-29 10:58:24');
INSERT INTO `sub_process_code` VALUES (32, 6, 3, 24, 'PA026', '铣弧2', '', 1, '2025-10-29 10:58:59', '2025-10-29 10:58:59');
INSERT INTO `sub_process_code` VALUES (33, 6, 3, 25, 'PA027', '冲板', '', 1, '2025-10-29 10:59:20', '2025-10-29 10:59:20');
INSERT INTO `sub_process_code` VALUES (34, 6, 3, 26, 'PA028', '攻牙', '', 1, '2025-10-29 10:59:45', '2025-10-29 10:59:45');
INSERT INTO `sub_process_code` VALUES (35, 6, 3, 27, 'PA029', '上叉冲弧', '', 1, '2025-10-29 11:00:17', '2025-10-29 11:00:17');
INSERT INTO `sub_process_code` VALUES (36, 6, 3, 47, 'PA030', '折弯校正', '', 1, '2025-10-29 11:00:43', '2025-10-29 11:00:43');
INSERT INTO `sub_process_code` VALUES (37, 6, 3, 22, 'PA031', '硬焊', '', 1, '2025-10-29 11:01:34', '2025-10-29 11:01:34');
INSERT INTO `sub_process_code` VALUES (38, 6, 3, 28, 'PA032', '自动研磨', '', 1, '2025-10-29 11:05:31', '2025-10-29 11:05:31');
INSERT INTO `sub_process_code` VALUES (39, 6, 3, 47, 'PA033', '打磨', '', 1, '2025-10-29 11:06:11', '2025-10-29 11:06:11');
INSERT INTO `sub_process_code` VALUES (40, 6, 3, 23, 'PA034', '铣R', '', 1, '2025-10-29 11:06:50', '2025-10-29 11:06:50');
INSERT INTO `sub_process_code` VALUES (41, 6, 3, 29, 'PB001', '点焊左钩爪', '', 1, '2025-10-30 14:35:18', '2025-10-30 14:35:18');
INSERT INTO `sub_process_code` VALUES (42, 6, 3, 29, 'PB002', '焊左钩爪', '', 1, '2025-10-30 14:37:18', '2025-10-30 14:37:27');
INSERT INTO `sub_process_code` VALUES (43, 6, 3, 29, 'PB003', '点焊右钩爪', '', 1, '2025-10-30 14:39:10', '2025-10-30 14:39:10');
INSERT INTO `sub_process_code` VALUES (44, 6, 3, 29, 'PB004', '焊右钩爪', '', 1, '2025-10-30 14:39:38', '2025-10-30 14:39:38');
INSERT INTO `sub_process_code` VALUES (45, 6, 3, 29, 'PB005', '点上支杆货架螺母', '', 1, '2025-10-30 14:40:29', '2025-10-30 14:40:29');
INSERT INTO `sub_process_code` VALUES (46, 6, 3, 29, 'PB006', '焊上支杆货架螺母', '', 1, '2025-10-30 14:41:02', '2025-10-30 14:41:02');
INSERT INTO `sub_process_code` VALUES (47, 6, 3, 29, 'PB007', '点加焊上叉泥板螺母', '', 1, '2025-10-30 14:41:51', '2025-10-30 14:41:51');
INSERT INTO `sub_process_code` VALUES (48, 6, 3, 29, 'PB008', '点小中管接头', '', 1, '2025-10-30 14:42:48', '2025-10-30 14:42:48');
INSERT INTO `sub_process_code` VALUES (49, 6, 3, 29, 'PB009', '点枝干加曲付', '', 1, '2025-10-30 14:43:27', '2025-10-30 14:43:27');
INSERT INTO `sub_process_code` VALUES (50, 6, 3, 29, 'PB010', '焊竖管', '', 1, '2025-10-30 14:43:52', '2025-10-30 14:43:52');
INSERT INTO `sub_process_code` VALUES (51, 6, 3, 29, 'PB011', '点下叉接五通', '', 1, '2025-10-30 14:44:18', '2025-10-30 14:44:18');
INSERT INTO `sub_process_code` VALUES (52, 6, 3, 29, 'PB012', '焊碟刹', '', 1, '2025-10-30 14:44:45', '2025-10-30 14:44:45');
INSERT INTO `sub_process_code` VALUES (53, 6, 3, 29, 'PB013', '点焊链盖曲付', '', 1, '2025-10-30 14:45:24', '2025-10-30 14:45:24');
INSERT INTO `sub_process_code` VALUES (54, 6, 3, 29, 'PB014', '点焊停车曲付', '', 1, '2025-10-30 14:45:54', '2025-10-30 14:45:54');
INSERT INTO `sub_process_code` VALUES (55, 6, 3, 29, 'PB015', '点焊支撑棒', '', 1, '2025-10-30 14:46:18', '2025-10-30 14:46:18');
INSERT INTO `sub_process_code` VALUES (56, 6, 3, 29, 'PB016', '点焊五通曲付', '', 1, '2025-10-30 14:46:51', '2025-10-30 14:46:51');
INSERT INTO `sub_process_code` VALUES (57, 6, 3, 29, 'PB017', '点头管曲付', '', 1, '2025-10-30 14:47:16', '2025-10-30 14:47:16');
INSERT INTO `sub_process_code` VALUES (58, 6, 3, 29, 'PB018', '焊头管曲付', '', 1, '2025-10-30 14:47:50', '2025-10-30 14:47:50');
INSERT INTO `sub_process_code` VALUES (59, 6, 3, 29, 'PB019', '焊过线板', '', 1, '2025-10-30 14:48:14', '2025-10-30 14:48:14');
INSERT INTO `sub_process_code` VALUES (60, 6, 3, 29, 'PB020', '点避震片', '', 1, '2025-10-30 14:48:37', '2025-10-30 14:48:37');
INSERT INTO `sub_process_code` VALUES (61, 6, 3, 29, 'PB021', '焊避震片', '', 1, '2025-10-30 14:48:59', '2025-10-30 14:48:59');
INSERT INTO `sub_process_code` VALUES (62, 6, 3, 29, 'PB022', '点中管曲付', '', 1, '2025-10-30 14:49:35', '2025-10-30 14:49:35');
INSERT INTO `sub_process_code` VALUES (63, 6, 3, 29, 'PB023', '焊中管曲付', '', 1, '2025-10-30 14:50:16', '2025-10-30 14:50:16');
INSERT INTO `sub_process_code` VALUES (64, 6, 3, 29, 'PB024', '五通接中管加曲付组立', '', 1, '2025-10-30 14:50:46', '2025-10-30 14:50:46');
INSERT INTO `sub_process_code` VALUES (65, 6, 3, 29, 'PB025', '点货架片', '', 1, '2025-10-30 14:51:12', '2025-10-30 14:51:12');
INSERT INTO `sub_process_code` VALUES (66, 6, 3, 29, 'PB026', '货架+支撑管', '', 1, '2025-10-30 14:51:53', '2025-10-30 14:53:18');
INSERT INTO `sub_process_code` VALUES (67, 6, 3, 29, 'PB027', '点货架左右片', '', 1, '2025-10-30 14:53:46', '2025-10-30 14:53:46');
INSERT INTO `sub_process_code` VALUES (68, 6, 3, 29, 'PB028', '点边框加支撑管', '', 1, '2025-10-30 14:54:25', '2025-10-30 14:54:25');
INSERT INTO `sub_process_code` VALUES (69, 6, 3, 29, 'PB029', '点焊前三角曲付', '', 1, '2025-10-30 14:54:50', '2025-10-30 14:54:50');
INSERT INTO `sub_process_code` VALUES (70, 6, 3, 29, 'PB030', '点焊控制器封口片', '', 1, '2025-10-30 14:55:17', '2025-10-30 14:55:17');
INSERT INTO `sub_process_code` VALUES (71, 6, 3, 29, 'PB031', '点控制器接五通加中管', '', 1, '2025-10-30 14:55:46', '2025-10-30 14:55:46');
INSERT INTO `sub_process_code` VALUES (72, 6, 3, 29, 'PB032', '点焊尾灯片', '', 1, '2025-10-30 14:56:08', '2025-10-30 14:56:08');
INSERT INTO `sub_process_code` VALUES (73, 6, 3, 29, 'PB033', '点分体式上叉', '', 1, '2025-10-30 14:56:33', '2025-10-30 14:56:33');
INSERT INTO `sub_process_code` VALUES (74, 6, 3, 29, 'PB034', '点分体式下叉', '', 1, '2025-10-30 14:57:02', '2025-10-30 14:57:02');
INSERT INTO `sub_process_code` VALUES (75, 6, 3, 29, 'PB035', '点补强盒加线扣', '', 1, '2025-10-30 14:57:25', '2025-10-30 14:57:25');
INSERT INTO `sub_process_code` VALUES (76, 6, 3, 29, 'PB036', '点控制器线扣', '', 1, '2025-10-30 14:57:49', '2025-10-30 14:57:49');
INSERT INTO `sub_process_code` VALUES (77, 6, 3, 29, 'PB037', '点下叉线扣', '', 1, '2025-10-30 14:58:16', '2025-10-30 14:58:16');
INSERT INTO `sub_process_code` VALUES (78, 6, 3, 29, 'PB038', '点电池板', '', 1, '2025-10-30 14:58:42', '2025-10-30 14:58:42');
INSERT INTO `sub_process_code` VALUES (79, 6, 3, 29, 'PB039', '点电池板 线扣', '', 1, '2025-10-30 14:59:02', '2025-10-30 14:59:02');
INSERT INTO `sub_process_code` VALUES (80, 6, 3, 29, 'PB040', '点货架加强片左右', '', 1, '2025-10-30 14:59:45', '2025-10-30 14:59:45');
INSERT INTO `sub_process_code` VALUES (81, 6, 3, 29, 'PB041', '点上叉枝干1', '', 1, '2025-10-30 15:00:11', '2025-10-30 15:00:11');
INSERT INTO `sub_process_code` VALUES (82, 6, 3, 29, 'PB042', '点上叉枝干2', '', 1, '2025-10-30 15:00:35', '2025-10-30 15:00:35');
INSERT INTO `sub_process_code` VALUES (83, 6, 3, 29, 'PB043', '点货架接头加加强片', '', 1, '2025-10-30 15:01:03', '2025-10-30 15:01:03');
INSERT INTO `sub_process_code` VALUES (84, 6, 3, 29, 'PB044', '点货架加支撑管', '', 1, '2025-10-30 15:01:27', '2025-10-30 15:01:27');
INSERT INTO `sub_process_code` VALUES (85, 6, 3, 29, 'PB045', '点货架加 后支撑管', '', 1, '2025-10-30 15:01:53', '2025-10-30 15:01:53');
INSERT INTO `sub_process_code` VALUES (86, 6, 3, 29, 'PB046', '点焊电池仓', '', 1, '2025-10-30 15:02:22', '2025-10-30 15:02:22');
INSERT INTO `sub_process_code` VALUES (87, 6, 3, 29, 'PB047', '小五通接支撑管', '', 1, '2025-10-30 15:02:48', '2025-10-30 15:02:48');
INSERT INTO `sub_process_code` VALUES (88, 6, 3, 29, 'PB048', '点焊货架螺母', '', 1, '2025-10-30 15:03:21', '2025-10-30 15:03:21');
INSERT INTO `sub_process_code` VALUES (89, 6, 3, 29, 'PB049', '货架曲付锁螺丝', '', 1, '2025-10-30 15:03:55', '2025-10-30 15:03:55');
INSERT INTO `sub_process_code` VALUES (90, 6, 3, 31, 'PB050', '前三角组立', '', 1, '2025-10-30 15:04:56', '2025-10-30 15:04:56');
INSERT INTO `sub_process_code` VALUES (91, 6, 3, 32, 'PB051', '后三角组立', '', 1, '2025-10-30 15:05:27', '2025-10-30 15:05:27');
INSERT INTO `sub_process_code` VALUES (92, 6, 3, 33, 'PB052', '切折叠器', '', 1, '2025-10-30 15:05:49', '2025-10-30 15:05:49');
INSERT INTO `sub_process_code` VALUES (93, 6, 3, 46, 'PB053', '校正', '', 1, '2025-10-30 15:06:21', '2025-10-30 15:06:21');
INSERT INTO `sub_process_code` VALUES (94, 6, 3, 29, 'PB054', '焊前三角', '', 1, '2025-10-30 15:06:51', '2025-10-30 15:06:51');
INSERT INTO `sub_process_code` VALUES (95, 6, 3, 29, 'PB055', '焊后三角', '', 1, '2025-10-30 15:07:12', '2025-10-30 15:07:12');
INSERT INTO `sub_process_code` VALUES (96, 6, 3, 29, 'PB056', '点右勾爪', '', 1, '2025-10-30 15:07:46', '2025-10-30 15:07:46');
INSERT INTO `sub_process_code` VALUES (97, 6, 3, 48, 'PB057', '清洗', '', 1, '2025-10-30 15:08:10', '2025-10-30 15:08:10');
INSERT INTO `sub_process_code` VALUES (98, 6, 3, 29, 'PB058', '点折叠器', '', 1, '2025-10-30 15:08:44', '2025-10-30 15:08:44');
INSERT INTO `sub_process_code` VALUES (99, 6, 3, 29, 'PB059', '焊折叠器', '', 1, '2025-10-30 15:09:08', '2025-10-30 15:09:08');
INSERT INTO `sub_process_code` VALUES (100, 6, 3, 35, 'PC001', 'T4', '', 1, '2025-10-30 15:09:53', '2025-10-30 15:09:53');
INSERT INTO `sub_process_code` VALUES (101, 6, 3, 34, 'PC002', '校正', '', 1, '2025-10-30 15:10:19', '2025-10-30 15:10:19');
INSERT INTO `sub_process_code` VALUES (102, 6, 3, 36, 'PC003', '对眼', '', 1, '2025-10-30 15:10:49', '2025-10-30 15:10:49');
INSERT INTO `sub_process_code` VALUES (103, 6, 3, 37, 'PC004', 'T6', '', 1, '2025-10-30 15:11:16', '2025-10-30 15:11:16');
INSERT INTO `sub_process_code` VALUES (104, 6, 3, 38, 'PC005', '铰孔', '', 1, '2025-10-30 15:11:50', '2025-10-30 15:11:50');
INSERT INTO `sub_process_code` VALUES (105, 6, 3, 39, 'PC006', '铣头管', '', 1, '2025-10-30 15:12:11', '2025-10-30 15:12:11');
INSERT INTO `sub_process_code` VALUES (106, 6, 3, 40, 'PC007', '铣五通', '', 1, '2025-10-30 15:12:33', '2025-10-30 15:12:33');
INSERT INTO `sub_process_code` VALUES (107, 6, 3, 41, 'PC008', '铣碟刹', '', 1, '2025-10-30 15:12:58', '2025-10-30 15:12:58');
INSERT INTO `sub_process_code` VALUES (108, 6, 3, 9, 'PD001', '开折叠器', '', 1, '2025-10-30 15:13:37', '2025-10-30 15:13:37');
INSERT INTO `sub_process_code` VALUES (109, 6, 3, 9, 'PD002', '研磨', '', 1, '2025-10-30 15:14:15', '2025-10-30 15:14:15');
INSERT INTO `sub_process_code` VALUES (110, 6, 3, 43, 'PE001', '补土', '', 1, '2025-10-30 15:15:18', '2025-10-30 15:15:18');
INSERT INTO `sub_process_code` VALUES (111, 6, 3, 21, 'PF001', '钻电池空', '', 1, '2025-10-30 15:15:56', '2025-10-30 15:15:56');
INSERT INTO `sub_process_code` VALUES (112, 6, 3, 42, 'PF002', '皮膜', '', 1, '2025-10-30 15:16:28', '2025-10-30 15:16:28');
INSERT INTO `sub_process_code` VALUES (113, 6, 3, 44, 'PF003', 'QC全检', '', 1, '2025-10-30 15:17:22', '2025-10-30 15:17:22');
INSERT INTO `sub_process_code` VALUES (114, 6, 3, 45, 'PF004', '包装', '', 1, '2025-10-30 15:18:23', '2025-10-30 15:18:23');
INSERT INTO `sub_process_code` VALUES (115, 15, 3, 49, 'PX001', '铣边槽', '', 1, '2025-11-29 11:34:19', '2025-11-29 11:34:19');

-- ----------------------------
-- Table structure for sub_process_cycle
-- ----------------------------
DROP TABLE IF EXISTS `sub_process_cycle`;
CREATE TABLE `sub_process_cycle`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键ID',
  `company_id` int(11) NOT NULL COMMENT '企业id，关联企业信息表',
  `user_id` int(11) NOT NULL COMMENT '发布的用户id，关联用户表',
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '制程名称',
  `sort` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '排序',
  `sort_date` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '最短交货时间',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '制程组列表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_process_cycle
-- ----------------------------
INSERT INTO `sub_process_cycle` VALUES (1, 1, 1, '备料组', '0', '4', 1, '2025-08-21 09:30:12', '2025-10-26 18:10:51');
INSERT INTO `sub_process_cycle` VALUES (2, 1, 1, '设备组', '0', '4', 1, '2025-08-21 09:30:39', '2025-10-26 18:10:52');
INSERT INTO `sub_process_cycle` VALUES (3, 1, 1, '生产组', '0', '5', 1, '2025-08-21 09:30:45', '2025-10-26 18:10:52');
INSERT INTO `sub_process_cycle` VALUES (4, 1, 1, '其他组', '0', NULL, 1, '2025-10-16 19:09:55', '2025-10-26 18:10:53');
INSERT INTO `sub_process_cycle` VALUES (5, 1, 1, '不好组', '0', NULL, 1, '2025-10-16 19:15:43', '2025-10-26 18:10:53');
INSERT INTO `sub_process_cycle` VALUES (6, 3, 15, '备料组', 'A', '1', 1, '2025-10-18 10:10:27', '2025-11-29 11:04:38');
INSERT INTO `sub_process_cycle` VALUES (7, 3, 15, '焊接组', 'B', '2', 1, '2025-10-18 10:10:44', '2025-11-29 11:04:45');
INSERT INTO `sub_process_cycle` VALUES (8, 3, 15, '热处理', 'C', '1.5', 1, '2025-10-18 10:11:22', '2025-11-29 11:04:54');
INSERT INTO `sub_process_cycle` VALUES (9, 3, 15, '研磨组', 'D', '1', 1, '2025-10-18 10:11:37', '2025-11-29 11:05:01');
INSERT INTO `sub_process_cycle` VALUES (10, 3, 15, '补土组', 'E', '1.5', 1, '2025-10-18 10:11:55', '2025-11-29 11:05:08');
INSERT INTO `sub_process_cycle` VALUES (11, 3, 15, '后段组', 'F', '1.5', 1, '2025-10-18 10:12:08', '2025-11-29 11:05:15');
INSERT INTO `sub_process_cycle` VALUES (12, 3, 6, '行政部', '0', NULL, 1, '2025-10-28 13:45:18', '2025-10-28 13:45:18');
INSERT INTO `sub_process_cycle` VALUES (13, 3, 6, '技术部', '0', NULL, 1, '2025-10-28 13:45:30', '2025-10-28 13:45:30');
INSERT INTO `sub_process_cycle` VALUES (14, 3, 6, '业务部', '0', NULL, 1, '2025-10-28 13:45:41', '2025-10-28 13:45:41');
INSERT INTO `sub_process_cycle` VALUES (15, 3, 6, '总经办', '0', NULL, 1, '2025-10-28 13:45:53', '2025-10-28 13:45:53');
INSERT INTO `sub_process_cycle` VALUES (16, 3, 6, '生产部', '0', NULL, 1, '2025-11-09 01:08:57', '2025-11-09 01:08:57');
INSERT INTO `sub_process_cycle` VALUES (17, 3, 15, '财务部', '0', NULL, 1, '2025-11-11 02:21:21', '2025-11-29 11:00:19');
INSERT INTO `sub_process_cycle` VALUES (18, 3, 15, '外协组', '1', '2', 1, '2025-11-28 16:31:17', '2025-11-29 15:01:39');

-- ----------------------------
-- Table structure for sub_process_cycle_child
-- ----------------------------
DROP TABLE IF EXISTS `sub_process_cycle_child`;
CREATE TABLE `sub_process_cycle_child`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键 ID',
  `cycle_id` int(11) NULL DEFAULT NULL COMMENT '生产制程ID',
  `progress_id` int(11) NULL DEFAULT NULL COMMENT '进度表ID',
  `end_date` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '预排交期',
  `load` decimal(20, 1) NULL DEFAULT NULL COMMENT '制程日总负荷',
  `order_number` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '完成数量',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 494 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_process_cycle_child
-- ----------------------------
INSERT INTO `sub_process_cycle_child` VALUES (274, 6, 230, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (275, 7, 230, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (276, 8, 230, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (277, 9, 230, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (278, 10, 230, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (279, 11, 230, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (280, 12, 230, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (281, 13, 230, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (282, 14, 230, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (283, 15, 230, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (284, 6, 231, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (285, 7, 231, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (286, 8, 231, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (287, 9, 231, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (288, 10, 231, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (289, 11, 231, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (290, 12, 231, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (291, 13, 231, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (292, 14, 231, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (293, 15, 231, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (294, 6, 232, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (295, 7, 232, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (296, 8, 232, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (297, 9, 232, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (298, 10, 232, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (299, 11, 232, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (300, 12, 232, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (301, 13, 232, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (302, 14, 232, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (303, 15, 232, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (304, 6, 233, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (305, 7, 233, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (306, 8, 233, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (307, 9, 233, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (308, 10, 233, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (309, 11, 233, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (310, 12, 233, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (311, 13, 233, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (312, 14, 233, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (313, 15, 233, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (314, 6, 234, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (315, 7, 234, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (316, 8, 234, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (317, 9, 234, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (318, 10, 234, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (319, 11, 234, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (320, 12, 234, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (321, 13, 234, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (322, 14, 234, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (323, 15, 234, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (324, 6, 235, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (325, 7, 235, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (326, 8, 235, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (327, 9, 235, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (328, 10, 235, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (329, 11, 235, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (330, 12, 235, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (331, 13, 235, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (332, 14, 235, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (333, 15, 235, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (334, 6, 236, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (335, 7, 236, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (336, 8, 236, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (337, 9, 236, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (338, 10, 236, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (339, 11, 236, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (340, 12, 236, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (341, 13, 236, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (342, 14, 236, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (343, 15, 236, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (344, 6, 237, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (345, 7, 237, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (346, 8, 237, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (347, 9, 237, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (348, 10, 237, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (349, 11, 237, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (350, 12, 237, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (351, 13, 237, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (352, 14, 237, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (353, 15, 237, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (354, 6, 238, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (355, 7, 238, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (356, 8, 238, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (357, 9, 238, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (358, 10, 238, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (359, 11, 238, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (360, 12, 238, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (361, 13, 238, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (362, 14, 238, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (363, 15, 238, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (364, 6, 239, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (365, 7, 239, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (366, 8, 239, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (367, 9, 239, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (368, 10, 239, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (369, 11, 239, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (370, 12, 239, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (371, 13, 239, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (372, 14, 239, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (373, 15, 239, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (374, 6, 240, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (375, 7, 240, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (376, 8, 240, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (377, 9, 240, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (378, 10, 240, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (379, 11, 240, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (380, 12, 240, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (381, 13, 240, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (382, 14, 240, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (383, 15, 240, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (384, 6, 241, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (385, 7, 241, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (386, 8, 241, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (387, 9, 241, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (388, 10, 241, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (389, 11, 241, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (390, 12, 241, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (391, 13, 241, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (392, 14, 241, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (393, 15, 241, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (394, 6, 242, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (395, 7, 242, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (396, 8, 242, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (397, 9, 242, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (398, 10, 242, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (399, 11, 242, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (400, 12, 242, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (401, 13, 242, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (402, 14, 242, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (403, 15, 242, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (404, 6, 243, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (405, 7, 243, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (406, 8, 243, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (407, 9, 243, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (408, 10, 243, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (409, 11, 243, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (410, 12, 243, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (411, 13, 243, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (412, 14, 243, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (413, 15, 243, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (414, 6, 244, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (415, 7, 244, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (416, 8, 244, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (417, 9, 244, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (418, 10, 244, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (419, 11, 244, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (420, 12, 244, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (421, 13, 244, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (422, 14, 244, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (423, 15, 244, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (424, 6, 245, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (425, 7, 245, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (426, 8, 245, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (427, 9, 245, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (428, 10, 245, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (429, 11, 245, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (430, 12, 245, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (431, 13, 245, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (432, 14, 245, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (433, 15, 245, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (434, 6, 246, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (435, 7, 246, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (436, 8, 246, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (437, 9, 246, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (438, 10, 246, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (439, 11, 246, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (440, 12, 246, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (441, 13, 246, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (442, 14, 246, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (443, 15, 246, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (444, 6, 247, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (445, 7, 247, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (446, 8, 247, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (447, 9, 247, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (448, 10, 247, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (449, 11, 247, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (450, 12, 247, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (451, 13, 247, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (452, 14, 247, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (453, 15, 247, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (454, 6, 248, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (455, 7, 248, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (456, 8, 248, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (457, 9, 248, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (458, 10, 248, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (459, 11, 248, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (460, 12, 248, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (461, 13, 248, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (462, 14, 248, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (463, 15, 248, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (464, 6, 249, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (465, 7, 249, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (466, 8, 249, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (467, 9, 249, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (468, 10, 249, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (469, 11, 249, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (470, 12, 249, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (471, 13, 249, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (472, 14, 249, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (473, 15, 249, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (474, 6, 250, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (475, 7, 250, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (476, 8, 250, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (477, 9, 250, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (478, 10, 250, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (479, 11, 250, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (480, 12, 250, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (481, 13, 250, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (482, 14, 250, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (483, 15, 250, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (484, 6, 251, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (485, 7, 251, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (486, 8, 251, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (487, 9, 251, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (488, 10, 251, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (489, 11, 251, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (490, 12, 251, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (491, 13, 251, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (492, 14, 251, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');
INSERT INTO `sub_process_cycle_child` VALUES (493, 15, 251, NULL, NULL, NULL, '2025-11-02 14:38:22', '2025-11-02 14:38:22');

-- ----------------------------
-- Table structure for sub_product_code
-- ----------------------------
DROP TABLE IF EXISTS `sub_product_code`;
CREATE TABLE `sub_product_code`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键ID',
  `company_id` int(11) NOT NULL COMMENT '企业id',
  `user_id` int(5) NULL DEFAULT NULL COMMENT '发布的用户id',
  `product_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '产品的唯一标识编码',
  `product_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '产品的名称',
  `drawing` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '工程图号',
  `model` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '产品的型号',
  `specification` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '产品的规格参数',
  `other_features` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '产品的其他特性描述',
  `component_structure` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '产品的部件结构说明',
  `unit` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '产品的计量单位',
  `production_requirements` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '产品的生产要求',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '1：未删除；0：已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '记录创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '记录最后更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '产品编码基础信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_product_code
-- ----------------------------
INSERT INTO `sub_product_code` VALUES (9, 1, 1, '12111111', '113', '图只可以', '21', '2131', '3131', '1313', '', '21', 1, '2025-07-08 15:02:27', '2025-11-28 11:23:09');
INSERT INTO `sub_product_code` VALUES (10, 1, 1, '1233', '212', '月1', '121', '2121', '2121', '21', '', '2121', 1, '2025-07-08 15:12:29', '2025-11-28 11:23:09');
INSERT INTO `sub_product_code` VALUES (11, 1, 1, '1234', '12', '121', '212', '21', '212', '211', '', '121', 1, '2025-07-15 11:04:40', '2025-11-28 11:23:10');
INSERT INTO `sub_product_code` VALUES (12, 1, 1, '12321', '21221', '2121', 'wdd', 'dwwdq', 'dwqwdw', 'qdwq', '', '2121', 1, '2025-08-08 11:19:00', '2025-11-28 11:23:11');
INSERT INTO `sub_product_code` VALUES (13, 1, 1, '12322', '21222', '2121', 'wdd', 'dwwdq', 'dwqwdw', 'qdwq', '', '2121', 1, '2025-08-08 11:23:21', '2025-11-28 11:23:11');
INSERT INTO `sub_product_code` VALUES (14, 1, 1, '12323', '21223', '2121', 'wdd', 'dwwdq', 'dwqwdw', 'qdwq', '', '2121', 1, '2025-08-08 11:28:28', '2025-11-28 11:23:12');
INSERT INTO `sub_product_code` VALUES (15, 1, 1, '12324', '21224', '2121', 'wdd', 'dwwdq', 'dwqwdw', 'qdwq', '', '2121', 1, '2025-08-08 11:34:57', '2025-11-28 11:23:12');
INSERT INTO `sub_product_code` VALUES (16, 1, 1, '12325', '21225', '2121', 'wdd', 'dwwdq', 'dwqwdw', 'qdwq', '', '2121', 1, '2025-08-08 11:35:22', '2025-11-28 11:23:13');
INSERT INTO `sub_product_code` VALUES (17, 1, 1, '12671', '4841', 'eewqw', 'ewe', 'rwrw', 'rww', 'qeqeq', '', '31', 1, '2025-08-08 11:36:50', '2025-11-28 11:23:14');
INSERT INTO `sub_product_code` VALUES (18, 1, 1, '43456', '2345', '23', '423', '42', 'ewf', '5', '', '12', 0, '2025-08-08 14:10:41', '2025-11-28 11:23:14');
INSERT INTO `sub_product_code` VALUES (19, 1, 1, 'A001', '圆珠笔', 'qqqwe', 'eeqqwq', 'sewww', 'ersdsd', 'ewww', '', 'rww', 1, '2025-08-10 10:09:09', '2025-11-28 11:23:15');
INSERT INTO `sub_product_code` VALUES (20, 3, 6, 'WA-A00001', '0611铝车架', '0611', '城市代步Q1', '36寸', '折叠型', '整车结构', '48', '1.字码2510001-2510800；2.车架补土后烤漆', 1, '2025-10-18 04:34:51', '2025-11-28 11:23:24');
INSERT INTO `sub_product_code` VALUES (21, 3, 6, 'WA-A00002', '0612铝车架', '0612', '山地车', '32寸', '配载重货架', '整体车架+独立货架', '', '1.产品表面研磨清洗；2.产品杜绝补土；3.按订单要求打字码', 1, '2025-10-27 14:44:02', '2025-11-28 11:23:17');

-- ----------------------------
-- Table structure for sub_product_notice
-- ----------------------------
DROP TABLE IF EXISTS `sub_product_notice`;
CREATE TABLE `sub_product_notice`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键ID',
  `company_id` int(11) NOT NULL COMMENT '企业id',
  `user_id` int(11) NOT NULL COMMENT '发布的用户id',
  `notice` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '生产订单号',
  `customer_id` int(11) NULL DEFAULT NULL COMMENT '客户id',
  `product_id` int(11) NULL DEFAULT NULL COMMENT '产品id',
  `sale_id` int(11) NULL DEFAULT NULL COMMENT '销售id',
  `delivery_time` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '交货日期',
  `is_notice` int(1) NULL DEFAULT 1 COMMENT '是否已排产：1 - 未排产，0 - 已排产',
  `is_finish` int(11) NULL DEFAULT 1 COMMENT '是否已完结：1 - 未完结，0 - 已完结',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '生产通知单信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_product_notice
-- ----------------------------
INSERT INTO `sub_product_notice` VALUES (11, 3, 6, 'DD2511001', 4, 20, 5, '2025-12-28', 0, 1, 1, '2025-11-28 15:54:19', '2025-11-28 16:58:04');
INSERT INTO `sub_product_notice` VALUES (12, 3, 6, 'DD2511002', 5, 20, 6, '2025-12-27', 1, 1, 1, '2025-11-28 15:54:39', '2025-11-28 16:28:39');
INSERT INTO `sub_product_notice` VALUES (13, 3, 15, 'DD2511003', 5, 21, 7, '2026-01-13', 0, 1, 1, '2025-11-29 14:14:29', '2025-11-29 14:26:39');

-- ----------------------------
-- Table structure for sub_product_quotation
-- ----------------------------
DROP TABLE IF EXISTS `sub_product_quotation`;
CREATE TABLE `sub_product_quotation`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键ID',
  `company_id` int(11) NOT NULL COMMENT '企业id',
  `user_id` int(11) NOT NULL COMMENT '发布的用户id',
  `sale_id` int(11) NOT NULL COMMENT '销售订单id',
  `customer_id` int(11) NULL DEFAULT NULL COMMENT '客户id',
  `product_id` int(11) NULL DEFAULT NULL COMMENT '产品id',
  `notice` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '报价单号',
  `product_price` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '产品单价',
  `transaction_currency` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '交易币别',
  `transaction_method` int(5) NULL DEFAULT NULL COMMENT '交易方式',
  `other_transaction_terms` varchar(5) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '结算周期',
  `other_text` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '其他结算周期',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '产品报价表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_product_quotation
-- ----------------------------
INSERT INTO `sub_product_quotation` VALUES (15, 3, 6, 5, 4, 20, '', '580', 'RMB', 27, '31', '', 1, '2025-11-28 15:45:35', '2025-11-28 15:45:35');
INSERT INTO `sub_product_quotation` VALUES (16, 3, 6, 6, 5, 20, '', '600', 'RMB', 29, '31', '', 1, '2025-11-28 15:46:28', '2025-11-28 15:46:28');
INSERT INTO `sub_product_quotation` VALUES (17, 3, 15, 7, 5, 21, '', '550', 'RMB', 29, '31', '', 1, '2025-11-29 14:13:54', '2025-11-29 14:13:54');

-- ----------------------------
-- Table structure for sub_production_progress
-- ----------------------------
DROP TABLE IF EXISTS `sub_production_progress`;
CREATE TABLE `sub_production_progress`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键ID',
  `company_id` int(11) NOT NULL COMMENT '企业id',
  `user_id` int(11) NOT NULL COMMENT '发布的用户id',
  `notice_id` int(11) NULL DEFAULT NULL COMMENT '生产通知单id',
  `notice_number` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生产通知单',
  `delivery_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '客户交期',
  `customer_abbreviation` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '客户名称',
  `product_id` int(11) NULL DEFAULT NULL COMMENT '产品id',
  `product_code` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '产品编码',
  `product_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '产品名称',
  `product_drawing` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '产品图号',
  `part_id` int(11) NULL DEFAULT NULL COMMENT '部件id',
  `part_code` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '部件编码',
  `part_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '部件名称',
  `bom_id` int(11) NULL DEFAULT NULL COMMENT 'bom表的id',
  `house_number` int(11) NULL DEFAULT NULL COMMENT '委外/库存数量',
  `order_number` int(20) NULL DEFAULT NULL COMMENT '订单数量',
  `customer_order` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '客户订单号',
  `rece_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '接单日期',
  `out_number` int(20) NULL DEFAULT NULL COMMENT '生产数量',
  `start_date` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '预计起始生产时间',
  `remarks` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '生产特别要求',
  `is_finish` int(11) NULL DEFAULT 1 COMMENT '生产订单是否已完结：1 - 未完结，0 - 已完结',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '生产进度表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_production_progress
-- ----------------------------

-- ----------------------------
-- Table structure for sub_progress_base
-- ----------------------------
DROP TABLE IF EXISTS `sub_progress_base`;
CREATE TABLE `sub_progress_base`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `company_id` int(11) NULL DEFAULT NULL COMMENT '企业ID',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '用户发布的ID',
  `notice_id` int(11) NULL DEFAULT NULL COMMENT '生产订单ID',
  `sale_id` int(11) NULL DEFAULT NULL COMMENT '销售订单ID',
  `product_id` int(11) NULL DEFAULT NULL COMMENT '产品id',
  `product_code` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '产品编码',
  `product_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '产品名称',
  `drawing` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '产品图号',
  `part_id` int(11) NULL DEFAULT NULL COMMENT '部件id',
  `part_code` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '部件编码',
  `part_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '部件名称',
  `bom_id` int(11) NULL DEFAULT NULL COMMENT 'bom表的id',
  `house_number` int(11) NULL DEFAULT NULL COMMENT '委外/库存数量',
  `out_number` int(11) NULL DEFAULT NULL COMMENT '生产数量',
  `start_date` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '预计起始生产时间',
  `remarks` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '生产特别要求',
  `is_finish` int(1) NULL DEFAULT 1 COMMENT '生产订单是否已完结：1 - 未完结，0 - 已完结',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '进度表的基础数据表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_progress_base
-- ----------------------------
INSERT INTO `sub_progress_base` VALUES (1, 3, 6, 11, 5, 20, 'WA-A00001', '0611铝车架', '0611', 21, 'X001', '车首管', 59, NULL, 18000, '2025-11-29', '', 1, 1, '2025-11-28 16:58:04', '2025-11-28 16:59:27');
INSERT INTO `sub_progress_base` VALUES (2, 3, 6, 11, 5, 20, 'WA-A00001', '0611铝车架', '0611', 27, 'X007', '五通', 60, NULL, 18000, '2025-11-29', '', 1, 1, '2025-11-28 16:58:04', '2025-11-28 16:59:27');
INSERT INTO `sub_progress_base` VALUES (3, 3, 6, 11, 5, 20, 'WA-A00001', '0611铝车架', '0611', 34, 'X014', '中管', 63, NULL, 18000, '2025-11-29', '', 1, 1, '2025-11-28 16:58:04', '2025-11-28 16:59:27');
INSERT INTO `sub_progress_base` VALUES (4, 3, 6, 11, 5, 20, 'WA-A00001', '0611铝车架', '0611', 33, 'X013', '手提管', 64, NULL, 18000, '2025-11-29', '', 1, 1, '2025-11-28 16:58:04', '2025-11-28 16:59:27');
INSERT INTO `sub_progress_base` VALUES (5, 3, 6, 11, 5, 20, 'WA-A00001', '0611铝车架', '0611', 25, 'X005', '下管', 65, NULL, 18000, '2025-11-29', '', 1, 1, '2025-11-28 16:58:04', '2025-11-28 16:59:27');
INSERT INTO `sub_progress_base` VALUES (6, 3, 6, 11, 5, 20, 'WA-A00001', '0611铝车架', '0611', 38, 'X018', '过线管', 66, NULL, 18000, '2025-11-29', '', 1, 1, '2025-11-28 16:58:04', '2025-11-28 16:59:27');
INSERT INTO `sub_progress_base` VALUES (7, 3, 6, 11, 5, 20, 'WA-A00001', '0611铝车架', '0611', 22, 'X002', '主梁管', 67, NULL, 18000, '2025-11-29', '', 1, 1, '2025-11-28 16:58:04', '2025-11-28 16:59:27');
INSERT INTO `sub_progress_base` VALUES (8, 3, 6, 11, 5, 20, 'WA-A00001', '0611铝车架', '0611', 29, 'X009', '后上叉L', 68, NULL, 18000, '2025-11-29', '', 1, 1, '2025-11-28 16:58:04', '2025-11-28 16:59:27');
INSERT INTO `sub_progress_base` VALUES (9, 3, 6, 11, 5, 20, 'WA-A00001', '0611铝车架', '0611', 28, 'X008', '后上叉R', 69, NULL, 18000, '2025-11-29', '', 1, 1, '2025-11-28 16:58:04', '2025-11-28 16:59:27');
INSERT INTO `sub_progress_base` VALUES (10, 3, 6, 11, 5, 20, 'WA-A00001', '0611铝车架', '0611', 35, 'X015', '上支杆', 70, NULL, 18000, '2025-11-29', '', 1, 1, '2025-11-28 16:58:04', '2025-11-28 16:59:27');
INSERT INTO `sub_progress_base` VALUES (11, 3, 6, 11, 5, 20, 'WA-A00001', '0611铝车架', '0611', 36, 'X016', '下枝杆', 71, NULL, 18000, '2025-11-29', '', 1, 1, '2025-11-28 16:58:04', '2025-11-28 16:59:27');
INSERT INTO `sub_progress_base` VALUES (12, 3, 6, 11, 5, 20, 'WA-A00001', '0611铝车架', '0611', 39, 'X019', '上叉', 72, NULL, 18000, '2025-11-29', '', 1, 1, '2025-11-28 16:58:04', '2025-11-28 16:59:27');
INSERT INTO `sub_progress_base` VALUES (13, 3, 6, 11, 5, 20, 'WA-A00001', '0611铝车架', '0611', 30, 'X010', '后下叉R', 73, NULL, 18000, '2025-11-29', '', 1, 1, '2025-11-28 16:58:04', '2025-11-28 16:59:27');
INSERT INTO `sub_progress_base` VALUES (14, 3, 6, 11, 5, 20, 'WA-A00001', '0611铝车架', '0611', 31, 'X011', '后下叉L', 74, NULL, 18000, '2025-11-29', '', 1, 1, '2025-11-28 16:58:04', '2025-11-28 16:59:27');
INSERT INTO `sub_progress_base` VALUES (15, 3, 6, 11, 5, 20, 'WA-A00001', '0611铝车架', '0611', 37, 'X017', '下叉', 75, NULL, 18000, '2025-11-29', '', 1, 1, '2025-11-28 16:58:04', '2025-11-28 16:59:27');
INSERT INTO `sub_progress_base` VALUES (16, 3, 6, 11, 5, 20, 'WA-A00001', '0611铝车架', '0611', 40, 'Y001', '左钩爪', 76, NULL, 18000, '2025-11-29', '', 1, 1, '2025-11-28 16:58:04', '2025-11-28 16:59:27');
INSERT INTO `sub_progress_base` VALUES (17, 3, 6, 11, 5, 20, 'WA-A00001', '0611铝车架', '0611', 41, 'Y002', '右钩爪', 77, NULL, 18000, '2025-11-29', '', 1, 1, '2025-11-28 16:58:04', '2025-11-28 16:59:27');
INSERT INTO `sub_progress_base` VALUES (18, 3, 6, 11, 5, 20, 'WA-A00001', '0611铝车架', '0611', 42, 'Y003', '上叉支杆', 78, NULL, 18000, '2025-11-29', '', 1, 1, '2025-11-28 16:58:04', '2025-11-28 16:59:27');
INSERT INTO `sub_progress_base` VALUES (19, 3, 6, 11, 5, 20, 'WA-A00001', '0611铝车架', '0611', 43, 'Y004', '组立折叠器', 79, NULL, 18000, '2025-11-29', '', 1, 1, '2025-11-28 16:58:04', '2025-11-28 16:59:27');
INSERT INTO `sub_progress_base` VALUES (20, 3, 6, 11, 5, 20, 'WA-A00001', '0611铝车架', '0611', 44, 'Y005', '组立前三角', 80, NULL, 18000, '2025-11-29', '', 1, 1, '2025-11-28 16:58:04', '2025-11-28 16:59:27');
INSERT INTO `sub_progress_base` VALUES (21, 3, 6, 11, 5, 20, 'WA-A00001', '0611铝车架', '0611', 45, 'Y006', '组立后三角', 81, NULL, 18000, '2025-11-29', '', 1, 1, '2025-11-28 16:58:04', '2025-11-28 16:59:27');
INSERT INTO `sub_progress_base` VALUES (22, 3, 6, 11, 5, 20, 'WA-A00001', '0611铝车架', '0611', 46, 'Z001', '成品车架', 82, NULL, 18000, '2025-11-29', '', 1, 1, '2025-11-28 16:58:04', '2025-11-28 16:59:27');
INSERT INTO `sub_progress_base` VALUES (23, 3, 15, 13, 7, 21, 'WA-A00002', '0612铝车架', '0612', 27, 'X007', '五通', 85, NULL, 5000, '2025-11-30', '', 1, 1, '2025-11-29 14:26:39', '2025-11-29 15:02:19');
INSERT INTO `sub_progress_base` VALUES (24, 3, 15, 13, 7, 21, 'WA-A00002', '0612铝车架', '0612', 27, 'X007', '五通', 83, NULL, 5000, '2025-11-30', '', 1, 1, '2025-11-29 14:26:39', '2025-11-29 15:02:19');

-- ----------------------------
-- Table structure for sub_progress_cycle
-- ----------------------------
DROP TABLE IF EXISTS `sub_progress_cycle`;
CREATE TABLE `sub_progress_cycle`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键 ID',
  `company_id` int(11) NULL DEFAULT NULL COMMENT '公司ID',
  `notice_id` int(11) NULL DEFAULT NULL COMMENT '生产通知单ID',
  `cycle_id` int(11) NULL DEFAULT NULL COMMENT '生产制程ID',
  `progress_id` int(11) NULL DEFAULT NULL COMMENT '进度表ID',
  `end_date` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '预排交期',
  `load` decimal(20, 1) NULL DEFAULT NULL COMMENT '制程日总负荷',
  `order_number` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '完成数量',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 169 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '进度表的制程子表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_progress_cycle
-- ----------------------------
INSERT INTO `sub_progress_cycle` VALUES (1, 3, 11, 18, 1, NULL, NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_cycle` VALUES (2, 3, 11, 6, 1, '2025-12-06', NULL, NULL, '2025-11-28 16:58:04', '2025-11-29 15:08:06');
INSERT INTO `sub_progress_cycle` VALUES (3, 3, 11, 7, 1, '2025-12-18', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:02:12');
INSERT INTO `sub_progress_cycle` VALUES (4, 3, 11, 8, 1, '2025-12-20', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:57');
INSERT INTO `sub_progress_cycle` VALUES (5, 3, 11, 9, 1, '2025-12-22', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:40');
INSERT INTO `sub_progress_cycle` VALUES (6, 3, 11, 10, 1, '2025-12-24', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:22');
INSERT INTO `sub_progress_cycle` VALUES (7, 3, 11, 11, 1, '2025-12-27', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:00:17');
INSERT INTO `sub_progress_cycle` VALUES (8, 3, 11, 18, 2, NULL, NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_cycle` VALUES (9, 3, 11, 6, 2, '2025-12-06', NULL, NULL, '2025-11-28 16:58:04', '2025-11-29 15:08:06');
INSERT INTO `sub_progress_cycle` VALUES (10, 3, 11, 7, 2, '2025-12-18', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:02:12');
INSERT INTO `sub_progress_cycle` VALUES (11, 3, 11, 8, 2, '2025-12-20', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:57');
INSERT INTO `sub_progress_cycle` VALUES (12, 3, 11, 9, 2, '2025-12-22', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:40');
INSERT INTO `sub_progress_cycle` VALUES (13, 3, 11, 10, 2, '2025-12-24', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:22');
INSERT INTO `sub_progress_cycle` VALUES (14, 3, 11, 11, 2, '2025-12-27', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:00:17');
INSERT INTO `sub_progress_cycle` VALUES (15, 3, 11, 18, 3, NULL, NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_cycle` VALUES (16, 3, 11, 6, 3, '2025-12-06', NULL, NULL, '2025-11-28 16:58:04', '2025-11-29 15:08:06');
INSERT INTO `sub_progress_cycle` VALUES (17, 3, 11, 7, 3, '2025-12-18', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:02:12');
INSERT INTO `sub_progress_cycle` VALUES (18, 3, 11, 8, 3, '2025-12-20', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:57');
INSERT INTO `sub_progress_cycle` VALUES (19, 3, 11, 9, 3, '2025-12-22', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:40');
INSERT INTO `sub_progress_cycle` VALUES (20, 3, 11, 10, 3, '2025-12-24', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:22');
INSERT INTO `sub_progress_cycle` VALUES (21, 3, 11, 11, 3, '2025-12-27', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:00:17');
INSERT INTO `sub_progress_cycle` VALUES (22, 3, 11, 18, 4, NULL, NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_cycle` VALUES (23, 3, 11, 6, 4, '2025-12-06', NULL, NULL, '2025-11-28 16:58:04', '2025-11-29 15:08:06');
INSERT INTO `sub_progress_cycle` VALUES (24, 3, 11, 7, 4, '2025-12-18', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:02:12');
INSERT INTO `sub_progress_cycle` VALUES (25, 3, 11, 8, 4, '2025-12-20', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:57');
INSERT INTO `sub_progress_cycle` VALUES (26, 3, 11, 9, 4, '2025-12-22', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:40');
INSERT INTO `sub_progress_cycle` VALUES (27, 3, 11, 10, 4, '2025-12-24', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:22');
INSERT INTO `sub_progress_cycle` VALUES (28, 3, 11, 11, 4, '2025-12-27', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:00:17');
INSERT INTO `sub_progress_cycle` VALUES (29, 3, 11, 18, 5, NULL, NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_cycle` VALUES (30, 3, 11, 6, 5, '2025-12-06', NULL, NULL, '2025-11-28 16:58:04', '2025-11-29 15:08:06');
INSERT INTO `sub_progress_cycle` VALUES (31, 3, 11, 7, 5, '2025-12-18', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:02:12');
INSERT INTO `sub_progress_cycle` VALUES (32, 3, 11, 8, 5, '2025-12-20', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:57');
INSERT INTO `sub_progress_cycle` VALUES (33, 3, 11, 9, 5, '2025-12-22', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:40');
INSERT INTO `sub_progress_cycle` VALUES (34, 3, 11, 10, 5, '2025-12-24', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:22');
INSERT INTO `sub_progress_cycle` VALUES (35, 3, 11, 11, 5, '2025-12-27', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:00:17');
INSERT INTO `sub_progress_cycle` VALUES (36, 3, 11, 18, 6, NULL, NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_cycle` VALUES (37, 3, 11, 6, 6, '2025-12-06', NULL, NULL, '2025-11-28 16:58:04', '2025-11-29 15:08:06');
INSERT INTO `sub_progress_cycle` VALUES (38, 3, 11, 7, 6, '2025-12-18', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:02:12');
INSERT INTO `sub_progress_cycle` VALUES (39, 3, 11, 8, 6, '2025-12-20', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:57');
INSERT INTO `sub_progress_cycle` VALUES (40, 3, 11, 9, 6, '2025-12-22', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:40');
INSERT INTO `sub_progress_cycle` VALUES (41, 3, 11, 10, 6, '2025-12-24', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:22');
INSERT INTO `sub_progress_cycle` VALUES (42, 3, 11, 11, 6, '2025-12-27', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:00:17');
INSERT INTO `sub_progress_cycle` VALUES (43, 3, 11, 18, 7, NULL, NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_cycle` VALUES (44, 3, 11, 6, 7, '2025-12-06', NULL, NULL, '2025-11-28 16:58:04', '2025-11-29 15:08:06');
INSERT INTO `sub_progress_cycle` VALUES (45, 3, 11, 7, 7, '2025-12-18', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:02:12');
INSERT INTO `sub_progress_cycle` VALUES (46, 3, 11, 8, 7, '2025-12-20', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:57');
INSERT INTO `sub_progress_cycle` VALUES (47, 3, 11, 9, 7, '2025-12-22', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:40');
INSERT INTO `sub_progress_cycle` VALUES (48, 3, 11, 10, 7, '2025-12-24', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:22');
INSERT INTO `sub_progress_cycle` VALUES (49, 3, 11, 11, 7, '2025-12-27', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:00:17');
INSERT INTO `sub_progress_cycle` VALUES (50, 3, 11, 18, 8, NULL, NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_cycle` VALUES (51, 3, 11, 6, 8, '2025-12-06', NULL, NULL, '2025-11-28 16:58:04', '2025-11-29 15:08:06');
INSERT INTO `sub_progress_cycle` VALUES (52, 3, 11, 7, 8, '2025-12-18', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:02:12');
INSERT INTO `sub_progress_cycle` VALUES (53, 3, 11, 8, 8, '2025-12-20', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:57');
INSERT INTO `sub_progress_cycle` VALUES (54, 3, 11, 9, 8, '2025-12-22', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:40');
INSERT INTO `sub_progress_cycle` VALUES (55, 3, 11, 10, 8, '2025-12-24', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:22');
INSERT INTO `sub_progress_cycle` VALUES (56, 3, 11, 11, 8, '2025-12-27', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:00:17');
INSERT INTO `sub_progress_cycle` VALUES (57, 3, 11, 18, 9, NULL, NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_cycle` VALUES (58, 3, 11, 6, 9, '2025-12-06', NULL, NULL, '2025-11-28 16:58:04', '2025-11-29 15:08:06');
INSERT INTO `sub_progress_cycle` VALUES (59, 3, 11, 7, 9, '2025-12-18', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:02:12');
INSERT INTO `sub_progress_cycle` VALUES (60, 3, 11, 8, 9, '2025-12-20', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:57');
INSERT INTO `sub_progress_cycle` VALUES (61, 3, 11, 9, 9, '2025-12-22', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:40');
INSERT INTO `sub_progress_cycle` VALUES (62, 3, 11, 10, 9, '2025-12-24', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:22');
INSERT INTO `sub_progress_cycle` VALUES (63, 3, 11, 11, 9, '2025-12-27', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:00:17');
INSERT INTO `sub_progress_cycle` VALUES (64, 3, 11, 18, 10, NULL, NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_cycle` VALUES (65, 3, 11, 6, 10, '2025-12-06', NULL, NULL, '2025-11-28 16:58:04', '2025-11-29 15:08:06');
INSERT INTO `sub_progress_cycle` VALUES (66, 3, 11, 7, 10, '2025-12-18', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:02:12');
INSERT INTO `sub_progress_cycle` VALUES (67, 3, 11, 8, 10, '2025-12-20', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:57');
INSERT INTO `sub_progress_cycle` VALUES (68, 3, 11, 9, 10, '2025-12-22', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:40');
INSERT INTO `sub_progress_cycle` VALUES (69, 3, 11, 10, 10, '2025-12-24', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:22');
INSERT INTO `sub_progress_cycle` VALUES (70, 3, 11, 11, 10, '2025-12-27', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:00:17');
INSERT INTO `sub_progress_cycle` VALUES (71, 3, 11, 18, 11, NULL, NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_cycle` VALUES (72, 3, 11, 6, 11, '2025-12-06', NULL, NULL, '2025-11-28 16:58:04', '2025-11-29 15:08:06');
INSERT INTO `sub_progress_cycle` VALUES (73, 3, 11, 7, 11, '2025-12-18', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:02:12');
INSERT INTO `sub_progress_cycle` VALUES (74, 3, 11, 8, 11, '2025-12-20', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:57');
INSERT INTO `sub_progress_cycle` VALUES (75, 3, 11, 9, 11, '2025-12-22', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:40');
INSERT INTO `sub_progress_cycle` VALUES (76, 3, 11, 10, 11, '2025-12-24', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:22');
INSERT INTO `sub_progress_cycle` VALUES (77, 3, 11, 11, 11, '2025-12-27', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:00:17');
INSERT INTO `sub_progress_cycle` VALUES (78, 3, 11, 18, 12, NULL, NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_cycle` VALUES (79, 3, 11, 6, 12, '2025-12-06', NULL, NULL, '2025-11-28 16:58:04', '2025-11-29 15:08:06');
INSERT INTO `sub_progress_cycle` VALUES (80, 3, 11, 7, 12, '2025-12-18', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:02:12');
INSERT INTO `sub_progress_cycle` VALUES (81, 3, 11, 8, 12, '2025-12-20', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:57');
INSERT INTO `sub_progress_cycle` VALUES (82, 3, 11, 9, 12, '2025-12-22', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:40');
INSERT INTO `sub_progress_cycle` VALUES (83, 3, 11, 10, 12, '2025-12-24', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:22');
INSERT INTO `sub_progress_cycle` VALUES (84, 3, 11, 11, 12, '2025-12-27', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:00:17');
INSERT INTO `sub_progress_cycle` VALUES (85, 3, 11, 18, 13, NULL, NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_cycle` VALUES (86, 3, 11, 6, 13, '2025-12-06', NULL, NULL, '2025-11-28 16:58:04', '2025-11-29 15:08:06');
INSERT INTO `sub_progress_cycle` VALUES (87, 3, 11, 7, 13, '2025-12-18', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:02:12');
INSERT INTO `sub_progress_cycle` VALUES (88, 3, 11, 8, 13, '2025-12-20', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:57');
INSERT INTO `sub_progress_cycle` VALUES (89, 3, 11, 9, 13, '2025-12-22', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:40');
INSERT INTO `sub_progress_cycle` VALUES (90, 3, 11, 10, 13, '2025-12-24', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:22');
INSERT INTO `sub_progress_cycle` VALUES (91, 3, 11, 11, 13, '2025-12-27', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:00:17');
INSERT INTO `sub_progress_cycle` VALUES (92, 3, 11, 18, 14, NULL, NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_cycle` VALUES (93, 3, 11, 6, 14, '2025-12-06', NULL, NULL, '2025-11-28 16:58:04', '2025-11-29 15:08:06');
INSERT INTO `sub_progress_cycle` VALUES (94, 3, 11, 7, 14, '2025-12-18', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:02:12');
INSERT INTO `sub_progress_cycle` VALUES (95, 3, 11, 8, 14, '2025-12-20', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:57');
INSERT INTO `sub_progress_cycle` VALUES (96, 3, 11, 9, 14, '2025-12-22', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:40');
INSERT INTO `sub_progress_cycle` VALUES (97, 3, 11, 10, 14, '2025-12-24', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:22');
INSERT INTO `sub_progress_cycle` VALUES (98, 3, 11, 11, 14, '2025-12-27', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:00:17');
INSERT INTO `sub_progress_cycle` VALUES (99, 3, 11, 18, 15, NULL, NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_cycle` VALUES (100, 3, 11, 6, 15, '2025-12-06', NULL, NULL, '2025-11-28 16:58:04', '2025-11-29 15:08:06');
INSERT INTO `sub_progress_cycle` VALUES (101, 3, 11, 7, 15, '2025-12-18', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:02:12');
INSERT INTO `sub_progress_cycle` VALUES (102, 3, 11, 8, 15, '2025-12-20', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:57');
INSERT INTO `sub_progress_cycle` VALUES (103, 3, 11, 9, 15, '2025-12-22', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:40');
INSERT INTO `sub_progress_cycle` VALUES (104, 3, 11, 10, 15, '2025-12-24', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:22');
INSERT INTO `sub_progress_cycle` VALUES (105, 3, 11, 11, 15, '2025-12-27', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:00:17');
INSERT INTO `sub_progress_cycle` VALUES (106, 3, 11, 18, 16, NULL, NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_cycle` VALUES (107, 3, 11, 6, 16, '2025-12-06', NULL, NULL, '2025-11-28 16:58:04', '2025-11-29 15:08:06');
INSERT INTO `sub_progress_cycle` VALUES (108, 3, 11, 7, 16, '2025-12-18', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:02:12');
INSERT INTO `sub_progress_cycle` VALUES (109, 3, 11, 8, 16, '2025-12-20', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:57');
INSERT INTO `sub_progress_cycle` VALUES (110, 3, 11, 9, 16, '2025-12-22', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:40');
INSERT INTO `sub_progress_cycle` VALUES (111, 3, 11, 10, 16, '2025-12-24', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:22');
INSERT INTO `sub_progress_cycle` VALUES (112, 3, 11, 11, 16, '2025-12-27', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:00:17');
INSERT INTO `sub_progress_cycle` VALUES (113, 3, 11, 18, 17, NULL, NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_cycle` VALUES (114, 3, 11, 6, 17, '2025-12-06', NULL, NULL, '2025-11-28 16:58:04', '2025-11-29 15:08:06');
INSERT INTO `sub_progress_cycle` VALUES (115, 3, 11, 7, 17, '2025-12-18', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:02:12');
INSERT INTO `sub_progress_cycle` VALUES (116, 3, 11, 8, 17, '2025-12-20', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:57');
INSERT INTO `sub_progress_cycle` VALUES (117, 3, 11, 9, 17, '2025-12-22', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:40');
INSERT INTO `sub_progress_cycle` VALUES (118, 3, 11, 10, 17, '2025-12-24', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:22');
INSERT INTO `sub_progress_cycle` VALUES (119, 3, 11, 11, 17, '2025-12-27', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:00:17');
INSERT INTO `sub_progress_cycle` VALUES (120, 3, 11, 18, 18, NULL, NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_cycle` VALUES (121, 3, 11, 6, 18, '2025-12-06', NULL, NULL, '2025-11-28 16:58:04', '2025-11-29 15:08:06');
INSERT INTO `sub_progress_cycle` VALUES (122, 3, 11, 7, 18, '2025-12-18', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:02:12');
INSERT INTO `sub_progress_cycle` VALUES (123, 3, 11, 8, 18, '2025-12-20', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:57');
INSERT INTO `sub_progress_cycle` VALUES (124, 3, 11, 9, 18, '2025-12-22', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:40');
INSERT INTO `sub_progress_cycle` VALUES (125, 3, 11, 10, 18, '2025-12-24', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:22');
INSERT INTO `sub_progress_cycle` VALUES (126, 3, 11, 11, 18, '2025-12-27', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:00:17');
INSERT INTO `sub_progress_cycle` VALUES (127, 3, 11, 18, 19, NULL, NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_cycle` VALUES (128, 3, 11, 6, 19, '2025-12-06', NULL, NULL, '2025-11-28 16:58:04', '2025-11-29 15:08:06');
INSERT INTO `sub_progress_cycle` VALUES (129, 3, 11, 7, 19, '2025-12-18', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:02:12');
INSERT INTO `sub_progress_cycle` VALUES (130, 3, 11, 8, 19, '2025-12-20', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:57');
INSERT INTO `sub_progress_cycle` VALUES (131, 3, 11, 9, 19, '2025-12-22', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:40');
INSERT INTO `sub_progress_cycle` VALUES (132, 3, 11, 10, 19, '2025-12-24', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:22');
INSERT INTO `sub_progress_cycle` VALUES (133, 3, 11, 11, 19, '2025-12-27', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:00:17');
INSERT INTO `sub_progress_cycle` VALUES (134, 3, 11, 18, 20, NULL, NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_cycle` VALUES (135, 3, 11, 6, 20, '2025-12-06', NULL, NULL, '2025-11-28 16:58:04', '2025-11-29 15:08:06');
INSERT INTO `sub_progress_cycle` VALUES (136, 3, 11, 7, 20, '2025-12-18', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:02:12');
INSERT INTO `sub_progress_cycle` VALUES (137, 3, 11, 8, 20, '2025-12-20', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:57');
INSERT INTO `sub_progress_cycle` VALUES (138, 3, 11, 9, 20, '2025-12-22', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:40');
INSERT INTO `sub_progress_cycle` VALUES (139, 3, 11, 10, 20, '2025-12-24', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:22');
INSERT INTO `sub_progress_cycle` VALUES (140, 3, 11, 11, 20, '2025-12-27', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:00:17');
INSERT INTO `sub_progress_cycle` VALUES (141, 3, 11, 18, 21, NULL, NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_cycle` VALUES (142, 3, 11, 6, 21, '2025-12-06', NULL, NULL, '2025-11-28 16:58:04', '2025-11-29 15:08:06');
INSERT INTO `sub_progress_cycle` VALUES (143, 3, 11, 7, 21, '2025-12-18', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:02:12');
INSERT INTO `sub_progress_cycle` VALUES (144, 3, 11, 8, 21, '2025-12-20', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:57');
INSERT INTO `sub_progress_cycle` VALUES (145, 3, 11, 9, 21, '2025-12-22', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:40');
INSERT INTO `sub_progress_cycle` VALUES (146, 3, 11, 10, 21, '2025-12-24', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:22');
INSERT INTO `sub_progress_cycle` VALUES (147, 3, 11, 11, 21, '2025-12-27', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:00:17');
INSERT INTO `sub_progress_cycle` VALUES (148, 3, 11, 18, 22, NULL, NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_cycle` VALUES (149, 3, 11, 6, 22, '2025-12-06', NULL, NULL, '2025-11-28 16:58:04', '2025-11-29 15:08:06');
INSERT INTO `sub_progress_cycle` VALUES (150, 3, 11, 7, 22, '2025-12-18', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:02:12');
INSERT INTO `sub_progress_cycle` VALUES (151, 3, 11, 8, 22, '2025-12-20', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:57');
INSERT INTO `sub_progress_cycle` VALUES (152, 3, 11, 9, 22, '2025-12-22', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:40');
INSERT INTO `sub_progress_cycle` VALUES (153, 3, 11, 10, 22, '2025-12-24', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:01:22');
INSERT INTO `sub_progress_cycle` VALUES (154, 3, 11, 11, 22, '2025-12-27', NULL, NULL, '2025-11-28 16:58:04', '2025-11-28 17:00:17');
INSERT INTO `sub_progress_cycle` VALUES (155, 3, 13, 18, 23, '2025-12-04', NULL, NULL, '2025-11-29 14:26:39', '2025-11-29 15:03:06');
INSERT INTO `sub_progress_cycle` VALUES (156, 3, 13, 6, 23, NULL, NULL, NULL, '2025-11-29 14:26:39', '2025-11-29 14:26:39');
INSERT INTO `sub_progress_cycle` VALUES (157, 3, 13, 7, 23, NULL, NULL, NULL, '2025-11-29 14:26:39', '2025-11-29 14:26:39');
INSERT INTO `sub_progress_cycle` VALUES (158, 3, 13, 8, 23, NULL, NULL, NULL, '2025-11-29 14:26:39', '2025-11-29 14:26:39');
INSERT INTO `sub_progress_cycle` VALUES (159, 3, 13, 9, 23, NULL, NULL, NULL, '2025-11-29 14:26:39', '2025-11-29 14:26:39');
INSERT INTO `sub_progress_cycle` VALUES (160, 3, 13, 10, 23, NULL, NULL, NULL, '2025-11-29 14:26:39', '2025-11-29 14:26:39');
INSERT INTO `sub_progress_cycle` VALUES (161, 3, 13, 11, 23, NULL, NULL, NULL, '2025-11-29 14:26:39', '2025-11-29 14:26:39');
INSERT INTO `sub_progress_cycle` VALUES (162, 3, 13, 18, 24, '2025-12-04', NULL, NULL, '2025-11-29 14:26:39', '2025-11-29 15:03:59');
INSERT INTO `sub_progress_cycle` VALUES (163, 3, 13, 6, 24, NULL, NULL, NULL, '2025-11-29 14:26:39', '2025-11-29 14:26:39');
INSERT INTO `sub_progress_cycle` VALUES (164, 3, 13, 7, 24, NULL, NULL, NULL, '2025-11-29 14:26:39', '2025-11-29 14:26:39');
INSERT INTO `sub_progress_cycle` VALUES (165, 3, 13, 8, 24, NULL, NULL, NULL, '2025-11-29 14:26:39', '2025-11-29 14:26:39');
INSERT INTO `sub_progress_cycle` VALUES (166, 3, 13, 9, 24, NULL, NULL, NULL, '2025-11-29 14:26:39', '2025-11-29 14:26:39');
INSERT INTO `sub_progress_cycle` VALUES (167, 3, 13, 10, 24, NULL, NULL, NULL, '2025-11-29 14:26:39', '2025-11-29 14:26:39');
INSERT INTO `sub_progress_cycle` VALUES (168, 3, 13, 11, 24, NULL, NULL, NULL, '2025-11-29 14:26:39', '2025-11-29 14:26:39');

-- ----------------------------
-- Table structure for sub_progress_total
-- ----------------------------
DROP TABLE IF EXISTS `sub_progress_total`;
CREATE TABLE `sub_progress_total`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `company_id` int(11) NULL DEFAULT NULL COMMENT '企业ID',
  `number` int(11) NULL DEFAULT NULL COMMENT '数量',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用来统计进度表首页的延期预警' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_progress_total
-- ----------------------------
INSERT INTO `sub_progress_total` VALUES (1, 3, 6, '2025-11-28 16:58:10', '2025-12-01 16:27:38');

-- ----------------------------
-- Table structure for sub_progress_work
-- ----------------------------
DROP TABLE IF EXISTS `sub_progress_work`;
CREATE TABLE `sub_progress_work`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `company_id` int(11) NULL DEFAULT NULL COMMENT '公司ID',
  `progress_id` int(11) NULL DEFAULT NULL COMMENT '进度表ID',
  `notice_id` int(11) NULL DEFAULT NULL COMMENT '生产订单ID',
  `bom_id` int(11) NULL DEFAULT NULL COMMENT 'bom表的id',
  `child_id` int(11) NULL DEFAULT NULL COMMENT 'bom表工序ID',
  `process_index` int(11) NULL DEFAULT NULL COMMENT '排序',
  `all_work_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '全部工时(H)',
  `load` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '每日负荷',
  `finish` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '累计完成',
  `order_number` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单尾数',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 108 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '工艺BOM表工序下进度表的子表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_progress_work
-- ----------------------------
INSERT INTO `sub_progress_work` VALUES (1, 3, 1, 11, 59, 86, 1, '75.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (2, 3, 2, 11, 60, 77, 1, '20.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (3, 3, 2, 11, 60, 78, 2, '20.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (4, 3, 2, 11, 60, 88, 3, '20.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (5, 3, 2, 11, 60, 89, 4, '20.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (6, 3, 3, 11, 63, 94, 1, '25.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (7, 3, 3, 11, 63, 95, 2, '25.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (8, 3, 3, 11, 63, 92, 3, '25.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (9, 3, 3, 11, 63, 93, 4, '25.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (10, 3, 3, 11, 63, 96, 5, '25.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (11, 3, 3, 11, 63, 97, 6, '75.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (12, 3, 4, 11, 64, 105, 1, '75.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (13, 3, 4, 11, 64, 102, 2, '40.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (14, 3, 4, 11, 64, 106, 3, '25.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (15, 3, 4, 11, 64, 103, 4, '40.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (16, 3, 4, 11, 64, 104, 5, '40.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (17, 3, 5, 11, 65, 111, 1, '300.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (18, 3, 5, 11, 65, 115, 2, '40.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (19, 3, 5, 11, 65, 112, 3, '50.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (20, 3, 5, 11, 65, 113, 4, '50.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (21, 3, 5, 11, 65, 114, 5, '100.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (22, 3, 6, 11, 66, 116, 1, '25.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (23, 3, 7, 11, 67, 120, 1, '40.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (24, 3, 7, 11, 67, 117, 2, '40.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (25, 3, 7, 11, 67, 121, 3, '25.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (26, 3, 7, 11, 67, 118, 4, '25.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (27, 3, 7, 11, 67, 122, 5, '25.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (28, 3, 7, 11, 67, 119, 6, '25.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (29, 3, 7, 11, 67, 123, 7, '25.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (30, 3, 7, 11, 67, 124, 8, '25.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (31, 3, 7, 11, 67, 125, 9, '50.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (32, 3, 7, 11, 67, 126, 10, '75.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (33, 3, 7, 11, 67, 127, 11, '40.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (34, 3, 7, 11, 67, 128, 12, '40.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (35, 3, 7, 11, 67, 129, 13, '40.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (36, 3, 7, 11, 67, 130, 14, '75.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (37, 3, 8, 11, 68, 141, 1, '50.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (38, 3, 8, 11, 68, 138, 2, '40.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (39, 3, 8, 11, 68, 142, 3, '50.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (40, 3, 8, 11, 68, 139, 4, '25.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (41, 3, 8, 11, 68, 140, 5, '40.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (42, 3, 8, 11, 68, 137, 6, '50.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (43, 3, 9, 11, 69, 146, 1, '40.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (44, 3, 9, 11, 69, 143, 2, '50.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (45, 3, 9, 11, 69, 147, 3, '50.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (46, 3, 9, 11, 69, 144, 4, '40.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (47, 3, 9, 11, 69, 148, 5, '50.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (48, 3, 9, 11, 69, 145, 6, '25.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (49, 3, 10, 11, 70, 152, 1, '25.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (50, 3, 10, 11, 70, 149, 2, '25.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (51, 3, 10, 11, 70, 153, 3, '50.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (52, 3, 10, 11, 70, 150, 4, '25.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (53, 3, 10, 11, 70, 151, 5, '25.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (54, 3, 11, 11, 71, 155, 1, '25.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (55, 3, 11, 11, 71, 156, 2, '25.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (56, 3, 11, 11, 71, 157, 3, '25.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (57, 3, 11, 11, 71, 154, 4, '25.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (58, 3, 11, 11, 71, 158, 5, '50.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (59, 3, 12, 11, 72, 162, 1, '100.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (60, 3, 12, 11, 72, 159, 2, '50.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (61, 3, 12, 11, 72, 160, 3, '75.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (62, 3, 13, 11, 73, 168, 1, '50.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (63, 3, 13, 11, 73, 165, 2, '25.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (64, 3, 13, 11, 73, 166, 3, '40.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (65, 3, 13, 11, 73, 163, 4, '25.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (66, 3, 13, 11, 73, 167, 5, '25.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (67, 3, 13, 11, 73, 164, 6, '25.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (68, 3, 14, 11, 74, 173, 1, '50.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (69, 3, 14, 11, 74, 170, 2, '25.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (70, 3, 14, 11, 74, 174, 3, '40.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (71, 3, 14, 11, 74, 171, 4, '25.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (72, 3, 14, 11, 74, 172, 5, '25.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (73, 3, 15, 11, 75, 175, 1, '25.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (74, 3, 15, 11, 75, 176, 2, '50.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (75, 3, 15, 11, 75, 177, 3, '50.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (76, 3, 16, 11, 76, 178, 1, '75.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (77, 3, 16, 11, 76, 179, 2, '50.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (78, 3, 16, 11, 76, 180, 3, '100.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (79, 3, 17, 11, 77, 181, 1, '75.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (80, 3, 18, 11, 78, 182, 1, '75.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (81, 3, 18, 11, 78, 183, 2, '50.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (82, 3, 19, 11, 79, 185, 1, '100.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (83, 3, 20, 11, 80, 186, 1, '600.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (84, 3, 21, 11, 81, 187, 1, '300.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (85, 3, 22, 11, 82, 188, 1, '27000.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (86, 3, 22, 11, 82, 189, 2, '75.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (87, 3, 22, 11, 82, 190, 3, '75.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (88, 3, 22, 11, 82, 191, 4, '63000.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (89, 3, 22, 11, 82, 192, 5, '100.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (90, 3, 22, 11, 82, 193, 6, '50.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (91, 3, 22, 11, 82, 194, 7, '50.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (92, 3, 22, 11, 82, 195, 8, '50.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (93, 3, 22, 11, 82, 196, 9, '75.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (94, 3, 22, 11, 82, 197, 10, '3000.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (95, 3, 22, 11, 82, 198, 11, '1500.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (96, 3, 22, 11, 82, 199, 12, '3000.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (97, 3, 22, 11, 82, 200, 13, '20000.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (98, 3, 22, 11, 82, 201, 14, '700.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (99, 3, 22, 11, 82, 202, 15, '700.0', NULL, NULL, '18000', '2025-11-28 16:58:04', '2025-11-28 16:58:04');
INSERT INTO `sub_progress_work` VALUES (100, 3, 23, 13, 85, 208, NULL, '5.6', NULL, NULL, '5000', '2025-11-29 14:26:39', '2025-11-29 14:26:39');
INSERT INTO `sub_progress_work` VALUES (101, 3, 23, 13, 85, 211, NULL, '5.6', NULL, NULL, '5000', '2025-11-29 14:26:39', '2025-11-29 14:26:39');
INSERT INTO `sub_progress_work` VALUES (102, 3, 23, 13, 85, 210, NULL, '5.6', NULL, NULL, '5000', '2025-11-29 14:26:39', '2025-11-29 14:26:39');
INSERT INTO `sub_progress_work` VALUES (103, 3, 23, 13, 85, 209, NULL, '55.6', NULL, NULL, '5000', '2025-11-29 14:26:39', '2025-11-29 14:26:39');
INSERT INTO `sub_progress_work` VALUES (104, 3, 24, 13, 83, 204, 1, '55.6', NULL, NULL, '5000', '2025-11-29 14:26:39', '2025-11-29 14:26:39');
INSERT INTO `sub_progress_work` VALUES (105, 3, 24, 13, 83, 205, 2, '5.6', NULL, NULL, '5000', '2025-11-29 14:26:39', '2025-11-29 14:26:39');
INSERT INTO `sub_progress_work` VALUES (106, 3, 24, 13, 83, 206, 3, '5.6', NULL, NULL, '5000', '2025-11-29 14:26:39', '2025-11-29 14:26:39');
INSERT INTO `sub_progress_work` VALUES (107, 3, 24, 13, 83, 203, 4, '5.6', NULL, NULL, '5000', '2025-11-29 14:26:39', '2025-11-29 14:26:39');

-- ----------------------------
-- Table structure for sub_rate_wage
-- ----------------------------
DROP TABLE IF EXISTS `sub_rate_wage`;
CREATE TABLE `sub_rate_wage`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `company_id` int(11) NULL DEFAULT NULL COMMENT '公司ID',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '员工ID',
  `bom_child_id` int(11) NULL DEFAULT NULL COMMENT '工艺bom子表ID',
  `product_id` int(11) NULL DEFAULT NULL COMMENT '产品ID',
  `part_id` int(11) NULL DEFAULT NULL COMMENT '部件ID',
  `process_id` int(11) NULL DEFAULT NULL COMMENT '工艺ID',
  `notice_id` int(11) NULL DEFAULT NULL COMMENT '生产订单ID',
  `progress_id` int(11) NULL DEFAULT NULL COMMENT '进度表ID',
  `number` int(20) NULL DEFAULT NULL COMMENT '完成数量',
  `status` int(2) NULL DEFAULT 0 COMMENT '状态，0未确认，1已确认',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '员工计件工资表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_rate_wage
-- ----------------------------

-- ----------------------------
-- Table structure for sub_sale_cancel
-- ----------------------------
DROP TABLE IF EXISTS `sub_sale_cancel`;
CREATE TABLE `sub_sale_cancel`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `company_id` int(11) NULL DEFAULT NULL COMMENT '企业id',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '发布的用户id',
  `sale_id` int(11) NULL DEFAULT NULL COMMENT '销售ID',
  `notice_id` int(11) NULL DEFAULT NULL COMMENT '生产ID',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '销售订单取消订单储存的数据' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_sale_cancel
-- ----------------------------

-- ----------------------------
-- Table structure for sub_sales_order
-- ----------------------------
DROP TABLE IF EXISTS `sub_sales_order`;
CREATE TABLE `sub_sales_order`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键ID',
  `company_id` int(11) NULL DEFAULT NULL COMMENT '企业id',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '发布的用户id',
  `rece_time` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '接单日期',
  `customer_id` int(11) NULL DEFAULT NULL COMMENT '客户id',
  `customer_order` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '客户订单号',
  `product_id` int(11) NULL DEFAULT NULL COMMENT '产品编码id',
  `product_req` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '产品要求',
  `order_number` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单数量',
  `actual_number` int(11) NULL DEFAULT NULL COMMENT '实际数量，给采购单使用的',
  `unit` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '单位',
  `delivery_time` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '交货日期',
  `goods_time` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '送货日期',
  `goods_address` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '送货地点',
  `is_quote` int(1) NULL DEFAULT 1 COMMENT '是否已创建报价单：1-未创建，0-已创建',
  `is_sale` int(1) NULL DEFAULT 1 COMMENT '是否已创建生产订单：1-未创建，0-已创建',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '销售订单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_sales_order
-- ----------------------------
INSERT INTO `sub_sales_order` VALUES (5, 3, 6, '2025-11-28', 4, 'CGO12511001', 20, '1.字码2510001-2510800；2.车架补土后烤漆', '18000', 18000, '52', '2025-12-30', '', '公司材料仓', 0, 0, 1, '2025-11-28 15:40:58', '2025-11-28 15:54:19');
INSERT INTO `sub_sales_order` VALUES (6, 3, 6, '2025-11-28', 5, 'CG022511005', 20, '1.字码2510001-2510800；2.车架补土后烤漆', '7500', 7500, '52', '2025-12-28', '', '高埗镇合鑫喷漆厂', 0, 0, 1, '2025-11-28 15:43:36', '2025-11-28 15:54:39');
INSERT INTO `sub_sales_order` VALUES (7, 3, 15, '2025-11-29', 5, 'CR022511009', 21, '1.产品表面研磨清洗；2.产品杜绝补土；3.按订单要求打字码', '5000', 5000, '52', '2026-01-15', '', '高埗镇合鑫喷漆厂', 0, 0, 1, '2025-11-29 14:13:16', '2025-11-29 14:14:29');

-- ----------------------------
-- Table structure for sub_supplier_info
-- ----------------------------
DROP TABLE IF EXISTS `sub_supplier_info`;
CREATE TABLE `sub_supplier_info`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键ID',
  `user_id` int(11) NOT NULL COMMENT '发布的用户id',
  `company_id` int(11) NOT NULL COMMENT '所属企业id',
  `supplier_code` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '供应商编码',
  `supplier_abbreviation` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '供应商简称',
  `contact_person` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系人',
  `contact_information` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系方式',
  `supplier_full_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商全名',
  `supplier_address` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商地址',
  `supplier_category` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商类别',
  `supply_method` int(5) NULL DEFAULT NULL COMMENT '供货方式',
  `transaction_method` int(5) NULL DEFAULT NULL COMMENT '交易方式',
  `transaction_currency` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '交易币别',
  `other_transaction_terms` int(11) NULL DEFAULT NULL COMMENT '其它交易条件',
  `other_text` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '其他结算周期',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '供应商信息信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_supplier_info
-- ----------------------------
INSERT INTO `sub_supplier_info` VALUES (6, 15, 3, 'GA001', '晶鑫昌', '刘总', '13012345678', '深圳市晶鑫昌科技有限公司', '深圳市宝安区沙井镇', '[38,41]', 35, 27, 'RMB', 31, '', 1, '2025-11-29 14:54:55', '2025-11-29 14:54:55');
INSERT INTO `sub_supplier_info` VALUES (7, 15, 3, 'GA002', '城至', '许小姐', '18612345678', '东莞市城至精密五金有限公司', '东莞市万江区简沙洲工业区', '[38,41,39]', 37, 28, 'RMB', 32, '', 1, '2025-11-29 15:01:01', '2025-11-29 15:01:01');

-- ----------------------------
-- Table structure for sub_warehouse_apply
-- ----------------------------
DROP TABLE IF EXISTS `sub_warehouse_apply`;
CREATE TABLE `sub_warehouse_apply`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '发布的用户id',
  `company_id` int(11) NULL DEFAULT NULL COMMENT '所属企业id',
  `print_id` int(30) NULL DEFAULT NULL COMMENT '打印的id',
  `procure_id` int(30) NULL DEFAULT NULL COMMENT '采购单号ID',
  `sale_id` int(11) NULL DEFAULT NULL COMMENT '销售订单ID',
  `ware_id` int(11) NULL DEFAULT NULL COMMENT '仓库类型ID 1材料2部件3成品',
  `house_id` int(11) NULL DEFAULT NULL COMMENT '仓库ID',
  `operate` int(1) NULL DEFAULT NULL COMMENT '1:入库 2:出库',
  `type` int(2) NULL DEFAULT NULL COMMENT '出入库类型(常量)',
  `house_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '仓库名称',
  `plan_id` int(11) NULL DEFAULT NULL COMMENT '供应商id or 制程id',
  `plan` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商 or 制程',
  `notice_id` int(11) NULL DEFAULT NULL COMMENT '生产通知单ID',
  `item_id` int(11) NULL DEFAULT NULL COMMENT '物料ID',
  `code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '物料编码',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '物料名称',
  `model_spec` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '规格型号',
  `other_features` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '其他特性',
  `quantity` int(20) NULL DEFAULT NULL COMMENT '数量/使用数量',
  `pay_quantity` int(20) NULL DEFAULT NULL COMMENT '支付数量',
  `buy_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '采购/销售单价',
  `price` decimal(10, 2) NULL DEFAULT NULL COMMENT '内部单价',
  `total_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '总价',
  `inv_unit` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '库存单位',
  `unit` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '采购/销售单位',
  `is_buying` int(1) NULL DEFAULT 1 COMMENT '是否已生成出入库单：1未生成，0已生成',
  `order_id` int(11) NULL DEFAULT NULL COMMENT '出入库单ID',
  `apply_id` int(11) NULL DEFAULT NULL COMMENT '申请人ID',
  `apply_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '申请人名称',
  `apply_time` timestamp NULL DEFAULT NULL COMMENT '申请时间',
  `step` int(2) NULL DEFAULT 0 COMMENT '审核当前在第几步，默认0，每审核一步加1',
  `status` int(1) NULL DEFAULT 0 COMMENT '状态（0审批中/1通过/2拒绝/3已反审）',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '1：未删除；0：已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '出库入库申请表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_warehouse_apply
-- ----------------------------
INSERT INTO `sub_warehouse_apply` VALUES (11, 15, 3, NULL, 2, NULL, 1, 14, 1, 4, '管料仓-铝管', 6, '晶鑫昌', 11, 21, 'H0302-0013', '左勾爪', '', NULL, 5000, NULL, 2.80, 3.00, 14000.00, NULL, NULL, 0, 6, 15, '粟云', '2025-11-29 16:50:32', 1, 1, 1, '2025-11-29 16:50:32', '2025-11-29 16:52:48');
INSERT INTO `sub_warehouse_apply` VALUES (12, 15, 3, NULL, NULL, NULL, 3, 16, 1, 10, '成品-铝车架', NULL, '', 11, 20, 'WA-A00001', '0611铝车架', '城市代步Q1', '折叠型', 1000, NULL, 600.00, 540.00, 600000.00, NULL, NULL, 0, 7, 15, '粟云', '2025-11-29 17:01:17', 1, 1, 1, '2025-11-29 17:01:17', '2025-11-29 17:04:53');
INSERT INTO `sub_warehouse_apply` VALUES (13, 6, 3, NULL, NULL, 5, 3, 16, 2, 14, '成品-铝车架', 4, '旭欧', 11, 20, 'WA-A00001', '0611铝车架', '城市代步Q1', '折叠型', 800, NULL, 580.00, 540.00, 464000.00, '', '52', 1, 1, 6, '徐庆华', '2025-12-01 10:29:22', 1, 1, 1, '2025-12-01 10:29:22', '2025-12-01 10:29:46');
INSERT INTO `sub_warehouse_apply` VALUES (14, 15, 3, NULL, 3, NULL, 1, 14, 1, 4, '管料仓-铝管', 6, '晶鑫昌', NULL, 10, 'M0103-0234', '主梁管', '', NULL, 18000, 700, 2.80, 3.30, 50400.00, '51', '54', 0, 8, 15, '粟云', '2025-12-01 16:05:34', 1, 1, 1, '2025-12-01 16:05:34', '2025-12-01 16:06:12');
INSERT INTO `sub_warehouse_apply` VALUES (15, 15, 3, NULL, 2, NULL, 1, 14, 1, 4, '管料仓-铝管', 6, '晶鑫昌', 11, 21, 'H0302-0013', '左勾爪', '', NULL, 2000, 2000, 2.80, 3.00, 5600.00, '51', '51', 1, 1, 15, '粟云', '2025-12-01 16:23:05', 1, 1, 1, '2025-12-01 16:23:05', '2025-12-01 16:23:11');

-- ----------------------------
-- Table structure for sub_warehouse_content
-- ----------------------------
DROP TABLE IF EXISTS `sub_warehouse_content`;
CREATE TABLE `sub_warehouse_content`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `user_id` int(11) NOT NULL COMMENT '发布的用户id',
  `company_id` int(11) NOT NULL COMMENT '所属企业id',
  `ware_id` int(11) NULL DEFAULT NULL COMMENT '仓库类型ID',
  `house_id` int(11) NULL DEFAULT NULL COMMENT '仓库ID',
  `item_id` int(11) NULL DEFAULT NULL COMMENT '物料ID',
  `code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '物料编码',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '物料名称',
  `model_spec` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '规格型号',
  `other_features` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '其他特性',
  `buy_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '采购/销售单价',
  `price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '内部单价',
  `quantity` int(20) NULL DEFAULT 0 COMMENT '最新库存数量',
  `inv_unit` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '库存单位',
  `unit` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '采购/销售单位',
  `last_in_time` timestamp NULL DEFAULT NULL COMMENT '最后入库时间',
  `last_out_time` timestamp NULL DEFAULT NULL COMMENT '最后出库时间',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '1：未删除；0：已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '仓库列表数据表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_warehouse_content
-- ----------------------------
INSERT INTO `sub_warehouse_content` VALUES (7, 15, 3, 1, 14, 21, 'H0302-0013', '左勾爪', '', NULL, 2.80, 3.00, 7000, '51', '51', '2025-11-29 16:50:52', NULL, 1, '2025-11-29 16:50:52', '2025-12-01 16:23:10');
INSERT INTO `sub_warehouse_content` VALUES (8, 15, 3, 3, 16, 20, 'WA-A00001', '0611铝车架', '城市代步Q1', '折叠型', 580.00, 540.00, 200, NULL, '52', '2025-11-29 17:01:51', NULL, 1, '2025-11-29 17:01:51', '2025-12-01 10:29:46');
INSERT INTO `sub_warehouse_content` VALUES (9, 15, 3, 1, 14, 10, 'M0103-0234', '主梁管', '', NULL, 2.80, 3.30, 18000, '54', '54', '2025-12-01 16:05:38', NULL, 1, '2025-12-01 16:05:38', '2025-12-01 16:05:38');

-- ----------------------------
-- Table structure for sub_warehouse_cycle
-- ----------------------------
DROP TABLE IF EXISTS `sub_warehouse_cycle`;
CREATE TABLE `sub_warehouse_cycle`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键ID',
  `company_id` int(11) NOT NULL COMMENT '企业id，关联企业信息表',
  `user_id` int(11) NOT NULL COMMENT '发布的用户id，关联用户表',
  `ware_id` int(11) NULL DEFAULT NULL COMMENT '仓库类型id',
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '仓库名称',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '仓库名列表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_warehouse_cycle
-- ----------------------------
INSERT INTO `sub_warehouse_cycle` VALUES (14, 3, 15, 1, '管料仓-铝管', 1, '2025-11-29 11:35:54', '2025-11-29 11:35:54');
INSERT INTO `sub_warehouse_cycle` VALUES (15, 3, 15, 1, '配件仓-铝合金', 1, '2025-11-29 11:36:33', '2025-11-29 11:36:33');
INSERT INTO `sub_warehouse_cycle` VALUES (16, 3, 15, 3, '成品-铝车架', 1, '2025-11-29 11:37:18', '2025-11-29 11:37:18');
INSERT INTO `sub_warehouse_cycle` VALUES (17, 3, 15, 3, '成品-铁架', 1, '2025-11-29 11:37:40', '2025-11-29 11:37:40');
INSERT INTO `sub_warehouse_cycle` VALUES (18, 1, 1, 1, '管料仓-钢管', 1, '2025-12-02 10:52:03', '2025-12-02 10:52:13');

-- ----------------------------
-- Table structure for sub_warehouse_order
-- ----------------------------
DROP TABLE IF EXISTS `sub_warehouse_order`;
CREATE TABLE `sub_warehouse_order`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `company_id` int(11) NULL DEFAULT NULL COMMENT '企业ID',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '发布的用户id',
  `operate` int(1) NULL DEFAULT NULL COMMENT '1:入库 2:出库',
  `ware_id` int(11) NULL DEFAULT NULL COMMENT '仓库类型ID 1材料2部件3成品',
  `house_id` int(11) NULL DEFAULT NULL COMMENT '仓库ID',
  `no` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单编号',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '仓库出入库单' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_warehouse_order
-- ----------------------------
INSERT INTO `sub_warehouse_order` VALUES (6, 3, 15, 1, 1, 14, 'MR032511001', 1, '2025-11-29 16:52:48', '2025-11-29 16:53:11');
INSERT INTO `sub_warehouse_order` VALUES (7, 3, 15, 1, 3, 16, 'PR032511001', 1, '2025-11-29 17:04:53', '2025-11-29 17:04:57');
INSERT INTO `sub_warehouse_order` VALUES (8, 3, 15, 1, 1, 14, NULL, 1, '2025-12-01 16:06:12', '2025-12-01 16:06:12');

-- ----------------------------
-- Table structure for sub_warehouse_type
-- ----------------------------
DROP TABLE IF EXISTS `sub_warehouse_type`;
CREATE TABLE `sub_warehouse_type`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `type` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '常量类型',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '仓库类型名称',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '系统变量表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_warehouse_type
-- ----------------------------
INSERT INTO `sub_warehouse_type` VALUES (1, 'house', '材料仓', '2025-09-09 10:08:29', '2025-09-16 20:36:50');
INSERT INTO `sub_warehouse_type` VALUES (2, 'house', '部件仓', '2025-09-09 10:08:29', '2025-09-16 20:36:50');
INSERT INTO `sub_warehouse_type` VALUES (3, 'house', '成品仓', '2025-09-09 10:08:29', '2025-09-16 20:36:51');
INSERT INTO `sub_warehouse_type` VALUES (4, 'materialIn', '采购入库', '2025-09-16 20:37:46', '2025-09-16 20:37:46');
INSERT INTO `sub_warehouse_type` VALUES (5, 'materialIn', '期初入库', '2025-09-16 20:38:04', '2025-09-16 20:38:04');
INSERT INTO `sub_warehouse_type` VALUES (6, 'materialIn', '盘盈入库', '2025-09-16 20:38:12', '2025-11-24 15:50:02');
INSERT INTO `sub_warehouse_type` VALUES (7, 'materialOut', '生产领料', '2025-09-16 20:38:50', '2025-09-16 20:38:50');
INSERT INTO `sub_warehouse_type` VALUES (8, 'materialOut', '委外领料', '2025-09-16 20:39:00', '2025-09-16 20:39:00');
INSERT INTO `sub_warehouse_type` VALUES (9, 'materialOut', '盘亏出库', '2025-09-16 20:39:32', '2025-09-16 20:39:32');
INSERT INTO `sub_warehouse_type` VALUES (10, 'productIn', '生产入库', '2025-09-16 20:39:56', '2025-09-16 20:39:56');
INSERT INTO `sub_warehouse_type` VALUES (11, 'productIn', '期初入库', '2025-09-16 20:40:09', '2025-09-16 20:40:09');
INSERT INTO `sub_warehouse_type` VALUES (12, 'productIn', '盘盈入库', '2025-09-16 20:40:17', '2025-11-24 15:50:04');
INSERT INTO `sub_warehouse_type` VALUES (13, 'productIn', '退货入库', '2025-09-16 20:40:35', '2025-09-16 20:41:16');
INSERT INTO `sub_warehouse_type` VALUES (14, 'productOut', '成品出货', '2025-09-16 20:40:43', '2025-09-21 13:53:53');
INSERT INTO `sub_warehouse_type` VALUES (15, 'productOut', '报废出库', '2025-09-16 20:40:50', '2025-09-16 20:41:26');
INSERT INTO `sub_warehouse_type` VALUES (16, 'productOut', '盘亏出库', '2025-09-16 20:41:29', '2025-09-16 20:41:36');

SET FOREIGN_KEY_CHECKS = 1;
