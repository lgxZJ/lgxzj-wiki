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
pid_file_loc=${mysql_install_dir}/data/mysql.pid
while [ ! -f "$pid_file_loc" ]
do
	echo "waiting for mysqld to start..."
	sleep 1
done

echo "mysqld started!"
