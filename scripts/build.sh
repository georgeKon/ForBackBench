BASE_DIR=$1
SIZE=$2

source <(grep = $BASE_DIR/config.ini)
export PGPASSWORD
for ((i=0;i<$NUM_TESTS;++i)); do
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