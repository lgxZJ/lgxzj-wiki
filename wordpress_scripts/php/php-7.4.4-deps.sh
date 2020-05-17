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
php_install_dir=$(read_ini ${iniFileLoc} install_php_dir)
download_tmp_dir=$(read_ini ${iniFileLoc} download_leaf_dir_name)

deps_download_url_libc_client=$(read_ini ${iniFileLoc} deps_download_url_libc_client)
deps_download_name_libc_client=$(read_ini ${iniFileLoc} deps_download_name_libc_client)
deps_download_prefix_libc_client=$(read_ini ${iniFileLoc} deps_download_prefix_libc_client)

deps_download_url_uw_imap_devel=$(read_ini ${iniFileLoc} deps_download_url_uw_imap_devel)
deps_download_name_uw_imap_devel=$(read_ini ${iniFileLoc} deps_download_name_uw_imap_devel)
deps_download_prefix_uw_imap_devel=$(read_ini ${iniFileLoc} deps_download_prefix_uw_imap_devel)

deps_download_url_oniguruma_devel=$(read_ini ${iniFileLoc} deps_download_url_oniguruma_devel)
deps_download_name_oniguruma_devel=$(read_ini ${iniFileLoc} deps_download_name_oniguruma_devel)
deps_download_prefix_oniguruma_devel=$(read_ini ${iniFileLoc} deps_download_prefix_oniguruma_devel)

deps_download_url_oniguruma=$(read_ini ${iniFileLoc} deps_download_url_oniguruma)
deps_download_name_oniguruma=$(read_ini ${iniFileLoc} deps_download_name_oniguruma)
deps_download_prefix_oniguruma=$(read_ini ${iniFileLoc} deps_download_prefix_oniguruma)

##############################################################
# Install Deps
##############################################################
yum install -y libxml2-devel sqlite-devel krb5-devel openssl-devel bzip2-devel libcurl-devel libpng-devel libjpeg-turbo-devel freetype-devel  libicu-devel gcc-c++ libpq-devel libxslt-devel libzip-devel

rm -rf ${download_tmp_dir}
mkdir ${download_tmp_dir}
cd ${download_tmp_dir}

libc_client_installed=`rpm -qa | grep "${deps_download_prefix_libc_client}"`
if  [[ -z "${libc_client_installed}" ]]; then
    wget ${deps_download_url_libc_client}
    rpm -Uvh ${deps_download_name_libc_client}
else
    echo "libc_client installed!"
fi

imap_installed=`rpm -qa | grep "${deps_download_prefix_uw_imap_devel}"`
if [[ -z "$imap_installed" ]]; then
	wget ${deps_download_url_uw_imap_devel}
	rpm -Uvh ${deps_download_name_uw_imap_devel}

else
	echo "uw_imap already installed!"
fi

oniguruma_devel_installed=`rpm -qa | grep "${deps_download_prefix_oniguruma_devel}"`
if [[ -z "$oniguruma_devel_installed" ]]; then
	wget ${deps_download_url_oniguruma_devel}
	rpm -Uvh ${deps_download_name_oniguruma_devel}
else
	echo "oniguruma_devel already installed!"
fi

oniguruma_installed=`rpm -qa | grep "${deps_download_prefix_oniguruma}"`
if [[ -z "$oniguruma_installed" ]]; then
	wget ${deps_download_url_oniguruma}
	rpm -Uvh ${deps_download_name_oniguruma}
else
	echo "onigurum already installed!"
fi
