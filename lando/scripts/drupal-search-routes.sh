#!/usr/bin/env bash

# Searches Drupal route names for search term(s).
#
# Use via lando tooling:
# lando drupal-search-routes node.
#
# ARGS:
# search term(s). string.
#
# Usage example:
# lando drupal-search-routes node

source /app/lando/scripts/helpers/vars.sh

ARGS="$@"

if [ -z "$ARGS" ]; then
  echo
  echo -e "${RED}Missing search term parameter!${NORMAL} ❌"
  echo -e "${NORMAL}For example: lando drupal-search-routes node${NORMAL}"
  echo
  exit 1
fi

echo
echo -e "${CYAN}Searching Drupal route names for \"$ARGS\"...${NORMAL}"
echo

$DRUSH_CMD route | grep --color -i "$ARGS"
