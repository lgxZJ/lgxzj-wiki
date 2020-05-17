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

if [ ! -f "../str_replacer.sh" ]; then
    echo "!!!!!!!!!!!!!!!!!!!!!!!"
    echo "str_replacer.sh not found"
    echo "!!!!!!!!!!!!!!!!!!!!!!!"
    exit 255
fi
. ../str_replacer.sh

##############################################################
# Load variables from the conf file
##############################################################
iniFileLoc=../lgxzj.ini
nginx_install_dir=$(read_ini ${iniFileLoc} install_nginx_dir)
blog_domain=$(read_ini ${iniFileLoc} blog_domain)

##############################################################
# Generate conf file using templates
##############################################################
rm -f ./nginx.conf
cp ./nginx.conf.template ./nginx.conf
replace_str ./nginx.conf '${blog_domain}' ${blog_domain}
replace_str ./nginx.conf '${install_nginx_dir}' ${nginx_install_dir}

##############################################################
# Start nginx
##############################################################
cp -f ./nginx.conf ${nginx_install_dir}/conf/nginx.conf
${nginx_install_dir}/sbin/nginx
