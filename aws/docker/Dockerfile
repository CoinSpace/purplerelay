# Built by Akito
# npub1wprtv89px7z2ut04vvquscpmyfuzvcxttwy2csvla5lvwyj807qqz5aqle

FROM alpine:3.18.3 AS build

ENV TZ=Europe/London

WORKDIR /build

COPY . .

RUN \
  apk --no-cache add \
    linux-headers \
    git \
    g++ \
    make \
    pkgconfig \
    libtool \
    ca-certificates \
    perl-yaml \
    perl-template-toolkit \
    perl-app-cpanminus \
    libressl-dev \
    zlib-dev \
    lmdb-dev \
    flatbuffers-dev \
    libsecp256k1-dev \
    zstd-dev \
    nginx \
  && rm -rf /var/cache/apk/* \
  && cpanm Regexp::Grammars \
  && git submodule update --init \
  && make setup-golpe \
  && make -j4

FROM alpine:3.18.3
ENV MNT_DIR ./strfry-db

WORKDIR /app

RUN \
  apk --no-cache add \
    lmdb \
    flatbuffers \
    libsecp256k1 \
    libb2 \
    zstd \
    libressl \
  && rm -rf /var/cache/apk/*

RUN \
  apk --no-cache add \
    nginx \
    curl \
    lsb-release \
    fuse \
    fuse-dev \
    git \
    python3 \
    py3-crcmod \
    libc6-compat \
    openssh-client \
  && rm -rf /var/cache/apk/*

COPY --from=build /build/strfry strfry

COPY ./STAR.purplerelay.com.key /etc/ssl/STAR.purplerelay.com.key
COPY ./ssl-bundle.crt /etc/ssl/ssl-bundle.crt

COPY --from=build ./build/nginx.conf ./
COPY --from=build ./build/default.conf ./
RUN mkdir -p /var/www/media
COPY --from=build ./build/favicon.ico /var/www/media/favicon.ico

RUN curl -fsSL https://deno.land/install.sh | sh

COPY ./strfry.conf /etc/strfry.conf
COPY ./strfry-router.config /etc/strfry-router.config
COPY ./strfry-policy.ts /opt/strfry-policy.ts
COPY ./strfry-db ./strfry-db

RUN chmod +x /opt/strfry-policy.ts

COPY ./entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh

EXPOSE 80
EXPOSE 443
