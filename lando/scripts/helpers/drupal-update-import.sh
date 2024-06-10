#!/usr/bin/env bash

# Runs composer install, database updates, config import etc.
# Called by `lando drupal-reinstall` and `lando drupal-reset` and post `lando pull`.
#
# ARGS/FLAGS:
# --config
#   string. The config to import ("all", "local" or "none").
# --users
#   boolean. Whether to create test users (true or false).

source /app/lando/scripts/helpers/color-vars.sh

# Set argument option defaults
CONFIG='all';
USERS=true;

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
    -u|--users|--users=*)
      echo '--'
      if [ "${1##--users=}" != "$1" ]; then
        USERS="${1##--users=}"
        shift
      else
        USERS=$2
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

if [ "$USERS" = true ]; then
  # Create test user accounts.
  /app/lando/scripts/drupal-create-users.sh
fi
