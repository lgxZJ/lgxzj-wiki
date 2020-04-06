./php-7.4.4-deps.sh

rm -rf /lgxzj-install/php
mkdir /lgxzj-install/php

rm -rf lgxzj-php
mkdir lgxzj-php
cd lgxzj-php
wget https://www.php.net/distributions/php-7.4.4.tar.gz
tar -zxvf php-7.4.4.tar.gz
cd php-7.4.4
./configure --prefix=/lgxzj-install/php --with-fpm-user=lgxzj-php --with-fpm-group=lgxzj-php
make
