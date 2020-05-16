./nginx-1.17.9-deps.sh

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
download_tmp_dir=$(read_ini ${iniFileLoc} download_leaf_dir_name)
nginx_download_url=$(read_ini ${iniFileLoc} nginx_download_url)
nginx_download_name=$(read_ini ${iniFileLoc} nginx_download_name)
nginx_download_prefix=$(read_ini ${iniFileLoc} nginx_download_prefix)

##############################################################
# Copy Nginx into install dir
##############################################################
mkdir ${nginx_install_dir}

rm -rf ${download_tmp_dir}
mkdir ${download_tmp_dir}
cd ${download_tmp_dir}

wget ${nginx_download_url}
tar -zxvf ${nginx_download_name}

cd ${nginx_download_prefix}
./configure --prefix=${nginx_install_dir}
make
make install
