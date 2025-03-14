ARG GOLANG_VERSION="1.19.1"

FROM golang:$GOLANG_VERSION-alpine as builder
RUN apk --no-cache add tzdata
WORKDIR /go/src/github.com/serjs/socks5
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-s' -o ./socks5

FROM ctroncoso/alpine-autossh
COPY --from=builder /go/src/github.com/serjs/socks5/socks5 /
ADD docker-entrypoint.sh /usr/local/bin
#COPY ./.ssh /payload
ENTRYPOINT ["docker-entrypoint.sh"]
