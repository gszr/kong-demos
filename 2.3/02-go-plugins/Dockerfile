FROM golang:alpine as builder
ENV GO111MODULE=on

RUN mkdir /go-plugins
COPY go-hello.go /go-plugins/
RUN cd /go-plugins && \
    go mod init go-plugins && \
    go mod tidy && \
    go build go-hello.go

FROM kong:2.3.3-alpine

COPY --from=builder /go-plugins/go-hello /usr/local/bin/
COPY config.yml /tmp/
