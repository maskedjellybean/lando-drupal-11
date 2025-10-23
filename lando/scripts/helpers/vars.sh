#!/usr/bin/env bash

# Variables for use in scripts.
# Usage example:
# source /app/lando/scripts/helpers/vars.sh
# echo -e "{ORANGE}Some text{NORMAL}"

DRUSH_CMD="/app/vendor/drush/drush/drush.php"

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
