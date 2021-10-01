DROP TABLE IF EXISTS "src_Chair";
CREATE TABLE "src_Chair" (c0 text);
DROP TABLE IF EXISTS "src_mastersDegreeFrom";
CREATE TABLE "src_mastersDegreeFrom" (c0 text , c1 text);
DROP TABLE IF EXISTS "src_AdministrativeStaff";
CREATE TABLE "src_AdministrativeStaff" (c0 text , c1 text , c2 text);
DROP TABLE IF EXISTS "src_SystemsStaff";
CREATE TABLE "src_SystemsStaff" (c0 text , c1 text);
DROP TABLE IF EXISTS "src_Career";
CREATE TABLE "src_Career" (c0 text , c1 text , c2 text);
DROP TABLE IF EXISTS "src_AssistantProfessor";
CREATE TABLE "src_AssistantProfessor" (c0 text , c1 text , c2 text);
DROP TABLE IF EXISTS "src_doctoralDegreeFrom";
CREATE TABLE "src_doctoralDegreeFrom" (c0 text , c1 text , c2 text);
DROP TABLE IF EXISTS "src_AssociateProfessor";
CREATE TABLE "src_AssociateProfessor" (c0 text , c1 text , c2 text);
DROP TABLE IF EXISTS "src_GraduateStudent";
CREATE TABLE "src_GraduateStudent" (c0 text , c1 text , c2 text , c3 text);
DROP TABLE IF EXISTS "src_BachelorExam";
CREATE TABLE "src_BachelorExam" (c0 text , c1 text , c2 text , c3 text);
DROP TABLE IF EXISTS "src_UndergraduateStudent";
CREATE TABLE "src_UndergraduateStudent" (c0 text , c1 text , c2 text);
DROP TABLE IF EXISTS "src_headOf";
CREATE TABLE "src_headOf" (c0 text , c1 text , c2 text);
DROP TABLE IF EXISTS "src_PostDoc";
CREATE TABLE "src_PostDoc" (c0 text , c1 text , c2 text , c3 text);
DROP TABLE IF EXISTS "src_VisitingProfessor";
CREATE TABLE "src_VisitingProfessor" (c0 text , c1 text);
DROP TABLE IF EXISTS "src_teacherOf";
CREATE TABLE "src_teacherOf" (c0 text , c1 text , c2 text);
DROP TABLE IF EXISTS "src_Employee";
CREATE TABLE "src_Employee" (c0 text , c1 text , c2 text);
DROP TABLE IF EXISTS "src_GraduateCourse";
CREATE TABLE "src_GraduateCourse" (c0 text , c1 text);
DROP TABLE IF EXISTS "src_Work";
CREATE TABLE "src_Work" (c0 text , c1 text);
DROP TABLE IF EXISTS "src_hasAlumnus";
CREATE TABLE "src_hasAlumnus" (c0 text , c1 text , c2 text);
DROP TABLE IF EXISTS "src_degreeFrom";
CREATE TABLE "src_degreeFrom" (c0 text , c1 text , c2 text , c3 text);
DROP TABLE IF EXISTS "src_Program";
CREATE TABLE "src_Program" (c0 text , c1 text);
DROP TABLE IF EXISTS "src_memberOf";
CREATE TABLE "src_memberOf" (c0 text , c1 text , c2 text);
DROP TABLE IF EXISTS "src_hasFaculty";
CREATE TABLE "src_hasFaculty" (c0 text , c1 text);
DROP TABLE IF EXISTS "src_ResearchAssistant";
CREATE TABLE "src_ResearchAssistant" (c0 text , c1 text);
DROP TABLE IF EXISTS "src_Exam";
CREATE TABLE "src_Exam" (c0 text , c1 text , c2 text);
DROP TABLE IF EXISTS "src_ExamRecord";
CREATE TABLE "src_ExamRecord" (c0 text , c1 text);
DROP TABLE IF EXISTS "src_ClericalStaff";
CREATE TABLE "src_ClericalStaff" (c0 text , c1 text);
DROP TABLE IF EXISTS "src_orgPublication";
CREATE TABLE "src_orgPublication" (c0 text , c1 text , c2 text);
DROP TABLE IF EXISTS "src_takesCourse";
CREATE TABLE "src_takesCourse" (c0 text , c1 text , c2 text , c3 text);
DROP TABLE IF EXISTS "src_Professor";
CREATE TABLE "src_Professor" (c0 text , c1 text , c2 text);
DROP TABLE IF EXISTS "src_University";
CREATE TABLE "src_University" (c0 text , c1 text);
DROP TABLE IF EXISTS "src_publicationAuthor";
CREATE TABLE "src_publicationAuthor" (c0 text , c1 text , c2 text);
DROP TABLE IF EXISTS "src_isPartOfUniversity";
CREATE TABLE "src_isPartOfUniversity" (c0 text , c1 text , c2 text);
DROP TABLE IF EXISTS "src_Director";
CREATE TABLE "src_Director" (c0 text , c1 text , c2 text);
DROP TABLE IF EXISTS "src_FullProfessor";
CREATE TABLE "src_FullProfessor" (c0 text , c1 text , c2 text);
DROP TABLE IF EXISTS "src_Course";
CREATE TABLE "src_Course" (c0 text , c1 text , c2 text);
DROP TABLE IF EXISTS "src_tenured";
CREATE TABLE "src_tenured" (c0 text , c1 text);
DROP TABLE IF EXISTS "src_College";
CREATE TABLE "src_College" (c0 text , c1 text);
DROP TABLE IF EXISTS "src_Degree";
CREATE TABLE "src_Degree" (c0 text , c1 text , c2 text , c3 text);
DROP TABLE IF EXISTS "src_Lecturer";
CREATE TABLE "src_Lecturer" (c0 text , c1 text);
DROP TABLE IF EXISTS "src_teachingAssistantOf";
CREATE TABLE "src_teachingAssistantOf" (c0 text , c1 text , c2 text , c3 text);
DROP TABLE IF EXISTS "src_ExDean";
CREATE TABLE "src_ExDean" (c0 text , c1 text , c2 text , c3 text);
DROP TABLE IF EXISTS "src_FacultyStaff";
CREATE TABLE "src_FacultyStaff" (c0 text , c1 text);
DROP TABLE IF EXISTS "src_member";
CREATE TABLE "src_member" (c0 text , c1 text , c2 text , c3 text);
DROP TABLE IF EXISTS "src_advisor";
CREATE TABLE "src_advisor" (c0 text , c1 text , c2 text , c3 text);
DROP TABLE IF EXISTS "src_Student";
CREATE TABLE "src_Student" (c0 text , c1 text , c2 text);
DROP TABLE IF EXISTS "src_worksFor";
CREATE TABLE "src_worksFor" (c0 text , c1 text , c2 text);
DROP TABLE IF EXISTS "src_Dean";
CREATE TABLE "src_Dean" (c0 text , c1 text);
DROP TABLE IF EXISTS "src_Faculty";
CREATE TABLE "src_Faculty" (c0 text , c1 text , c2 text);
DROP TABLE IF EXISTS "src_Person";
CREATE TABLE "src_Person" (c0 text , c1 text);
DROP TABLE IF EXISTS "src_affiliateOf";
CREATE TABLE "src_affiliateOf" (c0 text , c1 text);
DROP TABLE IF EXISTS "src_undergraduateDegreeFrom";
CREATE TABLE "src_undergraduateDegreeFrom" (c0 text , c1 text , c2 text);
DROP TABLE IF EXISTS "src_affiliatedOrganizationOf";
CREATE TABLE "src_affiliatedOrganizationOf" (c0 text , c1 text , c2 text , c3 text);
DROP TABLE IF EXISTS "src_hasExamRecord";
CREATE TABLE "src_hasExamRecord" (c0 text , c1 text , c2 text);
DROP TABLE IF EXISTS "src_Organization";
CREATE TABLE "src_Organization" (c0 text , c1 text);
