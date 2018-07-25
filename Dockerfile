FROM golang:1.9.2
ENV PORT 8080
COPY . /go/src/github.com/glower/hello-web
WORKDIR /go/src/github.com/glower/hello-web
RUN make install

FROM alpine:latest
RUN apk --no-cache add ca-certificates
COPY --from=0 /go/bin/service /bin/service
ENTRYPOINT ["/bin/service"]

EXPOSE $PORT
