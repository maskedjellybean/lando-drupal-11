#!/usr/bin/env bash

# Drops the database in a pretty way.

source /app/lando/scripts/helpers/vars.sh

echo
echo -e "${CYAN}Dropping database...${NORMAL} 🧨"
echo
# Destroy tables replicating the method found in Lando Acquia plugin `lando pull` command.
# See: https://github.com/lando/acquia/blob/ddb07952d23779eae0298f3ad00d1c05c14b4b1d/scripts/acquia-pull.sh#L130
# This is just for visual consistency. If it stops working uncomment the following line instead.
#php -d memory_limit=-1 $DRUSH_CMD sql-drop -y
if command -v jq >/dev/null 2>&1; then
  TABLES=$(mysql --user="$DB_USER" --password="$DB_PW" --database="$DB_NAME" --host=database --port=3306 -e 'SHOW TABLES' | awk '{ print $1}' | grep -v '^Tables' ) || true
  echo -n "    "
  echo -e "${GREEN}✔${NORMAL} Destroying all current tables in local database if needed... "
  for t in $TABLES; do
    echo -n "    "
    echo -e "${GREEN}✔${NORMAL} Dropping $t from local database..."
    mysql --user="$DB_USER" --password="$DB_PW" --database="$DB_NAME" --host=database --port=3306 <<-EOF
      SET FOREIGN_KEY_CHECKS=0;
      DROP VIEW IF EXISTS \`$t\`;
      DROP TABLE IF EXISTS \`$t\`;
EOF
  done
else
  php -d memory_limit=-1 $DRUSH_CMD sql-drop -y
fi
