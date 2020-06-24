prometheus_pid=`pgrep -f prometheus`
if [ -z "${prometheus_pid}" ]; then
    echo "prometheus not active, no need to kill"
else
    kill -s SIGTERM ${prometheus_pid}
fi

node_exporter_pid=`pgrep -f node_exporter`
if [ -z "${node_exporter_pid}" ]; then
    echo "node_exporter not active, no need to kill"
else
    kill -s SIGTERM ${node_exporter_pid}
fi

mysqld_exporter_pid=`pgrep -f mysqld_exporter`
if [ -z "${mysqld_exporter_pid}" ]; then
    echo "mysqld_exporter not active, no need to kill"
else
    kill -s SIGTERM ${mysqld_exporter_pid}
fi
