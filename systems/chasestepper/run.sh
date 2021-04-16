# s-schema t-schema st-tgds src t-tgds qdir qnum

java -jar ./tools/chasestepper/chasestepper-1.0.jar $3 $5 $6/Q$7.txt
java -jar ./tools/RDFox/chaseRDFox-linux.jar -chase standard -s-sch $1 -t-sch $2 -st-tgds $6/Q$7-tgds.rule -src $4 -qdir $6
