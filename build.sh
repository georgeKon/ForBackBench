if [ -d "$1" ]; then
  source <(grep = $1/config.ini)
  export PGPASSWORD
  DATABASE="src_${PGDATABASE}"
  psql -h $PGHOST -p $PGPORT -U $PGUSER -c "DROP DATABASE IF EXISTS \"${DATABASE}\";" -q
  psql -h $PGHOST -p $PGPORT -U $PGUSER -c "CREATE DATABASE \"${DATABASE}\";" -q
  PGHOST=$PGHOST PGPORT=$PGPORT PGUSER=$PGUSER PGDATABASE=$DATABASE PGPASSWORD=$PGPASSWORD obdabenchmark load $1/schema/s-schema.sql $1/data/
fi
