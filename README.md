# Todo application

1. [Download and install Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli#download-and-install)
2. [Create an application](#create-an-application)
3. Then to deploy the application:

```bash
heroku git:remote -a $(terraform output server_url)
```

## Create an application

set `ADMIN_APP`

```bash
export ADMIN_APP=terraform-admin
```

or if you use fish shell

```fish
set -l ADMIN_APP terraform-admin
```

After [Set up admin project](#set-up-admin-project)

```bash
terraform init -backend-config="conn_str=$(heroku config:get DATABASE_URL --app $ADMIN_APP)"
terraform apply -var netlify_token=$(cat token)
```

### Destroy

```bash
terraform destroy
```

### Set environments of Netlify

[Link to a repository](https://docs.netlify.com/configure-builds/repo-permissions-linking/#convert-existing-sites)

Settings > Build & deploy > Continuous deployment > Build settings. Select Edit settings, then Link to a different repository.

```bash
echo "SERVICE_URL=$(terraform output server_url)"
```

### Set environments of Heroku

[Configuration and Config Vars](https://devcenter.heroku.com/articles/config-vars)

```bash
echo RESOURCE_SHARING_URL=$(terraform output client_url)
```

### Set up admin project

```bash
heroku create $ADMIN_APP
heroku addons:create heroku-postgresql:hobby-dev --app $ADMIN_APP
```
