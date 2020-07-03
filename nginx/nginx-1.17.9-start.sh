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
nginx_prometheus_metric_listen_address=$(read_ini ${iniFileLoc} nginx_prometheus_metric_listen_address)
install_nginx_lua_prometheus_dir=$(read_ini ${iniFileLoc} install_nginx_lua_prometheus_dir)

react_domain=$(read_ini ${iniFileLoc} react_domain)
install_react_dir=$(read_ini ${iniFileLoc} install_react_dir)

##############################################################
# Generate conf file using templates
##############################################################
rm -f ./nginx.conf
cp ./nginx.conf.template ./nginx.conf

replace_str ./nginx.conf '${blog_domain}' ${blog_domain}
replace_str ./nginx.conf '${install_nginx_dir}' ${nginx_install_dir}
replace_str ./nginx.conf '${install_nginx_lua_prometheus_dir}' ${install_nginx_lua_prometheus_dir}
replace_str ./nginx.conf '${nginx_prometheus_metric_listen_address}' ${nginx_prometheus_metric_listen_address~}

replace_str ./nginx.conf '${react_domain}' ${react_domain}
replace_str ./nginx.conf '${install_react_dir}' ${install_react_dir}

##############################################################
# Create react deploy dir
##############################################################
if [ ! -d "${install_react_dir}" ]; then
    mkdir ${install_react_dir}
else
    echo "react dir existed, creation skipped"
fi

##############################################################
# Start nginx
##############################################################
cp -f ./nginx.conf ${nginx_install_dir}/conf/nginx.conf
${nginx_install_dir}/sbin/nginx
