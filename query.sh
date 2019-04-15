
## SETUP
NUM_TESTS=1
BASE_DIR=$1
QUERY=$2
# Clean output directories
rm -f $BASE_DIR/tests/Q$QUERY/*.csv
# Read database config file
source <(grep = $BASE_DIR/config.ini)
export PGPASSWORD
# Set up result arrays
declare -A TOTAL
declare -A REWRITE
declare -A CONVERT
declare -A EXECUTE
declare -A RDFOX

# RUN TESTS
echo "===== RAPID ====="
for ((i=0;i<$NUM_TESTS;++i)); do
  START_TIME=$(date +%s%N)
  TOTAL[0,$i]=$START_TIME
  RAPID=$(java -jar tools/rapid/Rapid2.jar DU SHORT $BASE_DIR/dependencies/ontology.owl $BASE_DIR/queries/iqaros/Q$QUERY.txt 2> /dev/null | grep -G '^Q')
  REWRITE[0,$i]=$(($(date +%s%N) - $START_TIME))
  SIZE=$(echo "$RAPID" | grep -c "<-")
  echo "Rewriting: $((${REWRITE[0,$i]}/1000000)) milliseconds, Size: $SIZE"

  START_TIME=$(date +%s%N)
  SQL=$(obdaconvert ucqstring "$RAPID" $BASE_DIR/schema/t-schema.txt rapid)
  CONVERT[0,$i]=$(($(date +%s%N) - $START_TIME))
  echo "Converting: $((${CONVERT[0,$i]}/1000000)) milliseconds"

  START_TIME=$(date +%s%N)
  TUPLES=$(psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -c "SELECT COUNT(*) FROM (${SQL%?}) AS query;" | grep '-' -A1 | grep -v '-')
  EXECUTE[0,$i]=$(($(date +%s%N) - $START_TIME))
  TOTAL[0,$i]=$(($(date +%s%N) - ${TOTAL[0,$i]}))
  echo "Executing: $((${EXECUTE[0,$i]}/1000000)) milliseconds"
  echo "# of tuples: $TUPLES"
done

echo "===== IQAROS ====="
for ((i=0;i<$NUM_TESTS;++i)); do
  START_TIME=$(date +%s%N)
  TOTAL[1,$i]=$START_TIME 
  IQAROS=$(java -jar tools/iqaros/iqaros.jar $BASE_DIR/dependencies/ontology.owl $BASE_DIR/queries/iqaros/Q$QUERY.txt 2> /dev/null | grep -G '^Q')
  REWRITE[1,$i]=$(($(date +%s%N) - $START_TIME))
  SIZE=$(echo "$IQAROS" | grep -c "<-")
  echo "Rewriting: $((${REWRITE[1,$i]}/1000000)) milliseconds, Size: $SIZE"

  START_TIME=$(date +%s%N)
  SQL=$(obdaconvert ucqstring "$IQAROS" $BASE_DIR/schema/t-schema.txt iqaros)
  CONVERT[1,$i]=$(($(date +%s%N) - $START_TIME))
  echo "Converting: $((${CONVERT[1,$i]}/1000000)) milliseconds"

  START_TIME=$(date +%s%N)
  TUPLES=$(psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -c "SELECT COUNT(*) FROM (${SQL%?}) AS query;" | grep '-' -A1 | grep -v '-')
  EXECUTE[1,$i]=$(($(date +%s%N) - $START_TIME))
  TOTAL[1,$i]=$(($(date +%s%N) - ${TOTAL[1,$i]}))
  echo "Executing: $((${EXECUTE[1,$i]}/1000000)) milliseconds"
  echo "# of tuples: $TUPLES"
done

echo "===== GRAAL ====="
for ((i=0;i<$NUM_TESTS;++i)); do
  START_TIME=$(date +%s%N)
  TOTAL[2,$i]=$START_TIME
  GRAAL=$(java -jar tools/graal/obda-benchmark-graal-1.0-SNAPSHOT-spring-boot.jar $BASE_DIR/dependencies/ontology.owl $BASE_DIR/queries/graal/Q$QUERY.rq 2> /dev/null | grep -G '^?')
  REWRITE[2,$i]=$(($(date +%s%N) - $START_TIME))
  SIZE=$(echo "$GRAAL" | grep -c ":-")
  echo "Rewriting: $((${REWRITE[2,$i]}/1000000)) milliseconds, Size: $SIZE"

  START_TIME=$(date +%s%N)
  SQL=$(obdaconvert ucqstring "$GRAAL" $BASE_DIR/schema/t-schema.txt graal)
  CONVERT[2,$i]=$(($(date +%s%N) - $START_TIME))
  echo "Converting: $((${CONVERT[2,$i]}/1000000)) milliseconds"

  START_TIME=$(date +%s%N)
  TUPLES=$(psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -c "SELECT COUNT(*) FROM (${SQL%?}) AS query;" | grep '-' -A1 | grep -v '-')
  EXECUTE[2,$i]=$(($(date +%s%N) - $START_TIME))
  TOTAL[2,$i]=$(($(date +%s%N) - ${TOTAL[2,$i]}))
  echo "Executing: $((${EXECUTE[2,$i]}/1000000)) milliseconds"
  echo "# of tuples: $TUPLES"
done

echo "===== RDFox ====="
for ((i=0;i<$NUM_TESTS;++i)); do
  START_TIME=$(date +%s%N)
  TOTAL[3,$i]=$START_TIME
  java -jar tools/RDFox/chaseRDFox-linux.jar -chase standard -s-sch $BASE_DIR/schema/s-schema.txt -t-sch $BASE_DIR/schema/t-schema.txt -st-tgds $BASE_DIR/dependencies/st-tgds.txt -src $BASE_DIR/data -t-tgds $BASE_DIR/dependencies/t-tgds.txt -qdir $BASE_DIR/queries/RDFox/Q$QUERY/ | grep "Query" -A1 | grep -v "Query"
  RDFOX[0,$i]=$(($(date +%s%N) - $START_TIME))
  TOTAL[3,$i]=$(($(date +%s%N) - ${TOTAL[3,$i]}))
  echo "Time elapsed: $((${TOTAL[3,$i]}/1000000)) milliseconds"
done

echo "===== ChaseStepper ====="
for ((i=0;i<$NUM_TESTS;++i)); do
  START_TIME=$(date +%s%N)
  TOTAL[4,$i]=$START_TIME
  java -jar ./tools/chasestepper/chasestepper-1.0.jar $BASE_DIR/dependencies/st-tgds.txt $BASE_DIR/dependencies/t-tgds.txt $BASE_DIR/queries/RDFox/Q$QUERY/Q$QUERY.txt > /dev/null
  if [ $? -eq 0 ]; then
    BLOCK_TIME[$i]=$(($(date +%s%N) - $START_TIME))
  else
    BLOCK_TIME[$i]="ERR"
  fi
  START_TIME=$(date +%s%N)
  java -jar ./tools/RDFox/chaseRDFox-linux.jar -chase standard -s-sch $BASE_DIR/schema/s-schema.txt -t-sch $BASE_DIR/schema/t-schema.txt -st-tgds $BASE_DIR/queries/RDFox/Q$QUERY/Q$QUERY-tgds.rule -src $BASE_DIR/data -qdir $BASE_DIR/queries/RDFox/Q$QUERY/ | grep "Query" -A1 | grep -v "Query"
  RDFOX[1,$i]=$(($(date +%s%N) - $START_TIME))
  TOTAL[4,$i]=$(($(date +%s%N) - ${TOTAL[4,$i]}))
  echo "Time elapsed: $((${TOTAL[4,$i]}/1000000)) milliseconds"
done

## WRITE RESULTS
echo "rewrite,convert,execute,total" >> $BASE_DIR/tests/Q$QUERY/rapid.csv
echo "rewrite,convert,execute,total" >> $BASE_DIR/tests/Q$QUERY/iqaros.csv
echo "rewrite,convert,execute,total" >> $BASE_DIR/tests/Q$QUERY/graal.csv
echo "chase" >> $BASE_DIR/tests/Q$QUERY/chasestepper.csv
echo "chase" >> $BASE_DIR/tests/Q$QUERY/rdfox.csv

for ((i=1;i<$NUM_TESTS;++i)); do
  echo "${REWRITE[0,$i]},${CONVERT[0,$i]},${EXECUTE[0,$i]},${TOTAL[0,$i]}" >> $BASE_DIR/tests/Q$QUERY/rapid.csv
  echo "${REWRITE[1,$i]},${CONVERT[1,$i]},${EXECUTE[1,$i]},${TOTAL[1,$i]}" >> $BASE_DIR/tests/Q$QUERY/iqaros.csv
  echo "${REWRITE[2,$i]},${CONVERT[2,$i]},${EXECUTE[2,$i]},${TOTAL[2,$i]}" >> $BASE_DIR/tests/Q$QUERY/graal.csv
  echo "${RDFOX[0,$i]},${TOTAL[3,$i]}" >> $BASE_DIR/tests/Q$QUERY/rdfox.csv
  echo "${BLOCK_TIME[$i]},${RDFOX[1,$i]},${TOTAL[4,$i]}" >> $BASE_DIR/tests/Q$QUERY/chasestepper.csv
done
