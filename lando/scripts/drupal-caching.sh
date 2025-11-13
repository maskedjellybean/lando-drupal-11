#!/usr/bin/env bash

# Enables/disables Drupal caching by modifying local.settings.php.
#
# Use via lando tooling:
# lando drupal-caching.
#
# ARGS:
# "on", "off", or a specific cache such as "render on" or "render off". string.
#
# Usage example:
# lando drupal-caching on

source /app/lando/scripts/helpers/vars.sh

MODE='on'
# Two args were passed. We assume this is
# a combination of a mode and cache name
# such as "render on".
if [[ -n "$1" && -n "$2" ]]; then
  MODE="$1 $2"
elif [ "$#" -ne 1 ]; then
  # Nothing was passed so toggle on/off.
  # Check if already on.
  if grep -q "// Disabled by Lando" "$DRUPAL_LOCAL_SETTINGS"; then
    MODE="on"
  else
    MODE="off"
  fi
elif [ "$1" = "on" ]; then
  # 'on' was passed.
  MODE="on"
elif [ "$1" = "off" ]; then
  # 'off' was passed.
  MODE="off"
else
  MODE="error"
fi

echo

if [ "$MODE" = "off" ]; then
  sed -i "s/\/\/\$settings\['cache'\]\['bins'\]\['render'\] = 'cache.backend.null';/\$settings\['cache'\]\['bins'\]\['render'\] = 'cache.backend.null'; \/\/ Disabled by Lando/" "$DRUPAL_LOCAL_SETTINGS"
  sed -i "s/\/\/\$settings\['cache'\]\['bins'\]\['page'\] = 'cache.backend.null';/\$settings\['cache'\]\['bins'\]\['page'\] = 'cache.backend.null'; \/\/ Disabled by Lando/" "$DRUPAL_LOCAL_SETTINGS"
  sed -i "s/\/\/\$settings\['cache'\]\['bins'\]\['dynamic_page_cache'\] = 'cache.backend.null';/\$settings\['cache'\]\['bins'\]\['dynamic_page_cache'\] = 'cache.backend.null'; \/\/ Disabled by Lando/" "$DRUPAL_LOCAL_SETTINGS"
  echo -e "${CYAN}Caching disabled. 🔴${NORMAL}"
elif [ "$MODE" = "on" ]; then
  sed -i "s/\$settings\['cache'\]\['bins'\]\['render'\] = 'cache.backend.null'; \/\/ Disabled by Lando/\/\/\$settings\['cache'\]\['bins'\]\['render'\] = 'cache.backend.null';/" "$DRUPAL_LOCAL_SETTINGS"
  sed -i "s/\$settings\['cache'\]\['bins'\]\['page'\] = 'cache.backend.null'; \/\/ Disabled by Lando/\/\/\$settings\['cache'\]\['bins'\]\['page'\] = 'cache.backend.null';/" "$DRUPAL_LOCAL_SETTINGS"
  sed -i "s/\$settings\['cache'\]\['bins'\]\['dynamic_page_cache'\] = 'cache.backend.null'; \/\/ Disabled by Lando/\/\/\$settings\['cache'\]\['bins'\]\['dynamic_page_cache'\] = 'cache.backend.null';/" "$DRUPAL_LOCAL_SETTINGS"
  echo -e "${GREEN}Caching enabled. 🟢${NORMAL}"
elif [ "$MODE" = "render off" ]; then
  sed -i "s/\/\/\$settings\['cache'\]\['bins'\]\['render'\] = 'cache.backend.null';/\$settings\['cache'\]\['bins'\]\['render'\] = 'cache.backend.null'; \/\/ Disabled by Lando/" "$DRUPAL_LOCAL_SETTINGS"
  echo -e "${CYAN}Render cache disabled. 🔴${NORMAL}"
elif [ "$MODE" = "render on" ]; then
  sed -i "s/\$settings\['cache'\]\['bins'\]\['render'\] = 'cache.backend.null'; \/\/ Disabled by Lando/\/\/\$settings\['cache'\]\['bins'\]\['render'\] = 'cache.backend.null';/" "$DRUPAL_LOCAL_SETTINGS"
  echo -e "${GREEN}Render cache enabled. 🟢${NORMAL}"
elif [ "$MODE" = "page off" ]; then
  sed -i "s/\/\/\$settings\['cache'\]\['bins'\]\['page'\] = 'cache.backend.null';/\$settings\['cache'\]\['bins'\]\['page'\] = 'cache.backend.null'; \/\/ Disabled by Lando/" "$DRUPAL_LOCAL_SETTINGS"
  echo -e "${CYAN}Page cache disabled. 🔴${NORMAL}"
elif [ "$MODE" = "page on" ]; then
  sed -i "s/\$settings\['cache'\]\['bins'\]\['page'\] = 'cache.backend.null'; \/\/ Disabled by Lando/\/\/\$settings\['cache'\]\['bins'\]\['page'\] = 'cache.backend.null';/" "$DRUPAL_LOCAL_SETTINGS"
  echo -e "${GREEN}Page cache enabled. 🟢${NORMAL}"
elif [ "$MODE" = "dynamic_page_cache off" ]; then
  sed -i "s/\/\/\$settings\['cache'\]\['bins'\]\['dynamic_page_cache'\] = 'cache.backend.null';/\$settings\['cache'\]\['bins'\]\['dynamic_page_cache'\] = 'cache.backend.null'; \/\/ Disabled by Lando/" "$DRUPAL_LOCAL_SETTINGS"
  echo -e "${CYAN}Dynamic page cache disabled. 🔴${NORMAL}"
elif [ "$MODE" = "dynamic_page_cache on" ]; then
  sed -i "s/\$settings\['cache'\]\['bins'\]\['dynamic_page_cache'\] = 'cache.backend.null'; \/\/ Disabled by Lando/\/\/\$settings\['cache'\]\['bins'\]\['dynamic_page_cache'\] = 'cache.backend.null';/" "$DRUPAL_LOCAL_SETTINGS"
  echo -e "${GREEN}Dynamic page cache enabled. 🟢${NORMAL}"
else
  echo -e "${RED}Invalid argument. Valid args: on, off, render on, render off, page on, page off, dynamic_page_cache on, dynamic_page_cache off. ❌${NORMAL}"
fi

echo
