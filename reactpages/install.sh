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
install_react_dir=$(read_ini ${iniFileLoc} install_react_dir)

##############################################################
# Deploy in react install dir
##############################################################
if [ ! -d "${install_react_dir}" ]; then
    mkdir ${install_react_dir}
else
    echo "react deploy dir existed, creation skipped"
fi

cp -rf ./build/* ${install_react_dir}
