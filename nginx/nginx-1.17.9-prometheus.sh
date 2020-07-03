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
install_nginx_lua_prometheus_dir=$(read_ini ${iniFileLoc} install_nginx_lua_prometheus_dir)
download_leaf_dir_name=$(read_ini ${iniFileLoc} download_leaf_dir_name)

rm -rf ${download_leaf_dir_name}
mkdir ${download_leaf_dir_name}
cd ${download_leaf_dir_name}
git clone https://github.com/knyar/nginx-lua-prometheus.git

rm -rf ${install_nginx_lua_prometheus_dir}
mkdir ${install_nginx_lua_prometheus_dir}
cp -rf nginx-lua-prometheus/* ${install_nginx_lua_prometheus_dir}
