#!/usr/bin/env bash

# Prompts user to run composer install, database updates and config import after importing a database.
# Runs post `lando pull-db` and `lando db-import`.

source /app/lando/scripts/helpers/vars.sh

# If this file does not exist then lando pull-db or lando db-import failed.
if [ -f "/app/lando/configs/tmp/post-db-import-var.sh" ]; then
  # Get $CONFIG var.
  source /app/lando/configs/tmp/post-db-import-var.sh

  echo
  echo -e "${CYAN}Checking for database...${NORMAL}"
  echo

  # Check for Drupal database to be 100% sure.
  if [[ $($DRUSH_CMD core:status --field='Drupal bootstrap' 2>&1) == *"Successful"* ]]; then
    echo -e "${GREEN}Drupal database was found!${NORMAL} 💧 ✅"
    echo
  else
    echo -e "${RED}Drupal database was not found!${NORMAL} 😢 💧 ❌"
    echo
    exit 1
  fi

  /app/lando/scripts/helpers/drupal-update-import.sh --config "$CONFIG" --users true
fi
