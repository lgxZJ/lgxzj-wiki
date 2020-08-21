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
monitor_pushgateway_install_dir=$(read_ini ${iniFileLoc} monitor_pushgateway_install_dir)
pusher_install_dir=$(read_ini ${iniFileLoc} pusher_install_dir)
node_exporter_listen_address=$(read_ini ${iniFileLoc} node_exporter_listen_address)
prometheus_listen_address=$(read_ini ${iniFileLoc} prometheus_listen_address)
pushgateway_listen_address=$(read_ini ${iniFileLoc} pushgateway_listen_address)
mysql_exporter_account=$(read_ini ${iniFileLoc} mysql_exporter_account)
mysql_exporter_password=$(read_ini ${iniFileLoc} mysql_exporter_password)
mysql_socket_file_loc=$(read_ini ${iniFileLoc} mysql_socket_file_loc)
mysql_exporter_listen_address=$(read_ini ${iniFileLoc} mysql_exporter_listen_address)
php_fpm_exporter_listen_address=$(read_ini ${iniFileLoc} php_fpm_exporter_listen_address)
backup_exporter_listen_address=$(read_ini ${iniFileLoc} backup_exporter_listen_address)
install_backups_dir=$(read_ini ${iniFileLoc} install_backups_dir)

## start prometheus
cd ${monitor_prometheus_install_dir}
nohup ./prometheus --web.listen-address=":${prometheus_listen_address}" --config.file=./prometheus.yml >> ./prometheus.log &

# pushgateway
cd ${monitor_pushgateway_install_dir}
nohup ./pushgateway --web.listen-address=":${pushgateway_listen_address}"  --web.telemetry-path="/metrics" --web.enable-admin-api >> pushgateway.log &

## pushers
cd ${pusher_install_dir}
nohup ./ps_pusher.sh >> ps_pusher.log &

## start exporters
cd ${monitor_exporters_install_dir}

# node exporter
nohup ./node_exporter --web.listen-address=":${node_exporter_listen_address}" --web.telemetry-path="/metrics" >> ./node_exporter.log &

# mysql exporter
export DATA_SOURCE_NAME="${mysql_exporter_account}:${mysql_exporter_password}@unix(${mysql_socket_file_loc})/"
nohup ./mysqld_exporter --web.listen-address=":${mysql_exporter_listen_address}" --web.telemetry-path="/metrics" --collect.info_schema.query_response_time >> mysqld_exporter.log &

# php_fpm exporter
nohup ./php_fpm_exporter server --web.listen-address 127.0.0.1:${php_fpm_exporter_listen_address} --web.telemetry-path="/metrics" --phpfpm.scrape-uri=tcp://127.0.0.1:9000/status,tcp://127.0.0.1:9001/status --phpfpm.fix-process-count=true >> php_fpm_exporter.log &

# process exporter
#nohup ./process_exporter -web.listen-address=127.0.0.1:${php_fpm_exporter_listen_address} -web.telemetry-path="/metrics" >> process_exporter.log &

# backup_exporter
nohup java -jar ${monitor_exporters_install_dir}/backup_exporter.jar --includeHidden=false --server.port=${backup_exporter_listen_address} --dirUrl=${install_backups_dir} > backup_exporter.log &
echo $! > backup_exporter.pid
