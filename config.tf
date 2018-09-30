variable "name" {}
variable "email" {}
variable "api_key" {}

provider "heroku" {
  email = "${var.email}"
  api_key = "${var.api_key}"
}

resource "heroku_app" "default" {
  name   = "${var.name}"
  region = "us"

  buildpacks = [
    "heroku/nodejs",
    "heroku/ruby",
  ]
}
