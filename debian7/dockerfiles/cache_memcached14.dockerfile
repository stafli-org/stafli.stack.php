
#
#    Debian 7 (wheezy) PHP Stack - Memcached14 Cache System (dockerfile)
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

FROM stafli/stafli.cache.memcached:memcached14_debian7

#
# Arguments
#

ARG app_memcached_user="memcache"
ARG app_memcached_group="memcache"
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

#
# Configuration
#

# Memcached
RUN printf "Updading Memcached configuration...\n"; \
    \
    # /etc/default/memcached \
    file="/etc/default/memcached"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    # enable memcached \
    perl -0p -i -e "s>ENABLE_MEMCACHED=.*>ENABLE_MEMCACHED=yes>" ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/memcached.conf \
    file="/etc/memcached.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    # disable daemon/run in foreground \
    perl -0p -i -e "s># information.\n.*-d\n># information.\n#-d\n>" ${file}; \
    # run as user \
    perl -0p -i -e "s># -u command is present in this config file\n.*-u .*\n># -u command is present in this config file\n-u ${app_memcached_user}\n>" ${file}; \
    # change log level \
    if [ "$app_memcached_loglevel" = "notice" ]; then app_memcached_loglevel_ovr="-v"; elif [ "$app_memcached_loglevel" = "verbose" ]; then app_memcached_loglevel_ovr="-vv"; else app_memcached_loglevel_ovr=""; fi; \
    perl -0p -i -e "s># Be verbose\n.*-v\n># Be verbose\n${app_memcached_loglevel_ovr}\n>" ${file}; \
    # change interface \
    perl -0p -i -e "s># it's listening on a firewalled interface.\n.*-l .*\n># it's listening on a firewalled interface.\n-l ${app_memcached_listen_addr}\n>" ${file}; \
    # change port \
    perl -0p -i -e "s># Default connection port is 11211\n.*-p .*\n># Default connection port is 11211\n-p ${app_memcached_listen_port}\n>" ${file}; \
    # change backlog queue limit \
    printf "\n# Set the backlog queue limit (default: 1024)\n-b ${app_memcached_limit_backlog}\n" >> ${file}; \
    # change max concurrent connections \
    perl -0p -i -e "s># Limit the number of simultaneous incoming connections. The daemon default is 1024\n.*-c .*\n># Limit the number of simultaneous incoming connections. The daemon default is 1024\n-c ${app_memcached_limit_concurent}\n>" ${file}; \
    # change max memory \
    perl -0p -i -e "s># memory\n.*-m .*\n># memory\n-m ${app_memcached_limit_memory}\n>" ${file}; \
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

