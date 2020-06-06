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
install_borg_dir=$(read_ini ${iniFileLoc} install_borg_dir)
install_backups_dir=$(read_ini ${iniFileLoc} install_backups_dir)
borg_standalone_download_url=$(read_ini ${iniFileLoc} borg_standalone_download_url)
borg_backup_repokey=$(read_ini ${iniFileLoc} borg_backup_repokey)
wordpress_deploy_dir=$(read_ini ${iniFileLoc} wordpress_deploy_dir)

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
rm -f backups.sh
cp backups.template backups.sh
replace_str ./backups.sh '${install_backups_dir}' ${install_backups_dir}
cp backups.sh ${install_backups_dir}
chmod u+x ${install_backups_dir}/backups.sh

rm -f wordpress_backup.sh
cp wordpress_backup.template wordpress_backup.sh
replace_str wordpress_backup.sh '${borg_backup_repokey}' ${borg_backup_repokey}
replace_str wordpress_backup.sh '${install_borg_dir}' ${install_borg_dir}
replace_str wordpress_backup.sh '${install_backups_dir}' ${install_backups_dir}
replace_str wordpress_backup.sh '${wordpress_deploy_dir}' ${wordpress_deploy_dir}
cp wordpress_backup.sh ${install_backups_dir}
chmod u+x ${install_backups_dir}/wordpress_backup.sh

###############################################
# Deploy backup scripts
###############################################
crontab ${install_backups_dir}/backups.sh
