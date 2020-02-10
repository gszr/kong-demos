FROM golang:alpine as builder

RUN apk add --no-cache git gcc libc-dev
RUN go get github.com/Kong/go-pluginserver

RUN mkdir /go-plugins
COPY go-hello.go /go-plugins/
RUN go build -buildmode plugin -o /go-plugins/go-hello.so /go-plugins/go-hello.go

FROM kong:2.0.1-alpine

COPY --from=builder /go/bin/go-pluginserver /usr/local/bin/
RUN mkdir /tmp/go-plugins
COPY --from=builder /go-plugins/go-hello.so /tmp/go-plugins
COPY config.yml /tmp/
