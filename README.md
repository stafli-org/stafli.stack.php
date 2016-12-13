# Docker High Performance PHP Stack
High Performance PHP stack builds based on [Debian](https://www.debian.org/) and [CentOS](https://www.centos.org/), and developed as scripts for [Docker](https://www.docker.com/).  
Continues on [Docker General Purpose System Distro](https://github.com/solict/docker-general-purpose-system-distro) builds.

Requires [Docker Compose](https://docs.docker.com/compose/) 1.6.x or higher due to the [version 2](https://docs.docker.com/compose/compose-file/#versioning) format of the docker-compose.yml files.

There are docker-compose.yml files per distribution, as well as docker-compose.override.yml and .env files, which may be used to override configuration.
An optional [Makefile](../../tree/master/Makefile) is provided to help with loading these with ease and perform commands in batch.

Scripts are also provided for each distribution to help test and deploy the installation procedures in non-Docker environments.

The images are automatically built at a [repository](https://hub.docker.com/r/solict/high-performance-php-stack) in the Docker Hub registry.

## Distributions
The services use custom images as a starting point:
- __Debian__, from the [Docker General Purpose System Distro](https://github.com/solict/docker-general-purpose-system-distro)
  - [Debian 8 (jessie)](../../tree/master/debian8)
  - [Debian 7 (wheezy)](../../tree/master/debian7)
- __CentOS__, from the [Docker General Purpose System Distro](https://github.com/solict/docker-general-purpose-system-distro)
  - [CentOS 7 (centos7)](../../tree/master/centos7)
  - [CentOS 6 (centos6)](../../tree/master/centos6)

## Services
These are the services described by the dockerfile and dockercompose files:
- Memcached 1.4.x, adds Memcached on top of upstream Standard service
- Redis 3.2.x, adds Redis on top of upstream Standard service
- MariaDB 10.x, adds MariaDB on top of upstream Standard service
- PHP 5.6.x, adds PHP on top of upstream Devel service
- HTTPd 2.2.x/2.4.x Web, adds HTTPd on top of upstream Standard/Devel service
- HTTPd 2.2.x/2.4.x Proxy, adds HTTPd on top of upstream Standard service

## Images
These are the [resulting images](https://hub.docker.com/r/solict/high-performance-php-stack/tags/) upon building:
- Memcached 1.4.x service:
  - solict/high-performance-php-stack:debian8_memcached14
  - solict/high-performance-php-stack:debian7_memcached14
  - solict/high-performance-php-stack:centos7_memcached14
  - solict/high-performance-php-stack:centos6_memcached14
- Redis 3.2.x service:
  - solict/high-performance-php-stack:debian8_redis32
  - solict/high-performance-php-stack:debian7_redis32
  - solict/high-performance-php-stack:centos7_redis32
  - solict/high-performance-php-stack:centos6_redis32
- MariaDB 10.x service:
  - solict/high-performance-php-stack:debian8_mariadb10
  - solict/high-performance-php-stack:debian7_mariadb10
  - solict/high-performance-php-stack:centos7_mariadb10
  - solict/high-performance-php-stack:centos6_mariadb10
- PHP 5.6.x service:
  - solict/high-performance-php-stack:debian8_php56
  - solict/high-performance-php-stack:debian7_php56
  - solict/high-performance-php-stack:centos7_php56
  - solict/high-performance-php-stack:centos6_php56
- HTTPd 2.x.x Web service:
  - solict/high-performance-php-stack:debian8_httpd24_web
  - solict/high-performance-php-stack:debian7_httpd22_web
  - solict/high-performance-php-stack:centos7_httpd24_web
  - solict/high-performance-php-stack:centos6_httpd22_web
- HTTPd 2.x.x Proxy service:
  - solict/high-performance-php-stack:debian8_httpd24_proxy
  - solict/high-performance-php-stack:debian7_httpd22_proxy
  - solict/high-performance-php-stack:centos7_httpd24_proxy
  - solict/high-performance-php-stack:centos6_httpd22_proxy

## Containers
These containers can be created from the images:
- Memcached 1.4.x service:
  - debian8_memcached14_xxx
  - debian7_memcached14_xxx
  - centos7_memcached14_xxx
  - centos6_memcached14_xxx
- Redis 3.2.x service:
  - debian8_redis32_xxx
  - debian7_redis32_xxx
  - centos7_redis32_xxx
  - centos6_redis32_xxx
- MariaDB 10.x service:
  - debian8_mariadb10_xxx
  - debian7_mariadb10_xxx
  - centos7_mariadb10_xxx
  - centos6_mariadb10_xxx
- PHP 5.6.x service:
  - debian8_php56_xxx
  - debian7_php56_xxx
  - centos7_php56_xxx
  - centos6_php56_xxx
- HTTPd 2.x.x Web service:
  - debian8_httpd24_web_xxx
  - debian7_httpd22_web_xxx
  - centos7_httpd24_web_xxx
  - centos6_httpd22_web_xxx
- HTTPd 2.x.x Proxy service:
  - debian8_httpd24_proxy_xxx
  - debian7_httpd22_proxy_xxx
  - centos7_httpd24_proxy_xxx
  - centos6_httpd22_proxy_xxx

## Usage

### From Docker Hub repository (manual)

Note: this method will not allow you to use the docker-compose files nor the Makefile.

1. To pull the images, try typing:  
`docker pull <image_url>`
2. You can start a new container interactively by typing:  
`docker run -ti <image_url> /bin/bash`

Where <image_url> is the full image url (lookup the image list above).

Example:
```
docker pull solict/high-performance-php-stack:debian8_memcached14
docker pull solict/high-performance-php-stack:debian8_redis32
docker pull solict/high-performance-php-stack:debian8_mariadb10
docker pull solict/high-performance-php-stack:debian8_php56
docker pull solict/high-performance-php-stack:debian8_httpd24_web
docker pull solict/high-performance-php-stack:debian8_httpd24_proxy

docker run -ti solict/high-performance-php-stack:debian8_memcached14 /bin/bash
```

### From GitHub repository (automated)

Note: this method allows using docker-compose and the Makefile.

1. Download the repository [zip file](https://github.com/solict/docker-high-performance-php-stack/archive/master.zip) and unpack it or clone the repository using:  
`git clone https://github.com/solict/docker-high-performance-php-stack.git`
2. Navigate to the project directory through the terminal:  
`cd docker-high-performance-php-stack`
3. Type in the desired operation through the terminal:  
`make <operation> DISTRO=<distro>`

Where <distro> is the distribution/directory and <operation> is the desired docker-compose operation.

Example:
```
git clone https://github.com/solict/docker-high-performance-php-stack.git;
cd docker-high-performance-php-stack;

# Example #1: quick start, with build
make up DISTRO=debian8;

# Example #2: quick start, with pull
make img-pull DISTRO=debian8;
make up DISTRO=debian8;

# Example #3: manual steps, with build
make img-build DISTRO=debian8;
make net-create DISTRO=debian8;
make vol-create DISTRO=debian8;
make con-create DISTRO=debian8;
make con-start DISTRO=debian8;
make con-ls DISTRO=debian8;
```

Type `make` in the terminal to discover all the possible commands.

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
