
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

#
# Build
#

# Base image to use
FROM stafli/stafli.rdbms.mariadb:mariadb10_debian7

# Labels to apply
LABEL description="Stafli PHP Stack (stafli/stafli.stack.php), Based on Stafli Memcached Cache (stafli/stafli.cache.memcached), Stafli Redis Cache (stafli/stafli.cache.redis), Stafli MariaDB Cache (stafli/stafli.rdbms.mariadb), Stafli PHP Language (stafli/stafli.language.php), Stafli HTTPd Web Server (stafli/stafli.web.httpd) and Stafli HTTPd Proxy Server (stafli/stafli.proxy.httpd)" \
      maintainer="lp@algarvio.org" \
      org.label-schema.schema-version="1.0.0-rc.1" \
      org.label-schema.name="Stafli PHP Stack (stafli/stafli.stack.php)" \
      org.label-schema.description="Based on Stafli Memcached Cache (stafli/stafli.cache.memcached), Stafli Redis Cache (stafli/stafli.cache.redis), Stafli MariaDB Cache (stafli/stafli.rdbms.mariadb), Stafli PHP Language (stafli/stafli.language.php), Stafli HTTPd Web Server (stafli/stafli.web.httpd) and Stafli HTTPd Proxy Server (stafli/stafli.proxy.httpd)" \
      org.label-schema.keywords="stafli, stack, memcached, redis, mariadb, php, httpd, debian, centos" \
      org.label-schema.url="https://stafli.org/" \
      org.label-schema.license="GPLv3" \
      org.label-schema.vendor-name="Stafli" \
      org.label-schema.vendor-email="info@stafli.org" \
      org.label-schema.vendor-website="https://www.stafli.org" \
      org.label-schema.authors.lpalgarvio.name="Luis Pedro Algarvio" \
      org.label-schema.authors.lpalgarvio.email="lp@algarvio.org" \
      org.label-schema.authors.lpalgarvio.homepage="https://lp.algarvio.org" \
      org.label-schema.authors.lpalgarvio.role="Maintainer" \
      org.label-schema.registry-url="https://hub.docker.com/r/stafli/stafli.stack.php" \
      org.label-schema.vcs-url="https://github.com/stafli-org/stafli.stack.php" \
      org.label-schema.vcs-branch="master" \
      org.label-schema.os-id="debian" \
      org.label-schema.os-version-id="7" \
      org.label-schema.os-architecture="amd64" \
      org.label-schema.version="1.0"

#
# Arguments
#

ARG app_mariadb_user="mysql"
ARG app_mariadb_group="mysql"
ARG app_mariadb_home="/var/lib/mysql"
ARG app_mariadb_loglevel="notice"
ARG app_mariadb_listen_addr="0.0.0.0"
ARG app_mariadb_listen_port="3306"

#
# Environment
#

# Working directory to use when executing build and run instructions
# Defaults to /.
#WORKDIR /

# User and group to use when executing build and run instructions
# Defaults to root.
#USER root:root

#
# Packages
#

#
# Configuration
#

# MariaDB
RUN printf "Updading MariaDB configuration...\n" && \
    \
    # ignoring /etc/default/mysql \
    \
    # /etc/mysql/my.cnf \
    file="/etc/mysql/my.cnf" && \
    printf "\n# Applying configuration for ${file}...\n" && \
    # run as user \
    perl -0p -i -e "s>user\t\t= .*>user\t\t= ${app_mariadb_user}>" ${file} && \
    # change logging \
    perl -0p -i -e "s>\[mysqld_safe\]>\[mysqld_safe\]\nlog_error       = /var/log/mysql/mariadb-error.log>" ${file} && \
    perl -0p -i -e "s># Error logging goes to syslog due to /etc/mysql/conf.d/mysqld_safe_syslog.cnf.\n#># Error logging goes to syslog due to /etc/mysql/conf.d/mysqld_safe_syslog.cnf.\n#\nlog_error               = /var/log/mysql/mariadb-error.log>" ${file} && \
    if [ "$app_mariadb_loglevel" = "notice" ]; then app_memcached_loglevel_ovr="1"; elif [ "$app_mariadb_loglevel" = "verbose" ]; then app_memcached_loglevel_ovr="2"; else app_memcached_loglevel_ovr="1"; fi && \
    perl -0p -i -e "s>\[mysqld_safe\]>\[mysqld_safe\]\nlog_warnings    = ${app_mariadb_loglevel}>" ${file} && \
    perl -0p -i -e "s># we do want to know about network errors and such\nlog_warnings .*># we do want to know about network errors and such\nlog_warnings            = ${app_mariadb_loglevel}>" ${file} && \
    perl -0p -i -e "s>\[mysqld_safe\]>\[mysqld_safe\]\nlog_output      = FILE>" ${file} && \
    perl -0p -i -e "s># we do want to know about network errors and such\nlog_warnings># we do want to know about network errors and such\nlog_output              = FILE\nlog_warnings>" ${file} && \
    perl -0p -i -e "s>.*general_log             = .*>general_log             = 1>" ${file} && \
    perl -0p -i -e "s>.*general_log_file        = .*>general_log_file        = /var/log/mysql/mariadb-general.log>" ${file} && \
    perl -0p -i -e "s>.*slow_query_log\[.*>slow_query_log          = 1>" ${file} && \
    perl -0p -i -e "s>.*slow_query_log_file     = .*>slow_query_log_file     = /var/log/mysql/mariadb-slow.log>" ${file} && \
    perl -0p -i -e "s>.*log_slow_admin_statements>log_slow_admin_statements = 1>" ${file} && \
    perl -0p -i -e "s>.*log-queries-not-using-indexes>log_queries_not_using_indexes = 1>" ${file} && \
    perl -0p -i -e "s>.*log_slow_rate_limit.*>log_slow_rate_limit     = 1>" ${file} && \
    perl -0p -i -e "s>.*long_query_time = .*>long_query_time         = 2>" ${file} && \
    # change interface \
    perl -0p -i -e "s>bind-address\t\t= .*>bind-address\t\t= ${app_mariadb_listen_addr}>" ${file} && \
    # change port \
    perl -0p -i -e "s>port\t\t= .*>port\t\t= ${app_mariadb_listen_port}>g" ${file} && \
    # change protocol \
    perl -0p -i -e "s>\[client\]>\[client\]\nprotocol        = tcp>" ${file} && \
    # storage engine \
    perl -0p -i -e "s>\[mysqld\]>\[mysqld\]\ndefault-storage-engine = InnoDB>" ${file} && \
    # change performance settings \
    perl -0p -i -e "s>max_allowed_packet\t= .*>max_allowed_packet\t= 128M>" ${file} && \
    perl -0p -i -e "s>\[mysqldump\]\nquick\nquote-names\nmax_allowed_packet\t= .*>\[mysqldump\]\nquick\nquote-names\nmax_allowed_packet\t= 24M>" ${file} && \
    printf "Done patching ${file}...\n" && \
    \
    # /etc/mysql/conf.d/mariadb.cnf \
    file="/etc/mysql/conf.d/mariadb.cnf" && \
    printf "\n# Applying configuration for ${file}...\n" && \
    # change engine and collation \
    # https://stackoverflow.com/questions/3513773/change-mysql-default-character-set-to-utf-8-in-my-cnf \
    # https://www.percona.com/blog/2014/01/28/10-mysql-settings-to-tune-after-installation/ \
    # https://dev.mysql.com/doc/refman/5.6/en/charset-configuration.html \
    perl -0p -i -e "s>.*default-character-set = .*>default-character-set = utf8>" ${file} && \
    perl -0p -i -e "s>.*character-set-server  = .*>character-set-server  = utf8>" ${file} && \
    perl -0p -i -e "s>.*collation-server      = .*>collation-server      = utf8_general_ci>" ${file} && \
    printf "Done patching ${file}...\n" && \
    \
    # /etc/mysql/conf.d/mysqld_safe_syslog.cnf \
    file="/etc/mysql/conf.d/mysqld_safe_syslog.cnf" && \
    printf "\n# Applying configuration for ${file}...\n" && \
    # change logging from syslog to files \
    # http://baligena.com/mysql-enable-error-logging/ \
    perl -0p -i -e "s>.*skip_log_error>#skip_log_error>" ${file} && \
    perl -0p -i -e "s>.*syslog>#syslog>" ${file} && \
    printf "Done patching ${file}...\n" && \
    \
    printf "\n# Testing configuration...\n" && \
    echo "Testing $(which mysql):"; $(which mysql) -V && \
    echo "Testing $(which mysqld):"; $(which mysqld) -V && \
    printf "Done testing configuration...\n" && \
    \
    printf "Finished updading MariaDB configuration...\n";

#
# Run
#

# Command to execute
# Defaults to /bin/bash.
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf", "--nodaemon"]

# Ports to expose
# Defaults to 3306
EXPOSE ${app_mariadb_listen_port}

