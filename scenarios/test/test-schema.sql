DROP TABLE IF EXISTS "doctor";
CREATE TABLE "doctor" (npi integer, doctor text, spec text, hospital text, conf double precision);
DROP TABLE IF EXISTS "prescription";
CREATE TABLE "prescription" (id integer, patient text, npi integer, conf double precision);
DROP TABLE IF EXISTS "targethospital";
CREATE TABLE "targethospital" (doctor text, spec text, hospital text, npi integer, conf double precision);