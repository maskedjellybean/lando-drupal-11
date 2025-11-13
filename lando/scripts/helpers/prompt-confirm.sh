#!/usr/bin/env bash

# Prompts user for confirmation.
#
# Args:
# 1. String. The question to ask. Defaults to "Are you sure?".
# 2. String. If "false", "Yes" or "No" won't be echoed to the user.
#    This allows you to give more descriptive feedback.
#
# Return:
# "yes" if user responded affirmative.
# "no" if user responded negative.
#
# Example usage #1:
# source /app/lando/scripts/helpers/prompt-confirm.sh
# if [[ $(prompt_confirm "Proceed?") = "no" ]]; then
#  exit 1
# fi
#
# Example usage #2:
# source /app/lando/scripts/helpers/prompt-confirm.sh
# if [[ $(prompt_confirm "Proceed?" "false") = "yes" ]]; then
#  echo "Proceeding with thing"
# fi

source /app/lando/scripts/helpers/vars.sh

prompt_confirm() {
  read -r -p "$(echo -e $ORANGE)${1:-Are you sure?} [[Y]/n] $(echo -e $BLUE)" response
  echo -e "${NORMAL}" > $(tty)

  # If second argument is "false", don't echo "Yes" or "No".
  if [[ -n "$1" ]] && [[ -n "$2" ]] && [[ "$2" == "false" ]]; then
    print_response="false"
  else
    print_response="true"
  fi

  if [[ $response =~ [yY](es)* ]]; then
    if [ "$print_response" == "true" ]; then
      echo -e "${BLUE}Yes${NORMAL}" >&2
      echo >&2
    fi
    echo "yes"
  elif [[ -z $response ]]; then
    if [ "$print_response" == "true" ]; then
      echo -e "${BLUE}Yes${NORMAL}" >&2
      echo >&2
    fi
    echo "yes"
  else
    if [ "$print_response" == "true" ]; then
      echo -e "${BLUE}No${NORMAL}" >&2
      echo >&2
    fi
    echo "no"
  fi
}
