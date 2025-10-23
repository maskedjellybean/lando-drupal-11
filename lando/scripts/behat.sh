#!/usr/bin/env bash

# Runs Behat CLI commands.
#
# Use via lando tooling:
# lando behat features/Group-Admin-View.feature:40

source /app/lando/scripts/helpers/vars.sh

ARGS="$@"

echo -e "${NORMAL}Note you can run tagged scenarios/tests like this:${NORMAL}"
echo -e "${NORMAL}lando behat --tags @events${NORMAL}"
echo
echo -e "${NORMAL}Or you can run a single feature like this:${NORMAL}"
echo -e "${NORMAL}lando behat Group-Admin-View.feature${NORMAL}"
echo -e "${NORMAL}Or:${NORMAL}"
echo -e "${NORMAL}lando behat features/Group-Admin-View.feature${NORMAL}"
echo
echo -e "${NORMAL}Or you can run a single scenario/test like this:${NORMAL}"
echo -e "${NORMAL}lando behat Group-Admin-View.feature:40${NORMAL}"
echo
echo -e "${NORMAL}Behat CLI docs:${NORMAL}"
echo -e "${NORMAL}https://docs.behat.org/en/v2.5/guides/6.cli.html${NORMAL}"
echo
echo -e "${NORMAL}If scenario tagged @javascript is unresponsive, try running:${NORMAL}"
echo -e "${NORMAL}docker container restart drupal-11-dev_selenium-chrome_1${NORMAL}"
echo
echo -e "${CYAN}Running Behat...${NORMAL}"
echo

# Temporarily rewrite behat.yml to play nicely with Lando.
/app/lando/scripts/helpers/behat-prep.sh

# Allow user to leave out "features/" when running
# a feature for expediency.
if [[ $ARGS == *".feature"* && $ARGS != *"features/"* ]]; then
  ARGS="features/$ARGS"
fi

/app/vendor/bin/behat --config /app/tests/behat/behat.yml $ARGS --profile local --suite default

/app/lando/scripts/helpers/behat-prep.sh reset
