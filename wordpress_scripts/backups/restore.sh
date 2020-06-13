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
mysql_install_dir=$(read_ini ${iniFileLoc} mysql_install_dir)
mysql_socket_file_loc=$(read_ini ${iniFileLoc} mysql_socket_file_loc)
mysql_root_local_password=$(read_ini ${iniFileLoc} mysql_root_local_password)

##############################################################
#
##############################################################
backup_sql_file=$1
if [ "$#" -ne 1 ]; then
    echo ""
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    echo "Usage: restore.sh backup_file.sql"
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    echo ""
    exit 255
fi

${mysql_install_dir}/bin/mysql --socket ${mysql_socket_file_loc} -u root -p${mysql_root_local_password} < ${backup_sql_file}
