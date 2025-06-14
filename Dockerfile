FROM node:24.2.0-alpine@sha256:7aaba6b13a55a1d78411a1162c1994428ed039c6bbef7b1d9859c25ada1d7cc5 AS builder

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

FROM nginx:1.28.0-alpine-slim@sha256:39a9a15e0a81914a96fa9ffa980cdfe08e2e5e73ae3424f341ad1f470147c413

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
