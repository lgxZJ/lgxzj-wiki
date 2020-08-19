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

pid_file="${monitor_exporters_install_dir}/backup_exporter.pid"
if [ ! -f "${pid_file}" ]; then
    echo "backup_exporter not active, skip"
else
    pid=`cat ${pid_file}`
    kill -s SIGTERM ${pid}
    rm -f ${pid_file}
fi
