#!/bin/bash

## SETUP
NUM_TESTS=1
TIMEOUT=1800
BASE_DIR=$1
QUERY=$2
DATA_SIZE=$3
JRE=java

mkdir -p experiments/$BASE_DIR/$DATA_SIZE/Q$QUERY
mkdir -p outputs/$BASE_DIR/$DATA_SIZE/Q$QUERY

# Read database config file
source <(grep = $BASE_DIR/postgres-config.ini)
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

# Set up result arrays
declare -A RAPID
declare -A IQAROS
declare -A GRAAL
declare -A ONTOPRW
declare -A BCAGQR
declare -A BCASTC
declare -A RDFOX
declare -A RULEWERK


# RUN TESTS
echo "===== RAPID ====="
mkdir -p outputs/rapid/$BASE_DIR/rewritings
mkdir -p outputs/rapid/$BASE_DIR/gqr
mkdir -p outputs/rapid/$BASE_DIR/answer/$DATA_SIZE
for ((i=0;i<$NUM_TESTS;++i)); do
  START_TIME=$(date +%s%N)
  RAPID[$TOTAL,$i]=$START_TIME
  rapidOutput=$($JRE -jar systems/rapid/Rapid2.jar DU SHORT $BASE_DIR/owl/ontology.owl $BASE_DIR/queries/iqaros/Q$QUERY.txt 2> /dev/null | grep -G '^Q' | grep 'io_' -v | grep -v 'AUX')
  RAPID[$REWRITE,$i]=$(($(date +%s%N) - $START_TIME))
  RAPID[$SIZE,$i]=$(echo "$rapidOutput" | grep -c "<-")

  echo "$rapidOutput" | sed 's/$/ ./g' > outputs/rapid/$BASE_DIR/rewritings/Q$QUERY-rewriting.txt
  START_TIME=$(date +%s%N)
  OUT=$(java -jar ./systems/GQR/GQRrw.jar -st-tgds $BASE_DIR/GQRdependencies/st-tgds.rule -q outputs/rapid/$BASE_DIR/rewritings/Q$QUERY-rewriting.txt)
  RAPID[$GQR,$i]=$(($(date +%s%N) - $START_TIME))
  echo "$OUT" > outputs/rapid/$BASE_DIR/gqr/Q$QUERY-rewriting.txt
  nulls=$(echo "$OUT" | grep -c "rewNo:null")
  if [ "$nulls" = "0" ]; then 
    SQL=$(echo "$OUT"| grep "SELECT")
    RAPID[$GQRSIZE,$i]=$(echo "UNION $SQL" |grep -o -i "UNION" | wc -l)
    START_TIME=$(date +%s%N)
    RAPID[$TUPLES,$i]=$(psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -c "SELECT COUNT(*) FROM (${SQL%?}) AS query;" | grep '-' -A1 | grep -v '-')
    echo ${RAPID[$TUPLES,$i]} > outputs/rapid/$BASE_DIR/answer/$DATA_SIZE/Q$QUERY.txt
    RAPID[$EXECUTE,$i]=$(($(date +%s%N) - $START_TIME))
    RAPID[$TOTAL,$i]=$(($(date +%s%N) - ${RAPID[$TOTAL,$i]}))
  else
    RAPID[$REWRITE,$i]="-1"
    RAPID[$GQR,$i]="-1"
    RAPID[$SIZE,$i]="-1"
    RAPID[$TUPLES,$i]="-1"
    RAPID[$EXECUTE,$i]="-1"
    RAPID[$TOTAL,$i]="-1"
    RAPID[$GQRSIZE,$i]="-1" 
  fi
  echo "Rewriting: $((${RAPID[$REWRITE,$i]}/1000000)) milliseconds, Size: ${RAPID[$SIZE,$i]}"
  echo "Converting: $((${RAPID[$GQR,$i]}/1000000)) milliseconds"
  echo "GQR Size: ${RAPID[$GQRSIZE,$i]}"
  echo "Executing: $((${RAPID[$EXECUTE,$i]}/1000000)) milliseconds"
  echo "Time elapsed:: $((${RAPID[$TOTAL,$i]}/1000000)) milliseconds"
  echo "# of tuples: ${RAPID[$TUPLES,$i]}"
done

echo "===== IQAROS ====="
mkdir -p outputs/iqaros/$BASE_DIR/rewritings
mkdir -p outputs/iqaros/$BASE_DIR/gqr
mkdir -p outputs/iqaros/$BASE_DIR/answer/$DATA_SIZE
for ((i=0;i<$NUM_TESTS;++i)); do
  START_TIME=$(date +%s%N)
  IQAROS[$TOTAL,$i]=$START_TIME
  iqarosOutput=$($JRE -jar systems/iqaros/iqaros.jar $BASE_DIR/owl/ontology.owl $BASE_DIR/queries/iqaros/Q$QUERY.txt 2> /dev/null | grep -G '^Q' | grep 'io_' -v)

  IQAROS[$REWRITE,$i]=$(($(date +%s%N) - $START_TIME))
  IQAROS[$SIZE,$i]=$(echo "$iqarosOutput" | grep -c "<-")
  echo "Rewriting: $((${IQAROS[$REWRITE,$i]}/1000000)) milliseconds, Size: ${IQAROS[$SIZE,$i]}"

  echo "$iqarosOutput" | sed 's/\^/,/g; s/$/ ./g; s/X/?X/g' > outputs/iqaros/$BASE_DIR/rewritings/Q$QUERY-rewriting.txt
  START_TIME=$(date +%s%N)
  OUT=$(java -jar ./systems/GQR/GQRrw.jar -st-tgds $BASE_DIR/GQRdependencies/st-tgds.rule -q outputs/iqaros/$BASE_DIR/rewritings/Q$QUERY-rewriting.txt)
  IQAROS[$GQR,$i]=$(($(date +%s%N) - $START_TIME))
  echo "$OUT" > outputs/iqaros/$BASE_DIR/gqr/Q$QUERY-rewriting.txt
  nulls=$(echo "$OUT" | grep -c "rewNo:null")
  if [ "$nulls" = "0" ]; then 
    SQL=$(echo "$OUT"| grep "SELECT")
    IQAROS[$GQRSIZE,$i]=$(echo "UNION $SQL" |grep -o -i "UNION" | wc -l)
    START_TIME=$(date +%s%N)
    IQAROS[$TUPLES,$i]=$(psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -c "SELECT COUNT(*) FROM (${SQL%?}) AS query;" | grep '-' -A1 | grep -v '-')
    echo ${IQAROS[$TUPLES,$i]} > outputs/iqaros/$BASE_DIR/answer/$DATA_SIZE/Q$QUERY.txt
    IQAROS[$EXECUTE,$i]=$(($(date +%s%N) - $START_TIME))
    IQAROS[$TOTAL,$i]=$(($(date +%s%N) - ${IQAROS[$TOTAL,$i]}))
  else
    IQAROS[$REWRITE,$i]="-1"
    IQAROS[$GQR,$i]="-1"
    IQAROS[$SIZE,$i]="-1"
    IQAROS[$TUPLES,$i]="-1"
    IQAROS[$EXECUTE,$i]="-1"
    IQAROS[$TOTAL,$i]="-1"
    IQAROS[$GQRSIZE,$i]="-1" 
  fi
  echo "Rewriting: $((${IQAROS[$REWRITE,$i]}/1000000)) milliseconds, Size: ${IQAROS[$SIZE,$i]}"
  echo "Converting: $((${IQAROS[$GQR,$i]}/1000000)) milliseconds"
  echo "GQR Size: ${IQAROS[$GQRSIZE,$i]}"
  echo "Executing: $((${IQAROS[$EXECUTE,$i]}/1000000)) milliseconds"
  echo "Time elapsed:: $((${IQAROS[$TOTAL,$i]}/1000000)) milliseconds"
  echo "# of tuples: ${IQAROS[$TUPLES,$i]}"
  
done


echo "===== GRAAL ====="
mkdir -p outputs/graal/$BASE_DIR/rewritings
mkdir -p outputs/graal/$BASE_DIR/gqr
mkdir -p outputs/graal/$BASE_DIR/answer/$DATA_SIZE
for ((i=0;i<$NUM_TESTS;++i)); do
  START_TIME=$(date +%s%N)
  GRAAL[$TOTAL,$i]=$START_TIME
  graalOutput=$($JRE -jar systems/graal/obda-benchmark-graal-1.0-SNAPSHOT-spring-boot.jar $BASE_DIR/owl/ontology.owl $BASE_DIR/queries/SPARQL/Q$QUERY.rq 2> /dev/null | grep -G '^?' | grep 'io_' -v)
  GRAAL[$REWRITE,$i]=$(($(date +%s%N) - $START_TIME))
  GRAAL[$SIZE,$i]=$(echo "$graalOutput" | grep -c ":-")
  echo "Rewriting: $((${GRAAL[$REWRITE,$i]}/1000000)) milliseconds, Size: ${GRAAL[$SIZE,$i]}"
  echo "$graalOutput" | sed 's/?/Q/g; s/VAR_/?/g;s/X/?/g;s/<[a-zA-Z0-9\-\_\.\/\~\:]*#//g; s/>//g; s/:-/<-/g' > outputs/graal/$BASE_DIR/rewritings/Q$QUERY-rewriting.txt
  START_TIME=$(date +%s%N)
  OUT=$(java -jar ./systems/GQR/GQRrw.jar -st-tgds $BASE_DIR/GQRdependencies/st-tgds.rule -q outputs/graal/$BASE_DIR/rewritings/Q$QUERY-rewriting.txt)
  GRAAL[$GQR,$i]=$(($(date +%s%N) - $START_TIME))
  echo "$OUT" > outputs/graal/$BASE_DIR/gqr/Q$QUERY-rewriting.txt
  nulls=$(echo "$OUT" | grep -c "rewNo:null")
  if [ "$nulls" = "0" ]; then 
    SQL=$(echo "$OUT"| grep "SELECT")
    GRAAL[$GQRSIZE,$i]=$(echo "UNION $SQL" |grep -o -i "UNION" | wc -l)
    START_TIME=$(date +%s%N)
    GRAAL[$TUPLES,$i]=$(psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -c "SELECT COUNT(*) FROM (${SQL%?}) AS query;" | grep '-' -A1 | grep -v '-')
    echo ${GRAAL[$TUPLES,$i]} > outputs/graal/$BASE_DIR/answer/$DATA_SIZE/Q$QUERY.txt
    GRAAL[$EXECUTE,$i]=$(($(date +%s%N) - $START_TIME))
    GRAAL[$TOTAL,$i]=$(($(date +%s%N) - ${GRAAL[$TOTAL,$i]}))
  else
    GRAAL[$REWRITE,$i]="-1"
    GRAAL[$GQR,$i]="-1"
    GRAAL[$SIZE,$i]="-1"
    GRAAL[$TUPLES,$i]="-1"
    GRAAL[$EXECUTE,$i]="-1"
    GRAAL[$TOTAL,$i]="-1"
    GRAAL[$GQRSIZE,$i]="-1" 
  fi
  echo "Rewriting: $((${GRAAL[$REWRITE,$i]}/1000000)) milliseconds, Size: ${GRAAL[$SIZE,$i]}"
  echo "Converting: $((${GRAAL[$GQR,$i]}/1000000)) milliseconds"
  echo "GQR Size: ${GRAAL[$GQRSIZE,$i]}"
  echo "Executing: $((${GRAAL[$EXECUTE,$i]}/1000000)) milliseconds"
  echo "Time elapsed:: $((${GRAAL[$TOTAL,$i]}/1000000)) milliseconds"
  echo "# of tuples: ${GRAAL[$TUPLES,$i]}" 
done

echo "===== ONTOP RW ====="
mkdir -p outputs/ontoprw/$BASE_DIR/rewritings
mkdir -p outputs/ontoprw/$BASE_DIR/gqr
mkdir -p outputs/ontoprw/$BASE_DIR/answer/$DATA_SIZE
for ((i=0;i<$NUM_TESTS;++i)); do
START_TIME=$(date +%s%N)
  ONTOPRW[$TOTAL,$i]=$START_TIME
  ontopOutput=$($JRE -jar systems/tw-rewriting/tw-rewriting.jar $BASE_DIR/owl/ontology.owl $BASE_DIR/queries/SPARQL/Q$QUERY.rq | sed '/FINAL REWRITING/,$!d; /REWRITING OVER/,$d')
  ONTOPRW[$REWRITE,$i]=$(($(date +%s%N) - $START_TIME))
  
  subs=$(echo "$ontopOutput" | grep ':-' | grep -v 'q' | sed 's/$/ ./g')
  query=$(echo "$ontopOutput" | grep ':-' | grep 'q' | cut -d '#' -f1 | sed 's/$/ ./g')
  cbq=$(java -jar utilityTools/datalogToCB-1.09.jar -exts "$subs" -query "$query")
  ONTOPRW[$SIZE,$i]=$(echo "$cbq" | grep -c "<-")
  echo "$cbq" > outputs/ontoprw/$BASE_DIR/rewritings/Q$QUERY-rewriting.txt
  echo "Rewriting: $((${ONTOPRW[$REWRITE,$i]}/1000000)) milliseconds, Size: ${ONTOPRW[$SIZE,$i]}"

  START_TIME=$(date +%s%N)
  OUT=$(java -jar ./systems/GQR/GQRrw.jar -st-tgds $BASE_DIR/GQRdependencies/st-tgds.rule -q outputs/ontoprw/$BASE_DIR/rewritings/Q$QUERY-rewriting.txt)
  ONTOPRW[$GQR,$i]=$(($(date +%s%N) - $START_TIME))
  echo "$OUT" > outputs/ontoprw/$BASE_DIR/gqr/Q$QUERY-rewriting.txt
  nulls=$(echo "$OUT" | grep -c "rewNo:null")
  if [ "$nulls" = "0" ]; then 
    SQL=$(echo "$OUT"| grep "SELECT")
    ONTOPRW[$GQRSIZE,$i]=$(echo "UNION $SQL" |grep -o -i "UNION" | wc -l)
    START_TIME=$(date +%s%N)
    ONTOPRW[$TUPLES,$i]=$(psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -c "SELECT COUNT(*) FROM (${SQL%?}) AS query;" | grep '-' -A1 | grep -v '-')
    echo ${ONTOPRW[$TUPLES,$i]} > outputs/ontoprw/$BASE_DIR/answer/$DATA_SIZE/Q$QUERY.txt
    ONTOPRW[$EXECUTE,$i]=$(($(date +%s%N) - $START_TIME))
    ONTOPRW[$TOTAL,$i]=$(($(date +%s%N) - ${ONTOPRW[$TOTAL,$i]}))
  else
    ONTOPRW[$REWRITE,$i]="-1"
    ONTOPRW[$GQR,$i]="-1"
    ONTOPRW[$SIZE,$i]="-1"
    ONTOPRW[$TUPLES,$i]="-1"
    ONTOPRW[$EXECUTE,$i]="-1"
    ONTOPRW[$TOTAL,$i]="-1"
    ONTOPRW[$GQRSIZE,$i]="-1" 
  fi
  echo "Rewriting: $((${ONTOPRW[$REWRITE,$i]}/1000000)) milliseconds, Size: ${ONTOPRW[$SIZE,$i]}"
  echo "Converting: $((${ONTOPRW[$GQR,$i]}/1000000)) milliseconds"
  echo "GQR Size: ${ONTOPRW[$GQRSIZE,$i]}"
  echo "Executing: $((${ONTOPRW[$EXECUTE,$i]}/1000000)) milliseconds"
  echo "Time elapsed:: $((${ONTOPRW[$TOTAL,$i]}/1000000)) milliseconds"
  echo "# of tuples: ${ONTOPRW[$TUPLES,$i]}" 
done

echo "===== RDFox ====="
for ((i=0;i<$NUM_TESTS;++i)); do
  START_TIME=$(date +%s%N)
  RDFOX[$TOTAL,$i]=$START_TIME
  OUT=$(timeout $TIMEOUT $JRE -jar systems/RDFox/chaseRDFox-linux.jar -chase standard -s-sch $BASE_DIR/schema/s-schema.txt -t-sch $BASE_DIR/schema/t-schema.txt -st-tgds $BASE_DIR/dependencies/st-tgds.txt -src $BASE_DIR/data/$DATA_SIZE -t-tgds $BASE_DIR/dependencies/t-tgds.txt -qdir $BASE_DIR/queries/Chasebench/Q$QUERY/)
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
 #  $JRE -jar ./systems/chasestepper/chasestepper-1.01.jar $BASE_DIR/dependencies/st-tgds.txt $BASE_DIR/dependencies/t-tgds.txt $BASE_DIR/queries/Chasebench/Q$QUERY/Q$QUERY.txt > /dev/null
#   mv $BASE_DIR/queries/Chasebench/Q$QUERY/Q$QUERY-tgds.rule outputs/bcagqr/$BASE_DIR/chased-mapping
#   BCAGQR[$BLOCK,$i]=$(($(date +%s%N) - $START_TIME))
  START_TIME=$(date +%s%N)
  OUT=$($JRE -jar ./systems/GQR/GQRrw.jar -st-tgds $BASE_DIR/GQRdependencies/st-tgds.rule -q $BASE_DIR/queries/Chasebench/Q$QUERY/Q$QUERY.txt)
  BCAGQR[$REWRITE,$i]=$(($(date +%s%N) - $START_TIME))
  nulls=$(echo "$OUT" | grep -c "rewNo:null")
  if [ "$nulls" = "0" ]; then 
    SQL=$(echo "$OUT"| grep "SELECT")
    echo "$SQL" > outputs/bcagqr/$BASE_DIR/rewritings/Q$QUERY-rewriting.txt
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
  
  
#   echo "Blocking: $((${BCAGQR[$BLOCK,$i]}/1000000)) milliseconds"
  echo "GQR Rewriting: $((${BCAGQR[$REWRITE,$i]}/1000000)) milliseconds"
  echo "Size: ${BCAGQR[$SIZE,$i]}"
  echo "Executing: $((${BCAGQR[$EXECUTE,$i]}/1000000)) milliseconds"
  echo "Time elapsed: $((${BCAGQR[$TOTAL,$i]}/1000000)) milliseconds"
  echo "# of tuples: ${BCAGQR[$TUPLES,$i]}"
  
done

# echo "===== BCA STChase ====="
# mkdir -p outputs/bcastc/$BASE_DIR/chased-mapping
# mkdir -p outputs/bcastc/$BASE_DIR/answer/$DATA_SIZE
# for ((i=0;i<$NUM_TESTS;++i)); do
#   START_TIME=$(date +%s%N)
#   BCASTC[$TOTAL,$i]=$START_TIME 
#  #  $JRE -jar ./systems/chasestepper/chasestepper-1.01.jar $BASE_DIR/dependencies/st-tgds.txt $BASE_DIR/dependencies/t-tgds.txt $BASE_DIR/queries/Chasebench/Q$QUERY/Q$QUERY.txt > /dev/null
# #   mv $BASE_DIR/queries/Chasebench/Q$QUERY/Q$QUERY-tgds.rule outputs/bcastc/$BASE_DIR/chased-mapping
# #   BCASTC[$BLOCK,$i]=$(($(date +%s%N) - $START_TIME))
#   START_TIME=$(date +%s%N)
#   OUT=$(timeout $TIMEOUT java -jar ./utilityTools/singleStep-1.08.jar -t-sql $BASE_DIR/schema/t-schema.sql -s-sch $BASE_DIR/schema/s-schema.txt -t-sch $BASE_DIR/schema/t-schema.txt -st-tgds outputs/bcastc/$BASE_DIR/chased-mapping/Q$QUERY-tgds.rule -q $BASE_DIR/queries/Chasebench/Q$QUERY/Q$QUERY.txt -data $BASE_DIR/data/$DATA_SIZE)
#   if [ $? -eq 0 ]; then
#    BCASTC[$TOTAL,$i]=$(($(date +%s%N) - ${BCASTC[$TOTAL,$i]}))
#    BCASTC[$CHASE,$i]=$(($(date +%s%N) - $START_TIME))
#    echo "$OUT" > outputs/bcastc/$BASE_DIR/answer/$DATA_SIZE/Q$QUERY.txt
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

echo "===== Rulewerk ====="
mkdir -p outputs/rulewerk/$BASE_DIR/rewritings
mkdir -p outputs/rulewerk/$BASE_DIR/answer/$DATA_SIZE
# write the query as a rule in rls file
queryString=$(<$BASE_DIR/queries/iqaros/Q$QUERY.txt)
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
if [[ $(grep -L "Q$QUERY(" $BASE_DIR/rulewerkfiles/$DATA_SIZE/rule.rls) ]]; then   
  echo "$queryString" >> $BASE_DIR/rulewerkfiles/$DATA_SIZE/rule.rls
else
	pattern=$(echo "Q$QUERY(")
	sed -i "/$pattern/d" $BASE_DIR/rulewerkfiles/$DATA_SIZE/rule.rls
	 echo "$queryString" >> $BASE_DIR/rulewerkfiles/$DATA_SIZE/rule.rls
fi

# start testing
for ((i=0;i<$NUM_TESTS;++i)); do
  START_TIME=$(date +%s%N)
  RULEWERK[$TOTAL,$i]=$START_TIME
  q=$(echo $queryString| cut -d':' -f 1)
  ulimit -c unlimited
 rulewerkOutput=$(timeout $TIMEOUT java -jar systems/rulewerk/rulewerkClient-Apr-10.jar materialize --rule-file=$BASE_DIR/rulewerkfiles/$DATA_SIZE/rule.rls --query=$q )
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


## WRITE RESULTS
file=experiments/$BASE_DIR/$DATA_SIZE/Q$QUERY/rapid.csv
if [ -f "$file" ]
then
	echo "Printed"
else
	echo "========================== Files =========================== "	
	echo "rewrite,gqr,gqrsize,execute,total,size,tuples" >> experiments/$BASE_DIR/$DATA_SIZE/Q$QUERY/rapid.csv
	echo "rewrite,gqr,gqrsize,execute,total,size,tuples" >> experiments/$BASE_DIR/$DATA_SIZE/Q$QUERY/iqaros.csv
	echo "rewrite,gqr,gqrsize,execute,total,size,tuples" >> experiments/$BASE_DIR/$DATA_SIZE/Q$QUERY/graal.csv
	echo "rewrite,gqr,gqrsize,execute,total,size,tuples" >> experiments/$BASE_DIR/$DATA_SIZE/Q$QUERY/ontopRW.csv
	echo "chase,execute,loading,total,tuples" >> experiments/$BASE_DIR/$DATA_SIZE/Q$QUERY/rdfox.csv
	echo "block,gqr,execute,total,size,tuples" >> experiments/$BASE_DIR/$DATA_SIZE/Q$QUERY/chasestepper.csv
	echo "block,chase,total,tuples" >> experiments/$BASE_DIR/$DATA_SIZE/Q$QUERY/chasestepperST.csv
	echo "chase,execute,loading,total,tuples" >> experiments/$BASE_DIR/$DATA_SIZE/Q$QUERY/rulewerk.csv

fi

for ((i=1;i<$NUM_TESTS;++i)); do
 echo "${RAPID[$REWRITE,$i]},${RAPID[$GQR,$i]},${RAPID[$GQRSIZE,$i]},${RAPID[$EXECUTE,$i]},${RAPID[$TOTAL,$i]},${RAPID[$SIZE,$i]},${RAPID[$TUPLES,$i]}" >> experiments/$BASE_DIR/$DATA_SIZE/Q$QUERY/rapid.csv
 echo "${IQAROS[$REWRITE,$i]},${IQAROS[$GQR,$i]},${IQAROS[$GQRSIZE,$i]},${IQAROS[$EXECUTE,$i]},${IQAROS[$TOTAL,$i]},${IQAROS[$SIZE,$i]},${IQAROS[$TUPLES,$i]}" >> experiments/$BASE_DIR/$DATA_SIZE/Q$QUERY/iqaros.csv
 echo "${GRAAL[$REWRITE,$i]},${GRAAL[$GQR,$i]},${GRAAL[$GQRSIZE,$i]},${GRAAL[$EXECUTE,$i]},${GRAAL[$TOTAL,$i]},${GRAAL[$SIZE,$i]},${GRAAL[$TUPLES,$i]}" >> experiments/$BASE_DIR/$DATA_SIZE/Q$QUERY/graal.csv
 echo "${ONTOPRW[$REWRITE,$i]},${ONTOPRW[$GQR,$i]},${ONTOPRW[$GQRSIZE,$i]},${ONTOPRW[$EXECUTE,$i]},${ONTOPRW[$TOTAL,$i]},${ONTOPRW[$SIZE,$i]},${ONTOPRW[$TUPLES,$i]}" >> experiments/$BASE_DIR/$DATA_SIZE/Q$QUERY/ontopRW.csv
 echo "${RDFOX[$CHASE,$i]},${RDFOX[$EXECUTE,$i]},${RDFOX[$LOAD,$i]},${RDFOX[$TOTAL,$i]},${RDFOX[$TUPLES,$i]}" >> experiments/$BASE_DIR/$DATA_SIZE/Q$QUERY/rdfox.csv
 echo "${BCAGQR[$BLOCK,$i]},${BCAGQR[$GQR,$i]},${BCAGQR[$EXECUTE,$i]},${BCAGQR[$TOTAL,$i]},${BCAGQR[$SIZE,$i]},${BCAGQR[$TUPLES,$i]}" >> experiments/$BASE_DIR/$DATA_SIZE/Q$QUERY/chasestepper.csv
 echo "${BCASTC[$BLOCK,$i]},${BCASTC[$CHASE,$i]},${BCASTC[$TOTAL,$i]},${BCASTC[$TUPLES,$i]}" >> experiments/$BASE_DIR/$DATA_SIZE/Q$QUERY/chasestepperST.csv
 echo "${RULEWERK[$CHASE,$i]},${RULEWERK[$EXECUTE,$i]},${RULEWERK[$LOAD,$i]},${RULEWERK[$TOTAL,$i]},${RULEWERK[$TUPLES,$i]}" >> experiments/$BASE_DIR/$DATA_SIZE/Q$QUERY/rulewerk.csv
 done
