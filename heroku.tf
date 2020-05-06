terraform {
  backend "pg" {
  }
}

provider "heroku" {
  version = "~> 2.0"
}

variable "prefix" {
  description = "High-level name of this configuration, used as a resource name prefix"
  type        = "string"
  default     = ""
}

resource "random_pet" "sample" {}
resource "random_integer" "sample" {
  min = 1
  max = 9999
}

resource "heroku_app" "default" {
  name   = "${var.prefix}${random_pet.sample.id}-${random_integer.sample.result}"
  region = "us"
  stack  = "container"
}

resource "heroku_addon" "database" {
  app  = "${heroku_app.default.name}"
  plan = "heroku-postgresql:hobby-dev"
}

output "app_name" {
  value = "${heroku_app.default.name}"
}
