# Utility Tools
This README describes the package of converter tools and other helper functions developed to assist the cross-approach comparison model by converting between formats such as ChaseBench and OWL2 QL. These tools are used by the ForBackBench `scripts/` to run, but can also be used as standalone tools in other projects if desired. The source code folder also contains the source codes for all these tools. 


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
--create		[lav|gav|both]		| flag determining whether GAV, LAV, or both types of output are created. Defaults to both.
--scenario		[dir ...]			| A list of scenario directories to act on. Scenario folders must conform to the project spec. Defaults to looping through the scenario/ directory
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


`datalogToCB` \\- converts the datalog output into a list of sub queries and a main query

### SYNOPSIS

java -jar datalogToCB-1.09.jar -exts [*rewritings*] -query [*query*]

```
-exts       <string>  | the string contains the EXT rewritings
-query      <string>  | the string containing the query
```


### DESCRIPTION

This is used for getting the Tree Witness Rewriter (it also called  the ontop rewriter in places) to be compatible with the SQL converter. This converts the datalog output into a list of sub queries and a main query. It then will recursively substitute theses sub queries into the main query and all of those will be collected when no more substitutions can be made. This function also takes the datalog output as a cli argument that can be done using bash, not a file. 
This reads in strings from the command line and prints the output to the command line back. So no files are read for this.

## GenerateAndAppendData.jar

### NAME


`GenerateAndAppendData` \\- produces a dataset from a schema, a set of queries, or both

### SYNOPSIS

java -jar CreateLAVandGAV.jar --schema [*schema file*] --query [*query file*] ... [*query file*] --output <*output dir*>

```
--schema		[file]			| a file containing a schema
--query			[file ...]		| one or more query files (in e.g. ChaseBench format)
--output 		<folder>		| the folder that will contain the generated output
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
--tgd 			 <file>		| file containing a TGD mapping (GAV or LAV)
--output 		<dir>		| directory to store the output
--rows 			[int] 		| number of rows to generate, default 100]
--distinguished [int] 		| number of distinguished variables, default 5]
--existential 	[int] 		| number of existential variables, default 10]
```


### DESCRIPTION

This is an extension of the DataExchangeGenerator project, used to populate a dataset based on a TGD mapping (GAV or LAV). This tools is designed to append to existing data files in its output directory rather than overwriting them.


## ModifyChaseBench

### NAME

`modifyChaseBench` \\- produces queries formats that work with ontology based systems

### SYNOPSIS

java -jar utilityTools/modifyChaseBench-1.08.jar -st-tgds [*st-tgd file*] -t-tgds [*t-tgd file*] -q [*query file*]


```
-st-tgds       <file>   | the file containing the source-to-target TGDs
-t-tgds        <file>   | the file containing the target-to-target TGDs
-q             <folder> | the folder containing queries in chasebench format
```


### DESCRIPTION

This takes the old chasebench scenarios and makes them work with ontology based systems. As in, it chops the atoms or relations so that they are only binary and unary. This sometimes will give problems with existential and meaningless unanswerable queries, but they do usually run.

<!-- ### NOTE
The jar file for this tool can be build directly from the source code 'ModifyChaseBench.java'.
 -->

## OBDAtoTGDsGAV.jar

### NAME

`OBDAtoTGDsGAV` \\- Convert OBDA mapping file to GAV TGDs

### SYNOPSIS
java -jar utilityTools/OBDAtoTGDsGAV.jar [*mapping file*] [*schema file*] [*Output file*]

```
mapping        <file>   | the file containing the GAV OBDA mapping
schema         <file>   | the file containing the source schema in ChaseBench format
out          <folder>   | the output folder location.
```

### DESCRIPTION
This takes an OBDA mapping file and creates GAV source-to-traget TGD file. 


## ConvertCBschemaToSQL.jar

### NAME

`ConvertCBschemaToSQL` \\- Generate SQL schema from ChaseBench schema.

### SYNOPSIS

java -jar utilityTools/ConvertCBschemaToSQL.jar -s-sch [*ChaseBench schema file*] -out [*Output file*]


```
-s-sch       <file>   | the file containing the schema in ChaseBench format
-out         <file>   | the output file that will contain the SQL schema.
```


### DESCRIPTION
This takes database schema in ChaseBench format and creates an SQL schema file.


## ontopMappingGenerator-1.09.jar

### NAME

`ontopMappingGenerator` \\- creates Ontop OBDA mapping from TGDs.

### SYNOPSIS
java -jar ontopMappingGenerator-1.09.jar -st-tgds [*st-tgd file*] -out [*output file*]


```
-st-tgds    <file>  | the file containing the source-to-target TGDs
-out        <file>  | the file containing the obda mapping
```

### DESCRIPTION
This takes in an st-tgd file in CB format and creates an ontop obda mapping file. Theses mapping files are a series of unary and binary mappings in the format of 

for binary atoms or properties
```
mappingId <Mapping ID>
target  ns:ns/{var0} ns:<property> ns:ns/{var1} .
source  <SQL Statement>
```
for unary atoms or classes
```
mappingId <Mapping ID>
target  ns:<class>/{var0} a ns:<class> .
source  <SQL Statement>
```
These are created by going through the rules and filtering all the binary and unary target atoms then building these mapping from the rules. The sql statement is generated from the rule using the SQL converter that will be mentioned later. This currently will work with GAV (global as view or many to 1 rules) but I'm not sure about the correctness of LAV (1 to many rules). There are a bunch of owl related methods that are not used anymore but have been left if you wanted to expand the program. They mostly filter out only relevant atoms.




<!-- 
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

 -->


## RulewerkLongTGDs.jar

### NAME

`RulewerkLongTGDs` \\- create long complex TGDs

### SYNOPSIS

$JRE -jar RulewerkLongTGDs.jar -st-tgds [*st-tgd file*] -t-tgds [*t-tgd file*] -out [*output file*]

```
-st-tgds    <file>  | the file containing the source-to-target TGDs
-t-tgds    <file>  | the file containing the target-to-target TGDs
-out        <file>  | the file containing the query
```

### DESCRIPTION
To build a long TGD for each single body in st-TGD, Rulewerk is used to chase st-TGDs and t-TGDs; then, using the getInferences() method, all materialised instances (chased facts) are returned to build the head of the long TGD. 



## schemaGenerator

### NAME

`schemaGenerator` \\- generates source and target schema

### SYNOPSIS
java -jar schemaGenerator-1.08.jar -st-tgds [*st-tgd file*] -t-tgds [*t-tgd file*] -s-schema [*source schema file*] -t-schema [*target schema file*]


```
-st-tgds      <file>   | the file containing the source-to-target TGDs
-t-tgds       <file>   | the file containing the target-to-target TGDs
-s-schema     <file>   | the output file of the source schema
-t-schema     <file>   | the output file of the target schema
```

### DESCRIPTION
This takes in the st-tgds and t-tgds rules and returns source and target schemas. This is entirely uses the CB tools to this. With no file output location this will not print to the terminal and the results will be ignored so make sure they are included. This won't print anything to the command line



## SQLConverterRealDB.jar

### NAME

`SQLConverterRealDB` \\- converts UCQ fromOBDA systems to SQL queries

### SYNOPSIS
java -jar SQLConverterRealDB-v1.08.jar [*UCQ as String*] [*source schema file*] 

```
-s-schema     <file>   | the output file of the source schema
-UCQ         <string>  | the string containing the union of conjunctive queries from obda systems
```

 
### DESCRIPTION
This take the rewritings as union of conjunctive queries from rewriting tools and using the schema to create SQL query.


<!-- 
## SQLConverterRealDB-v1.08.jar

### NAME


`SQLConverterRealDB` \\- 

### SYNOPSIS

### DESCRIPTION
 -->




## TGDsToRlsConverter.jar

### NAME


`TGDsToRlsConverter` \\- generates the rule file format that required by RLS.

### SYNOPSIS

java -jar utilityTools/TGDsToRlsConverter.jar -st-tgds [*st-tgd file*] -t-tgds [*t-tgd file*] -out [*rls output file*] -data [*data folder*]

```
-st-tgds      <file>   | the file containing the source-to-target TGDs
-t-tgds       <file>   | the file containing the target-to-target TGDs
-s-schema     <file>   | the output file of RLS rule file
-data       <folder>   | the path for data folder 
```

### DESCRIPTION
This tool takes the source-to-target TGDs and target-to-target TGDs in ChaseBench format , and converts it into rls format.
As an example, consider the following source-to-target TGD:

```
S1(X) -> P1(X) .
```
It will be converted to: 

```
P1(?X) :- S1(?X) .
```



## TGDToOWL-v1.10.jar

### NAME

`TGDToOWL` \\- 

### SYNOPSIS

java -jar utilityTools/TGDToOWL-v1.10.jar -t-tgds [*t-tgd file*] -out [*owl output file*]

```
-t-tgds    <file>  | the file containing the target-to-target TGDs
-out        <file>  | the output file containing the ontology
```

### DESCRIPTION
It takes  a t-tgd file and loop through each rule to parse it, checks if it is supported by OWL 2 QL profile; then converts it to  an owl file. If the file contains illegal rule then it will not convert it to owl and shows a message to report the illegal rules.

For example, it takes the following TGD:
```
R(y,x) -> P(x, z) .
```

The generated owl:

```
<owl:ObjectProperty rdf:about="#R">
	<rdfs:range>
		<owl:Restriction>
    		<owl:onProperty rdf:resource="#P"/>
    		<owl:someValuesFrom rdf:resource="owl#Thing"/>
		</owl:Restriction>
	</rdfs:range>
</owl:ObjectProperty>
```


## UnfoldingV1.jar

### NAME

`unfolding` \\- unfold UCQ from obda based systems to an SQL query.

### SYNOPSIS
java -jar unfoldingV1.jar [*UCQ*] [*gav mapping file*] 
```
UCQ  <string>  | the string of UCQ from Rapid, Graal and Iqaros.
GAV  <file>    | the file containing the GAV mapping.
```

### DESCRIPTION

This converter unfold UCQ from Rapid, Graal and Iqaros using GAV mapping to produce query that is executable on GAV.
