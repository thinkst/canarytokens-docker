FROM nginx
MAINTAINER Marco Slaviero <marco@thinkst.com>
LABEL Description="This image provides the http proxy for Canarytokens" Vendor="Thinkst Applied Research" Version="1.3"
COPY nginx.conf /etc/nginx/nginx.conf
COPY conf.d/blocked_tokens.conf /etc/nginx/conf.d/blocked_tokens.conf
