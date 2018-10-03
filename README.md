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
