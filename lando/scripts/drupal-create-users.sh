#!/usr/bin/env bash

# Creates test Drupal user accounts.
#
# Use via Lando tooling:
# lando drupal-create-users.

source /app/lando/scripts/helpers/vars.sh

P=(👩🏻‍🚀 🧑🏿‍🚒 👩🏽‍🍳 👷🏾 👩🏼‍ 🦹🏽‍️ 🧑🏼‍🎨 👮🏾 👨🏻‍🎤 👨🏽‍🌾 👩🏼‍🔧 👩🏾‍🔬 🧑🏿‍🏫)

echo ""
echo -e "${CYAN}Creating test user accounts...${NORMAL} ${P[RANDOM%${#P[@]}]} ${P[RANDOM%${#P[@]}]} ${P[RANDOM%${#P[@]}]} ${P[RANDOM%${#P[@]}]}"
echo ""

# Check for existence of admin before creating to avoid throwing error.
ADMIN_STATUS=$(drush user:information admin 2>&1 | grep "Unable to find a matching user")
if [ ! -z "${ADMIN_STATUS}" ]; then
  drush ucrt admin --mail="test+admin@test.com" --password="thisisonlyatest";
fi
drush user:password admin "thisisonlyatest"; drush urol administrator admin; drush uublk admin;

# @todo Modify this as needed for your project.
#drush ucrt testsupport --mail="test+support@test.com" --password="thisisonlyatest"; drush user:password testsupport "thisisonlyatest"; drush urol support testsupport; drush uublk testsupport;

#drush ucrt testcentralsupport --mail="test+centralsupport@test.com" --password="thisisonlyatest"; drush user:password testcentralsupport "thisisonlyatest"; drush urol central_support testcentralsupport; drush uublk testcentralsupport;

#drush ucrt testcontributor --mail="test+contributor@test.com" --password="thisisonlyatest"; drush user:password testcontributor "thisisonlyatest"; drush urol contributor testcontributor; drush uublk testcontributor;

#drush ucrt testeventeditor --mail="test+eventeditor@test.com" --password="thisisonlyatest"; drush user:password testeventeditor "thisisonlyatest"; drush urol event_editor testeventeditor; drush uublk testeventeditor;

#drush ucrt testauthenticated --mail="test+authenticated@test.com" --password="thisisonlyatest"; drush user:password testauthenticated "thisisonlyatest"; drush uublk testauthenticated;

echo ""
echo -e "${GREEN}Created these users that have corresponding global roles:${NORMAL}"
echo ""
echo -e "${NORMAL}admin${NORMAL}"
#echo -e "${NORMAL}testsupport${NORMAL}"
#echo -e "${NORMAL}testcentralsupport${NORMAL}"
#echo -e "${NORMAL}testcontributor${NORMAL}"
#echo -e "${NORMAL}testeventeditor${NORMAL}"
#echo -e "${NORMAL}testauthenticated${NORMAL}"
echo ""
echo -e "${NORMAL}The password for each is 'thisisonlyatest'. Ssshhh.${NORMAL} 🤐"
echo ""
