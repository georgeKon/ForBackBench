SELECT COUNT(*) FROM (SELECT DISTINCT A."c1" FROM "src_m287004" as A, "src_m231004" as B WHERE A."c1" = B."c1" UNION SELECT DISTINCT A."c1" FROM "src_m287004" as A, "src_m97004" as B WHERE A."c1" = B."c1" UNION SELECT DISTINCT A."c1" FROM "src_m175004" as A, "src_m287004" as B WHERE A."c1" = B."c1" UNION SELECT DISTINCT A."c1" FROM "src_m287004" as A, "src_m157004" as B WHERE A."c1" = B."c0" UNION SELECT DISTINCT A."c1" FROM "src_m58004" as A, "src_m287004" as B WHERE A."c1" = B."c1" UNION SELECT DISTINCT A."c2" FROM "src_m44004" as A, "src_m287004" as B WHERE A."c2" = B."c1" UNION SELECT DISTINCT A."c1" FROM "src_m287004" as A, "src_m51004" as B WHERE A."c1" = B."c0" UNION SELECT DISTINCT A."c0" FROM "src_m168004" as A, "src_m231004" as B WHERE A."c0" = B."c1" UNION SELECT DISTINCT A."c0" FROM "src_m168004" as A, "src_m97004" as B WHERE A."c0" = B."c1" UNION SELECT DISTINCT A."c1" FROM "src_m175004" as A, "src_m168004" as B WHERE A."c1" = B."c0" UNION SELECT DISTINCT A."c0" FROM "src_m168004" as A, "src_m157004" as B WHERE A."c0" = B."c0" UNION SELECT DISTINCT A."c1" FROM "src_m58004" as A, "src_m168004" as B WHERE A."c1" = B."c0" UNION SELECT DISTINCT A."c2" FROM "src_m44004" as A, "src_m168004" as B WHERE A."c2" = B."c0" UNION SELECT DISTINCT A."c0" FROM "src_m168004" as A, "src_m51004" as B WHERE A."c0" = B."c0" UNION SELECT DISTINCT A."c1" FROM "src_m61004" as A, "src_m231004" as B WHERE A."c1" = B."c1" UNION SELECT DISTINCT A."c1" FROM "src_m61004" as A, "src_m97004" as B WHERE A."c1" = B."c1" UNION SELECT DISTINCT A."c1" FROM "src_m175004" as A, "src_m61004" as B WHERE A."c1" = B."c1" UNION SELECT DISTINCT A."c1" FROM "src_m61004" as A, "src_m157004" as B WHERE A."c1" = B."c0" UNION SELECT DISTINCT A."c1" FROM "src_m58004" as A, "src_m61004" as B WHERE A."c1" = B."c1" UNION SELECT DISTINCT A."c1" FROM "src_m61004" as A, "src_m44004" as B WHERE A."c1" = B."c2" UNION SELECT DISTINCT A."c1" FROM "src_m61004" as A, "src_m51004" as B WHERE A."c1" = B."c0" UNION SELECT DISTINCT A."c0" FROM "src_m102004" as A, "src_m287004" as B WHERE A."c0" = B."c1" UNION SELECT DISTINCT A."c2" FROM "src_m37004" as A, "src_m287004" as B WHERE A."c2" = B."c1" UNION SELECT DISTINCT A."c0" FROM "src_m121004" as A, "src_m287004" as B WHERE A."c0" = B."c1" UNION SELECT DISTINCT A."c0" FROM "src_m102004" as A, "src_m168004" as B WHERE A."c0" = B."c0" UNION SELECT DISTINCT A."c2" FROM "src_m37004" as A, "src_m168004" as B WHERE A."c2" = B."c0" UNION SELECT DISTINCT A."c0" FROM "src_m121004" as A, "src_m168004" as B WHERE A."c0" = B."c0" UNION SELECT DISTINCT A."c0" FROM "src_m102004" as A, "src_m61004" as B WHERE A."c0" = B."c1" UNION SELECT DISTINCT A."c2" FROM "src_m37004" as A, "src_m61004" as B WHERE A."c2" = B."c1" UNION SELECT DISTINCT A."c0" FROM "src_m121004" as A, "src_m61004" as B WHERE A."c0" = B."c1") AS query;
