APP?=service
PORT?=80080
CMD?=cmd/service/main.go
PROJECT?=github.com/glower/hello-web
RELEASE?=0.0.3
COMMIT?=$(shell git rev-parse --short HEAD)
BUILD_TIME?=$(shell date -u '+%Y-%m-%d_%H:%M:%S')
GOOS?=linux

LDFLAGS		+= -X ${PROJECT}/version.Release=$(RELEASE)
LDFLAGS		+= -X ${PROJECT}/version.Commit=$(COMMIT)
LDFLAGS		+= -X ${PROJECT}/version.BuildTime=$(BUILD_TIME)

clean:
	rm -f ${APP}

build: clean
	@echo "++ Building"
	CGO_ENABLED=0 GOOS=${GOOS} cd cmd/service && go build \
		-ldflags "$(LDFLAGS) -s -w" -o ${APP} .

install:
	@echo "++ Installing"
	CGO_ENABLED=0 GOOS=${GOOS} go install -ldflags "$(LDFLAGS) -w -s" $(PROJECT)/cmd/service

docker: build
	docker build -t welmoki/hello-web:latest .

run: docker
	docker stop $(APP):$(RELEASE) || true && docker rm $(APP):$(RELEASE) || true
	docker run --name ${APP} -p ${PORT}:${PORT} --rm -e "PORT=${PORT}" $(APP):$(RELEASE)

deploy: docker
	@echo "++ Pushing app latest build"
	docker push welmoki/hello-web:latest

test:
	@echo "++ Running tests for ${FOO}"
	go test -v -race ./...
