#!/usr/bin/env bash

NORMAL="\033[0m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[1;33m"
ORANGE="\033[33m"
PINK="\033[35m"
BLUE="\033[34m"
CYAN="\033[36m"

echo
echo -e "${CYAN}Running PHPCS... ${NORMAL}"
echo

# See: https://github.com/squizlabs/PHP_CodeSniffer/wiki/Usage
/app/vendor/bin/phpcs
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
  echo -e "${ORANGE}Some issues were found that can be fixed automatically. Want to try?"
  echo -e "${BLUE}(y/n): ${BLUE}"
  read REPLY
  if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    echo
    echo -e "${CYAN}Running PHPCBF... ${NORMAL}"
    echo

    /app/vendor/bin/phpcbf
  else
    exit 1
  fi
elif [ "$exitStatus" = 3 ]; then
  echo
  echo -e "${CYAN}Some kind of processing error has occurred (phpcs error code 3)..️${NORMAL} 🤷‍"
  echo
fi
