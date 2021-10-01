#!/bin/bash

#PATH=$(npm bin):$PATH

## SETUP
NUM_TESTS=6
TIMEOUT=1800
BASE_DIR=$1
QUERY=$2
DATA_SIZE=$3
JRE=java

mkdir -p ../experiments/$BASE_DIR/oneToOne/$DATA_SIZE/Q$QUERY
# mkdir -p ../experiments/outputs/$BASE_DIR/oneToOne/$DATA_SIZE/Q$QUERY

# Read database config file
source <(grep = ../$BASE_DIR/postgres-config.ini)
export PGPASSWORD

##Enums for the recording results
REWRITE=0
CONVERT=1
EXECUTE=2
SIZE=3
TUPLES=4
CHASE=5
PREPROCESS=6
LOAD=7
TOTAL=8

# Set up result arrays
declare -A RAPID
declare -A IQAROS
declare -A GRAAL
declare -A ONTOP
declare -A ONTOPRW
declare -A GQR
declare -A BCAGQR
declare -A BCASTC
declare -A RDFOX
declare -A RULEWERK
declare -A RULEWERK1
declare -A CGQR

# SS="SELECT DISTINCT A.\"c0\" FROM \"src_Device\" as A, \"src_PhysicalAbility\" as B, \"src_Quadriplegia\" as C, \"src_affects\" as D, \"src_assistsWith\" as E WHERE A.\"c0\" = E.\"c0\" AND C.\"c0\" = D.\"c0\" AND B.\"c0\" = D.\"c1\" AND D.\"c1\" = E.\"c1\";"
# testQ5=$(timeout $TIMEOUT psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -c "SELECT COUNT(*) FROM (${SS%?}) AS query;" | grep '-' -A1 | grep -v '-' )
# echo "$testQ5"
echo "===== RAPID ====="
echo "$DATA_SIZE"
mkdir -p ../experiments/outputs/rapid/$BASE_DIR/rewritings
mkdir -p ../experiments/outputs/rapid/$BASE_DIR/answer/$DATA_SIZE
RapidTimeoutCounter=0
for ((i=0;i<$NUM_TESTS;++i)); do
  START_TIME=$(date +%s%N)
  RAPID[$TOTAL,$i]=$START_TIME
  rapidOutput=$(timeout $TIMEOUT $JRE -jar ../systems/rapid/Rapid2.jar DU SHORT ../$BASE_DIR/owl/ontology.owl ../$BASE_DIR/queries/iqaros/Q$QUERY.txt 2> /dev/null | grep -G '^Q' | grep 'io_' -v | grep -v 'AUX')
  RAPID[$REWRITE,$i]=$(($(date +%s%N) - $START_TIME))
  echo "$rapidOutput" > ../experiments/outputs/rapid/$BASE_DIR/rewritings/Q$QUERY-rewriting.txt
  #  echo "$rapidOutput"
  RAPID[$SIZE,$i]=$(echo "$rapidOutput" | grep -c "<-")
  echo "Rewriting: $((${RAPID[$REWRITE,$i]}/1000000)) milliseconds, Size: ${RAPID[$SIZE,$i]}"
  # echo "$rapidOutput"
##########   --  Filter Rewriting  --
  #filteredRW=$(timeout $TIMEOUT $JRE -jar ../utilityTools/FilterRwritings.jar -rw "../experiments/outputs/rapid/$BASE_DIR/rewritings/Q$QUERY-rewriting.txt" -out "../experiments/outputs/rapid/$BASE_DIR/rewritings/Q$QUERY-Filtered-Rewriting.txt" )
  #rapidCB=$(echo "$filteredRW" | sed 's/$/ ./g')
##########


  START_TIME=$(date +%s%N)
  rapidCB=$(echo "$rapidOutput" | sed 's/$/ ./g')
  # echo "rapidCBFiltered:  $rapidCB"
  #  echo "rapidCB: $rapidOutput"
  SQL=$(java -jar ../utilityTools/SQLConverterRealDB.jar "$rapidCB" ../$BASE_DIR/schema/oneToOne/s-schema.txt --src )
  #   SQL=$(java -jar ../utilityTools/sqlConvert-1.08.jar "$rapidCB" --src ../$BASE_DIR/ontop-files/mapping.obda)
  #SQL=$(obdaconvert ucq "$RAPID" ../$BASE_DIR/schema/oneToOne/t-schema.txt rapid --string --src)
  #   echo "$SQL"
  RAPID[$CONVERT,$i]=$(($(date +%s%N) - $START_TIME))
  echo "Converting: $((${RAPID[$CONVERT,$i]}/1000000)) milliseconds"
 
  #  printf 'SELECT COUNT(*) FROM (%s) AS query;\n' "${SQL%?}" >$BASE_DIR/queries/statements.sql
  #   START_TIME=$(date +%s%N)
  #   RAPID[$TUPLES,$i]=$(timeout $TIMEOUT psql -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -d "$PGDATABASE" -f ../$BASE_DIR/queries/statements.sql | grep '-' -A1 | grep -v '-' )

  START_TIME=$(date +%s%N)
  RAPID[$TUPLES,$i]=$(timeout $TIMEOUT psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -c "SELECT COUNT(*) FROM (${SQL%?}) AS query;" | grep '-' -A1 | grep -v '-' )
 
  echo ${RAPID[$TUPLES,$i]} > ../experiments/outputs/rapid/$BASE_DIR/answer/$DATA_SIZE/Q$QUERY.txt
  RAPID[$EXECUTE,$i]=$(($(date +%s%N) - $START_TIME))
  	ExcuteingTime=$((${RAPID[$EXECUTE,$i]}/1000000))
 	echo "$ExcuteingTime"

	if [ $ExcuteingTime -ge 1800000 ] 
	then
		let "RapidTimeoutCounter+=1"
    	echo "command timeout $RapidTimeoutCounter"
	fi
  RAPID[$TOTAL,$i]=$(($(date +%s%N) - ${RAPID[$TOTAL,$i]}))
  echo "Executing: $((${RAPID[$EXECUTE,$i]}/1000000)) milliseconds"
  echo "Time elapsed: $((${RAPID[$TOTAL,$i]}/1000000)) milliseconds"
  echo "# of tuples: ${RAPID[$TUPLES,$i]}"
  OUTSQL=$(timeout $TIMEOUT psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -c "SELECT * FROM (${SQL%?}) AS query;" )
  # 	echo "$OUTSQL"
 if [ $RapidTimeoutCounter -eq 2 ]
	then
    	break
	fi
done
# # 
echo "===== IQAROS ====="
mkdir -p ../experiments/outputs/iqaros/$BASE_DIR/rewritings
mkdir -p ../experiments/outputs/iqaros/$BASE_DIR/answer/$DATA_SIZE
IQAROSTimeoutCounter=0
for ((i=0;i<$NUM_TESTS;++i)); do
  START_TIME=$(date +%s%N)
  IQAROS[$TOTAL,$i]=$START_TIME 
  iqarosOutput=$(timeout $TIMEOUT $JRE -jar ../systems/iqaros/iqaros.jar ../$BASE_DIR/owl/ontology.owl ../$BASE_DIR/queries/iqaros/Q$QUERY.txt 2> /dev/null | grep -G '^Q' | grep 'io_' -v)
  IQAROS[$REWRITE,$i]=$(($(date +%s%N) - $START_TIME))
  #   echo "$iqarosOutput"
  IQAROS[$SIZE,$i]=$(echo "$iqarosOutput" | grep -c "<-")
  echo "$iqarosOutput" > ../experiments/outputs/iqaros/$BASE_DIR/rewritings/Q$QUERY-rewriting.txt
  echo "Rewriting: $((${IQAROS[$REWRITE,$i]}/1000000)) milliseconds, Size: ${IQAROS[$SIZE,$i]}"
  #   echo "$iqarosOutput" 
  iqCB=$(echo "$iqarosOutput" | sed 's/\^/,/g; s/$/ ./g; s/X/?X/g')

  START_TIME=$(date +%s%N)
  #SQL=$(obdaconvert ucq "$IQAROS" ../$BASE_DIR/schema/oneToOne/t-schema.txt iqaros --string --src)
  SQL=$(java -jar ../utilityTools/SQLConverterRealDB.jar "$iqCB" ../$BASE_DIR/schema/oneToOne/s-schema.txt --src )

  #   SQL=$(java -jar ../utilityTools/sqlConvert-1.08.jar "$iqCB" --src ../$BASE_DIR/ontop-files/mapping.obda)
  #   echo "$SQL" 
  IQAROS[$CONVERT,$i]=$(($(date +%s%N) - $START_TIME))
  echo "Converting: $((${IQAROS[$CONVERT,$i]}/1000000)) milliseconds"

  # printf 'SELECT COUNT(*) FROM (%s) AS query;\n' "${SQL%?}" >$BASE_DIR/queries/statements.sql
  #   START_TIME=$(date +%s%N)
  #   IQAROS[$TUPLES,$i]=$(timeout $TIMEOUT psql -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -d "$PGDATABASE" -f ../$BASE_DIR/queries/statements.sql | grep '-' -A1 | grep -v '-' )
  #   
  START_TIME=$(date +%s%N)
  IQAROS[$TUPLES,$i]=$(timeout $TIMEOUT psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -c "SELECT COUNT(*) FROM (${SQL%?}) AS query;" | grep '-' -A1 | grep -v '-')
  echo ${IQAROS[$TUPLES,$i]} > ../experiments/outputs/iqaros/$BASE_DIR/answer/$DATA_SIZE/Q$QUERY.txt
  IQAROS[$EXECUTE,$i]=$(($(date +%s%N) - $START_TIME))
    IqExcuteingTime=$((${IQAROS[$EXECUTE,$i]}/1000000))

	if [ $IqExcuteingTime -ge 1800000 ] 
	then
		let "IQAROSTimeoutCounter+=1"
    	echo "command timeout $IQAROSTimeoutCounter"
	fi
  IQAROS[$TOTAL,$i]=$(($(date +%s%N) - ${IQAROS[$TOTAL,$i]}))
  echo "Executing: $((${IQAROS[$EXECUTE,$i]}/1000000)) milliseconds"
  echo "Time elapsed: $((${IQAROS[$TOTAL,$i]}/1000000)) milliseconds"
  echo "# of tuples: ${IQAROS[$TUPLES,$i]}"
 if [ $IQAROSTimeoutCounter -eq 2 ]
	then
    	break
	fi
done

echo "===== GRAAL ====="
mkdir -p ../experiments/outputs/graal/$BASE_DIR/rewritings
mkdir -p ../experiments/outputs/graal/$BASE_DIR/answer/$DATA_SIZE
GRAALTimeoutCounter=0
for ((i=0;i<$NUM_TESTS;++i)); do
  START_TIME=$(date +%s%N)
  GRAAL[$TOTAL,$i]=$START_TIME
  graalOutput=$(timeout $TIMEOUT $JRE -jar ../systems/graal/obda-benchmark-graal-1.0-SNAPSHOT-spring-boot.jar ../$BASE_DIR/owl/ontology.owl ../$BASE_DIR/queries/SPARQL/Q$QUERY.rq 2> /dev/null | grep -G '^?' | grep 'io_' -v)
  GRAAL[$REWRITE,$i]=$(($(date +%s%N) - $START_TIME))
  GRAAL[$SIZE,$i]=$(echo "$graalOutput" | grep -c ":-")
  echo "$graalOutput" > ../experiments/outputs/graal/$BASE_DIR/rewritings/Q$QUERY-rewriting.txt
  echo "Rewriting: $((${GRAAL[$REWRITE,$i]}/1000000)) milliseconds, Size: ${GRAAL[$SIZE,$i]}"
  graalCB=$(echo "$graalOutput" | sed 's/?/Q/g; s/VAR_/?/g;s/X/?/g;s,<[a-zA-Z0-9\:\/~][^#]*#,,g; s/>//g; s/:-/<-/g')
  START_TIME=$(date +%s%N)
  #SQL=$(obdaconvert ucq "$GRAAL" ../$BASE_DIR/schema/oneToOne/t-schema.txt graal --string --src)
  SQL=$(java -jar ../utilityTools/SQLConverterRealDB.jar "$graalCB" ../$BASE_DIR/schema/oneToOne/s-schema.txt --src )

  #   SQL=$(java -jar ../utilityTools/sqlConvert-1.08.jar "$graalCB" --src ../$BASE_DIR/ontop-files/mapping.obda)
#   echo "$graalOutput"
  #   echo "$SQL"

  GRAAL[$CONVERT,$i]=$(($(date +%s%N) - $START_TIME))
  echo "Converting: $((${GRAAL[$CONVERT,$i]}/1000000)) milliseconds"

  #  printf 'SELECT COUNT(*) FROM (%s) AS query;\n' "${SQL%?}" >$BASE_DIR/queries/statements.sql
  #   START_TIME=$(date +%s%N)
  #   GRAAL[$TUPLES,$i]=$(timeout $TIMEOUT psql -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -d "$PGDATABASE" -f ../$BASE_DIR/queries/statements.sql | grep '-' -A1 | grep -v '-' )
  #   
  START_TIME=$(date +%s%N)
  GRAAL[$TUPLES,$i]=$(timeout $TIMEOUT psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -c "SELECT COUNT(*) FROM (${SQL%?}) AS query;" | grep '-' -A1 | grep -v '-')
  echo ${GRAAL[$TUPLES,$i]} > ../experiments/outputs/graal/$BASE_DIR/answer/$DATA_SIZE/Q$QUERY.txt
 
  GRAAL[$EXECUTE,$i]=$(($(date +%s%N) - $START_TIME))
   gExcuteingTime=$((${GRAAL[$EXECUTE,$i]}/1000000))

	if [ $gExcuteingTime -ge 1800000 ] 
	then
		let "GRAALTimeoutCounter+=1"
    	echo "command timeout $GRAALTimeoutCounter"
	fi
  GRAAL[$TOTAL,$i]=$(($(date +%s%N) - ${GRAAL[$TOTAL,$i]}))
  echo "Executing: $((${GRAAL[$EXECUTE,$i]}/1000000)) milliseconds"
  echo "Time elapsed: $((${GRAAL[$TOTAL,$i]}/1000000)) milliseconds"
  echo "# of tuples: ${GRAAL[$TUPLES,$i]}"
  OUTSQL=$(timeout $TIMEOUT psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -c "SELECT * FROM (${SQL%?}) AS query;" )
  #   echo "$OUTSQL"
   if [ $GRAALTimeoutCounter -eq 2 ]
	then
    	break
	fi	
done

# #  
echo "===== RDFox ====="
mkdir -p ../experiments/outputs/rdfox/$BASE_DIR
RDFOXTimeoutCounter=0
for ((i=0;i<$NUM_TESTS;++i)); do
  START_TIME=$(date +%s%N)
  RDFOX[$TOTAL,$i]=$START_TIME
  #   OUT=$(./../systems/RDFox/fixed.sh $BASE_DIR $DATA_SIZE $QUERY)
  OUT=$(timeout $TIMEOUT $JRE -jar ../systems/RDFox/chaseRDFox-linux.jar -chase standard -s-sch ../$BASE_DIR/schema/oneToOne/s-schema.txt -t-sch ../$BASE_DIR/schema/oneToOne/t-schema.txt -st-tgds ../$BASE_DIR/dependencies/oneToOne-st-tgds.txt -src ../$BASE_DIR/data/oneToOne/$DATA_SIZE -t-tgds ../$BASE_DIR/dependencies/oneToOne-t-tgds.txt -qdir ../$BASE_DIR/queries/Chasebench/Q$QUERY/)
#     echo $OUT
  if [ $? -eq 0 ]; then
    RDFOX[$TOTAL,$i]=$(($(date +%s%N) - $START_TIME))
    RDFOX[$LOAD,$i]=$(echo "$OUT" | grep "Loading source instance data" | cut -d'.' -f6 | cut -d'm' -f1)
    RDFOX[$CHASE,$i]=$(echo "$OUT" | grep "Chase took"| cut -d 'm' -f 1 | cut -d 'k' -f 2)
    RDFOX[$EXECUTE,$i]=$(echo "$OUT" | grep "Total time" | cut -d ':' -f 2 | cut -d 'm' -f 1)
    RDFOX[$TUPLES,$i]=$(echo "$OUT" | grep "Query" -A1 | grep -v "Query" | cut -d ':' -f 2)
  else 
    RDFOX[$TOTAL,$i]="-1"
    RDFOX[$LOAD,$i]="-1"
    RDFOX[$CHASE,$i]="-1"
    RDFOX[$EXECUTE,$i]="-1"
    RDFOX[$TUPLES,$i]="-1"
    let "RDFOXTimeoutCounter+=1"
    echo "command timeout $RDFOXTimeoutCounter"
  fi
  echo "Chasing: $((${RDFOX[$CHASE,$i]})) milliseconds"
  echo "Loading: $((${RDFOX[$LOAD,$i]})) milliseconds"
  echo "Executing: $((${RDFOX[$EXECUTE,$i]})) milliseconds"
  echo "Time elapsed: $((${RDFOX[$TOTAL,$i]}/1000000)) milliseconds"
  echo "# of tuples: ${RDFOX[$TUPLES,$i]}"
  if [ $RDFOXTimeoutCounter -eq 2 ]
	then
    	break
	fi
done
 
echo "===== GQR ====="
mkdir -p ../experiments/outputs/gqr/$BASE_DIR/rewritings
mkdir -p ../experiments/outputs/gqr/$BASE_DIR/answer/$DATA_SIZE
for ((i=0;i<$NUM_TESTS;++i)); do
  START_TIME=$(date +%s%N)
  GQR[$TOTAL,$i]=$START_TIME
  #  $JRE -jar ./../systems/chasestepper/chasestepper-1.01.jar ../$BASE_DIR/dependencies/oneToOne-st-tgds.txt ../$BASE_DIR/dependencies/oneToOne-t-tgds.txt ../$BASE_DIR/queries/Chasebench/Q$QUERY/Q$QUERY.txt > /dev/null
  #  mv ../$BASE_DIR/queries/Chasebench/Q$QUERY/Q$QUERY-tgds.rule ../experiments/outputs/bcagqr/$BASE_DIR/chased-mapping

  timeout $TIMEOUT $JRE -jar ../utilityTools/RulewerkLongTGDs.jar -st-tgds ../$BASE_DIR/dependencies/oneToOne-st-tgds.txt -t-tgds ../$BASE_DIR/dependencies/oneToOne-t-tgds.txt -out ../$BASE_DIR/dependencies/longTGDs.rule
 
  GQR[$LOAD,$i]=$(($(date +%s%N) - $START_TIME))
  START_TIME=$(date +%s%N)
 
  OUT=$(timeout $TIMEOUT $JRE -jar ../systems/GQR/GQR.jar -st-tgds ../$BASE_DIR/dependencies/longTGDs.rule -q ../$BASE_DIR/queries/Chasebench/Q$QUERY/Q$QUERY.txt)
   
#     echo "$OUT"
  GQR[$REWRITE,$i]=$(($(date +%s%N) - $START_TIME))
  nulls=$(echo "$OUT" | grep -c "rewNo:null")
  if [ "$nulls" = "0" ]; then 
    rw=$(echo "$OUT"|  awk '/Start Rewriting/{flag=1;next}/End Rewriting/{flag=0}flag' )
   
    echo "$rw" > ../experiments/outputs/gqr/$BASE_DIR/rewritings/Q$QUERY-rewriting.txt
    SQL=$(echo "$OUT"| grep "SELECT")
    echo "$SQL" > ../experiments/outputs/gqr/$BASE_DIR/rewritings/Q$QUERY-SQL.txt
    GQR[$SIZE,$i]=$(echo "UNION $SQL" |grep -o -i "UNION" | wc -l)
    
#     GQR[$CONVERT,$i]=$(echo "$OUT"| grep "Converting Time: " | cut -d':' -f 2)
	#GQR[$CONVERT,$i]=$((${GQR[$CONVERT,$i]}*1000000))
    printf 'SELECT COUNT(*) FROM (%s) AS query;\n' "${SQL%?}" >../$BASE_DIR/queries/statements.sql
    START_TIME=$(date +%s%N)
    GQR[$TUPLES,$i]=$(timeout $TIMEOUT psql -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -d "$PGDATABASE" -f ../$BASE_DIR/queries/statements.sql | grep '-' -A1 | grep -v '-' )
#     GQR[$TUPLES,$i]=$(timeout $TIMEOUT psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -c "SELECT COUNT(*) FROM (${SQL%?}) AS query;" | grep '-' -A1 | grep -v '-')
	GQR[$EXECUTE,$i]=$(($(date +%s%N) - $START_TIME))
    echo ${GQR[$TUPLES,$i]} > ../experiments/outputs/gqr/$BASE_DIR/answer/$DATA_SIZE/Q$QUERY.txt
    GQR[$TOTAL,$i]=$(($(date +%s%N) - ${GQR[$TOTAL,$i]}))
  else
    GQR[$REWRITE,$i]="-1"
    GQR[$LOAD,$i]="-1"
#     GQR[$CONVERT,$i]="-1"
    GQR[$SIZE,$i]="-1"
    GQR[$TUPLES,$i]="-1"
    GQR[$EXECUTE,$i]="-1"
    GQR[$TOTAL,$i]="-1"
  fi
   echo "Size: ${GQR[$SIZE,$i]}"
  echo "Loading: $((${GQR[$LOAD,$i]}/1000000)) milliseconds"
  echo "Rewriting: $((${GQR[$REWRITE,$i]}/1000000)) milliseconds"
#   echo "Converting: $((${GQR[$CONVERT,$i]})) milliseconds"
  echo "Executing: $((${GQR[$EXECUTE,$i]}/1000000)) milliseconds"
  echo "# of tuples: ${GQR[$TUPLES,$i]}"
  echo "Time elapsed: $((${GQR[$TOTAL,$i]}/1000000)) milliseconds"
done
#  
# echo "===== BCA GQR ====="
# mkdir -p ../experiments/outputs/bcagqr/$BASE_DIR/chased-mapping
# mkdir -p ../experiments/outputs/bcagqr/$BASE_DIR/rewritings
# mkdir -p ../experiments/outputs/bcagqr/$BASE_DIR/answer/$DATA_SIZE
# for ((i=0;i<$NUM_TESTS;++i)); do
#   START_TIME=$(date +%s%N)
#   BCAGQR[$TOTAL,$i]=$START_TIME
#   $JRE -jar ./../systems/chasestepper/chasestepper-1.01.jar ../$BASE_DIR/dependencies/oneToOne-st-tgds.txt ../$BASE_DIR/dependencies/oneToOne-t-tgds.txt ../$BASE_DIR/queries/Chasebench/Q$QUERY/Q$QUERY.txt > /dev/null
#   mv ../$BASE_DIR/queries/Chasebench/Q$QUERY/Q$QUERY-tgds.rule ../experiments/outputs/bcagqr/$BASE_DIR/chased-mapping
#   BCAGQR[$PREPROCESS,$i]=$(($(date +%s%N) - $START_TIME))
#   START_TIME=$(date +%s%N)
#   OUT=$($JRE -jar ./../systems/GQR/GQR.jar -st-tgds ../experiments/outputs/bcagqr/$BASE_DIR/chased-mapping/Q$QUERY-tgds.rule -q ../$BASE_DIR/queries/Chasebench/Q$QUERY/Q$QUERY.txt)
#   BCAGQR[$REWRITE,$i]=$(($(date +%s%N) - $START_TIME))
#   nulls=$(echo "$OUT" | grep -c "rewNo:null")
#   if [ "$nulls" = "0" ]; then 
#     SQL=$(echo "$OUT"| grep "SELECT")
#     echo "$SQL" > ../experiments/outputs/bcagqr/$BASE_DIR/rewritings/Q$QUERY-rewriting.txt
#     BCAGQR[$SIZE,$i]=$(echo "UNION $SQL" |grep -o -i "UNION" | wc -l)
#     START_TIME=$(date +%s%N)
#     BCAGQR[$TUPLES,$i]=$(timeout $TIMEOUT psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -c "SELECT COUNT(*) FROM (${SQL%?}) AS query;" | grep '-' -A1 | grep -v '-')
#     echo ${BCAGQR[$TUPLES,$i]} > ../experiments/outputs/bcagqr/$BASE_DIR/answer/$DATA_SIZE/Q$QUERY.txt
#     BCAGQR[$EXECUTE,$i]=$(($(date +%s%N) - $START_TIME))
#     BCAGQR[$TOTAL,$i]=$(($(date +%s%N) - ${BCAGQR[$TOTAL,$i]}))
#   else
#     BCAGQR[$REWRITE,$i]="-1"
#     BCAGQR[$PREPROCESS,$i]="-1"
#     BCAGQR[$SIZE,$i]="-1"
#     BCAGQR[$TUPLES,$i]="-1"
#     BCAGQR[$EXECUTE,$i]="-1"
#     BCAGQR[$TOTAL,$i]="-1"
#   fi
#   echo "Size: ${BCAGQR[$SIZE,$i]}"
#   echo "# of tuples: ${BCAGQR[$TUPLES,$i]}"
#   echo "Blocking: $((${BCAGQR[$PREPROCESS,$i]}/1000000)) milliseconds"
#   echo "GQR: $((${BCAGQR[$REWRITE,$i]}/1000000)) milliseconds"
#   echo "Executing: $((${BCAGQR[$EXECUTE,$i]}/1000000)) milliseconds"
#   echo "Time elapsed: $((${BCAGQR[$TOTAL,$i]}/1000000)) milliseconds"
# done

echo "===== ONTOP ====="
mkdir -p ../experiments/outputs/ontop/$BASE_DIR/log/$DATA_SIZE
ONTOPTimeoutCounter=0
for ((i=0;i<$NUM_TESTS;++i)); do
  START_TIME=$(date +%s%N)
  ONTOP[$TOTAL,$i]=$START_TIME
  ontopOutput=$(timeout $TIMEOUT  ./../systems/ontop/ontop query -t ../$BASE_DIR/owl/ontology.owl -q ../$BASE_DIR/queries/SPARQL/Q$QUERY.rq -m ../$BASE_DIR/ontop-files/mapping.obda -p ../$BASE_DIR/ontop-files/properties.txt)
  if [ $? -eq 0 ]; then
   echo "$ontopOutput" > ../experiments/outputs/ontop/$BASE_DIR/log/$DATA_SIZE/Q$QUERY-log.txt
   
   ONTOP[$TOTAL,$i]=$(($(date +%s%N) - ${ONTOP[$TOTAL,$i]}))
   loadStart=$(echo "$ontopOutput" | grep "Loaded OntologyID"  | cut -d'[' -f 1);
   #echo "$ontopOutput" | grep "Loaded OntologyID" 
   loadSTime=$(date -u -d "$loadStart" +"%s.%N"); 
   #echo "$loadSTime"
   loadEnd=$(echo "$ontopOutput" | grep "Ontop has completed the setup and it is ready for query answering"  | cut -d'[' -f 1);
  # echo "$ontopOutput" | grep "Ontop has completed the setup and it is ready for query answering"  
   loadETime=$(date -u -d "$loadEnd" +"%s.%N");
   #echo "$loadETime"
   ONTOP[$LOAD,$i]=$(date -u -d "0 $loadETime sec - $loadSTime sec" +%S%N | sed 's/^0*//')
   
   rWStart=$(echo "$ontopOutput" | grep "Start the rewriting process"  | cut -d'[' -f 1);
   rWSTime=$(date -u -d "$rWStart" +"%s.%N"); 
   rWEnd=$(echo "$ontopOutput" | grep "New query after pulling out equalities"  | cut -d'[' -f 1);
   
   # if it has empty query 
   if test -z "$rWEnd" 
   then
       rWEnd=$(echo "$ontopOutput" | grep "Empty query --> no solution"  | cut -d'[' -f 1);
   fi
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
   if [ $eSTime == $eETime ]; then
   	ONTOP[$EXECUTE,$i]=$(date -u -d "0 $eETime sec - $eSTime sec" +%S%N)
   fi
  
  # reweriting=$(echo "$ontopOutput" | sed -n -e '/Program normalized for SQL translation/,/Resulting native query/p' | sed 's/.*://');
#    echo "$reweriting"
#    
  else 
    ONTOP[$TOTAL,$i]="-1"
    ONTOP[$LOAD,$i]="-1"
    ONTOP[$REWRITE,$i]="-1"
    ONTOP[$CONVERT,$i]="-1"
    ONTOP[$EXECUTE,$i]="-1"
    ONTOP[$TUPLES,$i]="-1"
     let "ONTOPTimeoutCounter+=1"
    echo "command timeout $ONTOPTimeoutCounter"
  fi
  
  echo "Loading: $((${ONTOP[$LOAD,$i]}/1000000)) milliseconds"
  echo "Rewriting: $((${ONTOP[$REWRITE,$i]}/1000000)) milliseconds"
  echo "Executing: $((${ONTOP[$EXECUTE,$i]}/1000000)) milliseconds"
  echo "Time elapsed: $((${ONTOP[$TOTAL,$i]}/1000000)) milliseconds"
  echo "# of tuples: ${ONTOP[$TUPLES,$i]}"
   if [ $ONTOPTimeoutCounter -eq 2 ]
	then
    	break
	fi
done


# echo "===== STChase ====="
# mkdir -p ../experiments/outputs/bcastc/$BASE_DIR/rewritings
# mkdir -p ../experiments/outputs/bcastc/$BASE_DIR/answer/$DATA_SIZE
# 
# for ((i=0;i<$NUM_TESTS;++i)); do
#   START_TIME=$(date +%s%N)
#   BCASTC[$TOTAL,$i]=$START_TIME 
#   
#   timeout $TIMEOUT $JRE -jar ../utilityTools/RulewerkLongTGDs.jar -st-tgds ../$BASE_DIR/dependencies/oneToOne-st-tgds.txt -t-tgds ../$BASE_DIR/dependencies/oneToOne-t-tgds.txt -out ../$BASE_DIR/dependencies/longTGDs.rule
#   
# #   BCASTC[$PREPROCESS,$i]=$(($(date +%s%N) - $START_TIME))
#   
#   # START_TIME=$(date +%s%N)
#   OUT=$(timeout $TIMEOUT java -jar ../systems/STChase/singleStep-1.08.jar -t-sql ../$BASE_DIR/schema/oneToOne/t-schema.sql -s-sch ../$BASE_DIR/schema/oneToOne/s-schema.txt -t-sch ../$BASE_DIR/schema/oneToOne/t-schema.txt -st-tgds ../$BASE_DIR/dependencies/longTGDs.rule -q ../$BASE_DIR/queries/Chasebench/Q$QUERY/Q$QUERY.txt -data ../$BASE_DIR/data/oneToOne/$DATA_SIZE)
#   if [ $? -eq 0 ]; then
#    BCASTC[$CHASE,$i]=$(($(date +%s%N) - $START_TIME))
#    echo "$OUT" > ../experiments/outputs/bcastc/$BASE_DIR/answer/$DATA_SIZE/Q$QUERY.txt
#    BCASTC[$TUPLES,$i]=$(echo "$OUT" | grep "Count :" | cut -d':' -f2)
#    BCASTC[$TOTAL,$i]=$(($(date +%s%N) - ${BCASTC[$TOTAL,$i]}))
#   else
# #    BCASTC[$PREPROCESS,$i]="-1"
#    BCASTC[$TOTAL,$i]="-1"
#    BCASTC[$CHASE,$i]="-1"
#    BCASTC[$TUPLES,$i]="-1"
#   fi
# #   echo "Blocking: $((${BCASTC[$PREPROCESS,$i]}/1000000)) milliseconds"
#   echo "Chasing: $((${BCASTC[$CHASE,$i]}/1000000)) milliseconds"
#   echo "Time elapsed: $((${BCASTC[$TOTAL,$i]}/1000000)) milliseconds"
#   echo "# of tuples: ${BCASTC[$TUPLES,$i]}"
# done

echo "===== ONTOP RW ====="
mkdir -p ../experiments/outputs/ontoprw/$BASE_DIR/rewritings
mkdir -p ../experiments/outputs/ontoprw/$BASE_DIR/answer/$DATA_SIZE
ontopRTimeoutCounter=0
for ((i=0;i<$NUM_TESTS;++i)); do
 START_TIME=$(date +%s%N | sed 's/^0*//')
 ONTOPRW[$TOTAL,$i]=$START_TIME
 OUTPUT=$(timeout $TIMEOUT $JRE -jar ../systems/tw-rewriting/tw-rewriting.jar ../$BASE_DIR/owl/ontology.owl ../$BASE_DIR/queries/SPARQL/Q$QUERY.rq | sed '/FINAL REWRITING/,$!d; /REWRITING OVER/,$d' | grep 'io_' -v)
 ONTOPRW[$REWRITE,$i]=$(($(date +%s%N) - $START_TIME)) 
 echo "$OUTPUT" > ../experiments/outputs/ontoprw/$BASE_DIR/rewritings/Q$QUERY-rewriting.txt
 #  echo "output: $OUTPUT"
 subs=$(echo "$OUTPUT" | grep ':-' | grep -v 'q' | sed 's/$/ ./g')
 
 query=$(echo "$OUTPUT" | grep ':-' | grep 'q' | cut -d '#' -f1 | sed 's/$/ ./g')
 #  echo "query: $query"
 #  echo "subs: $subs"
 TW=$(java -jar ../utilityTools/datalogToCB-1.09.jar -exts "$subs" -query "$query")
 ONTOPRW[$SIZE,$i]=$(echo "$TW" | grep -c "<-")
 echo "Rewriting: $((${ONTOPRW[$REWRITE,$i]}/1000000)) milliseconds, Size: ${ONTOPRW[$SIZE,$i]}"
#  echo "TW: $TW"
 START_TIME=$(date +%s%N)
 SQL=$(java -jar ../utilityTools/SQLConverterRealDB.jar "$TW" ../$BASE_DIR/schema/oneToOne/s-schema.txt --src )

  #   SQL=$(java -jar ../utilityTools/sqlConvert-1.08.jar "$TW" --src ../$BASE_DIR/ontop-files/mapping.obda)
  #echo "$SQL"
  ONTOPRW[$CONVERT,$i]=$(($(date +%s%N) - $START_TIME))
  echo "Converting: $((${ONTOPRW[$CONVERT,$i]}/1000000)) milliseconds"

  #  printf 'SELECT COUNT(*) FROM (%s) AS query;\n' "${SQL%?}" >$BASE_DIR/queries/statements.sql
  #   START_TIME=$(date +%s%N)
  #   ONTOPRW[$TUPLES,$i]=$(timeout $TIMEOUT psql -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -d "$PGDATABASE" -f ../$BASE_DIR/queries/statements.sql | grep '-' -A1 | grep -v '-' )

  START_TIME=$(date +%s%N)
  ONTOPRW[$TUPLES,$i]=$(timeout $TIMEOUT psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -c "SELECT COUNT(*) FROM (${SQL%?}) AS query;" | grep '-' -A1 | grep -v '-')
  echo ${ONTOPRW[$TUPLES,$i]} > ../experiments/outputs/ontoprw/$BASE_DIR/answer/$DATA_SIZE/Q$QUERY.txt
  ONTOPRW[$EXECUTE,$i]=$(($(date +%s%N) - $START_TIME))
   ontopRExcuteingTime=$((${ONTOPRW[$EXECUTE,$i]}/1000000))

	if [ $ontopRExcuteingTime -ge 1800000 ] 
	then
		let "ontopRTimeoutCounter+=1"
    	echo "command timeout $ontopRTimeoutCounter"
	fi
  ONTOPRW[$TOTAL,$i]=$(($(date +%s%N) - ${ONTOPRW[$TOTAL,$i]}))
  echo "Executing: $((${ONTOPRW[$EXECUTE,$i]}/1000000)) milliseconds"
  echo "Time elapsed: $((${ONTOPRW[$TOTAL,$i]}/1000000)) milliseconds"
  echo "# of tuples: ${ONTOPRW[$TUPLES,$i]}"
  OUTSQL=$(timeout $TIMEOUT psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -c "SELECT * FROM (${SQL%?}) AS query;" )
  #   echo "$OUTSQL"
  if [ $ontopRTimeoutCounter -eq 2 ]
	then
    	break
	fi
done



echo "===== CGQR ====="

mkdir -p ../experiments/outputs/chasegqr/$BASE_DIR/rewritings
mkdir -p ../experiments/outputs/chasegqr/$BASE_DIR/answer/$DATA_SIZE
for ((i=0;i<$NUM_TESTS;++i)); do
  START_TIME=$(date +%s%N)
  CGQR[$TOTAL,$i]=$START_TIME
  #  $JRE -jar ./../systems/chasestepper/chasestepper-1.01.jar ../$BASE_DIR/dependencies/st-tgds.txt ../$BASE_DIR/dependencies/t-tgds.txt ../$BASE_DIR/queries/Chasebench/Q$QUERY/Q$QUERY.txt > /dev/null
  #   mv ../$BASE_DIR/queries/Chasebench/Q$QUERY/Q$QUERY-tgds.rule ../experiments/outputs/bcagqr/$BASE_DIR/chased-mapping
  #   BCAGQR[$PREPROCESS,$i]=$(($(date +%s%N) - $START_TIME))
  START_TIME=$(date +%s%N)
  OUT=$(timeout $TIMEOUT $JRE -jar ../systems/ChaseGQR/ChaseGQR.jar -t ../$BASE_DIR/dependencies/ChaseGQR/cgqr-t-tgds.txt -v ../$BASE_DIR/dependencies/oneToOne-st-tgds.txt -q ../$BASE_DIR/queries/Chasebench/Q$QUERY/Q$QUERY.txt -d ../$BASE_DIR/dependencies/ChaseGQR/db.properties)
#   CGQR[$GQR,$i]=$(($(date +%s%N) - $START_TIME))
  if [ $? -eq 0 ]; then
  
    loadingStart=$(echo "$OUT" | grep "Start Loading Views"| cut -d ' ' -f2 );
    loadingSTime=$(date -u -d "$loadingStart" +"%s.%N"); 
    
    gqrStart=$(echo "$OUT" | grep "Start GQR"| cut -d ' ' -f2 );
    gqrSTime=$(date -u -d "$gqrStart" +"%s.%N"); 
    CGQR[$LOAD,$i]=$(date -u -d "0 $gqrSTime sec - $loadingSTime sec" +%S%N | sed 's/^0*//')

    rwStart=$(echo "$OUT" | grep "Start Rewriting"| cut -d ' ' -f2  );
    rwStartTime=$(date -u -d "$rwStart" +"%s.%N"); 
#     CGQR[$GQR,$i]=$(date -u -d "0 $rwStartTime sec - $gqrSTime sec" +%S%N | sed 's/^0*//')
    
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
#     CGQR[$GQR,$i]="-1"
    CGQR[$REWRITE,$i]="-1"
    CGQR[$CONVERT,$i]="-1"
    CGQR[$EXECUTE,$i]="-1"
    CGQR[$TOTAL,$i]="-1"
    CGQR[$TUPLES,$i]="-1" 
  fi
  
  
  echo "Loading: $((${CGQR[$LOAD,$i]}/1000000)) milliseconds"
#   echo "GQR: $((${CGQR[$GQR,$i]}/1000000)) milliseconds"
  echo "Rewriting: $((${CGQR[$REWRITE,$i]}/1000000)) milliseconds"
  echo "Converting: $((${CGQR[$CONVERT,$i]}/1000000)) milliseconds"
  echo "Executing: $((${CGQR[$EXECUTE,$i]}/1000000)) milliseconds"
  echo "Total Time : $((${CGQR[$TOTAL,$i]}/1000000)) milliseconds"
  echo "# of tuples: ${CGQR[$TUPLES,$i]}"  
done
# 
# 
echo "===== Rulewerk ====="
mkdir -p ../experiments/outputs/rulewerk/$BASE_DIR/rewritings
mkdir -p ../experiments/outputs/rulewerk/$BASE_DIR/answer/$DATA_SIZE
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
if [[ $(grep -L "Q$QUERY(" ../$BASE_DIR/rulewerkfiles/oneToOne/$DATA_SIZE/rule.rls) ]]; then   
  echo "$queryString" >> ../$BASE_DIR/rulewerkfiles/oneToOne/$DATA_SIZE/rule.rls
else
	pattern=$(echo "Q$QUERY(")
	sed -i "/$pattern/d" ../$BASE_DIR/rulewerkfiles/oneToOne/$DATA_SIZE/rule.rls
	 echo "$queryString" >> ../$BASE_DIR/rulewerkfiles/oneToOne/$DATA_SIZE/rule.rls
fi

# start testing
RULEWERKTimeoutCounter=0
for ((i=0;i<$NUM_TESTS;++i)); do
  START_TIME=$(date +%s%N)
  RULEWERK[$TOTAL,$i]=$START_TIME
  #q=$(<$BASE_DIR/queries/rulewerk/Q$QUERY/Q$QUERY.txt)
  q=$(echo $queryString| cut -d':' -f 1)
  ulimit -c unlimited
  #  echo "========== Start OLD ============" 
  #    rulewerkOutput1=$(timeout $TIMEOUT java -jar ../systems/rulewerk/rulewerkClient-Apr-21.jar materialize --rule-file=../$BASE_DIR/rulewerkfiles/oneToOne/$DATA_SIZE/rule.rls --query=$q )
  #   echo "$rulewerkOutput1"
  #   echo "========== END OLD ============" 
  rulewerkOutput=$(timeout $TIMEOUT java -jar ../systems/rulewerk/RulewerkDebug.jar materialize --rule-file=../$BASE_DIR/rulewerkfiles/oneToOne/$DATA_SIZE/rule.rls --query=$q )
#      rulewerkOutput=$(timeout $TIMEOUT java -jar ../systems/rulewerk/RulewerkDebug.jar materialize --rule-file=../$BASE_DIR/rulewerkfiles/oneToOne/$DATA_SIZE/rule.rls --chase-algorithm=SKOLEM_CHASE --query=$q )

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
    let "RULEWERKTimeoutCounter+=1"
    echo "command timeout $RULEWERKTimeoutCounter"
  fi
  
  echo "Chasing: $((${RULEWERK[$CHASE,$i]}/1000000)) milliseconds"
  echo "Loading: $((${RULEWERK[$LOAD,$i]}/1000000)) milliseconds"
  echo "Executing: $((${RULEWERK[$EXECUTE,$i]}/1000000)) milliseconds"
  echo "Time elapsed: $((${RULEWERK[$TOTAL,$i]}/1000000)) milliseconds"
  echo "# of tuples: ${RULEWERK[$TUPLES,$i]}" 
  echo "QUery is : $QUERY"
   if [ $RULEWERKTimeoutCounter -eq 2 ]
	then
    	break
	fi
done



echo "===== Rulewerk with long st-tgds====="
mkdir -p ../experiments/outputs/rulewerk/$BASE_DIR/rewritings
mkdir -p ../experiments/outputs/rulewerk/$BASE_DIR/answer/$DATA_SIZE
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
 
 START_TIME=$(date +%s%N)
# ===== Generating long st-TGDS 
  timeout $TIMEOUT $JRE -jar ../utilityTools/RulewerkLongTGDs.jar -st-tgds ../$BASE_DIR/dependencies/oneToOne-st-tgds.txt -t-tgds ../$BASE_DIR/dependencies/oneToOne-t-tgds.txt -out ../$BASE_DIR/dependencies/longTGDs.rule
CREATETGDSTIME=$(($(date +%s%N) - $START_TIME))
# ===== converting the long st-TGDS  to RLS
touch ../$BASE_DIR/dependencies/temp-t-tgds.txt
  timeout $TIMEOUT $JRE -jar ../utilityTools/TGDsToRlsConverter.jar -st-tgds "../$BASE_DIR/dependencies/longTGDs.rule" -t-tgds "../$BASE_DIR/dependencies/temp-t-tgds.txt" -out "../$BASE_DIR/rulewerkfiles/oneToOne/$DATA_SIZE/longTGD" -data "../$BASE_DIR/data/oneToOne/$DATA_SIZE"
rm ../$BASE_DIR/dependencies/temp-t-tgds.txt



# check if the rule is already exists or not
if [[ $(grep -L "Q$QUERY(" ../$BASE_DIR/rulewerkfiles/oneToOne/$DATA_SIZE/longTGD/rule.rls) ]]; then   
  echo "$queryString" >> ../$BASE_DIR/rulewerkfiles/oneToOne/$DATA_SIZE/longTGD/rule.rls
else
	pattern=$(echo "Q$QUERY(")
	sed -i "/$pattern/d" ../$BASE_DIR/rulewerkfiles/oneToOne/$DATA_SIZE/longTGD/rule.rls
	 echo "$queryString" >> ../$BASE_DIR/rulewerkfiles/oneToOne/$DATA_SIZE/longTGD/rule.rls
fi

# start testing
RULEWERK1TimeoutCounter=0
for ((i=0;i<$NUM_TESTS;++i)); do
  START_TIME=$(date +%s%N)
  RULEWERK1[$TOTAL,$i]=$START_TIME
  q=$(echo $queryString| cut -d':' -f 1)
  ulimit -c unlimited
 rulewerkOutput=$(timeout $TIMEOUT java -jar ../systems/rulewerk/RulewerkDebug.jar materialize --rule-file=../$BASE_DIR/rulewerkfiles/oneToOne/$DATA_SIZE/longTGD/rule.rls --query=$q )
  echo "$rulewerkOutput"
  if [ $? -eq 0 ]; then
    RULEWERK1[$TOTAL,$i]=$(($(date +%s%N) - $START_TIME))
  
    loadingStart=$(echo "$rulewerkOutput" | grep "Started loading knowledge base"| cut -d ' ' -f2 );
    loadingSTime=$(date -u -d "$loadingStart" +"%s.%N"); 
    loadingEnd=$(echo "$rulewerkOutput" | grep "Finished loading knowledge base"| cut -d ' ' -f2 );
    loadingETime=$(date -u -d "$loadingEnd" +"%s.%N"); 
    RULEWERK1[$LOAD,$i]=$(date -u -d "0 $loadingETime sec - $loadingSTime sec" +%S%N | sed 's/^0*//')

    chaseStart=$(echo "$rulewerkOutput" | grep "Started materialisation of inferences"| cut -d ' ' -f2  );
    chaseSTime=$(date -u -d "$chaseStart" +"%s.%N"); 
    chaseEnd=$(echo "$rulewerkOutput" | grep "Completed materialisation of inferences"| cut -d ' ' -f2  );
    chaseETime=$(date -u -d "$chaseEnd" +"%s.%N"); 
#     RULEWERK1[$CHASE,$i]=$(date -u -d "0 $chaseETime sec - $chaseSTime sec" +%S%N | sed 's/^0*//')
    RulewerkChase=$(date -u -d "0 $chaseETime sec - $chaseSTime sec" +%S%N | sed 's/^0*//')
	RULEWERK1[$CHASE,$i]=$(($CREATETGDSTIME+$RulewerkChase))
    echo "$RulewerkChase"
    echo "$CREATETGDSTIME"
    echo "${RULEWERK1[$CHASE,$i]}"

    exEnd=$(echo "$rulewerkOutput" | grep "Finished Answering queries"| cut -d ' ' -f2 );
    exETime=$(date -u -d "$exEnd" +"%s.%N"); 
    RULEWERK1[$EXECUTE,$i]=$(date -u -d "0 $exETime sec - $chaseETime sec" +%S%N | sed 's/^0*//')
        
    RULEWERK1[$TUPLES,$i]=$(echo "$rulewerkOutput" | grep "Number of query answers"| cut -d ':' -f2)
#     RULEWERK1[$PREPROCESS,$i]=$CREATETGDSTIME
  else 
    RULEWERK1[$TOTAL,$i]="-1"
    RULEWERK1[$LOAD,$i]="-1"
    RULEWERK1[$CHASE,$i]="-1"
    RULEWERK1[$EXECUTE,$i]="-1"
    RULEWERK1[$TUPLES,$i]="-1"
#     RULEWERK1[$PREPROCESS,$i]="-1"
 	let "RULEWERK1TimeoutCounter+=1"
    echo "command timeout $RULEWERK1TimeoutCounter"
  fi
#   echo "Pre-process: $((${RULEWERK1[$PREPROCESS,$i]}/1000000)) milliseconds"
  echo "Chasing: $((${RULEWERK1[$CHASE,$i]}/1000000)) milliseconds"
  echo "Loading: $((${RULEWERK1[$LOAD,$i]}/1000000)) milliseconds"
  echo "Executing: $((${RULEWERK1[$EXECUTE,$i]}/1000000)) milliseconds"
  echo "Time elapsed: $((${RULEWERK1[$TOTAL,$i]})) milliseconds"
  echo "# of tuples: ${RULEWERK1[$TUPLES,$i]}" 
  echo "QUery is : $QUERY"
   if [ $RULEWERK1TimeoutCounter -eq 2 ]
	then
    	break
	fi
done



## WRITE RESULTS
file=../experiments/$BASE_DIR/oneToOne/$DATA_SIZE/Q$QUERY/rapid.csv
if [ -f "$file" ]
then
	echo "Printed"
else
	echo "========================== Files =========================== "
	echo "rewrite,convert,execute,total,size,tuples" >> ../experiments/$BASE_DIR/oneToOne/$DATA_SIZE/Q$QUERY/Rapid.csv
	echo "rewrite,convert,execute,total,size,tuples" >> ../experiments/$BASE_DIR/oneToOne/$DATA_SIZE/Q$QUERY/Iqaros.csv
	echo "rewrite,convert,execute,total,size,tuples" >> ../experiments/$BASE_DIR/oneToOne/$DATA_SIZE/Q$QUERY/Graal.csv
 	echo "chase,execute,loading,total,tuples" >> ../experiments/$BASE_DIR/oneToOne/$DATA_SIZE/Q$QUERY/RDFox.csv
# 	echo "chase,total,tuples" >> ../experiments/$BASE_DIR/oneToOne/$DATA_SIZE/Q$QUERY/STchase.csv
	echo "loading,rewrite,execute,total,size,tuples" >> ../experiments/$BASE_DIR/oneToOne/$DATA_SIZE/Q$QUERY/RwLongST+GQR.csv
	echo "rewrite,convert,execute,loading,total,tuples" >> ../experiments/$BASE_DIR/oneToOne/$DATA_SIZE/Q$QUERY/Ontop.csv
	echo "loading,rewrite,convert,execute,total,tuples" >> ../experiments/$BASE_DIR/oneToOne/$DATA_SIZE/Q$QUERY/ChaseGQR.csv
	echo "rewrite,convert,execute,total,size,tuples" >> ../experiments/$BASE_DIR/oneToOne/$DATA_SIZE/Q$QUERY/OntopR.csv
	echo "chase,execute,loading,total,tuples" >> ../experiments/$BASE_DIR/oneToOne/$DATA_SIZE/Q$QUERY/Rulewerk.csv
	echo "chase,execute,loading,total,tuples" >> ../experiments/$BASE_DIR/oneToOne/$DATA_SIZE/Q$QUERY/RwLongSTChase.csv

fi

for ((i=1;i<$NUM_TESTS;++i)); do
 
 echo "${RAPID[$REWRITE,$i]},${RAPID[$CONVERT,$i]},${RAPID[$EXECUTE,$i]},${RAPID[$TOTAL,$i]},${RAPID[$SIZE,$i]},${RAPID[$TUPLES,$i]}" >> ../experiments/$BASE_DIR/oneToOne/$DATA_SIZE/Q$QUERY/Rapid.csv
 echo "${IQAROS[$REWRITE,$i]},${IQAROS[$CONVERT,$i]},${IQAROS[$EXECUTE,$i]},${IQAROS[$TOTAL,$i]},${IQAROS[$SIZE,$i]},${IQAROS[$TUPLES,$i]}" >> ../experiments/$BASE_DIR/oneToOne/$DATA_SIZE/Q$QUERY/Iqaros.csv
 echo "${GRAAL[$REWRITE,$i]},${GRAAL[$CONVERT,$i]},${GRAAL[$EXECUTE,$i]},${GRAAL[$TOTAL,$i]},${GRAAL[$SIZE,$i]},${GRAAL[$TUPLES,$i]}" >> ../experiments/$BASE_DIR/oneToOne/$DATA_SIZE/Q$QUERY/Graal.csv
 echo "${ONTOPRW[$REWRITE,$i]},${ONTOPRW[$CONVERT,$i]},${ONTOPRW[$EXECUTE,$i]},${ONTOPRW[$TOTAL,$i]},${ONTOPRW[$SIZE,$i]},${ONTOPRW[$TUPLES,$i]}" >> ../experiments/$BASE_DIR/oneToOne/$DATA_SIZE/Q$QUERY/OntopR.csv
 echo "${RDFOX[$CHASE,$i]},${RDFOX[$EXECUTE,$i]},${RDFOX[$LOAD,$i]},${RDFOX[$TOTAL,$i]},${RDFOX[$TUPLES,$i]}" >> ../experiments/$BASE_DIR/oneToOne/$DATA_SIZE/Q$QUERY/RDFox.csv
 echo "${GQR[$LOAD,$i]},${GQR[$REWRITE,$i]},${GQR[$EXECUTE,$i]},${GQR[$TOTAL,$i]},${GQR[$SIZE,$i]},${GQR[$TUPLES,$i]}" >> ../experiments/$BASE_DIR/oneToOne/$DATA_SIZE/Q$QUERY/RwLongST+GQR.csv
 echo "${CGQR[$LOAD,$i]},${CGQR[$REWRITE,$i]},${CGQR[$CONVERT,$i]},${CGQR[$EXECUTE,$i]},${CGQR[$TOTAL,$i]},${CGQR[$TUPLES,$i]}" >> ../experiments/$BASE_DIR/oneToOne/$DATA_SIZE/Q$QUERY/ChaseGQR.csv
 echo "${ONTOP[$REWRITE,$i]},${ONTOP[$CONVERT,$i]},${ONTOP[$EXECUTE,$i]},${ONTOP[$LOAD,$i]},${ONTOP[$TOTAL,$i]},${ONTOP[$TUPLES,$i]}" >> ../experiments/$BASE_DIR/oneToOne/$DATA_SIZE/Q$QUERY/Ontop.csv
#  echo "${BCASTC[$CHASE,$i]},${BCASTC[$TOTAL,$i]},${BCASTC[$TUPLES,$i]}" >> ../experiments/$BASE_DIR/oneToOne/$DATA_SIZE/Q$QUERY/STchase.csv
 echo "${RULEWERK[$CHASE,$i]},${RULEWERK[$EXECUTE,$i]},${RULEWERK[$LOAD,$i]},${RULEWERK[$TOTAL,$i]},${RULEWERK[$TUPLES,$i]}" >> ../experiments/$BASE_DIR/oneToOne/$DATA_SIZE/Q$QUERY/Rulewerk.csv
 echo "${RULEWERK1[$CHASE,$i]},${RULEWERK1[$EXECUTE,$i]},${RULEWERK1[$LOAD,$i]},${RULEWERK1[$TOTAL,$i]},${RULEWERK1[$TUPLES,$i]}" >> ../experiments/$BASE_DIR/oneToOne/$DATA_SIZE/Q$QUERY/RwLongSTChase.csv
done