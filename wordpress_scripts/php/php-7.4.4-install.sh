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

./configure --prefix=/lgxzj-install/php --enable-fpm --with-fpm-user=${php_user} --with-fpm-group=${php_group} --with-pdo-pgsql --with-zlib-dir --with-freetype --enable-mbstring --enable-soap --enable-calendar --with-curl --with-zlib --enable-gd --with-pgsql --disable-rpath --enable-inline-optimization --with-bz2 --with-zlib --enable-sockets --enable-sysvsem --enable-sysvshm --enable-pcntl --enable-mbregex --enable-exif --enable-bcmath --with-mhash --with-zip --with-pdo-mysql --with-mysqli --with-jpeg --with-openssl --enable-ftp --with-imap --with-imap-ssl --with-kerberos --with-gettext --with-xmlrpc --with-xsl --enable-opcache --enable-intl --with-pear
make
make install
