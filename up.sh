#/bin/sh

sudo rm -rf htdocs

CONTAINER_ID=$(docker ps -a -q --filter="name=portfolio")

if [ $CONTAINER_ID ]
  then
    echo "Deleting container..."
    docker stop $CONTAINER_ID
    docker rm portfolio
fi

docker build -t chmez/portfolio:latest .
docker run --net=host -d -i -t --name portfolio chmez/portfolio:latest

docker exec -it portfolio service apache2 start
docker exec -it portfolio service mysql start

docker exec -it portfolio chown -R www-data:www-data sites/default
docker exec -it portfolio drush si portfolio --db-url=mysql://root:root@localhost:3306/alexgor_portfoli --account-name=alexgor_portfoli --account-pass=394zqcdq --account-mail=chmez070@gmail.com --locale=uk --site-name=Portfolio --site-mail=chmez070@gmail.com -y

docker exec -it portfolio chown -R www-data:www-data sites/default
docker exec -it portfolio drush cr