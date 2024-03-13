# Cvyntar Landing Site

## Quick Start

```shell
docker run --platform linux/amd64 \
    --interactive --rm \
    --mount type=bind,source="${PWD}",target=/data \
    --publish 4000:4000 \
    theanurin/jekyll:20240212
```

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

### Content Pages

This aggregate all pages for current language.
If content page is resolved as page in current language or first existing language.

```
{%- assign page_language = page.collection | default: site.language_default -%}
{%- assign languages = site.collections | where_exp: "item", "item.label != 'posts' and item.label != 'drafts'" | sort: "lang_sort_order" -%}
{%- assign unique_page_names = site.documents | where_exp: "item", "item.layout == 'page' or item.layout == 'home'" | map: "name" | uniq -%}
{%- assign content_pages = "" | split: ',' -%}
{%- for unique_page_name in unique_page_names -%}
  {%- assign localized_page = site[page_language] | where_exp: "item", "item.name == unique_page_name" | first -%}
  {%- if localized_page -%}
    {%- assign content_pages = content_pages | push: localized_page -%}
  {%- else -%}
    {%- assign page_lang_variants = "" | split: ',' -%}
    {%- for language in languages -%}
      {%- assign localized_page = site.documents | where_exp: "item", "item.name == unique_page_name" | where: "collection", language.label | first -%}
      {%- if localized_page %}
        {% assign page_lang_variants = page_lang_variants | push: localized_page %}
      {%- endif -%}
    {%- endfor -%}
    {%- assign localized_page = page_lang_variants | first -%}
    {%- assign content_pages = content_pages | push: localized_page -%}
  {%- endif -%}
{%- endfor -%}
```


## Theme Notes

- `site.pages`, `site.posts`, `site.html_pages`, `site.html_files` do not provide content documents (use `site.documents` instead)


## References

- [Jekyll](https://jekyllrb.com)
- [Liquid](https://shopify.github.io/liquid/)
- [Making a multilingual website with Jekyll collections](https://www.kooslooijesteijn.net/blog/multilingual-website-with-jekyll-collections)
- [Pug Language](https://pugjs.org)
- [Free Country Flags in SVG](https://flagicons.lipis.dev/)
