
#
#    Debian 7 (wheezy) PHP Stack - MariaDB10 RDBMS (dockerfile)
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

FROM stafli/stafli.rdbms.mariadb:mariadb10_debian7

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
    # ignoring /etc/default/mysql \
    \
    # /etc/mysql/my.cnf \
    file="/etc/mysql/my.cnf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    # run as user \
    perl -0p -i -e "s>user\t\t= .*>user\t\t= ${app_mariadb_user}>" ${file}; \
    # change logging \
    perl -0p -i -e "s>\[mysqld_safe\]>\[mysqld_safe\]\nlog-error       = /var/log/mysql/mariadb-error.log>" ${file}; \
    perl -0p -i -e "s># Error logging goes to syslog due to /etc/mysql/conf.d/mysqld_safe_syslog.cnf.\n#># Error logging goes to syslog due to /etc/mysql/conf.d/mysqld_safe_syslog.cnf.\n#\nlog-error               = /var/log/mysql/mariadb-error.log>" ${file}; \
    # change interface \
    perl -0p -i -e "s>bind-address\t\t= .*>bind-address\t\t= ${app_mariadb_listen_addr}>" ${file}; \
    # change port \
    perl -0p -i -e "s>port\t\t= .*>port\t\t= ${app_mariadb_listen_port}>g" ${file}; \
    # change protocol \
    perl -0p -i -e "s>\[client\]>\[client\]\nprotocol        = tcp>" ${file}; \
    # storage engine \
    perl -0p -i -e "s>\[mysqld\]>\[mysqld\]\ndefault-storage-engine = InnoDB>" ${file}; \
    # change performance settings \
    perl -0p -i -e "s>max_allowed_packet\t= .*>max_allowed_packet\t= 128M>" ${file}; \
    perl -0p -i -e "s>\[mysqldump\]\nquick\nquote-names\nmax_allowed_packet\t= .*>\[mysqldump\]\nquick\nquote-names\nmax_allowed_packet\t= 24M>" ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/mysql/conf.d/mariadb.cnf \
    file="/etc/mysql/conf.d/mariadb.cnf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    # change engine and collation \
    # https://stackoverflow.com/questions/3513773/change-mysql-default-character-set-to-utf-8-in-my-cnf \
    # https://www.percona.com/blog/2014/01/28/10-mysql-settings-to-tune-after-installation/ \
    # https://dev.mysql.com/doc/refman/5.6/en/charset-configuration.html \
    perl -0p -i -e "s>.*default-character-set = .*>default-character-set = utf8>" ${file}; \
    perl -0p -i -e "s>.*character-set-server  = .*>character-set-server  = utf8>" ${file}; \
    perl -0p -i -e "s>.*collation-server      = .*>collation-server      = utf8_general_ci>" ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    printf "\n# Testing configuration...\n"; \
    echo "Testing $(which mysql):"; $(which mysql) -V; \
    echo "Testing $(which mysqld):"; $(which mysqld) -V; \
    printf "Done testing configuration...\n"; \
    \
    printf "Finished updading MariaDB configuration...\n";

