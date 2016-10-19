
#
#    CentOS 7 (centos7) PHP56 service (dockerfile)
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

FROM solict/general-purpose-system-distro:centos7_devel
MAINTAINER Luís Pedro Algarvio <lp.algarvio@gmail.com>

#
# Arguments
#

ARG app_php_exts_core_dis="mysql"
ARG app_php_exts_core_en="mcrypt curl gd imap ldap mysqli mysqlnd odbc pdo pdo_mysql pdo_odbc opcache"
ARG app_php_exts_extra_dis="xdebug xhprof"
ARG app_php_exts_extra_en="igbinary msgpack yaml solr mongodb memcache memcached redis"
ARG app_php_global_log_level="E_ALL"
ARG app_php_global_log_display="On"
ARG app_php_global_log_file="On"
ARG app_php_global_limit_timeout="120"
ARG app_php_global_limit_memory="134217728"
ARG app_fpm_global_user="apache"
ARG app_fpm_global_group="apache"
ARG app_fpm_global_home="/var/www"
ARG app_fpm_global_log_level="notice"
ARG app_fpm_global_limit_descriptors="1024"
ARG app_fpm_global_limit_processes="128"
ARG app_fpm_pool_id="default"
ARG app_fpm_pool_user="apache"
ARG app_fpm_pool_group="apache"
ARG app_fpm_pool_listen_wlist="0.0.0.0"
ARG app_fpm_pool_listen_addr="0.0.0.0"
ARG app_fpm_pool_listen_port="9000"
ARG app_fpm_pool_limit_descriptors="1024"
ARG app_fpm_pool_limit_backlog="256"
ARG app_fpm_pool_pm_method="dynamic"
ARG app_fpm_pool_pm_max_children="100"
ARG app_fpm_pool_pm_start_servers="20"
ARG app_fpm_pool_pm_min_spare_servers="10"
ARG app_fpm_pool_pm_max_spare_servers="30"
ARG app_fpm_pool_pm_process_idle_timeout="10s"
ARG app_fpm_pool_pm_max_requests="5000"

#
# Packages
#

# Add foreign repositories and GPG keys
#  - remi-release: for Les RPM de remi pour Enterprise Linux 7 (Remi)
#  - N/A: for MariaDB
# Install the Utilities and Clients packages
# - httpd-tools: for ab and others, the HTTPd utilities
# - MariaDB-client: for mysql, the MariaDB client
# - mytop: for mytop, the MariaDB monitoring tool
# Install the PHP packages
# - php-common: the PHP common libraries and files
# - php-devel: the PHP development libraries and files
# - php-pear: the PEAR package manager
# - php-cli: for php5, the PHP CLI (command line interface)
# - php-fpm: the PHP FPM (fast process manager)
# - php-mbstring: the PHP Mbstring extension
# - php-mcrypt: the PHP Mcrypt extension
# - php-gd: the PHP GD extension
# - php-imap: the PHP IMAP extension
# - php-xml: the PHP XML extension
# - php-soap: the PHP SOAP extension
# - php-ldap: the PHP LDAP extension
# - php-pdo: the PHP PDO extension
# - php-mysqlnd: the PHP MariaDB Native Driver extension
# - php-odbc: the PHP ODBC extension
# - libyaml-devel: the YAML library - development files
# - libmemcached-devel: the Memcached library - development files
RUN printf "Installing repositories and packages...\n" && \
    \
    printf "Install the repositories and refresh the GPG keys...\n" && \
    printf "# MariaDB repository\n\
[mariadb]\n\
name = MariaDB\n\
baseurl = http://yum.mariadb.org/10.1/centos7-amd64\n\
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB\n\
gpgcheck=1\n\
\n" > /etc/yum.repos.d/mariadb.repo && \
    rpm --import https://yum.mariadb.org/RPM-GPG-KEY-MariaDB && \
    rpm --rebuilddb && \
    yum makecache && yum install -y \
      http://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
    yum-config-manager --enable remi-safe remi remi-php56 && \
    gpg --refresh-keys && \
    printf "Install the Utilities and Clients packages...\n" && \
    yum makecache && yum install -y \
      httpd-tools \
      MariaDB-client mytop && \
    printf "Install the PHP packages...\n" && \
    yum makecache && yum install -y \
      php-common php-devel php-pear \
      php-cli php-fpm \
      php-mbstring php-mcrypt \
      php-gd php-imap \
      php-xml php-soap \
      php-ldap \
      php-pdo php-mysqlnd php-odbc \
      php-opcache \
      libyaml-devel libmemcached-devel && \
    printf "Cleanup the Package Manager...\n" && \
    yum clean all && rm -Rf /var/lib/yum/*; \
    \
    printf "Finished installing repositories and packages...\n";

#
# PHP extensions
#

# Build and Install PHP extensions
# - Binary API (igbinary)
# - MessagePack (msgpack)
# - YAML
# - Solr
# - MongoDB
# - Memcache
# - Memcached
# - Redis
# - Xdebug
# - XHProf
RUN printf "Start installing extensions...\n" && \
    \
    printf "Building the Binary API (rpm: php-pecl-igbinary) extension...\n" && \
    pecl install igbinary-1.2.1 && \
    echo "extension=igbinary.so" > /etc/php.d/50-igbinary.ini && \
    rm -rf /tmp/pear && \
    \
    printf "Building the MessagePack (rpm: php-pecl-msgpack) extension...\n" && \
    pecl install msgpack-0.5.7 && \
    echo "extension=msgpack.so" > /etc/php.d/50-msgpack.ini && \
    rm -rf /tmp/pear && \
    \
    printf "Building the YAML (rpm: php-pecl-yaml) extension...\n" && \
    pecl install yaml-1.2.0 && \
    echo "extension=yaml.so" > /etc/php.d/50-yaml.ini && \
    rm -rf /tmp/pear && \
    \
    printf "Building the Solr (rpm: php-pecl-solr, php-pecl-solr2) extension...\n" && \
    pecl install solr-2.4.0 && \
    echo "extension=solr.so" > /etc/php.d/60-solr.ini && \
    rm -rf /tmp/pear && \
    \
    printf "Building the MongoDB (rpm: php-pecl-mongo) extension...\n" && \
    pecl install mongodb-1.1.6 && \
    echo "extension=mongodb.so" > /etc/php.d/60-mongodb.ini && \
    rm -rf /tmp/pear && \
    \
    printf "Building the Memcache (rpm: php-pecl-memcache) extension...\n" && \
    pecl install memcache-2.2.7 && \
    pecl install memcache-3.0.8 && \
    echo "extension=memcache.so" > /etc/php.d/60-memcache.ini && \
    rm -rf /tmp/pear && \
    \
    printf "Building the Memcached (deb: php5-memcached) extension...\n" && \
    ( \
      wget -qO- https://github.com/php-memcached-dev/php-memcached/archive/2.2.0.tar.gz | tar xz && cd php-memcached-2.2.0 && \
      perl -0p -i -e "s><extsrcrelease\>><extsrcrelease\>\n\
  <configureoption name=\"enable-memcached-sasl\" default=\"yes\" prompt=\"Enable SASL\"/\>\n\
  <configureoption name=\"enable-memcached-json\" default=\"yes\" prompt=\"Enable JSON\"/\>\n\
  <configureoption name=\"enable-memcached-igbinary\" default=\"yes\" prompt=\"Enable igbinary\"/\>\n\
  <configureoption name=\"enable-memcached-msgpack\" default=\"yes\" prompt=\"Enable msgpack\"/\>\n\
  <configureoption name=\"enable-memcached-protocol\" default=\"no\" prompt=\"Enable protocol\"/\>\
>" package.xml && \
      pecl install package.xml && \
      echo -e "extension=memcached.so\n\n$(cat memcached.ini)" > /etc/php.d/60-memcached.ini && \
      cd .. && rm -Rf php-memcached-2.2.0 \
    ) && \
    rm -rf /tmp/pear && \
    \
    printf "Building the Redis (deb: php5-redis) extension...\n" && \
    ( \
      wget -qO- https://github.com/phpredis/phpredis/archive/2.2.7.tar.gz | tar xz && cd phpredis-2.2.7 && \
      perl -0p -i -e "s>2.2.5>2.2.7>g" package.xml rpm/php-redis.spec && \
      perl -0p -i -e "s><extsrcrelease/\>><extsrcrelease\>\n\
  <configureoption name=\"enable-redis-igbinary\" default=\"yes\" prompt=\"Enable igbinary\"/\>\n\
 </extsrcrelease\>>" package.xml && \
      pecl install package.xml && \
      cd .. && rm -Rf phpredis-2.2.7 \
    ) && \
    echo "extension=redis.so" > /etc/php.d/60-redis.ini && \
    rm -rf /tmp/pear && \
    \
    printf "Building the Xdebug (rpm: php-pecl-xdebug) extension...\n" && \
    pecl install xdebug-2.4.0 && \
    echo "zend_extension=xdebug.so" > /etc/php.d/70-xdebug.ini && \
    rm -rf /tmp/pear && \
    \
    printf "Building the XHProf (rpm: php-pecl-xhprof) extension...\n" && \
    pecl install xhprof-0.9.4 && \
    echo "extension=xhprof.so" > /etc/php.d/70-xhprof.ini && \
    rm -rf /tmp/pear && \
    \
    printf "Enabling/disabling extensions...\n" && \
    # Core extensions \
    echo "php5dismod -f ${app_php_exts_core_dis}" && \
    echo "php5enmod -f ${app_php_exts_core_en}" && \
    # Extra extensions \
    echo "php5dismod -f ${app_php_exts_extra_dis}" && \
    echo "php5enmod -f ${app_php_exts_extra_en}" && \
    \
    printf "Finished installing extensions...\n";

#
# Configuration
#

# Add users and groups
RUN printf "Adding users and groups...\n"; \
    \
    printf "Add php-fpm user and group...\n"; \
    id -g ${app_fpm_global_user} || \
    groupadd \
      --system ${app_fpm_global_group} && \
    id -u ${app_fpm_global_user} && \
    usermod \
      --gid ${app_fpm_global_group} \
      --home ${app_fpm_global_home} \
      --shell /sbin/nologin \
      ${app_fpm_global_user} \
    || \
    useradd \
      --system --gid ${app_fpm_global_group} \
      --no-create-home --home-dir ${app_fpm_global_home} \
      --shell /sbin/nologin \
      ${app_fpm_global_user}; \
    \
    printf "Add pool user and group...\n"; \
    app_fpm_pool_home="${app_fpm_global_home}/${app_fpm_pool_id}"; \
    id -g ${app_fpm_pool_user} || \
    groupadd \
      --system ${app_fpm_pool_group} && \
    id -u ${app_fpm_pool_user} && \
    usermod \
      --gid ${app_fpm_global_group} \
      --home ${app_fpm_pool_home} \
      --shell /sbin/nologin \
      ${app_fpm_global_user} \
    || \
    useradd \
      --system --gid ${app_fpm_pool_group} \
      --create-home --home-dir ${app_fpm_pool_home} \
      --shell /sbin/nologin \
      ${app_fpm_pool_user}; \
    \
    printf "Setting pool ownership and permissions...\n"; \
    mkdir -p ${app_fpm_pool_home}/bin ${app_fpm_pool_home}/log ${app_fpm_pool_home}/html ${app_fpm_pool_home}/tmp; \
    chown -R ${app_fpm_global_user}:${app_fpm_global_group} ${app_fpm_pool_home}; \
    chmod -R ug=rwX,o=rX ${app_fpm_pool_home}; \
    \
    printf "Finished adding users and groups...\n";

# Supervisor
RUN printf "Updading Supervisor configuration...\n"; \
    \
    # /etc/supervisord.d/init.conf \
    file="/etc/supervisord.d/init.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    perl -0p -i -e "s>supervisorctl start dropbear;>supervisorctl start dropbear; supervisorctl start phpfpm;>" ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/supervisord.d/phpfpm.conf \
    file="/etc/supervisord.d/phpfpm.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    printf "# PHP-FPM\n\
[program:phpfpm]\n\
command=/bin/bash -c \"\$(which php-fpm) -y /etc/php-fpm.conf -c /etc/php-fpm.ini --nodaemonize\"\n\
autostart=false\n\
autorestart=true\n\
\n" > ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    printf "Finished updading Supervisor configuration...\n";

# PHP / PHP-FPM
RUN printf "Updading PHP and PHP-FPM configuration...\n"; \
    \
    # /etc/php.ini \
    file="/etc/php.ini"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    # change logging \
    perl -0p -i -e "s>; http://php.net/error-reporting\nerror_reporting = .*>; http://php.net/error-reporting\nerror_reporting = ${app_php_global_log_level}>" ${file}; \
    perl -0p -i -e "s>; http://php.net/display-startup-errors\ndisplay_startup_errors = .*>; http://php.net/display-startup-errors\ndisplay_startup_errors = ${app_php_global_log_display}>" ${file}; \
    perl -0p -i -e "s>; http://php.net/display-errors\ndisplay_errors = .*>; http://php.net/display-errors\ndisplay_errors = ${app_php_global_log_display}>" ${file}; \
    perl -0p -i -e "s>; http://php.net/log-errors\nlog_errors = .*>; http://php.net/log-errors\nlog_errors = ${app_php_global_log_file}>" ${file}; \
    perl -0p -i -e "s>; http://php.net/log-errors-max-len\nlog_errors_max_len = .*>; http://php.net/log-errors-max-len\nlog_errors_max_len = 10M>" ${file}; \
    # change timeouts \
    perl -0p -i -e "s>; http://php.net/max-input-time\nmax_input_time = .*>; http://php.net/max-input-time\nmax_input_time = -1>" ${file}; \
    perl -0p -i -e "s>; Note: This directive is hardcoded to 0 for the CLI SAPI\nmax_execution_time = .*>; Note: This directive is hardcoded to 0 for the CLI SAPI\nmax_execution_time = -1>" ${file}; \
    # change memory limit \
    perl -0p -i -e "s>; http://php.net/memory-limit\nmemory_limit = .*>; http://php.net/memory-limit\nmemory_limit = -1>" ${file}; \
    # change upload limit \
    perl -0p -i -e "s>; http://php.net/post-max-size\npost_max_size = .*>; http://php.net/post-max-size\npost_max_size = -1>" ${file}; \
    perl -0p -i -e "s>; http://php.net/upload-max-filesize\nupload_max_filesize = .*>; http://php.net/upload-max-filesize\nupload_max_filesize = -1>" ${file}; \
    # change i18n \
    perl -0p -i -e "s>; http://php.net/default-mimetype\ndefault_mimetype = .*>; http://php.net/default-mimetype\ndefault_mimetype = \"text/html\">" ${file}; \
    perl -0p -i -e "s>; http://php.net/default-charset\ndefault_charset =.*>; http://php.net/default-charset\ndefault_charset = \"UTF-8\">" ${file}; \
    perl -0p -i -e "s>; http://php.net/date.timezone\n;date.timezone =.*>; http://php.net/date.timezone\ndate.timezone = \"UTC\">" ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/php-fpm.ini \
    file="/etc/php-fpm.ini"; \
    cp "/etc/php.ini" $file; \
    printf "\n# Applying configuration for ${file}...\n"; \
    # change logging \
    perl -0p -i -e "s>; http://php.net/error-reporting\nerror_reporting = .*>; http://php.net/error-reporting\nerror_reporting = ${app_php_global_log_level}>" ${file}; \
    perl -0p -i -e "s>; http://php.net/display-startup-errors\ndisplay_startup_errors = .*>; http://php.net/display-startup-errors\ndisplay_startup_errors = ${app_php_global_log_display}>" ${file}; \
    perl -0p -i -e "s>; http://php.net/display-errors\ndisplay_errors = .*>; http://php.net/display-errors\ndisplay_errors = ${app_php_global_log_display}>" ${file}; \
    perl -0p -i -e "s>; http://php.net/log-errors\nlog_errors = .*>; http://php.net/log-errors\nlog_errors = ${app_php_global_log_file}>" ${file}; \
    perl -0p -i -e "s>; http://php.net/log-errors-max-len\nlog_errors_max_len = .*>; http://php.net/log-errors-max-len\nlog_errors_max_len = 10M>" ${file}; \
    # change timeouts \
    perl -0p -i -e "s>; http://php.net/max-input-time\nmax_input_time = .*>; http://php.net/max-input-time\nmax_input_time = $((${app_php_global_limit_timeout}/2))>" ${file}; \
    perl -0p -i -e "s>; Note: This directive is hardcoded to 0 for the CLI SAPI\nmax_execution_time = .*>; Note: This directive is hardcoded to 0 for the CLI SAPI\nmax_execution_time = ${app_php_global_limit_timeout}>" ${file}; \
    # change memory limit \
    perl -0p -i -e "s>; http://php.net/memory-limit\nmemory_limit = .*>; http://php.net/memory-limit\nmemory_limit = $((${app_php_global_limit_memory}/1024/1024))M>" ${file}; \
    # change upload limit \
    perl -0p -i -e "s>; http://php.net/post-max-size\npost_max_size = .*>; http://php.net/post-max-size\npost_max_size = $((${app_php_global_limit_memory}*15/20/1024/1024))M>" ${file}; \
    perl -0p -i -e "s>; http://php.net/upload-max-filesize\nupload_max_filesize = .*>; http://php.net/upload-max-filesize\nupload_max_filesize = $((${app_php_global_limit_memory}/2/1024/1024))M>" ${file}; \
    # change i18n \
    perl -0p -i -e "s>; http://php.net/default-mimetype\ndefault_mimetype = .*>; http://php.net/default-mimetype\ndefault_mimetype = \"text/html\">" ${file}; \
    perl -0p -i -e "s>; http://php.net/default-charset\ndefault_charset =.*>; http://php.net/default-charset\ndefault_charset = \"UTF-8\">" ${file}; \
    perl -0p -i -e "s>; http://php.net/date.timezone\n;date.timezone =.*>; http://php.net/date.timezone\ndate.timezone = \"UTC\">" ${file}; \
    # change CGI \
    perl -0p -i -e "s>; http://php.net/cgi.force-redirect\n;cgi.force_redirect = .*>; http://php.net/cgi.force-redirect\ncgi.force_redirect = 1>" ${file}; \
    perl -0p -i -e "s>; http://php.net/cgi.fix-pathinfo\n;cgi.fix_pathinfo=.*>; http://php.net/cgi.fix-pathinfo\ncgi.fix_pathinfo = 1>" ${file}; \
    perl -0p -i -e "s>; this feature.\n;fastcgi.logging = .*>; this feature.\nfastcgi.logging = 1>" ${file}; \
    perl -0p -i -e "s>; http://php.net/cgi.rfc2616-headers\n;cgi.rfc2616_headers = .*>; http://php.net/cgi.rfc2616-headers\ncgi.rfc2616_headers = 0>" ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/php-fpm.conf \
    file="/etc/php-fpm.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    # disable daemon/run in foreground \
    perl -0p -i -e "s>; Default Value: yes\n;daemonize = .*>; Default Value: yes\ndaemonize = no>" ${file}; \
    # change log facility
    perl -0p -i -e "s>; Default Value: daemon\n;syslog.facility = .*>; Default Value: daemon\nsyslog.facility = daemon>" ${file}; \
    perl -0p -i -e "s>; Default Value: php-fpm\n;syslog.ident = .*>; Default Value: php-fpm\nsyslog.ident = php-fpm>" ${file}; \
    # change log level \
    perl -0p -i -e "s>; Default Value: notice\n;log_level = .*>; Default Value: notice\nlog_level = ${app_fpm_global_log_level}>" ${file}; \
    # change maximum file open limit \
    perl -0p -i -e "s>; Default Value: system defined value\n;rlimit_files = .*>; Default Value: system defined value\nrlimit_files = ${app_fpm_global_limit_descriptors}>" ${file}; \
    # change maximum processes \
    perl -0p -i -e "s>; Default Value: 0\n; process.max = .*>; Default Value: 0\nprocess.max = ${app_fpm_global_limit_processes}>" ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # PHP-FPM Pool \
    app_fpm_pool_home="${app_fpm_global_home}/${app_fpm_pool_id}"; \
    \
    # Rename original pool configuration \
    mv "/etc/php-fpm.d/www.conf" "/etc/php-fpm.d/www.conf.orig"; \
    \
    # /etc/php-fpm.d/${app_fpm_pool_id}.conf \
    file="/etc/php-fpm.d/${app_fpm_pool_id}.conf"; \
    cp "/etc/php-fpm.d/www.conf.orig" $file; \
    printf "\n# Applying configuration for ${file}...\n"; \
    # delete bad defaults \
    perl -0p -i -e "s>php_admin_flag\[.*>>g" ${file}; \
    perl -0p -i -e "s>php_flag\[.*>>g" ${file}; \
    perl -0p -i -e "s>php_admin_value\[.*>>g" ${file}; \
    perl -0p -i -e "s>php_value\[.*>>g" ${file}; \
    # rename pool \
    perl -0p -i -e "s>; pool name \(\'www\' here\)\n\[www\]>; pool name ('www' here)\n[${app_fpm_pool_id}]>" ${file}; \
    # change pool prefix \
    perl -0p -i -e "s>; Default Value: none\n;prefix = .*>; Default Value: none\nprefix = ${app_fpm_global_home}/\\\$pool>" ${file}; \
    # run as user/group \
    perl -0p -i -e "s>user = .*\ngroup = .*>user = ${app_fpm_pool_user}\ngroup = ${app_fpm_pool_group}>" ${file}; \
    # listen as user/group \
    perl -0p -i -e "s>;listen.owner = .*\n;listen.group = .*\n;listen.mode = .*>listen.owner = ${app_fpm_pool_user}\nlisten.group = ${app_fpm_pool_group}\nlisten.mode = 0660>" ${file}; \
    # change logging \
    printf "\n; Error log path\nphp_admin_value[error_log] = ${app_fpm_pool_home}/log/${app_fpm_pool_id}.error.log\n" >> ${file}; \
    perl -0p -i -e "s>; Default: not set\n;access.log = .*>; Default: not set\naccess.log = log/\\\$pool.access.log>" ${file}; \
    perl -0p -i -e "s>; Note: slowlog is mandatory if request_slowlog_timeout is set\nslowlog = .*>; Note: slowlog is mandatory if request_slowlog_timeout is set\nslowlog = log/\\\$pool.slow.log>" ${file}; \
    # change status \
    perl -0p -i -e "s>; Default Value: not set\n;pm.status_path = .*>; Default Value: not set\npm.status_path = /fpm-status>" ${file}; \
    perl -0p -i -e "s>; Default Value: not set\n;ping.path = .*>; Default Value: not set\nping.path = /fpm-ping>" ${file}; \
    perl -0p -i -e "s>; Default Value: pong\n;ping.response = .*>; Default Value: pong\nping.response = pong>" ${file}; \
    # change whitelist \
    perl -0p -i -e "s>; Default Value: any\nlisten.allowed_clients = .*>; Default Value: any\n;listen.allowed_clients = ${app_fpm_pool_listen_wlist}>" ${file}; \
    # change interface and port \
    perl -0p -i -e "s>; Note: This value is mandatory.\nlisten = .*>; Note: This value is mandatory.\nlisten = ${app_fpm_pool_listen_addr}:${app_fpm_pool_listen_port}>" ${file}; \
    # change maximum file open limit \
    perl -0p -i -e "s>; Default Value: system defined value\n;rlimit_files = .*>; Default Value: system defined value\nrlimit_files = ${app_fpm_pool_limit_descriptors}>" ${file};\
    # change backlog queue limit \
    perl -0p -i -e "s>; Default Value: 65535\n;listen.backlog = .*>; Default Value: 65535 \(-1 on FreeBSD and OpenBSD\)\nlisten.backlog = ${app_fpm_pool_limit_backlog}>" ${file}; \
    # change process manager \
    perl -0p -i -e "s>; Note: This value is mandatory.\npm = .*>; Note: This value is mandatory.\npm = ${app_fpm_pool_pm_method}>" ${file}; \
    perl -0p -i -e "s>; Note: This value is mandatory.\npm.max_children = .*>; Note: This value is mandatory.\npm.max_children = ${app_fpm_pool_pm_max_children}>" ${file}; \
    perl -0p -i -e "s>; Default Value: min_spare_servers \+ \(max_spare_servers - min_spare_servers\) / 2\npm.start_servers = .*>; Default Value: min_spare_servers \+ \(max_spare_servers - min_spare_servers\) / 2\npm.start_servers = ${app_fpm_pool_pm_start_servers}>" ${file}; \
    perl -0p -i -e "s>; Note: Mandatory when pm is set to 'dynamic'\npm.min_spare_servers = .*>; Note: Mandatory when pm is set to 'dynamic'\npm.min_spare_servers = ${app_fpm_pool_pm_min_spare_servers}>" ${file}; \
    perl -0p -i -e "s>; Note: Mandatory when pm is set to 'dynamic'\npm.max_spare_servers = .*>; Note: Mandatory when pm is set to 'dynamic'\npm.max_spare_servers = ${app_fpm_pool_pm_max_spare_servers}>" ${file}; \
    perl -0p -i -e "s>; Default Value: 10s\n;pm.process_idle_timeout = .*>; Default Value: 10s\npm.process_idle_timeout = ${app_fpm_pool_pm_process_idle_timeout}>" ${file}; \
    perl -0p -i -e "s>; Default Value: 0\n;pm.max_requests = .*>; Default Value: 0\npm.max_requests = ${app_fpm_pool_pm_max_requests}>" ${file}; \
    # change timeouts \
    perl -0p -i -e "s>; Default Value: 0\n;request_slowlog_timeout = .*>; Default Value: 0\nrequest_slowlog_timeout = $((${app_php_global_limit_timeout}+5))>" ${file}; \
    perl -0p -i -e "s>; Default Value: 0\n;request_terminate_timeout = .*>; Default Value: 0\nrequest_terminate_timeout = $((${app_php_global_limit_timeout}+10))>" ${file}; \
    # change chroot \
    perl -0p -i -e "s>; Default Value: not set\n;chroot = .*>; Default Value: not set\n;chroot = ${app_fpm_pool_home}>" ${file}; \
    # change chdir \
    perl -0p -i -e "s>; Default Value: current directory or / when chroot\n;chdir = .*>; Default Value: current directory or / when chroot\n;chdir = /html/>" ${file}; \
    # change allowed extensions \
    perl -0p -i -e "s>; Default Value: .php\n;security.limit_extensions = .*>; Default Value: .php\nsecurity.limit_extensions = .php>" ${file}; \
    # change temporary files \
    printf "\n; Temporary files path\nphp_admin_value[upload_tmp_dir] = ${app_fpm_pool_home}/tmp\n" >> ${file}; \
    # change session \
    printf "\n; Session handler\nphp_admin_value[session.save_handler] = files\n" >> ${file}; \
    printf "\n; Session path\nphp_admin_value[session.save_path] = ${app_fpm_pool_home}/tmp\n" >> ${file}; \
    # change environment \
    perl -0p -i -e "s>; Default Value: clean env>; Default Value: clean env\n\n; Main variables>" ${file}; \
    perl -0p -i -e "s>;env\[HOSTNAME\] = .*>env\[HOSTNAME\] = \\\$HOSTNAME>" ${file}; \
    perl -0p -i -e "s>;env\[PATH\] = .*>env\[PATH\] = \\\$PATH>" ${file}; \
    perl -0p -i -e "s>;env\[TMP\] = .*>env\[TMP\] = ${app_fpm_pool_home}/tmp>" ${file}; \
    perl -0p -i -e "s>;env\[TMPDIR\] = .*>env\[TMPDIR\] = ${app_fpm_pool_home}/tmp>" ${file}; \
    perl -0p -i -e "s>;env\[TEMP\] = .*>env\[TEMP\] = ${app_fpm_pool_home}/tmp>" ${file}; \
    perl -0p -i -e "s>; Additional php.ini defines, specific to this pool of workers>; Proxy variables\n\n; Additional php.ini defines, specific to this pool of workers>" ${file}; \
    perl -0p -i -e "s>; Proxy variables\n>; Proxy variables\nenv\[ftp_proxy\] = \\\$ftp_proxy\n>" ${file}; \
    perl -0p -i -e "s>; Proxy variables\n>; Proxy variables\nenv\[https_proxy\] = \\\$https_proxy\n>" ${file}; \
    perl -0p -i -e "s>; Proxy variables\n>; Proxy variables\nenv\[http_proxy\] = \\\$http_proxy\n>" ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    printf "\n# Test configuration...\n"; \
    $(which php-fpm) --test; \
    printf "Done testing...\n"; \
    \
    printf "Finished updading PHP and PHP-FPM configuration...\n";

#
# Demo
#

RUN printf "Preparing demo...\n"; \
    # PHP-FPM Pool \
    app_fpm_pool_home="${app_fpm_global_home}/${app_fpm_pool_id}"; \
    \
    # ${app_fpm_pool_home}/html/index.php \
    file="${app_fpm_pool_home}/html/index.php"; \
    printf "\n# Adding demo file ${file}...\n"; \
    printf "<?php\n\
echo \"Hello World!\";\n\
\n" > ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # ${app_fpm_pool_home}/html/phpinfo.php \
    file="${app_fpm_pool_home}/html/phpinfo.php"; \
    printf "\n# Adding demo file ${file}...\n"; \
    printf "<?php\n\
phpinfo();\n\
\n" > ${file}; \
    printf "Done patching ${file}...\n";

