FROM node:17-alpine as build-stage
RUN apk update && apk upgrade
WORKDIR /app
COPY . /app
COPY package.json .
COPY yarn.lock .
RUN yarn install --frozen-lockfile
RUN npm run build

FROM node:17-alpine
MAINTAINER Rubén Hernández Vicente <contacto@rubenhernandez.es>
LABEL org.label-schema.name="awekas-receiver" \
        org.label-schema.vendor="TioRuben" \
        org.label-schema.description="Awekas receiver for Bresser weather stations to publish data on Influx DB" \
        org.label-schema.vcs-url="https://github.com/TioRuben/awekas-receiver" \
        org.label-schema.license="MIT"
RUN apk update && apk upgrade
WORKDIR /app
COPY --from=build-stage /app/dist/ /app
COPY package.json .
COPY yarn.lock .
RUN yarn install --frozen-lockfile
USER node
CMD ["node", "index.js"]
