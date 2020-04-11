mysql_install_dir=/lgxzj-install/mysql
mysql_user=test-mysql
mysql_root_password=18712726983c++

cd ${mysql_install_dir}
./bin/mysqladmin shutdown -u root -p${mysql_root_password}
