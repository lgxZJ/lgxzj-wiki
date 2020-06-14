##############################################################
# Load inf funcs
##############################################################
if [ ! -f "./ini_reader.sh" ]; then
    echo "!!!!!!!!!!!!!!!!!!!!!!!"
    echo "ini_reader.sh not found"
    echo "!!!!!!!!!!!!!!!!!!!!!!!"
    exit 255
fi
. ./ini_reader.sh

##############################################################
# Load variables from the conf file
##############################################################
iniFileLoc=./lgxzj.ini
root_install_dir=$(read_ini ${iniFileLoc} install_root_dir)

###################################
# Install global deps
###################################
yum install -y wget gcc make tar git
mkdir ${root_install_dir}

#############################################
# Install and start Mysql/Php/Nginx/Wordpress
#############################################
cd mysql
./mysql-8.0.19-deps.sh
./mysql-8.0.19-install.sh
./mysql-8.0.19-init.sh
./mysql-8.0.19-start.sh &
cd ..

cd php
./php-7.4.4-deps.sh
./php-7.4.4-install.sh
./php-7.4.4-start.sh
cd ..

cd nginx
./nginx-1.17.9-deps.sh
./nginx-1.17.9-install.sh
./nginx-1.17.9-start.sh
cd ..

cd wordpress
./wordpress-install.sh
./wordpress-prepare-db.sh
cd ..

cd backups
./install.sh
cd ..

########################################################
# Open port 80 via firewalld
########################################################
firewall-cmd --permanent --zone=public --add-port=80/tcp
firewall-cmd --reload
