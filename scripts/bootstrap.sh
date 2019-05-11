BASE_DIR=$1
DATA=$3
mkdir -p $BASE_DIR/data
mkdir -p $BASE_DIR/out
SIZES=("small" "medium" "large")

mkdir -p $BASE_DIR/tests/$size

if [[ $2 = "chasebench" ]]
then
  if [[ $3 = "data" ]]; then
    for size in ${SIZES[*]}; do
      mkdir -p $BASE_DIR/data/$size
      ./scripts/generate.sh $BASE_DIR $size
    done
  fi
  obdabenchmark bootstrap $BASE_DIR chasebench
elif [[ $2 = "dllite" ]]
then
  mkdir -p $BASE_DIR/schema
  obdabenchmark bootstrap $BASE_DIR dllite
  if [[ $3 = "data" ]]; then
    for size in ${SIZES[*]}; do
      mkdir -p $BASE_DIR/data/$size
      ./scripts/generate.sh $BASE_DIR $size
    done
  fi
fi
