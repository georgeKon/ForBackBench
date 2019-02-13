FROM node:10-alpine

COPY /scenarios/ /usr/scenarios/

RUN mkdir -p /usr/logs/converters/
COPY /OBDAconverter/ /usr/src/converters/

WORKDIR /usr/src/converters/
RUN yarn && run build --outDir ../../dist/converters/

WORKDIR /

RUN mkdir -p /usr/logs/framework/
COPY /OBDAframework/ /usr/src/framework/

WORKDIR /usr/src/framework/
RUN yarn && yarn run build --outDir ../../dist/framework/

WORKDIR /usr/dist/framework/

CMD ["node", "logger.js"]
