// nginx.pkr.hcl
packer {
  required_plugins {
    docker = {
      version = ">= 1.0.8"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "nginx" {
  image  = "nginx:alpine"
  commit = true
  changes = [
    "CMD [\"nginx\", \"-g\", \"daemon off;\"]",
    "EXPOSE 80"
  ]
}

build {
  sources = ["source.docker.nginx"]

  provisioner "file" {
    source      = "./index.html"
    destination = "/usr/share/nginx/html/index.html"
  }

  post-processor "docker-tag" {
    repository = "my-custom-nginx"
    tags       = ["latest"]
  }
}