DROP TABLE IF EXISTS "AdministrativeStaff";
CREATE TABLE "AdministrativeStaff" (c0 text);
DROP TABLE IF EXISTS "Article";
CREATE TABLE "Article" (c0 text);
DROP TABLE IF EXISTS "AssistantProfessor";
CREATE TABLE "AssistantProfessor" (c0 text);
DROP TABLE IF EXISTS "AssociateProfessor";
CREATE TABLE "AssociateProfessor" (c0 text);
DROP TABLE IF EXISTS "Book";
CREATE TABLE "Book" (c0 text);
DROP TABLE IF EXISTS "Chair";
CREATE TABLE "Chair" (c0 text);
DROP TABLE IF EXISTS "ClericalStaff";
CREATE TABLE "ClericalStaff" (c0 text);
DROP TABLE IF EXISTS "College";
CREATE TABLE "College" (c0 text);
DROP TABLE IF EXISTS "ConferencePaper";
CREATE TABLE "ConferencePaper" (c0 text);
DROP TABLE IF EXISTS "Course";
CREATE TABLE "Course" (c0 text);
DROP TABLE IF EXISTS "Dean";
CREATE TABLE "Dean" (c0 text);
DROP TABLE IF EXISTS "Department";
CREATE TABLE "Department" (c0 text);
DROP TABLE IF EXISTS "Director";
CREATE TABLE "Director" (c0 text);
DROP TABLE IF EXISTS "Employee";
CREATE TABLE "Employee" (c0 text);
DROP TABLE IF EXISTS "Faculty";
CREATE TABLE "Faculty" (c0 text);
DROP TABLE IF EXISTS "FullProfessor";
CREATE TABLE "FullProfessor" (c0 text);
DROP TABLE IF EXISTS "GraduateCourse";
CREATE TABLE "GraduateCourse" (c0 text);
DROP TABLE IF EXISTS "GraduateStudent";
CREATE TABLE "GraduateStudent" (c0 text);
DROP TABLE IF EXISTS "Institute";
CREATE TABLE "Institute" (c0 text);
DROP TABLE IF EXISTS "JournalArticle";
CREATE TABLE "JournalArticle" (c0 text);
DROP TABLE IF EXISTS "Lecturer";
CREATE TABLE "Lecturer" (c0 text);
DROP TABLE IF EXISTS "Manual";
CREATE TABLE "Manual" (c0 text);
DROP TABLE IF EXISTS "Organization";
CREATE TABLE "Organization" (c0 text);
DROP TABLE IF EXISTS "Person";
CREATE TABLE "Person" (c0 text);
DROP TABLE IF EXISTS "PostDoc";
CREATE TABLE "PostDoc" (c0 text);
DROP TABLE IF EXISTS "Professor";
CREATE TABLE "Professor" (c0 text);
DROP TABLE IF EXISTS "Program";
CREATE TABLE "Program" (c0 text);
DROP TABLE IF EXISTS "Publication";
CREATE TABLE "Publication" (c0 text);
DROP TABLE IF EXISTS "Research";
CREATE TABLE "Research" (c0 text);
DROP TABLE IF EXISTS "ResearchAssistant";
CREATE TABLE "ResearchAssistant" (c0 text);
DROP TABLE IF EXISTS "ResearchGroup";
CREATE TABLE "ResearchGroup" (c0 text);
DROP TABLE IF EXISTS "Schedule";
CREATE TABLE "Schedule" (c0 text);
DROP TABLE IF EXISTS "Software";
CREATE TABLE "Software" (c0 text);
DROP TABLE IF EXISTS "Specification";
CREATE TABLE "Specification" (c0 text);
DROP TABLE IF EXISTS "Student";
CREATE TABLE "Student" (c0 text);
DROP TABLE IF EXISTS "SystemsStaff";
CREATE TABLE "SystemsStaff" (c0 text);
DROP TABLE IF EXISTS "TeachingAssistant";
CREATE TABLE "TeachingAssistant" (c0 text);
DROP TABLE IF EXISTS "TechnicalReport";
CREATE TABLE "TechnicalReport" (c0 text);
DROP TABLE IF EXISTS "UndergraduateStudent";
CREATE TABLE "UndergraduateStudent" (c0 text);
DROP TABLE IF EXISTS "University";
CREATE TABLE "University" (c0 text);
DROP TABLE IF EXISTS "UnofficialPublication";
CREATE TABLE "UnofficialPublication" (c0 text);
DROP TABLE IF EXISTS "VisitingProfessor";
CREATE TABLE "VisitingProfessor" (c0 text);
DROP TABLE IF EXISTS "Work";
CREATE TABLE "Work" (c0 text);
DROP TABLE IF EXISTS "advisor";
CREATE TABLE "advisor" (c0 text, c1 text);
DROP TABLE IF EXISTS "affiliateOf";
CREATE TABLE "affiliateOf" (c0 text, c1 text);
DROP TABLE IF EXISTS "affiliatedOrganizationOf";
CREATE TABLE "affiliatedOrganizationOf" (c0 text, c1 text);
DROP TABLE IF EXISTS "age";
CREATE TABLE "age" (c0 text, c1 text);
DROP TABLE IF EXISTS "degreeFrom";
CREATE TABLE "degreeFrom" (c0 text, c1 text);
DROP TABLE IF EXISTS "doctoralDegreeFrom";
CREATE TABLE "doctoralDegreeFrom" (c0 text, c1 text);
DROP TABLE IF EXISTS "emailAddress";
CREATE TABLE "emailAddress" (c0 text, c1 text);
DROP TABLE IF EXISTS "hasAlumnus";
CREATE TABLE "hasAlumnus" (c0 text, c1 text);
DROP TABLE IF EXISTS "headOf";
CREATE TABLE "headOf" (c0 text, c1 text);
DROP TABLE IF EXISTS "listedCourse";
CREATE TABLE "listedCourse" (c0 text, c1 text);
DROP TABLE IF EXISTS "mastersDegreeFrom";
CREATE TABLE "mastersDegreeFrom" (c0 text, c1 text);
DROP TABLE IF EXISTS "member";
CREATE TABLE "member" (c0 text, c1 text);
DROP TABLE IF EXISTS "memberOf";
CREATE TABLE "memberOf" (c0 text, c1 text);
DROP TABLE IF EXISTS "orgPublication";
CREATE TABLE "orgPublication" (c0 text, c1 text);
DROP TABLE IF EXISTS "publicationAuthor";
CREATE TABLE "publicationAuthor" (c0 text, c1 text);
DROP TABLE IF EXISTS "publicationDate";
CREATE TABLE "publicationDate" (c0 text, c1 text);
DROP TABLE IF EXISTS "publicationResearch";
CREATE TABLE "publicationResearch" (c0 text, c1 text);
DROP TABLE IF EXISTS "researchProject";
CREATE TABLE "researchProject" (c0 text, c1 text);
DROP TABLE IF EXISTS "softwareDocumentation";
CREATE TABLE "softwareDocumentation" (c0 text, c1 text);
DROP TABLE IF EXISTS "softwareVersion";
CREATE TABLE "softwareVersion" (c0 text, c1 text);
DROP TABLE IF EXISTS "subOrganizationOf";
CREATE TABLE "subOrganizationOf" (c0 text, c1 text);
DROP TABLE IF EXISTS "takesCourse";
CREATE TABLE "takesCourse" (c0 text, c1 text);
DROP TABLE IF EXISTS "teacherOf";
CREATE TABLE "teacherOf" (c0 text, c1 text);
DROP TABLE IF EXISTS "teachingAssistantOf";
CREATE TABLE "teachingAssistantOf" (c0 text, c1 text);
DROP TABLE IF EXISTS "telephone";
CREATE TABLE "telephone" (c0 text, c1 text);
DROP TABLE IF EXISTS "tenured";
CREATE TABLE "tenured" (c0 text, c1 text);
DROP TABLE IF EXISTS "title";
CREATE TABLE "title" (c0 text, c1 text);
DROP TABLE IF EXISTS "undergraduateDegreeFrom";
CREATE TABLE "undergraduateDegreeFrom" (c0 text, c1 text);
DROP TABLE IF EXISTS "worksFor";
CREATE TABLE "worksFor" (c0 text, c1 text);