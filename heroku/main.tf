provider "heroku" {
  version = "~> 2.0"
}

resource "heroku_app" "default" {
  name   = var.server_name
  region = "us"
  stack  = "container"
}

resource "heroku_addon" "database" {
  app  = heroku_app.default.name
  plan = "heroku-postgresql:hobby-dev"
}
