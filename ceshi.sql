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

 Date: 07/11/2025 00:23:30
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
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ad_user
-- ----------------------------
INSERT INTO `ad_user` VALUES (1, 1, 'admin1', '$2b$10$qJOWecY5nOd6ICarLgePce3XPyVtXXrp1dkbB9ZQvtydVrKLz8uGG', '我是名字', NULL, NULL, 1, 0, 1, 1, '2025-07-07 13:56:55', '2025-07-21 17:26:05');
INSERT INTO `ad_user` VALUES (2, 2, 'admin99', '$2b$10$Ukc2Byd6TFsl0u2p68J0leC7tVgwp4LDWr7s6YV0EWpc6xR3dZyMm', NULL, NULL, NULL, 1, 0, 1, 1, '2025-07-07 14:00:05', '2025-07-08 14:21:48');
INSERT INTO `ad_user` VALUES (3, 1, '2121', '$2b$10$EpPaXdgc4ugWWT1Qi.DFSeRoz9XyBa3N7mKkNGuXEBvmy.pe8HEWq', NULL, NULL, NULL, 1, 0, 1, 1, '2025-07-08 10:35:09', '2025-07-08 14:21:49');
INSERT INTO `ad_user` VALUES (4, 1, '121', '$2b$10$qJOWecY5nOd6ICarLgePce3XPyVtXXrp1dkbB9ZQvtydVrKLz8uGG', '2132', NULL, '[[\"基础资料\",\"ProductCode\"],[\"基础资料\",\"PartCode\"],[\"基础资料\",\"MaterialCode\"],[\"基础资料\",\"ProcessCode\"],[\"基础资料\",\"EquipmentCode\"],[\"基础资料\",\"EmployeeInfo\"],[\"订单管理\",\"CustomerInfo\"],[\"订单管理\",\"ProductQuote\"],[\"订单管理\",\"SalesOrder\"],[\"仓库管理\"],[\"仓库管理\",\"ProductHouse\"],[\"仓库管理\",\"MaterialHouse\"],[\"仓库管理\",\"WarehouseRate\"],[\"采购管理\"],[\"委外管理\"],[\"采购管理\",\"PurchaseOrder\"],[\"采购管理\",\"MaterialQuote\"],[\"采购管理\",\"SupplierInfo\"],[\"委外管理\",\"OutsourcingQuote\"],[\"委外管理\",\"OutsourcingOrder\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:add\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:print\"]]', 2, 1, 1, 1, '2025-07-08 14:10:45', '2025-09-23 16:45:29');
INSERT INTO `ad_user` VALUES (5, 1, 'admin2', '$2b$10$qJOWecY5nOd6ICarLgePce3XPyVtXXrp1dkbB9ZQvtydVrKLz8uGG', '哈哈', NULL, '[[\"系统管理\"],[\"系统管理\",\"OrganizeManagement\"],[\"系统管理\",\"ProcessCycle\"],[\"系统管理\",\"ProcessCycle\",\"ProcessCycle:edit\"],[\"系统管理\",\"WarehouseType\"],[\"基础资料\"],[\"基础资料\",\"MaterialCode\"],[\"基础资料\",\"PartCode\"],[\"基础资料\",\"ProductCode\"],[\"基础资料\",\"ProductCode\",\"ProductCode:add\"],[\"基础资料\",\"ProductCode\",\"ProductCode:edit\"],[\"基础资料\",\"PartCode\",\"PartCode:edit\"],[\"基础资料\",\"PartCode\",\"PartCode:delete\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:edit\"],[\"基础资料\",\"ProcessCode\"],[\"基础资料\",\"EquipmentCode\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:edit\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:add\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:delete\"],[\"基础资料\",\"EmployeeInfo\",\"EmployeeInfo:delete\"],[\"基础资料\",\"EmployeeInfo\",\"EmployeeInfo:edit\"],[\"基础资料\",\"EmployeeInfo\"],[\"订单管理\"],[\"订单管理\",\"CustomerInfo\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:add\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:edit\"],[\"订单管理\",\"SalesOrder\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:edit\"],[\"订单管理\",\"ProductQuote\"],[\"订单管理\",\"ProductQuote\",\"ProductQuote:add\"],[\"订单管理\",\"ProductNotice\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:edit\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:add\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:date\"],[\"产品信息\"],[\"产品信息\",\"MaterialBOM\"],[\"产品信息\",\"MaterialBOM\",\"MaterialBOM:add\"],[\"产品信息\",\"MaterialBOM\",\"MaterialBOM:edit\"],[\"产品信息\",\"MaterialBOM\",\"MaterialBOM:archive\"],[\"产品信息\",\"MaterialBOM\",\"MaterialBOM:newPage\"],[\"产品信息\",\"MaterialBOMArchive\"],[\"产品信息\",\"ProcessBOM\"],[\"产品信息\",\"ProcessBOM\",\"ProcessBOM:archive\"],[\"产品信息\",\"ProcessBOM\",\"ProcessBOM:newPage\"],[\"产品信息\",\"ProcessBOMArchive\"],[\"委外管理\"],[\"委外管理\",\"OutsourcingOrder\"],[\"委外管理\",\"OutsourcingQuote\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:add\"],[\"仓库管理\"],[\"仓库管理\",\"ProductHouse\"],[\"仓库管理\",\"MaterialHouse\"],[\"仓库管理\",\"WarehouseRate\"],[\"采购管理\"],[\"采购管理\",\"SupplierInfo\"],[\"采购管理\",\"MaterialQuote\"],[\"采购管理\",\"PurchaseOrder\"],[\"首页\"],[\"首页\",\"Home\"]]', 2, 1, 1, 1, '2025-07-08 14:20:13', '2025-10-14 14:41:54');
INSERT INTO `ad_user` VALUES (6, 3, 'xuqinghua', '$2b$10$MUd.2TTjcfV8u2o0DRY.5OPdroD0SgSZaLr/xKnpnXXB.VkcIz27C', '徐庆华', NULL, NULL, 1, 0, 1, 1, '2025-10-16 00:03:16', '2025-10-24 00:00:39');
INSERT INTO `ad_user` VALUES (7, 3, 'xufurong', '$2b$10$6nBULA3lrE67GJgCSHHd8Of9H24WkaXNSGRPpvadq7ZTOBSuqCoWG', '徐芙蓉', NULL, '[[\"基础资料\"],[\"基础资料\",\"ProductCode\"],[\"基础资料\",\"ProductCode\",\"ProductCode:add\"],[\"基础资料\",\"ProductCode\",\"ProductCode:edit\"],[\"基础资料\",\"PartCode\"],[\"基础资料\",\"PartCode\",\"PartCode:add\"],[\"基础资料\",\"PartCode\",\"PartCode:edit\"],[\"基础资料\",\"MaterialCode\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:add\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:edit\"],[\"订单管理\"],[\"订单管理\",\"CustomerInfo\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:add\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:edit\"]]', 2, 6, 0, 0, '2025-10-16 14:45:16', '2025-10-16 14:50:42');
INSERT INTO `ad_user` VALUES (8, 1, '1231', '$2b$10$SNysIqFfTVzbYdYilDmMwOt0zF0O5rkfXbZETcW/4.4Gc.8dIN.uK', '2121', NULL, '[[\"产品信息\"],[\"产品信息\",\"ProcessBOMArchive\"],[\"产品信息\",\"ProcessBOM\"],[\"产品信息\",\"MaterialBOMArchive\"],[\"产品信息\",\"MaterialBOM\"]]', 2, 1, 1, 1, '2025-10-16 14:48:37', '2025-10-16 14:48:45');
INSERT INTO `ad_user` VALUES (9, 1, '312121', '$2b$10$d5SvhAYPngTVFoyT0RZzYOrgX.9QzeCxcddQ2wUMnsE6Kl14rRdHW', '21213131', NULL, '[[\"采购管理\"],[\"采购管理\",\"MaterialQuote\"],[\"采购管理\",\"PurchaseOrder\"]]', 2, 1, 0, 1, '2025-10-16 14:48:59', '2025-10-21 12:45:08');
INSERT INTO `ad_user` VALUES (10, 3, 'liang', '$2b$10$zkLfaAwf0gbLrsGcXv.fjebNp4OllOlRfQkpsoP3X8eb1ci6H3HDW', '梁伟锋', NULL, '[[\"系统管理\"],[\"基础资料\"],[\"基础资料\",\"PartCode\"],[\"基础资料\",\"MaterialCode\"],[\"系统管理\",\"OrganizeManagement\"]]', 2, 6, 1, 0, '2025-10-16 14:49:57', '2025-10-16 14:50:40');
INSERT INTO `ad_user` VALUES (11, 3, 'lupeisen', '$2b$10$AfLUeYHX4zV7k9IQRtFXr.mtSMVEfsEopPbPHWPFrpBn3ta4j4uVy', 'lupeisen', NULL, '[[\"系统管理\"],[\"系统管理\",\"OrganizeManagement\"],[\"系统管理\",\"ProcessCycle\"]]', 2, 6, 0, 0, '2025-10-16 14:50:25', '2025-10-16 14:50:38');
INSERT INTO `ad_user` VALUES (12, 3, 'xuchudong', '$2b$10$bDucRLeOiNHFFXRtbW10lutWWBcXItwYf3jSzomDePYbjmBbWDXD6', '徐楚东', NULL, '[[\"基础资料\",\"ProductCode\",\"ProductCode:add\"],[\"基础资料\",\"ProductCode\",\"ProductCode:edit\"],[\"系统管理\",\"ProcessCycle\",\"ProcessCycle:add\"],[\"系统管理\",\"ProcessCycle\",\"ProcessCycle:edit\"],[\"系统管理\",\"WarehouseType\",\"Warehouse:add\"],[\"系统管理\",\"WarehouseType\",\"Warehouse:edit\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:add\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:edit\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:delete\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:add\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:edit\"],[\"订单管理\",\"ProductQuote\",\"ProductQuote:add\"],[\"订单管理\",\"ProductQuote\",\"ProductQuote:edit\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:add\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:edit\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:date\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:finish\"],[\"订单管理\",\"FinishNotice\"],[\"委外管理\",\"OutsourcingQuote\",\"OutsourcingQuote:add\"],[\"委外管理\",\"OutsourcingQuote\",\"OutsourcingQuote:edit\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:add\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:edit\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:set\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:print\"],[\"生产管理\",\"ProductionProgress\"],[\"生产管理\",\"WorkOrder\",\"WorkOrder:print\"],[\"仓库管理\",\"WarehouseRate\",\"WarehouseRate:edit\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:addIn\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:addOut\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:set\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:print\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:addIn\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:addOut\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:set\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:print\"],[\"财务管理\",\"EmployeePieceRate\"],[\"财务管理\",\"AccountsReceivable\"],[\"财务管理\",\"AccountsPayable\"],[\"财务管理\",\"AccountsOutsourcing\"],[\"系统管理\",\"OrganizeManagement\"],[\"基础资料\",\"PartCode\",\"PartCode:add\"],[\"基础资料\",\"PartCode\",\"PartCode:edit\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:add\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:edit\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:add\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:edit\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:add\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:edit\"],[\"基础资料\",\"EmployeeInfo\",\"EmployeeInfo:add\"],[\"基础资料\",\"EmployeeInfo\",\"EmployeeInfo:edit\"],[\"采购管理\",\"SupplierInfo\",\"SupplierInfo:add\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:add\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:edit\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:archive\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:newPage\"],[\"产品工程\",\"MaterialBOMArchive\",\"MaterialBOM:cope\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:add\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:edit\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:archive\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:newPage\"],[\"产品工程\",\"ProcessBOMArchive\",\"ProcessBOM:cope\"],[\"系统管理\",\"UserManagement\",\"user:add\"],[\"系统管理\",\"UserManagement\",\"user:edit\"],[\"系统管理\",\"UserManagement\",\"user:delete\"],[\"基础资料\",\"ProductCode\",\"ProductCode:delete\"],[\"基础资料\",\"PartCode\",\"PartCode:delete\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:delete\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:delete\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:delete\"],[\"基础资料\",\"EmployeeInfo\",\"EmployeeInfo:delete\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:delete\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:delete\"],[\"采购管理\",\"SupplierInfo\",\"SupplierInfo:edit\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:add\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:archive\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:newPage\"],[\"采购管理\",\"MaterialQuoteArchive\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:add\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:edit\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:set\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:print\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:edit\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:edit\"]]', 2, 6, 1, 1, '2025-10-16 14:55:08', '2025-11-03 11:30:01');
INSERT INTO `ad_user` VALUES (15, 3, 'suyun', '$2b$10$3giSn6u0TSPgXQTMQxOhjeBlyIByKkV9KTXVtQFFFw.gyQN9y/xyC', '粟云', NULL, '[[\"系统管理\",\"ProcessCycle\",\"ProcessCycle:add\"],[\"系统管理\",\"ProcessCycle\",\"ProcessCycle:edit\"],[\"系统管理\",\"WarehouseType\",\"Warehouse:add\"],[\"系统管理\",\"WarehouseType\",\"Warehouse:edit\"],[\"基础资料\",\"ProductCode\",\"ProductCode:add\"],[\"基础资料\",\"ProductCode\",\"ProductCode:edit\"],[\"基础资料\",\"ProductCode\",\"ProductCode:delete\"],[\"基础资料\",\"PartCode\",\"PartCode:add\"],[\"基础资料\",\"PartCode\",\"PartCode:edit\"],[\"基础资料\",\"PartCode\",\"PartCode:delete\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:add\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:edit\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:delete\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:add\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:edit\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:delete\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:add\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:edit\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:delete\"],[\"基础资料\",\"EmployeeInfo\",\"EmployeeInfo:add\"],[\"基础资料\",\"EmployeeInfo\",\"EmployeeInfo:edit\"],[\"基础资料\",\"EmployeeInfo\",\"EmployeeInfo:delete\"],[\"系统管理\",\"UserManagement\",\"user:add\"],[\"系统管理\",\"UserManagement\",\"user:edit\"],[\"系统管理\",\"UserManagement\",\"user:delete\"],[\"系统管理\",\"OrganizeManagement\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:add\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:edit\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:delete\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:add\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:edit\"],[\"订单管理\",\"ProductQuote\",\"ProductQuote:add\"],[\"订单管理\",\"ProductQuote\",\"ProductQuote:edit\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:add\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:edit\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:date\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:finish\"],[\"订单管理\",\"FinishNotice\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:add\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:edit\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:delete\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:archive\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:newPage\"],[\"产品工程\",\"MaterialBOMArchive\",\"MaterialBOM:cope\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:add\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:edit\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:delete\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:archive\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:newPage\"],[\"产品工程\",\"ProcessBOMArchive\",\"ProcessBOM:cope\"],[\"采购管理\",\"SupplierInfo\",\"SupplierInfo:add\"],[\"采购管理\",\"SupplierInfo\",\"SupplierInfo:edit\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:add\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:archive\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:newPage\"],[\"采购管理\",\"MaterialQuoteArchive\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:add\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:edit\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:set\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:print\"],[\"委外管理\",\"OutsourcingQuote\",\"OutsourcingQuote:add\"],[\"委外管理\",\"OutsourcingQuote\",\"OutsourcingQuote:edit\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:add\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:edit\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:set\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:print\"],[\"生产管理\",\"ProductionProgress\"],[\"生产管理\",\"WorkOrder\",\"WorkOrder:print\"],[\"仓库管理\",\"WarehouseRate\",\"WarehouseRate:edit\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:addIn\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:addOut\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:edit\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:set\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:print\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:addIn\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:addOut\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:edit\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:set\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:print\"],[\"财务管理\",\"EmployeePieceRate\"],[\"财务管理\",\"AccountsReceivable\"],[\"财务管理\",\"AccountsPayable\"],[\"财务管理\",\"AccountsOutsourcing\"]]', 2, 6, 1, 1, '2025-10-19 16:00:54', '2025-11-03 11:29:48');
INSERT INTO `ad_user` VALUES (16, 3, 'lengbing', '$2b$10$7ndhZpR5StJSxEy7Oe7ByOo7NpyWNr2n9SHgnvcdAEaJfPihG0hN2', '冷冰', NULL, '[[\"系统管理\",\"UserManagement\",\"user:add\"],[\"系统管理\",\"UserManagement\",\"user:edit\"],[\"系统管理\",\"UserManagement\",\"user:delete\"],[\"系统管理\",\"OrganizeManagement\"],[\"系统管理\",\"ProcessCycle\",\"ProcessCycle:add\"],[\"系统管理\",\"ProcessCycle\",\"ProcessCycle:edit\"],[\"系统管理\",\"WarehouseType\",\"Warehouse:add\"],[\"系统管理\",\"WarehouseType\",\"Warehouse:edit\"],[\"基础资料\",\"ProductCode\",\"ProductCode:add\"],[\"基础资料\",\"ProductCode\",\"ProductCode:edit\"],[\"基础资料\",\"ProductCode\",\"ProductCode:delete\"],[\"基础资料\",\"PartCode\",\"PartCode:add\"],[\"基础资料\",\"PartCode\",\"PartCode:edit\"],[\"基础资料\",\"PartCode\",\"PartCode:delete\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:add\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:edit\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:delete\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:add\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:edit\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:delete\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:add\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:edit\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:delete\"],[\"基础资料\",\"EmployeeInfo\",\"EmployeeInfo:add\"],[\"基础资料\",\"EmployeeInfo\",\"EmployeeInfo:edit\"],[\"基础资料\",\"EmployeeInfo\",\"EmployeeInfo:delete\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:add\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:edit\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:delete\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:add\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:edit\"],[\"订单管理\",\"ProductQuote\",\"ProductQuote:add\"],[\"订单管理\",\"ProductQuote\",\"ProductQuote:edit\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:add\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:edit\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:date\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:finish\"],[\"订单管理\",\"FinishNotice\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:add\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:edit\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:delete\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:archive\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:newPage\"],[\"产品工程\",\"MaterialBOMArchive\",\"MaterialBOM:cope\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:add\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:edit\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:delete\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:archive\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:newPage\"],[\"产品工程\",\"ProcessBOMArchive\",\"ProcessBOM:cope\"],[\"采购管理\",\"SupplierInfo\",\"SupplierInfo:add\"],[\"采购管理\",\"SupplierInfo\",\"SupplierInfo:edit\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:add\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:archive\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:newPage\"],[\"采购管理\",\"MaterialQuoteArchive\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:add\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:edit\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:set\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:print\"],[\"委外管理\",\"OutsourcingQuote\",\"OutsourcingQuote:add\"],[\"委外管理\",\"OutsourcingQuote\",\"OutsourcingQuote:edit\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:add\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:edit\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:set\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:print\"],[\"生产管理\",\"ProductionProgress\"],[\"生产管理\",\"WorkOrder\",\"WorkOrder:print\"],[\"仓库管理\",\"WarehouseRate\",\"WarehouseRate:edit\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:addIn\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:addOut\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:edit\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:set\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:print\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:addIn\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:addOut\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:edit\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:set\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:print\"],[\"财务管理\",\"EmployeePieceRate\"],[\"财务管理\",\"AccountsReceivable\"],[\"财务管理\",\"AccountsPayable\"],[\"财务管理\",\"AccountsOutsourcing\"]]', 2, 6, 1, 1, '2025-10-27 20:21:26', '2025-11-03 11:29:40');
INSERT INTO `ad_user` VALUES (17, 3, 'hexiongming', '$2b$10$aJ2gjfgqhWKFNhA7jv8rVef1AkKhUgd3mq.owmEVJ3WpU935Yklci', '何雄明', NULL, '[[\"系统管理\",\"UserManagement\",\"user:add\"],[\"系统管理\",\"UserManagement\",\"user:edit\"],[\"系统管理\",\"UserManagement\",\"user:delete\"],[\"系统管理\",\"OrganizeManagement\"],[\"系统管理\",\"ProcessCycle\",\"ProcessCycle:add\"],[\"系统管理\",\"ProcessCycle\",\"ProcessCycle:edit\"],[\"系统管理\",\"WarehouseType\",\"Warehouse:add\"],[\"系统管理\",\"WarehouseType\",\"Warehouse:edit\"],[\"基础资料\",\"ProductCode\",\"ProductCode:add\"],[\"基础资料\",\"ProductCode\",\"ProductCode:edit\"],[\"基础资料\",\"ProductCode\",\"ProductCode:delete\"],[\"基础资料\",\"PartCode\",\"PartCode:add\"],[\"基础资料\",\"PartCode\",\"PartCode:edit\"],[\"基础资料\",\"PartCode\",\"PartCode:delete\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:add\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:edit\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:delete\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:add\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:edit\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:delete\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:add\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:edit\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:delete\"],[\"基础资料\",\"EmployeeInfo\",\"EmployeeInfo:add\"],[\"基础资料\",\"EmployeeInfo\",\"EmployeeInfo:edit\"],[\"基础资料\",\"EmployeeInfo\",\"EmployeeInfo:delete\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:add\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:edit\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:delete\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:add\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:edit\"],[\"订单管理\",\"ProductQuote\",\"ProductQuote:add\"],[\"订单管理\",\"ProductQuote\",\"ProductQuote:edit\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:add\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:edit\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:date\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:finish\"],[\"订单管理\",\"FinishNotice\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:add\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:edit\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:delete\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:archive\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:newPage\"],[\"产品工程\",\"MaterialBOMArchive\",\"MaterialBOM:cope\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:add\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:edit\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:delete\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:archive\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:newPage\"],[\"产品工程\",\"ProcessBOMArchive\",\"ProcessBOM:cope\"],[\"采购管理\",\"SupplierInfo\",\"SupplierInfo:add\"],[\"采购管理\",\"SupplierInfo\",\"SupplierInfo:edit\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:add\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:archive\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:newPage\"],[\"采购管理\",\"MaterialQuoteArchive\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:add\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:edit\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:set\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:print\"],[\"委外管理\",\"OutsourcingQuote\",\"OutsourcingQuote:add\"],[\"委外管理\",\"OutsourcingQuote\",\"OutsourcingQuote:edit\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:add\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:edit\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:set\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:print\"],[\"生产管理\",\"ProductionProgress\"],[\"生产管理\",\"WorkOrder\",\"WorkOrder:print\"],[\"仓库管理\",\"WarehouseRate\",\"WarehouseRate:edit\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:addIn\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:addOut\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:edit\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:set\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:print\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:addIn\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:addOut\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:edit\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:set\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:print\"],[\"财务管理\",\"EmployeePieceRate\"],[\"财务管理\",\"AccountsReceivable\"],[\"财务管理\",\"AccountsPayable\"],[\"财务管理\",\"AccountsOutsourcing\"]]', 2, 6, 1, 1, '2025-10-27 20:22:48', '2025-11-03 11:29:27');

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
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '审批步骤配置表' ROW_FORMAT = DYNAMIC;

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
INSERT INTO `sub_approval_step` VALUES (12, 3, 'purchase_order', 1, 16, '冷冰', 1, '2025-11-02 03:42:26', '2025-11-02 03:42:26');
INSERT INTO `sub_approval_step` VALUES (13, 3, 'purchase_order', 2, 15, '粟云', 1, '2025-11-02 03:42:26', '2025-11-02 03:42:26');

-- ----------------------------
-- Table structure for sub_approval_user
-- ----------------------------
DROP TABLE IF EXISTS `sub_approval_user`;
CREATE TABLE `sub_approval_user`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `company_id` int(11) NOT NULL COMMENT '企业id',
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
) ENGINE = InnoDB AUTO_INCREMENT = 95 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '流程控制用户表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_approval_user
-- ----------------------------
INSERT INTO `sub_approval_user` VALUES (13, 1, 'material_warehouse', 17, 5, '哈哈', NULL, 1, 0, '2025-09-19 21:18:25', '2025-09-21 17:03:50');
INSERT INTO `sub_approval_user` VALUES (14, 1, 'material_warehouse', 17, 4, '2132', NULL, 2, 0, '2025-09-19 21:18:25', '2025-09-21 17:03:51');
INSERT INTO `sub_approval_user` VALUES (15, 1, 'material_warehouse', 18, 5, '哈哈', NULL, 1, 0, '2025-09-19 21:18:25', '2025-09-21 17:03:52');
INSERT INTO `sub_approval_user` VALUES (16, 1, 'material_warehouse', 18, 4, '2132', NULL, 2, 0, '2025-09-19 21:18:25', '2025-09-19 21:18:25');
INSERT INTO `sub_approval_user` VALUES (17, 1, 'material_warehouse', 19, 5, '哈哈', NULL, 1, 0, '2025-09-19 21:18:25', '2025-09-21 17:03:52');
INSERT INTO `sub_approval_user` VALUES (18, 1, 'material_warehouse', 19, 4, '2132', NULL, 2, 0, '2025-09-19 21:18:25', '2025-09-21 17:03:55');
INSERT INTO `sub_approval_user` VALUES (19, 1, 'material_warehouse', 20, 5, '哈哈', NULL, 1, 0, '2025-09-19 21:18:25', '2025-09-19 21:18:25');
INSERT INTO `sub_approval_user` VALUES (20, 1, 'material_warehouse', 20, 4, '2132', NULL, 2, 0, '2025-09-19 21:18:25', '2025-09-19 21:18:25');
INSERT INTO `sub_approval_user` VALUES (21, 1, 'material_warehouse', 21, 5, '哈哈', NULL, 1, 0, '2025-09-19 21:52:27', '2025-09-21 17:03:56');
INSERT INTO `sub_approval_user` VALUES (22, 1, 'material_warehouse', 21, 4, '2132', NULL, 2, 0, '2025-09-19 21:52:27', '2025-09-19 21:52:27');
INSERT INTO `sub_approval_user` VALUES (23, 1, 'material_warehouse', 22, 5, '哈哈', NULL, 1, 1, '2025-09-19 21:52:27', '2025-09-26 16:33:26');
INSERT INTO `sub_approval_user` VALUES (24, 1, 'material_warehouse', 22, 4, '2132', NULL, 2, 0, '2025-09-19 21:52:27', '2025-09-19 21:52:27');
INSERT INTO `sub_approval_user` VALUES (25, 1, 'material_warehouse', 23, 5, '哈哈', NULL, 1, 1, '2025-09-20 19:53:35', '2025-09-21 17:18:33');
INSERT INTO `sub_approval_user` VALUES (26, 1, 'material_warehouse', 23, 4, '2132', NULL, 2, 1, '2025-09-20 19:53:35', '2025-09-21 17:20:30');
INSERT INTO `sub_approval_user` VALUES (27, 1, 'material_warehouse', 18, 5, '哈哈', NULL, 1, 0, '2025-09-20 19:53:35', '2025-09-20 19:53:35');
INSERT INTO `sub_approval_user` VALUES (28, 1, 'material_warehouse', 18, 4, '2132', NULL, 2, 0, '2025-09-20 19:53:35', '2025-09-20 19:53:35');
INSERT INTO `sub_approval_user` VALUES (29, 1, 'material_warehouse', 18, 5, '哈哈', NULL, 1, 0, '2025-09-20 19:54:20', '2025-09-20 19:54:20');
INSERT INTO `sub_approval_user` VALUES (30, 1, 'material_warehouse', 18, 4, '2132', NULL, 2, 0, '2025-09-20 19:54:20', '2025-09-20 19:54:20');
INSERT INTO `sub_approval_user` VALUES (31, 1, 'material_warehouse', 18, 5, '哈哈', NULL, 1, 0, '2025-09-20 19:54:42', '2025-09-20 19:54:42');
INSERT INTO `sub_approval_user` VALUES (32, 1, 'material_warehouse', 18, 4, '2132', NULL, 2, 0, '2025-09-20 19:54:42', '2025-09-20 19:54:42');
INSERT INTO `sub_approval_user` VALUES (33, 1, 'material_warehouse', 18, 5, '哈哈', NULL, 1, 0, '2025-09-20 19:55:50', '2025-09-20 19:55:50');
INSERT INTO `sub_approval_user` VALUES (34, 1, 'material_warehouse', 18, 4, '2132', NULL, 2, 0, '2025-09-20 19:55:50', '2025-09-20 19:55:50');
INSERT INTO `sub_approval_user` VALUES (35, 1, 'material_warehouse', 18, 5, '哈哈', NULL, 1, 0, '2025-09-20 19:57:20', '2025-09-20 19:57:20');
INSERT INTO `sub_approval_user` VALUES (36, 1, 'material_warehouse', 18, 4, '2132', NULL, 2, 0, '2025-09-20 19:57:20', '2025-09-20 19:57:20');
INSERT INTO `sub_approval_user` VALUES (37, 1, 'material_warehouse', 18, 5, '哈哈', NULL, 1, 0, '2025-09-20 19:58:58', '2025-09-20 19:58:58');
INSERT INTO `sub_approval_user` VALUES (38, 1, 'material_warehouse', 18, 4, '2132', NULL, 2, 0, '2025-09-20 19:58:58', '2025-09-20 19:58:58');
INSERT INTO `sub_approval_user` VALUES (39, 1, 'material_warehouse', 18, 5, '哈哈', NULL, 1, 0, '2025-09-20 19:59:29', '2025-09-20 19:59:29');
INSERT INTO `sub_approval_user` VALUES (40, 1, 'material_warehouse', 18, 4, '2132', NULL, 2, 0, '2025-09-20 19:59:29', '2025-09-20 19:59:29');
INSERT INTO `sub_approval_user` VALUES (41, 1, 'material_warehouse', 25, 5, '哈哈', NULL, 1, 1, '2025-09-20 20:00:01', '2025-09-21 17:18:22');
INSERT INTO `sub_approval_user` VALUES (42, 1, 'material_warehouse', 25, 4, '2132', NULL, 2, 1, '2025-09-20 20:00:01', '2025-09-21 17:20:30');
INSERT INTO `sub_approval_user` VALUES (43, 1, 'material_warehouse', 26, 5, '哈哈', NULL, 1, 1, '2025-09-20 20:00:01', '2025-09-21 17:18:30');
INSERT INTO `sub_approval_user` VALUES (44, 1, 'material_warehouse', 26, 4, '2132', NULL, 2, 1, '2025-09-20 20:00:01', '2025-09-21 17:20:30');
INSERT INTO `sub_approval_user` VALUES (45, 1, 'material_warehouse', 27, 5, '哈哈', NULL, 1, 1, '2025-09-21 16:52:36', '2025-09-26 16:32:55');
INSERT INTO `sub_approval_user` VALUES (46, 1, 'material_warehouse', 27, 4, '2132', NULL, 2, 0, '2025-09-21 16:52:36', '2025-09-21 16:52:36');
INSERT INTO `sub_approval_user` VALUES (47, 1, 'material_warehouse', 28, 5, '哈哈', NULL, 1, 1, '2025-09-21 16:56:51', '2025-09-22 14:17:05');
INSERT INTO `sub_approval_user` VALUES (48, 1, 'material_warehouse', 28, 4, '2132', NULL, 2, 1, '2025-09-21 16:56:51', '2025-09-22 14:17:05');
INSERT INTO `sub_approval_user` VALUES (49, 1, 'purchase_order', 3, 5, '哈哈', NULL, 1, 1, '2025-09-23 14:54:56', '2025-09-26 15:50:08');
INSERT INTO `sub_approval_user` VALUES (50, 1, 'purchase_order', 3, 4, '2132', NULL, 2, 0, '2025-09-23 14:54:56', '2025-09-23 15:38:14');
INSERT INTO `sub_approval_user` VALUES (51, 1, 'outsourcing_order', 8, 4, '2132', NULL, 1, 1, '2025-09-23 16:31:18', '2025-09-23 16:45:42');
INSERT INTO `sub_approval_user` VALUES (52, 1, 'outsourcing_order', 8, 5, '哈哈', NULL, 2, 2, '2025-09-23 16:31:18', '2025-09-23 16:46:09');
INSERT INTO `sub_approval_user` VALUES (53, 1, 'outsourcing_order', 9, 4, '2132', NULL, 1, 0, '2025-09-23 16:46:50', '2025-09-23 16:46:50');
INSERT INTO `sub_approval_user` VALUES (54, 1, 'outsourcing_order', 9, 5, '哈哈', NULL, 2, 0, '2025-09-23 16:46:50', '2025-09-23 16:46:50');
INSERT INTO `sub_approval_user` VALUES (55, 1, 'outsourcing_order', 10, 4, '2132', NULL, 1, 0, '2025-09-23 16:47:08', '2025-09-23 16:47:08');
INSERT INTO `sub_approval_user` VALUES (56, 1, 'outsourcing_order', 10, 5, '哈哈', NULL, 2, 0, '2025-09-23 16:47:08', '2025-09-23 16:47:08');
INSERT INTO `sub_approval_user` VALUES (57, 1, 'outsourcing_order', 8, 4, '2132', NULL, 1, 0, '2025-09-23 16:51:46', '2025-09-23 16:51:46');
INSERT INTO `sub_approval_user` VALUES (58, 1, 'outsourcing_order', 8, 5, '哈哈', NULL, 2, 0, '2025-09-23 16:51:46', '2025-09-23 16:51:46');
INSERT INTO `sub_approval_user` VALUES (59, 1, 'purchase_order', 4, 5, '哈哈', NULL, 1, 1, '2025-09-26 14:03:04', '2025-09-26 15:49:50');
INSERT INTO `sub_approval_user` VALUES (60, 1, 'purchase_order', 4, 4, '2132', NULL, 2, 0, '2025-09-26 14:03:04', '2025-09-26 14:03:04');
INSERT INTO `sub_approval_user` VALUES (61, 1, 'outsourcing_order', 11, 4, '2132', NULL, 1, 1, '2025-09-26 14:40:30', '2025-09-26 15:45:25');
INSERT INTO `sub_approval_user` VALUES (62, 1, 'outsourcing_order', 11, 5, '哈哈', NULL, 2, 2, '2025-09-26 14:40:30', '2025-09-26 15:46:59');
INSERT INTO `sub_approval_user` VALUES (67, 1, 'material_warehouse', 29, 5, '哈哈', NULL, 1, 0, '2025-09-26 16:32:19', '2025-09-26 16:32:19');
INSERT INTO `sub_approval_user` VALUES (68, 1, 'material_warehouse', 29, 4, '2132', NULL, 2, 0, '2025-09-26 16:32:19', '2025-09-26 16:32:19');
INSERT INTO `sub_approval_user` VALUES (73, 1, 'product_warehouse', 32, 5, '哈哈', NULL, 1, 1, '2025-09-26 17:25:53', '2025-09-26 17:26:17');
INSERT INTO `sub_approval_user` VALUES (74, 1, 'product_warehouse', 32, 4, '2132', NULL, 2, 1, '2025-09-26 17:25:53', '2025-09-26 17:26:29');
INSERT INTO `sub_approval_user` VALUES (75, 1, 'product_warehouse', 33, 5, '哈哈', NULL, 1, 1, '2025-09-26 17:25:53', '2025-09-26 17:26:17');
INSERT INTO `sub_approval_user` VALUES (76, 1, 'product_warehouse', 33, 4, '2132', NULL, 2, 1, '2025-09-26 17:25:53', '2025-09-26 17:26:29');
INSERT INTO `sub_approval_user` VALUES (77, 1, 'outsourcing_order', 12, 4, '2132', NULL, 1, 0, '2025-09-26 21:29:06', '2025-09-26 21:29:06');
INSERT INTO `sub_approval_user` VALUES (78, 1, 'outsourcing_order', 12, 5, '哈哈', NULL, 2, 0, '2025-09-26 21:29:06', '2025-09-26 21:29:06');
INSERT INTO `sub_approval_user` VALUES (79, 1, 'outsourcing_order', 11, 4, '2132', NULL, 1, 0, '2025-09-26 21:29:06', '2025-09-26 21:29:06');
INSERT INTO `sub_approval_user` VALUES (80, 1, 'outsourcing_order', 11, 5, '哈哈', NULL, 2, 0, '2025-09-26 21:29:06', '2025-09-26 21:29:06');
INSERT INTO `sub_approval_user` VALUES (81, 1, 'material_warehouse', 40, 5, '哈哈', NULL, 1, 0, '2025-10-11 16:29:33', '2025-10-11 16:29:33');
INSERT INTO `sub_approval_user` VALUES (82, 1, 'material_warehouse', 40, 4, '2132', NULL, 2, 0, '2025-10-11 16:29:33', '2025-10-11 16:29:33');
INSERT INTO `sub_approval_user` VALUES (83, 1, 'material_warehouse', 41, 5, '哈哈', NULL, 1, 0, '2025-10-12 00:13:52', '2025-10-12 00:13:52');
INSERT INTO `sub_approval_user` VALUES (84, 1, 'material_warehouse', 41, 4, '2132', NULL, 2, 0, '2025-10-12 00:13:52', '2025-10-12 00:13:52');
INSERT INTO `sub_approval_user` VALUES (85, 1, 'product_warehouse', 42, 5, '哈哈', NULL, 1, 1, '2025-10-12 13:06:54', '2025-10-12 13:08:34');
INSERT INTO `sub_approval_user` VALUES (86, 1, 'product_warehouse', 42, 4, '2132', NULL, 2, 1, '2025-10-12 13:06:54', '2025-10-12 13:08:50');
INSERT INTO `sub_approval_user` VALUES (87, 1, 'product_warehouse', 43, 5, '哈哈', NULL, 1, 1, '2025-10-12 13:44:30', '2025-10-12 14:21:12');
INSERT INTO `sub_approval_user` VALUES (88, 1, 'product_warehouse', 43, 4, '2132', NULL, 2, 1, '2025-10-12 13:44:30', '2025-10-12 14:21:59');
INSERT INTO `sub_approval_user` VALUES (89, 1, 'product_warehouse', 44, 5, '哈哈', NULL, 1, 1, '2025-10-12 14:09:26', '2025-10-12 14:21:09');
INSERT INTO `sub_approval_user` VALUES (90, 1, 'product_warehouse', 44, 4, '2132', NULL, 2, 1, '2025-10-12 14:09:26', '2025-10-12 14:21:59');
INSERT INTO `sub_approval_user` VALUES (91, 1, 'product_warehouse', 44, 5, '哈哈', NULL, 1, 1, '2025-10-12 14:21:03', '2025-10-12 14:21:48');
INSERT INTO `sub_approval_user` VALUES (92, 1, 'product_warehouse', 44, 4, '2132', NULL, 2, 1, '2025-10-12 14:21:03', '2025-10-12 14:22:13');
INSERT INTO `sub_approval_user` VALUES (93, 1, 'product_warehouse', 43, 5, '哈哈', NULL, 1, 1, '2025-10-12 14:21:03', '2025-10-12 14:21:48');
INSERT INTO `sub_approval_user` VALUES (94, 1, 'product_warehouse', 43, 4, '2132', NULL, 2, 1, '2025-10-12 14:21:03', '2025-10-12 14:22:13');

-- ----------------------------
-- Table structure for sub_const_type
-- ----------------------------
DROP TABLE IF EXISTS `sub_const_type`;
CREATE TABLE `sub_const_type`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `type` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '常量类型',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '仓库类型名称',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 39 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_const_type
-- ----------------------------
INSERT INTO `sub_const_type` VALUES (1, 'house', '材料仓', '2025-09-09 10:08:29', '2025-09-16 20:36:50');
INSERT INTO `sub_const_type` VALUES (2, 'house', '部件仓', '2025-09-09 10:08:29', '2025-09-16 20:36:50');
INSERT INTO `sub_const_type` VALUES (3, 'house', '成品仓', '2025-09-09 10:08:29', '2025-09-16 20:36:51');
INSERT INTO `sub_const_type` VALUES (4, 'materialIn', '采购入库', '2025-09-16 20:37:46', '2025-09-16 20:37:46');
INSERT INTO `sub_const_type` VALUES (5, 'materialIn', '期初入库', '2025-09-16 20:38:04', '2025-09-16 20:38:04');
INSERT INTO `sub_const_type` VALUES (6, 'materialIn', '盘银入库', '2025-09-16 20:38:12', '2025-09-16 20:38:12');
INSERT INTO `sub_const_type` VALUES (7, 'materialOut', '生产领料', '2025-09-16 20:38:50', '2025-09-16 20:38:50');
INSERT INTO `sub_const_type` VALUES (8, 'materialOut', '委外领料', '2025-09-16 20:39:00', '2025-09-16 20:39:00');
INSERT INTO `sub_const_type` VALUES (9, 'materialOut', '盘亏出库', '2025-09-16 20:39:32', '2025-09-16 20:39:32');
INSERT INTO `sub_const_type` VALUES (10, 'productIn', '生产入库', '2025-09-16 20:39:56', '2025-09-16 20:39:56');
INSERT INTO `sub_const_type` VALUES (11, 'productIn', '期初入库', '2025-09-16 20:40:09', '2025-09-16 20:40:09');
INSERT INTO `sub_const_type` VALUES (12, 'productIn', '盘银入库', '2025-09-16 20:40:17', '2025-09-16 20:40:17');
INSERT INTO `sub_const_type` VALUES (13, 'productIn', '退货入库', '2025-09-16 20:40:35', '2025-09-16 20:41:16');
INSERT INTO `sub_const_type` VALUES (14, 'productOut', '成品出货', '2025-09-16 20:40:43', '2025-09-21 13:53:53');
INSERT INTO `sub_const_type` VALUES (15, 'productOut', '报废出库', '2025-09-16 20:40:50', '2025-09-16 20:41:26');
INSERT INTO `sub_const_type` VALUES (16, 'productOut', '盘亏出库', '2025-09-16 20:41:29', '2025-09-16 20:41:36');
INSERT INTO `sub_const_type` VALUES (17, 'employeeInfo', '个人计件', '2025-10-22 12:46:09', '2025-10-22 12:46:09');
INSERT INTO `sub_const_type` VALUES (18, 'employeeInfo', '团体计件', '2025-10-22 12:46:32', '2025-10-22 12:46:32');
INSERT INTO `sub_const_type` VALUES (19, 'employeeInfo', '计时', '2025-10-22 12:46:41', '2025-10-22 12:46:41');
INSERT INTO `sub_const_type` VALUES (20, 'employeeInfo', '月薪', '2025-10-22 12:46:48', '2025-10-22 12:46:48');
INSERT INTO `sub_const_type` VALUES (21, 'payInfo', '现金', '2025-10-22 13:12:54', '2025-10-22 13:12:54');
INSERT INTO `sub_const_type` VALUES (22, 'payInfo', '支票', '2025-10-22 13:13:00', '2025-10-22 13:13:15');
INSERT INTO `sub_const_type` VALUES (23, 'payInfo', '存兑', '2025-10-22 13:13:13', '2025-10-22 13:13:16');
INSERT INTO `sub_const_type` VALUES (24, 'payTime', '货到付款', '2025-11-03 05:57:18', '2025-11-03 05:57:18');
INSERT INTO `sub_const_type` VALUES (25, 'payTime', '月结30天', '2025-11-03 05:57:40', '2025-11-03 05:57:40');
INSERT INTO `sub_const_type` VALUES (26, 'payTime', '月结60天', '2025-11-03 05:57:55', '2025-11-03 05:57:55');
INSERT INTO `sub_const_type` VALUES (27, 'payTime', '月结90天', '2025-11-03 05:58:13', '2025-11-03 05:58:13');
INSERT INTO `sub_const_type` VALUES (28, 'payTime', '其他', '2025-11-03 05:58:23', '2025-11-03 05:58:23');
INSERT INTO `sub_const_type` VALUES (29, 'supplyMethod', '送货上门', '2025-11-03 20:17:47', '2025-11-03 20:17:47');
INSERT INTO `sub_const_type` VALUES (30, 'supplyMethod', '自提取货', '2025-11-03 20:17:55', '2025-11-03 20:17:55');
INSERT INTO `sub_const_type` VALUES (31, 'supplyMethod', '三方物流', '2025-11-03 20:18:05', '2025-11-03 20:18:05');
INSERT INTO `sub_const_type` VALUES (32, 'supplierType', '原材料供应', '2025-11-03 20:29:56', '2025-11-03 20:29:56');
INSERT INTO `sub_const_type` VALUES (33, 'supplierType', '易耗材供应', '2025-11-03 20:29:58', '2025-11-03 20:30:01');
INSERT INTO `sub_const_type` VALUES (34, 'supplierType', '设备供应', '2025-11-03 20:30:07', '2025-11-03 20:30:07');
INSERT INTO `sub_const_type` VALUES (35, 'supplierType', '委外加工', '2025-11-03 20:30:13', '2025-11-03 20:30:15');
INSERT INTO `sub_const_type` VALUES (36, 'invoice', '不含税', '2025-11-04 11:41:15', '2025-11-04 11:41:33');
INSERT INTO `sub_const_type` VALUES (37, 'invoice', '普通发票', '2025-11-04 11:41:45', '2025-11-04 11:41:45');
INSERT INTO `sub_const_type` VALUES (38, 'invoice', '增值发票', '2025-11-04 11:41:52', '2025-11-04 11:41:52');

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
  `transaction_method` int(5) NULL DEFAULT NULL COMMENT '交易方式',
  `transaction_currency` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '交易币别',
  `other_transaction_terms` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '其它交易条件',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '客户信息基础信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_customer_info
-- ----------------------------
INSERT INTO `sub_customer_info` VALUES (1, 1, 1, '123223', '石龙佳洁士', '1', '1', '1', '1', '1', '1', 22, '1', '1', 1, '2025-07-08 19:29:21', '2025-10-22 13:14:26');
INSERT INTO `sub_customer_info` VALUES (2, 1, 1, '1234', '惠州饮料厂', '212', '121', '21', '121', '2121', '21', 21, '2121', '2121', 1, '2025-07-09 00:58:19', '2025-10-22 13:18:16');
INSERT INTO `sub_customer_info` VALUES (3, 1, 1, '12311', '东莞鞋厂', '12', '1', '15', '155', '15', '15', 23, '55', '11', 1, '2025-07-09 15:04:51', '2025-10-22 13:18:08');
INSERT INTO `sub_customer_info` VALUES (4, 6, 3, 'KA001', '旭欧', '潘总', '13812345678', '东莞市旭欧精密五金有限公司', '东莞市石碣镇单屋村', '公司材料仓', 'SJ123456', 21, '人民币', '月结60天', 1, '2025-10-18 11:09:32', '2025-10-30 15:52:38');
INSERT INTO `sub_customer_info` VALUES (5, 6, 3, 'KA002', '鑫宇', '王总', '13712345678', '东莞市鑫宇五金制品厂', '东莞市万江区官桥窖村', '高埗镇合鑫喷漆厂', 'WJ123456', 21, '人民币', '月结90天', 1, '2025-10-30 15:52:21', '2025-10-30 15:52:21');

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
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '日历记录的表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_date_info
-- ----------------------------
INSERT INTO `sub_date_info` VALUES (8, 1, '2025-10-17', '2025-10-16 11:07:35', '2025-10-16 11:07:35');
INSERT INTO `sub_date_info` VALUES (9, 1, '2025-10-20', '2025-10-16 11:07:35', '2025-10-16 11:07:35');
INSERT INTO `sub_date_info` VALUES (10, 1, '2025-10-21', '2025-10-16 11:07:35', '2025-10-16 11:07:35');
INSERT INTO `sub_date_info` VALUES (11, 1, '2025-10-04', '2025-10-16 11:07:35', '2025-10-16 11:07:35');
INSERT INTO `sub_date_info` VALUES (12, 1, '2025-10-11', '2025-10-16 11:07:35', '2025-10-16 11:07:35');
INSERT INTO `sub_date_info` VALUES (13, 1, '2025-10-18', '2025-10-16 11:07:35', '2025-10-16 11:07:35');
INSERT INTO `sub_date_info` VALUES (14, 1, '2025-10-25', '2025-10-16 11:07:35', '2025-10-16 11:07:35');

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
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '员工信息基础信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_employee_info
-- ----------------------------
INSERT INTO `sub_employee_info` VALUES (1, 1, 1, '1', '1', NULL, NULL, 3, '1', 17, '1', 1, '2025-07-08 16:39:58', '2025-10-22 13:10:15');
INSERT INTO `sub_employee_info` VALUES (2, 1, 1, '2', '2', 'base2', '$2b$10$mHXkEoWarhWYGisAwOnZ9Oghb6wEcnG0NOH8WdevQwS7HKLlET/Ja', 2, '23', 18, '3', 1, '2025-07-08 16:40:09', '2025-10-22 13:10:16');
INSERT INTO `sub_employee_info` VALUES (3, 1, 1, '21', '2121', 'base1', '$2b$10$K0JSC.MSvQbD6mkRHjvjC.gpS4XvjatLgIf/yw0wjSs.N3FHt9aCe', 2, '21', 19, '211', 1, '2025-10-01 14:42:30', '2025-10-22 13:11:01');
INSERT INTO `sub_employee_info` VALUES (4, 1, 1, '22', '5445', 'base3', '$2b$10$7DtT7oDcCGxZaLYfiJTPd.mywJj.yYGwC7di.3HLUfD.JBtP3wv0y', 2, '2121', 20, '21', 1, '2025-10-01 15:05:57', '2025-10-22 13:10:19');
INSERT INTO `sub_employee_info` VALUES (5, 6, 3, 'GL0002', '冷冰', 'SC0001', '$2b$10$1fJx1ONLKdN8t7dmcuQ.KODgtQ1ff5bFVVC0tUk4IQbkkXUX3k7pm', 14, '业务部副总', 20, NULL, 1, '2025-10-18 10:54:01', '2025-11-03 11:28:38');
INSERT INTO `sub_employee_info` VALUES (6, 6, 3, 'GL0001', '徐庆华', 'GL0002', '$2b$10$vqlF5BJP4DLhCjIc3rIS8.7j02OmX7NWxUQYBjScbdnUiZ49rT63C', 15, '公司创始人', 20, NULL, 1, '2025-10-18 11:00:50', '2025-10-28 15:04:40');
INSERT INTO `sub_employee_info` VALUES (7, 6, 3, 'GL0003', '何雄明', NULL, '$2b$10$1zaoOimS5ZBJDnocBe5isuXqsA2RiW2/y1lmfm3YpnxhCCSBB4PQm', 13, '技术部副总', 20, NULL, 1, '2025-10-27 20:45:10', '2025-11-03 11:28:12');
INSERT INTO `sub_employee_info` VALUES (8, 6, 3, 'GL0004', '粟云', NULL, '$2b$10$vIxMD.gzhk7SKu4nSAMSoeb8LMRr.w.MGYSM1axo1CztZSVfNbgtm', 15, '生产部副总', 20, NULL, 1, '2025-10-27 20:49:12', '2025-11-03 11:29:10');
INSERT INTO `sub_employee_info` VALUES (9, 6, 3, 'GL0005', '徐楚东', NULL, '$2b$10$I2QbpPtCfgs6e.XcCVPASOkbCuL3Pjnaa82yrFLkw9OxUGmbJhQ6m', 12, '行政部专员', 20, NULL, 1, '2025-10-31 10:01:52', '2025-11-03 11:27:58');

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
) ENGINE = InnoDB AUTO_INCREMENT = 49 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '设备信息基础信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_equipment_code
-- ----------------------------
INSERT INTO `sub_equipment_code` VALUES (3, 1, 1, '123', '钻床', 12, 3, '7', 56, 8, '无', 1, '2025-07-08 16:06:29', '2025-10-22 11:39:46');
INSERT INTO `sub_equipment_code` VALUES (4, 1, 1, '122', '退火炉', 22, 1, '10', 40, 4, '无', 1, '2025-08-09 16:06:56', '2025-10-22 11:39:41');
INSERT INTO `sub_equipment_code` VALUES (5, 1, 1, '124', '激光机', 5, 1, '8', 40, 5, '无', 1, '2025-08-29 09:33:14', '2025-10-22 11:39:35');
INSERT INTO `sub_equipment_code` VALUES (6, 6, 3, 'JX01', '打字机', 2, 6, '10', 20, 2, '', 1, '2025-10-18 10:17:12', '2025-11-02 09:14:56');
INSERT INTO `sub_equipment_code` VALUES (7, 6, 3, 'JX02', '16T冲床', 8, 6, '10', 80, 8, '', 1, '2025-10-18 10:21:33', '2025-10-23 23:51:20');
INSERT INTO `sub_equipment_code` VALUES (8, 6, 3, 'JX03', '钻床-A', 5, 6, '10', 50, 5, '', 1, '2025-10-18 10:24:42', '2025-10-23 23:51:15');
INSERT INTO `sub_equipment_code` VALUES (9, 6, 3, 'JX04', '手动研磨机', 4, 9, '10', 40, 4, '', 1, '2025-10-18 10:38:09', '2025-10-28 22:35:10');
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
INSERT INTO `sub_equipment_code` VALUES (29, 6, 3, 'JX24', '氩焊机', 49, 7, '10', 490, 49, '', 1, '2025-10-28 13:37:55', '2025-10-28 13:37:55');
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
  `archive` int(11) NULL DEFAULT NULL COMMENT '是否已存档，1未存，0已存',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 42 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '材料BOM表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_material_bom
-- ----------------------------
INSERT INTO `sub_material_bom` VALUES (5, 1, 1, 11, 6, 0, 1, '2025-07-27 11:10:29', '2025-08-03 11:04:19');
INSERT INTO `sub_material_bom` VALUES (6, 1, 1, 10, 5, 0, 1, '2025-07-27 11:22:56', '2025-08-03 11:04:19');
INSERT INTO `sub_material_bom` VALUES (7, 1, 1, 9, 6, 0, 1, '2025-07-27 11:50:06', '2025-08-03 11:04:19');
INSERT INTO `sub_material_bom` VALUES (8, 1, 1, 10, 6, 0, 1, '2025-08-02 11:04:51', '2025-08-03 11:04:19');
INSERT INTO `sub_material_bom` VALUES (9, 1, 1, 19, 5, 0, 1, '2025-08-11 10:19:02', '2025-08-13 14:40:29');
INSERT INTO `sub_material_bom` VALUES (10, 1, 1, 19, 6, 0, 1, '2025-08-11 10:19:02', '2025-08-13 14:40:29');
INSERT INTO `sub_material_bom` VALUES (11, 1, 1, 19, 10, 0, 1, '2025-08-11 10:19:02', '2025-08-13 14:40:29');
INSERT INTO `sub_material_bom` VALUES (12, 1, 1, 17, 7, 0, 1, '2025-08-13 10:38:41', '2025-08-13 14:40:29');
INSERT INTO `sub_material_bom` VALUES (13, 1, 1, 19, 6, 0, 1, '2025-08-13 14:41:35', '2025-08-17 09:48:46');
INSERT INTO `sub_material_bom` VALUES (14, 1, 1, 17, 7, 0, 1, '2025-08-13 14:41:55', '2025-08-17 09:48:46');
INSERT INTO `sub_material_bom` VALUES (15, 1, 1, 19, 10, 0, 1, '2025-08-13 14:42:03', '2025-08-17 09:48:46');
INSERT INTO `sub_material_bom` VALUES (16, 1, 1, 17, 7, 0, 1, '2025-08-21 09:35:05', '2025-09-25 14:39:53');
INSERT INTO `sub_material_bom` VALUES (17, 1, 1, 16, 8, 0, 1, '2025-09-25 14:38:28', '2025-09-25 14:39:53');
INSERT INTO `sub_material_bom` VALUES (18, 1, 1, 11, 9, 0, 1, '2025-09-25 14:39:31', '2025-09-25 14:39:53');
INSERT INTO `sub_material_bom` VALUES (19, 1, 1, 14, 10, 0, 1, '2025-09-25 14:39:45', '2025-09-25 14:39:53');
INSERT INTO `sub_material_bom` VALUES (20, 1, 1, 14, 13, 0, 1, '2025-09-25 14:44:26', '2025-09-25 14:44:42');
INSERT INTO `sub_material_bom` VALUES (21, 1, 1, 14, 10, 0, 1, '2025-09-25 14:44:36', '2025-09-25 14:44:42');
INSERT INTO `sub_material_bom` VALUES (22, 3, 12, 20, 21, 1, 0, '2025-10-18 14:29:06', '2025-10-18 15:10:13');
INSERT INTO `sub_material_bom` VALUES (23, 3, 6, 20, 21, 0, 1, '2025-10-18 14:30:01', '2025-10-30 17:14:43');
INSERT INTO `sub_material_bom` VALUES (24, 3, 6, 20, 27, 0, 1, '2025-10-18 15:08:30', '2025-10-30 17:14:43');
INSERT INTO `sub_material_bom` VALUES (25, 1, 1, 15, 8, 1, 1, '2025-10-21 21:04:49', '2025-10-21 21:23:26');
INSERT INTO `sub_material_bom` VALUES (26, 3, 6, 20, 34, 0, 1, '2025-10-30 16:49:20', '2025-10-30 17:14:43');
INSERT INTO `sub_material_bom` VALUES (27, 3, 6, 20, 33, 0, 1, '2025-10-30 16:49:58', '2025-10-30 17:14:43');
INSERT INTO `sub_material_bom` VALUES (28, 3, 6, 20, 25, 0, 1, '2025-10-30 16:54:25', '2025-10-30 17:14:43');
INSERT INTO `sub_material_bom` VALUES (29, 3, 6, 20, 38, 0, 1, '2025-10-30 16:55:14', '2025-10-30 17:14:43');
INSERT INTO `sub_material_bom` VALUES (30, 3, 6, 20, 22, 0, 1, '2025-10-30 16:58:07', '2025-10-30 17:14:43');
INSERT INTO `sub_material_bom` VALUES (31, 3, 6, 20, 29, 0, 1, '2025-10-30 16:59:47', '2025-10-30 17:14:43');
INSERT INTO `sub_material_bom` VALUES (32, 3, 6, 20, 28, 0, 1, '2025-10-30 17:01:11', '2025-10-30 17:14:43');
INSERT INTO `sub_material_bom` VALUES (33, 3, 6, 20, 35, 0, 1, '2025-10-30 17:01:55', '2025-10-30 17:14:43');
INSERT INTO `sub_material_bom` VALUES (34, 3, 6, 20, 36, 0, 1, '2025-10-30 17:02:54', '2025-10-30 17:14:43');
INSERT INTO `sub_material_bom` VALUES (35, 3, 6, 20, 30, 0, 1, '2025-10-30 17:04:53', '2025-10-30 17:14:43');
INSERT INTO `sub_material_bom` VALUES (36, 3, 6, 20, 31, 0, 1, '2025-10-30 17:05:52', '2025-10-30 17:14:43');
INSERT INTO `sub_material_bom` VALUES (37, 3, 6, 20, 40, 0, 1, '2025-10-30 17:07:19', '2025-10-30 17:14:43');
INSERT INTO `sub_material_bom` VALUES (38, 3, 6, 20, 41, 0, 1, '2025-10-30 17:07:53', '2025-10-30 17:14:43');
INSERT INTO `sub_material_bom` VALUES (39, 3, 6, 20, 42, 0, 1, '2025-10-30 17:12:29', '2025-10-30 17:14:43');
INSERT INTO `sub_material_bom` VALUES (40, 3, 6, 20, 43, 0, 1, '2025-10-30 17:12:55', '2025-10-30 17:14:43');
INSERT INTO `sub_material_bom` VALUES (41, 3, 6, 20, 44, 0, 1, '2025-10-30 17:13:58', '2025-10-30 17:14:43');

-- ----------------------------
-- Table structure for sub_material_bom_child
-- ----------------------------
DROP TABLE IF EXISTS `sub_material_bom_child`;
CREATE TABLE `sub_material_bom_child`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键ID',
  `material_bom_id` int(11) NOT NULL COMMENT '材料BOM的父表id',
  `material_id` int(11) NOT NULL COMMENT '材料编码ID，关联材料编码表',
  `number` int(20) NULL DEFAULT NULL COMMENT '数量',
  `process_index` int(5) NULL DEFAULT NULL COMMENT '工序下标',
  `is_buy` int(11) NULL DEFAULT 0 COMMENT '是否已采购，0未采购1已采购',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 65 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '材料BOM表子表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_material_bom_child
-- ----------------------------
INSERT INTO `sub_material_bom_child` VALUES (6, 12, 2, 12, 1, 0, '2025-08-13 10:38:41', '2025-10-31 10:23:14');
INSERT INTO `sub_material_bom_child` VALUES (7, 12, 2, 22, 2, 0, '2025-08-13 10:38:41', '2025-10-31 10:23:14');
INSERT INTO `sub_material_bom_child` VALUES (8, 12, 2, 24, 3, 0, '2025-08-13 10:38:41', '2025-10-31 10:23:16');
INSERT INTO `sub_material_bom_child` VALUES (9, 11, 2, 23, 1, 0, '2025-08-13 10:59:47', '2025-10-31 10:23:17');
INSERT INTO `sub_material_bom_child` VALUES (10, 11, 2, 34, 2, 0, '2025-08-13 10:59:47', '2025-10-31 10:23:17');
INSERT INTO `sub_material_bom_child` VALUES (11, 10, 2, 12, 1, 0, '2025-08-13 10:59:52', '2025-10-31 10:23:18');
INSERT INTO `sub_material_bom_child` VALUES (12, 13, 3, 12, 1, 0, '2025-08-13 14:41:35', '2025-10-31 10:22:59');
INSERT INTO `sub_material_bom_child` VALUES (13, 14, 2, 12, 1, 0, '2025-08-13 14:41:55', '2025-10-31 10:22:57');
INSERT INTO `sub_material_bom_child` VALUES (14, 14, 2, 22, 2, 0, '2025-08-13 14:41:55', '2025-10-31 10:23:23');
INSERT INTO `sub_material_bom_child` VALUES (15, 14, 3, 24, 3, 0, '2025-08-13 14:41:55', '2025-10-31 10:23:27');
INSERT INTO `sub_material_bom_child` VALUES (16, 15, 2, 23, 1, 0, '2025-08-13 14:42:03', '2025-10-31 10:22:52');
INSERT INTO `sub_material_bom_child` VALUES (17, 15, 2, 34, 2, 0, '2025-08-13 14:42:03', '2025-10-31 10:22:51');
INSERT INTO `sub_material_bom_child` VALUES (18, 16, 3, 12, 1, 0, '2025-08-21 09:35:05', '2025-10-31 10:22:47');
INSERT INTO `sub_material_bom_child` VALUES (19, 17, 2, 600, 1, 0, '2025-09-25 14:38:28', '2025-10-31 10:22:45');
INSERT INTO `sub_material_bom_child` VALUES (20, 17, 3, 400, 2, 0, '2025-09-25 14:38:28', '2025-10-31 10:22:46');
INSERT INTO `sub_material_bom_child` VALUES (21, 18, 3, 900, 1, 0, '2025-09-25 14:39:31', '2025-10-31 10:22:44');
INSERT INTO `sub_material_bom_child` VALUES (22, 19, 2, 600, 1, 0, '2025-09-25 14:39:45', '2025-10-31 10:22:41');
INSERT INTO `sub_material_bom_child` VALUES (23, 19, 3, 700, 2, 0, '2025-09-25 14:39:45', '2025-10-31 10:22:43');
INSERT INTO `sub_material_bom_child` VALUES (24, 20, 2, 198, 1, 0, '2025-09-25 14:44:26', '2025-10-31 10:22:39');
INSERT INTO `sub_material_bom_child` VALUES (25, 20, 2, 158, 2, 0, '2025-09-25 14:44:26', '2025-10-31 10:22:41');
INSERT INTO `sub_material_bom_child` VALUES (26, 21, 2, 485, 1, 0, '2025-09-25 14:44:36', '2025-10-31 10:22:38');
INSERT INTO `sub_material_bom_child` VALUES (27, 22, 4, 5, 1, 0, '2025-10-18 14:29:06', '2025-10-31 10:22:37');
INSERT INTO `sub_material_bom_child` VALUES (29, 24, 5, 1, 1, 0, '2025-10-18 15:08:30', '2025-10-31 10:22:35');
INSERT INTO `sub_material_bom_child` VALUES (31, 23, 4, 1, 1, 0, '2025-10-19 15:37:50', '2025-10-31 10:22:34');
INSERT INTO `sub_material_bom_child` VALUES (34, 25, 3, 30, 1, 0, '2025-10-21 21:04:49', '2025-10-31 10:22:25');
INSERT INTO `sub_material_bom_child` VALUES (36, 25, 2, 60, 2, 0, '2025-10-21 21:04:49', '2025-10-31 10:22:25');
INSERT INTO `sub_material_bom_child` VALUES (37, 25, 3, 40, 3, 0, '2025-10-21 21:23:26', '2025-10-31 10:22:26');
INSERT INTO `sub_material_bom_child` VALUES (38, 25, 2, 50, 4, 0, '2025-10-21 21:23:26', '2025-10-31 10:22:33');
INSERT INTO `sub_material_bom_child` VALUES (39, 26, 6, 1, 1, 0, '2025-10-30 16:49:20', '2025-10-31 10:22:24');
INSERT INTO `sub_material_bom_child` VALUES (40, 27, 7, 1, 1, 0, '2025-10-30 16:49:58', '2025-10-31 10:22:22');
INSERT INTO `sub_material_bom_child` VALUES (41, 28, 8, 1, 1, 0, '2025-10-30 16:54:25', '2025-10-31 10:22:19');
INSERT INTO `sub_material_bom_child` VALUES (42, 28, 9, 1, 2, 0, '2025-10-30 16:54:25', '2025-10-31 10:22:20');
INSERT INTO `sub_material_bom_child` VALUES (43, 29, 9, 3, 1, 0, '2025-10-30 16:55:14', '2025-10-31 10:22:18');
INSERT INTO `sub_material_bom_child` VALUES (44, 30, 10, 1, 1, 0, '2025-10-30 16:58:07', '2025-10-31 10:22:07');
INSERT INTO `sub_material_bom_child` VALUES (45, 30, 9, 2, 2, 0, '2025-10-30 16:58:07', '2025-10-31 10:22:07');
INSERT INTO `sub_material_bom_child` VALUES (46, 30, 11, 1, 3, 0, '2025-10-30 16:58:07', '2025-10-31 10:22:08');
INSERT INTO `sub_material_bom_child` VALUES (47, 30, 12, 1, 4, 0, '2025-10-30 16:58:07', '2025-10-31 10:22:11');
INSERT INTO `sub_material_bom_child` VALUES (48, 31, 13, 1, 1, 0, '2025-10-30 16:59:47', '2025-10-31 10:22:03');
INSERT INTO `sub_material_bom_child` VALUES (49, 31, 12, 1, 2, 0, '2025-10-30 16:59:47', '2025-10-31 10:22:06');
INSERT INTO `sub_material_bom_child` VALUES (50, 32, 14, 1, 1, 0, '2025-10-30 17:01:11', '2025-10-31 10:22:01');
INSERT INTO `sub_material_bom_child` VALUES (51, 33, 15, 1, 1, 0, '2025-10-30 17:01:55', '2025-10-31 10:22:00');
INSERT INTO `sub_material_bom_child` VALUES (52, 34, 16, 1, 1, 0, '2025-10-30 17:02:54', '2025-10-31 10:21:54');
INSERT INTO `sub_material_bom_child` VALUES (53, 34, 17, 1, 2, 0, '2025-10-30 17:02:54', '2025-10-31 10:22:00');
INSERT INTO `sub_material_bom_child` VALUES (54, 35, 18, 1, 1, 0, '2025-10-30 17:04:53', '2025-10-31 10:21:50');
INSERT INTO `sub_material_bom_child` VALUES (55, 35, 12, 3, 2, 0, '2025-10-30 17:04:53', '2025-10-31 10:21:51');
INSERT INTO `sub_material_bom_child` VALUES (56, 35, 20, 2, 3, 0, '2025-10-30 17:04:53', '2025-10-31 10:21:53');
INSERT INTO `sub_material_bom_child` VALUES (57, 36, 19, 1, 1, 0, '2025-10-30 17:05:52', '2025-10-31 10:21:49');
INSERT INTO `sub_material_bom_child` VALUES (58, 37, 21, 1, 1, 0, '2025-10-30 17:07:19', '2025-10-31 10:21:41');
INSERT INTO `sub_material_bom_child` VALUES (59, 37, 23, 1, 2, 0, '2025-10-30 17:07:19', '2025-10-31 10:21:45');
INSERT INTO `sub_material_bom_child` VALUES (60, 38, 22, 1, 1, 0, '2025-10-30 17:07:53', '2025-10-31 10:21:40');
INSERT INTO `sub_material_bom_child` VALUES (61, 39, 27, 2, 1, 0, '2025-10-30 17:12:29', '2025-10-31 10:21:36');
INSERT INTO `sub_material_bom_child` VALUES (62, 40, 24, 1, 1, 0, '2025-10-30 17:12:55', '2025-10-31 10:21:15');
INSERT INTO `sub_material_bom_child` VALUES (63, 41, 25, 1, 1, 0, '2025-10-30 17:13:58', '2025-10-31 10:18:34');
INSERT INTO `sub_material_bom_child` VALUES (64, 41, 26, 1, 2, 0, '2025-10-30 17:13:58', '2025-10-31 10:18:37');

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
  `model` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '型号',
  `specification` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '规格',
  `other_features` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '其它特性',
  `usage_unit` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '使用单位',
  `purchase_unit` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '采购单位',
  `remarks` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '备注',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '1：未删除；0：已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '记录创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '记录最后更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 28 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '材料编码基础信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_material_code
-- ----------------------------
INSERT INTO `sub_material_code` VALUES (2, 1, 1, '123', '121', '2121', '21', '2121', '21', '21', '21', 1, '2025-07-08 15:36:33', '2025-08-12 10:18:06');
INSERT INTO `sub_material_code` VALUES (3, 1, 1, '789', '555', '5356', '35353', '353', '353', '5353', '353', 1, '2025-08-17 09:38:16', '2025-10-21 14:56:14');
INSERT INTO `sub_material_code` VALUES (4, 6, 3, 'H0101-0089', '车首管', 'JHD-AT-0074*146L', 'JHD-AT-0074*146L', '', 'PCS', 'KG', '', 1, '2025-10-18 05:10:39', '2025-10-27 16:21:45');
INSERT INTO `sub_material_code` VALUES (5, 6, 3, 'H0201-0053', '五通', 'φ43*4.6T*100L JHD-AK-002G偏心铣弧口', 'φ43*4.6T*100L JHD-AK-002G偏心铣弧口', '', 'PCS', 'KG', '', 1, '2025-10-18 14:27:16', '2025-10-27 16:21:38');
INSERT INTO `sub_material_code` VALUES (6, 6, 3, 'M0101-0668', '中管', 'φ40.8*2.2T*410L', 'φ40.8*2.2T*410L', '', 'PCS', 'KG', '', 1, '2025-10-18 14:35:20', '2025-10-27 16:21:23');
INSERT INTO `sub_material_code` VALUES (7, 6, 3, 'M0101-1123', '手提管', 'φ22.2*2.0T*200L', 'φ22.2*2.0T*200L', '', 'PCS', 'KG', '', 1, '2025-10-27 16:17:44', '2025-10-27 16:21:15');
INSERT INTO `sub_material_code` VALUES (8, 6, 3, 'M0101-0565', '下管', 'φ28.6*2.0T*220L', 'φ28.6*2.0T*220L', '', 'PCS', 'KG', '', 1, '2025-10-27 16:19:44', '2025-10-27 16:21:30');
INSERT INTO `sub_material_code` VALUES (9, 6, 3, 'M0103-0015', '过线管', '方27*17*2000L(CM-15114)(成品15L,一分百)', '方27*17*2000L(CM-15114)(成品15L,一分百)', '', 'PCS', 'KG', '', 1, '2025-10-27 16:21:05', '2025-10-27 16:21:05');
INSERT INTO `sub_material_code` VALUES (10, 6, 3, 'M0103-0234', '主梁管', '方121*65*600L', '方121*65*600L', '', 'PCS', 'KG', '', 1, '2025-10-27 16:23:05', '2025-10-27 16:23:05');
INSERT INTO `sub_material_code` VALUES (11, 6, 3, 'H0801-0004', '水壶螺母', 'YD008-044（M4）', 'YD008-044（M4）', '', '个', '盒（50个）', '', 1, '2025-10-27 16:28:28', '2025-10-27 16:28:28');
INSERT INTO `sub_material_code` VALUES (12, 6, 3, 'H0703-0001', '油压线扣', 'YD007-004', 'YD007-004', '', '个', '盒（100个）', '', 1, '2025-10-27 16:29:45', '2025-10-28 10:47:18');
INSERT INTO `sub_material_code` VALUES (13, 6, 3, 'M0101-0635', '后上叉L', 'φ19*2.0T*455L', 'φ19*2.0T*455L', '', 'PCS', 'PCS', '', 1, '2025-10-28 10:43:21', '2025-10-28 10:48:27');
INSERT INTO `sub_material_code` VALUES (14, 6, 3, 'M0101-0636', '后上叉R', 'φ19*2.0T*455L', 'φ19*2.0T*455L', '', 'PCS', 'PCS', '', 1, '2025-10-28 10:44:33', '2025-10-28 10:48:41');
INSERT INTO `sub_material_code` VALUES (15, 6, 3, 'M0101-0019', '上枝杆', 'φ19*1.8T*105L（±1MM)', 'φ19*1.8T*105L（±1MM)', '', 'PCS', 'PCS', '', 1, '2025-10-28 10:45:38', '2025-10-28 10:47:42');
INSERT INTO `sub_material_code` VALUES (16, 6, 3, 'M0101-0020', '下枝杆', 'φ19*1.8T*105L（±1MM)', 'φ19*1.8T*105L（±1MM)', '', 'PCS', 'PCS', '', 1, '2025-10-28 10:46:52', '2025-10-28 10:48:00');
INSERT INTO `sub_material_code` VALUES (17, 6, 3, 'H0801-0001', '硬焊螺母', 'YD008-006 M5*9L普通', 'YD008-006 M5*9L普通', '', '个', '盒（50个）', '', 1, '2025-10-28 10:50:20', '2025-10-28 10:50:20');
INSERT INTO `sub_material_code` VALUES (18, 6, 3, 'M0101-0444', '后下叉R', 'φ22.2*2.0*420L', 'φ22.2*2.0*420L', '', 'PCS', 'PCS', '', 1, '2025-10-28 10:51:34', '2025-10-28 10:51:34');
INSERT INTO `sub_material_code` VALUES (19, 6, 3, 'M0101-0445', '后下叉L', 'φ22.2*2.0*420L', 'φ22.2*2.0*420L', '', 'PCS', 'PCS', '', 1, '2025-10-28 10:52:42', '2025-10-28 10:52:42');
INSERT INTO `sub_material_code` VALUES (20, 6, 3, 'H0702-0001', '止栓', 'YD004-026', 'YD004-026', '', 'PCS', 'PCS', '', 1, '2025-10-28 10:53:46', '2025-10-28 10:53:46');
INSERT INTO `sub_material_code` VALUES (21, 6, 3, 'H0302-0013', '左勾爪', 'YD001-003DS-45度', 'YD001-003DS-45度', '', 'PCS', 'PCS', '', 1, '2025-10-28 11:01:29', '2025-10-28 11:01:29');
INSERT INTO `sub_material_code` VALUES (22, 6, 3, 'H0302-0014', '右勾爪', 'YD001-003DS-45度', 'YD001-003DS-45度', '', 'PCS', 'PCS', '', 1, '2025-10-28 11:02:37', '2025-10-28 11:02:37');
INSERT INTO `sub_material_code` VALUES (23, 6, 3, 'H1202-0012', '边支撑', 'JHD-TC18', 'JHD-TC18', '', 'PCS', 'PCS', '', 1, '2025-10-28 11:03:49', '2025-10-28 11:03:49');
INSERT INTO `sub_material_code` VALUES (24, 6, 3, 'H0401-0036', '折叠器', 'ZHD-DX160-T01/02-Z', 'ZHD-DX160-T01/02-Z', '', 'PCS', 'PCS', '', 1, '2025-10-28 11:05:05', '2025-10-28 11:05:05');
INSERT INTO `sub_material_code` VALUES (25, 6, 3, 'H1102-0099', '加强片', 'JHD-BQ-211', 'JHD-BQ-211', '', 'PCS', 'PCS', '', 1, '2025-10-28 11:06:14', '2025-10-28 11:06:14');
INSERT INTO `sub_material_code` VALUES (26, 6, 3, 'H1201-0001', '支撑棒', 'JS-ZJ-001*120L', 'JS-ZJ-001*120L', '', 'PCS', 'PCS', '', 1, '2025-10-28 11:07:19', '2025-10-28 11:07:19');
INSERT INTO `sub_material_code` VALUES (27, 6, 3, 'H0802-0001', '货架螺母', 'YD008-021 M5', 'YD008-021 M5', '', '个', '盒（50个）', '', 1, '2025-10-30 17:11:30', '2025-10-30 17:11:30');

-- ----------------------------
-- Table structure for sub_material_ment
-- ----------------------------
DROP TABLE IF EXISTS `sub_material_ment`;
CREATE TABLE `sub_material_ment`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键ID',
  `company_id` int(11) NULL DEFAULT NULL COMMENT '企业id',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '发布的用户id',
  `quote_id` int(11) NULL DEFAULT NULL COMMENT '报价单ID',
  `material_bom_id` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '材料BOM ID',
  `print_id` int(30) NULL DEFAULT NULL COMMENT '打印的id',
  `notice_id` int(11) NULL DEFAULT NULL COMMENT '生产订单ID',
  `notice` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生产订单',
  `supplier_id` int(11) NULL DEFAULT NULL COMMENT '供应商ID',
  `supplier_code` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商编码',
  `supplier_abbreviation` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商名称',
  `product_id` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '产品Id',
  `product_code` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '产品编码',
  `product_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '产品名称',
  `material_id` int(11) NULL DEFAULT NULL COMMENT '材料ID',
  `material_code` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '材料编码',
  `material_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '材料名称',
  `model_spec` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '型号&规格',
  `other_features` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '其它特性',
  `unit` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '单位',
  `price` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '单价',
  `order_number` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '预计数量',
  `number` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '实际数量',
  `delivery_time` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '交货时间',
  `apply_id` int(11) NULL DEFAULT NULL COMMENT '申请人ID',
  `apply_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '申请人名称',
  `apply_time` timestamp NULL DEFAULT NULL COMMENT '申请时间',
  `step` int(2) NULL DEFAULT 0 COMMENT '审核当前在第几步，默认0，每审核一步加1',
  `status` int(11) NULL DEFAULT 0 COMMENT '状态（0审批中/1通过/2拒绝）',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '材料采购单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_material_ment
-- ----------------------------
INSERT INTO `sub_material_ment` VALUES (3, 1, 1, NULL, NULL, 15, 6, '2222', 2, '1234', '151', '10', '1233', '212', 3, '789', '555', '535/35353', '353', '353', '2.5', '18000', '18000', '2025-07-07', 1, '我是名字', '2025-09-23 14:54:56', 1, 1, 1, '2025-09-23 14:54:56', '2025-10-24 12:59:26');
INSERT INTO `sub_material_ment` VALUES (4, 1, 1, NULL, NULL, 15, 8, '1122', 2, '1234', '151', '19', 'A001', '圆珠笔', 2, '123', '121', '2121/21', '2121', '21', '2.6', '15000', '15000', '2025-10-31', 1, '我是名字', '2025-09-26 14:03:04', 1, 1, 1, '2025-09-26 14:03:04', '2025-10-24 12:59:29');

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
  `price` int(11) NULL DEFAULT NULL COMMENT '单价',
  `unit` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '采购单位',
  `delivery` int(5) NULL DEFAULT NULL COMMENT '送货方式',
  `packaging` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '包装要求',
  `transaction_currency` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '交易币别',
  `other_transaction_terms` int(5) NULL DEFAULT NULL COMMENT '交易条件',
  `invoice` int(5) NULL DEFAULT NULL COMMENT '税票要求',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '材料报价信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_material_quote
-- ----------------------------
INSERT INTO `sub_material_quote` VALUES (1, 1, 1, 2, 2, 24, NULL, 1111, '1111', '1111', 1111, 1111, 1, '2025-07-27 21:43:20', '2025-09-26 13:28:03');
INSERT INTO `sub_material_quote` VALUES (2, 1, 1, 1, 2, 21, NULL, 2222, '222', '22', 222, 22, 1, '2025-07-27 22:40:03', '2025-09-26 13:41:17');
INSERT INTO `sub_material_quote` VALUES (3, 1, 1, 2, 3, 111, NULL, 515, '2www', '1', 11, 2, 1, '2025-10-23 13:26:53', '2025-11-05 11:55:25');

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_no_encoding
-- ----------------------------

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户操作日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_operation_history
-- ----------------------------

-- ----------------------------
-- Table structure for sub_outsourcing_order
-- ----------------------------
DROP TABLE IF EXISTS `sub_outsourcing_order`;
CREATE TABLE `sub_outsourcing_order`  (
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
  `price` int(11) NULL DEFAULT NULL COMMENT '加工单价',
  `number` int(11) NULL DEFAULT NULL COMMENT '委外数量',
  `transaction_currency` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '交易币别',
  `other_transaction_terms` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '交易条件',
  `ment` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '加工要求',
  `delivery_time` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '要求交期',
  `remarks` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '备注',
  `status` int(1) NULL DEFAULT 0 COMMENT '状态（0审批中/1通过/2拒绝）',
  `apply_id` int(11) NULL DEFAULT NULL COMMENT '申请人ID',
  `apply_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '申请人名称',
  `apply_time` timestamp NULL DEFAULT NULL COMMENT '申请时间',
  `step` int(2) NULL DEFAULT 0 COMMENT '审核当前在第几步，默认0，每审核一步加1',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '委外报价信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_outsourcing_order
-- ----------------------------
INSERT INTO `sub_outsourcing_order` VALUES (11, 1, 1, 16, 8, NULL, 1, 58, 75, '￥', 3, 600, '无1', '无2', '无', '2025-09-30', '无', 1, 1, '我是名字', '2025-09-26 21:29:06', 0, 1, '2025-09-26 14:40:30', '2025-10-24 13:05:23');
INSERT INTO `sub_outsourcing_order` VALUES (12, 1, 1, 16, 8, NULL, 1, 57, 74, '21', 21, 21, '121', '2121', '212', '2025-09-25', '2121', 1, 1, '我是名字', '2025-09-26 21:29:06', 0, 1, '2025-09-26 21:29:06', '2025-10-24 13:05:26');

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
  `other_transaction_terms` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '交易条件',
  `ment` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '加工要求',
  `remarks` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '备注',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '委外报价信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_outsourcing_quote
-- ----------------------------
INSERT INTO `sub_outsourcing_quote` VALUES (5, 1, 1, 8, 1, 57, '73', '3', 3, 15000, '￥', '无', NULL, '', 1, '2025-09-26 14:07:56', '2025-09-26 14:28:40');
INSERT INTO `sub_outsourcing_quote` VALUES (6, 3, 6, 9, 3, 76, '77', '2', 1, 800, '人民币', '现金', NULL, '', 1, '2025-10-19 16:43:13', '2025-10-31 09:00:05');
INSERT INTO `sub_outsourcing_quote` VALUES (8, 1, 1, 8, 2, 57, '74', '2.5', 3, 15000, '2121', '313131', NULL, '', 1, '2025-10-23 13:42:18', '2025-10-23 13:42:18');
INSERT INTO `sub_outsourcing_quote` VALUES (9, 3, 6, 9, 4, 78, '78', '2.1', 2, 800, '人民币', '现金', NULL, '', 1, '2025-10-24 11:44:48', '2025-10-31 09:17:55');

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
INSERT INTO `sub_part_code` VALUES (5, 1, 1, 'C002', '笔芯', '212', '1212', '121', '3131', '3131', '3131', 1, '2025-07-08 15:35:24', '2025-08-21 15:46:13');
INSERT INTO `sub_part_code` VALUES (6, 1, 1, 'C001', '笔筒', '12', '1212', '1', '3131', '2121', '2121', 1, '2025-07-08 15:36:15', '2025-08-21 15:45:21');
INSERT INTO `sub_part_code` VALUES (7, 1, 1, '1234', '2124', '212', '1212', '121', '3131', '3131', '3131', 1, '2025-07-08 15:35:24', '2025-08-08 11:14:41');
INSERT INTO `sub_part_code` VALUES (8, 1, 1, '1238', '2128', '212', '1212', '121', '3131', '3131', '3131', 1, '2025-07-08 15:35:24', '2025-08-08 11:14:38');
INSERT INTO `sub_part_code` VALUES (9, 1, 1, '12310', '21210', '212', '1212', '121', '3131', '3131', '3131', 1, '2025-07-08 15:35:24', '2025-08-08 11:14:44');
INSERT INTO `sub_part_code` VALUES (10, 1, 1, '12311', '21211', '212', '1212', '121', '3131', '3131', '3131', 1, '2025-07-08 15:35:24', '2025-08-08 11:14:48');
INSERT INTO `sub_part_code` VALUES (12, 1, 1, '12312', '21212', '212', '1212', '121', '3131', '3131', '3131', 1, '2025-07-08 15:35:24', '2025-08-08 11:14:51');
INSERT INTO `sub_part_code` VALUES (13, 1, 1, '12313', '21213', '212', '1212', '121', '3131', '3131', '3131', 1, '2025-07-08 15:35:24', '2025-07-08 15:35:24');
INSERT INTO `sub_part_code` VALUES (14, 1, 1, '12314', '21214', '212', '1212', '121', '3131', '3131', '3131', 1, '2025-07-08 15:35:24', '2025-07-08 15:35:24');
INSERT INTO `sub_part_code` VALUES (15, 1, 1, '12315', '21215', '212', '1212', '121', '3131', '3131', '3131', 1, '2025-07-08 15:35:24', '2025-07-08 15:35:24');
INSERT INTO `sub_part_code` VALUES (16, 1, 1, '12316', '21216', '212', '1212', '121', '3131', '3131', '3131', 1, '2025-07-08 15:35:24', '2025-07-08 15:35:24');
INSERT INTO `sub_part_code` VALUES (17, 1, 1, '12317', '21217', '212', '1212', '121', '3131', '3131', '3131', 1, '2025-07-08 15:35:24', '2025-08-08 11:16:00');
INSERT INTO `sub_part_code` VALUES (18, 1, 1, '12318', '21218', '212', '1212', '121', '3131', '3131', '3131', 1, '2025-07-08 15:35:24', '2025-07-08 15:35:24');
INSERT INTO `sub_part_code` VALUES (19, 1, 1, '12319', '21219', '212', '1212', '121', '3131', '3131', '3131', 1, '2025-07-08 15:35:24', '2025-07-08 15:35:24');
INSERT INTO `sub_part_code` VALUES (20, 1, 1, '12320', '21220', '212', '1212', '121', '3131', '3131', '3131', 1, '2025-07-08 15:35:24', '2025-07-08 15:35:24');
INSERT INTO `sub_part_code` VALUES (21, 6, 3, 'X001', '车首管', '', '', '', 'PCS', '', '', 1, '2025-10-18 04:59:23', '2025-10-27 14:54:38');
INSERT INTO `sub_part_code` VALUES (22, 6, 3, 'X002', '主梁管', '', '', '', 'PCS', '', '', 1, '2025-10-18 15:07:26', '2025-10-27 14:54:57');
INSERT INTO `sub_part_code` VALUES (23, 6, 3, 'X003', '辅助管', '', '', '', 'PCS', '', '', 1, '2025-10-27 14:58:25', '2025-10-27 14:58:25');
INSERT INTO `sub_part_code` VALUES (24, 6, 3, 'X004', '上管', '', '', '', 'PCS', '', '', 1, '2025-10-27 15:03:56', '2025-10-27 15:03:56');
INSERT INTO `sub_part_code` VALUES (25, 6, 3, 'X005', '下管', '', '', '', 'PCS', '', '', 1, '2025-10-27 15:04:18', '2025-10-27 15:04:18');
INSERT INTO `sub_part_code` VALUES (26, 6, 3, 'X006', '座管', '', '', '', 'PCS', '', '', 1, '2025-10-27 15:04:59', '2025-10-27 15:04:59');
INSERT INTO `sub_part_code` VALUES (27, 6, 3, 'X007', '五通', 'X', 'X', '', 'PCS', '', '', 1, '2025-10-27 15:06:48', '2025-10-30 16:46:24');
INSERT INTO `sub_part_code` VALUES (28, 6, 3, 'X008', '后上叉R', '', '', '', 'PCS', '', '', 1, '2025-10-27 15:07:21', '2025-10-27 15:07:21');
INSERT INTO `sub_part_code` VALUES (29, 6, 3, 'X009', '后上叉L', '', '', '', 'PCS', '', '', 1, '2025-10-27 15:11:47', '2025-10-27 15:11:47');
INSERT INTO `sub_part_code` VALUES (30, 6, 3, 'X010', '后下叉R', '', '', '', 'PCS', '', '', 1, '2025-10-27 15:12:39', '2025-10-27 15:12:39');
INSERT INTO `sub_part_code` VALUES (31, 6, 3, 'X011', '后下叉L', '', '', '', 'PCS', '', '', 1, '2025-10-27 15:12:57', '2025-10-27 15:12:57');
INSERT INTO `sub_part_code` VALUES (32, 6, 3, 'X012', '电池盒板', '', '', '', 'PCS', '', '', 1, '2025-10-27 15:23:24', '2025-10-27 15:23:24');
INSERT INTO `sub_part_code` VALUES (33, 6, 3, 'X013', '手提管', '', '', '', 'PCS', '', '', 1, '2025-10-27 15:23:45', '2025-10-27 15:23:45');
INSERT INTO `sub_part_code` VALUES (34, 6, 3, 'X014', '中管', '', '', '', 'PCS', '', '', 1, '2025-10-27 15:24:25', '2025-10-27 15:24:25');
INSERT INTO `sub_part_code` VALUES (35, 6, 3, 'X015', '上支杆', '', '', '', 'PCS', '', '', 1, '2025-10-27 15:24:50', '2025-10-27 15:26:02');
INSERT INTO `sub_part_code` VALUES (36, 6, 3, 'X016', '下枝杆', '', '', '', 'PCS', '', '', 1, '2025-10-27 15:25:37', '2025-10-27 15:26:12');
INSERT INTO `sub_part_code` VALUES (37, 6, 3, 'X017', '下叉', '', '', '', 'PCS', '', '', 1, '2025-10-27 15:27:35', '2025-10-27 15:27:35');
INSERT INTO `sub_part_code` VALUES (38, 6, 3, 'X018', '过线管', '', '', '', 'PCS', '', '', 1, '2025-10-27 15:27:59', '2025-10-27 15:27:59');
INSERT INTO `sub_part_code` VALUES (39, 6, 3, 'X019', '上叉', '', '', '', 'PCS', '', '', 1, '2025-10-27 15:28:29', '2025-10-27 15:28:29');
INSERT INTO `sub_part_code` VALUES (40, 6, 3, 'Y001', '左钩爪', '', '', '', 'PCS', '', '', 1, '2025-10-27 15:28:56', '2025-10-27 15:28:56');
INSERT INTO `sub_part_code` VALUES (41, 6, 3, 'Y002', '右钩爪', '', '', '', 'PCS', '', '', 1, '2025-10-27 15:29:16', '2025-10-27 15:29:16');
INSERT INTO `sub_part_code` VALUES (42, 6, 3, 'Y003', '上叉支杆', '', '', '', 'PCS', '', '', 1, '2025-10-27 15:30:11', '2025-10-27 15:30:11');
INSERT INTO `sub_part_code` VALUES (43, 6, 3, 'Y004', '组立折叠器', '', '', '', 'PCS', '', '', 1, '2025-10-27 15:30:34', '2025-10-27 15:30:34');
INSERT INTO `sub_part_code` VALUES (44, 6, 3, 'Y005', '组立前三角', '', '', '', 'PCS', '', '', 1, '2025-10-27 15:31:01', '2025-10-27 15:31:01');
INSERT INTO `sub_part_code` VALUES (45, 6, 3, 'Y006', '组立后三角', '', '', '', 'PCS', '', '', 1, '2025-10-27 15:31:21', '2025-10-27 15:31:21');
INSERT INTO `sub_part_code` VALUES (46, 6, 3, 'Z001', '成品车架', '', '', '', 'PCS', '', '', 1, '2025-10-27 15:32:05', '2025-10-27 15:32:05');
INSERT INTO `sub_part_code` VALUES (47, 6, 3, 'Z002', '前三角', '', '', '', 'PCS', '', '', 1, '2025-10-27 15:32:27', '2025-10-27 15:32:27');
INSERT INTO `sub_part_code` VALUES (48, 6, 3, 'Z003', '后三角', '', '', '', 'PCS', '', '', 1, '2025-10-27 15:32:48', '2025-10-27 15:32:48');
INSERT INTO `sub_part_code` VALUES (49, 6, 3, 'Z004', '上叉支杆', '', '', '', 'PCS', '', '', 1, '2025-10-27 15:33:10', '2025-10-27 15:33:10');
INSERT INTO `sub_part_code` VALUES (50, 6, 3, '019', 'X', '', '', '', 'X', '', '', 0, '2025-10-27 16:31:42', '2025-10-27 16:32:05');
INSERT INTO `sub_part_code` VALUES (51, 6, 3, 'X020', 'X', '', '', '', 'X', '', '', 1, '2025-10-27 16:33:25', '2025-10-27 16:33:42');

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
) ENGINE = InnoDB AUTO_INCREMENT = 83 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '工艺BOM表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_process_bom
-- ----------------------------
INSERT INTO `sub_process_bom` VALUES (56, 1, 1, NULL, NULL, 19, 8, 0, 0, 1, '2025-09-24 15:58:17', '2025-09-24 16:03:21');
INSERT INTO `sub_process_bom` VALUES (57, 1, 1, NULL, NULL, 14, 12, 0, 0, 1, '2025-09-25 14:50:12', '2025-09-25 14:51:59');
INSERT INTO `sub_process_bom` VALUES (58, 1, 1, NULL, NULL, 14, 8, 0, 0, 1, '2025-09-25 14:51:50', '2025-09-25 14:51:59');
INSERT INTO `sub_process_bom` VALUES (59, 3, 6, NULL, NULL, 20, 21, 0, 0, 1, '2025-10-19 15:45:17', '2025-10-30 19:21:18');
INSERT INTO `sub_process_bom` VALUES (60, 3, 6, NULL, NULL, 20, 27, 0, 0, 1, '2025-10-19 15:49:23', '2025-10-30 20:00:52');
INSERT INTO `sub_process_bom` VALUES (61, 1, 1, NULL, NULL, 14, 8, 0, 1, 1, '2025-10-21 21:32:41', '2025-10-21 21:35:24');
INSERT INTO `sub_process_bom` VALUES (62, 3, 6, NULL, NULL, 20, 21, 0, 1, 0, '2025-10-29 09:46:29', '2025-10-30 19:10:28');
INSERT INTO `sub_process_bom` VALUES (63, 3, 6, NULL, NULL, 20, 34, 0, 0, 1, '2025-10-30 20:02:25', '2025-10-30 20:13:35');
INSERT INTO `sub_process_bom` VALUES (64, 3, 6, NULL, NULL, 20, 33, 0, 0, 1, '2025-10-30 20:16:04', '2025-10-30 21:46:26');
INSERT INTO `sub_process_bom` VALUES (65, 3, 6, NULL, NULL, 20, 25, 0, 0, 1, '2025-10-30 20:31:48', '2025-10-30 20:36:48');
INSERT INTO `sub_process_bom` VALUES (66, 3, 6, NULL, NULL, 20, 38, 0, 0, 1, '2025-10-30 21:48:54', '2025-10-30 21:49:47');
INSERT INTO `sub_process_bom` VALUES (67, 3, 6, NULL, NULL, 20, 22, 0, 0, 1, '2025-10-30 22:03:52', '2025-10-30 22:16:36');
INSERT INTO `sub_process_bom` VALUES (68, 3, 6, NULL, NULL, 20, 29, 0, 0, 1, '2025-10-30 22:21:18', '2025-10-30 22:26:39');
INSERT INTO `sub_process_bom` VALUES (69, 3, 6, NULL, NULL, 20, 28, 0, 0, 1, '2025-10-30 22:30:01', '2025-10-30 22:30:50');
INSERT INTO `sub_process_bom` VALUES (70, 3, 6, NULL, NULL, 20, 35, 0, 0, 1, '2025-10-30 22:32:06', '2025-10-30 22:40:20');
INSERT INTO `sub_process_bom` VALUES (71, 3, 6, NULL, NULL, 20, 36, 0, 0, 1, '2025-10-30 22:55:21', '2025-10-30 22:55:36');
INSERT INTO `sub_process_bom` VALUES (72, 3, 6, NULL, NULL, 20, 39, 0, 0, 1, '2025-10-30 22:56:45', '2025-10-30 23:00:10');
INSERT INTO `sub_process_bom` VALUES (73, 3, 6, NULL, NULL, 20, 30, 0, 0, 1, '2025-10-30 23:01:17', '2025-10-30 23:05:47');
INSERT INTO `sub_process_bom` VALUES (74, 3, 6, NULL, NULL, 20, 31, 0, 0, 1, '2025-10-30 23:06:50', '2025-10-30 23:14:31');
INSERT INTO `sub_process_bom` VALUES (75, 3, 6, NULL, NULL, 20, 37, 0, 0, 1, '2025-10-30 23:16:29', '2025-10-30 23:18:34');
INSERT INTO `sub_process_bom` VALUES (76, 3, 6, NULL, NULL, 20, 40, 0, 0, 1, '2025-10-30 23:24:51', '2025-10-30 23:25:07');
INSERT INTO `sub_process_bom` VALUES (77, 3, 6, NULL, NULL, 20, 41, 0, 0, 1, '2025-10-30 23:28:36', '2025-10-30 23:31:42');
INSERT INTO `sub_process_bom` VALUES (78, 3, 6, NULL, NULL, 20, 42, 0, 0, 1, '2025-10-30 23:30:00', '2025-10-30 23:31:42');
INSERT INTO `sub_process_bom` VALUES (79, 3, 6, NULL, NULL, 20, 43, 0, 0, 1, '2025-10-30 23:35:15', '2025-10-30 23:38:06');
INSERT INTO `sub_process_bom` VALUES (80, 3, 6, NULL, NULL, 20, 44, 0, 0, 1, '2025-10-30 23:36:27', '2025-10-30 23:38:06');
INSERT INTO `sub_process_bom` VALUES (81, 3, 6, NULL, NULL, 20, 45, 0, 0, 1, '2025-10-30 23:37:56', '2025-10-30 23:38:06');
INSERT INTO `sub_process_bom` VALUES (82, 3, 6, NULL, NULL, 20, 46, 0, 0, 1, '2025-10-30 23:50:10', '2025-10-30 23:50:29');

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
  `qr_code` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '二维码',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 203 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '工艺BOM表子表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_process_bom_child
-- ----------------------------
INSERT INTO `sub_process_bom_child` VALUES (71, 1, '1122', 8, 56, 5, 4, 1, 8, 2.00, NULL, 'http://cdn.yuanfangzixun.com.cn/qrcodes/7e081466-1421-4fcb-ad52-2164378ceb55.png', '2025-09-24 15:58:17', '2025-11-05 14:38:30');
INSERT INTO `sub_process_bom_child` VALUES (72, 1, '1122', 8, 56, 6, 3, 2, 9, 2.00, NULL, 'http://cdn.yuanfangzixun.com.cn/qrcodes/363b2db6-40f9-4d98-b7aa-9dc97b33327a.png', '2025-09-24 15:58:17', '2025-11-05 14:38:16');
INSERT INTO `sub_process_bom_child` VALUES (73, NULL, NULL, NULL, 57, 5, 5, 1, 8, 2.00, NULL, 'http://cdn.yuanfangzixun.com.cn/qrcodes/478e261e-327e-41b5-ab9b-6e5840980e00.png', '2025-09-25 14:50:12', '2025-09-25 14:50:12');
INSERT INTO `sub_process_bom_child` VALUES (74, NULL, NULL, NULL, 57, 6, 5, 2, 6, 8.00, NULL, 'http://cdn.yuanfangzixun.com.cn/qrcodes/d48ac941-c764-49a3-9914-cc6cf9af32e6.png', '2025-09-25 14:50:12', '2025-09-25 14:50:12');
INSERT INTO `sub_process_bom_child` VALUES (75, NULL, NULL, NULL, 58, 5, 4, 1, 6, 8.00, NULL, 'http://cdn.yuanfangzixun.com.cn/qrcodes/dc9ac27b-7a9b-4f7f-8ce2-89094ae5ca61.png', '2025-09-25 14:51:50', '2025-09-25 14:51:50');
INSERT INTO `sub_process_bom_child` VALUES (77, 3, 'DD-A2510001', 9, 60, 8, 7, 1, 4, 0.05, '1', 'http://cdn.yuanfangzixun.com.cn/qrcodes/691c887e-3de0-4afe-8b32-4e121625955b.png', '2025-10-19 15:49:23', '2025-11-05 14:38:16');
INSERT INTO `sub_process_bom_child` VALUES (78, 3, 'DD-A2510001', 9, 60, 8, 7, 2, 4, 0.05, '1', 'http://cdn.yuanfangzixun.com.cn/qrcodes/d8f387be-9b3e-45bf-9664-acb8efd1621e.png', '2025-10-19 15:49:23', '2025-11-05 14:38:16');
INSERT INTO `sub_process_bom_child` VALUES (79, NULL, NULL, NULL, 61, 5, 4, 4, 8, 8.00, NULL, NULL, '2025-10-21 21:32:41', '2025-10-21 21:35:24');
INSERT INTO `sub_process_bom_child` VALUES (80, NULL, NULL, NULL, 61, 6, 3, 1, 7, 7.00, NULL, NULL, '2025-10-21 21:34:41', '2025-10-21 21:35:04');
INSERT INTO `sub_process_bom_child` VALUES (81, NULL, NULL, NULL, 61, 5, 5, 2, 6, 6.00, NULL, NULL, '2025-10-21 21:34:41', '2025-10-21 21:35:04');
INSERT INTO `sub_process_bom_child` VALUES (83, NULL, NULL, NULL, 61, 5, 3, 3, 4, 4.00, NULL, NULL, '2025-10-21 21:34:41', '2025-10-21 21:35:24');
INSERT INTO `sub_process_bom_child` VALUES (85, NULL, NULL, NULL, 61, 5, 3, 5, 9, 9.00, NULL, NULL, '2025-10-21 21:35:24', '2025-10-21 21:35:24');
INSERT INTO `sub_process_bom_child` VALUES (86, 3, 'DD-A2510001', 9, 59, 7, 6, 1, 5, 0.18, '1', NULL, '2025-10-22 14:22:50', '2025-11-05 14:38:16');
INSERT INTO `sub_process_bom_child` VALUES (87, NULL, NULL, NULL, 62, 7, 6, 1, 3, 0.00, '1', 'http://cdn.yuanfangzixun.com.cn/qrcodes/6916e3f8-ff22-4d00-85ca-df7f952ae963.png', '2025-10-29 09:46:29', '2025-10-29 09:46:30');
INSERT INTO `sub_process_bom_child` VALUES (88, 3, 'DD-A2510001', 9, 60, 8, 7, 3, 4, 0.05, '1', NULL, '2025-10-30 20:00:52', '2025-11-05 14:38:16');
INSERT INTO `sub_process_bom_child` VALUES (89, 3, 'DD-A2510001', 9, 60, 8, 7, 4, 4, 0.05, '1', NULL, '2025-10-30 20:00:52', '2025-11-05 14:38:17');
INSERT INTO `sub_process_bom_child` VALUES (92, 3, 'DD-A2510001', 9, 63, 9, 8, 3, 5, 0.05, '1', NULL, '2025-10-30 20:02:25', '2025-11-05 14:38:17');
INSERT INTO `sub_process_bom_child` VALUES (93, 3, 'DD-A2510001', 9, 63, 9, 8, 4, 5, 0.05, '1', NULL, '2025-10-30 20:02:25', '2025-11-05 14:38:17');
INSERT INTO `sub_process_bom_child` VALUES (94, 3, 'DD-A2510001', 9, 63, 9, 8, 1, 5, 0.05, '1', NULL, '2025-10-30 20:02:25', '2025-11-05 14:38:17');
INSERT INTO `sub_process_bom_child` VALUES (95, 3, 'DD-A2510001', 9, 63, 9, 8, 2, 5, 0.05, '1', NULL, '2025-10-30 20:02:25', '2025-11-05 14:38:17');
INSERT INTO `sub_process_bom_child` VALUES (96, 3, 'DD-A2510001', 9, 63, 12, 10, 5, 5, 0.08, '1', NULL, '2025-10-30 20:13:30', '2025-11-05 14:38:17');
INSERT INTO `sub_process_bom_child` VALUES (97, 3, 'DD-A2510001', 9, 63, 39, 47, 6, 15, 0.10, '1', NULL, '2025-10-30 20:13:30', '2025-11-05 14:38:17');
INSERT INTO `sub_process_bom_child` VALUES (102, 3, 'DD-A2510001', 9, 64, 11, 7, 2, 8, 0.08, '1', NULL, '2025-10-30 20:16:04', '2025-11-05 14:38:17');
INSERT INTO `sub_process_bom_child` VALUES (103, 3, 'DD-A2510001', 9, 64, 13, 11, 4, 8, 0.07, '1', NULL, '2025-10-30 20:16:04', '2025-11-05 14:38:17');
INSERT INTO `sub_process_bom_child` VALUES (104, 3, 'DD-A2510001', 9, 64, 13, 11, 5, 8, 0.08, '1', NULL, '2025-10-30 20:16:04', '2025-11-05 14:38:17');
INSERT INTO `sub_process_bom_child` VALUES (105, 3, 'DD-A2510001', 9, 64, 39, 47, 1, 15, 0.05, '1', NULL, '2025-10-30 20:16:04', '2025-11-05 14:38:17');
INSERT INTO `sub_process_bom_child` VALUES (106, 3, 'DD-A2510001', 9, 64, 12, 10, 3, 5, 0.07, '1', NULL, '2025-10-30 20:21:41', '2025-11-05 14:38:17');
INSERT INTO `sub_process_bom_child` VALUES (111, 3, 'DD-A2510001', 9, 65, 39, 47, 1, 60, 0.07, '1', NULL, '2025-10-30 20:31:48', '2025-11-05 14:38:17');
INSERT INTO `sub_process_bom_child` VALUES (112, 3, 'DD-A2510001', 9, 65, 13, 11, 3, 10, 0.08, '1', NULL, '2025-10-30 20:31:48', '2025-11-05 14:38:17');
INSERT INTO `sub_process_bom_child` VALUES (113, 3, 'DD-A2510001', 9, 65, 13, 11, 4, 10, 0.08, '1', NULL, '2025-10-30 20:31:48', '2025-11-05 14:38:17');
INSERT INTO `sub_process_bom_child` VALUES (114, 3, 'DD-A2510001', 9, 65, 29, 22, 5, 20, 0.35, '1', NULL, '2025-10-30 20:31:48', '2025-11-05 14:38:17');
INSERT INTO `sub_process_bom_child` VALUES (115, 3, 'DD-A2510001', 9, 65, 12, 10, 2, 8, 0.07, '1', NULL, '2025-10-30 20:31:48', '2025-11-05 14:38:17');
INSERT INTO `sub_process_bom_child` VALUES (116, 3, 'DD-A2510001', 9, 66, 13, 11, 1, 5, 0.08, '1', NULL, '2025-10-30 21:48:54', '2025-11-05 14:38:17');
INSERT INTO `sub_process_bom_child` VALUES (117, 3, 'DD-A2510001', 9, 67, 13, 11, 2, 8, 0.08, '1', NULL, '2025-10-30 22:03:52', '2025-11-05 14:38:17');
INSERT INTO `sub_process_bom_child` VALUES (118, 3, 'DD-A2510001', 9, 67, 12, 10, 4, 5, 0.08, '1', NULL, '2025-10-30 22:03:52', '2025-11-05 14:38:17');
INSERT INTO `sub_process_bom_child` VALUES (119, 3, 'DD-A2510001', 9, 67, 12, 10, 6, 5, 0.07, '1', NULL, '2025-10-30 22:03:52', '2025-11-05 14:38:17');
INSERT INTO `sub_process_bom_child` VALUES (120, 3, 'DD-A2510001', 9, 67, 13, 11, 1, 8, 0.08, '1', NULL, '2025-10-30 22:03:52', '2025-11-05 14:38:17');
INSERT INTO `sub_process_bom_child` VALUES (121, 3, 'DD-A2510001', 9, 67, 12, 10, 3, 5, 0.08, '1', NULL, '2025-10-30 22:03:52', '2025-11-05 14:38:17');
INSERT INTO `sub_process_bom_child` VALUES (122, 3, 'DD-A2510001', 9, 67, 12, 10, 5, 5, 0.08, '1', NULL, '2025-10-30 22:03:52', '2025-11-05 14:38:17');
INSERT INTO `sub_process_bom_child` VALUES (123, 3, 'DD-A2510001', 9, 67, 12, 10, 7, 5, 0.03, '1', NULL, '2025-10-30 22:16:36', '2025-11-05 14:38:17');
INSERT INTO `sub_process_bom_child` VALUES (124, 3, 'DD-A2510001', 9, 67, 28, 47, 8, 5, 0.04, '1', NULL, '2025-10-30 22:16:36', '2025-11-05 14:38:17');
INSERT INTO `sub_process_bom_child` VALUES (125, 3, 'DD-A2510001', 9, 67, 15, 11, 9, 10, 0.04, '1', NULL, '2025-10-30 22:16:36', '2025-11-05 14:38:17');
INSERT INTO `sub_process_bom_child` VALUES (126, 3, 'DD-A2510001', 9, 67, 16, 8, 10, 15, 0.05, '1', NULL, '2025-10-30 22:16:36', '2025-11-05 14:38:17');
INSERT INTO `sub_process_bom_child` VALUES (127, 3, 'DD-A2510001', 9, 67, 30, 8, 11, 8, 0.04, '1', NULL, '2025-10-30 22:16:36', '2025-11-05 14:38:17');
INSERT INTO `sub_process_bom_child` VALUES (128, 3, 'DD-A2510001', 9, 67, 39, 47, 12, 8, 0.04, '1', NULL, '2025-10-30 22:16:36', '2025-11-05 14:38:17');
INSERT INTO `sub_process_bom_child` VALUES (129, 3, 'DD-A2510001', 9, 67, 29, 22, 13, 8, 0.05, '1', NULL, '2025-10-30 22:16:36', '2025-11-05 14:38:17');
INSERT INTO `sub_process_bom_child` VALUES (130, 3, 'DD-A2510001', 9, 67, 29, 22, 14, 15, 0.06, '1', NULL, '2025-10-30 22:16:36', '2025-11-05 14:38:17');
INSERT INTO `sub_process_bom_child` VALUES (137, 3, 'DD-A2510001', 9, 68, 13, 11, 6, 10, 0.08, '1', NULL, '2025-10-30 22:21:18', '2025-11-05 14:38:17');
INSERT INTO `sub_process_bom_child` VALUES (138, 3, 'DD-A2510001', 9, 68, 18, 13, 2, 8, 0.07, '1', NULL, '2025-10-30 22:21:18', '2025-11-05 14:38:17');
INSERT INTO `sub_process_bom_child` VALUES (139, 3, 'DD-A2510001', 9, 68, 30, 8, 4, 5, 0.05, '1', NULL, '2025-10-30 22:21:18', '2025-11-05 14:38:18');
INSERT INTO `sub_process_bom_child` VALUES (140, 3, 'DD-A2510001', 9, 68, 11, 7, 5, 8, 0.07, '1', NULL, '2025-10-30 22:21:18', '2025-11-05 14:38:18');
INSERT INTO `sub_process_bom_child` VALUES (141, 3, 'DD-A2510001', 9, 68, 39, 47, 1, 10, 0.04, '1', NULL, '2025-10-30 22:21:18', '2025-11-05 14:38:18');
INSERT INTO `sub_process_bom_child` VALUES (142, 3, 'DD-A2510001', 9, 68, 28, 47, 3, 10, 0.10, '1', NULL, '2025-10-30 22:21:18', '2025-11-05 14:38:18');
INSERT INTO `sub_process_bom_child` VALUES (143, 3, 'DD-A2510001', 9, 69, 13, 11, 2, 10, 0.08, '1', NULL, '2025-10-30 22:30:01', '2025-11-05 14:38:18');
INSERT INTO `sub_process_bom_child` VALUES (144, 3, 'DD-A2510001', 9, 69, 18, 13, 4, 8, 0.07, '1', NULL, '2025-10-30 22:30:01', '2025-11-05 14:38:18');
INSERT INTO `sub_process_bom_child` VALUES (145, 3, 'DD-A2510001', 9, 69, 30, 8, 6, 5, 0.05, '1', NULL, '2025-10-30 22:30:01', '2025-11-05 14:38:18');
INSERT INTO `sub_process_bom_child` VALUES (146, 3, 'DD-A2510001', 9, 69, 11, 7, 1, 8, 0.07, '1', NULL, '2025-10-30 22:30:01', '2025-11-05 14:38:18');
INSERT INTO `sub_process_bom_child` VALUES (147, 3, 'DD-A2510001', 9, 69, 39, 47, 3, 10, 0.04, '1', NULL, '2025-10-30 22:30:01', '2025-11-05 14:38:18');
INSERT INTO `sub_process_bom_child` VALUES (148, 3, 'DD-A2510001', 9, 69, 28, 47, 5, 10, 0.10, '1', NULL, '2025-10-30 22:30:01', '2025-11-05 14:38:18');
INSERT INTO `sub_process_bom_child` VALUES (149, 3, 'DD-A2510001', 9, 70, 30, 8, 2, 5, 0.05, '1', NULL, '2025-10-30 22:32:06', '2025-11-05 14:38:18');
INSERT INTO `sub_process_bom_child` VALUES (150, 3, 'DD-A2510001', 9, 70, 12, 10, 4, 5, 0.07, '1', NULL, '2025-10-30 22:32:06', '2025-11-05 14:38:18');
INSERT INTO `sub_process_bom_child` VALUES (151, 3, 'DD-A2510001', 9, 70, 12, 10, 5, 5, 0.08, '1', NULL, '2025-10-30 22:32:06', '2025-11-05 14:38:18');
INSERT INTO `sub_process_bom_child` VALUES (152, 3, 'DD-A2510001', 9, 70, 8, 7, 1, 5, 0.08, '1', NULL, '2025-10-30 22:32:06', '2025-11-05 14:38:18');
INSERT INTO `sub_process_bom_child` VALUES (153, 3, 'DD-A2510001', 9, 70, 39, 47, 3, 10, 0.10, '1', NULL, '2025-10-30 22:32:06', '2025-11-05 14:38:18');
INSERT INTO `sub_process_bom_child` VALUES (154, 3, 'DD-A2510001', 9, 71, 30, 8, 4, 5, 0.05, '1', NULL, '2025-10-30 22:55:21', '2025-11-05 14:38:18');
INSERT INTO `sub_process_bom_child` VALUES (155, 3, 'DD-A2510001', 9, 71, 12, 10, 1, 5, 0.07, '1', NULL, '2025-10-30 22:55:21', '2025-11-05 14:38:18');
INSERT INTO `sub_process_bom_child` VALUES (156, 3, 'DD-A2510001', 9, 71, 12, 10, 2, 5, 0.08, '1', NULL, '2025-10-30 22:55:21', '2025-11-05 14:38:18');
INSERT INTO `sub_process_bom_child` VALUES (157, 3, 'DD-A2510001', 9, 71, 8, 7, 3, 5, 0.08, '1', NULL, '2025-10-30 22:55:21', '2025-11-05 14:38:18');
INSERT INTO `sub_process_bom_child` VALUES (158, 3, 'DD-A2510001', 9, 71, 39, 47, 5, 10, 0.10, '1', NULL, '2025-10-30 22:55:21', '2025-11-05 14:38:18');
INSERT INTO `sub_process_bom_child` VALUES (159, 3, 'DD-A2510001', 9, 72, 39, 47, 2, 10, 0.04, '1', NULL, '2025-10-30 22:56:45', '2025-11-05 14:38:18');
INSERT INTO `sub_process_bom_child` VALUES (160, 3, 'DD-A2510001', 9, 72, 29, 22, 3, 15, 0.35, '1', NULL, '2025-10-30 22:56:45', '2025-11-05 14:38:18');
INSERT INTO `sub_process_bom_child` VALUES (162, 3, 'DD-A2510001', 9, 72, 25, 18, 1, 20, 0.18, '1', NULL, '2025-10-30 22:56:45', '2025-11-05 14:38:18');
INSERT INTO `sub_process_bom_child` VALUES (163, 3, 'DD-A2510001', 9, 73, 30, 8, 4, 5, 0.05, '1', NULL, '2025-10-30 23:01:17', '2025-11-05 14:38:18');
INSERT INTO `sub_process_bom_child` VALUES (164, 3, 'DD-A2510001', 9, 73, 11, 7, 6, 5, 0.07, '1', NULL, '2025-10-30 23:01:17', '2025-11-05 14:38:18');
INSERT INTO `sub_process_bom_child` VALUES (165, 3, 'DD-A2510001', 9, 73, 11, 7, 2, 5, 0.05, '1', NULL, '2025-10-30 23:01:17', '2025-11-05 14:38:18');
INSERT INTO `sub_process_bom_child` VALUES (166, 3, 'DD-A2510001', 9, 73, 18, 13, 3, 8, 0.07, '1', NULL, '2025-10-30 23:01:17', '2025-11-05 14:38:18');
INSERT INTO `sub_process_bom_child` VALUES (167, 3, 'DD-A2510001', 9, 73, 20, 7, 5, 5, 0.07, '1', NULL, '2025-10-30 23:01:17', '2025-11-05 14:38:18');
INSERT INTO `sub_process_bom_child` VALUES (168, 3, 'DD-A2510001', 9, 73, 39, 47, 1, 10, 0.04, '1', NULL, '2025-10-30 23:01:17', '2025-11-05 14:38:18');
INSERT INTO `sub_process_bom_child` VALUES (170, 3, 'DD-A2510001', 9, 74, 11, 7, 2, 5, 0.05, '1', NULL, '2025-10-30 23:06:50', '2025-11-05 14:38:18');
INSERT INTO `sub_process_bom_child` VALUES (171, 3, 'DD-A2510001', 9, 74, 30, 8, 4, 5, 0.05, '1', NULL, '2025-10-30 23:06:50', '2025-11-05 14:38:18');
INSERT INTO `sub_process_bom_child` VALUES (172, 3, 'DD-A2510001', 9, 74, 11, 7, 5, 5, 0.07, '1', NULL, '2025-10-30 23:06:50', '2025-11-05 14:38:18');
INSERT INTO `sub_process_bom_child` VALUES (173, 3, 'DD-A2510001', 9, 74, 39, 47, 1, 10, 0.04, '1', NULL, '2025-10-30 23:06:50', '2025-11-05 14:38:18');
INSERT INTO `sub_process_bom_child` VALUES (174, 3, 'DD-A2510001', 9, 74, 18, 13, 3, 8, 0.07, '1', NULL, '2025-10-30 23:06:50', '2025-11-05 14:38:19');
INSERT INTO `sub_process_bom_child` VALUES (175, 3, 'DD-A2510001', 9, 75, 20, 7, 1, 5, 0.05, '1', NULL, '2025-10-30 23:16:29', '2025-11-05 14:38:19');
INSERT INTO `sub_process_bom_child` VALUES (176, 3, 'DD-A2510001', 9, 75, 29, 22, 2, 10, 0.35, '1', NULL, '2025-10-30 23:16:29', '2025-11-05 14:38:19');
INSERT INTO `sub_process_bom_child` VALUES (177, 3, 'DD-A2510001', 9, 75, 29, 22, 3, 10, 0.35, '1', NULL, '2025-10-30 23:16:29', '2025-11-05 14:38:19');
INSERT INTO `sub_process_bom_child` VALUES (178, 3, 'DD-A2510001', 9, 76, 41, 29, 1, 15, 0.20, '1', 'http://cdn.yuanfangzixun.com.cn/qrcodes/65f22e24-4044-45f8-8d1e-88193837d46c.png', '2025-10-30 23:24:51', '2025-11-05 14:38:19');
INSERT INTO `sub_process_bom_child` VALUES (179, 3, 'DD-A2510001', 9, 76, 75, 22, 2, 10, 0.35, '1', 'http://cdn.yuanfangzixun.com.cn/qrcodes/dacae4d9-95fd-4c26-b6c6-887bb5a492c4.png', '2025-10-30 23:24:51', '2025-11-05 14:38:19');
INSERT INTO `sub_process_bom_child` VALUES (180, 3, 'DD-A2510001', 9, 76, 74, 23, 3, 20, 0.18, '1', 'http://cdn.yuanfangzixun.com.cn/qrcodes/43c5e1c4-5de1-41c1-8cbd-683c216dbe81.png', '2025-10-30 23:24:51', '2025-11-05 14:38:19');
INSERT INTO `sub_process_bom_child` VALUES (181, 3, 'DD-A2510001', 9, 77, 96, 29, 1, 15, 0.20, '1', 'http://cdn.yuanfangzixun.com.cn/qrcodes/57f1457c-f6be-45ee-aa03-ef7c5ff11053.png', '2025-10-30 23:28:36', '2025-11-05 14:38:19');
INSERT INTO `sub_process_bom_child` VALUES (182, 3, 'DD-A2510001', 9, 78, 45, 29, 1, 15, 0.50, '1', 'http://cdn.yuanfangzixun.com.cn/qrcodes/be61b76f-f656-48a4-8446-b9b386b1784e.png', '2025-10-30 23:30:00', '2025-11-05 14:38:19');
INSERT INTO `sub_process_bom_child` VALUES (183, 3, 'DD-A2510001', 9, 78, 97, 48, 2, 10, 0.05, '1', NULL, '2025-10-30 23:31:08', '2025-11-05 14:38:19');
INSERT INTO `sub_process_bom_child` VALUES (185, 3, 'DD-A2510001', 9, 79, 98, 29, 1, 20, 0.72, '1', 'http://cdn.yuanfangzixun.com.cn/qrcodes/14abc1a7-a11e-463e-a209-dbdb0d0712fb.png', '2025-10-30 23:35:15', '2025-11-05 14:38:19');
INSERT INTO `sub_process_bom_child` VALUES (186, 3, 'DD-A2510001', 9, 80, 90, 31, 1, 120, 1.20, '1', 'http://cdn.yuanfangzixun.com.cn/qrcodes/d1954167-3d9e-4041-84ea-24a58106cc59.png', '2025-10-30 23:36:27', '2025-11-05 14:38:19');
INSERT INTO `sub_process_bom_child` VALUES (187, 3, 'DD-A2510001', 9, 81, 91, 32, 1, 60, 1.10, '1', 'http://cdn.yuanfangzixun.com.cn/qrcodes/ed7d9e90-9ede-45b3-af93-8e322aec4d2f.png', '2025-10-30 23:37:56', '2025-11-05 14:38:19');
INSERT INTO `sub_process_bom_child` VALUES (188, 3, 'DD-A2510001', 9, 82, 100, 35, 1, 5400, 1.00, '1', 'http://cdn.yuanfangzixun.com.cn/qrcodes/de032772-9114-4ffe-bf2b-7132aad9b4bd.png', '2025-10-30 23:50:10', '2025-11-05 14:38:19');
INSERT INTO `sub_process_bom_child` VALUES (189, 3, 'DD-A2510001', 9, 82, 101, 34, 2, 15, 0.10, '1', 'http://cdn.yuanfangzixun.com.cn/qrcodes/e71e4348-2b25-47cd-8e3c-ef2fa2311ae1.png', '2025-10-30 23:50:10', '2025-11-05 14:38:19');
INSERT INTO `sub_process_bom_child` VALUES (190, 3, 'DD-A2510001', 9, 82, 102, 36, 3, 15, 0.10, '1', 'http://cdn.yuanfangzixun.com.cn/qrcodes/a1b7192d-cb4f-44e7-bef4-5787d632731a.png', '2025-10-30 23:50:10', '2025-11-05 14:38:19');
INSERT INTO `sub_process_bom_child` VALUES (191, 3, 'DD-A2510001', 9, 82, 103, 37, 4, 12600, 2.00, '1', 'http://cdn.yuanfangzixun.com.cn/qrcodes/79d6d53f-c258-45d9-9966-861d8ae8020b.png', '2025-10-30 23:50:10', '2025-11-05 14:38:19');
INSERT INTO `sub_process_bom_child` VALUES (192, 3, 'DD-A2510001', 9, 82, 104, 38, 5, 20, 0.15, '1', 'http://cdn.yuanfangzixun.com.cn/qrcodes/7a9ed5ee-ffb3-41f5-afda-b79b0ae9a86e.png', '2025-10-30 23:50:10', '2025-11-05 14:38:19');
INSERT INTO `sub_process_bom_child` VALUES (193, 3, 'DD-A2510001', 9, 82, 105, 39, 6, 10, 0.10, '1', 'http://cdn.yuanfangzixun.com.cn/qrcodes/caef18e7-bf3e-4852-9760-c6a13ab07249.png', '2025-10-30 23:50:10', '2025-11-05 14:38:19');
INSERT INTO `sub_process_bom_child` VALUES (194, 3, 'DD-A2510001', 9, 82, 106, 40, 7, 10, 0.10, '1', 'http://cdn.yuanfangzixun.com.cn/qrcodes/6713361b-3c5f-4ada-a8fa-16cee6a2b254.png', '2025-10-30 23:50:10', '2025-11-05 14:38:19');
INSERT INTO `sub_process_bom_child` VALUES (195, 3, 'DD-A2510001', 9, 82, 107, 41, 8, 10, 0.10, '1', 'http://cdn.yuanfangzixun.com.cn/qrcodes/aa565973-0d7d-4a66-9995-3dd52489368c.png', '2025-10-30 23:50:10', '2025-11-05 14:38:19');
INSERT INTO `sub_process_bom_child` VALUES (196, 3, 'DD-A2510001', 9, 82, 108, 9, 9, 15, 0.13, '1', 'http://cdn.yuanfangzixun.com.cn/qrcodes/2d6a765e-db1d-42d8-8615-d7c0ac16c57f.png', '2025-10-30 23:50:10', '2025-11-05 14:38:19');
INSERT INTO `sub_process_bom_child` VALUES (197, 3, 'DD-A2510001', 9, 82, 111, 21, 10, 600, 4.50, '1', 'http://cdn.yuanfangzixun.com.cn/qrcodes/9a72bfa8-b9da-435c-a0ec-4de520a64ba7.png', '2025-10-30 23:50:10', '2025-11-05 14:38:19');
INSERT INTO `sub_process_bom_child` VALUES (198, 3, 'DD-A2510001', 9, 82, 109, 9, 11, 300, 2.30, '1', 'http://cdn.yuanfangzixun.com.cn/qrcodes/7a1c4c1d-104d-41f4-a382-e438d0a08295.png', '2025-10-30 23:50:10', '2025-11-05 14:38:19');
INSERT INTO `sub_process_bom_child` VALUES (199, 3, 'DD-A2510001', 9, 82, 112, 42, 12, 600, 1.10, '1', 'http://cdn.yuanfangzixun.com.cn/qrcodes/ba077b3a-262b-44b1-b4cc-a1b8fef1c8d5.png', '2025-10-30 23:50:10', '2025-11-05 14:38:19');
INSERT INTO `sub_process_bom_child` VALUES (200, 3, 'DD-A2510001', 9, 82, 110, 43, 13, 4000, 20.00, '1', 'http://cdn.yuanfangzixun.com.cn/qrcodes/fef45690-d985-4af4-8049-34dee160e5b4.png', '2025-10-30 23:50:10', '2025-11-05 14:38:19');
INSERT INTO `sub_process_bom_child` VALUES (201, 3, 'DD-A2510001', 9, 82, 113, 44, 14, 140, 0.65, '1', 'http://cdn.yuanfangzixun.com.cn/qrcodes/5df9bbd6-8ccb-4e9c-84bd-e587a7576c78.png', '2025-10-30 23:50:10', '2025-11-05 14:38:19');
INSERT INTO `sub_process_bom_child` VALUES (202, 3, 'DD-A2510001', 9, 82, 114, 45, 15, 140, 0.60, '1', 'http://cdn.yuanfangzixun.com.cn/qrcodes/c80f86a4-f1e2-4411-a80d-c2d43c9ea5de.png', '2025-10-30 23:50:10', '2025-11-05 14:38:19');

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
) ENGINE = InnoDB AUTO_INCREMENT = 115 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '工艺编码基础信息表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '制程组列表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_process_cycle
-- ----------------------------
INSERT INTO `sub_process_cycle` VALUES (1, 1, 1, '备料组', '1', '4', 1, '2025-08-21 09:30:12', '2025-11-05 20:42:50');
INSERT INTO `sub_process_cycle` VALUES (2, 1, 1, '设备组', '4', '4', 1, '2025-08-21 09:30:39', '2025-11-05 20:43:00');
INSERT INTO `sub_process_cycle` VALUES (3, 1, 1, '生产组', '2', '5', 1, '2025-08-21 09:30:45', '2025-11-05 20:42:53');
INSERT INTO `sub_process_cycle` VALUES (4, 1, 1, '其他组', '3', NULL, 1, '2025-10-16 19:09:55', '2025-11-05 20:42:57');
INSERT INTO `sub_process_cycle` VALUES (5, 1, 1, '不好组', '0', NULL, 1, '2025-10-16 19:15:43', '2025-10-26 18:10:53');
INSERT INTO `sub_process_cycle` VALUES (6, 3, 6, '备料组', '1', '1', 1, '2025-10-18 10:10:27', '2025-10-28 13:40:09');
INSERT INTO `sub_process_cycle` VALUES (7, 3, 6, '焊接组', '7', '1', 1, '2025-10-18 10:10:44', '2025-11-05 14:09:20');
INSERT INTO `sub_process_cycle` VALUES (8, 3, 6, '热处理', '3', '2', 1, '2025-10-18 10:11:22', '2025-11-06 16:17:00');
INSERT INTO `sub_process_cycle` VALUES (9, 3, 6, '研磨组', '4', '5', 1, '2025-10-18 10:11:37', '2025-10-28 13:44:10');
INSERT INTO `sub_process_cycle` VALUES (10, 3, 6, '补土组', '5', '6', 1, '2025-10-18 10:11:55', '2025-10-28 13:44:35');
INSERT INTO `sub_process_cycle` VALUES (11, 3, 6, '后段组', '6', '8', 1, '2025-10-18 10:12:08', '2025-10-28 13:44:44');
INSERT INTO `sub_process_cycle` VALUES (12, 3, 6, '行政部', '0', NULL, 1, '2025-10-28 13:45:18', '2025-10-28 13:45:18');
INSERT INTO `sub_process_cycle` VALUES (13, 3, 6, '技术部', '0', NULL, 1, '2025-10-28 13:45:30', '2025-10-28 13:45:30');
INSERT INTO `sub_process_cycle` VALUES (14, 3, 6, '业务部', '0', NULL, 1, '2025-10-28 13:45:41', '2025-10-28 13:45:41');
INSERT INTO `sub_process_cycle` VALUES (15, 3, 6, '总经办', '0', NULL, 1, '2025-10-28 13:45:53', '2025-10-28 13:45:53');

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
INSERT INTO `sub_product_code` VALUES (9, 1, 1, '12111111', '113', '图只可以', '21', '2131', '3131', '1313', '212', '21', 1, '2025-07-08 15:02:27', '2025-10-29 10:19:03');
INSERT INTO `sub_product_code` VALUES (10, 1, 1, '1233', '212', '月1', '121', '2121', '2121', '21', '212', '2121', 1, '2025-07-08 15:12:29', '2025-07-14 10:04:29');
INSERT INTO `sub_product_code` VALUES (11, 1, 1, '1234', '12', '121', '212', '21', '212', '211', '1212', '121', 1, '2025-07-15 11:04:40', '2025-07-15 11:12:37');
INSERT INTO `sub_product_code` VALUES (12, 1, 1, '12321', '21221', '2121', 'wdd', 'dwwdq', 'dwqwdw', 'qdwq', 'qw', '2121', 1, '2025-08-08 11:19:00', '2025-08-08 11:19:00');
INSERT INTO `sub_product_code` VALUES (13, 1, 1, '12322', '21222', '2121', 'wdd', 'dwwdq', 'dwqwdw', 'qdwq', 'qw', '2121', 1, '2025-08-08 11:23:21', '2025-08-08 14:44:31');
INSERT INTO `sub_product_code` VALUES (14, 1, 1, '12323', '21223', '2121', 'wdd', 'dwwdq', 'dwqwdw', 'qdwq', 'qw', '2121', 1, '2025-08-08 11:28:28', '2025-08-08 11:28:28');
INSERT INTO `sub_product_code` VALUES (15, 1, 1, '12324', '21224', '2121', 'wdd', 'dwwdq', 'dwqwdw', 'qdwq', 'qw', '2121', 1, '2025-08-08 11:34:57', '2025-08-08 11:34:57');
INSERT INTO `sub_product_code` VALUES (16, 1, 1, '12325', '21225', '2121', 'wdd', 'dwwdq', 'dwqwdw', 'qdwq', 'qw', '2121', 1, '2025-08-08 11:35:22', '2025-08-08 14:09:03');
INSERT INTO `sub_product_code` VALUES (17, 1, 1, '12671', '4841', 'eewqw', 'ewe', 'rwrw', 'rww', 'qeqeq', 'eqwew', '31', 1, '2025-08-08 11:36:50', '2025-08-08 11:36:50');
INSERT INTO `sub_product_code` VALUES (18, 1, 1, '43456', '2345', '23', '423', '42', 'ewf', '5', '3553', '12', 0, '2025-08-08 14:10:41', '2025-08-08 14:58:55');
INSERT INTO `sub_product_code` VALUES (19, 1, 1, 'A001', '圆珠笔', 'qqqwe', 'eeqqwq', 'sewww', 'ersdsd', 'ewww', 'ff', 'rww', 1, '2025-08-10 10:09:09', '2025-08-21 15:44:55');
INSERT INTO `sub_product_code` VALUES (20, 3, 12, 'WA-A00001', '0611铝车架', '0611', '城市代步Q1', '36寸', '折叠型', '整车结构', '台', '1.字码2510001-2510800；2.车架补土后烤漆', 1, '2025-10-18 04:34:51', '2025-10-18 04:37:04');
INSERT INTO `sub_product_code` VALUES (21, 3, 6, 'WA-A00002', '0612铝车架', '0612', '山地车', '32寸', '配载重货架', '整体车架+独立货架', '套', '1.产品表面研磨清洗；2.产品杜绝补土；3.按订单要求打字码', 1, '2025-10-27 14:44:02', '2025-10-27 14:44:02');

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
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '生产通知单信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_product_notice
-- ----------------------------
INSERT INTO `sub_product_notice` VALUES (8, 1, 1, '1122', 2, 19, 2, '2025-10-15', 0, 1, 1, '2025-09-24 15:56:38', '2025-11-05 20:48:30');
INSERT INTO `sub_product_notice` VALUES (9, 3, 6, 'DD-A2510001', 4, 20, 3, '2025-11-20', 0, 1, 1, '2025-10-18 14:17:30', '2025-11-06 15:50:12');
INSERT INTO `sub_product_notice` VALUES (10, 3, 6, 'DD-2510002', 5, 20, 4, '2025-11-07', 1, 1, 1, '2025-10-30 16:20:55', '2025-10-30 16:20:55');

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
  `other_transaction_terms` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '交易条件',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '产品报价表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_product_quotation
-- ----------------------------
INSERT INTO `sub_product_quotation` VALUES (11, 1, 1, 2, 2, 9, '111', '111', '111', '111', 1, '2025-07-25 22:44:22', '2025-07-25 22:44:22');
INSERT INTO `sub_product_quotation` VALUES (12, 1, 1, 1, 3, 10, '222', '222', '222', '222', 1, '2025-07-25 22:44:29', '2025-07-25 22:44:29');
INSERT INTO `sub_product_quotation` VALUES (13, 3, 6, 3, 4, 20, 'BJD001', '580', 'RMB', '现金/月结60天', 1, '2025-10-18 12:51:58', '2025-10-18 12:51:58');

-- ----------------------------
-- Table structure for sub_production_progress
-- ----------------------------
DROP TABLE IF EXISTS `sub_production_progress`;
CREATE TABLE `sub_production_progress`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键ID',
  `company_id` int(11) NOT NULL COMMENT '企业id',
  `user_id` int(11) NOT NULL COMMENT '发布的用户id',
  `notice_id` int(11) NULL DEFAULT NULL COMMENT '生产通知单id',
  `product_id` int(11) NULL DEFAULT NULL COMMENT '产品id',
  `product_code` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '产品编码',
  `product_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '产品名称',
  `drawing` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '产品图号',
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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '进度表的基础数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sub_progress_base
-- ----------------------------

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '进度表的制程子表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_progress_cycle
-- ----------------------------

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '工艺BOM表工序下进度表的子表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sub_progress_work
-- ----------------------------

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
  `number` int(20) NULL DEFAULT NULL COMMENT '完成数量',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '员工计件工资表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_rate_wage
-- ----------------------------
INSERT INTO `sub_rate_wage` VALUES (1, 1, 3, 71, 19, 8, 5, 10, '2025-10-07 13:44:49', '2025-10-07 13:44:49');

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
  `is_sale` int(1) NULL DEFAULT 1 COMMENT '是否已创建生产订单：1-未创建，0-已创建',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '销售订单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_sales_order
-- ----------------------------
INSERT INTO `sub_sales_order` VALUES (1, 1, 1, '2025-07-07', 3, 'G2222222', 10, '我的要求', '18000', 313, '个', '2025-07-07', '2025-07-27', '大朗镇', 1, 1, '2025-07-14 13:55:51', '2025-09-03 09:43:29');
INSERT INTO `sub_sales_order` VALUES (2, 1, 1, '2025-07-10', 2, 'hui11111111', 19, '无要求', '12000', 2121, '件', '2025-10-31', '2025-07-14', '寮步镇', 1, 1, '2025-07-14 18:47:31', '2025-10-31 01:04:11');
INSERT INTO `sub_sales_order` VALUES (3, 3, 6, '2025-10-10', 4, 'CG01-2510009', 20, '1.字码2510001-2510800；2.车架补土后烤漆', '17500', 800, '台', '2025-11-30', '2025-11-30', '公司材料仓', 1, 1, '2025-10-18 11:17:11', '2025-11-07 00:21:48');
INSERT INTO `sub_sales_order` VALUES (4, 3, 6, '2025-10-30', 5, 'CG02-2510018', 20, '1.字码自2511001起；2.车架补土后送烤漆', '7500', 7500, '台', '2025-12-12', '2025-12-12', '高埗镇合鑫喷漆厂', 1, 1, '2025-10-30 16:04:11', '2025-10-30 16:22:00');

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
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '供应商信息信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_supplier_info
-- ----------------------------
INSERT INTO `sub_supplier_info` VALUES (1, 1, 1, '123', '2121', '13', '15', '1515', '212', '5151', 15, 15151, '1515', 15, 1, '2025-07-10 00:03:15', '2025-07-10 00:03:15');
INSERT INTO `sub_supplier_info` VALUES (2, 1, 1, '1234', '151', '153333333', '1', '515', '155', '511', 515, 15, '1', 515, 1, '2025-07-10 00:03:27', '2025-07-10 00:03:37');
INSERT INTO `sub_supplier_info` VALUES (3, 6, 3, 'GA001', '晶鑫昌', '刘总', '136123456678', '深圳市晶鑫昌科技有限公司', '深圳市宝安区沙井镇', '材料供应/委外加工', 29, 21, '人民币', 27, 1, '2025-10-19 16:27:11', '2025-11-05 11:58:10');
INSERT INTO `sub_supplier_info` VALUES (4, 6, 3, 'GA002', '城至', '许总', '13112345678', '东莞市城至精密五金有限公司', '东莞市万江区简沙洲', '委外加工', 29, 21, '人民币', 26, 1, '2025-10-24 11:26:22', '2025-11-05 11:58:12');
INSERT INTO `sub_supplier_info` VALUES (5, 6, 3, 'GA003', '源达', '葛小姐', '18812345678', '东莞市源达五金制品有限公司', '东莞市万江区五金工业城', '易耗材料/委外加工', 29, 23, '人民币', 25, 1, '2025-10-31 00:49:46', '2025-11-05 11:58:36');

-- ----------------------------
-- Table structure for sub_warehouse_apply
-- ----------------------------
DROP TABLE IF EXISTS `sub_warehouse_apply`;
CREATE TABLE `sub_warehouse_apply`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '发布的用户id',
  `company_id` int(11) NULL DEFAULT NULL COMMENT '所属企业id',
  `print_id` int(30) NULL DEFAULT NULL COMMENT '打印的id',
  `buyPrint_id` int(30) NULL DEFAULT NULL COMMENT '采购单号ID',
  `sale_id` int(11) NULL DEFAULT NULL COMMENT '销售订单ID',
  `ware_id` int(11) NULL DEFAULT NULL COMMENT '仓库类型ID 1材料2部件3成品',
  `house_id` int(11) NULL DEFAULT NULL COMMENT '仓库ID',
  `operate` int(1) NULL DEFAULT NULL COMMENT '1:入库 2:出库',
  `type` int(2) NULL DEFAULT NULL COMMENT '出入库类型(常量)',
  `house_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '仓库名称',
  `plan_id` int(11) NULL DEFAULT NULL COMMENT '供应商id or 制程id',
  `plan` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商 or 制程',
  `item_id` int(11) NULL DEFAULT NULL COMMENT '物料ID',
  `code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '物料编码',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '物料名称',
  `model_spec` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '规格型号',
  `other_features` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '其他特性',
  `quantity` int(20) NULL DEFAULT NULL COMMENT '数量',
  `buy_price` decimal(10, 1) NULL DEFAULT NULL COMMENT '单价',
  `total_price` decimal(10, 1) NULL DEFAULT NULL COMMENT '总价',
  `apply_id` int(11) NULL DEFAULT NULL COMMENT '申请人ID',
  `apply_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '申请人名称',
  `apply_time` timestamp NULL DEFAULT NULL COMMENT '申请时间',
  `step` int(2) NULL DEFAULT 0 COMMENT '审核当前在第几步，默认0，每审核一步加1',
  `status` int(1) NULL DEFAULT 0 COMMENT '状态（0审批中/1通过/2拒绝）',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '1：未删除；0：已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 45 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '出库入库申请表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_warehouse_apply
-- ----------------------------
INSERT INTO `sub_warehouse_apply` VALUES (17, 1, 1, 17, NULL, NULL, 1, 6, 1, 4, '材料仓', 1, '2121', 3, '789', '555', '535/35353', NULL, 574, 2.1, 1205.4, 1, '我是名字', '2025-09-19 13:18:25', 0, 0, 1, '2025-09-19 21:18:25', '2025-10-11 15:15:49');
INSERT INTO `sub_warehouse_apply` VALUES (18, 1, 1, 17, NULL, NULL, 1, 6, 1, 4, '材料仓', 2, '151', 2, '123', '121', '2121/21', NULL, 475, 1.8, 855.0, 1, '我是名字', '2025-09-20 11:59:29', 0, 0, 1, '2025-09-19 21:18:25', '2025-10-11 15:15:49');
INSERT INTO `sub_warehouse_apply` VALUES (19, 1, 1, 17, NULL, NULL, 1, 6, 1, 4, '材料仓', 2, '151', 3, '789', '555', '535/35353', NULL, 502, 2.5, 1255.0, 1, '我是名字', '2025-09-19 13:18:25', 0, 0, 1, '2025-09-19 21:18:25', '2025-10-11 15:15:49');
INSERT INTO `sub_warehouse_apply` VALUES (20, 1, 1, 17, NULL, NULL, 1, 6, 1, 4, '材料仓', 2, '151', 2, '123', '121', '2121/21', NULL, 645, 2.4, 1548.0, 1, '我是名字', '2025-09-19 13:18:25', 0, 0, 1, '2025-09-19 21:18:25', '2025-10-11 15:15:49');
INSERT INTO `sub_warehouse_apply` VALUES (21, 1, 1, 17, NULL, NULL, 1, 6, 1, 4, '材料仓', 2, '151', 3, '789', '555', '535/35353', NULL, 236, 1.9, 448.4, 1, '我是名字', '2025-09-19 13:52:27', 0, 0, 1, '2025-09-19 21:52:27', '2025-10-11 15:15:49');
INSERT INTO `sub_warehouse_apply` VALUES (22, 1, 1, 17, NULL, NULL, 1, 6, 1, 4, '材料仓', 1, '2121', 3, '789', '555', '535/35353', NULL, 222, 2.5, 555.0, 1, '我是名字', '2025-09-19 13:52:27', 1, 0, 1, '2025-09-19 21:52:27', '2025-10-11 15:15:49');
INSERT INTO `sub_warehouse_apply` VALUES (23, 1, 1, 17, NULL, NULL, 1, 6, 1, 4, '材料仓', 2, '151', 2, '123', '121', '2121/21', NULL, 600, 2.1, 1260.0, 1, '我是名字', '2025-09-20 11:53:35', 2, 0, 1, '2025-09-20 19:53:35', '2025-10-11 15:15:49');
INSERT INTO `sub_warehouse_apply` VALUES (25, 1, 1, 17, NULL, NULL, 1, 6, 1, 4, '材料仓', 2, '151', 3, '789', '555', '535/35353', NULL, 400, 1.9, 760.0, 1, '我是名字', '2025-09-20 12:00:01', 2, 0, 1, '2025-09-20 20:00:01', '2025-10-11 15:15:49');
INSERT INTO `sub_warehouse_apply` VALUES (26, 1, 1, 17, NULL, NULL, 1, 6, 1, 4, '材料仓', 1, '2121', 3, '789', '555', '535/35353', NULL, 632, 2.0, 1264.0, 1, '我是名字', '2025-09-20 12:00:01', 2, 0, 1, '2025-09-20 20:00:01', '2025-10-11 15:15:49');
INSERT INTO `sub_warehouse_apply` VALUES (27, 1, 1, 17, NULL, NULL, 1, 6, 1, 4, '材料仓', 2, '151', 3, '789', '555', '535/35353', NULL, 615, 1.9, 1168.5, 1, '我是名字', '2025-09-21 08:52:36', 1, 0, 1, '2025-09-21 16:52:36', '2025-10-11 15:15:49');
INSERT INTO `sub_warehouse_apply` VALUES (28, 1, 1, 17, NULL, NULL, 1, 6, 1, 4, '材料仓', 1, '2121', 3, '789', '555', '535/35353', '353', 158, 2.6, 410.8, 1, '我是名字', '2025-09-21 08:56:51', 1, 0, 1, '2025-09-21 16:56:51', '2025-10-11 15:15:49');
INSERT INTO `sub_warehouse_apply` VALUES (29, 1, 1, 17, NULL, NULL, 1, 6, 1, 4, '材料仓', 1, '2121', 3, '789', '555', '535/35353', '353', 22, 12.0, 264.0, 1, '我是名字', '2025-09-26 16:32:19', 0, 0, 1, '2025-09-26 16:32:19', '2025-10-11 15:15:49');
INSERT INTO `sub_warehouse_apply` VALUES (32, 1, 1, 21, NULL, NULL, 3, 4, 1, 10, '成品仓', NULL, '', 11, '1234', '12', '212/21', '212', 800, 2.4, 1920.0, 1, '我是名字', '2025-09-26 17:25:53', 2, 1, 1, '2025-09-26 17:25:53', '2025-10-15 11:20:18');
INSERT INTO `sub_warehouse_apply` VALUES (33, 1, 1, 21, NULL, NULL, 3, 4, 1, 11, '成品仓', NULL, '', 19, 'A001', '圆珠笔', 'eeqqwq/sewww', 'ersdsd', 300, 2.6, 780.0, 1, '我是名字', '2025-09-26 17:25:53', 2, 1, 1, '2025-09-26 17:25:53', '2025-10-15 11:20:18');
INSERT INTO `sub_warehouse_apply` VALUES (34, 1, 1, 17, NULL, NULL, 1, 6, 1, 4, '材料仓', 1, '2121', 3, '789', '555', '535/35353', NULL, 574, 2.1, 1205.4, 1, '我是名字', '2025-09-19 13:18:25', 0, 0, 1, '2025-09-19 21:18:25', '2025-10-11 15:15:49');
INSERT INTO `sub_warehouse_apply` VALUES (35, 1, 1, 17, NULL, NULL, 1, 6, 1, 4, '材料仓', 1, '2121', 3, '789', '555', '535/35353', NULL, 574, 2.1, 1205.4, 1, '我是名字', '2025-09-19 13:18:25', 0, 0, 1, '2025-09-19 21:18:25', '2025-10-11 15:15:49');
INSERT INTO `sub_warehouse_apply` VALUES (36, 1, 1, 17, NULL, NULL, 1, 6, 1, 4, '材料仓', 1, '2121', 3, '789', '555', '535/35353', NULL, 574, 2.1, 1205.4, 1, '我是名字', '2025-09-19 13:18:25', 0, 0, 1, '2025-09-19 21:18:25', '2025-10-11 15:15:49');
INSERT INTO `sub_warehouse_apply` VALUES (37, 1, 1, 17, NULL, NULL, 1, 6, 1, 4, '材料仓', 1, '2121', 3, '789', '555', '535/35353', NULL, 574, 2.1, 1205.4, 1, '我是名字', '2025-09-19 13:18:25', 0, 0, 1, '2025-09-19 21:18:25', '2025-10-11 15:15:49');
INSERT INTO `sub_warehouse_apply` VALUES (38, 1, 1, 17, NULL, NULL, 1, 6, 1, 4, '材料仓', 1, '2121', 3, '789', '555', '535/35353', NULL, 574, 2.1, 1205.4, 1, '我是名字', '2025-09-19 13:18:25', 0, 0, 1, '2025-09-19 21:18:25', '2025-10-11 15:15:49');
INSERT INTO `sub_warehouse_apply` VALUES (39, 1, 1, 17, NULL, NULL, 1, 6, 1, 4, '材料仓', 1, '2121', 3, '789', '555', '535/35353', NULL, 574, 2.1, 1205.4, 1, '我是名字', '2025-09-19 13:18:25', 0, 0, 1, '2025-09-19 21:18:25', '2025-10-11 15:15:49');
INSERT INTO `sub_warehouse_apply` VALUES (40, 1, 1, 18, 15, NULL, 1, 6, 1, 4, '材料仓', 2, '151', 2, '123', '121', '2121/21', '2121', 15000, 2.6, 39000.0, 1, '我是名字', '2025-10-11 16:29:33', 0, 0, 1, '2025-10-11 16:29:33', '2025-10-12 12:50:17');
INSERT INTO `sub_warehouse_apply` VALUES (41, 1, 1, 18, 16, NULL, 1, 6, 2, 8, '材料仓', 1, '2121', 2, '123', '121', '2121/21', '2121', 50, 21.0, 1050.0, 1, '我是名字', '2025-10-12 00:13:52', 0, 0, 1, '2025-10-12 00:13:52', '2025-10-12 12:50:17');
INSERT INTO `sub_warehouse_apply` VALUES (42, 1, 1, 21, NULL, NULL, 3, 4, 1, 10, '成品仓', NULL, '', 16, '12325', '21225', 'wdd/dwwdq', 'dwqwdw', 50, 1200.0, 60000.0, 1, '我是名字', '2025-10-12 13:06:54', 2, 1, 1, '2025-10-12 13:06:54', '2025-10-15 11:20:18');
INSERT INTO `sub_warehouse_apply` VALUES (43, 1, 1, 21, NULL, 1, 3, 4, 2, 14, '成品仓', 3, '东莞鞋厂', 10, '1233', '212', '121/2121', '2121', 2, 100.0, 200.0, 1, '我是名字', '2025-10-12 14:21:03', 4, 1, 1, '2025-10-12 13:44:30', '2025-10-15 11:20:18');
INSERT INTO `sub_warehouse_apply` VALUES (44, 1, 1, 21, NULL, 2, 3, 4, 2, 14, '成品仓', 2, '惠州饮料厂', 19, 'A001', '圆珠笔', 'eeqqwq/sewww', 'ersdsd', 1, 23.0, 23.0, 1, '我是名字', '2025-10-12 14:21:03', 4, 1, 1, '2025-10-12 14:09:26', '2025-10-15 11:20:18');

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
  `unit` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '采购单位',
  `inv_unit` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '库存单位',
  `initial` int(20) NULL DEFAULT 0 COMMENT '非正常入库数量',
  `number_in` int(20) NULL DEFAULT 0 COMMENT '正常入库数量',
  `number_out` int(20) NULL DEFAULT 0 COMMENT '出库数量',
  `number_new` int(20) NULL DEFAULT 0 COMMENT '最新库存',
  `price` decimal(10, 1) NULL DEFAULT 0.0 COMMENT '内部单价',
  `price_total` decimal(20, 1) NULL DEFAULT 0.0 COMMENT '存货金额',
  `price_in` decimal(20, 1) NULL DEFAULT 0.0 COMMENT '入库金额(弃)',
  `price_out` decimal(10, 1) NULL DEFAULT 0.0 COMMENT '出库金额',
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
INSERT INTO `sub_warehouse_content` VALUES (3, 4, 1, 1, 6, 3, '789', '555', '535/35353', '353', '', '', 0, 400, 0, 400, 0.0, 0.0, 0.0, 0.0, '2025-09-21 17:20:30', NULL, 1, '2025-09-21 17:17:24', '2025-09-22 14:17:05');
INSERT INTO `sub_warehouse_content` VALUES (4, 1, 1, 1, 6, 2, '123', '121', '2121/21', NULL, '', '件', 0, 600, 0, 600, 2.8, 1680.0, 0.0, 0.0, '2025-09-21 17:20:30', NULL, 1, '2025-09-21 17:20:30', '2025-09-22 17:03:58');
INSERT INTO `sub_warehouse_content` VALUES (6, 4, 1, 3, 4, 11, '1234', '12', '212/21', '212', '', '', 0, 800, 0, 800, 0.0, 0.0, 0.0, 0.0, '2025-09-26 17:26:29', NULL, 1, '2025-09-26 17:26:29', '2025-09-26 17:26:29');
INSERT INTO `sub_warehouse_content` VALUES (7, 4, 1, 3, 4, 19, 'A001', '圆珠笔', 'eeqqwq/sewww', 'ersdsd', '', '', 300, 0, 0, 300, 0.0, 0.0, 0.0, 0.0, '2025-09-26 17:26:29', NULL, 1, '2025-09-26 17:26:29', '2025-09-26 17:26:29');
INSERT INTO `sub_warehouse_content` VALUES (8, 4, 1, 3, 4, 16, '12325', '21225', 'wdd/dwwdq', 'dwqwdw', '', '', 0, 51, 0, 51, 0.0, 0.0, 0.0, 0.0, '2025-10-12 13:08:50', NULL, 1, '2025-10-12 13:08:50', '2025-10-12 14:19:14');
INSERT INTO `sub_warehouse_content` VALUES (9, 4, 1, 3, 4, 10, '1233', '212', '121/2121', '2121', '', '', 0, 0, 0, 0, 0.0, 0.0, 0.0, 0.0, '2025-10-12 14:22:13', NULL, 1, '2025-10-12 14:22:13', '2025-10-12 14:22:13');

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
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '仓库名列表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_warehouse_cycle
-- ----------------------------
INSERT INTO `sub_warehouse_cycle` VALUES (4, 1, 1, 3, '成品仓', 1, '2025-08-23 09:35:08', '2025-09-09 10:21:59');
INSERT INTO `sub_warehouse_cycle` VALUES (5, 1, 1, 2, '半成品仓', 1, '2025-08-23 09:35:27', '2025-09-09 10:21:55');
INSERT INTO `sub_warehouse_cycle` VALUES (6, 1, 1, 1, '材料仓', 1, '2025-08-23 09:35:34', '2025-09-09 10:20:20');
INSERT INTO `sub_warehouse_cycle` VALUES (7, 1, 1, 2, '小小部件', 1, '2025-09-16 13:01:10', '2025-09-16 13:01:10');
INSERT INTO `sub_warehouse_cycle` VALUES (8, 3, 6, 1, '管料仓-铝管', 1, '2025-10-16 15:05:46', '2025-10-28 09:33:58');
INSERT INTO `sub_warehouse_cycle` VALUES (9, 3, 6, 1, '配件仓-铝架配件', 1, '2025-10-16 15:06:04', '2025-10-29 09:31:59');
INSERT INTO `sub_warehouse_cycle` VALUES (10, 3, 6, 1, '管件仓-铁管', 1, '2025-10-28 09:32:51', '2025-10-28 09:34:18');
INSERT INTO `sub_warehouse_cycle` VALUES (11, 3, 6, 1, '配件仓-铁架配件', 1, '2025-10-28 09:33:44', '2025-10-29 09:32:20');

SET FOREIGN_KEY_CHECKS = 1;
