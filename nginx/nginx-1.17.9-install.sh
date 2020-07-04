./nginx-1.17.9-deps.sh
./nginx-1.17.9-lua.sh
./nginx-1.17.9-prometheus.sh

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
install_luajit_dir=$(read_ini ${iniFileLoc} install_luajit_dir)
install_ndk_dir=$(read_ini ${iniFileLoc} install_ndk_dir)
install_lua_module_dir=$(read_ini ${iniFileLoc} install_lua_module_dir)

##############################################################
# Copy Nginx into install dir
##############################################################
mkdir ${nginx_install_dir}

rm -rf ${download_tmp_dir}
mkdir ${download_tmp_dir}
cd ${download_tmp_dir}

wget ${nginx_download_url}
tar -zxvf ${nginx_download_name}

# the location to find LuaJit2.0
export LUAJIT_LIB=${install_luajit_dir}/lib
export LUAJIT_INC=${install_luajit_dir}/include/luajit-2.1

cd ${nginx_download_prefix}
./configure --prefix=${nginx_install_dir} --with-ld-opt="-Wl,-rpath,${LUAJIT_LIB}" --add-module=${install_ndk_dir} --add-module=${install_lua_module_dir} --with-stream
make
make install
