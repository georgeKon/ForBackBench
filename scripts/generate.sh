#!/bin/bash

mkdir -p $1/data/$2
java -jar tools/datagenerator/datagenerator-1.01.jar $1/schema/s-schema.txt $1/data/$2 tools/datagenerator/config.ini $2
