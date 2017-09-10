# An Var
variable "project-tag"{
  value = "$NVY_VAR{project-name}:$NVY_VAR{project-version}"
}

variable "project-tag-build"{
  value = "build-$NVY_VAR{project-name}:$NVY_VAR{project-version}"
}

variable "push-tag"{
  value = "$NVY_VAR{project-namespace}/$NVY_VAR{project-tag}"
}

# An Docker
docker "build" {
  dockerfile  = "Dockerfile.build"
  path        = "$NVY_VAR{sys_workspace}"
  tag         = "$NVY_VAR{project-tag-build}"
  no_cache     = "false"
}

/*
docker "run" {
  name        = "$NVY_VAR{project-tag-build}"
  image       = "$NVY_VAR{project-tag-build}"
  cmd         = ["env", "GOOS=linux", "GOARCH=amd64", "go", "build", "-o", "bin/server", "main.go"]
  volume_binds = ["$NVY_VAR{sys_workspace}/bin:/go/src/github.com/andrepinto/simpleserver/bin"]
}

docker "build" {
  dockerfile  = "Dockerfile.dist"
  path        = "$NVY_VAR{sys_workspace}"
  tag         = "$NVY_VAR{project-tag}"
  no_cache     = "false"
}

docker "rm"{
  container =  "$NVY_VAR{project-tag-build}"
}

docker "rmi"{
  name =  "$NVY_VAR{project-tag-build}"
}
*/
