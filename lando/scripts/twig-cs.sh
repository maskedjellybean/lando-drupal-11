#!/usr/bin/env bash

# Runs Twig-CS-Fixer.
#
# Use via lando tooling:
# lando twig-cs

source /app/lando/scripts/helpers/vars.sh

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
  source /app/lando/scripts/helpers/prompt-confirm.sh
  if [[ $(prompt_confirm "Some issues were found. Should we try to fix them automatically?") = "no" ]]; then
    exit 1
  fi

  echo
  echo -e "${CYAN}Running Twig CS Fixer... ${NORMAL}"
  echo

  /app/vendor/bin/twig-cs-fixer lint --fix /app/web/themes/custom /app/web/modules/custom
fi
