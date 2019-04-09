if [ $1 = "A" ]
then
  BASE_DIR="scenarios/Adolena"
fi

source <(grep = ${BASE_DIR}/config.ini)

docker-compose run -e PGPASSWORD=${PGPASSWORD} -e PGDATABASE=${PGDATABASE} -e PGPORT=${PGPORT} -e PGUSER=${PGUSER} framework obdabenchmark load ${BASE_DIR}/schema/t-schema.txt ${BASE_DIR}/data/

# # Dataset QueryNumber Tool Options
# if [ $1 = "A" ]
# then
#   SCHEMA="scenarios/Adolena/schema.txt"
#   DATA="scenarios/Adolena/data/"
#   QUERY="scenarios/Adolena/Q${2}"
#   ONTO="scenarios/Adolena/ontology.owl"
# elif [ $1 = "U" ]
# then
#   SCHEMA="scenarios/University/schema.txt"
#   DATA="scenarios/University/data/"
#   QUERY="scenarios/University/Q${2}"
#   ONTO="scenarios/University/ontology.owl"
# elif [ $1 = "S" ]
# then
#   SCHEMA="scenarios/StockExchange/schema.txt"
#   DATA="scenarios/StockExchange/data/"
#   QUERY="scenarios/StockExchange/Q${2}"
#   ONTO="scenarios/StockExchange/ontology.owl"
# elif [ $1 = "V" ]
# then
#   SCHEMA="scenarios/Vicodi/schema.txt"
#   DATA="scenarios/Vicodi/data/"
#   QUERY="scenarios/Vicodi/Q${2}"
#   ONTO="scenarios/Vicodi/ontology.owl"
# fi

# if [ $3 = "graal" ]
# then 
#   QUERY="${QUERY}.rq"
# else
#   QUERY="${QUERY}.txt"
# fi

# docker-compose run framework obdabenchmark test $SCHEMA $DATA $QUERY $ONTO $3 $4
