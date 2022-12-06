#!/bin/bash

# This will remove the create_docker_setup files and folder provided by the setup
# By: JLBardinas

# CASE STATEMENT
read -p "Are you sure to remove the Docker Setup? [Y/N]" ANSWER
case "$ANSWER" in
    [yY] | [yY][eE][sS])
        rm docker-compose.yml
        echo "Removed docker-compose.yml file"

        rm -rf .lemp
        echo "Removed .lemp folder"
        ;;
    [nN] | [nN][oO])
        echo "Exiting the Docker Setup."
        ;;
    *)
    # default
        echo "Please enter y/yes or n/no"
        ;;
esac