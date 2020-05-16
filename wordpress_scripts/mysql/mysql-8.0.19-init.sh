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

script_dir=`pwd`
mysql_user=$(read_ini ${iniFileLoc} mysql_user)
mysql_group=$(read_ini ${iniFileLoc} mysql_group)
mysql_root_local_password=$(read_ini ${iniFileLoc} mysql_root_local_password)

#############################
# Prepare Option Files
#############################
rm -rf ${mysql_install_dir}/data
mkdir ${mysql_install_dir}/data
chown -R ${mysql_user} ${mysql_install_dir}/data
chmod 777 -R ${mysql_install_dir}/data

rm -rf ${mysql_install_dir}/etc
mkdir ${mysql_install_dir}/etc
chown -R ${mysql_user} ${mysql_install_dir}/etc
chmod 777 -R ${mysql_install_dir}/etc

rm -rf ${mysql_install_dir}/logs
mkdir ${mysql_install_dir}/logs
chown -R ${mysql_user} ${mysql_install_dir}/logs
chmod 777 -R ${mysql_install_dir}/logs
touch ${mysql_install_dir}/logs/mysql.error
chmod o+rw ${mysql_install_dir}/logs/mysql.error

rm -rf ${mysql_install_dir}/tmp
mkdir ${mysql_install_dir}/tmp
chown -R ${mysql_user} ${mysql_install_dir}/tmp
chmod 777 -R ${mysql_install_dir}/tmp

cp ./my.cnf ${mysql_install_dir}/etc

##############################
# Enter the install dir
##############################
cd ${mysql_install_dir}

##############################
# Create user and group
##############################
groupadd ${mysql_group}
# create a non login permission user
useradd -r -g ${mysql_group} -s /bin/false ${mysql_user}


##############################
# Initialize data
##############################
mysql_conf_path=${mysql_install_dir}/etc/my.cnf

# this will cause mysqld to initialize the data directory
# with the given user as the default owner
./bin/mysqld --defaults-file=${mysql_conf_path} --initialize-insecure

##############################
# Change Local Root Password
##############################
cd ${script_dir}
./mysql-8.0.19-start.sh &
./mysql-8.0.19-wait-pid.sh

mysql_sock_loc=${mysql_install_dir}/data/mysql.sock
cd ${mysql_install_dir}
./bin/mysql --socket=${mysql_sock_loc} -u root --skip-password -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${mysql_root_local_password}'"

cd ${script_dir}
./mysql-8.0.19-stop.sh
