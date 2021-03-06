<!-- # Overview
 -->

<!-- obda-converter is a JavaScript project, written using TypeScript and bundled with NPM. obdabenchmark also contains a TypeScript segment, but is mostly bash scripts, data integration tools and scenario data. chasestepper is a Java project, bundled with Gradle - this could be altered to use maven or some other system if needed but is probably not recommended? It also contains the data generator files. Obdabenchmarkingtools is the recent addition to the previous 3 tools. Originally this was just a tool to generate mappings for Ontop but has significantly more tools bundled with it. Recommend looking at <https://git.soton.ac.uk/gk1e17/obda-chase-bench/blob/master/README.md> for more information on that.
 -->
<!-- 
### ChaseStepper

To build

- `gradle chasestepperJar`
- `gradle dataJar`
- Can also use `gradle clean` to clear previous builds
 -->

# ForBackBench Framework

ForBackBench framework is a benchmark infrastructure that provides a set of test scenarios, a set of generators, and translator tools in an experimental infrastructure to compare different chase and query-rewriting systems.

<!-- To download dependencies - `yarn` - this must be done on first downloading the code
<!-- , or any time the 'node_modules' folder is deleted
 -->
 <!-- 
To build

- `yarn build`
- Use `sudo npm link` to update the local binary command
 -->
<!-- 
### Obda-converter

To download dependencies

- `yarn`

this must be done on first downloading the code, or any time the 'node_modules' folder is deleted

To build

- `yarn build`
- Use `sudo npm link` to update the local binary command


<!-- 
The `obdabenchmark llunatic <folder>` command is used to generate the llunatic xml files for a scenario
 -->
<!-- 
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
 -->


## Getting it to run

<!-- When first using the codebase, you need to download the Javascript dependencies and build the scripts. To do this:

```
cd to project folder
yarn && yarn build && sudo npm link
```
 -->
To run experiments there are 3 different types of mappings:
- Simple One-To-One mapping (runTrivialMapping.sh)
- LAV mapping (runLAVMapping.sh)
- GAV mapping (runGAVMapping.sh)

Each run scripts run its corresponding Query script (queryTrivialMapping.sh, queryLAVMapping.sh, and queryGAVMapping.sh).

**To run experiments, you should follow these steps:**

**First,** make sure you have the scenario folders set up as you need, following the layout defined below. Note: If you want to create new scenario that is not currently in the scenario folder, you can use the bootstrap.sh script to automate the building of much of them as described below.

**Second,** follow these steps to set up the ForBackBench environment requirements:
1. This step for Windows only, install any bash command line such as Git bash.
2. Install Java.
3. Install Node.js
4. Install PostgreSQL.
5. Install yarn from command line:
```
	npm install --global yarn
	Then, add it to environment variable by following commands:
	cd C:\Users\userName\AppData\Roaming\npm\node_modules\yarn\bin
	set path=%PATH%;%CD%
	setx path "%PATH%"
 ```
6. Install dependencies:
```
	cd (to obda-benchmark folder inside project folder )
	yarn && yarn build && npm link
 ```
7. Add obdabenchmark command to the environment variable by following commands (this setp only is needed if you building a new scenario):
```
	cd C:\Users\userName\AppData\Roaming\npm
	set path=%PATH%;%CD%
	setx path "%PATH%"
 ```
8. Generate Data as described in Data Generation below 
9. Run experiment:
You may need to edit the selected run script to define which scenarios and data sizes you wish to run as defined in Run scripts section below, then use the commands:

<!-- 1- Make sure you have the scenario folders set up as you need, following the layout defined below. 
Note: If you want to create new scenario that is not currently in the scenario folder, you can use the bootstrap.sh script to automate the building of much of them as described below. 

2- You have to generate the data for the scenario you want as described in Data Generation below.

3- You need to edit the selected run script to define which scenarios and data sizes you wish to run as defined in Run scripts section below.
 You can edit the corresponding Query script to define which systems you wish to run as defined in Query scripts section below. -->

<!-- 4- Run the expriment, using the command: -->
```
cd scripts
./runTrivialMapping.sh 
or
./runLAVMapping.sh
or
./runGAVMapping.sh
```

When the code has finished, the results are printed to set of CSV files found in the experiments folder of the scenarios.

#### Notes:
- For Mac and Linux, these steps to run experiments and systems jar files.
- For windows, follow same steps as Mac and Linux, but for [RDFox](https://github.com/dbunibas/chasebench/tree/master/tools/rdfox) and [ONTOP](https://sourceforge.net/projects/ontop4obda/files/) systems check the developers of the tools.
- To run each utility in isolation read [this](https://github.com/georgeKon/ForBackBench/tree/OBDI/utilityTools#readme) 

### Experiments Folder Structure

This is where the experiment results go

```
experiments/scenarios
|-- scenario/ := Scenario Name
| |-- Mapping/ := GAV/LAV/oneToOne mapping
| | |-- size/ := small/medium/large dataset
| | | |-- query/ := Q1-5
| | | | |-- tool.csv := result of that query with each tool in the scenario
```

### Output Folder Structure

This is where the experiment results go

```
experiments/outputs/

|-- tool/ := Rewriting tools output (Iqaros, Rapid, Graal, OntopRW, ChaseGQR, GQR, RDFox, Rulewerk)
| |-- scenario/ := For each scenario
| | |-- rewriting/ := Q1-5
| | | |-- QX-rewritings.txt := Rewriting
| | |-- answers/ := Tuples Returned
| | | |-- size/
| | | | |-- QX.txt := Result for each query
| | |-- GAV/ := For GAV scenario
| | | |-- answers/ := Tuples Returned
| | | | |-- size/
| | | |-- rewriting/ := Q1-5
| | | | |-- QX-rewritings.txt := Rewriting
| | |-- LAV/ := For LAV scenario
| | | |-- answers/ := Tuples Returned
| | | | |-- size/
| | | |-- rewriting/ := Q1-5
| | | | |-- QX-rewritings.txt := Rewriting

|-- ontop/ := Ontop outputs
| |-- scenarios
| | |-- log/ := Ontop Output Log files
| | | |-- size/
| | | | |-- QX.txt := Log file for each query
| | |-- GAV/ := For GAV scenario
| | | |-- log/ := Ontop Output Log files


```

## Scripts

### Build Scenario Folder (bootstrap.sh)
This script build the scenario folder structure from DL Lite or ChaseBench scenarios.

The majority of this structure can be bootstrapped using the provided scripts. 
For a DL-Lite scenario, the minimum set up to be bootstrapped is the following:

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

To create a scenario from DL Lite scenario, use the command `./scripts/bootstrap.sh <folder> dllite [data]` - add data if you also want to generate data

To create a scenario from ChaseBench scenario, use the command  `./scripts/bootstrap.sh <folder> chasebench`

The setup.sh script is used to automate the bootstrapping of multiple scenarios - edit it as you need. Within the bootstrap.sh script, you will need to change the SIZES list to match which data sizes you wish to generate.

#### Scenario folder structure

```
name/
|-- data/               := CSV data files
| |-- Mapping/ := GAV/LAV/oneToOne mapping
| | |-- size/ := small/medium/large dataset
| | | |-- a.csv
|-- dependencies/
| |-- oneToOne-st-tgds.txt       := ChaseBench rules
| |-- oneToOne-t-tgds.txt        := ChaseBench rules
| |-- lav.txt        := ChaseBench rules
| |-- gav.txt        := ChaseBench rules
| |-- ChaseGQR/ := ChaseGQR rules
| | |-- cgqr-t-tgds.txt        := ChaseGQR rules
| | |-- db.properties    := ChaseGQR specific DB config file. (Similar to config.ini)
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
| |-- Mapping/ := GAV/LAV/oneToOne mapping
| | |-- s-schema.sql      := PostgreSQL sql
| | |-- s-schema.txt      := ChaseBench schema
| | |-- t-schema.sql      := PostgreSQL sql
| | |-- t-schema.txt      := ChaseBench schema
|-- ontop-files
| |-- mapping.obda      := Ontop Mapping file (Similar to st-tgds)
| |-- gav-mapping.obda      := Ontop GAV Mapping file (Similar to st-tgds)
| |-- properties.txt    := Ontop specific DB config file. (Similar to config.ini)
|-- rulewerkfiles/               := Rulewerk rules files
| |-- Mapping/ := GAV/LAV/oneToOne mapping
| | |-- size/ := small/medium/large dataset
| | | |-- rule.rls
|--postgres-config.ini          := INI database config
```
<!-- There hasn't been an automated way of generating the `properties.txt` but a manual copy from is simple `config.ini`
 -->

### Data Generation (generate.sh)
#### One-to-one mappings data
The generate.sh script automates data generation for One-to-one mappings by using the command:

```./scripts/generate.sh <folder> <size> oneToOne```, where:

```
<folder>  is the top level scenario name such as "scenarios/Deep100"
<size> is a data size defined in the config.ini in tools/datagenerator and it takes one of four values "small, medium, large, huge"
```


#### GAV/LAV mappings data
If you need to generate data for GAV or LAV mapping, you can simply use our Utility Tool in the command line:
```java -jar utilityTools/GenerateDataFromTGD.jar --tgd <file of LAV/GAV source-to-traget TGD>  --output <path for the data folder>```, where:

```
<file of LAV/GAV source-to-traget TGD> is the source-to-traget TGD and it loacted in scenario/dependencies/ folder. For example in Deep scenario, GAV is "scenarios/Deep100/dependencies/gav.txt" and LAV is "scenarios/Deep100/dependencies/lav.txt"
<path for the data folder> this should be follow the folder structure defined above such as "scenarios/Deep100/data/LAV/small" for small data in LAV and "scenarios/Deep100/data/GAV/small" for GAV.
```


### Build Database (build.sh)
This scripts drops a database if exists, then creates and imports - use `./scripts/build.sh <folder> <size>` where 'folder' is the top level scenario name and 'size' is a data size defined in the data folder of that scenario. The database information is taken from the scenario config.ini file

### Query scripts (queryTrivialMapping.sh, queryLAVMapping.sh, and queryGAVMapping.sh)
This is the main heavy lifter of the scripts, and runs a test of a query on each tool, 6 times. It is invoked inside run scripts using `./queryTrivialMapping.sh <folder> <query number> <size>`, where 'folder' is the top level scenario name, query number is self explanatory and 'size' is a data size defined in the data folder of that scenario. 

Most of these commands are automated using the Run scripts.

### Run scripts (runTrivialMapping.sh, runLAVMapping.sh, and runGAVMapping.sh)
This script automates the running of the query scripts. To add scenarios this script expand the `SCENARIOS` array to become something like

```
SCENARIOS=("scenarios/<SCENARIO NAME>" "scenarios/<SCENARIO NAME>")
```
To add test data sizes do the same but with the `SIZES` array to become something like

```
SIZES=("small" "medium")
```


# Re-run the online appendices experiments:

To run all experiments that in the online appendices:
1. Setup the environment by downloading the project and install all required program in the steps 1 to 7 in Getting it to run section. 
2. Generate Data for each scenario for all mappings and all data sizes. Let takes Deep scenario with medium data size as example:
    1. One-to-one mappings data: 
    ```
    ./scripts/generate.sh <folder> <size> oneToOne  
    ```
    Example, Deep scenario with medium data size
     ```
     mkdir -p scenarios/Deep100/data/oneToOne/medium
     ./scripts/generate.sh scenarios/Deep100 medium oneToOne
     ```
    2. LAV mapping data:  
    ```
    java -jar utilityTools/GenerateDataFromTGD.jar --tgd scenarios/Deep100/dependencies/lav.txt --rows 500 --output scenarios/Deep100/data/LAV/medium
    ```
    3. GAV mapping data: 
    ``` 
    ./scripts/generateGAVData.sh scenarios/Deep100 medium
    ```
Repeat these steps for all data sizes for all scenarios you want.

3. Run Expirements:
You need to edit the SCENARIOS and SIZES array inside the selected run script(runTrivialMapping.sh, runLAVMapping.sh, or runGAVMapping.sh) to define which scenarios and data sizes you wish to run. 
For example, to run Deep scenario with medium data size on OneToOne mapping:
	1. Open the run script (runTrivialMapping.sh), modify:
	```
	SCENARIOS=("scenarios/Deep100")
	SIZES=("medium")
	```
	2. Run the Expirement:
	```
	cd scripts
	./runTrivialMapping.sh 
	```
Repeat this step with LAV mapping (runLAVMapping.sh), or GAV mapping(runGAVMapping.sh) as you need.

4. Draw the graph:
**For OneToOne mapping:**
```
python scripts/csvToGraph.py experiments/scenarios/Deep100/oneToOne/medium 
```
**For LAV mapping:**
```
python scripts/csvToGraph.py experiments/scenarios/Deep100/LAV/medium 
```
**For GAV mapping:**
```
python scripts/csvToGraph.py experiments/scenarios/Deep100/GAV/medium 
```
Repeat this step with each experiments you run.	



<!-- **Note: to run each utility in isolation read** [this](https://github.com/georgeKon/ForBackBench/tree/OBDI/utilityTools#readme) 
 -->
