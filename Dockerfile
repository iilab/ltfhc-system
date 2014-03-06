FROM stackbrew/ubuntu:saucy

MAINTAINER iilab tech@iilab.org

# need the ltfhc-system git repo checked out.
ADD etc/nginx/health.docker /etc/nginx/sites-available/health
ADD etc/couchdb/local.d/ltfhc.ini /etc/couchdb/local.d/ltfhc.ini
ADD etc/apt/sources.list.d/universe.list /etc/apt/sources.list.d/universe.list
ADD etc/supervisor/conf.d/supervisord.conf /etc/supervisor/conf.d/supervisord.conf 

# install our packages
RUN apt-get update
RUN apt-get install software-properties-common -y
RUN apt-add-repository ppa:novacut/stable
RUN apt-add-repository ppa:chris-lea/node.js
RUN apt-get update
RUN apt-get install nodejs supervisor ssl-cert couchdb nginx --force-yes -y

# Run nginx in the foreground for supervisord
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# Make sure our own config is the only one.
RUN rm -f /etc/nginx/sites-enabled/*
RUN ln -sf /etc/nginx/sites-available/health /etc/nginx/sites-enabled/health

RUN mkdir /var/run/couchdb
RUN chown couchdb:couchdb /var/run/couchdb

EXPOSE 443 5984
CMD ["/usr/bin/supervisord"]
