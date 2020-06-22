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
download_leaf_dir_name=$(read_ini ${iniFileLoc} download_leaf_dir_name)
monitor_install_dir=$(read_ini ${iniFileLoc} monitor_install_dir)
prometheus_download_url=$(read_ini ${iniFileLoc} prometheus_download_url)
prometheus_download_name=$(read_ini ${iniFileLoc} prometheus_download_name)
prometheus_download_prefix=$(read_ini ${iniFileLoc} prometheus_download_prefix)
prometheus_listen_address=$(read_ini ${iniFileLoc} prometheus_listen_address)
monitor_prometheus_install_dir=$(read_ini ${iniFileLoc} monitor_prometheus_install_dir)
monitor_exporters_install_dir=$(read_ini ${iniFileLoc} monitor_exporters_install_dir)
node_exporter_download_url=$(read_ini ${iniFileLoc} node_exporter_download_url)
node_exporter_download_name=$(read_ini ${iniFileLoc} node_exporter_download_name)
node_exporter_download_prefix=$(read_ini ${iniFileLoc} node_exporter_download_prefix)
node_exporter_listen_address=$(read_ini ${iniFileLoc} node_exporter_listen_address)

##############################################################
# Create dir and enter
##############################################################
cur_dir=`pwd`

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

cp -f ${cur_dir}/prometheus.template prometheus.yml
replace_str ./prometheus.yml '${node_exporter_listen_address}' ${node_exporter_listen_address}
replace_str ./prometheus.yml '${prometheus_listen_address}' ${prometheus_listen_address}
cp -f prometheus.yml ${monitor_prometheus_install_dir}

#######################################################
# Create Exporter dir
#######################################################
rm -rf ${monitor_exporters_install_dir}
mkdir ${monitor_exporters_install_dir}

########################################################
# Install Node Exporter
########################################################
wget ${node_exporter_download_url}
tar -zxvf ${node_exporter_download_name}
cp ${node_exporter_download_prefix}/node_exporter ${monitor_exporters_install_dir}
