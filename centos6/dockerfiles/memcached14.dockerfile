
#
#    CentOS 6 (centos6) Memcached14 service (dockerfile)
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

FROM solict/general-purpose-system-distro:centos6_standard
MAINTAINER Luís Pedro Algarvio <lp.algarvio@gmail.com>

#
# Arguments
#

ARG app_memcached_user="memcached"
ARG app_memcached_group="memcached"
ARG app_memcached_home="/var/run/memcached"
ARG app_memcached_loglevel="notice"
ARG app_memcached_auth_sasl="no"
ARG app_memcached_listen_proto="auto"
ARG app_memcached_listen_addr="0.0.0.0"
ARG app_memcached_listen_port="11211"
ARG app_memcached_limit_backlog="256"
ARG app_memcached_limit_concurent="256"
ARG app_memcached_limit_memory="128"

#
# Packages
#

# Add foreign repositories and GPG keys
#  - remi-release: for Les RPM de remi pour Enterprise Linux 6 (Remi)
# Install the Memcached packages
#  - memcached: for memcached, the Memcached distributed memory object caching system server
RUN printf "Installing repositories and packages...\n" && \
    \
    printf "Install the repositories and refresh the GPG keys...\n" && \
    rpm --rebuilddb && \
    yum makecache && yum install -y \
      http://rpms.remirepo.net/enterprise/remi-release-6.rpm && \
    yum-config-manager --enable remi-safe remi && \
    gpg --refresh-keys && \
    printf "Install the Memcached packages...\n" && \
    yum makecache && yum install -y \
      memcached && \
    printf "Cleanup the Package Manager...\n" && \
    yum clean all && rm -Rf /var/lib/yum/*; \
    \
    printf "Finished installing repositories and packages...\n";

#
# Configuration
#

# Add users and groups
RUN printf "Adding users and groups...\n"; \
    \
    printf "Add memcached user and group...\n"; \
    id -g ${app_memcached_user} || \
    groupadd \
      --system ${app_memcached_group} && \
    id -u ${app_memcached_user} && \
    usermod \
      --gid ${app_memcached_group} \
      --home ${app_memcached_home} \
      --shell /sbin/nologin \
      ${app_memcached_user} \
    || \
    useradd \
      --system --gid ${app_memcached_group} \
      --no-create-home --home-dir ${app_memcached_home} \
      --shell /sbin/nologin \
      ${app_memcached_user}; \
    \
    printf "Finished adding users and groups...\n";

# Supervisor
RUN printf "Updading Supervisor configuration...\n"; \
    \
    # init is not working at this point \
    \
    # /etc/supervisord.conf \
    file="/etc/supervisord.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    printf "# Memcached\n\
[program:memcached]\n\
command=/bin/bash -c \"opts=\$(grep -o '^[^#]*' /etc/memcached.conf) && exec \$(which memcached) \$opts 2>&1 | logger -i -p local1.info -t memcached\"\n\
autostart=true\n\
autorestart=false\n\
\n" >> ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    printf "Finished updading Supervisor configuration...\n";

# Rsyslog
RUN printf "Updading Rsyslog configuration...\n"; \
    \
    # /etc/rsyslog.d/memcached.conf
    file="/etc/rsyslog.d/memcached.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    printf "# Memcached\n\
local1.debug  /var/log/memcached.log\n\
\n" > ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    printf "Finished Updading Rsyslog configuration...\n";

# Logrotate
RUN printf "Updading Logrotate configuration...\n"; \
    \
    # /etc/logrotate.d/memcached.conf \
    file="/etc/logrotate.d/memcached.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    printf "# Memcached\n\
/var/log/memcached.log {\n\
    weekly\n\
    rotate 4\n\
    dateext\n\
    missingok\n\
    create 0640 ${app_memcached_user} ${app_memcached_group}\n\
    compress\n\
    delaycompress\n\
    postrotate\n\
        supervisorctl restart memcached\n\
    endscript\n\
}\n\
\n" > ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    printf "Finished updading Logrotate configuration...\n";

# Memcached
RUN printf "Updading Memcached configuration...\n"; \
    \
    # /etc/sysconfig/memcached \
    file="/etc/sysconfig/memcached"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    # disable daemon/run in foreground \
    perl -0p -i -e "s>OPTIONS=\">OPTIONS=\"#-d >" ${file}; \
    # run as user \
    perl -0p -i -e "s>USER=.*>USER=\"${app_memcached_user}\">" ${file}; \
    # change log level \
    if [ "$app_memcached_loglevel" = "notice" ]; then app_memcached_loglevel_ovr="-v"; elif [ "$app_memcached_loglevel" = "verbose" ]; then app_memcached_loglevel_ovr="-vv"; else app_memcached_loglevel_ovr=""; fi; \
    perl -0p -i -e "s>OPTIONS=\">OPTIONS=\"${app_memcached_loglevel_ovr} >" ${file}; \
    # change interface \
    perl -0p -i -e "s>OPTIONS=\">OPTIONS=\"-l ${app_memcached_listen_addr} >" ${file}; \
    # change port \
    perl -0p -i -e "s>PORT=.*>PORT=\"${app_memcached_listen_port}\">" ${file}; \
    # change backlog queue limit \
    perl -0p -i -e "s>OPTIONS=\">OPTIONS=\"-b ${app_memcached_limit_backlog} >" ${file}; \
    # change max concurrent connections \
    perl -0p -i -e "s>MAXCONN=.*>MAXCONN=\"${app_memcached_limit_concurent}\">" ${file}; \
    # change max memory \
    perl -0p -i -e "s>CACHESIZE=.*>CACHESIZE=\"${app_memcached_limit_memory}\">" ${file}; \
    # change protocol to auto \
    perl -0p -i -e "s>OPTIONS=\">OPTIONS=\"-B ${app_memcached_listen_proto} >" ${file}; \
    # change SASL authentication \
    if [ "$app_memcached_auth_sasl" = "yes" ]; then app_memcached_auth_sasl="-S"; else app_memcached_auth_sasl=""; fi; \
    perl -0p -i -e "s>OPTIONS=\">OPTIONS=\"${app_memcached_auth_sasl} >" ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/memcached.conf \
    file="/etc/memcached.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    # clear old file \
    printf "#\n# memcached.conf\n#\n" > ${file}; \
    # disable daemon/run in foreground \
    printf "\n# Run memcached as a daemon.\n#-d\n" >> ${file}; \
    # run as user \
    printf "\n# Specify which user to run memcache on.\n-u ${app_memcached_user}\n" >> ${file}; \
    # change log level \
    if [ "$app_memcached_loglevel" = "notice" ]; then app_memcached_loglevel_ovr="-v"; elif [ "$app_memcached_loglevel" = "verbose" ]; then app_memcached_loglevel_ovr="-vv"; else app_memcached_loglevel_ovr=""; fi; \
    printf "\n# Be verbose\n${app_memcached_loglevel_ovr}\n" >> ${file}; \
    # change interface \
    printf "\n# Specify which IP address to listen on.\n-l ${app_memcached_listen_addr}\n" >> ${file}; \
    # change port \
    printf "\n# Default connection port is 11211\n-p ${app_memcached_listen_port}\n" >> ${file}; \
    # change backlog queue limit \
    printf "\n# Set the backlog queue limit (default: 1024)\n-b ${app_memcached_limit_backlog}\n" >> ${file}; \
    # change max concurrent connections \
    printf "\n# Limit the number of simultaneous incoming connections. The daemon default is 1024\n-c ${app_memcached_limit_concurent}\n" >> ${file}; \
    # change max memory \
    printf "\n# Limit the memory usage.\n-m ${app_memcached_limit_memory}\n" >> ${file}; \
    # change protocol to auto \
    printf "\n# Binding protocol - one of ascii, binary, or auto (default)\n-B ${app_memcached_listen_proto}\n" >> ${file}; \
    # change SASL authentication \
    if [ "$app_memcached_auth_sasl" = "yes" ]; then app_memcached_auth_sasl="-S"; else app_memcached_auth_sasl="#-S"; fi; \
    printf "\n# Turn on SASL authentication\n${app_memcached_auth_sasl}\n" >> ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    printf "\n# Testing configuration...\n"; \
    echo "Testing $(which memcached):"; $(which memcached) -i | grep "memcached"; \
    printf "Done testing configuration...\n"; \
    \
    printf "Finished updading Memcached configuration...\n";

