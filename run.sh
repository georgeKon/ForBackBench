# read each folder in the given scenario folder
for d in $1/*; do
  if [ -d "$d" ]; then
    # Load the database config
    source <(grep = $d/config.ini)
    export PGPASSWORD
    # Create the database
    psql -h $PGHOST -p $PGPORT -U $PGUSER -c "DROP DATABASE IF EXISTS \"${PGDATABASE}\";"
    psql -h $PGHOST -p $PGPORT -U $PGUSER -c "CREATE DATABASE \"${PGDATABASE}\";"
    PGHOST=$PGHOST PGPORT=$PGPORT PGUSER=$PGUSER PGDATABASE=$PGDATABASE PGPASSWORD=$PGPASSWORD obdabenchmark load $d/schema/t-schema.sql $d/data/
  fi
done
