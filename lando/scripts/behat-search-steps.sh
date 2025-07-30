#!/usr/bin/env bash

# Searches Behat step definitions for search term(s).
#
# Use via lando tooling:
# lando behat-search-steps I visit.
#
# ARGS:
# search term(s). string.
#
# Usage example:
# lando behat-search-steps I visit

source /app/lando/scripts/helpers/color-vars.sh

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

# There is a built in Behat step definition search, but it only searches literal step definitions ("@when I do this").
# Our attempt searches the entire docblock and method name.
# Does not search variable names in docblock because for some reason those are excluded from `behat -di`.
# Grep 1: Searches for "default |" then searches for $ARGS but does not match if it finds "()`" before $ARGS. If $ARGS is found, matches until "()`".
# grep -i = case insensitive
# grep -P = Perl compatible
# grep -o = Print only matching
# grep -z = Treat input as set of lines
# Sed 1: Adds new lines before "default"
# Grep 2: Highlight "default |" to end of line (highlights the step definition)
/app/vendor/bin/behat --config /app/tests/behat/behat.yml -di --profile local --suite default | grep -oPzi "((?:default \|)(?:(?:.(?!\(\)\`)|\n)*?)(?:$ARGS)(?:(?:.|\n)*?)(?:\(\)\`))" | sed -r 's/default \|/\n\n&/' | GREP_COLOR='mt=033;33' grep -Ea --color=always '^default((.*?))|$'
# @todo Highlight search term while leaving entire step definition line highlighted a different color.
# sed "/^default((.*?))($ARGS)/ s//\`printf \"\033[32m$ARGS\033[0m\"\`/"

/app/lando/scripts/helpers/behat-prep.sh reset
