
#
#    Debian 7 (wheezy) MariaDB10 service (dockerfile)
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

ARG app_mariadb_user="mysql"
ARG app_mariadb_group="mysql"
ARG app_mariadb_home="/var/lib/mysql"
ARG app_mariadb_listen_addr="0.0.0.0"
ARG app_mariadb_listen_port="3306"

#
# Packages
#

# Add foreign repositories and GPG keys
#  - N/A: for MariaDB
# Install the MariaDB packages
#  - mariadb-server: for mysqld, the MariaDB relational database management system server
#  - mariadb-client: for mysql, the MariaDB relational database management system client
#  - mytop: for mytop, the MariaDB relational database management system top-like utility
RUN printf "Installing repositories and packages...\n" && \
    \
    printf "Install the repositories and refresh the GPG keys...\n" && \
    printf "# MariaDB repository\n\
deb http://lon1.mirrors.digitalocean.com/mariadb/repo/10.1/debian wheezy main\n\
\n" > /etc/apt/sources.list.d/mariadb.list && \
    apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db && \
    gpg --refresh-keys && \
    printf "Install the MariaDB packages...\n" && \
    apt-get update && apt-get install -qy \
      mariadb-server mariadb-client mytop && \
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
    printf "Add mariadb user and group...\n"; \
    id -g ${app_mariadb_user} || \
    groupadd \
      --system ${app_mariadb_group} && \
    id -u ${app_mariadb_user} && \
    usermod \
      --gid ${app_mariadb_group} \
      --home ${app_mariadb_home} \
      --shell /usr/sbin/nologin \
      ${app_mariadb_user} \
    || \
    useradd \
      --system --gid ${app_mariadb_group} \
      --no-create-home --home-dir ${app_mariadb_home} \
      --shell /usr/sbin/nologin \
      ${app_mariadb_user}; \
    \
    printf "Finished adding users and groups...\n";

# Supervisor
RUN printf "Updading Supervisor configuration...\n"; \
    \
    # /etc/supervisor/conf.d/init.conf \
    file="/etc/supervisor/conf.d/init.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    perl -0p -i -e "s>supervisorctl start dropbear;>supervisorctl start dropbear; supervisorctl start mysql;>" ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/supervisor/conf.d/mysql.conf \
    file="/etc/supervisor/conf.d/mysql.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    printf "# MariaDB\n\
[program:mysql]\n\
command=/bin/bash -c \"\$(which mysqld_safe) --defaults-file=/etc/mysql/my.cnf\"\n\
autostart=false\n\
autorestart=true\n\
\n" > ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    printf "Finished updading Supervisor configuration...\n";

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
    printf "Finished updading MariaDB configuration...\n";

