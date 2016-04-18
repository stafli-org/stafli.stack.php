# Docker High Performance PHP Stack
High Performance PHP stack builds based on [Debian](https://www.debian.org/) and [CentOS](https://www.centos.org/), and developed as scripts for [Docker](https://www.docker.com/).  
Continues on [Docker General Purpose System Distro](https://github.com/solict/docker-general-purpose-system-distro) builds.

Requires [Docker Compose](https://docs.docker.com/compose/) 1.6.x or higher due to the [version 2](https://docs.docker.com/compose/compose-file/#versioning) format of the docker-compose.yml files.

The docker-compose.yml are separated by distribution and require .env files to function properly.  

## Distributions
The profiles use custom images as a starting point:
- __Debian__, from the [Docker General Purpose System Distro](https://github.com/solict/docker-general-purpose-system-distro)
  - [Debian 8 (jessie)](../../tree/master/debian8)
  - [Debian 7 (wheezy)](../../tree/master/debian7)
- __CentOS__, from the [Docker General Purpose System Distro](https://github.com/solict/docker-general-purpose-system-distro)
  - [CentOS 7 (centos7)](../../tree/master/centos7)
  - [CentOS 6 (centos6)](../../tree/master/centos6)

## Credits
Docker High Performance PHP Stack  
Copyright (C) 2016 SOL-ICT  
Luís Pedro Algarvio

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.