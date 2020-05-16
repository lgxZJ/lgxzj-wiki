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
mysql_user=$(read_ini ${iniFileLoc} mysql_user)
mysql_root_password=$(read_ini ${iniFileLoc} mysql_root_local_password)
mysql_sock_loc=${mysql_install_dir}/data/mysql.sock

##############################################################
# Shutdown Mysql
##############################################################
cd ${mysql_install_dir}
./bin/mysqladmin shutdown --socket=${mysql_sock_loc} -u root -p${mysql_root_password}
