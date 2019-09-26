#!/bin/bash

#PATH=$(npm bin):$PATH

## SETUP
NUM_TESTS=1
TIMEOUT=1800
BASE_DIR=$1
QUERY=$2
DATA_SIZE=$3
JRE=~/.sdkman/candidates/java/8.0.201-oracle/bin/java

mkdir -p experiments/$BASE_DIR/$DATA_SIZE/Q$QUERY
mkdir -p outputs/$BASE_DIR/$DATA_SIZE/Q$QUERY

# Read database config file
source <(grep = $BASE_DIR/postgres-config.ini)
export PGPASSWORD

##Enums for the recording results
REWRITE=0
CONVERT=1
EXECUTE=2
SIZE=3
TUPLES=4
CHASE=5
BLOCK=6
LOAD=7
TOTAL=8

# Set up result arrays
declare -A RAPID
declare -A IQAROS
declare -A GRAAL
declare -A ONTOP
declare -A ONTOPRW
declare -A BCAGQR
declare -A BCASTC
declare -A RDFOX

echo "===== RAPID ====="
mkdir -p outputs/rapid/$BASE_DIR/rewritings
mkdir -p outputs/rapid/$BASE_DIR/answer/$DATA_SIZE
for ((i=0;i<$NUM_TESTS;++i)); do
  START_TIME=$(date +%s%N)
  RAPID[$TOTAL,$i]=$START_TIME
  rapidOutput=$($JRE -jar tools/rapid/Rapid2.jar DU SHORT $BASE_DIR/owl/ontology.owl $BASE_DIR/queries/iqaros/Q$QUERY.txt 2> /dev/null | grep -G '^Q' | grep 'io_' -v | grep -v 'AUX')
  RAPID[$REWRITE,$i]=$(($(date +%s%N) - $START_TIME))
  echo "$rapidOutput" > outputs/rapid/$BASE_DIR/rewritings/Q$QUERY-rewriting.txt
  RAPID[$SIZE,$i]=$(echo "$rapidOutput" | grep -c "<-")
  echo "Rewriting: $((${RAPID[$REWRITE,$i]}/1000000)) milliseconds, Size: ${RAPID[$SIZE,$i]}"

  START_TIME=$(date +%s%N)
  rapidCB=$(echo "$rapidOutput" | sed 's/$/ ./g')
  SQL=$(java -jar tools/obdabenchmarkingtools/sqlConvert-1.08.jar "$rapidCB" --src)
  #SQL=$(obdaconvert ucq "$RAPID" $BASE_DIR/schema/t-schema.txt rapid --string --src)
  
  RAPID[$CONVERT,$i]=$(($(date +%s%N) - $START_TIME))
  echo "Converting: $((${RAPID[$CONVERT,$i]}/1000000)) milliseconds"
  START_TIME=$(date +%s%N)
  RAPID[$TUPLES,$i]=$(psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -c "SELECT COUNT(*) FROM (${SQL%?}) AS query;" | grep '-' -A1 | grep -v '-')
  echo ${RAPID[$TUPLES,$i]} > outputs/rapid/$BASE_DIR/answer/$DATA_SIZE/Q$QUERY.txt
  RAPID[$EXECUTE,$i]=$(($(date +%s%N) - $START_TIME))
  RAPID[$TOTAL,$i]=$(($(date +%s%N) - ${RAPID[$TOTAL,$i]}))
  echo "Executing: $((${RAPID[$EXECUTE,$i]}/1000000)) milliseconds"
  echo "# of tuples: ${RAPID[$TUPLES,$i]}"
done

echo "===== IQAROS ====="
mkdir -p outputs/iqaros/$BASE_DIR/rewritings
mkdir -p outputs/iqaros/$BASE_DIR/answer/$DATA_SIZE
for ((i=0;i<$NUM_TESTS;++i)); do
  START_TIME=$(date +%s%N)
  IQAROS[$TOTAL,$i]=$START_TIME 
  iqarosOutput=$($JRE -jar tools/iqaros/iqaros.jar $BASE_DIR/owl/ontology.owl $BASE_DIR/queries/iqaros/Q$QUERY.txt 2> /dev/null | grep -G '^Q' | grep 'io_' -v)
  IQAROS[$REWRITE,$i]=$(($(date +%s%N) - $START_TIME))
  IQAROS[$SIZE,$i]=$(echo "$iqarosOutput" | grep -c "<-")
  echo "$iqarosOutput" > outputs/iqaros/$BASE_DIR/rewritings/Q$QUERY-rewriting.txt
  echo "Rewriting: $((${IQAROS[$REWRITE,$i]}/1000000)) milliseconds, Size: ${IQAROS[$SIZE,$i]}"
  
  iqCB=$(echo "$iqarosOutput" | sed 's/\^/,/g; s/$/ ./g; s/X/?X/g')

  START_TIME=$(date +%s%N)
  #SQL=$(obdaconvert ucq "$IQAROS" $BASE_DIR/schema/t-schema.txt iqaros --string --src)
  SQL=$(java -jar tools/obdabenchmarkingtools/sqlConvert-1.08.jar "$iqCB" --src)
  IQAROS[$CONVERT,$i]=$(($(date +%s%N) - $START_TIME))
  echo "Converting: $((${IQAROS[$CONVERT,$i]}/1000000)) milliseconds"

  START_TIME=$(date +%s%N)
  IQAROS[$TUPLES,$i]=$(psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -c "SELECT COUNT(*) FROM (${SQL%?}) AS query;" | grep '-' -A1 | grep -v '-')
  echo ${IQAROS[$TUPLES,$i]} > outputs/iqaros/$BASE_DIR/answer/$DATA_SIZE/Q$QUERY.txt
  IQAROS[$EXECUTE,$i]=$(($(date +%s%N) - $START_TIME))
  IQAROS[$TOTAL,$i]=$(($(date +%s%N) - ${IQAROS[$TOTAL,$i]}))
  echo "Executing: $((${IQAROS[$EXECUTE,$i]}/1000000)) milliseconds"
  echo "# of tuples: ${IQAROS[$TUPLES,$i]}"
done

echo "===== GRAAL ====="
mkdir -p outputs/graal/$BASE_DIR/rewritings
mkdir -p outputs/graal/$BASE_DIR/answer/$DATA_SIZE
for ((i=0;i<$NUM_TESTS;++i)); do
  START_TIME=$(date +%s%N)
  GRAAL[$TOTAL,$i]=$START_TIME
  graalOutput=$($JRE -jar tools/graal/obda-benchmark-graal-1.0-SNAPSHOT-spring-boot.jar $BASE_DIR/owl/ontology.owl $BASE_DIR/queries/SPARQL/Q$QUERY.rq 2> /dev/null | grep -G '^?' | grep 'io_' -v)
  GRAAL[$REWRITE,$i]=$(($(date +%s%N) - $START_TIME))
  GRAAL[$SIZE,$i]=$(echo "$graalOutput" | grep -c ":-")
  echo "$graalOutput" > outputs/graal/$BASE_DIR/rewritings/Q$QUERY-rewriting.txt
  echo "Rewriting: $((${GRAAL[$REWRITE,$i]}/1000000)) milliseconds, Size: ${GRAAL[$SIZE,$i]}"
  graalCB=$(echo "$graalOutput" | sed 's/?/Q/g; s/VAR_/?/g;s,<[a-zA-Z0-9\:\/~][^#]*#,,g; s/>//g; s/:-/<-/g')
  START_TIME=$(date +%s%N)
  #SQL=$(obdaconvert ucq "$GRAAL" $BASE_DIR/schema/t-schema.txt graal --string --src)
  SQL=$(java -jar tools/obdabenchmarkingtools/sqlConvert-1.08.jar "$graalCB" --src)
  GRAAL[$CONVERT,$i]=$(($(date +%s%N) - $START_TIME))
  echo "Converting: $((${GRAAL[$CONVERT,$i]}/1000000)) milliseconds"

  START_TIME=$(date +%s%N)
  GRAAL[$TUPLES,$i]=$(psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -c "SELECT COUNT(*) FROM (${SQL%?}) AS query;" | grep '-' -A1 | grep -v '-')
  echo ${GRAAL[$TUPLES,$i]} > outputs/graal/$BASE_DIR/answer/$DATA_SIZE/Q$QUERY.txt
  GRAAL[$EXECUTE,$i]=$(($(date +%s%N) - $START_TIME))
  GRAAL[$TOTAL,$i]=$(($(date +%s%N) - ${GRAAL[$TOTAL,$i]}))
  echo "Executing: $((${GRAAL[$EXECUTE,$i]}/1000000)) milliseconds"
  echo "# of tuples: ${GRAAL[$TUPLES,$i]}"
done

echo "===== RDFox ====="
mkdir -p outputs/rdfox/$BASE_DIR
for ((i=0;i<$NUM_TESTS;++i)); do
  START_TIME=$(date +%s%N)
  RDFOX[$TOTAL,$i]=$START_TIME
  OUT=$(timeout $TIMEOUT $JRE -jar tools/RDFox/chaseRDFox-linux.jar -chase standard -s-sch $BASE_DIR/schema/s-schema.txt -t-sch $BASE_DIR/schema/t-schema.txt -st-tgds $BASE_DIR/dependencies/st-tgds.txt -src $BASE_DIR/data/$DATA_SIZE -t-tgds $BASE_DIR/dependencies/t-tgds.txt -qdir $BASE_DIR/queries/Chasebench/Q$QUERY/)
  if [ $? -eq 0 ]; then
    RDFOX[$TOTAL,$i]=$(($(date +%s%N) - $START_TIME))
    RDFOX[$LOAD,$i]=$(echo "$OUT" | grep "Loading source instance data" | cut -d'.' -f4 | cut -d'm' -f1)
    RDFOX[$CHASE,$i]=$(echo "$OUT" | grep "Chase took"| cut -d 'm' -f 1 | cut -d 'k' -f 2)
    RDFOX[$EXECUTE,$i]=$(echo "$OUT" | grep "Total time" | cut -d ':' -f 2 | cut -d 'm' -f 1)
    RDFOX[$TUPLES,$i]=$(echo "$OUT" | grep "Query" -A1 | grep -v "Query" | cut -d ':' -f 2)
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

echo "===== BCA GQR ====="
mkdir -p outputs/bcagqr/$BASE_DIR/chased-mapping
mkdir -p outputs/bcagqr/$BASE_DIR/rewritings
mkdir -p outputs/bcagqr/$BASE_DIR/answer/$DATA_SIZE
for ((i=0;i<$NUM_TESTS;++i)); do
  START_TIME=$(date +%s%N)
  BCAGQR[$TOTAL,$i]=$START_TIME
  $JRE -jar ./tools/chasestepper/chasestepper-1.01.jar $BASE_DIR/dependencies/st-tgds.txt $BASE_DIR/dependencies/t-tgds.txt $BASE_DIR/queries/Chasebench/Q$QUERY/Q$QUERY.txt > /dev/null
  mv $BASE_DIR/queries/Chasebench/Q$QUERY/Q$QUERY-tgds.rule outputs/bcagqr/$BASE_DIR/chased-mapping
  BCAGQR[$BLOCK,$i]=$(($(date +%s%N) - $START_TIME))
  START_TIME=$(date +%s%N)
  OUT=$($JRE -jar ./tools/GQR/GQR.jar -st-tgds outputs/bcagqr/$BASE_DIR/chased-mapping/Q$QUERY-tgds.rule -q $BASE_DIR/queries/Chasebench/Q$QUERY/Q$QUERY.txt)
  BCAGQR[$REWRITE,$i]=$(($(date +%s%N) - $START_TIME))
  nulls=$(echo "$OUT" | grep -c "rewNo:null")
  if [ "$nulls" = "0" ]; then 
    SQL=$(echo "$OUT"| grep "SELECT")
    echo SQL > outputs/bcagqr/$BASE_DIR/rewritings/Q$QUERY-rewriting.txt
    BCAGQR[$SIZE,$i]=$(echo "UNION $SQL" |grep -o -i "UNION" | wc -l)
    START_TIME=$(date +%s%N)
    BCAGQR[$TUPLES,$i]=$(psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -c "SELECT COUNT(*) FROM (${SQL%?}) AS query;" | grep '-' -A1 | grep -v '-')
    echo ${BCAGQR[$TUPLES,$i]} > outputs/bcagqr/$BASE_DIR/answer/$DATA_SIZE/Q$QUERY.txt
    BCAGQR[$EXECUTE,$i]=$(($(date +%s%N) - $START_TIME))
    BCAGQR[$TOTAL,$i]=$(($(date +%s%N) - ${BCAGQR[$TOTAL,$i]}))
  else
    BCAGQR[$REWRITE,$i]="-1"
    BCAGQR[$BLOCK,$i]="-1"
    BCAGQR[$SIZE,$i]="-1"
    BCAGQR[$TUPLES,$i]="-1"
    BCAGQR[$EXECUTE,$i]="-1"
    BCAGQR[$TOTAL,$i]="-1"
  fi
  echo "Size: ${BCAGQR[$SIZE,$i]}"
  echo "# of tuples: ${BCAGQR[$TUPLES,$i]}"
  echo "Blocking: $((${BCAGQR[$BLOCK,$i]}/1000000)) milliseconds"
  echo "GQR: $((${BCAGQR[$REWRITE,$i]}/1000000)) milliseconds"
  echo "Executing: $((${BCAGQR[$EXECUTE,$i]}/1000000)) milliseconds"
  echo "Time elapsed: $((${BCAGQR[$TOTAL,$i]}/1000000)) milliseconds"
done

echo "===== ONTOP ====="
mkdir -p outputs/ontop/$BASE_DIR/log/$DATA_SIZE
for ((i=0;i<$NUM_TESTS;++i)); do
  START_TIME=$(date +%s%N)
  ONTOP[$TOTAL,$i]=$START_TIME
  ontopOutput=$(timeout $TIMEOUT ./tools/ontop/ontop query -t $BASE_DIR/owl/ontology.owl -q $BASE_DIR/queries/SPARQL/Q$QUERY.rq -m $BASE_DIR/ontop-files/mapping.obda -p $BASE_DIR/ontop-files/properties.txt)
  if [ $? -eq 0 ]; then
   echo "$ontopOutput" > outputs/ontop/$BASE_DIR/log/$DATA_SIZE/Q$QUERY-log.txt
   ONTOP[$TOTAL,$i]=$(($(date +%s%N) - ${ONTOP[$TOTAL,$i]}))
   loadStart=$(echo "$ontopOutput" | grep "Loaded OntologyID"  | cut -d'[' -f 1);
   loadSTime=$(date -u -d "$loadStart" +"%s.%N"); 
   loadEnd=$(echo "$ontopOutput" | grep "Ontop has completed the setup and it is ready for query answering"  | cut -d'[' -f 1);
   loadETime=$(date -u -d "$loadEnd" +"%s.%N");
   ONTOP[$LOAD,$i]=$(date -u -d "0 $loadETime sec - $loadSTime sec" +%S%N | sed 's/^0*//')

   rWStart=$(echo "$ontopOutput" | grep "Start the rewriting process"  | cut -d'[' -f 1);
   rWSTime=$(date -u -d "$rWStart" +"%s.%N"); 
   rWEnd=$(echo "$ontopOutput" | grep "New query after pulling out equalities"  | cut -d'[' -f 1);
   rWETime=$(date -u -d "$rWEnd" +"%s.%N");
   ONTOP[$REWRITE,$i]=$(date -u -d "0 $rWETime sec - $rWSTime sec" +%S%N | sed 's/^0*//')

   cStart=$(echo "$ontopOutput" | grep "Program normalized for SQL translation"  | cut -d'[' -f 1);
   cSTime=$(date -u -d "$cStart" +"%s.%N"); 
   cEnd=$(echo "$ontopOutput" | grep "Resulting native query:"  | cut -d'[' -f 1);
   cETime=$(date -u -d "$cEnd" +"%s.%N");
   ONTOP[$CONVERT,$i]=$(date -u -d "0 $cETime sec - $cSTime sec" +%S%N | sed 's/^0*//')

   eStart=$(echo "$ontopOutput" | grep "Executing the query and get the result..."  | cut -d'[' -f 1);
   eSTime=$(date -u -d "$eStart" +"%s.%N"); 
   eEnd=$(echo "$ontopOutput" | grep "Execution finished."  | cut -d'[' -f 1);
   eETime=$(date -u -d "$eEnd" +"%s.%N");
   ONTOP[$EXECUTE,$i]=$(date -u -d "0 $eETime sec - $eSTime sec" +%S%N | sed 's/^0*//')
   ONTOP[$TUPLES,$i]=$(echo "$ontopOutput" | sed -n '/Execution finished./,$p' | grep "<" | wc -l)
  else 
    ONTOP[$TOTAL,$i]="-1"
    ONTOP[$LOAD,$i]="-1"
    ONTOP[$REWRITE,$i]="-1"
    ONTOP[$CONVERT,$i]="-1"
    ONTOP[$EXECUTE,$i]="-1"
    ONTOP[$TUPLES,$i]="-1"
  fi
  

  echo "Loading: $((${ONTOP[$LOAD,$i]}/1000000)) milliseconds"
  echo "Rewriting: $((${ONTOP[$REWRITE,$i]}/1000000)) milliseconds"
  echo "Executing: $((${ONTOP[$EXECUTE,$i]}/1000000)) milliseconds"
  echo "Time elapsed: $((${ONTOP[$TOTAL,$i]}/1000000)) milliseconds"
  echo "# of tuples: ${ONTOP[$TUPLES,$i]}"
done


echo "===== BCA STChase ====="
mkdir -p outputs/bcastc/$BASE_DIR/chased-mapping
mkdir -p outputs/bcastc/$BASE_DIR/answer/$DATA_SIZE
for ((i=0;i<$NUM_TESTS;++i)); do
  START_TIME=$(date +%s%N)
  BCASTC[$TOTAL,$i]=$START_TIME 
  $JRE -jar ./tools/chasestepper/chasestepper-1.01.jar $BASE_DIR/dependencies/st-tgds.txt $BASE_DIR/dependencies/t-tgds.txt $BASE_DIR/queries/Chasebench/Q$QUERY/Q$QUERY.txt > /dev/null
  mv $BASE_DIR/queries/Chasebench/Q$QUERY/Q$QUERY-tgds.rule outputs/bcastc/$BASE_DIR/chased-mapping
  BCASTC[$BLOCK,$i]=$(($(date +%s%N) - $START_TIME))
  START_TIME=$(date +%s%N)
  OUT=$(timeout $TIMEOUT java -jar ./tools/obdabenchmarkingtools/singleStep-1.08.jar -t-sql $BASE_DIR/schema/t-schema.sql -s-sch $BASE_DIR/schema/s-schema.txt -t-sch $BASE_DIR/schema/t-schema.txt -st-tgds outputs/bcastc/$BASE_DIR/chased-mapping/Q$QUERY-tgds.rule -q $BASE_DIR/queries/Chasebench/Q$QUERY/Q$QUERY.txt -data $BASE_DIR/data/$DATA_SIZE)
  if [ $? -eq 0 ]; then
   BCASTC[$TOTAL,$i]=$(($(date +%s%N) - ${BCASTC[$TOTAL,$i]}))
   BCASTC[$CHASE,$i]=$(($(date +%s%N) - $START_TIME))
   echo "$OUT" > outputs/bcastc/$BASE_DIR/answer/$DATA_SIZE/Q$QUERY.txt
   BCASTC[$TUPLES,$i]=$(echo "$OUT" | grep "Count :" | cut -d':' -f2)
  else
   BCASTC[$BLOCK,$i]="-1"
   BCASTC[$TOTAL,$i]="-1"
   BCASTC[$CHASE,$i]="-1"
   BCASTC[$TUPLES,$i]="-1"
  fi
  echo "Blocking: $((${BCASTC[$BLOCK,$i]}/1000000)) milliseconds"
  echo "Chasing: $((${BCASTC[$CHASE,$i]}/1000000)) milliseconds"
  echo "Time elapsed: $((${BCASTC[$TOTAL,$i]}/1000000)) milliseconds"
  echo "# of tuples: ${BCASTC[$TUPLES,$i]}"
done

echo "===== ONTOP RW ====="
mkdir -p outputs/ontoprw/$BASE_DIR/rewritings
mkdir -p outputs/ontoprw/$BASE_DIR/answer/$DATA_SIZE
for ((i=0;i<$NUM_TESTS;++i)); do
 START_TIME=$(date +%s%N | sed 's/^0*//')
 ONTOPRW[$TOTAL,$i]=$START_TIME
 OUTPUT=$($JRE -jar tools/tw-rewriting/tw-rewriting.jar $BASE_DIR/owl/ontology.owl $BASE_DIR/queries/SPARQL/Q$QUERY.rq | sed '/FINAL REWRITING/,$!d; /REWRITING OVER/,$d')
 ONTOPRW[$REWRITE,$i]=$(($(date +%s%N) - $START_TIME))
 echo "$OUTPUT" > outputs/ontoprw/$BASE_DIR/rewritings/Q$QUERY-rewriting.txt
 subs=$(echo "$OUTPUT" | grep ':-' | grep -v 'q' | sed 's/$/ ./g')
 query=$(echo "$OUTPUT" | grep ':-' | grep 'q' | cut -d '#' -f1 | sed 's/$/ ./g')
 TW=$(java -jar tools/obdabenchmarkingtools/datalogToCB-1.08.jar -exts "$subs" -query "$query")
 ONTOPRW[$SIZE,$i]=$(echo "$TW" | grep -c "<-")
 echo "Rewriting: $((${ONTOPRW[$REWRITE,$i]}/1000000)) milliseconds, Size: ${ONTOPRW[$SIZE,$i]}"

  START_TIME=$(date +%s%N)
  SQL=$(java -jar tools/obdabenchmarkingtools/sqlConvert-1.08.jar "$TW" --src)
  ONTOPRW[$CONVERT,$i]=$(($(date +%s%N) - $START_TIME))
  echo "Converting: $((${ONTOPRW[$CONVERT,$i]}/1000000)) milliseconds"


  START_TIME=$(date +%s%N)
  ONTOPRW[$TUPLES,$i]=$(psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -c "SELECT COUNT(*) FROM (${SQL%?}) AS query;" | grep '-' -A1 | grep -v '-')
  echo ${ONTOPRW[$TUPLES,$i]} > outputs/ontoprw/$BASE_DIR/answer/$DATA_SIZE/Q$QUERY.txt
  ONTOPRW[$EXECUTE,$i]=$(($(date +%s%N) - $START_TIME))
  ONTOPRW[$TOTAL,$i]=$(($(date +%s%N) - ${ONTOPRW[$TOTAL,$i]}))
 echo "Executing: $((${ONTOPRW[$EXECUTE,$i]}/1000000)) milliseconds"
 echo "# of tuples: ${ONTOPRW[$TUPLES,$i]}"
done

# echo "===== Llunatic ====="
# for ((i=0;i<$NUM_TESTS;++i)); do
#   START_TIME=$(date +%s%N)
#   OUT=$(timeout $TIMEOUT ./tools/Llunatic-master/lunaticEngine/runExp.sh $BASE_DIR/queries/Chasebench/Q$QUERY/$DATA_SIZE.xml)
#   if [ $? -eq 0 ]; then
#     TOTAL[1,$i]=$(($(date +%s%N) - $START_TIME))
#   elif [ $? -eq 124 ]; then
#     TOTAL[1,$i]="TIME"
#   else 
#     TOTAL[1,$i]="ERR"
#   fi
#   LOAD[5,$i]=$(echo "$OUT" | grep "Import time" -m 1 | cut -d ':' -f 2 | cut -d 'm' -f 1)
#   LLUNATIC[$i]=$(echo "$OUT" | grep "Chase time" -m 1 | cut -d ':' -f 2 | cut -d 'm' -f 1)
#   EXECUTE[5,$i]=$(echo "$OUT" | grep "Query time" -m 1 | cut -d ':' -f 2 | cut -d 'm' -f 1)
#   TUPLES[5,$i]=$(echo "$OUT" | grep "Result size" | cut -d ':' -f 3)
#   echo "Executing: $((${EXECUTE[5,$i]})) milliseconds"
#   echo "Time elapsed: $((${TOTAL[5,$i]}/1000000)) milliseconds"
#   echo "# of tuples: ${TUPLES[5,$i]}"
# done

## WRITE RESULTS

echo "rewrite,convert,execute,total,size,tuples" >> experiments/$BASE_DIR/$DATA_SIZE/Q$QUERY/rapid.csv
echo "rewrite,convert,execute,total,size,tuples" >> experiments/$BASE_DIR/$DATA_SIZE/Q$QUERY/iqaros.csv
echo "rewrite,convert,execute,total,size,tuples" >> experiments/$BASE_DIR/$DATA_SIZE/Q$QUERY/graal.csv
echo "chase,execute,loading,total,tuples" >> experiments/$BASE_DIR/$DATA_SIZE/Q$QUERY/rdfox.csv
echo "block,rewrite,execute,total,size,tuples" >> experiments/$BASE_DIR/$DATA_SIZE/Q$QUERY/chasestepper.csv
#echo "block,rewrite,convert,execute,total,tuples" >> experiments/$BASE_DIR/$DATA_SIZE/Q$QUERY/gqr.csv
echo "rewrite,convert,execute,loading,total,tuples" >> experiments/$BASE_DIR/$DATA_SIZE/Q$QUERY/ontop.csv
echo "block,chase,total,tuples" >> experiments/$BASE_DIR/$DATA_SIZE/Q$QUERY/chasestepperST.csv
echo "rewrite,convert,execute,total,size,tuples" >> experiments/$BASE_DIR/$DATA_SIZE/Q$QUERY/ontopR.csv
#echo "load,chase,execute,total,tuples" >> experiments/$BASE_DIR/$DATA_SIZE/Q$QUERY/llunatic.csv
for ((i=1;i<$NUM_TESTS;++i)); do
 echo "${RAPID[$REWRITE,$i]},${RAPID[$CONVERT,$i]},${RAPID[$EXECUTE,$i]},${RAPID[$TOTAL,$i]},${RAPID[$SIZE,$i]},${RAPID[$TUPLES,$i]}" >> experiments/$BASE_DIR/$DATA_SIZE/Q$QUERY/rapid.csv
 echo "${IQAROS[$REWRITE,$i]},${IQAROS[$CONVERT,$i]},${IQAROS[$EXECUTE,$i]},${IQAROS[$TOTAL,$i]},${IQAROS[$SIZE,$i]},${IQAROS[$TUPLES,$i]}" >> experiments/$BASE_DIR/$DATA_SIZE/Q$QUERY/iqaros.csv
 echo "${GRAAL[$REWRITE,$i]},${GRAAL[$CONVERT,$i]},${GRAAL[$EXECUTE,$i]},${GRAAL[$TOTAL,$i]},${GRAAL[$SIZE,$i]},${GRAAL[$TUPLES,$i]}" >> experiments/$BASE_DIR/$DATA_SIZE/Q$QUERY/graal.csv
 echo "${ONTOPRW[$REWRITE,$i]},${ONTOPRW[$CONVERT,$i]},${ONTOPRW[$EXECUTE,$i]},${ONTOPRW[$TOTAL,$i]},${ONTOPRW[$SIZE,$i]},${ONTOPRW[$TUPLES,$i]}" >> experiments/$BASE_DIR/$DATA_SIZE/Q$QUERY/ontopR.csv
 echo "${RDFOX[$CHASE,$i]},${RDFOX[$EXECUTE,$i]},${RDFOX[$LOAD,$i]},${RDFOX[$TOTAL,$i]},${RDFOX[$TUPLES,$i]}" >> experiments/$BASE_DIR/$DATA_SIZE/Q$QUERY/rdfox.csv
 echo "${BCAGQR[$BLOCK,$i]},${BCAGQR[$REWRITE,$i]},${BCAGQR[$EXECUTE,$i]},${BCAGQR[$TOTAL,$i]},${BCAGQR[$SIZE,$i]},${BCAGQR[$TUPLES,$i]}" >> experiments/$BASE_DIR/$DATA_SIZE/Q$QUERY/chasestepper.csv
 echo "${ONTOP[$REWRITE,$i]},${ONTOP[$CONVERT,$i]},${ONTOP[$EXECUTE,$i]},${ONTOP[$LOAD,$i]},${ONTOP[$TOTAL,$i]},${ONTOP[$TUPLES,$i]}" >> experiments/$BASE_DIR/$DATA_SIZE/Q$QUERY/ontop.csv
 echo "${BCASTC[$BLOCK,$i]},${BCASTC[$CHASE,$i]},${BCASTC[$TOTAL,$i]},${BCASTC[$TUPLES,$i]}" >> experiments/$BASE_DIR/$DATA_SIZE/Q$QUERY/chasestepperST.csv
 #echo "${LOAD[5,$i]},${LLUNATIC[$i]},${EXECUTE[5,$i]},${TOTAL[5,$i]},${TUPLES[5,$i]}" >> experiments/$BASE_DIR/$DATA_SIZE/Q$QUERY/llunatic.csv
done
