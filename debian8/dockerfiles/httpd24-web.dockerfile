
#
#    Debian 8 (jessie) HTTPd24 Web profile (dockerfile)
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

FROM solict/general-purpose-system-distro:debian8_standard
MAINTAINER Luís Pedro Algarvio <lp.algarvio@gmail.com>

#
# Arguments
#

ARG app_httpd_global_mods_core_dis="allowmethods asis auth_digest auth_form authn_anon authn_dbd authn_dbm authn_socache authnz_fcgi authnz_ldap authz_dbd authz_dbm authz_owner buffer cache cache_disk cache_socache cgi cgid charset_lite dav_fs dav dav_lock data dbd dialup dump_io echo ext_filter file_cache heartbeat heartmonitor ident include lbmethod_bybusyness lbmethod_byrequests lbmethod_bytraffic lbmethod_heartbeat ldap log_debug log_forensic lua mime_magic negotiation proxy_balancer proxy_connect proxy_express proxy_fdpass proxy_ftp proxy_html proxy_scgi proxy_wstunnel ratelimit reflector remoteip reqtimeout request sed session_crypto session_dbd slotmem_plain slotmem_shm socache_dbm socache_memcache speling substitute suexec unique_id userdir usertrack vhost_alias xml2enc"
ARG app_httpd_global_mods_core_en="mpm_event macro alias dir autoindex mime setenvif env expires headers filter deflate rewrite actions authn_core authn_file authz_core authz_groupfile authz_host authz_user auth_basic access_compat session session_cookie socache_shmcb ssl proxy proxy_ajp proxy_fcgi proxy_http info status"
ARG app_httpd_global_mods_extra_dis="authnz_external"
ARG app_httpd_global_mods_extra_en="upload_progress xsendfile"
ARG app_httpd_global_user="www-data"
ARG app_httpd_global_group="www-data"
ARG app_httpd_global_loglevel="warn"
ARG app_httpd_global_listen_addr="0.0.0.0"
ARG app_httpd_global_listen_port_http="80"
ARG app_httpd_global_listen_port_https="443"
ARG app_httpd_global_listen_timeout="140"
ARG app_httpd_global_listen_keepalive_status="On"
ARG app_httpd_global_listen_keepalive_requests="100"
ARG app_httpd_global_listen_keepalive_timeout="5"

#
# Packages
#

# Install the HTTPd packages
# - apache2: for apache2, the HTTPd server
# - apache2-utils: for ab and others, the HTTPd utilities
# - apachetop: for apachetop, the top-like utility for HTTPd
# - apache2-mpm-event: the Event MPM module
# - libapache2-mod-authnz-external: the External Authentication DSO module
# - pwauth: for pwauth, the authenticator for mod_authnz_external
# - libapache2-mod-xsendfile: the X-Sendfile DSO module
# - libapache2-mod-upload-progress: the Upload Progress DSO module
# - ssl-cert: for make-ssl-cert, to generate certificates
RUN printf "# Install the HTTPd packages...\n" && \
    apt-get update && apt-get install -qy \
      apache2 \
      apache2-utils apachetop \
      apache2-mpm-event \
      libapache2-mod-authnz-external pwauth \
      libapache2-mod-xsendfile libapache2-mod-upload-progress \
      ssl-cert && \
    printf "# Cleanup the Package Manager...\n" && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

#
# HTTPd DSO modules
#

# Enable/Disable HTTPd modules
RUN printf "# Start installing modules...\n" && \
    \
    printf "# Enabling/disabling modules...\n" && \
    # Core modules \
    a2dismod -f ${app_httpd_global_mods_core_dis} && \
    a2enmod -f ${app_httpd_global_mods_core_en} && \
    # Extra modules \
    a2dismod -f ${app_httpd_global_mods_extra_dis} && \
    a2enmod -f ${app_httpd_global_mods_extra_en} && \
    \
    printf "# Finished installing modules...\n";

#
# Configuration
#

# Add users and groups
RUN printf "Adding users and groups...\n"; \
    id -g ${app_httpd_global_user} || \
    groupadd \
      --system ${app_httpd_global_group} && \
    id -u ${app_httpd_global_user} || \
    useradd \
      --system --gid ${app_httpd_global_group} \
      --no-create-home --home-dir /var/www \
      --shell /usr/sbin/nologin \
      ${app_httpd_global_user};

# Supervisor
RUN printf "Updading Supervisor configuration...\n"; \
    \
    # /etc/supervisor/conf.d/init.conf \
    file="/etc/supervisor/conf.d/init.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    perl -0p -i -e "s>supervisorctl start dropbear;>supervisorctl start dropbear; supervisorctl start httpd;>" ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/supervisor/conf.d/httpd.conf \
    file="/etc/supervisor/conf.d/httpd.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    printf "# httpd\n\
[program:httpd]\n\
command=/bin/bash -c \"\$(which apache2ctl) -d /etc/apache2 -f /etc/apache2/apache2.conf -D FOREGROUND\"\n\
autostart=false\n\
autorestart=true\n\
\n" > ${file}; \
    printf "Done patching ${file}...\n";

# HTTPd
RUN printf "Updading HTTPd configuration...\n"; \
    \
    mkdir /etc/apache2/incl.d; \
    \
    # /etc/apache2/apache2.conf \
    file="/etc/apache2/apache2.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    # run as user/group \
    perl -0p -i -e "s># These need to be set in /etc/apache2/envvars\nUser = .*\nGroup = .*># These need to be set in /etc/apache2/envvars\nUser = \${APACHE_RUN_USER}\nGroup = \${APACHE_RUN_GROUP}>" ${file}; \
    # change log level \
    perl -0p -i -e "s># alert, emerg.\n#\nLogLevel .*># alert, emerg.\n#\nLogLevel ${app_httpd_global_loglevel}>" ${file}; \
    # change config directories \
    perl -0p -i -e "s># Do NOT add a slash at the end of the directory path.\n#\nServerRoot .*># Do NOT add a slash at the end of the directory path.\n#\nServerRoot \"/etc/apache2\">" ${file}; \
    # change timeout \
    perl -0p -i -e "s># Timeout: The number of seconds before receives and sends time out.\n#\nTimeout .*># Timeout: The number of seconds before receives and sends time out.\n#\nTimeout ${app_httpd_global_listen_timeout}>" ${file}; \
    # change keepalive \
    perl -0p -i -e "s># one request per connection\). Set to \"Off\" to deactivate.\n#\nKeepAlive .*># one request per connection\). Set to \"Off\" to deactivate.\n#\nKeepAlive ${app_httpd_global_listen_keepalive_status}>" ${file}; \
    perl -0p -i -e "s># We recommend you leave this number high, for maximum performance.\n#\nMaxKeepAliveRequests .*># We recommend you leave this number high, for maximum performance.\n#\nMaxKeepAliveRequests ${app_httpd_global_listen_keepalive_requests}>" ${file}; \
    perl -0p -i -e "s># same client on the same connection.\n#\nKeepAliveTimeout .*># same client on the same connection.\n#\nKeepAliveTimeout ${app_httpd_global_listen_keepalive_timeout}>" ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/apache2/ports.conf \
    file="/etc/apache2/ports.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    perl -0p -i -e "s>Listen 80>Listen ${app_httpd_global_listen_addr}:${app_httpd_global_listen_port_http}>g" ${file}; \
    perl -0p -i -e "s>Listen 443>Listen ${app_httpd_global_listen_addr}:${app_httpd_global_listen_port_https}>g" ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/apache2/incl.d/000-php-fpm.conf \
    file="/etc/apache2/incl.d/000-php-fpm.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    printf "# Pool for PHP-FPM\n\
<IfModule proxy_fcgi_module>\n\
DirectoryIndex index.php\n\
ProxyPassMatch ^/(.*\.php(/.*)?)$ fcgi://debian8_php56_1:9000/\$1\n\
</IfModule>\n\
\n" > ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/apache2/sites-available/000-default.conf \
    file="/etc/apache2/sites-available/000-default.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    # add php-fpm include \
    perl -0p -i -e "s>#Include conf-available/serve-cgi-bin.conf>#Include conf-available/serve-cgi-bin.conf\n\n\
        # Worker for PHP-FPM\n\
        Include incl.d/000-php-fpm.conf\
>" ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/apache2/sites-available/default-ssl.conf \
    file="/etc/apache2/sites-available/default-ssl.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    # add php-fpm include \
    perl -0p -i -e "s>#Include conf-available/serve-cgi-bin.conf>#Include conf-available/serve-cgi-bin.conf\n\n\
                # Worker for PHP-FPM\n\
                Include incl.d/000-php-fpm.conf\
>" ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    printf "\n# Generate certificates...\n"; \
    make-ssl-cert generate-default-snakeoil --force-overwrite; \
    \
    printf "\n# Enable sites...\n"; \
    mv /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-available/000-default-ssl.conf; \
    a2ensite 000-default 000-default-ssl;

#
# Demo
#

RUN printf "Preparing demo...\n"; \
    # HTTPd vhost \
    app_httpd_vhost_home="/var/www"; \
    \
    # ${app_httpd_vhost_home}/html/index.php \
    file="${app_httpd_vhost_home}/html/index.php"; \
    printf "\n# Adding demo file ${file}...\n"; \
    printf "<?php\n\
echo \"Hello World!\";\n\
\n" > ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # ${app_httpd_vhost_home}/html/phpinfo.php \
    file="${app_httpd_vhost_home}/html/phpinfo.php"; \
    printf "\n# Adding demo file ${file}...\n"; \
    printf "<?php\n\
phpinfo();\n\
\n" > ${file}; \
    printf "Done patching ${file}...\n";

