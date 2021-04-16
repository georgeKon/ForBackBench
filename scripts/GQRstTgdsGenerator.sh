#!/bin/bash

#PATH=$(npm bin):$PATH

## SETUP
BASE_DIR=$1
JRE=java
#


echo "===== Generating GQR st-TGDS  ...... "

$JRE -jar ./systems/chasestepper/chasestepper-1.01.jar $BASE_DIR/dependencies/st-tgds0.txt $BASE_DIR/dependencies/t-tgds0.txt $BASE_DIR/queries/GQRQuery/Qlong.txt > /dev/null
mv $BASE_DIR/queries/GQRQuery/Qlong-tgds.rule $BASE_DIR/dependencies/LAV-t-tgds.rule
cp $BASE_DIR/GQRdependencies/LAV-t-tgds.rule $BASE_DIR/dependencies/LAV-st-tgds.txt  
echo "===== Done. "