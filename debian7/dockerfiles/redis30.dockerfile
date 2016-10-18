
#
#    Debian 7 (wheezy) Redis30 service (dockerfile)
#    Copyright (C) 2016 SOL-ICT
#    This file is part of the Docker High Performance PHP Stack.
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

FROM solict/general-purpose-system-distro:debian7_standard
MAINTAINER Luís Pedro Algarvio <lp.algarvio@gmail.com>

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
# Packages
#

# Add foreign repositories and GPG keys
#  - N/A: for Dotdeb
# Install the Redis packages
#  - redis-server: for redis-server, the Redis data structure server
#  - redis-tools: for redis-cli, the Redis data structure client
RUN printf "Installing repositories and packages...\n" && \
    \
    printf "Install the repositories and refresh the GPG keys...\n" && \
    printf "# Dotdeb repository\n\
deb http://packages.dotdeb.org wheezy all\n\
\n" > /etc/apt/sources.list.d/dotdeb.list && \
    apt-key adv --fetch-keys http://www.dotdeb.org/dotdeb.gpg && \
    gpg --refresh-keys && \
    printf "Install the Redis packages...\n" && \
    apt-get update && apt-get install -qy \
      redis-server redis-tools && \
    printf "Cleanup the Package Manager...\n" && \
    apt-get clean && rm -rf /var/lib/apt/lists/*; \
    \
    printf "Finished installing repositories and packages...\n";

#
# Configuration
#

# Add users and groups
RUN printf "Adding users and groups...\n"; \
    \
    printf "Add redis user and group...\n"; \
    id -g ${app_redis_user} || \
    groupadd \
      --system ${app_redis_group} && \
    id -u ${app_redis_user} && \
    usermod \
      --gid ${app_redis_group} \
      --home ${app_redis_home} \
      --shell /usr/sbin/nologin \
      ${app_redis_user} \
    || \
    useradd \
      --system --gid ${app_redis_group} \
      --no-create-home --home-dir ${app_redis_home} \
      --shell /usr/sbin/nologin \
      ${app_redis_user}; \
    \
    printf "Finished adding users and groups...\n";

# Supervisor
RUN printf "Updading Supervisor configuration...\n"; \
    \
    # /etc/supervisor/conf.d/init.conf \
    file="/etc/supervisor/conf.d/init.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    perl -0p -i -e "s>supervisorctl start dropbear;>supervisorctl start dropbear; supervisorctl start redis;>" ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/supervisor/conf.d/redis.conf \
    file="/etc/supervisor/conf.d/redis.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    printf "# redis\n\
[program:redis]\n\
command=/bin/bash -c \"\$(which redis-server) /etc/redis/redis.conf --daemonize no\"\n\
autostart=false\n\
autorestart=true\n\
\n" > ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    printf "Finished updading Supervisor configuration...\n";

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
    printf "Finished updading Redis configuration...\n";

