#!/usr/bin/env bash

# Runs Behat CLI commands.
#
# Use via lando tooling:
# lando behat-cli features/Group-Admin-View.feature:40

source /app/lando/scripts/helpers/vars.sh

ARGS="$@"

echo -e "${NORMAL}You can run tagged scenarios/tests like this:"
echo -e "${NORMAL}lando behat --tags @events"
echo
echo -e "${NORMAL}Or you can run a single feature like this:"
echo -e "${NORMAL}lando behat Group-Admin-View.feature"
echo -e "${NORMAL}Or:"
echo -e "${NORMAL}lando behat features/Group-Admin-View.feature"
echo
echo -e "${NORMAL}Or you can run a single scenario/test like this:"
echo -e "${NORMAL}lando behat Group-Admin-View.feature:40"
echo
echo -e "${NORMAL}Behat CLI docs:${NORMAL}"
echo -e "${NORMAL}https://docs.behat.org/en/v2.5/guides/6.cli.html${NORMAL}"
echo
echo -e "${NORMAL}If scenario tagged @javascript is unresponsive, try running:${NORMAL}"
echo -e "${NORMAL}docker container restart "$LANDO_APP_NAME"_selenium-chrome_1${NORMAL}"
echo
echo -e "${CYAN}Running Behat...${NORMAL}"
echo

# Allow user to leave out "features/" when running
# a feature for expediency.
if [[ $ARGS == *".feature"* && $ARGS != *"/app/tests/behat/features/"* ]]; then
  ARGS=${ARGS/features\//""}
  ARGS="/app/tests/behat/features/$ARGS"
fi

/app/vendor/bin/behat $ARGS \
--config="$BEHAT_LANDO_CONFIG" \
--profile=local

# We need to set exit code back to 0 in case Behat has set it to
# something else on failure. This allows any other commands configured
# to run after this script in .lando.yml to run (either within the behat tooling
# command itself or as a post-behat event).
(exit 0)
