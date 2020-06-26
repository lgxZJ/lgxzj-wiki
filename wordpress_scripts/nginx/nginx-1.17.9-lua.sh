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
install_luajit_dir=$(read_ini ${iniFileLoc} install_luajit_dir)
nginx_luajit_download_url=$(read_ini ${iniFileLoc} nginx_luajit_download_url)
nginx_luajit_download_name=$(read_ini ${iniFileLoc} nginx_luajit_download_name)
nginx_luajit_download_prefix=$(read_ini ${iniFileLoc} nginx_luajit_download_prefix)
download_leaf_dir_name=$(read_ini ${iniFileLoc} download_leaf_dir_name)

install_ndk_dir=$(read_ini ${iniFileLoc} install_ndk_dir)
nginx_ndk_download_url=$(read_ini ${iniFileLoc} nginx_ndk_download_url)
nginx_ndk_download_name=$(read_ini ${iniFileLoc} nginx_ndk_download_name)
nginx_ndk_download_prefix=$(read_ini ${iniFileLoc} nginx_ndk_download_prefix)

install_lua_module_dir=$(read_ini ${iniFileLoc} install_lua_module_dir)
nginx_lua_module_download_url=$(read_ini ${iniFileLoc} nginx_lua_module_download_url)
nginx_lua_module_download_name=$(read_ini ${iniFileLoc} nginx_lua_module_download_name)
nginx_lua_module_download_prefix=$(read_ini ${iniFileLoc} nginx_lua_module_download_prefix)

##############################################################
# Install LuaJit
##############################################################
rm -rf ${download_leaf_dir_name}
mkdir ${download_leaf_dir_name}
cd ${download_leaf_dir_name}

wget ${nginx_luajit_download_url}
tar -zxvf ${nginx_luajit_download_name}
cd ${nginx_luajit_download_prefix}

#make install PREFIX=${install_luajit_dir}
cd ..

##############################################################
# Copy ngx_devel_kit and lua-nginx-module to dest dir
##############################################################
wget ${nginx_ndk_download_url}
tar -zxvf ${nginx_ndk_download_name}
rm -rf ${install_ndk_dir}
mkdir ${install_ndk_dir}
cp -rf ./${nginx_ndk_download_prefix}/* ${install_ndk_dir}

wget ${nginx_lua_module_download_url}
tar -zxvf ${nginx_lua_module_download_name}
rm -rf ${install_lua_module_dir}
mkdir ${install_lua_module_dir}
cp -rf ./${nginx_lua_module_download_prefix}/* ${install_lua_module_dir}
