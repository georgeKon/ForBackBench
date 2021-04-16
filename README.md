# Overview

The project is split across 4 repositories

- obdabenchmark <https://git.soton.ac.uk/gk1e17/obdabenchmark> (Written by JE)
- chasestepper <https://git.soton.ac.uk/jde1g16/chasestepper> (Written by JE, modified by NB)
- obda-converter <https://github.com/JamesErrington/obda-converter> (Written by JE)
- obdabenchmarkingtools <https://git.soton.ac.uk/gk1e17/obda-chase-bench> (Written by NB)

This structure is very fluid and can be easily changed if needed - probably will need to be as the 'chasestepper' name was only meant to be a placeholder, and having stuff across 2 different git systems on 3 accounts probably isn't the best

obda-converter is a JavaScript project, written using TypeScript and bundled with NPM. obdabenchmark also contains a TypeScript segment, but is mostly bash scripts, data integration tools and scenario data. chasestepper is a Java project, bundled with Gradle - this could be altered to use maven or some other system if needed but is probably not recommended? It also contains the data generator files. Obdabenchmarkingtools is the recent addition to the previous 3 tools. Originally this was just a tool to generate mappings for Ontop but has significantly more tools bundled with it. Recommend looking at <https://git.soton.ac.uk/gk1e17/obda-chase-bench/blob/master/README.md> for more information on that.

### ChaseStepper

To build

- `gradle chasestepperJar`
- `gradle dataJar`
- Can also use `gradle clean` to clear previous builds

### Obdabenchmark

To download dependencies - `yarn` - this must be done on first downloading the code, or any time the 'node_modules' folder is deleted

To build

- `yarn build`
- Use `sudo npm link` to update the local binary command

### Obda-converter

To download dependencies

- `yarn`

this must be done on first downloading the code, or any time the 'node_modules' folder is deleted

To build

- `yarn build`
- Use `sudo npm link` to update the local binary command

The `obdabenchmark llunatic <folder>` command is used to generate the llunatic xml files for a scenario

### Obdabenchmarkingtools

This project has many tools tools and also uses the gradle build system

- `gradle schemaGenerator`
- `gradle ontopMappingGenerator`
- `gradle owlGenerator`
- `gradle modifyChaseBench`
- `gradle datalogToUCQ`
- `gradle sqlConv`
- `gradle stChase`
- `gradle deepData`

## Output Folder Structure

This is where the experiment results go

```
outputs/

|-- rewriting-tool/ := Rewriting tools output (Iqaros, Rapid, Graal, OntopRW)
| |-- scenario/ := For each scenario
| | |-- rewriting/ := Q1-5
| | | |-- QX-rewritings.txt := Rewriting
| | |-- answers/ := Tuples Returned
| | | |-- size/
| | | | |-- QX.txt := Result for each query

|-- ontop/ := Ontop outputs
| |-- scenarios
| | |-- log/ := Ontop Output Log files
| | | |-- size/
| | | | |-- QX.txt := Log file for each query

|-- bcagqr/ := BCA and GQR
| |-- scenario/ := For each scenario
| | |-- chased-mappings/ := Q1-5
| | | |-- QX-tgds.rule := BCA chased mappings
| | |-- rewriting/ := Q1-5
| | | |-- QX-rewritings.txt := Rewriting
| | |-- answers/ := Tuples Returned
| | | |-- size/
| | | | |-- QX.txt := Result for each query

|-- bcastc/ := BCA and ST Chase
| |-- scenario/ := For each scenario
| | |-- chased-mappings/ := Q1-5
| | | |-- QX-tgds.rule := BCA chased mappings
| | |-- answers/ := Tuples Returned
| | | |-- size/
| | | | |-- QX.txt := Result for each query

```

## Experiments Folder Structure

This is where the experiment results go

```
experiments/
|-- scenario/ := Scenario Name
| |-- size/ := small/medium/large dataset
| | |-- query/ := Q1-5
| | | |-- tool.csv := result of that query with each tool in the scenario
```

## Scenario folder structure

```
name/
|-- data/               := CSV data files
| |-- a.csv
|-- dependencies/
| |-- st-tgds.txt       := ChaseBench rules
| |-- t-tgds.txt        := ChaseBench rules
|-- owl/
| |-- ontology.owl      := OWL ontology file
|-- queries
| |-- SPARQL             := SPARQL queries
|   |-- Qx.rq
| |-- iqaros            := IQAROS queries
|   |-- Qx.txt
| |-- Chasebench            := ChaseBench queries
|   |-- Qx/
|     |-- Qx.txt
|-- schema/
| |-- s-schema.sql      := PostgreSQL sql
| |-- s-schema.txt      := ChaseBench schema
| |-- t-schema.sql      := PostgreSQL sql
| |-- t-schema.txt      := ChaseBench schema
|-- ontop-files
| |-- mapping.obda      := Ontop Mapping file (Similar to st-tgds)
| |-- properties.txt    := Ontop specific DB config file. (Similar to config.ini)
|--postgres-config.ini          := INI database config
```

The majority of this structure can be bootstrapped using the provided scripts. For a DL-Lite scenario, the minimum set up to be bootstrapped is the following:

```
name/
|-- data/
| |-- a.csv
|-- dependencies/
| |-- ontology.owl
|-- queries
| |-- Qx.rq
|-- config.ini
```

For a ChaseBench scenario:

```
name/
|-- data/
| |-- a.csv
|-- dependencies/
| |-- st-tgds.txt
| |-- t-tgds.txt
|-- queries
| |-- Qx.txt
|-- schema/
| |-- s-schema.txt
| |-- t-schema.txt
|-- config.ini
```

There hasn't been an automated way of generating the `properties.txt` but a manual copy from is simple `config.ini`

## Scripts

Bootstrap DL Lite scenarios with `./scripts/bootstrap.sh <folder> dllite [data]` - add data if you also want to generate data

Bootstrap ChaseBench scenarios with `./scripts/bootstrap.sh <folder> chasebench`
The setup.sh script is used to automate the bootstrapping of multiple scenarios - edit it as you need. Within the bootstrap.sh script, you will need to change the SIZES list to match which data sizes you wish to generate.

The generate.sh script automates data generation - use `./scripts/generate.sh <folder> <size>` where 'folder' is the top level scenario name and 'size' is a data size defined
in the config.ini in tools/datagenerator

build.sh drops a database if exists, then creates and imports - use `./scripts/build.sh <folder> <size>` where 'folder' is the top level scenario name and 'size' is a data size defined in the data folder of that scenario. The database information is taken from the scenario config.ini file

query.sh is the main heavy lifter of the scripts, and runs a test of a query on each tool, 6 times. It is invoked using `./scripts/query.sh <folder> <query number> <size>`, where 'folder' is the top level scenario name, query number is self explanatory and 'size' is a data size defined in the data folder of that scenario. Below will be a guide to modifying this script to expand it to more tools.

Most of these commands are automated using the run.sh script. At the moment, the parameters of the test have to be changed in the script itself, but this could be changed to take command line arguments

### Run.sh

This script automates the running of the query script. To add scenarios this script expand the `SCENARIOS` array to become something like

```
SCENARIOS=("scenarios/<SCENARIO NAME>" "scenarios/<SCENARIO NAME>")
```
To add test data sizes do the same but with the `SIZES` array to become something like

```
SIZES=("small" "medium")
```

The run the deep datasets change the SIZES to ```"deep"```

## Getting it to run

When first using the codebase, you need to download the Javascript dependencies and build the scripts. To do this:

```
cd obda-benchmark
yarn && yarn build && sudo npm link
```

Then, make sure you have the scenario folders set up as you need, following the layout defined above. You can use the setup.sh or bootstrap.sh scripts to automate the building of much of them.

Then, you need to edit the query.sh and run.sh scripts to define which tools you wish to run, over which scenarios and data sizes.

When the code has finished, the results are printed to set of CSV files found in the test/ folder of the scenarios.

## Tools

### Rapid

Rapid is taken from the link George sent to me, and I believe was slightly edited to not print as much superficial output, but nothing else was changed.

In this situation, it is invoked with the following command:

```java -jar Rapid2.jar DU SHORT <OWL ontology file> <rule query file>```

In the Rule Query file, numbers are used as variable names

### IQAROS

IQAROS is taken from the link George sent to me, but this was found to be broken since it has been partially updated with names changed in one place but not the other. There is an unofficial github <https://github.com/INL/iqaros> that contains a working version, which on inspection has just removed the broken code, which was a fix I found to work on the original code.

To invoke, use the following command:

```java -jar iqaros.jar <OWL ontology file> <rule query file>```

In the Rule Query file, numbers are used as variable names

### Graal

#### Rewriter

Graal uses only the query rewriting API from <http://graphik-team.github.io/graal/doc/index> as the full end-to-end could not be made to work. The examples were adapted to parse OWL ontologies and SPARQL queries and packaged into a Spring Jar as it was the only way found to get the dependencies to be included properly.

It is invoked with the following command:
```java -jar obda-benchmark-graal-1.0-SNAPSHOT-spring-boot.jar <OWL ontology file> <SPARQL query file>```

#### Other progress

In terms of progress towards the end-to-end system, it was found that Graal does not properly support Postgres in the fact that it cannot handle upper case letters in names. In emails to the creators, the following responses are highlighted:

>the main problem comes from the case sensitiveness detection. However PostgreSQL is case sensitive, JDBC says me not (through DatabaseMetaData.supportsMixedCaseIdentifiers())) so wrong processing is done over predicate and table names.
> but it's not an option in Graal. I think we misunderstood the semantic of the "supportsMixedCaseIdentifiers" method, so it's surely a bug.
>I just wanted to inform you that we have planned a more in-depth analysis of this problem during the week of May 20. We will keep you informed.

If this bug is fixed, I do not think it would be much work to get Graal working, since all the other infrastructure (ontologies, queries, databases) is already set up.

### RDFox

The RDFox jar is taken from the ChaseBench, and is invoked with the following command:

```
java -jar chaseRDFox-linux.jar -threads <number> -chase [standard | skolem] -s-sch <source schema> -t-sch <target schema> -st-tgds <source to target tgds> -src <data folder> -t-tgds <target tgds> -qdir <query folder>
```

I have added a run.sh script that simplifies running the code based on the folder structure defined above:

```
./run.sh <base scenario folder> <data size> <query number>
```

Queries have to use letters for variables

### BCA

The base BCA code that generates the new st-tgds is invoked with the following command:

```
java -jar chasestepper-1.0.jar <source to target tgds> <target tgds> <rule query file>
```

This was originally used in conjunction with RDFox to do the chasing, however has been paired with two other systems

#### GQR

GQR rewrites queries with only the source-to-target-tgds so the output of BCA can be used to answer any query based with only t-tgds and st-tgds. GQR was originally written to read and write in Datalog formats. I have ported this to use chasebench parsing and classes so that it can be easily used. The current version of GQR writes out to an SQL statement but that can be modified in source if required.

```
java -jar GQR.jar -st-tgds <source to target tgds> -q <rule query file>
```

#### Single Step Chase (ST-Chase)

Also another prototype name. This is a basic chase that only does one chase step based on a query and the st-tgds file. It should only be used seriously be used with BCA as this chase is not complete and would give inaccurate results.

```
java -jar ./tools/obdabenchmarkingtools/stChase-1.08.jar -t-sql <Target Schema in SQL> -s-sch <Source Schema in CB> -t-sch <Target Schema in CB> -st-tgds <BCA generated st-tgds> -q <CB query> -data <Folder of csv files>
```

This tool has a more in-depth on the obdabenchmarkingtools github project

### ChaseFun

The ChaseFun code is from George's dropbox, and includes a jar, a start script, and some sample properties files. I have not got ChaseFun to work properly, but I have made some progress and can provide some help.

Firstly, the properties file. Although there is both a 'userdb' and 'pwddb' field, the code internally only reads the 'userdb' property and assigns the it to the username and password - the result of this being your Postgres role must have the same username and password in order for ChaseFun to run.

From decompiling the jar, I can provide the following API

```
userdb : username for rdmbs
pwddb : COMPLETELY USELESS
dbUrlDriverSource : jdbc url of source database
dbUrlDriverTarget : jdbc url of target database
SourceSchema : name of source database (default : source)
TargetSchema : name of target database (default : target)
scenarioPath : base folder of scenario files
dataPath : data folder
solutionPath : folder to output solution to
recreateDb : remakes database (i think) (default : true)
doMaterialize : run chase (default : true)
threads : number of threads to use (default : all)
scenarioType : type of abstraction layer to use (default : pods)
```

scenarioType : pods (or leaving it blank) is what is needed here - otherwise it uses XML

At the moment, I can parse the scenario and import the data, but it then throws an error connecting (somehow?)

```Start: parse and import data
total tuples source: 5250000
Start: chase and export solution
Connection to the DB is impossible!! due to:java.sql.SQLException: Error preloading the connection pool
Try to restore the pool!!
Connection to the DB is definitly impossible!! due to:java.sql.SQLException: Error preloading the connection pool
```

I have tried using only lower case in the database names, no luck. Googling this error gives suggestions of setting the pool number to 0, but that doesn't seem to be an option we have control over.

#### Known Issue

In ChaseFun, you can only have one file named 's-schema' or 't-schema', regardless of file extension. This means you will have to rename the SQL files, or add a ~ to the start of the file name.

### Ontop

Ontop has finally decided to cooperate however requires is own unique files to run. Download from here <https://sourceforge.net/projects/ontop4obda/files/> and documentation here <https://ontop.inf.unibz.it/documentation/>.

There is also a seperate download for the tree-witness rewriter that is used internally <http://www.dcs.bbk.ac.uk/~roman/tw-rewriting/> and that can be used as such:

```
java -jar tw-rewriting.jar <OWL ontology file> <SPARQL query file>
```

However, this rewriter produces Datalog which now has been converted into ChaseBench format and this can be converted to SQL and has been added to the tests as the Tree Witness Rewriter like Rapid or IQAROS. This converter is also in the obdabenmarkingtools project and will be explained in that readme as well.

For the end-to-end, the download comes with a script with various commands - one of these is the bootstrap command, which creates the mapping files needed for Ontop:

```
./ontop bootstrap -m <mapping file name> -l <jdbc url> -p <database password> -u <database username> -d <jdbc driver name> -t <ontology file name> -b <base uri>
```

I would recommend not using this bootstrapping tool as it just doesn't really work and using the Ontop mapping generator that I have created. It probably isn't completely correctly either but it is much closer to working that their own tool. It does work for all the currently tested scenarios (It returns the same answers as the other tools)

The other command is to query

```
./ontop query -t <OWL ontology file> -q  <SPARQL query file> -m <Ontop Mapping file> -p <database properties file>
```

### Llunatic

While Llunatic I think has been discounted from this due to it only using one thread and therefore being very slow compared to RDFox, I can still provide some pointers for its use.

Download from <https://github.com/donatellosantoro/Llunatic> as this version definitely includes the fix that I had to submit to them. Build it with the ant command they define

```
ant gfp
```

and then use the runExp.sh script in the lunaticEngine folder. I have written a Javascript command that autogenerates the XML files needed to define a scenario in Llunatic:

```
obdabenchmark llunatic <folder>
```

If you provide a valid scenario folder of the structure defined above, this command should produce an XML file for each query for each data size you have data for.

I think there were still issues with its use for some of the scenarios, but we definitely got it to work for LUBM.

## Query Script

This script is can be broken down into the sections below

### Timing

Timing of most tools is done within the script by recording the time before running the script and then after it has finished and measuring the difference.

```
  START_TIME=$(date +%s%N)
  ACTION=$(COMMAND)
  TOOL[$TYPEOFACTION,$i]=$(($(date +%s%N) - $START_TIME))
```

Ontop is done slightly differently since it is end to end. This uses the times inside of the debug output, parsing them into the unix time format and then doing the save

```
STARTEVENT=$(echo <ONTOP OUTPUT> | grep <START MESSAGE>  | cut -d'[' -f 1);
STARTTIME=$(date -u -d <STARTEVENT> +"%s.%N");
ENDEVENT=$(echo <ONTOP OUTPUT> | grep <END MESSAGE>  | cut -d'[' -f 1);
ENDTIME=$(date -u -d <ENDEVENT> +"%s.%N");
ONTOP[$ACTION,$i]=$(date -u -d "0 $ENDTIME sec - $STARTTIME sec" +%S%N | sed 's/^0*//')
```


#### Issue

With Ontop sometimes it throws a curveball saying the query is empty. I haven't worked out why yet. It is a valid query and I think there are valid responses for that. This results in the timing being end event I was looking for not existing. Like below:

```
16:15:51.066 [main] DEBUG i.u.i.o.a.r.impl.QuestQueryProcessor - Directly translated (SPARQL) intermediate query:
ans1(x)
CONSTRUCT [x] []
   JOIN
      INTENSIONAL file:///home/aurona/0AlleWerk/Navorsing/Ontologies/NAP/NAP#Device(x)
      INTENSIONAL http://ksg.meraka.co.za/adolena.owl#assistsWith(x,y)
      INTENSIONAL file:///home/aurona/0AlleWerk/Navorsing/Ontologies/NAP/NAP#PhysicalAbility(y)

16:15:51.066 [main] DEBUG i.u.i.o.a.r.impl.QuestQueryProcessor - Start the unfolding...
16:15:51.071 [main] DEBUG i.u.i.o.a.r.impl.QuestQueryProcessor - Empty query --> no solution.
16:15:51.072 [Thread-2] DEBUG i.u.i.o.a.c.impl.QuestStatement - Executing the query and get the result...
16:15:51.073 [Thread-2] DEBUG i.u.i.o.a.c.impl.QuestStatement - Execution finished.
```

There is now error handling so that if a tool fails the whole of that run is set to having a time of -1 which can be caught by the tools that produce the graphs

### Recording the times

As shown there is a modified way of storing the times of the scripts compared to the original version by JE. This new system, I hope is more readable and is better for noticing mistakes. Each tool has an array declared with their name i.e

```
declare -A RAPID
declare -A IQAROS
declare -A GRAAL
declare -A ONTOP
...
```

Then each of the different metrics are giving an enum.

```
REWRITE=0
CONVERT=1
EXECUTE=2
SIZE=3
...
```

These two groups are then used in conjunction with each other where ```RAPID[$REWRITE,$i]``` refers to the time of rapid to rewrite for the i<sup>th</sup> time.

### File writing

Finally these arrays are written to csv files. The current settings will just append lines to a csv file which will cause most libraries to fail to parse the files. However they ensure the data isn't lost. First it writes the headings of each file. Then it writes out each of the results by iterating the arrays.

### Other Notes

There is a sister script to run.sh and query.sh called newRun.sh and newQuery.sh. Imaginatively named. These are used when the source to target tgds are non linear. These use GQR to bridge the gap between the rewritings and the source data. These have only been tested on one scenario.

Some of these tools require the use of Java8 (RDFox and Ontop). Not at least java8. Don't question it. If you're using something more modern (As you should) use something like sdkman, add ```JRE=~/.sdkman/candidates/java/8.0.201-oracle/bin/java``` to the top of the query script and replace ```java``` with ```$JRE```. It's what I've done personally. Most of the tools in obdabenchmarkingtools shouldn't care as long as its newer than Java8.

During development and testing the new scenarios. I created individual scripts for each tools without timing. I recommend doing this locally when you are having issue as it will skip all the DB creation which takes a while and the DB should still exist anyway. Just copy the script into another bash script and rip out the timing features.
