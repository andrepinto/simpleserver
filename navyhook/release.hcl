# An Var
variable "project-tag"{
  value = "$NVY_VAR{repo.namespace}/$NVY_VAR{navy.project}:$NVY_VAR{repo.tag}"
}

variable "project-build-name"{
  value = "build-$NVY_VAR{navy.project}-$NVY_VAR{repo.tag}"
}

variable "project-tag-build"{
  value = "build-$NVY_VAR{project-tag}"
}

variable "push-tag"{
  value = "$NVY_VAR{repo.namespace}/$NVY_VAR{project-tag}"
}

# An Docker
docker "build" {
  dockerfile  = "Dockerfile.build"
  path        = "$NVY_VAR{sys_workspace}"
  tag         = "$NVY_VAR{project-tag-build}"
  no_cache     = "false"
}

docker "run" {
  name        = "$NVY_VAR{project-build-name}"
  image       = "$NVY_VAR{project-tag-build}"
  cmd         = ["env", "GOOS=linux", "GOARCH=amd64", "go", "build", "-o", "bin/server", "main.go"]
  volume_binds = ["$NVY_VAR{sys_workspace}/bin:/go/src/github.com/andrepinto/simpleserver/bin"]
}

docker "rm"{
  container =  "$NVY_VAR{project-build-name}"
}

docker "rmi"{
  name =  "$NVY_VAR{project-tag-build}"
}

docker "build" {
  dockerfile  = "Dockerfile.dist"
  path        = "$NVY_VAR{sys_workspace}"
  tag         = "$NVY_VAR{project-tag}"
  no_cache     = "false"
}

docker "push"{
  image =  "$NVY_VAR{project-tag}"
  username = "AWS"
  password = "eyJwYXlsb2FkIjoiTVFpSmh6THZjaHA4eEdTVmc4Tk9keU15U2NFaXIvdVVXd2Y5UHJPTTBScFZmZVBXWHdTNllHczl5dnRVdGR2RTA4TXhvV2ZFNHVNNnZ1UjJvc2J2eFlNQitRWisrZE5QVVlpUERXR3YxWnBBZlphT2RHQnMzUlUvTkZ6RnpDMXlSQUREVzdiMUlHQ1d3OURZM0JXNUVEZ2Q3bTl0UzRtd2pPeXpJMGZlRTIxbnBzd0c0SFhsSU5ycHYzaytFaUtubGdrOUV1K29lZHBLdzZvcitxTDFkc1pjNUNua0l1cU9QUkFpaDlydHZIaTlDREhjY0ZUbzBsbWNvRFUvSFdJbGZ4cGZVc0M0Z01xeHF5UW5Kck1ieWVxci9jYmh3REppaDdWM2xBTThla3pRQzYrVzVEdy9MNWFVQk5iNlJUTERGUEM2eW51OStLK2NYYVkya01oMzhVNzZOWUJqb1NsMXJNcWJNQUlpSmFEYWkyUXUxUU9ocElKcHpDMkpGbjNTUE1Wb2J3SmtUUk1YeVJiL0V5L3lnZlJ0NmdVcldIUDExcEh6Mk5hQWlYRkg4emlUL1VxbnJUc2Jka2NVWVpSbWo3RlQwdi9sUyt6WENCYmVvNTB6YlVhRDVnOVN0SStsLzNvN2paSGpUZUxDQ0tDSzVEcmRWS2NUZjFsVk1TYzA1aFo3T0s1ayt6MU9jbTB4Y201VXo2Z2xxcFNJdFlwOHlaeTFhMlQ5bUJvdVNCbDgzZ1dJRnUvQWUzM0l6V0lzNEJPK055VnB4ejN0L2NzVFlYV0ltSmVBNEVFUWU3SzBKSTVIWGV3MDdVakR6akpLUm9Jb1hCdFJEV1kyNTFKclRMR0N1TjJvbXhhaVE1bC9ORW80WExTSUxQZ1F4azNmai91TEF1YjdmTkFLamx1VXdKMXY3a3ZldFhHanppVlB0ODRqSUFpWkNjRHBkV3JIM1hIYlFqMkY2bmFwUk5OSEhucTVMTHJ3aXBla1pLNjJGK25RWWczbDBNWFhVdU9nd0cyRTNNaTdDb3JWdmhKc0Rtb2FvaXNYYlp5M0lLb2lZT0NHSTlNaXFtOU9mVGlYM1BzaUJaWUMzaEk3SG03V1Q4LytGc3FIVmk3MGQyREN0R0JEYVhtT05lS0o0NzZXRjc4TzYySUM5WlBmbTBXL1ZTZ0VyR3JwTzVKMmpRUjIwdnI0RlNTUlVTaDJEKzhOclVCVjdiaUZFc0R6NzFRVzg3SE84R3RYd3Rpa3ZYMU1IWmFFNFd4Z0RCQWJaT2tVMzBDbTBFNGNmYlZiZCszcUdKYU9EWGlHMXFzTktXbFVjbldtc1FVMTlQTXBSeWJmbm5LWTBPSmV6cDI3TFlBR2VFcUlEUTVvQnA0YlJjZVMvbzJGVmhhRnNpakI1QmZ2VHRzWTB0OWhPcVZQUTVSK3lGU3JnRUwvZ01WaWNqNXVxMjFjSWtQT3dERkciLCJkYXRha2V5IjoiQVFFQkFIaCtkUytCbE51ME54blh3b3diSUxzMTE1eWpkK0xOQVpoQkxac3VuT3hrM0FBQUFINHdmQVlKS29aSWh2Y05BUWNHb0c4d2JRSUJBREJvQmdrcWhraUc5dzBCQndFd0hnWUpZSVpJQVdVREJBRXVNQkVFREY3UFgxWk5nMVAwZVREdzlnSUJFSUE3T3pCTWNEZmlZdjkvWlIvcG5jdm9WbEwxUG1xNSt6VFUvaldXbU5Eckl4OUN4elVLaWwvdnBGbUlhTHJsTTlPMGxLQzlTMnZlZUwzR3JsWT0iLCJ2ZXJzaW9uIjoiMSIsInR5cGUiOiJEQVRBX0tFWSJ9"
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
