FROM alpine:3.23.3

LABEL maintainer="Vadim Fabi <vaad.fabi@gmail.com>"
ARG TARGETARCH
ARG APP_NAME=open-ports-scanner
ARG APP_VERSION=1.0.0
ENV APP_NAME=${APP_NAME}
ENV APP_VERSION=${APP_VERSION}

RUN apk add --update --no-cache python3 nmap curl
ADD app /app
RUN mkdir /app/data
RUN chmod -R 755 /app
WORKDIR /app

ENTRYPOINT ["/app/entrypoint.sh"]
