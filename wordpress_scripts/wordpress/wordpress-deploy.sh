cd lgxzj-wordpress
cd wordpress

blog_dir=/lgxzj-install/nginx/html
rm -rf ${blog_dir}
mkdir -p ${blog_dir}
cp -R ./* ${blog_dir}
