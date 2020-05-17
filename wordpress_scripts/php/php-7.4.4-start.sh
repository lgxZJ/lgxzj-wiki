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

if [ ! -f "../str_replacer.sh" ]; then
    echo "!!!!!!!!!!!!!!!!!!!!!!!"
    echo "str_replacer.sh not found"
    echo "!!!!!!!!!!!!!!!!!!!!!!!"
    exit 255
fi
. ../str_replacer.sh

##############################################################
# Load variables from the conf file
##############################################################
iniFileLoc=../lgxzj.ini
php_install_dir=$(read_ini ${iniFileLoc} install_php_dir)
php_user=$(read_ini ${iniFileLoc} php_user)
php_group=$(read_ini ${iniFileLoc} php_group)

##############################################################
# Replace template variables with conf values
##############################################################
rm -f ./php-fpm.conf
cp ./php-fpm.conf.template ./php-fpm.conf
replace_str ./php-fpm.conf '${install_php_dir}' ${php_install_dir}

rm -f ./wordpress.conf
cp ./wordpress.conf.template ./wordpress.conf
replace_str ./wordpress.conf '${php_user}' ${php_user}
replace_str ./wordpress.conf '${php_group}' ${php_group}

##############################################################
# Start php-fpm
##############################################################
rm -f ${php_install_dir}/etc/php-fpm.d/www.conf.default
cp ./php-fpm.conf ${php_install_dir}/etc
cp ./wordpress.conf ${php_install_dir}/etc/php-fpm.d/
cp ./php.ini ${php_install_dir}/etc

${php_install_dir}/sbin/php-fpm  --fpm-config ${php_install_dir}/etc/php-fpm.conf -c ${php_install_dir}/etc/php.ini
