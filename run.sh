source <(grep = $1/config.ini)
export PGPASSWORD

echo "===== RAPID ====="
STARTTIME=$(date +%s%N)
RAPID=$(java -jar tools/rapid/Rapid2.jar DU SHORT $1/dependencies/ontology.owl $1/queries/iqaros/Q$2.txt 2> /dev/null | grep -G '^Q')
ENDTIME=$(date +%s%N)
echo "Rewriting: $((($ENDTIME - $STARTTIME)/1000000)) milliseconds"

echo "$RAPID"

STARTTIME=$(date +%s%N)
SQL=$(obdaconvert ucqstring "$RAPID" $1/schema/t-schema.txt rapid)
ENDTIME=$(date +%s%N)
echo "Converting: $((($ENDTIME - $STARTTIME)/1000000)) milliseconds"

psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -c "SELECT COUNT(*) FROM (${SQL%?}) AS query;"

echo "===== IQAROS ====="
STARTTIME=$(date +%s%N) 
IQAROS=$(java -jar tools/iqaros/iqaros.jar $1/dependencies/ontology.owl $1/queries/iqaros/Q$2.txt 2> /dev/null | grep -G '^Q')
ENDTIME=$(date +%s%N)
echo "Rewriting: $((($ENDTIME - $STARTTIME)/1000000)) milliseconds"

echo "$IQAROS"

STARTTIME=$(date +%s%N)
SQL=$(obdaconvert ucqstring "$IQAROS" $1/schema/t-schema.txt iqaros)
ENDTIME=$(date +%s%N)
echo "Converting: $((($ENDTIME - $STARTTIME)/1000000)) milliseconds"

psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -c "SELECT COUNT(*) FROM (${SQL%?}) AS query;"

echo "===== GRAAL ====="
STARTTIME=$(date +%s%N)
GRAAL=$(java -jar tools/graal/obda-benchmark-graal-1.0-SNAPSHOT-spring-boot.jar $1/dependencies/ontology.owl $1/queries/graal/Q$2.rq 2> /dev/null | grep -G '^?')
ENDTIME=$(date +%s%N)
echo "Rewriting: $((($ENDTIME - $STARTTIME)/1000000)) milliseconds"

echo "$GRAAL"

STARTTIME=$(date +%s%N)
SQL=$(obdaconvert ucqstring "$GRAAL" $1/schema/t-schema.txt graal)
ENDTIME=$(date +%s%N)
echo "Converting: $((($ENDTIME - $STARTTIME)/1000000)) milliseconds"

psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -c "SELECT COUNT(*) FROM (${SQL%?}) AS query;"

echo "===== ChaseStepper ====="
STARTTIME=$(date +%s%N)
./tools/chasestepper/run.sh $1/schema/s-schema.txt $1/schema/t-schema.txt $1/dependencies/st-tgds.txt $1/data $1/dependencies/t-tgds.txt $1/cs-out/ $1/queries/RDFox/Q$2/ $2 $1/cs-results | grep "Query" -A 1
ENDTIME=$(date +%s%N)
echo "Time elapsed: $((($ENDTIME - $STARTTIME)/1000000)) milliseconds"


echo "===== RDFox ====="
STARTTIME=$(date +%s%N)
java -jar tools/RDFox/chaseRDFox-linux.jar -chase standard -s-sch $1/schema/s-schema.txt -t-sch $1/schema/t-schema.txt -st-tgds $1/dependencies/st-tgds.txt -src $1/data -t-tgds $1/dependencies/t-tgds.txt -trg $1/out/ -qdir $1/queries/RDFox/Q$2/ -qres $1/results | grep "Query" -A 1
ENDTIME=$(date +%s%N)
echo "Time elapsed: $((($ENDTIME - $STARTTIME)/1000000)) milliseconds"
