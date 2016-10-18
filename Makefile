#
#    Makefile
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

# If distro is not provided, default to all
ifndef DISTRO
	DISTRO:=all
endif

all: help

help:
	@echo "\
Docker High Performance PHP Stack\n\
\n\
Issuing commands:\n\
By default, the target distribution will be all available.\n\
If you want to target a specific distribution, you will need to specify it.\n\
You can do this by adding DISTRO to the command.\n\
\n\
Available Commands:\n\
- help:		This help text.\n\
- build:	Builds images from dockerfiles.\n\
- pull:		Pull images from repository.\n\
- create:	Creates containers.\n\
- rm:		Removes containers.\n\
- start:	Starts containers.\n\
- stop:		Stops containers.\n\
- restart:	Restarts containers.\n\
- pause:	Pauses containers.\n\
- unpause:	Unpauses containers.\n\
- ps:		Shows containers.\n\
- logs:		Shows logs.\n\
- events:	Shows events.\n\
- up:		Creates and starts containers.\n\
- down:		Stops and removes containers, networks, images, and volumes.\n\
- netup:	Creates networks.\n\
- netdown:	Removes networks.\n\
\n\
Available distributions:\n\
- debian8\n\
- debian7\n\
- centos7\n\
- centos6\n\
\n\
Example:\n\
 make build DISTRO=debian8\n\
 make create DISTRO=debian8\n\
 make start DISTRO=debian8\n\
 make ps DISTRO=debian8\n\
"


build:
	@echo
	@echo Building images...
	@echo
        ifeq ($(DISTRO), all)
		@echo Building images for debian8...
		bash -c "(cd debian8; set -o allexport; source .env; set +o allexport; docker-compose build)";
		@echo
		@echo Building images for debian7...
		bash -c "(cd debian7; set -o allexport; source .env; set +o allexport; docker-compose build)";
		@echo
		@echo Building images for centos7...
		bash -c "(cd centos7; set -o allexport; source .env; set +o allexport; docker-compose build)";
		@echo
		@echo Building images for centos6...
		bash -c "(cd centos6; set -o allexport; source .env; set +o allexport; docker-compose build)";
        else
		@echo Building images for $(DISTRO)...
		bash -c "(cd $(DISTRO); set -o allexport; source .env; set +o allexport; docker-compose build)";
        endif


pull:
	@echo
	@echo Pulling images...
	@echo
        ifeq ($(DISTRO), all)
		@echo Pulling images for debian8...
		bash -c "(cd debian8; set -o allexport; source .env; set +o allexport; docker-compose pull)";
		@echo
		@echo Pulling images for debian7...
		bash -c "(cd debian7; set -o allexport; source .env; set +o allexport; docker-compose pull)";
		@echo
		@echo Pulling images for centos7...
		bash -c "(cd centos7; set -o allexport; source .env; set +o allexport; docker-compose pull)";
		@echo
		@echo Pulling images for centos6...
		bash -c "(cd centos6; set -o allexport; source .env; set +o allexport; docker-compose pull)";
        else
		@echo Pulling images for $(DISTRO)...
		bash -c "(cd $(DISTRO); set -o allexport; source .env; set +o allexport; docker-compose pull)";
        endif


create:
	@echo
	@echo Creating containers...
	@echo
        ifeq ($(DISTRO), all)
		@echo Creating containers for debian8...
		bash -c "(cd debian8; set -o allexport; source .env; set +o allexport; docker-compose create)";
		@echo
		@echo Creating containers for debian7...
		bash -c "(cd debian7; set -o allexport; source .env; set +o allexport; docker-compose create)";
		@echo
		@echo Creating containers for centos7...
		bash -c "(cd centos7; set -o allexport; source .env; set +o allexport; docker-compose create)";
		@echo
		@echo Creating containers for centos6...
		bash -c "(cd centos6; set -o allexport; source .env; set +o allexport; docker-compose create)";
        else
		@echo Creating containers for $(DISTRO)...
		bash -c "(cd $(DISTRO); set -o allexport; source .env; set +o allexport; docker-compose create)";
        endif


rm:
	@echo
	@echo Removing containers...
	@echo
        ifeq ($(DISTRO), all)
		@echo Removing containers for debian8...
		bash -c "(cd debian8; set -o allexport; source .env; set +o allexport; docker-compose rm)";
		@echo
		@echo Removing containers for debian7...
		bash -c "(cd debian7; set -o allexport; source .env; set +o allexport; docker-compose rm)";
		@echo
		@echo Removing containers for centos7...
		bash -c "(cd centos7; set -o allexport; source .env; set +o allexport; docker-compose rm)";
		@echo
		@echo Removing containers for centos6...
		bash -c "(cd centos6; set -o allexport; source .env; set +o allexport; docker-compose rm)";
        else
		@echo Removing containers for $(DISTRO)...
		bash -c "(cd $(DISTRO); set -o allexport; source .env; set +o allexport; docker-compose rm)";
        endif


start:
	@echo
	@echo Starting containers...
	@echo
        ifeq ($(DISTRO), all)
		@echo Starting containers for debian8...
		bash -c "(cd debian8; set -o allexport; source .env; set +o allexport; docker-compose start)";
		@echo
		@echo Starting containers for debian7...
		bash -c "(cd debian7; set -o allexport; source .env; set +o allexport; docker-compose start)";
		@echo
		@echo Starting containers for centos7...
		bash -c "(cd centos7; set -o allexport; source .env; set +o allexport; docker-compose start)";
		@echo
		@echo Starting containers for centos6...
		bash -c "(cd centos6; set -o allexport; source .env; set +o allexport; docker-compose start)";
        else
		@echo Starting containers for $(DISTRO)...
		bash -c "(cd $(DISTRO); set -o allexport; source .env; set +o allexport; docker-compose start)";
        endif


stop:
	@echo
	@echo Stoping containers...
	@echo
        ifeq ($(DISTRO), all)
		@echo Stoping containers for debian8...
		bash -c "(cd debian8; set -o allexport; source .env; set +o allexport; docker-compose stop)";
		@echo
		@echo Stoping containers for debian7...
		bash -c "(cd debian7; set -o allexport; source .env; set +o allexport; docker-compose stop)";
		@echo
		@echo Stoping containers for centos7...
		bash -c "(cd centos7; set -o allexport; source .env; set +o allexport; docker-compose stop)";
		@echo
		@echo Stoping containers for centos6...
		bash -c "(cd centos6; set -o allexport; source .env; set +o allexport; docker-compose stop)";
        else
		@echo Stoping containers for $(DISTRO)...
		bash -c "(cd $(DISTRO); set -o allexport; source .env; set +o allexport; docker-compose stop)";
        endif


restart:
	@echo
	@echo Restarting containers...
	@echo
        ifeq ($(DISTRO), all)
		@echo Restarting containers for debian8...
		bash -c "(cd debian8; set -o allexport; source .env; set +o allexport; docker-compose restart)";
		@echo
		@echo Restarting containers for debian7...
		bash -c "(cd debian7; set -o allexport; source .env; set +o allexport; docker-compose restart)";
		@echo
		@echo Restarting containers for centos7...
		bash -c "(cd centos7; set -o allexport; source .env; set +o allexport; docker-compose restart)";
		@echo
		@echo Restarting containers for centos6...
		bash -c "(cd centos6; set -o allexport; source .env; set +o allexport; docker-compose restart)";
        else
		@echo Restarting containers for $(DISTRO)...
		bash -c "(cd $(DISTRO); set -o allexport; source .env; set +o allexport; docker-compose restart)";
        endif


pause:
	@echo
	@echo Pausing containers...
	@echo
        ifeq ($(DISTRO), all)
		@echo Pausing containers for debian8...
		bash -c "(cd debian8; set -o allexport; source .env; set +o allexport; docker-compose pause)";
		@echo
		@echo Pausing containers for debian7...
		bash -c "(cd debian7; set -o allexport; source .env; set +o allexport; docker-compose pause)";
		@echo
		@echo Pausing containers for centos7...
		bash -c "(cd centos7; set -o allexport; source .env; set +o allexport; docker-compose pause)";
		@echo
		@echo Pausing containers for centos6...
		bash -c "(cd centos6; set -o allexport; source .env; set +o allexport; docker-compose pause)";
        else
		@echo Pausing containers for $(DISTRO)...
		bash -c "(cd $(DISTRO); set -o allexport; source .env; set +o allexport; docker-compose pause)";
        endif


unpause:
	@echo
	@echo Unpausing containers...
	@echo
        ifeq ($(DISTRO), all)
		@echo Unpausing containers for debian8...
		bash -c "(cd debian8; set -o allexport; source .env; set +o allexport; docker-compose unpause)";
		@echo
		@echo Unpausing containers for debian7...
		bash -c "(cd debian7; set -o allexport; source .env; set +o allexport; docker-compose unpause)";
		@echo
		@echo Unpausing containers for centos7...
		bash -c "(cd centos7; set -o allexport; source .env; set +o allexport; docker-compose unpause)";
		@echo
		@echo Unpausing containers for centos6...
		bash -c "(cd centos6; set -o allexport; source .env; set +o allexport; docker-compose unpause)";
        else
		@echo Unpausing containers for $(DISTRO)...
		bash -c "(cd $(DISTRO); set -o allexport; source .env; set +o allexport; docker-compose unpause)";
        endif


ps:
	@echo
	@echo Showing containers...
	@echo
        ifeq ($(DISTRO), all)
		@echo Showing containers for debian8...
		bash -c "(cd debian8; set -o allexport; source .env; set +o allexport; docker-compose ps)";
		@echo
		@echo Showing containers for debian7...
		bash -c "(cd debian7; set -o allexport; source .env; set +o allexport; docker-compose ps)";
		@echo
		@echo Showing containers for centos7...
		bash -c "(cd centos7; set -o allexport; source .env; set +o allexport; docker-compose ps)";
		@echo
		@echo Showing containers for centos6...
		bash -c "(cd centos6; set -o allexport; source .env; set +o allexport; docker-compose ps)";
        else
		@echo Showing containers for $(DISTRO)...
		bash -c "(cd $(DISTRO); set -o allexport; source .env; set +o allexport; docker-compose ps)";
        endif


logs:
	@echo
	@echo Showing logs...
	@echo
        ifeq ($(DISTRO), all)
		@echo Showing logs for debian8...
		bash -c "(cd debian8; set -o allexport; source .env; set +o allexport; docker-compose logs)";
		@echo
		@echo Showing logs for debian7...
		bash -c "(cd debian7; set -o allexport; source .env; set +o allexport; docker-compose logs)";
		@echo
		@echo Showing logs for centos7...
		bash -c "(cd centos7; set -o allexport; source .env; set +o allexport; docker-compose logs)";
		@echo
		@echo Showing logs for centos6...
		bash -c "(cd centos6; set -o allexport; source .env; set +o allexport; docker-compose logs)";
        else
		@echo Showing logs for $(DISTRO)...
		bash -c "(cd $(DISTRO); set -o allexport; source .env; set +o allexport; docker-compose logs)";
        endif


events:
	@echo
	@echo Showing events...
	@echo
        ifeq ($(DISTRO), all)
		@echo Showing events for debian8...
		bash -c "(cd debian8; set -o allexport; source .env; set +o allexport; docker-compose events)";
		@echo
		@echo Showing events for debian7...
		bash -c "(cd debian7; set -o allexport; source .env; set +o allexport; docker-compose events)";
		@echo
		@echo Showing events for centos7...
		bash -c "(cd centos7; set -o allexport; source .env; set +o allexport; docker-compose events)";
		@echo
		@echo Showing events for centos6...
		bash -c "(cd centos6; set -o allexport; source .env; set +o allexport; docker-compose events)";
        else
		@echo Showing events for $(DISTRO)...
		bash -c "(cd $(DISTRO); set -o allexport; source .env; set +o allexport; docker-compose events)";
        endif


up:
	@echo
	@echo Building images and starting containers...
	@echo
        ifeq ($(DISTRO), all)
		@echo Building images and starting containers for debian8...
		bash -c "(cd debian8; set -o allexport; source .env; set +o allexport; docker-compose up)";
		@echo
		@echo Building images and starting containers for debian7...
		bash -c "(cd debian7; set -o allexport; source .env; set +o allexport; docker-compose up)";
		@echo
		@echo Building images and starting containers for centos7...
		bash -c "(cd centos7; set -o allexport; source .env; set +o allexport; docker-compose up)";
		@echo
		@echo Building images and starting containers for centos6...
		bash -c "(cd centos6; set -o allexport; source .env; set +o allexport; docker-compose up)";
        else
		@echo Building images and starting containers for $(DISTRO)...
		bash -c "(cd $(DISTRO); set -o allexport; source .env; set +o allexport; docker-compose up)";
        endif

down:
	@echo
	@echo Stopping and removing containers, networks, images, and volumes....
	@echo
        ifeq ($(DISTRO), all)
		@echo Stopping and removing containers, networks, images, and volumes for debian8...
		bash -c "(cd debian8; set -o allexport; source .env; set +o allexport; docker-compose down)";
		@echo
		@echo Stopping and removing containers, networks, images, and volumes for debian7...
		bash -c "(cd debian7; set -o allexport; source .env; set +o allexport; docker-compose down)";
		@echo
		@echo Stopping and removing containers, networks, images, and volumes for centos7...
		bash -c "(cd centos7; set -o allexport; source .env; set +o allexport; docker-compose down)";
		@echo
		@echo Stopping and removing containers, networks, images, and volumes for centos6...
		bash -c "(cd centos6; set -o allexport; source .env; set +o allexport; docker-compose down)";
        else
		@echo Stopping and removing containers, networks, images, and volumes for $(DISTRO)...
		bash -c "(cd $(DISTRO); set -o allexport; source .env; set +o allexport; docker-compose down)";
        endif


netup:
	@echo
	@echo Creating networks...
	@echo
        ifeq ($(DISTRO), all)
		@echo Creating networks for debian8...
		docker network create debian8_proxy;
		docker network create debian8_frontend;
		docker network create debian8_application;
		docker network create debian8_backend;
		@echo
		@echo Creating networks for debian7...
		docker network create debian7_proxy;
		docker network create debian7_frontend;
		docker network create debian7_application;
		docker network create debian7_backend;
		@echo
		@echo Creating networks for centos7...
		docker network create centos7_proxy;
		docker network create centos7_frontend;
		docker network create centos7_application;
		docker network create centos7_backend;
		@echo
		@echo Creating networks for centos6...
		docker network create centos6_proxy;
		docker network create centos6_frontend;
		docker network create centos6_application;
		docker network create centos6_backend;
        else
		@echo Creating networks for $(DISTRO)...
		docker network create $(DISTRO)_proxy;
		docker network create $(DISTRO)_frontend;
		docker network create $(DISTRO)_application;
		docker network create $(DISTRO)_backend;
        endif


netdown:
	@echo
	@echo Removing networks...
	@echo
        ifeq ($(DISTRO), all)
		@echo Removing networks for debian8...
		docker network rm debian8_proxy;
		docker network rm debian8_frontend;
		docker network rm debian8_application;
		docker network rm debian8_backend;
		@echo
		@echo Removing networks for debian7...
		docker network rm debian7_proxy;
		docker network rm debian7_frontend;
		docker network rm debian7_application;
		docker network rm debian7_backend;
		@echo
		@echo Removing networks for centos7...
		docker network rm centos7_proxy;
		docker network rm centos7_frontend;
		docker network rm centos7_application;
		docker network rm centos7_backend;
		@echo
		@echo Removing networks for centos6...
		docker network rm centos6_proxy;
		docker network rm centos6_frontend;
		docker network rm centos6_application;
		docker network rm centos6_backend;
        else
		@echo Removing networks for $(DISTRO)...
		docker network rm $(DISTRO)_proxy;
		docker network rm $(DISTRO)_frontend;
		docker network rm $(DISTRO)_application;
		docker network rm $(DISTRO)_backend;
        endif


.SILENT: help

