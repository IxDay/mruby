FROM alpine:3.20 as compiler

RUN apk add --no-cache build-base autoconf git zig ruby-rake automake libtool mingw-w64-gcc

FROM ruby:3.2.2-bullseye

RUN apt-get update && apt-get install --no-install-recommends -y python3-pip shellcheck \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock .pre-commit-config.yaml ./

RUN bundle install && pip3 install --no-cache-dir pre-commit && git init . && pre-commit install-hooks

COPY . .
