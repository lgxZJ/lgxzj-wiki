mysql_install_dir=/lgxzj-install/mysql
mysql_user=test-mysql

cd ${mysql_install_dir}
./bin/mysqld_safe --user=${mysql_user}
