#!/usr/bin/env bash

# This script is called by `lando pull-db-X`, `lando drupal-reinstall` and `lando drupal-reset`.

NORMAL="\033[0m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[1;33m"
ORANGE="\033[33m"
PINK="\033[35m"
BLUE="\033[34m"
CYAN="\033[36m"

# Set argument option defaults
CONFIG='all'; # The config to import ("all", "local" or "none").

# PARSE THE ARGZZ
while (( "$#" )); do
  case "$1" in
    -c|--config|--config=*)
      echo '--'
      if [ "${1##--config=}" != "$1" ]; then
        CONFIG="${1##--config=}"
        shift
      else
        CONFIG=$2
        shift 2
      fi
      ;;
    --)
      shift
      break
      ;;
    -*|--*=)
      shift
      ;;
    *)
      shift
      ;;
  esac
done

echo -e "${CYAN}Running composer install...${NORMAL}"
echo
composer install
if [[ $? != 0 ]]; then
  echo
  echo -e "${RED}Composer install failed!${NORMAL} ❌"
  echo
  exit 1
fi

echo
echo -e "${CYAN}Running database updates...${NORMAL}"
echo
php -d memory_limit=-1 /app/vendor/drush/drush/drush updb -y
if [[ $? != 0 ]]; then
  echo
  echo -e "${RED}Database updates failed!${NORMAL} ❌"
  echo
  exit 1
fi

echo
echo -e "${CYAN}Clearing caches...${NORMAL}"
echo
php -d memory_limit=-1 /app/vendor/drush/drush/drush cr

if [ "$CONFIG" = 'all' ]; then
  echo
  echo -e "${CYAN}Running config import...${NORMAL}"
  echo
  php -d memory_limit=-1 /app/vendor/drush/drush/drush cim -y
  if [[ $? != 0 ]]; then
    echo
    echo -e "${RED}Config import failed!.${NORMAL} ❌"
    echo
    exit 1
  fi
elif [ "$CONFIG" = 'local' ]; then
    echo
    echo -e "${CYAN}Importing local config split...${NORMAL}"
    echo
  php -d memory_limit=-1 /app/vendor/drush/drush/drush config-split:import local -y
  if [[ $? != 0 ]]; then
    echo
    echo -e "${RED}Config import failed!${NORMAL} ❌"
    echo
    exit 1
  fi
fi

echo
echo -e "${CYAN}Clearing caches...${NORMAL}"
echo
php -d memory_limit=-1 /app/vendor/drush/drush/drush cr

echo
echo -e "${CYAN}Running deploy hooks...${NORMAL}"
echo
php -d memory_limit=-1 /app/vendor/drush/drush/drush deploy:hook -y
if [[ $? != 0 ]]; then
  echo
  echo -e "${RED}Deploy hooks failed!${NORMAL} ❌"
  echo
  exit 1
fi

echo
echo -e "${CYAN}Clearing caches...${NORMAL}"
echo
php -d memory_limit=-1 /app/vendor/drush/drush/drush cr

# Run Drupal health/status check.
/app/lando/scripts/drupal-status.sh

echo -e "${ORANGE}Do you want to create test user accounts?"
echo -e "${BLUE}(y/n):${BLUE}"
read REPLY
if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
  exit 1
else
  # Create test user accounts.
  /app/lando/scripts/drupal-create-users.sh
fi
