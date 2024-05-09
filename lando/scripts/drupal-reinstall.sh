#!/usr/bin/env bash

# This script is configured in .lando.yml. Run: lando drupal-reinstall.
# It will drop the database, run composer install and run drush site:install.

NORMAL="\033[0m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[1;33m"
ORANGE="\033[33m"
PINK="\033[35m"
BLUE="\033[34m"
CYAN="\033[36m"

echo -e "${CYAN}"
cat << "EOF"

    ____       _            __        ____   ____                         __
   / __ \___  (_)___  _____/ /_____ _/ / /  / __ \_______  ______  ____ _/ /
  / /_/ / _ \/ / __ \/ ___/ __/ __ `/ / /  / / / / ___/ / / / __ \/ __ `/ /
 / _, _/  __/ / / / (__  ) /_/ /_/ / / /  / /_/ / /  / /_/ / /_/ / /_/ / /
/_/ |_|\___/_/_/ /_/____/\__/\__,_/_/_/  /_____/_/   \__,_/ .___/\__,_/_/
                                                         /_/
EOF
echo -e "${NORMAL}"

echo -e "${ORANGE}Are you sure you want to drop the database, run composer install and (re)install the site?"
echo -e "${RED}You will lose all unexported config and ALL database content. ⚠️ 💣"
echo -e "${BLUE}(y/n):${BLUE}"
read REPLY
if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
  exit 1
fi
echo -e "${NORMAL}"

echo
echo -e "${CYAN}Dropping database, running composer install, running drush site:install, config import and clearing caches...${NORMAL}"
echo

echo
echo -e "${CYAN}Dropping database...${NORMAL} 🧨"
echo
php -d memory_limit=-1 /app/vendor/drush/drush/drush sql-drop -y

echo
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
echo -e "${CYAN}Running drush site:install. This will take a while...${NORMAL} ⏱"
echo
php -d memory_limit=-1 /app/vendor/drush/drush/drush site:install -y --existing-config --account-pass=password

if [[ $(drush core:status --field='Drupal bootstrap') == *"Successful"* ]]; then
  echo
  echo -e "${GREEN}Drupal was successfully installed!${NORMAL} 💧 ✅"
  echo
else
  echo
  echo -e "${RED}Drupal install failed!${NORMAL} 😢 💧 ❌"
  echo
  exit 1
fi

/app/lando/scripts/helpers/drupal-update-import.sh --config all

echo
echo -e "${CYAN}Or use this link to login:${NORMAL}"
echo
php -d memory_limit=-1 /app/vendor/drush/drush/drush uli
echo
