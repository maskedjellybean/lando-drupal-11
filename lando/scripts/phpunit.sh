#!/usr/bin/env bash

# Runs phpunit CLI commands.
#
# Use via lando tooling:
# lando phpunit docroot/core/modules/media/tests/src/Functional/MediaOverviewPageTest.php

source /app/lando/scripts/helpers/vars.sh

ARGS="$@"

# Based on: https://www.drupal.org/docs/develop/automated-testing/phpunit-in-drupal/running-phpunit-tests#s-configure-phpunit

echo -e "${NORMAL}If test that extends WebDriverTestBase is unresponsive, try running:${NORMAL}"
echo -e "${NORMAL}docker container restart "$LANDO_APP_NAME"_selenium-chrome_1${NORMAL}"
echo

# Copy Drupal core phpunit config.
cp /app/docroot/core/phpunit.xml.dist /app/docroot/core/phpunit.xml

# Configure it for Lando.
sed -i "s/<env name=\"SIMPLETEST_BASE_URL\" value=\"\"\/>/<env name=\"SIMPLETEST_BASE_URL\" value=\"http:\/\/"$LANDO_APP_NAME"\.lndo\.site\"\/>/" /app/docroot/core/phpunit.xml
sed -i "s/<env name=\"SIMPLETEST_DB\" value=\"\"\/>/<env name=\"SIMPLETEST_DB\" value=\"mysql:\/\/"$DB_NAME":"$DB_USER"@database\/"$DB_PW"\"\/>/" /app/docroot/core/phpunit.xml
sed -i "s/<env name=\"BROWSERTEST_OUTPUT_BASE_URL\" value=\"\"\/>/<env name=\"BROWSERTEST_OUTPUT_BASE_URL\" value=\"http:\/\/"$LANDO_APP_NAME"\.lndo\.site\"\/>/" /app/docroot/core/phpunit.xml

# Support Drupal 11 where BROWSERTEST_OUTPUT_DIRECTORY does not exist in phpunit.xml.dist.
# Instead there is <parameter name="outputDirectory".
sed -i 's/sites\/simpletest\/browser_output/\/app\/docroot\/sites\/simpletest\/browser_output/' /app/docroot/core/phpunit.xml
# Support Drupal 10 where BROWSERTEST_OUTPUT_DIRECTORY exists in phpunit.xml.dist.
sed -i 's/<env name=\"BROWSERTEST_OUTPUT_DIRECTORY\" value=\"\"\/>/<env name=\"BROWSERTEST_OUTPUT_DIRECTORY\" value=\"\/app\/docroot\/sites\/simpletest\/browser_output\/\"\/>/' /app/docroot/core/phpunit.xml

sed -i 's/<env name=\"MINK_DRIVER_ARGS_WEBDRIVER\" value='\'''\''\/>/<env name=\"MINK_DRIVER_ARGS_WEBDRIVER\" value='\''\[\"chrome\", {\"browserName\":\"chrome\",\"goog:chromeOptions\":{\"w3c\":false, \"args\":\[\"--disable-gpu\",\"--headless\", \"--no-sandbox\", \"--disable-dev-shm-usage\"\]}}, \"http:\/\/selenium-chrome:4444\/wd\/hub\"\]'\''\/>/' /app/docroot/core/phpunit.xml

# Make output directory if it doesn't exist and set permissions.
mkdir -p /app/docroot/sites/simpletest
chmod -R 777 /app/docroot/sites/simpletest
mkdir -p /app/docroot/sites/simpletest/browser_output
chmod -R 777 /app/docroot/sites/simpletest/browser_output
# Delete previous results.
rm -f /app/docroot/sites/simpletest/browser_output/*.html
rm -f /app/docroot/sites/simpletest/browser_output/*.counter

# Run phpunit using Drupal core config.
/app/vendor/bin/phpunit -c /app/docroot/core $ARGS
