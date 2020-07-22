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

mysql_exporter_download_url=$(read_ini ${iniFileLoc} mysql_exporter_download_url)
mysql_exporter_download_name=$(read_ini ${iniFileLoc} mysql_exporter_download_name)
mysql_exporter_download_prefix=$(read_ini ${iniFileLoc} mysql_exporter_download_prefix)
mysql_exporter_listen_address=$(read_ini ${iniFileLoc} mysql_exporter_listen_address)

php_fpm_exporter_download_url=$(read_ini ${iniFileLoc} php_fpm_exporter_download_url)
php_fpm_exporter_download_name=$(read_ini ${iniFileLoc} php_fpm_exporter_download_name)

process_exporter_download_name=$(read_ini ${iniFileLoc} process_exporter_download_name)
process_exporter_download_url=$(read_ini ${iniFileLoc} process_exporter_download_url)
process_exporter_download_prefix=$(read_ini ${iniFileLoc} process_exporter_download_prefix)

pushgateway_download_url=$(read_ini ${iniFileLoc} pushgateway_download_url)
pushgateway_download_name=$(read_ini ${iniFileLoc} pushgateway_download_name)
pushgateway_download_prefix=$(read_ini ${iniFileLoc} pushgateway_download_prefix)
monitor_pushgateway_install_dir=$(read_ini ${iniFileLoc} monitor_pushgateway_install_dir)
pushgateway_listen_address=$(read_ini ${iniFileLoc} pushgateway_listen_address)
pusher_install_dir=$(read_ini ${iniFileLoc} pusher_install_dir)
ps_pusher_top_n=$(read_ini ${iniFileLoc} ps_pusher_top_n)
ps_pusher_sleep_second=$(read_ini ${iniFileLoc} ps_pusher_sleep_second)
ps_pusher_pid_file_loc=$(read_ini ${iniFileLoc} ps_pusher_pid_file_loc)

##############################################################
# Translate stop.template into runnable scripts
##############################################################
rm -f stop.sh
cp stop.template stop.sh
replace_str ./stop.sh '${ps_pusher_pid_file_loc}' ${ps_pusher_pid_file_loc}
replace_str ./stop.sh '${pusher_install_dir}' ${pusher_install_dir}
chmod u+x ./stop.sh

##############################################################
# Translate `pushers` into runnable scripts and Install
##############################################################
rm -rf ${pusher_install_dir}
mkdir ${pusher_install_dir}

rm -rf ps_pusher.sh
cp ps_pusher.template ps_pusher.sh
replace_str ./ps_pusher.sh '${pushgateway_listen_address}' ${pushgateway_listen_address}
replace_str ./ps_pusher.sh '${ps_pusher_top_n}' ${ps_pusher_top_n}
replace_str ./ps_pusher.sh '${ps_pusher_sleep_second}' ${ps_pusher_sleep_second}
replace_str ./ps_pusher.sh '${ps_pusher_pid_file_loc}' ${ps_pusher_pid_file_loc}
chmod u+x ps_pusher.sh

local_pushers_dir=`pwd`

##############################################################
# Create dir and enter
##############################################################
cur_dir=`pwd`

rm -rf ${monitor_install_dir}
mkdir ${monitor_install_dir}
cd ${monitor_install_dir}

#######################################################
# Install pushers
#######################################################
rm -rf ${pusher_install_dir}
mkdir ${pusher_install_dir}
cp ${local_pushers_dir}/ps_pusher.sh ${pusher_install_dir}

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
replace_str ./prometheus.yml '${pushgateway_listen_address}' ${pushgateway_listen_address}
cp -f prometheus.yml ${monitor_prometheus_install_dir}

########################################################
# Install Pushgateway
########################################################
rm -rf ${monitor_pushgateway_install_dir}
mkdir ${monitor_pushgateway_install_dir}

wget ${pushgateway_download_url}
tar -zxvf ${pushgateway_download_name}
cp ./${pushgateway_download_prefix}/pushgateway ${monitor_pushgateway_install_dir}

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

########################################################
# Install Mysql Exporter
########################################################

# !! before doing this, mysql must be started !!
chmod u+x ./create_account.sh
./create_account.sh

wget ${mysql_exporter_download_url}
tar -zxvf ${mysql_exporter_download_name}
cp ${mysql_exporter_download_prefix}/mysqld_exporter ${monitor_exporters_install_dir}

########################################################
# Install PHP-FPM Exporter
########################################################
wget ${php_fpm_exporter_download_url}
chmod u+x ./${php_fpm_exporter_download_name}
cp ./${php_fpm_exporter_download_name} ${monitor_exporters_install_dir}/php_fpm_exporter

########################################################
# Install Process-Exporter
########################################################
#wget ${process_exporter_download_url}
#tar -zxvf ${process_exporter_download_name}
#mv ./${process_exporter_download_prefix}/process-exporter ./${process_exporter_download_prefix}/process_exporter
#cp ./${process_exporter_download_prefix}/process_exporter ${monitor_exporters_install_dir}/process_exporter

