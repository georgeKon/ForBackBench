# Utility Tools
This README describes the package of converter tools and other helper functions developed to assist the cross-approach comparison model by converting between formats such as ChaseBench and OWL2. These tools are used by the ForBackBench 
```
scripts/
```
 to run, but can also be used as standalone tools in other projects if desired.


## CreateCGQRTTGDs.jar

### NAME


`CreateCGQRTTGDs` \\- creates T-TGDs for use with C-GQR

### SYNOPSIS

java -jar CreateCGQRTTGDs.jar <*tgd file*> <*output file*>


```
<tgd file>   | the file containing the source-to-target TGDs
<output file>   | the file to output the consolidated T-TGDs to
```

### DESCRIPTION

This script creates a complex T-TGD file by consolidating matching rules. For example:

```
University(X) -> studentOf(Y, X)
University(X) -> administratorOf(Y, X)
```

is consolidated to:

```
University(X) -> studentOf(Y, X), administratorOf(Z, X)
```


## CreateLAVandGAV.jar

### NAME


`CreateLAVandGAV` \\- creates LAV or GAV mappings from trivial mappings

### SYNOPSIS

java -jar CreateLAVandGAV.jar --create [**lav**|**gav**|**both**] --scenario [*scenario dir*] ... [*scenario dir*]


```
--create       [lav|gav|both]    | flag determining whether GAV, LAV, or both types of output are created. Defaults to both.
--scenario     [dir ...]   		 | A list of scenario directories to act on. Scenario folders must conform to the project spec. Defaults to looping through the scenario/ directory
```



### DESCRIPTION

This tool takes a (trivial) source-to-target mapping, and expands it into either a LAV or GAV mapping.
As an example, consider the following source-to-target mapping:


```
S1(X) -> P1(X)
S2(X) -> P2(X)
S3(X, Y) -> P3(X, Y)
```


With the GAV option, a batch of rule bodies are consolidated together. No variable names are replaced. E.g.:


```
S1(X), S2(X), S3(X, Y) -> P1(X)
```


With the LAV option, a batch of rule *heads* are consolidated together. Variable names in the head have a 50% chance of being replaced with a globally unique name. The body takes 30% of the unique variables present in the body (leaving the remainder as existential variables).


```
S1(X, A) -> P1(X), P2(A),  P3(X, Y)
```




## datalogToCB-1.09.jar

### NAME


`datalogToCB` \\- 

### SYNOPSIS

### DESCRIPTION




## GenerateAndAppendData.jar

### NAME


`GenerateAndAppendData` \\- produces a dataset from a schema, a set of queries, or both

### SYNOPSIS

java -jar CreateLAVandGAV.jar --schema [*schema file*] --query [*query file*] ... [*query file*] --output <*output dir*>



```
--schema       [file]        | a file containing a schema
-query        [file ...]     | one or more query files (in e.g. ChaseBench format)
-output       <folder>       | the folder that will contain the generated output
```



### DESCRIPTION
This is an extension of the DataExchangeGenerator project, used to populate datasets with data based on schema files or queries. This tools is designed to append to existing data files in its output directory rather than overwriting them.

Given a schema file, it will generate a set of compatible queries, and associated data that ensures the queries are resolvable.

Given one or more query files, it will generate data that ensures the queries are resolvable.

Given both schema file and one or more query files, it will generate data that ensures the queries are resolvable and then supplement this with data generated based on the schema.



## GenerateDataFromTGD.jar

### NAME


`GenerateDataFromTGD` \\- produces a dataset from a TGD file

### SYNOPSIS

java -jar GenerateDataFromTGD.jar --tgd <*tgd file*> --output <*output dir*> --rows [number of rows] --distinguished [number of distinguished variables] --existential [number of existential variables]


```
--tgd 			 <file>		 | file containing a TGD mapping (GAV or LAV)
--output 		<dir>		| directory to store the output
--rows 			[int] 		| number of rows to generate, default 100]
--distinguished [int] 		| number of distinguished variables, default 5]
--existential 	[int] 		| number of existential variables, default 10]
```


### DESCRIPTION

This is an extension of the DataExchangeGenerator project, used to populate a dataset based on a TGD mapping (GAV or LAV). This tools is designed to append to existing data files in its output directory rather than overwriting them.


## modifyChaseBench-1.08.jar

### NAME

`modifyChaseBench` \\- 

### SYNOPSIS

```
java -jar modifyChaseBench-1.08.jar 
```

```
-st-tgds       <file>   | the file containing the source-to-target TGDs
-t-tgds        <file>   | the file containing the target-to-target TGDs
-q             <folder> | the folder containing queries in chasebench format
```


### DESCRIPTION

This takes the old chasebench scenarios and makes them work with ontology based tools. As in, it chops the atoms or relations so that they are only binary and unary. This sometimes will give problems with existential and meaningless unanswerable queries, but they do usually run.




## OBDAtoTGDsGAV.jar

### NAME

`OBDAtoTGDsGAV` \\- 

### SYNOPSIS

### DESCRIPTION





## ontopMappingGenerator-1.08.jar

### NAME

`ontopMappingGenerator` \\- 

### SYNOPSIS

### DESCRIPTION




## ontopMappingGenerator-1.09.jar

### NAME

`ontopMappingGenerator` \\- 

### SYNOPSIS


```
-st-tgds    <file>  | the file containing the source-to-target TGDs
-out        <file>  | the file containing the query
```


### DESCRIPTION

This converter is not complete. The output isn't formatted correctly but it does parse with all the owl parsers the tools use. It takes only a t-tgd file and returns an owl file. It also makes the "src_" linear tgds if you need those. And can be done at the same time as generating the owl file. There are a few known issues that are listed below:
* There are edge cases that will successfully create owl files that will fail to parse. A lot of this has to do with the sub-properties, domain and ranges not being explicit, and other fun quirks.
* There are some implied domain and range constraints when they appear with explicit domain and range constraints there is an error. Maybe make a hierarchy of what is outputted?
* The use of inverseOf and a number of inverse properties that are used temporary fixes may sometimes interact with properties which are actually inverses.



## RulewerkLongTGDs.jar

### NAME

`RulewerkLongTGDs` \\- 

### SYNOPSIS

### DESCRIPTION




## schemaGenerator-1.08.jar

### NAME

`schemaGenerator` \\- 

### SYNOPSIS

### DESCRIPTION




## SQLConverterRealDB.jar

### NAME

`SQLConverterRealDB` \\- 

### SYNOPSIS

### DESCRIPTION



## SQLConverterRealDB-v1.08.jar

### NAME


`SQLConverterRealDB` \\- 

### SYNOPSIS

### DESCRIPTION




## TGDsToRlsConverter.jar

### NAME


`TGDsToRlsConverter` \\- 

### SYNOPSIS

### DESCRIPTION




## TGDToOWL-v1.10.jar

### NAME

`TGDToOWL` \\- 

### SYNOPSIS

### DESCRIPTION




## unfoldingV1.jar

### NAME

`unfolding` \\- 

### SYNOPSIS

### DESCRIPTION
