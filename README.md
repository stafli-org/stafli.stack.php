# Docker High Performance PHP Stack
High Performance PHP stack builds based on [Debian](https://www.debian.org/) and [CentOS](https://www.centos.org/), and developed as scripts for [Docker](https://www.docker.com/).  
Continues on [Docker General Purpose System Distro](https://github.com/solict/docker-general-purpose-system-distro) builds.

Requires [Docker Compose](https://docs.docker.com/compose/) 1.6.x or higher due to the [version 2](https://docs.docker.com/compose/compose-file/#versioning) format of the docker-compose.yml files.

The docker-compose.yml are separated by distribution and require .env files to function properly.  
A rudimentary script [docker-compose-helper.sh](../../tree/master/docker-compose-helper.sh) is provided to help with loading these.

Scripts are also provided to help test and deploy the installation procedures in non-Docker environments.

The images are automatically built at a [repository](https://hub.docker.com/r/solict/high-performance-php-stack) in the Docker Hub registry.

## Distributions
The profiles use custom images as a starting point:
- __Debian__, from the [Docker General Purpose System Distro](https://github.com/solict/docker-general-purpose-system-distro)
  - [Debian 8 (jessie)](../../tree/master/debian8)
  - [Debian 7 (wheezy)](../../tree/master/debian7)
- __CentOS__, from the [Docker General Purpose System Distro](https://github.com/solict/docker-general-purpose-system-distro)
  - [CentOS 7 (centos7)](../../tree/master/centos7)
  - [CentOS 6 (centos6)](../../tree/master/centos6)

## Profiles
These are the profiles described by the dockerfiles:
- Memcached 1.4.x, adds Memcached on top of upstream Standard profile
- Redis 3.0.x, adds Redis on top of upstream Standard profile
- MySQL 5.5.x/5.6.x/MariaDB 10.x, adds MySQL/MariaDB on top of upstream Standard profile
- PHP 5.6.x, adds PHP on top of upstream Devel profile
- HTTPd 2.x.x Web, adds HTTPd on top of upstream Devel profile
- HTTPd 2.x.x Proxy, adds HTTPd on top of upstream Standard profile

## Images
These are the [resulting images](https://hub.docker.com/r/solict/high-performance-php-stack/tags/) upon building:
- Memcached 1.4.x profile:
  - solict/high-performance-php-stack:debian8_memcached14
  - solict/high-performance-php-stack:debian7_memcached14
  - solict/high-performance-php-stack:centos7_memcached14
  - solict/high-performance-php-stack:centos6_memcached14
- Redis 3.0.x profile:
  - solict/high-performance-php-stack:debian8_redis30
  - solict/high-performance-php-stack:debian7_redis30
  - solict/high-performance-php-stack:centos7_redis30
  - solict/high-performance-php-stack:centos6_redis30
- MySQL 5.5.x/5.6.x/MariaDB 10.x profile:
  - solict/high-performance-php-stack:debian8_mysql56
  - solict/high-performance-php-stack:debian7_mysql56
  - solict/high-performance-php-stack:centos7_mysql55
  - solict/high-performance-php-stack:centos6_mysql55
- PHP 5.6.x profile:
  - solict/high-performance-php-stack:debian8_php56
  - solict/high-performance-php-stack:debian7_php56
  - solict/high-performance-php-stack:centos7_php56
  - solict/high-performance-php-stack:centos6_php56
- HTTPd 2.x.x Web profile:
  - solict/high-performance-php-stack:debian8_httpd24_web
  - solict/high-performance-php-stack:debian7_httpd22_web
  - solict/high-performance-php-stack:centos7_httpd24_web
  - solict/high-performance-php-stack:centos6_httpd22_web
- HTTPd 2.x.x Proxy profile:
  - solict/high-performance-php-stack:debian8_httpd24_proxy
  - solict/high-performance-php-stack:debian7_httpd22_proxy
  - solict/high-performance-php-stack:centos7_httpd24_proxy
  - solict/high-performance-php-stack:centos6_httpd22_proxy

## Containers
These containers are generated upon issuing a create:
- Memcached 1.4.x profile:
  - debian8_memcached14_xxx
  - debian7_memcached14_xxx
  - centos7_memcached14_xxx
  - centos6_memcached14_xxx
- Redis 3.0.x profile:
  - debian8_redis30_xxx
  - debian7_redis30_xxx
  - centos7_redis30_xxx
  - centos6_redis30_xxx
- MySQL 5.5.x/5.6.x/MariaDB 10.x profile:
  - debian8_mysql56_xxx
  - debian7_mysql56_xxx
  - centos7_mysql55_xxx
  - centos6_mysql55_xxx
- PHP 5.6.x profile:
  - debian8_php56_xxx
  - debian7_php56_xxx
  - centos7_php56_xxx
  - centos6_php56_xxx
- HTTPd 2.x.x Web profile:
  - debian8_httpd24_web_xxx
  - debian7_httpd22_web_xxx
  - centos7_httpd24_web_xxx
  - centos6_httpd22_web_xxx
- HTTPd 2.x.x Proxy profile:
  - debian8_httpd24_proxy_xxx
  - debian7_httpd22_proxy_xxx
  - centos7_httpd24_proxy_xxx
  - centos6_httpd22_proxy_xxx

## Usage

### From Docker Hub repository (basics)

Note: this method will not allow you to use the docker-compose files nor the script.

1. To pull the images, try typing:  
`docker pull <image_url>`
2. You can start a new container interactively by typing:  
`docker run -ti <image_url> /bin/bash`

Where <image_url> is the full image url (lookup the image list above).

Examples:
```
docker pull solict/high-performance-php-stack:debian7_memcached14
docker pull solict/high-performance-php-stack:debian7_redis30
docker pull solict/high-performance-php-stack:debian7_mysql56
docker pull solict/high-performance-php-stack:debian7_php56
docker pull solict/high-performance-php-stack:debian7_httpd22_web
docker pull solict/high-performance-php-stack:debian7_httpd22_proxy
```

### From GitHub repository (advanced)

1. Download the repository [zip file](https://github.com/solict/docker-high-performance-php-stack/archive/master.zip) and unpack it or clone the repository using:  
`git clone https://github.com/solict/docker-high-performance-php-stack.git`
2. Navigate to the project directory with a terminal and type:  
`docker-compose-helper --project=<distro> <operation>`

Where <distro> is the distribution/directory and <operation> is the desired docker-compose operation.

Examples:
```
./docker-compose-helper.sh --project=debian7 build
./docker-compose-helper.sh --project=debian7 create
./docker-compose-helper.sh --project=debian7 start
./docker-compose-helper.sh --project=debian7 stop
./docker-compose-helper.sh --project=debian7 rm
```

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