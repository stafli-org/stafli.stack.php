
#
#    CentOS 7 (centos7) HTTPd24 Proxy profile (dockerfile)
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

ARG app_httpd_global_mods_core_dis=""
ARG app_httpd_global_mods_core_en=""
ARG app_httpd_global_mods_extra_dis=""
ARG app_httpd_global_mods_extra_en=""
ARG app_httpd_global_user="apache"
ARG app_httpd_global_group="apache"
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
# - httpd: for httpd, the HTTPd server
# - httpd-tools: for ab and others, the HTTPd utilities
# - apachetop: for apachetop, the top-like utility for HTTPd
# - mod_ssl: the OpenSSL DSO module
# - mod_authnz_external: the External Authentication DSO module
# - mod_xsendfile: the X-Sendfile DSO module
RUN printf "# Install the HTTPd packages...\n" && \
    yum makecache && yum install -y \
      httpd \
      httpd-tools apachetop \
      mod_ssl \
      mod_authnz_external pwauth \
      mod_xsendfile && \
    printf "# Cleanup the Package Manager...\n" && \
    yum clean all && rm -Rf /var/lib/yum/*;

#
# HTTPd DSO modules
#

# Enable/Disable HTTPd modules
RUN printf "# Start installing modules...\n" && \
    \
    printf "# Enabling/disabling modules...\n" && \
    # Core modules \
    echo "a2dismod -f ${app_httpd_global_mods_core_dis}" && \
    echo "a2enmod -f ${app_httpd_global_mods_core_en}" && \
    # Extra modules \
    echo "a2dismod -f ${app_httpd_global_mods_extra_dis}" && \
    echo "a2enmod -f ${app_httpd_global_mods_extra_en}" && \
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
    # /etc/supervisord.d/init.conf \
    file="/etc/supervisord.d/init.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    perl -0p -i -e "s>supervisorctl start dropbear;>supervisorctl start dropbear; supervisorctl start httpd;>" ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/supervisord.d/httpd.conf \
    file="/etc/supervisord.d/httpd.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    printf "# httpd\n\
[program:httpd]\n\
command=/bin/bash -c \"\$(which apachectl) -d /etc/httpd -f /etc/httpd/conf/httpd.conf -D FOREGROUND\"\n\
autostart=false\n\
autorestart=true\n\
\n" > ${file}; \
    printf "Done patching ${file}...\n";

# HTTPd
RUN printf "Updading HTTPd configuration...\n"; \
    \
    touch /etc/httpd/ports.conf; \
    mkdir /etc/httpd/sites.d; \
    \
    # /etc/httpd/conf/httpd.conf \
    file="/etc/httpd/conf/httpd.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    # run as user/group \
    perl -0p -i -e "s>#  don't use Group #-1 on these systems!\n#\nUser = .*\nGroup = .*>#  don't use Group #-1 on these systems!\n#\nUser = ${app_httpd_global_user}\nGroup = ${app_httpd_global_group}>" ${file}; \
    # change log level \
    perl -0p -i -e "s># alert, emerg.\n#\nLogLevel .*># alert, emerg.\n#\nLogLevel ${app_httpd_global_loglevel}>" ${file}; \
    # change config directory \
    perl -0p -i -e "s># Do NOT add a slash at the end of the directory path.\n#\nServerRoot .*># Do NOT add a slash at the end of the directory path.\n#\nServerRoot \"/etc/httpd\">" ${file}; \
    # replace ports with config file \
    perl -0p -i -e "s>#\n# Listen: Allows you to bind Apache to specific IP addresses and/or\n# ports, instead of the default. See also the \<VirtualHost\>\n# directive.\n#\n# Change this to Listen on specific IP addresses as shown below to \n# prevent Apache from glomming onto all bound IP addresses.\n#\n#Listen 12.34.56.78:80\nListen 80\n\n>>" ${file}; \
    printf "\n\
# Include list of ports to listen on\n\
Include ports.conf\n\
" >> ${file}; \
    # add vhost config files \
    printf "\n\
# Include the virtual host configurations\n\
Include sites.d/*.conf\n\
" >> ${file}; \
    # change timeout \
    perl -0p -i -e "s># Timeout: The number of seconds before receives and sends time out.\n#\nTimeout .*># Timeout: The number of seconds before receives and sends time out.\n#\nTimeout ${app_httpd_global_listen_timeout}>" ${file}; \
    # change keepalive \
    perl -0p -i -e "s># one request per connection\). Set to \"Off\" to deactivate.\n#\nKeepAlive .*># one request per connection\). Set to \"Off\" to deactivate.\n#\nKeepAlive ${app_httpd_global_listen_keepalive_status}>" ${file}; \
    perl -0p -i -e "s># We recommend you leave this number high, for maximum performance.\n#\nMaxKeepAliveRequests .*># We recommend you leave this number high, for maximum performance.\n#\nMaxKeepAliveRequests ${app_httpd_global_listen_keepalive_requests}>" ${file}; \
    perl -0p -i -e "s># same client on the same connection.\n#\nKeepAliveTimeout .*># same client on the same connection.\n#\nKeepAliveTimeout ${app_httpd_global_listen_keepalive_timeout}>" ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/httpd/ports.conf \
    file="/etc/httpd/ports.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    printf "\
# If you just change the port or add more ports here, you will likely also\n\
# have to change the VirtualHost statement in\n\
# /etc/httpd/sites.d/000-default.conf\n\
\n\
Listen ${app_httpd_global_listen_addr}:${app_httpd_global_listen_port_http}\n\
\n\
<IfModule ssl_module>\n\
    Listen ${app_httpd_global_listen_addr}:${app_httpd_global_listen_port_https}\n\
</IfModule>\n\
\n\
<IfModule gnutls_module>\n\
    Listen ${app_httpd_global_listen_addr}:${app_httpd_global_listen_port_https}\n\
</IfModule>\n\
" > ${file}; \
    printf "Done patching ${file}...\n";

