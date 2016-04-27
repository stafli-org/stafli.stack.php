
#
#    CentOS 6 (centos6) HTTPd22 Proxy profile (dockerfile)
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
    rpm --rebuilddb && \
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
    # init is not working at this point \
    \
    # /etc/supervisord.conf \
    file="/etc/supervisord.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    printf "# httpd\n\
[program:httpd]\n\
command=/bin/bash -c \"\$(which apachectl) -d /etc/httpd -f /etc/httpd/conf/httpd.conf -D FOREGROUND\"\n\
autostart=true\n\
autorestart=true\n\
\n" >> ${file}; \
    printf "Done patching ${file}...\n";

# HTTPd
RUN printf "Updading HTTPd configuration...\n"; \
    \
    touch /etc/httpd/ports.conf; \
    mkdir /etc/httpd/sites.d; \
    mkdir /etc/httpd/conf.modules.d; \
    touch /etc/httpd/conf.modules.d/00-dav.conf; \
    touch /etc/httpd/conf.modules.d/00-proxy.conf; \
    touch /etc/httpd/conf.modules.d/00-ssl.conf; \
    touch /etc/httpd/conf.modules.d/01-cgi.conf; \
    touch /etc/httpd/conf.modules.d/00-base.conf; \
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
    # replace optional config files \
    perl -0p -i -e "s>#\n# Load config files from the config directory \"/etc/httpd/conf.d\".\n#\nInclude conf.d/*.conf>>" ${file}; \
    printf "\n\
# Supplemental configuration\n\
#\n\
# Load config files in the \"/etc/httpd/conf.d\" directory, if any.\n\
Include conf.d/*.conf\n\
" >> ${file}; \
    # replace ports with config file \
    perl -0p -i -e "s>#\n# Listen: Allows you to bind Apache to specific IP addresses and/or\n# ports, in addition to the default. See also the \<VirtualHost\>\n# directive.\n#\n# Change this to Listen on specific IP addresses as shown below to \n# prevent Apache from glomming onto all bound IP addresses \(0.0.0.0\)\n#\n#Listen 12.34.56.78:80\nListen 80\n\n>>" ${file}; \
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
    # replace load modules \
    perl -0p -i -e "s># LoadModule foo_module modules/mod_foo.so\n#\n># LoadModule foo_module modules/mod_foo.so\n#\nInclude conf.modules.d/*.conf\n\n>" ${file}; \
    perl -0p -i -e "s>\nLoadModule .*>>g" ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/httpd/conf.modules.d/00-dav.conf \
    file="/etc/httpd/conf.modules.d/00-dav.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    printf "\
LoadModule dav_module modules/mod_dav.so\n\
LoadModule dav_fs_module modules/mod_dav_fs.so\n\
" > ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/httpd/conf.modules.d/00-proxy.conf \
    file="/etc/httpd/conf.modules.d/00-proxy.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    printf "\
# This file configures all the proxy modules:\n\
LoadModule proxy_module modules/mod_proxy.so\n\
LoadModule proxy_ajp_module modules/mod_proxy_ajp.so\n\
LoadModule proxy_balancer_module modules/mod_proxy_balancer.so\n\
LoadModule proxy_connect_module modules/mod_proxy_connect.so\n\
LoadModule proxy_ftp_module modules/mod_proxy_ftp.so\n\
LoadModule proxy_http_module modules/mod_proxy_http.so\n\
" > ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/httpd/conf.modules.d/00-ssl.conf \
    file="/etc/httpd/conf.modules.d/00-ssl.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    printf "\
LoadModule ssl_module modules/mod_ssl.so\n\
" > ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/httpd/conf.modules.d/01-cgi.conf \
    file="/etc/httpd/conf.modules.d/01-cgi.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    printf "\
# This configuration file loads a CGI module appropriate to the MPM\n\
# which has been configured in 00-mpm.conf.  mod_cgid should be used\n\
# with a threaded MPM; mod_cgi with the prefork MPM.\n\
\n\
<IfModule mpm_worker_module>\n\
   LoadModule cgid_module modules/mod_cgid.so\n\
</IfModule>\n\
<IfModule mpm_prefork_module>\n\
   LoadModule cgi_module modules/mod_cgi.so\n\
</IfModule>\n\
" > ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/httpd/conf.modules.d/00-base.conf \
    file="/etc/httpd/conf.modules.d/00-base.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    printf "\
#\n\
# This file loads most of the modules included with the Apache HTTP\n\
# Server itself.\n\
#\n\
\n\
LoadModule actions_module modules/mod_actions.so\n\
LoadModule alias_module modules/mod_alias.so\n\
LoadModule auth_basic_module modules/mod_auth_basic.so\n\
LoadModule auth_digest_module modules/mod_auth_digest.so\n\
LoadModule authn_alias_module modules/mod_authn_alias.so\n\
LoadModule authn_anon_module modules/mod_authn_anon.so\n\
LoadModule authn_dbd_module modules/mod_authn_dbd.so\n\
LoadModule authn_dbm_module modules/mod_authn_dbm.so\n\
LoadModule authn_default_module modules/mod_authn_default.so\n\
LoadModule authn_file_module modules/mod_authn_file.so\n\
LoadModule authz_dbm_module modules/mod_authz_dbm.so\n\
LoadModule authz_default_module modules/mod_authz_default.so\n\
LoadModule authz_groupfile_module modules/mod_authz_groupfile.so\n\
LoadModule authz_host_module modules/mod_authz_host.so\n\
LoadModule authz_owner_module modules/mod_authz_owner.so\n\
LoadModule authz_user_module modules/mod_authz_user.so\n\
LoadModule authnz_ldap_module modules/mod_authnz_ldap.so\n\
LoadModule autoindex_module modules/mod_autoindex.so\n\
LoadModule cache_module modules/mod_cache.so\n\
LoadModule disk_cache_module modules/mod_disk_cache.so\n\
LoadModule dbd_module modules/mod_dbd.so\n\
LoadModule deflate_module modules/mod_deflate.so\n\
LoadModule dir_module modules/mod_dir.so\n\
LoadModule dumpio_module modules/mod_dumpio.so\n\
LoadModule env_module modules/mod_env.so\n\
LoadModule expires_module modules/mod_expires.so\n\
LoadModule ext_filter_module modules/mod_ext_filter.so\n\
LoadModule filter_module modules/mod_filter.so\n\
LoadModule headers_module modules/mod_headers.so\n\
LoadModule include_module modules/mod_include.so\n\
LoadModule info_module modules/mod_info.so\n\
LoadModule ldap_module modules/mod_ldap.so\n\
LoadModule log_config_module modules/mod_log_config.so\n\
LoadModule logio_module modules/mod_logio.so\n\
LoadModule mime_magic_module modules/mod_mime_magic.so\n\
LoadModule mime_module modules/mod_mime.so\n\
LoadModule negotiation_module modules/mod_negotiation.so\n\
LoadModule rewrite_module modules/mod_rewrite.so\n\
LoadModule setenvif_module modules/mod_setenvif.so\n\
LoadModule status_module modules/mod_status.so\n\
LoadModule substitute_module modules/mod_substitute.so\n\
LoadModule suexec_module modules/mod_suexec.so\n\
LoadModule unique_id_module modules/mod_unique_id.so\n\
LoadModule userdir_module modules/mod_userdir.so\n\
LoadModule version_module modules/mod_version.so\n\
LoadModule vhost_alias_module modules/mod_vhost_alias.so\n\
\n\
#LoadModule asis_module modules/mod_asis.so\n\
#LoadModule cern_meta_module modules/mod_cern_meta.so\n\
#LoadModule ident_module modules/mod_ident.so\n\
#LoadModule log_forensic_module modules/mod_log_forensic.so\n\
#LoadModule usertrack_module modules/mod_usertrack.so\n\
#LoadModule speling_module modules/mod_speling.so\n\
" > ${file}; \
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
NameVirtualHost ${app_httpd_global_listen_addr}:${app_httpd_global_listen_port_http}\n\
Listen ${app_httpd_global_listen_addr}:${app_httpd_global_listen_port_http}\n\
\n\
<IfModule ssl_module>\n\
    # If you add NameVirtualHost *:443 here, you will also have to change\n\
    # the VirtualHost statement in /etc/httpd/sites.d/000-default-ssl.conf\n\
    # to <VirtualHost *:443>\n\
    # Server Name Indication for SSL named virtual hosts is currently not\n\
    # supported by MSIE on Windows XP.\n\
    NameVirtualHost ${app_httpd_global_listen_addr}:${app_httpd_global_listen_port_https}\n\
    Listen ${app_httpd_global_listen_addr}:${app_httpd_global_listen_port_https}\n\
</IfModule>\n\
\n\
<IfModule gnutls_module>\n\
    NameVirtualHost ${app_httpd_global_listen_addr}:${app_httpd_global_listen_port_https}\n\
    Listen ${app_httpd_global_listen_addr}:${app_httpd_global_listen_port_https}\n\
</IfModule>\n\
" > ${file}; \
    printf "Done patching ${file}...\n";

