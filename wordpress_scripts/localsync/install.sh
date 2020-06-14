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

if [ ! -f "../str_replacer.sh" ]; then
    echo "!!!!!!!!!!!!!!!!!!!!!!!"
    echo "str_replacer.sh not found"
    echo "!!!!!!!!!!!!!!!!!!!!!!!"
    exit 255
fi
. ../str_replacer.sh

#####################################
# Load Confs
#####################################
iniFileLoc=../lgxzj.ini
install_backups_dir=$(read_ini ${iniFileLoc} install_backups_dir)
blog_domain=$(read_ini ${iniFileLoc} blog_domain)
sshkey_loc=$(read_ini ${iniFileLoc} sshkey_loc)
sshkey_pub_loc=$(read_ini ${iniFileLoc} sshkey_pub_loc)
backup_user=$(read_ini ${iniFileLoc} backup_user)

home_dir=`echo $HOME`
sshkey_loc="${home_dir}/${sshkey_loc}"
sshkey_pub_loc="${home_dir}/${sshkey_pub_loc}"

#####################################
# Setup non-password ssh login
#####################################
home_dir=`echo $HOME`
rm -f ${sshkey_loc}
rm -f ${sshkey_pub_loc}
ssh-keygen -t rsa -N "" -f ${sshkey_loc}
ssh-copy-id -i ${sshkey_pub_loc} ${backup_user}@${blog_domain}
ssh-add

#####################################
# Replace vars
#####################################
rm -f backup_sync.sh
cp backup_sync.template backup_sync.sh
replace_str backup_sync.sh '${install_backups_dir}' ${install_backups_dir}
replace_str backup_sync.sh '${blog_domain}' ${blog_domain}
replace_str backup_sync.sh '${backup_user}' ${backup_user}
chmod u+x backup_sync.sh

chmod u+x backup_crontab.sh

#####################################
# Install daily backup `syncer`
#####################################
crontab ./backup_crontab.sh
