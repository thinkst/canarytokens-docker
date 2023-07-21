ARG ARCH=amd64

FROM --platform=linux/${ARCH} python:3.9 as builder
MAINTAINER Marco Slaviero <marco@thinkst.com>

LABEL Description="This image provides the frontend site for Canarytokens" Vendor="Thinkst Applied Research" Version="1.4"
# setting the current directory
WORKDIR /
# removing PIP deprecation banners
ENV PIP_DISABLE_PIP_VERSION_CHECK=1

# concatenating RUN commands into a single image layer
RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates dnsutils fortune-mod fortunes gcc gnupg2 iproute2 jq \
        libffi-dev libncurses5-dev libreadline-dev libssl-dev libxml2-dev libxslt-dev \
        libz-dev locales lsb-release lsof make ncdu net-tools openssh-client \
        osslsigncode patch sudo unzip vim-tiny wget zip zlib1g && \
    rm -rf /var/lib/apt/lists/* && \
    python -m pip install poetry
ARG BRANCH=master
RUN wget -O archive.zip https://github.com/thinkst/canarytokens/archive/refs/heads/${BRANCH}.zip && \
    unzip archive.zip && \
    mv /canarytokens-*/* /srv && \
    rm -rf /canarytokens-* && \
    echo _COMMIT_HASH_ > /COMMIT_SHA

# discarding the build-stage image and adding a new one
# with only the necessary binaries/libraries to run the app
FROM builder as canary-tokens
# copy the working directory from the previous image into the final image
COPY --from=builder /srv /srv
# setting the working environment
WORKDIR /srv
RUN poetry install -E 'twisted web'

CMD echo "Please use the docker compose setup described at https://github.com/thinkst/canarytokens-docker"
