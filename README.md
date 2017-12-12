# Stafli PHP Stack
Stafli PHP Stack builds based on [Debian](https://www.debian.org) and [CentOS](https://www.centos.org), and developed as scripts for [Docker](https://www.docker.com).  
Continues on [Stafli *](https://github.com/stafli-org/stafli.*) builds.  
This project is part of the [Stafli Application Stack](https://github.com/stafli-org).

Requires [Docker Compose](https://docs.docker.com/compose) 1.6.x or higher due to the [version 2](https://docs.docker.com/compose/compose-file/#versioning) format of the docker-compose.yml files.

There are docker-compose.yml files per distribution, as well as docker-compose.override.yml and .env files, which may be used to override configuration.
An optional [Makefile](../../tree/master/Makefile) is provided to help with loading these with ease and perform commands in batch.

Scripts are also provided for each distribution to help test and deploy the installation procedures in non-Docker environments.

The images are automatically built at a [repository](https://hub.docker.com/r/stafli/stafli.stack.php) in the Docker Hub registry.

## Distributions
The services use custom images as a starting point for the following distributions:
- __Debian__, from the [official repository](https://hub.docker.com/_/debian)
  - [Debian 8 (jessie)](../../tree/master/debian8)
  - [Debian 7 (wheezy)](../../tree/master/debian7)
- __CentOS__, from the [official repository](https://hub.docker.com/_/centos)
  - [CentOS 7 (centos7)](../../tree/master/centos7)
  - [CentOS 6 (centos6)](../../tree/master/centos6)

## Services
These are the services described by the dockerfile and docker-compose files:
- Memcached 1.4.x Cache, built on [Stafli Memcached Cache](https://github.com/stafli-org/stafli.cache.memcached)
- Redis 3.2.x Cache, built on [Stafli Redis Cache](https://github.com/stafli-org/stafli.cache.redis)
- MariaDB 10.x.x RDBMS, built on [Stafli MariaDB RDBMS](https://github.com/stafli-org/stafli.rdbms.mariadb)
- PHP 5.6.x Language, built on [Stafli PHP Language](https://github.com/stafli-org/stafli.language.php)
- HTTPd 2.2.x/2.4.x Web, built on [Stafli HTTPd Web](https://github.com/stafli-org/stafli.web.httpd)
- HTTPd 2.2.x/2.4.x Proxy, built on [Stafli HTTPd Proxy](https://github.com/stafli-org/stafli.proxy.httpd)

## Images
These are the [resulting images](https://hub.docker.com/r/stafli/stafli.stack.php/tags) upon building:
- Memcached 1.4.x Cache:
  - stafli/stafli.stack.php:cache_memcached14_debian8
  - stafli/stafli.stack.php:cache_memcached14_debian7
  - stafli/stafli.stack.php:cache_memcached14_centos7
  - stafli/stafli.stack.php:cache_memcached14_debian8
- Redis 3.2.x Cache:
  - stafli/stafli.stack.php:cache_redis32_debian8
  - stafli/stafli.stack.php:cache_redis32_debian7
  - stafli/stafli.stack.php:cache_redis32_centos7
  - stafli/stafli.stack.php:cache_redis32_centos6
- MariaDB 10.x.x RDBMS:
  - stafli/stafli.stack.php:rdbms_mariadb10_debian8
  - stafli/stafli.stack.php:rdbms_mariadb10_debian7
  - stafli/stafli.stack.php:rdbms_mariadb10_centos7
  - stafli/stafli.stack.php:rdbms_mariadb10_centos6
- PHP 5.6.x Language:
  - stafli/stafli.stack.php:language_php56_debian8
  - stafli/stafli.stack.php:language_php56_debian7
  - stafli/stafli.stack.php:language_php56_centos7
  - stafli/stafli.stack.php:language_php56_centos6
- HTTPd 2.x.x Web:
  - stafli/stafli.stack.php:web_httpd24_debian8
  - stafli/stafli.stack.php:web_httpd22_debian7
  - stafli/stafli.stack.php:web_httpd24_centos7
  - stafli/stafli.stack.php:web_httpd22_centos6
- HTTPd 2.x.x Proxy:
  - stafli/stafli.web.httpd:proxy_httpd24_debian8
  - stafli/stafli.web.httpd:proxy_httpd22_debian7
  - stafli/stafli.web.httpd:proxy_httpd24_centos7
  - stafli/stafli.web.httpd:proxy_httpd22_centos6

## Containers
These containers can be created from the images:
- Memcached 1.4.x Cache:
  - stafli_stack_php56_cache_memcached14_debian8_xxx
  - stafli_stack_php56_cache_memcached14_debian7_xxx
  - stafli_stack_php56_cache_memcached14_centos7_xxx
  - stafli_stack_php56_cache_memcached14_debian8_xxx
- Redis 3.2.x Cache:
  - stafli_stack_php56_cache_redis32_debian8_xxx
  - stafli_stack_php56_cache_redis32_debian7_xxx
  - stafli_stack_php56_cache_redis32_centos7_xxx
  - stafli_stack_php56_cache_redis32_centos6_xxx
- MariaDB 10.x.x RDBMS:
  - stafli_stack_php56_rdbms_mariadb10_debian8_xxx
  - stafli_stack_php56_rdbms_mariadb10_debian7_xxx
  - stafli_stack_php56_rdbms_mariadb10_centos7_xxx
  - stafli_stack_php56_rdbms_mariadb10_centos6_xxx
- PHP 5.6.x Language:
  - stafli_stack_php56_language_php56_debian8_xxx
  - stafli_stack_php56_language_php56_debian7_xxx
  - stafli_stack_php56_language_php56_centos7_xxx
  - stafli_stack_php56_language_php56_centos6_xxx
- HTTPd 2.x.x Web:
  - stafli_stack_php56_web_httpd24_debian8_xxx
  - stafli_stack_php56_web_httpd22_debian7_xxx
  - stafli_stack_php56_web_httpd24_centos7_xxx
  - stafli_stack_php56_web_httpd22_centos6_xxx
- HTTPd 2.x.x Proxy:
  - stafli_stack_php56_proxy_httpd24_debian8_xxx
  - stafli_stack_php56_proxy_httpd22_debian7_xxx
  - stafli_stack_php56_proxy_httpd24_centos7_xxx
  - stafli_stack_php56_proxy_httpd22_centos6_xxx

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
docker pull stafli/stafli.stack.php:memcached14_debian8
docker pull stafli/stafli.stack.php:redis32_debian8
docker pull stafli/stafli.stack.php:mariadb10_debian8
docker pull stafli/stafli.stack.php:php56_debian8
docker pull stafli/stafli.stack.php:web_httpd24_debian8
docker pull stafli/stafli.web.httpd:proxy_httpd24_debian8

docker run -ti stafli/stafli.stack.php:memcached14_debian8 /bin/bash
```

### From GitHub repository (automated)

Note: this method allows using docker-compose and the Makefile.

1. Download the repository [zip file](https://github.com/stafli-org/stafli.stack.php/archive/master.zip) and unpack it or clone the repository using:  
`git clone https://github.com/stafli-org/stafli.stack.php.git`
2. Navigate to the project directory through the terminal:  
`cd stafli.stack.php`
3. Type in the desired operation through the terminal:  
`make <operation> DISTRO=<distro>`

Where <distro> is the distribution/directory and <operation> is the desired docker-compose operation.

Example:
```
git clone https://github.com/stafli-org/stafli.stack.php.git;
cd stafli.stack.php;

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
Stafli PHP Stack  
Copyright (C) 2016-2017 Stafli  
Luís Pedro Algarvio  
This file is part of the Stafli Application Stack.

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
