FROM ubuntu:18.04 as builder

MAINTAINER Marco Slaviero <marco@thinkst.com>

LABEL Description="This image provides the frontend site for Canarytokens" Vendor="Thinkst Applied Research" Version="1.4"
# setting the current directory
WORKDIR /
# uploading PIP requirements file into the base image
COPY requirements.txt ./
# removing PIP deprecation banners
ENV PIP_DISABLE_PIP_VERSION_CHECK=1
# concatenating RUN commands into a single image layer
# installing PIP requirements from requirements.txt file
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates \
    wget python-pip unzip osslsigncode gcc python-dev libreadline-dev \
    libncurses5-dev libffi-dev gcc patch make libxslt-dev libxml2-dev \
    libz-dev fortune-mod fortunes libssl-dev && \
    rm -rf /var/lib/apt/lists/* && \
    pip install -U setuptools && \
    pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    wget -O master.zip https://github.com/thinkst/canarytokens/archive/master.zip?step=1 && \
    unzip master.zip && \
    mv /canarytokens-master/* /srv && \
    rm -rf /canarytokens-master
# discarding the build-stage image and adding a new one
# with only the necessary binaries/libraries to run the app
FROM builder as canary-tokens
# copy the working directory from the previous image into the final image
COPY --from=builder /srv /srv
# seting the working environment
WORKDIR /srv

CMD echo "Please use the docker-compose setup described at https://github.com/thinkst/canarytokens-docker"