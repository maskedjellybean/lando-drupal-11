#!/usr/bin/env bash

# Enables/disables Xdebug and sets mode.
# See: https://github.com/lando/lando/issues/1668#issuecomment-772829423
#
# Use via lando tooling:
# lando xdebug.
#
# ARGS:
# "on", "off", or a valid Xdebug mode such as "debug". string.
#
# Usage example:
# lando xdebug on

source /app/lando/scripts/helpers/vars.sh

MODE='on'

#!/usr/bin/env bash
# Script to enable/disable Xdebug and set mode.
# See: https://github.com/lando/lando/issues/1668#issuecomment-772829423
if [ "$#" -ne 1 ]; then
  # Nothing was passed so toggle on/off.
  # Check if already on.
  if [[ $(php -v) = *Xdebug* ]]; then
    MODE="off"
  else
    MODE="on"
  fi
elif [ "$1" = "on" ]; then
  # 'on' was passed.
  # Check if already on.
  if [[ $(php -v) = *Xdebug* ]]; then
    echo
    echo -e "${GREEN}Xdebug is already ON.${NORMAL}"
    echo
    exit 0
  else
    MODE="on"
  fi
elif [ "$1" = "off" ]; then
  # 'off' was passed.
  MODE="off"
else
  # A mode was passed.
  # @todo validate mode.
  MODE="$1"
fi

if [ "$MODE" = "off" ]; then
  echo xdebug.mode = off > /usr/local/etc/php/conf.d/zzz-lando-xdebug.ini
  rm /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && pkill -o -USR2 php-fpm || /etc/init.d/apache2 reload
  php -v
  echo
  echo -e "${RED}Xdebug is OFF.${NORMAL}"
  echo

  source /app/lando/scripts/helpers/prompt-confirm.sh
  if [[ $(prompt_confirm "Do you want to (re)enable caching in local.settings.php?") = "no" ]]; then
    exit 1
  else
    sed -i "s/\$settings\['cache'\]\['bins'\]\['render'\] = 'cache.backend.null'; \/\/ Disabled/\/\/\$settings\['cache'\]\['bins'\]\['render'\] = 'cache.backend.null';/" /app/web/sites/default/settings.local.php
    sed -i "s/\$settings\['cache'\]\['bins'\]\['page'\] = 'cache.backend.null'; \/\/ Disabled/\/\/\$settings\['cache'\]\['bins'\]\['page'\] = 'cache.backend.null';/" /app/web/sites/default/settings.local.php
    sed -i "s/\$settings\['cache'\]\['bins'\]\['dynamic_page_cache'\] = 'cache.backend.null'; \/\/ Disabled/\/\/\$settings\['cache'\]\['bins'\]\['dynamic_page_cache'\] = 'cache.backend.null';/" /app/web/sites/default/settings.local.php

    echo -e "${GREEN}Caching enabled.${NORMAL}"
    echo
  fi
else
  if [ "$MODE" = "on" ]; then
    MODE="debug"
  fi
  echo xdebug.mode = "$MODE" > /usr/local/etc/php/conf.d/zzz-lando-xdebug.ini
  docker-php-ext-enable xdebug && pkill -o -USR2 php-fpm || /etc/init.d/apache2 reload
  php -v
  echo
  echo -e "${GREEN}Xdebug is ON in $MODE mode.${NORMAL} 🐞"
  echo
  echo -e "${NORMAL}To load in a different mode:${NORMAL}"
  echo
  echo -e "${NORMAL}lando xdebug <mode>${NORMAL}"
  echo
  echo -e "${NORMAL}Valid modes: https://xdebug.org/docs/all_settings#mode${NORMAL}"
  echo

  echo -e "${ORANGE}Do you want to disable caching in settings.local.php?"
  echo -e "${NORMAL}Disabling caching will make it more likely that breakpoints are triggered as expected."
  source /app/lando/scripts/helpers/prompt-confirm.sh
  if [[ $(prompt_confirm "Disable caching?") = "no" ]]; then
    exit 1
  else
    sed -i "s/\/\/\$settings\['cache'\]\['bins'\]\['render'\] = 'cache.backend.null';/\$settings\['cache'\]\['bins'\]\['render'\] = 'cache.backend.null'; \/\/ Disabled/" /app/web/sites/default/settings.local.php
    sed -i "s/\/\/\$settings\['cache'\]\['bins'\]\['page'\] = 'cache.backend.null';/\$settings\['cache'\]\['bins'\]\['page'\] = 'cache.backend.null'; \/\/ Disabled/" /app/web/sites/default/settings.local.php
    sed -i "s/\/\/\$settings\['cache'\]\['bins'\]\['dynamic_page_cache'\] = 'cache.backend.null';/\$settings\['cache'\]\['bins'\]\['dynamic_page_cache'\] = 'cache.backend.null'; \/\/ Disabled/" /app/web/sites/default/settings.local.php

    echo -e "${GREEN}Caching disabled.${NORMAL}"
    echo
  fi
fi
