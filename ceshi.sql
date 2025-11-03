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

 Date: 03/11/2025 12:42:43
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
INSERT INTO `ad_user` VALUES (12, 3, 'xuchudong', '$2b$10$X8j4FSLo4roCW3ZRFz529e.uK5va/4lmhZ2MnGeyFFhFtP/gPbbrG', '徐楚东', NULL, '[[\"基础资料\",\"ProductCode\",\"ProductCode:add\"],[\"基础资料\",\"ProductCode\",\"ProductCode:edit\"],[\"系统管理\",\"ProcessCycle\",\"ProcessCycle:add\"],[\"系统管理\",\"ProcessCycle\",\"ProcessCycle:edit\"],[\"系统管理\",\"WarehouseType\",\"Warehouse:add\"],[\"系统管理\",\"WarehouseType\",\"Warehouse:edit\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:add\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:edit\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:delete\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:add\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:edit\"],[\"订单管理\",\"ProductQuote\",\"ProductQuote:add\"],[\"订单管理\",\"ProductQuote\",\"ProductQuote:edit\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:add\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:edit\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:date\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:finish\"],[\"订单管理\",\"FinishNotice\"],[\"委外管理\",\"OutsourcingQuote\",\"OutsourcingQuote:add\"],[\"委外管理\",\"OutsourcingQuote\",\"OutsourcingQuote:edit\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:add\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:edit\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:set\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:print\"],[\"生产管理\",\"ProductionProgress\"],[\"生产管理\",\"WorkOrder\",\"WorkOrder:print\"],[\"仓库管理\",\"WarehouseRate\",\"WarehouseRate:edit\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:addIn\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:addOut\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:set\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:print\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:addIn\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:addOut\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:set\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:print\"],[\"财务管理\",\"EmployeePieceRate\"],[\"财务管理\",\"AccountsReceivable\"],[\"财务管理\",\"AccountsPayable\"],[\"财务管理\",\"AccountsOutsourcing\"],[\"系统管理\",\"OrganizeManagement\"],[\"基础资料\",\"PartCode\",\"PartCode:add\"],[\"基础资料\",\"PartCode\",\"PartCode:edit\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:add\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:edit\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:add\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:edit\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:add\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:edit\"],[\"基础资料\",\"EmployeeInfo\",\"EmployeeInfo:add\"],[\"基础资料\",\"EmployeeInfo\",\"EmployeeInfo:edit\"],[\"采购管理\",\"SupplierInfo\",\"SupplierInfo:add\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:add\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:edit\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:archive\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:newPage\"],[\"产品工程\",\"MaterialBOMArchive\",\"MaterialBOM:cope\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:add\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:edit\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:archive\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:newPage\"],[\"产品工程\",\"ProcessBOMArchive\",\"ProcessBOM:cope\"],[\"系统管理\",\"UserManagement\",\"user:add\"],[\"系统管理\",\"UserManagement\",\"user:edit\"],[\"系统管理\",\"UserManagement\",\"user:delete\"],[\"基础资料\",\"ProductCode\",\"ProductCode:delete\"],[\"基础资料\",\"PartCode\",\"PartCode:delete\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:delete\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:delete\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:delete\"],[\"基础资料\",\"EmployeeInfo\",\"EmployeeInfo:delete\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:delete\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:delete\"],[\"采购管理\",\"SupplierInfo\",\"SupplierInfo:edit\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:add\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:archive\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:newPage\"],[\"采购管理\",\"MaterialQuoteArchive\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:add\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:edit\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:set\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:print\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:edit\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:edit\"]]', 2, 6, 1, 1, '2025-10-16 14:55:08', '2025-10-27 20:19:54');
INSERT INTO `ad_user` VALUES (15, 3, 'suyun', '$2b$10$GRaOfS8A9pIpTamrCTq/r.QK8LD5t6G6GZS3QRK0cnBbLndWyTfnG', '粟云', NULL, '[[\"系统管理\",\"ProcessCycle\",\"ProcessCycle:add\"],[\"系统管理\",\"ProcessCycle\",\"ProcessCycle:edit\"],[\"系统管理\",\"WarehouseType\",\"Warehouse:add\"],[\"系统管理\",\"WarehouseType\",\"Warehouse:edit\"],[\"基础资料\",\"ProductCode\",\"ProductCode:add\"],[\"基础资料\",\"ProductCode\",\"ProductCode:edit\"],[\"基础资料\",\"ProductCode\",\"ProductCode:delete\"],[\"基础资料\",\"PartCode\",\"PartCode:add\"],[\"基础资料\",\"PartCode\",\"PartCode:edit\"],[\"基础资料\",\"PartCode\",\"PartCode:delete\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:add\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:edit\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:delete\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:add\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:edit\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:delete\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:add\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:edit\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:delete\"],[\"基础资料\",\"EmployeeInfo\",\"EmployeeInfo:add\"],[\"基础资料\",\"EmployeeInfo\",\"EmployeeInfo:edit\"],[\"基础资料\",\"EmployeeInfo\",\"EmployeeInfo:delete\"],[\"系统管理\",\"UserManagement\",\"user:add\"],[\"系统管理\",\"UserManagement\",\"user:edit\"],[\"系统管理\",\"UserManagement\",\"user:delete\"],[\"系统管理\",\"OrganizeManagement\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:add\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:edit\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:delete\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:add\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:edit\"],[\"订单管理\",\"ProductQuote\",\"ProductQuote:add\"],[\"订单管理\",\"ProductQuote\",\"ProductQuote:edit\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:add\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:edit\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:date\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:finish\"],[\"订单管理\",\"FinishNotice\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:add\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:edit\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:delete\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:archive\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:newPage\"],[\"产品工程\",\"MaterialBOMArchive\",\"MaterialBOM:cope\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:add\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:edit\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:delete\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:archive\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:newPage\"],[\"产品工程\",\"ProcessBOMArchive\",\"ProcessBOM:cope\"],[\"采购管理\",\"SupplierInfo\",\"SupplierInfo:add\"],[\"采购管理\",\"SupplierInfo\",\"SupplierInfo:edit\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:add\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:archive\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:newPage\"],[\"采购管理\",\"MaterialQuoteArchive\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:add\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:edit\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:set\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:print\"],[\"委外管理\",\"OutsourcingQuote\",\"OutsourcingQuote:add\"],[\"委外管理\",\"OutsourcingQuote\",\"OutsourcingQuote:edit\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:add\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:edit\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:set\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:print\"],[\"生产管理\",\"ProductionProgress\"],[\"生产管理\",\"WorkOrder\",\"WorkOrder:print\"],[\"仓库管理\",\"WarehouseRate\",\"WarehouseRate:edit\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:addIn\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:addOut\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:edit\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:set\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:print\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:addIn\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:addOut\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:edit\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:set\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:print\"],[\"财务管理\",\"EmployeePieceRate\"],[\"财务管理\",\"AccountsReceivable\"],[\"财务管理\",\"AccountsPayable\"],[\"财务管理\",\"AccountsOutsourcing\"]]', 2, 6, 1, 1, '2025-10-19 16:00:54', '2025-10-29 14:40:31');
INSERT INTO `ad_user` VALUES (16, 3, 'lengbing', '$2b$10$2vEZnKFzzPSyF6.SoMy9D.5TY8HGXDUwSsLHwBNlgBSIKC0ezMSFW', '冷冰', NULL, '[[\"系统管理\",\"UserManagement\",\"user:add\"],[\"系统管理\",\"UserManagement\",\"user:edit\"],[\"系统管理\",\"UserManagement\",\"user:delete\"],[\"系统管理\",\"OrganizeManagement\"],[\"系统管理\",\"ProcessCycle\",\"ProcessCycle:add\"],[\"系统管理\",\"ProcessCycle\",\"ProcessCycle:edit\"],[\"系统管理\",\"WarehouseType\",\"Warehouse:add\"],[\"系统管理\",\"WarehouseType\",\"Warehouse:edit\"],[\"基础资料\",\"ProductCode\",\"ProductCode:add\"],[\"基础资料\",\"ProductCode\",\"ProductCode:edit\"],[\"基础资料\",\"ProductCode\",\"ProductCode:delete\"],[\"基础资料\",\"PartCode\",\"PartCode:add\"],[\"基础资料\",\"PartCode\",\"PartCode:edit\"],[\"基础资料\",\"PartCode\",\"PartCode:delete\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:add\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:edit\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:delete\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:add\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:edit\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:delete\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:add\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:edit\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:delete\"],[\"基础资料\",\"EmployeeInfo\",\"EmployeeInfo:add\"],[\"基础资料\",\"EmployeeInfo\",\"EmployeeInfo:edit\"],[\"基础资料\",\"EmployeeInfo\",\"EmployeeInfo:delete\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:add\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:edit\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:delete\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:add\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:edit\"],[\"订单管理\",\"ProductQuote\",\"ProductQuote:add\"],[\"订单管理\",\"ProductQuote\",\"ProductQuote:edit\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:add\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:edit\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:date\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:finish\"],[\"订单管理\",\"FinishNotice\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:add\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:edit\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:delete\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:archive\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:newPage\"],[\"产品工程\",\"MaterialBOMArchive\",\"MaterialBOM:cope\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:add\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:edit\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:delete\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:archive\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:newPage\"],[\"产品工程\",\"ProcessBOMArchive\",\"ProcessBOM:cope\"],[\"采购管理\",\"SupplierInfo\",\"SupplierInfo:add\"],[\"采购管理\",\"SupplierInfo\",\"SupplierInfo:edit\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:add\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:archive\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:newPage\"],[\"采购管理\",\"MaterialQuoteArchive\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:add\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:edit\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:set\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:print\"],[\"委外管理\",\"OutsourcingQuote\",\"OutsourcingQuote:add\"],[\"委外管理\",\"OutsourcingQuote\",\"OutsourcingQuote:edit\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:add\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:edit\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:set\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:print\"],[\"生产管理\",\"ProductionProgress\"],[\"生产管理\",\"WorkOrder\",\"WorkOrder:print\"],[\"仓库管理\",\"WarehouseRate\",\"WarehouseRate:edit\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:addIn\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:addOut\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:edit\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:set\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:print\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:addIn\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:addOut\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:edit\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:set\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:print\"],[\"财务管理\",\"EmployeePieceRate\"],[\"财务管理\",\"AccountsReceivable\"],[\"财务管理\",\"AccountsPayable\"],[\"财务管理\",\"AccountsOutsourcing\"]]', 2, 6, 1, 1, '2025-10-27 20:21:26', '2025-10-27 20:21:26');
INSERT INTO `ad_user` VALUES (17, 3, 'hexiongming', '$2b$10$MFR7RcFGw6hPOYfpR1/8yeHzB4vbGkHpNjZtyCmI7rOZ3BCp7K64W', '何雄明', NULL, '[[\"系统管理\",\"UserManagement\",\"user:add\"],[\"系统管理\",\"UserManagement\",\"user:edit\"],[\"系统管理\",\"UserManagement\",\"user:delete\"],[\"系统管理\",\"OrganizeManagement\"],[\"系统管理\",\"ProcessCycle\",\"ProcessCycle:add\"],[\"系统管理\",\"ProcessCycle\",\"ProcessCycle:edit\"],[\"系统管理\",\"WarehouseType\",\"Warehouse:add\"],[\"系统管理\",\"WarehouseType\",\"Warehouse:edit\"],[\"基础资料\",\"ProductCode\",\"ProductCode:add\"],[\"基础资料\",\"ProductCode\",\"ProductCode:edit\"],[\"基础资料\",\"ProductCode\",\"ProductCode:delete\"],[\"基础资料\",\"PartCode\",\"PartCode:add\"],[\"基础资料\",\"PartCode\",\"PartCode:edit\"],[\"基础资料\",\"PartCode\",\"PartCode:delete\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:add\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:edit\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:delete\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:add\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:edit\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:delete\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:add\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:edit\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:delete\"],[\"基础资料\",\"EmployeeInfo\",\"EmployeeInfo:add\"],[\"基础资料\",\"EmployeeInfo\",\"EmployeeInfo:edit\"],[\"基础资料\",\"EmployeeInfo\",\"EmployeeInfo:delete\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:add\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:edit\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:delete\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:add\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:edit\"],[\"订单管理\",\"ProductQuote\",\"ProductQuote:add\"],[\"订单管理\",\"ProductQuote\",\"ProductQuote:edit\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:add\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:edit\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:date\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:finish\"],[\"订单管理\",\"FinishNotice\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:add\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:edit\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:delete\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:archive\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:newPage\"],[\"产品工程\",\"MaterialBOMArchive\",\"MaterialBOM:cope\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:add\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:edit\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:delete\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:archive\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:newPage\"],[\"产品工程\",\"ProcessBOMArchive\",\"ProcessBOM:cope\"],[\"采购管理\",\"SupplierInfo\",\"SupplierInfo:add\"],[\"采购管理\",\"SupplierInfo\",\"SupplierInfo:edit\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:add\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:archive\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:newPage\"],[\"采购管理\",\"MaterialQuoteArchive\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:add\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:edit\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:set\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:print\"],[\"委外管理\",\"OutsourcingQuote\",\"OutsourcingQuote:add\"],[\"委外管理\",\"OutsourcingQuote\",\"OutsourcingQuote:edit\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:add\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:edit\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:set\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:print\"],[\"生产管理\",\"ProductionProgress\"],[\"生产管理\",\"WorkOrder\",\"WorkOrder:print\"],[\"仓库管理\",\"WarehouseRate\",\"WarehouseRate:edit\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:addIn\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:addOut\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:edit\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:set\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:print\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:addIn\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:addOut\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:edit\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:set\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:print\"],[\"财务管理\",\"EmployeePieceRate\"],[\"财务管理\",\"AccountsReceivable\"],[\"财务管理\",\"AccountsPayable\"],[\"财务管理\",\"AccountsOutsourcing\"]]', 2, 6, 1, 1, '2025-10-27 20:22:48', '2025-10-27 20:22:48');

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
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '审批步骤配置表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 24 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 42 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '日历记录的表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_date_info
-- ----------------------------
INSERT INTO `sub_date_info` VALUES (32, 1, '2025-10-04', '2025-10-31 11:16:11', '2025-10-31 11:16:11');
INSERT INTO `sub_date_info` VALUES (33, 1, '2025-10-11', '2025-10-31 11:16:11', '2025-10-31 11:16:11');
INSERT INTO `sub_date_info` VALUES (34, 1, '2025-10-17', '2025-10-31 11:16:11', '2025-10-31 11:16:11');
INSERT INTO `sub_date_info` VALUES (35, 1, '2025-10-18', '2025-10-31 11:16:11', '2025-10-31 11:16:11');
INSERT INTO `sub_date_info` VALUES (36, 1, '2025-10-20', '2025-10-31 11:16:11', '2025-10-31 11:16:11');
INSERT INTO `sub_date_info` VALUES (37, 1, '2025-10-21', '2025-10-31 11:16:11', '2025-10-31 11:16:11');
INSERT INTO `sub_date_info` VALUES (38, 1, '2025-10-25', '2025-10-31 11:16:11', '2025-10-31 11:16:11');
INSERT INTO `sub_date_info` VALUES (39, 1, '2025-11-05', '2025-10-31 11:16:11', '2025-10-31 11:16:11');
INSERT INTO `sub_date_info` VALUES (40, 1, '2025-11-08', '2025-10-31 11:16:11', '2025-10-31 11:16:11');
INSERT INTO `sub_date_info` VALUES (41, 1, '2025-11-09', '2025-10-31 11:16:11', '2025-10-31 11:16:11');

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
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '员工信息基础信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_employee_info
-- ----------------------------
INSERT INTO `sub_employee_info` VALUES (1, 1, 1, '1', '1', NULL, NULL, 3, '1', 17, '1', 1, '2025-07-08 16:39:58', '2025-10-22 13:10:15');
INSERT INTO `sub_employee_info` VALUES (2, 1, 1, '2', '2', 'base2', '$2b$10$mHXkEoWarhWYGisAwOnZ9Oghb6wEcnG0NOH8WdevQwS7HKLlET/Ja', 2, '23', 18, '3', 1, '2025-07-08 16:40:09', '2025-10-22 13:10:16');
INSERT INTO `sub_employee_info` VALUES (3, 1, 1, '21', '2121', 'base1', '$2b$10$K0JSC.MSvQbD6mkRHjvjC.gpS4XvjatLgIf/yw0wjSs.N3FHt9aCe', 2, '21', 19, '211', 1, '2025-10-01 14:42:30', '2025-10-22 13:11:01');
INSERT INTO `sub_employee_info` VALUES (4, 1, 1, '22', '5445', 'base3', '$2b$10$7DtT7oDcCGxZaLYfiJTPd.mywJj.yYGwC7di.3HLUfD.JBtP3wv0y', 2, '2121', 20, '21', 1, '2025-10-01 15:05:57', '2025-10-22 13:10:19');
INSERT INTO `sub_employee_info` VALUES (5, 6, 3, 'GL0002', '冷冰', 'SC0001', '$2b$10$piyXeFkMk25JPqIZbVMH/e1VJvAeN2BwGsnmDXn0STxgXg0GXeKo6', 14, '业务部副总', 20, NULL, 1, '2025-10-18 10:54:01', '2025-10-28 15:04:54');
INSERT INTO `sub_employee_info` VALUES (6, 6, 3, 'GL0001', '徐庆华', 'GL0002', '$2b$10$vqlF5BJP4DLhCjIc3rIS8.7j02OmX7NWxUQYBjScbdnUiZ49rT63C', 15, '公司创始人', 20, NULL, 1, '2025-10-18 11:00:50', '2025-10-28 15:04:40');
INSERT INTO `sub_employee_info` VALUES (7, 6, 3, 'GL0003', '何雄明', NULL, '$2b$10$S4YfKQlNBLoja5jVH.Ileuu7N1Tvjs2oHbc6hlFAKnVnLFRvpltLK', 13, '技术部副总', 20, NULL, 1, '2025-10-27 20:45:10', '2025-10-28 15:04:05');
INSERT INTO `sub_employee_info` VALUES (8, 6, 3, 'GL0004', '粟云', NULL, '$2b$10$IBOfatJHLzI7B1oQ.PGmRedBSla0r7.yDZwf0yY45HuN9wGGSY7Lu', 15, '生产部副总', 20, NULL, 1, '2025-10-27 20:49:12', '2025-10-28 13:47:49');

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
INSERT INTO `sub_equipment_code` VALUES (6, 6, 3, 'JX01', '打字机', 2, 6, '10', 20, 2, '', 1, '2025-10-18 10:17:12', '2025-10-23 23:47:35');
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
INSERT INTO `sub_material_bom` VALUES (18, 1, 1, 11, 9, 0, 1, '2025-09-25 14:39:31', '2025-10-31 10:10:11');
INSERT INTO `sub_material_bom` VALUES (19, 1, 1, 14, 10, 0, 1, '2025-09-25 14:39:45', '2025-10-31 10:10:11');
INSERT INTO `sub_material_bom` VALUES (20, 1, 1, 14, 13, 0, 1, '2025-09-25 14:44:26', '2025-10-31 10:10:11');
INSERT INTO `sub_material_bom` VALUES (21, 1, 1, 14, 10, 0, 1, '2025-09-25 14:44:36', '2025-10-31 10:10:31');
INSERT INTO `sub_material_bom` VALUES (22, 3, 12, 20, 21, 1, 0, '2025-10-18 14:29:06', '2025-10-18 15:10:13');
INSERT INTO `sub_material_bom` VALUES (23, 3, 6, 20, 21, 0, 1, '2025-10-18 14:30:01', '2025-10-30 17:14:43');
INSERT INTO `sub_material_bom` VALUES (24, 3, 6, 20, 27, 0, 1, '2025-10-18 15:08:30', '2025-10-30 17:14:43');
INSERT INTO `sub_material_bom` VALUES (25, 1, 1, 15, 8, 0, 1, '2025-10-21 21:04:49', '2025-10-31 10:10:11');
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
) ENGINE = InnoDB AUTO_INCREMENT = 68 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '材料BOM表子表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_material_bom_child
-- ----------------------------
INSERT INTO `sub_material_bom_child` VALUES (6, 12, 2, 12, NULL, 0, '2025-08-13 10:38:41', '2025-08-13 10:38:41');
INSERT INTO `sub_material_bom_child` VALUES (7, 12, 2, 22, NULL, 0, '2025-08-13 10:38:41', '2025-08-13 10:38:41');
INSERT INTO `sub_material_bom_child` VALUES (8, 12, 2, 24, NULL, 0, '2025-08-13 10:38:41', '2025-08-13 10:38:41');
INSERT INTO `sub_material_bom_child` VALUES (9, 11, 2, 23, NULL, 0, '2025-08-13 10:59:47', '2025-08-13 10:59:47');
INSERT INTO `sub_material_bom_child` VALUES (10, 11, 2, 34, NULL, 0, '2025-08-13 10:59:47', '2025-08-13 10:59:47');
INSERT INTO `sub_material_bom_child` VALUES (11, 10, 2, 12, NULL, 0, '2025-08-13 10:59:52', '2025-08-13 10:59:52');
INSERT INTO `sub_material_bom_child` VALUES (12, 13, 3, 12, NULL, 0, '2025-08-13 14:41:35', '2025-08-17 09:48:42');
INSERT INTO `sub_material_bom_child` VALUES (13, 14, 2, 12, NULL, 0, '2025-08-13 14:41:55', '2025-08-13 14:41:55');
INSERT INTO `sub_material_bom_child` VALUES (14, 14, 2, 22, NULL, 0, '2025-08-13 14:41:55', '2025-08-13 14:41:55');
INSERT INTO `sub_material_bom_child` VALUES (15, 14, 3, 24, NULL, 0, '2025-08-13 14:41:55', '2025-08-17 09:38:34');
INSERT INTO `sub_material_bom_child` VALUES (16, 15, 2, 23, NULL, 0, '2025-08-13 14:42:03', '2025-08-13 14:42:03');
INSERT INTO `sub_material_bom_child` VALUES (17, 15, 2, 34, NULL, 0, '2025-08-13 14:42:03', '2025-08-13 14:42:03');
INSERT INTO `sub_material_bom_child` VALUES (18, 16, 3, 12, NULL, 0, '2025-08-21 09:35:05', '2025-08-21 09:35:05');
INSERT INTO `sub_material_bom_child` VALUES (19, 17, 2, 600, NULL, 0, '2025-09-25 14:38:28', '2025-09-25 14:38:28');
INSERT INTO `sub_material_bom_child` VALUES (20, 17, 3, 400, NULL, 0, '2025-09-25 14:38:28', '2025-09-25 14:38:28');
INSERT INTO `sub_material_bom_child` VALUES (21, 18, 3, 900, NULL, 0, '2025-09-25 14:39:31', '2025-09-25 14:39:31');
INSERT INTO `sub_material_bom_child` VALUES (22, 19, 2, 600, NULL, 0, '2025-09-25 14:39:45', '2025-09-25 14:39:45');
INSERT INTO `sub_material_bom_child` VALUES (23, 19, 3, 70, NULL, 0, '2025-09-25 14:39:45', '2025-10-31 10:09:10');
INSERT INTO `sub_material_bom_child` VALUES (24, 20, 2, 198, NULL, 0, '2025-09-25 14:44:26', '2025-09-25 14:44:26');
INSERT INTO `sub_material_bom_child` VALUES (25, 20, 2, 158, NULL, 0, '2025-09-25 14:44:26', '2025-09-25 14:44:26');
INSERT INTO `sub_material_bom_child` VALUES (26, 21, 2, 485, NULL, 0, '2025-09-25 14:44:36', '2025-09-25 14:44:36');
INSERT INTO `sub_material_bom_child` VALUES (27, 22, 4, 5, NULL, 0, '2025-10-18 14:29:06', '2025-10-18 14:29:06');
INSERT INTO `sub_material_bom_child` VALUES (29, 24, 5, 1, NULL, 0, '2025-10-18 15:08:30', '2025-10-30 16:44:29');
INSERT INTO `sub_material_bom_child` VALUES (31, 23, 4, 1, NULL, 0, '2025-10-19 15:37:50', '2025-10-30 16:43:39');
INSERT INTO `sub_material_bom_child` VALUES (34, 25, 3, 30, NULL, 0, '2025-10-21 21:04:49', '2025-10-21 21:04:49');
INSERT INTO `sub_material_bom_child` VALUES (36, 25, 2, 60, NULL, 0, '2025-10-21 21:04:49', '2025-10-21 21:04:49');
INSERT INTO `sub_material_bom_child` VALUES (37, 25, 3, 40, NULL, 0, '2025-10-21 21:23:26', '2025-10-21 21:23:26');
INSERT INTO `sub_material_bom_child` VALUES (38, 25, 2, 50, NULL, 0, '2025-10-21 21:23:26', '2025-10-21 21:23:26');
INSERT INTO `sub_material_bom_child` VALUES (39, 26, 6, 1, NULL, 0, '2025-10-30 16:49:20', '2025-10-30 16:49:20');
INSERT INTO `sub_material_bom_child` VALUES (40, 27, 7, 1, NULL, 0, '2025-10-30 16:49:58', '2025-10-30 16:49:58');
INSERT INTO `sub_material_bom_child` VALUES (41, 28, 8, 1, NULL, 0, '2025-10-30 16:54:25', '2025-10-30 16:54:25');
INSERT INTO `sub_material_bom_child` VALUES (42, 28, 9, 1, NULL, 0, '2025-10-30 16:54:25', '2025-10-30 16:54:25');
INSERT INTO `sub_material_bom_child` VALUES (43, 29, 9, 3, NULL, 0, '2025-10-30 16:55:14', '2025-10-30 16:55:14');
INSERT INTO `sub_material_bom_child` VALUES (44, 30, 10, 1, NULL, 0, '2025-10-30 16:58:07', '2025-10-30 16:58:07');
INSERT INTO `sub_material_bom_child` VALUES (45, 30, 9, 2, NULL, 0, '2025-10-30 16:58:07', '2025-10-30 16:58:07');
INSERT INTO `sub_material_bom_child` VALUES (46, 30, 11, 1, NULL, 0, '2025-10-30 16:58:07', '2025-10-30 16:58:07');
INSERT INTO `sub_material_bom_child` VALUES (47, 30, 12, 1, NULL, 0, '2025-10-30 16:58:07', '2025-10-30 16:58:07');
INSERT INTO `sub_material_bom_child` VALUES (48, 31, 13, 1, NULL, 0, '2025-10-30 16:59:47', '2025-10-30 16:59:47');
INSERT INTO `sub_material_bom_child` VALUES (49, 31, 12, 1, NULL, 0, '2025-10-30 16:59:47', '2025-10-30 16:59:47');
INSERT INTO `sub_material_bom_child` VALUES (50, 32, 14, 1, NULL, 0, '2025-10-30 17:01:11', '2025-10-30 17:01:11');
INSERT INTO `sub_material_bom_child` VALUES (51, 33, 15, 1, NULL, 0, '2025-10-30 17:01:55', '2025-10-30 17:01:55');
INSERT INTO `sub_material_bom_child` VALUES (52, 34, 16, 1, NULL, 0, '2025-10-30 17:02:54', '2025-10-30 17:02:54');
INSERT INTO `sub_material_bom_child` VALUES (53, 34, 17, 1, NULL, 0, '2025-10-30 17:02:54', '2025-10-30 17:02:54');
INSERT INTO `sub_material_bom_child` VALUES (54, 35, 18, 1, NULL, 0, '2025-10-30 17:04:53', '2025-10-30 17:04:53');
INSERT INTO `sub_material_bom_child` VALUES (55, 35, 12, 3, NULL, 0, '2025-10-30 17:04:53', '2025-10-30 17:04:53');
INSERT INTO `sub_material_bom_child` VALUES (56, 35, 20, 2, NULL, 0, '2025-10-30 17:04:53', '2025-10-30 17:04:53');
INSERT INTO `sub_material_bom_child` VALUES (57, 36, 19, 1, NULL, 0, '2025-10-30 17:05:52', '2025-10-30 17:05:52');
INSERT INTO `sub_material_bom_child` VALUES (58, 37, 21, 1, NULL, 0, '2025-10-30 17:07:19', '2025-10-30 17:07:19');
INSERT INTO `sub_material_bom_child` VALUES (59, 37, 23, 1, NULL, 0, '2025-10-30 17:07:19', '2025-10-30 17:07:19');
INSERT INTO `sub_material_bom_child` VALUES (60, 38, 22, 1, NULL, 0, '2025-10-30 17:07:53', '2025-10-30 17:07:53');
INSERT INTO `sub_material_bom_child` VALUES (61, 39, 27, 2, NULL, 0, '2025-10-30 17:12:29', '2025-10-30 17:12:29');
INSERT INTO `sub_material_bom_child` VALUES (62, 40, 24, 1, NULL, 0, '2025-10-30 17:12:55', '2025-10-30 17:12:55');
INSERT INTO `sub_material_bom_child` VALUES (63, 41, 25, 1, 1, 0, '2025-10-30 17:13:58', '2025-10-31 10:20:32');
INSERT INTO `sub_material_bom_child` VALUES (64, 41, 26, 1, 2, 0, '2025-10-30 17:13:58', '2025-10-31 10:20:06');
INSERT INTO `sub_material_bom_child` VALUES (65, 18, 2, 70, NULL, 0, '2025-10-31 10:09:20', '2025-10-31 10:09:20');
INSERT INTO `sub_material_bom_child` VALUES (67, 21, 3, 70, NULL, 0, '2025-10-31 10:10:23', '2025-10-31 10:10:31');

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
  `delivery` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '送货方式',
  `packaging` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '包装要求',
  `transaction_currency` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '交易币别',
  `other_transaction_terms` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '交易条件',
  `remarks` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '备注',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '材料报价信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_material_quote
-- ----------------------------
INSERT INTO `sub_material_quote` VALUES (1, 1, 1, 2, 2, 24, NULL, '1111', '1111', '1111', '1111', '1111', 1, '2025-07-27 21:43:20', '2025-09-26 13:28:03');
INSERT INTO `sub_material_quote` VALUES (2, 1, 1, 1, 2, 21, NULL, '2222', '222', '22', '222', '22', 1, '2025-07-27 22:40:03', '2025-09-26 13:41:17');
INSERT INTO `sub_material_quote` VALUES (3, 1, 1, 2, 3, 111, NULL, '515', '2www', '1', '1www', 'ee1eee', 1, '2025-10-23 13:26:53', '2025-10-23 13:26:53');

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
) ENGINE = InnoDB AUTO_INCREMENT = 400 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户操作日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_operation_history
-- ----------------------------
INSERT INTO `sub_operation_history` VALUES (1, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-10-24 01:29:08');
INSERT INTO `sub_operation_history` VALUES (2, 1, 1, '我是名字', 'login', '登录', '用户{ 我是名字 }成功登录', '{\"newData\":{\"username\":\"admin1\",\"password\":\"***\"}}', '2025-10-24 02:34:18');
INSERT INTO `sub_operation_history` VALUES (3, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-10-24 02:35:32');
INSERT INTO `sub_operation_history` VALUES (4, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-10-24 02:37:48');
INSERT INTO `sub_operation_history` VALUES (5, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-10-24 02:39:19');
INSERT INTO `sub_operation_history` VALUES (6, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-10-24 02:39:34');
INSERT INTO `sub_operation_history` VALUES (7, 3, 6, '徐庆华', 'update', '生产制程', '修改生产制程：名称：A备料组', '{\"newData\":{\"id\":6,\"name\":\"A备料组\"}}', '2025-10-24 02:50:41');
INSERT INTO `sub_operation_history` VALUES (8, 3, 6, '徐庆华', 'update', '生产制程', '修改生产制程：名称：B焊接组', '{\"newData\":{\"id\":7,\"name\":\"B焊接组\"}}', '2025-10-24 02:50:49');
INSERT INTO `sub_operation_history` VALUES (9, 3, 6, '徐庆华', 'update', '生产制程', '修改生产制程：名称：C热处理', '{\"newData\":{\"id\":8,\"name\":\"C热处理\"}}', '2025-10-24 02:50:55');
INSERT INTO `sub_operation_history` VALUES (10, 3, 6, '徐庆华', 'update', '生产制程', '修改生产制程：名称：D后段组', '{\"newData\":{\"id\":11,\"name\":\"D后段组\"}}', '2025-10-24 02:52:17');
INSERT INTO `sub_operation_history` VALUES (11, 3, 6, '徐庆华', 'update', '生产制程', '修改生产制程：名称：E研磨组', '{\"newData\":{\"id\":9,\"name\":\"E研磨组\"}}', '2025-10-24 02:52:24');
INSERT INTO `sub_operation_history` VALUES (12, 3, 6, '徐庆华', 'update', '生产制程', '修改生产制程：名称：F补土组', '{\"newData\":{\"id\":10,\"name\":\"F补土组\"}}', '2025-10-24 02:52:30');
INSERT INTO `sub_operation_history` VALUES (13, 3, 6, '徐庆华', 'add', '供应商资料', '新增供应商资料，供应商编码：GA002', '{\"newData\":{\"supplier_code\":\"GA002\",\"supplier_abbreviation\":\"城至\",\"contact_person\":\"吴总\",\"contact_information\":\"12345678901\",\"supplier_full_name\":\"东莞市城至精密五金有限公司\",\"supplier_address\":\"东莞市万江区尖沙咀\",\"supplier_category\":\"委外加工\",\"supply_method\":\"送货上门\",\"transaction_method\":\"现金\",\"transaction_currency\":\"人民币\",\"other_transaction_terms\":\"月结60天\"}}', '2025-10-24 03:26:23');
INSERT INTO `sub_operation_history` VALUES (14, 1, 1, '我是名字', 'login', '登录', '用户{ 我是名字 }成功登录', '{\"newData\":{\"username\":\"admin1\",\"password\":\"***\"}}', '2025-10-24 04:57:17');
INSERT INTO `sub_operation_history` VALUES (15, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-10-24 05:18:59');
INSERT INTO `sub_operation_history` VALUES (16, 1, 1, '我是名字', 'login', '登录', '用户{ 我是名字 }成功登录', '{\"newData\":{\"username\":\"admin1\",\"password\":\"***\"}}', '2025-10-24 05:36:10');
INSERT INTO `sub_operation_history` VALUES (17, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-10-24 06:00:23');
INSERT INTO `sub_operation_history` VALUES (18, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-10-25 02:42:40');
INSERT INTO `sub_operation_history` VALUES (19, 1, 1, '我是名字', 'login', '登录', '用户{ 我是名字 }成功登录', '{\"newData\":{\"username\":\"admin1\",\"password\":\"***\"}}', '2025-10-26 10:19:05');
INSERT INTO `sub_operation_history` VALUES (20, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-10-27 00:58:33');
INSERT INTO `sub_operation_history` VALUES (21, 3, 6, '徐庆华', 'keyup', '工艺BOM', '存档工艺BOM，产品编码：WA-A00001，部件编码：X001，材料编码：PA001,PA002；', '{\"newData\":{\"ids\":[59],\"archive\":0}}', '2025-10-27 01:18:16');
INSERT INTO `sub_operation_history` VALUES (22, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-10-27 03:53:52');
INSERT INTO `sub_operation_history` VALUES (23, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-10-27 06:34:33');
INSERT INTO `sub_operation_history` VALUES (24, 3, 6, '徐庆华', 'add', '产品编码', '新增产品编码：WA-A00002', '{\"newData\":{\"product_code\":\"WA-A00002\",\"product_name\":\"0612铝车架\",\"drawing\":\"0612\",\"model\":\"山地车\",\"specification\":\"32寸\",\"other_features\":\"配载重货架\",\"component_structure\":\"整体车架+独立货架\",\"unit\":\"套\",\"production_requirements\":\"1.产品表面研磨清洗；2.产品杜绝补土；3.按订单要求打字码\"}}', '2025-10-27 06:44:03');
INSERT INTO `sub_operation_history` VALUES (25, 3, 6, '徐庆华', 'update', '部件编码', '修改部件编码：X001', '{\"newData\":{\"id\":21,\"company_id\":3,\"user_id\":12,\"part_code\":\"X001\",\"part_name\":\"车首管\",\"model\":\"\",\"specification\":\"\",\"other_features\":\"\",\"unit\":\"PCS\",\"production_requirements\":\"\",\"remarks\":\"\",\"is_deleted\":1,\"created_at\":\"2025-10-18\",\"updated_at\":\"2025-10-18\"}}', '2025-10-27 06:54:38');
INSERT INTO `sub_operation_history` VALUES (26, 3, 6, '徐庆华', 'update', '部件编码', '修改部件编码：X002', '{\"newData\":{\"id\":22,\"company_id\":3,\"user_id\":12,\"part_code\":\"X002\",\"part_name\":\"主梁管\",\"model\":\"\",\"specification\":\"\",\"other_features\":\"\",\"unit\":\"PCS\",\"production_requirements\":\"\",\"remarks\":\"\",\"is_deleted\":1,\"created_at\":\"2025-10-18\",\"updated_at\":\"2025-10-18\"}}', '2025-10-27 06:54:57');
INSERT INTO `sub_operation_history` VALUES (27, 3, 6, '徐庆华', 'add', '部件编码', '新增部件编码：X003', '{\"newData\":{\"part_code\":\"X003\",\"part_name\":\"辅助管\",\"model\":\"\",\"specification\":\"\",\"other_features\":\"\",\"unit\":\"PCS\",\"production_requirements\":\"\",\"remarks\":\"\"}}', '2025-10-27 06:58:25');
INSERT INTO `sub_operation_history` VALUES (28, 3, 6, '徐庆华', 'add', '部件编码', '新增部件编码：X004', '{\"newData\":{\"part_code\":\"X004\",\"part_name\":\"上管\",\"model\":\"\",\"specification\":\"\",\"other_features\":\"\",\"unit\":\"PCS\",\"production_requirements\":\"\",\"remarks\":\"\"}}', '2025-10-27 07:03:56');
INSERT INTO `sub_operation_history` VALUES (29, 3, 6, '徐庆华', 'add', '部件编码', '新增部件编码：X005', '{\"newData\":{\"part_code\":\"X005\",\"part_name\":\"下管\",\"model\":\"\",\"specification\":\"\",\"other_features\":\"\",\"unit\":\"PCS\",\"production_requirements\":\"\",\"remarks\":\"\"}}', '2025-10-27 07:04:18');
INSERT INTO `sub_operation_history` VALUES (30, 3, 6, '徐庆华', 'add', '部件编码', '新增部件编码：X006', '{\"newData\":{\"part_code\":\"X006\",\"part_name\":\"座管\",\"model\":\"\",\"specification\":\"\",\"other_features\":\"\",\"unit\":\"PCS\",\"production_requirements\":\"\",\"remarks\":\"\"}}', '2025-10-27 07:04:59');
INSERT INTO `sub_operation_history` VALUES (31, 3, 6, '徐庆华', 'add', '部件编码', '新增部件编码：X007', '{\"newData\":{\"part_code\":\"X007\",\"part_name\":\"吴桐\",\"model\":\"\",\"specification\":\"\",\"other_features\":\"\",\"unit\":\"PCS\",\"production_requirements\":\"\",\"remarks\":\"\"}}', '2025-10-27 07:06:48');
INSERT INTO `sub_operation_history` VALUES (32, 3, 6, '徐庆华', 'add', '部件编码', '新增部件编码：X008', '{\"newData\":{\"part_code\":\"X008\",\"part_name\":\"后上叉R\",\"model\":\"\",\"specification\":\"\",\"other_features\":\"\",\"unit\":\"PCS\",\"production_requirements\":\"\",\"remarks\":\"\"}}', '2025-10-27 07:07:21');
INSERT INTO `sub_operation_history` VALUES (33, 3, 6, '徐庆华', 'add', '部件编码', '新增部件编码：X009', '{\"newData\":{\"part_code\":\"X009\",\"part_name\":\"后上叉L\",\"model\":\"\",\"specification\":\"\",\"other_features\":\"\",\"unit\":\"PCS\",\"production_requirements\":\"\",\"remarks\":\"\"}}', '2025-10-27 07:11:47');
INSERT INTO `sub_operation_history` VALUES (34, 3, 6, '徐庆华', 'add', '部件编码', '新增部件编码：X010', '{\"newData\":{\"part_code\":\"X010\",\"part_name\":\"后下叉R\",\"model\":\"\",\"specification\":\"\",\"other_features\":\"\",\"unit\":\"PCS\",\"production_requirements\":\"\",\"remarks\":\"\"}}', '2025-10-27 07:12:39');
INSERT INTO `sub_operation_history` VALUES (35, 3, 6, '徐庆华', 'add', '部件编码', '新增部件编码：X011', '{\"newData\":{\"part_code\":\"X011\",\"part_name\":\"后下叉L\",\"model\":\"\",\"specification\":\"\",\"other_features\":\"\",\"unit\":\"PCS\",\"production_requirements\":\"\",\"remarks\":\"\"}}', '2025-10-27 07:12:57');
INSERT INTO `sub_operation_history` VALUES (36, 3, 6, '徐庆华', 'add', '部件编码', '新增部件编码：X012', '{\"newData\":{\"part_code\":\"X012\",\"part_name\":\"电池盒板\",\"model\":\"\",\"specification\":\"\",\"other_features\":\"\",\"unit\":\"PCS\",\"production_requirements\":\"\",\"remarks\":\"\"}}', '2025-10-27 07:23:24');
INSERT INTO `sub_operation_history` VALUES (37, 3, 6, '徐庆华', 'add', '部件编码', '新增部件编码：X013', '{\"newData\":{\"part_code\":\"X013\",\"part_name\":\"手提管\",\"model\":\"\",\"specification\":\"\",\"other_features\":\"\",\"unit\":\"PCS\",\"production_requirements\":\"\",\"remarks\":\"\"}}', '2025-10-27 07:23:46');
INSERT INTO `sub_operation_history` VALUES (38, 3, 6, '徐庆华', 'add', '部件编码', '新增部件编码：X014', '{\"newData\":{\"part_code\":\"X014\",\"part_name\":\"中管\",\"model\":\"\",\"specification\":\"\",\"other_features\":\"\",\"unit\":\"PCS\",\"production_requirements\":\"\",\"remarks\":\"\"}}', '2025-10-27 07:24:25');
INSERT INTO `sub_operation_history` VALUES (39, 3, 6, '徐庆华', 'add', '部件编码', '新增部件编码：X016', '{\"newData\":{\"part_code\":\"X016\",\"part_name\":\"上支杆\",\"model\":\"\",\"specification\":\"\",\"other_features\":\"\",\"unit\":\"PCS\",\"production_requirements\":\"\",\"remarks\":\"\"}}', '2025-10-27 07:24:50');
INSERT INTO `sub_operation_history` VALUES (40, 3, 6, '徐庆华', 'add', '部件编码', '新增部件编码：X017', '{\"newData\":{\"part_code\":\"X017\",\"part_name\":\"下枝杆\",\"model\":\"\",\"specification\":\"\",\"other_features\":\"\",\"unit\":\"PCS\",\"production_requirements\":\"\",\"remarks\":\"\"}}', '2025-10-27 07:25:37');
INSERT INTO `sub_operation_history` VALUES (41, 3, 6, '徐庆华', 'update', '部件编码', '修改部件编码：X015', '{\"newData\":{\"id\":35,\"company_id\":3,\"user_id\":6,\"part_code\":\"X015\",\"part_name\":\"上支杆\",\"model\":\"\",\"specification\":\"\",\"other_features\":\"\",\"unit\":\"PCS\",\"production_requirements\":\"\",\"remarks\":\"\",\"is_deleted\":1,\"created_at\":\"2025-10-27\",\"updated_at\":\"2025-10-27\"}}', '2025-10-27 07:26:02');
INSERT INTO `sub_operation_history` VALUES (42, 3, 6, '徐庆华', 'update', '部件编码', '修改部件编码：X016', '{\"newData\":{\"id\":36,\"company_id\":3,\"user_id\":6,\"part_code\":\"X016\",\"part_name\":\"下枝杆\",\"model\":\"\",\"specification\":\"\",\"other_features\":\"\",\"unit\":\"PCS\",\"production_requirements\":\"\",\"remarks\":\"\",\"is_deleted\":1,\"created_at\":\"2025-10-27\",\"updated_at\":\"2025-10-27\"}}', '2025-10-27 07:26:12');
INSERT INTO `sub_operation_history` VALUES (43, 3, 6, '徐庆华', 'add', '部件编码', '新增部件编码：X017', '{\"newData\":{\"part_code\":\"X017\",\"part_name\":\"下叉\",\"model\":\"\",\"specification\":\"\",\"other_features\":\"\",\"unit\":\"PCS\",\"production_requirements\":\"\",\"remarks\":\"\"}}', '2025-10-27 07:27:35');
INSERT INTO `sub_operation_history` VALUES (44, 3, 6, '徐庆华', 'add', '部件编码', '新增部件编码：X018', '{\"newData\":{\"part_code\":\"X018\",\"part_name\":\"过线管\",\"model\":\"\",\"specification\":\"\",\"other_features\":\"\",\"unit\":\"PCS\",\"production_requirements\":\"\",\"remarks\":\"\"}}', '2025-10-27 07:28:00');
INSERT INTO `sub_operation_history` VALUES (45, 3, 6, '徐庆华', 'add', '部件编码', '新增部件编码：X019', '{\"newData\":{\"part_code\":\"X019\",\"part_name\":\"上叉\",\"model\":\"\",\"specification\":\"\",\"other_features\":\"\",\"unit\":\"PCS\",\"production_requirements\":\"\",\"remarks\":\"\"}}', '2025-10-27 07:28:29');
INSERT INTO `sub_operation_history` VALUES (46, 3, 6, '徐庆华', 'add', '部件编码', '新增部件编码：Y001', '{\"newData\":{\"part_code\":\"Y001\",\"part_name\":\"左钩爪\",\"model\":\"\",\"specification\":\"\",\"other_features\":\"\",\"unit\":\"PCS\",\"production_requirements\":\"\",\"remarks\":\"\"}}', '2025-10-27 07:28:56');
INSERT INTO `sub_operation_history` VALUES (47, 3, 6, '徐庆华', 'add', '部件编码', '新增部件编码：Y002', '{\"newData\":{\"part_code\":\"Y002\",\"part_name\":\"右钩爪\",\"model\":\"\",\"specification\":\"\",\"other_features\":\"\",\"unit\":\"PCS\",\"production_requirements\":\"\",\"remarks\":\"\"}}', '2025-10-27 07:29:16');
INSERT INTO `sub_operation_history` VALUES (48, 3, 6, '徐庆华', 'add', '部件编码', '新增部件编码：Y003', '{\"newData\":{\"part_code\":\"Y003\",\"part_name\":\"上叉支杆\",\"model\":\"\",\"specification\":\"\",\"other_features\":\"\",\"unit\":\"PCS\",\"production_requirements\":\"\",\"remarks\":\"\"}}', '2025-10-27 07:30:12');
INSERT INTO `sub_operation_history` VALUES (49, 3, 6, '徐庆华', 'add', '部件编码', '新增部件编码：Y004', '{\"newData\":{\"part_code\":\"Y004\",\"part_name\":\"组立折叠器\",\"model\":\"\",\"specification\":\"\",\"other_features\":\"\",\"unit\":\"PCS\",\"production_requirements\":\"\",\"remarks\":\"\"}}', '2025-10-27 07:30:34');
INSERT INTO `sub_operation_history` VALUES (50, 3, 6, '徐庆华', 'add', '部件编码', '新增部件编码：Y005', '{\"newData\":{\"part_code\":\"Y005\",\"part_name\":\"组立前三角\",\"model\":\"\",\"specification\":\"\",\"other_features\":\"\",\"unit\":\"PCS\",\"production_requirements\":\"\",\"remarks\":\"\"}}', '2025-10-27 07:31:01');
INSERT INTO `sub_operation_history` VALUES (51, 3, 6, '徐庆华', 'add', '部件编码', '新增部件编码：Y006', '{\"newData\":{\"part_code\":\"Y006\",\"part_name\":\"组立后三角\",\"model\":\"\",\"specification\":\"\",\"other_features\":\"\",\"unit\":\"PCS\",\"production_requirements\":\"\",\"remarks\":\"\"}}', '2025-10-27 07:31:21');
INSERT INTO `sub_operation_history` VALUES (52, 3, 6, '徐庆华', 'add', '部件编码', '新增部件编码：Z001', '{\"newData\":{\"part_code\":\"Z001\",\"part_name\":\"成品车架\",\"model\":\"\",\"specification\":\"\",\"other_features\":\"\",\"unit\":\"PCS\",\"production_requirements\":\"\",\"remarks\":\"\"}}', '2025-10-27 07:32:05');
INSERT INTO `sub_operation_history` VALUES (53, 3, 6, '徐庆华', 'add', '部件编码', '新增部件编码：Z002', '{\"newData\":{\"part_code\":\"Z002\",\"part_name\":\"前三角\",\"model\":\"\",\"specification\":\"\",\"other_features\":\"\",\"unit\":\"PCS\",\"production_requirements\":\"\",\"remarks\":\"\"}}', '2025-10-27 07:32:27');
INSERT INTO `sub_operation_history` VALUES (54, 3, 6, '徐庆华', 'add', '部件编码', '新增部件编码：Z003', '{\"newData\":{\"part_code\":\"Z003\",\"part_name\":\"后三角\",\"model\":\"\",\"specification\":\"\",\"other_features\":\"\",\"unit\":\"PCS\",\"production_requirements\":\"\",\"remarks\":\"\"}}', '2025-10-27 07:32:48');
INSERT INTO `sub_operation_history` VALUES (55, 3, 6, '徐庆华', 'add', '部件编码', '新增部件编码：Z004', '{\"newData\":{\"part_code\":\"Z004\",\"part_name\":\"上叉支杆\",\"model\":\"\",\"specification\":\"\",\"other_features\":\"\",\"unit\":\"PCS\",\"production_requirements\":\"\",\"remarks\":\"\"}}', '2025-10-27 07:33:10');
INSERT INTO `sub_operation_history` VALUES (56, 3, 6, '徐庆华', 'update', '原材料编码', '修改原材料编码：H0101-0089', '{\"newData\":{\"id\":4,\"user_id\":12,\"company_id\":3,\"material_code\":\"H0101-0089\",\"material_name\":\"头管\",\"model\":\"JHD-AT-0074*146L\",\"specification\":\"JHD-AT-0074*146L\",\"other_features\":\"\",\"usage_unit\":\"PCS\",\"purchase_unit\":\"PCS\",\"remarks\":\"\",\"is_deleted\":1,\"created_at\":\"2025-10-18\",\"updated_at\":\"2025-10-18\"}}', '2025-10-27 07:47:47');
INSERT INTO `sub_operation_history` VALUES (57, 3, 6, '徐庆华', 'update', '原材料编码', '修改原材料编码：H0201-0053', '{\"newData\":{\"id\":5,\"user_id\":12,\"company_id\":3,\"material_code\":\"H0201-0053\",\"material_name\":\"普通五通\",\"model\":\"φ43*4.6T*100L JHD-AK-002G偏心铣弧口\",\"specification\":\"φ43*4.6T*100L JHD-AK-002G偏心铣弧口\",\"other_features\":\"\",\"usage_unit\":\"PCS\",\"purchase_unit\":\"PCS\",\"remarks\":\"\",\"is_deleted\":1,\"created_at\":\"2025-10-18\",\"updated_at\":\"2025-10-18\"}}', '2025-10-27 07:49:59');
INSERT INTO `sub_operation_history` VALUES (58, 3, 6, '徐庆华', 'update', '原材料编码', '修改原材料编码：M0101-0668', '{\"newData\":{\"id\":6,\"user_id\":12,\"company_id\":3,\"material_code\":\"M0101-0668\",\"material_name\":\"中管\",\"model\":\"φ40.8*2.2T*410L\",\"specification\":\"φ40.8*2.2T*410L\",\"other_features\":\"\",\"usage_unit\":\"PCS\",\"purchase_unit\":\"PCS\",\"remarks\":\"\",\"is_deleted\":1,\"created_at\":\"2025-10-18\",\"updated_at\":\"2025-10-18\"}}', '2025-10-27 07:51:05');
INSERT INTO `sub_operation_history` VALUES (59, 3, 6, '徐庆华', 'add', '原材料编码', '新增原材料编码：M0101-1123', '{\"newData\":{\"material_code\":\"M0101-1123\",\"material_name\":\"手提管\",\"model\":\"φ22.2*2.0T*200L\",\"specification\":\"φ22.2*2.0T*200L\",\"other_features\":\"\",\"usage_unit\":\"PCS\",\"purchase_unit\":\"PCS\",\"remarks\":\"\"}}', '2025-10-27 08:17:44');
INSERT INTO `sub_operation_history` VALUES (60, 3, 6, '徐庆华', 'update', '原材料编码', '修改原材料编码：H0101-0089', '{\"newData\":{\"id\":4,\"user_id\":6,\"company_id\":3,\"material_code\":\"H0101-0089\",\"material_name\":\"车首管\",\"model\":\"JHD-AT-0074*146L\",\"specification\":\"JHD-AT-0074*146L\",\"other_features\":\"\",\"usage_unit\":\"PCS\",\"purchase_unit\":\"PCS\",\"remarks\":\"\",\"is_deleted\":1,\"created_at\":\"2025-10-18\",\"updated_at\":\"2025-10-27\"}}', '2025-10-27 08:18:17');
INSERT INTO `sub_operation_history` VALUES (61, 3, 6, '徐庆华', 'update', '原材料编码', '修改原材料编码：H0201-0053', '{\"newData\":{\"id\":5,\"user_id\":6,\"company_id\":3,\"material_code\":\"H0201-0053\",\"material_name\":\"五通\",\"model\":\"φ43*4.6T*100L JHD-AK-002G偏心铣弧口\",\"specification\":\"φ43*4.6T*100L JHD-AK-002G偏心铣弧口\",\"other_features\":\"\",\"usage_unit\":\"PCS\",\"purchase_unit\":\"PCS\",\"remarks\":\"\",\"is_deleted\":1,\"created_at\":\"2025-10-18\",\"updated_at\":\"2025-10-27\"}}', '2025-10-27 08:18:25');
INSERT INTO `sub_operation_history` VALUES (62, 3, 6, '徐庆华', 'add', '原材料编码', '新增原材料编码：M0101-0565', '{\"newData\":{\"material_code\":\"M0101-0565\",\"material_name\":\"下管\",\"model\":\"φ28.6*2.0T*220L\",\"specification\":\"φ28.6*2.0T*220L\",\"other_features\":\"\",\"usage_unit\":\"PCS\",\"purchase_unit\":\"PCS\",\"remarks\":\"\"}}', '2025-10-27 08:19:44');
INSERT INTO `sub_operation_history` VALUES (63, 3, 6, '徐庆华', 'add', '原材料编码', '新增原材料编码：M0103-0015', '{\"newData\":{\"material_code\":\"M0103-0015\",\"material_name\":\"过线管\",\"model\":\"方27*17*2000L(CM-15114)(成品15L,一分百)\",\"specification\":\"方27*17*2000L(CM-15114)(成品15L,一分百)\",\"other_features\":\"\",\"usage_unit\":\"PCS\",\"purchase_unit\":\"KG\",\"remarks\":\"\"}}', '2025-10-27 08:21:06');
INSERT INTO `sub_operation_history` VALUES (64, 3, 6, '徐庆华', 'update', '原材料编码', '修改原材料编码：M0101-1123', '{\"newData\":{\"id\":7,\"user_id\":6,\"company_id\":3,\"material_code\":\"M0101-1123\",\"material_name\":\"手提管\",\"model\":\"φ22.2*2.0T*200L\",\"specification\":\"φ22.2*2.0T*200L\",\"other_features\":\"\",\"usage_unit\":\"PCS\",\"purchase_unit\":\"KG\",\"remarks\":\"\",\"is_deleted\":1,\"created_at\":\"2025-10-27\",\"updated_at\":\"2025-10-27\"}}', '2025-10-27 08:21:15');
INSERT INTO `sub_operation_history` VALUES (65, 3, 6, '徐庆华', 'update', '原材料编码', '修改原材料编码：M0101-0668', '{\"newData\":{\"id\":6,\"user_id\":6,\"company_id\":3,\"material_code\":\"M0101-0668\",\"material_name\":\"中管\",\"model\":\"φ40.8*2.2T*410L\",\"specification\":\"φ40.8*2.2T*410L\",\"other_features\":\"\",\"usage_unit\":\"PCS\",\"purchase_unit\":\"KG\",\"remarks\":\"\",\"is_deleted\":1,\"created_at\":\"2025-10-18\",\"updated_at\":\"2025-10-27\"}}', '2025-10-27 08:21:23');
INSERT INTO `sub_operation_history` VALUES (66, 3, 6, '徐庆华', 'update', '原材料编码', '修改原材料编码：M0101-0565', '{\"newData\":{\"id\":8,\"user_id\":6,\"company_id\":3,\"material_code\":\"M0101-0565\",\"material_name\":\"下管\",\"model\":\"φ28.6*2.0T*220L\",\"specification\":\"φ28.6*2.0T*220L\",\"other_features\":\"\",\"usage_unit\":\"PCS\",\"purchase_unit\":\"KG\",\"remarks\":\"\",\"is_deleted\":1,\"created_at\":\"2025-10-27\",\"updated_at\":\"2025-10-27\"}}', '2025-10-27 08:21:30');
INSERT INTO `sub_operation_history` VALUES (67, 3, 6, '徐庆华', 'update', '原材料编码', '修改原材料编码：H0201-0053', '{\"newData\":{\"id\":5,\"user_id\":6,\"company_id\":3,\"material_code\":\"H0201-0053\",\"material_name\":\"五通\",\"model\":\"φ43*4.6T*100L JHD-AK-002G偏心铣弧口\",\"specification\":\"φ43*4.6T*100L JHD-AK-002G偏心铣弧口\",\"other_features\":\"\",\"usage_unit\":\"PCS\",\"purchase_unit\":\"KG\",\"remarks\":\"\",\"is_deleted\":1,\"created_at\":\"2025-10-18\",\"updated_at\":\"2025-10-27\"}}', '2025-10-27 08:21:38');
INSERT INTO `sub_operation_history` VALUES (68, 3, 6, '徐庆华', 'update', '原材料编码', '修改原材料编码：H0101-0089', '{\"newData\":{\"id\":4,\"user_id\":6,\"company_id\":3,\"material_code\":\"H0101-0089\",\"material_name\":\"车首管\",\"model\":\"JHD-AT-0074*146L\",\"specification\":\"JHD-AT-0074*146L\",\"other_features\":\"\",\"usage_unit\":\"PCS\",\"purchase_unit\":\"KG\",\"remarks\":\"\",\"is_deleted\":1,\"created_at\":\"2025-10-18\",\"updated_at\":\"2025-10-27\"}}', '2025-10-27 08:21:45');
INSERT INTO `sub_operation_history` VALUES (69, 3, 6, '徐庆华', 'add', '原材料编码', '新增原材料编码：M0103-0234', '{\"newData\":{\"material_code\":\"M0103-0234\",\"material_name\":\"主梁管\",\"model\":\"方121*65*600L\",\"specification\":\"方121*65*600L\",\"other_features\":\"\",\"usage_unit\":\"PCS\",\"purchase_unit\":\"KG\",\"remarks\":\"\"}}', '2025-10-27 08:23:05');
INSERT INTO `sub_operation_history` VALUES (70, 3, 6, '徐庆华', 'add', '原材料编码', '新增原材料编码：H0801-0004', '{\"newData\":{\"material_code\":\"H0801-0004\",\"material_name\":\"水壶螺母\",\"model\":\"YD008-044（M4）\",\"specification\":\"YD008-044（M4）\",\"other_features\":\"\",\"usage_unit\":\"个\",\"purchase_unit\":\"盒（50个）\",\"remarks\":\"\"}}', '2025-10-27 08:28:29');
INSERT INTO `sub_operation_history` VALUES (71, 3, 6, '徐庆华', 'add', '原材料编码', '新增原材料编码：H0703-0001', '{\"newData\":{\"material_code\":\"H0703-0001\",\"material_name\":\"油压线扣\",\"model\":\"/YD007-004\",\"specification\":\"/YD007-004\",\"other_features\":\"\",\"usage_unit\":\"个\",\"purchase_unit\":\"盒（100个）\",\"remarks\":\"\"}}', '2025-10-27 08:29:45');
INSERT INTO `sub_operation_history` VALUES (72, 3, 6, '徐庆华', 'add', '部件编码', '新增部件编码：019', '{\"newData\":{\"part_code\":\"019\",\"part_name\":\"X\",\"model\":\"\",\"specification\":\"\",\"other_features\":\"\",\"unit\":\"X\",\"production_requirements\":\"\",\"remarks\":\"\"}}', '2025-10-27 08:31:42');
INSERT INTO `sub_operation_history` VALUES (73, 3, 6, '徐庆华', 'delete', '部件编码', '删除部件编码：019', '{\"newData\":50}', '2025-10-27 08:32:05');
INSERT INTO `sub_operation_history` VALUES (74, 3, 6, '徐庆华', 'add', '部件编码', '新增部件编码：X021', '{\"newData\":{\"part_code\":\"X021\",\"part_name\":\"X\",\"model\":\"\",\"specification\":\"\",\"other_features\":\"\",\"unit\":\"X\",\"production_requirements\":\"\",\"remarks\":\"\"}}', '2025-10-27 08:33:25');
INSERT INTO `sub_operation_history` VALUES (75, 3, 6, '徐庆华', 'update', '部件编码', '修改部件编码：X020', '{\"newData\":{\"id\":51,\"company_id\":3,\"user_id\":6,\"part_code\":\"X020\",\"part_name\":\"X\",\"model\":\"\",\"specification\":\"\",\"other_features\":\"\",\"unit\":\"X\",\"production_requirements\":\"\",\"remarks\":\"\",\"is_deleted\":1,\"created_at\":\"2025-10-27\",\"updated_at\":\"2025-10-27\"}}', '2025-10-27 08:33:42');
INSERT INTO `sub_operation_history` VALUES (76, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-10-27 12:12:40');
INSERT INTO `sub_operation_history` VALUES (77, 3, 6, '徐庆华', 'update', '员工信息', '修改员工信息：工号：GL0001，姓名：徐庆华', '{\"newData\":{\"id\":6,\"company_id\":3,\"employee_id\":\"GL0001\",\"name\":\"徐庆华\",\"cycle_id\":6,\"position\":\"公司总经理\",\"salary_attribute\":20,\"remarks\":null,\"created_at\":\"2025-10-18\",\"cycle\":{\"id\":6,\"name\":\"A备料组\"}}}', '2025-10-27 12:38:42');
INSERT INTO `sub_operation_history` VALUES (78, 3, 6, '徐庆华', 'update', '员工信息', '修改员工信息：工号：GL0002，姓名：冷冰', '{\"newData\":{\"id\":5,\"company_id\":3,\"employee_id\":\"GL0002\",\"name\":\"冷冰\",\"cycle_id\":6,\"position\":\"业务部副总\",\"salary_attribute\":20,\"remarks\":null,\"created_at\":\"2025-10-18\",\"cycle\":{\"id\":6,\"name\":\"A备料组\"}}}', '2025-10-27 12:41:01');
INSERT INTO `sub_operation_history` VALUES (79, 3, 6, '徐庆华', 'update', '员工信息', '修改员工信息：工号：GL0001，姓名：徐庆华', '{\"newData\":{\"id\":6,\"company_id\":3,\"employee_id\":\"GL0001\",\"name\":\"徐庆华\",\"cycle_id\":6,\"position\":\"公司创始人\",\"salary_attribute\":20,\"remarks\":null,\"created_at\":\"2025-10-18\",\"cycle\":{\"id\":6,\"name\":\"A备料组\"}}}', '2025-10-27 12:41:54');
INSERT INTO `sub_operation_history` VALUES (80, 3, 6, '徐庆华', 'add', '员工信息', '新增员工信息：工号：GL0003，姓名：何雄明', '{\"newData\":{\"employee_id\":\"GL0003\",\"name\":\"何雄明\",\"password\":\"he2xiong2ming2\",\"cycle_id\":6,\"cycle_name\":\"\",\"position\":\"开发部副总\",\"salary_attribute\":20}}', '2025-10-27 12:45:10');
INSERT INTO `sub_operation_history` VALUES (81, 3, 6, '徐庆华', 'update', '员工信息', '修改员工信息：工号：GL0003，姓名：何雄明', '{\"newData\":{\"id\":7,\"company_id\":3,\"employee_id\":\"GL0003\",\"name\":\"何雄明\",\"cycle_id\":6,\"position\":\"开发部副总\",\"salary_attribute\":20,\"remarks\":null,\"created_at\":\"2025-10-27\",\"cycle\":{\"id\":6,\"name\":\"A备料组\"}}}', '2025-10-27 12:45:45');
INSERT INTO `sub_operation_history` VALUES (82, 3, 6, '徐庆华', 'add', '员工信息', '新增员工信息：工号：GL0004，姓名：粟云', '{\"newData\":{\"employee_id\":\"GL0004\",\"name\":\"粟云\",\"password\":\"su4yun2\",\"cycle_id\":6,\"cycle_name\":\"\",\"position\":\"生产部副总\",\"salary_attribute\":20}}', '2025-10-27 12:49:12');
INSERT INTO `sub_operation_history` VALUES (83, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-10-27 16:09:33');
INSERT INTO `sub_operation_history` VALUES (84, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-10-28 01:19:52');
INSERT INTO `sub_operation_history` VALUES (85, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-10-28 01:22:38');
INSERT INTO `sub_operation_history` VALUES (86, 3, 6, '徐庆华', 'update', '生产制程', '修改生产制程：名称：A备料组', '{\"newData\":{\"id\":6,\"name\":\"A备料组\",\"sort\":\"1\"}}', '2025-10-28 01:29:12');
INSERT INTO `sub_operation_history` VALUES (87, 3, 6, '徐庆华', 'update', '生产制程', '修改生产制程：名称：B焊接组', '{\"newData\":{\"id\":7,\"name\":\"B焊接组\",\"sort\":\"1\"}}', '2025-10-28 01:29:23');
INSERT INTO `sub_operation_history` VALUES (88, 3, 6, '徐庆华', 'update', '生产制程', '修改生产制程：名称：B焊接组', '{\"newData\":{\"id\":7,\"name\":\"B焊接组\",\"sort\":\"2\"}}', '2025-10-28 01:29:42');
INSERT INTO `sub_operation_history` VALUES (89, 3, 6, '徐庆华', 'update', '生产制程', '修改生产制程：名称：C热处理', '{\"newData\":{\"id\":8,\"name\":\"C热处理\",\"sort\":\"2\"}}', '2025-10-28 01:30:01');
INSERT INTO `sub_operation_history` VALUES (90, 3, 6, '徐庆华', 'update', '生产制程', '修改生产制程：名称：C热处理', '{\"newData\":{\"id\":8,\"name\":\"C热处理\",\"sort\":\"3\"}}', '2025-10-28 01:30:14');
INSERT INTO `sub_operation_history` VALUES (91, 3, 6, '徐庆华', 'update', '仓库建立', '修改仓库：名称：管料仓-铝材', '{\"newData\":{\"id\":8,\"ware_id\":1,\"name\":\"管料仓-铝材\"}}', '2025-10-28 01:32:09');
INSERT INTO `sub_operation_history` VALUES (92, 3, 6, '徐庆华', 'add', '仓库建立', '新增仓库：名称：管件仓-铁材', '{\"newData\":{\"ware_id\":1,\"name\":\"管件仓-铁材\"}}', '2025-10-28 01:32:52');
INSERT INTO `sub_operation_history` VALUES (93, 3, 6, '徐庆华', 'update', '仓库建立', '修改仓库：名称：配件仓-铝件', '{\"newData\":{\"id\":9,\"ware_id\":1,\"name\":\"配件仓-铝件\"}}', '2025-10-28 01:33:11');
INSERT INTO `sub_operation_history` VALUES (94, 3, 6, '徐庆华', 'add', '仓库建立', '新增仓库：名称：配件仓-铁件', '{\"newData\":{\"ware_id\":1,\"name\":\"配件仓-铁件\"}}', '2025-10-28 01:33:44');
INSERT INTO `sub_operation_history` VALUES (95, 3, 6, '徐庆华', 'update', '仓库建立', '修改仓库：名称：管料仓-铝管', '{\"newData\":{\"id\":8,\"ware_id\":1,\"name\":\"管料仓-铝管\"}}', '2025-10-28 01:33:58');
INSERT INTO `sub_operation_history` VALUES (96, 3, 6, '徐庆华', 'update', '仓库建立', '修改仓库：名称：管件仓-铁管', '{\"newData\":{\"id\":10,\"ware_id\":1,\"name\":\"管件仓-铁管\"}}', '2025-10-28 01:34:19');
INSERT INTO `sub_operation_history` VALUES (97, 1, 1, '我是名字', 'login', '登录', '用户{ 我是名字 }成功登录', '{\"newData\":{\"username\":\"admin1\",\"password\":\"***\"}}', '2025-10-28 02:13:15');
INSERT INTO `sub_operation_history` VALUES (98, 3, 6, '徐庆华', 'add', '原材料编码', '新增原材料编码：M0101-0635', '{\"newData\":{\"material_code\":\"M0101-0635\",\"material_name\":\"后上叉L/φ19*2.0T*455L\",\"model\":\"L/φ19*2.0T*455L\",\"specification\":\"L/φ19*2.0T*455L\",\"other_features\":\"\",\"usage_unit\":\"PCS\",\"purchase_unit\":\"PCS\",\"remarks\":\"\"}}', '2025-10-28 02:43:21');
INSERT INTO `sub_operation_history` VALUES (99, 3, 6, '徐庆华', 'add', '原材料编码', '新增原材料编码：M0101-0636', '{\"newData\":{\"material_code\":\"M0101-0636\",\"material_name\":\"后上叉R/φ19*2.0T*455L\",\"model\":\"φ19*2.0T*455L\",\"specification\":\"φ19*2.0T*455L\",\"other_features\":\"\",\"usage_unit\":\"PCS\",\"purchase_unit\":\"PCS\",\"remarks\":\"\"}}', '2025-10-28 02:44:33');
INSERT INTO `sub_operation_history` VALUES (100, 3, 6, '徐庆华', 'add', '原材料编码', '新增原材料编码：M0101-0019', '{\"newData\":{\"material_code\":\"M0101-0019\",\"material_name\":\"上枝杆/φ19*1.8T*105L（±1MM)\",\"model\":\"φ19*1.8T*105L（±1MM)\",\"specification\":\"φ19*1.8T*105L（±1MM)\",\"other_features\":\"\",\"usage_unit\":\"PCS\",\"purchase_unit\":\"PCS\",\"remarks\":\"\"}}', '2025-10-28 02:45:39');
INSERT INTO `sub_operation_history` VALUES (101, 3, 6, '徐庆华', 'add', '原材料编码', '新增原材料编码：M0101-0020', '{\"newData\":{\"material_code\":\"M0101-0020\",\"material_name\":\"下枝杆/φ19*1.8T*105L（±1MM)\",\"model\":\"φ19*1.8T*105L（±1MM)\",\"specification\":\"φ19*1.8T*105L（±1MM)\",\"other_features\":\"\",\"usage_unit\":\"PCS\",\"purchase_unit\":\"PCS\",\"remarks\":\"\"}}', '2025-10-28 02:46:52');
INSERT INTO `sub_operation_history` VALUES (102, 3, 6, '徐庆华', 'update', '原材料编码', '修改原材料编码：H0703-0001', '{\"newData\":{\"id\":12,\"user_id\":6,\"company_id\":3,\"material_code\":\"H0703-0001\",\"material_name\":\"油压线扣\",\"model\":\"YD007-004\",\"specification\":\"YD007-004\",\"other_features\":\"\",\"usage_unit\":\"个\",\"purchase_unit\":\"盒（100个）\",\"remarks\":\"\",\"is_deleted\":1,\"created_at\":\"2025-10-27\",\"updated_at\":\"2025-10-27\"}}', '2025-10-28 02:47:18');
INSERT INTO `sub_operation_history` VALUES (103, 3, 6, '徐庆华', 'update', '原材料编码', '修改原材料编码：M0101-0019', '{\"newData\":{\"id\":15,\"user_id\":6,\"company_id\":3,\"material_code\":\"M0101-0019\",\"material_name\":\"上枝杆\",\"model\":\"φ19*1.8T*105L（±1MM)\",\"specification\":\"φ19*1.8T*105L（±1MM)\",\"other_features\":\"\",\"usage_unit\":\"PCS\",\"purchase_unit\":\"PCS\",\"remarks\":\"\",\"is_deleted\":1,\"created_at\":\"2025-10-28\",\"updated_at\":\"2025-10-28\"}}', '2025-10-28 02:47:42');
INSERT INTO `sub_operation_history` VALUES (104, 3, 6, '徐庆华', 'update', '原材料编码', '修改原材料编码：M0101-0020', '{\"newData\":{\"id\":16,\"user_id\":6,\"company_id\":3,\"material_code\":\"M0101-0020\",\"material_name\":\"下枝杆\",\"model\":\"φ19*1.8T*105L（±1MM)\",\"specification\":\"φ19*1.8T*105L（±1MM)\",\"other_features\":\"\",\"usage_unit\":\"PCS\",\"purchase_unit\":\"PCS\",\"remarks\":\"\",\"is_deleted\":1,\"created_at\":\"2025-10-28\",\"updated_at\":\"2025-10-28\"}}', '2025-10-28 02:48:00');
INSERT INTO `sub_operation_history` VALUES (105, 3, 6, '徐庆华', 'update', '原材料编码', '修改原材料编码：M0101-0635', '{\"newData\":{\"id\":13,\"user_id\":6,\"company_id\":3,\"material_code\":\"M0101-0635\",\"material_name\":\"后上叉L\",\"model\":\"φ19*2.0T*455L\",\"specification\":\"φ19*2.0T*455L\",\"other_features\":\"\",\"usage_unit\":\"PCS\",\"purchase_unit\":\"PCS\",\"remarks\":\"\",\"is_deleted\":1,\"created_at\":\"2025-10-28\",\"updated_at\":\"2025-10-28\"}}', '2025-10-28 02:48:27');
INSERT INTO `sub_operation_history` VALUES (106, 3, 6, '徐庆华', 'update', '原材料编码', '修改原材料编码：M0101-0636', '{\"newData\":{\"id\":14,\"user_id\":6,\"company_id\":3,\"material_code\":\"M0101-0636\",\"material_name\":\"后上叉R\",\"model\":\"φ19*2.0T*455L\",\"specification\":\"φ19*2.0T*455L\",\"other_features\":\"\",\"usage_unit\":\"PCS\",\"purchase_unit\":\"PCS\",\"remarks\":\"\",\"is_deleted\":1,\"created_at\":\"2025-10-28\",\"updated_at\":\"2025-10-28\"}}', '2025-10-28 02:48:41');
INSERT INTO `sub_operation_history` VALUES (107, 3, 6, '徐庆华', 'add', '原材料编码', '新增原材料编码：H0801-0001', '{\"newData\":{\"material_code\":\"H0801-0001\",\"material_name\":\"硬焊螺母\",\"model\":\"YD008-006 M5*9L普通\",\"specification\":\"YD008-006 M5*9L普通\",\"other_features\":\"\",\"usage_unit\":\"个\",\"purchase_unit\":\"盒（50个）\",\"remarks\":\"\"}}', '2025-10-28 02:50:20');
INSERT INTO `sub_operation_history` VALUES (108, 3, 6, '徐庆华', 'add', '原材料编码', '新增原材料编码：M0101-0444', '{\"newData\":{\"material_code\":\"M0101-0444\",\"material_name\":\"后下叉R\",\"model\":\"φ22.2*2.0*420L\",\"specification\":\"φ22.2*2.0*420L\",\"other_features\":\"\",\"usage_unit\":\"PCS\",\"purchase_unit\":\"PCS\",\"remarks\":\"\"}}', '2025-10-28 02:51:34');
INSERT INTO `sub_operation_history` VALUES (109, 3, 6, '徐庆华', 'add', '原材料编码', '新增原材料编码：M0101-0445', '{\"newData\":{\"material_code\":\"M0101-0445\",\"material_name\":\"后下叉L\",\"model\":\"φ22.2*2.0*420L\",\"specification\":\"φ22.2*2.0*420L\",\"other_features\":\"\",\"usage_unit\":\"PCS\",\"purchase_unit\":\"PCS\",\"remarks\":\"\"}}', '2025-10-28 02:52:42');
INSERT INTO `sub_operation_history` VALUES (110, 3, 6, '徐庆华', 'add', '原材料编码', '新增原材料编码：H0702-0001', '{\"newData\":{\"material_code\":\"H0702-0001\",\"material_name\":\"止栓\",\"model\":\"YD004-026\",\"specification\":\"YD004-026\",\"other_features\":\"\",\"usage_unit\":\"PCS\",\"purchase_unit\":\"PCS\",\"remarks\":\"\"}}', '2025-10-28 02:53:46');
INSERT INTO `sub_operation_history` VALUES (111, 3, 6, '徐庆华', 'add', '原材料编码', '新增原材料编码：H0302-0013', '{\"newData\":{\"material_code\":\"H0302-0013\",\"material_name\":\"左勾爪\",\"model\":\"YD001-003DS-45度\",\"specification\":\"YD001-003DS-45度\",\"other_features\":\"\",\"usage_unit\":\"PCS\",\"purchase_unit\":\"PCS\",\"remarks\":\"\"}}', '2025-10-28 03:01:29');
INSERT INTO `sub_operation_history` VALUES (112, 3, 6, '徐庆华', 'add', '原材料编码', '新增原材料编码：H0302-0014', '{\"newData\":{\"material_code\":\"H0302-0014\",\"material_name\":\"右勾爪\",\"model\":\"YD001-003DS-45度\",\"specification\":\"YD001-003DS-45度\",\"other_features\":\"\",\"usage_unit\":\"PCS\",\"purchase_unit\":\"PCS\",\"remarks\":\"\"}}', '2025-10-28 03:02:37');
INSERT INTO `sub_operation_history` VALUES (113, 3, 6, '徐庆华', 'add', '原材料编码', '新增原材料编码：H1202-0012', '{\"newData\":{\"material_code\":\"H1202-0012\",\"material_name\":\"边支撑\",\"model\":\"JHD-TC18\",\"specification\":\"JHD-TC18\",\"other_features\":\"\",\"usage_unit\":\"PCS\",\"purchase_unit\":\"PCS\",\"remarks\":\"\"}}', '2025-10-28 03:03:49');
INSERT INTO `sub_operation_history` VALUES (114, 3, 6, '徐庆华', 'add', '原材料编码', '新增原材料编码：H0401-0036', '{\"newData\":{\"material_code\":\"H0401-0036\",\"material_name\":\"折叠器\",\"model\":\"ZHD-DX160-T01/02-Z\",\"specification\":\"ZHD-DX160-T01/02-Z\",\"other_features\":\"\",\"usage_unit\":\"PCS\",\"purchase_unit\":\"PCS\",\"remarks\":\"\"}}', '2025-10-28 03:05:05');
INSERT INTO `sub_operation_history` VALUES (115, 3, 6, '徐庆华', 'add', '原材料编码', '新增原材料编码：H1102-0099', '{\"newData\":{\"material_code\":\"H1102-0099\",\"material_name\":\"加强片\",\"model\":\"JHD-BQ-211\",\"specification\":\"JHD-BQ-211\",\"other_features\":\"\",\"usage_unit\":\"PCS\",\"purchase_unit\":\"PCS\",\"remarks\":\"\"}}', '2025-10-28 03:06:15');
INSERT INTO `sub_operation_history` VALUES (116, 3, 6, '徐庆华', 'add', '原材料编码', '新增原材料编码：H1201-0001', '{\"newData\":{\"material_code\":\"H1201-0001\",\"material_name\":\"支撑棒\",\"model\":\"JS-ZJ-001*120L\",\"specification\":\"JS-ZJ-001*120L\",\"other_features\":\"\",\"usage_unit\":\"PCS\",\"purchase_unit\":\"PCS\",\"remarks\":\"\"}}', '2025-10-28 03:07:19');
INSERT INTO `sub_operation_history` VALUES (117, 3, 6, '徐庆华', 'add', '设备编码', '新增设备编码：JX05', '{\"newData\":{\"equipment_code\":\"JX05\",\"equipment_name\":\"卧冲\",\"quantity\":\"2\",\"cycle_id\":6,\"working_hours\":\"10\",\"efficiency\":20,\"available\":2,\"remarks\":\"\"}}', '2025-10-28 05:17:08');
INSERT INTO `sub_operation_history` VALUES (118, 3, 6, '徐庆华', 'add', '设备编码', '新增设备编码：JX06', '{\"newData\":{\"equipment_code\":\"JX06\",\"equipment_name\":\"切料机\",\"quantity\":\"3\",\"cycle_id\":6,\"working_hours\":\"10\",\"efficiency\":30,\"available\":3,\"remarks\":\"\"}}', '2025-10-28 05:18:23');
INSERT INTO `sub_operation_history` VALUES (119, 3, 6, '徐庆华', 'add', '设备编码', '新增设备编码：JX07', '{\"newData\":{\"equipment_code\":\"JX07\",\"equipment_name\":\"双头钻\",\"quantity\":\"1\",\"cycle_id\":6,\"working_hours\":\"10\",\"efficiency\":10,\"available\":1,\"remarks\":\"\"}}', '2025-10-28 05:20:21');
INSERT INTO `sub_operation_history` VALUES (120, 3, 6, '徐庆华', 'add', '设备编码', '新增设备编码：JX08', '{\"newData\":{\"equipment_code\":\"JX08\",\"equipment_name\":\"开槽机\",\"quantity\":\"1\",\"cycle_id\":6,\"working_hours\":\"10\",\"efficiency\":10,\"available\":1,\"remarks\":\"\"}}', '2025-10-28 05:20:57');
INSERT INTO `sub_operation_history` VALUES (121, 3, 6, '徐庆华', 'add', '设备编码', '新增设备编码：JX09', '{\"newData\":{\"equipment_code\":\"JX09\",\"equipment_name\":\"大弯管机\",\"quantity\":\"1\",\"cycle_id\":6,\"working_hours\":\"10\",\"efficiency\":10,\"available\":1,\"remarks\":\"\"}}', '2025-10-28 05:21:31');
INSERT INTO `sub_operation_history` VALUES (122, 3, 6, '徐庆华', 'add', '设备编码', '新增设备编码：JX10', '{\"newData\":{\"equipment_code\":\"JX10\",\"equipment_name\":\"小弯管机\",\"quantity\":\"1\",\"cycle_id\":6,\"working_hours\":\"10\",\"efficiency\":10,\"available\":1,\"remarks\":\"\"}}', '2025-10-28 05:22:06');
INSERT INTO `sub_operation_history` VALUES (123, 3, 6, '徐庆华', 'add', '设备编码', '新增设备编码：JX11', '{\"newData\":{\"equipment_code\":\"JX11\",\"equipment_name\":\"60T油压机\",\"quantity\":\"1\",\"cycle_id\":6,\"working_hours\":\"10\",\"efficiency\":10,\"available\":1,\"remarks\":\"\"}}', '2025-10-28 05:22:45');
INSERT INTO `sub_operation_history` VALUES (124, 3, 6, '徐庆华', 'add', '设备编码', '新增设备编码：JX12', '{\"newData\":{\"equipment_code\":\"JX12\",\"equipment_name\":\"缩管机\",\"quantity\":\"1\",\"cycle_id\":6,\"working_hours\":\"10\",\"efficiency\":10,\"available\":1,\"remarks\":\"\"}}', '2025-10-28 05:23:27');
INSERT INTO `sub_operation_history` VALUES (125, 3, 6, '徐庆华', 'add', '设备编码', '新增设备编码：JX13', '{\"newData\":{\"equipment_code\":\"JX13\",\"equipment_name\":\"铣上叉弧机\",\"quantity\":\"1\",\"cycle_id\":6,\"working_hours\":\"10\",\"efficiency\":10,\"available\":1,\"remarks\":\"\"}}', '2025-10-28 05:25:42');
INSERT INTO `sub_operation_history` VALUES (126, 3, 6, '徐庆华', 'add', '设备编码', '新增设备编码：JX14', '{\"newData\":{\"equipment_code\":\"JX14\",\"equipment_name\":\"铣下叉弧机\",\"quantity\":\"1\",\"cycle_id\":6,\"working_hours\":\"10\",\"efficiency\":10,\"available\":1,\"remarks\":\"\"}}', '2025-10-28 05:28:57');
INSERT INTO `sub_operation_history` VALUES (127, 3, 6, '徐庆华', 'add', '设备编码', '新增设备编码：JX15', '{\"newData\":{\"equipment_code\":\"JX15\",\"equipment_name\":\"退火炉\",\"quantity\":\"1\",\"cycle_id\":6,\"working_hours\":\"10\",\"efficiency\":10,\"available\":1,\"remarks\":\"\"}}', '2025-10-28 05:29:38');
INSERT INTO `sub_operation_history` VALUES (128, 3, 6, '徐庆华', 'add', '设备编码', '新增设备编码：JX16', '{\"newData\":{\"equipment_code\":\"JX16\",\"equipment_name\":\"钻床-B\",\"quantity\":\"3\",\"cycle_id\":11,\"working_hours\":\"10\",\"efficiency\":30,\"available\":3,\"remarks\":\"\"}}', '2025-10-28 05:31:50');
INSERT INTO `sub_operation_history` VALUES (129, 3, 6, '徐庆华', 'add', '设备编码', '新增设备编码：JX17', '{\"newData\":{\"equipment_code\":\"JX17\",\"equipment_name\":\"人工-硬焊\",\"quantity\":\"5\",\"cycle_id\":6,\"working_hours\":\"10\",\"efficiency\":50,\"available\":5,\"remarks\":\"\"}}', '2025-10-28 05:32:44');
INSERT INTO `sub_operation_history` VALUES (130, 3, 6, '徐庆华', 'add', '设备编码', '新增设备编码：JX18', '{\"newData\":{\"equipment_code\":\"JX18\",\"equipment_name\":\"万能铣弧机\",\"quantity\":\"1\",\"cycle_id\":6,\"working_hours\":\"10\",\"efficiency\":10,\"available\":1,\"remarks\":\"\"}}', '2025-10-28 05:34:21');
INSERT INTO `sub_operation_history` VALUES (131, 3, 6, '徐庆华', 'add', '设备编码', '新增设备编码：JX19', '{\"newData\":{\"equipment_code\":\"JX19\",\"equipment_name\":\"数控铣弧机\",\"quantity\":\"1\",\"cycle_id\":6,\"working_hours\":\"10\",\"efficiency\":10,\"available\":1,\"remarks\":\"\"}}', '2025-10-28 05:35:06');
INSERT INTO `sub_operation_history` VALUES (132, 3, 6, '徐庆华', 'add', '设备编码', '新增设备编码：JX20', '{\"newData\":{\"equipment_code\":\"JX20\",\"equipment_name\":\"40T冲床\",\"quantity\":\"1\",\"cycle_id\":6,\"working_hours\":\"10\",\"efficiency\":10,\"available\":1,\"remarks\":\"\"}}', '2025-10-28 05:35:41');
INSERT INTO `sub_operation_history` VALUES (133, 3, 6, '徐庆华', 'add', '设备编码', '新增设备编码：JX21', '{\"newData\":{\"equipment_code\":\"JX21\",\"equipment_name\":\"攻牙机\",\"quantity\":\"1\",\"cycle_id\":6,\"working_hours\":\"10\",\"efficiency\":10,\"available\":1,\"remarks\":\"\"}}', '2025-10-28 05:36:13');
INSERT INTO `sub_operation_history` VALUES (134, 3, 6, '徐庆华', 'add', '设备编码', '新增设备编码：JX22', '{\"newData\":{\"equipment_code\":\"JX22\",\"equipment_name\":\"上叉冲弧机\",\"quantity\":\"1\",\"cycle_id\":6,\"working_hours\":\"10\",\"efficiency\":10,\"available\":1,\"remarks\":\"\"}}', '2025-10-28 05:36:45');
INSERT INTO `sub_operation_history` VALUES (135, 3, 6, '徐庆华', 'add', '设备编码', '新增设备编码：JX23', '{\"newData\":{\"equipment_code\":\"JX23\",\"equipment_name\":\"自动研磨机\",\"quantity\":\"1\",\"cycle_id\":6,\"working_hours\":\"10\",\"efficiency\":10,\"available\":1,\"remarks\":\"\"}}', '2025-10-28 05:37:12');
INSERT INTO `sub_operation_history` VALUES (136, 3, 6, '徐庆华', 'add', '设备编码', '新增设备编码：JX24', '{\"newData\":{\"equipment_code\":\"JX24\",\"equipment_name\":\"氩焊机\",\"quantity\":\"49\",\"cycle_id\":7,\"working_hours\":\"10\",\"efficiency\":490,\"available\":49,\"remarks\":\"\"}}', '2025-10-28 05:37:55');
INSERT INTO `sub_operation_history` VALUES (137, 3, 6, '徐庆华', 'add', '设备编码', '新增设备编码：JX25', '{\"newData\":{\"equipment_code\":\"JX25\",\"equipment_name\":\"激光机\",\"quantity\":\"1\",\"cycle_id\":7,\"working_hours\":\"10\",\"efficiency\":10,\"available\":1,\"remarks\":\"\"}}', '2025-10-28 05:38:43');
INSERT INTO `sub_operation_history` VALUES (138, 3, 6, '徐庆华', 'update', '生产制程', '修改生产制程：名称：备料组', '{\"newData\":{\"id\":6,\"name\":\"备料组\",\"sort\":\"1\"}}', '2025-10-28 05:40:09');
INSERT INTO `sub_operation_history` VALUES (139, 3, 6, '徐庆华', 'update', '生产制程', '修改生产制程：名称：焊接组', '{\"newData\":{\"id\":7,\"name\":\"焊接组\",\"sort\":\"2\"}}', '2025-10-28 05:40:18');
INSERT INTO `sub_operation_history` VALUES (140, 3, 6, '徐庆华', 'update', '生产制程', '修改生产制程：名称：热处理', '{\"newData\":{\"id\":8,\"name\":\"热处理\",\"sort\":\"3\"}}', '2025-10-28 05:40:23');
INSERT INTO `sub_operation_history` VALUES (141, 3, 6, '徐庆华', 'update', '生产制程', '修改生产制程：名称：研磨组', '{\"newData\":{\"id\":9,\"name\":\"研磨组\",\"sort\":\"4\"}}', '2025-10-28 05:44:10');
INSERT INTO `sub_operation_history` VALUES (142, 3, 6, '徐庆华', 'update', '生产制程', '修改生产制程：名称：后段组', '{\"newData\":{\"id\":11,\"name\":\"后段组\",\"sort\":\"06\"}}', '2025-10-28 05:44:27');
INSERT INTO `sub_operation_history` VALUES (143, 3, 6, '徐庆华', 'update', '生产制程', '修改生产制程：名称：补土组', '{\"newData\":{\"id\":10,\"name\":\"补土组\",\"sort\":\"5\"}}', '2025-10-28 05:44:35');
INSERT INTO `sub_operation_history` VALUES (144, 3, 6, '徐庆华', 'update', '生产制程', '修改生产制程：名称：后段组', '{\"newData\":{\"id\":11,\"name\":\"后段组\",\"sort\":\"6\"}}', '2025-10-28 05:44:44');
INSERT INTO `sub_operation_history` VALUES (145, 3, 6, '徐庆华', 'add', '生产制程', '新增生产制程：名称：行政部', '{\"newData\":{\"name\":\"行政部\",\"sort\":\"0\"}}', '2025-10-28 05:45:18');
INSERT INTO `sub_operation_history` VALUES (146, 3, 6, '徐庆华', 'add', '生产制程', '新增生产制程：名称：技术部', '{\"newData\":{\"name\":\"技术部\",\"sort\":\"\"}}', '2025-10-28 05:45:30');
INSERT INTO `sub_operation_history` VALUES (147, 3, 6, '徐庆华', 'add', '生产制程', '新增生产制程：名称：业务部', '{\"newData\":{\"name\":\"业务部\",\"sort\":\"\"}}', '2025-10-28 05:45:42');
INSERT INTO `sub_operation_history` VALUES (148, 3, 6, '徐庆华', 'add', '生产制程', '新增生产制程：名称：总经办', '{\"newData\":{\"name\":\"总经办\",\"sort\":\"\"}}', '2025-10-28 05:45:53');
INSERT INTO `sub_operation_history` VALUES (149, 3, 6, '徐庆华', 'update', '员工信息', '修改员工信息：工号：GL0004，姓名：粟云', '{\"newData\":{\"id\":8,\"company_id\":3,\"employee_id\":\"GL0004\",\"name\":\"粟云\",\"cycle_id\":15,\"position\":\"生产部副总\",\"salary_attribute\":20,\"remarks\":null,\"created_at\":\"2025-10-27\",\"cycle\":{\"id\":6,\"name\":\"备料组\"}}}', '2025-10-28 05:47:49');
INSERT INTO `sub_operation_history` VALUES (150, 3, 6, '徐庆华', 'add', '组织架构', '新增组织架构：岗位：行政部，姓名：徐楚东', '{\"newData\":{\"label\":\"行政部\",\"menber_id\":12,\"pid\":0}}', '2025-10-28 05:51:48');
INSERT INTO `sub_operation_history` VALUES (151, 3, 6, '徐庆华', 'add', '设备编码', '新增设备编码：JX26', '{\"newData\":{\"equipment_code\":\"JX26\",\"equipment_name\":\"前三角组立台\",\"quantity\":\"3\",\"cycle_id\":7,\"working_hours\":\"10\",\"efficiency\":30,\"available\":3,\"remarks\":\"\"}}', '2025-10-28 06:30:44');
INSERT INTO `sub_operation_history` VALUES (152, 3, 6, '徐庆华', 'add', '设备编码', '新增设备编码：JX27', '{\"newData\":{\"equipment_code\":\"JX27\",\"equipment_name\":\"后三角组立台\",\"quantity\":\"3\",\"cycle_id\":7,\"working_hours\":\"10\",\"efficiency\":30,\"available\":3,\"remarks\":\"\"}}', '2025-10-28 06:31:18');
INSERT INTO `sub_operation_history` VALUES (153, 3, 6, '徐庆华', 'add', '设备编码', '新增设备编码：JX28', '{\"newData\":{\"equipment_code\":\"JX28\",\"equipment_name\":\"切折叠器机\",\"quantity\":\"1\",\"cycle_id\":7,\"working_hours\":\"10\",\"efficiency\":10,\"available\":1,\"remarks\":\"\"}}', '2025-10-28 06:36:02');
INSERT INTO `sub_operation_history` VALUES (154, 3, 6, '徐庆华', 'add', '设备编码', '新增设备编码：JX29', '{\"newData\":{\"equipment_code\":\"JX29\",\"equipment_name\":\"校正台-A\",\"quantity\":\"6\",\"cycle_id\":8,\"working_hours\":\"10\",\"efficiency\":60,\"available\":6,\"remarks\":\"\"}}', '2025-10-28 06:40:06');
INSERT INTO `sub_operation_history` VALUES (155, 3, 6, '徐庆华', 'add', '设备编码', '新增设备编码：JX30', '{\"newData\":{\"equipment_code\":\"JX30\",\"equipment_name\":\"T4炉\",\"quantity\":\"60\",\"cycle_id\":8,\"working_hours\":\"20\",\"efficiency\":1200,\"available\":60,\"remarks\":\"\"}}', '2025-10-28 06:41:49');
INSERT INTO `sub_operation_history` VALUES (156, 3, 6, '徐庆华', 'add', '设备编码', '新增设备编码：JX31', '{\"newData\":{\"equipment_code\":\"JX31\",\"equipment_name\":\"对眼机\",\"quantity\":\"1\",\"cycle_id\":8,\"working_hours\":\"10\",\"efficiency\":10,\"available\":1,\"remarks\":\"\"}}', '2025-10-28 06:42:22');
INSERT INTO `sub_operation_history` VALUES (157, 3, 6, '徐庆华', 'add', '设备编码', '新增设备编码：JX32', '{\"newData\":{\"equipment_code\":\"JX32\",\"equipment_name\":\"T6炉\",\"quantity\":\"200\",\"cycle_id\":8,\"working_hours\":\"20\",\"efficiency\":4000,\"available\":200,\"remarks\":\"\"}}', '2025-10-28 06:43:32');
INSERT INTO `sub_operation_history` VALUES (158, 3, 6, '徐庆华', 'add', '设备编码', '新增设备编码：JX33', '{\"newData\":{\"equipment_code\":\"JX33\",\"equipment_name\":\"铰孔机\",\"quantity\":\"2\",\"cycle_id\":8,\"working_hours\":\"01\",\"efficiency\":2,\"available\":2,\"remarks\":\"\"}}', '2025-10-28 06:48:59');
INSERT INTO `sub_operation_history` VALUES (159, 3, 6, '徐庆华', 'add', '设备编码', '新增设备编码：JX34', '{\"newData\":{\"equipment_code\":\"JX34\",\"equipment_name\":\"铣头管机\",\"quantity\":\"2\",\"cycle_id\":8,\"working_hours\":\"10\",\"efficiency\":20,\"available\":2,\"remarks\":\"\"}}', '2025-10-28 06:49:41');
INSERT INTO `sub_operation_history` VALUES (160, 3, 6, '徐庆华', 'add', '设备编码', '新增设备编码：JX35', '{\"newData\":{\"equipment_code\":\"JX35\",\"equipment_name\":\"铣五通机\",\"quantity\":\"1\",\"cycle_id\":8,\"working_hours\":\"10\",\"efficiency\":10,\"available\":1,\"remarks\":\"\"}}', '2025-10-28 06:56:06');
INSERT INTO `sub_operation_history` VALUES (161, 3, 6, '徐庆华', 'update', '设备编码', '修改设备编码：JX33', '{\"newData\":{\"id\":38,\"company_id\":3,\"user_id\":6,\"equipment_code\":\"JX33\",\"equipment_name\":\"铰孔机\",\"quantity\":2,\"cycle_id\":8,\"working_hours\":\"10\",\"efficiency\":20,\"available\":2,\"remarks\":\"\",\"is_deleted\":1,\"created_at\":\"2025-10-28\",\"updated_at\":\"2025-10-28\",\"cycle\":{\"id\":8,\"company_id\":3,\"user_id\":6,\"name\":\"热处理\",\"sort\":\"3\",\"sort_date\":\"1.5\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:11:22.000Z\",\"updated_at\":\"2025-10-28T05:40:23.000Z\"}}}', '2025-10-28 06:56:19');
INSERT INTO `sub_operation_history` VALUES (162, 3, 6, '徐庆华', 'add', '设备编码', '新增设备编码：JX36', '{\"newData\":{\"equipment_code\":\"JX36\",\"equipment_name\":\"铣碟刹机\",\"quantity\":\"2\",\"cycle_id\":8,\"working_hours\":\"10\",\"efficiency\":20,\"available\":2,\"remarks\":\"\"}}', '2025-10-28 06:57:11');
INSERT INTO `sub_operation_history` VALUES (163, 3, 6, '徐庆华', 'add', '设备编码', '新增设备编码：JX37', '{\"newData\":{\"equipment_code\":\"JX37\",\"equipment_name\":\"皮膜槽\",\"quantity\":\"4\",\"cycle_id\":11,\"working_hours\":\"10\",\"efficiency\":40,\"available\":4,\"remarks\":\"\"}}', '2025-10-28 06:58:03');
INSERT INTO `sub_operation_history` VALUES (164, 3, 6, '徐庆华', 'add', '设备编码', '新增设备编码：JX38', '{\"newData\":{\"equipment_code\":\"JX38\",\"equipment_name\":\"人工-补土\",\"quantity\":\"10\",\"cycle_id\":10,\"working_hours\":\"10\",\"efficiency\":100,\"available\":10,\"remarks\":\"\"}}', '2025-10-28 06:58:39');
INSERT INTO `sub_operation_history` VALUES (165, 3, 6, '徐庆华', 'add', '设备编码', '新增设备编码：JX39', '{\"newData\":{\"equipment_code\":\"JX39\",\"equipment_name\":\"QC全检\",\"quantity\":\"2\",\"cycle_id\":11,\"working_hours\":\"10\",\"efficiency\":20,\"available\":2,\"remarks\":\"\"}}', '2025-10-28 06:59:13');
INSERT INTO `sub_operation_history` VALUES (166, 3, 6, '徐庆华', 'add', '设备编码', '新增设备编码：JX40', '{\"newData\":{\"equipment_code\":\"JX40\",\"equipment_name\":\"包装\",\"quantity\":\"2\",\"cycle_id\":11,\"working_hours\":\"10\",\"efficiency\":20,\"available\":2,\"remarks\":\"\"}}', '2025-10-28 06:59:45');
INSERT INTO `sub_operation_history` VALUES (167, 3, 6, '徐庆华', 'add', '设备编码', '新增设备编码：JX41', '{\"newData\":{\"equipment_code\":\"JX41\",\"equipment_name\":\"校正台-B\",\"quantity\":\"2\",\"cycle_id\":7,\"working_hours\":\"10\",\"efficiency\":20,\"available\":2,\"remarks\":\"\"}}', '2025-10-28 07:00:40');
INSERT INTO `sub_operation_history` VALUES (168, 3, 6, '徐庆华', 'add', '设备编码', '新增设备编码：JX42', '{\"newData\":{\"equipment_code\":\"JX42\",\"equipment_name\":\"打磨毛刺校正\",\"quantity\":\"3\",\"cycle_id\":6,\"working_hours\":\"10\",\"efficiency\":30,\"available\":3,\"remarks\":\"\"}}', '2025-10-28 07:01:16');
INSERT INTO `sub_operation_history` VALUES (169, 3, 6, '徐庆华', 'add', '设备编码', '新增设备编码：JX43', '{\"newData\":{\"equipment_code\":\"JX43\",\"equipment_name\":\"焊接清洗工\",\"quantity\":\"1\",\"cycle_id\":7,\"working_hours\":\"10\",\"efficiency\":10,\"available\":1,\"remarks\":\"\"}}', '2025-10-28 07:02:27');
INSERT INTO `sub_operation_history` VALUES (170, 3, 6, '徐庆华', 'update', '员工信息', '修改员工信息：工号：GL0003，姓名：何雄明', '{\"newData\":{\"id\":7,\"company_id\":3,\"employee_id\":\"GL0003\",\"name\":\"何雄明\",\"cycle_id\":13,\"position\":\"技术部副总\",\"salary_attribute\":20,\"remarks\":null,\"created_at\":\"2025-10-27\",\"cycle\":{\"id\":6,\"name\":\"备料组\"}}}', '2025-10-28 07:04:05');
INSERT INTO `sub_operation_history` VALUES (171, 3, 6, '徐庆华', 'update', '员工信息', '修改员工信息：工号：GL0001，姓名：徐庆华', '{\"newData\":{\"id\":6,\"company_id\":3,\"employee_id\":\"GL0001\",\"name\":\"徐庆华\",\"cycle_id\":15,\"position\":\"公司创始人\",\"salary_attribute\":20,\"remarks\":null,\"created_at\":\"2025-10-18\",\"cycle\":{\"id\":6,\"name\":\"备料组\"}}}', '2025-10-28 07:04:40');
INSERT INTO `sub_operation_history` VALUES (172, 3, 6, '徐庆华', 'update', '员工信息', '修改员工信息：工号：GL0002，姓名：冷冰', '{\"newData\":{\"id\":5,\"company_id\":3,\"employee_id\":\"GL0002\",\"name\":\"冷冰\",\"cycle_id\":14,\"position\":\"业务部副总\",\"salary_attribute\":20,\"remarks\":null,\"created_at\":\"2025-10-18\",\"cycle\":{\"id\":6,\"name\":\"备料组\"}}}', '2025-10-28 07:04:55');
INSERT INTO `sub_operation_history` VALUES (173, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-10-28 08:24:17');
INSERT INTO `sub_operation_history` VALUES (174, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-10-28 08:27:58');
INSERT INTO `sub_operation_history` VALUES (175, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-10-28 11:30:37');
INSERT INTO `sub_operation_history` VALUES (176, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-10-28 14:28:37');
INSERT INTO `sub_operation_history` VALUES (177, 3, 6, '徐庆华', 'update', '设备编码', '修改设备编码：JX04', '{\"newData\":{\"id\":9,\"company_id\":3,\"user_id\":6,\"equipment_code\":\"JX04\",\"equipment_name\":\"手动研磨机\",\"quantity\":4,\"cycle_id\":9,\"working_hours\":\"10\",\"efficiency\":40,\"available\":4,\"remarks\":\"\",\"is_deleted\":1,\"created_at\":\"2025-10-18\",\"updated_at\":\"2025-10-18\",\"cycle\":{\"id\":9,\"company_id\":3,\"user_id\":6,\"name\":\"研磨组\",\"sort\":\"4\",\"sort_date\":\"5\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:11:37.000Z\",\"updated_at\":\"2025-10-28T05:44:10.000Z\"}}}', '2025-10-28 14:35:10');
INSERT INTO `sub_operation_history` VALUES (178, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-10-29 01:07:52');
INSERT INTO `sub_operation_history` VALUES (179, 3, 6, '徐庆华', 'update', '仓库建立', '修改仓库：名称：配件仓-铝架配件', '{\"newData\":{\"id\":9,\"ware_id\":1,\"name\":\"配件仓-铝架配件\"}}', '2025-10-29 01:31:59');
INSERT INTO `sub_operation_history` VALUES (180, 3, 6, '徐庆华', 'update', '仓库建立', '修改仓库：名称：配件仓-铁架配件', '{\"newData\":{\"id\":11,\"ware_id\":1,\"name\":\"配件仓-铁架配件\"}}', '2025-10-29 01:32:20');
INSERT INTO `sub_operation_history` VALUES (181, 3, 6, '徐庆华', 'add', '工艺BOM', '新增工艺BOM，产品编码：WA-A00001，部件编码：X001，工艺编码：PA001', '{\"newData\":{\"product_id\":20,\"part_id\":21,\"children\":[{\"process_id\":7,\"equipment_id\":6,\"time\":\"3\",\"price\":\"0.12\",\"points\":\"1\",\"process_index\":1}],\"archive\":1}}', '2025-10-29 01:46:30');
INSERT INTO `sub_operation_history` VALUES (182, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PA003', '{\"newData\":{\"equipment_id\":8,\"process_code\":\"PA003\",\"process_name\":\"钻孔\",\"remarks\":\"\"}}', '2025-10-29 02:00:51');
INSERT INTO `sub_operation_history` VALUES (183, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PAO4', '{\"newData\":{\"equipment_id\":9,\"process_code\":\"PAO4\",\"process_name\":\"研磨\",\"remarks\":\"\"}}', '2025-10-29 02:01:49');
INSERT INTO `sub_operation_history` VALUES (184, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PA05', '{\"newData\":{\"equipment_id\":7,\"process_code\":\"PA05\",\"process_name\":\"打弯\",\"remarks\":\"\"}}', '2025-10-29 02:02:31');
INSERT INTO `sub_operation_history` VALUES (185, 1, 1, '我是名字', 'login', '登录', '用户{ 我是名字 }成功登录', '{\"newData\":{\"username\":\"admin1\",\"password\":\"***\"}}', '2025-10-29 02:18:29');
INSERT INTO `sub_operation_history` VALUES (186, 1, 1, '我是名字', 'update', '产品编码', '修改产品编码：123', '{\"newData\":{\"id\":9,\"company_id\":1,\"user_id\":1,\"product_code\":\"123\",\"product_name\":\"113\",\"drawing\":\"图只可以\",\"model\":\"21\",\"specification\":\"2131\",\"other_features\":\"3131\",\"component_structure\":\"1313\",\"unit\":\"212\",\"production_requirements\":\"21\",\"is_deleted\":1,\"created_at\":\"2025-07-08\",\"updated_at\":\"2025-07-14\"}}', '2025-10-29 02:18:38');
INSERT INTO `sub_operation_history` VALUES (187, 1, 1, '我是名字', 'update', '产品编码', '修改产品编码：12111111', '{\"newData\":{\"id\":9,\"company_id\":1,\"user_id\":1,\"product_code\":\"12111111\",\"product_name\":\"113\",\"drawing\":\"图只可以\",\"model\":\"21\",\"specification\":\"2131\",\"other_features\":\"3131\",\"component_structure\":\"1313\",\"unit\":\"212\",\"production_requirements\":\"21\",\"is_deleted\":1,\"created_at\":\"2025-07-08\",\"updated_at\":\"2025-07-14\"}}', '2025-10-29 02:19:03');
INSERT INTO `sub_operation_history` VALUES (188, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-10-29 02:26:40');
INSERT INTO `sub_operation_history` VALUES (189, 3, 6, '徐庆华', 'update', '工艺编码', '修改工艺编码：PA005', '{\"newData\":{\"id\":11,\"company_id\":3,\"user_id\":6,\"equipment_id\":7,\"process_code\":\"PA005\",\"process_name\":\"打弯\",\"remarks\":\"\",\"is_deleted\":1,\"created_at\":\"2025-10-29\",\"updated_at\":\"2025-10-29\",\"equipment\":{\"id\":7,\"company_id\":3,\"user_id\":6,\"equipment_code\":\"JX02\",\"equipment_name\":\"16T冲床\",\"quantity\":8,\"cycle_id\":6,\"working_hours\":\"10\",\"efficiency\":80,\"available\":8,\"remarks\":\"\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:21:33.000Z\",\"updated_at\":\"2025-10-23T15:51:20.000Z\"}}}', '2025-10-29 02:30:53');
INSERT INTO `sub_operation_history` VALUES (190, 3, 6, '徐庆华', 'update', '工艺编码', '修改工艺编码：PAO04', '{\"newData\":{\"id\":10,\"company_id\":3,\"user_id\":6,\"equipment_id\":9,\"process_code\":\"PAO04\",\"process_name\":\"研磨\",\"remarks\":\"\",\"is_deleted\":1,\"created_at\":\"2025-10-29\",\"updated_at\":\"2025-10-29\",\"equipment\":{\"id\":9,\"company_id\":3,\"user_id\":6,\"equipment_code\":\"JX04\",\"equipment_name\":\"手动研磨机\",\"quantity\":4,\"cycle_id\":9,\"working_hours\":\"10\",\"efficiency\":40,\"available\":4,\"remarks\":\"\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:38:09.000Z\",\"updated_at\":\"2025-10-28T14:35:10.000Z\"}}}', '2025-10-29 02:31:04');
INSERT INTO `sub_operation_history` VALUES (191, 3, 6, '徐庆华', 'update', '工艺编码', '修改工艺编码：PA004', '{\"newData\":{\"id\":10,\"company_id\":3,\"user_id\":6,\"equipment_id\":9,\"process_code\":\"PA004\",\"process_name\":\"研磨\",\"remarks\":\"\",\"is_deleted\":1,\"created_at\":\"2025-10-29\",\"updated_at\":\"2025-10-29\",\"equipment\":{\"id\":9,\"company_id\":3,\"user_id\":6,\"equipment_code\":\"JX04\",\"equipment_name\":\"手动研磨机\",\"quantity\":4,\"cycle_id\":9,\"working_hours\":\"10\",\"efficiency\":40,\"available\":4,\"remarks\":\"\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:38:09.000Z\",\"updated_at\":\"2025-10-28T14:35:10.000Z\"}}}', '2025-10-29 02:32:00');
INSERT INTO `sub_operation_history` VALUES (192, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-10-29 02:32:08');
INSERT INTO `sub_operation_history` VALUES (193, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PA006', '{\"newData\":{\"equipment_id\":10,\"process_code\":\"PA006\",\"process_name\":\"冲弧\",\"remarks\":\"\"}}', '2025-10-29 02:34:43');
INSERT INTO `sub_operation_history` VALUES (194, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PA007', '{\"newData\":{\"equipment_id\":11,\"process_code\":\"PA007\",\"process_name\":\"切斜\",\"remarks\":\"\"}}', '2025-10-29 02:35:22');
INSERT INTO `sub_operation_history` VALUES (195, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PA008', '{\"newData\":{\"equipment_id\":11,\"process_code\":\"PA008\",\"process_name\":\"下料\",\"remarks\":\"\"}}', '2025-10-29 02:35:53');
INSERT INTO `sub_operation_history` VALUES (196, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PA009', '{\"newData\":{\"equipment_id\":11,\"process_code\":\"PA009\",\"process_name\":\"切折叠器\",\"remarks\":\"\"}}', '2025-10-29 02:36:29');
INSERT INTO `sub_operation_history` VALUES (197, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PA010', '{\"newData\":{\"equipment_id\":8,\"process_code\":\"PA010\",\"process_name\":\"钻防水孔\",\"remarks\":\"\"}}', '2025-10-29 02:36:57');
INSERT INTO `sub_operation_history` VALUES (198, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PA011', '{\"newData\":{\"equipment_id\":12,\"process_code\":\"PA011\",\"process_name\":\"钻水壶孔\",\"remarks\":\"\"}}', '2025-10-29 02:37:27');
INSERT INTO `sub_operation_history` VALUES (199, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PA012', '{\"newData\":{\"equipment_id\":13,\"process_code\":\"PA012\",\"process_name\":\"开槽\",\"remarks\":\"\"}}', '2025-10-29 02:38:07');
INSERT INTO `sub_operation_history` VALUES (200, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PA013', '{\"newData\":{\"equipment_id\":11,\"process_code\":\"PA013\",\"process_name\":\"切消位\",\"remarks\":\"\"}}', '2025-10-29 02:38:31');
INSERT INTO `sub_operation_history` VALUES (201, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PA014', '{\"newData\":{\"equipment_id\":7,\"process_code\":\"PA014\",\"process_name\":\"打消位\",\"remarks\":\"\"}}', '2025-10-29 02:39:13');
INSERT INTO `sub_operation_history` VALUES (202, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PA015', '{\"newData\":{\"equipment_id\":14,\"process_code\":\"PA015\",\"process_name\":\"弯大管\",\"remarks\":\"\"}}', '2025-10-29 02:39:59');
INSERT INTO `sub_operation_history` VALUES (203, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PA016', '{\"newData\":{\"equipment_id\":15,\"process_code\":\"PA016\",\"process_name\":\"弯小管\",\"remarks\":\"\"}}', '2025-10-29 02:40:32');
INSERT INTO `sub_operation_history` VALUES (204, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PA017', '{\"newData\":{\"equipment_id\":16,\"process_code\":\"PA017\",\"process_name\":\"压弯\",\"remarks\":\"\"}}', '2025-10-29 02:42:04');
INSERT INTO `sub_operation_history` VALUES (205, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PA018', '{\"newData\":{\"equipment_id\":17,\"process_code\":\"PA018\",\"process_name\":\"缩管\",\"remarks\":\"\"}}', '2025-10-29 02:43:00');
INSERT INTO `sub_operation_history` VALUES (206, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PA019', '{\"newData\":{\"equipment_id\":18,\"process_code\":\"PA019\",\"process_name\":\"铣上叉弧\",\"remarks\":\"\"}}', '2025-10-29 02:43:46');
INSERT INTO `sub_operation_history` VALUES (207, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PA020', '{\"newData\":{\"equipment_id\":19,\"process_code\":\"PA020\",\"process_name\":\"铣下叉弧\",\"remarks\":\"\"}}', '2025-10-29 02:44:25');
INSERT INTO `sub_operation_history` VALUES (208, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PA021', '{\"newData\":{\"equipment_id\":20,\"process_code\":\"PA021\",\"process_name\":\"退火\",\"remarks\":\"\"}}', '2025-10-29 02:56:25');
INSERT INTO `sub_operation_history` VALUES (209, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PA022', '{\"newData\":{\"equipment_id\":47,\"process_code\":\"PA022\",\"process_name\":\"刮毛刺\",\"remarks\":\"\"}}', '2025-10-29 02:57:00');
INSERT INTO `sub_operation_history` VALUES (210, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PA023', '{\"newData\":{\"equipment_id\":22,\"process_code\":\"PA023\",\"process_name\":\"硬焊\",\"remarks\":\"\"}}', '2025-10-29 02:57:23');
INSERT INTO `sub_operation_history` VALUES (211, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PA024', '{\"newData\":{\"equipment_id\":8,\"process_code\":\"PA024\",\"process_name\":\"钻消水孔\",\"remarks\":\"\"}}', '2025-10-29 02:57:55');
INSERT INTO `sub_operation_history` VALUES (212, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PA025', '{\"newData\":{\"equipment_id\":23,\"process_code\":\"PA025\",\"process_name\":\"铣弧1\",\"remarks\":\"\"}}', '2025-10-29 02:58:24');
INSERT INTO `sub_operation_history` VALUES (213, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PA026', '{\"newData\":{\"equipment_id\":24,\"process_code\":\"PA026\",\"process_name\":\"铣弧2\",\"remarks\":\"\"}}', '2025-10-29 02:58:59');
INSERT INTO `sub_operation_history` VALUES (214, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PA027', '{\"newData\":{\"equipment_id\":25,\"process_code\":\"PA027\",\"process_name\":\"冲板\",\"remarks\":\"\"}}', '2025-10-29 02:59:20');
INSERT INTO `sub_operation_history` VALUES (215, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PA028', '{\"newData\":{\"equipment_id\":26,\"process_code\":\"PA028\",\"process_name\":\"攻牙\",\"remarks\":\"\"}}', '2025-10-29 02:59:45');
INSERT INTO `sub_operation_history` VALUES (216, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PA029', '{\"newData\":{\"equipment_id\":27,\"process_code\":\"PA029\",\"process_name\":\"上叉冲弧\",\"remarks\":\"\"}}', '2025-10-29 03:00:17');
INSERT INTO `sub_operation_history` VALUES (217, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PA030', '{\"newData\":{\"equipment_id\":47,\"process_code\":\"PA030\",\"process_name\":\"折弯校正\",\"remarks\":\"\"}}', '2025-10-29 03:00:43');
INSERT INTO `sub_operation_history` VALUES (218, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PA031', '{\"newData\":{\"equipment_id\":22,\"process_code\":\"PA031\",\"process_name\":\"硬焊\",\"remarks\":\"\"}}', '2025-10-29 03:01:34');
INSERT INTO `sub_operation_history` VALUES (219, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PA032', '{\"newData\":{\"equipment_id\":28,\"process_code\":\"PA032\",\"process_name\":\"自动研磨\",\"remarks\":\"\"}}', '2025-10-29 03:05:31');
INSERT INTO `sub_operation_history` VALUES (220, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PA033', '{\"newData\":{\"equipment_id\":47,\"process_code\":\"PA033\",\"process_name\":\"打磨\",\"remarks\":\"\"}}', '2025-10-29 03:06:11');
INSERT INTO `sub_operation_history` VALUES (221, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PA034', '{\"newData\":{\"equipment_id\":23,\"process_code\":\"PA034\",\"process_name\":\"铣R\",\"remarks\":\"\"}}', '2025-10-29 03:06:50');
INSERT INTO `sub_operation_history` VALUES (222, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-10-29 06:37:19');
INSERT INTO `sub_operation_history` VALUES (223, 3, 6, '徐庆华', 'update', '设备编码', '修改设备编码：JX05', '{\"newData\":{\"id\":10,\"company_id\":3,\"user_id\":6,\"equipment_code\":\"JX05\",\"equipment_name\":\"卧冲\",\"quantity\":2,\"cycle_id\":6,\"working_hours\":\"10\",\"efficiency\":10,\"available\":1,\"remarks\":\"\",\"is_deleted\":1,\"created_at\":\"2025-10-28\",\"updated_at\":\"2025-10-28\",\"cycle\":{\"id\":6,\"company_id\":3,\"user_id\":6,\"name\":\"备料组\",\"sort\":\"1\",\"sort_date\":\"1\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:10:27.000Z\",\"updated_at\":\"2025-10-28T05:40:09.000Z\"}}}', '2025-10-29 06:59:52');
INSERT INTO `sub_operation_history` VALUES (224, 3, 6, '徐庆华', 'update', '设备编码', '修改设备编码：JX05', '{\"newData\":{\"id\":10,\"company_id\":3,\"user_id\":6,\"equipment_code\":\"JX05\",\"equipment_name\":\"卧冲\",\"quantity\":2,\"cycle_id\":6,\"working_hours\":\"10\",\"efficiency\":20,\"available\":2,\"remarks\":\"\",\"is_deleted\":1,\"created_at\":\"2025-10-28\",\"updated_at\":\"2025-10-29\",\"cycle\":{\"id\":6,\"company_id\":3,\"user_id\":6,\"name\":\"备料组\",\"sort\":\"1\",\"sort_date\":\"1\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:10:27.000Z\",\"updated_at\":\"2025-10-28T05:40:09.000Z\"}}}', '2025-10-29 07:00:24');
INSERT INTO `sub_operation_history` VALUES (225, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-10-29 07:04:04');
INSERT INTO `sub_operation_history` VALUES (226, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-10-29 14:01:00');
INSERT INTO `sub_operation_history` VALUES (227, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-10-29 14:30:33');
INSERT INTO `sub_operation_history` VALUES (228, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-10-30 02:18:18');
INSERT INTO `sub_operation_history` VALUES (229, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-10-30 04:14:14');
INSERT INTO `sub_operation_history` VALUES (230, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB001', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB001\",\"process_name\":\"点焊左钩爪\",\"remarks\":\"\"}}', '2025-10-30 06:35:18');
INSERT INTO `sub_operation_history` VALUES (231, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB002', '{\"newData\":{\"equipment_id\":32,\"process_code\":\"PB002\",\"process_name\":\"焊左钩爪\",\"remarks\":\"\"}}', '2025-10-30 06:37:18');
INSERT INTO `sub_operation_history` VALUES (232, 3, 6, '徐庆华', 'update', '工艺编码', '修改工艺编码：PB002', '{\"newData\":{\"id\":42,\"company_id\":3,\"user_id\":6,\"equipment_id\":29,\"process_code\":\"PB002\",\"process_name\":\"焊左钩爪\",\"remarks\":\"\",\"is_deleted\":1,\"created_at\":\"2025-10-30\",\"updated_at\":\"2025-10-30\",\"equipment\":{\"id\":32,\"company_id\":3,\"user_id\":6,\"equipment_code\":\"JX27\",\"equipment_name\":\"后三角组立台\",\"quantity\":3,\"cycle_id\":7,\"working_hours\":\"10\",\"efficiency\":30,\"available\":3,\"remarks\":\"\",\"is_deleted\":1,\"created_at\":\"2025-10-28T06:31:18.000Z\",\"updated_at\":\"2025-10-28T06:31:18.000Z\"}}}', '2025-10-30 06:37:27');
INSERT INTO `sub_operation_history` VALUES (233, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB003', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB003\",\"process_name\":\"点焊右钩爪\",\"remarks\":\"\"}}', '2025-10-30 06:39:10');
INSERT INTO `sub_operation_history` VALUES (234, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB004', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB004\",\"process_name\":\"焊右钩爪\",\"remarks\":\"\"}}', '2025-10-30 06:39:38');
INSERT INTO `sub_operation_history` VALUES (235, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB005', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB005\",\"process_name\":\"点上支杆货架螺母\",\"remarks\":\"\"}}', '2025-10-30 06:40:29');
INSERT INTO `sub_operation_history` VALUES (236, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB006', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB006\",\"process_name\":\"焊上支杆货架螺母\",\"remarks\":\"\"}}', '2025-10-30 06:41:02');
INSERT INTO `sub_operation_history` VALUES (237, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB007', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB007\",\"process_name\":\"点加焊上叉泥板螺母\",\"remarks\":\"\"}}', '2025-10-30 06:41:51');
INSERT INTO `sub_operation_history` VALUES (238, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB008', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB008\",\"process_name\":\"点小中管接头\",\"remarks\":\"\"}}', '2025-10-30 06:42:48');
INSERT INTO `sub_operation_history` VALUES (239, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB009', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB009\",\"process_name\":\"点枝干加曲付\",\"remarks\":\"\"}}', '2025-10-30 06:43:27');
INSERT INTO `sub_operation_history` VALUES (240, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB010', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB010\",\"process_name\":\"焊竖管\",\"remarks\":\"\"}}', '2025-10-30 06:43:52');
INSERT INTO `sub_operation_history` VALUES (241, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB011', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB011\",\"process_name\":\"点下叉接五通\",\"remarks\":\"\"}}', '2025-10-30 06:44:19');
INSERT INTO `sub_operation_history` VALUES (242, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB012', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB012\",\"process_name\":\"焊碟刹\",\"remarks\":\"\"}}', '2025-10-30 06:44:45');
INSERT INTO `sub_operation_history` VALUES (243, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB013', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB013\",\"process_name\":\"点焊链盖曲付\",\"remarks\":\"\"}}', '2025-10-30 06:45:24');
INSERT INTO `sub_operation_history` VALUES (244, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB014', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB014\",\"process_name\":\"点焊停车曲付\",\"remarks\":\"\"}}', '2025-10-30 06:45:54');
INSERT INTO `sub_operation_history` VALUES (245, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB015', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB015\",\"process_name\":\"点焊支撑棒\",\"remarks\":\"\"}}', '2025-10-30 06:46:18');
INSERT INTO `sub_operation_history` VALUES (246, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB016', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB016\",\"process_name\":\"点焊五通曲付\",\"remarks\":\"\"}}', '2025-10-30 06:46:51');
INSERT INTO `sub_operation_history` VALUES (247, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB017', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB017\",\"process_name\":\"点头管曲付\",\"remarks\":\"\"}}', '2025-10-30 06:47:16');
INSERT INTO `sub_operation_history` VALUES (248, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB018', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB018\",\"process_name\":\"焊头管曲付\",\"remarks\":\"\"}}', '2025-10-30 06:47:50');
INSERT INTO `sub_operation_history` VALUES (249, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB019', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB019\",\"process_name\":\"焊过线板\",\"remarks\":\"\"}}', '2025-10-30 06:48:14');
INSERT INTO `sub_operation_history` VALUES (250, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB020', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB020\",\"process_name\":\"点避震片\",\"remarks\":\"\"}}', '2025-10-30 06:48:37');
INSERT INTO `sub_operation_history` VALUES (251, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB021', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB021\",\"process_name\":\"焊避震片\",\"remarks\":\"\"}}', '2025-10-30 06:48:59');
INSERT INTO `sub_operation_history` VALUES (252, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB022', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB022\",\"process_name\":\"点中管曲付\",\"remarks\":\"\"}}', '2025-10-30 06:49:35');
INSERT INTO `sub_operation_history` VALUES (253, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB023', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB023\",\"process_name\":\"焊中管曲付\",\"remarks\":\"\"}}', '2025-10-30 06:50:16');
INSERT INTO `sub_operation_history` VALUES (254, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB024', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB024\",\"process_name\":\"五通接中管加曲付组立\",\"remarks\":\"\"}}', '2025-10-30 06:50:46');
INSERT INTO `sub_operation_history` VALUES (255, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB025', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB025\",\"process_name\":\"点货架片\",\"remarks\":\"\"}}', '2025-10-30 06:51:12');
INSERT INTO `sub_operation_history` VALUES (256, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB026', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB026\",\"process_name\":\"货架架支撑管\",\"remarks\":\"\"}}', '2025-10-30 06:51:53');
INSERT INTO `sub_operation_history` VALUES (257, 3, 6, '徐庆华', 'update', '工艺编码', '修改工艺编码：PB026', '{\"newData\":{\"id\":66,\"company_id\":3,\"user_id\":6,\"equipment_id\":29,\"process_code\":\"PB026\",\"process_name\":\"货架+支撑管\",\"remarks\":\"\",\"is_deleted\":1,\"created_at\":\"2025-10-30\",\"updated_at\":\"2025-10-30\",\"equipment\":{\"id\":29,\"company_id\":3,\"user_id\":6,\"equipment_code\":\"JX24\",\"equipment_name\":\"氩焊机\",\"quantity\":49,\"cycle_id\":7,\"working_hours\":\"10\",\"efficiency\":490,\"available\":49,\"remarks\":\"\",\"is_deleted\":1,\"created_at\":\"2025-10-28T05:37:55.000Z\",\"updated_at\":\"2025-10-28T05:37:55.000Z\"}}}', '2025-10-30 06:53:18');
INSERT INTO `sub_operation_history` VALUES (258, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB027', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB027\",\"process_name\":\"点货架左右片\",\"remarks\":\"\"}}', '2025-10-30 06:53:47');
INSERT INTO `sub_operation_history` VALUES (259, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB028', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB028\",\"process_name\":\"点边框加支撑管\",\"remarks\":\"\"}}', '2025-10-30 06:54:25');
INSERT INTO `sub_operation_history` VALUES (260, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB029', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB029\",\"process_name\":\"点焊前三角曲付\",\"remarks\":\"\"}}', '2025-10-30 06:54:50');
INSERT INTO `sub_operation_history` VALUES (261, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB030', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB030\",\"process_name\":\"点焊控制器封口片\",\"remarks\":\"\"}}', '2025-10-30 06:55:17');
INSERT INTO `sub_operation_history` VALUES (262, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB031', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB031\",\"process_name\":\"点控制器接五通加中管\",\"remarks\":\"\"}}', '2025-10-30 06:55:46');
INSERT INTO `sub_operation_history` VALUES (263, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB032', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB032\",\"process_name\":\"点焊尾灯片\",\"remarks\":\"\"}}', '2025-10-30 06:56:08');
INSERT INTO `sub_operation_history` VALUES (264, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB033', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB033\",\"process_name\":\"点分体式上叉\",\"remarks\":\"\"}}', '2025-10-30 06:56:33');
INSERT INTO `sub_operation_history` VALUES (265, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB034', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB034\",\"process_name\":\"点分体式下叉\",\"remarks\":\"\"}}', '2025-10-30 06:57:02');
INSERT INTO `sub_operation_history` VALUES (266, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB035', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB035\",\"process_name\":\"点补强盒加线扣\",\"remarks\":\"\"}}', '2025-10-30 06:57:25');
INSERT INTO `sub_operation_history` VALUES (267, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB036', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB036\",\"process_name\":\"点控制器线扣\",\"remarks\":\"\"}}', '2025-10-30 06:57:49');
INSERT INTO `sub_operation_history` VALUES (268, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB037', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB037\",\"process_name\":\"点下叉线扣\",\"remarks\":\"\"}}', '2025-10-30 06:58:16');
INSERT INTO `sub_operation_history` VALUES (269, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB038', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB038\",\"process_name\":\"点电池板\",\"remarks\":\"\"}}', '2025-10-30 06:58:42');
INSERT INTO `sub_operation_history` VALUES (270, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB039', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB039\",\"process_name\":\"点电池板 线扣\",\"remarks\":\"\"}}', '2025-10-30 06:59:02');
INSERT INTO `sub_operation_history` VALUES (271, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB040', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB040\",\"process_name\":\"点货架加强片左右\",\"remarks\":\"\"}}', '2025-10-30 06:59:45');
INSERT INTO `sub_operation_history` VALUES (272, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB041', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB041\",\"process_name\":\"点上叉枝干1\",\"remarks\":\"\"}}', '2025-10-30 07:00:11');
INSERT INTO `sub_operation_history` VALUES (273, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB042', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB042\",\"process_name\":\"点上叉枝干2\",\"remarks\":\"\"}}', '2025-10-30 07:00:35');
INSERT INTO `sub_operation_history` VALUES (274, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB043', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB043\",\"process_name\":\"点货架接头加加强片\",\"remarks\":\"\"}}', '2025-10-30 07:01:03');
INSERT INTO `sub_operation_history` VALUES (275, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB044', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB044\",\"process_name\":\"点货架加支撑管\",\"remarks\":\"\"}}', '2025-10-30 07:01:27');
INSERT INTO `sub_operation_history` VALUES (276, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB045', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB045\",\"process_name\":\"点货架加 后支撑管\",\"remarks\":\"\"}}', '2025-10-30 07:01:53');
INSERT INTO `sub_operation_history` VALUES (277, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB046', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB046\",\"process_name\":\"点焊电池仓\",\"remarks\":\"\"}}', '2025-10-30 07:02:22');
INSERT INTO `sub_operation_history` VALUES (278, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB047', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB047\",\"process_name\":\"小五通接支撑管\",\"remarks\":\"\"}}', '2025-10-30 07:02:48');
INSERT INTO `sub_operation_history` VALUES (279, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB048', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB048\",\"process_name\":\"点焊货架螺母\",\"remarks\":\"\"}}', '2025-10-30 07:03:21');
INSERT INTO `sub_operation_history` VALUES (280, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB049', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB049\",\"process_name\":\"货架曲付锁螺丝\",\"remarks\":\"\"}}', '2025-10-30 07:03:55');
INSERT INTO `sub_operation_history` VALUES (281, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB050', '{\"newData\":{\"equipment_id\":31,\"process_code\":\"PB050\",\"process_name\":\"前三角组立\",\"remarks\":\"\"}}', '2025-10-30 07:04:56');
INSERT INTO `sub_operation_history` VALUES (282, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB051', '{\"newData\":{\"equipment_id\":32,\"process_code\":\"PB051\",\"process_name\":\"后三角组立\",\"remarks\":\"\"}}', '2025-10-30 07:05:27');
INSERT INTO `sub_operation_history` VALUES (283, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB052', '{\"newData\":{\"equipment_id\":33,\"process_code\":\"PB052\",\"process_name\":\"切折叠器\",\"remarks\":\"\"}}', '2025-10-30 07:05:49');
INSERT INTO `sub_operation_history` VALUES (284, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB053', '{\"newData\":{\"equipment_id\":46,\"process_code\":\"PB053\",\"process_name\":\"校正\",\"remarks\":\"\"}}', '2025-10-30 07:06:21');
INSERT INTO `sub_operation_history` VALUES (285, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB054', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB054\",\"process_name\":\"焊前三角\",\"remarks\":\"\"}}', '2025-10-30 07:06:51');
INSERT INTO `sub_operation_history` VALUES (286, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB055', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB055\",\"process_name\":\"焊后三角\",\"remarks\":\"\"}}', '2025-10-30 07:07:12');
INSERT INTO `sub_operation_history` VALUES (287, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB056', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB056\",\"process_name\":\"点右勾爪\",\"remarks\":\"\"}}', '2025-10-30 07:07:46');
INSERT INTO `sub_operation_history` VALUES (288, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB057', '{\"newData\":{\"equipment_id\":48,\"process_code\":\"PB057\",\"process_name\":\"清洗\",\"remarks\":\"\"}}', '2025-10-30 07:08:10');
INSERT INTO `sub_operation_history` VALUES (289, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB058', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB058\",\"process_name\":\"点折叠器\",\"remarks\":\"\"}}', '2025-10-30 07:08:44');
INSERT INTO `sub_operation_history` VALUES (290, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PB059', '{\"newData\":{\"equipment_id\":29,\"process_code\":\"PB059\",\"process_name\":\"焊折叠器\",\"remarks\":\"\"}}', '2025-10-30 07:09:08');
INSERT INTO `sub_operation_history` VALUES (291, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PC001', '{\"newData\":{\"equipment_id\":35,\"process_code\":\"PC001\",\"process_name\":\"T4\",\"remarks\":\"\"}}', '2025-10-30 07:09:53');
INSERT INTO `sub_operation_history` VALUES (292, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PC002', '{\"newData\":{\"equipment_id\":34,\"process_code\":\"PC002\",\"process_name\":\"校正\",\"remarks\":\"\"}}', '2025-10-30 07:10:19');
INSERT INTO `sub_operation_history` VALUES (293, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PC003', '{\"newData\":{\"equipment_id\":36,\"process_code\":\"PC003\",\"process_name\":\"对眼\",\"remarks\":\"\"}}', '2025-10-30 07:10:50');
INSERT INTO `sub_operation_history` VALUES (294, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PC004', '{\"newData\":{\"equipment_id\":37,\"process_code\":\"PC004\",\"process_name\":\"T6\",\"remarks\":\"\"}}', '2025-10-30 07:11:16');
INSERT INTO `sub_operation_history` VALUES (295, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PC005', '{\"newData\":{\"equipment_id\":38,\"process_code\":\"PC005\",\"process_name\":\"铰孔\",\"remarks\":\"\"}}', '2025-10-30 07:11:50');
INSERT INTO `sub_operation_history` VALUES (296, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PC006', '{\"newData\":{\"equipment_id\":39,\"process_code\":\"PC006\",\"process_name\":\"铣头管\",\"remarks\":\"\"}}', '2025-10-30 07:12:11');
INSERT INTO `sub_operation_history` VALUES (297, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PC007', '{\"newData\":{\"equipment_id\":40,\"process_code\":\"PC007\",\"process_name\":\"铣五通\",\"remarks\":\"\"}}', '2025-10-30 07:12:33');
INSERT INTO `sub_operation_history` VALUES (298, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PC008', '{\"newData\":{\"equipment_id\":41,\"process_code\":\"PC008\",\"process_name\":\"铣碟刹\",\"remarks\":\"\"}}', '2025-10-30 07:12:59');
INSERT INTO `sub_operation_history` VALUES (299, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PD001', '{\"newData\":{\"equipment_id\":9,\"process_code\":\"PD001\",\"process_name\":\"开折叠器\",\"remarks\":\"\"}}', '2025-10-30 07:13:37');
INSERT INTO `sub_operation_history` VALUES (300, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PD002', '{\"newData\":{\"equipment_id\":9,\"process_code\":\"PD002\",\"process_name\":\"研磨\",\"remarks\":\"\"}}', '2025-10-30 07:14:15');
INSERT INTO `sub_operation_history` VALUES (301, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PE001', '{\"newData\":{\"equipment_id\":43,\"process_code\":\"PE001\",\"process_name\":\"补土\",\"remarks\":\"\"}}', '2025-10-30 07:15:18');
INSERT INTO `sub_operation_history` VALUES (302, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PF001', '{\"newData\":{\"equipment_id\":21,\"process_code\":\"PF001\",\"process_name\":\"钻电池空\",\"remarks\":\"\"}}', '2025-10-30 07:15:56');
INSERT INTO `sub_operation_history` VALUES (303, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PF002', '{\"newData\":{\"equipment_id\":42,\"process_code\":\"PF002\",\"process_name\":\"皮膜\",\"remarks\":\"\"}}', '2025-10-30 07:16:28');
INSERT INTO `sub_operation_history` VALUES (304, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PF003', '{\"newData\":{\"equipment_id\":44,\"process_code\":\"PF003\",\"process_name\":\"QC全检\",\"remarks\":\"\"}}', '2025-10-30 07:17:22');
INSERT INTO `sub_operation_history` VALUES (305, 3, 6, '徐庆华', 'add', '工艺编码', '新增工艺编码：PF004', '{\"newData\":{\"equipment_id\":45,\"process_code\":\"PF004\",\"process_name\":\"包装\",\"remarks\":\"\"}}', '2025-10-30 07:18:23');
INSERT INTO `sub_operation_history` VALUES (306, 3, 6, '徐庆华', 'update', '客户信息', '修改客户编码：KA001', '{\"newData\":{\"id\":4,\"user_id\":6,\"company_id\":3,\"customer_code\":\"KA001\",\"customer_abbreviation\":\"旭欧\",\"contact_person\":\"潘总\",\"contact_information\":\"13812345678\",\"company_full_name\":\"东莞市旭欧精密五金有限公司\",\"company_address\":\"东莞市石碣镇单屋村\",\"delivery_address\":\"公司材料仓\",\"tax_registration_number\":\"12345678\",\"transaction_method\":21,\"transaction_currency\":\"人民币\",\"other_transaction_terms\":\"月结60天\",\"is_deleted\":1,\"created_at\":\"2025-10-18\",\"updated_at\":\"2025-10-22\"}}', '2025-10-30 07:46:24');
INSERT INTO `sub_operation_history` VALUES (307, 3, 6, '徐庆华', 'add', '客户信息', '新增客户编码：KA002', '{\"newData\":{\"customer_code\":\"KA002\",\"customer_abbreviation\":\"鑫宇\",\"contact_person\":\"王总\",\"contact_information\":\"13712345678\",\"company_full_name\":\"东莞市鑫宇五金制品厂\",\"company_address\":\"东莞市万江区官桥窖村\",\"delivery_address\":\"高埗镇合鑫喷漆厂\",\"tax_registration_number\":\"WJ123456\",\"transaction_method\":21,\"transaction_currency\":\"人民币\",\"other_transaction_terms\":\"月结90天\"}}', '2025-10-30 07:52:21');
INSERT INTO `sub_operation_history` VALUES (308, 3, 6, '徐庆华', 'update', '客户信息', '修改客户编码：KA001', '{\"newData\":{\"id\":4,\"user_id\":6,\"company_id\":3,\"customer_code\":\"KA001\",\"customer_abbreviation\":\"旭欧\",\"contact_person\":\"潘总\",\"contact_information\":\"13812345678\",\"company_full_name\":\"东莞市旭欧精密五金有限公司\",\"company_address\":\"东莞市石碣镇单屋村\",\"delivery_address\":\"公司材料仓\",\"tax_registration_number\":\"SJ123456\",\"transaction_method\":21,\"transaction_currency\":\"人民币\",\"other_transaction_terms\":\"月结60天\",\"is_deleted\":1,\"created_at\":\"2025-10-18\",\"updated_at\":\"2025-10-30\"}}', '2025-10-30 07:52:38');
INSERT INTO `sub_operation_history` VALUES (309, 3, 6, '徐庆华', 'add', '销售订单', '新增销售订单，客户订单号：CG02-2510018', '{\"newData\":{\"rece_time\":\"2025-10-30\",\"customer_id\":5,\"customer_order\":\"CG02-2510018\",\"product_id\":20,\"product_req\":\"1.字码2510001-2510800；2.车架补土后烤漆\",\"order_number\":\"7500\",\"unit\":\"台\",\"delivery_time\":\"2025-12-12\",\"goods_time\":\"2025-11-07\",\"goods_address\":\"高埗镇合鑫喷漆厂\"}}', '2025-10-30 08:04:11');
INSERT INTO `sub_operation_history` VALUES (310, 3, 6, '徐庆华', 'update', '销售订单', '修改销售订单，客户订单号：JHD25001', '{\"newData\":{\"id\":3,\"company_id\":3,\"user_id\":6,\"rece_time\":\"2025-10-10\",\"customer_id\":4,\"customer_order\":\"JHD25001\",\"product_id\":20,\"product_req\":\"1.按照2510001-2510800打字码；2.补土后烤漆\",\"order_number\":\"8000\",\"actual_number\":800,\"unit\":\"台\",\"delivery_time\":\"2025-11-30\",\"goods_time\":\"2025-11-30\",\"goods_address\":\"公司厂区\",\"is_deleted\":1,\"created_at\":\"2025-10-18\",\"updated_at\":\"2025-10-18\",\"customer\":{\"id\":4,\"user_id\":6,\"company_id\":3,\"customer_code\":\"KA001\",\"customer_abbreviation\":\"旭欧\",\"contact_person\":\"潘总\",\"contact_information\":\"13812345678\",\"company_full_name\":\"东莞市旭欧精密五金有限公司\",\"company_address\":\"东莞市石碣镇单屋村\",\"delivery_address\":\"公司材料仓\",\"tax_registration_number\":\"SJ123456\",\"transaction_method\":21,\"transaction_currency\":\"人民币\",\"other_transaction_terms\":\"月结60天\",\"is_deleted\":1,\"created_at\":\"2025-10-18T03:09:32.000Z\",\"updated_at\":\"2025-10-30T07:52:38.000Z\"},\"product\":{\"id\":20,\"company_id\":3,\"user_id\":12,\"product_code\":\"WA-A00001\",\"product_name\":\"0611铝车架\",\"drawing\":\"0611\",\"model\":\"城市代步Q1\",\"specification\":\"36寸\",\"other_features\":\"折叠型\",\"component_structure\":\"整车结构\",\"unit\":\"台\",\"production_requirements\":\"1.字码2510001-2510800；2.车架补土后烤漆\",\"is_deleted\":1,\"created_at\":\"2025-10-17T20:34:51.000Z\",\"updated_at\":\"2025-10-17T20:37:04.000Z\"}}}', '2025-10-30 08:04:25');
INSERT INTO `sub_operation_history` VALUES (311, 3, 6, '徐庆华', 'update', '销售订单', '修改销售订单，客户订单号：JHD25001', '{\"newData\":{\"id\":3,\"company_id\":3,\"user_id\":6,\"rece_time\":\"2025-10-10\",\"customer_id\":4,\"customer_order\":\"JHD25001\",\"product_id\":20,\"product_req\":\"1.按照2510001-2510800打字码；\",\"order_number\":\"8000\",\"actual_number\":800,\"unit\":\"台\",\"delivery_time\":\"2025-11-30\",\"goods_time\":\"2025-11-30\",\"goods_address\":\"公司厂区\",\"is_deleted\":1,\"created_at\":\"2025-10-18\",\"updated_at\":\"2025-10-30\",\"customer\":{\"id\":4,\"user_id\":6,\"company_id\":3,\"customer_code\":\"KA001\",\"customer_abbreviation\":\"旭欧\",\"contact_person\":\"潘总\",\"contact_information\":\"13812345678\",\"company_full_name\":\"东莞市旭欧精密五金有限公司\",\"company_address\":\"东莞市石碣镇单屋村\",\"delivery_address\":\"公司材料仓\",\"tax_registration_number\":\"SJ123456\",\"transaction_method\":21,\"transaction_currency\":\"人民币\",\"other_transaction_terms\":\"月结60天\",\"is_deleted\":1,\"created_at\":\"2025-10-18T03:09:32.000Z\",\"updated_at\":\"2025-10-30T07:52:38.000Z\"},\"product\":{\"id\":20,\"company_id\":3,\"user_id\":12,\"product_code\":\"WA-A00001\",\"product_name\":\"0611铝车架\",\"drawing\":\"0611\",\"model\":\"城市代步Q1\",\"specification\":\"36寸\",\"other_features\":\"折叠型\",\"component_structure\":\"整车结构\",\"unit\":\"台\",\"production_requirements\":\"1.字码2510001-2510800；2.车架补土后烤漆\",\"is_deleted\":1,\"created_at\":\"2025-10-17T20:34:51.000Z\",\"updated_at\":\"2025-10-17T20:37:04.000Z\"}}}', '2025-10-30 08:05:01');
INSERT INTO `sub_operation_history` VALUES (312, 3, 6, '徐庆华', 'update', '销售订单', '修改销售订单，客户订单号：CG02-2510018', '{\"newData\":{\"id\":4,\"company_id\":3,\"user_id\":6,\"rece_time\":\"2025-10-30\",\"customer_id\":5,\"customer_order\":\"CG02-2510018\",\"product_id\":20,\"product_req\":\"1.字码自2511001起；2.车架补土后烤漆\",\"order_number\":\"7500\",\"actual_number\":7500,\"unit\":\"台\",\"delivery_time\":\"2025-12-12\",\"goods_time\":\"2025-11-07\",\"goods_address\":\"高埗镇合鑫喷漆厂\",\"is_deleted\":1,\"created_at\":\"2025-10-30\",\"updated_at\":\"2025-10-30\",\"customer\":{\"id\":5,\"user_id\":6,\"company_id\":3,\"customer_code\":\"KA002\",\"customer_abbreviation\":\"鑫宇\",\"contact_person\":\"王总\",\"contact_information\":\"13712345678\",\"company_full_name\":\"东莞市鑫宇五金制品厂\",\"company_address\":\"东莞市万江区官桥窖村\",\"delivery_address\":\"高埗镇合鑫喷漆厂\",\"tax_registration_number\":\"WJ123456\",\"transaction_method\":21,\"transaction_currency\":\"人民币\",\"other_transaction_terms\":\"月结90天\",\"is_deleted\":1,\"created_at\":\"2025-10-30T07:52:21.000Z\",\"updated_at\":\"2025-10-30T07:52:21.000Z\"},\"product\":{\"id\":20,\"company_id\":3,\"user_id\":12,\"product_code\":\"WA-A00001\",\"product_name\":\"0611铝车架\",\"drawing\":\"0611\",\"model\":\"城市代步Q1\",\"specification\":\"36寸\",\"other_features\":\"折叠型\",\"component_structure\":\"整车结构\",\"unit\":\"台\",\"production_requirements\":\"1.字码2510001-2510800；2.车架补土后烤漆\",\"is_deleted\":1,\"created_at\":\"2025-10-17T20:34:51.000Z\",\"updated_at\":\"2025-10-17T20:37:04.000Z\"}}}', '2025-10-30 08:06:03');
INSERT INTO `sub_operation_history` VALUES (313, 3, 6, '徐庆华', 'update', '销售订单', '修改销售订单，客户订单号：CG02-2510018', '{\"newData\":{\"id\":4,\"company_id\":3,\"user_id\":6,\"rece_time\":\"2025-10-30\",\"customer_id\":5,\"customer_order\":\"CG02-2510018\",\"product_id\":20,\"product_req\":\"1.字码自2511001起；2.车架补土后送烤漆\",\"order_number\":\"7500\",\"actual_number\":7500,\"unit\":\"台\",\"delivery_time\":\"2025-12-12\",\"goods_time\":\"2025-11-07\",\"goods_address\":\"高埗镇合鑫喷漆厂\",\"is_deleted\":1,\"created_at\":\"2025-10-30\",\"updated_at\":\"2025-10-30\",\"customer\":{\"id\":5,\"user_id\":6,\"company_id\":3,\"customer_code\":\"KA002\",\"customer_abbreviation\":\"鑫宇\",\"contact_person\":\"王总\",\"contact_information\":\"13712345678\",\"company_full_name\":\"东莞市鑫宇五金制品厂\",\"company_address\":\"东莞市万江区官桥窖村\",\"delivery_address\":\"高埗镇合鑫喷漆厂\",\"tax_registration_number\":\"WJ123456\",\"transaction_method\":21,\"transaction_currency\":\"人民币\",\"other_transaction_terms\":\"月结90天\",\"is_deleted\":1,\"created_at\":\"2025-10-30T07:52:21.000Z\",\"updated_at\":\"2025-10-30T07:52:21.000Z\"},\"product\":{\"id\":20,\"company_id\":3,\"user_id\":12,\"product_code\":\"WA-A00001\",\"product_name\":\"0611铝车架\",\"drawing\":\"0611\",\"model\":\"城市代步Q1\",\"specification\":\"36寸\",\"other_features\":\"折叠型\",\"component_structure\":\"整车结构\",\"unit\":\"台\",\"production_requirements\":\"1.字码2510001-2510800；2.车架补土后烤漆\",\"is_deleted\":1,\"created_at\":\"2025-10-17T20:34:51.000Z\",\"updated_at\":\"2025-10-17T20:37:04.000Z\"}}}', '2025-10-30 08:06:26');
INSERT INTO `sub_operation_history` VALUES (314, 3, 6, '徐庆华', 'update', '销售订单', '修改销售订单，客户订单号：JHD25001', '{\"newData\":{\"id\":3,\"company_id\":3,\"user_id\":6,\"rece_time\":\"2025-10-10\",\"customer_id\":4,\"customer_order\":\"JHD25001\",\"product_id\":20,\"product_req\":\"1.按照自25100001打字码；2.不准补土\",\"order_number\":\"8000\",\"actual_number\":800,\"unit\":\"台\",\"delivery_time\":\"2025-11-30\",\"goods_time\":\"2025-11-30\",\"goods_address\":\"公司厂区\",\"is_deleted\":1,\"created_at\":\"2025-10-18\",\"updated_at\":\"2025-10-30\",\"customer\":{\"id\":4,\"user_id\":6,\"company_id\":3,\"customer_code\":\"KA001\",\"customer_abbreviation\":\"旭欧\",\"contact_person\":\"潘总\",\"contact_information\":\"13812345678\",\"company_full_name\":\"东莞市旭欧精密五金有限公司\",\"company_address\":\"东莞市石碣镇单屋村\",\"delivery_address\":\"公司材料仓\",\"tax_registration_number\":\"SJ123456\",\"transaction_method\":21,\"transaction_currency\":\"人民币\",\"other_transaction_terms\":\"月结60天\",\"is_deleted\":1,\"created_at\":\"2025-10-18T03:09:32.000Z\",\"updated_at\":\"2025-10-30T07:52:38.000Z\"},\"product\":{\"id\":20,\"company_id\":3,\"user_id\":12,\"product_code\":\"WA-A00001\",\"product_name\":\"0611铝车架\",\"drawing\":\"0611\",\"model\":\"城市代步Q1\",\"specification\":\"36寸\",\"other_features\":\"折叠型\",\"component_structure\":\"整车结构\",\"unit\":\"台\",\"production_requirements\":\"1.字码2510001-2510800；2.车架补土后烤漆\",\"is_deleted\":1,\"created_at\":\"2025-10-17T20:34:51.000Z\",\"updated_at\":\"2025-10-17T20:37:04.000Z\"}}}', '2025-10-30 08:07:49');
INSERT INTO `sub_operation_history` VALUES (315, 3, 6, '徐庆华', 'update', '销售订单', '修改销售订单，客户订单号：JHD25001', '{\"newData\":{\"id\":3,\"company_id\":3,\"user_id\":6,\"rece_time\":\"2025-10-10\",\"customer_id\":4,\"customer_order\":\"JHD25001\",\"product_id\":20,\"product_req\":\"1.按照自25100001打字码；2.补土后直接送货\",\"order_number\":\"8000\",\"actual_number\":800,\"unit\":\"台\",\"delivery_time\":\"2025-11-30\",\"goods_time\":\"2025-11-30\",\"goods_address\":\"公司厂区\",\"is_deleted\":1,\"created_at\":\"2025-10-18\",\"updated_at\":\"2025-10-30\",\"customer\":{\"id\":4,\"user_id\":6,\"company_id\":3,\"customer_code\":\"KA001\",\"customer_abbreviation\":\"旭欧\",\"contact_person\":\"潘总\",\"contact_information\":\"13812345678\",\"company_full_name\":\"东莞市旭欧精密五金有限公司\",\"company_address\":\"东莞市石碣镇单屋村\",\"delivery_address\":\"公司材料仓\",\"tax_registration_number\":\"SJ123456\",\"transaction_method\":21,\"transaction_currency\":\"人民币\",\"other_transaction_terms\":\"月结60天\",\"is_deleted\":1,\"created_at\":\"2025-10-18T03:09:32.000Z\",\"updated_at\":\"2025-10-30T07:52:38.000Z\"},\"product\":{\"id\":20,\"company_id\":3,\"user_id\":12,\"product_code\":\"WA-A00001\",\"product_name\":\"0611铝车架\",\"drawing\":\"0611\",\"model\":\"城市代步Q1\",\"specification\":\"36寸\",\"other_features\":\"折叠型\",\"component_structure\":\"整车结构\",\"unit\":\"台\",\"production_requirements\":\"1.字码2510001-2510800；2.车架补土后烤漆\",\"is_deleted\":1,\"created_at\":\"2025-10-17T20:34:51.000Z\",\"updated_at\":\"2025-10-17T20:37:04.000Z\"}}}', '2025-10-30 08:08:28');
INSERT INTO `sub_operation_history` VALUES (316, 3, 6, '徐庆华', 'update', '销售订单', '修改销售订单，客户订单号：CG01-2510009', '{\"newData\":{\"id\":3,\"company_id\":3,\"user_id\":6,\"rece_time\":\"2025-10-10\",\"customer_id\":4,\"customer_order\":\"CG01-2510009\",\"product_id\":20,\"product_req\":\"1.按照自25100001打字码；2.补土后直接送货\",\"order_number\":\"8000\",\"actual_number\":800,\"unit\":\"台\",\"delivery_time\":\"2025-11-30\",\"goods_time\":\"2025-11-30\",\"goods_address\":\"公司厂区\",\"is_deleted\":1,\"created_at\":\"2025-10-18\",\"updated_at\":\"2025-10-30\",\"customer\":{\"id\":4,\"user_id\":6,\"company_id\":3,\"customer_code\":\"KA001\",\"customer_abbreviation\":\"旭欧\",\"contact_person\":\"潘总\",\"contact_information\":\"13812345678\",\"company_full_name\":\"东莞市旭欧精密五金有限公司\",\"company_address\":\"东莞市石碣镇单屋村\",\"delivery_address\":\"公司材料仓\",\"tax_registration_number\":\"SJ123456\",\"transaction_method\":21,\"transaction_currency\":\"人民币\",\"other_transaction_terms\":\"月结60天\",\"is_deleted\":1,\"created_at\":\"2025-10-18T03:09:32.000Z\",\"updated_at\":\"2025-10-30T07:52:38.000Z\"},\"product\":{\"id\":20,\"company_id\":3,\"user_id\":12,\"product_code\":\"WA-A00001\",\"product_name\":\"0611铝车架\",\"drawing\":\"0611\",\"model\":\"城市代步Q1\",\"specification\":\"36寸\",\"other_features\":\"折叠型\",\"component_structure\":\"整车结构\",\"unit\":\"台\",\"production_requirements\":\"1.字码2510001-2510800；2.车架补土后烤漆\",\"is_deleted\":1,\"created_at\":\"2025-10-17T20:34:51.000Z\",\"updated_at\":\"2025-10-17T20:37:04.000Z\"}}}', '2025-10-30 08:10:51');
INSERT INTO `sub_operation_history` VALUES (317, 3, 6, '徐庆华', 'add', '生产通知单', '新增生产通知单，订单号：DD-2510002', '{\"newData\":{\"sale_id\":4,\"notice\":\"DD-2510002\",\"delivery_time\":\"2025-11-07\"}}', '2025-10-30 08:20:55');
INSERT INTO `sub_operation_history` VALUES (318, 3, 6, '徐庆华', 'update', '销售订单', '修改销售订单，客户订单号：CG02-2510018', '{\"newData\":{\"id\":4,\"company_id\":3,\"user_id\":6,\"rece_time\":\"2025-10-30\",\"customer_id\":5,\"customer_order\":\"CG02-2510018\",\"product_id\":20,\"product_req\":\"1.字码自2511001起；2.车架补土后送烤漆\",\"order_number\":\"7500\",\"actual_number\":7500,\"unit\":\"台\",\"delivery_time\":\"2025-12-12\",\"goods_time\":\"2025-12-12\",\"goods_address\":\"高埗镇合鑫喷漆厂\",\"is_deleted\":1,\"created_at\":\"2025-10-30\",\"updated_at\":\"2025-10-30\",\"customer\":{\"id\":5,\"user_id\":6,\"company_id\":3,\"customer_code\":\"KA002\",\"customer_abbreviation\":\"鑫宇\",\"contact_person\":\"王总\",\"contact_information\":\"13712345678\",\"company_full_name\":\"东莞市鑫宇五金制品厂\",\"company_address\":\"东莞市万江区官桥窖村\",\"delivery_address\":\"高埗镇合鑫喷漆厂\",\"tax_registration_number\":\"WJ123456\",\"transaction_method\":21,\"transaction_currency\":\"人民币\",\"other_transaction_terms\":\"月结90天\",\"is_deleted\":1,\"created_at\":\"2025-10-30T07:52:21.000Z\",\"updated_at\":\"2025-10-30T07:52:21.000Z\"},\"product\":{\"id\":20,\"company_id\":3,\"user_id\":12,\"product_code\":\"WA-A00001\",\"product_name\":\"0611铝车架\",\"drawing\":\"0611\",\"model\":\"城市代步Q1\",\"specification\":\"36寸\",\"other_features\":\"折叠型\",\"component_structure\":\"整车结构\",\"unit\":\"台\",\"production_requirements\":\"1.字码2510001-2510800；2.车架补土后烤漆\",\"is_deleted\":1,\"created_at\":\"2025-10-17T20:34:51.000Z\",\"updated_at\":\"2025-10-17T20:37:04.000Z\"}}}', '2025-10-30 08:22:00');
INSERT INTO `sub_operation_history` VALUES (319, 3, 6, '徐庆华', 'update', '材料BOM', '修改材料BOM，产品编码：WA-A00001，部件编码：X001，材料编码：H0101-0089', '{\"newData\":{\"id\":23,\"product_id\":20,\"part_id\":21,\"children\":[{\"id\":31,\"material_bom_id\":23,\"material_id\":4,\"number\":\"1\",\"material\":{\"id\":4,\"material_code\":\"H0101-0089\",\"material_name\":\"车首管\",\"specification\":\"JHD-AT-0074*146L\"}}],\"archive\":1}}', '2025-10-30 08:43:39');
INSERT INTO `sub_operation_history` VALUES (320, 3, 6, '徐庆华', 'update', '材料BOM', '修改材料BOM，产品编码：WA-A00001，部件编码：X002，材料编码：H0201-0053', '{\"newData\":{\"id\":24,\"product_id\":20,\"part_id\":22,\"children\":[{\"id\":29,\"material_bom_id\":24,\"material_id\":5,\"number\":\"1\",\"material\":{\"id\":6,\"material_code\":\"M0101-0668\",\"material_name\":\"中管\",\"specification\":\"φ40.8*2.2T*410L\"}}],\"archive\":1}}', '2025-10-30 08:44:29');
INSERT INTO `sub_operation_history` VALUES (321, 3, 6, '徐庆华', 'update', '材料BOM', '修改材料BOM，产品编码：WA-A00001，部件编码：X007，材料编码：H0201-0053', '{\"newData\":{\"id\":24,\"product_id\":20,\"part_id\":27,\"children\":[{\"id\":29,\"material_bom_id\":24,\"material_id\":5,\"number\":1,\"material\":{\"id\":5,\"material_code\":\"H0201-0053\",\"material_name\":\"五通\",\"specification\":\"φ43*4.6T*100L JHD-AK-002G偏心铣弧口\"}}],\"archive\":1}}', '2025-10-30 08:45:11');
INSERT INTO `sub_operation_history` VALUES (322, 3, 6, '徐庆华', 'update', '部件编码', '修改部件编码：X007', '{\"newData\":{\"id\":27,\"company_id\":3,\"user_id\":6,\"part_code\":\"X007\",\"part_name\":\"五通\",\"model\":\"X\",\"specification\":\"X\",\"other_features\":\"\",\"unit\":\"PCS\",\"production_requirements\":\"\",\"remarks\":\"\",\"is_deleted\":1,\"created_at\":\"2025-10-27\",\"updated_at\":\"2025-10-27\"}}', '2025-10-30 08:46:24');
INSERT INTO `sub_operation_history` VALUES (323, 3, 6, '徐庆华', 'add', '材料BOM', '新增材料BOM，产品编码：WA-A00001，部件编码：X014，材料编码：M0101-0668', '{\"newData\":{\"product_id\":20,\"part_id\":34,\"children\":[{\"material_id\":6,\"number\":\"1\"}],\"archive\":1}}', '2025-10-30 08:49:20');
INSERT INTO `sub_operation_history` VALUES (324, 3, 6, '徐庆华', 'add', '材料BOM', '新增材料BOM，产品编码：WA-A00001，部件编码：X013，材料编码：M0101-1123', '{\"newData\":{\"product_id\":20,\"part_id\":33,\"children\":[{\"material_id\":7,\"number\":\"1\"}],\"archive\":1}}', '2025-10-30 08:49:58');
INSERT INTO `sub_operation_history` VALUES (325, 3, 6, '徐庆华', 'add', '材料BOM', '新增材料BOM，产品编码：WA-A00001，部件编码：X005，材料编码：M0101-0565,M0103-0015', '{\"newData\":{\"product_id\":20,\"part_id\":25,\"children\":[{\"material_id\":8,\"number\":\"1\"},{\"material_id\":9,\"number\":\"1\"}],\"archive\":1}}', '2025-10-30 08:54:25');
INSERT INTO `sub_operation_history` VALUES (326, 3, 6, '徐庆华', 'add', '材料BOM', '新增材料BOM，产品编码：WA-A00001，部件编码：X018，材料编码：M0103-0015', '{\"newData\":{\"product_id\":20,\"part_id\":38,\"children\":[{\"material_id\":9,\"number\":\"3\"}],\"archive\":1}}', '2025-10-30 08:55:14');
INSERT INTO `sub_operation_history` VALUES (327, 3, 6, '徐庆华', 'add', '材料BOM', '新增材料BOM，产品编码：WA-A00001，部件编码：X002，材料编码：M0103-0234,M0103-0015,H0801-0004,H0703-0001', '{\"newData\":{\"product_id\":20,\"part_id\":22,\"children\":[{\"material_id\":10,\"number\":\"1\"},{\"material_id\":9,\"number\":\"2\"},{\"material_id\":11,\"number\":\"1\"},{\"material_id\":12,\"number\":\"1\"}],\"archive\":1}}', '2025-10-30 08:58:07');
INSERT INTO `sub_operation_history` VALUES (328, 3, 6, '徐庆华', 'add', '材料BOM', '新增材料BOM，产品编码：WA-A00001，部件编码：X009，材料编码：M0101-0635,H0703-0001', '{\"newData\":{\"product_id\":20,\"part_id\":29,\"children\":[{\"material_id\":13,\"number\":\"1\"},{\"material_id\":12,\"number\":\"1\"}],\"archive\":1}}', '2025-10-30 08:59:47');
INSERT INTO `sub_operation_history` VALUES (329, 3, 6, '徐庆华', 'add', '材料BOM', '新增材料BOM，产品编码：WA-A00001，部件编码：X008，材料编码：M0101-0636', '{\"newData\":{\"product_id\":20,\"part_id\":28,\"children\":[{\"material_id\":14,\"number\":\"1\"}],\"archive\":1}}', '2025-10-30 09:01:11');
INSERT INTO `sub_operation_history` VALUES (330, 3, 6, '徐庆华', 'add', '材料BOM', '新增材料BOM，产品编码：WA-A00001，部件编码：X015，材料编码：M0101-0019', '{\"newData\":{\"product_id\":20,\"part_id\":35,\"children\":[{\"material_id\":15,\"number\":\"1\"}],\"archive\":1}}', '2025-10-30 09:01:55');
INSERT INTO `sub_operation_history` VALUES (331, 3, 6, '徐庆华', 'add', '材料BOM', '新增材料BOM，产品编码：WA-A00001，部件编码：X016，材料编码：M0101-0020,H0801-0001', '{\"newData\":{\"product_id\":20,\"part_id\":36,\"children\":[{\"material_id\":16,\"number\":\"1\"},{\"material_id\":17,\"number\":\"1\"}],\"archive\":1}}', '2025-10-30 09:02:54');
INSERT INTO `sub_operation_history` VALUES (332, 3, 6, '徐庆华', 'add', '材料BOM', '新增材料BOM，产品编码：WA-A00001，部件编码：X010，材料编码：M0101-0444,H0703-0001,H0702-0001', '{\"newData\":{\"product_id\":20,\"part_id\":30,\"children\":[{\"material_id\":18,\"number\":\"1\"},{\"material_id\":12,\"number\":\"3\"},{\"material_id\":20,\"number\":\"2\"}],\"archive\":1}}', '2025-10-30 09:04:53');
INSERT INTO `sub_operation_history` VALUES (333, 3, 6, '徐庆华', 'add', '材料BOM', '新增材料BOM，产品编码：WA-A00001，部件编码：X011，材料编码：M0101-0445', '{\"newData\":{\"product_id\":20,\"part_id\":31,\"children\":[{\"material_id\":19,\"number\":\"1\"}],\"archive\":1}}', '2025-10-30 09:05:52');
INSERT INTO `sub_operation_history` VALUES (334, 3, 6, '徐庆华', 'add', '材料BOM', '新增材料BOM，产品编码：WA-A00001，部件编码：Y001，材料编码：H0302-0013,H1202-0012', '{\"newData\":{\"product_id\":20,\"part_id\":40,\"children\":[{\"material_id\":21,\"number\":\"1\"},{\"material_id\":23,\"number\":\"1\"}],\"archive\":1}}', '2025-10-30 09:07:19');
INSERT INTO `sub_operation_history` VALUES (335, 3, 6, '徐庆华', 'add', '材料BOM', '新增材料BOM，产品编码：WA-A00001，部件编码：Y002，材料编码：H0302-0014', '{\"newData\":{\"product_id\":20,\"part_id\":41,\"children\":[{\"material_id\":22,\"number\":\"1\"}],\"archive\":1}}', '2025-10-30 09:07:53');
INSERT INTO `sub_operation_history` VALUES (336, 3, 6, '徐庆华', 'add', '原材料编码', '新增原材料编码：H0802-0001', '{\"newData\":{\"material_code\":\"H0802-0001\",\"material_name\":\"货架螺母\",\"model\":\"YD008-021 M5\",\"specification\":\"YD008-021 M5\",\"other_features\":\"\",\"usage_unit\":\"个\",\"purchase_unit\":\"盒（50个）\",\"remarks\":\"\"}}', '2025-10-30 09:11:30');
INSERT INTO `sub_operation_history` VALUES (337, 3, 6, '徐庆华', 'add', '材料BOM', '新增材料BOM，产品编码：WA-A00001，部件编码：Y003，材料编码：H0802-0001', '{\"newData\":{\"product_id\":20,\"part_id\":42,\"children\":[{\"material_id\":27,\"number\":\"2\"}],\"archive\":1}}', '2025-10-30 09:12:29');
INSERT INTO `sub_operation_history` VALUES (338, 3, 6, '徐庆华', 'add', '材料BOM', '新增材料BOM，产品编码：WA-A00001，部件编码：Y004，材料编码：H0401-0036', '{\"newData\":{\"product_id\":20,\"part_id\":43,\"children\":[{\"material_id\":24,\"number\":\"1\"}],\"archive\":1}}', '2025-10-30 09:12:55');
INSERT INTO `sub_operation_history` VALUES (339, 3, 6, '徐庆华', 'add', '材料BOM', '新增材料BOM，产品编码：WA-A00001，部件编码：Y005，材料编码：H1102-0099,H1201-0001', '{\"newData\":{\"product_id\":20,\"part_id\":44,\"children\":[{\"material_id\":25,\"number\":\"1\"},{\"material_id\":26,\"number\":\"1\"}],\"archive\":1}}', '2025-10-30 09:13:58');
INSERT INTO `sub_operation_history` VALUES (340, 3, 6, '徐庆华', 'keyup', '材料BOM', '存档材料BOM，{ 产品编码：WA-A00001，部件编码：Y005，材料编码：H1102-0099,H1201-0001 }，{ 产品编码：WA-A00001，部件编码：Y004，材料编码：H0401-0036 }，{ 产品编码：WA-A00001，部件编码：Y003，材料编码：H0802-0001 }，{ 产品编码：WA-A00001，部件编码：Y002，材料编码：H0302-0014 }，{ 产品编码：WA-A00001，部件编码：Y001，材料编码：H1202-0012,H0302-0013 }，{ 产品编码：WA-A00001，部件编码：X011，材料编码：M0101-0445 }，{ 产品编码：WA-A00001，部件编码：X010，材料编码：H0703-0001,H0702-0001,M0101-0444 }，{ 产品编码：WA-A00001，部件编码：X016，材料编码：M0101-0020,H0801-0001 }，{ 产品编码：WA-A00001，部件编码：X015，材料编码：M0101-0019 }，{ 产品编码：WA-A00001，部件编码：X008，材料编码：M0101-0636 }，{ 产品编码：WA-A00001，部件编码：X009，材料编码：M0101-0635,H0703-0001 }，{ 产品编码：WA-A00001，部件编码：X002，材料编码：H0703-0001,M0103-0234,M0103-0015,H0801-0004 }，{ 产品编码：WA-A00001，部件编码：X018，材料编码：M0103-0015 }，{ 产品编码：WA-A00001，部件编码：X005，材料编码：M0101-0565,M0103-0015 }，{ 产品编码：WA-A00001，部件编码：X013，材料编码：M0101-1123 }，{ 产品编码：WA-A00001，部件编码：X014，材料编码：M0101-0668 }，{ 产品编码：WA-A00001，部件编码：X007，材料编码：H0201-0053 }，{ 产品编码：WA-A00001，部件编码：X001，材料编码：H0101-0089 }', '{\"newData\":{\"ids\":[41,40,39,38,37,36,35,34,33,32,31,30,29,28,27,26,24,23],\"archive\":0}}', '2025-10-30 09:14:43');
INSERT INTO `sub_operation_history` VALUES (341, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-10-30 10:03:47');
INSERT INTO `sub_operation_history` VALUES (342, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-10-30 10:54:26');
INSERT INTO `sub_operation_history` VALUES (343, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-10-30 11:08:59');
INSERT INTO `sub_operation_history` VALUES (344, 3, 6, '徐庆华', 'update', '工艺BOM', '修改工艺BOM，产品编码：WA-A00001，部件编码：X001，工艺编码：PA001', '{\"newData\":{\"id\":59,\"children\":[{\"id\":86,\"process_bom_id\":59,\"process_id\":7,\"equipment_id\":6,\"process_index\":1,\"time\":\"5\",\"price\":\"0.18\",\"points\":\"1\",\"process\":{\"id\":8,\"process_code\":\"PA002\",\"process_name\":\"冲孔\"},\"equipment\":{\"id\":7,\"equipment_code\":\"JX02\",\"equipment_name\":\"16T冲床\",\"cycle\":{\"id\":6,\"company_id\":3,\"user_id\":6,\"name\":\"备料组\",\"sort\":\"1\",\"sort_date\":\"1\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:10:27.000Z\",\"updated_at\":\"2025-10-28T05:40:09.000Z\"}}}],\"product_id\":20,\"part_id\":21,\"archive\":0}}', '2025-10-30 11:21:18');
INSERT INTO `sub_operation_history` VALUES (345, 3, 6, '徐庆华', 'update', '工艺BOM', '修改工艺BOM，产品编码：WA-A00001，部件编码：X007，工艺编码：PA002,PA002', '{\"newData\":{\"id\":60,\"children\":[{\"id\":77,\"process_bom_id\":60,\"process_id\":8,\"equipment_id\":7,\"process_index\":1,\"time\":\"4\",\"price\":\"0.05\",\"points\":\"1\",\"process\":{\"id\":8,\"process_code\":\"PA002\",\"process_name\":\"冲孔\"},\"equipment\":{\"id\":7,\"equipment_code\":\"JX02\",\"equipment_name\":\"16T冲床\",\"cycle\":{\"id\":6,\"company_id\":3,\"user_id\":6,\"name\":\"备料组\",\"sort\":\"1\",\"sort_date\":\"1\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:10:27.000Z\",\"updated_at\":\"2025-10-28T05:40:09.000Z\"}}},{\"id\":78,\"process_bom_id\":60,\"process_id\":8,\"equipment_id\":7,\"process_index\":2,\"time\":4,\"price\":\"0.05\",\"points\":\"1\",\"process\":{\"id\":7,\"process_code\":\"PA001\",\"process_name\":\"打字\"},\"equipment\":{\"id\":6,\"equipment_code\":\"JX01\",\"equipment_name\":\"打字机\",\"cycle\":{\"id\":6,\"company_id\":3,\"user_id\":6,\"name\":\"备料组\",\"sort\":\"1\",\"sort_date\":\"1\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:10:27.000Z\",\"updated_at\":\"2025-10-28T05:40:09.000Z\"}}}],\"product_id\":20,\"part_id\":27,\"archive\":0}}', '2025-10-30 11:52:42');
INSERT INTO `sub_operation_history` VALUES (346, 3, 6, '徐庆华', 'update', '工艺BOM', '修改工艺BOM，产品编码：WA-A00001，部件编码：X007，工艺编码：PA002,PA002,PA002,PA002', '{\"newData\":{\"id\":60,\"children\":[{\"id\":77,\"process_bom_id\":60,\"process_id\":8,\"equipment_id\":7,\"process_index\":1,\"time\":4,\"price\":\"0.05\",\"points\":\"1\",\"process\":{\"id\":8,\"process_code\":\"PA002\",\"process_name\":\"冲孔\"},\"equipment\":{\"id\":7,\"equipment_code\":\"JX02\",\"equipment_name\":\"16T冲床\",\"cycle\":{\"id\":6,\"company_id\":3,\"user_id\":6,\"name\":\"备料组\",\"sort\":\"1\",\"sort_date\":\"1\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:10:27.000Z\",\"updated_at\":\"2025-10-28T05:40:09.000Z\"}}},{\"id\":78,\"process_bom_id\":60,\"process_id\":8,\"equipment_id\":7,\"process_index\":2,\"time\":4,\"price\":\"0.05\",\"points\":\"1\",\"process\":{\"id\":8,\"process_code\":\"PA002\",\"process_name\":\"冲孔\"},\"equipment\":{\"id\":7,\"equipment_code\":\"JX02\",\"equipment_name\":\"16T冲床\",\"cycle\":{\"id\":6,\"company_id\":3,\"user_id\":6,\"name\":\"备料组\",\"sort\":\"1\",\"sort_date\":\"1\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:10:27.000Z\",\"updated_at\":\"2025-10-28T05:40:09.000Z\"}}},{\"process_id\":8,\"equipment_id\":7,\"time\":\"4\",\"price\":\"0.05\",\"points\":\"1\",\"process_index\":3,\"process_bom_id\":60},{\"process_id\":8,\"equipment_id\":7,\"time\":\"4\",\"price\":\"0.05\",\"points\":\"1\",\"process_index\":4,\"process_bom_id\":60}],\"product_id\":20,\"part_id\":27,\"archive\":0}}', '2025-10-30 12:00:52');
INSERT INTO `sub_operation_history` VALUES (347, 3, 6, '徐庆华', 'copeAdd', '工艺BOM', '复制新增工艺BOM，产品编码：WA-A00001，部件编码：X007，工艺编码：PA002,PA002,PA002,PA002', '{\"newData\":60}', '2025-10-30 12:02:25');
INSERT INTO `sub_operation_history` VALUES (348, 3, 6, '徐庆华', 'update', '工艺BOM', '修改工艺BOM，产品编码：WA-A00001，部件编码：X014，工艺编码：PA003,PA003,PA003,PA003,PA006,PA033', '{\"newData\":{\"id\":63,\"children\":[{\"id\":94,\"process_bom_id\":63,\"process_id\":9,\"equipment_id\":8,\"process_index\":1,\"time\":\"5\",\"price\":\"0.05\",\"points\":\"1\",\"process\":{\"id\":8,\"process_code\":\"PA002\",\"process_name\":\"冲孔\"},\"equipment\":{\"id\":7,\"equipment_code\":\"JX02\",\"equipment_name\":\"16T冲床\",\"cycle\":{\"id\":6,\"company_id\":3,\"user_id\":6,\"name\":\"备料组\",\"sort\":\"1\",\"sort_date\":\"1\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:10:27.000Z\",\"updated_at\":\"2025-10-28T05:40:09.000Z\"}}},{\"id\":95,\"process_bom_id\":63,\"process_id\":9,\"equipment_id\":8,\"process_index\":2,\"time\":\"5\",\"price\":\"0.05\",\"points\":\"1\",\"process\":{\"id\":8,\"process_code\":\"PA002\",\"process_name\":\"冲孔\"},\"equipment\":{\"id\":7,\"equipment_code\":\"JX02\",\"equipment_name\":\"16T冲床\",\"cycle\":{\"id\":6,\"company_id\":3,\"user_id\":6,\"name\":\"备料组\",\"sort\":\"1\",\"sort_date\":\"1\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:10:27.000Z\",\"updated_at\":\"2025-10-28T05:40:09.000Z\"}}},{\"id\":92,\"process_bom_id\":63,\"process_id\":9,\"equipment_id\":8,\"process_index\":3,\"time\":\"5\",\"price\":\"0.05\",\"points\":\"1\",\"process\":{\"id\":8,\"process_code\":\"PA002\",\"process_name\":\"冲孔\"},\"equipment\":{\"id\":7,\"equipment_code\":\"JX02\",\"equipment_name\":\"16T冲床\",\"cycle\":{\"id\":6,\"company_id\":3,\"user_id\":6,\"name\":\"备料组\",\"sort\":\"1\",\"sort_date\":\"1\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:10:27.000Z\",\"updated_at\":\"2025-10-28T05:40:09.000Z\"}}},{\"id\":93,\"process_bom_id\":63,\"process_id\":9,\"equipment_id\":8,\"process_index\":4,\"time\":\"5\",\"price\":\"0.05\",\"points\":\"1\",\"process\":{\"id\":8,\"process_code\":\"PA002\",\"process_name\":\"冲孔\"},\"equipment\":{\"id\":7,\"equipment_code\":\"JX02\",\"equipment_name\":\"16T冲床\",\"cycle\":{\"id\":6,\"company_id\":3,\"user_id\":6,\"name\":\"备料组\",\"sort\":\"1\",\"sort_date\":\"1\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:10:27.000Z\",\"updated_at\":\"2025-10-28T05:40:09.000Z\"}}},{\"process_id\":12,\"equipment_id\":10,\"time\":\"5\",\"price\":\"0.08\",\"points\":\"1\",\"process_index\":5,\"process_bom_id\":63},{\"process_id\":39,\"equipment_id\":47,\"time\":\"15\",\"price\":\"0.1\",\"points\":\"1\",\"process_index\":6,\"process_bom_id\":63}],\"product_id\":20,\"part_id\":34,\"archive\":1}}', '2025-10-30 12:13:30');
INSERT INTO `sub_operation_history` VALUES (349, 3, 6, '徐庆华', 'keyup', '工艺BOM', '存档工艺BOM，产品编码：WA-A00001，部件编码：X014，材料编码：PA003,PA003,PA003,PA006,PA003,PA033；', '{\"newData\":{\"ids\":[63],\"archive\":0}}', '2025-10-30 12:13:35');
INSERT INTO `sub_operation_history` VALUES (350, 3, 6, '徐庆华', 'copeAdd', '工艺BOM', '复制新增工艺BOM，产品编码：WA-A00001，部件编码：X007，工艺编码：PA002,PA002,PA002,PA002,,', '{\"newData\":60}', '2025-10-30 12:16:04');
INSERT INTO `sub_operation_history` VALUES (351, 3, 6, '徐庆华', 'update', '工艺BOM', '修改工艺BOM，产品编码：WA-A00001，部件编码：X013，工艺编码：PA033,PA005,PA006,PA007,PA007', '{\"newData\":{\"id\":64,\"children\":[{\"id\":104,\"process_bom_id\":64,\"process_id\":39,\"equipment_id\":47,\"process_index\":1,\"time\":\"15\",\"price\":\"0.05\",\"points\":\"1\",\"process\":{\"id\":8,\"process_code\":\"PA002\",\"process_name\":\"冲孔\"},\"equipment\":{\"id\":7,\"equipment_code\":\"JX02\",\"equipment_name\":\"16T冲床\",\"cycle\":{\"id\":6,\"company_id\":3,\"user_id\":6,\"name\":\"备料组\",\"sort\":\"1\",\"sort_date\":\"1\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:10:27.000Z\",\"updated_at\":\"2025-10-28T05:40:09.000Z\"}}},{\"id\":105,\"process_bom_id\":64,\"process_id\":11,\"equipment_id\":7,\"process_index\":2,\"time\":\"8\",\"price\":\"0.08\",\"points\":\"1\",\"process\":{\"id\":8,\"process_code\":\"PA002\",\"process_name\":\"冲孔\"},\"equipment\":{\"id\":7,\"equipment_code\":\"JX02\",\"equipment_name\":\"16T冲床\",\"cycle\":{\"id\":6,\"company_id\":3,\"user_id\":6,\"name\":\"备料组\",\"sort\":\"1\",\"sort_date\":\"1\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:10:27.000Z\",\"updated_at\":\"2025-10-28T05:40:09.000Z\"}}},{\"id\":102,\"process_bom_id\":64,\"process_id\":12,\"equipment_id\":10,\"process_index\":3,\"time\":\"5\",\"price\":\"0.07\",\"points\":\"1\",\"process\":{\"id\":8,\"process_code\":\"PA002\",\"process_name\":\"冲孔\"},\"equipment\":{\"id\":7,\"equipment_code\":\"JX02\",\"equipment_name\":\"16T冲床\",\"cycle\":{\"id\":6,\"company_id\":3,\"user_id\":6,\"name\":\"备料组\",\"sort\":\"1\",\"sort_date\":\"1\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:10:27.000Z\",\"updated_at\":\"2025-10-28T05:40:09.000Z\"}}},{\"id\":103,\"process_bom_id\":64,\"process_id\":13,\"equipment_id\":11,\"process_index\":4,\"time\":\"8\",\"price\":\"0.07\",\"points\":\"1\",\"process\":{\"id\":8,\"process_code\":\"PA002\",\"process_name\":\"冲孔\"},\"equipment\":{\"id\":7,\"equipment_code\":\"JX02\",\"equipment_name\":\"16T冲床\",\"cycle\":{\"id\":6,\"company_id\":3,\"user_id\":6,\"name\":\"备料组\",\"sort\":\"1\",\"sort_date\":\"1\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:10:27.000Z\",\"updated_at\":\"2025-10-28T05:40:09.000Z\"}}},{\"process_id\":13,\"equipment_id\":11,\"time\":\"8\",\"price\":\"0.08\",\"points\":\"1\",\"process_index\":5,\"process_bom_id\":64}],\"product_id\":20,\"part_id\":33,\"archive\":0}}', '2025-10-30 12:21:41');
INSERT INTO `sub_operation_history` VALUES (352, 3, 6, '徐庆华', 'copeAdd', '工艺BOM', '复制新增工艺BOM，产品编码：WA-A00001，部件编码：X013，工艺编码：PA007,PA033,PA005,PA006,PA007,', '{\"newData\":64}', '2025-10-30 12:31:48');
INSERT INTO `sub_operation_history` VALUES (353, 3, 6, '徐庆华', 'update', '工艺BOM', '修改工艺BOM，产品编码：WA-A00001，部件编码：X005，工艺编码：PA033,PA006,PA007,PA007,PA023', '{\"newData\":{\"id\":65,\"children\":[{\"id\":111,\"process_bom_id\":65,\"process_id\":39,\"equipment_id\":47,\"process_index\":1,\"time\":\"60\",\"price\":\"0.07\",\"points\":\"1\",\"process\":{\"id\":12,\"process_code\":\"PA006\",\"process_name\":\"冲弧\"},\"equipment\":{\"id\":10,\"equipment_code\":\"JX05\",\"equipment_name\":\"卧冲\",\"cycle\":{\"id\":6,\"company_id\":3,\"user_id\":6,\"name\":\"备料组\",\"sort\":\"1\",\"sort_date\":\"1\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:10:27.000Z\",\"updated_at\":\"2025-10-28T05:40:09.000Z\"}}},{\"id\":115,\"process_bom_id\":65,\"process_id\":12,\"equipment_id\":10,\"process_index\":2,\"time\":8,\"price\":\"0.07\",\"points\":\"1\",\"process\":{\"id\":13,\"process_code\":\"PA007\",\"process_name\":\"切斜\"},\"equipment\":{\"id\":11,\"equipment_code\":\"JX06\",\"equipment_name\":\"切料机\",\"cycle\":{\"id\":6,\"company_id\":3,\"user_id\":6,\"name\":\"备料组\",\"sort\":\"1\",\"sort_date\":\"1\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:10:27.000Z\",\"updated_at\":\"2025-10-28T05:40:09.000Z\"}}},{\"id\":112,\"process_bom_id\":65,\"process_id\":13,\"equipment_id\":11,\"process_index\":3,\"time\":\"10\",\"price\":\"0.08\",\"points\":\"1\",\"process\":{\"id\":13,\"process_code\":\"PA007\",\"process_name\":\"切斜\"},\"equipment\":{\"id\":11,\"equipment_code\":\"JX06\",\"equipment_name\":\"切料机\",\"cycle\":{\"id\":6,\"company_id\":3,\"user_id\":6,\"name\":\"备料组\",\"sort\":\"1\",\"sort_date\":\"1\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:10:27.000Z\",\"updated_at\":\"2025-10-28T05:40:09.000Z\"}}},{\"id\":113,\"process_bom_id\":65,\"process_id\":13,\"equipment_id\":11,\"process_index\":4,\"time\":\"10\",\"price\":\"0.08\",\"points\":\"1\",\"process\":{\"id\":39,\"process_code\":\"PA033\",\"process_name\":\"打磨\"},\"equipment\":{\"id\":47,\"equipment_code\":\"JX42\",\"equipment_name\":\"打磨毛刺校正\",\"cycle\":{\"id\":6,\"company_id\":3,\"user_id\":6,\"name\":\"备料组\",\"sort\":\"1\",\"sort_date\":\"1\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:10:27.000Z\",\"updated_at\":\"2025-10-28T05:40:09.000Z\"}}},{\"id\":114,\"process_bom_id\":65,\"process_id\":29,\"equipment_id\":22,\"process_index\":5,\"time\":\"20\",\"price\":\"0.35\",\"points\":\"1\",\"process\":{\"id\":11,\"process_code\":\"PA005\",\"process_name\":\"打弯\"},\"equipment\":{\"id\":7,\"equipment_code\":\"JX02\",\"equipment_name\":\"16T冲床\",\"cycle\":{\"id\":6,\"company_id\":3,\"user_id\":6,\"name\":\"备料组\",\"sort\":\"1\",\"sort_date\":\"1\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:10:27.000Z\",\"updated_at\":\"2025-10-28T05:40:09.000Z\"}}}],\"product_id\":20,\"part_id\":25,\"archive\":0}}', '2025-10-30 12:36:48');
INSERT INTO `sub_operation_history` VALUES (354, 3, 6, '徐庆华', 'update', '工艺BOM', '修改工艺BOM，产品编码：WA-A00001，部件编码：X013，工艺编码：PA033,PB005,PA006,PA007,PA007', '{\"newData\":{\"id\":64,\"children\":[{\"id\":103,\"process_bom_id\":64,\"process_id\":39,\"equipment_id\":47,\"process_index\":1,\"time\":\"15\",\"price\":\"0.05\",\"points\":\"1\",\"process\":{\"id\":13,\"process_code\":\"PA007\",\"process_name\":\"切斜\"},\"equipment\":{\"id\":11,\"equipment_code\":\"JX06\",\"equipment_name\":\"切料机\",\"cycle\":{\"id\":6,\"company_id\":3,\"user_id\":6,\"name\":\"备料组\",\"sort\":\"1\",\"sort_date\":\"1\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:10:27.000Z\",\"updated_at\":\"2025-10-28T05:40:09.000Z\"}}},{\"id\":104,\"process_bom_id\":64,\"process_id\":45,\"equipment_id\":7,\"process_index\":2,\"time\":\"8\",\"price\":\"0.08\",\"points\":\"1\",\"process\":{\"id\":39,\"process_code\":\"PA033\",\"process_name\":\"打磨\"},\"equipment\":{\"id\":47,\"equipment_code\":\"JX42\",\"equipment_name\":\"打磨毛刺校正\",\"cycle\":{\"id\":6,\"company_id\":3,\"user_id\":6,\"name\":\"备料组\",\"sort\":\"1\",\"sort_date\":\"1\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:10:27.000Z\",\"updated_at\":\"2025-10-28T05:40:09.000Z\"}}},{\"id\":105,\"process_bom_id\":64,\"process_id\":12,\"equipment_id\":10,\"process_index\":3,\"time\":\"5\",\"price\":\"0.07\",\"points\":\"1\",\"process\":{\"id\":11,\"process_code\":\"PA005\",\"process_name\":\"打弯\"},\"equipment\":{\"id\":7,\"equipment_code\":\"JX02\",\"equipment_name\":\"16T冲床\",\"cycle\":{\"id\":6,\"company_id\":3,\"user_id\":6,\"name\":\"备料组\",\"sort\":\"1\",\"sort_date\":\"1\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:10:27.000Z\",\"updated_at\":\"2025-10-28T05:40:09.000Z\"}}},{\"id\":102,\"process_bom_id\":64,\"process_id\":13,\"equipment_id\":11,\"process_index\":4,\"time\":\"8\",\"price\":\"0.07\",\"points\":\"1\",\"process\":{\"id\":12,\"process_code\":\"PA006\",\"process_name\":\"冲弧\"},\"equipment\":{\"id\":10,\"equipment_code\":\"JX05\",\"equipment_name\":\"卧冲\",\"cycle\":{\"id\":6,\"company_id\":3,\"user_id\":6,\"name\":\"备料组\",\"sort\":\"1\",\"sort_date\":\"1\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:10:27.000Z\",\"updated_at\":\"2025-10-28T05:40:09.000Z\"}}},{\"id\":106,\"process_bom_id\":64,\"process_id\":13,\"equipment_id\":11,\"process_index\":5,\"time\":8,\"price\":\"0.08\",\"points\":\"1\",\"process\":{\"id\":13,\"process_code\":\"PA007\",\"process_name\":\"切斜\"},\"equipment\":{\"id\":11,\"equipment_code\":\"JX06\",\"equipment_name\":\"切料机\",\"cycle\":{\"id\":6,\"company_id\":3,\"user_id\":6,\"name\":\"备料组\",\"sort\":\"1\",\"sort_date\":\"1\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:10:27.000Z\",\"updated_at\":\"2025-10-28T05:40:09.000Z\"}}}],\"product_id\":20,\"part_id\":33,\"archive\":0}}', '2025-10-30 12:46:33');
INSERT INTO `sub_operation_history` VALUES (355, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-10-30 13:10:09');
INSERT INTO `sub_operation_history` VALUES (356, 3, 6, '徐庆华', 'update', '工艺BOM', '修改工艺BOM，产品编码：WA-A00001，部件编码：X013，工艺编码：PA033,PA007,PA007,PA033,PB005', '{\"newData\":{\"id\":64,\"children\":[{\"id\":105,\"process_bom_id\":64,\"process_id\":39,\"equipment_id\":47,\"process_index\":1,\"time\":\"15\",\"price\":\"0.05\",\"points\":\"1\",\"process\":{\"id\":12,\"process_code\":\"PA006\",\"process_name\":\"冲弧\"},\"equipment\":{\"id\":10,\"equipment_code\":\"JX05\",\"equipment_name\":\"卧冲\",\"cycle\":{\"id\":6,\"company_id\":3,\"user_id\":6,\"name\":\"备料组\",\"sort\":\"1\",\"sort_date\":\"1\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:10:27.000Z\",\"updated_at\":\"2025-10-28T05:40:09.000Z\"}}},{\"id\":102,\"process_bom_id\":64,\"process_id\":13,\"equipment_id\":11,\"process_index\":2,\"time\":8,\"price\":\"0.07\",\"points\":\"1\",\"process\":{\"id\":13,\"process_code\":\"PA007\",\"process_name\":\"切斜\"},\"equipment\":{\"id\":11,\"equipment_code\":\"JX06\",\"equipment_name\":\"切料机\",\"cycle\":{\"id\":6,\"company_id\":3,\"user_id\":6,\"name\":\"备料组\",\"sort\":\"1\",\"sort_date\":\"1\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:10:27.000Z\",\"updated_at\":\"2025-10-28T05:40:09.000Z\"}}},{\"id\":106,\"process_bom_id\":64,\"process_id\":13,\"equipment_id\":11,\"process_index\":3,\"time\":8,\"price\":\"0.08\",\"points\":\"1\",\"process\":{\"id\":13,\"process_code\":\"PA007\",\"process_name\":\"切斜\"},\"equipment\":{\"id\":11,\"equipment_code\":\"JX06\",\"equipment_name\":\"切料机\",\"cycle\":{\"id\":6,\"company_id\":3,\"user_id\":6,\"name\":\"备料组\",\"sort\":\"1\",\"sort_date\":\"1\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:10:27.000Z\",\"updated_at\":\"2025-10-28T05:40:09.000Z\"}}},{\"id\":103,\"process_bom_id\":64,\"process_id\":39,\"equipment_id\":47,\"process_index\":4,\"time\":15,\"price\":\"0.05\",\"points\":\"1\",\"process\":{\"id\":39,\"process_code\":\"PA033\",\"process_name\":\"打磨\"},\"equipment\":{\"id\":47,\"equipment_code\":\"JX42\",\"equipment_name\":\"打磨毛刺校正\",\"cycle\":{\"id\":6,\"company_id\":3,\"user_id\":6,\"name\":\"备料组\",\"sort\":\"1\",\"sort_date\":\"1\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:10:27.000Z\",\"updated_at\":\"2025-10-28T05:40:09.000Z\"}}},{\"id\":104,\"process_bom_id\":64,\"process_id\":45,\"equipment_id\":7,\"process_index\":5,\"time\":8,\"price\":\"0.08\",\"points\":\"1\",\"process\":{\"id\":45,\"process_code\":\"PB005\",\"process_name\":\"点上支杆货架螺母\"},\"equipment\":{\"id\":7,\"equipment_code\":\"JX02\",\"equipment_name\":\"16T冲床\",\"cycle\":{\"id\":6,\"company_id\":3,\"user_id\":6,\"name\":\"备料组\",\"sort\":\"1\",\"sort_date\":\"1\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:10:27.000Z\",\"updated_at\":\"2025-10-28T05:40:09.000Z\"}}}],\"product_id\":20,\"part_id\":33,\"archive\":0}}', '2025-10-30 13:18:46');
INSERT INTO `sub_operation_history` VALUES (357, 3, 6, '徐庆华', 'update', '设备编码', '修改设备编码：JX30', '{\"newData\":{\"id\":35,\"company_id\":3,\"user_id\":6,\"equipment_code\":\"JX30\",\"equipment_name\":\"T4炉\",\"quantity\":60,\"cycle_id\":8,\"working_hours\":10,\"efficiency\":600,\"available\":60,\"remarks\":\"\",\"is_deleted\":1,\"created_at\":\"2025-10-28\",\"updated_at\":\"2025-10-28\",\"cycle\":{\"id\":8,\"company_id\":3,\"user_id\":6,\"name\":\"热处理\",\"sort\":\"3\",\"sort_date\":\"1.5\",\"is_deleted\":1,\"created_at\":\"2025-10-18T02:11:22.000Z\",\"updated_at\":\"2025-10-28T05:40:23.000Z\"}}}', '2025-10-30 13:33:51');
INSERT INTO `sub_operation_history` VALUES (358, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-10-30 13:39:11');
INSERT INTO `sub_operation_history` VALUES (359, 1, 1, '我是名字', 'login', '登录', '用户{ 我是名字 }成功登录', '{\"newData\":{\"username\":\"admin1\",\"password\":\"***\"}}', '2025-10-30 14:00:10');
INSERT INTO `sub_operation_history` VALUES (360, 1, 1, '我是名字', 'update', '生产制程', '修改生产制程：名称：设备组', '{\"newData\":{\"id\":2,\"name\":\"设备组\",\"sort\":\"2\"}}', '2025-10-30 14:00:49');
INSERT INTO `sub_operation_history` VALUES (361, 1, 1, '我是名字', 'update', '生产制程', '修改生产制程：名称：其他组', '{\"newData\":{\"id\":4,\"name\":\"其他组\",\"sort\":\"3\"}}', '2025-10-30 14:00:55');
INSERT INTO `sub_operation_history` VALUES (362, 1, 1, '我是名字', 'update', '生产制程', '修改生产制程：名称：备料组', '{\"newData\":{\"id\":1,\"name\":\"备料组\",\"sort\":\"4\"}}', '2025-10-30 14:01:01');
INSERT INTO `sub_operation_history` VALUES (363, 1, 1, '我是名字', 'update', '生产制程', '修改生产制程：名称：不好组', '{\"newData\":{\"id\":5,\"name\":\"不好组\",\"sort\":\"5\"}}', '2025-10-30 14:01:04');
INSERT INTO `sub_operation_history` VALUES (364, 1, 1, '我是名字', 'update', '生产制程', '修改生产制程：名称：生产组', '{\"newData\":{\"id\":3,\"name\":\"生产组\",\"sort\":\"6\"}}', '2025-10-30 14:01:09');
INSERT INTO `sub_operation_history` VALUES (365, 1, 1, '我是名字', 'update', '生产制程', '修改生产制程：名称：设备组', '{\"newData\":{\"id\":2,\"name\":\"设备组\",\"sort\":\"7\"}}', '2025-10-30 14:01:59');
INSERT INTO `sub_operation_history` VALUES (366, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-10-30 14:20:46');
INSERT INTO `sub_operation_history` VALUES (367, 1, 1, '我是名字', 'login', '登录', '用户{ 我是名字 }成功登录', '{\"newData\":{\"username\":\"admin1\",\"password\":\"***\"}}', '2025-10-30 15:53:40');
INSERT INTO `sub_operation_history` VALUES (368, 1, 1, '我是名字', 'update', '销售订单', '修改销售订单，客户订单号：hui11111111', '{\"newData\":{\"id\":2,\"company_id\":1,\"user_id\":1,\"rece_time\":\"2025-07-10\",\"customer_id\":2,\"customer_order\":\"hui11111111\",\"product_id\":19,\"product_req\":\"无要求\",\"order_number\":\"11000\",\"actual_number\":2121,\"unit\":\"件\",\"delivery_time\":\"2025-10-31\",\"goods_time\":\"2025-07-14\",\"goods_address\":\"寮步镇\",\"is_deleted\":1,\"created_at\":\"2025-07-14\",\"updated_at\":\"2025-09-03\",\"customer\":{\"id\":2,\"user_id\":1,\"company_id\":1,\"customer_code\":\"1234\",\"customer_abbreviation\":\"惠州饮料厂\",\"contact_person\":\"212\",\"contact_information\":\"121\",\"company_full_name\":\"21\",\"company_address\":\"121\",\"delivery_address\":\"2121\",\"tax_registration_number\":\"21\",\"transaction_method\":21,\"transaction_currency\":\"2121\",\"other_transaction_terms\":\"2121\",\"is_deleted\":1,\"created_at\":\"2025-07-08T16:58:19.000Z\",\"updated_at\":\"2025-10-22T05:18:16.000Z\"},\"product\":{\"id\":19,\"company_id\":1,\"user_id\":1,\"product_code\":\"A001\",\"product_name\":\"圆珠笔\",\"drawing\":\"qqqwe\",\"model\":\"eeqqwq\",\"specification\":\"sewww\",\"other_features\":\"ersdsd\",\"component_structure\":\"ewww\",\"unit\":\"ff\",\"production_requirements\":\"rww\",\"is_deleted\":1,\"created_at\":\"2025-08-10T02:09:09.000Z\",\"updated_at\":\"2025-08-21T07:44:55.000Z\"}}}', '2025-10-30 15:54:14');
INSERT INTO `sub_operation_history` VALUES (369, 1, 1, '我是名字', 'update', '销售订单', '修改销售订单，客户订单号：hui11111111', '{\"newData\":{\"id\":2,\"company_id\":1,\"user_id\":1,\"rece_time\":\"2025-07-10\",\"customer_id\":2,\"customer_order\":\"hui11111111\",\"product_id\":19,\"product_req\":\"无要求\",\"order_number\":\"12000\",\"actual_number\":2121,\"unit\":\"件\",\"delivery_time\":\"2025-10-31\",\"goods_time\":\"2025-07-14\",\"goods_address\":\"寮步镇\",\"is_deleted\":1,\"created_at\":\"2025-07-14\",\"updated_at\":\"2025-10-30\",\"customer\":{\"id\":2,\"user_id\":1,\"company_id\":1,\"customer_code\":\"1234\",\"customer_abbreviation\":\"惠州饮料厂\",\"contact_person\":\"212\",\"contact_information\":\"121\",\"company_full_name\":\"21\",\"company_address\":\"121\",\"delivery_address\":\"2121\",\"tax_registration_number\":\"21\",\"transaction_method\":21,\"transaction_currency\":\"2121\",\"other_transaction_terms\":\"2121\",\"is_deleted\":1,\"created_at\":\"2025-07-08T16:58:19.000Z\",\"updated_at\":\"2025-10-22T05:18:16.000Z\"},\"product\":{\"id\":19,\"company_id\":1,\"user_id\":1,\"product_code\":\"A001\",\"product_name\":\"圆珠笔\",\"drawing\":\"qqqwe\",\"model\":\"eeqqwq\",\"specification\":\"sewww\",\"other_features\":\"ersdsd\",\"component_structure\":\"ewww\",\"unit\":\"ff\",\"production_requirements\":\"rww\",\"is_deleted\":1,\"created_at\":\"2025-08-10T02:09:09.000Z\",\"updated_at\":\"2025-08-21T07:44:55.000Z\"}}}', '2025-10-30 15:56:28');
INSERT INTO `sub_operation_history` VALUES (370, 1, 1, '我是名字', 'update', '销售订单', '修改销售订单，客户订单号：hui11111111', '{\"newData\":{\"id\":2,\"company_id\":1,\"user_id\":1,\"rece_time\":\"2025-07-10\",\"customer_id\":2,\"customer_order\":\"hui11111111\",\"product_id\":19,\"product_req\":\"无要求\",\"order_number\":\"12000\",\"actual_number\":2121,\"unit\":\"件\",\"delivery_time\":\"2025-10-31\",\"goods_time\":\"2025-07-14\",\"goods_address\":\"寮步镇\",\"is_deleted\":1,\"created_at\":\"2025-07-14\",\"updated_at\":\"2025-10-30\",\"customer\":{\"id\":2,\"user_id\":1,\"company_id\":1,\"customer_code\":\"1234\",\"customer_abbreviation\":\"惠州饮料厂\",\"contact_person\":\"212\",\"contact_information\":\"121\",\"company_full_name\":\"21\",\"company_address\":\"121\",\"delivery_address\":\"2121\",\"tax_registration_number\":\"21\",\"transaction_method\":21,\"transaction_currency\":\"2121\",\"other_transaction_terms\":\"2121\",\"is_deleted\":1,\"created_at\":\"2025-07-08T16:58:19.000Z\",\"updated_at\":\"2025-10-22T05:18:16.000Z\"},\"product\":{\"id\":19,\"company_id\":1,\"user_id\":1,\"product_code\":\"A001\",\"product_name\":\"圆珠笔\",\"drawing\":\"qqqwe\",\"model\":\"eeqqwq\",\"specification\":\"sewww\",\"other_features\":\"ersdsd\",\"component_structure\":\"ewww\",\"unit\":\"ff\",\"production_requirements\":\"rww\",\"is_deleted\":1,\"created_at\":\"2025-08-10T02:09:09.000Z\",\"updated_at\":\"2025-08-21T07:44:55.000Z\"}}}', '2025-10-30 15:57:01');
INSERT INTO `sub_operation_history` VALUES (371, 1, 1, '我是名字', 'update', '销售订单', '修改销售订单，客户订单号：hui11111111', '{\"newData\":{\"id\":2,\"company_id\":1,\"user_id\":1,\"rece_time\":\"2025-07-10\",\"customer_id\":2,\"customer_order\":\"hui11111111\",\"product_id\":19,\"product_req\":\"无要求\",\"order_number\":\"17000\",\"actual_number\":2121,\"unit\":\"件\",\"delivery_time\":\"2025-10-31\",\"goods_time\":\"2025-07-14\",\"goods_address\":\"寮步镇\",\"is_deleted\":1,\"created_at\":\"2025-07-14\",\"updated_at\":\"2025-10-30\",\"customer\":{\"id\":2,\"user_id\":1,\"company_id\":1,\"customer_code\":\"1234\",\"customer_abbreviation\":\"惠州饮料厂\",\"contact_person\":\"212\",\"contact_information\":\"121\",\"company_full_name\":\"21\",\"company_address\":\"121\",\"delivery_address\":\"2121\",\"tax_registration_number\":\"21\",\"transaction_method\":21,\"transaction_currency\":\"2121\",\"other_transaction_terms\":\"2121\",\"is_deleted\":1,\"created_at\":\"2025-07-08T16:58:19.000Z\",\"updated_at\":\"2025-10-22T05:18:16.000Z\"},\"product\":{\"id\":19,\"company_id\":1,\"user_id\":1,\"product_code\":\"A001\",\"product_name\":\"圆珠笔\",\"drawing\":\"qqqwe\",\"model\":\"eeqqwq\",\"specification\":\"sewww\",\"other_features\":\"ersdsd\",\"component_structure\":\"ewww\",\"unit\":\"ff\",\"production_requirements\":\"rww\",\"is_deleted\":1,\"created_at\":\"2025-08-10T02:09:09.000Z\",\"updated_at\":\"2025-08-21T07:44:55.000Z\"}}}', '2025-10-30 16:02:02');
INSERT INTO `sub_operation_history` VALUES (372, 1, 1, '我是名字', 'update', '销售订单', '修改销售订单，客户订单号：hui11111111', '{\"newData\":{\"id\":2,\"company_id\":1,\"user_id\":1,\"rece_time\":\"2025-07-10\",\"customer_id\":2,\"customer_order\":\"hui11111111\",\"product_id\":19,\"product_req\":\"无要求\",\"order_number\":\"11000\",\"actual_number\":2121,\"unit\":\"件\",\"delivery_time\":\"2025-10-31\",\"goods_time\":\"2025-07-14\",\"goods_address\":\"寮步镇\",\"is_deleted\":1,\"created_at\":\"2025-07-14\",\"updated_at\":\"2025-10-31\",\"customer\":{\"id\":2,\"user_id\":1,\"company_id\":1,\"customer_code\":\"1234\",\"customer_abbreviation\":\"惠州饮料厂\",\"contact_person\":\"212\",\"contact_information\":\"121\",\"company_full_name\":\"21\",\"company_address\":\"121\",\"delivery_address\":\"2121\",\"tax_registration_number\":\"21\",\"transaction_method\":21,\"transaction_currency\":\"2121\",\"other_transaction_terms\":\"2121\",\"is_deleted\":1,\"created_at\":\"2025-07-08T16:58:19.000Z\",\"updated_at\":\"2025-10-22T05:18:16.000Z\"},\"product\":{\"id\":19,\"company_id\":1,\"user_id\":1,\"product_code\":\"A001\",\"product_name\":\"圆珠笔\",\"drawing\":\"qqqwe\",\"model\":\"eeqqwq\",\"specification\":\"sewww\",\"other_features\":\"ersdsd\",\"component_structure\":\"ewww\",\"unit\":\"ff\",\"production_requirements\":\"rww\",\"is_deleted\":1,\"created_at\":\"2025-08-10T02:09:09.000Z\",\"updated_at\":\"2025-08-21T07:44:55.000Z\"}}}', '2025-10-30 16:03:39');
INSERT INTO `sub_operation_history` VALUES (373, 1, 1, '我是名字', 'update', '销售订单', '修改销售订单，客户订单号：hui11111111', '{\"newData\":{\"id\":2,\"company_id\":1,\"user_id\":1,\"rece_time\":\"2025-07-10\",\"customer_id\":2,\"customer_order\":\"hui11111111\",\"product_id\":19,\"product_req\":\"无要求\",\"order_number\":\"12000\",\"actual_number\":2121,\"unit\":\"件\",\"delivery_time\":\"2025-10-31\",\"goods_time\":\"2025-07-14\",\"goods_address\":\"寮步镇\",\"is_deleted\":1,\"created_at\":\"2025-07-14\",\"updated_at\":\"2025-10-31\",\"customer\":{\"id\":2,\"user_id\":1,\"company_id\":1,\"customer_code\":\"1234\",\"customer_abbreviation\":\"惠州饮料厂\",\"contact_person\":\"212\",\"contact_information\":\"121\",\"company_full_name\":\"21\",\"company_address\":\"121\",\"delivery_address\":\"2121\",\"tax_registration_number\":\"21\",\"transaction_method\":21,\"transaction_currency\":\"2121\",\"other_transaction_terms\":\"2121\",\"is_deleted\":1,\"created_at\":\"2025-07-08T16:58:19.000Z\",\"updated_at\":\"2025-10-22T05:18:16.000Z\"},\"product\":{\"id\":19,\"company_id\":1,\"user_id\":1,\"product_code\":\"A001\",\"product_name\":\"圆珠笔\",\"drawing\":\"qqqwe\",\"model\":\"eeqqwq\",\"specification\":\"sewww\",\"other_features\":\"ersdsd\",\"component_structure\":\"ewww\",\"unit\":\"ff\",\"production_requirements\":\"rww\",\"is_deleted\":1,\"created_at\":\"2025-08-10T02:09:09.000Z\",\"updated_at\":\"2025-08-21T07:44:55.000Z\"}}}', '2025-10-30 16:04:25');
INSERT INTO `sub_operation_history` VALUES (374, 1, 1, '我是名字', 'update', '销售订单', '修改销售订单，客户订单号：hui11111111', '{\"newData\":{\"id\":2,\"company_id\":1,\"user_id\":1,\"rece_time\":\"2025-07-10\",\"customer_id\":2,\"customer_order\":\"hui11111111\",\"product_id\":19,\"product_req\":\"无要求\",\"order_number\":\"13000\",\"actual_number\":2121,\"unit\":\"件\",\"delivery_time\":\"2025-10-31\",\"goods_time\":\"2025-07-14\",\"goods_address\":\"寮步镇\",\"is_deleted\":1,\"created_at\":\"2025-07-14\",\"updated_at\":\"2025-10-31\",\"customer\":{\"id\":2,\"user_id\":1,\"company_id\":1,\"customer_code\":\"1234\",\"customer_abbreviation\":\"惠州饮料厂\",\"contact_person\":\"212\",\"contact_information\":\"121\",\"company_full_name\":\"21\",\"company_address\":\"121\",\"delivery_address\":\"2121\",\"tax_registration_number\":\"21\",\"transaction_method\":21,\"transaction_currency\":\"2121\",\"other_transaction_terms\":\"2121\",\"is_deleted\":1,\"created_at\":\"2025-07-08T16:58:19.000Z\",\"updated_at\":\"2025-10-22T05:18:16.000Z\"},\"product\":{\"id\":19,\"company_id\":1,\"user_id\":1,\"product_code\":\"A001\",\"product_name\":\"圆珠笔\",\"drawing\":\"qqqwe\",\"model\":\"eeqqwq\",\"specification\":\"sewww\",\"other_features\":\"ersdsd\",\"component_structure\":\"ewww\",\"unit\":\"ff\",\"production_requirements\":\"rww\",\"is_deleted\":1,\"created_at\":\"2025-08-10T02:09:09.000Z\",\"updated_at\":\"2025-08-21T07:44:55.000Z\"}}}', '2025-10-30 16:04:54');
INSERT INTO `sub_operation_history` VALUES (375, 1, 1, '我是名字', 'update', '销售订单', '修改销售订单，客户订单号：hui11111111', '{\"newData\":{\"id\":2,\"company_id\":1,\"user_id\":1,\"rece_time\":\"2025-07-10\",\"customer_id\":2,\"customer_order\":\"hui11111111\",\"product_id\":19,\"product_req\":\"无要求\",\"order_number\":\"11000\",\"actual_number\":2121,\"unit\":\"件\",\"delivery_time\":\"2025-10-31\",\"goods_time\":\"2025-07-14\",\"goods_address\":\"寮步镇\",\"is_deleted\":1,\"created_at\":\"2025-07-14\",\"updated_at\":\"2025-10-31\",\"customer\":{\"id\":2,\"user_id\":1,\"company_id\":1,\"customer_code\":\"1234\",\"customer_abbreviation\":\"惠州饮料厂\",\"contact_person\":\"212\",\"contact_information\":\"121\",\"company_full_name\":\"21\",\"company_address\":\"121\",\"delivery_address\":\"2121\",\"tax_registration_number\":\"21\",\"transaction_method\":21,\"transaction_currency\":\"2121\",\"other_transaction_terms\":\"2121\",\"is_deleted\":1,\"created_at\":\"2025-07-08T16:58:19.000Z\",\"updated_at\":\"2025-10-22T05:18:16.000Z\"},\"product\":{\"id\":19,\"company_id\":1,\"user_id\":1,\"product_code\":\"A001\",\"product_name\":\"圆珠笔\",\"drawing\":\"qqqwe\",\"model\":\"eeqqwq\",\"specification\":\"sewww\",\"other_features\":\"ersdsd\",\"component_structure\":\"ewww\",\"unit\":\"ff\",\"production_requirements\":\"rww\",\"is_deleted\":1,\"created_at\":\"2025-08-10T02:09:09.000Z\",\"updated_at\":\"2025-08-21T07:44:55.000Z\"}}}', '2025-10-30 16:05:21');
INSERT INTO `sub_operation_history` VALUES (376, 1, 1, '我是名字', 'update', '工艺BOM', '修改工艺BOM，产品编码：A001，部件编码：1234，工艺编码：T002,T001', '{\"newData\":{\"id\":58,\"children\":[{\"process_id\":6,\"equipment_id\":4,\"time\":\"5\",\"price\":\"9\",\"points\":\"1\",\"process_index\":1,\"process_bom_id\":58},{\"process_id\":5,\"equipment_id\":3,\"time\":\"6\",\"price\":\"7\",\"points\":\"1\",\"process_index\":2,\"process_bom_id\":58}],\"product_id\":19,\"part_id\":7,\"archive\":0}}', '2025-10-30 16:12:49');
INSERT INTO `sub_operation_history` VALUES (377, 1, 1, '我是名字', 'update', '工艺BOM', '修改工艺BOM，产品编码：12323，部件编码：12312，工艺编码：T001,T002', '{\"newData\":{\"id\":57,\"children\":[{\"process_id\":5,\"equipment_id\":5,\"time\":\"2\",\"price\":\"8\",\"points\":\"1\",\"process_index\":1,\"process_bom_id\":57},{\"process_id\":6,\"equipment_id\":4,\"time\":\"4\",\"price\":\"3\",\"points\":\"1\",\"process_index\":2,\"process_bom_id\":57}],\"product_id\":14,\"part_id\":12,\"archive\":0}}', '2025-10-30 16:13:17');
INSERT INTO `sub_operation_history` VALUES (378, 1, 1, '我是名字', 'update', '工艺BOM', '修改工艺BOM，产品编码：A001，部件编码：1238，工艺编码：T001', '{\"newData\":{\"id\":56,\"children\":[{\"process_id\":5,\"equipment_id\":3,\"time\":\"3\",\"price\":\"9\",\"points\":\"1\",\"process_index\":1,\"process_bom_id\":56}],\"product_id\":19,\"part_id\":8,\"archive\":0}}', '2025-10-30 16:13:27');
INSERT INTO `sub_operation_history` VALUES (379, 1, 1, '我是名字', 'paichang', '生产通知单', '执行通知单排产，订单号：1122', '{\"newData\":8}', '2025-10-30 16:16:01');
INSERT INTO `sub_operation_history` VALUES (380, 1, 1, '我是名字', 'update', '销售订单', '修改销售订单，客户订单号：hui11111111', '{\"newData\":{\"id\":2,\"company_id\":1,\"user_id\":1,\"rece_time\":\"2025-07-10\",\"customer_id\":2,\"customer_order\":\"hui11111111\",\"product_id\":19,\"product_req\":\"无要求\",\"order_number\":\"11000\",\"actual_number\":2121,\"unit\":\"件\",\"delivery_time\":\"2025-11-05\",\"goods_time\":\"2025-07-06\",\"goods_address\":\"寮步镇\",\"is_deleted\":1,\"created_at\":\"2025-07-14\",\"updated_at\":\"2025-10-31\",\"customer\":{\"id\":2,\"user_id\":1,\"company_id\":1,\"customer_code\":\"1234\",\"customer_abbreviation\":\"惠州饮料厂\",\"contact_person\":\"212\",\"contact_information\":\"121\",\"company_full_name\":\"21\",\"company_address\":\"121\",\"delivery_address\":\"2121\",\"tax_registration_number\":\"21\",\"transaction_method\":21,\"transaction_currency\":\"2121\",\"other_transaction_terms\":\"2121\",\"is_deleted\":1,\"created_at\":\"2025-07-08T16:58:19.000Z\",\"updated_at\":\"2025-10-22T05:18:16.000Z\"},\"product\":{\"id\":19,\"company_id\":1,\"user_id\":1,\"product_code\":\"A001\",\"product_name\":\"圆珠笔\",\"drawing\":\"qqqwe\",\"model\":\"eeqqwq\",\"specification\":\"sewww\",\"other_features\":\"ersdsd\",\"component_structure\":\"ewww\",\"unit\":\"ff\",\"production_requirements\":\"rww\",\"is_deleted\":1,\"created_at\":\"2025-08-10T02:09:09.000Z\",\"updated_at\":\"2025-08-21T07:44:55.000Z\"}}}', '2025-10-30 16:16:40');
INSERT INTO `sub_operation_history` VALUES (381, 1, 1, '我是名字', 'update', '生产通知单', '修改生产通知单，订单号：1122', '{\"newData\":{\"id\":8,\"company_id\":1,\"user_id\":1,\"notice\":\"1122\",\"sale_id\":2,\"product_id\":19,\"customer_id\":2,\"delivery_time\":\"2025-11-05\",\"is_notice\":0,\"is_finish\":1,\"is_deleted\":1,\"created_at\":\"2025-09-24\",\"updated_at\":\"2025-10-31\",\"sale\":{\"id\":2,\"company_id\":1,\"user_id\":1,\"rece_time\":\"2025-07-10\",\"customer_id\":2,\"customer_order\":\"hui11111111\",\"product_id\":19,\"product_req\":\"无要求\",\"order_number\":\"11000\",\"actual_number\":2121,\"unit\":\"件\",\"delivery_time\":\"2025-11-05\",\"goods_time\":\"2025-07-06\",\"goods_address\":\"寮步镇\",\"is_deleted\":1,\"created_at\":\"2025-07-14T10:47:31.000Z\",\"updated_at\":\"2025-10-30T16:16:40.000Z\"},\"customer\":{\"id\":2,\"user_id\":1,\"company_id\":1,\"customer_code\":\"1234\",\"customer_abbreviation\":\"惠州饮料厂\",\"contact_person\":\"212\",\"contact_information\":\"121\",\"company_full_name\":\"21\",\"company_address\":\"121\",\"delivery_address\":\"2121\",\"tax_registration_number\":\"21\",\"transaction_method\":21,\"transaction_currency\":\"2121\",\"other_transaction_terms\":\"2121\",\"is_deleted\":1,\"created_at\":\"2025-07-08T16:58:19.000Z\",\"updated_at\":\"2025-10-22T05:18:16.000Z\"},\"product\":{\"id\":19,\"company_id\":1,\"user_id\":1,\"product_code\":\"A001\",\"product_name\":\"圆珠笔\",\"drawing\":\"qqqwe\",\"model\":\"eeqqwq\",\"specification\":\"sewww\",\"other_features\":\"ersdsd\",\"component_structure\":\"ewww\",\"unit\":\"ff\",\"production_requirements\":\"rww\",\"is_deleted\":1,\"created_at\":\"2025-08-10T02:09:09.000Z\",\"updated_at\":\"2025-08-21T07:44:55.000Z\"}}}', '2025-10-30 16:17:01');
INSERT INTO `sub_operation_history` VALUES (382, 1, 1, '我是名字', 'update', '销售订单', '修改销售订单，客户订单号：hui11111111', '{\"newData\":{\"id\":2,\"company_id\":1,\"user_id\":1,\"rece_time\":\"2025-07-10\",\"customer_id\":2,\"customer_order\":\"hui11111111\",\"product_id\":19,\"product_req\":\"无要求\",\"order_number\":\"12000\",\"actual_number\":2121,\"unit\":\"件\",\"delivery_time\":\"2025-11-05\",\"goods_time\":\"2025-07-06\",\"goods_address\":\"寮步镇\",\"is_deleted\":1,\"created_at\":\"2025-07-14\",\"updated_at\":\"2025-10-31\",\"customer\":{\"id\":2,\"user_id\":1,\"company_id\":1,\"customer_code\":\"1234\",\"customer_abbreviation\":\"惠州饮料厂\",\"contact_person\":\"212\",\"contact_information\":\"121\",\"company_full_name\":\"21\",\"company_address\":\"121\",\"delivery_address\":\"2121\",\"tax_registration_number\":\"21\",\"transaction_method\":21,\"transaction_currency\":\"2121\",\"other_transaction_terms\":\"2121\",\"is_deleted\":1,\"created_at\":\"2025-07-08T16:58:19.000Z\",\"updated_at\":\"2025-10-22T05:18:16.000Z\"},\"product\":{\"id\":19,\"company_id\":1,\"user_id\":1,\"product_code\":\"A001\",\"product_name\":\"圆珠笔\",\"drawing\":\"qqqwe\",\"model\":\"eeqqwq\",\"specification\":\"sewww\",\"other_features\":\"ersdsd\",\"component_structure\":\"ewww\",\"unit\":\"ff\",\"production_requirements\":\"rww\",\"is_deleted\":1,\"created_at\":\"2025-08-10T02:09:09.000Z\",\"updated_at\":\"2025-08-21T07:44:55.000Z\"}}}', '2025-10-30 16:21:46');
INSERT INTO `sub_operation_history` VALUES (383, 1, 1, '我是名字', 'update', '销售订单', '修改销售订单，客户订单号：hui11111111', '{\"newData\":{\"id\":2,\"company_id\":1,\"user_id\":1,\"rece_time\":\"2025-07-10\",\"customer_id\":2,\"customer_order\":\"hui11111111\",\"product_id\":19,\"product_req\":\"无要求\",\"order_number\":\"13000\",\"actual_number\":2121,\"unit\":\"件\",\"delivery_time\":\"2025-11-05\",\"goods_time\":\"2025-07-06\",\"goods_address\":\"寮步镇\",\"is_deleted\":1,\"created_at\":\"2025-07-14\",\"updated_at\":\"2025-10-31\",\"customer\":{\"id\":2,\"user_id\":1,\"company_id\":1,\"customer_code\":\"1234\",\"customer_abbreviation\":\"惠州饮料厂\",\"contact_person\":\"212\",\"contact_information\":\"121\",\"company_full_name\":\"21\",\"company_address\":\"121\",\"delivery_address\":\"2121\",\"tax_registration_number\":\"21\",\"transaction_method\":21,\"transaction_currency\":\"2121\",\"other_transaction_terms\":\"2121\",\"is_deleted\":1,\"created_at\":\"2025-07-08T16:58:19.000Z\",\"updated_at\":\"2025-10-22T05:18:16.000Z\"},\"product\":{\"id\":19,\"company_id\":1,\"user_id\":1,\"product_code\":\"A001\",\"product_name\":\"圆珠笔\",\"drawing\":\"qqqwe\",\"model\":\"eeqqwq\",\"specification\":\"sewww\",\"other_features\":\"ersdsd\",\"component_structure\":\"ewww\",\"unit\":\"ff\",\"production_requirements\":\"rww\",\"is_deleted\":1,\"created_at\":\"2025-08-10T02:09:09.000Z\",\"updated_at\":\"2025-08-21T07:44:55.000Z\"}}}', '2025-10-30 16:21:53');
INSERT INTO `sub_operation_history` VALUES (384, 1, 1, '我是名字', 'update', '材料BOM', '修改材料BOM，产品编码：12323，部件编码：12311，材料编码：123', '{\"newData\":{\"id\":21,\"product_id\":14,\"part_id\":10,\"children\":[{\"id\":26,\"material_bom_id\":21,\"material_id\":2,\"number\":485,\"material\":{\"id\":2,\"material_code\":\"123\",\"material_name\":\"121\",\"specification\":\"21\"}}],\"archive\":1}}', '2025-10-31 02:09:00');
INSERT INTO `sub_operation_history` VALUES (385, 1, 1, '我是名字', 'update', '材料BOM', '修改材料BOM，产品编码：12323，部件编码：12313，材料编码：123,123', '{\"newData\":{\"id\":20,\"product_id\":14,\"part_id\":13,\"children\":[{\"id\":24,\"material_bom_id\":20,\"material_id\":2,\"number\":198,\"material\":{\"id\":2,\"material_code\":\"123\",\"material_name\":\"121\",\"specification\":\"21\"}},{\"id\":25,\"material_bom_id\":20,\"material_id\":2,\"number\":158,\"material\":{\"id\":2,\"material_code\":\"123\",\"material_name\":\"121\",\"specification\":\"21\"}}],\"archive\":1}}', '2025-10-31 02:09:05');
INSERT INTO `sub_operation_history` VALUES (386, 1, 1, '我是名字', 'update', '材料BOM', '修改材料BOM，产品编码：12323，部件编码：12311，材料编码：123,789', '{\"newData\":{\"id\":19,\"product_id\":14,\"part_id\":10,\"children\":[{\"id\":22,\"material_bom_id\":19,\"material_id\":2,\"number\":600,\"material\":{\"id\":2,\"material_code\":\"123\",\"material_name\":\"121\",\"specification\":\"21\"}},{\"id\":23,\"material_bom_id\":19,\"material_id\":3,\"number\":\"70\",\"material\":{\"id\":3,\"material_code\":\"789\",\"material_name\":\"555\",\"specification\":\"35353\"}}],\"archive\":1}}', '2025-10-31 02:09:11');
INSERT INTO `sub_operation_history` VALUES (387, 1, 1, '我是名字', 'update', '材料BOM', '修改材料BOM，产品编码：1234，部件编码：12310，材料编码：789,123', '{\"newData\":{\"id\":18,\"product_id\":11,\"part_id\":9,\"children\":[{\"id\":21,\"material_bom_id\":18,\"material_id\":3,\"number\":900,\"material\":{\"id\":3,\"material_code\":\"789\",\"material_name\":\"555\",\"specification\":\"35353\"}},{\"material_id\":2,\"number\":\"70\"}],\"archive\":1}}', '2025-10-31 02:09:20');
INSERT INTO `sub_operation_history` VALUES (388, 1, 1, '我是名字', 'keyup', '材料BOM', '存档材料BOM，{ 产品编码：12324，部件编码：1238，材料编码：789,123,789,123 }，{ 产品编码：12323，部件编码：12311，材料编码：123 }，{ 产品编码：12323，部件编码：12313，材料编码：123,123 }，{ 产品编码：12323，部件编码：12311，材料编码：123,789 }，{ 产品编码：1234，部件编码：12310，材料编码：789,123 }', '{\"newData\":{\"ids\":[25,21,20,19,18],\"archive\":0}}', '2025-10-31 02:10:11');
INSERT INTO `sub_operation_history` VALUES (389, 1, 1, '我是名字', 'update', '材料BOM', '修改材料BOM，产品编码：12323，部件编码：12311，材料编码：123,789', '{\"newData\":{\"id\":21,\"product_id\":14,\"part_id\":10,\"children\":[{\"id\":26,\"material_bom_id\":21,\"material_id\":2,\"number\":485,\"material\":{\"id\":2,\"material_code\":\"123\",\"material_name\":\"121\",\"specification\":\"21\"}},{\"material_id\":3,\"number\":\"80\"}],\"archive\":0}}', '2025-10-31 02:10:23');
INSERT INTO `sub_operation_history` VALUES (390, 1, 1, '我是名字', 'update', '材料BOM', '修改材料BOM，产品编码：12323，部件编码：12311，材料编码：789,123', '{\"newData\":{\"id\":21,\"product_id\":14,\"part_id\":10,\"children\":[{\"id\":67,\"material_bom_id\":21,\"material_id\":3,\"number\":\"70\",\"material\":{\"id\":3,\"material_code\":\"789\",\"material_name\":\"555\",\"specification\":\"35353\"}},{\"id\":26,\"material_bom_id\":21,\"material_id\":2,\"number\":485,\"material\":{\"id\":2,\"material_code\":\"123\",\"material_name\":\"121\",\"specification\":\"21\"}}],\"archive\":0}}', '2025-10-31 02:10:31');
INSERT INTO `sub_operation_history` VALUES (391, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-10-31 02:19:10');
INSERT INTO `sub_operation_history` VALUES (392, 1, 1, '我是名字', 'login', '登录', '用户{ 我是名字 }成功登录', '{\"newData\":{\"username\":\"admin1\",\"password\":\"***\"}}', '2025-10-31 02:31:00');
INSERT INTO `sub_operation_history` VALUES (393, 1, 1, '我是名字', 'update', '生产通知单', '修改生产通知单，订单号：1122', '{\"newData\":{\"id\":8,\"company_id\":1,\"user_id\":1,\"notice\":\"1122\",\"sale_id\":2,\"product_id\":19,\"customer_id\":2,\"delivery_time\":\"2025-11-20\",\"is_notice\":0,\"is_finish\":1,\"is_deleted\":1,\"created_at\":\"2025-09-24\",\"updated_at\":\"2025-10-31\",\"sale\":{\"id\":2,\"company_id\":1,\"user_id\":1,\"rece_time\":\"2025-07-10\",\"customer_id\":2,\"customer_order\":\"hui11111111\",\"product_id\":19,\"product_req\":\"无要求\",\"order_number\":\"13000\",\"actual_number\":2121,\"unit\":\"件\",\"delivery_time\":\"2025-11-05\",\"goods_time\":\"2025-07-06\",\"goods_address\":\"寮步镇\",\"is_deleted\":1,\"created_at\":\"2025-07-14T10:47:31.000Z\",\"updated_at\":\"2025-10-30T16:21:53.000Z\"},\"customer\":{\"id\":2,\"user_id\":1,\"company_id\":1,\"customer_code\":\"1234\",\"customer_abbreviation\":\"惠州饮料厂\",\"contact_person\":\"212\",\"contact_information\":\"121\",\"company_full_name\":\"21\",\"company_address\":\"121\",\"delivery_address\":\"2121\",\"tax_registration_number\":\"21\",\"transaction_method\":21,\"transaction_currency\":\"2121\",\"other_transaction_terms\":\"2121\",\"is_deleted\":1,\"created_at\":\"2025-07-08T16:58:19.000Z\",\"updated_at\":\"2025-10-22T05:18:16.000Z\"},\"product\":{\"id\":19,\"company_id\":1,\"user_id\":1,\"product_code\":\"A001\",\"product_name\":\"圆珠笔\",\"drawing\":\"qqqwe\",\"model\":\"eeqqwq\",\"specification\":\"sewww\",\"other_features\":\"ersdsd\",\"component_structure\":\"ewww\",\"unit\":\"ff\",\"production_requirements\":\"rww\",\"is_deleted\":1,\"created_at\":\"2025-08-10T02:09:09.000Z\",\"updated_at\":\"2025-08-21T07:44:55.000Z\"}}}', '2025-10-31 03:15:39');
INSERT INTO `sub_operation_history` VALUES (394, 3, 6, '徐庆华', 'login', '登录', '用户{ 徐庆华 }成功登录', '{\"newData\":{\"username\":\"xuqinghua\",\"password\":\"***\"}}', '2025-10-31 03:38:42');
INSERT INTO `sub_operation_history` VALUES (395, 1, 1, '我是名字', 'login', '登录', '用户{ 我是名字 }成功登录', '{\"newData\":{\"username\":\"admin1\",\"password\":\"***\"}}', '2025-10-31 03:42:26');
INSERT INTO `sub_operation_history` VALUES (396, 1, 1, '我是名字', 'update', '生产通知单', '修改生产通知单，订单号：1122', '{\"newData\":{\"id\":8,\"company_id\":1,\"user_id\":1,\"notice\":\"1122\",\"sale_id\":2,\"product_id\":19,\"customer_id\":2,\"delivery_time\":\"2025-11-20\",\"is_notice\":1,\"is_finish\":1,\"is_deleted\":1,\"created_at\":\"2025-09-24\",\"updated_at\":\"2025-11-01\",\"sale\":{\"id\":2,\"company_id\":1,\"user_id\":1,\"rece_time\":\"2025-07-10\",\"customer_id\":2,\"customer_order\":\"hui11111111\",\"product_id\":19,\"product_req\":\"无要求\",\"order_number\":\"13000\",\"actual_number\":2121,\"unit\":\"件\",\"delivery_time\":\"2025-11-05\",\"goods_time\":\"2025-07-06\",\"goods_address\":\"寮步镇\",\"is_deleted\":1,\"created_at\":\"2025-07-14T10:47:31.000Z\",\"updated_at\":\"2025-10-30T16:21:53.000Z\"},\"customer\":{\"id\":2,\"user_id\":1,\"company_id\":1,\"customer_code\":\"1234\",\"customer_abbreviation\":\"惠州饮料厂\",\"contact_person\":\"212\",\"contact_information\":\"121\",\"company_full_name\":\"21\",\"company_address\":\"121\",\"delivery_address\":\"2121\",\"tax_registration_number\":\"21\",\"transaction_method\":21,\"transaction_currency\":\"2121\",\"other_transaction_terms\":\"2121\",\"is_deleted\":1,\"created_at\":\"2025-07-08T16:58:19.000Z\",\"updated_at\":\"2025-10-22T05:18:16.000Z\"},\"product\":{\"id\":19,\"company_id\":1,\"user_id\":1,\"product_code\":\"A001\",\"product_name\":\"圆珠笔\",\"drawing\":\"qqqwe\",\"model\":\"eeqqwq\",\"specification\":\"sewww\",\"other_features\":\"ersdsd\",\"component_structure\":\"ewww\",\"unit\":\"ff\",\"production_requirements\":\"rww\",\"is_deleted\":1,\"created_at\":\"2025-08-10T02:09:09.000Z\",\"updated_at\":\"2025-08-21T07:44:55.000Z\"}}}', '2025-11-01 13:28:26');
INSERT INTO `sub_operation_history` VALUES (397, 1, 1, '我是名字', 'paichang', '生产通知单', '执行通知单排产，订单号：1122', '{\"newData\":8}', '2025-11-01 14:13:25');
INSERT INTO `sub_operation_history` VALUES (398, 1, 1, '我是名字', 'update', '生产制程', '修改生产制程：名称：备料组', '{\"newData\":{\"id\":1,\"name\":\"备料组\",\"sort\":\"8\"}}', '2025-11-01 14:15:43');
INSERT INTO `sub_operation_history` VALUES (399, 1, 1, '我是名字', 'update', '生产制程', '修改生产制程：名称：备料组', '{\"newData\":{\"id\":1,\"name\":\"备料组\",\"sort\":\"4\"}}', '2025-11-01 14:27:16');

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
INSERT INTO `sub_outsourcing_quote` VALUES (6, 3, 12, 9, 3, 60, '77', '2', 1, 800, '人民币', '现金', NULL, '', 1, '2025-10-19 16:43:13', '2025-10-19 16:45:48');
INSERT INTO `sub_outsourcing_quote` VALUES (8, 1, 1, 8, 2, 57, '74', '2.5', 3, 15000, '2121', '313131', NULL, '', 1, '2025-10-23 13:42:18', '2025-10-23 13:42:18');
INSERT INTO `sub_outsourcing_quote` VALUES (9, 3, 6, 9, 3, 60, '78', '2.1', 2, 800, 'X', 'X', NULL, '', 1, '2025-10-24 11:44:48', '2025-10-24 11:44:48');

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
  `archive` int(11) NULL DEFAULT NULL COMMENT '是否已存档，1未存，0已存',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 66 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '工艺BOM表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_process_bom
-- ----------------------------
INSERT INTO `sub_process_bom` VALUES (56, 1, 1, NULL, NULL, 19, 8, 0, 1, '2025-09-24 15:58:17', '2025-10-31 00:13:27');
INSERT INTO `sub_process_bom` VALUES (57, 1, 1, NULL, NULL, 14, 12, 0, 1, '2025-09-25 14:50:12', '2025-10-31 00:13:17');
INSERT INTO `sub_process_bom` VALUES (58, 1, 1, NULL, NULL, 19, 7, 0, 1, '2025-09-25 14:51:50', '2025-10-31 00:12:49');
INSERT INTO `sub_process_bom` VALUES (59, 3, 6, NULL, NULL, 20, 21, 0, 1, '2025-10-19 15:45:17', '2025-10-30 19:21:18');
INSERT INTO `sub_process_bom` VALUES (60, 3, 6, NULL, NULL, 20, 27, 0, 1, '2025-10-19 15:49:23', '2025-10-30 20:00:52');
INSERT INTO `sub_process_bom` VALUES (61, 1, 1, NULL, NULL, 14, 8, 1, 1, '2025-10-21 21:32:41', '2025-10-21 21:35:24');
INSERT INTO `sub_process_bom` VALUES (62, 3, 6, NULL, NULL, 20, 21, 1, 0, '2025-10-29 09:46:29', '2025-10-30 19:10:28');
INSERT INTO `sub_process_bom` VALUES (63, 3, 6, NULL, NULL, 20, 34, 0, 1, '2025-10-30 20:02:25', '2025-10-30 20:13:35');
INSERT INTO `sub_process_bom` VALUES (64, 3, 6, NULL, NULL, 20, 33, 0, 1, '2025-10-30 20:16:04', '2025-10-30 21:18:46');
INSERT INTO `sub_process_bom` VALUES (65, 3, 6, NULL, NULL, 20, 25, 0, 1, '2025-10-30 20:31:48', '2025-10-30 20:36:48');

-- ----------------------------
-- Table structure for sub_process_bom_child
-- ----------------------------
DROP TABLE IF EXISTS `sub_process_bom_child`;
CREATE TABLE `sub_process_bom_child`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键ID',
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
) ENGINE = InnoDB AUTO_INCREMENT = 121 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '工艺BOM表子表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_process_bom_child
-- ----------------------------
INSERT INTO `sub_process_bom_child` VALUES (116, 1, '1122', 8, 58, 6, 4, 1, 5, 9.00, '1', 55000.0, NULL, NULL, 12500, NULL, '2025-10-31 00:12:49', '2025-11-02 00:05:35');
INSERT INTO `sub_process_bom_child` VALUES (117, 1, '1122', 8, 58, 5, 3, 2, 6, 7.00, '1', 66000.0, NULL, NULL, 12500, NULL, '2025-10-31 00:12:49', '2025-11-02 00:05:35');
INSERT INTO `sub_process_bom_child` VALUES (118, NULL, NULL, NULL, 57, 5, 5, 1, 2, 8.00, '1', NULL, NULL, NULL, NULL, NULL, '2025-10-31 00:13:17', '2025-10-31 00:13:17');
INSERT INTO `sub_process_bom_child` VALUES (119, NULL, NULL, NULL, 57, 6, 4, 2, 4, 3.00, '1', NULL, NULL, NULL, NULL, NULL, '2025-10-31 00:13:17', '2025-10-31 00:13:17');
INSERT INTO `sub_process_bom_child` VALUES (120, 1, '1122', 8, 56, 5, 3, 1, 3, 9.00, '1', 33000.0, NULL, NULL, 12600, NULL, '2025-10-31 00:13:27', '2025-11-02 00:05:49');

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
INSERT INTO `sub_process_cycle` VALUES (1, 1, 1, '备料组', '4', '1.5', 1, '2025-08-21 09:30:12', '2025-11-02 00:02:50');
INSERT INTO `sub_process_cycle` VALUES (2, 1, 1, '设备组', '7', '1.5', 1, '2025-08-21 09:30:39', '2025-10-31 10:32:44');
INSERT INTO `sub_process_cycle` VALUES (3, 1, 1, '生产组', '6', '2', 1, '2025-08-21 09:30:45', '2025-10-31 10:32:34');
INSERT INTO `sub_process_cycle` VALUES (4, 1, 1, '其他组', '3', '2', 1, '2025-10-16 19:09:55', '2025-10-31 10:31:37');
INSERT INTO `sub_process_cycle` VALUES (5, 1, 1, '不好组', '5', '1', 1, '2025-10-16 19:15:43', '2025-10-31 10:32:24');
INSERT INTO `sub_process_cycle` VALUES (6, 3, 6, '备料组', '1', '1', 1, '2025-10-18 10:10:27', '2025-10-28 13:40:09');
INSERT INTO `sub_process_cycle` VALUES (7, 3, 6, '焊接组', '2', '1', 1, '2025-10-18 10:10:44', '2025-10-28 13:40:18');
INSERT INTO `sub_process_cycle` VALUES (8, 3, 6, '热处理', '3', '1.5', 1, '2025-10-18 10:11:22', '2025-10-28 13:40:23');
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
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_process_cycle_child
-- ----------------------------
INSERT INTO `sub_process_cycle_child` VALUES (1, 1, 1, '2025-11-03', NULL, NULL, '2025-11-01 22:13:25', '2025-11-02 00:03:03');
INSERT INTO `sub_process_cycle_child` VALUES (2, 2, 1, NULL, NULL, NULL, '2025-11-01 22:13:25', '2025-11-01 22:13:25');
INSERT INTO `sub_process_cycle_child` VALUES (3, 3, 1, NULL, NULL, NULL, '2025-11-01 22:13:25', '2025-11-01 22:13:25');
INSERT INTO `sub_process_cycle_child` VALUES (4, 4, 1, NULL, NULL, NULL, '2025-11-01 22:13:25', '2025-11-01 22:13:25');
INSERT INTO `sub_process_cycle_child` VALUES (5, 5, 1, NULL, NULL, NULL, '2025-11-01 22:13:25', '2025-11-01 22:13:25');
INSERT INTO `sub_process_cycle_child` VALUES (6, 1, 2, '2025-11-03', NULL, NULL, '2025-11-01 22:13:25', '2025-11-02 00:03:03');
INSERT INTO `sub_process_cycle_child` VALUES (7, 2, 2, NULL, NULL, NULL, '2025-11-01 22:13:25', '2025-11-01 22:13:25');
INSERT INTO `sub_process_cycle_child` VALUES (8, 3, 2, NULL, NULL, NULL, '2025-11-01 22:13:25', '2025-11-01 22:13:25');
INSERT INTO `sub_process_cycle_child` VALUES (9, 4, 2, NULL, NULL, NULL, '2025-11-01 22:13:25', '2025-11-01 22:13:25');
INSERT INTO `sub_process_cycle_child` VALUES (10, 5, 2, NULL, NULL, NULL, '2025-11-01 22:13:25', '2025-11-01 22:13:25');

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
INSERT INTO `sub_product_notice` VALUES (8, 1, 1, '1122', 2, 19, 2, '2025-11-20', 0, 1, 1, '2025-09-24 15:56:38', '2025-11-01 22:13:25');
INSERT INTO `sub_product_notice` VALUES (9, 3, 6, 'DD-A2510001', 4, 20, 3, '2025-11-30', 1, 1, 1, '2025-10-18 14:17:30', '2025-10-31 00:09:59');
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
  `sale_id` int(11) NULL DEFAULT NULL COMMENT '销售id',
  `part_id` int(11) NULL DEFAULT NULL COMMENT '部件id',
  `bom_id` int(11) NULL DEFAULT NULL COMMENT 'bom表的id',
  `out_number` int(20) NULL DEFAULT NULL COMMENT '生产数量',
  `house_number` int(11) NULL DEFAULT NULL COMMENT '委外/库存数量',
  `start_date` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '预计起始生产时间',
  `remarks` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '生产特别要求',
  `is_finish` int(11) NULL DEFAULT 1 COMMENT '生产订单是否已完结：1 - 未完结，0 - 已完结',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '生产进度表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_production_progress
-- ----------------------------
INSERT INTO `sub_production_progress` VALUES (1, 1, 1, 8, 19, 2, 7, 58, 12500, 500, '2025-11-02', '', 1, 1, '2025-11-01 22:13:24', '2025-11-02 00:05:35');
INSERT INTO `sub_production_progress` VALUES (2, 1, 1, 8, 19, 2, 8, 56, 12600, 400, '2025-11-02', '', 1, 1, '2025-11-01 22:13:24', '2025-11-02 00:05:49');

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
-- Table structure for sub_sales_order
-- ----------------------------
DROP TABLE IF EXISTS `sub_sales_order`;
CREATE TABLE `sub_sales_order`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键ID',
  `company_id` int(11) NOT NULL COMMENT '企业id',
  `user_id` int(11) NOT NULL COMMENT '发布的用户id',
  `rece_time` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '接单日期',
  `customer_id` int(11) NOT NULL COMMENT '客户id',
  `customer_order` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '客户订单号',
  `product_id` int(11) NOT NULL COMMENT '产品编码id',
  `product_req` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '产品要求',
  `order_number` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单数量',
  `actual_number` int(11) NULL DEFAULT NULL COMMENT '实际数量，给采购单使用的',
  `unit` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '单位',
  `delivery_time` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '交货日期',
  `goods_time` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '送货日期',
  `goods_address` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '送货地点',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '销售订单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_sales_order
-- ----------------------------
INSERT INTO `sub_sales_order` VALUES (1, 1, 1, '2025-07-07', 3, 'G2222222', 10, '我的要求', '18000', 313, '个', '2025-07-07', '2025-07-27', '大朗镇', 1, '2025-07-14 13:55:51', '2025-09-03 09:43:29');
INSERT INTO `sub_sales_order` VALUES (2, 1, 1, '2025-07-10', 2, 'hui11111111', 19, '无要求', '13000', 2121, '件', '2025-11-05', '2025-07-06', '寮步镇', 1, '2025-07-14 18:47:31', '2025-10-31 00:21:53');
INSERT INTO `sub_sales_order` VALUES (3, 3, 6, '2025-10-10', 4, 'CG01-2510009', 20, '1.按照自25100001打字码；2.补土后直接送货', '8000', 800, '台', '2025-11-30', '2025-11-30', '公司厂区', 1, '2025-10-18 11:17:11', '2025-10-30 16:10:51');
INSERT INTO `sub_sales_order` VALUES (4, 3, 6, '2025-10-30', 5, 'CG02-2510018', 20, '1.字码自2511001起；2.车架补土后送烤漆', '7500', 7500, '台', '2025-12-12', '2025-12-12', '高埗镇合鑫喷漆厂', 1, '2025-10-30 16:04:11', '2025-10-30 16:22:00');

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
  `supply_method` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供货方式',
  `transaction_method` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '交易方式',
  `transaction_currency` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '交易币别',
  `other_transaction_terms` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '其它交易条件',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '供应商信息信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_supplier_info
-- ----------------------------
INSERT INTO `sub_supplier_info` VALUES (1, 1, 1, '123', '2121', '13', '15', '1515', '212', '5151', '15', '15151', '1515', '15', 1, '2025-07-10 00:03:15', '2025-07-10 00:03:15');
INSERT INTO `sub_supplier_info` VALUES (2, 1, 1, '1234', '151', '153333333', '1', '515', '155', '511', '515', '15', '1', '515', 1, '2025-07-10 00:03:27', '2025-07-10 00:03:37');
INSERT INTO `sub_supplier_info` VALUES (3, 12, 3, 'GA001', '俊宏达', '小张', '136123456678', '东莞市俊宏达铝业科技有限公司', '东莞市常平镇常黄路38号', '材料供应', '送货上门', '现金', '人民币', '月结90天', 1, '2025-10-19 16:27:11', '2025-10-19 16:30:08');
INSERT INTO `sub_supplier_info` VALUES (4, 6, 3, 'GA002', '城至', '吴总', '12345678901', '东莞市城至精密五金有限公司', '东莞市万江区尖沙咀', '委外加工', '送货上门', '现金', '人民币', '月结60天', 1, '2025-10-24 11:26:22', '2025-10-24 11:26:22');

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
