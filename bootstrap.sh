BASE_DIR=$1

source <(grep = $BASE_DIR/config.ini)

if [[ $2 = "chasebench" ]]
then
# generate data
mkdir -p $BASE_DIR/data
  for size in "small"; do
    mkdir -p $BASE_DIR/data/$size
    mkdir -p $BASE_DIR/tests/$size
    ./generate.sh $BASE_DIR $size
  done
  obdabenchmark bootstrap $BASE_DIR chasebench
elif [[ $2 = "dllite" ]]
then
  mkdir -p $BASE_DIR/schema
  obdabenchmark bootstrap $BASE_DIR dllite
  # generate data
  for size in "small"; do
    mkdir -p $BASE_DIR/data/$size
    mkdir -p $BASE_DIR/tests/$size
    ./generate.sh $BASE_DIR $size
  done
fi

PGUSER=$PGUSER PGDATABASE=$PGDATABASE PGPASSWORD=$PGPASSWORD obdabenchmark llunatic $BASE_DIR
