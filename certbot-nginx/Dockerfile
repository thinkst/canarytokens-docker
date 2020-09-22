FROM nginx
MAINTAINER Thinkst Applied Research "jason@thinkst.com"
LABEL Description="This image provides the http proxy for Canarytokens" Vendor="Thinkst Applied Research" Version="1.0"

RUN apt-get update &&  apt-get install -y \
  wget \
  procps

RUN wget https://dl.eff.org/certbot-auto && chmod a+x ./certbot-auto
RUN ./certbot-auto --install-only -n
COPY nginx.conf /etc/nginx/nginx.conf
COPY start.sh /
CMD /start.sh
