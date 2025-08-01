#!/usr/bin/env bash

# Runs phpunit CLI commands.
#
# Use via lando tooling:
# lando phpunit web/path/to/Test.php

source /app/lando/scripts/helpers/color-vars.sh

ARGS="$@"

# Based on: https://www.drupal.org/docs/develop/automated-testing/phpunit-in-drupal/running-phpunit-tests-in-lando

# Copy Drupal core phpunit config.
cp /app/web/core/phpunit.xml.dist /app/web/core/phpunit.xml

# Configure it for Lando.
sed -i 's/<env name=\"SIMPLETEST_BASE_URL\" value=\"\"\/>/<env name=\"SIMPLETEST_BASE_URL\" value=\"http:\/\/drupal-11-dev\.lndo\.site\"\/>/' /app/web/core/phpunit.xml
sed -i 's/<env name=\"SIMPLETEST_DB\" value=\"\"\/>/<env name=\"SIMPLETEST_DB\" value=\"mysql:\/\/drupal:drupal@database\/drupal\"\/>/' /app/web/core/phpunit.xml
sed -i 's/<env name=\"BROWSERTEST_OUTPUT_BASE_URL\" value=\"\"\/>/<env name=\"BROWSERTEST_OUTPUT_BASE_URL\" value=\"http:\/\/drupal-11-dev\.lndo\.site\"\/>/' /app/web/core/phpunit.xml

# Support Drupal 11 where BROWSERTEST_OUTPUT_DIRECTORY does not exist in phpunit.xml.dist.
# Instead there is <parameter name="outputDirectory".
sed -i 's/sites\/simpletest\/browser_output/\/app\/web\/sites\/simpletest\/browser_output/' /app/web/core/phpunit.xml
# Support Drupal 10 where BROWSERTEST_OUTPUT_DIRECTORY exists in phpunit.xml.dist.
sed -i 's/<env name=\"BROWSERTEST_OUTPUT_DIRECTORY\" value=\"\"\/>/<env name=\"BROWSERTEST_OUTPUT_DIRECTORY\" value=\"\/app\/web\/sites\/simpletest\/browser_output\/\"\/>/' /app/web/core/phpunit.xml

sed -i 's/<env name=\"MINK_DRIVER_ARGS_WEBDRIVER\" value='\'''\''\/>/<env name=\"MINK_DRIVER_ARGS_WEBDRIVER\" value='\''\[\"chrome\", {\"browserName\":\"chrome\",\"goog:chromeOptions\":{\"w3c\":false, \"args\":\[\"--disable-gpu\",\"--headless\", \"--no-sandbox\", \"--disable-dev-shm-usage\"\]}}, \"http:\/\/selenium-chrome:4444\/wd\/hub\"\]'\''\/>/' /app/web/core/phpunit.xml

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
