#!/bin/bash
# Created By: JLBardinas & John WIlson

OS="default"

case "$(uname -sr)" in

   Darwin*)
     echo 'Mac in used, Nice!!!'
     OS="mac"
     ;;

   Linux*Microsoft*)
     echo 'WSL in used'  # Windows Subsystem for Linux
     OS="wsl"
     ;;

   Linux*)
     echo 'Linux'
     OS="linux"
     ;;

   # Add here more strings to compare
   # See correspondence table at the bottom of this answer

   *)
     echo 'Invalid OS: It must be Mac or Linux'
     exit 1;
     ;;
esac


# Check if the docker-compose.yml file exists
COMPOSE_FILE='docker-compose.yml'
if [ -e "$COMPOSE_FILE" ] {

}

