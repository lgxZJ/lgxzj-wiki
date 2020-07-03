function read_ini() {
	if [ "$#" -ne 2 ]; then
		echo -e "!!!!!!!!!!!!!!!!!!!!!!!!"
		echo -e "usage: readIni filePath itemKey"
		echo -e "!!!!!!!!!!!!!!!!!!!!!!!!"
		return 255
	fi

	filename="$1"
	checkKey="$2"
	itemFound=false

	while read line
	do
		if [ "${line:0:1}" = "#" ]; then
			# skip comments
			continue
		fi

		if [ -z "${line}" ]; then
			# skip empty lines
			continue
		fi

		keyValue=(${line//=/ })
		if [ "${#keyValue[*]}" -ne 2 ]; then
			echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
			echo "invalid ini line inside file: ${line}"
			echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
			exit 255
		fi

		if [ "${keyValue[0]}" != "${checkKey}" ]; then
			continue
		fi
		
		echo "${keyValue[1]}"
		itemFound=true
		break

	done < $filename  

	if [ "${itemFound}" != true ]; then
		echo "Ini item ${itemKey} not found"
		exit 255
	fi	
}
