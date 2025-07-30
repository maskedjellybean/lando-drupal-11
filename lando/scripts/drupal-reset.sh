#!/usr/bin/env bash

# Runs composer install, database updates, imports config and clears caches.
#
# Use via lando tooling:
# lando drupal-reset.

source /app/lando/scripts/helpers/color-vars.sh

echo -e "${ORANGE}"
cat << "EOF"
    ____                 __     ____                         __
   / __ \___  ________  / /_   / __ \_______  ______  ____ _/ /
  / /_/ / _ \/ ___/ _ \/ __/  / / / / ___/ / / / __ \/ __ `/ /
 / _, _/  __(__  )  __/ /_   / /_/ / /  / /_/ / /_/ / /_/ / /
/_/ |_|\___/____/\___/\__/  /_____/_/   \__,_/ .___/\__,_/_/
                                            /_/
EOF
echo -e "${NORMAL}"

echo -e "${ORANGE}Are you sure you want to run composer install, database updates, config import, post deploy hooks and clear caches?"
echo -e "${RED}You will lose all unexported config but other database content will remain. ⚠️"
source /app/lando/scripts/helpers/prompt-confirm.sh
if [[ $(prompt_confirm "Proceed?") = "no" ]]; then
  exit 1
fi

/app/lando/scripts/helpers/drupal-update-import.sh --config all --users false
