./php-7.4.4-deps.sh

rm -rf /lgxzj-install/php
mkdir /lgxzj-install/php

rm -rf lgxzj-php
mkdir lgxzj-php
cd lgxzj-php
wget https://www.php.net/distributions/php-7.4.4.tar.gz
tar -zxvf php-7.4.4.tar.gz
cd php-7.4.4

##############################
# Create user and group
##############################
php_user=lgxzj-php
php_group=lgxzj-php

groupadd ${php_group}
# create a non login permission user
useradd -r -g ${php_group} -s /bin/false ${php_user}

./configure --prefix=/lgxzj-install/php --enable-fpm --with-fpm-user=${php_user} --with-fpm-group=${php_group}
make
make install
