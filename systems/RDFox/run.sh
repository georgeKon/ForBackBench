BASE_DIR=$1
DATA_SIZE=$2
QUERY=$3
~/.sdkman/candidates/java/8.0.201-oracle/jre/bin/java -jar tools/RDFox/chaseRDFox-linux.jar -chase standard -s-sch $BASE_DIR/schema/s-schema.txt -t-sch $BASE_DIR/schema/t-schema.txt -st-tgds $BASE_DIR/dependencies/st-tgds.txt -t-tgds $BASE_DIR/dependencies/t-tgds.txt -src $BASE_DIR/data/$DATA_SIZE -qdir $BASE_DIR/queries/RDFox/Q$QUERY/
