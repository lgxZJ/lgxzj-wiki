./nginx-1.17.9-deps.sh

nginx_tmp_dir=lgxzj-nginx
nginx_install_dir=/lgxzj-install/nginx

mkdir ${nginx_install_dir}

rm -rf ${nginx_tmp_dir}
mkdir ${nginx_tmp_dir}
cd ${nginx_tmp_dir}

nginx_pkg_name=nginx-1.17.9
nginx_pkg_ext=.tar.gz
nginx_pkg=${nginx_pkg_name}${nginx_pkg_ext}
wget http://nginx.org/download/${nginx_pkg}
tar -zxvf ${nginx_pkg}

cd ${nginx_pkg_name}
./configure --prefix=/lgxzj-install/nginx
make
make install
