#!/usr/bin/env bash

# Runs PHP_CodeSniffer.
#
# Use via lando tooling:
# lando php-cs

source /app/lando/scripts/helpers/color-vars.sh

ARGS="$@"

echo
echo -e "${CYAN}Running PHPCS... ${NORMAL}"
echo

# See: https://github.com/squizlabs/PHP_CodeSniffer/wiki/Usage
/app/vendor/bin/phpcs $ARGS
exitStatus=$?

if [ "$exitStatus" = 0 ]; then
  echo
  echo -e "${GREEN}PHP looks great!${NORMAL} 🍕🍕🍕"
  echo
elif [ "$exitStatus" = 1 ]; then
  echo
  echo -e "${RED}Some issues were found that can't be fixed automatically.${NORMAL} 😑"
  echo
elif [ "$exitStatus" = 2 ]; then
  echo
  source /app/lando/scripts/helpers/prompt-confirm.sh
  if [[ $(prompt_confirm "Some issues were found that can be fixed automatically. Want to try?") = "no" ]]; then
    exit 1
  fi

  echo
  echo -e "${CYAN}Running PHPCBF... ${NORMAL}"
  echo

  /app/vendor/bin/phpcbf
elif [ "$exitStatus" = 3 ]; then
  echo
  echo -e "${CYAN}Some kind of processing error has occurred (phpcs error code 3)..️${NORMAL} 🤷‍"
  echo
fi
