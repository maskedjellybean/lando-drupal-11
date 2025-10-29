#!/usr/bin/env bash

# Prompts user for confirmation.
#
# Example usage:
# source /app/lando/scripts/helpers/prompt-confirm.sh
# if [[ $(prompt_confirm "Proceed?") = "yes" ]]; then
#  echo "Selected yes"
# fi

source /app/lando/scripts/helpers/vars.sh

prompt_confirm() {
  read -r -p "$(echo -e $ORANGE)${1:-Are you sure?} [[Y]/n] $(echo -e $BLUE)" response
  echo -e "${NORMAL}" > $(tty)
  if [[ $response =~ [yY](es)* ]]; then
    echo "Yes"
  elif [[ $response = '' ]]; then
    echo -e "${BLUE}Yes${NORMAL}" >&2
    echo >&2
    echo "Yes"
  else
    echo "No"
  fi
}
