# copied from https://github.com/go-acme/lego/blob/master/Dockerfile

FROM golang:1-alpine as builder

RUN apk --no-cache --no-progress add make git

WORKDIR /go
RUN git clone --depth 1 https://github.com/go-acme/lego.git
COPY lego.strip.patch /go/lego

WORKDIR /go/lego

ENV GO111MODULE on

RUN make build

FROM alpine:3
RUN apk update \
    && apk add --no-cache ca-certificates tzdata curl \
    && update-ca-certificates

COPY --from=builder /go/lego/dist/lego /usr/bin/lego

WORKDIR /app
ADD scripts /app
ENTRYPOINT [ "/app/entry.sh" ]
