#!/usr/bin/env bash

# Runs phpunit CLI commands.
#
# Use via lando tooling:
# lando phpunit web/path/to/Test.php

source /app/lando/scripts/helpers/color-vars.sh

ARGS="$@"

# Based on: https://www.drupal.org/docs/develop/automated-testing/phpunit-in-drupal/running-phpunit-tests#s-configure-phpunit

# Copy Drupal core phpunit config.
cp /app/web/core/phpunit.xml.dist /app/web/core/phpunit.xml

# Configure it for Lando.
sed -i 's/<env name=\"SIMPLETEST_BASE_URL\" value=\"\"\/>/<env name=\"SIMPLETEST_BASE_URL\" value=\"http:\/\/drupal-11-dev\.lndo\.site\"\/>/' /app/web/core/phpunit.xml
sed -i 's/<env name=\"SIMPLETEST_DB\" value=\"\"\/>/<env name=\"SIMPLETEST_DB\" value=\"mysql:\/\/drupal:drupal@database\/drupal\"\/>/' /app/web/core/phpunit.xml
sed -i 's/<env name=\"BROWSERTEST_OUTPUT_BASE_URL\" value=\"\"\/>/<env name=\"BROWSERTEST_OUTPUT_BASE_URL\" value=\"http:\/\/drupal-11-dev\.lndo\.site\"\/>/' /app/web/core/phpunit.xml
sed -i 's/sites\/simpletest\/browser_output/\/app\/web\/sites\/simpletest\/browser_output/' /app/web/core/phpunit.xml

# Make output directory if it doesn't exist and set permissions.
mkdir -p /app/web/sites/simpletest
chmod -R 777 /app/web/sites/simpletest
mkdir -p /app/web/sites/simpletest/browser_output
chmod -R 777 /app/web/sites/simpletest/browser_output
# Delete previous results.
rm -f /app/web/sites/simpletest/browser_output/*.html
rm -f /app/web/sites/simpletest/browser_output/*.counter

# Run phpunit using Drupal core config.
/app/vendor/bin/phpunit -c /app/web/core $ARGS
