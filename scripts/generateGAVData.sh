#!/bin/bash

#PATH=$(npm bin):$PATH

## SETUP
NUM_TESTS=1
TIMEOUT=1800
JRE=java
BASE_DIR=$1
SIZE=$2

# SCENARIOS=("scenarios/Deep100")
# SIZES=("medium")

# for BASE_DIR in "${SCENARIOS[@]}"; do
	mkdir -p experiments/outputs/rapid/$BASE_DIR/GAV/unfoldedQueries
#   for SIZE in ${SIZES[*]}; do
  	rm -r $BASE_DIR/data/GAV/$SIZE

    # then we run all 5 queries
    for ((i=1;i<=5;++i)); do
  	  rapidOutput=$($JRE -jar systems/rapid/Rapid2.jar DU SHORT $BASE_DIR/owl/ontology.owl $BASE_DIR/queries/iqaros/Q$i.txt 2> /dev/null | grep -G '^Q' | grep 'io_' -v | grep -v 'AUX')
      rapidCB=$(echo "$rapidOutput" | sed 's/$/ ./g')
      echo "$rapidCB"
  	  UNFOLD=$(timeout $TIMEOUT java -jar utilityTools/unfoldingV1.jar "$rapidCB" $BASE_DIR/dependencies/gav.txt)
  		echo "================="
  		echo "Q$i"
  
  	echo "unfold: $UNFOLD"
  	if [ "$i" -eq "1" ]; then
  		echo "$UNFOLD" > experiments/outputs/rapid/$BASE_DIR/GAV/unfoldedQueries/Q-unfold.txt
  	else
  	  	echo "$UNFOLD" >> experiments/outputs/rapid/$BASE_DIR/GAV/unfoldedQueries/Q-unfold.txt
  	fi
    done
#     java -jar utilityTools/GenerateDataFromTGD.jar --tgd $BASE_DIR/dependencies/gav.txt --rows 100 --query experiments/outputs/rapid/$BASE_DIR/GAV/unfoldedQueries/Q-unfold.txt --output $BASE_DIR/data/GAV/$SIZE
  if [ $SIZE="small" ]; then
    	java -jar utilityTools/GenerateDataFromTGD.jar --tgd $BASE_DIR/dependencies/gav.txt --rows 100 --query experiments/outputs/rapid/$BASE_DIR/GAV/unfoldedQueries/Q-unfold.txt --output $BASE_DIR/data/GAV/$SIZE
  fi
  if [  $SIZE="medium" ]; then
    	java -jar utilityTools/GenerateDataFromTGD.jar --tgd $BASE_DIR/dependencies/gav.txt --rows 500 --query experiments/outputs/rapid/$BASE_DIR/GAV/unfoldedQueries/Q-unfold.txt --output $BASE_DIR/data/GAV/$SIZE
  fi
  if [  $SIZE="large" ]; then
    	java -jar utilityTools/GenerateDataFromTGD.jar --tgd $BASE_DIR/dependencies/gav.txt --rows 1000 --query experiments/outputs/rapid/$BASE_DIR/GAV/unfoldedQueries/Q-unfold.txt --output $BASE_DIR/data/GAV/$SIZE
  fi
#   done
# done

 
