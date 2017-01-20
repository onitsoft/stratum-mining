FROM python:2.7

RUN apt-get update && apt-get install -y \
    git \
    python-twisted \
    python-mysqldb \
    python-dev \
    python-setuptools \
    python-memcache \
    python-simplejson \
    python-pylibmc \
    build-essential

ADD . /root/stratum-mining
RUN easy_install -U distribute
RUN cd /root/stratum-mining \
    && git submodule init \
    && git submodule update
RUN cd /root/stratum-mining/externals/litecoin_scrypt \
    && python setup.py install
RUN cd /root/stratum-mining/externals/stratum \
    && python setup.py install \
    && cd /root/stratum-mining
RUN chmod +x /root/stratum-mining/entrypoint.sh

RUN sed -i '0,/re/s/autobahn.websocket/autobahn.twisted.websocket/g' /usr/local/lib/python2.7/site-packages/stratum-0.2.13-py2.7.egg/stratum/websocket_transport.py

WORKDIR /root/stratum-mining
