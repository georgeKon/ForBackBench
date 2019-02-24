FROM timbru31/java-node:latest

COPY /scenarios/ /scenarios/
COPY /tools/ /tools/
RUN mkdir -p /logs/ && mkdir -p /app/

COPY /obda-benchmark/package.json /obda-benchmark/yarn.lock /tmp/
RUN cd /tmp/ && yarn
RUN cp -ar /tmp/{package.json,yarn.lock,node_modules} /app/

COPY /obda-benchmark/app/ /obda-benchmark/tsconfig.json /app/
RUN cd /app/ && yarn run build && npm link
