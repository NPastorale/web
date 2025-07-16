FROM node:24.4.0-alpine@sha256:0ab98940b04ac16c3e2360973c8fe2fc259dd48732eebabcb86e4d8a50efca84 AS builder

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

FROM nginx:1.29.0-alpine-slim@sha256:af91a64cdcd89e74bad1f4fba5229cc19302662530b7544155fbcb9b5fb883dd

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
