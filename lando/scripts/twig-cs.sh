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
echo -e "${CYAN}Running Twig CS Fixer... ${NORMAL}"
echo

# See: https://github.com/VincentLanglet/Twig-CS-Fixer
/app/vendor/bin/twig-cs-fixer lint /app/web/themes/custom /app/web/modules/custom
exitStatus=$?

if [ "$exitStatus" = 0 ]; then
  echo
  echo -e "${GREEN}Twig looks great!${NORMAL} 🎋🎋🎋🍕🍕🍕"
  echo
elif [ "$exitStatus" = 1 ]; then
  echo
  echo -e "${ORANGE}Some issues were found. Should we try to fix them automatically?"
  echo -e "${BLUE}(y/n): ${BLUE}"
  read REPLY
  if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    echo
    echo -e "${CYAN}Running Twig CS Fixer... ${NORMAL}"
    echo

    /app/vendor/bin/twig-cs-fixer lint --fix /app/web/themes/custom /app/web/modules/custom
  else
    exit 1
  fi
fi
