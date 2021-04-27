-- MySQL dump 10.13  Distrib 5.7.17, for Linux (x86_64)
--
-- Host: localhost    Database: npd
-- ------------------------------------------------------
-- Server version	5.7.17-0ubuntu0.16.04.1
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO,POSTGRESQL' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table "apaAreaGross"
--

DROP TABLE IF EXISTS "apaAreaGross";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "apaAreaGross" (
  "apaMap_no" varchar NOT NULL,
  "apaAreaGeometry_KML_WGS84" text NOT NULL,
  "apaAreaGross_id" varchar  NOT NULL,
  PRIMARY KEY ("apaAreaGross_id")
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "apaAreaNet"
--

DROP TABLE IF EXISTS "apaAreaNet";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "apaAreaNet" (
  "blkId" varchar NOT NULL,
  "blkLabel" varchar NOT NULL,
  "qdrName" varchar NOT NULL,
  "blkName" varchar NOT NULL,
  "prvName" varchar(2) NOT NULL,
  "apaAreaType" varchar DEFAULT NULL,
  "urlNPD" varchar(200) NOT NULL,
  "apaAreaNet_id" varchar  NOT NULL,
  PRIMARY KEY ("apaAreaNet_id","qdrName","blkName","prvName","blkId")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "baaArea"
--

DROP TABLE IF EXISTS "baaArea";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "baaArea" (
  "baaNpdidBsnsArrArea" varchar NOT NULL ,
  "baaNpdidBsnsArrAreaPoly" varchar NOT NULL,
  "baaName" varchar NOT NULL ,
  "baaKind" varchar NOT NULL ,
  "baaAreaPolyDateValidFrom" varchar NOT NULL ,
  "baaAreaPolyDateValidTo" varchar DEFAULT NULL ,
  "baaAreaPolyActive" varchar NOT NULL,
  "baaDateApproved" varchar NOT NULL ,
  "baaDateValidFrom" varchar NOT NULL ,
  "baaDateValidTo" varchar DEFAULT NULL ,
  "baaActive" varchar(20) NOT NULL ,
  "baaFactPageUrl" varchar(200) NOT NULL ,
  "baaFactMapUrl" varchar(200) DEFAULT NULL ,
  PRIMARY KEY ("baaNpdidBsnsArrArea","baaNpdidBsnsArrAreaPoly")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "bsns_arr_area"
--

DROP TABLE IF EXISTS "bsns_arr_area" ;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "bsns_arr_area" (
  "baaName" varchar NOT NULL ,
  "baaKind" varchar NOT NULL ,
  "baaDateApproved" varchar NOT NULL ,
  "baaDateValidFrom" varchar NOT NULL ,
  "baaDateValidTo" varchar DEFAULT NULL ,
  "baaFactPageUrl" varchar(200) NOT NULL ,
  "baaFactMapUrl" varchar(200) DEFAULT NULL ,
  "baaNpdidBsnsArrArea" varchar NOT NULL ,
  "baaDateUpdated" varchar DEFAULT NULL ,
  "baaDateUpdatedMax" varchar DEFAULT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("baaNpdidBsnsArrArea")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "bsns_arr_area_area_poly_hst"
--

DROP TABLE IF EXISTS "bsns_arr_area_area_poly_hst";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "bsns_arr_area_area_poly_hst" (
  "baaName" varchar NOT NULL ,
  "baaAreaPolyDateValidFrom" varchar NOT NULL ,
  "baaAreaPolyDateValidTo" varchar NOT NULL DEFAULT '1900-01-01' ,
  "baaAreaPolyNationCode2" varchar(2) NOT NULL ,
  "baaAreaPolyBlockName" varchar NOT NULL DEFAULT '' ,
  "baaAreaPolyNo" varchar NOT NULL,
  "baaAreaPolyArea" varchar NOT NULL ,
  "baaNpdidBsnsArrArea" varchar NOT NULL ,
  "baaAreaPolyDateUpdated" varchar DEFAULT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("baaNpdidBsnsArrArea","baaAreaPolyBlockName","baaAreaPolyNo","baaAreaPolyDateValidFrom","baaAreaPolyDateValidTo")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "bsns_arr_area_licensee_hst"
--

DROP TABLE IF EXISTS "bsns_arr_area_licensee_hst";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "bsns_arr_area_licensee_hst" (
  "baaName" varchar NOT NULL ,
  "baaLicenseeDateValidFrom" varchar NOT NULL ,
  "baaLicenseeDateValidTo" varchar NOT NULL DEFAULT '1900-01-01' ,
  "cmpLongName" varchar(200) NOT NULL ,
  "baaLicenseeInterest" varchar NOT NULL ,
  "baaLicenseeSdfi" varchar DEFAULT NULL ,
  "baaNpdidBsnsArrArea" varchar NOT NULL ,
  "cmpNpdidCompany" varchar NOT NULL ,
  "baaLicenseeDateUpdated" varchar DEFAULT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("baaNpdidBsnsArrArea","cmpNpdidCompany","baaLicenseeDateValidFrom","baaLicenseeDateValidTo")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "bsns_arr_area_operator"
--

DROP TABLE IF EXISTS "bsns_arr_area_operator";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "bsns_arr_area_operator" (
  "baaName" varchar NOT NULL ,
  "cmpLongName" varchar(200) NOT NULL ,
  "baaNpdidBsnsArrArea" varchar NOT NULL ,
  "cmpNpdidCompany" varchar NOT NULL ,
  "baaOperatorDateUpdated" varchar DEFAULT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("baaNpdidBsnsArrArea")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "bsns_arr_area_transfer_hst"
--

DROP TABLE IF EXISTS "bsns_arr_area_transfer_hst";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "bsns_arr_area_transfer_hst" (
  "baaName" varchar NOT NULL ,
  "baaTransferDateValidFrom" varchar NOT NULL ,
  "baaTransferDirection" varchar(4) NOT NULL ,
  "baaTransferKind" varchar DEFAULT NULL ,
  "cmpLongName" varchar(200) NOT NULL ,
  "baaTransferredInterest" varchar NOT NULL ,
  "baaTransferSdfi" varchar DEFAULT NULL ,
  "baaNpdidBsnsArrArea" varchar NOT NULL ,
  "cmpNpdidCompany" varchar NOT NULL ,
  "baaTransferDateUpdated" varchar DEFAULT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("baaNpdidBsnsArrArea","baaTransferDirection","cmpNpdidCompany","baaTransferDateValidFrom")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "company"
--

DROP TABLE IF EXISTS "company" ;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "company" (
  "cmpLongName" varchar(200) NOT NULL ,
  "cmpOrgNumberBrReg" varchar(100) DEFAULT NULL ,
  "cmpGroup" varchar(100) DEFAULT NULL ,
  "cmpShortName" varchar NOT NULL ,
  "cmpNpdidCompany" varchar NOT NULL ,
  "cmpLicenceOperCurrent" varchar(2) NOT NULL ,
  "cmpLicenceOperFormer" varchar(2) NOT NULL ,
  "cmpLicenceLicenseeCurrent" varchar(2) NOT NULL ,
  "cmpLicenceLicenseeFormer" varchar(2) NOT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("cmpNpdidCompany")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "company_reserves"
--

DROP TABLE IF EXISTS "company_reserves";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "company_reserves" (
  "cmpLongName" varchar(200) NOT NULL ,
  "fldName" varchar NOT NULL ,
  "cmpRecoverableOil" varchar NOT NULL,
  "cmpRecoverableGas" varchar NOT NULL,
  "cmpRecoverableNGL" varchar NOT NULL,
  "cmpRecoverableCondensate" varchar NOT NULL,
  "cmpRecoverableOE" varchar NOT NULL,
  "cmpRemainingOil" varchar NOT NULL,
  "cmpRemainingGas" varchar NOT NULL,
  "cmpRemainingNGL" varchar NOT NULL,
  "cmpRemainingCondensate" varchar NOT NULL,
  "cmpRemainingOE" varchar NOT NULL,
  "cmpDateOffResEstDisplay" varchar NOT NULL,
  "cmpShare" varchar NOT NULL,
  "fldNpdidField" varchar NOT NULL ,
  "cmpNpdidCompany" varchar NOT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("cmpNpdidCompany","fldNpdidField")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "discovery"
--

DROP TABLE IF EXISTS "discovery" ;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "discovery" (
  "dscName" varchar NOT NULL ,
  "cmpLongName" varchar(200) DEFAULT NULL ,
  "dscCurrentActivityStatus" varchar NOT NULL ,
  "dscHcType" varchar DEFAULT NULL ,
  "wlbName" varchar(60) DEFAULT NULL ,
  "nmaName" varchar DEFAULT NULL ,
  "fldName" varchar DEFAULT NULL ,
  "dscDateFromInclInField" varchar DEFAULT NULL ,
  "dscDiscoveryYear" varchar NOT NULL ,
  "dscResInclInDiscoveryName" varchar DEFAULT NULL ,
  "dscOwnerKind" varchar DEFAULT NULL ,
  "dscOwnerName" varchar DEFAULT NULL ,
  "dscNpdidDiscovery" varchar NOT NULL ,
  "fldNpdidField" varchar DEFAULT NULL ,
  "wlbNpdidWellbore" varchar NOT NULL ,
  "dscFactPageUrl" varchar(200) NOT NULL ,
  "dscFactMapUrl" varchar(200) NOT NULL ,
  "dscDateUpdated" varchar DEFAULT NULL ,
  "dscDateUpdatedMax" varchar DEFAULT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("dscNpdidDiscovery")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "discovery_reserves"
--

DROP TABLE IF EXISTS "discovery_reserves";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "discovery_reserves" (
  "dscName" varchar NOT NULL ,
  "dscReservesRC" varchar NOT NULL ,
  "dscRecoverableOil" varchar NOT NULL ,
  "dscRecoverableGas" varchar NOT NULL ,
  "dscRecoverableNGL" varchar NOT NULL ,
  "dscRecoverableCondensate" varchar NOT NULL ,
  "dscDateOffResEstDisplay" varchar NOT NULL ,
  "dscNpdidDiscovery" varchar NOT NULL ,
  "dscReservesDateUpdated" varchar NOT NULL,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("dscNpdidDiscovery","dscReservesRC")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "dscArea"
--

DROP TABLE IF EXISTS "dscArea";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "dscArea" (
  "fldNpdidField" varchar DEFAULT NULL ,
  "fldName" varchar DEFAULT NULL ,
  "dscNpdidDiscovery" varchar NOT NULL ,
  "dscName" varchar NOT NULL ,
  "dscResInclInDiscoveryName" varchar DEFAULT NULL ,
  "dscNpdidResInclInDiscovery" varchar DEFAULT NULL,
  "dscIncludedInFld" varchar(3) NOT NULL,
  "dscHcType" varchar NOT NULL ,
  "fldHcType" varchar DEFAULT NULL,
  "dscCurrentActivityStatus" varchar NOT NULL ,
  "fldCurrentActivityStatus" varchar DEFAULT NULL,
  "flddscLabel" varchar NOT NULL,
  "dscFactUrl" varchar(200) NOT NULL,
  "fldFactUrl" varchar(200) DEFAULT NULL,
  PRIMARY KEY ("dscNpdidDiscovery","dscHcType")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "facility_fixed"
--

DROP TABLE IF EXISTS "facility_fixed" ;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "facility_fixed" (
  "fclName" varchar NOT NULL ,
  "fclPhase" varchar NOT NULL ,
  "fclSurface" varchar(2) NOT NULL ,
  "fclCurrentOperatorName" varchar(100) DEFAULT NULL ,
  "fclKind" varchar NOT NULL ,
  "fclBelongsToName" varchar(41) DEFAULT NULL ,
  "fclBelongsToKind" varchar DEFAULT NULL ,
  "fclBelongsToS" varchar DEFAULT NULL,
  "fclStartupDate" varchar DEFAULT NULL ,
  "fclGeodeticDatum" varchar(10) DEFAULT NULL ,
  "fclNsDeg" varchar DEFAULT NULL ,
  "fclNsMin" varchar DEFAULT NULL ,
  "fclNsSec" varchar DEFAULT NULL ,
  "fclNsCode" varchar(2) NOT NULL ,
  "fclEwDeg" varchar DEFAULT NULL ,
  "fclEwMin" varchar DEFAULT NULL ,
  "fclEwSec" varchar DEFAULT NULL ,
  "fclEwCode" varchar(2) NOT NULL ,
  "fclWaterDepth" varchar NOT NULL ,
  "fclFunctions" varchar(400) DEFAULT NULL ,
  "fclDesignLifetime" varchar DEFAULT NULL ,
  "fclFactPageUrl" varchar(200) NOT NULL ,
  "fclFactMapUrl" varchar(200) NOT NULL ,
  "fclNpdidFacility" varchar NOT NULL ,
  "fclDateUpdated" varchar DEFAULT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("fclNpdidFacility")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "facility_moveable"
--

DROP TABLE IF EXISTS "facility_moveable";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "facility_moveable" (
  "fclName" varchar NOT NULL ,
  "fclCurrentRespCompanyName" varchar(100) DEFAULT NULL ,
  "fclKind" varchar NOT NULL ,
  "fclFunctions" varchar(400) DEFAULT NULL ,
  "fclNationName" varchar NOT NULL ,
  "fclFactPageUrl" varchar(200) NOT NULL ,
  "fclNpdidFacility" varchar NOT NULL ,
  "fclNpdidCurrentRespCompany" varchar DEFAULT NULL ,
  "fclDateUpdated" varchar DEFAULT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("fclNpdidFacility")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "fclPoint"
--

DROP TABLE IF EXISTS "fclPoint";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "fclPoint" (
  "fclNpdidFacility" varchar NOT NULL ,
  "fclSurface" varchar(2) NOT NULL ,
  "fclCurrentOperatorName" varchar(100) DEFAULT NULL ,
  "fclName" varchar NOT NULL ,
  "fclKind" varchar NOT NULL ,
  "fclBelongsToName" varchar(41) DEFAULT NULL ,
  "fclBelongsToKind" varchar DEFAULT NULL ,
  "fclBelongsToS" varchar DEFAULT NULL,
  "fclStartupDate" varchar NOT NULL ,
  "fclWaterDepth" varchar NOT NULL ,
  "fclFunctions" varchar(400) DEFAULT NULL ,
  "fclDesignLifetime" varchar NOT NULL ,
  "fclFactPageUrl" varchar(200) NOT NULL ,
  "fclFactMapUrl" varchar(200) NOT NULL ,
  PRIMARY KEY ("fclNpdidFacility")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "field"
--

DROP TABLE IF EXISTS "field" ;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "field" (
  "fldName" varchar NOT NULL ,
  "cmpLongName" varchar(200) DEFAULT NULL ,
  "fldCurrentActivitySatus" varchar NOT NULL ,
  "wlbName" varchar(60) DEFAULT NULL ,
  "wlbCompletionDate" varchar DEFAULT NULL ,
  "fldOwnerKind" varchar DEFAULT NULL ,
  "fldOwnerName" varchar DEFAULT NULL ,
  "fldNpdidOwner" varchar DEFAULT NULL ,
  "fldNpdidField" varchar NOT NULL ,
  "wlbNpdidWellbore" varchar NOT NULL ,
  "cmpNpdidCompany" varchar DEFAULT NULL ,
  "fldFactPageUrl" varchar(200) NOT NULL ,
  "fldFactMapUrl" varchar(200) NOT NULL,
  "fldDateUpdated" varchar DEFAULT NULL ,
  "fldDateUpdatedMax" varchar DEFAULT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("fldNpdidField")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "field_activity_status_hst"
--

DROP TABLE IF EXISTS "field_activity_status_hst";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "field_activity_status_hst" (
  "fldName" varchar NOT NULL ,
  "fldStatusFromDate" varchar NOT NULL ,
  "fldStatusToDate" varchar NOT NULL DEFAULT '1900-01-01' ,
  "fldStatus" varchar NOT NULL ,
  "fldNpdidField" varchar NOT NULL ,
  "fldStatusDateUpdated" varchar DEFAULT NULL,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("fldNpdidField","fldStatus","fldStatusFromDate","fldStatusToDate")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "field_description"
--

DROP TABLE IF EXISTS "field_description";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "field_description" (
  "fldName" varchar NOT NULL ,
  "fldDescriptionHeading" varchar(255) NOT NULL ,
  "fldDescriptionText" text NOT NULL ,
  "fldNpdidField" varchar NOT NULL ,
  "fldDescriptionDateUpdated" varchar NOT NULL ,
  PRIMARY KEY ("fldNpdidField","fldDescriptionHeading")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "field_investment_yearly"
--

DROP TABLE IF EXISTS "field_investment_yearly";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "field_investment_yearly" (
  "prfInformationCarrier" varchar NOT NULL ,
  "prfYear" varchar NOT NULL ,
  "prfInvestmentsMillNOK" varchar NOT NULL ,
  "prfNpdidInformationCarrier" varchar NOT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("prfNpdidInformationCarrier","prfYear")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "field_licensee_hst"
--

DROP TABLE IF EXISTS "field_licensee_hst";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "field_licensee_hst" (
  "fldName" varchar NOT NULL ,
  "fldOwnerName" varchar NOT NULL ,
  "fldOwnerKind" varchar NOT NULL ,
  "fldOwnerFrom" varchar NOT NULL,
  "fldOwnerTo" varchar DEFAULT NULL,
  "fldLicenseeFrom" varchar NOT NULL,
  "fldLicenseeTo" varchar NOT NULL DEFAULT '1900-01-01',
  "cmpLongName" varchar(200) NOT NULL ,
  "fldCompanyShare" varchar NOT NULL ,
  "fldSdfiShare" varchar DEFAULT NULL ,
  "fldNpdidField" varchar NOT NULL ,
  "cmpNpdidCompany" varchar NOT NULL ,
  "fldLicenseeDateUpdated" varchar DEFAULT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("fldNpdidField","cmpNpdidCompany","fldLicenseeFrom","fldLicenseeTo")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "field_operator_hst"
--

DROP TABLE IF EXISTS "field_operator_hst";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "field_operator_hst" (
  "fldName" varchar NOT NULL ,
  "cmpLongName" varchar(200) NOT NULL ,
  "fldOperatorFrom" varchar NOT NULL,
  "fldOperatorTo" varchar NOT NULL DEFAULT '1900-01-01',
  "fldNpdidField" varchar NOT NULL ,
  "cmpNpdidCompany" varchar NOT NULL ,
  "fldOperatorDateUpdated" varchar DEFAULT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("fldNpdidField","cmpNpdidCompany","fldOperatorFrom","fldOperatorTo")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "field_owner_hst"
--

DROP TABLE IF EXISTS "field_owner_hst";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "field_owner_hst" (
  "fldName" varchar NOT NULL ,
  "fldOwnerKind" varchar NOT NULL ,
  "fldOwnerName" varchar NOT NULL ,
  "fldOwnershipFromDate" varchar NOT NULL,
  "fldOwnershipToDate" varchar NOT NULL DEFAULT '1900-01-01',
  "fldNpdidField" varchar NOT NULL ,
  "fldNpdidOwner" varchar NOT NULL ,
  "fldOwnerDateUpdated" varchar DEFAULT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("fldNpdidField","fldNpdidOwner","fldOwnershipFromDate","fldOwnershipToDate")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "field_production_monthly"
--

DROP TABLE IF EXISTS "field_production_monthly";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "field_production_monthly" (
  "prfInformationCarrier" varchar NOT NULL ,
  "prfYear" varchar NOT NULL ,
  "prfMonth" varchar NOT NULL ,
  "prfPrdOilNetMillSm3" varchar NOT NULL ,
  "prfPrdGasNetBillSm3" varchar NOT NULL ,
  "prfPrdNGLNetMillSm3" varchar NOT NULL ,
  "prfPrdCondensateNetMillSm3" varchar NOT NULL ,
  "prfPrdOeNetMillSm3" varchar NOT NULL ,
  "prfPrdProducedWaterInFieldMillSm3" varchar NOT NULL ,
  "prfNpdidInformationCarrier" varchar NOT NULL ,
  PRIMARY KEY ("prfNpdidInformationCarrier","prfYear","prfMonth")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "field_production_totalt_NCS_month"
--

DROP TABLE IF EXISTS "field_production_totalt_NCS_month";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "field_production_totalt_NCS_month" (
  "prfYear" varchar NOT NULL ,
  "prfMonth" varchar NOT NULL ,
  "prfPrdOilNetMillSm3" varchar NOT NULL ,
  "prfPrdGasNetBillSm3" varchar NOT NULL ,
  "prfPrdNGLNetMillSm3" varchar NOT NULL ,
  "prfPrdCondensateNetMillSm3" varchar NOT NULL ,
  "prfPrdOeNetMillSm3" varchar NOT NULL ,
  "prfPrdProducedWaterInFieldMillSm3" varchar NOT NULL ,
  PRIMARY KEY ("prfYear","prfMonth")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "field_production_totalt_NCS_year"
--

DROP TABLE IF EXISTS "field_production_totalt_NCS_year";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "field_production_totalt_NCS_year" (
  "prfYear" varchar NOT NULL ,
  "prfPrdOilNetMillSm" varchar NOT NULL,
  "prfPrdGasNetBillSm" varchar NOT NULL,
  "prfPrdCondensateNetMillSm3" varchar NOT NULL ,
  "prfPrdNGLNetMillSm3" varchar NOT NULL ,
  "prfPrdOeNetMillSm3" varchar NOT NULL ,
  "prfPrdProducedWaterInFieldMillSm3" varchar NOT NULL ,
  PRIMARY KEY ("prfYear")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "field_production_yearly"
--

DROP TABLE IF EXISTS "field_production_yearly";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "field_production_yearly" (
  "prfInformationCarrier" varchar NOT NULL ,
  "prfYear" varchar NOT NULL ,
  "prfPrdOilNetMillSm3" varchar NOT NULL ,
  "prfPrdGasNetBillSm3" varchar NOT NULL ,
  "prfPrdNGLNetMillSm3" varchar NOT NULL ,
  "prfPrdCondensateNetMillSm3" varchar NOT NULL ,
  "prfPrdOeNetMillSm3" varchar NOT NULL ,
  "prfPrdProducedWaterInFieldMillSm3" varchar NOT NULL ,
  "prfNpdidInformationCarrier" varchar NOT NULL ,
  PRIMARY KEY ("prfNpdidInformationCarrier","prfYear")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "field_reserves"
--

DROP TABLE IF EXISTS "field_reserves";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "field_reserves" (
  "fldName" varchar NOT NULL ,
  "fldRecoverableOil" varchar NOT NULL ,
  "fldRecoverableGas" varchar NOT NULL ,
  "fldRecoverableNGL" varchar NOT NULL ,
  "fldRecoverableCondensate" varchar NOT NULL ,
  "fldRecoverableOE" varchar NOT NULL ,
  "fldRemainingOil" varchar NOT NULL ,
  "fldRemainingGas" varchar NOT NULL ,
  "fldRemainingNGL" varchar NOT NULL ,
  "fldRemainingCondensate" varchar NOT NULL ,
  "fldRemainingOE" varchar NOT NULL ,
  "fldDateOffResEstDisplay" varchar NOT NULL ,
  "fldNpdidField" varchar NOT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("fldNpdidField")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "fldArea"
--

DROP TABLE IF EXISTS "fldArea";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "fldArea" (
  "fldNpdidField" varchar NOT NULL ,
  "fldName" varchar NOT NULL ,
  "dscNpdidDiscovery" varchar NOT NULL ,
  "dscName" varchar NOT NULL ,
  "dscResInclInDiscoveryName" varchar DEFAULT NULL ,
  "dscNpdidResInclInDiscovery" varchar DEFAULT NULL,
  "dscIncludedInFld" varchar(3) NOT NULL,
  "dscHcType" varchar NOT NULL ,
  "fldHcType" varchar NOT NULL,
  "dscCurrentActivityStatus" varchar NOT NULL ,
  "fldCurrentActivityStatus" varchar NOT NULL,
  "flddscLabel" varchar NOT NULL,
  "dscFactUrl" varchar(200) NOT NULL,
  "fldFactUrl" varchar(200) NOT NULL,
  PRIMARY KEY ("dscNpdidDiscovery","dscHcType")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "licence"
--

DROP TABLE IF EXISTS "licence" ;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "licence" (
  "prlName" varchar(50) NOT NULL ,
  "prlLicensingActivityName" varchar NOT NULL ,
  "prlMainArea" varchar DEFAULT NULL ,
  "prlStatus" varchar NOT NULL ,
  "prlDateGranted" varchar NOT NULL ,
  "prlDateValidTo" varchar NOT NULL ,
  "prlOriginalArea" varchar NOT NULL ,
  "prlCurrentArea" varchar(20) NOT NULL ,
  "prlPhaseCurrent" varchar DEFAULT NULL ,
  "prlNpdidLicence" varchar NOT NULL ,
  "prlFactPageUrl" varchar(200) NOT NULL ,
  "prlFactMapUrl" varchar(200) DEFAULT NULL ,
  "prlDateUpdated" varchar DEFAULT NULL ,
  "prlDateUpdatedMax" varchar DEFAULT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("prlNpdidLicence")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "licence_area_poly_hst"
--

DROP TABLE IF EXISTS "licence_area_poly_hst";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "licence_area_poly_hst" (
  "prlName" varchar(50) NOT NULL ,
  "prlAreaPolyDateValidFrom" varchar NOT NULL ,
  "prlAreaPolyDateValidTo" varchar NOT NULL DEFAULT '1900-01-01' ,
  "prlAreaPolyNationCode" varchar(2) NOT NULL,
  "prlAreaPolyBlockName" varchar NOT NULL ,
  "prlAreaPolyStratigraphical" varchar(4) NOT NULL ,
  "prlAreaPolyPolyNo" varchar NOT NULL,
  "prlAreaPolyPolyArea" varchar NOT NULL ,
  "prlNpdidLicence" varchar NOT NULL ,
  "prlAreaDateUpdated" varchar DEFAULT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("prlNpdidLicence","prlAreaPolyBlockName","prlAreaPolyPolyNo","prlAreaPolyDateValidFrom","prlAreaPolyDateValidTo")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "licence_licensee_hst"
--

DROP TABLE IF EXISTS "licence_licensee_hst";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "licence_licensee_hst" (
  "prlName" varchar(50) NOT NULL ,
  "prlLicenseeDateValidFrom" varchar NOT NULL ,
  "prlLicenseeDateValidTo" varchar NOT NULL DEFAULT '1900-01-01' ,
  "cmpLongName" varchar(200) NOT NULL ,
  "prlLicenseeInterest" varchar NOT NULL ,
  "prlLicenseeSdfi" varchar DEFAULT NULL ,
  "prlOperDateValidFrom" varchar DEFAULT NULL ,
  "prlOperDateValidTo" varchar DEFAULT NULL ,
  "prlNpdidLicence" varchar NOT NULL ,
  "cmpNpdidCompany" varchar NOT NULL ,
  "prlLicenseeDateUpdated" varchar DEFAULT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("prlNpdidLicence","cmpNpdidCompany","prlLicenseeDateValidFrom","prlLicenseeDateValidTo")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "licence_oper_hst"
--

DROP TABLE IF EXISTS "licence_oper_hst";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "licence_oper_hst" (
  "prlName" varchar(50) NOT NULL ,
  "prlOperDateValidFrom" varchar NOT NULL ,
  "prlOperDateValidTo" varchar NOT NULL DEFAULT '1900-01-01' ,
  "cmpLongName" varchar(200) NOT NULL ,
  "prlNpdidLicence" varchar NOT NULL ,
  "cmpNpdidCompany" varchar NOT NULL ,
  "prlOperDateUpdated" varchar DEFAULT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("prlNpdidLicence","cmpNpdidCompany","prlOperDateValidFrom","prlOperDateValidTo")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "licence_petreg_licence"
--

DROP TABLE IF EXISTS "licence_petreg_licence";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "licence_petreg_licence" (
  "ptlName" varchar NOT NULL ,
  "ptlDateAwarded" varchar NOT NULL,
  "ptlDateValidFrom" varchar NOT NULL ,
  "ptlDateValidTo" varchar NOT NULL ,
  "prlNpdidLicence" varchar NOT NULL ,
  "ptlDateUpdated" varchar DEFAULT NULL ,
  "ptlDateUpdatedMax" varchar NOT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("prlNpdidLicence")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "licence_petreg_licence_licencee"
--

DROP TABLE IF EXISTS "licence_petreg_licence_licencee";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "licence_petreg_licence_licencee" (
  "ptlName" varchar NOT NULL ,
  "cmpLongName" varchar(200) NOT NULL ,
  "ptlLicenseeInterest" varchar NOT NULL ,
  "prlNpdidLicence" varchar NOT NULL ,
  "cmpNpdidCompany" varchar NOT NULL ,
  "ptlLicenseeDateUpdated" varchar DEFAULT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("prlNpdidLicence","cmpNpdidCompany")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "licence_petreg_licence_oper"
--

DROP TABLE IF EXISTS "licence_petreg_licence_oper";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "licence_petreg_licence_oper" (
  "ptlName" varchar NOT NULL ,
  "cmpLongName" varchar(200) NOT NULL ,
  "prlNpdidLicence" varchar NOT NULL ,
  "cmpNpdidCompany" varchar NOT NULL ,
  "ptlOperDateUpdated" varchar DEFAULT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("prlNpdidLicence")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "licence_petreg_message"
--

DROP TABLE IF EXISTS "licence_petreg_message";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "licence_petreg_message" (
  "prlName" varchar(50) NOT NULL ,
  "ptlMessageDocumentNo" varchar NOT NULL,
  "ptlMessage" text NOT NULL ,
  "ptlMessageRegisteredDate" varchar NOT NULL ,
  "ptlMessageKindDesc" varchar(100) NOT NULL ,
  "ptlMessageDateUpdated" varchar DEFAULT NULL ,
  "prlNpdidLicence" varchar NOT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("prlNpdidLicence","ptlMessageDocumentNo")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "licence_phase_hst"
--

DROP TABLE IF EXISTS "licence_phase_hst";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "licence_phase_hst" (
  "prlName" varchar(50) NOT NULL ,
  "prlDatePhaseValidFrom" varchar NOT NULL DEFAULT '1900-01-01' ,
  "prlDatePhaseValidTo" varchar NOT NULL DEFAULT '1900-01-01' ,
  "prlPhase" varchar NOT NULL ,
  "prlDateGranted" varchar NOT NULL ,
  "prlDateValidTo" varchar NOT NULL ,
  "prlDateInitialPeriodExpires" varchar NOT NULL ,
  "prlActiveStatusIndicator" varchar NOT NULL ,
  "prlNpdidLicence" varchar NOT NULL ,
  "prlPhaseDateUpdated" varchar DEFAULT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("prlNpdidLicence","prlPhase","prlDatePhaseValidFrom","prlDatePhaseValidTo")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "licence_task"
--

DROP TABLE IF EXISTS "licence_task";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "licence_task" (
  "prlName" varchar(50) NOT NULL ,
  "prlTaskName" varchar NOT NULL ,
  "prlTaskTypeNo" varchar(100) NOT NULL,
  "prlTaskTypeEn" varchar(200) NOT NULL ,
  "prlTaskStatusNo" varchar(100) NOT NULL,
  "prlTaskStatusEn" varchar NOT NULL ,
  "prlTaskExpiryDate" varchar NOT NULL ,
  "wlbName" varchar(60) DEFAULT NULL ,
  "prlDateValidTo" varchar NOT NULL ,
  "prlLicensingActivityName" varchar NOT NULL ,
  "cmpLongName" varchar(200) DEFAULT NULL ,
  "cmpNpdidCompany" varchar DEFAULT NULL ,
  "prlNpdidLicence" varchar NOT NULL ,
  "prlTaskID" varchar NOT NULL ,
  "prlTaskRefID" varchar DEFAULT NULL ,
  "prlTaskDateUpdated" varchar DEFAULT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("prlNpdidLicence","prlTaskID")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "licence_transfer_hst"
--

DROP TABLE IF EXISTS "licence_transfer_hst";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "licence_transfer_hst" (
  "prlName" varchar(50) NOT NULL ,
  "prlTransferDateValidFrom" varchar NOT NULL ,
  "prlTransferDirection" varchar(4) NOT NULL ,
  "prlTransferKind" varchar DEFAULT NULL ,
  "cmpLongName" varchar(200) NOT NULL ,
  "prlTransferredInterest" varchar NOT NULL ,
  "prlTransferSdfi" varchar DEFAULT NULL ,
  "prlNpdidLicence" varchar NOT NULL ,
  "cmpNpdidCompany" varchar NOT NULL ,
  "prlTransferDateUpdated" varchar DEFAULT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("prlNpdidLicence","prlTransferDirection","cmpNpdidCompany","prlTransferDateValidFrom")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "pipLine"
--

DROP TABLE IF EXISTS "pipLine";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "pipLine" (
  "pipNpdidPipe" varchar NOT NULL,
  "pipNpdidFromFacility" varchar NOT NULL,
  "pipNpdidToFacility" varchar NOT NULL,
  "pipNpdidOperator" varchar DEFAULT NULL,
  "pipName" varchar(50) NOT NULL,
  "pipNameFromFacility" varchar(50) NOT NULL,
  "pipNameToFacility" varchar(50) NOT NULL,
  "pipNameCurrentOperator" varchar(100) DEFAULT NULL,
  "pipCurrentPhase" varchar NOT NULL,
  "pipMedium" varchar(20) NOT NULL,
  "pipMainGrouping" varchar(20) NOT NULL,
  "pipDimension" varchar NOT NULL,
  PRIMARY KEY ("pipNpdidPipe")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "prlArea"
--

DROP TABLE IF EXISTS "prlArea";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "prlArea" (
  "prlName" varchar(50) NOT NULL ,
  "prlActive" varchar(20) NOT NULL ,
  "prlCurrentArea" varchar(20) NOT NULL ,
  "prlDateGranted" varchar NOT NULL ,
  "prlDateValidTo" varchar NOT NULL ,
  "prlAreaPolyDateValidFrom" varchar NOT NULL ,
  "prlAreaPolyDateValidTo" varchar NOT NULL DEFAULT '1900-01-01' ,
  "prlAreaPolyFromZvalue" varchar NOT NULL,
  "prlAreaPolyToZvalue" varchar NOT NULL,
  "prlAreaPolyVertLimEn" text,
  "prlAreaPolyVertLimNo" text,
  "prlStratigraphical" varchar(3) NOT NULL,
  "prlAreaPolyStratigraphical" varchar(4) NOT NULL ,
  "prlNpdidLicence" varchar NOT NULL ,
  "prlLastOperatorNameShort" varchar NOT NULL,
  "prlLastOperatorNameLong" varchar(200) NOT NULL,
  "prlLicensingActivityName" varchar NOT NULL ,
  "prlLastOperatorNpdidCompany" varchar NOT NULL,
  "prlFactUrl" varchar(200) NOT NULL,
  "prlArea_id" varchar  NOT NULL,
  PRIMARY KEY ("prlArea_id","prlNpdidLicence","prlAreaPolyDateValidFrom","prlAreaPolyDateValidTo")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "prlAreaSplitByBlock"
--

DROP TABLE IF EXISTS "prlAreaSplitByBlock";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "prlAreaSplitByBlock" (
  "prlName" varchar(50) NOT NULL ,
  "prlActive" varchar(20) NOT NULL ,
  "prlCurrentArea" varchar(20) NOT NULL ,
  "prlDateGranted" varchar NOT NULL ,
  "prlDateValidTo" varchar NOT NULL ,
  "prlAreaPolyDateValidFrom" varchar NOT NULL ,
  "prlAreaPolyDateValidTo" varchar NOT NULL DEFAULT '1900-01-01' ,
  "prlAreaPolyPolyNo" varchar NOT NULL,
  "prlAreaPolyPolyArea" varchar NOT NULL ,
  "blcName" varchar NOT NULL ,
  "prlAreaPolyFromZvalue" varchar NOT NULL,
  "prlAreaPolyToZvalue" varchar NOT NULL,
  "prlAreaPolyVertLimEn" text,
  "prlAreaPolyVertLimNo" text,
  "prlStratigraphical" varchar(3) NOT NULL,
  "prlLastOperatorNpdidCompany" varchar NOT NULL,
  "prlLastOperatorNameShort" varchar NOT NULL,
  "prlLastOperatorNameLong" varchar(200) NOT NULL,
  "prlLicensingActivityName" varchar NOT NULL ,
  "prlFactUrl" varchar(200) NOT NULL,
  "prlAreaPolyStratigraphical" varchar(4) NOT NULL ,
  "prlNpdidLicence" varchar NOT NULL ,
  PRIMARY KEY ("prlNpdidLicence","blcName","prlAreaPolyPolyNo","prlAreaPolyDateValidFrom","prlAreaPolyDateValidTo")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "seaArea"
--

DROP TABLE IF EXISTS "seaArea";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "seaArea" (
  "seaSurveyName" varchar(100) NOT NULL ,
  "seaNpdidSurvey" varchar NOT NULL ,
  "seaFactMapUrl" varchar(260) DEFAULT NULL ,
  "seaFactPageUrl" varchar(200) DEFAULT NULL,
  "seaStatus" varchar(100) NOT NULL ,
  "seaGeographicalArea" varchar(100) NOT NULL,
  "seaMarketAvailable" varchar(20) NOT NULL ,
  "seaSurveyTypeMain" varchar(100) NOT NULL ,
  "seaSurveyTypePart" varchar(100) DEFAULT NULL ,
  "seaCompanyReported" varchar(100) NOT NULL ,
  "seaSourceType" varchar(100) DEFAULT NULL ,
  "seaSourceNumber" varchar(100) DEFAULT NULL ,
  "seaSourceSize" varchar(100) DEFAULT NULL ,
  "seaSourcePressure" varchar(100) DEFAULT NULL ,
  "seaSensorType" varchar(100) DEFAULT NULL ,
  "seaSensorNumbers" varchar DEFAULT NULL ,
  "seaSensorLength" varchar(100) DEFAULT NULL ,
  "seaPlanFromDate" varchar NOT NULL ,
  "seaDateStarting" varchar DEFAULT NULL ,
  "seaPlanToDate" varchar NOT NULL ,
  "seaDateFinalized" varchar DEFAULT NULL ,
  "seaPlanCdpKm" varchar DEFAULT NULL ,
  "seaCdpTotalKm" varchar DEFAULT NULL ,
  "seaPlanBoatKm" varchar DEFAULT NULL ,
  "seaBoatTotalKm" varchar DEFAULT NULL ,
  "sea3DKm2" varchar DEFAULT NULL ,
  "seaPolygonKind" varchar(100) NOT NULL ,
  "seaArea_id" varchar  NOT NULL,
  PRIMARY KEY ("seaArea_id","seaSurveyName")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "seaMultiline"
--

DROP TABLE IF EXISTS "seaMultiline";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "seaMultiline" (
  "seaSurveyName" varchar(100) NOT NULL ,
  "seaFactMapUrl" varchar(260) DEFAULT NULL ,
  "seaFactPageUrl" varchar(200) DEFAULT NULL,
  "seaStatus" varchar(100) NOT NULL ,
  "seaMarketAvailable" varchar(20) NOT NULL ,
  "seaSurveyTypeMain" varchar(100) NOT NULL ,
  "seaSurveyTypePart" varchar(100) NOT NULL ,
  "seaCompanyReported" varchar(100) NOT NULL ,
  "seaSourceType" varchar(100) NOT NULL ,
  "seaSourceNumber" varchar(100) DEFAULT NULL ,
  "seaSourceSize" varchar(100) DEFAULT NULL ,
  "seaSourcePressure" varchar(100) DEFAULT NULL ,
  "seaSensorType" varchar(100) NOT NULL ,
  "seaSensorNumbers" varchar NOT NULL ,
  "seaSensorLength" varchar(100) NOT NULL ,
  "seaPlanFromDate" varchar NOT NULL ,
  "seaDateStarting" varchar DEFAULT NULL ,
  "seaPlanToDate" varchar NOT NULL ,
  "seaDateFinalized" varchar DEFAULT NULL ,
  "seaPlanCdpKm" varchar NOT NULL ,
  "seaCdpTotalKm" varchar DEFAULT NULL ,
  "seaPlanBoatKm" varchar NOT NULL ,
  "seaBoatTotalKm" varchar DEFAULT NULL ,
  PRIMARY KEY ("seaSurveyName")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "seis_acquisition"
--

DROP TABLE IF EXISTS "seis_acquisition";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "seis_acquisition" (
  "seaName" varchar(100) NOT NULL ,
  "seaPlanFromDate" varchar NOT NULL ,
  "seaNpdidSurvey" varchar NOT NULL ,
  "seaStatus" varchar(100) NOT NULL ,
  "seaGeographicalArea" varchar(100) NOT NULL,
  "seaSurveyTypeMain" varchar(100) NOT NULL ,
  "seaSurveyTypePart" varchar(100) DEFAULT NULL ,
  "seaCompanyReported" varchar(100) NOT NULL ,
  "seaPlanToDate" varchar NOT NULL ,
  "seaDateStarting" varchar DEFAULT NULL ,
  "seaDateFinalized" varchar DEFAULT NULL ,
  "seaCdpTotalKm" varchar DEFAULT NULL ,
  "seaBoatTotalKm" varchar DEFAULT NULL ,
  "sea3DKm2" varchar DEFAULT NULL ,
  "seaSampling" varchar(20) DEFAULT NULL ,
  "seaShallowDrilling" varchar(20) DEFAULT NULL ,
  "seaGeotechnical" varchar(20) DEFAULT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("seaNpdidSurvey","seaName")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "seis_acquisition_coordinates_inc_turnarea"
--

DROP TABLE IF EXISTS "seis_acquisition_coordinates_inc_turnarea";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "seis_acquisition_coordinates_inc_turnarea" (
  "seaSurveyName" varchar(100) NOT NULL ,
  "seaNpdidSurvey" varchar NOT NULL ,
  "seaPolygonPointNumber" varchar NOT NULL ,
  "seaPolygonNSDeg" varchar NOT NULL ,
  "seaPolygonNSMin" varchar NOT NULL ,
  "seaPolygonNSSec" varchar NOT NULL ,
  "seaPolygonEWDeg" varchar NOT NULL ,
  "seaPolygonEWMin" varchar NOT NULL ,
  "seaPolygonEWSec" varchar NOT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("seaSurveyName","seaPolygonPointNumber")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "seis_acquisition_progress"
--

DROP TABLE IF EXISTS "seis_acquisition_progress";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "seis_acquisition_progress" (
  "seaProgressDate" varchar NOT NULL,
  "seaProgressText2" varchar NOT NULL,
  "seaProgressText" text NOT NULL,
  "seaProgressDescription" text,
  "seaNpdidSurvey" varchar NOT NULL ,
  "seis_acquisition_progress_id" varchar  NOT NULL,
  PRIMARY KEY ("seis_acquisition_progress_id","seaProgressText2")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "strat_litho_wellbore"
--

DROP TABLE IF EXISTS "strat_litho_wellbore";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "strat_litho_wellbore" (
  "wlbName" varchar(60) NOT NULL ,
  "lsuTopDepth" varchar NOT NULL ,
  "lsuBottomDepth" varchar NOT NULL ,
  "lsuName" varchar(20) NOT NULL ,
  "lsuLevel" varchar(9) NOT NULL ,
  "lsuNpdidLithoStrat" varchar NOT NULL ,
  "wlbCompletionDate" varchar NOT NULL ,
  "wlbNpdidWellbore" varchar NOT NULL ,
  "lsuWellboreUpdatedDate" varchar DEFAULT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("wlbNpdidWellbore","lsuNpdidLithoStrat","lsuTopDepth","lsuBottomDepth")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "strat_litho_wellbore_core"
--

DROP TABLE IF EXISTS "strat_litho_wellbore_core";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "strat_litho_wellbore_core" (
  "wlbName" varchar(60) NOT NULL ,
  "lsuCoreLenght" varchar NOT NULL ,
  "lsuName" varchar(20) NOT NULL ,
  "lsuLevel" varchar(9) NOT NULL ,
  "wlbCompletionDate" varchar NOT NULL ,
  "lsuNpdidLithoStrat" varchar NOT NULL ,
  "wlbNpdidWellbore" varchar NOT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("wlbNpdidWellbore","lsuNpdidLithoStrat")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "tuf_operator_hst"
--

DROP TABLE IF EXISTS "tuf_operator_hst";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "tuf_operator_hst" (
  "tufName" varchar NOT NULL ,
  "cmpLongName" varchar(200) NOT NULL ,
  "tufOperDateValidFrom" varchar NOT NULL ,
  "tufOperDateValidTo" varchar NOT NULL DEFAULT '1900-01-01' ,
  "tufNpdidTuf" varchar NOT NULL ,
  "cmpNpdidCompany" varchar NOT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("tufNpdidTuf","cmpNpdidCompany","tufOperDateValidFrom","tufOperDateValidTo")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "tuf_owner_hst"
--

DROP TABLE IF EXISTS "tuf_owner_hst";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "tuf_owner_hst" (
  "tufName" varchar NOT NULL ,
  "cmpLongName" varchar(200) NOT NULL ,
  "tufOwnerDateValidFrom" varchar NOT NULL ,
  "tufOwnerDateValidTo" varchar NOT NULL DEFAULT '1900-01-01' ,
  "tufOwnerShare" varchar NOT NULL ,
  "tufNpdidTuf" varchar NOT NULL ,
  "cmpNpdidCompany" varchar NOT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("tufNpdidTuf","cmpNpdidCompany","tufOwnerDateValidFrom","tufOwnerDateValidTo")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "tuf_petreg_licence"
--

DROP TABLE IF EXISTS "tuf_petreg_licence";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "tuf_petreg_licence" (
  "ptlName" varchar NOT NULL ,
  "tufName" varchar NOT NULL ,
  "ptlDateValidFrom" varchar NOT NULL ,
  "ptlDateValidTo" varchar NOT NULL ,
  "tufNpdidTuf" varchar NOT NULL ,
  "ptlDateUpdated" varchar DEFAULT NULL ,
  "ptlDateUpdatedMax" varchar NOT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("tufNpdidTuf")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "tuf_petreg_licence_licencee"
--

DROP TABLE IF EXISTS "tuf_petreg_licence_licencee";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "tuf_petreg_licence_licencee" (
  "ptlName" varchar NOT NULL ,
  "cmpLongName" varchar(200) NOT NULL ,
  "ptlLicenseeInterest" varchar NOT NULL ,
  "tufName" varchar NOT NULL ,
  "tufNpdidTuf" varchar NOT NULL ,
  "cmpNpdidCompany" varchar NOT NULL ,
  "ptlLicenseeDateUpdated" varchar DEFAULT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("tufNpdidTuf","cmpNpdidCompany")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "tuf_petreg_licence_oper"
--

DROP TABLE IF EXISTS "tuf_petreg_licence_oper";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "tuf_petreg_licence_oper" (
  "Textbox42" varchar(20) NOT NULL,
  "Textbox2" varchar(20) NOT NULL,
  "ptlName" varchar NOT NULL ,
  "cmpLongName" varchar(200) NOT NULL ,
  "tufName" varchar NOT NULL ,
  "tufNpdidTuf" varchar NOT NULL ,
  "cmpNpdidCompany" varchar NOT NULL ,
  "ptlOperDateUpdated" varchar DEFAULT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("tufNpdidTuf")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "tuf_petreg_message"
--

DROP TABLE IF EXISTS "tuf_petreg_message";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "tuf_petreg_message" (
  "ptlName" varchar NOT NULL ,
  "ptlMessageDocumentNo" varchar NOT NULL,
  "ptlMessage" text NOT NULL ,
  "ptlMessageRegisteredDate" varchar NOT NULL ,
  "ptlMessageKindDesc" varchar(100) NOT NULL ,
  "tufName" varchar NOT NULL ,
  "ptlMessageDateUpdated" varchar DEFAULT NULL ,
  "tufNpdidTuf" varchar NOT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("tufNpdidTuf","ptlMessageDocumentNo")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "wellbore_casing_and_lot"
--

DROP TABLE IF EXISTS "wellbore_casing_and_lot";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "wellbore_casing_and_lot" (
  "wlbName" varchar(60) NOT NULL ,
  "wlbCasingType" varchar(10) DEFAULT NULL ,
  "wlbCasingDiameter" varchar(6) DEFAULT NULL ,
  "wlbCasingDepth" varchar NOT NULL ,
  "wlbHoleDiameter" varchar(6) DEFAULT NULL ,
  "wlbHoleDepth" varchar NOT NULL ,
  "wlbLotMudDencity" varchar NOT NULL ,
  "wlbNpdidWellbore" varchar NOT NULL ,
  "wlbCasingDateUpdated" varchar DEFAULT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  "wellbore_casing_and_lot_id" varchar  NOT NULL,
  PRIMARY KEY ("wellbore_casing_and_lot_id","wlbNpdidWellbore")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "wellbore_coordinates"
--

DROP TABLE IF EXISTS "wellbore_coordinates";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "wellbore_coordinates" (
  "wlbWellboreName" varchar NOT NULL ,
  "wlbDrillingOperator" varchar(60) NOT NULL ,
  "wlbProductionLicence" varchar DEFAULT NULL ,
  "wlbWellType" varchar(20) DEFAULT NULL ,
  "wlbPurposePlanned" varchar DEFAULT NULL ,
  "wlbContent" varchar DEFAULT NULL ,
  "wlbEntryDate" varchar DEFAULT NULL ,
  "wlbCompletionDate" varchar DEFAULT NULL ,
  "wlbField" varchar DEFAULT NULL ,
  "wlbMainArea" varchar NOT NULL ,
  "wlbGeodeticDatum" varchar(6) DEFAULT NULL ,
  "wlbNsDeg" varchar NOT NULL ,
  "wlbNsMin" varchar NOT NULL ,
  "wlbNsSec" varchar NOT NULL ,
  "wlbNsCode" varchar(2) DEFAULT NULL ,
  "wlbEwDeg" varchar NOT NULL ,
  "wlbEwMin" varchar NOT NULL ,
  "wlbEwSec" varchar NOT NULL ,
  "wlbEwCode" varchar(2) DEFAULT NULL ,
  "wlbNsDecDeg" varchar NOT NULL ,
  "wlbEwDesDeg" varchar NOT NULL ,
  "wlbNsUtm" varchar NOT NULL ,
  "wlbEwUtm" varchar NOT NULL ,
  "wlbUtmZone" varchar NOT NULL ,
  "wlbNpdidWellbore" varchar NOT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("wlbNpdidWellbore")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "wellbore_core"
--

DROP TABLE IF EXISTS "wellbore_core";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "wellbore_core" (
  "wlbName" varchar(60) NOT NULL ,
  "wlbCoreNumber" varchar NOT NULL ,
  "wlbCoreIntervalTop" varchar DEFAULT NULL ,
  "wlbCoreIntervalBottom" varchar DEFAULT NULL ,
  "wlbCoreIntervalUom" varchar(6) DEFAULT NULL ,
  "wlbTotalCoreLength" varchar NOT NULL ,
  "wlbNumberOfCores" varchar NOT NULL ,
  "wlbCoreSampleAvailable" varchar(3) NOT NULL ,
  "wlbNpdidWellbore" varchar NOT NULL ,
  "wlbCoreDateUpdated" varchar DEFAULT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  "wellbore_core_id" varchar  NOT NULL,
  PRIMARY KEY ("wellbore_core_id","wlbNpdidWellbore","wlbCoreNumber")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "wellbore_core_photo"
--

DROP TABLE IF EXISTS "wellbore_core_photo";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "wellbore_core_photo" (
  "wlbName" varchar(60) NOT NULL ,
  "wlbCoreNumber" varchar NOT NULL ,
  "wlbCorePhotoTitle" varchar(200) NOT NULL ,
  "wlbCorePhotoImgUrl" varchar(200) NOT NULL ,
  "wlbNpdidWellbore" varchar NOT NULL ,
  "wlbCorePhotoDateUpdated" varchar DEFAULT NULL ,
  "wellbore_core_photo_id" varchar  NOT NULL,
  PRIMARY KEY ("wellbore_core_photo_id","wlbNpdidWellbore","wlbCoreNumber","wlbCorePhotoTitle")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "wellbore_development_all"
--

DROP TABLE IF EXISTS "wellbore_development_all";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "wellbore_development_all" (
  "wlbWellboreName" varchar NOT NULL ,
  "wlbWell" varchar NOT NULL ,
  "wlbDrillingOperator" varchar(60) NOT NULL ,
  "wlbDrillingOperatorGroup" varchar(20) NOT NULL ,
  "wlbProductionLicence" varchar NOT NULL ,
  "wlbPurposePlanned" varchar DEFAULT NULL ,
  "wlbContent" varchar DEFAULT NULL ,
  "wlbWellType" varchar(20) NOT NULL ,
  "wlbEntryDate" varchar DEFAULT NULL ,
  "wlbCompletionDate" varchar DEFAULT NULL ,
  "wlbField" varchar NOT NULL ,
  "wlbDrillPermit" varchar(10) NOT NULL ,
  "wlbDiscovery" varchar NOT NULL ,
  "wlbDiscoveryWellbore" varchar(3) NOT NULL ,
  "wlbKellyBushElevation" varchar NOT NULL ,
  "wlbFinalVerticalDepth" varchar DEFAULT NULL ,
  "wlbTotalDepth" varchar NOT NULL ,
  "wlbWaterDepth" varchar NOT NULL ,
  "wlbMainArea" varchar NOT NULL ,
  "wlbDrillingFacility" varchar(50) DEFAULT NULL ,
  "wlbFacilityTypeDrilling" varchar DEFAULT NULL ,
  "wlbProductionFacility" varchar(50) DEFAULT NULL ,
  "wlbLicensingActivity" varchar NOT NULL ,
  "wlbMultilateral" varchar(3) NOT NULL ,
  "wlbContentPlanned" varchar DEFAULT NULL ,
  "wlbEntryYear" varchar NOT NULL ,
  "wlbCompletionYear" varchar NOT NULL ,
  "wlbReclassFromWellbore" varchar DEFAULT NULL ,
  "wlbPlotSymbol" varchar NOT NULL ,
  "wlbGeodeticDatum" varchar(6) DEFAULT NULL ,
  "wlbNsDeg" varchar NOT NULL ,
  "wlbNsMin" varchar NOT NULL ,
  "wlbNsSec" varchar NOT NULL ,
  "wlbNsCode" varchar(2) NOT NULL ,
  "wlbEwDeg" varchar NOT NULL ,
  "wlbEwMin" varchar NOT NULL ,
  "wlbEwSec" varchar NOT NULL ,
  "wlbEwCode" varchar(2) DEFAULT NULL ,
  "wlbNsDecDeg" varchar NOT NULL ,
  "wlbEwDesDeg" varchar NOT NULL ,
  "wlbNsUtm" varchar NOT NULL ,
  "wlbEwUtm" varchar NOT NULL ,
  "wlbUtmZone" varchar NOT NULL ,
  "wlbNamePart1" varchar NOT NULL ,
  "wlbNamePart2" varchar NOT NULL ,
  "wlbNamePart3" varchar(2) NOT NULL ,
  "wlbNamePart4" varchar NOT NULL ,
  "wlbNamePart5" varchar(2) DEFAULT NULL ,
  "wlbNamePart6" varchar(2) DEFAULT NULL ,
  "wlbFactPageUrl" varchar(200) NOT NULL ,
  "wlbFactMapUrl" varchar(200) NOT NULL ,
  "wlbDiskosWellboreType" varchar(20) NOT NULL ,
  "wlbDiskosWellboreParent" varchar DEFAULT NULL ,
  "wlbNpdidWellbore" varchar NOT NULL ,
  "dscNpdidDiscovery" varchar NOT NULL ,
  "fldNpdidField" varchar NOT NULL ,
  "wlbWdssQcdate" varchar DEFAULT NULL,
  "prlNpdidProductionLicence" varchar NOT NULL ,
  "fclNpdidFacilityDrilling" varchar DEFAULT NULL ,
  "fclNpdidFacilityProducing" varchar DEFAULT NULL ,
  "wlbNpdidWellboreReclass" varchar NOT NULL ,
  "wlbDiskosWellOperator" varchar NOT NULL ,
  "wlbDateUpdated" varchar NOT NULL ,
  "wlbDateUpdatedMax" varchar NOT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("wlbNpdidWellbore")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "wellbore_document"
--

DROP TABLE IF EXISTS "wellbore_document";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "wellbore_document" (
  "wlbName" varchar(60) NOT NULL ,
  "wlbDocumentType" varchar NOT NULL ,
  "wlbDocumentName" varchar(200) NOT NULL ,
  "wlbDocumentUrl" varchar(200) NOT NULL ,
  "wlbDocumentFormat" varchar NOT NULL ,
  "wlbDocumentSize" varchar NOT NULL ,
  "wlbNpdidWellbore" varchar NOT NULL ,
  "wlbDocumentDateUpdated" varchar DEFAULT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  "wellbore_document_id" varchar  NOT NULL,
  PRIMARY KEY ("wellbore_document_id","wlbNpdidWellbore","wlbDocumentName")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "wellbore_dst"
--

DROP TABLE IF EXISTS "wellbore_dst";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "wellbore_dst" (
  "wlbName" varchar(60) NOT NULL ,
  "wlbDstTestNumber" varchar NOT NULL ,
  "wlbDstFromDepth" varchar NOT NULL ,
  "wlbDstToDepth" varchar NOT NULL ,
  "wlbDstChokeSize" varchar NOT NULL ,
  "wlbDstFinShutInPress" varchar NOT NULL ,
  "wlbDstFinFlowPress" varchar NOT NULL ,
  "wlbDstBottomHolePress" varchar NOT NULL ,
  "wlbDstOilProd" varchar NOT NULL ,
  "wlbDstGasProd" varchar NOT NULL ,
  "wlbDstOilDensity" varchar NOT NULL ,
  "wlbDstGasDensity" varchar NOT NULL ,
  "wlbDstGasOilRelation" varchar NOT NULL ,
  "wlbNpdidWellbore" varchar NOT NULL ,
  "wlbDstDateUpdated" varchar DEFAULT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("wlbNpdidWellbore","wlbDstTestNumber")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "wellbore_exploration_all"
--

DROP TABLE IF EXISTS "wellbore_exploration_all";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "wellbore_exploration_all" (
  "wlbWellboreName" varchar NOT NULL ,
  "wlbWell" varchar NOT NULL ,
  "wlbDrillingOperator" varchar(60) NOT NULL ,
  "wlbDrillingOperatorGroup" varchar(20) NOT NULL ,
  "wlbProductionLicence" varchar NOT NULL ,
  "wlbPurpose" varchar NOT NULL ,
  "wlbStatus" varchar DEFAULT NULL ,
  "wlbContent" varchar DEFAULT NULL ,
  "wlbWellType" varchar(20) NOT NULL ,
  "wlbEntryDate" varchar DEFAULT NULL ,
  "wlbCompletionDate" varchar DEFAULT NULL ,
  "wlbField" varchar DEFAULT NULL ,
  "wlbDrillPermit" varchar(10) NOT NULL ,
  "wlbDiscovery" varchar DEFAULT NULL ,
  "wlbDiscoveryWellbore" varchar(3) NOT NULL ,
  "wlbBottomHoleTemperature" varchar DEFAULT NULL ,
  "wlbSeismicLocation" varchar(200) DEFAULT NULL ,
  "wlbMaxInclation" varchar DEFAULT NULL ,
  "wlbKellyBushElevation" varchar NOT NULL ,
  "wlbFinalVerticalDepth" varchar DEFAULT NULL ,
  "wlbTotalDepth" varchar NOT NULL ,
  "wlbWaterDepth" varchar NOT NULL ,
  "wlbAgeAtTd" varchar DEFAULT NULL ,
  "wlbFormationAtTd" varchar DEFAULT NULL ,
  "wlbMainArea" varchar NOT NULL ,
  "wlbDrillingFacility" varchar(50) NOT NULL ,
  "wlbFacilityTypeDrilling" varchar NOT NULL ,
  "wlbLicensingActivity" varchar NOT NULL ,
  "wlbMultilateral" varchar(3) NOT NULL ,
  "wlbPurposePlanned" varchar NOT NULL ,
  "wlbEntryYear" varchar NOT NULL ,
  "wlbCompletionYear" varchar NOT NULL ,
  "wlbReclassFromWellbore" varchar DEFAULT NULL ,
  "wlbReentryExplorationActivity" varchar DEFAULT NULL ,
  "wlbPlotSymbol" varchar NOT NULL ,
  "wlbFormationWithHc1" varchar(20) DEFAULT NULL ,
  "wlbAgeWithHc1" varchar(20) DEFAULT NULL ,
  "wlbFormationWithHc2" varchar(20) DEFAULT NULL ,
  "wlbAgeWithHc2" varchar(20) DEFAULT NULL ,
  "wlbFormationWithHc3" varchar(20) DEFAULT NULL ,
  "wlbAgeWithHc3" char(20) DEFAULT NULL ,
  "wlbDrillingDays" varchar NOT NULL ,
  "wlbReentry" varchar(3) NOT NULL ,
  "wlbGeodeticDatum" varchar(6) DEFAULT NULL ,
  "wlbNsDeg" varchar NOT NULL ,
  "wlbNsMin" varchar NOT NULL ,
  "wlbNsSec" varchar NOT NULL ,
  "wlbNsCode" varchar(2) NOT NULL ,
  "wlbEwDeg" varchar NOT NULL ,
  "wlbEwMin" varchar NOT NULL ,
  "wlbEwSec" varchar NOT NULL ,
  "wlbEwCode" varchar(2) NOT NULL ,
  "wlbNsDecDeg" varchar NOT NULL ,
  "wlbEwDesDeg" varchar NOT NULL ,
  "wlbNsUtm" varchar NOT NULL ,
  "wlbEwUtm" varchar NOT NULL ,
  "wlbUtmZone" varchar NOT NULL ,
  "wlbNamePart1" varchar NOT NULL ,
  "wlbNamePart2" varchar NOT NULL ,
  "wlbNamePart3" varchar(2) DEFAULT NULL ,
  "wlbNamePart4" varchar NOT NULL ,
  "wlbNamePart5" varchar(2) DEFAULT NULL ,
  "wlbNamePart6" varchar(2) DEFAULT NULL ,
  "wlbPressReleaseUrl" varchar(200) DEFAULT NULL,
  "wlbFactPageUrl" varchar(200) NOT NULL ,
  "wlbFactMapUrl" varchar(200) NOT NULL ,
  "wlbDiskosWellboreType" varchar(20) NOT NULL ,
  "wlbDiskosWellboreParent" varchar DEFAULT NULL ,
  "wlbWdssQcDate" varchar DEFAULT NULL ,
  "wlbNpdidWellbore" varchar NOT NULL ,
  "dscNpdidDiscovery" varchar DEFAULT NULL ,
  "fldNpdidField" varchar DEFAULT NULL ,
  "fclNpdidFacilityDrilling" varchar NOT NULL ,
  "wlbNpdidWellboreReclass" varchar NOT NULL ,
  "prlNpdidProductionLicence" varchar NOT NULL ,
  "wlbDiskosWellOperator" varchar NOT NULL ,
  "wlbDateUpdated" varchar NOT NULL ,
  "wlbDateUpdatedMax" varchar NOT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("wlbNpdidWellbore")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "wellbore_formation_top"
--

DROP TABLE IF EXISTS "wellbore_formation_top";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "wellbore_formation_top" (
  "wlbName" varchar(60) NOT NULL ,
  "lsuTopDepth" varchar NOT NULL ,
  "lsuBottomDepth" varchar NOT NULL ,
  "lsuName" varchar(20) NOT NULL ,
  "lsuLevel" varchar(9) NOT NULL ,
  "lsuNameParent" varchar(20) DEFAULT NULL ,
  "wlbNpdidWellbore" varchar NOT NULL ,
  "lsuNpdidLithoStrat" varchar NOT NULL ,
  "lsuNpdidLithoStratParent" varchar DEFAULT NULL ,
  "lsuWellboreUpdatedDate" varchar DEFAULT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("wlbNpdidWellbore","lsuNpdidLithoStrat","lsuTopDepth","lsuBottomDepth")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "wellbore_mud"
--

DROP TABLE IF EXISTS "wellbore_mud";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "wellbore_mud" (
  "wlbName" varchar(60) NOT NULL ,
  "wlbMD" varchar NOT NULL ,
  "wlbMudWeightAtMD" varchar NOT NULL ,
  "wlbMudViscosityAtMD" varchar NOT NULL ,
  "wlbYieldPointAtMD" varchar NOT NULL ,
  "wlbMudType" varchar DEFAULT NULL ,
  "wlbMudDateMeasured" varchar DEFAULT NULL ,
  "wlbNpdidWellbore" varchar NOT NULL ,
  "wlbMudDateUpdated" varchar DEFAULT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  "wellbore_mud_id" varchar  NOT NULL,
  PRIMARY KEY ("wellbore_mud_id","wlbNpdidWellbore")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "wellbore_npdid_overview"
--

DROP TABLE IF EXISTS "wellbore_npdid_overview" ;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "wellbore_npdid_overview" (
  "wlbWellboreName" varchar NOT NULL ,
  "wlbNpdidWellbore" varchar NOT NULL ,
  "wlbWell" varchar NOT NULL ,
  "wlbWellType" varchar(20) DEFAULT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("wlbNpdidWellbore")
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table "wellbore_oil_sample"
--

DROP TABLE IF EXISTS "wellbore_oil_sample";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "wellbore_oil_sample" (
  "wlbName" varchar(60) NOT NULL ,
  "wlbOilSampleTestType" varchar(4) DEFAULT NULL ,
  "wlbOilSampleTestNumber" varchar(10) DEFAULT NULL ,
  "wlbOilSampleTopDepth" varchar NOT NULL ,
  "wlbOilSampleBottomDepth" varchar NOT NULL ,
  "wlbOilSampleFluidType" varchar(20) DEFAULT NULL ,
  "wlbOilSampleTestDate" varchar DEFAULT NULL ,
  "wlbOilSampledateReceivedDate" varchar DEFAULT NULL ,
  "wlbNpdidWellbore" varchar NOT NULL ,
  "wlbOilSampleDateUpdated" varchar DEFAULT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  "wellbore_oil_sample_id" varchar  NOT NULL,
  PRIMARY KEY ("wellbore_oil_sample_id","wlbNpdidWellbore")
);
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table "wellbore_shallow_all"
--

DROP TABLE IF EXISTS "wellbore_shallow_all";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "wellbore_shallow_all" (
  "wlbWellboreName" varchar NOT NULL ,
  "wlbNpdidWellbore" varchar NOT NULL ,
  "wlbWell" varchar NOT NULL ,
  "wlbDrillingOperator" varchar(60) NOT NULL ,
  "wlbProductionLicence" varchar DEFAULT NULL ,
  "wlbDrillingFacility" varchar(50) DEFAULT NULL ,
  "wlbEntryDate" varchar DEFAULT NULL ,
  "wlbCompletionDate" varchar DEFAULT NULL ,
  "wlbDrillPermit" varchar(10) NOT NULL ,
  "wlbTotalDepth" varchar NOT NULL ,
  "wlbWaterDepth" varchar NOT NULL ,
  "wlbMainArea" varchar NOT NULL ,
  "wlbEntryYear" varchar NOT NULL ,
  "wlbCompletionYear" varchar NOT NULL ,
  "wlbSeismicLocation" varchar(200) DEFAULT NULL ,
  "wlbGeodeticDatum" varchar(6) DEFAULT NULL ,
  "wlbNsDeg" varchar NOT NULL ,
  "wlbNsMin" varchar NOT NULL ,
  "wlbNsSec" varchar NOT NULL ,
  "wlbNsCode" varchar(2) DEFAULT NULL ,
  "wlbEwDeg" varchar NOT NULL ,
  "wlbEwMin" varchar NOT NULL ,
  "wlbEwSec" varchar NOT NULL ,
  "wlbEwCode" varchar(2) DEFAULT NULL ,
  "wlbNsDecDeg" varchar NOT NULL ,
  "wlbEwDesDeg" varchar NOT NULL ,
  "wlbNsUtm" varchar NOT NULL ,
  "wlbEwUtm" varchar NOT NULL ,
  "wlbUtmZone" varchar NOT NULL ,
  "wlbNamePart1" varchar NOT NULL ,
  "wlbNamePart2" varchar NOT NULL ,
  "wlbNamePart3" varchar(2) NOT NULL ,
  "wlbNamePart4" varchar NOT NULL ,
  "wlbNamePart5" varchar(2) DEFAULT NULL ,
  "wlbNamePart6" varchar(2) DEFAULT NULL ,
  "wlbDateUpdated" varchar NOT NULL ,
  "wlbDateUpdatedMax" varchar NOT NULL ,
  "dateSyncNPD" varchar NOT NULL,
  PRIMARY KEY ("wlbNpdidWellbore")
);
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table "wlbPoint"
--

DROP TABLE IF EXISTS "wlbPoint";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "wlbPoint" (
  "wlbNpdidWellbore" varchar NOT NULL ,
  "wlbWellName" varchar NOT NULL,
  "wlbWellboreName" varchar NOT NULL ,
  "wlbField" varchar DEFAULT NULL ,
  "wlbProductionLicence" varchar DEFAULT NULL ,
  "wlbWellType" varchar(20) DEFAULT NULL ,
  "wlbDrillingOperator" varchar(60) NOT NULL ,
  "wlbMultilateral" varchar(3) NOT NULL ,
  "wlbDrillingFacility" varchar(50) DEFAULT NULL ,
  "wlbProductionFacility" varchar(50) DEFAULT NULL ,
  "wlbEntryDate" varchar DEFAULT NULL ,
  "wlbCompletionDate" varchar DEFAULT NULL ,
  "wlbContent" varchar DEFAULT NULL ,
  "wlbStatus" varchar DEFAULT NULL ,
  "wlbSymbol" varchar NOT NULL,
  "wlbPurpose" varchar DEFAULT NULL ,
  "wlbWaterDepth" varchar NOT NULL ,
  "wlbFactPageUrl" varchar(200) DEFAULT NULL ,
  "wlbFactMapUrl" varchar(200) DEFAULT NULL ,
  "wlbDiscoveryWellbore" varchar(3) NOT NULL ,
  PRIMARY KEY ("wlbNpdidWellbore")
);
/*!40101 SET character_set_client = @saved_cs_client */;


/*!40000 ALTER TABLE "wlbPoint" ENABLE KEYS */;
-- UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-03-24 10:29:50
