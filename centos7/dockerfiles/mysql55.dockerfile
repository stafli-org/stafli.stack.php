
#
#    CentOS 7 (centos7) MySQL55 (MariaDB10) profile (dockerfile)
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

FROM solict/general-purpose-system-distro:centos7_standard
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
#  - N/A: for MariaDB
# Install the MariaDB packages
#  - MariaDB-server: for mysqld, the MySQL relational database management system server
#  - MariaDB-client: for mysql, the MySQL relational database management system client
#  - mytop: for mytop, the MySQL relational database management system top-like utility
RUN printf "# Install the repositories and refresh the GPG keys...\n" && \
    printf "# MariaDB repository\n\
[mariadb]\n\
name = MariaDB\n\
baseurl = http://yum.mariadb.org/10.1/centos7-amd64\n\
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB\n\
gpgcheck=1\n\
\n" > /etc/yum.repos.d/mariadb.repo && \
    rpm --import https://yum.mariadb.org/RPM-GPG-KEY-MariaDB && \
    printf "# Install the MySQL packages...\n" && \
    rpm --rebuilddb && \
    yum makecache && yum install -y \
      MariaDB-server MariaDB-client mytop && \
    printf "# Cleanup the Package Manager...\n" && \
    yum clean all && rm -Rf /var/lib/yum/*;

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
      --shell /sbin/nologin \
      ${app_mysql_user} \
    || \
    useradd \
      --system --gid ${app_mysql_group} \
      --no-create-home --home-dir ${app_mysql_home} \
      --shell /sbin/nologin \
      ${app_mysql_user};

# Supervisor
RUN printf "Updading Supervisor configuration...\n"; \
    \
    # /etc/supervisord.d/init.conf \
    file="/etc/supervisord.d/init.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    perl -0p -i -e "s>supervisorctl start dropbear;>supervisorctl start dropbear; supervisorctl start mysql;>" ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/supervisord.d/mysql.conf \
    file="/etc/supervisord.d/mysql.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    printf "# mysql\n\
[program:mysql]\n\
command=/bin/bash -c \"\$(which mysqld_safe) --defaults-file=/etc/my.cnf\"\n\
autostart=false\n\
autorestart=true\n\
\n" > ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/rc.local
    file="/etc/rc.local"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    perl -0p -i -e "s>\nexit 0>>" ${file}; \
    printf "# Install MySQL\n\
if [ ! -d \"${app_mysql_home}/mysql\" ]; then\n\
  \$(which mysql_install_db) --user=${app_mysql_user} --ldata=${app_mysql_home};\n\
fi;\n\
mkdir -p /var/log/mysql;\n\
chown ${app_mysql_user}:${app_mysql_group} /var/log/mysql;\n\
\n\
exit 0\n" >> ${file}; \
    printf "Done patching ${file}...\n";

# MySQL
RUN printf "Updading MySQL configuration...\n"; \
    \
    # ignoring /etc/sysconfig/mysql \
    \
    # ignoring /etc/my.cnf \
    \
    # /etc/my.cnf.d/server.cnf \
    file="/etc/my.cnf.d/server.cnf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    # run as user \
    perl -0p -i -e "s>\[server\]>\[server\]\nuser = ${app_mysql_user}>" ${file}; \
    # change logging \
    perl -0p -i -e "s>\[server\]>\[server\]\nlog-error = /var/log/mysql/mariadb-error.log>" ${file}; \
    # change interface \
    perl -0p -i -e "s>\[server\]>\[server\]\nbind-address = ${app_mysql_listen_addr}>" ${file}; \
    # change port \
    perl -0p -i -e "s>\[server\]>\[server\]\nport = ${app_mysql_listen_port}>" ${file}; \
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
    printf "\n# Applying configuration for ${file}...\n"; \
    # change protocol \
    perl -0p -i -e "s>\[client\]>\[client\]\nprotocol = tcp>" ${file}; \
    # change port \
    perl -0p -i -e "s>\[client\]>\[client\]\nport = ${app_mysql_listen_port}>" ${file}; \
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
    printf "Done patching ${file}...\n";

