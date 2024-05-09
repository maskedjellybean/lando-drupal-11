#!/usr/bin/env bash

# This file is configured in .lando.yml. Run: lando create-users.
# It will create test user accounts.

NORMAL="\033[0m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[1;33m"
ORANGE="\033[33m"
PINK="\033[35m"
BLUE="\033[34m"
CYAN="\033[36m"

P=(👩🏻‍🚀 🧑🏿‍🚒 👩🏽‍🍳 👷🏾 👩🏼‍ 🦹🏽‍️ 🧑🏼‍🎨 👮🏾 👨🏻‍🎤 👨🏽‍🌾 👩🏼‍🔧 👩🏾‍🔬 🧑🏿‍🏫)

echo ""
echo -e "${CYAN}Creating test user accounts...${NORMAL} ${P[RANDOM%${#P[@]}]} ${P[RANDOM%${#P[@]}]} ${P[RANDOM%${#P[@]}]} ${P[RANDOM%${#P[@]}]}"
echo ""

drush ucrt admin --mail="test+admin@test.com" --password="thisisonlyatest"; drush user:password admin "thisisonlyatest"; drush urol administrator admin; drush uublk admin;

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
