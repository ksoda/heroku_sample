variable "name" {}

resource "heroku_app" "default" {
  name   = "${var.name}"
  region = "us"

  buildpacks = [
    "heroku/nodejs",
    "heroku/ruby",
  ]
}
