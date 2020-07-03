./mysql-8.0.19-deps.sh

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
mysql_download_dir=$(read_ini ${iniFileLoc} download_leaf_dir_name)
mysql_download_url=$(read_ini ${iniFileLoc} mysql_download_url)
mysql_download_name=$(read_ini ${iniFileLoc} mysql_download_name)
mysql_download_prefix=$(read_ini ${iniFileLoc} mysql_download_prefix)

############################################################
# Copy files to install dir
############################################################
rm -rf ${mysql_install_dir}
mkdir ${mysql_install_dir}

rm -r ${mysql_download_dir}
mkdir ${mysql_download_dir}
cd ${mysql_download_dir}
wget ${mysql_download_url}
tar -xvJf ${mysql_download_name}
cp -rf ${mysql_download_prefix}/* ${mysql_install_dir}
