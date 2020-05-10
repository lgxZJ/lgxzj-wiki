php_install_dir=/lgxzj-install/php

mv ${php_install_dir}/etc/php-fpm.conf.default ${php_install_dir}/etc/php-fpm.conf
rm -f ${php_install_dir}/etc/php-fpm.d/www.conf.default
cp ./wordpress.conf ${php_install_dir}/etc/php-fpm.d/
cp ./php.ini ${php_install_dir}/etc

${php_install_dir}/sbin/php-fpm  --fpm-config ${php_install_dir}/etc/php-fpm.conf -c ${php_install_dir}/etc/php.ini
