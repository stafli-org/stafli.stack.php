
#
#    CentOS 6 (centos6) MySQL51 profile (dockerfile)
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

ARG app_mysql_user="mysql"
ARG app_mysql_group="mysql"
ARG app_mysql_home="/var/lib/mysql"
ARG app_mysql_listen_addr="0.0.0.0"
ARG app_mysql_listen_port="3306"

#
# Packages
#

# Add foreign repositories and GPG keys
#  - remi-release: for Les RPM de remi pour Enterprise Linux 6 (Remi)
# Install the MySQL packages
#  - mysql-server: for mysqld, the MySQL relational database management system server
#  - mysql: for mysql, the MySQL relational database management system client
#  - mytop: for mytop, the MySQL relational database management system top-like utility
RUN printf "# Install the repositories and refresh the GPG keys...\n" && \
    rpm --rebuilddb && \
    yum makecache && yum install -y \
      http://rpms.remirepo.net/enterprise/remi-release-6.rpm && \
    yum-config-manager --enable remi-safe remi && \
    gpg --refresh-keys && \
    printf "# Install the MySQL packages...\n" && \
    yum makecache && yum install -y \
      mysql-server mysql mytop && \
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
    # init is not working at this point \
    \
    # /etc/supervisord.conf \
    file="/etc/supervisord.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    printf "# mysql\n\
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
if [ ! -d \"${app_mysql_home}/mysql\" ]; then\n\
  \$(which mysql_install_db) --user=${app_mysql_user} --ldata=${app_mysql_home};\n\
fi;\n\
\n\
exit 0\n" >> ${file}; \
    printf "Done patching ${file}...\n";

# MySQL
RUN printf "Updading MySQL configuration...\n"; \
    \
    # ignoring /etc/sysconfig/mysql
    \
    # /etc/my.cnf \
    file="/etc/my.cnf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    # add missing sections \
    perl -0p -i -e "s>#\n# include all files from the config directory>[mysqldump]\n#\n# include all files from the config directory>" ${file}; \
    perl -0p -i -e "s>#\n# include all files from the config directory>[client]\n\n#\n# include all files from the config directory>" ${file}; \
    # run as user \
    perl -0p -i -e "s>user=.*>user = ${app_mysql_user}>" ${file}; \
    # change logging \
    perl -0p -i -e "s>\[mysqld_safe\]\nlog-error=.*>\[mysqld_safe\]\nlog-error = /var/log/mysqld.log>" ${file}; \
    perl -0p -i -e "s>\n# Disabling symbolic-links is recommended to prevent assorted security risks>log-error = /var/log/mysqld.log\n\n# Disabling symbolic-links is recommended to prevent assorted security risks>" ${file}; \
    # change interface \
    perl -0p -i -e "s># Settings user and group are ignored>bind-address = ${app_mysql_listen_addr}\n# Settings user and group are ignored>" ${file}; \
    # change port \
    perl -0p -i -e "s># Settings user and group are ignored>port = ${app_mysql_listen_port}\n\n# Settings user and group are ignored>" ${file}; \
    perl -0p -i -e "s>\[client\]>\[client\]\nport = ${app_mysql_listen_port}>" ${file}; \
    # change protocol \
    perl -0p -i -e "s>\[client\]>\[client\]\nprotocol = tcp>" ${file}; \
    # change engine and collation \
    # https://stackoverflow.com/questions/3513773/change-mysql-default-character-set-to-utf-8-in-my-cnf \
    # https://www.percona.com/blog/2014/01/28/10-mysql-settings-to-tune-after-installation/ \
    # https://dev.mysql.com/doc/refman/5.6/en/charset-configuration.html \
    perl -0p -i -e "s>\[mysqld\]>\[mysqld\]\n#\n# Engine and Collation\n#\ndefault-storage-engine = InnoDB\ncharacter-set-server   = utf8\ncollation-server       = utf8_general_ci\n>" ${file}; \
    perl -0p -i -e "s>\[client\]>\[client\]\ndefault-character-set = utf8>" ${file}; \
    # change performance settings \
    perl -0p -i -e "s>\[mysqld\]>\[mysqld\]\n#\n# Performance\n#\nmax_allowed_packet = 1G\n>" ${file}; \
    perl -0p -i -e "s>\[mysqldump\]>\[mysqldump\]\nquick\nquote-names\nmax_allowed_packet = 24M\n>" ${file}; \
    printf "Done patching ${file}...\n";

