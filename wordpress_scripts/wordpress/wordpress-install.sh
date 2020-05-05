rm -rf lgxzj-wordpress
mkdir lgxzj-wordpress
cd lgxzj-wordpress

wget https://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
cp ../wp-config.php wordpress/wp-config.php

blog_dir=/lgxzj-install/nginx/html/blog
rm -rf ${blog_dir}
mkdir ${blog_dir}
