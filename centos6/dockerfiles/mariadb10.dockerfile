
#
#    CentOS 6 (centos6) MariaDB10 service (dockerfile)
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
#  - MariaDB-server: for mysqld, the MariaDB relational database management system server
#  - MariaDB-client: for mysql, the MariaDB relational database management system client
#  - mytop: for mytop, the MariaDB relational database management system top-like utility
RUN printf "Installing repositories and packages...\n" && \
    \
    printf "Install the repositories and refresh the GPG keys...\n" && \
    printf "# MariaDB repository\n\
[mariadb]\n\
name = MariaDB\n\
baseurl = http://yum.mariadb.org/10.1/centos6-amd64\n\
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB\n\
gpgcheck=1\n\
\n" > /etc/yum.repos.d/mariadb.repo && \
    rpm --import https://yum.mariadb.org/RPM-GPG-KEY-MariaDB && \
    printf "Install the MariaDB packages...\n" && \
    rpm --rebuilddb && \
    yum makecache && yum install -y \
      MariaDB-server MariaDB-client mytop && \
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
    printf "Add mariadb user and group...\n"; \
    id -g ${app_mariadb_user} || \
    groupadd \
      --system ${app_mariadb_group} && \
    id -u ${app_mariadb_user} && \
    usermod \
      --gid ${app_mariadb_group} \
      --home ${app_mariadb_home} \
      --shell /sbin/nologin \
      ${app_mariadb_user} \
    || \
    useradd \
      --system --gid ${app_mariadb_group} \
      --no-create-home --home-dir ${app_mariadb_home} \
      --shell /sbin/nologin \
      ${app_mariadb_user}; \
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
    printf "# MariaDB\n\
[program:mysql]\n\
command=/bin/bash -c \"\$(which mysqld_safe) --defaults-file=/etc/my.cnf\"\n\
autostart=true\n\
autorestart=true\n\
\n" >> ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/rc.local
    file="/etc/rc.local"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    perl -0p -i -e "s>\nexit 0>>" ${file}; \
    printf "# Install MySQL\n\
if [ ! -d \"${app_mariadb_home}/mysql\" ]; then\n\
  \$(which mysql_install_db) --user=${app_mariadb_user} --ldata=${app_mariadb_home};\n\
fi;\n\
mkdir -p /var/log/mysql;\n\
chown ${app_mariadb_user}:${app_mariadb_group} /var/log/mysql;\n\
\n\
exit 0\n" >> ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    printf "Finished updading Supervisor configuration...\n";

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

