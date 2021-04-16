#!/bin/bash

mkdir -p $1/data/$3/$2
# DATA_DIR="GAV"
# if [[ $3 = "LAV" ]]; then
#     $Schema_DIR="LAV"
# fi


java -jar systems/datagenerator/datagenerator-1.01.jar $1/schema/$3/s-schema.txt $1/data/$3/$2 systems/datagenerator/config.ini $2
