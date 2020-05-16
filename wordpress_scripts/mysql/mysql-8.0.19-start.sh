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
mysql_install_dir=$(read_ini ${iniFileLoc} install_mysql_dir)
mysql_conf_path=${mysql_install_dir}/etc/my.cnf
mysql_user=$(read_ini ${iniFileLoc} mysql_user)

##############################################################
# Start Mysql
##############################################################
cd ${mysql_install_dir}
./bin/mysqld_safe --defaults-file=${mysql_conf_path}
