#!/bin/bash

# query.sh runs a test on one query of a scenario
NUM_TESTS=1
SCENARIOS=("scenarios/OWL2Bench")
SIZES=("huge")

for BASE_DIR in "${SCENARIOS[@]}"; do
  for SIZE in ${SIZES[*]}; do
    mkdir -p ../experiments/$BASE_DIR
    # we first need to build up and tear down the database 6 times 
    source <(grep = ../$BASE_DIR/postgres-config.ini)
    export PGPASSWORD
    START_TIME=$(date +%s%N)
	psql -h $PGHOST -p $PGPORT -U $PGUSER -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'npd';"
    psql -h $PGHOST -p $PGPORT -U $PGUSER -c "DROP DATABASE IF EXISTS \"${PGDATABASE}\";"
    psql -h $PGHOST -p $PGPORT -U $PGUSER -c "CREATE DATABASE \"${PGDATABASE}\";"
    psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f ../$BASE_DIR/schema/oneToOne/s-schema.sql

    for file in ../$BASE_DIR/data/oneToOne/$SIZE/*.csv; do
      TABLE=$(basename "$file" .csv)
      cat $file | psql -c "COPY \"$TABLE\" from stdin CSV DELIMITER ','" -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE
    done
    # then we run all 5 queries
    for ((i=2;i<=2;++i)); do
      ./queryTrivialMapping.sh $BASE_DIR $i $SIZE
    done
  done
done

