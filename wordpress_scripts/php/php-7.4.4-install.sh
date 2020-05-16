./php-7.4.4-deps.sh

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
php_download_url=$(read_ini ${iniFileLoc} php_download_url)
php_download_name=$(read_ini ${iniFileLoc} php_download_name)
php_download_prefix=$(read_ini ${iniFileLoc} php_download_prefix)
php_user=$(read_ini ${iniFileLoc} lgxzj-php)
php_group=$(read_ini ${iniFileLoc} lgxzj-php)

##############################################################
# Download php sources
##############################################################
rm -rf ${php_install_dir}
mkdir ${php_install_dir}

rm -rf ${download_tmp_dir}
mkdir ${download_tmp_dir}
cd ${download_tmp_dir}
wget ${php_download_url}
tar -zxvf ${php_download_name}
cd ${php_download_prefix}

##############################
# Create user and group
##############################
groupadd ${php_group}
# create a non login permission user
useradd -r -g ${php_group} -s /bin/false ${php_user}

./configure --prefix=/lgxzj-install/php --enable-fpm --with-fpm-user=${php_user} --with-fpm-group=${php_group} --with-pdo-pgsql --with-zlib-dir --with-freetype --enable-mbstring --enable-soap --enable-calendar --with-curl --with-zlib --enable-gd --with-pgsql --disable-rpath --enable-inline-optimization --with-bz2 --with-zlib --enable-sockets --enable-sysvsem --enable-sysvshm --enable-pcntl --enable-mbregex --enable-exif --enable-bcmath --with-mhash --with-zip --with-pdo-mysql --with-mysqli --with-jpeg --with-openssl --enable-ftp --with-imap --with-imap-ssl --with-kerberos --with-gettext --with-xmlrpc --with-xsl --enable-opcache --enable-intl --with-pear --with-libdir=lib64
make
make install
