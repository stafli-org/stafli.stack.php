
#
#    Debian 8 (jessie) PHP Stack - MariaDB10 RDBMS (dockerfile)
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
FROM stafli/stafli.rdbms.mariadb:mariadb10_debian8

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
      org.label-schema.os-version-id="8" \
      org.label-schema.os-architecture="amd64" \
      org.label-schema.version="1.0"

#
# Arguments
#

ARG app_mariadb_global_user="mysql"
ARG app_mariadb_global_group="mysql"
ARG app_mariadb_global_home="/var/lib/mysql"
ARG app_mariadb_global_loglevel="notice"
ARG app_mariadb_global_listen_addr="0.0.0.0"
ARG app_mariadb_global_listen_port="3306"
ARG app_mariadb_global_default_storage_engine="InnoDB"
ARG app_mariadb_global_default_character_set="utf8"
ARG app_mariadb_global_default_collation="utf8_general_ci"
ARG app_mariadb_tuning_max_connections="100"
ARG app_mariadb_tuning_connect_timeout="5"
ARG app_mariadb_tuning_wait_timeout="600"
ARG app_mariadb_tuning_max_allowed_packet="128M"
ARG app_mariadb_tuning_thread_cache_size="128"
ARG app_mariadb_tuning_sort_buffer_size="4M"
ARG app_mariadb_tuning_bulk_insert_buffer_size="16M"
ARG app_mariadb_tuning_tmp_table_size="32M"
ARG app_mariadb_tuning_max_heap_table_size="32M"
ARG app_mariadb_query_cache_limit="128K"
ARG app_mariadb_query_cache_size="64M"
ARG app_mariadb_query_cache_min_res_unit="4k"
ARG app_mariadb_query_cache_type="DEMAND"
ARG app_mariadb_myisam_key_buffer_size="128M"
ARG app_mariadb_myisam_open_files_limit="2000"
ARG app_mariadb_myisam_table_open_cache="400"
ARG app_mariadb_myisam_myisam_sort_buffer_size="512M"
ARG app_mariadb_myisam_concurrent_insert="2"
ARG app_mariadb_myisam_read_buffer_size="2M"
ARG app_mariadb_myisam_read_rnd_buffer_size="1M"
ARG app_mariadb_innodb_log_file_size="50M"
ARG app_mariadb_innodb_buffer_pool_size="256M"
ARG app_mariadb_innodb_buffer_pool_instances="1"
ARG app_mariadb_innodb_log_buffer_size="8M"
ARG app_mariadb_innodb_file_per_table="1"
ARG app_mariadb_innodb_open_files="400"
ARG app_mariadb_innodb_io_capacity="400"
ARG app_mariadb_innodb_flush_method="O_DIRECT"

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
    perl -0p -i -e "s>user\t\t= .*>user\t\t= ${app_mariadb_global_user}>" ${file} && \
    # change home \
    perl -0p -i -e "s>datadir\t\t= .*>datadir\t\t= ${app_mariadb_global_home}>" ${file} && \
    # change logging \
    perl -0p -i -e "s>.*log_error       = .*>log_error       = /var/log/mysql/mariadb-error.log>" ${file} && \
    perl -0p -i -e "s># Error logging goes to syslog due to /etc/mysql/conf.d/mysqld_safe_syslog.cnf.\n#># Error logging goes to syslog due to /etc/mysql/conf.d/mysqld_safe_syslog.cnf.\n#\nlog_error               = /var/log/mysql/mariadb-error.log>" ${file} && \
    if [ "$app_mariadb_global_loglevel" = "notice" ]; then app_mariadb_global_loglevel_ovr="1"; elif [ "$app_mariadb_global_loglevel" = "verbose" ]; then app_mariadb_global_loglevel_ovr="2"; else app_mariadb_global_loglevel_ovr="1"; fi && \
    perl -0p -i -e "s>.*log_warnings    = .*>log_warnings    = ${app_mariadb_global_loglevel_ovr}>" ${file} && \
    perl -0p -i -e "s># we do want to know about network errors and such\nlog_warnings .*># we do want to know about network errors and such\nlog_warnings            = ${app_mariadb_global_loglevel_ovr}>" ${file} && \
    perl -0p -i -e "s>.*log_output      = .*>log_output      = FILE>" ${file} && \
    perl -0p -i -e "s># we do want to know about network errors and such\nlog_warnings># we do want to know about network errors and such\nlog_output              = FILE\nlog_warnings>" ${file} && \
    perl -0p -i -e "s>.*general_log             = .*>general_log             = 1>" ${file} && \
    perl -0p -i -e "s>.*general_log_file        = .*>general_log_file        = /var/log/mysql/mariadb-general.log>" ${file} && \
    perl -0p -i -e "s>.*slow_query_log\[.*>slow_query_log          = 1>" ${file} && \
    perl -0p -i -e "s>.*slow_query_log_file     = .*>slow_query_log_file     = /var/log/mysql/mariadb-slow.log>" ${file} && \
    perl -0p -i -e "s>.*log_slow_admin_statements>log_slow_admin_statements>" ${file} && \
    perl -0p -i -e "s>.*log-queries-not-using-indexes>log_queries_not_using_indexes = 1>" ${file} && \
    perl -0p -i -e "s>.*log_slow_rate_limit.*>log_slow_rate_limit     = 1>" ${file} && \
    perl -0p -i -e "s>.*long_query_time = .*>long_query_time         = 2>" ${file} && \
    # change interface \
    perl -0p -i -e "s>bind-address\t\t= .*>bind-address\t\t= ${app_mariadb_global_listen_addr}>" ${file} && \
    # change port \
    perl -0p -i -e "s>port\t\t= .*>port\t\t= ${app_mariadb_global_listen_port}>g" ${file} && \
    # change protocol \
    perl -0p -i -e "s>.*protocol        = .*>protocol        = tcp>" ${file} && \
    # storage engine \
    perl -0p -i -e "s>.*default_storage_engine\t= .*>default_storage_engine  = ${app_mariadb_global_default_storage_engine}>" ${file} && \
    # change tuning settings \
    perl -0p -i -e "s>.*max_connections\t\t= .*>max_connections\t\t= ${app_mariadb_tuning_max_connections}>" ${file} && \
    perl -0p -i -e "s>.*connect_timeout\t\t= .*>connect_timeout\t\t= ${app_mariadb_tuning_connect_timeout}>" ${file} && \
    perl -0p -i -e "s>.*wait_timeout\t\t= .*>wait_timeout\t\t= ${app_mariadb_tuning_wait_timeout}>" ${file} && \
    perl -0p -i -e "s>.*max_allowed_packet\t= .*>max_allowed_packet\t= ${app_mariadb_tuning_max_allowed_packet}>" ${file} && \
    perl -0p -i -e "s>.*thread_cache_size       = .*>thread_cache_size       = ${app_mariadb_tuning_thread_cache_size}>" ${file} && \
    perl -0p -i -e "s>.*sort_buffer_size\t= .*>sort_buffer_size\t= ${app_mariadb_tuning_sort_buffer_size}>" ${file} && \
    perl -0p -i -e "s>.*bulk_insert_buffer_size\t= .*>bulk_insert_buffer_size\t= ${app_mariadb_tuning_bulk_insert_buffer_size}>" ${file} && \
    perl -0p -i -e "s>.*tmp_table_size\t\t= .*>tmp_table_size\t\t= ${app_mariadb_tuning_tmp_table_size}>" ${file} && \
    perl -0p -i -e "s>.*max_heap_table_size\t= .*>max_heap_table_size\t= ${app_mariadb_tuning_max_heap_table_size}>" ${file} && \
    # change query cache settings \
    perl -0p -i -e "s>.*query_cache_limit\t\t= .*>query_cache_limit\t\t= ${app_mariadb_query_cache_limit}>" ${file} && \
    perl -0p -i -e "s>.*query_cache_size\t\t= .*>query_cache_size\t\t= ${app_mariadb_query_cache_size}>" ${file} && \
    perl -0p -i -e "s>.*nquery_cache_min_res_unit\t= .*>query_cache_min_res_unit\t= ${app_mariadb_query_cache_min_res_unit}>" ${file} && \
    perl -0p -i -e "s>.*query_cache_type\t\t= .*>query_cache_type\t\t= ${app_mariadb_query_cache_type}>" ${file} && \
    # change myisam settings \
    perl -0p -i -e "s>.*key_buffer_size\t\t= .*>key_buffer_size\t\t= ${app_mariadb_myisam_key_buffer_size}>" ${file} && \
    perl -0p -i -e "s>.*open-files-limit\t= .*>open-files-limit\t= ${app_mariadb_myisam_open_files_limit}>" ${file} && \
    perl -0p -i -e "s>.*table_open_cache\t= .*>table_open_cache\t= ${app_mariadb_myisam_table_open_cache}>" ${file} && \
    perl -0p -i -e "s>.*myisam_sort_buffer_size\t= .*>myisam_sort_buffer_size\t= ${app_mariadb_myisam_myisam_sort_buffer_size}>" ${file} && \
    perl -0p -i -e "s>.*concurrent_insert\t= .*>concurrent_insert\t= ${app_mariadb_myisam_concurrent_insert}>" ${file} && \
    perl -0p -i -e "s>.*read_buffer_size\t= .*>read_buffer_size\t= ${app_mariadb_myisam_read_buffer_size}>" ${file} && \
    perl -0p -i -e "s>.*read_rnd_buffer_size\t= .*>read_rnd_buffer_size\t= ${app_mariadb_myisam_read_rnd_buffer_size}>" ${file} && \
    # change innodb settings \
    perl -0p -i -e "s>.*innodb_log_file_size\t= .*>innodb_log_file_size\t= ${app_mariadb_innodb_log_file_size}>" ${file} && \
    perl -0p -i -e "s>.*innodb_buffer_pool_size\t= .*>innodb_buffer_pool_size\t= ${app_mariadb_innodb_buffer_pool_size}>" ${file} && \
    perl -0p -i -e "s>.*innodb_buffer_pool_instances\t= .*>innodb_buffer_pool_instances\t= ${app_mariadb_innodb_buffer_pool_instances}>" ${file} && \
    perl -0p -i -e "s>.*innodb_log_buffer_size\t= .*>innodb_log_buffer_size\t= ${app_mariadb_innodb_log_buffer_size}>" ${file} && \
    perl -0p -i -e "s>.*innodb_file_per_table\t= .*>innodb_file_per_table\t= ${app_mariadb_innodb_file_per_table}>" ${file} && \
    perl -0p -i -e "s>.*innodb_open_files\t= .*>innodb_open_files\t= ${app_mariadb_innodb_open_files}>" ${file} && \
    perl -0p -i -e "s>.*innodb_io_capacity\t= .*>innodb_io_capacity\t= ${app_mariadb_innodb_io_capacity}>" ${file} && \
    perl -0p -i -e "s>.*innodb_flush_method\t= .*>innodb_flush_method\t= ${app_mariadb_innodb_flush_method}>" ${file} && \
    # change mysqldump settings \
    perl -0p -i -e "s>\[mysqldump\]\nquick\nquote-names\nmax_allowed_packet\t= .*>\[mysqldump\]\nquick\nquote-names\nmax_allowed_packet\t= ${app_mariadb_tuning_max_allowed_packet}>" ${file} && \
    # change client settings \
    perl -0p -i -e "s>\[client\]\nport\t\t= .*>\[client\]\nport\t\t= ${app_mariadb_global_listen_port}>g" ${file} && \
    printf "Done patching ${file}...\n" && \
    \
    # /etc/mysql/conf.d/mariadb.cnf \
    file="/etc/mysql/conf.d/mariadb.cnf" && \
    printf "\n# Applying configuration for ${file}...\n" && \
    # change collation \
    # https://stackoverflow.com/questions/3513773/change-mysql-default-character-set-to-utf-8-in-my-cnf \
    # https://www.percona.com/blog/2014/01/28/10-mysql-settings-to-tune-after-installation/ \
    # https://dev.mysql.com/doc/refman/5.6/en/charset-configuration.html \
    perl -0p -i -e "s>.*default-character-set = .*>default-character-set = ${app_mariadb_global_default_character_set}>" ${file} && \
    perl -0p -i -e "s>.*character-set-server  = .*>character-set-server  = ${app_mariadb_global_default_character_set}>" ${file} && \
    perl -0p -i -e "s>.*character_set_server   = .*>character_set_server   = ${app_mariadb_global_default_character_set}>" ${file} && \
    perl -0p -i -e "s>.*collation-server      = .*>collation-server      = ${app_mariadb_global_default_collation}>" ${file} && \
    perl -0p -i -e "s>.*collation_server       = .*>collation_server       = ${app_mariadb_global_default_collation}>" ${file} && \
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
EXPOSE ${app_mariadb_global_listen_port}

