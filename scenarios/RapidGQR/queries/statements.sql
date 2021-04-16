SELECT COUNT(*) FROM (SELECT DISTINCT B."c1", A."c0", C."c1", E."c0" FROM "src_hasStock" as A, "src_listsStock" as B, "src_hasStock" as C, "src_listsStock" as D, "src_StockExchangeList" as E, "src_isListedIn" as F, "src_belongsToCompany" as G WHERE E."c0" = F."c1" AND B."c1" = G."c0" AND A."c0" = C."c0" AND C."c0" = F."c0" AND F."c0" = G."c1" AND C."c1" = D."c1" UNION SELECT DISTINCT A."c0", B."c0", C."c1", E."c0" FROM "src_belongsToCompany" as A, "src_hasStock" as B, "src_hasStock" as C, "src_listsStock" as D, "src_StockExchangeList" as E, "src_isListedIn" as F, "src_belongsToCompany" as G WHERE E."c0" = F."c1" AND A."c0" = G."c0" AND B."c0" = C."c0" AND C."c0" = F."c0" AND F."c0" = G."c1" AND C."c1" = D."c1" UNION SELECT DISTINCT E."c0", A."c0", B."c1", D."c0" FROM "src_hasStock" as A, "src_hasStock" as B, "src_listsStock" as C, "src_StockExchangeList" as D, "src_isListedIn" as E, "src_isListedIn" as F, "src_belongsToCompany" as G WHERE D."c0" = F."c1" AND E."c0" = G."c0" AND A."c0" = B."c0" AND B."c0" = F."c0" AND F."c0" = G."c1" AND B."c1" = C."c1" UNION SELECT DISTINCT A."c0", B."c0", C."c1", E."c0" FROM "src_FinantialInstrument" as A, "src_hasStock" as B, "src_hasStock" as C, "src_listsStock" as D, "src_StockExchangeList" as E, "src_isListedIn" as F, "src_belongsToCompany" as G WHERE E."c0" = F."c1" AND A."c0" = G."c0" AND B."c0" = C."c0" AND C."c0" = F."c0" AND F."c0" = G."c1" AND C."c1" = D."c1" UNION SELECT DISTINCT A."c0", B."c0", C."c1", E."c0" FROM "src_Stock" as A, "src_hasStock" as B, "src_hasStock" as C, "src_listsStock" as D, "src_StockExchangeList" as E, "src_isListedIn" as F, "src_belongsToCompany" as G WHERE E."c0" = F."c1" AND A."c0" = G."c0" AND B."c0" = C."c0" AND C."c0" = F."c0" AND F."c0" = G."c1" AND C."c1" = D."c1" UNION SELECT DISTINCT B."c1", A."c0", C."c1", D."c0" FROM "src_hasStock" as A, "src_listsStock" as B, "src_hasStock" as C, "src_StockExchangeList" as D, "src_belongsToCompany" as E, "src_isListedIn" as F, "src_belongsToCompany" as G WHERE D."c0" = F."c1" AND B."c1" = G."c0" AND A."c0" = C."c0" AND C."c0" = F."c0" AND F."c0" = G."c1" AND C."c1" = E."c0" UNION SELECT DISTINCT A."c0", B."c0", C."c1", D."c0" FROM "src_belongsToCompany" as A, "src_hasStock" as B, "src_hasStock" as C, "src_StockExchangeList" as D, "src_belongsToCompany" as E, "src_isListedIn" as F, "src_belongsToCompany" as G WHERE D."c0" = F."c1" AND A."c0" = G."c0" AND B."c0" = C."c0" AND C."c0" = F."c0" AND F."c0" = G."c1" AND C."c1" = E."c0" UNION SELECT DISTINCT E."c0", A."c0", B."c1", C."c0" FROM "src_hasStock" as A, "src_hasStock" as B, "src_StockExchangeList" as C, "src_belongsToCompany" as D, "src_isListedIn" as E, "src_isListedIn" as F, "src_belongsToCompany" as G WHERE C."c0" = F."c1" AND E."c0" = G."c0" AND A."c0" = B."c0" AND B."c0" = F."c0" AND F."c0" = G."c1" AND B."c1" = D."c0" UNION SELECT DISTINCT A."c0", B."c0", C."c1", D."c0" FROM "src_FinantialInstrument" as A, "src_hasStock" as B, "src_hasStock" as C, "src_StockExchangeList" as D, "src_belongsToCompany" as E, "src_isListedIn" as F, "src_belongsToCompany" as G WHERE D."c0" = F."c1" AND A."c0" = G."c0" AND B."c0" = C."c0" AND C."c0" = F."c0" AND F."c0" = G."c1" AND C."c1" = E."c0" UNION SELECT DISTINCT A."c0", B."c0", C."c1", D."c0" FROM "src_Stock" as A, "src_hasStock" as B, "src_hasStock" as C, "src_StockExchangeList" as D, "src_belongsToCompany" as E, "src_isListedIn" as F, "src_belongsToCompany" as G WHERE D."c0" = F."c1" AND A."c0" = G."c0" AND B."c0" = C."c0" AND C."c0" = F."c0" AND F."c0" = G."c1" AND C."c1" = E."c0" UNION SELECT DISTINCT C."c1", B."c0", A."c0", E."c0" FROM "src_isListedIn" as A, "src_hasStock" as B, "src_listsStock" as C, "src_hasStock" as D, "src_StockExchangeList" as E, "src_isListedIn" as F, "src_belongsToCompany" as G WHERE E."c0" = F."c1" AND C."c1" = G."c0" AND B."c0" = D."c0" AND D."c0" = F."c0" AND F."c0" = G."c1" AND A."c0" = D."c1" UNION SELECT DISTINCT A."c0", C."c0", B."c0", E."c0" FROM "src_belongsToCompany" as A, "src_isListedIn" as B, "src_hasStock" as C, "src_hasStock" as D, "src_StockExchangeList" as E, "src_isListedIn" as F, "src_belongsToCompany" as G WHERE E."c0" = F."c1" AND A."c0" = G."c0" AND C."c0" = D."c0" AND D."c0" = F."c0" AND F."c0" = G."c1" AND B."c0" = D."c1" UNION SELECT DISTINCT E."c0", B."c0", A."c0", D."c0" FROM "src_isListedIn" as A, "src_hasStock" as B, "src_hasStock" as C, "src_StockExchangeList" as D, "src_isListedIn" as E, "src_isListedIn" as F, "src_belongsToCompany" as G WHERE D."c0" = F."c1" AND E."c0" = G."c0" AND B."c0" = C."c0" AND C."c0" = F."c0" AND F."c0" = G."c1" AND A."c0" = C."c1" UNION SELECT DISTINCT B."c0", C."c0", A."c0", E."c0" FROM "src_isListedIn" as A, "src_FinantialInstrument" as B, "src_hasStock" as C, "src_hasStock" as D, "src_StockExchangeList" as E, "src_isListedIn" as F, "src_belongsToCompany" as G WHERE E."c0" = F."c1" AND B."c0" = G."c0" AND C."c0" = D."c0" AND D."c0" = F."c0" AND F."c0" = G."c1" AND A."c0" = D."c1" UNION SELECT DISTINCT B."c0", C."c0", A."c0", E."c0" FROM "src_isListedIn" as A, "src_Stock" as B, "src_hasStock" as C, "src_hasStock" as D, "src_StockExchangeList" as E, "src_isListedIn" as F, "src_belongsToCompany" as G WHERE E."c0" = F."c1" AND B."c0" = G."c0" AND C."c0" = D."c0" AND D."c0" = F."c0" AND F."c0" = G."c1" AND A."c0" = D."c1" UNION SELECT DISTINCT B."c1", A."c0", C."c1", D."c0" FROM "src_hasStock" as A, "src_listsStock" as B, "src_hasStock" as C, "src_StockExchangeList" as D, "src_Stock" as E, "src_isListedIn" as F, "src_belongsToCompany" as G WHERE D."c0" = F."c1" AND B."c1" = G."c0" AND A."c0" = C."c0" AND C."c0" = F."c0" AND F."c0" = G."c1" AND C."c1" = E."c0" UNION SELECT DISTINCT A."c0", B."c0", C."c1", D."c0" FROM "src_belongsToCompany" as A, "src_hasStock" as B, "src_hasStock" as C, "src_StockExchangeList" as D, "src_Stock" as E, "src_isListedIn" as F, "src_belongsToCompany" as G WHERE D."c0" = F."c1" AND A."c0" = G."c0" AND B."c0" = C."c0" AND C."c0" = F."c0" AND F."c0" = G."c1" AND C."c1" = E."c0" UNION SELECT DISTINCT E."c0", A."c0", B."c1", C."c0" FROM "src_hasStock" as A, "src_hasStock" as B, "src_StockExchangeList" as C, "src_Stock" as D, "src_isListedIn" as E, "src_isListedIn" as F, "src_belongsToCompany" as G WHERE C."c0" = F."c1" AND E."c0" = G."c0" AND A."c0" = B."c0" AND B."c0" = F."c0" AND F."c0" = G."c1" AND B."c1" = D."c0" UNION SELECT DISTINCT A."c0", B."c0", C."c1", D."c0" FROM "src_FinantialInstrument" as A, "src_hasStock" as B, "src_hasStock" as C, "src_StockExchangeList" as D, "src_Stock" as E, "src_isListedIn" as F, "src_belongsToCompany" as G WHERE D."c0" = F."c1" AND A."c0" = G."c0" AND B."c0" = C."c0" AND C."c0" = F."c0" AND F."c0" = G."c1" AND C."c1" = E."c0" UNION SELECT DISTINCT A."c0", B."c0", C."c1", D."c0" FROM "src_Stock" as A, "src_hasStock" as B, "src_hasStock" as C, "src_StockExchangeList" as D, "src_Stock" as E, "src_isListedIn" as F, "src_belongsToCompany" as G WHERE D."c0" = F."c1" AND A."c0" = G."c0" AND B."c0" = C."c0" AND C."c0" = F."c0" AND F."c0" = G."c1" AND C."c1" = E."c0" UNION SELECT DISTINCT B."c1", A."c0", C."c1", E."c0" FROM "src_Company" as A, "src_listsStock" as B, "src_hasStock" as C, "src_listsStock" as D, "src_StockExchangeList" as E, "src_isListedIn" as F, "src_belongsToCompany" as G WHERE E."c0" = F."c1" AND B."c1" = G."c0" AND A."c0" = C."c0" AND C."c0" = F."c0" AND F."c0" = G."c1" AND C."c1" = D."c1" UNION SELECT DISTINCT A."c0", B."c0", C."c1", E."c0" FROM "src_belongsToCompany" as A, "src_Company" as B, "src_hasStock" as C, "src_listsStock" as D, "src_StockExchangeList" as E, "src_isListedIn" as F, "src_belongsToCompany" as G WHERE E."c0" = F."c1" AND A."c0" = G."c0" AND B."c0" = C."c0" AND C."c0" = F."c0" AND F."c0" = G."c1" AND C."c1" = D."c1" UNION SELECT DISTINCT E."c0", A."c0", B."c1", D."c0" FROM "src_Company" as A, "src_hasStock" as B, "src_listsStock" as C, "src_StockExchangeList" as D, "src_isListedIn" as E, "src_isListedIn" as F, "src_belongsToCompany" as G WHERE D."c0" = F."c1" AND E."c0" = G."c0" AND A."c0" = B."c0" AND B."c0" = F."c0" AND F."c0" = G."c1" AND B."c1" = C."c1" UNION SELECT DISTINCT A."c0", B."c0", C."c1", E."c0" FROM "src_FinantialInstrument" as A, "src_Company" as B, "src_hasStock" as C, "src_listsStock" as D, "src_StockExchangeList" as E, "src_isListedIn" as F, "src_belongsToCompany" as G WHERE E."c0" = F."c1" AND A."c0" = G."c0" AND B."c0" = C."c0" AND C."c0" = F."c0" AND F."c0" = G."c1" AND C."c1" = D."c1" UNION SELECT DISTINCT A."c0", B."c0", C."c1", E."c0" FROM "src_Stock" as A, "src_Company" as B, "src_hasStock" as C, "src_listsStock" as D, "src_StockExchangeList" as E, "src_isListedIn" as F, "src_belongsToCompany" as G WHERE E."c0" = F."c1" AND A."c0" = G."c0" AND B."c0" = C."c0" AND C."c0" = F."c0" AND F."c0" = G."c1" AND C."c1" = D."c1" UNION SELECT DISTINCT B."c1", A."c0", C."c1", D."c0" FROM "src_Company" as A, "src_listsStock" as B, "src_hasStock" as C, "src_StockExchangeList" as D, "src_belongsToCompany" as E, "src_isListedIn" as F, "src_belongsToCompany" as G WHERE D."c0" = F."c1" AND B."c1" = G."c0" AND A."c0" = C."c0" AND C."c0" = F."c0" AND F."c0" = G."c1" AND C."c1" = E."c0" UNION SELECT DISTINCT A."c0", B."c0", C."c1", D."c0" FROM "src_belongsToCompany" as A, "src_Company" as B, "src_hasStock" as C, "src_StockExchangeList" as D, "src_belongsToCompany" as E, "src_isListedIn" as F, "src_belongsToCompany" as G WHERE D."c0" = F."c1" AND A."c0" = G."c0" AND B."c0" = C."c0" AND C."c0" = F."c0" AND F."c0" = G."c1" AND C."c1" = E."c0" UNION SELECT DISTINCT E."c0", A."c0", B."c1", C."c0" FROM "src_Company" as A, "src_hasStock" as B, "src_StockExchangeList" as C, "src_belongsToCompany" as D, "src_isListedIn" as E, "src_isListedIn" as F, "src_belongsToCompany" as G WHERE C."c0" = F."c1" AND E."c0" = G."c0" AND A."c0" = B."c0" AND B."c0" = F."c0" AND F."c0" = G."c1" AND B."c1" = D."c0" UNION SELECT DISTINCT A."c0", B."c0", C."c1", D."c0" FROM "src_FinantialInstrument" as A, "src_Company" as B, "src_hasStock" as C, "src_StockExchangeList" as D, "src_belongsToCompany" as E, "src_isListedIn" as F, "src_belongsToCompany" as G WHERE D."c0" = F."c1" AND A."c0" = G."c0" AND B."c0" = C."c0" AND C."c0" = F."c0" AND F."c0" = G."c1" AND C."c1" = E."c0" UNION SELECT DISTINCT A."c0", B."c0", C."c1", D."c0" FROM "src_Stock" as A, "src_Company" as B, "src_hasStock" as C, "src_StockExchangeList" as D, "src_belongsToCompany" as E, "src_isListedIn" as F, "src_belongsToCompany" as G WHERE D."c0" = F."c1" AND A."c0" = G."c0" AND B."c0" = C."c0" AND C."c0" = F."c0" AND F."c0" = G."c1" AND C."c1" = E."c0" UNION SELECT DISTINCT C."c1", B."c0", A."c0", E."c0" FROM "src_isListedIn" as A, "src_Company" as B, "src_listsStock" as C, "src_hasStock" as D, "src_StockExchangeList" as E, "src_isListedIn" as F, "src_belongsToCompany" as G WHERE E."c0" = F."c1" AND C."c1" = G."c0" AND B."c0" = D."c0" AND D."c0" = F."c0" AND F."c0" = G."c1" AND A."c0" = D."c1" UNION SELECT DISTINCT A."c0", C."c0", B."c0", E."c0" FROM "src_belongsToCompany" as A, "src_isListedIn" as B, "src_Company" as C, "src_hasStock" as D, "src_StockExchangeList" as E, "src_isListedIn" as F, "src_belongsToCompany" as G WHERE E."c0" = F."c1" AND A."c0" = G."c0" AND C."c0" = D."c0" AND D."c0" = F."c0" AND F."c0" = G."c1" AND B."c0" = D."c1" UNION SELECT DISTINCT E."c0", B."c0", A."c0", D."c0" FROM "src_isListedIn" as A, "src_Company" as B, "src_hasStock" as C, "src_StockExchangeList" as D, "src_isListedIn" as E, "src_isListedIn" as F, "src_belongsToCompany" as G WHERE D."c0" = F."c1" AND E."c0" = G."c0" AND B."c0" = C."c0" AND C."c0" = F."c0" AND F."c0" = G."c1" AND A."c0" = C."c1" UNION SELECT DISTINCT B."c0", C."c0", A."c0", E."c0" FROM "src_isListedIn" as A, "src_FinantialInstrument" as B, "src_Company" as C, "src_hasStock" as D, "src_StockExchangeList" as E, "src_isListedIn" as F, "src_belongsToCompany" as G WHERE E."c0" = F."c1" AND B."c0" = G."c0" AND C."c0" = D."c0" AND D."c0" = F."c0" AND F."c0" = G."c1" AND A."c0" = D."c1" UNION SELECT DISTINCT B."c0", C."c0", A."c0", E."c0" FROM "src_isListedIn" as A, "src_Stock" as B, "src_Company" as C, "src_hasStock" as D, "src_StockExchangeList" as E, "src_isListedIn" as F, "src_belongsToCompany" as G WHERE E."c0" = F."c1" AND B."c0" = G."c0" AND C."c0" = D."c0" AND D."c0" = F."c0" AND F."c0" = G."c1" AND A."c0" = D."c1" UNION SELECT DISTINCT B."c1", A."c0", C."c1", D."c0" FROM "src_Company" as A, "src_listsStock" as B, "src_hasStock" as C, "src_StockExchangeList" as D, "src_Stock" as E, "src_isListedIn" as F, "src_belongsToCompany" as G WHERE D."c0" = F."c1" AND B."c1" = G."c0" AND A."c0" = C."c0" AND C."c0" = F."c0" AND F."c0" = G."c1" AND C."c1" = E."c0" UNION SELECT DISTINCT A."c0", B."c0", C."c1", D."c0" FROM "src_belongsToCompany" as A, "src_Company" as B, "src_hasStock" as C, "src_StockExchangeList" as D, "src_Stock" as E, "src_isListedIn" as F, "src_belongsToCompany" as G WHERE D."c0" = F."c1" AND A."c0" = G."c0" AND B."c0" = C."c0" AND C."c0" = F."c0" AND F."c0" = G."c1" AND C."c1" = E."c0" UNION SELECT DISTINCT E."c0", A."c0", B."c1", C."c0" FROM "src_Company" as A, "src_hasStock" as B, "src_StockExchangeList" as C, "src_Stock" as D, "src_isListedIn" as E, "src_isListedIn" as F, "src_belongsToCompany" as G WHERE C."c0" = F."c1" AND E."c0" = G."c0" AND A."c0" = B."c0" AND B."c0" = F."c0" AND F."c0" = G."c1" AND B."c1" = D."c0" UNION SELECT DISTINCT A."c0", B."c0", C."c1", D."c0" FROM "src_FinantialInstrument" as A, "src_Company" as B, "src_hasStock" as C, "src_StockExchangeList" as D, "src_Stock" as E, "src_isListedIn" as F, "src_belongsToCompany" as G WHERE D."c0" = F."c1" AND A."c0" = G."c0" AND B."c0" = C."c0" AND C."c0" = F."c0" AND F."c0" = G."c1" AND C."c1" = E."c0" UNION SELECT DISTINCT A."c0", B."c0", C."c1", D."c0" FROM "src_Stock" as A, "src_Company" as B, "src_hasStock" as C, "src_StockExchangeList" as D, "src_Stock" as E, "src_isListedIn" as F, "src_belongsToCompany" as G WHERE D."c0" = F."c1" AND A."c0" = G."c0" AND B."c0" = C."c0" AND C."c0" = F."c0" AND F."c0" = G."c1" AND C."c1" = E."c0") AS query;
