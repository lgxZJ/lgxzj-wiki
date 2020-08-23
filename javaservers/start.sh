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
monitor_exporters_install_dir=$(read_ini ${iniFileLoc} monitor_exporters_install_dir)
backup_exporter_listen_address=$(read_ini ${iniFileLoc} backup_exporter_listen_address)
install_backups_dir=$(read_ini ${iniFileLoc} install_backups_dir)

cd ${monitor_exporters_install_dir}
nohup java -jar ${monitor_exporters_install_dir}/backup_exporter.jar --includeHidden=false --server.port=${backup_exporter_listen_address} --dirUrl=${install_backups_dir} > backup_exporter.log &
echo $! > backup_exporter.pid

