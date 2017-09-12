# Full image name ex: grc.io/simpleserver:v1.0.0
variable "project-tag"{
  value = "$NVY_VAR{repo.namespace}/$NVY_VAR{repo.name}:$NVY_VAR{repo.tag}"
}

# Full build image name ex: buuild-simpleserver-v1.0.0
variable "project-build-name"{
  value = "build-$NVY_VAR{repo.name}-$NVY_VAR{repo.tag}"
}

variable "project-tag-build"{
  value = "build-$NVY_VAR{project-tag}"
}

# Push image tag ex: grc.io/simpleserver
variable "push-tag"{
  value = "$NVY_VAR{repo.namespace}/$NVY_VAR{project-tag}"
}

# Build docker build image
docker "build" {
  dockerfile  = "Dockerfile.build"
  path        = "$NVY_VAR{sys_workspace}"
  tag         = "$NVY_VAR{project-tag-build}"
  no_cache     = "false"
}

# Run build image and mount output
docker "run" {
  name        = "$NVY_VAR{project-build-name}"
  image       = "$NVY_VAR{project-tag-build}"
  cmd         = ["env", "GOOS=linux", "GOARCH=amd64", "go", "build", "-o", "bin/server", "main.go"]
  volume_binds = ["$NVY_VAR{sys_workspace}/bin:/go/src/github.com/andrepinto/simpleserver/bin"]
}

# Remove build container
docker "rm"{
  container =  "$NVY_VAR{project-build-name}"
}

# Remove build image
docker "rmi"{
  name =  "$NVY_VAR{project-tag-build}"
}

# Run dist docker image
docker "build" {
  dockerfile  = "Dockerfile.dist"
  path        = "$NVY_VAR{sys_workspace}"
  tag         = "$NVY_VAR{project-tag}"
  no_cache     = "false"
}

# Push dist image
docker "push"{
  image =  "$NVY_VAR{project-tag}"
  username = "$NVY_VAR{ecr.username}"
  password = "$NVY_VAR{ecr.password}"
}

# Remove dist image
docker "rmi"{
  name =  "$NVY_VAR{project-tag}"
}

# Run plugin navy-helm
# Action build: replace and publish chart
plugin "navy-helm" "build"{
  path = "$NVY_VAR{sys_workspace}/navyhook/$NVY_VAR{repo.name}"
  destination ="$NVY_VAR{sys_workspace}"
  repository = "http://54.171.51.193:8000/charts/upload/"
  image = "$NVY_VAR{repo.namespace}/$NVY_VAR{repo.name}"
  tag = "$NVY_VAR{repo.tag}"
}
