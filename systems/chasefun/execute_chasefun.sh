#!/bin/sh
SCENARIO=$1
VARIANT=$2
INPUT_DIR="/chasebench/tools/chasefun/input/"

START=$(date +%s)

mkdir -p /chasebench/tools/output/chasefun/$SCENARIO/$VARIANT/
cd chasefun
java -jar 'ChaseFUN.jar' $INPUT_DIR''$SCENARIO'/'$SCENARIO'-'$VARIANT'.properties'
#mv SOLUTION/*.csv /chasebench/tools/output/chasefun/$VARIANT/
cd ..
END=$(date +%s)
DIFF=$(( $END - $START ))
echo "Total time: $DIFF seconds"