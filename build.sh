if [ -d "$1" ]; then
  source <(grep = $1/config.ini)
  export PGPASSWORD
  psql -h $PGHOST -p $PGPORT -U $PGUSER -c "DROP DATABASE IF EXISTS \"${PGDATABASE}\";" -q
  psql -h $PGHOST -p $PGPORT -U $PGUSER -c "CREATE DATABASE \"${PGDATABASE}\";" -q
  PGHOST=$PGHOST PGPORT=$PGPORT PGUSER=$PGUSER PGDATABASE=$PGDATABASE PGPASSWORD=$PGPASSWORD obdabenchmark load $1/schema/s-schema.sql $1/data/
fi
