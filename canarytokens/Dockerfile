ARG ARCH=amd64

FROM --platform=linux/${ARCH} python:3.13 AS builder
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
    python -m pip install poetry==2.2.1
ARG BRANCH=master
RUN wget -O archive.zip https://github.com/thinkst/canarytokens/archive/refs/heads/${BRANCH}.zip && \
    unzip archive.zip && \
    mv /canarytokens-*/* /srv && \
    rm -rf /canarytokens-* && \
    echo _COMMIT_HASH_ > /COMMIT_SHA

# new stage for building the Vue frontend
FROM node:22 AS frontend-builder
ARG GOOGLE_MAPS_API_KEY
ARG CLOUDFLARE_TURNSTILE_SITE_KEY
ARG VITE_GITHUB_SHA

WORKDIR /build
COPY --from=builder /archive.zip /build/archive.zip
RUN unzip archive.zip && \
    mv /build/canarytokens-*/frontend_vue /build/frontend && \
    rm -rf /build/canarytokens-* /build/archive.zip
WORKDIR /build/frontend

# Install dependencies
RUN npm ci

# Create .env file with build-time variables
RUN touch .env && \
    echo "VITE_GITHUB_SHA=${VITE_GITHUB_SHA}" >> .env && \
    echo "VITE_GOOGLE_MAPS_API_KEY=${GOOGLE_MAPS_API_KEY}" >> .env && \
    echo "VITE_CLOUDFLARE_TURNSTILE_SITE_KEY=${CLOUDFLARE_TURNSTILE_SITE_KEY}" >> .env && \
    cat .env

# Build the frontend
RUN npm run build

# discarding the build-stage image and adding a new one
# with only the necessary binaries/libraries to run the app
FROM builder AS canary-tokens
# copy the working directory from the previous image into the final image
COPY --from=builder /srv /srv

# copy the built frontend assets
RUN rm -rf /srv/dist
COPY --from=frontend-builder /build/dist /srv/dist

# setting the working environment
WORKDIR /srv
RUN poetry install -E 'twisted web'

CMD echo "Please use the docker compose setup described at https://github.com/thinkst/canarytokens-docker"
