# Getting Started

Install
[Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli#download-and-install)

```sh
terraform init
pip3 install haikunator
export name=(python3 -c "from haikunator import Haikunator; print(Haikunator().haikunate())")
terraform apply -var name=$name
 terraform apply -var name=$name -var email=ken0@example.test -var api_key=blah-blah-blah

heroku git:remote -a $name
git push heroku master
```
