FROM node:24.20.0-alpine@sha256:e67514e5d0f6c46656005e1b693b2ec9d52e80b641307de684d4a015ba7a4eaf AS builder

WORKDIR /app

RUN mkdir /app/dist
RUN mkdir /app/dist/css

RUN npm install html-minifier postcss-cli cssnano

COPY . .

RUN npx html-minifier --input-dir . --output-dir ./dist --file-ext html --collapse-whitespace --remove-comments --minify-js true --minify-css true

RUN rm -rf /app/dist/node_modules

RUN npx postcss-cli ./css/*.css --use cssnano --dir ./dist/css --no-map

RUN cp -r ./images ./dist/images

ENV WEB_VERSION="0.0.1"

ARG BUILD_DATE
ARG REVISION
ARG VERSION

FROM nginx:1.31.4-alpine-slim@sha256:1870de6d59aafee152589b64404556d2535922cdd998e6dac1c4888c938ed8f9

LABEL org.opencontainers.image.created=${BUILD_DATE}
LABEL org.opencontainers.image.authors="https://nahue.ar"
LABEL org.opencontainers.image.url="https://github.com/NPastorale/containers/web"
LABEL org.opencontainers.image.documentation="https://github.com/NPastorale/containers/web"
LABEL org.opencontainers.image.source="https://github.com/NPastorale/containers"
LABEL org.opencontainers.image.version=${VERSION}
LABEL org.opencontainers.image.revision=${REVISION}
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.title="web"
LABEL org.opencontainers.image.description="My website."

RUN rm -rf /usr/share/nginx/html/*

COPY --from=builder /app/dist /usr/share/nginx/html/
