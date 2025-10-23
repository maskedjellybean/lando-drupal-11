#!/usr/bin/env bash

# Imports a database (.sql or .sql.gz) from local machine.
# It leverages the script provided by Lando core which is called by
# the default `lando db-import` command, but calling it ourselves gives us the
# ability to add a warning message and ask about Drupal config import.
#
# Use via lando tooling:
# lando db-import path/to/file.sql.gz
#
# ARGS:
# Path to SQL file. string.
#

source /app/lando/scripts/helpers/vars.sh

FILE_PATH="$@"

# First delete temp file which is used to pass
# data from this script to post-db-import.sh.
# We can't call post-db-import.sh here because
# we are currently on the host machine and post-db-import.sh
# needs to run inside appserver service/container.
# So instead we set a var in this file and read it
# in post-db-import.sh when it's ran on appserver as a post event.
rm -f lando/configs/tmp/post-db-import-var.sh

echo -e "${RED}"
cat << "EOF"
    ____                                __     ____   ____
   /  _/____ ___   ____   ____   _____ / /_   / __ \ / __ )
   / / / __ `__ \ / __ \ / __ \ / ___// __/  / / / // __  |
 _/ / / / / / / // /_/ // /_/ // /   / /_   / /_/ // /_/ /
/___//_/ /_/ /_// .___/ \____//_/    \__/  /_____//_____/
               /_/
EOF
echo -e "${NORMAL}"

echo -e "${ORANGE}Are you sure you want to import a .sql or .sql.gz file from your machine?"
echo -e "${RED}You will lose ALL content in your current database. 💣  💧  ⚠️"
source /app/lando/scripts/helpers/prompt-confirm.sh
if [[ $(prompt_confirm "Proceed?") = "no" ]]; then
  exit 1
fi

# Check that file exists.
if [ ! -e "$FILE_PATH" ]; then
  echo
  echo -e "${RED}Could not find file!${NORMAL} ❌"
  exit 1
fi

# Ask user about Drupal config import.
# @todo Replace with multi select function in prompt-confirm.sh
echo -e "${ORANGE}After importing a database there may be unimported config. How should we handle it?"
echo -e "${NORMAL}(Either way we will run composer install, database updates and clear caches)."
echo -e "${ORANGE}1. Import all config."
echo -e "${ORANGE}2. Import only the local config split."
echo -e "${ORANGE}3. Don't import config."
echo -e "${ORANGE}[[1]/2/3]${BLUE}"
read REPLY
if [[ "$REPLY" = 1 || "$REPLY" = "" ]]; then
  CONFIG='all'
  if [[ "$REPLY" = 1 ]]; then
    echo
  fi
  echo -e "${BLUE}We will import all config.${NORMAL}"
  echo
elif [[ "$REPLY" = 2 ]]; then
  CONFIG='local'
  echo
  echo -e "${BLUE}We will only import the local config split.${NORMAL}"
  echo
elif [[ "$REPLY" = 3 ]]; then
  CONFIG='none'
  echo
  echo -e "${BLUE}We won't import config.${NORMAL}"
  echo
fi

echo -e "${CYAN}Importing database...${NORMAL}"
echo

# Call import script provided by Lando core.
/helpers/sql-import.sh "$FILE_PATH"

if [[ $? != 0 ]]; then
  echo
  echo -e "${RED}Import failed!${NORMAL} ❌"
  exit 1
else
  # Save user config choice to be read in post event
  # when post-db-import.sh is called.
  mkdir -p lando/configs/tmp
  touch lando/configs/tmp/post-db-import-var.sh
  echo "CONFIG=$CONFIG" >> lando/configs/tmp/post-db-import-var.sh
fi
