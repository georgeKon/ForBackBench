# Overview
The project is split across 3 repositories

- obdabenchmark https://git.soton.ac.uk/gk1e17/obdabenchmark
- chasestepper https://git.soton.ac.uk/jde1g16/chasestepper
- obda-converter https://github.com/JamesErrington/obda-converter

This structure is very fluid and can be easily changed if needed - probably will need to be as the 'chasestepper' name was only meant to be a placeholder, and having stuff across 2 different git systems on 3 accounts probably isn't the best

obda-converter is a JavaScript project, written using TypeScript and bundled with NPM. obdabenchmark also contains a TypeScript segment, but is mostly bash scripts, data integration tools and scenario data. chasestepper is a Java project, bundled with Gradle - this could be altered to use maven or some other system if needed but is probably not recommended? It also contains the data generator files

ChaseStepper
To build - `gradle chasestepperJar`
         - `gradle dataJar`
Can also use `gradle clean` to clear previous builds 

Obdabenchmark
To download dependencies - `yarn` - this must be done on first downloading the code, or any time the 'node_modules' folder is deleted
To build - `yarn build`
Use `sudo npm link` to update the local binary command

Obda-converter
To download dependencies - `yarn` - this must be done on first downloading the code, or any time the 'node_modules' folder is deleted
To build - `yarn build`
Use `sudo npm link` to update the local binary command

The `obdabenchmark llunatic <folder>` command is used to generate the llunatic xml files for a scenario

# Scenario folder structure
```
name/
|-- data/               := CSV data files
| |-- a.csv
|-- dependencies/
| |-- ontology.owl      := OWL ontology file
| |-- st-tgds.txt       := ChaseBench rules 
| |-- t-tgds.txt        := ChaseBench rules
|-- out/                := LLunatic output folders
| |-- size/
|   |-- Qx/
|     |-- Qx.csv
|-- queries
| |-- graal             := SPARQL queries
|   |-- Qx.rq
| |-- iqaros            := IQAROS queries
|   |-- Qx.txt
| |-- RDFox             := ChaseBench queries
|   |-- Qx/
|     |-- Qx.txt
|     |-- size.xml      := LLunatic XML
|     |-- size-bca.xml  := LLunatic XML for BCA
|-- schema/             
| |-- s-schema.sql      := PostgreSQL sql
| |-- s-schema.txt      := ChaseBench schema
| |-- t-schema.sql      := PostgreSQL sql
| |-- t-schema.txt      := ChaseBench schema
|-- tests
| |-- size/
|   |-- Qx/
|     |-- tool.csv
|   |-- database.csv
|-- config.ini          := INI database config
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
# Scripts

Bootstrap DL Lite scenarios with `./scripts/bootstrap.sh <folder> dllite [data]` - add data if you also want to generate data
Bootstrap ChaseBench scenarios with `./scripts/bootstrap.sh <folder> chasebench`
The setup.sh script is used to automate the bootstrapping of multiple scenarios - edit it as you need

The generate.sh script automates data generation - use `./scripts/generate.sh <folder> <size>` where 'folder' is the top level scenario name and 'size' is a data size defined
in the config.ini in tools/datagenerator

build.sh drops a database if exists, then creates and imports - use `./scripts/build.sh <folder> <size>` where 'folder' is the top level scenario name and 'size' is a data size defined in the data folder of that scenario. The database information is taken from the scenario config.ini file

query.sh is the main heavy lifter of the scripts, and runs a test of a query on each tool, 6 times. It is invoked using `./scripts/query.sh <folder> <query number> <size>`, where 'folder' is the top level scenario name, query number is self explanatory and 'size' is a data size defined in the data folder of that scenario

Most of these commands are automated using the run.sh script. At the moment, the parameters of the test have to be changed in the script itself, but this could be changed to take command line arguments

# Things that need to be tested and fixed
- The BCA algorithm assigns numbers to labelled nulls - a prefix of the index of the tree, and then the number of the null. I have realised this does not guarantee unique nulls and while maybe it hasn't made a difference, should be fixed. It also needs to change because, guess what, Llunatic cannot take numbered variables.
- A way to fix non-trivial st-tgds