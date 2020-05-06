yum install -y libxml2-devel sqlite-devel krb5-devel openssl-devel bzip2-devel libcurl-devel libpng-devel libjpeg-turbo-devel freetype-devel  libicu-devel gcc-c++ libpq-devel libxslt-devel libzip-devel

rm -rf lgxzj-deps
mkdir lgxzj-deps
cd lgxzj-deps

imap_installed=`rpm -qa | grep "uw-imap-devel-2007f-24.el8.x86_64"`
if [[ -z "$imap_installed" ]]; then
	wget https://download-ib01.fedoraproject.org/pub/epel/8/Everything/x86_64/Packages/u/uw-imap-devel-2007f-24.el8.x86_64.rpm
	rpm -Uvh uw-imap-devel-2007f-24.el8.x86_64.rpm

else
	echo "imap_installed already installed!"
fi

oniguruma_devel_install=`rpm -qa | grep "oniguruma-devel-6.8.2-1.el8.x86_64"`
if [[ -z "$oniguruma_devel_install" ]]; then
	wget http://mirror.centos.org/centos/8/PowerTools/x86_64/os/Packages/oniguruma-devel-6.8.2-1.el8.x86_64.rpm
	rpm -Uvh oniguruma-devel-6.8.2-1.el8.x86_64.rpm
else
	echo "oniguruma_devel already installed!"
fi

oniguruma_install=`rpm -qa | grep "oniguruma-6.8.2-1.el8.x86_64"`
if [[ -z "$oniguruma_install" ]]; then
	wget http://mirror.centos.org/centos/8/AppStream/x86_64/os/Packages/oniguruma-6.8.2-1.el8.x86_64.rpm
	rpm -Uvh oniguruma-6.8.2-1.el8.x86_64
else
	echo "onigurum already installed!"
fi
