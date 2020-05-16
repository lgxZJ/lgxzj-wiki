##############################################################
# Load inf funcs
##############################################################
if [ ! -f "../ini_reader.sh" ]; then
    echo "!!!!!!!!!!!!!!!!!!!!!!!"
    echo "ini_reader.sh not found"
    echo "!!!!!!!!!!!!!!!!!!!!!!!"
    exit 255
fi
. ../ini_reader.sh

##############################################################
# Load variables from the conf file
##############################################################
iniFileLoc=../lgxzj.ini
php_install_dir=$(read_ini ${iniFileLoc} install_php_dir)

##############################################################
# Start php-fpm
##############################################################
mv ${php_install_dir}/etc/php-fpm.conf.default ${php_install_dir}/etc/php-fpm.conf
rm -f ${php_install_dir}/etc/php-fpm.d/www.conf.default
cp ./wordpress.conf ${php_install_dir}/etc/php-fpm.d/
cp ./php.ini ${php_install_dir}/etc

${php_install_dir}/sbin/php-fpm  --fpm-config ${php_install_dir}/etc/php-fpm.conf -c ${php_install_dir}/etc/php.ini
