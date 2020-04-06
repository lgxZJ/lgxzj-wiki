rm -rf /lgxzj-install/mysql
mkdir /lgxzj-install/mysql

rm -rd lgxzj-mysql
mkdir lgxzj-mysql
cd lgxzj-mysql
wget https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8.0.19-linux-x86_64-minimal.tar.xz
tar -xvJf mysql-8.0.19-linux-x86_64-minimal.tar.xz
cp -rf mysql-8.0.19-linux-x86_64-minimal/* /lgxzj-install/mysql
