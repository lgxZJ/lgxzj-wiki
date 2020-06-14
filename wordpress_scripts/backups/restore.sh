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

###############################################
# Read Confs
###############################################
iniFileLoc=../lgxzj.ini
mysql_install_dir=$(read_ini ${iniFileLoc} install_mysql_dir)
install_backups_dir=$(read_ini ${iniFileLoc} install_backups_dir)
mysql_socket_file_loc=$(read_ini ${iniFileLoc} mysql_socket_file_loc)
mysql_root_local_password=$(read_ini ${iniFileLoc} mysql_root_local_password)
wordpress_deploy_dir=$(read_ini ${iniFileLoc} wordpress_deploy_dir)

##############################################################
#
##############################################################
backup_sql_file=$1
backup_wordpress_file=$2
if [ "$#" -ne 2 ]; then
    echo ""
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    echo "Usage: restore.sh backup_file.sql wordpress.tar.gz"
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    echo ""
    exit 255
fi

# restore mysql dbs
echo ""
echo "=================================="
echo "Mysql backup begins: `date`"
${mysql_install_dir}/bin/mysql --socket ${mysql_socket_file_loc} -u root -p${mysql_root_local_password} < ${backup_sql_file}
echo "Mysql backup ends: `date`"

# restore wordpress files
echo ""
echo "Wordpress backup begins: `date`"
rm -rf backups_tmp
mkdir backups_tmp
cd backups_tmp
tar -zxvf ${backup_wordpress_file} 1> /dev/null

mkdir -p ${wordpress_deploy_dir}
source_dir=${wordpress_deploy_dir:1}
cp -rf ${source_dir}/* ${wordpress_deploy_dir}

cd ..
rm -rf backups_tmp
echo "Wordpress backup ends: `date`"
echo "=================================="
echo ""
