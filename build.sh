# if [ -d "$1" ]; then
#   source <(grep = $1/config.ini)
#   export PGPASSWORD
#   psql -h $PGHOST -p $PGPORT -U $PGUSER -c "DROP DATABASE IF EXISTS \"${PGDATABASE}\";" -q
#   psql -h $PGHOST -p $PGPORT -U $PGUSER -c "CREATE DATABASE \"${PGDATABASE}\";" -q
#   PGHOST=$PGHOST PGPORT=$PGPORT PGUSER=$PGUSER PGDATABASE=$PGDATABASE PGPASSWORD=$PGPASSWORD obdabenchmark load $1/schema/s-schema.sql $1/data/
# fi

if [ -d "$1" ]; then
  source <(grep = $1/config.ini)
  export PGPASSWORD
  for ((i=0;i<1;++i)); do
    START_TIME=$(date +%s%N)
    psql -h $PGHOST -p $PGPORT -U $PGUSER -c "DROP DATABASE IF EXISTS \"${PGDATABASE}\";" -q
    psql -h $PGHOST -p $PGPORT -U $PGUSER -c "CREATE DATABASE \"${PGDATABASE}\";" -q
    psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f $1/schema/s-schema.sql
    for file in $1/data/$2/*.csv; do
      TABLE=$(basename "$file" .csv)
      cat $file | psql -c "COPY \"$TABLE\" from stdin CSV DELIMITER ','" -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE
    done
    DATABASE[$i]=$(($(date +%s%N) - $START_TIME))
  done
  echo ${DATABASE[*]}
  # PGHOST=$PGHOST PGPORT=$PGPORT PGUSER=$PGUSER PGDATABASE=$PGDATABASE PGPASSWORD=$PGPASSWORD obdabenchmark load $1/schema/s-schema.sql $1/data/
fi
