mysql_install_dir=/lgxzj-install/mysql
mysql_user=test-mysql
mysql_root_password=18712726983c++
mysql_sock_loc=${mysql_install_dir}/data/mysql.sock

cd ${mysql_install_dir}
./bin/mysqladmin shutdown --socket=${mysql_sock_loc} -u root -p${mysql_root_password}
