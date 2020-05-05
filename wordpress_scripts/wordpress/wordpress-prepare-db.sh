mysql_install_dir=/lgxzj-install/mysql
mysql_sock_loc=${mysql_install_dir}/data/mysql.sock
mysql_root_password=18712726983c++

cd ${mysql_install_dir}
./bin/mysql --socket=${mysql_sock_loc} -u root -p${mysql_root_password} -e "DROP DATABASE IF EXISTS wordpress;  CREATE DATABASE wordpress; CREATE USER 'lgxzj-wordpress'@'localhost' IDENTIFIED BY 'password-wordpress'; GRANT ALL PRIVILEGES ON wordpress.* to 'lgxzj-wordpress'@'localhost'; FLUSH PRIVILEGES;"
