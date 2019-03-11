# Dataset QueryNumber Tool Options
if [ $1 = "A" ]
then
  SCHEMA="scenarios/Adolena/schema.txt"
  DATA="scenarios/Adolena/data/"
  QUERY="scenarios/Adolena/Q${2}"
  ONTO="scenarios/Adolena/ontology.owl"
elif [ $1 = "U" ]
then
  SCHEMA="scenarios/LUBM/schema.txt"
  DATA="scenarios/LUBM/data/"
  QUERY="scenarios/LUBM/Q${2}"
  ONTO="scenarios/LUBM/ontology.owl"
elif [ $1 = "S" ]
then
  SCHEMA="scenarios/StockExchange/schema.txt"
  DATA="scenarios/StockExchange/data/"
  QUERY="scenarios/StockExchange/Q${2}"
  ONTO="scenarios/StockExchange/ontology.owl"
elif [ $1 = "V" ]
then
  SCHEMA="scenarios/Vicodi/schema.txt"
  DATA="scenarios/Vicodi/data/"
  QUERY="scenarios/Vicodi/Q${2}"
  ONTO="scenarios/Vicodi/ontology.owl"
fi

if [ $3 = "graal" ]
then 
  QUERY="${QUERY}.rq"
else
  QUERY="${QUERY}.txt"
fi

docker-compose run framework obdabenchmark test $SCHEMA $DATA $QUERY $ONTO $3 $4
