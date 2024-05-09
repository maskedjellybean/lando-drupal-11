#!/usr/bin/env bash

NORMAL="\033[0m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[1;33m"
ORANGE="\033[33m"
PINK="\033[35m"
BLUE="\033[34m"
CYAN="\033[36m"

ARGS="$@"

if [ -z "$ARGS" ]; then
  echo
  echo -e "${RED}Missing search term parameter!${NORMAL} ❌"
  echo -e "${NORMAL}For example: lando behat-search-steps I visit${NORMAL}"
  echo
  exit 1
fi

echo
echo -e "${CYAN}Searching Behat step definitions for \"$ARGS\"...${NORMAL}"
echo

# Sed 1: Capture lines from line containing search term (case insensitive) to  "()`" (end of method name)
# Sed 2: Add new line before "default"
# Grep 1: Highlight "default" to end of line (highlights the step definition)
/app/vendor/bin/behat --config /app/tests/behat/behat.yml -di --profile local --suite default | sed -n -e "/$ARGS/I,/()\`/ p" | sed -r 's/default /\n&/' | GREP_COLOR='033;33' grep -E --color=always '^default((.*?))|$'
# @todo Highlight search term while leaving entire step definition line highlighted a different color.
# sed "/^default((.*?))($ARGS)/ s//\`printf \"\033[32m$ARGS\033[0m\"\`/"
