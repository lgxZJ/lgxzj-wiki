###############################################################
#                Read Vars From Conf Files
###############################################################
function read_ini() {
	if [ "$#" -ne 1 ]; then
		echo -e "!!!!!!!!!!!!!!!!!!!!!!!!"
		echo -e "usage: readIni itemKey"
		echo -e "!!!!!!!!!!!!!!!!!!!!!!!!"
		return 255
	fi

	filename="./openvpn_installer.conf"
	checkKey="$1"
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

global__download_dir=$(read_ini global__download_dir)
openvpn__install_dir=$(read_ini openvpn__install_dir)
openvpn__install_etc_dir=$(read_ini openvpn__install_etc_dir)
openvpn__install_etc_ca_dir=$(read_ini openvpn__install_etc_ca_dir)
openvpn__install_etc_server_dir=$(read_ini openvpn__install_etc_server_dir)
openvpn__install_etc_server_client_dir=$(read_ini openvpn__install_etc_client_dir)
openvpn__install_download_url=$(read_ini openvpn__install_download_url)
openvpn__install_download_package=$(read_ini openvpn__install_download_package)
openvpn__install_download_folder=$(read_ini openvpn__install_download_folder)
easyrsa__install_download_url=$(read_ini easyrsa__install_download_url)
easyrsa__install_download_package=$(read_ini easyrsa__install_download_package)
easyrsa__install_download_name=$(read_ini easyrsa__install_download_name)


################################################################
#                      Real Commands
################################################################

kill -s SIGTERM $(pgrep openvpn)
