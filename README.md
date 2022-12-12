# 🐳 CREATE DOCKER SETUP LOCALLY
With this tool you can easily host a Website along with the following technologies for Web Development:
1. PHP:8.0
2. Composer:2
3. Git:2+
4. Vim, lsof
5. WP-CLI
6. NGINX:1.23.2
7. MySQL:8.0

---
# __⚠️ IMPORTANT__

If you are planning to use NPM or serve the site via Node. This setup does not contain it. Because we use Docker Container for this setup. The only solution is to have it in your local machine and use [__NVM__](https://github.com/nvm-sh/nvm) to easily switch Node + NPM Version.

---

# __📝 TODO__

1. Copy the setup in your __desktop__ _(or any location inside your machine)._
2. Make the commands  excutable by running:
```bash
chmod +x create_docker_setup.sh

chmod +x remove_docker_setup.sh

# If you are not running the command inside the project then kindly provide the necessary absolute path to target it properly.

#  With this commands we will allow our machine to make the two command executable.
```

---
# Their are two different scripts that you can use.

__1)__ ```create_docker_setup.sh``` - with this script we can create and populate the necessary files to be used in our setup
Simply running it by doing:
```./create_docker_setup.sh```

1.1 It will prompt to enter your desired site-name and timezone for setup and wait until a ```.lemp``` folder appeared and a ```docker-compose.yml``` file created.

1.2 In case both file exist kindly run the following command to build the necessary containers that as one will serve your application

``` docker-compose up --build ```

A detailed documentation can be found [here](https://app.clickup.com/6901085/docs/6jkax-2466) Titled: __Docker - Local Development Setup__

```bash
# In summary their are multiple docker comand that you can use now.

1. docker-compose up --build
# This will rebuild or build the images and container it may take a minute depending on your machine

2. docker-compose up -d
# Run this command if you already succesfully start the container before. Using the following command will run the docker-compose application in foreground. You can't analyze the each container running state with this command

3. docker-compose down --rmi=local -v
# Using this command will stop all the container on our setup and disconnect the network to the localmachine including the docker volumes which are the stored memory of each containers

# Whenever you start a project it is recommended to turn down any existing running setup because it will conflict on our host port available example: port 80 in web server. (nginx)

```



__2)__```remove_docker_setup.sh``` - You can run this command optionally if you are sure to remove the setup in the application.

__NOTE__

This will remove existing docker container that are running or idle. Use this with __cautions__ because any SQL Database import will be removed from MySQL Container

This will remove also the ```.lemp``` folder and the ```docker-compose.yml``` file.

---

Happy Coding 🙂

[JLBardinas](www.jlbardinas.com)

[JW]()