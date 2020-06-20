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
download_leaf_dir_name=$(read_ini ${iniFileLoc} download_leaf_dir_name)
monitor_install_dir=$(read_ini ${iniFileLoc} monitor_install_dir)
prometheus_download_url=$(read_ini ${iniFileLoc} prometheus_download_url)
prometheus_download_name=$(read_ini ${iniFileLoc} prometheus_download_name)
prometheus_download_prefix=$(read_ini ${iniFileLoc} prometheus_download_prefix)
monitor_prometheus_install_dir=$(read_ini ${iniFileLoc} monitor_prometheus_install_dir)
monitor_exporters_install_dir=$(read_ini ${iniFileLoc} monitor_exporters_install_dir)

##############################################################
# Create dir and enter
##############################################################
rm -rf ${monitor_install_dir}
mkdir ${monitor_install_dir}
cd ${monitor_install_dir}

########################################################
# Install Prometheus
########################################################
rm -rf ${download_leaf_dir_name}
mkdir ${download_leaf_dir_name}
cd ${download_leaf_dir_name}

wget ${prometheus_download_url}
tar -zxvf ${prometheus_download_name}

mv ${prometheus_download_prefix} ${monitor_prometheus_install_dir}
cd ..
rm -rf ${download_leaf_dir_name}
