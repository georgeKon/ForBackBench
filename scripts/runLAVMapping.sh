#!/bin/bash

# query.sh runs a test on one query of a scenario
NUM_TESTS=1
SCENARIOS=("scenarios/Deep100" )
SIZES=("medium")

for BASE_DIR in "${SCENARIOS[@]}"; do
  for SIZE in ${SIZES[*]}; do
    mkdir -p ../experiments/$BASE_DIR
    # we first need to build up and tear down the database 6 times 
    source <(grep = ../$BASE_DIR/postgres-config.ini)
    export PGPASSWORD
    psql -h $PGHOST -p $PGPORT -U $PGUSER -c "DROP DATABASE IF EXISTS \"${PGDATABASE}\";"
    psql -h $PGHOST -p $PGPORT -U $PGUSER -c "CREATE DATABASE \"${PGDATABASE}\";"
    psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f ../$BASE_DIR/schema/LAV/s-schema.sql
    for file in ../$BASE_DIR/data/LAV/$SIZE/*.csv; do
    TABLE=$(basename "$file" .csv)
    cat $file | psql -c "COPY \"$TABLE\" from stdin CSV DELIMITER ','" -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE
    done
    # then we run all 5 queriesd
    for ((i=1;i<=5;++i)); do
      ./queryLAVMapping.sh $BASE_DIR $i $SIZE
    done
  done
done
