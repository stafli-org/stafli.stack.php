
#
#    CentOS 6 (centos6) PHP Stack - MariaDB10 RDBMS (dockerfile)
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

FROM stafli/stafli.mariadb.rdbms:centos6_mariadb10

#
# Arguments
#

ARG app_mariadb_user="mysql"
ARG app_mariadb_group="mysql"
ARG app_mariadb_home="/var/lib/mysql"
ARG app_mariadb_listen_addr="0.0.0.0"
ARG app_mariadb_listen_port="3306"

#
# Packages
#

#
# Configuration
#

# MariaDB
RUN printf "Updading MariaDB configuration...\n"; \
    \
    # ignoring /etc/sysconfig/mysql \
    \
    # ignoring /etc/my.cnf \
    \
    # /etc/my.cnf.d/server.cnf \
    file="/etc/my.cnf.d/server.cnf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    # run as user \
    perl -0p -i -e "s>\[server\]>\[server\]\nuser = ${app_mariadb_user}>" ${file}; \
    # change logging \
    perl -0p -i -e "s>\[server\]>\[server\]\nlog-error = /var/log/mysql/mariadb-error.log>" ${file}; \
    # change interface \
    perl -0p -i -e "s>\[server\]>\[server\]\nbind-address = ${app_mariadb_listen_addr}>" ${file}; \
    # change port \
    perl -0p -i -e "s>\[server\]>\[server\]\nport = ${app_mariadb_listen_port}>" ${file}; \
    # change performance settings \
    perl -0p -i -e "s>\[server\]>\[server\]\nmax_allowed_packet = 128M>" ${file}; \
    # storage engine \
    perl -0p -i -e "s>\[server\]>\[server\]\ndefault-storage-engine = InnoDB>" ${file}; \
    # change engine and collation \
    # https://stackoverflow.com/questions/3513773/change-mysql-default-character-set-to-utf-8-in-my-cnf \
    # https://www.percona.com/blog/2014/01/28/10-mysql-settings-to-tune-after-installation/ \
    # https://dev.mysql.com/doc/refman/5.6/en/charset-configuration.html \
    perl -0p -i -e "s>\[server\]>\[server\]\ncharacter-set-server = utf8>" ${file}; \
    perl -0p -i -e "s>\[server\]>\[server\]\ncollation-server = utf8_general_ci>" ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/my.cnf.d/client.cnf \
    file="/etc/my.cnf.d/client.cnf"; \
    touch ${file}; \
    printf "\n# Applying configuration for ${file}...\n"; \
    # add missing sections \
    printf "#\n\
# These two groups are read by the client library\n\
# Use it for options that affect all clients, but not the server\n\
#\n\n\n\
[client]\n\n\
# This group is not read by mysql client library,\n\
# If you use the same .cnf file for MySQL and MariaDB,\n\
# use it for MariaDB-only client options\n\
[client-mariadb]\n\n" >> ${file}; \
    # change protocol \
    perl -0p -i -e "s>\[client\]>\[client\]\nprotocol = tcp>" ${file}; \
    # change port \
    perl -0p -i -e "s>\[client\]>\[client\]\nport = ${app_mariadb_listen_port}>" ${file}; \
    # change engine and collation \
    # https://stackoverflow.com/questions/3513773/change-mysql-default-character-set-to-utf-8-in-my-cnf \
    # https://www.percona.com/blog/2014/01/28/10-mysql-settings-to-tune-after-installation/ \
    # https://dev.mysql.com/doc/refman/5.6/en/charset-configuration.html \
    perl -0p -i -e "s>\[client\]>\[client\]\ndefault-character-set = utf8>" ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/my.cnf.d/mysql-clients.cnf \
    file="/etc/my.cnf.d/mysql-clients.cnf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    # change performance settings \
    perl -0p -i -e "s>\[mysqldump\]>\[mysqldump\]\nquick\nquote-names\nmax_allowed_packet = 24M>" ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    printf "\n# Testing configuration...\n"; \
    echo "Testing $(which mysql):"; $(which mysql) -V; \
    echo "Testing $(which mysqld):"; $(which mysqld) -V; \
    printf "Done testing configuration...\n"; \
    \
    printf "Finished updading MariaDB configuration...\n";

