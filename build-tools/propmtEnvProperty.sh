#!/bin/bash

# The environment variable to check
VAR_NAME="MY_ENV_VAR"

# Check if the environment variable is set
if [ -z "${!VAR_NAME}" ]; then
  echo "$VAR_NAME is not set."

  # Prompt the user to provide a value
  read -p "Please provide a value for $VAR_NAME: " user_input

  # Set the variable with the provided value
  export $VAR_NAME="$user_input"

  echo "$VAR_NAME is now set to: ${!VAR_NAME}"
else
  echo "$VAR_NAME is already set to: ${!VAR_NAME}"
fi
