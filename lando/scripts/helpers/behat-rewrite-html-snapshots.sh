#!/usr/bin/env bash

# Modifies Behat HTML snapshots to point to Lando URL so CSS is loaded.
# Runs after `lando behat`, `lando behat-cli`, `lando behat-run-nostop-tests`, `lando behat-run-logged-tests`.

source /app/lando/scripts/helpers/vars.sh

DIR="/app/reports/behat/"
DIR_FAIL="/app/reports/behat/failed/"

shopt -s nullglob
for file in "$DIR"*.html; do
  if ! grep -q "<base href="$APP_URL">" "$file"; then
    sed -i "s/<base href='https:\/\/localhost:42080\/'>//" "$file"
    sed -i "/<!DOCTYPE html>/a <base href="$APP_URL">" "$file"
  fi
done

shopt -s nullglob
for file in "$DIR_FAIL"*.html; do
  if ! grep -q "<base href="$APP_URL">" "$file"; then
    sed -i "/<!DOCTYPE html>/a <base href="$APP_URL">" "$file"
  fi
done
