BASE_DIR=$2

if [ $1 = "chasebench" ] 
then
  obdabenchmark bootstrap --mode chasebench --qdir $BASE_DIR/queries/ --data $BASE_DIR/data/ --t-tgds $BASE_DIR/dependencies/t-tgds.txt --t-schema $BASE_DIR/schema/t-schema.txt 
elif [ $1 = "dllite" ]
then
  obdabenchmark bootstrap --mode dllite --qdir $BASE_DIR/queries/ --onto $BASE_DIR/dependencies/ontology.owl --data $BASE_DIR/data/
fi
