#############################################################
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
install_mysql_dir=$(read_ini ${iniFileLoc} install_mysql_dir)
mysql_sock_loc=$(read_ini ${iniFileLoc} mysql_socket_file_loc)
mysql_root_password=$(read_ini ${iniFileLoc} mysql_root_local_password)
wordpress_db_user=$(read_ini ${iniFileLoc} wordpress_db_user)
wordpress_db_name=$(read_ini ${iniFileLoc} wordpress_db_name)
wordpress_db_password=$(read_ini ${iniFileLoc} wordpress_db_password)

cd ${install_mysql_dir}
./bin/mysql --socket=${mysql_sock_loc} -u root -p${mysql_root_password} -e "DROP DATABASE IF EXISTS ${wordpress_db_name};  CREATE DATABASE ${wordpress_db_name}; CREATE USER '${wordpress_db_user}'@'localhost' IDENTIFIED BY '${wordpress_db_password}'; GRANT ALL PRIVILEGES ON ${wordpress_db_name}.* to '${wordpress_db_user}'@'localhost'; FLUSH PRIVILEGES;"
