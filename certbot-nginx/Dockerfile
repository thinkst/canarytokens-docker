FROM nginx
MAINTAINER Thinkst Applied Research "jason@thinkst.com"

RUN apt-get update &&  apt-get install -y \
  wget \
  procps
RUN wget https://dl.eff.org/certbot-auto && chmod a+x ./certbot-auto
COPY nginx.conf /etc/nginx/nginx.conf
COPY start.sh /
CMD /start.sh