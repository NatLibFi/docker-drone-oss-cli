FROM golang:1 AS builder

RUN git clone https://github.com/drone/drone-cli /src \
  && cd /src \
  && ./.drone.sh
  
FROM alpine:3
ENTRYPOINT ["/app/bin/drone-cli"]

RUN apk add --no-cache ca-certificates
COPY --from=builder /src/release/linux/amd64/drone /app/bin/drone-cli