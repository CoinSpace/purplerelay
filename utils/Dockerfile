FROM ubuntu:jammy as build
ENV TZ=Europe/London
WORKDIR /build
RUN apt update && apt install -y --no-install-recommends \
    git g++ make pkg-config libtool ca-certificates \
    libyaml-perl libtemplate-perl libregexp-grammars-perl libssl-dev zlib1g-dev \
    liblmdb-dev libflatbuffers-dev libsecp256k1-dev \
    libzstd-dev

COPY . .
RUN git submodule update --init
RUN make setup-golpe
RUN make -j4

FROM ubuntu:jammy as runner
RUN apt update && apt install -y --no-install-recommends \
    liblmdb0 libflatbuffers1 libsecp256k1-0 libb2-1 libzstd1 \
    && rm -rf /var/lib/apt/lists/*
COPY --from=build /build/strfry ./strfry
COPY ./strfry-db ./strfry-db
COPY ./strfry.conf ./etc/strfry.conf

RUN apt-get update
RUN apt install nginx -y


RUN apt install curl -y
RUN set -e; \
    apt-get update -y && apt-get install -y \
    gnupg2 \
    tini \
    lsb-release; \
    gcsFuseRepo=gcsfuse-`lsb_release -c -s`; \
    echo "deb http://packages.cloud.google.com/apt $gcsFuseRepo main" | \
    tee /etc/apt/sources.list.d/gcsfuse.list; \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
    apt-key add -; \
    apt-get update; \
    apt-get install -y gcsfuse && apt-get clean
ENV MNT_DIR ./strfry-db

COPY ./STAR.purplerelay.com.key /etc/ssl/STAR.purplerelay.com.key
COPY ./ssl-bundle.crt /etc/ssl/ssl-bundle.crt

COPY --from=build ./build/nginx/nginx.conf ./
COPY --from=build ./build/nginx/new.default.conf ./

RUN cp -r ./nginx.conf /etc/nginx/nginx.conf
RUN cp -r ./new.default.conf /etc/nginx/sites-enabled/default.conf

# COPY ./nginx/default.conf ./etc/nginx/sites-enabled/default.conf
COPY ./run.sh ./run.sh
RUN chmod +x ./run.sh

COPY ./setup_gcloud_cli.sh ./setup_gcloud_cli.sh
RUN chmod +x ./setup_gcloud_cli.sh
RUN ./setup_gcloud_cli.sh
COPY ./application_default_credentials.json ./$HOME/.config/gcloud/application_default_credentials.json

EXPOSE 80
EXPOSE 443
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["./run.sh"]
