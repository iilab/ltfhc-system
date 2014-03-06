FROM stackbrew/ubuntu:saucy

MAINTAINER iilab tech@iilab.org

# need the ltfhc-system git repo checked out.
ADD ltfhc-system/etc/nginx/health.docker /etc/nginx/sites-available/health
ADD ltfhc-system/etc/couchdb/local.d/ltfhc.ini /etc/couchdb/local.d/ltfhc.ini
ADD ltfhc-system/etc/apt/sources.list.d/universe.list /etc/apt/sources.list.d/universe.list

# install our packages
RUN apt-get update
RUN apt-get install software-properties-common -y
RUN apt-add-repository ppa:novacut/stable
RUN apt-get update
RUN apt-get install supervisor ssl-cert couchdb nginx --force-yes

# Make sure our own config is the only one.
RUN rm -f /etc/nginx/sites-enabled/*
RUN ln -sf /etc/nginx/sites-available/health /etc/nginx/sites-enabled/health

EXPOSE 443
