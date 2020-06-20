prometheus_pid=`pgrep -f prometheus`
kill -s SIGTERM ${prometheus_pid}
