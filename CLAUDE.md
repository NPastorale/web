# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

Static personal website (`nahue.ar`) — a single `index.html` landing page with one stylesheet and two SVG icons. The output is a Docker image served by nginx, published to a container registry via GitHub Actions on every push/PR.

## Architecture

Two-stage Docker build in [Dockerfile](Dockerfile):

1. **Builder stage** (`node:24-alpine`) — installs `html-minifier`, `postcss-cli`, and `cssnano` on the fly (no `package.json` is committed), then:
   - Minifies every `.html` into `/app/dist` via `html-minifier`.
   - Runs `postcss-cli` with `cssnano` over `css/*.css` into `/app/dist/css`.
   - Copies `images/` verbatim into `/app/dist/images`.
2. **Runtime stage** (`nginx:alpine-slim`) — wipes `/usr/share/nginx/html`, copies `/app/dist` from the builder. OCI image labels are populated from `BUILD_DATE`, `REVISION`, `VERSION` build args.

There is no local dev toolchain — no `package.json`, no linter, no tests. All tooling lives inside the Dockerfile.

## Common commands

Local preview of the raw source (no build step needed):
```
python3 -m http.server 8000    # then open http://localhost:8000
```

Build and run the production image locally:
```
docker build -t web .
docker run --rm -p 8080:80 web
```

## CI / release

[.github/workflows/main.yaml](.github/workflows/main.yaml) delegates to the reusable workflow `npastorale/workflows/.github/workflows/multiarch-build.yaml@main`, which handles the multi-arch build and push. There is no branch-specific gating — every push and PR triggers a build.

## Dependency updates

Renovate is configured in [renovate.json](renovate.json) with `docker:pinDigests` and `regexManagers:dockerfileVersions`, so Dockerfile base images are pinned by tag **and** digest and bumped automatically (see recent commits updating `nginx` and `node` digests). When editing the Dockerfile, preserve the `image:tag@sha256:...` format — Renovate relies on it.
