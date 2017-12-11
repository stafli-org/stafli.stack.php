#!/bin/bash
#
#    CentOS 7 (centos7) PHP Stack - HTTPd24 Proxy Server (shellfile)
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

# Workaround for docker commands
alias FROM="#";
alias MAINTAINER="#";
alias ENV='export';
alias ARG='export';
alias RUN='';
shopt -s expand_aliases;

# Load dockerfile
source "$(dirname $(readlink -f $0))/../dockerfiles/httpd24_proxy.dockerfile";

#
# Configuration
#

# Enable daemon
systemctl enable httpd.service;

# Start daemon
systemctl restart httpd.service;

