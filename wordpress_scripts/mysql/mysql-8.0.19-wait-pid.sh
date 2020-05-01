pid_file_loc=/lgxzj-install/mysql/data/mysql.pid
while [ ! -f "$pid_file_loc" ]
do
	echo "waiting for mysqld to start..."
	sleep 1
done

echo "mysqld started!"
