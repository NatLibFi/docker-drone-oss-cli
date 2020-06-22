FROM golang:1 AS builder

ARG TAG_PATTERN='v1*'

RUN git clone https://github.com/drone/drone-cli /src \
  && cd /src \  
  && git checkout `git tag -l $TAG_PATTERN|grep -E '^v[0-9\.]+$'|sort -r|head -n1` \    
  && ./.drone.sh
  
FROM alpine:3
ENTRYPOINT ["/app/bin/drone-cli"]

RUN apk add --no-cache ca-certificates
COPY --from=builder /src/release/linux/amd64/drone /app/bin/drone-cli