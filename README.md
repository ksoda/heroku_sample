[![Build Status](https://travis-ci.org/ksoda/todo-app.svg?branch=master)](https://travis-ci.org/ksoda/todo-app)

## Deploy

```sh
bin/create-app
git push heroku master
heroku run rails db:migrate
```

## Destroy

### With API

```sh
host=example.test
http $host/todos/ | jq .[].id | xargs -I"{}" http delete $host/todos/{}
```
