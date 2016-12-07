FROM ubuntu:16.04
MAINTAINER Heiko Hüter <ender@ender74.de>

RUN apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install --no-install-recommends -y subversion apache2 \
      libapache2-svn \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* /root/.cache /tmp/* \
    && mkdir -p /srv/svn/playground \
    && svnadmin create --fs-type fsfs /srv/svn/playground \
    && chown -R www-data:www-data /srv/svn/playground \
    && a2enmod dav_svn \
    && touch /srv/dav_svn.passwd \
    && htpasswd -b /srv/dav_svn.passwd user 1234

ADD dav_svn.conf /etc/apache2/mods-enabled/
EXPOSE 80
VOLUME ["/srv"]

CMD ["apachectl", "-D", "FOREGROUND"]
