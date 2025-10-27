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

 Date: 28/10/2025 00:16:59
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
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '组织架构信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ad_organize
-- ----------------------------
INSERT INTO `ad_organize` VALUES (1, 1, 1, 0, '企业名称11', 4, 1, '2025-08-01 14:55:42', '2025-08-01 17:12:20');
INSERT INTO `ad_organize` VALUES (2, 1, 1, 1, '业务部', 1, 0, '2025-08-01 14:56:50', '2025-08-01 17:11:17');
INSERT INTO `ad_organize` VALUES (3, 1, 1, 0, '前端工程师', 4, 1, '2025-08-01 15:56:01', '2025-08-01 15:56:01');
INSERT INTO `ad_organize` VALUES (4, 1, 1, 1, '221', 5, 0, '2025-08-01 17:11:46', '2025-08-01 17:11:50');
INSERT INTO `ad_organize` VALUES (5, 1, 1, 1, '后端', 4, 1, '2025-09-26 16:02:14', '2025-09-26 16:02:14');

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
  `power` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '权限字符串',
  `type` int(1) NULL DEFAULT NULL COMMENT '账号类型：1-子管理员账号，2-普通子账号',
  `parent_id` int(11) NOT NULL COMMENT '上级的id',
  `status` int(1) NULL DEFAULT 1 COMMENT '账户状态：1-正常，0-禁用',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ad_user
-- ----------------------------
INSERT INTO `ad_user` VALUES (1, 1, 'admin1', '$2b$10$qJOWecY5nOd6ICarLgePce3XPyVtXXrp1dkbB9ZQvtydVrKLz8uGG', '我是名字', NULL, 1, 0, 1, 1, '2025-07-07 13:56:55', '2025-07-21 17:26:05');
INSERT INTO `ad_user` VALUES (2, 2, 'admin99', '$2b$10$Ukc2Byd6TFsl0u2p68J0leC7tVgwp4LDWr7s6YV0EWpc6xR3dZyMm', NULL, NULL, 1, 0, 1, 1, '2025-07-07 14:00:05', '2025-07-08 14:21:48');
INSERT INTO `ad_user` VALUES (3, 1, '2121', '$2b$10$EpPaXdgc4ugWWT1Qi.DFSeRoz9XyBa3N7mKkNGuXEBvmy.pe8HEWq', NULL, NULL, 1, 0, 1, 1, '2025-07-08 10:35:09', '2025-07-08 14:21:49');
INSERT INTO `ad_user` VALUES (4, 1, '121', '$2b$10$qJOWecY5nOd6ICarLgePce3XPyVtXXrp1dkbB9ZQvtydVrKLz8uGG', '2132', '[[\"基础资料\",\"ProductCode\"],[\"基础资料\",\"PartCode\"],[\"基础资料\",\"MaterialCode\"],[\"基础资料\",\"ProcessCode\"],[\"基础资料\",\"EquipmentCode\"],[\"基础资料\",\"EmployeeInfo\"],[\"订单管理\",\"CustomerInfo\"],[\"订单管理\",\"ProductQuote\"],[\"订单管理\",\"SalesOrder\"],[\"仓库管理\"],[\"仓库管理\",\"ProductHouse\"],[\"仓库管理\",\"MaterialHouse\"],[\"仓库管理\",\"WarehouseRate\"],[\"采购管理\"],[\"委外管理\"],[\"采购管理\",\"PurchaseOrder\"],[\"采购管理\",\"MaterialQuote\"],[\"采购管理\",\"SupplierInfo\"],[\"委外管理\",\"OutsourcingQuote\"],[\"委外管理\",\"OutsourcingOrder\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:add\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:print\"]]', 2, 1, 1, 1, '2025-07-08 14:10:45', '2025-09-23 16:45:29');
INSERT INTO `ad_user` VALUES (5, 1, 'admin2', '$2b$10$qJOWecY5nOd6ICarLgePce3XPyVtXXrp1dkbB9ZQvtydVrKLz8uGG', '哈哈', '[[\"系统管理\"],[\"系统管理\",\"OrganizeManagement\"],[\"系统管理\",\"ProcessCycle\"],[\"系统管理\",\"ProcessCycle\",\"ProcessCycle:edit\"],[\"系统管理\",\"WarehouseType\"],[\"基础资料\"],[\"基础资料\",\"MaterialCode\"],[\"基础资料\",\"PartCode\"],[\"基础资料\",\"ProductCode\"],[\"基础资料\",\"ProductCode\",\"ProductCode:add\"],[\"基础资料\",\"ProductCode\",\"ProductCode:edit\"],[\"基础资料\",\"PartCode\",\"PartCode:edit\"],[\"基础资料\",\"PartCode\",\"PartCode:delete\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:edit\"],[\"基础资料\",\"ProcessCode\"],[\"基础资料\",\"EquipmentCode\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:edit\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:add\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:delete\"],[\"基础资料\",\"EmployeeInfo\",\"EmployeeInfo:delete\"],[\"基础资料\",\"EmployeeInfo\",\"EmployeeInfo:edit\"],[\"基础资料\",\"EmployeeInfo\"],[\"订单管理\"],[\"订单管理\",\"CustomerInfo\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:add\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:edit\"],[\"订单管理\",\"SalesOrder\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:edit\"],[\"订单管理\",\"ProductQuote\"],[\"订单管理\",\"ProductQuote\",\"ProductQuote:add\"],[\"订单管理\",\"ProductNotice\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:edit\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:add\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:date\"],[\"产品信息\"],[\"产品信息\",\"MaterialBOM\"],[\"产品信息\",\"MaterialBOM\",\"MaterialBOM:add\"],[\"产品信息\",\"MaterialBOM\",\"MaterialBOM:edit\"],[\"产品信息\",\"MaterialBOM\",\"MaterialBOM:archive\"],[\"产品信息\",\"MaterialBOM\",\"MaterialBOM:newPage\"],[\"产品信息\",\"MaterialBOMArchive\"],[\"产品信息\",\"ProcessBOM\"],[\"产品信息\",\"ProcessBOM\",\"ProcessBOM:archive\"],[\"产品信息\",\"ProcessBOM\",\"ProcessBOM:newPage\"],[\"产品信息\",\"ProcessBOMArchive\"],[\"委外管理\"],[\"委外管理\",\"OutsourcingOrder\"],[\"委外管理\",\"OutsourcingQuote\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:add\"],[\"仓库管理\"],[\"仓库管理\",\"ProductHouse\"],[\"仓库管理\",\"MaterialHouse\"],[\"仓库管理\",\"WarehouseRate\"],[\"采购管理\"],[\"采购管理\",\"SupplierInfo\"],[\"采购管理\",\"MaterialQuote\"],[\"采购管理\",\"PurchaseOrder\"],[\"首页\"],[\"首页\",\"Home\"]]', 2, 1, 1, 1, '2025-07-08 14:20:13', '2025-10-14 14:41:54');
INSERT INTO `ad_user` VALUES (6, 3, 'xuqinghua', '$2b$10$MUd.2TTjcfV8u2o0DRY.5OPdroD0SgSZaLr/xKnpnXXB.VkcIz27C', '徐庆华', NULL, 1, 0, 1, 1, '2025-10-16 00:03:16', '2025-10-24 00:00:39');
INSERT INTO `ad_user` VALUES (7, 3, 'xufurong', '$2b$10$6nBULA3lrE67GJgCSHHd8Of9H24WkaXNSGRPpvadq7ZTOBSuqCoWG', '徐芙蓉', '[[\"基础资料\"],[\"基础资料\",\"ProductCode\"],[\"基础资料\",\"ProductCode\",\"ProductCode:add\"],[\"基础资料\",\"ProductCode\",\"ProductCode:edit\"],[\"基础资料\",\"PartCode\"],[\"基础资料\",\"PartCode\",\"PartCode:add\"],[\"基础资料\",\"PartCode\",\"PartCode:edit\"],[\"基础资料\",\"MaterialCode\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:add\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:edit\"],[\"订单管理\"],[\"订单管理\",\"CustomerInfo\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:add\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:edit\"]]', 2, 6, 0, 0, '2025-10-16 14:45:16', '2025-10-16 14:50:42');
INSERT INTO `ad_user` VALUES (8, 1, '1231', '$2b$10$SNysIqFfTVzbYdYilDmMwOt0zF0O5rkfXbZETcW/4.4Gc.8dIN.uK', '2121', '[[\"产品信息\"],[\"产品信息\",\"ProcessBOMArchive\"],[\"产品信息\",\"ProcessBOM\"],[\"产品信息\",\"MaterialBOMArchive\"],[\"产品信息\",\"MaterialBOM\"]]', 2, 1, 1, 1, '2025-10-16 14:48:37', '2025-10-16 14:48:45');
INSERT INTO `ad_user` VALUES (9, 1, '312121', '$2b$10$d5SvhAYPngTVFoyT0RZzYOrgX.9QzeCxcddQ2wUMnsE6Kl14rRdHW', '21213131', '[[\"采购管理\"],[\"采购管理\",\"MaterialQuote\"],[\"采购管理\",\"PurchaseOrder\"]]', 2, 1, 0, 1, '2025-10-16 14:48:59', '2025-10-21 12:45:08');
INSERT INTO `ad_user` VALUES (10, 3, 'liang', '$2b$10$zkLfaAwf0gbLrsGcXv.fjebNp4OllOlRfQkpsoP3X8eb1ci6H3HDW', '梁伟锋', '[[\"系统管理\"],[\"基础资料\"],[\"基础资料\",\"PartCode\"],[\"基础资料\",\"MaterialCode\"],[\"系统管理\",\"OrganizeManagement\"]]', 2, 6, 1, 0, '2025-10-16 14:49:57', '2025-10-16 14:50:40');
INSERT INTO `ad_user` VALUES (11, 3, 'lupeisen', '$2b$10$AfLUeYHX4zV7k9IQRtFXr.mtSMVEfsEopPbPHWPFrpBn3ta4j4uVy', 'lupeisen', '[[\"系统管理\"],[\"系统管理\",\"OrganizeManagement\"],[\"系统管理\",\"ProcessCycle\"]]', 2, 6, 0, 0, '2025-10-16 14:50:25', '2025-10-16 14:50:38');
INSERT INTO `ad_user` VALUES (12, 3, 'xuchudong', '$2b$10$X8j4FSLo4roCW3ZRFz529e.uK5va/4lmhZ2MnGeyFFhFtP/gPbbrG', '徐楚东', '[[\"基础资料\",\"ProductCode\",\"ProductCode:add\"],[\"基础资料\",\"ProductCode\",\"ProductCode:edit\"],[\"系统管理\",\"ProcessCycle\",\"ProcessCycle:add\"],[\"系统管理\",\"ProcessCycle\",\"ProcessCycle:edit\"],[\"系统管理\",\"WarehouseType\",\"Warehouse:add\"],[\"系统管理\",\"WarehouseType\",\"Warehouse:edit\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:add\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:edit\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:delete\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:add\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:edit\"],[\"订单管理\",\"ProductQuote\",\"ProductQuote:add\"],[\"订单管理\",\"ProductQuote\",\"ProductQuote:edit\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:add\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:edit\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:date\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:finish\"],[\"订单管理\",\"FinishNotice\"],[\"委外管理\",\"OutsourcingQuote\",\"OutsourcingQuote:add\"],[\"委外管理\",\"OutsourcingQuote\",\"OutsourcingQuote:edit\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:add\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:edit\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:set\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:print\"],[\"生产管理\",\"ProductionProgress\"],[\"生产管理\",\"WorkOrder\",\"WorkOrder:print\"],[\"仓库管理\",\"WarehouseRate\",\"WarehouseRate:edit\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:addIn\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:addOut\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:set\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:print\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:addIn\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:addOut\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:set\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:print\"],[\"财务管理\",\"EmployeePieceRate\"],[\"财务管理\",\"AccountsReceivable\"],[\"财务管理\",\"AccountsPayable\"],[\"财务管理\",\"AccountsOutsourcing\"],[\"系统管理\",\"OrganizeManagement\"],[\"基础资料\",\"PartCode\",\"PartCode:add\"],[\"基础资料\",\"PartCode\",\"PartCode:edit\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:add\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:edit\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:add\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:edit\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:add\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:edit\"],[\"基础资料\",\"EmployeeInfo\",\"EmployeeInfo:add\"],[\"基础资料\",\"EmployeeInfo\",\"EmployeeInfo:edit\"],[\"采购管理\",\"SupplierInfo\",\"SupplierInfo:add\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:add\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:edit\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:archive\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:newPage\"],[\"产品工程\",\"MaterialBOMArchive\",\"MaterialBOM:cope\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:add\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:edit\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:archive\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:newPage\"],[\"产品工程\",\"ProcessBOMArchive\",\"ProcessBOM:cope\"],[\"系统管理\",\"UserManagement\",\"user:add\"],[\"系统管理\",\"UserManagement\",\"user:edit\"],[\"系统管理\",\"UserManagement\",\"user:delete\"],[\"基础资料\",\"ProductCode\",\"ProductCode:delete\"],[\"基础资料\",\"PartCode\",\"PartCode:delete\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:delete\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:delete\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:delete\"],[\"基础资料\",\"EmployeeInfo\",\"EmployeeInfo:delete\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:delete\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:delete\"],[\"采购管理\",\"SupplierInfo\",\"SupplierInfo:edit\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:add\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:archive\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:newPage\"],[\"采购管理\",\"MaterialQuoteArchive\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:add\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:edit\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:set\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:print\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:edit\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:edit\"]]', 2, 6, 1, 1, '2025-10-16 14:55:08', '2025-10-27 20:19:54');
INSERT INTO `ad_user` VALUES (15, 3, 'xuyun', '$2b$10$RD1Ptk4dH57P2TQmYmCIQ.sMPfEj82Xu0xWLqd2XvQxmnDyzgOwdW', '粟云', '[[\"系统管理\",\"ProcessCycle\",\"ProcessCycle:add\"],[\"系统管理\",\"ProcessCycle\",\"ProcessCycle:edit\"],[\"系统管理\",\"WarehouseType\",\"Warehouse:add\"],[\"系统管理\",\"WarehouseType\",\"Warehouse:edit\"],[\"基础资料\",\"ProductCode\",\"ProductCode:add\"],[\"基础资料\",\"ProductCode\",\"ProductCode:edit\"],[\"基础资料\",\"ProductCode\",\"ProductCode:delete\"],[\"基础资料\",\"PartCode\",\"PartCode:add\"],[\"基础资料\",\"PartCode\",\"PartCode:edit\"],[\"基础资料\",\"PartCode\",\"PartCode:delete\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:add\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:edit\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:delete\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:add\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:edit\"],[\"基础资料\",\"ProcessCode\",\"ProcessCode:delete\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:add\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:edit\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:delete\"],[\"基础资料\",\"EmployeeInfo\",\"EmployeeInfo:add\"],[\"基础资料\",\"EmployeeInfo\",\"EmployeeInfo:edit\"],[\"基础资料\",\"EmployeeInfo\",\"EmployeeInfo:delete\"],[\"系统管理\",\"UserManagement\",\"user:add\"],[\"系统管理\",\"UserManagement\",\"user:edit\"],[\"系统管理\",\"UserManagement\",\"user:delete\"],[\"系统管理\",\"OrganizeManagement\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:add\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:edit\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:delete\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:add\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:edit\"],[\"订单管理\",\"ProductQuote\",\"ProductQuote:add\"],[\"订单管理\",\"ProductQuote\",\"ProductQuote:edit\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:add\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:edit\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:date\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:finish\"],[\"订单管理\",\"FinishNotice\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:add\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:edit\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:delete\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:archive\"],[\"产品工程\",\"MaterialBOM\",\"MaterialBOM:newPage\"],[\"产品工程\",\"MaterialBOMArchive\",\"MaterialBOM:cope\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:add\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:edit\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:delete\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:archive\"],[\"产品工程\",\"ProcessBOM\",\"ProcessBOM:newPage\"],[\"产品工程\",\"ProcessBOMArchive\",\"ProcessBOM:cope\"],[\"采购管理\",\"SupplierInfo\",\"SupplierInfo:add\"],[\"采购管理\",\"SupplierInfo\",\"SupplierInfo:edit\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:add\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:archive\"],[\"采购管理\",\"MaterialQuote\",\"MaterialQuote:newPage\"],[\"采购管理\",\"MaterialQuoteArchive\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:add\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:edit\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:set\"],[\"采购管理\",\"PurchaseOrder\",\"PurchaseOrder:print\"],[\"委外管理\",\"OutsourcingQuote\",\"OutsourcingQuote:add\"],[\"委外管理\",\"OutsourcingQuote\",\"OutsourcingQuote:edit\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:add\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:edit\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:set\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:print\"],[\"生产管理\",\"ProductionProgress\"],[\"生产管理\",\"WorkOrder\",\"WorkOrder:print\"],[\"仓库管理\",\"WarehouseRate\",\"WarehouseRate:edit\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:addIn\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:addOut\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:edit\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:set\"],[\"仓库管理\",\"MaterialHouse\",\"MaterialHouse:print\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:addIn\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:addOut\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:edit\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:set\"],[\"仓库管理\",\"ProductHouse\",\"ProductHouse:print\"],[\"财务管理\",\"EmployeePieceRate\"],[\"财务管理\",\"AccountsReceivable\"],[\"财务管理\",\"AccountsPayable\"],[\"财务管理\",\"AccountsOutsourcing\"]]', 2, 6, 1, 1, '2025-10-19 16:00:54', '2025-10-27 20:18:05');

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
) ENGINE = InnoDB AUTO_INCREMENT = 97 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '流程控制用户表' ROW_FORMAT = DYNAMIC;

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
INSERT INTO `sub_approval_user` VALUES (95, 1, 'purchase_order', 5, 5, '哈哈', NULL, 1, 0, '2025-10-27 23:37:51', '2025-10-27 23:37:51');
INSERT INTO `sub_approval_user` VALUES (96, 1, 'purchase_order', 5, 4, '2132', NULL, 2, 0, '2025-10-27 23:37:51', '2025-10-27 23:37:51');

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
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '客户信息基础信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_customer_info
-- ----------------------------
INSERT INTO `sub_customer_info` VALUES (1, 1, 1, '123223', '石龙佳洁士', '1', '1', '1', '1', '1', '1', 22, '1', '1', 1, '2025-07-08 19:29:21', '2025-10-22 13:14:26');
INSERT INTO `sub_customer_info` VALUES (2, 1, 1, '1234', '惠州饮料厂', '212', '121', '21', '121', '2121', '21', 21, '2121', '2121', 1, '2025-07-09 00:58:19', '2025-10-22 13:18:16');
INSERT INTO `sub_customer_info` VALUES (3, 1, 1, '12311', '东莞鞋厂', '12', '1', '15', '155', '15', '15', 23, '55', '11', 1, '2025-07-09 15:04:51', '2025-10-22 13:18:08');
INSERT INTO `sub_customer_info` VALUES (4, 6, 3, 'KA001', '俊宏达', '小吴', '13812345678', '东莞市俊宏达铝业科技有限公司', '东莞市常平镇常黄路38号', '公司厂区', '12345678', 21, '人民币', '月结60天', 1, '2025-10-18 11:09:32', '2025-10-22 13:14:32');

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
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '员工信息基础信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_employee_info
-- ----------------------------
INSERT INTO `sub_employee_info` VALUES (1, 1, 1, '1', '1', NULL, NULL, 3, '1', 17, '1', 1, '2025-07-08 16:39:58', '2025-10-22 13:10:15');
INSERT INTO `sub_employee_info` VALUES (2, 1, 1, '2', '2', 'base2', '$2b$10$mHXkEoWarhWYGisAwOnZ9Oghb6wEcnG0NOH8WdevQwS7HKLlET/Ja', 2, '23', 18, '3', 1, '2025-07-08 16:40:09', '2025-10-22 13:10:16');
INSERT INTO `sub_employee_info` VALUES (3, 1, 1, '21', '2121', 'base1', '$2b$10$K0JSC.MSvQbD6mkRHjvjC.gpS4XvjatLgIf/yw0wjSs.N3FHt9aCe', 2, '21', 19, '211', 1, '2025-10-01 14:42:30', '2025-10-22 13:11:01');
INSERT INTO `sub_employee_info` VALUES (4, 1, 1, '22', '5445', 'base3', '$2b$10$7DtT7oDcCGxZaLYfiJTPd.mywJj.yYGwC7di.3HLUfD.JBtP3wv0y', 2, '2121', 20, '21', 1, '2025-10-01 15:05:57', '2025-10-22 13:10:19');
INSERT INTO `sub_employee_info` VALUES (5, 6, 3, 'SC0001', '张三', 'SC0001', '$2b$10$piyXeFkMk25JPqIZbVMH/e1VJvAeN2BwGsnmDXn0STxgXg0GXeKo6', 6, '冲压工', 17, NULL, 1, '2025-10-18 10:54:01', '2025-10-22 13:10:21');
INSERT INTO `sub_employee_info` VALUES (6, 6, 3, 'GL0002', '李四', 'GL0002', '$2b$10$vqlF5BJP4DLhCjIc3rIS8.7j02OmX7NWxUQYBjScbdnUiZ49rT63C', 6, '备料组主管', 18, NULL, 1, '2025-10-18 11:00:50', '2025-10-22 13:10:23');

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
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '设备信息基础信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_equipment_code
-- ----------------------------
INSERT INTO `sub_equipment_code` VALUES (3, 1, 1, '123', '钻床', 12, 3, '7', 56, 8, '无', 1, '2025-07-08 16:06:29', '2025-10-22 11:39:46');
INSERT INTO `sub_equipment_code` VALUES (4, 1, 1, '122', '退火炉', 26, 1, '10', 40, 4, '无', 1, '2025-08-09 16:06:56', '2025-10-27 20:32:23');
INSERT INTO `sub_equipment_code` VALUES (5, 1, 1, '124', '激光机', 5, 1, '8', 40, 5, '无', 1, '2025-08-29 09:33:14', '2025-10-22 11:39:35');
INSERT INTO `sub_equipment_code` VALUES (6, 6, 3, 'JX01', '打字机', 2, 6, '10', 20, 2, '', 1, '2025-10-18 10:17:12', '2025-10-23 23:47:35');
INSERT INTO `sub_equipment_code` VALUES (7, 6, 3, 'JX02', '16T冲床', 8, 6, '10', 80, 8, '', 1, '2025-10-18 10:21:33', '2025-10-23 23:51:20');
INSERT INTO `sub_equipment_code` VALUES (8, 6, 3, 'JX03', '钻床-A', 5, 6, '10', 50, 5, '', 1, '2025-10-18 10:24:42', '2025-10-23 23:51:15');
INSERT INTO `sub_equipment_code` VALUES (9, 6, 3, 'JX04', '手动研磨机', 4, 9, '10', 30, 3, '1台维修中', 1, '2025-10-18 10:38:09', '2025-10-18 10:38:09');

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
) ENGINE = InnoDB AUTO_INCREMENT = 26 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '材料BOM表' ROW_FORMAT = DYNAMIC;

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
INSERT INTO `sub_material_bom` VALUES (23, 3, 6, 20, 21, 1, 1, '2025-10-18 14:30:01', '2025-10-19 15:37:50');
INSERT INTO `sub_material_bom` VALUES (24, 3, 12, 20, 22, 1, 1, '2025-10-18 15:08:30', '2025-10-18 15:08:30');
INSERT INTO `sub_material_bom` VALUES (25, 1, 1, 15, 8, 1, 1, '2025-10-21 21:04:49', '2025-10-21 21:23:26');

-- ----------------------------
-- Table structure for sub_material_bom_child
-- ----------------------------
DROP TABLE IF EXISTS `sub_material_bom_child`;
CREATE TABLE `sub_material_bom_child`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键ID',
  `material_bom_id` int(11) NOT NULL COMMENT '材料BOM的父表id',
  `material_id` int(11) NOT NULL COMMENT '材料编码ID，关联材料编码表',
  `number` int(20) NULL DEFAULT NULL COMMENT '数量',
  `is_buy` int(11) NULL DEFAULT 0 COMMENT '是否已采购，0未采购1已采购',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 39 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '材料BOM表子表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_material_bom_child
-- ----------------------------
INSERT INTO `sub_material_bom_child` VALUES (6, 12, 2, 12, 0, '2025-08-13 10:38:41', '2025-08-13 10:38:41');
INSERT INTO `sub_material_bom_child` VALUES (7, 12, 2, 22, 0, '2025-08-13 10:38:41', '2025-08-13 10:38:41');
INSERT INTO `sub_material_bom_child` VALUES (8, 12, 2, 24, 0, '2025-08-13 10:38:41', '2025-08-13 10:38:41');
INSERT INTO `sub_material_bom_child` VALUES (9, 11, 2, 23, 0, '2025-08-13 10:59:47', '2025-08-13 10:59:47');
INSERT INTO `sub_material_bom_child` VALUES (10, 11, 2, 34, 0, '2025-08-13 10:59:47', '2025-08-13 10:59:47');
INSERT INTO `sub_material_bom_child` VALUES (11, 10, 2, 12, 0, '2025-08-13 10:59:52', '2025-08-13 10:59:52');
INSERT INTO `sub_material_bom_child` VALUES (12, 13, 3, 12, 0, '2025-08-13 14:41:35', '2025-08-17 09:48:42');
INSERT INTO `sub_material_bom_child` VALUES (13, 14, 2, 12, 0, '2025-08-13 14:41:55', '2025-08-13 14:41:55');
INSERT INTO `sub_material_bom_child` VALUES (14, 14, 2, 22, 0, '2025-08-13 14:41:55', '2025-08-13 14:41:55');
INSERT INTO `sub_material_bom_child` VALUES (15, 14, 3, 24, 0, '2025-08-13 14:41:55', '2025-08-17 09:38:34');
INSERT INTO `sub_material_bom_child` VALUES (16, 15, 2, 23, 0, '2025-08-13 14:42:03', '2025-08-13 14:42:03');
INSERT INTO `sub_material_bom_child` VALUES (17, 15, 2, 34, 0, '2025-08-13 14:42:03', '2025-08-13 14:42:03');
INSERT INTO `sub_material_bom_child` VALUES (18, 16, 3, 12, 0, '2025-08-21 09:35:05', '2025-08-21 09:35:05');
INSERT INTO `sub_material_bom_child` VALUES (19, 17, 2, 600, 0, '2025-09-25 14:38:28', '2025-09-25 14:38:28');
INSERT INTO `sub_material_bom_child` VALUES (20, 17, 3, 400, 0, '2025-09-25 14:38:28', '2025-09-25 14:38:28');
INSERT INTO `sub_material_bom_child` VALUES (21, 18, 3, 900, 0, '2025-09-25 14:39:31', '2025-09-25 14:39:31');
INSERT INTO `sub_material_bom_child` VALUES (22, 19, 2, 600, 0, '2025-09-25 14:39:45', '2025-09-25 14:39:45');
INSERT INTO `sub_material_bom_child` VALUES (23, 19, 3, 700, 0, '2025-09-25 14:39:45', '2025-09-25 14:39:45');
INSERT INTO `sub_material_bom_child` VALUES (24, 20, 2, 198, 0, '2025-09-25 14:44:26', '2025-09-25 14:44:26');
INSERT INTO `sub_material_bom_child` VALUES (25, 20, 2, 158, 0, '2025-09-25 14:44:26', '2025-09-25 14:44:26');
INSERT INTO `sub_material_bom_child` VALUES (26, 21, 2, 485, 0, '2025-09-25 14:44:36', '2025-09-25 14:44:36');
INSERT INTO `sub_material_bom_child` VALUES (27, 22, 4, 5, 0, '2025-10-18 14:29:06', '2025-10-18 14:29:06');
INSERT INTO `sub_material_bom_child` VALUES (28, 23, 5, 1, 0, '2025-10-18 14:30:01', '2025-10-18 14:30:01');
INSERT INTO `sub_material_bom_child` VALUES (29, 24, 6, 2, 0, '2025-10-18 15:08:30', '2025-10-18 15:08:30');
INSERT INTO `sub_material_bom_child` VALUES (30, 24, 4, 5, 0, '2025-10-18 15:08:30', '2025-10-18 15:08:30');
INSERT INTO `sub_material_bom_child` VALUES (31, 23, 4, 3, 0, '2025-10-19 15:37:50', '2025-10-19 15:37:50');
INSERT INTO `sub_material_bom_child` VALUES (34, 25, 3, 30, 0, '2025-10-21 21:04:49', '2025-10-21 21:04:49');
INSERT INTO `sub_material_bom_child` VALUES (36, 25, 2, 60, 0, '2025-10-21 21:04:49', '2025-10-21 21:04:49');
INSERT INTO `sub_material_bom_child` VALUES (37, 25, 3, 40, 0, '2025-10-21 21:23:26', '2025-10-21 21:23:26');
INSERT INTO `sub_material_bom_child` VALUES (38, 25, 2, 50, 0, '2025-10-21 21:23:26', '2025-10-21 21:23:26');

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
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '材料编码基础信息表' ROW_FORMAT = DYNAMIC;

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
INSERT INTO `sub_material_code` VALUES (12, 6, 3, 'H0703-0001', '油压线扣', '/YD007-004', '/YD007-004', '', '个', '盒（100个）', '', 1, '2025-10-27 16:29:45', '2025-10-27 16:29:45');

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
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '材料采购单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_material_ment
-- ----------------------------
INSERT INTO `sub_material_ment` VALUES (3, 1, 1, NULL, NULL, 15, 6, '2222', 2, '1234', '151', '10', '1233', '212', 3, '789', '555', '535/35353', '353', '353', '2.5', '18000', '18000', '2025-07-07', 1, '我是名字', '2025-09-23 14:54:56', 1, 1, 1, '2025-09-23 14:54:56', '2025-10-24 12:59:26');
INSERT INTO `sub_material_ment` VALUES (4, 1, 1, NULL, NULL, 15, 8, '1122', 2, '1234', '151', '19', 'A001', '圆珠笔', 2, '123', '121', '2121/21', '2121', '21', '2.6', '15000', '15000', '2025-10-31', 1, '我是名字', '2025-09-26 14:03:04', 1, 1, 1, '2025-09-26 14:03:04', '2025-10-24 12:59:29');
INSERT INTO `sub_material_ment` VALUES (5, 1, 1, 1, '11', NULL, 8, '1122', 2, '1234', '151', '19', 'A001', '圆珠笔', 2, '123', '121', '2121/21', '2121', '个2', '24', '', '15000', '2025-10-15', 1, '我是名字', '2025-10-27 23:37:51', 0, 0, 1, '2025-10-27 23:37:51', '2025-10-27 23:37:51');

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
) ENGINE = InnoDB AUTO_INCREMENT = 82 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户操作日志表' ROW_FORMAT = DYNAMIC;

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
INSERT INTO `sub_operation_history` VALUES (77, 1, 1, '我是名字', 'update', '产品编码', '修改产品编码：123', '{\"newData\":{\"id\":9,\"company_id\":1,\"user_id\":1,\"product_code\":\"123\",\"product_name\":\"113\",\"drawing\":\"图只可以\",\"model\":\"21\",\"specification\":\"2131\",\"other_features\":\"3131\",\"component_structure\":\"1313\",\"unit\":\"212\",\"production_requirements\":\"21\",\"is_deleted\":1,\"created_at\":\"2025-07-08\",\"updated_at\":\"2025-07-14\"}}', '2025-10-27 12:27:23');
INSERT INTO `sub_operation_history` VALUES (78, 1, 1, '我是名字', 'update', '设备编码', '修改设备编码：122', '{\"newData\":{\"id\":4,\"company_id\":1,\"user_id\":1,\"equipment_code\":\"122\",\"equipment_name\":\"退火炉\",\"quantity\":22,\"cycle_id\":1,\"working_hours\":\"10\",\"efficiency\":40,\"available\":4,\"remarks\":\"无\",\"is_deleted\":1,\"created_at\":\"2025-08-09\",\"updated_at\":\"2025-10-22\",\"cycle\":{\"id\":1,\"company_id\":1,\"user_id\":1,\"name\":\"备料组\",\"sort\":\"0\",\"sort_date\":\"4\",\"is_deleted\":1,\"created_at\":\"2025-08-21T01:30:12.000Z\",\"updated_at\":\"2025-10-26T10:10:51.000Z\"}}}', '2025-10-27 12:32:14');
INSERT INTO `sub_operation_history` VALUES (79, 1, 1, '我是名字', 'update', '设备编码', '修改设备编码：122', '{\"newData\":{\"id\":4,\"company_id\":1,\"user_id\":1,\"equipment_code\":\"122\",\"equipment_name\":\"退火炉\",\"quantity\":22,\"cycle_id\":1,\"working_hours\":\"10\",\"efficiency\":40,\"available\":4,\"remarks\":\"无\",\"is_deleted\":1,\"created_at\":\"2025-08-09\",\"updated_at\":\"2025-10-22\",\"cycle\":{\"id\":1,\"company_id\":1,\"user_id\":1,\"name\":\"备料组\",\"sort\":\"0\",\"sort_date\":\"4\",\"is_deleted\":1,\"created_at\":\"2025-08-21T01:30:12.000Z\",\"updated_at\":\"2025-10-26T10:10:51.000Z\"}}}', '2025-10-27 12:32:16');
INSERT INTO `sub_operation_history` VALUES (80, 1, 1, '我是名字', 'update', '设备编码', '修改设备编码：122', '{\"newData\":{\"id\":4,\"company_id\":1,\"user_id\":1,\"equipment_code\":\"122\",\"equipment_name\":\"退火炉\",\"quantity\":\"26\",\"cycle_id\":1,\"working_hours\":\"10\",\"efficiency\":40,\"available\":4,\"remarks\":\"无\",\"is_deleted\":1,\"created_at\":\"2025-08-09\",\"updated_at\":\"2025-10-22\",\"cycle\":{\"id\":1,\"company_id\":1,\"user_id\":1,\"name\":\"备料组\",\"sort\":\"0\",\"sort_date\":\"4\",\"is_deleted\":1,\"created_at\":\"2025-08-21T01:30:12.000Z\",\"updated_at\":\"2025-10-26T10:10:51.000Z\"}}}', '2025-10-27 12:32:23');
INSERT INTO `sub_operation_history` VALUES (81, 1, 1, '我是名字', 'keyApproval', '采购单', '采购单提交审核：{ 供应商编码：1234，生产订单号：1122，产品编码：A001，材料编码：123 }', '{\"newData\":{\"data\":[{\"quote_id\":1,\"material_bom_id\":11,\"notice_id\":8,\"notice\":\"1122\",\"supplier_id\":2,\"supplier_code\":\"1234\",\"supplier_abbreviation\":\"151\",\"product_id\":19,\"product_code\":\"A001\",\"product_name\":\"圆珠笔\",\"material_id\":2,\"material_code\":\"123\",\"material_name\":\"121\",\"model_spec\":\"2121/21\",\"other_features\":\"2121\",\"unit\":\"个2\",\"price\":24,\"order_number\":\"\",\"number\":\"15000\",\"delivery_time\":\"2025-10-15\"}],\"type\":\"purchase_order\"}}', '2025-10-27 15:37:51');

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
INSERT INTO `sub_outsourcing_order` VALUES (11, 1, 1, 16, 8, 1, 58, 75, '￥', 3, 600, '无1', '无2', '无', '2025-09-30', '无', 1, 1, '我是名字', '2025-09-26 21:29:06', 0, 1, '2025-09-26 14:40:30', '2025-10-24 13:05:23');
INSERT INTO `sub_outsourcing_order` VALUES (12, 1, 1, 16, 8, 1, 57, 74, '21', 21, 21, '121', '2121', '212', '2025-09-25', '2121', 1, 1, '我是名字', '2025-09-26 21:29:06', 0, 1, '2025-09-26 21:29:06', '2025-10-24 13:05:26');

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
INSERT INTO `sub_part_code` VALUES (27, 6, 3, 'X007', '吴桐', '', '', '', 'PCS', '', '', 1, '2025-10-27 15:06:48', '2025-10-27 15:06:48');
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
) ENGINE = InnoDB AUTO_INCREMENT = 62 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '工艺BOM表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_process_bom
-- ----------------------------
INSERT INTO `sub_process_bom` VALUES (56, 1, 1, NULL, NULL, 19, 8, 0, 1, '2025-09-24 15:58:17', '2025-09-24 16:03:21');
INSERT INTO `sub_process_bom` VALUES (57, 1, 1, NULL, NULL, 14, 12, 0, 1, '2025-09-25 14:50:12', '2025-09-25 14:51:59');
INSERT INTO `sub_process_bom` VALUES (58, 1, 1, NULL, NULL, 14, 8, 0, 1, '2025-09-25 14:51:50', '2025-09-25 14:51:59');
INSERT INTO `sub_process_bom` VALUES (59, 3, 6, NULL, NULL, 20, 21, 0, 1, '2025-10-19 15:45:17', '2025-10-27 09:18:16');
INSERT INTO `sub_process_bom` VALUES (60, 3, 6, NULL, NULL, 20, 22, 0, 1, '2025-10-19 15:49:23', '2025-10-19 16:42:00');
INSERT INTO `sub_process_bom` VALUES (61, 1, 1, NULL, NULL, 14, 8, 1, 1, '2025-10-21 21:32:41', '2025-10-21 21:35:24');

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
  `price` int(11) NULL DEFAULT NULL COMMENT '加工单价',
  `points` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '段数点数',
  `all_time` decimal(11, 1) NULL DEFAULT NULL COMMENT '全部工时-H',
  `all_load` decimal(11, 1) NULL DEFAULT NULL COMMENT '每日负荷-H',
  `add_finish` int(11) NULL DEFAULT NULL COMMENT '累计完成',
  `order_number` int(11) NULL DEFAULT NULL COMMENT '订单尾数',
  `qr_code` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '二维码',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 87 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '工艺BOM表子表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_process_bom_child
-- ----------------------------
INSERT INTO `sub_process_bom_child` VALUES (71, NULL, NULL, NULL, 56, 5, 4, 1, 8, 2, NULL, 33.3, NULL, 50, 15000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/7e081466-1421-4fcb-ad52-2164378ceb55.png', '2025-09-24 15:58:17', '2025-10-07 15:08:28');
INSERT INTO `sub_process_bom_child` VALUES (72, NULL, NULL, NULL, 56, 6, 3, 2, 9, 2, NULL, 37.5, NULL, NULL, 15000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/363b2db6-40f9-4d98-b7aa-9dc97b33327a.png', '2025-09-24 15:58:17', '2025-09-24 16:03:50');
INSERT INTO `sub_process_bom_child` VALUES (73, NULL, NULL, NULL, 57, 5, 5, 1, 8, 2, NULL, NULL, NULL, NULL, NULL, 'http://cdn.yuanfangzixun.com.cn/qrcodes/478e261e-327e-41b5-ab9b-6e5840980e00.png', '2025-09-25 14:50:12', '2025-09-25 14:50:12');
INSERT INTO `sub_process_bom_child` VALUES (74, NULL, NULL, NULL, 57, 6, 5, 2, 6, 8, NULL, NULL, NULL, NULL, NULL, 'http://cdn.yuanfangzixun.com.cn/qrcodes/d48ac941-c764-49a3-9914-cc6cf9af32e6.png', '2025-09-25 14:50:12', '2025-09-25 14:50:12');
INSERT INTO `sub_process_bom_child` VALUES (75, NULL, NULL, NULL, 58, 5, 4, 1, 6, 8, NULL, NULL, NULL, NULL, NULL, 'http://cdn.yuanfangzixun.com.cn/qrcodes/dc9ac27b-7a9b-4f7f-8ce2-89094ae5ca61.png', '2025-09-25 14:51:50', '2025-09-25 14:51:50');
INSERT INTO `sub_process_bom_child` VALUES (76, NULL, NULL, NULL, 59, 7, 6, 1, 5, 7, '4.8', 1.1, NULL, NULL, 800, 'http://cdn.yuanfangzixun.com.cn/qrcodes/d30a25e5-227a-42a5-854b-a0306dc75c89.png', '2025-10-19 15:45:17', '2025-10-22 14:28:32');
INSERT INTO `sub_process_bom_child` VALUES (77, NULL, NULL, NULL, 60, 8, 7, 1, 3, 0, NULL, 0.7, NULL, NULL, 800, 'http://cdn.yuanfangzixun.com.cn/qrcodes/691c887e-3de0-4afe-8b32-4e121625955b.png', '2025-10-19 15:49:23', '2025-10-19 16:54:26');
INSERT INTO `sub_process_bom_child` VALUES (78, NULL, NULL, NULL, 60, 7, 6, 2, 4, 0, NULL, 0.9, NULL, NULL, 800, 'http://cdn.yuanfangzixun.com.cn/qrcodes/d8f387be-9b3e-45bf-9664-acb8efd1621e.png', '2025-10-19 15:49:23', '2025-10-19 16:54:26');
INSERT INTO `sub_process_bom_child` VALUES (79, NULL, NULL, NULL, 61, 5, 4, 4, 8, 8, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-21 21:32:41', '2025-10-21 21:35:24');
INSERT INTO `sub_process_bom_child` VALUES (80, NULL, NULL, NULL, 61, 6, 3, 1, 7, 7, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-21 21:34:41', '2025-10-21 21:35:04');
INSERT INTO `sub_process_bom_child` VALUES (81, NULL, NULL, NULL, 61, 5, 5, 2, 6, 6, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-21 21:34:41', '2025-10-21 21:35:04');
INSERT INTO `sub_process_bom_child` VALUES (83, NULL, NULL, NULL, 61, 5, 3, 3, 4, 4, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-21 21:34:41', '2025-10-21 21:35:24');
INSERT INTO `sub_process_bom_child` VALUES (85, NULL, NULL, NULL, 61, 5, 3, 5, 9, 9, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-21 21:35:24', '2025-10-21 21:35:24');
INSERT INTO `sub_process_bom_child` VALUES (86, NULL, NULL, NULL, 59, 8, 7, 2, 7, 7, '3.7', NULL, NULL, NULL, NULL, NULL, '2025-10-22 14:22:50', '2025-10-22 14:28:32');

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
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '工艺编码基础信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_process_code
-- ----------------------------
INSERT INTO `sub_process_code` VALUES (3, 1, 1, 3, '123', '212', '212', 0, '2025-07-08 15:56:54', '2025-09-24 15:45:55');
INSERT INTO `sub_process_code` VALUES (4, 1, 1, 4, '2222', '111', '3131', 0, '2025-08-09 16:07:09', '2025-09-24 15:45:54');
INSERT INTO `sub_process_code` VALUES (5, 1, 1, 5, 'T001', '钻床', '无', 1, '2025-09-24 15:48:02', '2025-09-24 15:52:18');
INSERT INTO `sub_process_code` VALUES (6, 1, 1, 4, 'T002', '打点', '', 1, '2025-09-24 15:53:42', '2025-09-24 15:53:42');
INSERT INTO `sub_process_code` VALUES (7, 6, 3, 6, 'PA001', '打字', '', 1, '2025-10-18 10:40:33', '2025-10-18 10:40:33');
INSERT INTO `sub_process_code` VALUES (8, 6, 3, 7, 'PA002', '冲孔', '', 1, '2025-10-19 15:48:05', '2025-10-19 15:48:05');

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
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '制程组列表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_process_cycle
-- ----------------------------
INSERT INTO `sub_process_cycle` VALUES (1, 1, 1, '备料组', '0', '4', 1, '2025-08-21 09:30:12', '2025-10-26 18:10:51');
INSERT INTO `sub_process_cycle` VALUES (2, 1, 1, '设备组', '0', '4', 1, '2025-08-21 09:30:39', '2025-10-26 18:10:52');
INSERT INTO `sub_process_cycle` VALUES (3, 1, 1, '生产组', '0', '5', 1, '2025-08-21 09:30:45', '2025-10-26 18:10:52');
INSERT INTO `sub_process_cycle` VALUES (4, 1, 1, '其他组', '0', NULL, 1, '2025-10-16 19:09:55', '2025-10-26 18:10:53');
INSERT INTO `sub_process_cycle` VALUES (5, 1, 1, '不好组', '0', NULL, 1, '2025-10-16 19:15:43', '2025-10-26 18:10:53');
INSERT INTO `sub_process_cycle` VALUES (6, 3, 6, 'A备料组', '0', '1', 1, '2025-10-18 10:10:27', '2025-10-26 18:10:54');
INSERT INTO `sub_process_cycle` VALUES (7, 3, 6, 'B焊接组', '0', '1', 1, '2025-10-18 10:10:44', '2025-10-26 18:10:54');
INSERT INTO `sub_process_cycle` VALUES (8, 3, 6, 'C热处理', '0', '1.5', 1, '2025-10-18 10:11:22', '2025-10-26 18:10:54');
INSERT INTO `sub_process_cycle` VALUES (9, 3, 6, 'E研磨组', '0', '5', 1, '2025-10-18 10:11:37', '2025-10-26 18:10:55');
INSERT INTO `sub_process_cycle` VALUES (10, 3, 6, 'F补土组', '0', '6', 1, '2025-10-18 10:11:55', '2025-10-26 18:10:55');
INSERT INTO `sub_process_cycle` VALUES (11, 3, 6, 'D后段组', '0', '8', 1, '2025-10-18 10:12:08', '2025-10-26 18:10:57');

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
) ENGINE = InnoDB AUTO_INCREMENT = 274 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_process_cycle_child
-- ----------------------------
INSERT INTO `sub_process_cycle_child` VALUES (259, 1, 227, '2025-10-31', NULL, NULL, '2025-10-13 11:37:22', '2025-10-15 10:41:33');
INSERT INTO `sub_process_cycle_child` VALUES (260, 2, 227, '2025-10-31', NULL, NULL, '2025-10-13 11:37:22', '2025-10-15 10:41:37');
INSERT INTO `sub_process_cycle_child` VALUES (261, 3, 227, '2025-10-31', NULL, NULL, '2025-10-13 11:37:22', '2025-10-15 10:41:43');
INSERT INTO `sub_process_cycle_child` VALUES (262, 6, 228, '2025-10-28', NULL, NULL, '2025-10-19 16:54:26', '2025-10-24 13:11:28');
INSERT INTO `sub_process_cycle_child` VALUES (263, 7, 228, '2025-10-29', NULL, NULL, '2025-10-19 16:54:26', '2025-10-19 16:58:06');
INSERT INTO `sub_process_cycle_child` VALUES (264, 8, 228, '2025-11-05', NULL, NULL, '2025-10-19 16:54:26', '2025-10-19 16:58:34');
INSERT INTO `sub_process_cycle_child` VALUES (265, 9, 228, '2025-11-08', NULL, NULL, '2025-10-19 16:54:26', '2025-10-19 16:58:50');
INSERT INTO `sub_process_cycle_child` VALUES (266, 10, 228, '2025-11-17', NULL, NULL, '2025-10-19 16:54:26', '2025-10-19 16:59:15');
INSERT INTO `sub_process_cycle_child` VALUES (267, 11, 228, '2025-10-28', NULL, NULL, '2025-10-19 16:54:26', '2025-10-19 16:59:33');
INSERT INTO `sub_process_cycle_child` VALUES (268, 6, 229, '2025-10-28', NULL, NULL, '2025-10-19 16:54:26', '2025-10-24 13:11:28');
INSERT INTO `sub_process_cycle_child` VALUES (269, 7, 229, '2025-10-28', NULL, NULL, '2025-10-19 16:54:26', '2025-10-19 16:57:56');
INSERT INTO `sub_process_cycle_child` VALUES (270, 8, 229, '2025-11-03', NULL, NULL, '2025-10-19 16:54:26', '2025-10-19 16:58:18');
INSERT INTO `sub_process_cycle_child` VALUES (271, 9, 229, '2025-11-08', NULL, NULL, '2025-10-19 16:54:26', '2025-10-19 16:58:50');
INSERT INTO `sub_process_cycle_child` VALUES (272, 10, 229, '2025-11-19', NULL, NULL, '2025-10-19 16:54:26', '2025-10-24 13:16:56');
INSERT INTO `sub_process_cycle_child` VALUES (273, 11, 229, '2025-10-28', NULL, NULL, '2025-10-19 16:54:26', '2025-10-19 16:59:33');

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
INSERT INTO `sub_product_code` VALUES (9, 1, 1, '123', '113', '图只可以', '21', '2131', '3131', '1313', '212', '21', 1, '2025-07-08 15:02:27', '2025-07-14 10:04:36');
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
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '生产通知单信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_product_notice
-- ----------------------------
INSERT INTO `sub_product_notice` VALUES (8, 1, 1, '1122', 2, 19, 2, '2025-10-15', 0, 1, 1, '2025-09-24 15:56:38', '2025-10-13 11:38:39');
INSERT INTO `sub_product_notice` VALUES (9, 3, 6, 'DD-A2510001', 4, 20, 3, '2025-11-30', 0, 1, 1, '2025-10-18 14:17:30', '2025-10-19 16:54:26');

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
) ENGINE = InnoDB AUTO_INCREMENT = 230 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '生产进度表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_production_progress
-- ----------------------------
INSERT INTO `sub_production_progress` VALUES (227, 1, 1, 8, '1122', '2025-10-30', '惠州饮料厂', 19, 'A001', '圆珠笔', 'qqqwe', 8, '1238', '2128', 56, 15000, 'hui11111111', '2025-07-10', 15000, '2025-10-15', NULL, 1, 1, '2025-10-13 11:37:22', '2025-10-15 10:41:29');
INSERT INTO `sub_production_progress` VALUES (228, 3, 12, 9, 'DD-A2510001', '2025-11-30', '俊宏达', 20, 'WA-A00001', '0611铝车架', '0611', 22, 'X002', '主梁管', 60, 800, 'JHD25001', '2025-10-10', 800, '2025-10-21', NULL, 1, 1, '2025-10-19 16:54:26', '2025-10-19 16:56:11');
INSERT INTO `sub_production_progress` VALUES (229, 3, 12, 9, 'DD-A2510001', '2025-11-30', '俊宏达', 20, 'WA-A00001', '0611铝车架', '0611', 21, 'X001', '车首管', 59, 800, 'JHD25001', '2025-10-10', 800, '2025-10-21', NULL, 1, 1, '2025-10-19 16:54:26', '2025-10-19 16:56:11');

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
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '销售订单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_sales_order
-- ----------------------------
INSERT INTO `sub_sales_order` VALUES (1, 1, 1, '2025-07-07', 3, 'G2222222', 10, '我的要求', '18000', 313, '个', '2025-07-07', '2025-07-27', '大朗镇', 1, '2025-07-14 13:55:51', '2025-09-03 09:43:29');
INSERT INTO `sub_sales_order` VALUES (2, 1, 1, '2025-07-10', 2, 'hui11111111', 19, '无要求', '15000', 2121, '件', '2025-10-31', '2025-07-14', '寮步镇', 1, '2025-07-14 18:47:31', '2025-09-03 09:43:20');
INSERT INTO `sub_sales_order` VALUES (3, 3, 6, '2025-10-10', 4, 'JHD25001', 20, '1.按照2510001-2510800打字码；2.补土后烤漆', '800', 800, '台', '2025-11-30', '2025-11-30', '公司厂区', 1, '2025-10-18 11:17:11', '2025-10-18 11:17:11');

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
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '仓库名列表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_warehouse_cycle
-- ----------------------------
INSERT INTO `sub_warehouse_cycle` VALUES (4, 1, 1, 3, '成品仓', 1, '2025-08-23 09:35:08', '2025-09-09 10:21:59');
INSERT INTO `sub_warehouse_cycle` VALUES (5, 1, 1, 2, '半成品仓', 1, '2025-08-23 09:35:27', '2025-09-09 10:21:55');
INSERT INTO `sub_warehouse_cycle` VALUES (6, 1, 1, 1, '材料仓', 1, '2025-08-23 09:35:34', '2025-09-09 10:20:20');
INSERT INTO `sub_warehouse_cycle` VALUES (7, 1, 1, 2, '小小部件', 1, '2025-09-16 13:01:10', '2025-09-16 13:01:10');
INSERT INTO `sub_warehouse_cycle` VALUES (8, 3, 6, 1, '管料仓', 1, '2025-10-16 15:05:46', '2025-10-16 15:05:46');
INSERT INTO `sub_warehouse_cycle` VALUES (9, 3, 6, 1, '配件仓', 1, '2025-10-16 15:06:04', '2025-10-16 15:06:04');

SET FOREIGN_KEY_CHECKS = 1;
