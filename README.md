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

Scenario folder structure

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

The majority of this structure can be bootstrapped using the provided scripts. For a DL-Lite scenario, the minimum set up to be bootstrapped is the following:

name/
|-- data/
| |-- a.csv
|-- dependencies/
| |-- ontology.owl
|-- queries
| |-- Qx.rq
|-- config.ini

For a ChaseBench scenario:

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