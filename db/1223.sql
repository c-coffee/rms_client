CREATE DATABASE  IF NOT EXISTS `reagent_db` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `reagent_db`;
-- MySQL dump 10.13  Distrib 5.7.12, for Win64 (x86_64)
--
-- Host: localhost    Database: reagent_db
-- ------------------------------------------------------
-- Server version	5.7.16-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `application`
--

DROP TABLE IF EXISTS `application`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `application` (
  `appID` int(11) NOT NULL AUTO_INCREMENT COMMENT '申领表ID',
  `appUserID` int(11) DEFAULT NULL COMMENT '申领用户ID',
  `appDatetime` datetime DEFAULT NULL COMMENT '申领时间',
  `hasDanger` tinyint(4) DEFAULT NULL COMMENT '是否包含申领易制毒、易制爆等危险物品 1: 有 0:没有',
  `approverID` int(11) DEFAULT NULL COMMENT '批准人ID',
  `approverDatetime` datetime DEFAULT NULL COMMENT '批准时间',
  `approveReason` varchar(45) DEFAULT NULL COMMENT '批准/拒绝 理由',
  `outStockID` int(11) DEFAULT NULL COMMENT '试剂发放环节，出库单ID',
  `reagentManagerID` int(11) DEFAULT NULL COMMENT '药剂管理员ID',
  `stepID` int(11) DEFAULT NULL,
  `deptID` int(11) DEFAULT NULL COMMENT '申请单所属部门ID',
  PRIMARY KEY (`appID`),
  KEY `FK_application_userID_idx` (`appUserID`),
  KEY `FK_application_stepID_idx` (`stepID`),
  KEY `FK_application_deptID_idx` (`deptID`),
  CONSTRAINT `FK_application_deptID` FOREIGN KEY (`deptID`) REFERENCES `department` (`deptID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_application_stepID` FOREIGN KEY (`stepID`) REFERENCES `steplist` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_application_userID` FOREIGN KEY (`appUserID`) REFERENCES `user` (`userID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='试剂申领表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `application`
--

LOCK TABLES `application` WRITE;
/*!40000 ALTER TABLE `application` DISABLE KEYS */;
INSERT INTO `application` VALUES (1,1,'2019-12-13 00:00:00',0,NULL,NULL,NULL,NULL,NULL,5,4),(2,1,'2019-12-13 00:00:00',1,1,NULL,'采用其它试剂替代',NULL,NULL,4,4),(3,1,'2019-12-13 00:00:00',0,NULL,NULL,NULL,NULL,NULL,1,4);
/*!40000 ALTER TABLE `application` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applicationdetail`
--

DROP TABLE IF EXISTS `applicationdetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `applicationdetail` (
  `appDetailID` int(11) NOT NULL AUTO_INCREMENT COMMENT '标识ID',
  `appID` int(11) DEFAULT NULL COMMENT '申领单ID\n',
  `reagentID` int(11) DEFAULT NULL COMMENT '试剂ID\n',
  `appNum` int(11) DEFAULT NULL,
  `remark` varchar(100) DEFAULT NULL COMMENT '其它备注要求',
  `state` int(11) DEFAULT '0' COMMENT '申领试剂状态 0：未发放 1：已发放 2:已收取  3:已退回  4: 申购中',
  `appSpec` varchar(45) DEFAULT NULL COMMENT '申领试剂规格',
  `appPurity` varchar(45) DEFAULT NULL COMMENT '申领试剂纯度',
  `providerNum` int(11) DEFAULT NULL COMMENT '试剂管理员发放数量',
  `providerSpec` varchar(45) DEFAULT NULL COMMENT '实际发放试剂规格',
  `provideDatetime` datetime DEFAULT NULL COMMENT '试剂管理员通知申请人员可以领取的时间',
  `receiveDatetime` datetime DEFAULT NULL COMMENT '申请人员领取成功时间',
  PRIMARY KEY (`appDetailID`),
  KEY `FK_appDetail_appID_idx` (`appID`),
  KEY `FK_appDetail_reagentID_idx` (`reagentID`),
  CONSTRAINT `FK_appDetail_appID` FOREIGN KEY (`appID`) REFERENCES `application` (`appID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_appDetail_reagentID` FOREIGN KEY (`reagentID`) REFERENCES `reagentinfo` (`reagentID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COMMENT='试剂申领表明细';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applicationdetail`
--

LOCK TABLES `applicationdetail` WRITE;
/*!40000 ALTER TABLE `applicationdetail` DISABLE KEYS */;
INSERT INTO `applicationdetail` VALUES (5,3,8,3,NULL,0,'AR500ml','分析纯',NULL,NULL,NULL,NULL),(8,1,1,1,NULL,1,'100L','分析纯',NULL,NULL,NULL,NULL),(9,1,9,2,'厂家甲乙丙',1,'0.1g','/',NULL,NULL,NULL,NULL),(10,2,8,1,NULL,0,'AR500ml','分析纯',NULL,NULL,NULL,NULL),(11,2,5,1,NULL,0,'JA10001','/',NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `applicationdetail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department`
--

DROP TABLE IF EXISTS `department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `department` (
  `deptID` int(11) NOT NULL AUTO_INCREMENT,
  `deptName` varchar(45) DEFAULT NULL COMMENT '部门名称',
  `state` tinyint(4) DEFAULT '1' COMMENT '数据状态：0 删除(不可用)  1 可用',
  PRIMARY KEY (`deptID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COMMENT='部门信息设置';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department`
--

LOCK TABLES `department` WRITE;
/*!40000 ALTER TABLE `department` DISABLE KEYS */;
INSERT INTO `department` VALUES (1,'检验一室',1),(2,'检验二室',1),(3,'检验三室',1),(4,'业务室',1),(5,'综合科',1),(6,'所长办',1);
/*!40000 ALTER TABLE `department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `deptstockdetail`
--

DROP TABLE IF EXISTS `deptstockdetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `deptstockdetail` (
  `dsdID` int(11) NOT NULL AUTO_INCREMENT COMMENT '标识ID',
  `reagentID` int(11) DEFAULT NULL COMMENT '试剂ID',
  `reagentNum` decimal(8,2) DEFAULT NULL COMMENT '出入库数量',
  `remark` varchar(45) DEFAULT NULL COMMENT '备注',
  `reagentSpec` varchar(45) DEFAULT NULL COMMENT '出入库试剂规格',
  `reagentPurity` varchar(45) DEFAULT NULL COMMENT '出入库试剂纯度',
  `direction` varchar(45) DEFAULT NULL COMMENT '出入库方向（入库 in   出库 out）',
  `opID` int(11) DEFAULT NULL COMMENT '操作ID  申领入库，退回出库等 对应操作的ID\n',
  `opName` varchar(45) DEFAULT NULL COMMENT '操作名称   申领出库，退回入库，进货入库等',
  `opDatetime` datetime DEFAULT NULL COMMENT '操作日期',
  `userID` int(11) DEFAULT NULL COMMENT '相关操作执行用户ID',
  PRIMARY KEY (`dsdID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='科室库存出入库详情表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deptstockdetail`
--

LOCK TABLES `deptstockdetail` WRITE;
/*!40000 ALTER TABLE `deptstockdetail` DISABLE KEYS */;
/*!40000 ALTER TABLE `deptstockdetail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `deptstocks`
--

DROP TABLE IF EXISTS `deptstocks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `deptstocks` (
  `deptStocksID` int(11) NOT NULL AUTO_INCREMENT COMMENT '部门库存ID',
  `reagentID` int(11) DEFAULT NULL COMMENT '部门库存试剂ID',
  `reagentNum` decimal(8,2) DEFAULT NULL COMMENT '部门库存试剂数量',
  `initialNum` decimal(8,2) DEFAULT NULL COMMENT '部门初始库存量',
  `deptStocksSpec` varchar(45) DEFAULT NULL,
  `deptStocksPurity` varchar(45) DEFAULT NULL,
  `deptID` int(11) DEFAULT NULL COMMENT '科室ID',
  PRIMARY KEY (`deptStocksID`),
  KEY `FK_deptStocks_reagentID_idx` (`reagentID`),
  KEY `FK_deptStocks_purity_idx` (`deptStocksPurity`),
  CONSTRAINT `FK_deptStocks_purity` FOREIGN KEY (`deptStocksPurity`) REFERENCES `purity` (`purityName`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_deptStocks_reagentID` FOREIGN KEY (`reagentID`) REFERENCES `reagentinfo` (`reagentID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='部门库存信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deptstocks`
--

LOCK TABLES `deptstocks` WRITE;
/*!40000 ALTER TABLE `deptstocks` DISABLE KEYS */;
/*!40000 ALTER TABLE `deptstocks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `module`
--

DROP TABLE IF EXISTS `module`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `module` (
  `moduleID` int(11) NOT NULL AUTO_INCREMENT COMMENT '模块ID',
  `moduleName` varchar(45) DEFAULT NULL COMMENT '模块名称',
  `moduleInfo` varchar(100) DEFAULT NULL COMMENT '模块描述',
  `parent_moduleID` int(11) DEFAULT NULL COMMENT '父模块ID',
  `state` tinyint(4) DEFAULT '1',
  PRIMARY KEY (`moduleID`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COMMENT='模块表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `module`
--

LOCK TABLES `module` WRITE;
/*!40000 ALTER TABLE `module` DISABLE KEYS */;
INSERT INTO `module` VALUES (1,'基础设置','BaseSet',0,1),(2,'科室设置','DepartmentSet',1,1),(3,'类型设置','ReagentTypeSet',1,1),(4,'性状设置','ReagentStateSet',1,1),(5,'危化类别','DangerTypeSet',1,1),(6,'模块管理','ModuleSet',1,1),(7,'纯度设置','PuritySet',1,1),(8,'数据管理','DataManage',0,1),(9,'供应商','SupplierManage',8,1),(10,'试剂管理','ReagentInfoManage',8,1),(11,'库存管理','ReagentStockManage',8,1),(12,'角色管理','RoleManage',8,1),(13,'用户管理','UserManage',8,1);
/*!40000 ALTER TABLE `module` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order`
--

DROP TABLE IF EXISTS `order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order` (
  `orderID` int(11) NOT NULL AUTO_INCREMENT COMMENT '申购/采购表 ID',
  `applyOrderUserID` int(11) DEFAULT NULL COMMENT '申购人员ID',
  `applyOrderTime` datetime DEFAULT NULL COMMENT '申购时间',
  `orderUserID` int(11) DEFAULT NULL COMMENT '订购人员ID',
  `orderTime` datetime DEFAULT NULL COMMENT '订购时间',
  `approveUserID` int(11) DEFAULT NULL COMMENT '采购批准人ID',
  `approveTime` datetime DEFAULT NULL COMMENT '批准时间',
  `price` decimal(10,2) DEFAULT NULL COMMENT '采购单总价',
  `orderState` int(11) DEFAULT NULL COMMENT '订单状态\n1.申购准备 2.提请申购 3.采购询价 4.采购审核 5.采购中 6.采购完成 7.采购驳回',
  `stepID` int(11) DEFAULT NULL,
  `applyRejectReason` varchar(200) DEFAULT NULL COMMENT '申购驳回原因',
  `orderRejectReason` varchar(200) DEFAULT NULL COMMENT '采购驳回原因',
  PRIMARY KEY (`orderID`),
  KEY `FK_order_applyOrderUserID_idx` (`applyOrderUserID`),
  KEY `FK_order_orderUserID_idx` (`orderUserID`),
  KEY `FK_order_approveUserID_idx` (`approveUserID`),
  KEY `FK_order_stepID_idx` (`stepID`),
  CONSTRAINT `FK_order_applyOrderUserID` FOREIGN KEY (`applyOrderUserID`) REFERENCES `user` (`userID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_order_approveUserID` FOREIGN KEY (`approveUserID`) REFERENCES `user` (`userID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_order_orderUserID` FOREIGN KEY (`orderUserID`) REFERENCES `user` (`userID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_order_stepID` FOREIGN KEY (`stepID`) REFERENCES `steplist` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order`
--

LOCK TABLES `order` WRITE;
/*!40000 ALTER TABLE `order` DISABLE KEYS */;
INSERT INTO `order` VALUES (1,1,'2019-12-13 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,15,NULL,'供应商资质不全'),(4,1,'2019-12-13 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,16,NULL,'重新选择供应商');
/*!40000 ALTER TABLE `order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orderdetail`
--

DROP TABLE IF EXISTS `orderdetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orderdetail` (
  `orderDetailID` int(11) NOT NULL AUTO_INCREMENT COMMENT '订单项ID',
  `orderID` int(11) DEFAULT NULL COMMENT '订单ID',
  `reagentID` int(11) DEFAULT NULL COMMENT '试剂ID',
  `orderNum` decimal(8,2) DEFAULT NULL COMMENT '订购试剂数量',
  `supplierID` int(11) DEFAULT NULL COMMENT '供应商ID',
  `price` decimal(8,2) DEFAULT NULL COMMENT '供应商价格',
  `remark` varchar(100) DEFAULT NULL COMMENT '备注',
  `orderSpec` varchar(45) DEFAULT NULL COMMENT '申购，订购 规格',
  `orderPurity` varchar(45) DEFAULT NULL COMMENT '申购订购纯度',
  `state` tinyint(4) DEFAULT '0' COMMENT '状态位：用来表示当前商品的采购状态\n0：未完成  1：已完成入库',
  PRIMARY KEY (`orderDetailID`),
  KEY `FK_orderDetail_orderID_idx` (`orderID`),
  KEY `FK_orderDetail_reagentID_idx` (`reagentID`),
  KEY `FK_orderDetail_supplierID_idx` (`supplierID`),
  CONSTRAINT `FK_orderDetail_orderID` FOREIGN KEY (`orderID`) REFERENCES `order` (`orderID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_orderDetail_reagentID` FOREIGN KEY (`reagentID`) REFERENCES `reagentinfo` (`reagentID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_orderDetail_supplierID` FOREIGN KEY (`supplierID`) REFERENCES `supplier` (`supplierID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orderdetail`
--

LOCK TABLES `orderdetail` WRITE;
/*!40000 ALTER TABLE `orderdetail` DISABLE KEYS */;
INSERT INTO `orderdetail` VALUES (1,1,5,1.00,2,NULL,NULL,'JA10001','/',0),(2,1,8,1.00,1,NULL,NULL,'AR500ml','分析纯',0),(10,4,1,1.00,2,NULL,NULL,'100L','分析纯',0),(11,4,9,2.00,3,NULL,'厂家甲乙丙','0.1g','/',1),(12,4,8,1.00,1,NULL,NULL,'AR500ml','分析纯',0);
/*!40000 ALTER TABLE `orderdetail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `purity`
--

DROP TABLE IF EXISTS `purity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `purity` (
  `purityID` int(11) NOT NULL COMMENT '纯度ID',
  `purityName` varchar(45) DEFAULT NULL COMMENT '纯度名称',
  `state` int(11) DEFAULT '1' COMMENT '状态',
  PRIMARY KEY (`purityID`),
  UNIQUE KEY `purityName_UNIQUE` (`purityName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purity`
--

LOCK TABLES `purity` WRITE;
/*!40000 ALTER TABLE `purity` DISABLE KEYS */;
INSERT INTO `purity` VALUES (1,'分析纯',1),(2,'优级纯',1),(3,'色谱纯',1),(4,'化学纯',1);
/*!40000 ALTER TABLE `purity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reagent_supplier`
--

DROP TABLE IF EXISTS `reagent_supplier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reagent_supplier` (
  `rsID` int(11) NOT NULL AUTO_INCREMENT,
  `reagentID` int(11) DEFAULT NULL COMMENT '试剂ID',
  `supplierID` int(11) DEFAULT NULL COMMENT '供应商ID',
  `price` decimal(8,2) DEFAULT NULL COMMENT '供应商报价',
  PRIMARY KEY (`rsID`),
  KEY `FK_rs_reagentID_idx` (`reagentID`),
  KEY `FK_rs_supplierID_idx` (`supplierID`),
  CONSTRAINT `FK_rs_reagentID` FOREIGN KEY (`reagentID`) REFERENCES `reagentinfo` (`reagentID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_rs_supplierID` FOREIGN KEY (`supplierID`) REFERENCES `supplier` (`supplierID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='试剂_供应商对应表，用以保存提供试剂报价的各个供应商信息';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reagent_supplier`
--

LOCK TABLES `reagent_supplier` WRITE;
/*!40000 ALTER TABLE `reagent_supplier` DISABLE KEYS */;
/*!40000 ALTER TABLE `reagent_supplier` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reagentdanger`
--

DROP TABLE IF EXISTS `reagentdanger`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reagentdanger` (
  `dangerID` int(11) NOT NULL AUTO_INCREMENT COMMENT '标识ID',
  `dangerName` varchar(45) DEFAULT NULL COMMENT '危险类型名称（普通类，易制毒，易制爆，剧毒等）',
  `state` tinyint(4) DEFAULT '1' COMMENT '状态： 0 删除（不可用） 1 正常（可用）',
  PRIMARY KEY (`dangerID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='试剂危险类型表（易制毒，易制爆，剧毒）';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reagentdanger`
--

LOCK TABLES `reagentdanger` WRITE;
/*!40000 ALTER TABLE `reagentdanger` DISABLE KEYS */;
INSERT INTO `reagentdanger` VALUES (1,'/',1),(2,'易制毒',1),(3,'易燃品',1),(4,'易爆品',1);
/*!40000 ALTER TABLE `reagentdanger` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reagentinfo`
--

DROP TABLE IF EXISTS `reagentinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reagentinfo` (
  `reagentID` int(11) NOT NULL AUTO_INCREMENT COMMENT '试剂信息ID\n',
  `reagentName` varchar(60) DEFAULT NULL COMMENT '试剂名称',
  `reagentTypeID` int(11) DEFAULT NULL COMMENT '试剂类型ID',
  `reagentStateID` int(11) DEFAULT NULL COMMENT '试剂性状ID',
  `reagentDangerID` int(11) DEFAULT NULL COMMENT '试剂危险物品类别ID，不是危险物品选择普通类',
  `reagentProduct` varchar(100) DEFAULT NULL COMMENT '试剂生产企业',
  `reagentSpec` varchar(150) DEFAULT NULL COMMENT '试剂规格',
  `reagentUnit` varchar(20) DEFAULT NULL COMMENT '试剂计量单位',
  `reagentShortCode` varchar(45) DEFAULT NULL COMMENT '试剂名称简码，便于搜索试剂',
  `state` tinyint(4) DEFAULT '1',
  `CAS` varchar(45) DEFAULT NULL COMMENT '试剂CAS码',
  PRIMARY KEY (`reagentID`),
  KEY `FK_reagent_TypeID_idx` (`reagentTypeID`),
  KEY `FK_reagent_StateID_idx` (`reagentStateID`),
  KEY `FK_reagent_DangerID_idx` (`reagentDangerID`),
  CONSTRAINT `FK_reagent_DangerID` FOREIGN KEY (`reagentDangerID`) REFERENCES `reagentdanger` (`dangerID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_reagent_StateID` FOREIGN KEY (`reagentStateID`) REFERENCES `reagentstate` (`stateID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_reagent_TypeID` FOREIGN KEY (`reagentTypeID`) REFERENCES `reagenttype` (`typeID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reagentinfo`
--

LOCK TABLES `reagentinfo` WRITE;
/*!40000 ALTER TABLE `reagentinfo` DISABLE KEYS */;
INSERT INTO `reagentinfo` VALUES (1,'甲醇',1,NULL,1,'/','10L,100L,500mg,100mg','L','jc',1,'67-56-1'),(2,'喹乙醇',1,NULL,1,'/','100mg,10mg,1L','瓶','kyc',1,'23696-28-8'),(3,'恩诺沙星',1,NULL,1,'/','100g,10g','g','ensx',1,'93106-60-6'),(4,'克伦丙罗/克仑普罗',3,NULL,1,'DR','10mg','瓶','klblklpl',1,'1173021-09-4'),(5,'电子天平',2,NULL,1,'/','JA10001',NULL,'dztp',1,'/'),(6,'低吸附管',2,NULL,1,'eppendorfe','2.0ml*250S',NULL,'dxfg',1,'/'),(7,'尖底离心管',2,NULL,1,'FISHER','15ml*50个',NULL,'jdlxg',1,'/'),(8,'三氯甲烷',4,NULL,2,'上海国药','AR500ml',NULL,'sljw',1,'67-66-3'),(9,'喹乙醇',3,NULL,1,'/','0.1g',NULL,'kyc',1,'23696-28-8'),(10,'塞布特罗',3,NULL,1,'witega','10mg',NULL,'sbtl',1,'54239-39-3'),(11,'碘化钾',1,NULL,1,'/','GR500g',NULL,'dhj',1,'7681-11-0'),(12,'无水碳酸钠',1,NULL,1,'/','GR500g',NULL,'wstsn',1,'497-19-8');
/*!40000 ALTER TABLE `reagentinfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reagentstate`
--

DROP TABLE IF EXISTS `reagentstate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reagentstate` (
  `stateID` int(11) NOT NULL AUTO_INCREMENT COMMENT '标识ID',
  `stateName` varchar(45) DEFAULT NULL COMMENT '状态名称（固态、液态等）\n',
  `state` tinyint(4) DEFAULT '1',
  PRIMARY KEY (`stateID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='试剂性状表(固态、液体)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reagentstate`
--

LOCK TABLES `reagentstate` WRITE;
/*!40000 ALTER TABLE `reagentstate` DISABLE KEYS */;
/*!40000 ALTER TABLE `reagentstate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reagenttype`
--

DROP TABLE IF EXISTS `reagenttype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reagenttype` (
  `typeID` int(11) NOT NULL AUTO_INCREMENT COMMENT '药剂类型ID\n',
  `typeName` varchar(45) DEFAULT NULL COMMENT '药剂类型名称',
  `state` tinyint(4) DEFAULT '1' COMMENT '状态： 0 删除（不可用） 1 正常（可用）',
  PRIMARY KEY (`typeID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='药剂类型表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reagenttype`
--

LOCK TABLES `reagenttype` WRITE;
/*!40000 ALTER TABLE `reagenttype` DISABLE KEYS */;
INSERT INTO `reagenttype` VALUES (1,'试剂',1),(2,'耗材',1),(3,'标准物质',1),(4,'易制毒（爆）',1);
/*!40000 ALTER TABLE `reagenttype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `returnstocks`
--

DROP TABLE IF EXISTS `returnstocks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `returnstocks` (
  `returnID` int(11) NOT NULL AUTO_INCREMENT COMMENT '退库单ID',
  `userID` int(11) DEFAULT NULL COMMENT '退库申请人ID',
  `reagentID` int(11) DEFAULT NULL COMMENT '退库试剂ID',
  `reagentNum` decimal(8,2) DEFAULT NULL COMMENT '退库数量',
  `returnReason` varchar(100) DEFAULT NULL COMMENT '退库原因',
  `returnDate` datetime DEFAULT NULL COMMENT '退库时间',
  `returnState` int(11) DEFAULT NULL COMMENT '退库申请当前状态：0 尚未提交  1.待处理  2.等待出库（试剂管理员入库） 3.退库完成   4.拒绝退库',
  `receiverUserID` int(11) DEFAULT NULL COMMENT '退库受理人ID',
  `rejectReason` varchar(100) DEFAULT NULL COMMENT '拒绝退库原因',
  `stepID` int(11) DEFAULT NULL,
  PRIMARY KEY (`returnID`),
  KEY `FK_returnStocks_userID_idx` (`userID`),
  KEY `FK_returnStocks_receiverUserID_idx` (`receiverUserID`),
  KEY `FK_returnStocks_reagentID_idx` (`reagentID`),
  KEY `FK_returnStocks_stepID_idx` (`stepID`),
  CONSTRAINT `FK_returnStocks_reagentID` FOREIGN KEY (`reagentID`) REFERENCES `reagentinfo` (`reagentID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_returnStocks_receiverUserID` FOREIGN KEY (`receiverUserID`) REFERENCES `user` (`userID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_returnStocks_stepID` FOREIGN KEY (`stepID`) REFERENCES `steplist` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_returnStocks_userID` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='退库信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `returnstocks`
--

LOCK TABLES `returnstocks` WRITE;
/*!40000 ALTER TABLE `returnstocks` DISABLE KEYS */;
/*!40000 ALTER TABLE `returnstocks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `role` (
  `roleID` int(11) NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `roleName` varchar(100) DEFAULT NULL COMMENT '角色名称',
  `state` tinyint(4) DEFAULT '1',
  PRIMARY KEY (`roleID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='角色表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES (1,'管理员',1);
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_module`
--

DROP TABLE IF EXISTS `role_module`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `role_module` (
  `rmID` int(11) NOT NULL AUTO_INCREMENT COMMENT '角色权限表标识ID',
  `roleID` int(11) DEFAULT NULL COMMENT '角色ID',
  `moduleID` int(11) DEFAULT NULL COMMENT '模块ID',
  `accessRight` varchar(4) DEFAULT NULL COMMENT '角色对资源的访问权限 IDMS\ninsert delete modify search',
  PRIMARY KEY (`rmID`),
  KEY `FK_role_module_roleID_idx` (`roleID`),
  KEY `FK_role_module_moduleID_idx` (`moduleID`),
  CONSTRAINT `FK_role_module_moduleID` FOREIGN KEY (`moduleID`) REFERENCES `module` (`moduleID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_role_module_roleID` FOREIGN KEY (`roleID`) REFERENCES `role` (`roleID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8 COMMENT='角色权限表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_module`
--

LOCK TABLES `role_module` WRITE;
/*!40000 ALTER TABLE `role_module` DISABLE KEYS */;
INSERT INTO `role_module` VALUES (13,1,1,'IDMS'),(14,1,2,'IDMS'),(15,1,3,'IDMS'),(16,1,4,'IDMS'),(17,1,5,'IDMS'),(18,1,6,'IDMS'),(19,1,7,'IDMS'),(20,1,8,'IDMS'),(21,1,9,'IDMS'),(22,1,10,'IDMS'),(23,1,11,'IDMS'),(24,1,12,'IDMS'),(25,1,13,'IDMS');
/*!40000 ALTER TABLE `role_module` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `steplist`
--

DROP TABLE IF EXISTS `steplist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `steplist` (
  `id` int(11) NOT NULL COMMENT '步骤id',
  `stepName` varchar(45) DEFAULT NULL COMMENT '步骤名称',
  `processName` varchar(45) DEFAULT NULL,
  `remark` varchar(100) DEFAULT NULL COMMENT '步骤说明',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用以描述药剂流程步骤信息';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `steplist`
--

LOCK TABLES `steplist` WRITE;
/*!40000 ALTER TABLE `steplist` DISABLE KEYS */;
INSERT INTO `steplist` VALUES (1,'待提交','试剂申请',NULL),(2,'待审核','试剂申请',NULL),(3,'已驳回','试剂申请',NULL),(4,'待受理','申领管理',NULL),(5,'待收取','申领管理',NULL),(6,'申购中','申领管理',NULL),(7,'已完成','申领管理',NULL),(10,'待提交','申购管理','生成申购单，未提交'),(11,'待处理','申购管理','申购单提交，试剂管理员无法修改，删除'),(12,'询价中','申购管理','采购员选择供应商，比较价格'),(13,'待审核','申购管理','询价完毕，提交审核中'),(14,'申购驳回','申购管理','试剂采购员驳回申请'),(15,'采购驳回','申购管理','驳回采购申请'),(16,'采购中','申购管理','审核通过'),(17,'已完成','申购管理','采购单全部入库完成');
/*!40000 ALTER TABLE `steplist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stockdetail`
--

DROP TABLE IF EXISTS `stockdetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stockdetail` (
  `sdID` int(11) NOT NULL AUTO_INCREMENT COMMENT '标识ID',
  `stocksID` int(11) DEFAULT NULL COMMENT '试剂ID',
  `reagentNum` decimal(8,2) DEFAULT NULL COMMENT '出入库数量',
  `remark` varchar(45) DEFAULT NULL COMMENT '备注',
  `direction` varchar(45) DEFAULT NULL COMMENT '出入库方向（入库 in   出库 out）',
  `opID` int(11) DEFAULT NULL COMMENT '操作ID  申领出库，退回入库，进货入库等 对应操作的ID\n',
  `opName` varchar(45) DEFAULT NULL COMMENT '操作名称   申领出库，退回入库，进货入库等',
  `opDatetime` datetime DEFAULT NULL,
  `userID` int(11) DEFAULT NULL COMMENT '相关操作执行用户ID',
  `state` int(11) DEFAULT '1' COMMENT '出入库状态\n1：正常  0：取消  2:已领取\n状态不影响实际库存出入，只用来辅助发放状态显示',
  PRIMARY KEY (`sdID`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stockdetail`
--

LOCK TABLES `stockdetail` WRITE;
/*!40000 ALTER TABLE `stockdetail` DISABLE KEYS */;
INSERT INTO `stockdetail` VALUES (1,16,1.00,'试剂采购入库','in',NULL,'ApplicationOrderManage','2019-12-17 00:00:00',1,NULL),(2,15,1.00,'试剂采购入库','in',NULL,'ApplicationOrderManage','2019-12-20 00:00:00',1,NULL),(3,15,1.00,'试剂采购入库','in',NULL,'ApplicationOrderManage','2019-12-20 00:00:00',1,NULL),(4,15,1.00,'试剂采购入库','in',11,'ApplicationOrderManage','2019-12-20 00:00:00',1,NULL),(5,15,2.00,'试剂发放','out',9,'application','2019-12-22 00:00:00',1,0),(6,16,1.00,'试剂发放','out',9,'application','2019-12-22 00:00:00',1,0),(7,16,NULL,'试剂撤回发放','in',9,'application','2019-12-22 00:00:00',1,1),(8,15,1.00,'试剂发放','out',9,'application','2019-12-22 00:00:00',1,0),(9,15,NULL,'试剂撤回发放','in',9,'application','2019-12-22 00:00:00',1,1),(10,15,NULL,'试剂撤回发放','in',9,'application','2019-12-22 00:00:00',1,1),(11,15,1.00,'试剂发放','out',9,'application','2019-12-22 00:00:00',1,1),(12,15,2.00,'试剂发放','out',9,'application','2019-12-22 00:00:00',1,0),(13,15,NULL,'试剂撤回发放','in',9,'application','2019-12-22 00:00:00',1,1);
/*!40000 ALTER TABLE `stockdetail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stocks`
--

DROP TABLE IF EXISTS `stocks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stocks` (
  `stocksID` int(11) NOT NULL AUTO_INCREMENT COMMENT '库存标识ID',
  `reagentID` int(11) DEFAULT NULL COMMENT '试剂ID',
  `reagentNum` decimal(8,2) DEFAULT NULL COMMENT '试剂数量',
  `initialNum` decimal(8,2) DEFAULT NULL COMMENT '初始库存\n每样库存商品的库存(reagentNum)=初始库存(initialNum)+入库数量-出库数量\n',
  `stockSpec` varchar(45) DEFAULT NULL COMMENT '库存试剂规格',
  `stockPurity` varchar(45) DEFAULT NULL COMMENT '库存试剂纯度等级',
  `stockRecordNo` varchar(45) DEFAULT NULL COMMENT '试剂库存备案号 （用于易制毒试剂）',
  `stockBatchNo` varchar(45) DEFAULT NULL COMMENT '试剂库存批号（用于标准品）',
  `composition` varchar(45) DEFAULT NULL COMMENT '试剂含量 (用于标准物质)',
  `stockUnit` varchar(45) DEFAULT NULL COMMENT '单位',
  `stockBrand` varchar(45) DEFAULT NULL COMMENT '试剂品牌',
  `expiryDate` datetime DEFAULT NULL COMMENT '试剂的保质期',
  `standardNo` varchar(45) DEFAULT NULL COMMENT '标准品编号（标准号）',
  PRIMARY KEY (`stocksID`),
  KEY `FK_stocks_reagentID_idx` (`reagentID`),
  KEY `FK_stocks_purity_idx` (`stockPurity`),
  CONSTRAINT `FK_stocks_purity` FOREIGN KEY (`stockPurity`) REFERENCES `purity` (`purityName`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_stocks_reagentID` FOREIGN KEY (`reagentID`) REFERENCES `reagentinfo` (`reagentID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8 COMMENT='库存信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stocks`
--

LOCK TABLES `stocks` WRITE;
/*!40000 ALTER TABLE `stocks` DISABLE KEYS */;
INSERT INTO `stocks` VALUES (15,9,7.00,0.00,'100L','分析纯','/','20191216','0.1','瓶','ABC','2020-12-25 00:00:00',NULL),(16,9,2.00,0.00,'100L','分析纯','/','20191010','0.5','瓶','ABC','2020-10-10 00:00:00',NULL);
/*!40000 ALTER TABLE `stocks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `supplier`
--

DROP TABLE IF EXISTS `supplier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `supplier` (
  `supplierID` int(11) NOT NULL AUTO_INCREMENT COMMENT '供应商ID',
  `supplierName` varchar(60) DEFAULT NULL COMMENT '供应商名称',
  `supplierAddress` varchar(100) DEFAULT NULL COMMENT '供应商地址',
  `supplierContact` varchar(45) DEFAULT NULL COMMENT '供应商联系人',
  `supplierContactPhone` varchar(45) DEFAULT NULL COMMENT '联系人电话',
  `supplierLevel` varchar(45) DEFAULT NULL COMMENT '供应商等级ABCD',
  `remark` varchar(150) DEFAULT NULL COMMENT '备注信息',
  `state` tinyint(4) DEFAULT '1' COMMENT '状态： 0 删除（不可用） 1 正常（可用）',
  PRIMARY KEY (`supplierID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='药剂供应商信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supplier`
--

LOCK TABLES `supplier` WRITE;
/*!40000 ALTER TABLE `supplier` DISABLE KEYS */;
INSERT INTO `supplier` VALUES (1,'裕丰','长沙市八一路','张三','13912345678','A','长沙市裕丰化玻器械有限公司',1),(2,'宇辉','荣湾镇新外滩','刘姐','13456578123','A','湖南宇辉科技发展有限公司',1),(3,'思通',NULL,'刘总','123456789','A','湖南思通科学仪器有限公司',1);
/*!40000 ALTER TABLE `supplier` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `userID` int(11) NOT NULL AUTO_INCREMENT COMMENT '用户id',
  `userName` varchar(45) DEFAULT NULL COMMENT '用户名',
  `userPwd` varchar(45) DEFAULT '202cb962ac59075b964b07152d234b70' COMMENT '用户密码, 初始密码（''202cb962ac59075b964b07152d234b70''） md5 000',
  `userDptID` int(11) DEFAULT NULL COMMENT '用户所属部门ID',
  `userPhone` varchar(45) DEFAULT NULL COMMENT '用户手机，便于之后实现短信提醒功能',
  `userRealName` varchar(45) DEFAULT NULL COMMENT '用户真实姓名',
  `userFavorite` varchar(200) DEFAULT NULL COMMENT '用户收藏采购试剂列表',
  `state` tinyint(4) DEFAULT '1' COMMENT '当前用户帐号状态： 1：正常使用  0: 停用',
  PRIMARY KEY (`userID`),
  KEY `FK_user_userDptID_idx` (`userDptID`),
  CONSTRAINT `FK_user_userDptID` FOREIGN KEY (`userDptID`) REFERENCES `department` (`deptID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='用户信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'admin','202cb962ac59075b964b07152d234b70',4,NULL,'管理员',NULL,1);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_role`
--

DROP TABLE IF EXISTS `user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_role` (
  `urID` int(11) NOT NULL AUTO_INCREMENT COMMENT '标识ID',
  `userID` int(11) DEFAULT NULL,
  `roleID` int(11) DEFAULT NULL,
  PRIMARY KEY (`urID`),
  KEY `FK_userID_idx` (`userID`),
  KEY `FK_roleID_idx` (`roleID`),
  CONSTRAINT `FK_user_role_roleID` FOREIGN KEY (`roleID`) REFERENCES `role` (`roleID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_user_role_userID` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='用户角色表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_role`
--

LOCK TABLES `user_role` WRITE;
/*!40000 ALTER TABLE `user_role` DISABLE KEYS */;
INSERT INTO `user_role` VALUES (1,1,1);
/*!40000 ALTER TABLE `user_role` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-12-23  7:42:14
