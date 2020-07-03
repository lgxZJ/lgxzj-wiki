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
nginx_install_dir=$(read_ini ${iniFileLoc} install_nginx_dir)

##############################################################
# Stop Nginx
##############################################################
${nginx_install_dir}/sbin/nginx -s stop
