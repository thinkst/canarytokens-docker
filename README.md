# Dockerized Canarytokens
by Thinkst Applied Research

## Overview

Canarytokens help track activity and actions on your network.

If you have any issues please check out our FAQ over [here](https://github.com/thinkst/canarytokens/wiki#), or create an issue and we'll try to get back to you as soon as possible.

## Table of Contents
- [Code of Conduct](#code-of-conduct)
- [Prerequisites](#prerequisites)
- [Migrating to v3](#migrating-to-v3)
- [Setup (in Ubuntu)](#setup-in-ubuntu)
- [Persisting data](#persisting-data)
- [How to enable HTTPS](#how-to-enable-https)
- [Enabling Basic Auth to your Canarytokens Site](#enabling-basic-auth-to-your-canarytokens-site)
- [What's new?](#whats-new)
- [FAQ](#faq)
- [Contributing](#contributing)

## Code of Conduct

This project and everyone participating in it is governed by the
[Code of Conduct](https://github.com/thinkst/.github/blob/master/CODE_OF_CONDUCT.md).
By participating, you are expected to uphold this code. Please report unacceptable behavior
to github@thinkst.com.

## Prerequisites

* At least one domain name. If you want to enable PDF-opening tracking, at least two domains.
* Internet-facing Docker host. You can [install Docker on a Linux host](https://docs.docker.com/installation/) quickly.

## Migrating to v3

* Depending on whether you're using letsencrypt: `docker compose -f docker-compose.yml down`
  or `docker compose -f docker-compose-letsencrypt.yml down`
* If running on an older version of Docker, you will need to [upgrade](https://docs.docker.com/engine/install/).
* `docker-compose` no longer works, and you will need to run `docker network prune` before bringing up your Canarytokens instance with `docker compose`. Canarytokens v2 will still work.
* Pull the latest version of the `canarytokens-docker` repo.
* And correspondingly: `docker compose -f docker-compose.yml up -d`
  or `docker compose -f docker-compose-letsencrypt.yml up -d`


NB: The updated `canarytokens-docker` repo no longer has the Dockerfile for Canarytokens v2, so running that requires using the tagged image `thinkst/canarytokens:v2_latest`. We highly recommend moving to v3. Please contact us if you're battling with the migration.


## Setup (in Ubuntu)

* Boot your Docker host, and take note of the public IP.
* Configure your domains so that their nameservers point to the public IP of the Docker host. This requires a change at your Registrar. Simply changing NS records in the zone file is insufficient. You will need an A record of your domain pointing towards your public IP.
* Clone the Docker setup:
```
$ git clone https://github.com/thinkst/canarytokens-docker
$ cd canarytokens-docker
```
* Install Docker compose (if not already present):
```
$ sudo apt-get install python3-pip python3-dev
$ sudo pip install -U docker-compose
#if this breaks with PyYAML errors, install the libyaml development package
# sudo apt-get install libyaml-dev
```

* We distribute two .env files that will be used for configuration, namely  ```switchboard.env.dist``` and ```frontend.env.dist```. You'll need to copy/rename them to ```switchboard.env``` and  ```frontend.env``` respectively (this ensures that your configuration doesn't get blown away if you pull changes). Once that is done, you can edit them:

1) Please go through both your newly created configuration files, `switchboard.env` and `frontend.env`, and fill in the `Required Settings` section. The `Optional Settings` are not required to work and have sane defaults so don't change them if you don't need to.

2) Next decide on which email provider you want to use to send alerts. You will have to decide between `mailgun`, `SMTP` and `sendgrid`. The relevant required details can be found in the relevant `.env` file.

3) Generate a single unique WireGuard key seed to set as `CANARY_WG_PRIVATE_KEY_SEED` in both `switchboard.env` and `frontend.env` with the command:

```
dd bs=32 count=1 if=/dev/urandom 2>/dev/null | base64
```

* Here are example files for a setup that uses:
  * the domains example1.com, example2.com, and example3.com (PDFs) for canarytoken triggers via switchboard
  * the public IP 1.1.1.1 for the switchboard triggers
  * the domain 'my.domain' to serve the frontend
  * the Mailgun Domain Name 'x.y' and API Key 'zzzzzzzzzz'
  * the WireGuard key seed `vk/GD+frlhve/hDTTSUvqpQ/WsQtioKAri0Rt5mg7dw=`

  * frontend.env
```
#These domains are used for general purpose tokens
CANARY_PUBLIC_IP=1.1.1.1
CANARY_DOMAINS=example1.com,example2.com

#These domains are only used for PDF tokens
CANARY_NXDOMAINS=example3.com

#Requires a Google Cloud API key to generate an incident map on the history page with the Maps JavaScript API
CANARY_GOOGLE_API_KEY=<grab google maps api key>
LOG_FILE=frontend.log
```
  * switchboard.env (Example using Mailgun for email)
```
CANARY_PUBLIC_DOMAIN=mydomain.com
LOG_FILE=switchboard.log
CANARY_MAILGUN_DOMAIN_NAME=x.y
CANARY_MAILGUN_API_KEY=zzzzzzzzzz
CANARY_ALERT_EMAIL_FROM_ADDRESS=noreply@example.com
CANARY_ALERT_EMAIL_FROM_DISPLAY="Example Canarytokens"
CANARY_ALERT_EMAIL_SUBJECT="Canarytoken"
CANARY_WG_PRIVATE_KEY_SEED=vk/GD+frlhve/hDTTSUvqpQ/WsQtioKAri0Rt5mg7dw=
```
* Finally, download and initiate the images:
```
$ docker compose up
```
* The front end and switchboard will now be running in the foreground. The front end is accessible at http://example1.com/generate. If you wish to run this in the background, you may use
```
$ docker compose up -d
```

NOTE: If you only own one domain, and would like to use pdf tokens, you can use subdomains for `CANARY_NXDOMAINS`. Using `example.com` as our domain, you can set `CANARY_NXDOMAINS` to `nx.example.com`. Then log into your DNS manager console (where you can edit your domain DNS records) and add an NS record of `nx.example.com` mapping to `example.com`.

## Persisting data


The tokens are saved in a Redis database file that exists outside of the Docker containers. Look for ```dump.rdb``` in the ```canarytokens-docker/data``` directory.

If you want to wipe all your tokens, delete dump.rdb.

## How to enable HTTPS

We have a separate docker-compose file that will automate (mostly) getting you up and running a Canarytokens server with HTTPS.
You will need to do the following:

* Edit the ```certbot.env```. You will need to provide your domain and email address (these are necessary for the certbot's registration process).
E.g.
```
# Specify a single domain name
MY_DOMAIN_NAME=example.com

# or multiple domains names with this different key (comment out MY_DOMAIN_NAME above if you do):
# MY_DOMAIN_NAMES=example.com anotherexample.net thirdexample.org

EMAIL_ADDRESS=jay@example.com
```
* Now when you want to bring up your server, you will use ```docker compose -f docker-compose-letsencrypt.yml up``` which will run the
server in the foreground so you can make sure everything gets started alright.

* If everything is running, you may want to CTRL+C, run ```docker compose -f docker-compose-letsencrypt.yml down``` to get to a clean slate, and then rerun ```docker compose -f docker-compose-letsencrypt.yml up -d``` with the added ```-d``` to run the server in the background (in daemon mode)

* Please keep in mind that using the HTTPS method will use the email you specified and the domain name to register the certificate. You can read about the let's encrypt process (using cerbot) over [here](https://certbot.eff.org/lets-encrypt/ubuntuxenial-nginx). The process involves verifying that you are the owner of the domain you have specified and registering you with let's encrypt.

* THERE IS A RATE LIMIT. So don't keep bringing this server up and down otherwise you will quickly hit a let's encrypt certificate generation limit. To avoid this, for testing purposes you may add ```--staging``` to the ```./certbot-auto``` command in ```cerbot-nginx/start.sh``` which will test whether let's encrypt gives you the certificate.

## Enabling Basic Auth to your Canarytokens Site

You may follow these steps if you wish to have a public-facing canarytokens site but would like some basic auth to access it.

1. `git clone https://github.com/thinkst/canarytokens-docker.git`
2. Navigate to the nginx folder:
    - for HTTP:
    ```bash
    cd canarytokens-docker/nginx
    ```
    - for HTTPS:
    ```bash
    cd canarytokens-docker/certbot-nginx
    ```
3. `sudo htpasswd -c .htpasswd user` where `user` can be any username you would like to use.
4. `sudo chown <user>:<user> .htpasswd` where `user` is the local linux user
5. edit the appropriate `nginx.conf` and
  ```
  server {
      ...
      location ~* (/generate|/manage|/download|/history|/settings|/resources|/legal).* {
          auth_basic           "Basic Auth Restricted Canrytokens"; <---- ADD
          auth_basic_user_file /etc/nginx/.htpasswd;                 <---- ADD
  ```
6. edit the appropriate `Dockerfile` and add below `COPY nginx.conf ...`
  ```
  COPY .htpasswd /etc/nginx/.htpasswd
  ```
7. rebuild the images using:
    - for HTTP:
    ```bash
    docker compose build
    ```
    - for HTTPS:
    ```bash
    docker compose -f docker-compose-letsencrypt.yml build
    ```
  restart your docker containers, and enjoy!

Thanks, @mamisano for catching a silly issue using the above 🙏

## What's new?

We are going to track some new features/additions here so that it is quick and easy to see what has been recently added.

- we have moved the "What's new?" to Github Discussions. Check it out [here](https://github.com/thinkst/canarytokens-docker/discussions).

- we now have the capability of sending error logs to a webhook of your choice, hopefully alerting you
or your team to the failures as opposed to these errors only living in a log file.
Simply supply the corresponding webhook URI in the `ERROR_LOG_WEBHOOK` value in your switchboard.env file. (2021-04-09)

- we've renamed the distributed .env files to ```switchboard.env.dist``` and ```frontend.env.dist```. This ensures that your local
  configuration doesn't get blown away when you pull changes from the repo. (We still use ```switchboard.env``` and ```frontend.env```
  for the config, it just means that new clones of the repo require the users to copy/rename the dist files)

- we have added an extra `switchboard.env` called `CANARY_IPINFO_API_KEY`. This allows you to use your ipinfo.io API key if you
  want to (keep in mind ipinfo.io does have a free tier of up to 1000 requests a day).

- we now have slack support. When you supply a webhook, you simply supply your slack webhook URL. (Thanks to @shortstack).

- we have added a new environment variable to `frontend.env` called `CANARY_AWSID_URL` which allows you to specify a private or
  different URL for the AWS ID token. This means you can easily change between accounts. (2018-10-17)

- if you intend to build the image to be run on another system with different architecture, you can build the images with
  `docker compose build --build-arg ARCH=<target arch>/`, noting the forward slash at the end of the argument. The image will not build
  correctly if this is not included.

## FAQ

We have a FAQ over [here](https://github.com/thinkst/canarytokens-docker/wiki)

## Contributing

Please check out our [Code of Conduct](https://github.com/thinkst/.github/blob/master/CODE_OF_CONDUCT.md) and [Contributing](https://github.com/thinkst/.github/blob/master/CONTRIBUTING.md) documents before submitting a pull request.

We look forward to your valuable contributions.
