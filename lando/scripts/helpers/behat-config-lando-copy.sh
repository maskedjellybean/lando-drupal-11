#!/usr/bin/env bash

# Copies tests/behat/behat.yml to tests/behat/local.yml and modifies it to play nicely with Lando.
# Runs during `lando behat`, `lando behat-cli`, `lando behat-run-nostop-tests`, `lando behat-run-logged-tests` and `lando behat-search-steps`.

source /app/lando/scripts/helpers/vars.sh

# Copy behat.yml to local.yml.
cp -fr "$BEHAT_CONFIG" "$BEHAT_LANDO_CONFIG"

# Rewrite local.yml to play nicely with Lando.
# @todo Create new suite in behat.yml which mostly inherits from default suite
# but contains these overrides for Lando. Then do away with these sed commands.
sed -i "s/\/var\/www/\/app/" "$BEHAT_LANDO_CONFIG"
sed -i "s%base_url\: https\:\/\/web%base_url\: "$APP_URL"%"  "$BEHAT_LANDO_CONFIG"
# @todo Would changing the service name in .lando.yml to "chrome" allow us to not do this?
sed -i "s/wd_host\: http\:\/\/chrome:4444\/wd\/hub/wd_host\: http\:\/\/selenium-chrome:4444\/wd\/hub/"  "$BEHAT_LANDO_CONFIG"
sed -i '1s;^;# ---- TEMPORARILY COPIED FROM /app/tests/behat/behat.yml BY LANDO ----\n;' "$BEHAT_LANDO_CONFIG"
