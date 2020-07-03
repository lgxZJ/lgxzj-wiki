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
php_install_dir=$(read_ini ${iniFileLoc} install_php_dir)
php_fpm_pid_loc=$(read_ini ${iniFileLoc} php_fpm_pid_loc)

kill -INT `cat ${php_fpm_pid_loc}`
