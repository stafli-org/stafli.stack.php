#!/bin/bash
#
#    Docker Compose Helper
#    Copyright (C) 2016 SOL-ICT
#    This file is part of the Docker General Purpose System Distro.
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
# Argument = \
#   -i, --interactive \
#   -a, --non-interactive \
#   --project=<project>

printf "\nDocker-compose-helper\n";


#
# Argument input
#

# Read arguments
opts=`getopt \
--options i,a \
--long \
interactive,non-interactive,\
project: \
-n "$0" -- "$@"`;

# Cancel execution if no params are given
if [ $? != 0 ]; then
  echo "Invalid params. Terminating..." >&2;
  exit 1;
fi;

# Set defaults
script_interactive=1;
script_project="";
script_operation=$2;

# Validate arguments
eval set -- "$opts";
while true; do
  case "$1" in
    -i | --interactive )
      script_interactive=1;
      shift;;
    -a | --non-interactive )
      script_interactive=0;
      shift;;
    --project )
      script_project="$2";
      shift 2;;
    -- )
      shift;
      break;;
    * )
      break;;
  esac;
done;


#
# Argument validation
#

# Get script project if empty
if [ -z "$script_project" -a "$script_project" != " " ]; then
  while true; do
    read -p "Please input the project name: " input_project;
    if [ ! -z "$input_project" -a "$input_project" != " " ]; then
      script_project=$input_project;
      break;
    fi;
  done;
fi;


#
# Functions
#

# Execute operation
function execOperation {
  (cd ${distro_path}; set -o allexport; source .env; set +o allexport; docker-compose ${script_operation});
}


#
# Execution
#

printf "Project ${script_project}...";

# Setup paths
project_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
distro_path="${project_path}/${script_project}";

# Prompt to continue
printf "\nExecuting ${script_operation} on ${script_project}...\n";
if [ "$script_interactive" -eq "1" ]; then
  while true; do
    read -p "Continue? [y/n] " input_yn;
    case $input_yn in
      [Yy]* )
        break;;
      [Nn]* )
        exit 0;
        break;;
      * )
        echo "Please answer yes or no."
    esac;
  done;
fi;

# Execute operation
execOperation;


# end