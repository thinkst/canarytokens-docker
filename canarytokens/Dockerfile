FROM ubuntu:16.04
MAINTAINER Marco Slaviero <marco@thinkst.com>
LABEL Description="This image provides the frontend site for Canarytokens" Vendor="Thinkst Applied Research" Version="1.4"
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates wget python-pip unzip osslsigncode gcc python-dev libreadline-dev libncurses5-dev libffi-dev gcc patch make libxslt-dev libxml2-dev libz-dev fortune-mod fortunes libssl-dev && rm -rf /var/lib/apt/lists/*
WORKDIR /
RUN pip install -U setuptools
RUN pip install --upgrade pip
RUN pip install --no-cache-dir pyOpenSSL==16.2.0
RUN pip install --no-cache-dir Jinja2==2.9.4
RUN pip install --no-cache-dir MarkupSafe==0.23
RUN pip install --no-cache-dir Twisted==15.2.1
RUN pip install --no-cache-dir cssselect==0.9.1
RUN pip install --no-cache-dir docopt==0.4.0
RUN pip install --no-cache-dir gnureadline==6.3.3
RUN pip install --no-cache-dir httplib2==0.9.1
RUN pip install --no-cache-dir lxml==3.4.4
RUN pip install --no-cache-dir mandrill==1.0.57
RUN pip install --no-cache-dir pytz==2015.4
RUN pip install --no-cache-dir redis==2.10.3
RUN pip install --no-cache-dir requests==2.20.0
RUN pip install --no-cache-dir simplejson==3.7.3
RUN pip install --no-cache-dir six==1.10.0
RUN pip install --no-cache-dir twilio==4.4.0
RUN pip install --no-cache-dir twill==1.8.0
RUN pip install --no-cache-dir wsgiref==0.1.2
RUN pip install --no-cache-dir zope.interface==4.1.2
RUN pip install --no-cache-dir PyQRCode==1.2.1
RUN pip install --no-cache-dir pypng==0.0.18
RUN pip install --no-cache-dir htmlmin==0.1.10
RUN pip install --no-cache-dir sendgrid==3.6.5
RUN pip install --no-cache-dir service_identity

RUN wget -O master.zip https://github.com/thinkst/canarytokens/archive/master.zip?step=21
RUN unzip master.zip
RUN mv /canarytokens-master/* /srv
RUN rm -rf /canarytokens-master
WORKDIR /srv

CMD echo "Please use the docker-compose setup described at https://github.com/thinkst/canarytokens-docker"
