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



if [[ $2 = "chasebench" ]]
then
  
  java -jar utilityTools/modifyChaseBench-1.08.jar -st-tgds $BASE_DIR/dependencies/oneToOne-st-tgds.txt -t-tgds $BASE_DIR/dependencies/oneToOne-t-tgds.txt -q $BASE_DIR/queries
  java -jar utilityTools/schemaGenerator-1.08.jar -st-tgds $BASE_DIR/dependencies/oneToOne-st-tgds.txt -t-tgds $BASE_DIR/dependencies/oneToOne-t-tgds.txt -s-schema $BASE_DIR/schema/oneToOne/s-schema.txt -t-schema $BASE_DIR/schema/oneToOne/t-schema.txt
  	
  cp -r $BASE_DIR/schema/oneToOne/. $BASE_DIR/schema/GAV

  #  create GAV and LAV Schema
	java -jar utilityTools/CreateLAVandGAV.jar
	mv -T $BASE_DIR/schema/lav/schema.txt $BASE_DIR/schema/LAV/s-schema.txt
  	rm -r $BASE_DIR/schema/lav
 	cp $BASE_DIR/schema/oneToOne/t-schema.txt $BASE_DIR/schema/LAV/t-schema.txt
    cp $BASE_DIR/schema/oneToOne/t-schema.sql $BASE_DIR/schema/LAV/t-schema.sql
 
	
	if [[ $3 = "data" ]]; then
    for size in ${SIZES[*]}; do
      mkdir -p $BASE_DIR/data/$GAVorLAV/$size
      ./scripts/generate.sh $BASE_DIR $size $GAVorLAV
    done
  fi
  obdabenchmark bootstrap $BASE_DIR chasebench
  mkdir -p $BASE_DIR/owl
  java -jar utilityTools/TGDToOWL-v1.10.jar -t-tgds $BASE_DIR/dependencies/oneToOne-t-tgds.txt -out $BASE_DIR/owl/ontology.owl
elif [[ $2 = "dllite" ]]
then

  obdabenchmark bootstrap $BASE_DIR dllite
	
    # change the name of st-tgds.txt files that created by node js 
	mv $BASE_DIR/dependencies/t-tgds.txt $BASE_DIR/dependencies/oneToOne-t-tgds.txt
	mv $BASE_DIR/dependencies/st-tgds.txt $BASE_DIR/dependencies/oneToOne-st-tgds.txt
	
	
	mv $BASE_DIR/schema/s-schema.txt $BASE_DIR/schema/oneToOne/s-schema.txt
	mv $BASE_DIR/schema/s-schema.sql $BASE_DIR/schema/oneToOne/s-schema.sql
	mv $BASE_DIR/schema/t-schema.txt $BASE_DIR/schema/oneToOne/t-schema.txt
	mv $BASE_DIR/schema/t-schema.sql $BASE_DIR/schema/oneToOne/t-schema.sql
	
	cp -r $BASE_DIR/schema/oneToOne/. $BASE_DIR/schema/GAV

  # java -jar utilityTools/schemaGenerator-1.08.jar -st-tgds $BASE_DIR/dependencies/oneToOne-st-tgds.txt -t-tgds $BASE_DIR/dependencies/oneToOne-t-tgds.txt -s-schema $BASE_DIR/schema/oneToOne/s-schema.txt -t-schema $BASE_DIR/schema/oneToOne/t-schema.txt
  # TODO: create GAV and LAV Schema
  java -jar utilityTools/CreateLAVandGAV.jar
  mv -T $BASE_DIR/schema/lav/schema.txt $BASE_DIR/schema/LAV/s-schema.txt
  rm -r $BASE_DIR/schema/lav
  cp $BASE_DIR/schema/oneToOne/t-schema.txt $BASE_DIR/schema/LAV/t-schema.txt
  cp $BASE_DIR/schema/oneToOne/t-schema.sql $BASE_DIR/schema/LAV/t-schema.sql
 
  if [[ $3 = "data" ]]; then
    for size in ${SIZES[*]}; do
      mkdir -p $BASE_DIR/data/$GAVorLAV/$size
      ./scripts/generate.sh $BASE_DIR $size $GAVorLAV
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

mkdir -p $BASE_DIR/CGQRFiles
# TODO: create t-tgd.txt and st-tgd.txt from jar file (that Tom has) and place it inside CGQRFiles
# TODO: this currently only creates a t-tgd file;
# TODO: confirm output location; currently goes to <scenario>/dependencies/cgqr-t-tgds.txt
java -jar utilityTools/CreateCGQRTTGDs.jar

mkdir -p $BASE_DIR/rulewerkfiles/GAV
mkdir -p $BASE_DIR/rulewerkfiles/LAV
mkdir -p $BASE_DIR/rulewerkfiles/oneToOne


for size in ${SIZES[*]}; do
   mkdir -p $BASE_DIR/rulewerkfiles/oneToOne/$size
   java -jar utilityTools/TGDsToRlsConverter.jar -st-tgds "$BASE_DIR/dependencies/oneToOne-st-tgds.txt" -t-tgds "$BASE_DIR/dependencies/oneToOne-t-tgds.txt" -out "$BASE_DIR/rulewerkfiles/oneToOne/$size" -data "$BASE_DIR/data/oneToOne/$size"
done

for size in ${SIZES[*]}; do
   mkdir -p $BASE_DIR/rulewerkfiles/GAV/$size
   java -jar utilityTools/TGDsToRlsConverter.jar -st-tgds "$BASE_DIR/dependencies/gav.txt" -t-tgds "$BASE_DIR/dependencies/oneToOne-t-tgds.txt" -out "$BASE_DIR/rulewerkfiles/GAV/$size" -data "$BASE_DIR/data/GAV/$size"
done

for size in ${SIZES[*]}; do
   mkdir -p $BASE_DIR/rulewerkfiles/LAV/$size
   java -jar utilityTools/TGDsToRlsConverter.jar -st-tgds "$BASE_DIR/dependencies/lav.txt" -t-tgds "$BASE_DIR/dependencies/oneToOne-t-tgds.txt" -out "$BASE_DIR/rulewerkfiles/LAV/$size" -data "$BASE_DIR/data/LAV/$size"
done