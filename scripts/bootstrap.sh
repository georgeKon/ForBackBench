#!/bin/bash

BASE_DIR=$1
DATA=$3
GAVorLAV=$4

mkdir -p $BASE_DIR/data/GAV
mkdir -p $BASE_DIR/data/LAV
mkdir -p $BASE_DIR/data/oneToOne


mkdir -p $BASE_DIR/schema/GAV
mkdir -p $BASE_DIR/schema/LAV
mkdir -p $BASE_DIR/schema/oneToOne

SIZES=("small" "medium" "large")

# scenarioName=$(echo "$BASE_DIR" | cut -d "/" -f2 )
# echo "$scenarioName"
if [[ $2 = "chasebench" ]]
then
  cp $BASE_DIR/dependencies/oneToOne-st-tgds.txt $BASE_DIR/dependencies/st-tgds.txt
  cp $BASE_DIR/dependencies/oneToOne-t-tgds.txt $BASE_DIR/dependencies/t-tgds.txt
  java -jar utilityTools/modifyChaseBench-1.08.jar -st-tgds $BASE_DIR/dependencies/st-tgds.txt -t-tgds $BASE_DIR/dependencies/t-tgds.txt -q $BASE_DIR/queries
  java -jar utilityTools/schemaGenerator-1.08.jar -st-tgds $BASE_DIR/dependencies/oneToOne-st-tgds.txt -t-tgds $BASE_DIR/dependencies/oneToOne-t-tgds.txt -s-schema $BASE_DIR/schema/oneToOne/s-schema.txt -t-schema $BASE_DIR/schema/oneToOne/t-schema.txt
  cp $BASE_DIR/schema/oneToOne/s-schema.txt $BASE_DIR/schema/s-schema.txt
  cp $BASE_DIR/schema/oneToOne/t-schema.txt $BASE_DIR/schema/t-schema.txt
  if [[ $3 = "data" ]]; then
    for size in ${SIZES[*]}; do
    # Generate oneToOne data set
      mkdir -p $BASE_DIR/data/oneToOne/$size
      ./scripts/generate.sh $BASE_DIR $size oneToOne
    done
	fi
#  create GAV and LAV Schema and mappings

java -jar utilityTools/CreateLAVandGAV.jar 
java -jar utilityTools/ConvertCBschemaToSQL.jar -s-sch $BASE_DIR/schema/LAV/s-schema.txt -out $BASE_DIR/schema/LAV/s-schema.sql

 mkdir -p $BASE_DIR/owl
  java -jar utilityTools/TGDToOWL-v1.10.jar -t-tgds $BASE_DIR/dependencies/oneToOne-t-tgds.txt -out $BASE_DIR/owl/ontology.owl


  obdabenchmark bootstrap $BASE_DIR chasebench
  cp $BASE_DIR/schema/t-schema.sql $BASE_DIR/schema/oneToOne/t-schema.sql
  cp $BASE_DIR/schema/s-schema.sql $BASE_DIR/schema/oneToOne/s-schema.sql
  cp $BASE_DIR/schema/oneToOne/t-schema.sql $BASE_DIR/schema/LAV/t-schema.sql
  cp $BASE_DIR/schema/oneToOne/t-schema.txt $BASE_DIR/schema/LAV/t-schema.txt
  cp -r $BASE_DIR/schema/oneToOne/. $BASE_DIR/schema/GAV

if [[ $3 = "data" ]]; then
    for size in ${SIZES[*]}; do
   
    # Generate LAV data set
    mkdir -p $BASE_DIR/data/LAV/$size
	java -jar utilityTools/GenerateDataFromTGD.jar --tgd $BASE_DIR/dependencies/lav.txt  --output $BASE_DIR/data/LAV/$size

    # Generate GAV data set
     mkdir -p $BASE_DIR/data/GAV/$size
     ./scripts/generateGAVData.sh $BASE_DIR $size
    done
fi
java -jar utilityTools/ConvertCBschemaToSQL.jar -s-sch $BASE_DIR/schema/LAV/s-schema.txt -out $BASE_DIR/schema/LAV/s-schema.sql
java -jar utilityTools/ConvertCBschemaToSQL.jar -s-sch $BASE_DIR/schema/LAV/s-schema.txt -out $BASE_DIR/schema/LAV/s-schema.sql

 rm -r $BASE_DIR/dependencies/st-tgds.txt
 rm -r $BASE_DIR/dependencies/t-tgds.txt
 rm -r $BASE_DIR/schema/s-schema.txt
 rm -r $BASE_DIR/schema/t-schema.txt
 rm -r $BASE_DIR/schema/s-schema.sql
 rm -r $BASE_DIR/schema/t-schema.sql
elif [[ $2 = "dllite" ]]
then

  obdabenchmark bootstrap $BASE_DIR dllite
	
	# if [[ $3 = "data" ]]; then
#     for size in ${SIZES[*]}; do
#     # Generate oneToOne data set
#       mkdir -p $BASE_DIR/data/oneToOne/$size
#       ./scripts/generate.sh $BASE_DIR $size oneToOne
#     done
#     fi
	
    # change the name of st-tgds.txt files that created by node js 
	cp $BASE_DIR/dependencies/t-tgds.txt $BASE_DIR/dependencies/oneToOne-t-tgds.txt
	cp $BASE_DIR/dependencies/st-tgds.txt $BASE_DIR/dependencies/oneToOne-st-tgds.txt
	
	
	cp $BASE_DIR/schema/s-schema.txt $BASE_DIR/schema/oneToOne/s-schema.txt
	cp $BASE_DIR/schema/s-schema.sql $BASE_DIR/schema/oneToOne/s-schema.sql
	cp $BASE_DIR/schema/t-schema.txt $BASE_DIR/schema/oneToOne/t-schema.txt
	cp $BASE_DIR/schema/t-schema.sql $BASE_DIR/schema/oneToOne/t-schema.sql
	
	mkdir -p $BASE_DIR/owl
	cp $BASE_DIR/dependencies/ontology.owl $BASE_DIR/owl/ontology.owl
  # java -jar utilityTools/schemaGenerator-1.08.jar -st-tgds $BASE_DIR/dependencies/oneToOne-st-tgds.txt -t-tgds $BASE_DIR/dependencies/oneToOne-t-tgds.txt -s-schema $BASE_DIR/schema/oneToOne/s-schema.txt -t-schema $BASE_DIR/schema/oneToOne/t-schema.txt
  # TODO: create GAV and LAV Schema
#   java -jar utilityTools/CreateLAVandGAV.jar
#   mv -T $BASE_DIR/schema/lav/schema.txt $BASE_DIR/schema/LAV/s-schema.txt
#   rm -r $BASE_DIR/schema/lav
#   cp $BASE_DIR/schema/oneToOne/t-schema.txt $BASE_DIR/schema/LAV/t-schema.txt
#   cp $BASE_DIR/schema/oneToOne/t-schema.sql $BASE_DIR/schema/LAV/t-schema.sql
#  

#  create GAV and LAV Schema and mappings
java -jar utilityTools/CreateLAVandGAV.jar
java -jar utilityTools/ConvertCBschemaToSQL.jar -s-sch $BASE_DIR/schema/LAV/s-schema.txt -out $BASE_DIR/schema/LAV/s-schema.sql
cp $BASE_DIR/schema/oneToOne/t-schema.txt $BASE_DIR/schema/LAV/t-schema.txt
cp $BASE_DIR/schema/oneToOne/t-schema.sql $BASE_DIR/schema/LAV/t-schema.sql
cp -r $BASE_DIR/schema/oneToOne/. $BASE_DIR/schema/GAV

  if [[ $3 = "data" ]]; then
    for size in ${SIZES[*]}; do
    # Generate oneToOne data set
      mkdir -p $BASE_DIR/data/oneToOne/$size
      ./scripts/generate.sh $BASE_DIR $size oneToOne
      
    # Generate LAV data set
     mkdir -p $BASE_DIR/data/LAV/$size
	java -jar utilityTools/GenerateDataFromTGD.jar --tgd $BASE_DIR/dependencies/lav.txt  --output $BASE_DIR/data/LAV/$size

    # Generate GAV data set
     mkdir -p $BASE_DIR/data/GAV/$size
     ./scripts/generateGAVData.sh $BASE_DIR $size
    done
  fi
fi


# TODO: confirm this is the correct place to be creating GAV/LAV mappings
# if [[ $4 = "GAV" ]]; then
#   java -jar utilityTools/CreateLAVandGAV.jar create GAV
# fi
# if [[ $4 = "LAV" ]]; then
#   java -jar utilityTools/CreateLAVandGAV.jar create LAV
# fi
# if [[ $4 = "BOTH" ]]; then
#   java -jar utilityTools/CreateLAVandGAV.jar
# fi




mkdir -p $BASE_DIR/ontop-files
java -jar utilityTools/ontopMappingGenerator-1.09.jar -st-tgds $BASE_DIR/dependencies/oneToOne-st-tgds.txt -out $BASE_DIR/ontop-files/mapping.obda
java -jar utilityTools/ontopMappingGenerator-1.09.jar -st-tgds $BASE_DIR/dependencies/gav.txt -out $BASE_DIR/ontop-files/gav-mapping.obda

mkdir -p $BASE_DIR/dependencies/ChaseGQR
java -jar utilityTools/CreateCGQRTTGDs.jar $BASE_DIR/dependencies/oneToOne-t-tgds.txt $BASE_DIR/dependencies/ChaseGQR/cgqr-t-tgds.txt

mkdir -p $BASE_DIR/rulewerkfiles/GAV
mkdir -p $BASE_DIR/rulewerkfiles/LAV
mkdir -p $BASE_DIR/rulewerkfiles/oneToOne


for size in ${SIZES[*]}; do
   mkdir -p $BASE_DIR/rulewerkfiles/oneToOne/$size
   java -jar utilityTools/TGDsToRlsConverter.jar -st-tgds "$BASE_DIR/dependencies/oneToOne-st-tgds.txt" -t-tgds "$BASE_DIR/dependencies/oneToOne-t-tgds.txt" -out "$BASE_DIR/rulewerkfiles/oneToOne/$size" -data "$BASE_DIR/data/oneToOne/$size"
   mkdir -p $BASE_DIR/rulewerkfiles/GAV/$size
   java -jar utilityTools/TGDsToRlsConverter.jar -st-tgds "$BASE_DIR/dependencies/gav.txt" -t-tgds "$BASE_DIR/dependencies/oneToOne-t-tgds.txt" -out "$BASE_DIR/rulewerkfiles/GAV/$size" -data "$BASE_DIR/data/GAV/$size"
   mkdir -p $BASE_DIR/rulewerkfiles/LAV/$size
   java -jar utilityTools/TGDsToRlsConverter.jar -st-tgds "$BASE_DIR/dependencies/lav.txt" -t-tgds "$BASE_DIR/dependencies/oneToOne-t-tgds.txt" -out "$BASE_DIR/rulewerkfiles/LAV/$size" -data "$BASE_DIR/data/LAV/$size"
done

