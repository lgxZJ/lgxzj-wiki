#############################################################
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
download_tmp_dir=$(read_ini ${iniFileLoc} download_leaf_dir_name)
wordpress_downlooad_url=$(read_ini ${iniFileLoc} wordpress_downlooad_url)
wordpress_downlooad_name=$(read_ini ${iniFileLoc} wordpress_downlooad_name)
wordpress_downlooad_prefix=$(read_ini ${iniFileLoc} wordpress_downlooad_prefix)
wordpress_db_name=$(read_ini ${iniFileLoc} wordpress_db_name)
wordpress_db_user=$(read_ini ${iniFileLoc} wordpress_db_user)
wordpress_db_password=$(read_ini ${iniFileLoc} wordpress_db_password)
mysql_socket_file_loc=$(read_ini ${iniFileLoc} mysql_socket_file_loc)
install_nginx_dir=$(read_ini ${iniFileLoc} install_nginx_dir)
php_user=$(read_ini ${iniFileLoc} php_user)

##############################################################
# Download wordpress
##############################################################
rm -rf ${download_tmp_dir}
mkdir ${download_tmp_dir}
cd ${download_tmp_dir}

wget ${wordpress_downlooad_url}
tar -xzvf ${wordpress_downlooad_name}

##############################################################
# Generate confs from template
##############################################################
rm -f ../wp-config.php
cp ../wp-config.php.template ../wp-config.php
replace_str ../wp-config.php '${wordpress_db_name}' ${wordpress_db_name}
replace_str ../wp-config.php '${wordpress_db_user}' ${wordpress_db_user}
replace_str ../wp-config.php '${wordpress_db_password}' ${wordpress_db_password}
replace_str ../wp-config.php '${mysql_socket_file_loc}' ${mysql_socket_file_loc}

cp ../wp-config.php ${wordpress_downlooad_prefix}/wp-config.php

##############################################################
# Copy to destination
##############################################################
blog_dir=${install_nginx_dir}/html
rm -rf ${blog_dir}
mkdir ${blog_dir}
cp -R ./${wordpress_downlooad_prefix}/* ${blog_dir}
chown -R ${php_user} ${blog_dir}
