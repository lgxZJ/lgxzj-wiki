##############################
# Enter the install dir
##############################
mysql_install_dir=/lgxzj-install/mysql
cd ${mysql_install_dir}

##############################
# Create user and group
##############################
mysql_user=lgxzj-mysql
mysql_group=lgxzj-mysql

groupadd ${mysql_group}
# create a non login permission user
useradd -r -g ${mysql_group} -s /bin/false ${mysql_user}

#############################
# Prepare Option Files
#############################
TODO

# setup secure_file_priv related stuffs
# specify data dir

##############################
# Initialize data
##############################
mysql_conf_path=${mysql_install_dir}/etc/my.cnf

# this will cause mysqld to initialize the data directory
# with the given user as the default owner
./bin/mysqld --defaults-file=${mysql_config_path} --initialize-insecure --user=${mysql_user}

##############################
# Change Local Root Password
##############################
./bin/mysql -u root --skip-password -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '18712726983c++'"
