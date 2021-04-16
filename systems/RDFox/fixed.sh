BASE_DIR=$1
DATA_SIZE=$2
QUERY=$3
OUT=$(java -jar ./tools/RDFox/chaseRDFox-linux.jar -chase standard -s-sch $BASE_DIR/schema/s-schema.txt -t-sch $BASE_DIR/schema/t-schema.txt -st-tgds $BASE_DIR/dependencies/st-tgds.txt -src $BASE_DIR/data/$DATA_SIZE -qdir $BASE_DIR/queries/Chasebench/Q$QUERY/)
#RDFOX= echo "$OUT" | grep "Total time" | cut -d ':' -f 2 | cut -d 'm' -f 1
RDFOX= echo "$OUT"
echo $RDFOX
