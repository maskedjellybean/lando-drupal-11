#!/usr/bin/env bash

# Prompts user to run composer install, database updates and config import after importing a database.
# Runs post `lando pull` and `lando db-import`.
# Runs during `lando pull-db-X`.

source /app/lando/scripts/helpers/color-vars.sh

echo
echo -e "${CYAN}Checking for database...${NORMAL}"
echo

# First make sure lando pull or db-import worked.
if [[ $(drush core:status --field='Drupal bootstrap' 2>&1) == *"Successful"* ]]; then
  echo -e "${GREEN}Drupal database was found!${NORMAL} 💧 ✅"
  echo
else
  echo -e "${RED}Drupal database was not found!${NORMAL} 😢 💧 ❌"
  echo
  exit 1
fi

# @todo Replace with multi select function in prompt-confirm.sh
echo -e "${ORANGE}There may be unimported config. How should we proceed?"
echo -e "${NORMAL}(Either way we will run composer install, database updates and clear caches)."
echo -e "${ORANGE}1. Import all config."
echo -e "${ORANGE}2. Import only the local config split."
echo -e "${ORANGE}3. Don't import config."
echo -e "${ORANGE}[1/2/3]${BLUE}"
read REPLY
if [[ "$REPLY" = 1 ]]; then
  CONFIG='all'
  echo
  echo -e "${CYAN}We will import all config.${NORMAL}"
  echo
elif [[ "$REPLY" = 2 ]]; then
  CONFIG='local'
  echo
  echo -e "${CYAN}We will only import the local config split.${NORMAL}"
  echo
elif [[ "$REPLY" = 3 ]]; then
  CONFIG='none'
  echo
  echo -e "${CYAN}We won't import config.${NORMAL}"
  echo
else
  CONFIG='all'
  echo
  echo -e "${CYAN}We will import all config.${NORMAL}"
  echo
fi

/app/lando/scripts/helpers/drupal-update-import.sh --config "$CONFIG" --users true
