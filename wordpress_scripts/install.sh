./inf-install.sh

cd mysql
./mysql-8.0.19-deps.sh
./mysql-8.0.19-install.sh
./mysql-8.0.19-init.sh
./mysql-8.0.19-start.sh &
cd ..

cd php
./php-7.4.4-deps.sh
./php-7.4.4-install.sh
./php-7.4.4-start.sh
cd ..

cd nginx
./nginx-1.17.9-deps.sh
./nginx-1.17.9-install.sh
./nginx-1.17.9-start.sh
cd ..

cd wordpress
./wordpress-install.sh
./wordpress-prepare-db.sh
./wordpress-deploy.sh
cd ..

./post-install.sh
