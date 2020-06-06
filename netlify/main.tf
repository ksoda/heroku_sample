
provider "netlify" {
  token = "${var.netlify_token}"
}

# Create a new deploy key for this specific website
resource "netlify_deploy_key" "key" {}

# Define your site
resource "netlify_site" "main" {
  name = "${var.server_name}"

  repo {
    command       = "cd client && npm install && npm run build"
    deploy_key_id = "${netlify_deploy_key.key.id}"
    dir           = "client/dist/"
    provider      = "github"
    repo_path     = "ksoda/todo-app"
    repo_branch   = "master"
  }
}
