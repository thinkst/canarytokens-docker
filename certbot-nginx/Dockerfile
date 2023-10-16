FROM nginx
LABEL Author="Thinkst Applied Research"
LABEL Description="This image provides the http proxy for Canarytokens" Vendor="Thinkst Applied Research" Version="2.1"

RUN apt-get update &&  apt-get install -y \
  wget \
  procps \
  certbot \
  python3-certbot-nginx

COPY nginx.conf /etc/nginx/nginx.conf
COPY conf.d/blocked_tokens.conf /etc/nginx/conf.d/blocked_tokens.conf
COPY start.sh /
CMD /start.sh
