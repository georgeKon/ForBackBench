# ./scripts/bootstrap.sh scenarios/A dllite
# ./scripts/bootstrap.sh scenarios/S dllite
./scripts/bootstrap.sh scenarios/V dllite data
./scripts/bootstrap.sh scenarios/U chasebench

cd scenarios/U/data/small && tar -xf small.tar.xz && rm small.tar.xz &&\
cd ../medium && tar -xf medium.tar.xz && rm medium.tar.xz &&\
cd ../large && tar -xf large.tar.xz && rm large.tar.xz &&\
cd ../huge && tar -xf small.tar.xz && rm small.tar.xz
