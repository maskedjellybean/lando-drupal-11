#!/usr/bin/env bash

# This script is configured in .lando.yml. Run: lando drupal-reset.
# It will run database updates, imports config and clear caches.

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

    ____                 __     ____                         __
   / __ \___  ________  / /_   / __ \_______  ______  ____ _/ /
  / /_/ / _ \/ ___/ _ \/ __/  / / / / ___/ / / / __ \/ __ `/ /
 / _, _/  __(__  )  __/ /_   / /_/ / /  / /_/ / /_/ / /_/ / /
/_/ |_|\___/____/\___/\__/  /_____/_/   \__,_/ .___/\__,_/_/
                                            /_/
EOF
echo -e "${NORMAL}"

echo -e "${ORANGE}Are you sure you want to run composer install, database updates, import config and clear caches?"
echo -e "${RED}You will lose all unexported config but other database content will remain. ⚠️"
echo -e "${BLUE}(y/n):${BLUE}"
read REPLY
if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
  exit 1
fi
echo -e "${NORMAL}"

/app/lando/scripts/helpers/drupal-update-import.sh --config all
