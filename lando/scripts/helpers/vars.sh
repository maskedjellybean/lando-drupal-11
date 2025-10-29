#!/usr/bin/env bash

# Variables for use in scripts.
# Usage example:
# source /app/lando/scripts/helpers/vars.sh
# echo -e "{ORANGE}Some text{NORMAL}"

# Get appserver URLs from $LANDO_INFO and set first URL as var unless we can find https one.
if command -v jq >/dev/null 2>&1; then
  APP_URLS=$(echo $LANDO_INFO | jq '.[] | select(.service == "appserver")' | jq -r '.urls' | jq -s '.[][]')
  APP_URL=$(echo $LANDO_INFO | jq '.[] | select(.service == "appserver")' | jq -r '.urls[0]')
  for URL in $APP_URLS; do
    if [[ $URL == *"https"* ]]; then
       APP_URL=$URL
       break
     fi
  done
fi

# Get database info from $LANDO_INFO and set as var.
if command -v jq >/dev/null 2>&1; then
  DB_NAME=$(echo $LANDO_INFO | jq '.[] | select(.service == "database")' | jq -r '.creds.database')
  DB_USER=$(echo $LANDO_INFO | jq '.[] | select(.service == "database")' | jq -r '.creds.user')
  DB_PW=$(echo $LANDO_INFO | jq '.[] | select(.service == "database")' | jq -r '.creds.password')
fi

# Set path to drush command.
DRUSH_CMD="/app/vendor/drush/drush/drush.php"

# Default Behat config.
BEHAT_CONFIG="/app/tests/behat/behat.yml"
# Behat Lando config.
# This will be created by copying behat.yml in behat-config-lando-copy.sh.
BEHAT_LANDO_CONFIG="/app/tests/behat/local.yml"

# Text color variables.
NORMAL="\033[0m"
RED="\033[31m"
RED_LABEL="red"
GREEN="\033[32m"
GREEN_LABEL="green"
YELLOW="\033[1;33m"
YELLOW_LABEL="yellow"
ORANGE="\033[33m"
ORANGE_LABEL="orange"
PINK="\033[35m"
PINK_LABEL="magenta"
BLUE="\033[34m"
BLUE_LABEL="blue"
CYAN="\033[36m"
CYAN_LABEL="cyan"
