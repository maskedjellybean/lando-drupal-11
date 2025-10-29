#!/usr/bin/env bash

# Searches Drupal container service names for search term(s).
#
# Use via lando tooling:
# lando drupal-search-services node.
#
# ARGS:
# search term(s). string.
#
# Usage example:
# lando drupal-search-services node

source /app/lando/scripts/helpers/vars.sh

ARGS="$@"

if [ -z "$ARGS" ]; then
  echo
  echo -e "${RED}Missing search term parameter!${NORMAL} ❌"
  echo -e "${NORMAL}For example: lando drupal-search-services node${NORMAL}"
  echo
  exit 1
fi

echo
echo -e "${CYAN}Searching Drupal container service names for \"$ARGS\"...${NORMAL}"
echo

$DRUSH_CMD devel:services | grep --color -i "$ARGS"
