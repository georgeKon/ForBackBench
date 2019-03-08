DROP TABLE IF EXISTS "Abbey";
CREATE TABLE "Abbey" (c0 text);
INSERT INTO "Abbey" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Building";
CREATE TABLE "Building" (c0 text);
INSERT INTO "Building" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Abstract-Notion";
CREATE TABLE "Abstract-Notion" (c0 text);
INSERT INTO "Abstract-Notion" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Flavour";
CREATE TABLE "Flavour" (c0 text);
INSERT INTO "Flavour" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Actor";
CREATE TABLE "Actor" (c0 text);
INSERT INTO "Actor" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Entertainer";
CREATE TABLE "Entertainer" (c0 text);
INSERT INTO "Entertainer" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Animal";
CREATE TABLE "Animal" (c0 text);
INSERT INTO "Animal" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Natural-Object";
CREATE TABLE "Natural-Object" (c0 text);
INSERT INTO "Natural-Object" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Architect";
CREATE TABLE "Architect" (c0 text);
INSERT INTO "Architect" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Creator";
CREATE TABLE "Creator" (c0 text);
INSERT INTO "Creator" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Armament";
CREATE TABLE "Armament" (c0 text);
INSERT INTO "Armament" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Artefact";
CREATE TABLE "Artefact" (c0 text);
INSERT INTO "Artefact" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Art-Form";
CREATE TABLE "Art-Form" (c0 text);
INSERT INTO "Art-Form" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Object";
CREATE TABLE "Object" (c0 text);
INSERT INTO "Object" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Artist";
CREATE TABLE "Artist" (c0 text);
INSERT INTO "Artist" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Artistic-Movement";
CREATE TABLE "Artistic-Movement" (c0 text);
INSERT INTO "Artistic-Movement" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Movement";
CREATE TABLE "Movement" (c0 text);
INSERT INTO "Movement" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Artistic-Style";
CREATE TABLE "Artistic-Style" (c0 text);
INSERT INTO "Artistic-Style" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Astronaut";
CREATE TABLE "Astronaut" (c0 text);
INSERT INTO "Astronaut" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Discoverer";
CREATE TABLE "Discoverer" (c0 text);
INSERT INTO "Discoverer" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Author";
CREATE TABLE "Author" (c0 text);
INSERT INTO "Author" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Badge";
CREATE TABLE "Badge" (c0 text);
INSERT INTO "Badge" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Conceptual-Object";
CREATE TABLE "Conceptual-Object" (c0 text);
INSERT INTO "Conceptual-Object" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Battle";
CREATE TABLE "Battle" (c0 text);
INSERT INTO "Battle" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Event";
CREATE TABLE "Event" (c0 text);
INSERT INTO "Event" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Board";
CREATE TABLE "Board" (c0 text);
INSERT INTO "Board" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Management-Organisation";
CREATE TABLE "Management-Organisation" (c0 text);
INSERT INTO "Management-Organisation" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Book";
CREATE TABLE "Book" (c0 text);
INSERT INTO "Book" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Writing";
CREATE TABLE "Writing" (c0 text);
INSERT INTO "Writing" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Business-Leader";
CREATE TABLE "Business-Leader" (c0 text);
INSERT INTO "Business-Leader" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Magnate";
CREATE TABLE "Magnate" (c0 text);
INSERT INTO "Magnate" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Category";
CREATE TABLE "Category" (c0 text);
INSERT INTO "Category" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "VicodiOI";
CREATE TABLE "VicodiOI" (c0 text);
INSERT INTO "VicodiOI" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Cathedral";
CREATE TABLE "Cathedral" (c0 text);
INSERT INTO "Cathedral" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Church";
CREATE TABLE "Church" (c0 text);
INSERT INTO "Church" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Church-Reformer";
CREATE TABLE "Church-Reformer" (c0 text);
INSERT INTO "Church-Reformer" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Religious-Leader";
CREATE TABLE "Religious-Leader" (c0 text);
INSERT INTO "Religious-Leader" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "City";
CREATE TABLE "City" (c0 text);
INSERT INTO "City" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Settlement";
CREATE TABLE "Settlement" (c0 text);
INSERT INTO "Settlement" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Cleric";
CREATE TABLE "Cleric" (c0 text);
INSERT INTO "Cleric" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Person-Role";
CREATE TABLE "Person-Role" (c0 text);
INSERT INTO "Person-Role" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Clerical-Leader";
CREATE TABLE "Clerical-Leader" (c0 text);
INSERT INTO "Clerical-Leader" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Leader";
CREATE TABLE "Leader" (c0 text);
INSERT INTO "Leader" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Clothing";
CREATE TABLE "Clothing" (c0 text);
INSERT INTO "Clothing" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Commodity";
CREATE TABLE "Commodity" (c0 text);
INSERT INTO "Commodity" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Composer";
CREATE TABLE "Composer" (c0 text);
INSERT INTO "Composer" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Conductor";
CREATE TABLE "Conductor" (c0 text);
INSERT INTO "Conductor" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Country";
CREATE TABLE "Country" (c0 text);
INSERT INTO "Country" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Location";
CREATE TABLE "Location" (c0 text);
INSERT INTO "Location" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Crime";
CREATE TABLE "Crime" (c0 text);
INSERT INTO "Crime" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Criminal";
CREATE TABLE "Criminal" (c0 text);
INSERT INTO "Criminal" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Cultural-Agreement";
CREATE TABLE "Cultural-Agreement" (c0 text);
INSERT INTO "Cultural-Agreement" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Cultural-Organisation";
CREATE TABLE "Cultural-Organisation" (c0 text);
INSERT INTO "Cultural-Organisation" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Organisation";
CREATE TABLE "Organisation" (c0 text);
INSERT INTO "Organisation" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Dancer";
CREATE TABLE "Dancer" (c0 text);
INSERT INTO "Dancer" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Diplomat";
CREATE TABLE "Diplomat" (c0 text);
INSERT INTO "Diplomat" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Functionary";
CREATE TABLE "Functionary" (c0 text);
INSERT INTO "Functionary" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Disaster";
CREATE TABLE "Disaster" (c0 text);
INSERT INTO "Disaster" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Disease";
CREATE TABLE "Disease" (c0 text);
INSERT INTO "Disease" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Dramaturge";
CREATE TABLE "Dramaturge" (c0 text);
INSERT INTO "Dramaturge" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Dynasty";
CREATE TABLE "Dynasty" (c0 text);
INSERT INTO "Dynasty" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Social-Group";
CREATE TABLE "Social-Group" (c0 text);
INSERT INTO "Social-Group" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Ecclesiarch";
CREATE TABLE "Ecclesiarch" (c0 text);
INSERT INTO "Ecclesiarch" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Economic-Enterprise";
CREATE TABLE "Economic-Enterprise" (c0 text);
INSERT INTO "Economic-Enterprise" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Economic-Organisation";
CREATE TABLE "Economic-Organisation" (c0 text);
INSERT INTO "Economic-Organisation" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Economic-Process";
CREATE TABLE "Economic-Process" (c0 text);
INSERT INTO "Economic-Process" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Economic-Symbol";
CREATE TABLE "Economic-Symbol" (c0 text);
INSERT INTO "Economic-Symbol" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Symbol";
CREATE TABLE "Symbol" (c0 text);
INSERT INTO "Symbol" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Economist";
CREATE TABLE "Economist" (c0 text);
INSERT INTO "Economist" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Scientist";
CREATE TABLE "Scientist" (c0 text);
INSERT INTO "Scientist" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Educational-Organisation";
CREATE TABLE "Educational-Organisation" (c0 text);
INSERT INTO "Educational-Organisation" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Election";
CREATE TABLE "Election" (c0 text);
INSERT INTO "Election" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Emperor";
CREATE TABLE "Emperor" (c0 text);
INSERT INTO "Emperor" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Head-of-State";
CREATE TABLE "Head-of-State" (c0 text);
INSERT INTO "Head-of-State" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Engineer";
CREATE TABLE "Engineer" (c0 text);
INSERT INTO "Engineer" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Environment";
CREATE TABLE "Environment" (c0 text);
INSERT INTO "Environment" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Ethnic-Group";
CREATE TABLE "Ethnic-Group" (c0 text);
INSERT INTO "Ethnic-Group" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Fictional-Event";
CREATE TABLE "Fictional-Event" (c0 text);
INSERT INTO "Fictional-Event" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Fictional-Person";
CREATE TABLE "Fictional-Person" (c0 text);
INSERT INTO "Fictional-Person" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Individual";
CREATE TABLE "Individual" (c0 text);
INSERT INTO "Individual" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Field-of-Knowledge";
CREATE TABLE "Field-of-Knowledge" (c0 text);
INSERT INTO "Field-of-Knowledge" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Intellectual-Construct";
CREATE TABLE "Intellectual-Construct" (c0 text);
INSERT INTO "Intellectual-Construct" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Film-Maker";
CREATE TABLE "Film-Maker" (c0 text);
INSERT INTO "Film-Maker" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Time-Dependent";
CREATE TABLE "Time-Dependent" (c0 text);
INSERT INTO "Time-Dependent" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Food";
CREATE TABLE "Food" (c0 text);
INSERT INTO "Food" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Foreign-Minister";
CREATE TABLE "Foreign-Minister" (c0 text);
INSERT INTO "Foreign-Minister" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Minister";
CREATE TABLE "Minister" (c0 text);
INSERT INTO "Minister" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "FuzzyTemporalInterval";
CREATE TABLE "FuzzyTemporalInterval" (c0 text);
INSERT INTO "FuzzyTemporalInterval" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Time";
CREATE TABLE "Time" (c0 text);
INSERT INTO "Time" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Geographer";
CREATE TABLE "Geographer" (c0 text);
INSERT INTO "Geographer" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Geographical-Discovery";
CREATE TABLE "Geographical-Discovery" (c0 text);
INSERT INTO "Geographical-Discovery" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Geographical-Feature";
CREATE TABLE "Geographical-Feature" (c0 text);
INSERT INTO "Geographical-Feature" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Geographical-Region";
CREATE TABLE "Geographical-Region" (c0 text);
INSERT INTO "Geographical-Region" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Governmental-Organisation";
CREATE TABLE "Governmental-Organisation" (c0 text);
INSERT INTO "Governmental-Organisation" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Political-Organisation";
CREATE TABLE "Political-Organisation" (c0 text);
INSERT INTO "Political-Organisation" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Head-of-Government";
CREATE TABLE "Head-of-Government" (c0 text);
INSERT INTO "Head-of-Government" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Secular-Leader";
CREATE TABLE "Secular-Leader" (c0 text);
INSERT INTO "Secular-Leader" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Idea";
CREATE TABLE "Idea" (c0 text);
INSERT INTO "Idea" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Ideology";
CREATE TABLE "Ideology" (c0 text);
INSERT INTO "Ideology" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Illness";
CREATE TABLE "Illness" (c0 text);
INSERT INTO "Illness" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Life-Event";
CREATE TABLE "Life-Event" (c0 text);
INSERT INTO "Life-Event" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Intellectual-Movement";
CREATE TABLE "Intellectual-Movement" (c0 text);
INSERT INTO "Intellectual-Movement" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "International-Alliance";
CREATE TABLE "International-Alliance" (c0 text);
INSERT INTO "International-Alliance" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "International-Organisation";
CREATE TABLE "International-Organisation" (c0 text);
INSERT INTO "International-Organisation" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Intra-State-Group";
CREATE TABLE "Intra-State-Group" (c0 text);
INSERT INTO "Intra-State-Group" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Inventor";
CREATE TABLE "Inventor" (c0 text);
INSERT INTO "Inventor" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Journal";
CREATE TABLE "Journal" (c0 text);
INSERT INTO "Journal" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Journalist";
CREATE TABLE "Journalist" (c0 text);
INSERT INTO "Journalist" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Jurist";
CREATE TABLE "Jurist" (c0 text);
INSERT INTO "Jurist" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "King";
CREATE TABLE "King" (c0 text);
INSERT INTO "King" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Landmark";
CREATE TABLE "Landmark" (c0 text);
INSERT INTO "Landmark" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Language";
CREATE TABLE "Language" (c0 text);
INSERT INTO "Language" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "League";
CREATE TABLE "League" (c0 text);
INSERT INTO "League" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Legislation";
CREATE TABLE "Legislation" (c0 text);
INSERT INTO "Legislation" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Liturgical-Object";
CREATE TABLE "Liturgical-Object" (c0 text);
INSERT INTO "Liturgical-Object" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Location-Part-Relation";
CREATE TABLE "Location-Part-Relation" (c0 text);
INSERT INTO "Location-Part-Relation" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Time-Dependent-Relation";
CREATE TABLE "Time-Dependent-Relation" (c0 text);
INSERT INTO "Time-Dependent-Relation" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Masonic-Lodge";
CREATE TABLE "Masonic-Lodge" (c0 text);
INSERT INTO "Masonic-Lodge" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Measurable-Trend";
CREATE TABLE "Measurable-Trend" (c0 text);
INSERT INTO "Measurable-Trend" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Meeting";
CREATE TABLE "Meeting" (c0 text);
INSERT INTO "Meeting" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Military-Organisation";
CREATE TABLE "Military-Organisation" (c0 text);
INSERT INTO "Military-Organisation" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Military-Person";
CREATE TABLE "Military-Person" (c0 text);
INSERT INTO "Military-Person" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Military-Unit";
CREATE TABLE "Military-Unit" (c0 text);
INSERT INTO "Military-Unit" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Monastery";
CREATE TABLE "Monastery" (c0 text);
INSERT INTO "Monastery" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Musician";
CREATE TABLE "Musician" (c0 text);
INSERT INTO "Musician" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "National-Symbol";
CREATE TABLE "National-Symbol" (c0 text);
INSERT INTO "National-Symbol" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Newspaper";
CREATE TABLE "Newspaper" (c0 text);
INSERT INTO "Newspaper" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Non-Military-Conflict";
CREATE TABLE "Non-Military-Conflict" (c0 text);
INSERT INTO "Non-Military-Conflict" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Other-Religious-Leader";
CREATE TABLE "Other-Religious-Leader" (c0 text);
INSERT INTO "Other-Religious-Leader" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Other-Religious-Person";
CREATE TABLE "Other-Religious-Person" (c0 text);
INSERT INTO "Other-Religious-Person" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Painter";
CREATE TABLE "Painter" (c0 text);
INSERT INTO "Painter" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Painting";
CREATE TABLE "Painting" (c0 text);
INSERT INTO "Painting" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Work-of-Art";
CREATE TABLE "Work-of-Art" (c0 text);
INSERT INTO "Work-of-Art" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Pamphlet";
CREATE TABLE "Pamphlet" (c0 text);
INSERT INTO "Pamphlet" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Party";
CREATE TABLE "Party" (c0 text);
INSERT INTO "Party" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Pastime";
CREATE TABLE "Pastime" (c0 text);
INSERT INTO "Pastime" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Period";
CREATE TABLE "Period" (c0 text);
INSERT INTO "Period" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Period-in-Office";
CREATE TABLE "Period-in-Office" (c0 text);
INSERT INTO "Period-in-Office" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Person";
CREATE TABLE "Person" (c0 text);
INSERT INTO "Person" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Role";
CREATE TABLE "Role" (c0 text);
INSERT INTO "Role" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Philanthropist";
CREATE TABLE "Philanthropist" (c0 text);
INSERT INTO "Philanthropist" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Philosopher";
CREATE TABLE "Philosopher" (c0 text);
INSERT INTO "Philosopher" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Physician";
CREATE TABLE "Physician" (c0 text);
INSERT INTO "Physician" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Piece-of-Music";
CREATE TABLE "Piece-of-Music" (c0 text);
INSERT INTO "Piece-of-Music" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Political-Region";
CREATE TABLE "Political-Region" (c0 text);
INSERT INTO "Political-Region" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Political-Symbol";
CREATE TABLE "Political-Symbol" (c0 text);
INSERT INTO "Political-Symbol" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Politician";
CREATE TABLE "Politician" (c0 text);
INSERT INTO "Politician" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Pollution";
CREATE TABLE "Pollution" (c0 text);
INSERT INTO "Pollution" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Pope";
CREATE TABLE "Pope" (c0 text);
INSERT INTO "Pope" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Population-Movement";
CREATE TABLE "Population-Movement" (c0 text);
INSERT INTO "Population-Movement" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Prince";
CREATE TABLE "Prince" (c0 text);
INSERT INTO "Prince" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Professor";
CREATE TABLE "Professor" (c0 text);
INSERT INTO "Professor" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Psychologist";
CREATE TABLE "Psychologist" (c0 text);
INSERT INTO "Psychologist" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Public-Oration";
CREATE TABLE "Public-Oration" (c0 text);
INSERT INTO "Public-Oration" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Publisher";
CREATE TABLE "Publisher" (c0 text);
INSERT INTO "Publisher" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Queen";
CREATE TABLE "Queen" (c0 text);
INSERT INTO "Queen" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Relic";
CREATE TABLE "Relic" (c0 text);
INSERT INTO "Relic" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Religious-Community";
CREATE TABLE "Religious-Community" (c0 text);
INSERT INTO "Religious-Community" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Religious-Organisation";
CREATE TABLE "Religious-Organisation" (c0 text);
INSERT INTO "Religious-Organisation" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Religious-Ideology";
CREATE TABLE "Religious-Ideology" (c0 text);
INSERT INTO "Religious-Ideology" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Religious-Movement";
CREATE TABLE "Religious-Movement" (c0 text);
INSERT INTO "Religious-Movement" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Religious-Order";
CREATE TABLE "Religious-Order" (c0 text);
INSERT INTO "Religious-Order" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Religious-Practice";
CREATE TABLE "Religious-Practice" (c0 text);
INSERT INTO "Religious-Practice" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Religious-Symbol";
CREATE TABLE "Religious-Symbol" (c0 text);
INSERT INTO "Religious-Symbol" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Representative-Institution";
CREATE TABLE "Representative-Institution" (c0 text);
INSERT INTO "Representative-Institution" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Ritual";
CREATE TABLE "Ritual" (c0 text);
INSERT INTO "Ritual" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Saint";
CREATE TABLE "Saint" (c0 text);
INSERT INTO "Saint" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Scandal";
CREATE TABLE "Scandal" (c0 text);
INSERT INTO "Scandal" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Scientific-Instrument";
CREATE TABLE "Scientific-Instrument" (c0 text);
INSERT INTO "Scientific-Instrument" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Sculptor";
CREATE TABLE "Sculptor" (c0 text);
INSERT INTO "Sculptor" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Sculpture";
CREATE TABLE "Sculpture" (c0 text);
INSERT INTO "Sculpture" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Secular-Ideology";
CREATE TABLE "Secular-Ideology" (c0 text);
INSERT INTO "Secular-Ideology" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Secular-Movement";
CREATE TABLE "Secular-Movement" (c0 text);
INSERT INTO "Secular-Movement" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Ship";
CREATE TABLE "Ship" (c0 text);
INSERT INTO "Ship" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Vehicle";
CREATE TABLE "Vehicle" (c0 text);
INSERT INTO "Vehicle" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Social-Stratum";
CREATE TABLE "Social-Stratum" (c0 text);
INSERT INTO "Social-Stratum" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Sportsman";
CREATE TABLE "Sportsman" (c0 text);
INSERT INTO "Sportsman" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Stereotype-Group";
CREATE TABLE "Stereotype-Group" (c0 text);
INSERT INTO "Stereotype-Group" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Structure";
CREATE TABLE "Structure" (c0 text);
INSERT INTO "Structure" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Sultan";
CREATE TABLE "Sultan" (c0 text);
INSERT INTO "Sultan" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Technical-Scientific-Advance";
CREATE TABLE "Technical-Scientific-Advance" (c0 text);
INSERT INTO "Technical-Scientific-Advance" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "TemporalInterval";
CREATE TABLE "TemporalInterval" (c0 text);
INSERT INTO "TemporalInterval" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Theologian";
CREATE TABLE "Theologian" (c0 text);
INSERT INTO "Theologian" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Trade-Association";
CREATE TABLE "Trade-Association" (c0 text);
INSERT INTO "Trade-Association" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Trades-Union";
CREATE TABLE "Trades-Union" (c0 text);
INSERT INTO "Trades-Union" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Trades-Unionist";
CREATE TABLE "Trades-Unionist" (c0 text);
INSERT INTO "Trades-Unionist" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Train";
CREATE TABLE "Train" (c0 text);
INSERT INTO "Train" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Treaty";
CREATE TABLE "Treaty" (c0 text);
INSERT INTO "Treaty" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Trial";
CREATE TABLE "Trial" (c0 text);
INSERT INTO "Trial" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "University";
CREATE TABLE "University" (c0 text);
INSERT INTO "University" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Uprising";
CREATE TABLE "Uprising" (c0 text);
INSERT INTO "Uprising" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Village";
CREATE TABLE "Village" (c0 text);
INSERT INTO "Village" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "War";
CREATE TABLE "War" (c0 text);
INSERT INTO "War" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "Water";
CREATE TABLE "Water" (c0 text);
INSERT INTO "Water" SELECT MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "exists";
CREATE TABLE "exists" (c0 text, c1 text);
INSERT INTO "exists" SELECT MD5(random()::text), MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "related";
CREATE TABLE "related" (c0 text, c1 text);
INSERT INTO "related" SELECT MD5(random()::text), MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "hasCategory";
CREATE TABLE "hasCategory" (c0 text, c1 text);
INSERT INTO "hasCategory" SELECT MD5(random()::text), MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "hasLocationContainerMember";
CREATE TABLE "hasLocationContainerMember" (c0 text, c1 text);
INSERT INTO "hasLocationContainerMember" SELECT MD5(random()::text), MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "hasRelationMember";
CREATE TABLE "hasRelationMember" (c0 text, c1 text);
INSERT INTO "hasRelationMember" SELECT MD5(random()::text), MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "hasLocationPartMember";
CREATE TABLE "hasLocationPartMember" (c0 text, c1 text);
INSERT INTO "hasLocationPartMember" SELECT MD5(random()::text), MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "hasRole";
CREATE TABLE "hasRole" (c0 text, c1 text);
INSERT INTO "hasRole" SELECT MD5(random()::text), MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "isLocationContainerMemberOf";
CREATE TABLE "isLocationContainerMemberOf" (c0 text, c1 text);
INSERT INTO "isLocationContainerMemberOf" SELECT MD5(random()::text), MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "isRelationMemberOf";
CREATE TABLE "isRelationMemberOf" (c0 text, c1 text);
INSERT INTO "isRelationMemberOf" SELECT MD5(random()::text), MD5(random()::text) FROM generate_series(1, 10);
DROP TABLE IF EXISTS "isLocationPartMemberOf";
CREATE TABLE "isLocationPartMemberOf" (c0 text, c1 text);
INSERT INTO "isLocationPartMemberOf" SELECT MD5(random()::text), MD5(random()::text) FROM generate_series(1, 10);