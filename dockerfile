FROM timbru31/java-node:latest

COPY /scenarios/ /usr/scenarios/
COPY /tools/ /usr/tools/

RUN mkdir -p /usr/logs/
COPY /obda-benchmark/ /usr/

WORKDIR /usr/
RUN yarn && yarn run build

WORKDIR /usr/dist/

CMD ["node", "./test.js"]
