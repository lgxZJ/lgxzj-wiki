script_dir=`pwd`
mysql_install_dir=/lgxzj-install/mysql

#############################
# Prepare Option Files
#############################
rm -rf ${mysql_install_dir}/etc
mkdir ${mysql_install_dir}/etc

rm -rf ${mysql_install_dir}/logs
mkdir ${mysql_install_dir}/logs

rm -rf ${mysql_install_dir}/tmp
mkdir ${mysql_install_dir}/tmp

cp ./my.cnf ${mysql_install_dir}/etc

##############################
# Enter the install dir
##############################
cd ${mysql_install_dir}

##############################
# Create user and group
##############################
mysql_user=lgxzj-mysql
mysql_group=lgxzj-mysql

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

cd ${mysql_install_dir}
./bin/mysql -u root --skip-password -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '18712726983c++'"
