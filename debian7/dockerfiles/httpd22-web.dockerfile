
#
#    Debian 7 (wheezy) HTTPd22 Web profile (dockerfile)
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

FROM solict/general-purpose-system-distro:debian7_devel
MAINTAINER Luís Pedro Algarvio <lp.algarvio@gmail.com>

#
# Arguments
#

ARG app_httpd_global_mods_core_dis="asis auth_digest authn_anon authn_dbd authn_dbm authnz_ldap authz_dbm authz_owner cache cern_meta cgi cgid charset_lite dav_fs dav dav_lock dbd disk_cache dump_io ext_filter file_cache filter ident imagemap include ldap log_forensic mem_cache mime_magic negotiation proxy_balancer proxy_connect proxy_ftp proxy_scgi reqtimeout speling substitute suexec unique_id userdir usertrack vhost_alias"
ARG app_httpd_global_mods_core_en="alias dir autoindex mime setenvif env expires headers deflate rewrite actions authn_default authn_alias authn_file authz_default authz_groupfile authz_host authz_user auth_basic ssl proxy proxy_ajp proxy_http info status"
ARG app_httpd_global_mods_extra_dis="authnz_external"
ARG app_httpd_global_mods_extra_en="upload_progress xsendfile proxy_fcgi"
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
# - apache2-threaded-dev: the HTTPd development libraries
# - apache2-utils: for ab and others, the HTTPd utilities
# - apachetop: for apachetop, the top-like utility for HTTPd
# - apache2-mpm-worker: the Worker MPM module
# - libapache2-mod-authnz-external: the External Authentication DSO module
# - pwauth: for pwauth, the authenticator for mod_authnz_external
# - libapache2-mod-xsendfile: the X-Sendfile DSO module
# - libapache2-mod-upload-progress: the Upload Progress DSO module
RUN printf "# Install the HTTPd packages...\n" && \
    apt-get update && apt-get install -qy \
      apache2 apache2-threaded-dev \
      apache2-utils apachetop \
      apache2-mpm-worker \
      libapache2-mod-authnz-external pwauth \
      libapache2-mod-xsendfile libapache2-mod-upload-progress && \
    printf "# Cleanup the Package Manager...\n" && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

#
# HTTPd DSO modules
#

# Build and Install HTTPd modules
# - Proxy FastCGI (mod_proxy_fcgi)
# Enable/Disable HTTPd modules
RUN printf "# Start installing modules...\n" && \
    \
    printf "# Building the Proxy FastCGI (mod_proxy_fcgi) module...\n" && \
    ( \
      wget -qO- https://github.com/ceph/mod-proxy-fcgi/archive/master.tar.gz | tar xz && cd mod-proxy-fcgi-master && \
      ln -sf apxs2 /usr/bin/apxs && \
      autoconf && ./configure && \
      sed -i "s>top_srcdir\=>top_srcdir\=.>" Makefile && \
      mkdir -p build && ln -sf /usr/share/apache2/build/instdso.sh build/instdso.sh && \
      make && make install && make clean && \
      chmod 644 /usr/lib/apache2/modules/mod_proxy_fcgi.so && \
      rm /usr/bin/apxs && \
      cd .. && rm -Rf mod-proxy-fcgi \
    ) && \
    printf "# Depends: proxy\n\
LoadModule proxy_fcgi_module /usr/lib/apache2/modules/mod_proxy_fcgi.so\n\
\n" > /etc/apache2/mods-available/proxy_fcgi.load && \
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
      --shell /bin/false \
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
    # /etc/apache2/apache2.conf \
    file="/etc/apache2/apache2.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    # run as user/group \
    perl -0p -i -e "s># These need to be set in /etc/apache2/envvars\nUser = .*\nGroup = .*># These need to be set in /etc/apache2/envvars\nUser = \${APACHE_RUN_USER}\nGroup = \${APACHE_RUN_GROUP}>" ${file}; \
    # change log level \
    perl -0p -i -e "s># alert, emerg.\n#\nLogLevel .*># alert, emerg.\n#\nLogLevel ${app_httpd_global_loglevel}>" ${file}; \
    # change config directories \
    perl -0p -i -e "s># Do NOT add a slash at the end of the directory path.\n#\nServerRoot .*># Do NOT add a slash at the end of the directory path.\n#\nServerRoot \"/etc/apache2\">" ${file}; \
    # replace optional config files \
    perl -0p -i -e "s># Include generic snippets of statements\nInclude conf.d/># Include generic snippets of statements\nInclude conf.d/\*.conf>" ${file}; \
    # replace vhost config files \
    perl -0p -i -e "s># Include the virtual host configurations:\nInclude sites-enabled/># Include the virtual host configurations:\nInclude sites-enabled/\*.conf>" ${file}; \
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
    perl -0p -i -e "s>NameVirtualHost *:80>NameVirtualHost ${app_httpd_global_listen_addr}:${app_httpd_global_listen_port_http}>g" ${file}; \
    perl -0p -i -e "s>Listen 443>NameVirtualHost ${app_httpd_global_listen_addr}:${app_httpd_global_listen_port_http}\nListen ${app_httpd_global_listen_addr}:${app_httpd_global_listen_port_https}>g" ${file}; \
    printf "Done patching ${file}...\n";

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

