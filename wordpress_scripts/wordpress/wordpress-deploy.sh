cd lgxzj-wordpress
cd wordpress

blog_dir=/lgxzj-install/nginx/html/blog
rm -rf ${blog_dir}
mkdir -p ${blog_dir}
cp -R ./* ${blog_dir}
