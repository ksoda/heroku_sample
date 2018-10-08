[![Build Status](https://travis-ci.org/ksoda/todo-app.svg?branch=master)](https://travis-ci.org/ksoda/todo-app)

## Deploy

```sh
bin/create-app
git push heroku master
heroku run rails db:migrate
```

## Destroy

### With API

Assume: `host=example.test`

```sh
# Load DB
docker-compose run --rm web bin/rails db:fixtures:load

# Create User
http post :3000/users email=john@example.test password=secret name=foo

# Get Token
t=$(http post $host/authentication email=john@example.test password=secret | jq -r .token)

# Find ID
id=$(http $host/todos/ | jq .[0].id)

# Delete
http delete $host/todos/$id "Authorization:Token token=$t"
```

```sh
# Batch Delete by IDs
cat todos.json | jq .[].id | xargs -I"{}" http delete $host/todos/{}
```
