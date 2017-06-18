.PHONY: all

build-lx:## Build agent binaries
	GOOS=linux go build -o $(CURDIR)/bin/main main.go

run-lx:## Build agent binaries
	docker run -it --volume=$(CURDIR)/bin:/go/src/github.com/andrepinto/simpleserver/bin  demo/ss:0.0.1 env GOOS=linux GOARCH=amd64 go build -ldflags="-s -w -X main.Version=1" -o bin/server main.go

bundle:
	glide install