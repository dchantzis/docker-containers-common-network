Docker Tertiary

Docker set-up to contain all the databases under one network

the database service: maindb
the namework name: mainnet













Useful docker-compose commands:

docker-compose build

docker-compose up

docker-compose up -d
docker-compose up --force-recreate -d

# Pass environmental parameters in the container:
APP_ENV=production docker-compose up -d

# Spin containers down
docker-compose down

# SSH in the container
docker-compose exec app bash

# Execute commands inside the container
docker-compose exec app bash -c 'cd /var/www/html && touch a.txt && echo "doobs!" >> a.txt'

docker images
docker image rm <ID>

docker container ls
docker container rm <ID>

docker network ls
docker network rm <ID>


#check if xdebug is on:
```
./ot.sh exec app php --info | grep remote_enable
```
# or
```
docker-compose exec app php --info | grep remote_enable
```

#Check if xdebug inside the "app" container is using the correct local machine Host IP:
```
docker-compose exec app cat /etc/php/7.4/mods-available/xdebug.ini
```
# or
```
./ot.sh exec app cat /etc/php/7.4/mods-available/xdebug.ini
```
# or
```
./ot.sh exec app php --info | grep remote_host
```

# Check what has been defined in the docker-compose.yml when it was created:
```
docker-compose config
```


#random commands for inside the container
#service php7.4-fpm restart
#service nginx reload


#PURGE EVERYTHING DOCKER:
docker container stop $(docker container ls -a -q) && docker system prune -a -f --volumes