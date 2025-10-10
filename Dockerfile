FROM node:24.10.0-alpine@sha256:6ff78d6d45f2614fe0da54756b44a7c529a15ebcaf9832fab8df036b1d466e73 AS builder

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

FROM nginx:1.29.2-alpine-slim@sha256:91fff1c842f0da2bbfb6df7d727d74e0a7ad01cb1fa9415f2f9bfa8b0aa5d62d

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
