FROM node:10-alpine

COPY /scenarios/ /usr/scenarios/

RUN mkdir -p /usr/logs/framework/
COPY /OBDAframework/ /usr/src/framework/

WORKDIR /usr/src/framework/
RUN yarn && yarn run build --outDir ../../dist/framework/

WORKDIR /usr/dist/framework/

RUN npm link

CMD ["yarn", "loadTest"]
