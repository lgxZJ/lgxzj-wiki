mysql_install_dir=/lgxzj-install/mysql
mysql_conf_path=${mysql_install_dir}/etc/my.cnf
mysql_user=test-mysql

cd ${mysql_install_dir}
./bin/mysqld_safe --defaults-file=${mysql_config_path}