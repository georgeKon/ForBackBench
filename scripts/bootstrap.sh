#!/bin/bash

BASE_DIR=$1
DATA=$3
mkdir -p $BASE_DIR/data
mkdir -p $BASE_DIR/out
SIZES=("small" "medium" "large")

mkdir -p $BASE_DIR/tests/$size

if [[ $2 = "chasebench" ]]
then
  if [[ $3 = "data" ]]; then
    for size in ${SIZES[*]}; do
      mkdir -p $BASE_DIR/data/$size
      ./scripts/generate.sh $BASE_DIR $size
    done
  fi
  java -jar tools/obdabenchmarkingtools/modifyChaseBench-1.08.jar -st-tgds $BASE_DIR/dependencies/st-tgds.txt -t-tgds $BASE_DIR/dependencies/t-tgds.txt -q $BASE_DIR/queries
  java -jar tools/obdabenchmarkingtools/schemaGenerator-1.08.jar -st-tgds $BASE_DIR/dependencies/st-tgds.txt -t-tgds $BASE_DIR/dependencies/t-tgds.txt -s-schema $BASE_DIR/schema/s-schema.txt -t-schema $BASE_DIR/schema/t-schema.txt

  obdabenchmark bootstrap $BASE_DIR chasebench
elif [[ $2 = "dllite" ]]
then
  mkdir -p $BASE_DIR/schema
  obdabenchmark bootstrap $BASE_DIR dllite
  if [[ $3 = "data" ]]; then
    for size in ${SIZES[*]}; do
      mkdir -p $BASE_DIR/data/$size
      ./scripts/generate.sh $BASE_DIR $size
    done
  fi
fi
java -jar tools/obdabenchmarkingtools/owlGenerator-1.08.jar -t-tgds $BASE_DIR/dependencies/t-tgds.txt -out $BASE_DIR/dependencies/ontology.owl
java -jar tools/obdabenchmarkingtools/ontopMappingGenerator-1.08.jar -st-tgds $BASE_DIR/dependencies/st-tgds.txt -owl $BASE_DIR/dependencies/ontology.owl -out $BASE_DIR/ontop-files/mapping.obda
