
#
#    Debian 8 (jessie) PHP Stack - Redis32 Cache System (dockerfile)
#    Copyright (C) 2016-2017 Stafli
#    Luís Pedro Algarvio
#    This file is part of the Stafli Application Stack.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

#
# Build
#

# Base image to use
FROM stafli/stafli.cache.redis:redis32_debian8

# Labels to apply
LABEL description="Stafli PHP Stack (stafli/stafli.stack.php), Based on Stafli Memcached Cache (stafli/stafli.cache.memcached), Stafli Redis Cache (stafli/stafli.cache.redis), Stafli MariaDB Cache (stafli/stafli.rdbms.mariadb), Stafli PHP Language (stafli/stafli.language.php), Stafli HTTPd Web Server (stafli/stafli.web.httpd) and Stafli HTTPd Proxy Server (stafli/stafli.proxy.httpd)" \
      maintainer="lp@algarvio.org" \
      org.label-schema.schema-version="1.0.0-rc.1" \
      org.label-schema.name="Stafli PHP Stack (stafli/stafli.stack.php)" \
      org.label-schema.description="Based on Stafli Memcached Cache (stafli/stafli.cache.memcached), Stafli Redis Cache (stafli/stafli.cache.redis), Stafli MariaDB Cache (stafli/stafli.rdbms.mariadb), Stafli PHP Language (stafli/stafli.language.php), Stafli HTTPd Web Server (stafli/stafli.web.httpd) and Stafli HTTPd Proxy Server (stafli/stafli.proxy.httpd)" \
      org.label-schema.keywords="stafli, stack, memcached, redis, mariadb, php, httpd, debian, centos" \
      org.label-schema.url="https://stafli.org/" \
      org.label-schema.license="GPLv3" \
      org.label-schema.vendor-name="Stafli" \
      org.label-schema.vendor-email="info@stafli.org" \
      org.label-schema.vendor-website="https://www.stafli.org" \
      org.label-schema.authors.lpalgarvio.name="Luis Pedro Algarvio" \
      org.label-schema.authors.lpalgarvio.email="lp@algarvio.org" \
      org.label-schema.authors.lpalgarvio.homepage="https://lp.algarvio.org" \
      org.label-schema.authors.lpalgarvio.role="Maintainer" \
      org.label-schema.registry-url="https://hub.docker.com/r/stafli/stafli.stack.php" \
      org.label-schema.vcs-url="https://github.com/stafli-org/stafli.stack.php" \
      org.label-schema.vcs-branch="master" \
      org.label-schema.os-id="debian" \
      org.label-schema.os-version-id="8" \
      org.label-schema.os-architecture="amd64" \
      org.label-schema.version="1.0"

#
# Arguments
#

ARG app_redis_user="redis"
ARG app_redis_group="redis"
ARG app_redis_home="/var/lib/redis"
ARG app_redis_loglevel="notice"
ARG app_redis_listen_addr="0.0.0.0"
ARG app_redis_listen_port="6379"
ARG app_redis_listen_timeout="5"
ARG app_redis_listen_keepalive="60"
ARG app_redis_limit_backlog="256"
ARG app_redis_limit_concurent="256"
ARG app_redis_limit_memory="134217728"

#
# Environment
#

# Working directory to use when executing build and run instructions
# Defaults to /.
#WORKDIR /

# User and group to use when executing build and run instructions
# Defaults to root.
#USER root:root

#
# Packages
#

#
# Configuration
#

# Redis
RUN printf "Updading Redis configuration...\n"; \
    \
    # ignoring /etc/default/redis-server
    \
    # /etc/redis/redis.conf \
    file="/etc/redis/redis.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    # disable daemon/run in foreground \
    perl -0p -i -e "s># Note that Redis will write a pid file in /var/run/redis.pid when daemonized.\ndaemonize .*\n># Note that Redis will write a pid file in /var/run/redis.pid when daemonized.\ndaemonize no\n>" ${file}; \
    # change log level \
    perl -0p -i -e "s># warning (only very important / critical messages are logged)\nloglevel .*\n># warning (only very important / critical messages are logged)\nloglevel ${app_redis_loglevel}\n>" ${file}; \
    # change interface \
    perl -0p -i -e "s># ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\nbind .*\n># ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\nbind ${app_redis_listen_addr}\n>" ${file}; \
    # change port \
    perl -0p -i -e "s># If port 0 is specified Redis will not listen on a TCP socket.\nport .*\n># If port 0 is specified Redis will not listen on a TCP socket.\nport ${app_redis_listen_port}\n>" ${file}; \
    # change timeout \
    perl -0p -i -e "s># Close the connection after a client is idle for N seconds \(0 to disable\)\ntimeout .*\n># Close the connection after a client is idle for N seconds \(0 to disable\)\ntimeout ${app_redis_listen_timeout}\n>" ${file}; \
    # change keepalive \
    perl -0p -i -e "s># A reasonable value for this option is 60 seconds.\ntcp-keepalive .*\n># A reasonable value for this option is 60 seconds.\ntcp-keepalive ${app_redis_listen_keepalive}\n>" ${file}; \
    # change backlog \
    perl -0p -i -e "s># in order to get the desired effect.\ntcp-backlog .*\n># in order to get the desired effect.\ntcp-backlog ${app_redis_limit_backlog}\n>" ${file}; \
    # change max clients \
    perl -0p -i -e "s># an error 'max number of clients reached'.\n#\n# maxclients 10000\n># an error 'max number of clients reached'.\n#\n# maxclients 10000\nmaxclients ${app_redis_limit_concurent}\n>" ${file}; \
    # change max memory \
    perl -0p -i -e "s># output buffers \(but this is not needed if the policy is \'noeviction\'\).\n#\n# maxmemory <bytes\>># output buffers \(but this is not needed if the policy is \'noeviction\'\).\n#\n# maxmemory <bytes\>\nmaxmemory ${app_redis_limit_memory}>" ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    printf "\n# Testing configuration...\n"; \
    echo "Testing $(which redis-cli):"; $(which redis-cli) -v; \
    echo "Testing $(which redis-server):"; $(which redis-server) -v; \
    printf "Done testing configuration...\n"; \
    \
    printf "Finished updading Redis configuration...\n";

#
# Run
#

# Command to execute
# Defaults to /bin/bash.
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf", "--nodaemon"]

# Ports to expose
# Defaults to 6379
EXPOSE ${app_redis_listen_port}

