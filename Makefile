#
#    Stafli PHP Stack (makefile)
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

# If distro is not provided, default to all
ifndef DISTRO
	DISTRO:=all
endif

all: help

help:
	@echo "\
Stafli PHP Stack\n\
\n\
Syntax:\n\
make <command> DISTRO=<distribution>\n\
\n\
Issuing commands:\n\
By default, the target distribution will be all available.\n\
If you want to target a specific distribution, you will need to specify it.\n\
You can do this by adding DISTRO to the command.\n\
\n\
Available commands:\n\
- help:			This help text.\n\
- quick start:\n\
  - up:			Builds images and creates and starts containers, networks and volumes.\n\
  - down:		Stops and removes containers and networks.\n\
  - purge:		Purges containers, networks, volumes and images.\n\
- for images:\n\
  - img-ls:		Lists images, using docker, using docker.\n\
  - img-build:		Builds images from dockerfiles, using docker-compose.\n\
  - img-pull:		Pulls images from repository, using docker-compose.\n\
  - img-rm:		Removes images, using docker.\n\
- for containers:\n\
  - con-ls:		Lists containers, using docker-compose.\n\
  - con-create:		Creates containers, using docker-compose.\n\
  - con-rm:		Removes containers, using docker-compose.\n\
  - con-start:		Starts containers, using docker-compose.\n\
  - con-stop:		Stops containers, using docker-compose.\n\
  - con-restart:	Restarts containers, using docker-compose.\n\
  - con-pause:		Pauses containers, using docker-compose.\n\
  - con-unpause:	Unpauses containers, using docker-compose.\n\
  - con-inspect:	Inspects containers, using docker.\n\
  - con-ips:		Shows ips of containers, using docker.\n\
  - con-ports:		Shows logs of containers, using docker.\n\
  - con-top:		Shows processes of containers, using docker.\n\
  - con-logs:		Shows logs of containers, using docker-compose.\n\
  - con-events:		Shows events of containers, using docker-compose.\n\
- for networks:\n\
  - net-ls:		Lists networks, using docker network.\n\
  - net-create:		Creates networks, using docker network.\n\
  - net-rm:		Removes networks, using docker network.\n\
  - net-inspect:	Inspects networks, using docker network.\n\
- for volumes:\n\
  - vol-ls:		Lists volumes, using docker volume.\n\
  - vol-create:		Creates volumes, using docker volume.\n\
  - vol-rm:		Removes volumes, using docker volume.\n\
  - vol-inspect:	Inspects volumes, using docker volume.\n\
\n\
Available distributions:\n\
- debian8\n\
- debian7\n\
- centos7\n\
- centos6\n\
\n\
Example #1: quick start, with build\n\
 make up DISTRO=debian8;\n\
\n\
Example #2: quick start, with pull\n\
 make img-pull DISTRO=debian8;\n\
 make up DISTRO=debian8;\n\
\n\
Example #3: manual steps, with build\n\
 make img-build DISTRO=debian8;\n\
 make net-create DISTRO=debian8;\n\
 make vol-create DISTRO=debian8;\n\
 make con-create DISTRO=debian8;\n\
 make con-start DISTRO=debian8;\n\
 make con-ls DISTRO=debian8;\n\
"


up:
	@echo
	@echo Building images and creates and starts containers, networks and volumes...
	@echo
        ifeq ($(DISTRO), all)
		@echo Building images and creates and starts containers, networks and volumes for debian8...
		bash -c "(cd debian8; set -o allexport; source .env; set +o allexport; docker-compose up)";
		@echo
		@echo Building images and creates and starts containers, networks and volumes for debian7...
		bash -c "(cd debian7; set -o allexport; source .env; set +o allexport; docker-compose up)";
		@echo
		@echo Building images and creates and starts containers, networks and volumes for centos7...
		bash -c "(cd centos7; set -o allexport; source .env; set +o allexport; docker-compose up)";
		@echo
		@echo Building images and creates and starts containers, networks and volumes for centos6...
		bash -c "(cd centos6; set -o allexport; source .env; set +o allexport; docker-compose up)";
        else
		@echo Building images and creates and starts containers, networks and volumes for $(DISTRO)...
		bash -c "(cd $(DISTRO); set -o allexport; source .env; set +o allexport; docker-compose up)";
        endif


down:
	@echo
	@echo Stopping and removes containers and networks....
	@echo
        ifeq ($(DISTRO), all)
		@echo Stopping and removes containers and networks for debian8...
		bash -c "(cd debian8; set -o allexport; source .env; set +o allexport; docker-compose down)";
		@echo
		@echo Stopping and removes containers and networks for debian7...
		bash -c "(cd debian7; set -o allexport; source .env; set +o allexport; docker-compose down)";
		@echo
		@echo Stopping and removes containers and networks for centos7...
		bash -c "(cd centos7; set -o allexport; source .env; set +o allexport; docker-compose down)";
		@echo
		@echo Stopping and removes containers and networks for centos6...
		bash -c "(cd centos6; set -o allexport; source .env; set +o allexport; docker-compose down)";
        else
		@echo Stopping and removes containers and networks for $(DISTRO)...
		bash -c "(cd $(DISTRO); set -o allexport; source .env; set +o allexport; docker-compose down)";
        endif


purge:
	@echo
	@echo Purging containers, networks, volumes and images....
	@echo
        ifeq ($(DISTRO), all)
		@echo Purging containers, networks, volumes and images for debian8...
		bash -c "(cd debian8; set -o allexport; source .env; set +o allexport; docker-compose down)";
		docker volume rm stafli_stack_php56_cache_memcached14_debian8_data;
		docker volume rm stafli_stack_php56_cache_redis32_debian8_data;
		docker volume rm stafli_stack_php56_rdbms_mariadb10_debian8_data;
		docker volume rm stafli_stack_php56_web_debian8_data;
		docker image rm stafli/stafli.stack.php:cache_memcached14_debian8;
		docker image rm stafli/stafli.stack.php:cache_redis32_debian8;
		docker image rm stafli/stafli.stack.php:rdbms_mariadb10_debian8;
		docker image rm stafli/stafli.stack.php:language_php56_debian8;
		docker image rm stafli/stafli.stack.php:web_httpd24_debian8;
		docker image rm stafli/stafli.stack.php:proxy_httpd24_debian8;
		@echo
		@echo Purging containers, networks, volumes and images for debian7...
		bash -c "(cd debian7; set -o allexport; source .env; set +o allexport; docker-compose down)";
		docker volume rm stafli_stack_php56_cache_memcached14_debian7_data;
		docker volume rm stafli_stack_php56_cache_redis32_debian7_data;
		docker volume rm stafli_stack_php56_rdbms_mariadb10_debian7_data;
		docker volume rm stafli_stack_php56_web_debian7_data;
		docker image rm stafli/stafli.stack.php:cache_memcached14_debian7;
		docker image rm stafli/stafli.stack.php:cache_redis32_debian7;
		docker image rm stafli/stafli.stack.php:rdbms_mariadb10_debian7;
		docker image rm stafli/stafli.stack.php:language_php56_debian7;
		docker image rm stafli/stafli.stack.php:web_httpd22_debian7;
		docker image rm stafli/stafli.stack.php:proxy_httpd22_debian7;
		@echo
		@echo Purging containers, networks, volumes and images for centos7...
		bash -c "(cd centos7; set -o allexport; source .env; set +o allexport; docker-compose down)";
		docker volume rm stafli_stack_php56_cache_memcached14_centos7_data;
		docker volume rm stafli_stack_php56_cache_redis32_centos7_data;
		docker volume rm stafli_stack_php56_rdbms_mariadb10_centos7_data;
		docker volume rm stafli_stack_php56_web_centos7_data;
		docker image rm stafli/stafli.stack.php:cache_memcached14_centos7;
		docker image rm stafli/stafli.stack.php:cache_redis32_centos7;
		docker image rm stafli/stafli.stack.php:rdbms_mariadb10_centos7;
		docker image rm stafli/stafli.stack.php:language_php56_centos7;
		docker image rm stafli/stafli.stack.php:web_httpd24_centos7;
		docker image rm stafli/stafli.stack.php:proxy_httpd24_centos7;
		@echo
		@echo Purging containers, networks, volumes and images for centos6...
		bash -c "(cd centos6; set -o allexport; source .env; set +o allexport; docker-compose down)";
		docker volume rm stafli_stack_php56_cache_memcached14_centos6_data;
		docker volume rm stafli_stack_php56_cache_redis32_centos6_data;
		docker volume rm stafli_stack_php56_rdbms_mariadb10_centos6_data;
		docker volume rm stafli_stack_php56_web_centos6_data;
		docker image rm stafli/stafli.stack.php:cache_memcached14_centos6;
		docker image rm stafli/stafli.stack.php:cache_redis32_centos6;
		docker image rm stafli/stafli.stack.php:rdbms_mariadb10_centos6;
		docker image rm stafli/stafli.stack.php:language_php56_centos6;
		docker image rm stafli/stafli.stack.php:web_httpd22_centos6;
		docker image rm stafli/stafli.stack.php:proxy_httpd22_centos6;
        else
		@echo Purging containers, networks, volumes and images for $(DISTRO)...
		bash -c "(cd $(DISTRO); set -o allexport; source .env; set +o allexport; docker-compose down)";
		docker volume rm stafli_stack_php56_cache_memcached14_$(DISTRO)_data;
		docker volume rm stafli_stack_php56_cache_redis32_$(DISTRO)_data;
		docker volume rm stafli_stack_php56_rdbms_mariadb10_$(DISTRO)_data;
		docker volume rm stafli_stack_php56_web_$(DISTRO)_data;
		docker image rm stafli/stafli.stack.php:cache_memcached14_$(DISTRO);
		docker image rm stafli/stafli.stack.php:cache_redis32_$(DISTRO);
		docker image rm stafli/stafli.stack.php:rdbms_mariadb10_$(DISTRO);
		docker image rm stafli/stafli.stack.php:language_php56_$(DISTRO);
                ifeq ($(DISTRO), debian8)
			docker image rm stafli/stafli.stack.php:web_httpd24_$(DISTRO);
			docker image rm stafli/stafli.stack.php:proxy_httpd24_$(DISTRO);
                else ifeq ($(DISTRO), debian7)
			docker image rm stafli/stafli.stack.php:web_httpd22_$(DISTRO);
			docker image rm stafli/stafli.stack.php:proxy_httpd22_$(DISTRO);
                else ifeq ($(DISTRO), centos7)
			docker image rm stafli/stafli.stack.php:web_httpd24_$(DISTRO);
			docker image rm stafli/stafli.stack.php:proxy_httpd24_$(DISTRO);
                else ifeq ($(DISTRO), centos6)
			docker image rm stafli/stafli.stack.php:web_httpd22_$(DISTRO);
			docker image rm stafli/stafli.stack.php:proxy_httpd22_$(DISTRO);
                endif
        endif


img-ls:
	@echo
	@echo Listing images...
	@echo
        ifeq ($(DISTRO), all)
		@echo Listing images for debian8...
		docker image ls | grep -E "stafli/stafli.stack.php.*debian8" | sort -n;
		@echo
		@echo Listing images for debian7...
		docker image ls | grep -E "stafli/stafli.stack.php.*debian7" | sort -n;
		@echo
		@echo Listing images for centos7...
		docker image ls | grep -E "stafli/stafli.stack.php.*centos7" | sort -n;
		@echo
		@echo Listing images for centos6...
		docker image ls | grep -E "stafli/stafli.stack.php.*centos6" | sort -n;
        else
		@echo Listing images for $(DISTRO)...
		docker image ls | grep -E "stafli/stafli.stack.php.*$(DISTRO)" | sort -n;
        endif


img-build:
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


img-pull:
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


img-rm:
	@echo
	@echo Removing images...
	@echo
        ifeq ($(DISTRO), all)
		@echo Removing images for debian8...
		docker image rm stafli/stafli.stack.php:cache_memcached14_debian8;
		docker image rm stafli/stafli.stack.php:cache_redis32_debian8;
		docker image rm stafli/stafli.stack.php:rdbms_mariadb10_debian8;
		docker image rm stafli/stafli.stack.php:language_php56_debian8;
		docker image rm stafli/stafli.stack.php:web_httpd24_debian8;
		docker image rm stafli/stafli.stack.php:proxy_httpd24_debian8;
		@echo
		@echo Removing images for debian7...
		docker image rm stafli/stafli.stack.php:cache_memcached14_debian7;
		docker image rm stafli/stafli.stack.php:cache_redis32_debian7;
		docker image rm stafli/stafli.stack.php:rdbms_mariadb10_debian7;
		docker image rm stafli/stafli.stack.php:language_php56_debian7;
		docker image rm stafli/stafli.stack.php:web_httpd22_debian7;
		docker image rm stafli/stafli.stack.php:proxy_httpd22_debian7;
		@echo
		@echo Removing images for centos7...
		docker image rm stafli/stafli.stack.php:cache_memcached14_centos7;
		docker image rm stafli/stafli.stack.php:cache_redis32_centos7;
		docker image rm stafli/stafli.stack.php:rdbms_mariadb10_centos7;
		docker image rm stafli/stafli.stack.php:language_php56_centos7;
		docker image rm stafli/stafli.stack.php:web_httpd24_centos7;
		docker image rm stafli/stafli.stack.php:proxy_httpd24_centos7;
		@echo
		@echo Removing images for centos6...
		docker image rm stafli/stafli.stack.php:cache_memcached14_centos6;
		docker image rm stafli/stafli.stack.php:cache_redis32_centos6;
		docker image rm stafli/stafli.stack.php:rdbms_mariadb10_centos6;
		docker image rm stafli/stafli.stack.php:language_php56_centos6;
		docker image rm stafli/stafli.stack.php:web_httpd22_centos6;
		docker image rm stafli/stafli.stack.php:proxy_httpd22_centos6;
        else
		@echo Removing images for $(DISTRO)...
		docker image rm stafli/stafli.stack.php:cache_memcached14_$(DISTRO);
		docker image rm stafli/stafli.stack.php:cache_redis32_$(DISTRO);
		docker image rm stafli/stafli.stack.php:rdbms_mariadb10_$(DISTRO);
		docker image rm stafli/stafli.stack.php:language_php56_$(DISTRO);
                ifeq ($(DISTRO), debian8)
			docker image rm stafli/stafli.stack.php:web_httpd24_$(DISTRO);
			docker image rm stafli/stafli.stack.php:proxy_httpd24_$(DISTRO);
                else ifeq ($(DISTRO), debian7)
			docker image rm stafli/stafli.stack.php:web_httpd22_$(DISTRO);
			docker image rm stafli/stafli.stack.php:proxy_httpd22_$(DISTRO);
                else ifeq ($(DISTRO), centos7)
			docker image rm stafli/stafli.stack.php:web_httpd24_$(DISTRO);
			docker image rm stafli/stafli.stack.php:proxy_httpd24_$(DISTRO);
                else ifeq ($(DISTRO), centos6)
			docker image rm stafli/stafli.stack.php:web_httpd22_$(DISTRO);
			docker image rm stafli/stafli.stack.php:proxy_httpd22_$(DISTRO);
                endif
        endif


con-ls:
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


con-create:
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


con-rm:
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


con-start:
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


con-stop:
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


con-restart:
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


con-pause:
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


con-unpause:
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


con-inspect:
	@echo
	@echo Inspecting containers...
	@echo
        ifeq ($(DISTRO), all)
		@echo Inspecting containers for debian8...
		docker container inspect stafli_stack_php56_cache_memcached14_debian8_1;
		docker container inspect stafli_stack_php56_cache_redis32_debian8_1;
		docker container inspect stafli_stack_php56_rdbms_mariadb10_debian8_1;
		docker container inspect stafli_stack_php56_language_php56_debian8_1;
		docker container inspect stafli_stack_php56_web_httpd24_debian8_1;
		docker container inspect stafli_stack_php56_proxy_httpd24_debian8_1;
		@echo
		@echo Inspecting containers for debian7...
		docker container inspect stafli_stack_php56_cache_memcached14_debian7_1;
		docker container inspect stafli_stack_php56_cache_redis32_debian7_1;
		docker container inspect stafli_stack_php56_rdbms_mariadb10_debian7_1;
		docker container inspect stafli_stack_php56_language_php56_debian7_1;
		docker container inspect stafli_stack_php56_web_httpd22_debian7_1;
		docker container inspect stafli_stack_php56_proxy_httpd22_debian7_1;
		@echo
		@echo Inspecting containers for centos7...
		docker container inspect stafli_stack_php56_cache_memcached14_centos7_1;
		docker container inspect stafli_stack_php56_cache_redis32_centos7_1;
		docker container inspect stafli_stack_php56_rdbms_mariadb10_centos7_1;
		docker container inspect stafli_stack_php56_language_php56_centos7_1;
		docker container inspect stafli_stack_php56_web_httpd24_centos7_1;
		docker container inspect stafli_stack_php56_proxy_httpd24_centos7_1;
		@echo
		@echo Inspecting containers for centos6...
		docker container inspect stafli_stack_php56_cache_memcached14_centos6_1;
		docker container inspect stafli_stack_php56_cache_redis32_centos6_1;
		docker container inspect stafli_stack_php56_rdbms_mariadb10_centos6_1;
		docker container inspect stafli_stack_php56_language_php56_centos6_1;
		docker container inspect stafli_stack_php56_web_httpd22_centos6_1;
		docker container inspect stafli_stack_php56_proxy_httpd22_centos6_1;
        else
		@echo Inspecting containers for $(DISTRO)...
		docker container inspect stafli_stack_php56_cache_memcached14_$(DISTRO)_1;
		docker container inspect stafli_stack_php56_cache_redis32_$(DISTRO)_1;
		docker container inspect stafli_stack_php56_rdbms_mariadb10_$(DISTRO)_1;
		docker container inspect stafli_stack_php56_language_php56_$(DISTRO)_1;
                ifeq ($(DISTRO), debian8)
			docker container inspect stafli_stack_php56_web_httpd24_$(DISTRO)_1;
			docker container inspect stafli_stack_php56_proxy_httpd24_$(DISTRO)_1;
                else ifeq ($(DISTRO), debian7)
			docker container inspect stafli_stack_php56_web_httpd22_$(DISTRO)_1;
			docker container inspect stafli_stack_php56_proxy_httpd22_$(DISTRO)_1;
                else ifeq ($(DISTRO), centos7)
			docker container inspect stafli_stack_php56_web_httpd24_$(DISTRO)_1;
			docker container inspect stafli_stack_php56_proxy_httpd24_$(DISTRO)_1;
                else ifeq ($(DISTRO), centos6)
			docker container inspect stafli_stack_php56_web_httpd22_$(DISTRO)_1;
			docker container inspect stafli_stack_php56_proxy_httpd22_$(DISTRO)_1;
                endif
        endif

con-ips:
	@echo
	@echo Showing IP addresses of containers...
	@echo
        ifeq ($(DISTRO), all)
		@echo Showing IP addresses of containers for debian8...
		docker container inspect stafli_stack_php56_cache_memcached14_debian8_1 | grep -e "inspect" -e "\"NetworkID\"" -B 0 -A 8;
		docker container inspect stafli_stack_php56_cache_redis32_debian8_1 | grep -e "inspect" -e "\"NetworkID\"" -B 0 -A 8;
		docker container inspect stafli_stack_php56_rdbms_mariadb10_debian8_1 | grep -e "inspect" -e "\"NetworkID\"" -B 0 -A 8;
		docker container inspect stafli_stack_php56_language_php56_debian8_1 | grep -e "inspect" -e "\"NetworkID\"" -B 0 -A 8;
		docker container inspect stafli_stack_php56_web_httpd24_debian8_1 | grep -e "inspect" -e "\"NetworkID\"" -B 0 -A 8;
		docker container inspect stafli_stack_php56_proxy_httpd24_debian8_1 | grep -e "inspect" -e "\"NetworkID\"" -B 0 -A 8;
		@echo
		@echo Showing IP addresses of containers for debian7...
		docker container inspect stafli_stack_php56_cache_memcached14_debian7_1 | grep -e "inspect" -e "\"NetworkID\"" -B 0 -A 8;
		docker container inspect stafli_stack_php56_cache_redis32_debian7_1 | grep -e "inspect" -e "\"NetworkID\"" -B 0 -A 8;
		docker container inspect stafli_stack_php56_rdbms_mariadb10_debian7_1 | grep -e "inspect" -e "\"NetworkID\"" -B 0 -A 8;
		docker container inspect stafli_stack_php56_language_php56_debian7_1 | grep -e "inspect" -e "\"NetworkID\"" -B 0 -A 8;
		docker container inspect stafli_stack_php56_web_httpd22_debian7_1 | grep -e "inspect" -e "\"NetworkID\"" -B 0 -A 8;
		docker container inspect stafli_stack_php56_proxy_httpd22_debian7_1 | grep -e "inspect" -e "\"NetworkID\"" -B 0 -A 8;
		@echo
		@echo Showing IP addresses of containers for centos7...
		docker container inspect stafli_stack_php56_cache_memcached14_centos7_1 | grep -e "inspect" -e "\"NetworkID\"" -B 0 -A 8;
		docker container inspect stafli_stack_php56_cache_redis32_centos7_1 | grep -e "inspect" -e "\"NetworkID\"" -B 0 -A 8;
		docker container inspect stafli_stack_php56_rdbms_mariadb10_centos7_1 | grep -e "inspect" -e "\"NetworkID\"" -B 0 -A 8;
		docker container inspect stafli_stack_php56_language_php56_centos7_1 | grep -e "inspect" -e "\"NetworkID\"" -B 0 -A 8;
		docker container inspect stafli_stack_php56_web_httpd24_centos7_1 | grep -e "inspect" -e "\"NetworkID\"" -B 0 -A 8;
		docker container inspect stafli_stack_php56_proxy_httpd24_centos7_1 | grep -e "inspect" -e "\"NetworkID\"" -B 0 -A 8;
		@echo
		@echo Showing IP addresses of containers for centos6...
		docker container inspect stafli_stack_php56_cache_memcached14_centos6_1 | grep -e "inspect" -e "\"NetworkID\"" -B 0 -A 8;
		docker container inspect stafli_stack_php56_cache_redis32_centos6_1 | grep -e "inspect" -e "\"NetworkID\"" -B 0 -A 8;
		docker container inspect stafli_stack_php56_rdbms_mariadb10_centos6_1 | grep -e "inspect" -e "\"NetworkID\"" -B 0 -A 8;
		docker container inspect stafli_stack_php56_language_php56_centos6_1 | grep -e "inspect" -e "\"NetworkID\"" -B 0 -A 8;
		docker container inspect stafli_stack_php56_web_httpd22_centos6_1 | grep -e "inspect" -e "\"NetworkID\"" -B 0 -A 8;
		docker container inspect stafli_stack_php56_proxy_httpd22_centos6_1 | grep -e "inspect" -e "\"NetworkID\"" -B 0 -A 8;
        else
		@echo Showing IP addresses of containers for $(DISTRO)...
		docker container inspect stafli_stack_php56_cache_memcached14_$(DISTRO)_1 | grep -e "inspect" -e "\"NetworkID\"" -B 0 -A 8;
		docker container inspect stafli_stack_php56_cache_redis32_$(DISTRO)_1 | grep -e "inspect" -e "\"NetworkID\"" -B 0 -A 8;
		docker container inspect stafli_stack_php56_rdbms_mariadb10_$(DISTRO)_1 | grep -e "inspect" -e "\"NetworkID\"" -B 0 -A 8;
		docker container inspect stafli_stack_php56_language_php56_$(DISTRO)_1 | grep -e "inspect" -e "\"NetworkID\"" -B 0 -A 8;
                ifeq ($(DISTRO), debian8)
			docker container inspect stafli_stack_php56_web_httpd24_$(DISTRO)_1 | grep -e "inspect" -e "\"NetworkID\"" -B 0 -A 8;
			docker container inspect stafli_stack_php56_proxy_httpd24_$(DISTRO)_1 | grep -e "inspect" -e "\"NetworkID\"" -B 0 -A 8;
                else ifeq ($(DISTRO), debian7)
			docker container inspect stafli_stack_php56_web_httpd22_$(DISTRO)_1 | grep -e "inspect" -e "\"NetworkID\"" -B 0 -A 8;
			docker container inspect stafli_stack_php56_proxy_httpd22_$(DISTRO)_1 | grep -e "inspect" -e "\"NetworkID\"" -B 0 -A 8;
                else ifeq ($(DISTRO), centos7)
			docker container inspect stafli_stack_php56_web_httpd24_$(DISTRO)_1 | grep -e "inspect" -e "\"NetworkID\"" -B 0 -A 8;
			docker container inspect stafli_stack_php56_proxy_httpd24_$(DISTRO)_1 | grep -e "inspect" -e "\"NetworkID\"" -B 0 -A 8;
                else ifeq ($(DISTRO), centos6)
			docker container inspect stafli_stack_php56_web_httpd22_$(DISTRO)_1 | grep -e "inspect" -e "\"NetworkID\"" -B 0 -A 8;
			docker container inspect stafli_stack_php56_proxy_httpd22_$(DISTRO)_1 | grep -e "inspect" -e "\"NetworkID\"" -B 0 -A 8;
                endif
        endif


con-ports:
	@echo
	@echo Showing ports of containers...
	@echo
        ifeq ($(DISTRO), all)
		@echo Showing ports of containers for debian8...
		docker container port stafli_stack_php56_cache_memcached14_debian8_1;
		docker container port stafli_stack_php56_cache_redis32_debian8_1;
		docker container port stafli_stack_php56_rdbms_mariadb10_debian8_1;
		docker container port stafli_stack_php56_language_php56_debian8_1;
		docker container port stafli_stack_php56_web_httpd24_debian8_1;
		docker container port stafli_stack_php56_proxy_httpd24_debian8_1;
		@echo
		@echo Showing ports of containers for debian7...
		docker container port stafli_stack_php56_cache_memcached14_debian7_1;
		docker container port stafli_stack_php56_cache_redis32_debian7_1;
		docker container port stafli_stack_php56_rdbms_mariadb10_debian7_1;
		docker container port stafli_stack_php56_language_php56_debian7_1;
		docker container port stafli_stack_php56_web_httpd22_debian7_1;
		docker container port stafli_stack_php56_proxy_httpd22_debian7_1;
		@echo
		@echo Showing ports of containers for centos7...
		docker container port stafli_stack_php56_cache_memcached14_centos7_1;
		docker container port stafli_stack_php56_cache_redis32_centos7_1;
		docker container port stafli_stack_php56_rdbms_mariadb10_centos7_1;
		docker container port stafli_stack_php56_language_php56_centos7_1;
		docker container port stafli_stack_php56_web_httpd24_centos7_1;
		docker container port stafli_stack_php56_proxy_httpd24_centos7_1;
		@echo
		@echo Showing ports of containers for centos6...
		docker container port stafli_stack_php56_cache_memcached14_centos6_1;
		docker container port stafli_stack_php56_cache_redis32_centos6_1;
		docker container port stafli_stack_php56_rdbms_mariadb10_centos6_1;
		docker container port stafli_stack_php56_language_php56_centos6_1;
		docker container port stafli_stack_php56_web_httpd22_centos6_1;
		docker container port stafli_stack_php56_proxy_httpd22_centos6_1;
        else
		@echo Showing ports of containers for $(DISTRO)...
		docker container port stafli_stack_php56_cache_memcached14_$(DISTRO)_1;
		docker container port stafli_stack_php56_cache_redis32_$(DISTRO)_1;
		docker container port stafli_stack_php56_rdbms_mariadb10_$(DISTRO)_1;
		docker container port stafli_stack_php56_language_php56_$(DISTRO)_1;
                ifeq ($(DISTRO), debian8)
			docker container port stafli_stack_php56_web_httpd24_$(DISTRO)_1;
			docker container port stafli_stack_php56_proxy_httpd24_$(DISTRO)_1;
                else ifeq ($(DISTRO), debian7)
			docker container port stafli_stack_php56_web_httpd22_$(DISTRO)_1;
			docker container port stafli_stack_php56_proxy_httpd22_$(DISTRO)_1;
                else ifeq ($(DISTRO), centos7)
			docker container port stafli_stack_php56_web_httpd24_$(DISTRO)_1;
			docker container port stafli_stack_php56_proxy_httpd24_$(DISTRO)_1;
                else ifeq ($(DISTRO), centos6)
			docker container port stafli_stack_php56_web_httpd22_$(DISTRO)_1;
			docker container port stafli_stack_php56_proxy_httpd22_$(DISTRO)_1;
                endif
        endif


con-top:
	@echo
	@echo Showing processes of containers...
	@echo
        ifeq ($(DISTRO), all)
		@echo Showing processes of containers for debian8...
		docker container top stafli_stack_php56_cache_memcached14_debian8_1;
		docker container top stafli_stack_php56_cache_redis32_debian8_1;
		docker container top stafli_stack_php56_rdbms_mariadb10_debian8_1;
		docker container top stafli_stack_php56_language_php56_debian8_1;
		docker container top stafli_stack_php56_web_httpd24_debian8_1;
		docker container top stafli_stack_php56_proxy_httpd24_debian8_1;
		@echo
		@echo Showing processes of containers for debian7...
		docker container top stafli_stack_php56_cache_memcached14_debian7_1;
		docker container top stafli_stack_php56_cache_redis32_debian7_1;
		docker container top stafli_stack_php56_rdbms_mariadb10_debian7_1;
		docker container top stafli_stack_php56_language_php56_debian7_1;
		docker container top stafli_stack_php56_web_httpd22_debian7_1;
		docker container top stafli_stack_php56_proxy_httpd22_debian7_1;
		@echo
		@echo Showing processes of containers for centos7...
		docker container top stafli_stack_php56_cache_memcached14_centos7_1;
		docker container top stafli_stack_php56_cache_redis32_centos7_1;
		docker container top stafli_stack_php56_rdbms_mariadb10_centos7_1;
		docker container top stafli_stack_php56_language_php56_centos7_1;
		docker container top stafli_stack_php56_web_httpd24_centos7_1;
		docker container top stafli_stack_php56_proxy_httpd24_centos7_1;
		@echo
		@echo Showing processes of containers for centos6...
		docker container top stafli_stack_php56_cache_memcached14_centos6_1;
		docker container top stafli_stack_php56_cache_redis32_centos6_1;
		docker container top stafli_stack_php56_rdbms_mariadb10_centos6_1;
		docker container top stafli_stack_php56_language_php56_centos6_1;
		docker container top stafli_stack_php56_web_httpd22_centos6_1;
		docker container top stafli_stack_php56_proxy_httpd22_centos6_1;
        else
		@echo Showing processes of containers for $(DISTRO)...
		docker container top stafli_stack_php56_cache_memcached14_$(DISTRO)_1;
		docker container top stafli_stack_php56_cache_redis32_$(DISTRO)_1;
		docker container top stafli_stack_php56_rdbms_mariadb10_$(DISTRO)_1;
		docker container top stafli_stack_php56_language_php56_$(DISTRO)_1;
                ifeq ($(DISTRO), debian8)
			docker container top stafli_stack_php56_web_httpd24_$(DISTRO)_1;
			docker container top stafli_stack_php56_proxy_httpd24_$(DISTRO)_1;
                else ifeq ($(DISTRO), debian7)
			docker container top stafli_stack_php56_web_httpd22_$(DISTRO)_1;
			docker container top stafli_stack_php56_proxy_httpd22_$(DISTRO)_1;
                else ifeq ($(DISTRO), centos7)
			docker container top stafli_stack_php56_web_httpd24_$(DISTRO)_1;
			docker container top stafli_stack_php56_proxy_httpd24_$(DISTRO)_1;
                else ifeq ($(DISTRO), centos6)
			docker container top stafli_stack_php56_web_httpd22_$(DISTRO)_1;
			docker container top stafli_stack_php56_proxy_httpd22_$(DISTRO)_1;
                endif
        endif


con-logs:
	@echo
	@echo Showing logs of containers...
	@echo
        ifeq ($(DISTRO), all)
		@echo Showing logs of containers for debian8...
		bash -c "(cd debian8; set -o allexport; source .env; set +o allexport; docker-compose logs)";
		@echo
		@echo Showing logs of containers for debian7...
		bash -c "(cd debian7; set -o allexport; source .env; set +o allexport; docker-compose logs)";
		@echo
		@echo Showing logs of containers for centos7...
		bash -c "(cd centos7; set -o allexport; source .env; set +o allexport; docker-compose logs)";
		@echo
		@echo Showing logs of containers for centos6...
		bash -c "(cd centos6; set -o allexport; source .env; set +o allexport; docker-compose logs)";
        else
		@echo Showing logs of containers for $(DISTRO)...
		bash -c "(cd $(DISTRO); set -o allexport; source .env; set +o allexport; docker-compose logs)";
        endif


con-events:
	@echo
	@echo Showing events of containers...
	@echo
        ifeq ($(DISTRO), all)
		@echo Showing events of containers for debian8...
		bash -c "(cd debian8; set -o allexport; source .env; set +o allexport; docker-compose events)";
		@echo
		@echo Showing events of containers for debian7...
		bash -c "(cd debian7; set -o allexport; source .env; set +o allexport; docker-compose events)";
		@echo
		@echo Showing events of containers for centos7...
		bash -c "(cd centos7; set -o allexport; source .env; set +o allexport; docker-compose events)";
		@echo
		@echo Showing events of containers for centos6...
		bash -c "(cd centos6; set -o allexport; source .env; set +o allexport; docker-compose events)";
        else
		@echo Showing events of containers for $(DISTRO)...
		bash -c "(cd $(DISTRO); set -o allexport; source .env; set +o allexport; docker-compose events)";
        endif


net-ls:
	@echo
	@echo Listing networks...
	@echo
        ifeq ($(DISTRO), all)
		@echo Listing networks for debian8...
		docker network ls | grep -E "debian8" | sort -n;
		@echo
		@echo Listing networks for debian7...
		docker network ls | grep -E "debian7" | sort -n;
		@echo
		@echo Listing networks for centos7...
		docker network ls | grep -E "centos7" | sort -n;
		@echo
		@echo Listing networks for centos6...
		docker network ls | grep -E "centos6" | sort -n;
        else
		@echo Listing networks for $(DISTRO)...
		docker network ls | grep -E "$(DISTRO)" | sort -n;
        endif


net-create:
	@echo
	@echo Creating networks...
	@echo
	@echo Creating networks for all...
	docker network create stafli_stack_php56_proxy;
	docker network create stafli_stack_php56_frontend;
	docker network create stafli_stack_php56_application;
	docker network create stafli_stack_php56_backend;


net-rm:
	@echo
	@echo Removing networks...
	@echo
	@echo Removing networks for all...
	docker network rm stafli_stack_php56_proxy;
	docker network rm stafli_stack_php56_frontend;
	docker network rm stafli_stack_php56_application;
	docker network rm stafli_stack_php56_backend;


net-inspect:
	@echo
	@echo Inspecting networks...
	@echo
	@echo Inspecting networks for all...
	docker network inspect stafli_stack_php56_proxy;
	docker network inspect stafli_stack_php56_frontend;
	docker network inspect stafli_stack_php56_application;
	docker network inspect stafli_stack_php56_backend;


vol-ls:
	@echo
	@echo Listing volumes...
	@echo
        ifeq ($(DISTRO), all)
		@echo Listing volumes for debian8...
		docker volume ls | grep -E "debian8" | sort -n;
		@echo
		@echo Listing volumes for debian7...
		docker volume ls | grep -E "debian7" | sort -n;
		@echo
		@echo Listing volumes for centos7...
		docker volume ls | grep -E "centos7" | sort -n;
		@echo
		@echo Listing volumes for centos6...
		docker volume ls | grep -E "centos6" | sort -n;
        else
		@echo Listing volumes for $(DISTRO)...
		docker volume ls | grep -E "$(DISTRO)" | sort -n;
        endif


vol-create:
	@echo
	@echo Creating volumes...
	@echo
        ifeq ($(DISTRO), all)
		@echo Creating volumes for debian8...
		docker volume create --driver local --name stafli_stack_php56_cache_memcached14_debian8_data;
		docker volume create --driver local --name stafli_stack_php56_cache_redis32_debian8_data;
		docker volume create --driver local --name stafli_stack_php56_rdbms_mariadb10_debian8_data;
		docker volume create --driver local --name stafli_stack_php56_web_debian8_data;
		@echo
		@echo Creating volumes for debian7...
		docker volume create --driver local --name stafli_stack_php56_cache_memcached14_debian7_data;
		docker volume create --driver local --name stafli_stack_php56_cache_redis32_debian7_data;
		docker volume create --driver local --name stafli_stack_php56_rdbms_mariadb10_debian7_data;
		docker volume create --driver local --name stafli_stack_php56_web_debian7_data;
		@echo
		@echo Creating volumes for centos7...
		docker volume create --driver local --name stafli_stack_php56_cache_memcached14_centos7_data;
		docker volume create --driver local --name stafli_stack_php56_cache_redis32_centos7_data;
		docker volume create --driver local --name stafli_stack_php56_rdbms_mariadb10_centos7_data;
		docker volume create --driver local --name stafli_stack_php56_web_centos7_data;
		@echo
		@echo Creating volumes for centos6...
		docker volume create --driver local --name stafli_stack_php56_cache_memcached14_centos6_data;
		docker volume create --driver local --name stafli_stack_php56_cache_redis32_centos6_data;
		docker volume create --driver local --name stafli_stack_php56_rdbms_mariadb10_centos6_data;
		docker volume create --driver local --name stafli_stack_php56_web_centos6_data;
        else
		@echo Creating volumes for $(DISTRO)...
		docker volume create --driver local --name stafli_stack_php56_cache_memcached14_$(DISTRO)_data;
		docker volume create --driver local --name stafli_stack_php56_cache_redis32_$(DISTRO)_data;
		docker volume create --driver local --name stafli_stack_php56_rdbms_mariadb10_$(DISTRO)_data;
		docker volume create --driver local --name stafli_stack_php56_web_$(DISTRO)_data;
        endif


vol-rm:
	@echo
	@echo Removing volumes...
	@echo
        ifeq ($(DISTRO), all)
		@echo Removing volumes for debian8...
		docker volume rm stafli_stack_php56_cache_memcached14_debian8_data;
		docker volume rm stafli_stack_php56_cache_redis32_debian8_data;
		docker volume rm stafli_stack_php56_rdbms_mariadb10_debian8_data;
		docker volume rm stafli_stack_php56_web_debian8_data;
		@echo
		@echo Removing volumes for debian7...
		docker volume rm stafli_stack_php56_cache_memcached14_debian7_data;
		docker volume rm stafli_stack_php56_cache_redis32_debian7_data;
		docker volume rm stafli_stack_php56_rdbms_mariadb10_debian7_data;
		docker volume rm stafli_stack_php56_web_debian7_data;
		@echo
		@echo Removing volumes for centos7...
		docker volume rm stafli_stack_php56_cache_memcached14_centos7_data;
		docker volume rm stafli_stack_php56_cache_redis32_centos7_data;
		docker volume rm stafli_stack_php56_rdbms_mariadb10_centos7_data;
		docker volume rm stafli_stack_php56_web_centos7_data;
		@echo
		@echo Removing volumes for centos6...
		docker volume rm stafli_stack_php56_cache_memcached14_centos6_data;
		docker volume rm stafli_stack_php56_cache_redis32_centos6_data;
		docker volume rm stafli_stack_php56_rdbms_mariadb10_centos6_data;
		docker volume rm stafli_stack_php56_web_centos6_data;
        else
		@echo Removing volumes for $(DISTRO)...
		docker volume rm stafli_stack_php56_cache_memcached14_$(DISTRO)_data;
		docker volume rm stafli_stack_php56_cache_redis32_$(DISTRO)_data;
		docker volume rm stafli_stack_php56_rdbms_mariadb10_$(DISTRO)_data;
		docker volume rm stafli_stack_php56_web_$(DISTRO)_data;
        endif


vol-inspect:
	@echo
	@echo Inspecting volumes...
	@echo
        ifeq ($(DISTRO), all)
		@echo Inspecting volumes for debian8...
		docker volume inspect stafli_stack_php56_cache_memcached14_debian8_data;
		docker volume inspect stafli_stack_php56_cache_redis32_debian8_data;
		docker volume inspect stafli_stack_php56_rdbms_mariadb10_debian8_data;
		docker volume inspect stafli_stack_php56_web_debian8_data;
		@echo
		@echo Inspecting volumes for debian7...
		docker volume inspect stafli_stack_php56_cache_memcached14_debian7_data;
		docker volume inspect stafli_stack_php56_cache_redis32_debian7_data;
		docker volume inspect stafli_stack_php56_rdbms_mariadb10_debian7_data;
		docker volume inspect stafli_stack_php56_web_debian7_data;
		@echo
		@echo Inspecting volumes for centos7...
		docker volume inspect stafli_stack_php56_cache_memcached14_centos7_data;
		docker volume inspect stafli_stack_php56_cache_redis32_centos7_data;
		docker volume inspect stafli_stack_php56_rdbms_mariadb10_centos7_data;
		docker volume inspect stafli_stack_php56_web_centos7_data;
		@echo
		@echo Inspecting volumes for centos6...
		docker volume inspect stafli_stack_php56_cache_memcached14_centos6_data;
		docker volume inspect stafli_stack_php56_cache_redis32_centos6_data;
		docker volume inspect stafli_stack_php56_rdbms_mariadb10_centos6_data;
		docker volume inspect stafli_stack_php56_web_centos6_data;
        else
		@echo Inspecting volumes for $(DISTRO)...
		docker volume inspect stafli_stack_php56_cache_memcached14_$(DISTRO)_data;
		docker volume inspect stafli_stack_php56_cache_redis32_$(DISTRO)_data;
		docker volume inspect stafli_stack_php56_rdbms_mariadb10_$(DISTRO)_data;
		docker volume inspect stafli_stack_php56_web_$(DISTRO)_data;
        endif


.SILENT: help

