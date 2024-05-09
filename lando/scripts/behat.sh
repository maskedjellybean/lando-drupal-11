#!/usr/bin/env bash

NORMAL="\033[0m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[1;33m"
ORANGE="\033[33m"
PINK="\033[35m"
BLUE="\033[34m"
CYAN="\033[36m"

ARGS="$@"

echo -e "${NORMAL}Note you can run tagged scenarios/tests like this:${NORMAL}"
echo -e "${NORMAL}lando behat --tags @events${NORMAL}"
echo
echo -e "${NORMAL}Or you can run a single feature like this:${NORMAL}"
echo -e "${NORMAL}lando behat features/Group-Admin-View.feature${NORMAL}"
echo
echo -e "${NORMAL}Or you can run a single scenario/test like this:${NORMAL}"
echo -e "${NORMAL}lando behat features/Group-Admin-View.feature:40${NORMAL}"
echo
echo -e "${NORMAL}Behat CLI docs:${NORMAL}"
echo -e "${NORMAL}https://docs.behat.org/en/v2.5/guides/6.cli.html${NORMAL}"
echo
echo -e "${NORMAL}If scenario tagged @javascript is unresponsive, try running:${NORMAL}"
echo -e "${NORMAL}docker container restart drupal-11-dev_selenium-chrome_1${NORMAL}"
echo
echo -e "${CYAN}Running Behat...${NORMAL}"
echo

/app/vendor/bin/behat --config /app/tests/behat/behat.yml $ARGS --profile local --suite default
