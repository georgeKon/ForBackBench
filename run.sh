#!/bin/bash

# query.sh runs a test on one query of a scenario
NUM_TESTS=1
SCENARIOS=("scenarios/LUBM_new")
SIZES=("small")

for BASE_DIR in "${SCENARIOS[@]}"; do
  for SIZE in ${SIZES[*]}; do
    mkdir -p experiments/$BASE_DIR
    # we first need to build up and tear down the database 6 times 
    source <(grep = $BASE_DIR/postgres-config.ini)
    export PGPASSWORD
    for ((i=0;i<1;++i)); do
      START_TIME=$(date +%s%N)
      psql -h $PGHOST -p $PGPORT -U $PGUSER -c "DROP DATABASE IF EXISTS \"${PGDATABASE}\";"
      psql -h $PGHOST -p $PGPORT -U $PGUSER -c "CREATE DATABASE \"${PGDATABASE}\";"
      psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f $BASE_DIR/schema/s-schema.sql
      for file in $BASE_DIR/data/$SIZE/*.csv; do
        TABLE=$(basename "$file" .csv)
        cat $file | psql -c "COPY \"$TABLE\" from stdin CSV DELIMITER ','" -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE
      done
      DATABASE[$i]=$(($(date +%s%N) - $START_TIME))
    done
    # then we run all 5 queries
    for ((i=1;i<=19;++i)); do
      ./scripts/query.sh $BASE_DIR $i $SIZE
    done
    # Finally, we write the results out
    echo "database" >> $BASE_DIR/tests/$SIZE/database.csv
    for ((i=1;i<$NUM_TESTS;++i)); do
      echo ${DATABASE[$i]} >> $BASE_DIR/tests/$SIZE/database.csv
    done
  done
done
