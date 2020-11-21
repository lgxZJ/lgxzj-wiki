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

###############################################################
#                      Common Func
###############################################################
function prepare_dir()
{
    dst_dir=$1
    if [ -z $dst_dir ]; then
	echo 'dst dir not presented!'
	exit 255
    fi

    rm -rf $dst_dir
    mkdir -p $dst_dir
    return 0
}

###############################################################
#                Install OpenVpn
###############################################################
cd $global__download_dir
rm -f $openvpn__install_download_package

wget $openvpn__install_download_url
tar -zxf $openvpn__install_download_package
cd $openvpn__install_download_folder
./configure --prefix=$openvpn__install_dir
make
make install

###############################################################
#                      Install EasyRsa
###############################################################
cd $global__download_dir
rm -f $easyrsa__install_download_package

wget $easyrsa__install_download_url
tar zxvf $easyrsa__install_download_package
cd $easyrsa__install_download_name

###############################################################
#                     Generate CA
#  No vars file, probably using the default settings of EasyRsa. 
#  Guide can be found here: https://www.howtoforge.com/tutorial/
#  how-to-install-openvpn-server-and-client-with-easy-rsa-3-on-
#  centos-8/
###############################################################
prepare_dir $openvpn__install_etc_dir
prepare_dir $openvpn__install_etc_ca_dir

cp $easyrsa__install_download_name/easyrsa $openvpn__install_etc_ca_dir
cd $openvpn__install_etc_ca_dir

./easyrsa init-pki
./easyrsa build-ca

###############################################################
#                  Generate Server Certificate                       
###############################################################
./easyrsa gen-req lgxzj_openvpn_server nopass
./easyrsa sign-req server lgxzj_openvpn_server

###############################################################
#                  Generate Client Certificate
###############################################################
./easyrsa gen-req lgxzj_openvpn_client nopass
./easyrsa sign-req client lgxzj_openvpn_client

###############################################################
#                  Generate Diffie-Hellman Key
###############################################################
./easyrsa gen-dh

###############################################################
#        Organize Server&Client Certificate to Bundles
###############################################################
prepare_dir $openvpn__install_etc_server_dir
prepare_dir $openvpn__install_etc_client_dir

cp ./pki/ca.crt $openvpn__install_etc_server_dir
cp ./pki/issued/lgxzj_openvpn_server.crt $openvpn__install_etc_server_dir
cp ./pki/private/lgxzj_openvpn_server.key $$openvpn__install_etc_server_dir
cp ./pki/dh.pem $$openvpn__install_etc_server_dir

cp ./pki/ca.crt $openvpn__install_etc_client_dir
cp ./pki/issued/lgxzj_openvpn_client.crt $openvpn__install_etc_client_dir
cp ./pki/private/lgxzj_openvpn_client.key $openvpn__install_etc_client_dir

###############################################################
#                  Configure OpenVpn
###############################################################
