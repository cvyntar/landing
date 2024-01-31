# Cvyntar Landing Site

## Development

### Jekyll via Docker
1. Build the site and make it available on a local server through [Docker](https://www.docker.com/)
  ```shell
  docker run --platform linux/amd64 \
    --interactive --rm \
    --mount type=bind,source="${PWD}",target=/data \
    --publish 4000:4000 \
    theanurin/jekyll:20230905
  ```
1. Browse to http://127.0.0.1:4000

### Jekyll local
1. Install Jekyll. See https://jekyllrb.com/docs/
1. Build the site and make it available on a local server
  ```shell
  cd docs
  bundle update
  jekyll serve --host 127.0.0.1 --port 4000
  ```
1. Browse to http://127.0.0.1:4000

## Site Content

- Landing Page
- Active Projects
- News
- Blog
