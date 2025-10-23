#!/usr/bin/env bash

# Drops the database, runs composer install and drush site:install.
#
# Use via lando tooling:
# lando drupal-reinstall.

source /app/lando/scripts/helpers/vars.sh

echo -e "${RED}"
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
echo -e "${RED}You will lose ALL database content. 💣  💧  ⚠️"
source /app/lando/scripts/helpers/prompt-confirm.sh
if [[ $(prompt_confirm "Proceed?") = "no" ]]; then
  exit 1
fi

echo -e "${CYAN}Dropping database, running composer install, running drush site:install, config import, deploy hooks and clearing caches...${NORMAL}"

/app/lando/scripts/helpers/db-drop.sh

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
php -d memory_limit=-1 $DRUSH_CMD site:install -y --existing-config --account-pass=password

echo
echo -e "${CYAN}Running drush status...${NORMAL}"
echo
# There's really no reason to do this here, but for some reason it helps
# avoid this error: "The "" entity type does not exist".
$DRUSH_CMD status

echo
echo -e "${CYAN}Clearing caches...${NORMAL}"
echo
$DRUSH_CMD cr

echo
echo -e "${CYAN}Checking the Drupal installation...${NORMAL} 🩺 🔍"

if [[ $($DRUSH_CMD core:status --field='Drupal bootstrap') == *"Successful"* ]]; then
  echo
  echo -e "${GREEN}Drupal was successfully installed!${NORMAL} 💧 ✅"
  echo
else
  echo
  echo -e "${RED}Drupal install failed!${NORMAL} 😢 💧 ❌"
  echo
  exit 1
fi

/app/lando/scripts/helpers/drupal-update-import.sh --config all --users true
