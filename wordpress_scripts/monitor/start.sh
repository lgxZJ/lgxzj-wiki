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

## start prometheus
cd ${monitor_prometheus_install_dir}
nohup ./prometheus --web.listen-address=":${prometheus_listen_address}" --config.file=./prometheus.yml >> ./prometheus.log &

## start exporters
cd ${monitor_exporters_install_dir}
nohup ./node_exporter --web.listen-address=":${node_exporter_listen_address}" --web.telemetry-path="/metrics" >> ./node_exporter.log &
