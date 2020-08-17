#!/usr/bin/env bash

# INSTRUCTIONS: MAKE THIS FILE EXECUTABLE TO USE: chmod +x ./dev.sh

### Set environment variables for dev or CLI
## THE PARAMETERS IN HERE WILL BE USED IN THE docker-compose.yml
##  They override the ones defined in the .env file for docker-compose.yml
##  Note: Parameter explicitly set in docker-compose.yml have the highest priority

# THE FOLLOWING WILL OVERRIDE THE DOCKER COMPOSE ENVIRONMENT PARAMETERS DEFINED IN THE docker-compose .env
export DB_PORT=${DB_PORT:-33063}
export DB_ROOT_PASSWORD=${DB_ROOT_PASSWORD:-root}
export DB_USER=${DB_USER:-root}
export DB_PASSWORD=${DB_PASSWORD:-root}

# Do NOT pass a pseudo-tty so it does not becaome interactive
#   PHPUnit will throw an error if it is run with tty (interactive)
# Disable pseudo-TTY allocation for CI (Jenkins)
TTY=""

# If $BUILD_NUMBER is defined
if [ ! -z "$BUILD_NUMBER" ]; then
  # Run as NPN-interactive
  TTY="-T"
fi

COMPOSE="docker-compose"

## DEFINE CASES FOR COMMAND PARAMETERS:

if [ $# -gt 0 ]; then

  if [ "$1" == "start" ]; then
      $COMPOSE up -d $TTY

  elif [ "$1" == "stop" ]; then
      $COMPOSE down $TTY

  elif [ "$1" == "run" ]; then
      # Run docker-compose commands inside the working directory.
      # docker-compose run SPINS UP A NEW CONTAINER. This is not the case with docker-compose exec (it re-uses the existing one)
      $COMPOSE run --rm $TTY \
          -w /var/www "$@"

  elif [ "$1" == "db" ]; then
      shift 1
      $COMPOSE exec maindb bash

  elif [ "$1" == "volumes" ]; then
      shift 1
      if [ "$1" == "size" ]; then
          docker system df -v

      else
          docker volume ls;
      fi

  # Unnecessary entry, just for clarity
  elif [ "" == "check" ]; then
      shift 1
      $COMPOSE check

  # Check the loaded docker-compose configuration
  elif [ "" == "config" ]; then
      shift 1
      $COMPOSE config

  # Else, pass-through args to docker-compose
  else
    $COMPOSE "$@"
  fi
else
  $COMPOSE ps
fi