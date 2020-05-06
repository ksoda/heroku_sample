# Todo application

<!-- Purpose -->

- client/: Not used
- server/: The persistence service

## Deploy to Heroku

1. [Download and install Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli#download-and-install)
2. [Create an application](#create-an-application)
3. Then to deploy the application:

```bash
heroku git:remote -a $(terraform output app_name)
```

## Create an application

```bash
terraform init -backend-config="conn_str=$(heroku config:get DATABASE_URL --app $ADMIN_APP)"
terraform apply
```

<details>
<summary>Set up admin project</summary>

```bash
export ADMIN_APP=terraform-admin
heroku create $ADMIN_APP
heroku addons:create heroku-postgresql:hobby-dev --app $ADMIN_APP
```

</details>

Destroy:

```bash
terraform destroy
```
