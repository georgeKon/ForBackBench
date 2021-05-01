# Utility Tools
This README describes the package of converter tools and other helper functions developed to assist the cross-approach comparison model by converting between formats such as ChaseBench and OWL2. These tools are used by the ForBackBench `scripts/` to run, but can also be used as standalone tools in other projects if desired.


## CreateCGQRTTGDs.jar

### NAME

`CreateCGQRTTGDs` \- creates T-TGDs for use with C-GQR

### SYNOPSIS

java -jar CreateCGQRTTGDs.jar <*tgd file*> <*output file*>


### DESCRIPTION

This script creates a complex T-TGD file by consolidating matching rules. For example:

`University(X) -> studentOf(Y, X)
University(X) -> administratorOf(Y, X)`

is consolidated to:

`University(X) -> studentOf(Y, X), administratorOf(Z, X)`


## CreateLAVandGAV.jar

### NAME

`CreateLAVandGAV` \- creates LAV or GAV mappings

### SYNOPSIS

java -jar CreateLAVandGAV.jar --create [**lav**|**gav**|**both**] --scenario [*scenario dir*] ... [*scenario dir*]


### DESCRIPTION


## datalogToCB-1.09.jar

### NAME

`datalogToCB` \- 

### SYNOPSIS

### DESCRIPTION

## GenerateAndAppendData.jar

### NAME

`GenerateAndAppendData` \- produces a dataset from a schema, a set of queries, or both

### SYNOPSIS

### DESCRIPTION

## GenerateDataFromTGD.jar

### NAME

`GenerateDataFromTGD` \- produces a dataset from a TGD file

### SYNOPSIS

### DESCRIPTION


## modifyChaseBench-1.08.jar

### NAME

`modifyChaseBench` \- 

### SYNOPSIS

### DESCRIPTION


## OBDAtoTGDsGAV.jar

### NAME

`OBDAtoTGDsGAV` \- 

### SYNOPSIS

### DESCRIPTION

## ontopMappingGenerator-1.08.jar

### NAME

`ontopMappingGenerator` \- 

### SYNOPSIS

### DESCRIPTION


## ontopMappingGenerator-1.09.jar

### NAME

`ontopMappingGenerator` \- 

### SYNOPSIS

### DESCRIPTION

## RulewerkLongTGDs.jar

### NAME

`RulewerkLongTGDs` \- 

### SYNOPSIS

### DESCRIPTION


## schemaGenerator-1.08.jar

### NAME

`schemaGenerator` \- 

### SYNOPSIS

### DESCRIPTION


## SQLConverterRealDB.jar

### NAME

`SQLConverterRealDB` \- 

### SYNOPSIS

### DESCRIPTION


## SQLConverterRealDB-v1.08.jar

### NAME

`SQLConverterRealDB` \- 

### SYNOPSIS

### DESCRIPTION


## TGDsToRlsConverter.jar

### NAME

`TGDsToRlsConverter` \- 

### SYNOPSIS

### DESCRIPTION


## TGDToOWL-v1.10.jar

### NAME

`TGDToOWL` \- 

### SYNOPSIS

### DESCRIPTION


## unfoldingV1.jar

### NAME

`unfolding` \- 

### SYNOPSIS

### DESCRIPTION
