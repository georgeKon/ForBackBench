# query.sh runs a test on one query of a scenario

NUM_TESTS=6
SCENARIOS=("scenarios/LUBM" "scenarios/Vicodi")

for BASE_DIR in "${SCENARIOS[@]}"; do
  # we first need to build up and tear down the database 6 times 
  source <(grep = $BASE_DIR/config.ini)
  export PGPASSWORD
  for((i=0;i<$NUM_TESTS;++i)); do
    START_TIME=$(date +%s%N)
    psql -h $PGHOST -p $PGPORT -U $PGUSER -c "DROP DATABASE IF EXISTS \"${PGDATABASE}\";" -q
    psql -h $PGHOST -p $PGPORT -U $PGUSER -c "CREATE DATABASE \"${PGDATABASE}\";" -q
    PGHOST=$PGHOST PGPORT=$PGPORT PGUSER=$PGUSER PGDATABASE=$PGDATABASE PGPASSWORD=$PGPASSWORD obdabenchmark load $BASE_DIR/schema/s-schema.sql $BASE_DIR/data/
    DATABASE[$i]=$(($(date +%s%N) - $START_TIME))
  done

  # then we run all 5 queries
  for((i=1;i<=5;++i)); do
    ./query.sh $BASE_DIR $i
  done

  # Finally, we write the results out
  echo "database" >> $BASE_DIR/tests/database.csv
  for((i=1;i<$NUM_TESTS;++i)); do
    echo ${DATABASE[$i]} >> $BASE_DIR/tests/database.csv
  done
done
