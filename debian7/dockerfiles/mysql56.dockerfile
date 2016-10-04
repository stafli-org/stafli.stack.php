
#
#    Debian 7 (wheezy) MySQL56 profile (dockerfile)
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

ARG app_mysql_user="mysql"
ARG app_mysql_group="mysql"
ARG app_mysql_home="/var/lib/mysql"
ARG app_mysql_listen_addr="0.0.0.0"
ARG app_mysql_listen_port="3306"

#
# Packages
#

# Add foreign repositories and GPG keys
#  - N/A: for Dotdeb
# Install the MySQL packages
#  - mysql-server-5.6: for mysqld, the MySQL relational database management system server
#  - mysql-client-5.6: for mysql, the MySQL relational database management system client
#  - mytop: for mytop, the MySQL relational database management system top-like utility
RUN printf "# Install the repositories and refresh the GPG keys...\n" && \
    printf "# Dotdeb repository\n\
deb http://packages.dotdeb.org wheezy all\n\
\n" > /etc/apt/sources.list.d/dotdeb.list && \
    apt-key adv --fetch-keys http://www.dotdeb.org/dotdeb.gpg && \
    gpg --refresh-keys && \
    printf "# Install the MySQL packages...\n" && \
    apt-get update && apt-get install -qy \
      mysql-server-5.6 mysql-client-5.6 mytop && \
    printf "# Cleanup the Package Manager...\n" && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

#
# Configuration
#

# Add users and groups
RUN printf "Adding users and groups...\n"; \
    id -g ${app_mysql_user} || \
    groupadd \
      --system ${app_mysql_group} && \
    id -u ${app_mysql_user} && \
    usermod \
      --gid ${app_mysql_group} \
      --home ${app_mysql_home} \
      --shell /usr/sbin/nologin \
      ${app_mysql_user} \
    || \
    useradd \
      --system --gid ${app_mysql_group} \
      --no-create-home --home-dir ${app_mysql_home} \
      --shell /usr/sbin/nologin \
      ${app_mysql_user};

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
    printf "# mysql\n\
[program:mysql]\n\
command=/bin/bash -c \"\$(which mysqld_safe) --defaults-file=/etc/mysql/my.cnf\"\n\
autostart=false\n\
autorestart=true\n\
\n" > ${file}; \
    printf "Done patching ${file}...\n";

# MySQL
RUN printf "Updading MySQL configuration...\n"; \
    \
    # ignoring /etc/default/mysql
    \
    # /etc/mysql/my.cnf \
    file="/etc/mysql/my.cnf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    # run as user \
    perl -0p -i -e "s>user\t\t= .*>user\t\t= ${app_mysql_user}>" ${file}; \
    # change logging \
    perl -0p -i -e "s>\[mysqld_safe\]>\[mysqld_safe\]\nlog-error       = /var/log/mysql/error.log>" ${file}; \
    perl -0p -i -e "s># Error log - should be very few entries.\n#\nlog_error = .*># Error log - should be very few entries.\n#\nlog_error                = /var/log/mysql/error.log>" ${file}; \
    # change interface \
    perl -0p -i -e "s>bind-address\t\t= .*>bind-address\t\t= ${app_mysql_listen_addr}>" ${file}; \
    # change port \
    perl -0p -i -e "s>port\t\t= .*>port\t\t= ${app_mysql_listen_port}>g" ${file}; \
    # change protocol \
    perl -0p -i -e "s>\[client\]>\[client\]\nprotocol        = tcp>" ${file}; \
    # change engine and collation \
    # https://stackoverflow.com/questions/3513773/change-mysql-default-character-set-to-utf-8-in-my-cnf \
    # https://www.percona.com/blog/2014/01/28/10-mysql-settings-to-tune-after-installation/ \
    # https://dev.mysql.com/doc/refman/5.6/en/charset-configuration.html \
    perl -0p -i -e "s>\[mysqld\]>\[mysqld\]\n#\n# Engine and Collation\n#\ndefault-storage-engine = InnoDB\ncharacter-set-server   = utf8\ncollation-server       = utf8_general_ci>" ${file}; \
    perl -0p -i -e "s>\[client\]>\[client\]\ndefault-character-set = utf8>" ${file}; \
    # change performance settings \
    perl -0p -i -e "s>max_allowed_packet      = .*\nthread_stack>max_allowed_packet      = 128M\nthread_stack>" ${file}; \
    perl -0p -i -e "s>\[mysqldump\]\nquick\nquote-names\nmax_allowed_packet      = .*\n>\[mysqldump\]\nquick\nquote-names\nmax_allowed_packet = 24M\n>" ${file}; \
    printf "Done patching ${file}...\n";

