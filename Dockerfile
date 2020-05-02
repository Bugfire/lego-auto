# copied from https://github.com/go-acme/lego/blob/master/Dockerfile

FROM golang:1.13-alpine3.10 as builder

RUN apk --no-cache --no-progress add make git

WORKDIR /go/src/github.com/go-acme
RUN git clone --depth 1 https://github.com/go-acme/lego.git
COPY lego.strip.patch /go/src/github.com/go-acme/lego
WORKDIR /go/src/github.com/go-acme/lego
RUN patch -p0 < lego.strip.patch && make build

FROM alpine:3.10
RUN apk update \
    && apk add --no-cache ca-certificates tzdata curl \
    && update-ca-certificates

WORKDIR /app
COPY --from=builder /go/src/github.com/go-acme/lego/dist/lego /app
ADD scripts /app
ENTRYPOINT [ "/app/entry.sh" ]
