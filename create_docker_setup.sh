#!/bin/bash
# By: JLBardinas & John WIlson

# COLORS
RED="\033[31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
CYAN="\033[0;36m"
NC="\033[0m"

bold=$(tput bold)
normal=$(tput sgr0)

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
     echo 'Invalid OS: Must be Mac or Linux'
     exit 1;
     ;;
esac


function print_instruction() {
  # echo "So, ${bold}I'm bolded${normal} but I'm not bolded"
  echo "${bold}LEGENDS:"
  echo -e "${BLUE}text${NC} - ${bold}Informational"
  echo -e "${YELLOW}text${NC} - ${bold}Warning"
  echo -e "${GREEN}text${NC} - ${bold}Success"
  echo -e "${RED}text${NC} - ${bold}Error"
  echo -e "${CYAN}code${NC} - ${bold}Code Snippets"
}

function generate_docker_setup() {
  # Create a docker-compose.yml file and provide the necessary project name:
  # Output the network
  # Containers name
  # How to enter in container mode
  # Check node version to become 16
  # echo "testing"
  FOLDER_NAME="$(basename $PWD)"
  DEFAULT_SITE_NAME="localhost"
  DEFAULT_TIME_ZONE="Australia/Melbourne"

  # GET THE DESIRED PROJECT_NAME:
  # read -p "PROJECT NAME [${FOLDER_NAME}]:" PROJECT_NAME
  # PROJECT_NAME=${PROJECT_NAME:-${FOLDER_NAME}}
  print_instruction


  echo -e "${bold}SITE NAME${normal} (ex. halie) This will become ${BLUE}${bold}http://halie.local:${normal}"
  read SITE_NAME
  SITE_NAME=${SITE_NAME:-${DEFAULT_SITE_NAME}}

  echo -e "${bold}TIMEZONE${normal} ${BLUE}${bold}[Australia/Melbourne]${normal}":
  read TIME_ZONE
  TIME_ZONE=${TIME_ZONE:-${DEFAULT_TIME_ZONE}}

  echo "${SITE_NAME} - ${TIME_ZONE}"

# DB_HOST=
# DB=
# DB_USERNAME=
# DB_PASSWORD=


cat > docker-compose.yml <<EOF
version: '3'

networks:
  ${SITE_NAME}-network:

services:
  nginx:
    image: nginx:latest
    container_name: ${SITE_NAME}-nginx
    tty: true
    ports:
        - '80:80'
    volumes:
        - .lemp/nginx/default.conf:/etc/nginx/conf.d/default.conf
        - .lemp/nginx:/var/log/nginx
        - .:/var/www/html
    depends_on:
        - php
        - mysql
    networks:
        - ${SITE_NAME}-network

  mysql:
    image: mysql:8.0.30
    container_name: halie-template-mysql
    restart: unless-stopped
    tty: true
    ports:
      - '3306:3306'
    volumes:
      - .lemp/mysql:/var/lib/mysql
    environment:
      TZ: ${TIME_ZONE}
      MYSQL_DATABASE: ${SITE_NAME}_db
      MYSQL_ALLOW_EMPTY_PASSWORD: 'true'
    networks:
      - ${SITE_NAME}-network

  php:
    build:
        context: .lemp
        dockerfile: php.Dockerfile
    image: ${SITE_NAME}-php-img
    container_name: ${SITE_NAME}
    tty: true
    volumes:
        - .:/var/www/html
    ports:
        - '9000:9000'
    networks:
        - ${SITE_NAME}-network

EOF

echo -e "${GREEN}GENERATED => ${NC}docker-compose.yml"


# echo -e
mkdir -p .lemp/mysql
mkdir .lemp/nginx

# CREATING NGINX SETUP (default.conf)
cat > .lemp/nginx/default.conf <<EOF
server {
    listen 80;
    server_name ${SITE_NAME}.local;
    charset utf-8;
    root /var/www/html/web;
    index index.php;

    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    location ~* \.(blade\.php)$ {
        deny all;
    }

    location ~* composer\.(json|lock)$ {
        deny all;
    }

    location ~* package(-lock)?\.json$ {
        deny all;
    }

    location ~* yarn\.lock$ {
        deny all;
    }

    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass php:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;
    }
}

EOF

echo -e "${GREEN}GENERATED => ${NC}.lemp/nginx/default.conf"


# CREATING php.Dockerfile for PHP Container
cat > .lemp/php.Dockerfile <<EOF
FROM php:8.0.25-fpm

WORKDIR /var/www/html

# Copy the Host PHP.ini to the container PHP.ini path
COPY php.ini /usr/local/etc/php/conf.d/php.ini
COPY php.ini /usr/local/etc/php/php.ini

# Install the mysqli extension
RUN docker-php-ext-install mysqli

# Install vim software for editing file inside the container.
RUN apt-get update && apt -y install vim

# Install lsof
RUN apt-get update && apt-get install lsof

# Install the proper composer version2 here
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Installing zip extension
RUN apt-get update && apt-get install zip unzip

# Installing git
RUN apt-get update && apt-get -y install git

# Instaling wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN php wp-cli.phar --info
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

RUN echo "PHP8.0 + Composer2 + Git2 container is now alive!!!"

EOF

# Altering php.ini inside PHP Container
cat > .lemp/php.ini <<EOF
date.timezone="${TIME_ZONE}"

# PHP INI Settings
memory_limit=-1
max_execution_time=60
upload_max_filesize=60M
post_max_size=32M

EOF

echo -e "${GREEN}GENERATED => ${NC}.lemp/php.Dockerfile"
echo -e "${BLUE} PHP Container Included Program: ${NC} \n 1. PHP:8.0 \n 2. Composer:2 \n 3. Git2 \n 4. Vim, lsof \n 5. WP-CLI"
echo -e "${BLUE} USAGE: \n ${NC}To enter the container and use the following programs \n Use the command:\n ${CYAN}${bold}'docker container exec -it ${SITE_NAME} bash' \n ${BLUE}This will enter the container environment 🙂. \n ${normal}To verify just type ${CYAN}${bold} PWD ${normal} command and it will return \n ${CYAN} /var/www/html ${NC}"


echo -e "${BLUE} Testing the docker-compose.yml file"
docker-compose -f docker-compose.yml config
echo -e "${NC}docker-compose.yml file is: ${GREEN}${bold}OK!! "

echo -e "${BLUE} To remove the setup kindly run ${bold}${CYAN} remove_docker_setup.sh"
echo -e "${BLUE} The setup required you to have a ${RED}NODE${NC} from your machine. \n Use NVM to switch in different version!!!.  ${CYAN}'https://github.com/nvm-sh/nvm\ ${CYAN} NVM'  "

}

# Check if the docker-compose.yml file exists
COMPOSE_FILE="docker-compose.yml"
LEMP_FOLDER="./lemp"
if [ -e "$COMPOSE_FILE" ]
then
  echo -e "${YELLOW}Message:${NC} docker-compose file already exists."
  exit 1
  # Check if the lemp folder exists
elif [ -d "LEMP_FOLDER" ]
then
  echo -e "${YELLOW}Message:${NC} .lemp folder exists."
  exit 1
else
  generate_docker_setup
fi