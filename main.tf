terraform {
  backend "pg" {
  }
}

variable "prefix" {
  description = "High-level name of this configuration, used as a resource name prefix"
  type        = "string"
  default     = ""
}
variable "netlify_token" {
  description = "The domain name of your server"
  type        = "string"
}


output "server_url" {
  value = "${module.server.app_url}"
}

output "client_url" {
  value = "${module.client.app_url}"
}


resource "random_pet" "sample" {}
resource "random_integer" "sample" {
  min = 1
  max = 9999
}

module "server" {
  source      = "./heroku"
  server_name = "${var.prefix}${random_pet.sample.id}-${random_integer.sample.result}"
}

module "client" {
  source        = "./netlify"
  server_name   = "${var.prefix}${random_pet.sample.id}-${random_integer.sample.result}"
  netlify_token = "${var.netlify_token}"
}
