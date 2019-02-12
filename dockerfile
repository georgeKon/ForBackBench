FROM node:10-alpine

RUN mkdir -p /usr/src/converters/
RUN mkdir -p /usr/logs/converters/
COPY /OBDAconverter/ /usr/src/converters/

WORKDIR /usr/src/converters/
RUN yarn

WORKDIR /

RUN mkdir -p /usr/src/framework/
RUN mkdir -p /usr/logs/framework/
COPY /OBDAframework/ /usr/src/framework/

WORKDIR /usr/src/framework/
RUN yarn && yarn run build --outDir ../../dist/framework/

WORKDIR /usr/dist/framework/

CMD ["node", "logger.js"]
