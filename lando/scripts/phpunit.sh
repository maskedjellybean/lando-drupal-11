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
sed -i 's/<env name=\"SIMPLETEST_DB\" value=\"\"\/>/<env name=\"SIMPLETEST_DB\" value=\"mysql:\/\/acquia:acquia@database\/acquia\"\/>/' /app/web/core/phpunit.xml
sed -i 's/<env name=\"BROWSERTEST_OUTPUT_DIRECTORY\" value=\"\"\/>/<env name=\"BROWSERTEST_OUTPUT_DIRECTORY\" value=\"\/app\/reports\/phpunit\/\"\/>/' /app/web/core/phpunit.xml
mkdir -p /app/reports/phpunit
sed -i 's/<env name=\"BROWSERTEST_OUTPUT_BASE_URL\" value=\"\"\/>/<env name=\"BROWSERTEST_OUTPUT_BASE_URL\" value=\"http:\/\/drupal-11-dev\.lndo\.site\"\/>/' /app/web/core/phpunit.xml

# Delete previous results.
rm -f /app/web/sites/simpletest/browser_output/*.html
rm -f /app/web/sites/simpletest/browser_output/*.counter

# Run phpunit using Drupal core config.
/app/vendor/bin/phpunit -c /app/web/core $ARGS
