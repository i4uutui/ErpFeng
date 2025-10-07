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

 Date: 07/10/2025 16:05:54
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
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '客户企业信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ad_company_info
-- ----------------------------
INSERT INTO `ad_company_info` VALUES (1, NULL, '东莞企业', '梁工', '13800138000', '东莞市寮步镇', '2025-07-07 11:54:18', '2025-07-07 11:55:10');
INSERT INTO `ad_company_info` VALUES (2, NULL, '东坑企业', '刘工1', '13800138000', '东坑镇', '2025-07-07 13:59:43', '2025-07-12 15:29:04');

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
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ad_user
-- ----------------------------
INSERT INTO `ad_user` VALUES (1, 1, 'admin1', '$2b$10$qJOWecY5nOd6ICarLgePce3XPyVtXXrp1dkbB9ZQvtydVrKLz8uGG', '我是名字', NULL, 1, 0, 1, 1, '2025-07-07 13:56:55', '2025-07-21 17:26:05');
INSERT INTO `ad_user` VALUES (2, 2, 'admin99', '$2b$10$Ukc2Byd6TFsl0u2p68J0leC7tVgwp4LDWr7s6YV0EWpc6xR3dZyMm', NULL, NULL, 1, 0, 1, 1, '2025-07-07 14:00:05', '2025-07-08 14:21:48');
INSERT INTO `ad_user` VALUES (3, 1, '2121', '$2b$10$EpPaXdgc4ugWWT1Qi.DFSeRoz9XyBa3N7mKkNGuXEBvmy.pe8HEWq', NULL, NULL, 1, 0, 1, 1, '2025-07-08 10:35:09', '2025-07-08 14:21:49');
INSERT INTO `ad_user` VALUES (4, 1, '121', '$2b$10$qJOWecY5nOd6ICarLgePce3XPyVtXXrp1dkbB9ZQvtydVrKLz8uGG', '2132', '[[\"基础资料\",\"ProductCode\"],[\"基础资料\",\"PartCode\"],[\"基础资料\",\"MaterialCode\"],[\"基础资料\",\"ProcessCode\"],[\"基础资料\",\"EquipmentCode\"],[\"基础资料\",\"EmployeeInfo\"],[\"订单管理\",\"CustomerInfo\"],[\"订单管理\",\"ProductQuote\"],[\"订单管理\",\"SalesOrder\"],[\"仓库管理\"],[\"仓库管理\",\"ProductHouse\"],[\"仓库管理\",\"MaterialHouse\"],[\"仓库管理\",\"WarehouseRate\"],[\"采购管理\"],[\"委外管理\"],[\"采购管理\",\"PurchaseOrder\"],[\"采购管理\",\"MaterialQuote\"],[\"采购管理\",\"SupplierInfo\"],[\"委外管理\",\"OutsourcingQuote\"],[\"委外管理\",\"OutsourcingOrder\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:add\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:print\"]]', 2, 1, 1, 1, '2025-07-08 14:10:45', '2025-09-23 16:45:29');
INSERT INTO `ad_user` VALUES (5, 1, 'admin2', '$2b$10$qJOWecY5nOd6ICarLgePce3XPyVtXXrp1dkbB9ZQvtydVrKLz8uGG', '哈哈', '[[\"系统管理\"],[\"系统管理\",\"OrganizeManagement\"],[\"系统管理\",\"ProcessCycle\"],[\"系统管理\",\"ProcessCycle\",\"ProcessCycle:edit\"],[\"系统管理\",\"WarehouseType\"],[\"基础资料\"],[\"基础资料\",\"MaterialCode\"],[\"基础资料\",\"PartCode\"],[\"基础资料\",\"ProductCode\"],[\"基础资料\",\"ProductCode\",\"ProductCode:add\"],[\"基础资料\",\"ProductCode\",\"ProductCode:edit\"],[\"基础资料\",\"PartCode\",\"PartCode:edit\"],[\"基础资料\",\"PartCode\",\"PartCode:delete\"],[\"基础资料\",\"MaterialCode\",\"MaterialCode:edit\"],[\"基础资料\",\"ProcessCode\"],[\"基础资料\",\"EquipmentCode\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:edit\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:add\"],[\"基础资料\",\"EquipmentCode\",\"EquipmentCode:delete\"],[\"基础资料\",\"EmployeeInfo\",\"EmployeeInfo:delete\"],[\"基础资料\",\"EmployeeInfo\",\"EmployeeInfo:edit\"],[\"基础资料\",\"EmployeeInfo\"],[\"订单管理\"],[\"订单管理\",\"CustomerInfo\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:add\"],[\"订单管理\",\"CustomerInfo\",\"CustomerInfo:edit\"],[\"订单管理\",\"SalesOrder\"],[\"订单管理\",\"SalesOrder\",\"SalesOrder:edit\"],[\"订单管理\",\"ProductQuote\"],[\"订单管理\",\"ProductQuote\",\"ProductQuote:add\"],[\"订单管理\",\"ProductNotice\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:edit\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:add\"],[\"订单管理\",\"ProductNotice\",\"ProductNotice:date\"],[\"产品信息\"],[\"产品信息\",\"MaterialBOM\"],[\"产品信息\",\"MaterialBOM\",\"MaterialBOM:add\"],[\"产品信息\",\"MaterialBOM\",\"MaterialBOM:edit\"],[\"产品信息\",\"MaterialBOM\",\"MaterialBOM:archive\"],[\"产品信息\",\"MaterialBOM\",\"MaterialBOM:newPage\"],[\"产品信息\",\"MaterialBOMArchive\"],[\"产品信息\",\"ProcessBOM\"],[\"产品信息\",\"ProcessBOM\",\"ProcessBOM:archive\"],[\"产品信息\",\"ProcessBOM\",\"ProcessBOM:newPage\"],[\"产品信息\",\"ProcessBOMArchive\"],[\"委外管理\"],[\"委外管理\",\"OutsourcingOrder\"],[\"委外管理\",\"OutsourcingQuote\"],[\"委外管理\",\"OutsourcingOrder\",\"OutsourcingOrder:add\"],[\"仓库管理\"],[\"仓库管理\",\"ProductHouse\"],[\"仓库管理\",\"MaterialHouse\"],[\"仓库管理\",\"WarehouseRate\"],[\"采购管理\"],[\"采购管理\",\"SupplierInfo\"],[\"采购管理\",\"MaterialQuote\"],[\"采购管理\",\"PurchaseOrder\"]]', 2, 1, 1, 1, '2025-07-08 14:20:13', '2025-09-23 15:38:00');

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
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '审批步骤配置表' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 81 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '流程控制用户表' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

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
  `transaction_method` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '交易方式',
  `transaction_currency` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '交易币别',
  `other_transaction_terms` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '其它交易条件',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '客户信息基础信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_customer_info
-- ----------------------------
INSERT INTO `sub_customer_info` VALUES (1, 1, 1, '123223', '石龙佳洁士', '1', '1', '1', '1', '1', '1', '1', '1', '1', 1, '2025-07-08 19:29:21', '2025-09-03 09:42:12');
INSERT INTO `sub_customer_info` VALUES (2, 1, 1, '1234', '惠州饮料厂', '212', '121', '21', '121', '2121', '21', '21', '2121', '2121', 1, '2025-07-09 00:58:19', '2025-09-03 09:42:24');
INSERT INTO `sub_customer_info` VALUES (3, 1, 1, '12311', '东莞鞋厂', '12', '1', '15', '155', '15', '15', '1', '55', '11', 1, '2025-07-09 15:04:51', '2025-09-03 09:41:38');

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
  `cycle_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '所属制程名称',
  `production_position` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生产岗位',
  `salary_attribute` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '工资属性',
  `remarks` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '备注',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '员工信息基础信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_employee_info
-- ----------------------------
INSERT INTO `sub_employee_info` VALUES (1, 1, 1, '1', '1', NULL, NULL, 3, '生产组', '1', '1', '1', 1, '2025-07-08 16:39:58', '2025-10-01 14:42:15');
INSERT INTO `sub_employee_info` VALUES (2, 1, 1, '2', '2', 'base2', '$2b$10$mHXkEoWarhWYGisAwOnZ9Oghb6wEcnG0NOH8WdevQwS7HKLlET/Ja', 2, '设备组', '23', '32', '3', 1, '2025-07-08 16:40:09', '2025-10-01 15:03:01');
INSERT INTO `sub_employee_info` VALUES (3, 1, 1, '21', '2121', 'base1', '$2b$10$K0JSC.MSvQbD6mkRHjvjC.gpS4XvjatLgIf/yw0wjSs.N3FHt9aCe', 2, '设备组', '21', '2121', '211', 1, '2025-10-01 14:42:30', '2025-10-01 16:13:03');
INSERT INTO `sub_employee_info` VALUES (4, 1, 1, '22', '5445', 'base3', '$2b$10$7DtT7oDcCGxZaLYfiJTPd.mywJj.yYGwC7di.3HLUfD.JBtP3wv0y', 2, '设备组', '2121', '2121', '21', 1, '2025-10-01 15:05:57', '2025-10-01 15:05:57');

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
  `equipment_quantity` int(11) NULL DEFAULT 2 COMMENT '设备数量',
  `cycle_id` int(11) NULL DEFAULT NULL COMMENT '所属制程组',
  `working_hours` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '工作时长(小时)',
  `equipment_efficiency` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '设备效能',
  `equipment_status` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '设备状态',
  `remarks` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '备注',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '1：未删除；0：已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '记录创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '记录最后更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '设备信息基础信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_equipment_code
-- ----------------------------
INSERT INTO `sub_equipment_code` VALUES (3, 1, 1, '123', '钻床', 12, 3, '7', '84', '状态3', '无', 1, '2025-07-08 16:06:29', '2025-08-29 10:06:36');
INSERT INTO `sub_equipment_code` VALUES (4, 1, 1, '122', '退火炉', 22, 1, '10', '220', '状态2', '无', 1, '2025-08-09 16:06:56', '2025-08-29 10:06:15');
INSERT INTO `sub_equipment_code` VALUES (5, 1, 1, '124', '激光机', 5, 1, '8', '40', '状态1', '无', 1, '2025-08-29 09:33:14', '2025-08-29 10:05:27');

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
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '材料BOM表' ROW_FORMAT = DYNAMIC;

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

-- ----------------------------
-- Table structure for sub_material_bom_child
-- ----------------------------
DROP TABLE IF EXISTS `sub_material_bom_child`;
CREATE TABLE `sub_material_bom_child`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键ID',
  `material_bom_id` int(11) NOT NULL COMMENT '材料BOM的父表id',
  `material_id` int(11) NOT NULL COMMENT '材料编码ID，关联材料编码表',
  `number` int(20) NULL DEFAULT NULL COMMENT '数量',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 27 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '材料BOM表子表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_material_bom_child
-- ----------------------------
INSERT INTO `sub_material_bom_child` VALUES (6, 12, 2, 12, '2025-08-13 10:38:41', '2025-08-13 10:38:41');
INSERT INTO `sub_material_bom_child` VALUES (7, 12, 2, 22, '2025-08-13 10:38:41', '2025-08-13 10:38:41');
INSERT INTO `sub_material_bom_child` VALUES (8, 12, 2, 24, '2025-08-13 10:38:41', '2025-08-13 10:38:41');
INSERT INTO `sub_material_bom_child` VALUES (9, 11, 2, 23, '2025-08-13 10:59:47', '2025-08-13 10:59:47');
INSERT INTO `sub_material_bom_child` VALUES (10, 11, 2, 34, '2025-08-13 10:59:47', '2025-08-13 10:59:47');
INSERT INTO `sub_material_bom_child` VALUES (11, 10, 2, 12, '2025-08-13 10:59:52', '2025-08-13 10:59:52');
INSERT INTO `sub_material_bom_child` VALUES (12, 13, 3, 12, '2025-08-13 14:41:35', '2025-08-17 09:48:42');
INSERT INTO `sub_material_bom_child` VALUES (13, 14, 2, 12, '2025-08-13 14:41:55', '2025-08-13 14:41:55');
INSERT INTO `sub_material_bom_child` VALUES (14, 14, 2, 22, '2025-08-13 14:41:55', '2025-08-13 14:41:55');
INSERT INTO `sub_material_bom_child` VALUES (15, 14, 3, 24, '2025-08-13 14:41:55', '2025-08-17 09:38:34');
INSERT INTO `sub_material_bom_child` VALUES (16, 15, 2, 23, '2025-08-13 14:42:03', '2025-08-13 14:42:03');
INSERT INTO `sub_material_bom_child` VALUES (17, 15, 2, 34, '2025-08-13 14:42:03', '2025-08-13 14:42:03');
INSERT INTO `sub_material_bom_child` VALUES (18, 16, 3, 12, '2025-08-21 09:35:05', '2025-08-21 09:35:05');
INSERT INTO `sub_material_bom_child` VALUES (19, 17, 2, 600, '2025-09-25 14:38:28', '2025-09-25 14:38:28');
INSERT INTO `sub_material_bom_child` VALUES (20, 17, 3, 400, '2025-09-25 14:38:28', '2025-09-25 14:38:28');
INSERT INTO `sub_material_bom_child` VALUES (21, 18, 3, 900, '2025-09-25 14:39:31', '2025-09-25 14:39:31');
INSERT INTO `sub_material_bom_child` VALUES (22, 19, 2, 600, '2025-09-25 14:39:45', '2025-09-25 14:39:45');
INSERT INTO `sub_material_bom_child` VALUES (23, 19, 3, 700, '2025-09-25 14:39:45', '2025-09-25 14:39:45');
INSERT INTO `sub_material_bom_child` VALUES (24, 20, 2, 198, '2025-09-25 14:44:26', '2025-09-25 14:44:26');
INSERT INTO `sub_material_bom_child` VALUES (25, 20, 2, 158, '2025-09-25 14:44:26', '2025-09-25 14:44:26');
INSERT INTO `sub_material_bom_child` VALUES (26, 21, 2, 485, '2025-09-25 14:44:36', '2025-09-25 14:44:36');

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
  `currency` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '币别',
  `remarks` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '备注',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '1：未删除；0：已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '记录创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '记录最后更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '材料编码基础信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_material_code
-- ----------------------------
INSERT INTO `sub_material_code` VALUES (2, 1, 1, '123', '121', '2121', '21', '2121', '21', '21', '12', '21', 1, '2025-07-08 15:36:33', '2025-08-12 10:18:06');
INSERT INTO `sub_material_code` VALUES (3, 1, 1, '789', '555', '535', '35353', '353', '353', '5353', '535', '353', 1, '2025-08-17 09:38:16', '2025-08-17 09:38:16');

-- ----------------------------
-- Table structure for sub_material_ment
-- ----------------------------
DROP TABLE IF EXISTS `sub_material_ment`;
CREATE TABLE `sub_material_ment`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键ID',
  `company_id` int(11) NOT NULL COMMENT '企业id',
  `user_id` int(11) NOT NULL COMMENT '发布的用户id',
  `notice_id` int(11) NULL DEFAULT NULL COMMENT '生产订单ID',
  `notice` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生产订单',
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
  `unit` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '单位',
  `price` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '单价',
  `order_number` int(10) NULL DEFAULT NULL COMMENT '预计数量',
  `number` int(10) NULL DEFAULT NULL COMMENT '实际数量',
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
INSERT INTO `sub_material_ment` VALUES (3, 1, 1, 6, '2222', 2, '1234', '151', 10, '1233', '212', 3, '789', '555', '535/35353', '353', '353', '2.5', 18000, 18000, '2025-07-07', 1, '我是名字', '2025-09-23 14:54:56', 1, 0, 1, '2025-09-23 14:54:56', '2025-09-26 15:50:08');
INSERT INTO `sub_material_ment` VALUES (4, 1, 1, 8, '1122', 2, '1234', '151', 19, 'A001', '圆珠笔', 2, '123', '121', '2121/21', '2121', '21', '2.6', 15000, 15000, '2025-10-31', 1, '我是名字', '2025-09-26 14:03:04', 1, 0, 1, '2025-09-26 14:03:04', '2025-09-26 15:49:50');

-- ----------------------------
-- Table structure for sub_material_quote
-- ----------------------------
DROP TABLE IF EXISTS `sub_material_quote`;
CREATE TABLE `sub_material_quote`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键ID',
  `company_id` int(11) NOT NULL COMMENT '企业id',
  `user_id` int(11) NOT NULL COMMENT '发布的用户id',
  `supplier_id` int(11) NULL DEFAULT NULL COMMENT '供应商id',
  `notice_id` int(11) NULL DEFAULT NULL COMMENT '生产通知单id',
  `product_id` int(11) NULL DEFAULT NULL COMMENT '产品编码id',
  `material_id` int(11) NOT NULL COMMENT '材料编码ID',
  `price` int(11) NULL DEFAULT NULL COMMENT '单价',
  `delivery` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '送货方式',
  `packaging` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '包装要求',
  `transaction_currency` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '交易币别',
  `other_transaction_terms` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '交易条件',
  `remarks` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '备注',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '材料报价信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_material_quote
-- ----------------------------
INSERT INTO `sub_material_quote` VALUES (1, 1, 1, 2, 8, 19, 2, 24, '1111', '1111', '1111', '1111', '1111', 1, '2025-07-27 21:43:20', '2025-09-26 13:28:03');
INSERT INTO `sub_material_quote` VALUES (2, 1, 1, 1, 8, 19, 2, 21, '2222', '222', '22', '222', '22', 1, '2025-07-27 22:40:03', '2025-09-26 13:41:17');

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
) ENGINE = InnoDB AUTO_INCREMENT = 78 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户操作日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sub_operation_history
-- ----------------------------
INSERT INTO `sub_operation_history` VALUES (26, 1, 1, '我是名字', 'update', '产品编码', '修改产品编码：A001', '{\"newData\":{\"id\":19,\"company_id\":1,\"user_id\":1,\"product_code\":\"A001\",\"product_name\":\"圆珠笔\",\"drawing\":\"qqqwe\",\"model\":\"eeqqwq\",\"specification\":\"sewww\",\"other_features\":\"ersdsd\",\"component_structure\":\"ewww\",\"unit\":\"ff\",\"unit_price\":22,\"currency\":\"3rr\",\"production_requirements\":\"rww\",\"is_deleted\":1,\"created_at\":\"2025-08-10\",\"updated_at\":\"2025-08-21\"}}', '2025-09-25 03:32:14');
INSERT INTO `sub_operation_history` VALUES (30, 1, 1, '我是名字', 'add', '材料BOM', '新增材料BOM，产品编码：1234，部件编码：12310，材料编码：789', '{\"newData\":{\"product_id\":11,\"part_id\":9,\"children\":[{\"material_id\":3,\"number\":\"900\"}],\"archive\":1}}', '2025-09-25 06:39:31');
INSERT INTO `sub_operation_history` VALUES (31, 1, 1, '我是名字', 'add', '材料BOM', '新增材料BOM，产品编码：12323，部件编码：12311，材料编码：123,789', '{\"newData\":{\"product_id\":14,\"part_id\":10,\"children\":[{\"material_id\":2,\"number\":\"600\"},{\"material_id\":3,\"number\":\"700\"}],\"archive\":1}}', '2025-09-25 06:39:45');
INSERT INTO `sub_operation_history` VALUES (32, 1, 1, '我是名字', 'keyup', '材料BOM', '存档材料BOM，产品编码：12323，部件编码：12311，材料编码：123,789；产品编码：1234，部件编码：12310，材料编码：789；产品编码：12325，部件编码：1238，材料编码：789,123；产品编码：12671，部件编码：1234，材料编码：789；', '{\"newData\":{\"ids\":[19,18,17,16],\"archive\":0}}', '2025-09-25 06:39:53');
INSERT INTO `sub_operation_history` VALUES (33, 1, 1, '我是名字', 'add', '材料BOM', '新增材料BOM，产品编码：12323，部件编码：12313，材料编码：123,123', '{\"newData\":{\"product_id\":14,\"part_id\":13,\"children\":[{\"material_id\":2,\"number\":\"198\"},{\"material_id\":2,\"number\":\"158\"}],\"archive\":1}}', '2025-09-25 06:44:26');
INSERT INTO `sub_operation_history` VALUES (34, 1, 1, '我是名字', 'add', '材料BOM', '新增材料BOM，产品编码：12323，部件编码：12311，材料编码：123', '{\"newData\":{\"product_id\":14,\"part_id\":10,\"children\":[{\"material_id\":2,\"number\":\"485\"}],\"archive\":1}}', '2025-09-25 06:44:36');
INSERT INTO `sub_operation_history` VALUES (35, 1, 1, '我是名字', 'keyup', '材料BOM', '存档材料BOM，产品编码：12323，部件编码：12311，材料编码：123；\r\n产品编码：12323，部件编码：12313，材料编码：123,123；', '{\"newData\":{\"ids\":[21,20],\"archive\":0}}', '2025-09-25 06:44:42');
INSERT INTO `sub_operation_history` VALUES (36, 1, 1, '我是名字', 'add', '工艺BOM', '新增工艺BOM，产品编码：12323，部件编码：1238，工艺编码：T001', '{\"newData\":{\"product_id\":14,\"part_id\":8,\"children\":[{\"process_id\":5,\"equipment_id\":4,\"time\":\"6\",\"price\":\"8\",\"process_index\":1}],\"archive\":1}}', '2025-09-25 06:51:51');
INSERT INTO `sub_operation_history` VALUES (37, 1, 1, '我是名字', 'keyup', '工艺BOM', '存档工艺BOM，产品编码：12323，部件编码：1238，材料编码：T001；\r\n产品编码：12323，部件编码：12312，材料编码：T001,T002；', '{\"newData\":{\"ids\":[58,57],\"archive\":0}}', '2025-09-25 06:51:59');
INSERT INTO `sub_operation_history` VALUES (38, 1, 1, '我是名字', 'update', '原材料报价', '修改原材料报价，供应商编码：123，生产订单号：1122，材料编码：123', '{\"newData\":{\"id\":2,\"supplier_id\":1,\"notice_id\":8,\"material_id\":2,\"price\":21,\"delivery\":\"2222\",\"packaging\":\"222\",\"transaction_currency\":\"22\",\"other_transaction_terms\":\"222\",\"remarks\":\"22\"}}', '2025-09-26 05:41:17');
INSERT INTO `sub_operation_history` VALUES (39, 1, 1, '我是名字', 'keyApproval', '采购单', '新增采购单并提交审核，供应商编码：2，生产订单号：8，产品编码：A001，材料编码：123', '{\"newData\":{\"data\":[{\"notice_id\":8,\"notice\":\"1122\",\"supplier_id\":2,\"supplier_code\":\"1234\",\"supplier_abbreviation\":\"151\",\"product_id\":19,\"product_code\":\"A001\",\"product_name\":\"圆珠笔\",\"material_id\":2,\"material_code\":\"123\",\"material_name\":\"121\",\"model_spec\":\"2121/21\",\"other_features\":\"2121\",\"unit\":\"21\",\"price\":\"2.6\",\"order_number\":\"15000\",\"number\":\"15000\",\"delivery_time\":\"2025-10-31\"}],\"type\":\"purchase_order\"}}', '2025-09-26 06:03:04');
INSERT INTO `sub_operation_history` VALUES (40, 1, 1, '我是名字', 'keyApproval', '委外加工单', '委外加工单提交审核：{ 供应商编码：123，生产订单号：1122，工艺BOM：12323:21223 - 1238:2128，工艺工序： }', '{\"newData\":{\"data\":[{\"notice_id\":8,\"supplier_id\":1,\"process_bom_id\":58,\"process_bom_children_id\":75,\"price\":3,\"number\":600,\"ment\":\"无\",\"unit\":\"￥\",\"transaction_currency\":\"无1\",\"other_transaction_terms\":\"无2\",\"remarks\":\"无\",\"delivery_time\":\"2025-09-30\",\"id\":11}],\"type\":\"outsourcing_order\"}}', '2025-09-26 07:23:50');
INSERT INTO `sub_operation_history` VALUES (41, 1, 4, '2132', 'approval', '委外加工单', '审批通过了委外加工单，委外加工单为：{ 供应商编码：123，生产订单号：1122，工艺BOM：12323:21223 - 1238:2128，工艺工序： }', '{\"newData\":{\"data\":[{\"id\":11,\"notice_id\":8,\"supplier_id\":1,\"process_bom_id\":58,\"process_bom_children_id\":75,\"ment\":\"无\",\"unit\":\"￥\",\"number\":600,\"price\":3,\"transaction_currency\":\"无1\",\"other_transaction_terms\":\"无2\",\"delivery_time\":\"2025-09-30\",\"remarks\":\"无\",\"status\":0,\"apply_id\":1,\"apply_name\":\"我是名字\",\"apply_time\":\"2025-09-26\",\"step\":2,\"supplier\":{\"id\":1,\"supplier_abbreviation\":\"2121\",\"supplier_code\":\"123\"},\"notice\":{\"id\":8,\"notice\":\"1122\",\"sale_id\":2,\"sale\":{\"id\":2,\"order_number\":\"15000\",\"unit\":\"件\",\"delivery_time\":\"2025-10-31\"}},\"processBom\":{\"id\":58,\"product_id\":14,\"part_id\":8,\"archive\":0,\"product\":{\"id\":14,\"product_name\":\"21223\",\"product_code\":\"12323\",\"drawing\":\"2121\",\"model\":\"wdd\",\"specification\":\"dwwdq\"},\"part\":{\"id\":8,\"part_name\":\"2128\",\"part_code\":\"1238\"}},\"processChildren\":{\"id\":75,\"process_bom_id\":58,\"process_id\":5,\"equipment_id\":4,\"time\":6,\"price\":8,\"process\":{\"id\":5,\"process_code\":\"T001\",\"process_name\":\"钻床\",\"section_points\":\"24.0\"},\"equipment\":{\"id\":4,\"equipment_code\":\"122\",\"equipment_name\":\"退火炉\"}},\"approval\":[{\"user_id\":4,\"user_name\":\"2132\",\"type\":\"outsourcing_order\",\"step\":1,\"company_id\":1,\"source_id\":11,\"user_time\":null,\"status\":1,\"id\":61},{\"user_id\":4,\"user_name\":\"2132\",\"type\":\"outsourcing_order\",\"step\":1,\"company_id\":1,\"source_id\":11,\"user_time\":null,\"status\":1,\"id\":63},{\"user_id\":4,\"user_name\":\"2132\",\"type\":\"outsourcing_order\",\"step\":1,\"company_id\":1,\"source_id\":11,\"user_time\":null,\"status\":0,\"id\":65},{\"user_id\":5,\"user_name\":\"哈哈\",\"type\":\"outsourcing_order\",\"step\":2,\"company_id\":1,\"source_id\":11,\"user_time\":null,\"status\":0,\"id\":62},{\"user_id\":5,\"user_name\":\"哈哈\",\"type\":\"outsourcing_order\",\"step\":2,\"company_id\":1,\"source_id\":11,\"user_time\":null,\"status\":0,\"id\":64},{\"user_id\":5,\"user_name\":\"哈哈\",\"type\":\"outsourcing_order\",\"step\":2,\"company_id\":1,\"source_id\":11,\"user_time\":null,\"status\":0,\"id\":66}]}],\"action\":1}}', '2025-09-26 07:26:50');
INSERT INTO `sub_operation_history` VALUES (42, 1, 5, '哈哈', 'approval', '委外加工单', '审批通过了委外加工单，委外加工单为：{ 供应商编码：123，生产订单号：1122，工艺BOM：12323:21223 - 1238:2128，工艺工序： }', '{\"newData\":{\"data\":[{\"id\":11,\"notice_id\":8,\"supplier_id\":1,\"process_bom_id\":58,\"process_bom_children_id\":75,\"ment\":\"无\",\"unit\":\"￥\",\"number\":600,\"price\":3,\"transaction_currency\":\"无1\",\"other_transaction_terms\":\"无2\",\"delivery_time\":\"2025-09-30\",\"remarks\":\"无\",\"status\":0,\"apply_id\":1,\"apply_name\":\"我是名字\",\"apply_time\":\"2025-09-26\",\"step\":3,\"supplier\":{\"id\":1,\"supplier_abbreviation\":\"2121\",\"supplier_code\":\"123\"},\"notice\":{\"id\":8,\"notice\":\"1122\",\"sale_id\":2,\"sale\":{\"id\":2,\"order_number\":\"15000\",\"unit\":\"件\",\"delivery_time\":\"2025-10-31\"}},\"processBom\":{\"id\":58,\"product_id\":14,\"part_id\":8,\"archive\":0,\"product\":{\"id\":14,\"product_name\":\"21223\",\"product_code\":\"12323\",\"drawing\":\"2121\",\"model\":\"wdd\",\"specification\":\"dwwdq\"},\"part\":{\"id\":8,\"part_name\":\"2128\",\"part_code\":\"1238\"}},\"processChildren\":{\"id\":75,\"process_bom_id\":58,\"process_id\":5,\"equipment_id\":4,\"time\":6,\"price\":8,\"process\":{\"id\":5,\"process_code\":\"T001\",\"process_name\":\"钻床\",\"section_points\":\"24.0\"},\"equipment\":{\"id\":4,\"equipment_code\":\"122\",\"equipment_name\":\"退火炉\"}},\"approval\":[{\"user_id\":4,\"user_name\":\"2132\",\"type\":\"outsourcing_order\",\"step\":1,\"company_id\":1,\"source_id\":11,\"user_time\":null,\"status\":1,\"id\":61},{\"user_id\":4,\"user_name\":\"2132\",\"type\":\"outsourcing_order\",\"step\":1,\"company_id\":1,\"source_id\":11,\"user_time\":null,\"status\":1,\"id\":63},{\"user_id\":4,\"user_name\":\"2132\",\"type\":\"outsourcing_order\",\"step\":1,\"company_id\":1,\"source_id\":11,\"user_time\":null,\"status\":1,\"id\":65},{\"user_id\":5,\"user_name\":\"哈哈\",\"type\":\"outsourcing_order\",\"step\":2,\"company_id\":1,\"source_id\":11,\"user_time\":null,\"status\":0,\"id\":62},{\"user_id\":5,\"user_name\":\"哈哈\",\"type\":\"outsourcing_order\",\"step\":2,\"company_id\":1,\"source_id\":11,\"user_time\":null,\"status\":0,\"id\":64},{\"user_id\":5,\"user_name\":\"哈哈\",\"type\":\"outsourcing_order\",\"step\":2,\"company_id\":1,\"source_id\":11,\"user_time\":null,\"status\":0,\"id\":66}]}],\"action\":1}}', '2025-09-26 07:28:44');
INSERT INTO `sub_operation_history` VALUES (43, 1, 5, '哈哈', 'approval', '委外加工单', '审批通过了委外加工单，委外加工单为：{ 供应商编码：123，生产订单号：1122，工艺BOM：12323:21223 - 1238:2128，工艺工序： }', '{\"newData\":{\"data\":[{\"id\":11,\"notice_id\":8,\"supplier_id\":1,\"process_bom_id\":58,\"process_bom_children_id\":75,\"ment\":\"无\",\"unit\":\"￥\",\"number\":600,\"price\":3,\"transaction_currency\":\"无1\",\"other_transaction_terms\":\"无2\",\"delivery_time\":\"2025-09-30\",\"remarks\":\"无\",\"status\":0,\"apply_id\":1,\"apply_name\":\"我是名字\",\"apply_time\":\"2025-09-26\",\"step\":4,\"supplier\":{\"id\":1,\"supplier_abbreviation\":\"2121\",\"supplier_code\":\"123\"},\"notice\":{\"id\":8,\"notice\":\"1122\",\"sale_id\":2,\"sale\":{\"id\":2,\"order_number\":\"15000\",\"unit\":\"件\",\"delivery_time\":\"2025-10-31\"}},\"processBom\":{\"id\":58,\"product_id\":14,\"part_id\":8,\"archive\":0,\"product\":{\"id\":14,\"product_name\":\"21223\",\"product_code\":\"12323\",\"drawing\":\"2121\",\"model\":\"wdd\",\"specification\":\"dwwdq\"},\"part\":{\"id\":8,\"part_name\":\"2128\",\"part_code\":\"1238\"}},\"processChildren\":{\"id\":75,\"process_bom_id\":58,\"process_id\":5,\"equipment_id\":4,\"time\":6,\"price\":8,\"process\":{\"id\":5,\"process_code\":\"T001\",\"process_name\":\"钻床\",\"section_points\":\"24.0\"},\"equipment\":{\"id\":4,\"equipment_code\":\"122\",\"equipment_name\":\"退火炉\"}},\"approval\":[{\"user_id\":4,\"user_name\":\"2132\",\"type\":\"outsourcing_order\",\"step\":1,\"company_id\":1,\"source_id\":11,\"user_time\":null,\"status\":1,\"id\":61},{\"user_id\":4,\"user_name\":\"2132\",\"type\":\"outsourcing_order\",\"step\":1,\"company_id\":1,\"source_id\":11,\"user_time\":null,\"status\":1,\"id\":63},{\"user_id\":4,\"user_name\":\"2132\",\"type\":\"outsourcing_order\",\"step\":1,\"company_id\":1,\"source_id\":11,\"user_time\":null,\"status\":1,\"id\":65},{\"user_id\":5,\"user_name\":\"哈哈\",\"type\":\"outsourcing_order\",\"step\":2,\"company_id\":1,\"source_id\":11,\"user_time\":null,\"status\":1,\"id\":62},{\"user_id\":5,\"user_name\":\"哈哈\",\"type\":\"outsourcing_order\",\"step\":2,\"company_id\":1,\"source_id\":11,\"user_time\":null,\"status\":0,\"id\":64},{\"user_id\":5,\"user_name\":\"哈哈\",\"type\":\"outsourcing_order\",\"step\":2,\"company_id\":1,\"source_id\":11,\"user_time\":null,\"status\":0,\"id\":66}]}],\"action\":1}}', '2025-09-26 07:29:28');
INSERT INTO `sub_operation_history` VALUES (44, 1, 5, '哈哈', 'approval', '委外加工单', '审批通过了委外加工单，委外加工单为：{ 供应商编码：123，生产订单号：1122，工艺BOM：12323:21223 - 1238:2128，工艺工序： }', '{\"newData\":{\"data\":[{\"id\":11,\"notice_id\":8,\"supplier_id\":1,\"process_bom_id\":58,\"process_bom_children_id\":75,\"ment\":\"无\",\"unit\":\"￥\",\"number\":600,\"price\":3,\"transaction_currency\":\"无1\",\"other_transaction_terms\":\"无2\",\"delivery_time\":\"2025-09-30\",\"remarks\":\"无\",\"status\":0,\"apply_id\":1,\"apply_name\":\"我是名字\",\"apply_time\":\"2025-09-26\",\"step\":5,\"supplier\":{\"id\":1,\"supplier_abbreviation\":\"2121\",\"supplier_code\":\"123\"},\"notice\":{\"id\":8,\"notice\":\"1122\",\"sale_id\":2,\"sale\":{\"id\":2,\"order_number\":\"15000\",\"unit\":\"件\",\"delivery_time\":\"2025-10-31\"}},\"processBom\":{\"id\":58,\"product_id\":14,\"part_id\":8,\"archive\":0,\"product\":{\"id\":14,\"product_name\":\"21223\",\"product_code\":\"12323\",\"drawing\":\"2121\",\"model\":\"wdd\",\"specification\":\"dwwdq\"},\"part\":{\"id\":8,\"part_name\":\"2128\",\"part_code\":\"1238\"}},\"processChildren\":{\"id\":75,\"process_bom_id\":58,\"process_id\":5,\"equipment_id\":4,\"time\":6,\"price\":8,\"process\":{\"id\":5,\"process_code\":\"T001\",\"process_name\":\"钻床\",\"section_points\":\"24.0\"},\"equipment\":{\"id\":4,\"equipment_code\":\"122\",\"equipment_name\":\"退火炉\"}},\"approval\":[{\"user_id\":4,\"user_name\":\"2132\",\"type\":\"outsourcing_order\",\"step\":1,\"company_id\":1,\"source_id\":11,\"user_time\":null,\"status\":1,\"id\":61},{\"user_id\":4,\"user_name\":\"2132\",\"type\":\"outsourcing_order\",\"step\":1,\"company_id\":1,\"source_id\":11,\"user_time\":null,\"status\":1,\"id\":63},{\"user_id\":4,\"user_name\":\"2132\",\"type\":\"outsourcing_order\",\"step\":1,\"company_id\":1,\"source_id\":11,\"user_time\":null,\"status\":1,\"id\":65},{\"user_id\":5,\"user_name\":\"哈哈\",\"type\":\"outsourcing_order\",\"step\":2,\"company_id\":1,\"source_id\":11,\"user_time\":null,\"status\":1,\"id\":62},{\"user_id\":5,\"user_name\":\"哈哈\",\"type\":\"outsourcing_order\",\"step\":2,\"company_id\":1,\"source_id\":11,\"user_time\":null,\"status\":1,\"id\":64},{\"user_id\":5,\"user_name\":\"哈哈\",\"type\":\"outsourcing_order\",\"step\":2,\"company_id\":1,\"source_id\":11,\"user_time\":null,\"status\":0,\"id\":66}]}],\"action\":1}}', '2025-09-26 07:29:35');
INSERT INTO `sub_operation_history` VALUES (45, 1, 4, '2132', 'approval', '委外加工单', '审批通过了委外加工单，委外加工单为：{ 供应商编码：123，生产订单号：1122，工艺BOM：12323:21223 - 1238:2128，工艺工序： }', '{\"newData\":{\"data\":[{\"id\":11,\"notice_id\":8,\"supplier_id\":1,\"process_bom_id\":58,\"process_bom_children_id\":75,\"ment\":\"无\",\"unit\":\"￥\",\"number\":600,\"price\":3,\"transaction_currency\":\"无1\",\"other_transaction_terms\":\"无2\",\"delivery_time\":\"2025-09-30\",\"remarks\":\"无\",\"status\":0,\"apply_id\":1,\"apply_name\":\"我是名字\",\"apply_time\":\"2025-09-26\",\"step\":0,\"supplier\":{\"id\":1,\"supplier_abbreviation\":\"2121\",\"supplier_code\":\"123\"},\"notice\":{\"id\":8,\"notice\":\"1122\",\"sale_id\":2,\"sale\":{\"id\":2,\"order_number\":\"15000\",\"unit\":\"件\",\"delivery_time\":\"2025-10-31\"}},\"processBom\":{\"id\":58,\"product_id\":14,\"part_id\":8,\"archive\":0,\"product\":{\"id\":14,\"product_name\":\"21223\",\"product_code\":\"12323\",\"drawing\":\"2121\",\"model\":\"wdd\",\"specification\":\"dwwdq\"},\"part\":{\"id\":8,\"part_name\":\"2128\",\"part_code\":\"1238\"}},\"processChildren\":{\"id\":75,\"process_bom_id\":58,\"process_id\":5,\"equipment_id\":4,\"time\":6,\"price\":8,\"process\":{\"id\":5,\"process_code\":\"T001\",\"process_name\":\"钻床\",\"section_points\":\"24.0\"},\"equipment\":{\"id\":4,\"equipment_code\":\"122\",\"equipment_name\":\"退火炉\"}},\"approval\":[{\"user_id\":4,\"user_name\":\"2132\",\"type\":\"outsourcing_order\",\"step\":1,\"company_id\":1,\"source_id\":11,\"user_time\":null,\"status\":0,\"id\":61},{\"user_id\":5,\"user_name\":\"哈哈\",\"type\":\"outsourcing_order\",\"step\":2,\"company_id\":1,\"source_id\":11,\"user_time\":null,\"status\":0,\"id\":62}]}],\"action\":1}}', '2025-09-26 07:31:49');
INSERT INTO `sub_operation_history` VALUES (46, 1, 5, '哈哈', 'approval', '委外加工单', '审批通过了委外加工单，委外加工单为：{ 供应商编码：123，生产订单号：1122，工艺BOM：12323:21223 - 1238:2128，工艺工序： }', '{\"newData\":{\"data\":[{\"id\":11,\"notice_id\":8,\"supplier_id\":1,\"process_bom_id\":58,\"process_bom_children_id\":75,\"ment\":\"无\",\"unit\":\"￥\",\"number\":600,\"price\":3,\"transaction_currency\":\"无1\",\"other_transaction_terms\":\"无2\",\"delivery_time\":\"2025-09-30\",\"remarks\":\"无\",\"status\":0,\"apply_id\":1,\"apply_name\":\"我是名字\",\"apply_time\":\"2025-09-26\",\"step\":1,\"supplier\":{\"id\":1,\"supplier_abbreviation\":\"2121\",\"supplier_code\":\"123\"},\"notice\":{\"id\":8,\"notice\":\"1122\",\"sale_id\":2,\"sale\":{\"id\":2,\"order_number\":\"15000\",\"unit\":\"件\",\"delivery_time\":\"2025-10-31\"}},\"processBom\":{\"id\":58,\"product_id\":14,\"part_id\":8,\"archive\":0,\"product\":{\"id\":14,\"product_name\":\"21223\",\"product_code\":\"12323\",\"drawing\":\"2121\",\"model\":\"wdd\",\"specification\":\"dwwdq\"},\"part\":{\"id\":8,\"part_name\":\"2128\",\"part_code\":\"1238\"}},\"processChildren\":{\"id\":75,\"process_bom_id\":58,\"process_id\":5,\"equipment_id\":4,\"time\":6,\"price\":8,\"process\":{\"id\":5,\"process_code\":\"T001\",\"process_name\":\"钻床\",\"section_points\":\"24.0\"},\"equipment\":{\"id\":4,\"equipment_code\":\"122\",\"equipment_name\":\"退火炉\"}},\"approval\":[{\"user_id\":4,\"user_name\":\"2132\",\"type\":\"outsourcing_order\",\"step\":1,\"company_id\":1,\"source_id\":11,\"user_time\":null,\"status\":1,\"id\":61},{\"user_id\":5,\"user_name\":\"哈哈\",\"type\":\"outsourcing_order\",\"step\":2,\"company_id\":1,\"source_id\":11,\"user_time\":null,\"status\":0,\"id\":62}]}],\"action\":1}}', '2025-09-26 07:32:26');
INSERT INTO `sub_operation_history` VALUES (47, 1, 5, '哈哈', 'backApproval', '委外加工单', '反审批了委外加工单，供应商编码：123，生产订单号：1122，工艺BOM：12323:21223 - 1238:2128，工艺工序：T001:钻床 - 122:退火炉', '{\"newData\":11}', '2025-09-26 07:42:57');
INSERT INTO `sub_operation_history` VALUES (48, 1, 4, '2132', 'approval', '委外加工单', '审批通过了委外加工单，委外加工单为：{ 供应商编码：123，生产订单号：1122，工艺BOM：12323:21223 - 1238:2128，工艺工序：T001:钻床 - 122:退火炉 }', '{\"newData\":{\"data\":[{\"id\":11,\"notice_id\":8,\"supplier_id\":1,\"process_bom_id\":58,\"process_bom_children_id\":75,\"ment\":\"无\",\"unit\":\"￥\",\"number\":600,\"price\":3,\"transaction_currency\":\"无1\",\"other_transaction_terms\":\"无2\",\"delivery_time\":\"2025-09-30\",\"remarks\":\"无\",\"status\":0,\"apply_id\":1,\"apply_name\":\"我是名字\",\"apply_time\":\"2025-09-26\",\"step\":0,\"supplier\":{\"id\":1,\"supplier_abbreviation\":\"2121\",\"supplier_code\":\"123\"},\"notice\":{\"id\":8,\"notice\":\"1122\",\"sale_id\":2,\"sale\":{\"id\":2,\"order_number\":\"15000\",\"unit\":\"件\",\"delivery_time\":\"2025-10-31\"}},\"processBom\":{\"id\":58,\"product_id\":14,\"part_id\":8,\"archive\":0,\"product\":{\"id\":14,\"product_name\":\"21223\",\"product_code\":\"12323\",\"drawing\":\"2121\",\"model\":\"wdd\",\"specification\":\"dwwdq\"},\"part\":{\"id\":8,\"part_name\":\"2128\",\"part_code\":\"1238\"}},\"processChildren\":{\"id\":75,\"process_bom_id\":58,\"process_id\":5,\"equipment_id\":4,\"time\":6,\"price\":8,\"process\":{\"id\":5,\"process_code\":\"T001\",\"process_name\":\"钻床\",\"section_points\":\"24.0\"},\"equipment\":{\"id\":4,\"equipment_code\":\"122\",\"equipment_name\":\"退火炉\"}},\"approval\":[{\"user_id\":4,\"user_name\":\"2132\",\"type\":\"outsourcing_order\",\"step\":1,\"company_id\":1,\"source_id\":11,\"user_time\":null,\"status\":0,\"id\":61},{\"user_id\":5,\"user_name\":\"哈哈\",\"type\":\"outsourcing_order\",\"step\":2,\"company_id\":1,\"source_id\":11,\"user_time\":null,\"status\":0,\"id\":62}]}],\"action\":1}}', '2025-09-26 07:45:26');
INSERT INTO `sub_operation_history` VALUES (49, 1, 5, '哈哈', 'approval', '委外加工单', '审批拒绝了委外加工单，委外加工单为：{ 供应商编码：123，生产订单号：1122，工艺BOM：12323:21223 - 1238:2128，工艺工序：T001:钻床 - 122:退火炉 }', '{\"newData\":{\"data\":[{\"id\":11,\"notice_id\":8,\"supplier_id\":1,\"process_bom_id\":58,\"process_bom_children_id\":75,\"ment\":\"无\",\"unit\":\"￥\",\"number\":600,\"price\":3,\"transaction_currency\":\"无1\",\"other_transaction_terms\":\"无2\",\"delivery_time\":\"2025-09-30\",\"remarks\":\"无\",\"status\":0,\"apply_id\":1,\"apply_name\":\"我是名字\",\"apply_time\":\"2025-09-26\",\"step\":1,\"supplier\":{\"id\":1,\"supplier_abbreviation\":\"2121\",\"supplier_code\":\"123\"},\"notice\":{\"id\":8,\"notice\":\"1122\",\"sale_id\":2,\"sale\":{\"id\":2,\"order_number\":\"15000\",\"unit\":\"件\",\"delivery_time\":\"2025-10-31\"}},\"processBom\":{\"id\":58,\"product_id\":14,\"part_id\":8,\"archive\":0,\"product\":{\"id\":14,\"product_name\":\"21223\",\"product_code\":\"12323\",\"drawing\":\"2121\",\"model\":\"wdd\",\"specification\":\"dwwdq\"},\"part\":{\"id\":8,\"part_name\":\"2128\",\"part_code\":\"1238\"}},\"processChildren\":{\"id\":75,\"process_bom_id\":58,\"process_id\":5,\"equipment_id\":4,\"time\":6,\"price\":8,\"process\":{\"id\":5,\"process_code\":\"T001\",\"process_name\":\"钻床\",\"section_points\":\"24.0\"},\"equipment\":{\"id\":4,\"equipment_code\":\"122\",\"equipment_name\":\"退火炉\"}},\"approval\":[{\"user_id\":4,\"user_name\":\"2132\",\"type\":\"outsourcing_order\",\"step\":1,\"company_id\":1,\"source_id\":11,\"user_time\":null,\"status\":1,\"id\":61},{\"user_id\":5,\"user_name\":\"哈哈\",\"type\":\"outsourcing_order\",\"step\":2,\"company_id\":1,\"source_id\":11,\"user_time\":null,\"status\":0,\"id\":62}]}],\"action\":2}}', '2025-09-26 07:46:59');
INSERT INTO `sub_operation_history` VALUES (50, 1, 5, '哈哈', 'approval', '采购单', '审批通过了采购单，采购单为：{ 供应商编码：1234，生产订单号：1122，产品编码：A001，材料编码：123 }', '{\"newData\":{\"data\":[{\"id\":4,\"company_id\":1,\"user_id\":1,\"notice_id\":8,\"notice\":\"1122\",\"supplier_id\":2,\"supplier_code\":\"1234\",\"supplier_abbreviation\":\"151\",\"product_id\":19,\"product_code\":\"A001\",\"product_name\":\"圆珠笔\",\"material_id\":2,\"material_code\":\"123\",\"material_name\":\"121\",\"model_spec\":\"2121/21\",\"other_features\":\"2121\",\"unit\":\"21\",\"price\":\"2.6\",\"order_number\":15000,\"number\":15000,\"delivery_time\":\"2025-10-31\",\"apply_id\":1,\"apply_name\":\"我是名字\",\"apply_time\":\"2025-09-26\",\"step\":0,\"status\":0,\"is_deleted\":1,\"created_at\":\"2025-09-26\",\"updated_at\":\"2025-09-26\",\"approval\":[{\"user_id\":5,\"user_name\":\"哈哈\",\"type\":\"purchase_order\",\"step\":1,\"company_id\":1,\"source_id\":4,\"user_time\":null,\"status\":0,\"id\":59},{\"user_id\":4,\"user_name\":\"2132\",\"type\":\"purchase_order\",\"step\":2,\"company_id\":1,\"source_id\":4,\"user_time\":null,\"status\":0,\"id\":60}]}],\"type\":\"purchase_order\"}}', '2025-09-26 07:49:50');
INSERT INTO `sub_operation_history` VALUES (51, 1, 5, '哈哈', 'approval', '采购单', '审批通过了采购单，采购单为：{ 供应商编码：1234，生产订单号：1122，产品编码：A001，材料编码：123 }，{ 供应商编码：1234，生产订单号：2222，产品编码：1233，材料编码：789 }', '{\"newData\":{\"data\":[{\"id\":4,\"company_id\":1,\"user_id\":1,\"notice_id\":8,\"notice\":\"1122\",\"supplier_id\":2,\"supplier_code\":\"1234\",\"supplier_abbreviation\":\"151\",\"product_id\":19,\"product_code\":\"A001\",\"product_name\":\"圆珠笔\",\"material_id\":2,\"material_code\":\"123\",\"material_name\":\"121\",\"model_spec\":\"2121/21\",\"other_features\":\"2121\",\"unit\":\"21\",\"price\":\"2.6\",\"order_number\":15000,\"number\":15000,\"delivery_time\":\"2025-10-31\",\"apply_id\":1,\"apply_name\":\"我是名字\",\"apply_time\":\"2025-09-26\",\"step\":1,\"status\":0,\"is_deleted\":1,\"created_at\":\"2025-09-26\",\"updated_at\":\"2025-09-26\",\"approval\":[{\"user_id\":5,\"user_name\":\"哈哈\",\"type\":\"purchase_order\",\"step\":1,\"company_id\":1,\"source_id\":4,\"user_time\":null,\"status\":1,\"id\":59},{\"user_id\":4,\"user_name\":\"2132\",\"type\":\"purchase_order\",\"step\":2,\"company_id\":1,\"source_id\":4,\"user_time\":null,\"status\":0,\"id\":60}]},{\"id\":3,\"company_id\":1,\"user_id\":1,\"notice_id\":6,\"notice\":\"2222\",\"supplier_id\":2,\"supplier_code\":\"1234\",\"supplier_abbreviation\":\"151\",\"product_id\":10,\"product_code\":\"1233\",\"product_name\":\"212\",\"material_id\":3,\"material_code\":\"789\",\"material_name\":\"555\",\"model_spec\":\"535/35353\",\"other_features\":\"353\",\"unit\":\"353\",\"price\":\"2.5\",\"order_number\":18000,\"number\":18000,\"delivery_time\":\"2025-07-07\",\"apply_id\":1,\"apply_name\":\"我是名字\",\"apply_time\":\"2025-09-23\",\"step\":0,\"status\":0,\"is_deleted\":1,\"created_at\":\"2025-09-23\",\"updated_at\":\"2025-09-23\",\"approval\":[{\"user_id\":5,\"user_name\":\"哈哈\",\"type\":\"purchase_order\",\"step\":1,\"company_id\":1,\"source_id\":3,\"user_time\":null,\"status\":0,\"id\":49},{\"user_id\":4,\"user_name\":\"2132\",\"type\":\"purchase_order\",\"step\":2,\"company_id\":1,\"source_id\":3,\"user_time\":null,\"status\":0,\"id\":50}]}],\"type\":\"purchase_order\"}}', '2025-09-26 07:50:08');
INSERT INTO `sub_operation_history` VALUES (52, 1, 1, '我是名字', 'add', '组织架构', '新增组织架构：岗位：后端，姓名：2132', '{\"newData\":{\"label\":\"后端\",\"menber_id\":4,\"pid\":1}}', '2025-09-26 08:02:14');
INSERT INTO `sub_operation_history` VALUES (53, 1, 5, '哈哈', 'inOut', '材料出入库', '出/入库了：', '{\"newData\":{\"data\":[22,27],\"action\":1,\"ware_id\":1}}', '2025-09-26 08:33:26');
INSERT INTO `sub_operation_history` VALUES (54, 1, 1, '我是名字', 'keyApproval', '材料出入库', '出/入库单提交审核：{ 仓库：小小部件，入库方式：生产入库，物料编码：12325 }', '{\"newData\":{\"data\":[{\"ware_id\":2,\"house_id\":7,\"house_name\":\"小小部件\",\"operate\":1,\"type\":10,\"plan_id\":\"\",\"plan\":\"\",\"item_id\":16,\"code\":\"12325\",\"name\":\"21225\",\"model_spec\":\"wdd/dwwdq\",\"other_features\":\"dwqwdw\",\"quantity\":\"56\",\"buy_price\":\"2\"}],\"type\":\"material_warehouse\"}}', '2025-09-26 08:50:27');
INSERT INTO `sub_operation_history` VALUES (55, 1, 5, '哈哈', 'approval', '成品出入库', '审批通过了出/入库单，它们有：{ 仓库：小小部件，入库方式：生产入库，物料编码：12325 }', '{\"newData\":{\"data\":[31],\"action\":1,\"ware_id\":2}}', '2025-09-26 09:12:59');
INSERT INTO `sub_operation_history` VALUES (56, 1, 4, '2132', 'approval', '成品出入库', '审批通过了出/入库单，它们有：{ 仓库：小小部件，入库方式：生产入库，物料编码：12325 }', '{\"newData\":{\"data\":[31],\"action\":1,\"ware_id\":2}}', '2025-09-26 09:13:12');
INSERT INTO `sub_operation_history` VALUES (57, 1, 5, '哈哈', 'approval', '成品出入库', '审批通过了出/入库单，它们有：{ 仓库：小小部件，入库方式：生产入库，物料编码：12325 }', '{\"newData\":{\"data\":[31],\"action\":1,\"ware_id\":2}}', '2025-09-26 09:16:47');
INSERT INTO `sub_operation_history` VALUES (58, 1, 1, '我是名字', 'keyApproval', '材料出入库', '出/入库单提交审核：{ 仓库：成品仓，入库方式：生产入库，物料编码：1234 }，{ 仓库：成品仓，入库方式：期初入库，物料编码：A001 }', '{\"newData\":{\"data\":[{\"ware_id\":3,\"house_id\":4,\"house_name\":\"成品仓\",\"operate\":1,\"type\":10,\"plan_id\":\"\",\"plan\":\"\",\"item_id\":11,\"code\":\"1234\",\"name\":\"12\",\"model_spec\":\"212/21\",\"other_features\":\"212\",\"quantity\":\"800\",\"buy_price\":\"2.4\"},{\"ware_id\":3,\"house_id\":4,\"house_name\":\"成品仓\",\"operate\":1,\"type\":11,\"plan_id\":\"\",\"plan\":\"\",\"item_id\":19,\"code\":\"A001\",\"name\":\"圆珠笔\",\"model_spec\":\"eeqqwq/sewww\",\"other_features\":\"ersdsd\",\"quantity\":\"300\",\"buy_price\":\"2.6\"}],\"type\":\"material_warehouse\"}}', '2025-09-26 09:25:53');
INSERT INTO `sub_operation_history` VALUES (59, 1, 5, '哈哈', 'approval', '成品出入库', '审批通过了出/入库单，它们有：{ 仓库：成品仓，入库方式：生产入库，物料编码：1234 }，{ 仓库：成品仓，入库方式：期初入库，物料编码：A001 }', '{\"newData\":{\"data\":[32,33],\"action\":1,\"ware_id\":3}}', '2025-09-26 09:26:17');
INSERT INTO `sub_operation_history` VALUES (60, 1, 4, '2132', 'approval', '成品出入库', '审批通过了出/入库单，它们有：{ 仓库：成品仓，入库方式：生产入库，物料编码：1234 }，{ 仓库：成品仓，入库方式：期初入库，物料编码：A001 }', '{\"newData\":{\"data\":[32,33],\"action\":1,\"ware_id\":3}}', '2025-09-26 09:26:29');
INSERT INTO `sub_operation_history` VALUES (61, 1, 1, '我是名字', 'update', '委外加工单', '修改委外加工单，供应商编码：123，生产订单号：1122，工艺BOM：12323:21223 - 1238:2128，工艺工序：T001:钻床 - 122:退火炉', '{\"newData\":{\"id\":11,\"notice_id\":8,\"supplier_id\":1,\"process_bom_id\":58,\"process_bom_children_id\":75,\"price\":3,\"number\":600,\"ment\":\"无\",\"unit\":\"￥\",\"transaction_currency\":\"无1\",\"other_transaction_terms\":\"无2\",\"remarks\":\"无\",\"delivery_time\":\"2025-09-30\"}}', '2025-09-26 13:28:46');
INSERT INTO `sub_operation_history` VALUES (62, 1, 1, '我是名字', 'keyApproval', '委外加工单', '委外加工单提交审核：{ 供应商编码：123，生产订单号：1122，工艺BOM：12323:21223 - 12312:21212，工艺工序： }，{ 供应商编码：123，生产订单号：1122，工艺BOM：12323:21223 - 1238:2128，工艺工序： }', '{\"newData\":{\"data\":[{\"notice_id\":8,\"supplier_id\":1,\"process_bom_id\":57,\"process_bom_children_id\":74,\"price\":\"21\",\"number\":\"21\",\"ment\":\"212\",\"unit\":\"21\",\"transaction_currency\":\"121\",\"other_transaction_terms\":\"2121\",\"remarks\":\"2121\",\"delivery_time\":\"2025-09-25\"},{\"notice_id\":8,\"supplier_id\":1,\"process_bom_id\":58,\"process_bom_children_id\":75,\"price\":3,\"number\":600,\"ment\":\"无\",\"unit\":\"￥\",\"transaction_currency\":\"无1\",\"other_transaction_terms\":\"无2\",\"remarks\":\"无\",\"delivery_time\":\"2025-09-30\",\"id\":11}],\"type\":\"outsourcing_order\"}}', '2025-09-26 13:29:06');
INSERT INTO `sub_operation_history` VALUES (63, 1, 1, '我是名字', 'update', '员工信息', '修改员工信息：工号：2，姓名：2', '{\"newData\":{\"id\":2,\"company_id\":1,\"user_id\":1,\"employee_id\":\"2\",\"name\":\"2\",\"cycle_id\":2,\"cycle_name\":\"设备组\",\"production_position\":\"23\",\"salary_attribute\":\"32\",\"remarks\":\"3\",\"is_deleted\":1,\"created_at\":\"2025-07-08\",\"updated_at\":\"2025-07-08\"}}', '2025-10-01 06:42:10');
INSERT INTO `sub_operation_history` VALUES (64, 1, 1, '我是名字', 'update', '员工信息', '修改员工信息：工号：1，姓名：1', '{\"newData\":{\"id\":1,\"company_id\":1,\"user_id\":1,\"employee_id\":\"1\",\"name\":\"1\",\"cycle_id\":3,\"cycle_name\":\"生产组\",\"production_position\":\"1\",\"salary_attribute\":\"1\",\"remarks\":\"1\",\"is_deleted\":1,\"created_at\":\"2025-07-08\",\"updated_at\":\"2025-08-12\"}}', '2025-10-01 06:42:15');
INSERT INTO `sub_operation_history` VALUES (65, 1, 1, '我是名字', 'add', '员工信息', '新增员工信息：工号：21，姓名：2121', '{\"newData\":{\"employee_id\":\"21\",\"name\":\"2121\",\"cycle_id\":2,\"cycle_name\":\"设备组\",\"production_position\":\"21\",\"salary_attribute\":\"2121\",\"remarks\":\"211\"}}', '2025-10-01 06:42:30');
INSERT INTO `sub_operation_history` VALUES (66, 1, 1, '我是名字', 'update', '员工信息', '修改员工信息：工号：21，姓名：2121', '{\"newData\":{\"id\":3,\"company_id\":1,\"employee_id\":\"21\",\"name\":\"2121\",\"cycle_id\":2,\"cycle_name\":\"设备组\",\"production_position\":\"21\",\"salary_attribute\":\"2121\",\"remarks\":\"211\",\"created_at\":\"2025-10-01\",\"account\":\"base1\",\"password\":\"123456\"}}', '2025-10-01 07:02:29');
INSERT INTO `sub_operation_history` VALUES (67, 1, 1, '我是名字', 'update', '员工信息', '修改员工信息：工号：2，姓名：2', '{\"newData\":{\"id\":2,\"company_id\":1,\"employee_id\":\"2\",\"name\":\"2\",\"cycle_id\":2,\"cycle_name\":\"设备组\",\"production_position\":\"23\",\"salary_attribute\":\"32\",\"remarks\":\"3\",\"created_at\":\"2025-07-08\",\"account\":\"base2\",\"password\":\"123456\"}}', '2025-10-01 07:03:01');
INSERT INTO `sub_operation_history` VALUES (68, 1, 1, '我是名字', 'add', '员工信息', '新增员工信息：工号：22，姓名：5445', '{\"newData\":{\"employee_id\":\"22\",\"name\":\"5445\",\"account\":\"base3\",\"password\":\"123456\",\"cycle_id\":2,\"cycle_name\":\"设备组\",\"production_position\":\"2121\",\"salary_attribute\":\"2121\",\"remarks\":\"21\"}}', '2025-10-01 07:05:57');
INSERT INTO `sub_operation_history` VALUES (69, 1, 1, '我是名字', 'update', '员工信息', '修改员工信息：工号：21，姓名：2121', '{\"newData\":{\"id\":3,\"company_id\":1,\"employee_id\":\"21\",\"name\":\"2121\",\"cycle_id\":2,\"cycle_name\":\"设备组\",\"production_position\":\"21\",\"salary_attribute\":\"2121\",\"remarks\":\"211\",\"created_at\":\"2025-10-01\",\"account\":\"base1\"}}', '2025-10-01 07:06:43');
INSERT INTO `sub_operation_history` VALUES (70, 1, 1, '我是名字', 'update', '员工信息', '修改员工信息：工号：21，姓名：2121', '{\"newData\":{\"id\":3,\"company_id\":1,\"employee_id\":\"21\",\"name\":\"2121\",\"cycle_id\":2,\"cycle_name\":\"设备组\",\"production_position\":\"21\",\"salary_attribute\":\"2121\",\"remarks\":\"211\",\"created_at\":\"2025-10-01\",\"account\":\"base1\",\"password\":\"123456\"}}', '2025-10-01 08:13:03');
INSERT INTO `sub_operation_history` VALUES (71, 1, 3, '2121', 'add', '移动端', '员工{ 2121 }报工数量：10', '{\"newData\":{\"number\":10,\"id\":\"71\",\"company_id\":\"1\"}}', '2025-10-02 03:36:50');
INSERT INTO `sub_operation_history` VALUES (72, 1, 3, '2121', 'add', '移动端', '员工{ 2121 }报工数量：10', '{\"newData\":{\"number\":10,\"id\":\"71\",\"company_id\":\"1\"}}', '2025-10-02 03:37:23');
INSERT INTO `sub_operation_history` VALUES (73, 1, 1, '我是名字', 'login', '登录', '用户{ 我是名字 }成功登录', '{\"newData\":{\"username\":\"admin1\",\"password\":\"***\"}}', '2025-10-05 03:01:51');
INSERT INTO `sub_operation_history` VALUES (74, 1, 1, '我是名字', 'login', '登录', '用户{ 我是名字 }成功登录', '{\"newData\":{\"username\":\"admin1\",\"password\":\"***\"}}', '2025-10-07 04:39:44');
INSERT INTO `sub_operation_history` VALUES (75, 1, 3, '2121', 'add', '移动端', '员工{ 2121 }报工数量：10', '{\"newData\":{\"number\":10,\"id\":\"71\",\"company_id\":\"1\"}}', '2025-10-07 05:42:01');
INSERT INTO `sub_operation_history` VALUES (76, 1, 3, '2121', 'add', '移动端', '员工{ 2121 }报工数量：10', '{\"newData\":{\"number\":10,\"id\":\"71\",\"company_id\":\"1\"}}', '2025-10-07 05:44:49');
INSERT INTO `sub_operation_history` VALUES (77, 1, 1, '我是名字', 'paichang', '生产通知单', '执行通知单排产，订单号：1122', '{\"newData\":8}', '2025-10-07 07:08:28');

-- ----------------------------
-- Table structure for sub_outsourcing_order
-- ----------------------------
DROP TABLE IF EXISTS `sub_outsourcing_order`;
CREATE TABLE `sub_outsourcing_order`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键ID',
  `company_id` int(11) NOT NULL COMMENT '企业id',
  `user_id` int(11) NOT NULL COMMENT '发布的用户id',
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
INSERT INTO `sub_outsourcing_order` VALUES (11, 1, 1, 8, 1, 58, 75, '￥', 3, 600, '无1', '无2', '无', '2025-09-30', '无', 0, 1, '我是名字', '2025-09-26 21:29:06', 0, 1, '2025-09-26 14:40:30', '2025-09-26 21:29:06');
INSERT INTO `sub_outsourcing_order` VALUES (12, 1, 1, 8, 1, 57, 74, '21', 21, 21, '121', '2121', '212', '2025-09-25', '2121', 0, 1, '我是名字', '2025-09-26 21:29:06', 0, 1, '2025-09-26 21:29:06', '2025-09-26 21:29:06');

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
  `process_bom_children_id` int(5) NULL DEFAULT NULL COMMENT '工艺BOM副表的id',
  `price` int(11) NULL DEFAULT NULL COMMENT '加工单价',
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
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '委外报价信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_outsourcing_quote
-- ----------------------------
INSERT INTO `sub_outsourcing_quote` VALUES (5, 1, 1, 8, 1, 57, 73, 3, 3, 15000, '￥', '无', NULL, '', 1, '2025-09-26 14:07:56', '2025-09-26 14:28:40');

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
  `unit_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '单价',
  `currency` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '币别',
  `production_requirements` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '生产要求',
  `remarks` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '备注',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '1：未删除；0：已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '记录创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '记录最后更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '部件编码基础信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_part_code
-- ----------------------------
INSERT INTO `sub_part_code` VALUES (5, 1, 1, 'C002', '笔芯', '212', '1212', '121', '3131', 31.00, '311', '3131', '3131', 1, '2025-07-08 15:35:24', '2025-08-21 15:46:13');
INSERT INTO `sub_part_code` VALUES (6, 1, 1, 'C001', '笔筒', '12', '1212', '1', '3131', 12.00, '21', '2121', '2121', 1, '2025-07-08 15:36:15', '2025-08-21 15:45:21');
INSERT INTO `sub_part_code` VALUES (7, 1, 1, '1234', '2124', '212', '1212', '121', '3131', 31.00, '311', '3131', '3131', 1, '2025-07-08 15:35:24', '2025-08-08 11:14:41');
INSERT INTO `sub_part_code` VALUES (8, 1, 1, '1238', '2128', '212', '1212', '121', '3131', 31.00, '311', '3131', '3131', 1, '2025-07-08 15:35:24', '2025-08-08 11:14:38');
INSERT INTO `sub_part_code` VALUES (9, 1, 1, '12310', '21210', '212', '1212', '121', '3131', 31.00, '311', '3131', '3131', 1, '2025-07-08 15:35:24', '2025-08-08 11:14:44');
INSERT INTO `sub_part_code` VALUES (10, 1, 1, '12311', '21211', '212', '1212', '121', '3131', 31.00, '311', '3131', '3131', 1, '2025-07-08 15:35:24', '2025-08-08 11:14:48');
INSERT INTO `sub_part_code` VALUES (12, 1, 1, '12312', '21212', '212', '1212', '121', '3131', 31.00, '311', '3131', '3131', 1, '2025-07-08 15:35:24', '2025-08-08 11:14:51');
INSERT INTO `sub_part_code` VALUES (13, 1, 1, '12313', '21213', '212', '1212', '121', '3131', 31.00, '311', '3131', '3131', 1, '2025-07-08 15:35:24', '2025-07-08 15:35:24');
INSERT INTO `sub_part_code` VALUES (14, 1, 1, '12314', '21214', '212', '1212', '121', '3131', 31.00, '311', '3131', '3131', 1, '2025-07-08 15:35:24', '2025-07-08 15:35:24');
INSERT INTO `sub_part_code` VALUES (15, 1, 1, '12315', '21215', '212', '1212', '121', '3131', 31.00, '311', '3131', '3131', 1, '2025-07-08 15:35:24', '2025-07-08 15:35:24');
INSERT INTO `sub_part_code` VALUES (16, 1, 1, '12316', '21216', '212', '1212', '121', '3131', 31.00, '311', '3131', '3131', 1, '2025-07-08 15:35:24', '2025-07-08 15:35:24');
INSERT INTO `sub_part_code` VALUES (17, 1, 1, '12317', '21217', '212', '1212', '121', '3131', 31.00, '311', '3131', '3131', 1, '2025-07-08 15:35:24', '2025-08-08 11:16:00');
INSERT INTO `sub_part_code` VALUES (18, 1, 1, '12318', '21218', '212', '1212', '121', '3131', 31.00, '311', '3131', '3131', 1, '2025-07-08 15:35:24', '2025-07-08 15:35:24');
INSERT INTO `sub_part_code` VALUES (19, 1, 1, '12319', '21219', '212', '1212', '121', '3131', 31.00, '311', '3131', '3131', 1, '2025-07-08 15:35:24', '2025-07-08 15:35:24');
INSERT INTO `sub_part_code` VALUES (20, 1, 1, '12320', '21220', '212', '1212', '121', '3131', 31.00, '311', '3131', '3131', 1, '2025-07-08 15:35:24', '2025-07-08 15:35:24');

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
) ENGINE = InnoDB AUTO_INCREMENT = 59 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '工艺BOM表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_process_bom
-- ----------------------------
INSERT INTO `sub_process_bom` VALUES (56, 1, 1, NULL, NULL, 19, 8, 0, 1, '2025-09-24 15:58:17', '2025-09-24 16:03:21');
INSERT INTO `sub_process_bom` VALUES (57, 1, 1, NULL, NULL, 14, 12, 0, 1, '2025-09-25 14:50:12', '2025-09-25 14:51:59');
INSERT INTO `sub_process_bom` VALUES (58, 1, 1, NULL, NULL, 14, 8, 0, 1, '2025-09-25 14:51:50', '2025-09-25 14:51:59');

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
  `all_time` decimal(11, 1) NULL DEFAULT NULL COMMENT '全部工时-H',
  `all_load` decimal(11, 1) NULL DEFAULT NULL COMMENT '每日负荷-H',
  `add_finish` int(11) NULL DEFAULT NULL COMMENT '累计完成',
  `order_number` int(11) NULL DEFAULT NULL COMMENT '订单尾数',
  `qr_code` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '二维码',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 76 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '工艺BOM表子表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_process_bom_child
-- ----------------------------
INSERT INTO `sub_process_bom_child` VALUES (71, NULL, NULL, NULL, 56, 5, 4, 1, 8, 2, 33.3, NULL, 50, 15000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/7e081466-1421-4fcb-ad52-2164378ceb55.png', '2025-09-24 15:58:17', '2025-10-07 15:08:28');
INSERT INTO `sub_process_bom_child` VALUES (72, NULL, NULL, NULL, 56, 6, 3, 2, 9, 2, 37.5, NULL, NULL, 15000, 'http://cdn.yuanfangzixun.com.cn/qrcodes/363b2db6-40f9-4d98-b7aa-9dc97b33327a.png', '2025-09-24 15:58:17', '2025-09-24 16:03:50');
INSERT INTO `sub_process_bom_child` VALUES (73, NULL, NULL, NULL, 57, 5, 5, 1, 8, 2, NULL, NULL, NULL, NULL, 'http://cdn.yuanfangzixun.com.cn/qrcodes/478e261e-327e-41b5-ab9b-6e5840980e00.png', '2025-09-25 14:50:12', '2025-09-25 14:50:12');
INSERT INTO `sub_process_bom_child` VALUES (74, NULL, NULL, NULL, 57, 6, 5, 2, 6, 8, NULL, NULL, NULL, NULL, 'http://cdn.yuanfangzixun.com.cn/qrcodes/d48ac941-c764-49a3-9914-cc6cf9af32e6.png', '2025-09-25 14:50:12', '2025-09-25 14:50:12');
INSERT INTO `sub_process_bom_child` VALUES (75, NULL, NULL, NULL, 58, 5, 4, 1, 6, 8, NULL, NULL, NULL, NULL, 'http://cdn.yuanfangzixun.com.cn/qrcodes/dc9ac27b-7a9b-4f7f-8ce2-89094ae5ca61.png', '2025-09-25 14:51:50', '2025-09-25 14:51:50');

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
  `time` varchar(5) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '单件工时(小时)',
  `price` decimal(10, 1) NULL DEFAULT NULL COMMENT '加工单价',
  `section_points` decimal(11, 1) NULL DEFAULT NULL COMMENT '段数点数',
  `total_processing_price` decimal(10, 1) NULL DEFAULT NULL COMMENT '加工总价',
  `remarks` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '备注',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '1：未删除；0：已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '记录创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '记录最后更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '工艺编码基础信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_process_code
-- ----------------------------
INSERT INTO `sub_process_code` VALUES (3, 1, 1, 3, '123', '212', '21', 2121.0, 21.0, 21.0, '212', 0, '2025-07-08 15:56:54', '2025-09-24 15:45:55');
INSERT INTO `sub_process_code` VALUES (4, 1, 1, 4, '2222', '111', '3131', 21.0, 213.0, 3131.0, '3131', 0, '2025-08-09 16:07:09', '2025-09-24 15:45:54');
INSERT INTO `sub_process_code` VALUES (5, 1, 1, 5, 'T001', '钻床', '8', 1.6, 24.0, 2.9, '无', 1, '2025-09-24 15:48:02', '2025-09-24 15:52:18');
INSERT INTO `sub_process_code` VALUES (6, 1, 1, 4, 'T002', '打点', '9', 1.4, 17.0, 2.5, '', 1, '2025-09-24 15:53:42', '2025-09-24 15:53:42');

-- ----------------------------
-- Table structure for sub_process_cycle
-- ----------------------------
DROP TABLE IF EXISTS `sub_process_cycle`;
CREATE TABLE `sub_process_cycle`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键ID',
  `company_id` int(11) NOT NULL COMMENT '企业id，关联企业信息表',
  `user_id` int(11) NOT NULL COMMENT '发布的用户id，关联用户表',
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '制程名称',
  `sort_date` int(5) NULL DEFAULT NULL COMMENT '最短交货时间',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '制程组列表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_process_cycle
-- ----------------------------
INSERT INTO `sub_process_cycle` VALUES (1, 1, 1, '备料组', 3, 1, '2025-08-21 09:30:12', '2025-09-04 15:45:29');
INSERT INTO `sub_process_cycle` VALUES (2, 1, 1, '设备组', 4, 1, '2025-08-21 09:30:39', '2025-09-04 15:46:36');
INSERT INTO `sub_process_cycle` VALUES (3, 1, 1, '生产组', 5, 1, '2025-08-21 09:30:45', '2025-09-04 15:45:43');

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
) ENGINE = InnoDB AUTO_INCREMENT = 256 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sub_process_cycle_child
-- ----------------------------
INSERT INTO `sub_process_cycle_child` VALUES (253, 1, 225, NULL, NULL, NULL, '2025-10-07 15:08:28', '2025-10-07 15:08:28');
INSERT INTO `sub_process_cycle_child` VALUES (254, 2, 225, NULL, NULL, NULL, '2025-10-07 15:08:28', '2025-10-07 15:08:28');
INSERT INTO `sub_process_cycle_child` VALUES (255, 3, 225, NULL, NULL, NULL, '2025-10-07 15:08:28', '2025-10-07 15:08:28');

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
  `unit_price` int(10) NULL DEFAULT NULL COMMENT '产品的单价',
  `currency` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '产品价格的币别',
  `production_requirements` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '产品的生产要求',
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '1：未删除；0：已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '记录创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '记录最后更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '产品编码基础信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_product_code
-- ----------------------------
INSERT INTO `sub_product_code` VALUES (9, 1, 1, '123', '113', '图只可以', '21', '2131', '3131', '1313', '212', 1212, '121', '21', 1, '2025-07-08 15:02:27', '2025-07-14 10:04:36');
INSERT INTO `sub_product_code` VALUES (10, 1, 1, '1233', '212', '月1', '121', '2121', '2121', '21', '212', 121, '21', '2121', 1, '2025-07-08 15:12:29', '2025-07-14 10:04:29');
INSERT INTO `sub_product_code` VALUES (11, 1, 1, '1234', '12', '121', '212', '21', '212', '211', '1212', 2212, '1212', '121', 1, '2025-07-15 11:04:40', '2025-07-15 11:12:37');
INSERT INTO `sub_product_code` VALUES (12, 1, 1, '12321', '21221', '2121', 'wdd', 'dwwdq', 'dwqwdw', 'qdwq', 'qw', 212, '211', '2121', 1, '2025-08-08 11:19:00', '2025-08-08 11:19:00');
INSERT INTO `sub_product_code` VALUES (13, 1, 1, '12322', '21222', '2121', 'wdd', 'dwwdq', 'dwqwdw', 'qdwq', 'qw', 212, '211', '2121', 1, '2025-08-08 11:23:21', '2025-08-08 14:44:31');
INSERT INTO `sub_product_code` VALUES (14, 1, 1, '12323', '21223', '2121', 'wdd', 'dwwdq', 'dwqwdw', 'qdwq', 'qw', 212, '211', '2121', 1, '2025-08-08 11:28:28', '2025-08-08 11:28:28');
INSERT INTO `sub_product_code` VALUES (15, 1, 1, '12324', '21224', '2121', 'wdd', 'dwwdq', 'dwqwdw', 'qdwq', 'qw', 212, '211', '2121', 1, '2025-08-08 11:34:57', '2025-08-08 11:34:57');
INSERT INTO `sub_product_code` VALUES (16, 1, 1, '12325', '21225', '2121', 'wdd', 'dwwdq', 'dwqwdw', 'qdwq', 'qw', 212, '211', '2121', 1, '2025-08-08 11:35:22', '2025-08-08 14:09:03');
INSERT INTO `sub_product_code` VALUES (17, 1, 1, '12671', '4841', 'eewqw', 'ewe', 'rwrw', 'rww', 'qeqeq', 'eqwew', 323, '21', '31', 1, '2025-08-08 11:36:50', '2025-08-08 11:36:50');
INSERT INTO `sub_product_code` VALUES (18, 1, 1, '43456', '2345', '23', '423', '42', 'ewf', '5', '3553', 21, '313', '12', 0, '2025-08-08 14:10:41', '2025-08-08 14:58:55');
INSERT INTO `sub_product_code` VALUES (19, 1, 1, 'A001', '圆珠笔', 'qqqwe', 'eeqqwq', 'sewww', 'ersdsd', 'ewww', 'ff', 22, '3rr', 'rww', 1, '2025-08-10 10:09:09', '2025-08-21 15:44:55');

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
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '生产通知单信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_product_notice
-- ----------------------------
INSERT INTO `sub_product_notice` VALUES (8, 1, 1, '1122', 2, 19, 2, '2025-10-15', 0, 1, '2025-09-24 15:56:38', '2025-09-24 16:03:50');

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
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '产品报价表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_product_quotation
-- ----------------------------
INSERT INTO `sub_product_quotation` VALUES (11, 1, 1, 2, 2, 9, '111', '111', '111', '111', 1, '2025-07-25 22:44:22', '2025-07-25 22:44:22');
INSERT INTO `sub_product_quotation` VALUES (12, 1, 1, 1, 3, 10, '222', '222', '222', '222', 1, '2025-07-25 22:44:29', '2025-07-25 22:44:29');

-- ----------------------------
-- Table structure for sub_production_notice
-- ----------------------------
DROP TABLE IF EXISTS `sub_production_notice`;
CREATE TABLE `sub_production_notice`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `company_id` int(11) NULL DEFAULT NULL COMMENT '企业ID',
  `notice_id` int(11) NULL DEFAULT NULL COMMENT '生产订单ID',
  `notice` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生产订单号',
  `customer_id` int(11) NULL DEFAULT NULL COMMENT '客户ID',
  `product_id` int(11) NULL DEFAULT NULL COMMENT '产品ID',
  `rece_time` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '接单日期',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '记录创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '记录最后更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '进度表列表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sub_production_notice
-- ----------------------------
INSERT INTO `sub_production_notice` VALUES (1, 1, 8, '1122', 2, 19, '2025-07-10', '2025-10-07 15:08:28', '2025-10-07 15:08:28');

-- ----------------------------
-- Table structure for sub_production_progress
-- ----------------------------
DROP TABLE IF EXISTS `sub_production_progress`;
CREATE TABLE `sub_production_progress`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键ID',
  `company_id` int(11) NOT NULL COMMENT '企业id',
  `user_id` int(11) NOT NULL COMMENT '发布的用户id',
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
  `is_deleted` int(1) NULL DEFAULT 1 COMMENT '是否删除：1-未删除，0-已删除',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 226 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '生产进度表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_production_progress
-- ----------------------------
INSERT INTO `sub_production_progress` VALUES (225, 1, 1, '1122', '2025-10-15', '惠州饮料厂', 19, 'A001', '圆珠笔', 'qqqwe', 8, '1238', '2128', 56, 15000, 'hui11111111', '2025-07-10', 15000, NULL, NULL, 1, '2025-10-07 15:08:28', '2025-10-07 15:08:28');

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
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '员工计件工资表' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '销售订单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_sales_order
-- ----------------------------
INSERT INTO `sub_sales_order` VALUES (1, 1, 1, '2025-07-07', 3, 'G2222222', 10, '我的要求', '18000', 313, '个', '2025-07-07', '2025-07-27', '大朗镇', 1, '2025-07-14 13:55:51', '2025-09-03 09:43:29');
INSERT INTO `sub_sales_order` VALUES (2, 1, 1, '2025-07-10', 2, 'hui11111111', 19, '无要求', '15000', 2121, '件', '2025-10-31', '2025-07-14', '寮步镇', 1, '2025-07-14 18:47:31', '2025-09-03 09:43:20');

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
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '供应商信息信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_supplier_info
-- ----------------------------
INSERT INTO `sub_supplier_info` VALUES (1, 1, 1, '123', '2121', '13', '15', '1515', '212', '5151', '15', '15151', '1515', '15', 1, '2025-07-10 00:03:15', '2025-07-10 00:03:15');
INSERT INTO `sub_supplier_info` VALUES (2, 1, 1, '1234', '151', '153333333', '1', '515', '155', '511', '515', '15', '1', '515', 1, '2025-07-10 00:03:27', '2025-07-10 00:03:37');

-- ----------------------------
-- Table structure for sub_warehouse_apply
-- ----------------------------
DROP TABLE IF EXISTS `sub_warehouse_apply`;
CREATE TABLE `sub_warehouse_apply`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `user_id` int(11) NOT NULL COMMENT '发布的用户id',
  `company_id` int(11) NOT NULL COMMENT '所属企业id',
  `ware_id` int(11) NULL DEFAULT NULL COMMENT '仓库类型ID 1材料2成品',
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
) ENGINE = InnoDB AUTO_INCREMENT = 34 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '出库入库申请表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sub_warehouse_apply
-- ----------------------------
INSERT INTO `sub_warehouse_apply` VALUES (17, 1, 1, 1, 6, 1, 4, '材料仓', 1, '2121', 3, '789', '555', '535/35353', NULL, 574, 2.1, 1205.4, 1, '我是名字', '2025-09-19 13:18:25', 0, 0, 1, '2025-09-19 21:18:25', '2025-09-21 17:03:37');
INSERT INTO `sub_warehouse_apply` VALUES (18, 1, 1, 1, 6, 1, 4, '材料仓', 2, '151', 2, '123', '121', '2121/21', NULL, 475, 1.8, 855.0, 1, '我是名字', '2025-09-20 11:59:29', 0, 0, 1, '2025-09-19 21:18:25', '2025-09-20 19:59:29');
INSERT INTO `sub_warehouse_apply` VALUES (19, 1, 1, 1, 6, 1, 4, '材料仓', 2, '151', 3, '789', '555', '535/35353', NULL, 502, 2.5, 1255.0, 1, '我是名字', '2025-09-19 13:18:25', 0, 0, 1, '2025-09-19 21:18:25', '2025-09-21 17:03:38');
INSERT INTO `sub_warehouse_apply` VALUES (20, 1, 1, 1, 6, 1, 4, '材料仓', 2, '151', 2, '123', '121', '2121/21', NULL, 645, 2.4, 1548.0, 1, '我是名字', '2025-09-19 13:18:25', 0, 0, 1, '2025-09-19 21:18:25', '2025-09-19 21:18:25');
INSERT INTO `sub_warehouse_apply` VALUES (21, 1, 1, 1, 6, 1, 4, '材料仓', 2, '151', 3, '789', '555', '535/35353', NULL, 236, 1.9, 448.4, 1, '我是名字', '2025-09-19 13:52:27', 0, 0, 1, '2025-09-19 21:52:27', '2025-09-21 17:03:40');
INSERT INTO `sub_warehouse_apply` VALUES (22, 1, 1, 1, 6, 1, 4, '材料仓', 1, '2121', 3, '789', '555', '535/35353', NULL, 222, 2.5, 555.0, 1, '我是名字', '2025-09-19 13:52:27', 1, 0, 1, '2025-09-19 21:52:27', '2025-09-26 16:33:26');
INSERT INTO `sub_warehouse_apply` VALUES (23, 1, 1, 1, 6, 1, 4, '材料仓', 2, '151', 2, '123', '121', '2121/21', NULL, 600, 2.1, 1260.0, 1, '我是名字', '2025-09-20 11:53:35', 2, 1, 1, '2025-09-20 19:53:35', '2025-09-21 17:20:30');
INSERT INTO `sub_warehouse_apply` VALUES (25, 1, 1, 1, 6, 1, 4, '材料仓', 2, '151', 3, '789', '555', '535/35353', NULL, 400, 1.9, 760.0, 1, '我是名字', '2025-09-20 12:00:01', 2, 1, 1, '2025-09-20 20:00:01', '2025-09-21 17:20:30');
INSERT INTO `sub_warehouse_apply` VALUES (26, 1, 1, 1, 6, 1, 4, '材料仓', 1, '2121', 3, '789', '555', '535/35353', NULL, 632, 2.0, 1264.0, 1, '我是名字', '2025-09-20 12:00:01', 2, 1, 1, '2025-09-20 20:00:01', '2025-09-21 17:20:30');
INSERT INTO `sub_warehouse_apply` VALUES (27, 1, 1, 1, 6, 1, 4, '材料仓', 2, '151', 3, '789', '555', '535/35353', NULL, 615, 1.9, 1168.5, 1, '我是名字', '2025-09-21 08:52:36', 1, 0, 1, '2025-09-21 16:52:36', '2025-09-26 16:32:55');
INSERT INTO `sub_warehouse_apply` VALUES (28, 1, 1, 1, 6, 1, 4, '材料仓', 1, '2121', 3, '789', '555', '535/35353', '353', 158, 2.6, 410.8, 1, '我是名字', '2025-09-21 08:56:51', 1, 0, 1, '2025-09-21 16:56:51', '2025-09-26 16:32:55');
INSERT INTO `sub_warehouse_apply` VALUES (29, 1, 1, 1, 6, 1, 4, '材料仓', 1, '2121', 3, '789', '555', '535/35353', '353', 22, 12.0, 264.0, 1, '我是名字', '2025-09-26 16:32:19', 0, 0, 1, '2025-09-26 16:32:19', '2025-09-26 16:32:19');
INSERT INTO `sub_warehouse_apply` VALUES (32, 1, 1, 3, 4, 1, 10, '成品仓', NULL, '', 11, '1234', '12', '212/21', '212', 800, 2.4, 1920.0, 1, '我是名字', '2025-09-26 17:25:53', 2, 1, 1, '2025-09-26 17:25:53', '2025-09-26 17:26:29');
INSERT INTO `sub_warehouse_apply` VALUES (33, 1, 1, 3, 4, 1, 11, '成品仓', NULL, '', 19, 'A001', '圆珠笔', 'eeqqwq/sewww', 'ersdsd', 300, 2.6, 780.0, 1, '我是名字', '2025-09-26 17:25:53', 2, 1, 1, '2025-09-26 17:25:53', '2025-09-26 17:26:29');

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
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '仓库列表数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sub_warehouse_content
-- ----------------------------
INSERT INTO `sub_warehouse_content` VALUES (3, 4, 1, 1, 6, 3, '789', '555', '535/35353', '353', '', '', 0, 400, 0, 400, 0.0, 0.0, 0.0, 0.0, '2025-09-21 17:20:30', NULL, 1, '2025-09-21 17:17:24', '2025-09-22 14:17:05');
INSERT INTO `sub_warehouse_content` VALUES (4, 1, 1, 1, 6, 2, '123', '121', '2121/21', NULL, '', '件', 0, 600, 0, 600, 2.8, 1680.0, 0.0, 0.0, '2025-09-21 17:20:30', NULL, 1, '2025-09-21 17:20:30', '2025-09-22 17:03:58');
INSERT INTO `sub_warehouse_content` VALUES (6, 4, 1, 3, 4, 11, '1234', '12', '212/21', '212', '', '', 0, 800, 0, 800, 0.0, 0.0, 0.0, 0.0, '2025-09-26 17:26:29', NULL, 1, '2025-09-26 17:26:29', '2025-09-26 17:26:29');
INSERT INTO `sub_warehouse_content` VALUES (7, 4, 1, 3, 4, 19, 'A001', '圆珠笔', 'eeqqwq/sewww', 'ersdsd', '', '', 300, 0, 0, 300, 0.0, 0.0, 0.0, 0.0, '2025-09-26 17:26:29', NULL, 1, '2025-09-26 17:26:29', '2025-09-26 17:26:29');

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
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '仓库名列表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sub_warehouse_cycle
-- ----------------------------
INSERT INTO `sub_warehouse_cycle` VALUES (4, 1, 1, 3, '成品仓', 1, '2025-08-23 09:35:08', '2025-09-09 10:21:59');
INSERT INTO `sub_warehouse_cycle` VALUES (5, 1, 1, 2, '半成品仓', 1, '2025-08-23 09:35:27', '2025-09-09 10:21:55');
INSERT INTO `sub_warehouse_cycle` VALUES (6, 1, 1, 1, '材料仓', 1, '2025-08-23 09:35:34', '2025-09-09 10:20:20');
INSERT INTO `sub_warehouse_cycle` VALUES (7, 1, 1, 2, '小小部件', 1, '2025-09-16 13:01:10', '2025-09-16 13:01:10');

SET FOREIGN_KEY_CHECKS = 1;
