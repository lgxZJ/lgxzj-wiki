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

###############################################
# Install Borg
###############################################

### Read Borg related confs
iniFileLoc=../lgxzj.ini
install_mysql_dir=$(read_ini ${iniFileLoc} install_mysql_dir)
install_borg_dir=$(read_ini ${iniFileLoc} install_borg_dir)
install_backups_dir=$(read_ini ${iniFileLoc} install_backups_dir)
borg_standalone_download_url=$(read_ini ${iniFileLoc} borg_standalone_download_url)
borg_backup_repokey=$(read_ini ${iniFileLoc} borg_backup_repokey)
wordpress_deploy_dir=$(read_ini ${iniFileLoc} wordpress_deploy_dir)
wordpress_db_name=$(read_ini ${iniFileLoc} wordpress_db_name)
mysql_socket_file_loc=$(read_ini ${iniFileLoc} mysql_socket_file_loc)
mysql_root_local_password=$(read_ini ${iniFileLoc} mysql_root_local_password)
backup_password=$(read_ini ${iniFileLoc} backup_password)
backup_user=$(read_ini ${iniFileLoc} backup_user)

### Download and Install Borg
cur_dir=`pwd`
rm -rf ${install_borg_dir}
mkdir ${install_borg_dir}
cd ${install_borg_dir}
wget ${borg_standalone_download_url} -O borg
chmod u+x ./borg
cd ${cur_dir}

###############################################
# Init Borg local backup repo
###############################################
rm -rf ${install_backups_dir}
mkdir ${install_backups_dir}

export BORG_PASSPHRASE=${borg_backup_repokey}
${install_borg_dir}/borg init --encryption=repokey ${install_backups_dir}

###############################################
# Replace backup scripts with conf variables
###############################################

# Generate backups.sh
rm -f backups.sh
cp backups.template backups.sh
replace_str ./backups.sh '${install_backups_dir}' ${install_backups_dir}
cp backups.sh ${install_backups_dir}
chmod u+x ${install_backups_dir}/backups.sh

# Generate wordpress_backup.sh
rm -f wordpress_backup.sh
cp wordpress_backup.template wordpress_backup.sh
replace_str wordpress_backup.sh '${borg_backup_repokey}' ${borg_backup_repokey}
replace_str wordpress_backup.sh '${install_borg_dir}' ${install_borg_dir}
replace_str wordpress_backup.sh '${install_backups_dir}' ${install_backups_dir}
replace_str wordpress_backup.sh '${wordpress_deploy_dir}' ${wordpress_deploy_dir}
cp wordpress_backup.sh ${install_backups_dir}
chmod u+x ${install_backups_dir}/wordpress_backup.sh

# Generate mysql_backup.sh
rm -f mysql_backup.sh
cp mysql_backup.template mysql_backup.sh
replace_str mysql_backup.sh '${mysql_install_dir}' ${install_mysql_dir}
replace_str mysql_backup.sh '${wordpress_db_name}' ${wordpress_db_name}
replace_str mysql_backup.sh '${install_backups_dir}' ${install_backups_dir}
replace_str mysql_backup.sh '${mysql_socket_file_loc}' ${mysql_socket_file_loc}
replace_str mysql_backup.sh '${mysql_root_local_password}' ${mysql_root_local_password}
cp mysql_backup.sh ${install_backups_dir}
chmod u+x ${install_backups_dir}/mysql_backup.sh

#####################################`##########
# Generate Backup accout
###############################################
userdel -r ${backup_user}
useradd ${backup_user} -m
echo ${backup_password} | passwd ${backup_user} --stdin

###############################################
# Deploy backup scripts
###############################################
crontab ${install_backups_dir}/backups.sh
