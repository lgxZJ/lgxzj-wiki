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
install_mysql_dir=$(read_ini ${iniFileLoc} install_mysql_dir)
mysql_root_local_password=$(read_ini ${iniFileLoc} mysql_root_local_password)
mysql_socket_file_loc=$(read_ini ${iniFileLoc} mysql_socket_file_loc)
mysql_exporter_account=$(read_ini ${iniFileLoc} mysql_exporter_account)
mysql_exporter_password=$(read_ini ${iniFileLoc} mysql_exporter_password)

cd ${install_mysql_dir}
echo ${mysql_exporter_account}
echo ${mysql_exporter_password}
./bin/mysql --socket=${mysql_socket_file_loc} -u root -p${mysql_root_local_password} -e "CREATE USER IF NOT EXISTS '${mysql_exporter_account}'@'localhost' IDENTIFIED BY '${mysql_exporter_password}' WITH MAX_USER_CONNECTIONS 3; GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO '${mysql_exporter_account}'@'localhost'; FLUSH PRIVILEGES;"
