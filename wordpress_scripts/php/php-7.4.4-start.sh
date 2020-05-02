php_install_dir=/lgxzj-install/php

mv ${php_install_dir}/etc/php-fpm.conf.default ${php_install_dir}/etc/php-fpm.conf
rm -f ${php_install_dir}/etc/php-fpm.d/www.conf.default
cp ./wordpress.conf ${php_install_dir}/etc/php-fpm.d/

${php_install_dir}/sbin/php-fpm 
