Dockerized Canarytokens
=======================
by Thinkst Applied Research

Overview
--------
Canarytokens helps track activity and actions on your network.

Prerequisites
-------------
* At least one domain name. If you want to enabled PDF-opening tracking, at least two domains.
* Internet-facing Docker host. You can [intall Docker on a Linux host](https://docs.docker.com/installation/) quickly.

Setup
-----
* Boot your Docker host, and take note of the public IP.
* Configure your domains so that their nameservers point to the public IP of the Docker host. This depends on your DNS provider (in Amazon's Route 53, changing NS records is sufficient.)
* Clone the Docker setup:
```
$ git clone https://github.com/thinkst/canarytokens-docker
$ cd canarytokens-docker
```
* Install Docker compose (if not already present):
```
$ sudo pip install -U docker-compose
#if this breaks with PyYAML errors, install the libyaml development package
# Ubuntu: sudo apt-get install libyaml-dev
```
* Configuration is held in the two .env files. Edit these. Here's example files for a setup that generates tokens on example1.com, example2.com and example3.com (PDFs), running on a host with public IP 1.1.1.1, using the Mandril API key 'xxxxxxxxxx':
  * frontend.ev
```
#These domains are used for general purpose tokens
CANARY_DOMAINS=example1.com,example2.com

#These domains are only used for PDF tokens
CANARY_NXDOMAINS=example3.com
```
  * switchboard.ev
```
CANARY_MANDRILL_API_KEY=xxxxxxxxxx
CANARY_PUBLIC_IP=1.1.1.1
CANARY_ALERT_EMAIL_FROM_ADDRESS=noreply@example.com
CANARY_ALERT_EMAIL_FROM_DISPLAY="Example Canarytokens"
CANARY_ALERT_EMAIL_SUBJECT="Canarytoken"
```
* Finally, download and instatiate the images:
```
$ docker-compose up
```
* Access the interface on http://example1.com/generate
