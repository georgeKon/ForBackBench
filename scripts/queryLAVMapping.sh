#!/bin/bash

## SETUP
NUM_TESTS=6
TIMEOUT=1800
BASE_DIR=$1
QUERY=$2
DATA_SIZE=$3
JRE=java

mkdir -p ../experiments/$BASE_DIR/LAV/$DATA_SIZE/Q$QUERY
# mkdir -p ../experiments/outputs/$BASE_DIR/LAV/$DATA_SIZE/Q$QUERY

# Read database config file
source <(grep = ../$BASE_DIR/postgres-config.ini)
export PGPASSWORD

##Enums for the recording results
REWRITE=0
GQR=1
EXECUTE=2
SIZE=3
TUPLES=4
CHASE=5
BLOCK=6
LOAD=7
TOTAL=8
GQRSIZE=9
CONVERT=10

# Set up result arrays
declare -A RAPID
declare -A IQAROS
declare -A GRAAL
declare -A ONTOPRW
declare -A BCAGQR
declare -A BCASTC
declare -A RDFOX
declare -A RULEWERK
declare -A RDFOX1
declare -A GQR
declare -A RULEWERK1
declare -A CGQR


# create new st-tgds using rulewerk 
# echo "===== Generating GQR st-TGDS  ...... "
# for ((i=0;i<4;++i)); do
# 	START_TIME=$(date +%s%N)
# 	$JRE -jar ../systems/chasestepper/chasestepper-1.01.jar ../$BASE_DIR/dependencies/lav.txt ../$BASE_DIR/dependencies/lav-t-tgds.txt ../$BASE_DIR/queries/GQRQuery/Qlong.txt > /dev/null
#    $JRE -jar ../utilityTools/RulewerkLongTGDs.jar -st-tgds ../$BASE_DIR/dependencies/lav.txt -t-tgds ../$BASE_DIR/dependencies/lav-t-tgds.txt -out ../$BASE_DIR/dependencies/longTGDs.rule
# 	CREATETGDSTIME=$(($(date +%s%N) - $START_TIME))
# 	mv ../$BASE_DIR/GQRQuery/Qlong-tgds.rule ../$BASE_DIR/GQRdependencies/st-tgds2.rule
# 	cp ../$BASE_DIR/GQRdependencies/st-tgds2.rule ../$BASE_DIR/dependencies/st-tgds2.txt
# done
# echo "===== Done. "

# RUN TESTS


echo "===== RAPID ====="
mkdir -p ../experiments/outputs/rapid/$BASE_DIR/LAV/rewritings
mkdir -p ../experiments/outputs/rapid/$BASE_DIR/LAV/gqr
mkdir -p ../experiments/outputs/rapid/$BASE_DIR/LAV/answer/$DATA_SIZE
for ((i=0;i<$NUM_TESTS;++i)); do
  START_TIME=$(date +%s%N)
  RAPID[$TOTAL,$i]=$START_TIME
  rapidOutput=$($JRE -jar ../systems/rapid/Rapid2.jar DU SHORT ../$BASE_DIR/owl/ontology.owl ../$BASE_DIR/queries/iqaros/Q$QUERY.txt 2> /dev/null | grep -G '^Q' | grep 'io_' -v | grep -v 'AUX')
  RAPID[$REWRITE,$i]=$(($(date +%s%N) - $START_TIME))
  RAPID[$SIZE,$i]=$(echo "$rapidOutput" | grep -c "<-")

  echo "$rapidOutput" | sed 's/$/ ./g' > ../experiments/outputs/rapid/$BASE_DIR/LAV/rewritings/Q$QUERY-rewriting.txt
 
  
	UNION=" UNION "
	COUNTER=1
	QSIZE=${RAPID[$SIZE,$i]}
	COMBINEDSQL=""
	START_TIME=$(date +%s%N)
	while read q; do
     	echo "$q" > ../experiments/outputs/rapid/$BASE_DIR/LAV/rewritings/Q$QUERY-rewriting-$COUNTER.txt
#   		OUT=$(java -jar ../systems/GQR/GQR-v1.08.jar -v ../$BASE_DIR/dependencies/lav.txt -q ../experiments/outputs/rapid/$BASE_DIR/LAV/rewritings/Q$QUERY-rewriting-$COUNTER.txt -d ../$BASE_DIR/dependencies/ChaseGQR/db.properties)
  OUT=$($JRE -jar ../systems/GQR/GQR.jar -st-tgds ../$BASE_DIR/dependencies/lav.txt -q ../experiments/outputs/rapid/$BASE_DIR/LAV/rewritings/Q$QUERY-rewriting-$COUNTER.txt)
		echo "$OUT"
		echo "$OUT" > ../experiments/outputs/rapid/$BASE_DIR/LAV/gqr/Q$QUERY-rewriting-$COUNTER.txt
		SINGLESQL=$(echo "$OUT"| grep "SELECT")
# 		if [ "$QSIZE" != "$COUNTER" ]; then
		SINGLESQL=${SINGLESQL//\;/$UNION}
# 		fi
		COMBINEDSQL=$COMBINEDSQL$SINGLESQL
		
		COUNTER=$[$COUNTER +1]
	done <../experiments/outputs/rapid/$BASE_DIR/LAV/rewritings/Q$QUERY-rewriting.txt

  echo "SQL this is 2: $COMBINEDSQL"
  RAPID[$CONVERT,$i]=$(($(date +%s%N) - $START_TIME))
   
  nulls=$(echo "$OUT" | grep -c "rewNo:null")
#   if [ "$nulls" = "0" ]; then 
#     SQL=$(echo "$OUT"| grep "SELECT")
    COMBINEDSQL1=$(echo "$COMBINEDSQL" | sed 's/\(.*\)UNION/\1 /')
    SQL=$COMBINEDSQL1
    RAPID[$GQRSIZE,$i]=$(echo "UNION $SQL" |grep -o -i "UNION" | wc -l)
   
    START_TIME=$(date +%s%N)
    RAPID[$TUPLES,$i]=$(psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -c "SELECT COUNT(*) FROM (${SQL%?}) AS query;" | grep '-' -A1 | grep -v '-')
    echo ${RAPID[$TUPLES,$i]} > ../experiments/outputs/rapid/$BASE_DIR/LAV/answer/$DATA_SIZE/Q$QUERY.txt
    RAPID[$EXECUTE,$i]=$(($(date +%s%N) - $START_TIME))
     if [ -z "$SQL" ]
	then
      RAPID[$TUPLES,$i]=0
	fi
    RAPID[$TOTAL,$i]=$(($(date +%s%N) - ${RAPID[$TOTAL,$i]}))
#   else
#     RAPID[$REWRITE,$i]="-1"
#     RAPID[$CONVERT,$i]="-1"
#     RAPID[$SIZE,$i]="-1"
#     RAPID[$TUPLES,$i]="-1"
#     RAPID[$EXECUTE,$i]="-1"
#     RAPID[$TOTAL,$i]="-1"
#     RAPID[$GQRSIZE,$i]="-1" 
#   fi
  echo "Rewriting: $((${RAPID[$REWRITE,$i]}/1000000)) milliseconds, Size: ${RAPID[$SIZE,$i]}"
  echo "Converting: $((${RAPID[$CONVERT,$i]}/1000000)) milliseconds"
  echo "GQR Size: ${RAPID[$GQRSIZE,$i]}"
  echo "Executing: $((${RAPID[$EXECUTE,$i]}/1000000)) milliseconds"
  echo "Time elapsed:: $((${RAPID[$TOTAL,$i]}/1000000)) milliseconds"
  echo "# of tuples: ${RAPID[$TUPLES,$i]}"
done

echo "===== IQAROS ====="
mkdir -p ../experiments/outputs/iqaros/$BASE_DIR/LAV/rewritings
mkdir -p ../experiments/outputs/iqaros/$BASE_DIR/LAV/gqr
mkdir -p ../experiments/outputs/iqaros/$BASE_DIR/LAV/answer/$DATA_SIZE
for ((i=0;i<$NUM_TESTS;++i)); do
  START_TIME=$(date +%s%N)
  IQAROS[$TOTAL,$i]=$START_TIME
  iqarosOutput=$($JRE -jar ../systems/iqaros/iqaros.jar ../$BASE_DIR/owl/ontology.owl ../$BASE_DIR/queries/iqaros/Q$QUERY.txt 2> /dev/null | grep -G '^Q' | grep 'io_' -v)

  IQAROS[$REWRITE,$i]=$(($(date +%s%N) - $START_TIME))
  IQAROS[$SIZE,$i]=$(echo "$iqarosOutput" | grep -c "<-")
  echo "Rewriting: $((${IQAROS[$REWRITE,$i]}/1000000)) milliseconds, Size: ${IQAROS[$SIZE,$i]}"

  echo "$iqarosOutput" | sed 's/\^/,/g; s/$/ ./g; s/X/?X/g' > ../experiments/outputs/iqaros/$BASE_DIR/LAV/rewritings/Q$QUERY-rewriting.txt
  
 #  START_TIME=$(date +%s%N)
#   OUT=$(java -jar ../systems/GQR/GQR-v1.08.jar -v ../$BASE_DIR/dependencies/lav.txt -q ../experiments/outputs/graal/$BASE_DIR/LAV/rewritings/Q$QUERY-rewriting.txt -d ../$BASE_DIR/dependencies/ChaseGQR/db.properties)
#   IQAROS[$CONVERT,$i]=$(($(date +%s%N) - $START_TIME))
#   echo "$OUT" > ../experiments/outputs/iqaros/$BASE_DIR/LAV/gqr/Q$QUERY-rewriting.txt
    UNION=" UNION "
	COUNTER=1
	QSIZE=${IQAROS[$SIZE,$i]}
	COMBINEDSQL=""
	START_TIME=$(date +%s%N)
	while read q; do
     	echo "$q" > ../experiments/outputs/iqaros/$BASE_DIR/LAV/rewritings/Q$QUERY-rewriting-$COUNTER.txt
#   		OUT=$(java -jar ../systems/GQR/GQR-v1.08.jar -v ../$BASE_DIR/dependencies/lav.txt -q ../experiments/outputs/iqaros/$BASE_DIR/LAV/rewritings/Q$QUERY-rewriting-$COUNTER.txt -d ../$BASE_DIR/dependencies/ChaseGQR/db.properties)
		OUT=$($JRE -jar ../systems/GQR/GQR.jar -st-tgds ../$BASE_DIR/dependencies/lav.txt -q ../experiments/outputs/iqaros/$BASE_DIR/LAV/rewritings/Q$QUERY-rewriting-$COUNTER.txt)

		echo "$OUT" > ../experiments/outputs/iqaros/$BASE_DIR/LAV/gqr/Q$QUERY-rewriting-$COUNTER.txt
		SINGLESQL=$(echo "$OUT"| grep "SELECT")
# 		if [ "$QSIZE" != "$COUNTER" ]; then
			SINGLESQL=${SINGLESQL//\;/$UNION}
# 		fi
		COMBINEDSQL=$COMBINEDSQL$SINGLESQL
		COUNTER=$[$COUNTER +1]
	done <../experiments/outputs/iqaros/$BASE_DIR/LAV/rewritings/Q$QUERY-rewriting.txt
    IQAROS[$CONVERT,$i]=$(($(date +%s%N) - $START_TIME))
  
  nulls=$(echo "$OUT" | grep -c "rewNo:null")
#   if [ "$nulls" = "0" ]; then 
#     SQL=$(echo "$OUT"| grep "SELECT")
	COMBINEDSQL1=$(echo "$COMBINEDSQL" | sed 's/\(.*\)UNION/\1 /')
    SQL=$COMBINEDSQL1
    IQAROS[$GQRSIZE,$i]=$(echo "UNION $SQL" |grep -o -i "UNION" | wc -l)
    START_TIME=$(date +%s%N)
    IQAROS[$TUPLES,$i]=$(psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -c "SELECT COUNT(*) FROM (${SQL%?}) AS query;" | grep '-' -A1 | grep -v '-')
    if [ -z "$SQL" ]
	then
      RAPID[$TUPLES,$i]=0
	fi
    echo ${IQAROS[$TUPLES,$i]} > ../experiments/outputs/iqaros/$BASE_DIR/LAV/answer/$DATA_SIZE/Q$QUERY.txt
    IQAROS[$EXECUTE,$i]=$(($(date +%s%N) - $START_TIME))
    IQAROS[$TOTAL,$i]=$(($(date +%s%N) - ${IQAROS[$TOTAL,$i]}))
  # else
#     IQAROS[$REWRITE,$i]="-1"
#     IQAROS[$CONVERT,$i]="-1"
#     IQAROS[$SIZE,$i]="-1"
#     IQAROS[$TUPLES,$i]="-1"
#     IQAROS[$EXECUTE,$i]="-1"
#     IQAROS[$TOTAL,$i]="-1"
#     IQAROS[$GQRSIZE,$i]="-1" 
#   fi
  echo "Rewriting: $((${IQAROS[$REWRITE,$i]}/1000000)) milliseconds, Size: ${IQAROS[$SIZE,$i]}"
  echo "Converting: $((${IQAROS[$CONVERT,$i]}/1000000)) milliseconds"
  echo "GQR Size: ${IQAROS[$GQRSIZE,$i]}"
  echo "Executing: $((${IQAROS[$EXECUTE,$i]}/1000000)) milliseconds"
  echo "Time elapsed:: $((${IQAROS[$TOTAL,$i]}/1000000)) milliseconds"
  echo "# of tuples: ${IQAROS[$TUPLES,$i]}"
  
done



echo "===== GRAAL ====="
mkdir -p ../experiments/outputs/graal/$BASE_DIR/LAV/rewritings
mkdir -p ../experiments/outputs/graal/$BASE_DIR/LAV/gqr
mkdir -p ../experiments/outputs/graal/$BASE_DIR/LAV/answer/$DATA_SIZE
for ((i=0;i<$NUM_TESTS;++i)); do
  START_TIME=$(date +%s%N)
  GRAAL[$TOTAL,$i]=$START_TIME
  graalOutput=$($JRE -jar ../systems/graal/obda-benchmark-graal-1.0-SNAPSHOT-spring-boot.jar ../$BASE_DIR/owl/ontology.owl ../$BASE_DIR/queries/SPARQL/Q$QUERY.rq 2> /dev/null | grep -G '^?' | grep 'io_' -v)
  GRAAL[$REWRITE,$i]=$(($(date +%s%N) - $START_TIME))
  GRAAL[$SIZE,$i]=$(echo "$graalOutput" | grep -c ":-")
  echo "Rewriting: $((${GRAAL[$REWRITE,$i]}/1000000)) milliseconds, Size: ${GRAAL[$SIZE,$i]}"
  echo "$graalOutput" | sed 's/?/Q/g; s/VAR_/?/g;s/X/?/g;s/<[a-zA-Z0-9\-\_\.\/\~\:]*#//g; s/>//g; s/:-/<-/g' > ../experiments/outputs/graal/$BASE_DIR/LAV/rewritings/Q$QUERY-rewriting.txt
  
 #  START_TIME=$(date +%s%N)
#   OUT=$(java -jar ../systems/GQR/GQR-v1.08.jar -v ../$BASE_DIR/dependencies/lav.txt -q ../experiments/outputs/graal/$BASE_DIR/LAV/rewritings/Q$QUERY-rewriting.txt -d ../$BASE_DIR/dependencies/ChaseGQR/db.properties)
#   GRAAL[$CONVERT,$i]=$(($(date +%s%N) - $START_TIME))
#   
    UNION=" UNION "
	COUNTER=1
	QSIZE=${GRAAL[$SIZE,$i]}
	COMBINEDSQL=""
	START_TIME=$(date +%s%N)
	while read q; do
     	echo "$q" > ../experiments/outputs/graal/$BASE_DIR/LAV/rewritings/Q$QUERY-rewriting-$COUNTER.txt
#   		OUT=$(java -jar ../systems/GQR/GQR-v1.08.jar -v ../$BASE_DIR/dependencies/lav.txt -q ../experiments/outputs/graal/$BASE_DIR/LAV/rewritings/Q$QUERY-rewriting-$COUNTER.txt -d ../$BASE_DIR/dependencies/ChaseGQR/db.properties)
		OUT=$($JRE -jar ../systems/GQR/GQR.jar -st-tgds ../$BASE_DIR/dependencies/lav.txt -q ../experiments/outputs/graal/$BASE_DIR/LAV/rewritings/Q$QUERY-rewriting-$COUNTER.txt)

		echo "$OUT" > ../experiments/outputs/graal/$BASE_DIR/LAV/gqr/Q$QUERY-rewriting-$COUNTER.txt
		SINGLESQL=$(echo "$OUT"| grep "SELECT")
# 		if [ "$QSIZE" != "$COUNTER" ]; then
			SINGLESQL=${SINGLESQL//\;/$UNION}
# 		fi
		COMBINEDSQL=$COMBINEDSQL$SINGLESQL
		COUNTER=$[$COUNTER +1]
	done <../experiments/outputs/graal/$BASE_DIR/LAV/rewritings/Q$QUERY-rewriting.txt
    GRAAL[$CONVERT,$i]=$(($(date +%s%N) - $START_TIME))
  
  echo "$OUT" > ../experiments/outputs/graal/$BASE_DIR/LAV/gqr/Q$QUERY-rewriting.txt
  nulls=$(echo "$OUT" | grep -c "rewNo:null")
#   if [ "$nulls" = "0" ]; then 
#     SQL=$(echo "$OUT"| grep "SELECT")
	COMBINEDSQL1=$(echo "$COMBINEDSQL" | sed 's/\(.*\)UNION/\1 /')
    SQL=$COMBINEDSQL1
    GRAAL[$GQRSIZE,$i]=$(echo "UNION $SQL" |grep -o -i "UNION" | wc -l)
    START_TIME=$(date +%s%N)
    GRAAL[$TUPLES,$i]=$(psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -c "SELECT COUNT(*) FROM (${SQL%?}) AS query;" | grep '-' -A1 | grep -v '-')
    if [ -z "$SQL" ]
	then
      RAPID[$TUPLES,$i]=0
	fi
    echo ${GRAAL[$TUPLES,$i]} > ../experiments/outputs/graal/$BASE_DIR/LAV/answer/$DATA_SIZE/Q$QUERY.txt
    GRAAL[$EXECUTE,$i]=$(($(date +%s%N) - $START_TIME))
    GRAAL[$TOTAL,$i]=$(($(date +%s%N) - ${GRAAL[$TOTAL,$i]}))
  # else
#     GRAAL[$REWRITE,$i]="-1"
#     GRAAL[$CONVERT,$i]="-1"
#     GRAAL[$SIZE,$i]="-1"
#     GRAAL[$TUPLES,$i]="-1"
#     GRAAL[$EXECUTE,$i]="-1"
#     GRAAL[$TOTAL,$i]="-1"
#     GRAAL[$GQRSIZE,$i]="-1" 
#   fi
  echo "Rewriting: $((${GRAAL[$REWRITE,$i]}/1000000)) milliseconds, Size: ${GRAAL[$SIZE,$i]}"
  echo "Converting: $((${GRAAL[$CONVERT,$i]}/1000000)) milliseconds"
  echo "GQR Size: ${GRAAL[$GQRSIZE,$i]}"
  echo "Executing: $((${GRAAL[$EXECUTE,$i]}/1000000)) milliseconds"
  echo "Time elapsed:: $((${GRAAL[$TOTAL,$i]}/1000000)) milliseconds"
  echo "# of tuples: ${GRAAL[$TUPLES,$i]}" 
done

echo "===== ONTOP RW ====="
mkdir -p ../experiments/outputs/ontoprw/$BASE_DIR/LAV/rewritings
mkdir -p ../experiments/outputs/ontoprw/$BASE_DIR/LAV/gqr
mkdir -p ../experiments/outputs/ontoprw/$BASE_DIR/LAV/answer/$DATA_SIZE
for ((i=0;i<$NUM_TESTS;++i)); do
 START_TIME=$(date +%s%N)
  ONTOPRW[$TOTAL,$i]=$START_TIME
  ontopOutput=$($JRE -jar ../systems/tw-rewriting/tw-rewriting.jar ../$BASE_DIR/owl/ontology.owl ../$BASE_DIR/queries/SPARQL/Q$QUERY.rq | sed '/FINAL REWRITING/,$!d; /REWRITING OVER/,$d')
  ONTOPRW[$REWRITE,$i]=$(($(date +%s%N) - $START_TIME))
  
  subs=$(echo "$ontopOutput" | grep ':-' | grep -v 'q' | sed 's/$/ ./g')
  query=$(echo "$ontopOutput" | grep ':-' | grep 'q' | cut -d '#' -f1 | sed 's/$/ ./g')
  cbq=$(java -jar ../utilityTools/datalogToCB-1.09.jar -exts "$subs" -query "$query")
  ONTOPRW[$SIZE,$i]=$(echo "$cbq" | grep -c "<-")
  echo "$cbq" > ../experiments/outputs/ontoprw/$BASE_DIR/LAV/rewritings/Q$QUERY-rewriting.txt
  echo "Rewriting: $((${ONTOPRW[$REWRITE,$i]}/1000000)) milliseconds, Size: ${ONTOPRW[$SIZE,$i]}"

#   START_TIME=$(date +%s%N)
#   OUT=$(java -jar ../systems/GQR/GQR-v1.08.jar -v ../$BASE_DIR/dependencies/lav.txt -q ../experiments/outputs/ontoprw/$BASE_DIR/LAV/rewritings/Q$QUERY-rewriting.txt -d ../$BASE_DIR/dependencies/ChaseGQR/db.properties)
#   ONTOPRW[$CONVERT,$i]=$(($(date +%s%N) - $START_TIME))
#   
    UNION=" UNION "
	COUNTER=1
	QSIZE=${ONTOPRW[$SIZE,$i]}
	COMBINEDSQL=""
	START_TIME=$(date +%s%N)
	while read q; do
     	echo "$q" > ../experiments/outputs/ontoprw/$BASE_DIR/LAV/rewritings/Q$QUERY-rewriting-$COUNTER.txt
#   		OUT=$(java -jar ../systems/GQR/GQR-v1.08.jar -v ../$BASE_DIR/dependencies/lav.txt -q ../experiments/outputs/ontoprw/$BASE_DIR/LAV/rewritings/Q$QUERY-rewriting-$COUNTER.txt -d ../$BASE_DIR/dependencies/ChaseGQR/db.properties)
		OUT=$($JRE -jar ../systems/GQR/GQR.jar -st-tgds ../$BASE_DIR/dependencies/lav.txt -q ../experiments/outputs/ontoprw/$BASE_DIR/LAV/rewritings/Q$QUERY-rewriting-$COUNTER.txt)
		echo "$OUT" > ../experiments/outputs/ontoprw/$BASE_DIR/LAV/gqr/Q$QUERY-rewriting-$COUNTER.txt
		SINGLESQL=$(echo "$OUT"| grep "SELECT")
# 		if [ "$QSIZE" != "$COUNTER" ]; then
			SINGLESQL=${SINGLESQL//\;/$UNION}
# 		fi
		COMBINEDSQL=$COMBINEDSQL$SINGLESQL
		COUNTER=$[$COUNTER +1]
	done <../experiments/outputs/ontoprw/$BASE_DIR/LAV/rewritings/Q$QUERY-rewriting.txt
    ONTOPRW[$CONVERT,$i]=$(($(date +%s%N) - $START_TIME))
  
  echo "$OUT" > ../experiments/outputs/ontoprw/$BASE_DIR/LAV/gqr/Q$QUERY-rewriting.txt
  nulls=$(echo "$OUT" | grep -c "rewNo:null")
#   if [ "$nulls" = "0" ]; then 
#     SQL=$(echo "$OUT"| grep "SELECT")
#     SQL=$COMBINEDSQL
    ONTOPRW[$GQRSIZE,$i]=$(echo "UNION $SQL" |grep -o -i "UNION" | wc -l)
    START_TIME=$(date +%s%N)
    ONTOPRW[$TUPLES,$i]=$(psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -c "SELECT COUNT(*) FROM (${SQL%?}) AS query;" | grep '-' -A1 | grep -v '-')
    if [ -z "$SQL" ]
	then
      RAPID[$TUPLES,$i]=0
	fi
    echo ${ONTOPRW[$TUPLES,$i]} > ../experiments/outputs/ontoprw/$BASE_DIR/LAV/answer/$DATA_SIZE/Q$QUERY.txt
    ONTOPRW[$EXECUTE,$i]=$(($(date +%s%N) - $START_TIME))
    ONTOPRW[$TOTAL,$i]=$(($(date +%s%N) - ${ONTOPRW[$TOTAL,$i]}))
  # else
#     ONTOPRW[$REWRITE,$i]="-1"
#     ONTOPRW[$CONVERT,$i]="-1"
#     ONTOPRW[$SIZE,$i]="-1"
#     ONTOPRW[$TUPLES,$i]="-1"
#     ONTOPRW[$EXECUTE,$i]="-1"
#     ONTOPRW[$TOTAL,$i]="-1"
#     ONTOPRW[$GQRSIZE,$i]="-1" 
#   fi
  echo "Rewriting: $((${ONTOPRW[$REWRITE,$i]}/1000000)) milliseconds, Size: ${ONTOPRW[$SIZE,$i]}"
  echo "Converting: $((${ONTOPRW[$CONVERT,$i]}/1000000)) milliseconds"
  echo "GQR Size: ${ONTOPRW[$GQRSIZE,$i]}"
  echo "Executing: $((${ONTOPRW[$EXECUTE,$i]}/1000000)) milliseconds"
  echo "Time elapsed:: $((${ONTOPRW[$TOTAL,$i]}/1000000)) milliseconds"
  echo "# of tuples: ${ONTOPRW[$TUPLES,$i]}" 
done
# 
echo "===== RDFox Original ====="
for ((i=0;i<$NUM_TESTS;++i)); do
  START_TIME=$(date +%s%N)
  RDFOX[$TOTAL,$i]=$START_TIME
  OUT=$(timeout $TIMEOUT $JRE -jar ../systems/RDFox/chaseRDFox-linux.jar -chase standard -s-sch ../$BASE_DIR/schema/LAV/s-schema.txt -t-sch ../$BASE_DIR/schema/LAV/t-schema.txt -st-tgds ../$BASE_DIR/dependencies/lav.txt -src ../$BASE_DIR/data/LAV/$DATA_SIZE -t-tgds ../$BASE_DIR/dependencies/lav-t-tgds.txt -qdir ../$BASE_DIR/queries/Chasebench/Q$QUERY/)
  if [ $? -eq 0 ]; then
    RDFOX[$TOTAL,$i]=$(($(date +%s%N) - $START_TIME))
    RDFOX[$LOAD,$i]=$(echo "$OUT" | grep "Loading source instance data" | cut -d'.' -f4 | cut -d'm' -f1)
    RDFOX[$CHASE,$i]=$(echo "$OUT" | grep "Chase took"| cut -d 'm' -f 1 | cut -d 'k' -f 2)
    RDFOX[$EXECUTE,$i]=$(echo "$OUT" | grep "Total time" | cut -d ':' -f 2 | cut -d 'm' -f 1)
    RDFOX[$TUPLES,$i]=$(echo "$OUT" | grep "Query" -A1 | grep -v "Query" | cut -d ':' -f 2)
    
    if [ -z "${RDFOX[$LOAD,$i]}" ]
	then
      RDFOX[$LOAD,$i]="-1"
	fi
    
    
  else 
    RDFOX[$TOTAL,$i]="-1"
    RDFOX[$LOAD,$i]="-1"
    RDFOX[$CHASE,$i]="-1"
    RDFOX[$EXECUTE,$i]="-1"
    RDFOX[$TUPLES,$i]="-1"
  fi
  echo "Chasing: $((${RDFOX[$CHASE,$i]})) milliseconds"
  echo "Loading: $((${RDFOX[$LOAD,$i]})) milliseconds"
  echo "Executing: $((${RDFOX[$EXECUTE,$i]})) milliseconds"
  echo "Time elapsed: $((${RDFOX[$TOTAL,$i]}/1000000)) milliseconds"
  echo "# of tuples: ${RDFOX[$TUPLES,$i]}"
done

# echo "===== RDFox with long st-tgds ====="
# for ((i=0;i<$NUM_TESTS;++i)); do
#   START_TIME=$(date +%s%N)
#   RDFOX1[$TOTAL,$i]=$START_TIME
#   OUT=$(timeout $TIMEOUT $JRE -jar ../systems/RDFox/chaseRDFox-linux.jar -chase standard -s-sch ../$BASE_DIR/schema/LAV/s-schema.txt -t-sch ../$BASE_DIR/schema/LAV/t-schema.txt -st-tgds ../$BASE_DIR/dependencies/st-tgds3.txt -src ../$BASE_DIR/data/LAV/$DATA_SIZE -t-tgds ../$BASE_DIR/dependencies/t-tgds2.txt -qdir ../$BASE_DIR/queries/Chasebench/Q$QUERY/)
#   if [ $? -eq 0 ]; then
#     RDFOX1[$TOTAL,$i]=$(($(date +%s%N) - $START_TIME))
#     RDFOX1[$LOAD,$i]=$(echo "$OUT" | grep "Loading source instance data" | cut -d'.' -f4 | cut -d'm' -f1)
#     RDFOX1[$CHASE,$i]=$(echo "$OUT" | grep "Chase took"| cut -d 'm' -f 1 | cut -d 'k' -f 2)
#     RDFOX1[$EXECUTE,$i]=$(echo "$OUT" | grep "Total time" | cut -d ':' -f 2 | cut -d 'm' -f 1)
#     RDFOX1[$TUPLES,$i]=$(echo "$OUT" | grep "Query" -A1 | grep -v "Query" | cut -d ':' -f 2)
#     RDFOX1[$BLOCK,$i]=$CREATETGDSTIME
#   else 
#     RDFOX1[$TOTAL,$i]="-1"
#     RDFOX1[$LOAD,$i]="-1"
#     RDFOX1[$CHASE,$i]="-1"
#     RDFOX1[$EXECUTE,$i]="-1"
#     RDFOX1[$TUPLES,$i]="-1"
#     RDFOX1[$BLOCK,$i]="-1"
#   fi
#   echo "Blocking: $((${RDFOX1[$BLOCK,$i]}/1000000)) milliseconds"
#   echo "Chasing: $((${RDFOX1[$CHASE,$i]})) milliseconds"
#   echo "Loading: $((${RDFOX1[$LOAD,$i]})) milliseconds"
#   echo "Executing: $((${RDFOX1[$EXECUTE,$i]})) milliseconds"
#   echo "Time elapsed: $((${RDFOX1[$TOTAL,$i]}/1000000)) milliseconds"
#   echo "# of tuples: ${RDFOX1[$TUPLES,$i]}"
# done

echo "===== CGQR ====="
mkdir -p ../experiments/outputs/chasegqr/$BASE_DIR/LAV/rewritings
mkdir -p ../experiments/outputs/chasegqr/$BASE_DIR/LAV/gqr
mkdir -p ../experiments/outputs/chasegqr/$BASE_DIR/LAV/answer/$DATA_SIZE

for ((i=0;i<$NUM_TESTS;++i)); do
  START_TIME=$(date +%s%N)
  CGQR[$TOTAL,$i]=$START_TIME
  #  $JRE -jar ./../systems/chasestepper/chasestepper-1.01.jar ../$BASE_DIR/dependencies/st-tgds.txt ../$BASE_DIR/dependencies/t-tgds.txt ../$BASE_DIR/queries/Chasebench/Q$QUERY/Q$QUERY.txt > /dev/null
  #   mv ../$BASE_DIR/queries/Chasebench/Q$QUERY/Q$QUERY-tgds.rule ../experiments/outputs/bcagqr/$BASE_DIR/chased-mapping
  #   BCAGQR[$PREPROCESS,$i]=$(($(date +%s%N) - $START_TIME))
  START_TIME=$(date +%s%N)
  OUT=$($JRE -jar ../systems/ChaseGQR/ChaseGQR.jar -t ../$BASE_DIR/dependencies/ChaseGQR/cgqr-t-tgds.txt -v ../$BASE_DIR/dependencies/lav.txt -q ../$BASE_DIR/queries/Chasebench/Q$QUERY/Q$QUERY.txt -d ../$BASE_DIR/dependencies/ChaseGQR/db.properties)
#   CGQR[$CONVERT,$i]=$(($(date +%s%N) - $START_TIME))
  if [ $? -eq 0 ]; then
    loadingStart=$(echo "$OUT" | grep "Start Loading Views"| cut -d ' ' -f2 );
    loadingSTime=$(date -u -d "$loadingStart" +"%s.%N"); 
    
    gqrStart=$(echo "$OUT" | grep "Start GQR"| cut -d ' ' -f2 );
    gqrSTime=$(date -u -d "$gqrStart" +"%s.%N"); 
    CGQR[$LOAD,$i]=$(date -u -d "0 $gqrSTime sec - $loadingSTime sec" +%S%N | sed 's/^0*//')

    rwStart=$(echo "$OUT" | grep "Start Rewriting"| cut -d ' ' -f2  );
    rwStartTime=$(date -u -d "$rwStart" +"%s.%N"); 
#     CGQR[$CONVERT,$i]=$(date -u -d "0 $rwStartTime sec - $gqrSTime sec" +%S%N | sed 's/^0*//')
    
    convertStart=$(echo "$OUT" | grep "Start Converting to SQL"| cut -d ' ' -f2 );
    convertStartTime=$(date -u -d "$convertStart" +"%s.%N"); 

    CGQR[$REWRITE,$i]=$(date -u -d "0 $convertStartTime sec - $gqrSTime sec" +%S%N | sed 's/^0*//')
 
    exStart=$(echo "$OUT" | grep "Start Executing SQL"| cut -d ' ' -f2 );
    exStartTime=$(date -u -d "$exStart" +"%s.%N"); 
    CGQR[$CONVERT,$i]=$(date -u -d "0 $exStartTime sec - $convertStartTime sec" +%S%N | sed 's/^0*//')
    
    endAll=$(echo "$OUT" | grep "End Executing SQL"| cut -d ' ' -f2 );
    endTime=$(date -u -d "$endAll" +"%s.%N"); 
    CGQR[$EXECUTE,$i]=$(date -u -d "0 $endTime sec - $exStartTime sec" +%S%N | sed 's/^0*//')

    CGQR[$TOTAL,$i]=$(date -u -d "0 $endTime sec - $loadingSTime sec" +%S%N | sed 's/^0*//')
           
    CGQR[$TUPLES,$i]=$(echo "$OUT" | grep "Total number of Tuples"| cut -d ' ' -f1)
    
  else
  	CGQR[$LOAD,$i]="-1"
#     CGQR[$CONVERT,$i]="-1"
    CGQR[$REWRITE,$i]="-1"
    CGQR[$CONVERT,$i]="-1"
    CGQR[$EXECUTE,$i]="-1"
    CGQR[$TOTAL,$i]="-1"
    CGQR[$TUPLES,$i]="-1" 
  fi
  
  
  echo "Loading: $((${CGQR[$LOAD,$i]}/1000000)) milliseconds"
#   echo "GQR: $((${CGQR[$CONVERT,$i]}/1000000)) milliseconds"
  echo "Rewriting: $((${CGQR[$REWRITE,$i]}/1000000)) milliseconds"
  echo "Converting: $((${CGQR[$CONVERT,$i]}/1000000)) milliseconds"
  echo "Executing: $((${CGQR[$EXECUTE,$i]}/1000000)) milliseconds"
  echo "Total Time : $((${CGQR[$TOTAL,$i]}/1000000)) milliseconds"
  echo "# of tuples: ${CGQR[$TUPLES,$i]}"  
done



echo "===== STChase ====="
mkdir -p ../experiments/outputs/bcastc/$BASE_DIR/LAV/rewritings
mkdir -p ../experiments/outputs/bcastc/$BASE_DIR/LAV/gqr
mkdir -p ../experiments/outputs/bcastc/$BASE_DIR/LAV/answer/$DATA_SIZE

for ((i=0;i<$NUM_TESTS;++i)); do
  START_TIME=$(date +%s%N)
  BCASTC[$TOTAL,$i]=$START_TIME 
  
  $JRE -jar ../utilityTools/RulewerkLongTGDs.jar -st-tgds ../$BASE_DIR/dependencies/lav.txt -t-tgds ../$BASE_DIR/dependencies/lav-t-tgds.txt -out ../$BASE_DIR/dependencies/longTGDs.rule
  
#   BCASTC[$PREPROCESS,$i]=$(($(date +%s%N) - $START_TIME))
  
  # START_TIME=$(date +%s%N)
  OUT=$(timeout $TIMEOUT java -jar ../systems/STChase/singleStep-1.08.jar -t-sql ../$BASE_DIR/schema/LAV/t-schema.sql -s-sch ../$BASE_DIR/schema/LAV/s-schema.txt -t-sch ../$BASE_DIR/schema/LAV/t-schema.txt -st-tgds ../$BASE_DIR/dependencies/longTGDs.rule -q ../$BASE_DIR/queries/Chasebench/Q$QUERY/Q$QUERY.txt -data ../$BASE_DIR/data/LAV/$DATA_SIZE)
  if [ $? -eq 0 ]; then
   BCASTC[$CHASE,$i]=$(($(date +%s%N) - $START_TIME))
   echo "$OUT" > ../experiments/outputs/bcastc/$BASE_DIR/LAV/answer/$DATA_SIZE/Q$QUERY.txt
   BCASTC[$TUPLES,$i]=$(echo "$OUT" | grep "Count :" | cut -d':' -f2)
   BCASTC[$TOTAL,$i]=$(($(date +%s%N) - ${BCASTC[$TOTAL,$i]}))
  else
#    BCASTC[$PREPROCESS,$i]="-1"
   BCASTC[$TOTAL,$i]="-1"
   BCASTC[$CHASE,$i]="-1"
   BCASTC[$TUPLES,$i]="-1"
  fi
#   echo "Blocking: $((${BCASTC[$PREPROCESS,$i]}/1000000)) milliseconds"
  echo "Chasing: $((${BCASTC[$CHASE,$i]}/1000000)) milliseconds"
  echo "Time elapsed: $((${BCASTC[$TOTAL,$i]}/1000000)) milliseconds"
  echo "# of tuples: ${BCASTC[$TUPLES,$i]}"
done

echo "===== GQR ====="
mkdir -p ../experiments/outputs/gqr/$BASE_DIR/LAV/rewritings
mkdir -p ../experiments/outputs/gqr/$BASE_DIR/LAV/gqr
mkdir -p ../experiments/outputs/gqr/$BASE_DIR/LAV/answer/$DATA_SIZE

for ((i=0;i<$NUM_TESTS;++i)); do
  START_TIME=$(date +%s%N)
  GQR[$TOTAL,$i]=$START_TIME
  #  $JRE -jar ./../systems/chasestepper/chasestepper-1.01.jar ../$BASE_DIR/dependencies/oneToOne-st-tgds.txt ../$BASE_DIR/dependencies/oneToOne-t-tgds.txt ../$BASE_DIR/queries/Chasebench/Q$QUERY/Q$QUERY.txt > /dev/null
  #  mv ../$BASE_DIR/queries/Chasebench/Q$QUERY/Q$QUERY-tgds.rule ../experiments/outputs/bcagqr/$BASE_DIR/chased-mapping

  $JRE -jar ../utilityTools/RulewerkLongTGDs.jar -st-tgds ../$BASE_DIR/dependencies/lav.txt -t-tgds ../$BASE_DIR/dependencies/lav-t-tgds.txt -out ../$BASE_DIR/dependencies/longTGDs.rule
 
  GQR[$CHASE,$i]=$(($(date +%s%N) - $START_TIME))
  START_TIME=$(date +%s%N)
 
  OUT=$($JRE -jar ../systems/GQR/GQR.jar -st-tgds ../$BASE_DIR/dependencies/longTGDs.rule -q ../$BASE_DIR/queries/Chasebench/Q$QUERY/Q$QUERY.txt)
   
    echo "$OUT"
  GQR[$REWRITE,$i]=$(($(date +%s%N) - $START_TIME))
  nulls=$(echo "$OUT" | grep -c "rewNo:null")
  if [ "$nulls" = "0" ]; then 
    rw=$(echo "$OUT"|  awk '/Start Rewriting/{flag=1;next}/End Rewriting/{flag=0}flag' )
   
    echo "$rw" > ../experiments/outputs/gqr/$BASE_DIR/LAV/rewritings/Q$QUERY-rewriting.txt
    SQL=$(echo "$OUT"| grep "SELECT")
    echo "$SQL" > ../experiments/outputs/gqr/$BASE_DIR/LAV/rewritings/Q$QUERY-SQL.txt
    GQR[$SIZE,$i]=$(echo "UNION $SQL" |grep -o -i "UNION" | wc -l)
    
#     GQR[$CONVERT,$i]=$(echo "$OUT"| grep "Converting Time: " | cut -d':' -f 2)
	#GQR[$CONVERT,$i]=$((${GQR[$CONVERT,$i]}*1000000))
    printf 'SELECT COUNT(*) FROM (%s) AS query;\n' "${SQL%?}" >../$BASE_DIR/queries/statements.sql
    START_TIME=$(date +%s%N)
    GQR[$TUPLES,$i]=$(psql -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -d "$PGDATABASE" -f ../$BASE_DIR/queries/statements.sql | grep '-' -A1 | grep -v '-' )
#     GQR[$TUPLES,$i]=$(psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -c "SELECT COUNT(*) FROM (${SQL%?}) AS query;" | grep '-' -A1 | grep -v '-')
	GQR[$EXECUTE,$i]=$(($(date +%s%N) - $START_TIME))
    echo ${GQR[$TUPLES,$i]} > ../experiments/outputs/gqr/$BASE_DIR/LAV/answer/$DATA_SIZE/Q$QUERY.txt
    GQR[$TOTAL,$i]=$(($(date +%s%N) - ${GQR[$TOTAL,$i]}))
  else
   #  GQR[$REWRITE,$i]="-1"
#     GQR[$CHASE,$i]="-1"
#     GQR[$CONVERT,$i]="-1"
    GQR[$SIZE,$i]="-1"
    GQR[$TUPLES,$i]="-1"
    GQR[$EXECUTE,$i]="-1"
#     GQR[$TOTAL,$i]="-1"
  fi
   echo "Size: ${GQR[$SIZE,$i]}"
  echo "Chasing: $((${GQR[$CHASE,$i]}/1000000)) milliseconds"
  echo "Rewriting: $((${GQR[$REWRITE,$i]}/1000000)) milliseconds"
#   echo "Converting: $((${GQR[$CONVERT,$i]})) milliseconds"
  echo "Executing: $((${GQR[$EXECUTE,$i]}/1000000)) milliseconds"
  echo "# of tuples: ${GQR[$TUPLES,$i]}"
  echo "Time elapsed: $((${GQR[$TOTAL,$i]}/1000000)) milliseconds"
done

# echo "===== BCA GQR ====="
# mkdir -p ../experiments/outputs/bcagqr/$BASE_DIR/chased-mapping
# mkdir -p ../experiments/outputs/bcagqr/$BASE_DIR/LAV/rewritings
# mkdir -p ../experiments/outputs/bcagqr/$BASE_DIR/LAV/answer/$DATA_SIZE
# for ((i=0;i<$NUM_TESTS;++i)); do
#   START_TIME=$(date +%s%N)
#   BCAGQR[$TOTAL,$i]=$START_TIME
#  #  $JRE -jar ../systems/chasestepper/chasestepper-1.01.jar ../$BASE_DIR/dependencies/st-tgds.txt ../$BASE_DIR/dependencies/t-tgds.txt ../$BASE_DIR/queries/Chasebench/Q$QUERY/Q$QUERY.txt > /dev/null
# #   mv ../$BASE_DIR/queries/Chasebench/Q$QUERY/Q$QUERY-tgds.rule ../experiments/outputs/bcagqr/$BASE_DIR/chased-mapping
# #   BCAGQR[$BLOCK,$i]=$(($(date +%s%N) - $START_TIME))
#   START_TIME=$(date +%s%N)
# #   OUT=$($JRE -jar ../systems/GQR/GQR-v1.08.jar -v ../$BASE_DIR/dependencies/st-tgds2.txt -q ../$BASE_DIR/queries/Chasebench/Q$QUERY/Q$QUERY.txt -d ../$BASE_DIR/dependencies/ChaseGQR/db.properties)
#   OUT=$($JRE -jar ../systems/GQR/GQR-v1.08.jar -v ../$BASE_DIR/dependencies/st-tgds3.txt -q ../$BASE_DIR/queries/Chasebench/Q$QUERY/Q$QUERY.txt -d ../$BASE_DIR/dependencies/ChaseGQR/db.properties)
#   BCAGQR[$CONVERT,$i]=$(($(date +%s%N) - $START_TIME))
#   nulls=$(echo "$OUT" | grep -c "rewNo:null")
#   if [ "$nulls" = "0" ]; then 
#     SQL=$(echo "$OUT"| grep "SELECT")
#     echo "$SQL" > ../experiments/outputs/bcagqr/$BASE_DIR/LAV/rewritings/Q$QUERY-rewriting.txt
#     BCAGQR[$SIZE,$i]=$(echo "UNION $SQL" |grep -o -i "UNION" | wc -l)
#     START_TIME=$(date +%s%N)
#     BCAGQR[$TUPLES,$i]=$(psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -c "SELECT COUNT(*) FROM (${SQL%?}) AS query;" | grep '-' -A1 | grep -v '-')
#     echo ${BCAGQR[$TUPLES,$i]} > ../experiments/outputs/bcagqr/$BASE_DIR/LAV/answer/$DATA_SIZE/Q$QUERY.txt
#     BCAGQR[$EXECUTE,$i]=$(($(date +%s%N) - $START_TIME))
#     BCAGQR[$TOTAL,$i]=$(($(date +%s%N) - ${BCAGQR[$TOTAL,$i]}))
#     BCAGQR[$BLOCK,$i]=$CREATETGDSTIME
#   else
#     BCAGQR[$CONVERT,$i]="-1"
#     BCAGQR[$BLOCK,$i]="-1"
#     BCAGQR[$SIZE,$i]="-1"
#     BCAGQR[$TUPLES,$i]="-1"
#     BCAGQR[$EXECUTE,$i]="-1"
#     BCAGQR[$TOTAL,$i]="-1"
#   fi
#   
#   
#   echo "Blocking: $((${BCAGQR[$BLOCK,$i]}/1000000)) milliseconds"
#   echo "GQR Rewriting: $((${BCAGQR[$CONVERT,$i]}/1000000)) milliseconds"
#   echo "Size: ${BCAGQR[$SIZE,$i]}"
#   echo "Executing: $((${BCAGQR[$EXECUTE,$i]}/1000000)) milliseconds"
#   echo "Time elapsed: $((${BCAGQR[$TOTAL,$i]}/1000000)) milliseconds"
#   echo "# of tuples: ${BCAGQR[$TUPLES,$i]}"
#   
# done

# echo "===== BCA STChase ====="
# mkdir -p ../experiments/outputs/bcastc/$BASE_DIR/chased-mapping
# mkdir -p ../experiments/outputs/bcastc/$BASE_DIR/LAV/answer/$DATA_SIZE
# for ((i=0;i<$NUM_TESTS;++i)); do
#   START_TIME=$(date +%s%N)
#   BCASTC[$TOTAL,$i]=$START_TIME 
#  #  $JRE -jar ../systems/chasestepper/chasestepper-1.01.jar ../$BASE_DIR/dependencies/st-tgds.txt ../$BASE_DIR/dependencies/t-tgds.txt ../$BASE_DIR/queries/Chasebench/Q$QUERY/Q$QUERY.txt > /dev/null
# #   mv ../$BASE_DIR/queries/Chasebench/Q$QUERY/Q$QUERY-tgds.rule ../experiments/outputs/bcastc/$BASE_DIR/chased-mapping
# #   BCASTC[$BLOCK,$i]=$(($(date +%s%N) - $START_TIME))
#   START_TIME=$(date +%s%N)
#   OUT=$(timeout $TIMEOUT java -jar ./../utilityTools/singleStep-1.08.jar -t-sql ../$BASE_DIR/schema/LAV/t-schema.sql -s-sch ../$BASE_DIR/schema/LAV/s-schema.txt -t-sch ../$BASE_DIR/schema/LAV/t-schema.txt -st-tgds ../experiments/outputs/bcastc/$BASE_DIR/chased-mapping/Q$QUERY-tgds.rule -q ../$BASE_DIR/queries/Chasebench/Q$QUERY/Q$QUERY.txt -data ../$BASE_DIR/data/LAV/$DATA_SIZE)
#   if [ $? -eq 0 ]; then
#    BCASTC[$TOTAL,$i]=$(($(date +%s%N) - ${BCASTC[$TOTAL,$i]}))
#    BCASTC[$CHASE,$i]=$(($(date +%s%N) - $START_TIME))
#    echo "$OUT" > ../experiments/outputs/bcastc/$BASE_DIR/LAV/answer/$DATA_SIZE/Q$QUERY.txt
#    BCASTC[$TUPLES,$i]=$(echo "$OUT" | grep "Count :" | cut -d':' -f2)
#   else
#    BCASTC[$BLOCK,$i]="-1"
#    BCASTC[$TOTAL,$i]="-1"
#    BCASTC[$CHASE,$i]="-1"
#    BCASTC[$TUPLES,$i]="-1"
#   fi
#   echo "Blocking: $((${BCASTC[$BLOCK,$i]}/1000000)) milliseconds"
#   echo "Chasing: $((${BCASTC[$CHASE,$i]}/1000000)) milliseconds"
#   echo "Time elapsed: $((${BCASTC[$TOTAL,$i]}/1000000)) milliseconds"
#   echo "# of tuples: ${BCASTC[$TUPLES,$i]}"
# done

echo "===== Rulewerk Original ====="
mkdir -p ../experiments/outputs/rulewerk/$BASE_DIR/LAV/rewritings
mkdir -p ../experiments/outputs/rulewerk/$BASE_DIR/LAV/answer/$DATA_SIZE
# write the query as a rule in rls file
queryString=$(<../$BASE_DIR/queries/iqaros/Q$QUERY.txt)
queryString=${queryString//-}
queryString=${queryString//_}
queryString=${queryString//\?0/?X}
queryString=${queryString//\?1/?Y}
queryString=${queryString//\?2/?X1}
queryString=${queryString//\?3/?Y1}
queryString=${queryString//\?4/?Y2}
queryString=${queryString//\?5/?Y3}
queryString=${queryString//Q(/Q$QUERY(}
old="<"
newreplace=":-"
queryString="${queryString//$old/$newreplace} ."
echo "$queryString"
# check if the rule is already exists or not
if [[ $(grep -L "Q$QUERY(" ../$BASE_DIR/rulewerkfiles/LAV/$DATA_SIZE/rule.rls) ]]; then   
  echo "$queryString" >> ../$BASE_DIR/rulewerkfiles/LAV/$DATA_SIZE/rule.rls
else
	pattern=$(echo "Q$QUERY(")
	sed -i "/$pattern/d" ../$BASE_DIR/rulewerkfiles/LAV/$DATA_SIZE/rule.rls
	 echo "$queryString" >> ../$BASE_DIR/rulewerkfiles/LAV/$DATA_SIZE/rule.rls
fi

# start testing
for ((i=0;i<$NUM_TESTS;++i)); do
  START_TIME=$(date +%s%N)
  RULEWERK[$TOTAL,$i]=$START_TIME
  q=$(echo $queryString| cut -d':' -f 1)
  ulimit -c unlimited
 rulewerkOutput=$(timeout $TIMEOUT java -jar ../systems/rulewerk/RulewerkDebug.jar materialize --rule-file=../$BASE_DIR/rulewerkfiles/LAV/$DATA_SIZE/rule.rls --query=$q )
  echo "$rulewerkOutput"
  if [ $? -eq 0 ]; then
    RULEWERK[$TOTAL,$i]=$(($(date +%s%N) - $START_TIME))
  
    loadingStart=$(echo "$rulewerkOutput" | grep "Started loading knowledge base"| cut -d ' ' -f2 );
    loadingSTime=$(date -u -d "$loadingStart" +"%s.%N"); 
    loadingEnd=$(echo "$rulewerkOutput" | grep "Finished loading knowledge base"| cut -d ' ' -f2 );
    loadingETime=$(date -u -d "$loadingEnd" +"%s.%N"); 
    RULEWERK[$LOAD,$i]=$(date -u -d "0 $loadingETime sec - $loadingSTime sec" +%S%N | sed 's/^0*//')

    chaseStart=$(echo "$rulewerkOutput" | grep "Started materialisation of inferences"| cut -d ' ' -f2  );
    chaseSTime=$(date -u -d "$chaseStart" +"%s.%N"); 
    chaseEnd=$(echo "$rulewerkOutput" | grep "Completed materialisation of inferences"| cut -d ' ' -f2  );
    chaseETime=$(date -u -d "$chaseEnd" +"%s.%N"); 
    RULEWERK[$CHASE,$i]=$(date -u -d "0 $chaseETime sec - $chaseSTime sec" +%S%N | sed 's/^0*//')
    
    exEnd=$(echo "$rulewerkOutput" | grep "Finished Answering queries"| cut -d ' ' -f2 );
    exETime=$(date -u -d "$exEnd" +"%s.%N"); 
    RULEWERK[$EXECUTE,$i]=$(date -u -d "0 $exETime sec - $chaseETime sec" +%S%N | sed 's/^0*//')
        
    RULEWERK[$TUPLES,$i]=$(echo "$rulewerkOutput" | grep "Number of query answers"| cut -d ':' -f2)
    
  else 
    RULEWERK[$TOTAL,$i]="-1"
    RULEWERK[$LOAD,$i]="-1"
    RULEWERK[$CHASE,$i]="-1"
    RULEWERK[$EXECUTE,$i]="-1"
    RULEWERK[$TUPLES,$i]="-1"
  fi
  
  echo "Chasing: $((${RULEWERK[$CHASE,$i]}/1000000)) milliseconds"
  echo "Loading: $((${RULEWERK[$LOAD,$i]}/1000000)) milliseconds"
  echo "Executing: $((${RULEWERK[$EXECUTE,$i]}/1000000)) milliseconds"
  echo "Time elapsed: $((${RULEWERK[$TOTAL,$i]}/1000000)) milliseconds"
  echo "# of tuples: ${RULEWERK[$TUPLES,$i]}" 
  echo "QUery is : $QUERY"
done



# echo "===== Rulewerk with long st-tgds====="
# mkdir -p ../experiments/outputs/rulewerk/$BASE_DIR/LAV/rewritings
# mkdir -p ../experiments/outputs/rulewerk/$BASE_DIR/LAV/answer/$DATA_SIZE
# # write the query as a rule in rls file
# queryString=$(<../$BASE_DIR/queries/iqaros/Q$QUERY.txt)
# queryString=${queryString//-}
# queryString=${queryString//_}
# queryString=${queryString//\?0/?X}
# queryString=${queryString//\?1/?Y}
# queryString=${queryString//\?2/?X1}
# queryString=${queryString//\?3/?Y1}
# queryString=${queryString//\?4/?Y2}
# queryString=${queryString//\?5/?Y3}
# queryString=${queryString//Q(/Q$QUERY(}
# old="<"
# newreplace=":-"
# queryString="${queryString//$old/$newreplace} ."
# echo "$queryString"
#  
#  START_TIME=$(date +%s%N)
# # ===== Generating long st-TGDS 
#   $JRE -jar ../utilityTools/RulewerkLongTGDs.jar -st-tgds ../$BASE_DIR/dependencies/lav.txt -t-tgds ../$BASE_DIR/dependencies/lav-t-tgds.txt -out ../$BASE_DIR/dependencies/longTGDs.rule
# CREATETGDSTIME=$(($(date +%s%N) - $START_TIME))
# # ===== converting the long st-TGDS  to RLS
# touch ../$BASE_DIR/dependencies/temp-t-tgds.txt
#   $JRE -jar ../utilityTools/TGDsToRlsConverter.jar -st-tgds "../$BASE_DIR/dependencies/longTGDs.rule" -t-tgds "../$BASE_DIR/dependencies/temp-t-tgds.txt" -out "../$BASE_DIR/rulewerkfiles/LAV/$DATA_SIZE/longTGD" -data "../$BASE_DIR/data/LAV/$DATA_SIZE"
# rm ../$BASE_DIR/dependencies/temp-t-tgds.txt
# 
# 
# 
# # check if the rule is already exists or not
# if [[ $(grep -L "Q$QUERY(" ../$BASE_DIR/rulewerkfiles/LAV/$DATA_SIZE/longTGD/rule.rls) ]]; then   
#   echo "$queryString" >> ../$BASE_DIR/rulewerkfiles/LAV/$DATA_SIZE/longTGD/rule.rls
# else
# 	pattern=$(echo "Q$QUERY(")
# 	sed -i "/$pattern/d" ../$BASE_DIR/rulewerkfiles/LAV/$DATA_SIZE/longTGD/rule.rls
# 	 echo "$queryString" >> ../$BASE_DIR/rulewerkfiles/LAV/$DATA_SIZE/longTGD/rule.rls
# fi
# 
# # start testing
# for ((i=0;i<$NUM_TESTS;++i)); do
#   START_TIME=$(date +%s%N)
#   RULEWERK1[$TOTAL,$i]=$START_TIME
#   q=$(echo $queryString| cut -d':' -f 1)
#   ulimit -c unlimited
#  rulewerkOutput=$(timeout $TIMEOUT java -jar ../systems/rulewerk/RulewerkDebug.jar materialize --rule-file=../$BASE_DIR/rulewerkfiles/LAV/$DATA_SIZE/longTGD/rule.rls --query=$q )
#   echo "$rulewerkOutput"
#   if [ $? -eq 0 ]; then
#     RULEWERK1[$TOTAL,$i]=$(($(date +%s%N) - $START_TIME))
#   
#     loadingStart=$(echo "$rulewerkOutput" | grep "Started loading knowledge base"| cut -d ' ' -f2 );
#     loadingSTime=$(date -u -d "$loadingStart" +"%s.%N"); 
#     loadingEnd=$(echo "$rulewerkOutput" | grep "Finished loading knowledge base"| cut -d ' ' -f2 );
#     loadingETime=$(date -u -d "$loadingEnd" +"%s.%N"); 
#     RULEWERK1[$LOAD,$i]=$(date -u -d "0 $loadingETime sec - $loadingSTime sec" +%S%N | sed 's/^0*//')
# 
#     chaseStart=$(echo "$rulewerkOutput" | grep "Started materialisation of inferences"| cut -d ' ' -f2  );
#     chaseSTime=$(date -u -d "$chaseStart" +"%s.%N"); 
#     chaseEnd=$(echo "$rulewerkOutput" | grep "Completed materialisation of inferences"| cut -d ' ' -f2  );
#     chaseETime=$(date -u -d "$chaseEnd" +"%s.%N"); 
#     RULEWERK1[$CHASE,$i]=$(date -u -d "0 $chaseETime sec - $chaseSTime sec" +%S%N | sed 's/^0*//')
# #     RulewerkChase=$(date -u -d "0 $chaseETime sec - $chaseSTime sec" +%S%N | sed 's/^0*//')
# # 	RULEWERK1[$CHASE,$i]=$(date -u -d "0 $CREATETGDSTIME sec + $RulewerkChase sec" +%S%N | sed 's/^0*//')
#    #  echo "$RulewerkChase"
# #     echo "$CREATETGDSTIME"
# #     echo "${RULEWERK1[$CHASE,$i]}"
# 
#     exEnd=$(echo "$rulewerkOutput" | grep "Finished Answering queries"| cut -d ' ' -f2 );
#     exETime=$(date -u -d "$exEnd" +"%s.%N"); 
#     RULEWERK1[$EXECUTE,$i]=$(date -u -d "0 $exETime sec - $chaseETime sec" +%S%N | sed 's/^0*//')
#         
#     RULEWERK1[$TUPLES,$i]=$(echo "$rulewerkOutput" | grep "Number of query answers"| cut -d ':' -f2)
#     RULEWERK1[$PREPROCESS,$i]=$CREATETGDSTIME
#   else 
#     RULEWERK1[$TOTAL,$i]="-1"
#     RULEWERK1[$LOAD,$i]="-1"
#     RULEWERK1[$CHASE,$i]="-1"
#     RULEWERK1[$EXECUTE,$i]="-1"
#     RULEWERK1[$TUPLES,$i]="-1"
#     RULEWERK1[$PREPROCESS,$i]="-1"
#   fi
#   echo "Pre-process: $((${RULEWERK1[$PREPROCESS,$i]}/1000000)) milliseconds"
#   echo "Chasing: $((${RULEWERK1[$CHASE,$i]}/1000000)) milliseconds"
#   echo "Loading: $((${RULEWERK1[$LOAD,$i]}/1000000)) milliseconds"
#   echo "Executing: $((${RULEWERK1[$EXECUTE,$i]}/1000000)) milliseconds"
#   echo "Time elapsed: $((${RULEWERK1[$TOTAL,$i]}/1000000)) milliseconds"
#   echo "# of tuples: ${RULEWERK1[$TUPLES,$i]}" 
#   echo "QUery is : $QUERY"
# done

# 
# 
# echo "===== Rulewerk with long st-tgds====="
# mkdir -p ../experiments/outputs/rulewerk/$BASE_DIR/LAV/rewritings
# mkdir -p ../experiments/outputs/rulewerk/$BASE_DIR/LAV/answer/$DATA_SIZE
# # write the query as a rule in rls file
# queryString=$(<../$BASE_DIR/queries/iqaros/Q$QUERY.txt)
# queryString=${queryString//-}
# queryString=${queryString//_}
# queryString=${queryString//\?0/?X}
# queryString=${queryString//\?1/?Y}
# queryString=${queryString//\?2/?X1}
# queryString=${queryString//\?3/?Y1}
# queryString=${queryString//\?4/?Y2}
# queryString=${queryString//\?5/?Y3}
# queryString=${queryString//Q(/Q$QUERY(}
# old="<"
# newreplace=":-"
# queryString="${queryString//$old/$newreplace} ."
# echo "$queryString"
# # check if the rule is already exists or not
# if [[ $(grep -L "Q$QUERY(" ../$BASE_DIR/rulewerkfiles/LAV/$DATA_SIZE/rule2.rls) ]]; then   
#   echo "$queryString" >> ../$BASE_DIR/rulewerkfiles/LAV/$DATA_SIZE/rule2.rls
# else
# 	pattern=$(echo "Q$QUERY(")
# 	sed -i "/$pattern/d" ../$BASE_DIR/rulewerkfiles/LAV/$DATA_SIZE/rule2.rls
# 	 echo "$queryString" >> ../$BASE_DIR/rulewerkfiles/LAV/$DATA_SIZE/rule2.rls
# fi
# 
# # start testing
# for ((i=0;i<$NUM_TESTS;++i)); do
#   START_TIME=$(date +%s%N)
#   RULEWERK1[$TOTAL,$i]=$START_TIME
#   q=$(echo $queryString| cut -d':' -f 1)
#   ulimit -c unlimited
#  rulewerkOutput=$(timeout $TIMEOUT java -jar ../systems/rulewerk/RulewerkDebug.jar materialize --rule-file=../$BASE_DIR/rulewerkfiles/LAV/$DATA_SIZE/rule3.rls --query=$q )
#   echo "$rulewerkOutput"
#   if [ $? -eq 0 ]; then
#     RULEWERK1[$TOTAL,$i]=$(($(date +%s%N) - $START_TIME))
#   
#     loadingStart=$(echo "$rulewerkOutput" | grep "Started loading knowledge base"| cut -d ' ' -f2 );
#     loadingSTime=$(date -u -d "$loadingStart" +"%s.%N"); 
#     loadingEnd=$(echo "$rulewerkOutput" | grep "Finished loading knowledge base"| cut -d ' ' -f2 );
#     loadingETime=$(date -u -d "$loadingEnd" +"%s.%N"); 
#     RULEWERK1[$LOAD,$i]=$(date -u -d "0 $loadingETime sec - $loadingSTime sec" +%S%N | sed 's/^0*//')
# 
#     chaseStart=$(echo "$rulewerkOutput" | grep "Started materialisation of inferences"| cut -d ' ' -f2  );
#     chaseSTime=$(date -u -d "$chaseStart" +"%s.%N"); 
#     chaseEnd=$(echo "$rulewerkOutput" | grep "Completed materialisation of inferences"| cut -d ' ' -f2  );
#     chaseETime=$(date -u -d "$chaseEnd" +"%s.%N"); 
#     RULEWERK1[$CHASE,$i]=$(date -u -d "0 $chaseETime sec - $chaseSTime sec" +%S%N | sed 's/^0*//')
#     
#     exEnd=$(echo "$rulewerkOutput" | grep "Finished Answering queries"| cut -d ' ' -f2 );
#     exETime=$(date -u -d "$exEnd" +"%s.%N"); 
#     RULEWERK1[$EXECUTE,$i]=$(date -u -d "0 $exETime sec - $chaseETime sec" +%S%N | sed 's/^0*//')
#         
#     RULEWERK1[$TUPLES,$i]=$(echo "$rulewerkOutput" | grep "Number of query answers"| cut -d ':' -f2)
#     RULEWERK1[$BLOCK,$i]=$CREATETGDSTIME
#   else 
#     RULEWERK1[$TOTAL,$i]="-1"
#     RULEWERK1[$LOAD,$i]="-1"
#     RULEWERK1[$CHASE,$i]="-1"
#     RULEWERK1[$EXECUTE,$i]="-1"
#     RULEWERK1[$TUPLES,$i]="-1"
#     RULEWERK1[$BLOCK,$i]="-1"
#   fi
#   echo "Blocking: $((${RULEWERK1[$BLOCK,$i]}/1000000)) milliseconds"
#   echo "Chasing: $((${RULEWERK1[$CHASE,$i]}/1000000)) milliseconds"
#   echo "Loading: $((${RULEWERK1[$LOAD,$i]}/1000000)) milliseconds"
#   echo "Executing: $((${RULEWERK1[$EXECUTE,$i]}/1000000)) milliseconds"
#   echo "Time elapsed: $((${RULEWERK1[$TOTAL,$i]}/1000000)) milliseconds"
#   echo "# of tuples: ${RULEWERK1[$TUPLES,$i]}" 
#   echo "QUery is : $QUERY"
# done
# 

## WRITE RESULTS
file=../experiments/$BASE_DIR/LAV/$DATA_SIZE/Q$QUERY/rapid.csv
if [ -f "$file" ]
then
	echo "Printed"
else
	echo "========================== Files =========================== "
	echo "rewrite,convert,execute,total,size,tuples" >> ../experiments/$BASE_DIR/LAV/$DATA_SIZE/Q$QUERY/rapid.csv
	echo "rewrite,convert,execute,total,size,tuples" >> ../experiments/$BASE_DIR/LAV/$DATA_SIZE/Q$QUERY/iqaros.csv
	echo "rewrite,convert,execute,total,size,tuples" >> ../experiments/$BASE_DIR/LAV/$DATA_SIZE/Q$QUERY/graal.csv
	echo "rewrite,convert,execute,total,size,tuples" >> ../experiments/$BASE_DIR/LAV/$DATA_SIZE/Q$QUERY/ontopR.csv
 	echo "chase,execute,loading,total,tuples" >> ../experiments/$BASE_DIR/LAV/$DATA_SIZE/Q$QUERY/rdfox.csv
	echo "chase,total,tuples" >> ../experiments/$BASE_DIR/LAV/$DATA_SIZE/Q$QUERY/STchase.csv
	echo "chase,rewrite,execute,total,size,tuples" >> ../experiments/$BASE_DIR/LAV/$DATA_SIZE/Q$QUERY/gqr.csv
# 	echo "rewrite,convert,execute,loading,total,tuples" >> ../experiments/$BASE_DIR/LAV/$DATA_SIZE/Q$QUERY/ontop.csv
	echo "loading,rewrite,convert,execute,total,tuples" >> ../experiments/$BASE_DIR/LAV/$DATA_SIZE/Q$QUERY/chaseGQR.csv
	echo "chase,execute,loading,total,tuples" >> ../experiments/$BASE_DIR/LAV/$DATA_SIZE/Q$QUERY/rulewerk.csv
# 	echo "preprocess,chase,execute,loading,total,tuples" >> ../experiments/$BASE_DIR/LAV/$DATA_SIZE/Q$QUERY/rulewerkLonger.csv

fi

for ((i=1;i<$NUM_TESTS;++i)); do
 
 echo "${RAPID[$REWRITE,$i]},${RAPID[$CONVERT,$i]},${RAPID[$EXECUTE,$i]},${RAPID[$TOTAL,$i]},${RAPID[$SIZE,$i]},${RAPID[$TUPLES,$i]}" >> ../experiments/$BASE_DIR/LAV/$DATA_SIZE/Q$QUERY/rapid.csv
 echo "${IQAROS[$REWRITE,$i]},${IQAROS[$CONVERT,$i]},${IQAROS[$EXECUTE,$i]},${IQAROS[$TOTAL,$i]},${IQAROS[$SIZE,$i]},${IQAROS[$TUPLES,$i]}" >> ../experiments/$BASE_DIR/LAV/$DATA_SIZE/Q$QUERY/iqaros.csv
 echo "${GRAAL[$REWRITE,$i]},${GRAAL[$CONVERT,$i]},${GRAAL[$EXECUTE,$i]},${GRAAL[$TOTAL,$i]},${GRAAL[$SIZE,$i]},${GRAAL[$TUPLES,$i]}" >> ../experiments/$BASE_DIR/LAV/$DATA_SIZE/Q$QUERY/graal.csv
 echo "${ONTOPRW[$REWRITE,$i]},${ONTOPRW[$CONVERT,$i]},${ONTOPRW[$EXECUTE,$i]},${ONTOPRW[$TOTAL,$i]},${ONTOPRW[$SIZE,$i]},${ONTOPRW[$TUPLES,$i]}" >> ../experiments/$BASE_DIR/LAV/$DATA_SIZE/Q$QUERY/ontopR.csv
 echo "${RDFOX[$CHASE,$i]},${RDFOX[$EXECUTE,$i]},${RDFOX[$LOAD,$i]},${RDFOX[$TOTAL,$i]},${RDFOX[$TUPLES,$i]}" >> ../experiments/$BASE_DIR/LAV/$DATA_SIZE/Q$QUERY/rdfox.csv
 echo "${GQR[$CHASE,$i]},${GQR[$REWRITE,$i]},${GQR[$EXECUTE,$i]},${GQR[$TOTAL,$i]},${GQR[$SIZE,$i]},${GQR[$TUPLES,$i]}" >> ../experiments/$BASE_DIR/LAV/$DATA_SIZE/Q$QUERY/gqr.csv
 echo "${CGQR[$LOAD,$i]},${CGQR[$REWRITE,$i]},${CGQR[$CONVERT,$i]},${CGQR[$EXECUTE,$i]},${CGQR[$TOTAL,$i]},${CGQR[$TUPLES,$i]}" >> ../experiments/$BASE_DIR/LAV/$DATA_SIZE/Q$QUERY/chaseGQR.csv
#  echo "${ONTOP[$REWRITE,$i]},${ONTOP[$CONVERT,$i]},${ONTOP[$EXECUTE,$i]},${ONTOP[$LOAD,$i]},${ONTOP[$TOTAL,$i]},${ONTOP[$TUPLES,$i]}" >> ../experiments/$BASE_DIR/LAV/$DATA_SIZE/Q$QUERY/ontop.csv
 echo "${BCASTC[$CHASE,$i]},${BCASTC[$TOTAL,$i]},${BCASTC[$TUPLES,$i]}" >> ../experiments/$BASE_DIR/LAV/$DATA_SIZE/Q$QUERY/STchase.csv
 echo "${RULEWERK[$CHASE,$i]},${RULEWERK[$EXECUTE,$i]},${RULEWERK[$LOAD,$i]},${RULEWERK[$TOTAL,$i]},${RULEWERK[$TUPLES,$i]}" >> ../experiments/$BASE_DIR/LAV/$DATA_SIZE/Q$QUERY/rulewerk.csv
#  echo "${RULEWERK1[$PREPROCESS,$i]},${RULEWERK1[$CHASE,$i]},${RULEWERK1[$EXECUTE,$i]},${RULEWERK1[$LOAD,$i]},${RULEWERK1[$TOTAL,$i]},${RULEWERK1[$TUPLES,$i]}" >> ../experiments/$BASE_DIR/LAV/$DATA_SIZE/Q$QUERY/rulewerkLonger.csv
done