# query.sh runs a test on one query of a scenario

NUM_TESTS=6
SCENARIOS=("scenarios/Vicodi" "scenarios/LUBM" "scenarios/StockExchange" "scenarios/Adolena")
SIZES=("small" "medium" "large" "huge")

for BASE_DIR in "${SCENARIOS[@]}"; do
  for SIZE in "${SIZES[@]}"; do
    echo "Testing the $SIZE dataset for the $BASE_DIR scenario"
    # we first need to build up and tear down the database 6 times 
    source <(grep = $BASE_DIR/config.ini)
    export PGPASSWORD
    for((i=0;i<$NUM_TESTS;++i)); do
      START_TIME=$(date +%s%N)
      psql -h $PGHOST -p $PGPORT -U $PGUSER -c "DROP DATABASE IF EXISTS \"${PGDATABASE}\";" -q
      psql -h $PGHOST -p $PGPORT -U $PGUSER -c "CREATE DATABASE \"${PGDATABASE}\";" -q
      PGHOST=$PGHOST PGPORT=$PGPORT PGUSER=$PGUSER PGDATABASE=$PGDATABASE PGPASSWORD=$PGPASSWORD obdabenchmark load $BASE_DIR/schema/s-schema.sql $BASE_DIR/data/$SIZE
      DATABASE[$i]=$(($(date +%s%N) - $START_TIME))
    done

    # then we run all 5 queries
    for((i=1;i<=5;++i)); do
      ./query.sh $BASE_DIR $i $SIZE
    done

    # Finally, we write the results out
    echo "database" >> $BASE_DIR/tests/$SIZE/database.csv
    for((i=1;i<$NUM_TESTS;++i)); do
      echo ${DATABASE[$i]} >> $BASE_DIR/tests/$SIZE/database.csv
    done
  done
done
