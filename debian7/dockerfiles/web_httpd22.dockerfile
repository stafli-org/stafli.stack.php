
#
#    Debian 7 (wheezy) PHP Stack - HTTPd22 Web Server (dockerfile)
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
FROM stafli/stafli.web.httpd:httpd22_debian7

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

ARG app_httpd_global_mods_core_dis="asis auth_digest authn_anon authn_dbd authn_dbm authnz_ldap authz_dbm authz_owner cache cern_meta cgi cgid charset_lite dav_fs dav dav_lock dbd disk_cache dump_io ext_filter file_cache filter ident imagemap include ldap log_forensic mem_cache mime_magic negotiation proxy_balancer proxy_connect proxy_ftp proxy_scgi reqtimeout speling substitute suexec unique_id userdir usertrack vhost_alias"
ARG app_httpd_global_mods_core_en="alias dir autoindex mime setenvif env expires headers deflate rewrite actions authn_default authn_alias authn_file authz_default authz_groupfile authz_host authz_user auth_basic ssl proxy proxy_ajp proxy_http info status"
ARG app_httpd_global_mods_extra_dis="authnz_external"
ARG app_httpd_global_mods_extra_en="upload_progress xsendfile proxy_fcgi"
ARG app_httpd_global_user="www-data"
ARG app_httpd_global_group="www-data"
ARG app_httpd_global_home="/var/www"
ARG app_httpd_global_loglevel="warn"
ARG app_httpd_global_listen_addr="0.0.0.0"
ARG app_httpd_global_listen_port_http="80"
ARG app_httpd_global_listen_port_https="443"
ARG app_httpd_global_listen_timeout="140"
ARG app_httpd_global_listen_keepalive_status="On"
ARG app_httpd_global_listen_keepalive_requests="100"
ARG app_httpd_global_listen_keepalive_timeout="5"
ARG app_httpd_vhost_id="default"
ARG app_httpd_vhost_user="www-data"
ARG app_httpd_vhost_group="www-data"
ARG app_httpd_vhost_listen_addr="0.0.0.0"
ARG app_httpd_vhost_listen_port_http="80"
ARG app_httpd_vhost_listen_port_https="443"
ARG app_httpd_vhost_httpd_wlist="127.0.0.1 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16"
ARG app_httpd_vhost_fpm_wlist="127.0.0.1 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16"
ARG app_httpd_vhost_fpm_addr="php56_stack_language_php56_debian7_1"
ARG app_httpd_vhost_fpm_port="9000"

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
# HTTPd DSO modules
#

# Enable/disable the httpd modules
RUN printf "Start installing modules...\n" && \
    \
    printf "Enabling/disabling modules...\n" && \
    # Core modules \
    $(which a2dismod) -f ${app_httpd_global_mods_core_dis} && \
    $(which a2enmod) -f ${app_httpd_global_mods_core_en} && \
    # Extra modules \
    $(which a2dismod) -f ${app_httpd_global_mods_extra_dis} && \
    $(which a2enmod) -f ${app_httpd_global_mods_extra_en} && \
    printf "Done enabling/disabling modules...\n" && \
    \
    printf "\nChecking modules...\n" && \
    $(which apache2ctl) -l; $(which apache2ctl) -M && \
    printf "Done checking modules...\n" && \
    \
    printf "Finished installing modules...\n";

#
# Configuration
#

# HTTPd
RUN printf "Updading HTTPd configuration...\n" && \
    \
    # /etc/apache2/envvars \
    file="/etc/apache2/envvars" && \
    printf "\n# Applying configuration for ${file}...\n" && \
    # run as user/group \
    perl -0p -i -e "s>APACHE_RUN_USER=.*>APACHE_RUN_USER=${app_httpd_global_user}>" ${file} && \
    perl -0p -i -e "s>APACHE_RUN_GROUP=.*>APACHE_RUN_GROUP=${app_httpd_global_group}>" ${file} && \
    printf "Done patching ${file}...\n" && \
    \
    # /etc/apache2/apache2.conf \
    file="/etc/apache2/apache2.conf" && \
    printf "\n# Applying configuration for ${file}...\n" && \
    # change logging \
    perl -0p -i -e "s># container, that host's errors will be logged there and not here.\n#\nErrorLog .*>ErrorLog /proc/self/fd/2>" ${file} && \
    perl -0p -i -e "s># alert, emerg.\n#\nLogLevel .*># alert, emerg.\n#\nLogLevel ${app_httpd_global_loglevel}>" ${file} && \
    # change config directory \
    perl -0p -i -e "s># Do NOT add a slash at the end of the directory path.\n#\nServerRoot .*># Do NOT add a slash at the end of the directory path.\n#\nServerRoot \"/etc/apache2\">" ${file} && \
    # change timeout \
    perl -0p -i -e "s># Timeout: The number of seconds before receives and sends time out.\n#\nTimeout .*># Timeout: The number of seconds before receives and sends time out.\n#\nTimeout ${app_httpd_global_listen_timeout}>" ${file} && \
    # change keepalive \
    perl -0p -i -e "s># one request per connection\). Set to \"Off\" to deactivate.\n#\nKeepAlive .*># one request per connection\). Set to \"Off\" to deactivate.\n#\nKeepAlive ${app_httpd_global_listen_keepalive_status}>" ${file} && \
    perl -0p -i -e "s># We recommend you leave this number high, for maximum performance.\n#\nMaxKeepAliveRequests .*># We recommend you leave this number high, for maximum performance.\n#\nMaxKeepAliveRequests ${app_httpd_global_listen_keepalive_requests}>" ${file} && \
    perl -0p -i -e "s># same client on the same connection.\n#\nKeepAliveTimeout .*># same client on the same connection.\n#\nKeepAliveTimeout ${app_httpd_global_listen_keepalive_timeout}>" ${file} && \
    # add main directory directives \
    perl -0p -i -e "s>Include ports.conf>Include ports.conf\n\n\
\# Sets the default security model of the Apache2 HTTPD server. It does\n\
\# not allow access to the root filesystem outside of /usr/share and /var/www.\n\
\# The former is used by web applications packaged in Debian,\n\
\# the latter may be used for local directories served by the web server. If\n\
\# your system is serving content from a sub-directory in /srv you must allow\n\
\# access here, or in any related virtual host.\n\
\<Directory /\>\n\
        Options FollowSymLinks\n\
        AllowOverride None\n\
        Allow from All\n\
\</Directory\>\n\
\n\
\<Directory /usr/share\>\n\
        AllowOverride None\n\
        Allow from All\n\
\</Directory\>\n\
\n\
\<Directory /var/www/\>\n\
        Options Indexes FollowSymLinks\n\
        AllowOverride None\n\
        Allow from All\n\
\</Directory\>\n\
\n\
\#\<Directory /srv/\>\n\
\#       Options Indexes FollowSymLinks\n\
\#       AllowOverride None\n\
\#       Allow from All\n\
\#\</Directory\>\n\
>" ${file} && \
    printf "Done patching ${file}...\n" && \
    \
    # /etc/apache2/ports.conf \
    file="/etc/apache2/ports.conf" && \
    printf "\n# Applying configuration for ${file}...\n" && \
    perl -0p -i -e "s>NameVirtualHost \*:80>NameVirtualHost ${app_httpd_global_listen_addr}:${app_httpd_global_listen_port_http}>g" ${file} && \
    perl -0p -i -e "s>Listen 80>Listen ${app_httpd_global_listen_addr}:${app_httpd_global_listen_port_http}>g" ${file} && \
    perl -0p -i -e "s>    Listen 443>    NameVirtualHost ${app_httpd_global_listen_addr}:${app_httpd_global_listen_port_http}\n    Listen ${app_httpd_global_listen_addr}:${app_httpd_global_listen_port_https}>g" ${file} && \
    printf "Done patching ${file}...\n" && \
    \
    # /etc/apache2/conf.d/serve-cgi-bin.conf \
    file="/etc/apache2/conf.d/serve-cgi-bin.conf" && \
    printf "\n# Applying configuration for ${file}...\n" && \
    # add universal cgi-bin configuration \
    printf "<IfModule alias_module>\n\
    ScriptAlias /cgi-bin/ /usr/lib/cgi-bin/\n\
    <Directory \"/usr/lib/cgi-bin\">\n\
        AllowOverride None\n\
        Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch\n\
        Order Allow,Deny\n\
        Allow from All\n\
    </Directory>\n\
</IfModule>\n\
\n" > ${file} && \
    printf "Done patching ${file}...\n" && \
    \
    # /etc/apache2/conf.d/security.conf \
    file="/etc/apache2/conf.d/security.conf" && \
    printf "\n# Applying configuration for ${file}...\n" && \
    # disable/replace badly configured defaults \
    perl -0p -i -e "s>#ServerTokens Minimal\nServerTokens OS\n#ServerTokens Full>ServerTokens Minor>" ${file} && \
    perl -0p -i -e "s>#ServerSignature Off\nServerSignature On>ServerSignature On>" ${file} && \
    printf "Done patching ${file}...\n" && \
    \
    # /etc/apache2/mods-available/ssl.conf \
    file="/etc/apache2/mods-available/ssl.conf" && \
    printf "\n# Applying configuration for ${file}...\n" && \
    # disable/replace badly configured defaults \
    perl -0p -i -e "s>.*SSLProtocol all .*>SSLProtocol all -SSLv2 -SSLv3>" ${file} && \
    perl -0p -i -e "s>.*SSLCipherSuite RC4.*>SSLCipherSuite ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA256:DHE-RSA-AES256-SHA:ECDHE-ECDSA-DES-CBC3-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:DES-CBC3-SHA:!DSS>" ${file} && \
    perl -0p -i -e "s>.*SSLHonorCipherOrder on>SSLHonorCipherOrder On>" ${file} && \
    perl -0p -i -e "s>\n\</IfModule\>>\n\
\# See more information at:\n\
\# https://mozilla.github.io/server-side-tls/ssl-config-generator/\?server=apache-2.2.22\&openssl=1.0.1p\&hsts=no\&profile=intermediate\n\
\n\</IfModule\>>" ${file} && \
    printf "Done patching ${file}...\n" && \
    \
    # /etc/apache2/conf.d/other-vhosts-access-log.conf \
    file="/etc/apache2/conf.d/other-vhosts-access-log.conf" && \
    printf "\n# Applying configuration for ${file}...\n" && \
    # change logging \
    perl -0p -i -e "s>CustomLog .*>CustomLog /proc/self/fd/1 vhost_combined>" ${file} && \
    printf "Done patching ${file}...\n" && \
    \
    # HTTPd vhost \
    app_httpd_vhost_home="${app_httpd_global_home}/${app_httpd_vhost_id}" && \
    \
    # /etc/apache2/incl.d/${app_httpd_vhost_id}-httpd.conf \
    file="/etc/apache2/incl.d/${app_httpd_vhost_id}-httpd.conf" && \
    printf "\n# Applying configuration for ${file}...\n" && \
    printf "# HTTPd info and status\n\
<IfModule info_module>\n\
  # HTTPd info\n\
  <Location /httpd-info>\n\
    SetHandler server-info\n\
    Allow from ${app_httpd_vhost_httpd_wlist}\n\
  </Location>\n\
</IfModule>\n\
<IfModule status_module>\n\
  # HTTPd status\n\
  <Location /httpd-status>\n\
    SetHandler server-status\n\
    Allow from ${app_httpd_vhost_httpd_wlist}\n\
  </Location>\n\
</IfModule>\n\
\n" > ${file} && \
    printf "Done patching ${file}...\n" && \
    \
    # /etc/apache2/incl.d/${app_httpd_vhost_id}-php-fpm.conf \
    file="/etc/apache2/incl.d/${app_httpd_vhost_id}-php-fpm.conf" && \
    printf "\n# Applying configuration for ${file}...\n" && \
    printf "# Pool for PHP-FPM\n\
<IfModule proxy_fcgi_module>\n\
  DirectoryIndex index.php\n\
  ProxyPassMatch ^/(.*\.php(/.*)?)$ fcgi://${app_httpd_vhost_fpm_addr}:${app_httpd_vhost_fpm_port}${app_httpd_vhost_home}/html/\$1\n\
  # PHP-FPM status and ping\n\
  <LocationMatch /(phpfpm-status|phpfpm-ping)>\n\
    ProxyPassMatch fcgi://${app_httpd_vhost_fpm_addr}:${app_httpd_vhost_fpm_port}${app_httpd_vhost_home}/html/\$1\n\
    Allow from ${app_httpd_vhost_fpm_wlist}\n\
  </LocationMatch>\n\
</IfModule>\n\
\n" > ${file} && \
    printf "Done patching ${file}...\n" && \
    \
    # /etc/apache2/sites-available/${app_httpd_vhost_id}-http.conf \
    file="/etc/apache2/sites-available/${app_httpd_vhost_id}-http.conf" && \
    cp "/etc/apache2/sites-available/000-default.conf.orig" $file && \
    printf "\n# Applying configuration for ${file}...\n" && \
    # change address and port
    perl -0p -i -e "s>\<VirtualHost .*\>>\<VirtualHost ${app_httpd_vhost_listen_addr}:${app_httpd_vhost_listen_port_http}\>>" ${file} && \
    # change logging
    perl -0p -i -e "s>ErrorLog .*>ErrorLog /proc/self/fd/2>" ${file} && \
    perl -0p -i -e "s>CustomLog .*>CustomLog /proc/self/fd/1 combined>" ${file} && \
    # change document root
    perl -0p -i -e "s>DocumentRoot .*>DocumentRoot ${app_httpd_vhost_home}/html>" ${file} && \
    # remove old directory directives \
    perl -0p -i -e "s>.*\<Directory /\>\n\
.*Options FollowSymLinks\n\
.*AllowOverride None\n\
.*\</Directory\>\n\
.*\<Directory /var/www/\>\n\
.*Options Indexes FollowSymLinks MultiViews\n\
.*AllowOverride None\n\
.*Order allow,deny\n\
.*allow from all\n\
.*\</Directory\>\
>>" ${file} && \
    # add directory directives
    perl -0p -i -e "s>\</VirtualHost\>>\n\
        \<Directory ${app_httpd_vhost_home}/html\>\n\
          Options Indexes FollowSymLinks\n\
          AllowOverride All\n\
          Allow from All\n\
        \</Directory\>\n\
\</VirtualHost\>\n\
>" ${file} && \
    # add httpd include \
    perl -0p -i -e "s>ScriptAlias ># HTTPd info and status\n\
        Include incl.d/${app_httpd_vhost_id}-httpd.conf\n\n\
        ScriptAlias \
>" ${file} && \
    # add php-fpm include \
    perl -0p -i -e "s>ScriptAlias ># PHP-FPM proxy \n\
        Include incl.d/${app_httpd_vhost_id}-php-fpm.conf\n\n\
        ScriptAlias \
>" ${file} && \
    printf "Done patching ${file}...\n" && \
    \
    # /etc/apache2/sites-available/${app_httpd_vhost_id}-https.conf \
    file="/etc/apache2/sites-available/${app_httpd_vhost_id}-https.conf" && \
    cp "/etc/apache2/sites-available/000-default-ssl.conf.orig" $file && \
    printf "\n# Applying configuration for ${file}...\n" && \
    # change address and port
    perl -0p -i -e "s>\<VirtualHost .*\>>\<VirtualHost ${app_httpd_vhost_listen_addr}:${app_httpd_vhost_listen_port_https}\>>" ${file} && \
    # change logging
    perl -0p -i -e "s>ErrorLog .*>ErrorLog /proc/self/fd/2>" ${file} && \
    perl -0p -i -e "s>CustomLog .*>CustomLog /proc/self/fd/1 combined>" ${file} && \
    # change document root
    perl -0p -i -e "s>DocumentRoot .*>DocumentRoot ${app_httpd_vhost_home}/html>" ${file} && \
    # remove old directory directives \
    perl -0p -i -e "s>.*\<Directory /\>\n\
.*Options FollowSymLinks\n\
.*AllowOverride None\n\
.*\</Directory\>\n\
.*\<Directory /var/www/\>\n\
.*Options Indexes FollowSymLinks MultiViews\n\
.*AllowOverride None\n\
.*Order allow,deny\n\
.*allow from all\n\
.*\</Directory\>\
>>" ${file} && \
    # add directory directives
    perl -0p -i -e "s>\</VirtualHost\>>\n\
        \<Directory ${app_httpd_vhost_home}/html\>\n\
          Options Indexes FollowSymLinks\n\
          AllowOverride All\n\
          Allow from All\n\
        \</Directory\>\n\
\</VirtualHost\>\n\
>" ${file} && \
    # add httpd include \
    perl -0p -i -e "s>ScriptAlias ># HTTPd info and status\n\
        Include incl.d/${app_httpd_vhost_id}-httpd.conf\n\n\
        ScriptAlias \
>" ${file} && \
    # add php-fpm include \
    perl -0p -i -e "s>ScriptAlias ># PHP-FPM proxy \n\
        Include incl.d/${app_httpd_vhost_id}-php-fpm.conf\n\n\
        ScriptAlias \
>" ${file} && \
    printf "Done patching ${file}...\n" && \
    \
    printf "\n# Generating certificates...\n" && \
    make-ssl-cert generate-default-snakeoil --force-overwrite && \
    printf "\n# Done generating certificates...\n" && \
    \
    printf "\n# Enabling/disabling vhosts...\n" && \
    a2ensite ${app_httpd_vhost_id}-http.conf ${app_httpd_vhost_id}-https.conf && \
    printf "\n# Done enabling/disabling vhosts...\n" && \
    \
    printf "\n# Testing configuration...\n" && \
    echo "Testing $(which apache2ctl):"; $(which apache2ctl) -V; $(which apache2ctl) configtest; $(which apache2ctl) -S && \
    printf "Done testing configuration...\n" && \
    \
    printf "Finished updading HTTPd configuration...\n";

#
# Demo
#

RUN printf "Preparing demo...\n" && \
    # HTTPd vhost \
    app_httpd_vhost_home="${app_httpd_global_home}/${app_httpd_vhost_id}" && \
    \
    # ${app_httpd_vhost_home}/html/index.php \
    file="${app_httpd_vhost_home}/html/index.php" && \
    printf "\n# Adding demo file ${file}...\n" && \
    printf "<?php\n\
echo \"Hello World!\";\n\
\n" > ${file} && \
    printf "Done patching ${file}...\n" && \
    \
    # ${app_httpd_vhost_home}/html/phpinfo.php \
    file="${app_httpd_vhost_home}/html/phpinfo.php" && \
    printf "\n# Adding demo file ${file}...\n" && \
    printf "<?php\n\
phpinfo();\n\
\n" > ${file} && \
    printf "Done patching ${file}...\n";

#
# Run
#

# Command to execute
# Defaults to /bin/bash.
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf", "--nodaemon"]

# Ports to expose
# Defaults to 80 and 443
EXPOSE ${app_httpd_global_listen_port_http}
EXPOSE ${app_httpd_global_listen_port_https}

