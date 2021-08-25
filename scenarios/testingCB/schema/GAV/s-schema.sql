DROP TABLE IF EXISTS "src_Acquisition";
CREATE TABLE "src_Acquisition" (c0 text);
DROP TABLE IF EXISTS "src_Address";
CREATE TABLE "src_Address" (c0 text);
DROP TABLE IF EXISTS "src_Company";
CREATE TABLE "src_Company" (c0 text);
DROP TABLE IF EXISTS "src_Dealer";
CREATE TABLE "src_Dealer" (c0 text);
DROP TABLE IF EXISTS "src_FinantialInstrument";
CREATE TABLE "src_FinantialInstrument" (c0 text);
DROP TABLE IF EXISTS "src_Investor";
CREATE TABLE "src_Investor" (c0 text);
DROP TABLE IF EXISTS "src_LegalPerson";
CREATE TABLE "src_LegalPerson" (c0 text);
DROP TABLE IF EXISTS "src_Offer";
CREATE TABLE "src_Offer" (c0 text);
DROP TABLE IF EXISTS "src_Person";
CREATE TABLE "src_Person" (c0 text);
DROP TABLE IF EXISTS "src_PhysicalPerson";
CREATE TABLE "src_PhysicalPerson" (c0 text);
DROP TABLE IF EXISTS "src_Stock";
CREATE TABLE "src_Stock" (c0 text);
DROP TABLE IF EXISTS "src_StockBroker";
CREATE TABLE "src_StockBroker" (c0 text);
DROP TABLE IF EXISTS "src_StockExchangeList";
CREATE TABLE "src_StockExchangeList" (c0 text);
DROP TABLE IF EXISTS "src_StockExchangeMember";
CREATE TABLE "src_StockExchangeMember" (c0 text);
DROP TABLE IF EXISTS "src_StockTrader";
CREATE TABLE "src_StockTrader" (c0 text);
DROP TABLE IF EXISTS "src_Thing";
CREATE TABLE "src_Thing" (c0 text);
DROP TABLE IF EXISTS "src_Trader";
CREATE TABLE "src_Trader" (c0 text);
DROP TABLE IF EXISTS "src_Transaction";
CREATE TABLE "src_Transaction" (c0 text);
DROP TABLE IF EXISTS "src_belongsToCompany";
CREATE TABLE "src_belongsToCompany" (c0 text, c1 text);
DROP TABLE IF EXISTS "src_hasAddress";
CREATE TABLE "src_hasAddress" (c0 text, c1 text);
DROP TABLE IF EXISTS "src_hasStock";
CREATE TABLE "src_hasStock" (c0 text, c1 text);
DROP TABLE IF EXISTS "src_inverseofhasAddress";
CREATE TABLE "src_inverseofhasAddress" (c0 text, c1 text);
DROP TABLE IF EXISTS "src_involvesInstrument";
CREATE TABLE "src_involvesInstrument" (c0 text, c1 text);
DROP TABLE IF EXISTS "src_isExecutedBy";
CREATE TABLE "src_isExecutedBy" (c0 text, c1 text);
DROP TABLE IF EXISTS "src_isExecutedFor";
CREATE TABLE "src_isExecutedFor" (c0 text, c1 text);
DROP TABLE IF EXISTS "src_isListedIn";
CREATE TABLE "src_isListedIn" (c0 text, c1 text);
DROP TABLE IF EXISTS "src_isTradedIn";
CREATE TABLE "src_isTradedIn" (c0 text, c1 text);
DROP TABLE IF EXISTS "src_listsStock";
CREATE TABLE "src_listsStock" (c0 text, c1 text);
DROP TABLE IF EXISTS "src_tradesOnBehalfOf";
CREATE TABLE "src_tradesOnBehalfOf" (c0 text, c1 text);
DROP TABLE IF EXISTS "src_usesBroker";
CREATE TABLE "src_usesBroker" (c0 text, c1 text);