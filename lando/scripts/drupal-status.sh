#!/usr/bin/env bash

# This file is configured in .lando.yml. Run: lando drupal-status.

source /app/lando/scripts/helpers/color-vars.sh

echo
echo -e "${CYAN}Checking the health/status of Drupal...${NORMAL} 🩺 🔍"
echo

if [[ $(drush core:status --field='Drupal bootstrap') == *"Successful"* ]]; then
  echo -e "${GREEN}Drupal database was found!${NORMAL} 💧 ✅"
  echo
else
  echo -e "${RED}Drupal database was not found!${NORMAL} 😢 💧 ❌"
  echo
  exit 1
fi

echo -e "${CYAN}Running drush status so you know what's up...${NORMAL} 📊"
echo
php -d memory_limit=-1 /app/vendor/drush/drush/drush status
echo
echo -e "${CYAN}Running drush config:status so you know if all config is imported...${NORMAL} 📊"
echo
STATUS=$(php -d memory_limit=-1 /app/vendor/drush/drush/drush cst)
echo
if [[ STATUS = *Different* ]]; then
  echo -e "${RED}There is some stuck/overridden config. You may need to export and commit these to unstuck them.${NORMAL} ⚠️️"
  echo
else
  echo -e "${GREEN}All config is imported!${NORMAL} 🔧 ✅"
  echo
fi

echo -e "${CYAN}Running composer audit to check for security vulnerabilities...${NORMAL} 🩺 🔍 🛡️"
echo
composer audit
