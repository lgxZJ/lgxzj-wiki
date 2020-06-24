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
monitor_install_dir=$(read_ini ${iniFileLoc} monitor_install_dir)
monitor_prometheus_install_dir=$(read_ini ${iniFileLoc} monitor_prometheus_install_dir)
monitor_exporters_install_dir=$(read_ini ${iniFileLoc} monitor_exporters_install_dir)
node_exporter_listen_address=$(read_ini ${iniFileLoc} node_exporter_listen_address)
prometheus_listen_address=$(read_ini ${iniFileLoc} prometheus_listen_address)
mysql_exporter_account=$(read_ini ${iniFileLoc} mysql_exporter_account)
mysql_exporter_password=$(read_ini ${iniFileLoc} mysql_exporter_password)
mysql_socket_file_loc=$(read_ini ${iniFileLoc} mysql_socket_file_loc)
mysql_exporter_listen_address=$(read_ini ${iniFileLoc} mysql_exporter_listen_address)

## start prometheus
cd ${monitor_prometheus_install_dir}
nohup ./prometheus --web.listen-address=":${prometheus_listen_address}" --config.file=./prometheus.yml >> ./prometheus.log &

## start exporters
cd ${monitor_exporters_install_dir}

# node exporter
nohup ./node_exporter --web.listen-address=":${node_exporter_listen_address}" --web.telemetry-path="/metrics" >> ./node_exporter.log &

# mysql exporter
export DATA_SOURCE_NAME="${mysql_exporter_account}:${mysql_exporter_password}@unix(${mysql_socket_file_loc})/"
nohup ./mysqld_exporter --web.listen-address=":${mysql_exporter_listen_address}" --web.telemetry-path="/metrics" >> mysqld_exporter.log &
