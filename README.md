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
docker-compose run --rm web bin/rails r \
  'User.create!(name: "Ken", email: "ken@example.test", password_digest: BCrypt::Password.create("secret", cost: 1))'
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
