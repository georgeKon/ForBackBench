FROM node:10-alpine

COPY /scenarios/ /usr/scenarios/

RUN mkdir -p /usr/logs/
COPY /OBDAframework/ /usr/

WORKDIR /usr/
RUN yarn && yarn run build --outDir ./dist/

WORKDIR /usr/dist/

CMD ["node", "test.js"]
