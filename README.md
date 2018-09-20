# Getting Started

[![Build Status](https://travis-ci.org/ksoda/todo-app.svg?branch=master)](https://travis-ci.org/ksoda/todo-app)

```sh
bin/create-app
git push heroku master
```

## Test

```sh
docker-compose run --rm web yarn install
docker-compose run --rm -e RAILS_ENV=test web bin/rails db:setup
docker-compose run --rm -e RAILS_ENV=test web bin/rails test
```

## Local

```sh
docker-compose up web
```
