
#
#    CentOS 7 (centos7) HTTPd24 Proxy service (dockerfile)
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

FROM stafli/stafli.httpd.proxy:centos7_httpd24

#
# Arguments
#

ARG app_httpd_global_mods_core_dis=""
ARG app_httpd_global_mods_core_en=""
ARG app_httpd_global_mods_extra_dis=""
ARG app_httpd_global_mods_extra_en=""
ARG app_httpd_global_user="apache"
ARG app_httpd_global_group="apache"
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
ARG app_httpd_vhost_user="apache"
ARG app_httpd_vhost_group="apache"
ARG app_httpd_vhost_listen_addr="0.0.0.0"
ARG app_httpd_vhost_listen_port_http="80"
ARG app_httpd_vhost_listen_port_https="443"
ARG app_httpd_vhost_httpd_wlist="ip 127.0.0.1 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16"

#
# Packages
#

#
# HTTPd DSO modules
#

# Enable/Disable HTTPd modules
RUN printf "Enabling/disabling modules...\n" && \
    \
    # /etc/httpd/conf.modules.d/00-base.conf \
    file="/etc/httpd/conf.modules.d/00-base.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    # replace load module \
    perl -0p -i -e "s>.*LoadModule access_compat_module>LoadModule access_compat_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule actions_module>LoadModule actions_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule alias_module>LoadModule alias_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule allowmethods_module>LoadModule allowmethods_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule auth_basic_module>LoadModule auth_basic_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule auth_digest_module>#LoadModule auth_digest_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule authn_anon_module>#LoadModule authn_anon_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule authn_core_module>LoadModule authn_core_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule authn_dbd_module>#LoadModule authn_dbd_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule authn_dbm_module>#LoadModule authn_dbm_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule authn_file_module>LoadModule authn_file_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule authn_socache_module>#LoadModule authn_socache_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule authz_core_module>LoadModule authz_core_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule authz_dbd_module>#LoadModule authz_dbd_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule authz_dbm_module>#LoadModule authz_dbm_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule authz_groupfile_module>LoadModule authz_groupfile_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule authz_host_module>LoadModule authz_host_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule authz_owner_module>LoadModule authz_owner_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule authz_user_module>LoadModule authz_user_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule autoindex_module>LoadModule autoindex_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule cache_module>#LoadModule cache_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule cache_disk_module>#LoadModule cache_disk_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule data_module>#LoadModule data_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule dbd_module>#LoadModule dbd_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule deflate_module>LoadModule deflate_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule dir_module>LoadModule dir_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule dumpio_module>#LoadModule dumpio_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule echo_module>#LoadModule echo_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule env_module>LoadModule env_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule expires_module>LoadModule expires_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule ext_filter_module>LoadModule ext_filter_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule filter_module>LoadModule filter_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule headers_module>LoadModule headers_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule include_module>#LoadModule include_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule info_module>LoadModule info_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule log_config_module>LoadModule log_config_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule logio_module>LoadModule logio_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule mime_magic_module>#LoadModule mime_magic_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule mime_module>LoadModule mime_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule negotiation_module>#LoadModule negotiation_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule remoteip_module>#LoadModule remoteip_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule reqtimeout_module>#LoadModule reqtimeout_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule rewrite_module>LoadModule rewrite_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule setenvif_module>LoadModule setenvif_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule slotmem_plain_module>#LoadModule slotmem_plain_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule slotmem_shm_module>#LoadModule slotmem_shm_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule socache_dbm_module>#LoadModule socache_dbm_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule socache_memcache_module>#LoadModule socache_memcache_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule socache_shmcb_module>LoadModule socache_shmcb_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule status_module>LoadModule status_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule substitute_module>#LoadModule substitute_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule suexec_module>#LoadModule suexec_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule unique_id_module>#LoadModule unique_id_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule unixd_module>LoadModule unixd_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule userdir_module>#LoadModule userdir_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule version_module>LoadModule version_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule vhost_alias_module>#LoadModule vhost_alias_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule buffer_module>#LoadModule buffer_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule watchdog_module>#LoadModule watchdog_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule heartbeat_module>#LoadModule heartbeat_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule heartmonitor_module>#LoadModule heartmonitor_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule usertrack_module>#LoadModule usertrack_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule dialup_module>#LoadModule dialup_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule charset_lite_module>#LoadModule charset_lite_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule log_debug_module>#LoadModule log_debug_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule ratelimit_module>#LoadModule ratelimit_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule reflector_module>#LoadModule reflector_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule request_module>#LoadModule request_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule sed_module>#LoadModule sed_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule speling_module>#LoadModule speling_module>" ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/httpd/conf.modules.d/00-dav.conf \
    file="/etc/httpd/conf.modules.d/00-dav.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    # replace load module \
    perl -0p -i -e "s>.*LoadModule dav_module>#LoadModule dav_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule dav_fs_module>#LoadModule dav_fs_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule dav_lock_module>#LoadModule dav_lock_module>" ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/httpd/conf.modules.d/00-lua.conf \
    file="/etc/httpd/conf.modules.d/00-lua.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    # replace load module \
    perl -0p -i -e "s>.*LoadModule lua_module>#LoadModule lua_module>" ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/httpd/conf.modules.d/00-mpm.conf \
    file="/etc/httpd/conf.modules.d/00-mpm.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    # replace load module \
    perl -0p -i -e "s>.*LoadModule mpm_prefork_module>#LoadModule mpm_prefork_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule mpm_worker_module>#LoadModule mpm_worker_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule mpm_event_module>LoadModule mpm_event_module>" ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/httpd/conf.modules.d/00-proxy.conf \
    file="/etc/httpd/conf.modules.d/00-proxy.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    # replace load module \
    perl -0p -i -e "s>.*LoadModule proxy_module>LoadModule proxy_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule lbmethod_bybusyness_module>#LoadModule lbmethod_bybusyness_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule lbmethod_byrequests_module>#LoadModule lbmethod_byrequests_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule lbmethod_bytraffic_module>#LoadModule lbmethod_bytraffic_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule lbmethod_heartbeat_module>#LoadModule lbmethod_heartbeat_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule proxy_ajp_module>#LoadModule proxy_ajp_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule proxy_balancer_module>#LoadModule proxy_balancer_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule proxy_connect_module>#LoadModule proxy_connect_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule proxy_express_module>#LoadModule proxy_express_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule proxy_fcgi_module>#LoadModule proxy_fcgi_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule proxy_fdpass_module>#LoadModule proxy_fdpass_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule proxy_ftp_module>#LoadModule proxy_ftp_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule proxy_http_module>LoadModule proxy_http_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule proxy_scgi_module>#LoadModule proxy_scgi_module>" ${file}; \
    perl -0p -i -e "s>.*LoadModule proxy_wstunnel_module>#LoadModule proxy_wstunnel_module>" ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/httpd/conf.modules.d/00-ssl.conf \
    file="/etc/httpd/conf.modules.d/00-ssl.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    # replace load module \
    perl -0p -i -e "s>.*LoadModule ssl_module>LoadModule ssl_module>" ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/httpd/conf.modules.d/00-systemd.conf \
    file="/etc/httpd/conf.modules.d/00-systemd.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    # replace load module \
    perl -0p -i -e "s>.*LoadModule systemd_module>LoadModule systemd_module>" ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/httpd/conf.modules.d/01-cgi.conf \
    file="/etc/httpd/conf.modules.d/01-cgi.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    # replace load module \
    perl -0p -i -e "s>.*LoadModule cgid_module>#LoadModule cgid_module>g" ${file}; \
    perl -0p -i -e "s>.*LoadModule cgi_module>#LoadModule cgi_module>" ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/httpd/conf.modules.d/authnz_external.conf \
    file="/etc/httpd/conf.modules.d/authnz_external.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    # add load module \
    printf "LoadModule      authnz_external_module  modules/mod_authnz_external.so\n\n" > ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/httpd/conf.modules.d/xsendfile.conf \
    file="/etc/httpd/conf.modules.d/xsendfile.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    # replace load module \
    perl -0p -i -e "s>.*LoadModule .*>LoadModule      xsendfile_module  modules/mod_xsendfile.so>" ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/httpd/conf.d/ssl.conf \
    file="/etc/httpd/conf.d/ssl.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    # add ifmodule \
    perl -0p -i -e "s>#>\<IfModule ssl_module\>\n#>" ${file}; \
    printf "</IfModule>" >> ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/httpd/conf.d/autoindex.conf \
    file="/etc/httpd/conf.d/autoindex.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    # add ifmodule \
    perl -0p -i -e "s>#>\<IfModule autoindex_module\>\n#>" ${file}; \
    printf "</IfModule>" >> ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/httpd/conf.d/authnz_external.conf \
    file="/etc/httpd/conf.d/authnz_external.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    # replace load module \
    perl -0p -i -e "s>LoadModule .*>\<IfModule authnz_external_module\>>" ${file}; \
    printf "</IfModule>" >> ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    printf "Done enabling/disabling modules...\n"; \
    \
    printf "\n# Checking modules...\n"; \
    $(which apachectl) -l; $(which apachectl) -M; \
    printf "Done checking modules...\n";

#
# Configuration
#

# HTTPd
RUN printf "Updading HTTPd configuration...\n"; \
    \
    # /etc/httpd/conf/httpd.conf \
    file="/etc/httpd/conf/httpd.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    # run as user/group \
    perl -0p -i -e "s>#  don't use Group #-1 on these systems!\n#\nUser .*\nGroup .*>#  don't use Group #-1 on these systems!\n#\nUser ${app_httpd_global_user}\nGroup ${app_httpd_global_group}>" ${file}; \
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
IncludeOptional sites.d/*.conf\n\
" >> ${file}; \
    # change timeout \
    perl -0p -i -e "s># Timeout: The number of seconds before receives and sends time out.\n#\nTimeout .*># Timeout: The number of seconds before receives and sends time out.\n#\nTimeout ${app_httpd_global_listen_timeout}>" ${file}; \
    # change keepalive \
    perl -0p -i -e "s># one request per connection\). Set to \"Off\" to deactivate.\n#\nKeepAlive .*># one request per connection\). Set to \"Off\" to deactivate.\n#\nKeepAlive ${app_httpd_global_listen_keepalive_status}>" ${file}; \
    perl -0p -i -e "s># We recommend you leave this number high, for maximum performance.\n#\nMaxKeepAliveRequests .*># We recommend you leave this number high, for maximum performance.\n#\nMaxKeepAliveRequests ${app_httpd_global_listen_keepalive_requests}>" ${file}; \
    perl -0p -i -e "s># same client on the same connection.\n#\nKeepAliveTimeout .*># same client on the same connection.\n#\nKeepAliveTimeout ${app_httpd_global_listen_keepalive_timeout}>" ${file}; \
    # add/replace main directory directives \
    perl -0p -i -e "s>\<Directory /\>\n\
    AllowOverride none\n\
    Require all denied\n\
\</Directory\>>\<Directory /\>\n\
    Options FollowSymLinks\n\
    AllowOverride None\n\
    Require all denied\n\
\</Directory\>\
>" ${file}; \
    perl -0p -i -e "s>\<Directory \"/var/www\"\>\n\
    AllowOverride None\n\
    \# Allow open access:\n\
    Require all granted\n\
\</Directory\>>\<Directory \"/var/www\"\>\n\
    Options Indexes FollowSymLinks\n\
    AllowOverride None\n\
    \# Allow open access:\n\
    Require all granted\n\
\</Directory\>\n\
\n\
\#\<Directory /srv/\>\n\
\#    Options Indexes FollowSymLinks\n\
\#    AllowOverride None\n\
\#    \# Allow open access:\n\
\#    Require all granted\n\
\#\</Directory\>\n\
>" ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/httpd/ports.conf \
    file="/etc/httpd/ports.conf"; \
    touch ${file}; \
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
    printf "Done patching ${file}...\n"; \
    \
    # /etc/httpd/conf.d/serve-cgi-bin.conf \
    file="/etc/httpd/conf.d/serve-cgi-bin.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    # add universal cgi-bin configuration \
    printf "<IfModule alias_module>\n\
    ScriptAlias /cgi-bin/ /var/www/cgi-bin/\n\
    <Directory \"/var/www/cgi-bin\">\n\
        AllowOverride None\n\
        Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch\n\
        Require all granted\n\
    </Directory>\n\
</IfModule>\n\
\n" > ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/httpd/conf.d/security.conf \
    file="/etc/httpd/conf.d/security.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    # add security settings \
    printf "\n\
# Changing the following options will not really affect the security of the\n\
# server, but might make attacks slightly more difficult in some cases.\n\
\n\
#\n\
# ServerTokens\n\
# This directive configures what you return as the Server HTTP response\n\
# Header. The default is 'Full' which sends information about the OS-Type\n\
# and compiled in modules.\n\
# Set to one of:  Full | OS | Minimal | Minor | Major | Prod\n\
# where Full conveys the most information, and Prod the least.\n\
ServerTokens Minor\n\
\n\
#\n\
# Optionally add a line containing the server version and virtual host\n\
# name to server-generated pages (internal error documents, FTP directory\n\
# listings, mod_status and mod_info output etc., but not CGI generated\n\
# documents or custom error documents).\n\
# Set to \"EMail\" to also include a mailto: link to the ServerAdmin.\n\
# Set to one of:  On | Off | EMail\n\
ServerSignature On\n\
\n" > ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/httpd/conf.d/ssl.conf \
    file="/etc/httpd/conf.d/ssl.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    # disable/replace badly configured defaults \
    perl -0p -i -e "s>Listen 443 https>>" ${file}; \
    perl -0p -i -e "s>.*SSLProtocol all .*>SSLProtocol all -SSLv3>" ${file}; \
    perl -0p -i -e "s>.*SSLCipherSuite HIGH.*>SSLCipherSuite ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA256:DHE-RSA-AES256-SHA:ECDHE-ECDSA-DES-CBC3-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:DES-CBC3-SHA:!DSS>" ${file}; \
    perl -0p -i -e "s>.*SSLHonorCipherOrder on>SSLHonorCipherOrder On>" ${file}; \
    perl -0p -i -e "s>\n\</IfModule\>>\n\
\# Additional security improvements\n\
SSLCompression Off\n\
\n\
\# OCSP Stapling\n\
SSLUseStapling On\n\
SSLStaplingResponderTimeout 5\n\
SSLStaplingReturnResponderErrors Off\n\
SSLStaplingCache shmcb:/var/run/ocsp\(128000\)\n\
\n\
\# See more information at:\n\
\# https://mozilla.github.io/server-side-tls/ssl-config-generator/\?server=apache-2.4.6\&openssl=1.0.1e\&hsts=no\&profile=intermediate\n\
\n\</IfModule\>>" ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # Additional configuration files \
    mkdir /etc/httpd/incl.d; \
    \
    # HTTPd vhost \
    app_httpd_vhost_home="${app_httpd_global_home}/${app_httpd_vhost_id}"; \
    \
    # /etc/httpd/incl.d/${app_httpd_vhost_id}-httpd.conf \
    file="/etc/httpd/incl.d/${app_httpd_vhost_id}-httpd.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    printf "# HTTPd info and status\n\
<IfModule info_module>\n\
  # HTTPd info\n\
  <Location /server-info>\n\
    SetHandler server-info\n\
    Require ${app_httpd_vhost_httpd_wlist}\n\
  </Location>\n\
</IfModule>\n\
<IfModule status_module>\n\
  # HTTPd status\n\
  <Location /server-status>\n\
    SetHandler server-status\n\
    Require ${app_httpd_vhost_httpd_wlist}\n\
  </Location>\n\
</IfModule>\n\
\n" > ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # Vhost configuration files \
    mkdir /etc/httpd/sites.d; \
    \
    # /etc/httpd/conf/httpd.conf \
    file="/etc/httpd/conf/httpd.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    # disable/replace badly configured default vhost \
    perl -0p -i -e "s>.*ServerAdmin root@localhost>#ServerAdmin root@localhost>" ${file}; \
    perl -0p -i -e "s>.*ServerName www.example.com:80>#ServerName www.example.com:80>" ${file}; \
    perl -0p -i -e "s>.*DocumentRoot \"/var/www/html\">#DocumentRoot \"/var/www/html\">" ${file}; \
    perl -0p -i -e "s>\<Directory \"/var/www/html\"\>>#\<Directory \"/var/www/html\"\>>" ${file}; \
    perl -0p -i -e "s>#\n    Options Indexes FollowSymLinks>#\n#    Options Indexes FollowSymLinks>" ${file}; \
    perl -0p -i -e "s>#\n    AllowOverride None>#\n#    AllowOverride None>" ${file}; \
    perl -0p -i -e "s>#\n    Require all granted\n\</Directory\>>#\n#    Require all granted\n#\</Directory\>>" ${file}; \
    perl -0p -i -e "s>    ScriptAlias /cgi-bin/ \"/var/www/cgi-bin/\">>" ${file}; \
    perl -0p -i -e "s>\<Directory \"/var/www/cgi-bin\"\>\n\
    AllowOverride None\n\
    Options None\n\
    Require all granted\n\
\</Directory\>>>" ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/httpd/conf.d/ssl.conf \
    file="/etc/httpd/conf.d/ssl.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    # disable/replace badly configured default vhost \
    perl -0p -i -e "s>\<VirtualHost _default_:443\>>#\<VirtualHost _default_:443\>>" ${file}; \
    perl -0p -i -e "s>.*DocumentRoot \"/var/www/html\">#DocumentRoot \"/var/www/html\">" ${file}; \
    perl -0p -i -e "s>.*ServerAdmin root@localhost>#ServerAdmin root@localhost>" ${file}; \
    perl -0p -i -e "s>.*ServerName www.example.com:443>#ServerName www.example.com:443>" ${file}; \
    perl -0p -i -e "s>.*ErrorLog logs/ssl_error_log\nTransferLog logs/ssl_access_log\nLogLevel warn>#ErrorLog logs/ssl_error_log\n#TransferLog logs/ssl_access_log\n#LogLevel warn>" ${file}; \
    perl -0p -i -e "s>.*SSLEngine on>#SSLEngine on>" ${file}; \
    perl -0p -i -e "s>.*SSLCertificateFile /etc/pki/tls/certs/localhost.crt>#SSLCertificateFile /etc/pki/tls/certs/localhost.crt>" ${file}; \
    perl -0p -i -e "s>.*SSLCertificateKeyFile /etc/pki/tls/private/localhost.key>#SSLCertificateKeyFile /etc/pki/tls/private/localhost.key>" ${file}; \
    perl -0p -i -e "s>.*SSLCertificateChainFile /etc/pki/tls/certs/server-chain.crt>#SSLCertificateChainFile /etc/pki/tls/certs/server-chain.crt>" ${file}; \
    perl -0p -i -e "s>.*SSLCACertificateFile /etc/pki/tls/certs/ca-bundle.crt>#SSLCACertificateFile /etc/pki/tls/certs/ca-bundle.crt>" ${file}; \
    perl -0p -i -e "s>\<Files ~>#\<Files ~>" ${file}; \
    perl -0p -i -e "s>    SSLOptions \+StdEnvVars>#    SSLOptions \+StdEnvVars>" ${file}; \
    perl -0p -i -e "s>\</Files\>>#\</Files\>>" ${file}; \
    perl -0p -i -e "s>\<Directory \"/var/www/cgi-bin\"\>\n\
    SSLOptions \+StdEnvVars\n\
\</Directory\>>#\<Directory \"/var/www/cgi-bin\"\>\n\
#    SSLOptions \+StdEnvVars\n\
#\</Directory\>\
>" ${file}; \
    perl -0p -i -e "s>CustomLog logs/ssl_request_log>#CustomLog logs/ssl_request_log>" ${file}; \
    perl -0p -i -e "s>          \"%t>#          \"%t>" ${file}; \
    perl -0p -i -e "s>\</VirtualHost\>>#\</VirtualHost\>>" ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/httpd/sites.d/${app_httpd_vhost_id}-http.conf \
    file="/etc/httpd/sites.d/${app_httpd_vhost_id}-http.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/httpd/sites.d/${app_httpd_vhost_id}-https.conf \
    file="/etc/httpd/sites.d/${app_httpd_vhost_id}-https.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    printf "Done patching ${file}...\n"; \
    \
    printf "\n# Testing configuration...\n"; \
    echo "Testing $(which apachectl):"; $(which apachectl) -V; $(which apachectl) configtest; $(which apachectl) -S; \
    printf "Done testing configuration...\n"; \
    \
    printf "Finished updading HTTPd configuration...\n";

