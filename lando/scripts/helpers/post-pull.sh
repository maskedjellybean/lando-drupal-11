#!/usr/bin/env bash

# Prompts user to run composer install, database updates and config import after pulling database from Acquia.
# Runs post `lando pull`.

source /app/lando/scripts/helpers/color-vars.sh


# First make sure lando pull worked.
if [[ $(drush core:status --field='Drupal bootstrap') == *"Successful"* ]]; then
  echo
  echo -e "${GREEN}Drupal database was found!${NORMAL} 💧 ✅"
  echo
else
  echo
  echo -e "${RED}Drupal database was not found! Pull failed!${NORMAL} 😢 💧"
  echo
  exit 1
fi

echo -e "${ORANGE}If you pulled the database from an Acquia environment there may be unimported config. How should we proceed?"
echo -e "${NORMAL}Either way we will run composer install, database updates, deploy hooks and clear caches."
echo -e "${BLUE}(1) Import all config."
echo -e "${BLUE}(2) Import only the local config split."
echo -e "${BLUE}(3) Don't import config."
echo -e "${BLUE}(1/2/3):${BLUE}"
read REPLY
if [[ "$REPLY" = 1 ]]; then
  echo
  echo -e "${CYAN}We will import all config.${NORMAL}"
  echo
  CONFIG='all'
elif [[ "$REPLY" = 2 ]]; then
  echo
  echo -e "${CYAN}We will only import the local config split.${NORMAL}"
  echo
  CONFIG='local'
elif [[ "$REPLY" = 3 ]]; then
  echo
  echo -e "${CYAN}We won't import config.${NORMAL}"
  echo
  CONFIG='none'
fi

/app/lando/scripts/helpers/drupal-update-import.sh --config "$CONFIG"

echo
echo -e "${CYAN}Or use this link to login:${NORMAL}"
echo
php -d memory_limit=-1 /app/vendor/drush/drush/drush uli
echo
