# Cvyntar Landing Site

## Development

### Jekyll via Docker

1. Build the site and make it available on a local server through [Docker](https://www.docker.com/)
  ```shell
  docker run --platform linux/amd64 \
    --interactive --rm \
    --mount type=bind,source="${PWD}",target=/data \
    --publish 4000:4000 \
    theanurin/jekyll:20240212
  ```
  Optionally your may add `--env BUNDLE_PATH=/data/vendor/bundle` to reduce delay between stop/start.
1. Browse to http://127.0.0.1:4000/devel/

### Jekyll local

1. Install Jekyll. See https://jekyllrb.com/docs/
1. Build the site and make it available on a local server
  ```shell
  bundle install
  jekyll serve --host 0.0.0.0 --port 4000 --trace
  ```
1. Browse to http://127.0.0.1:4000/devel/

## Site Content

- Landing Page
- Active Projects
- News
- Blog

## Dev Notes

...

## References

- [Jekyll](https://jekyllrb.com)
- [Liquid](https://shopify.github.io/liquid/)
- [Making a multilingual website with Jekyll collections](https://www.kooslooijesteijn.net/blog/multilingual-website-with-jekyll-collections)
- [Pug Language](https://pugjs.org)
- [Free Country Flags in SVG](https://flagicons.lipis.dev/)
