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

## Images
These are the [resulting images](https://hub.docker.com/r/solict/high-performance-php-stack/tags/) upon building:

## Containers
These containers are generated upon issuing a create:

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