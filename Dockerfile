FROM phusion/baseimage
MAINTAINER Matt Edlefsen <matt@xforty.com>

CMD ["/sbin/my_init"]

RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD build9p.sh /root/build9p.sh
