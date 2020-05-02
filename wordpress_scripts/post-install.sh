########################################################
# open port 80 via firewalld
########################################################
firewall-cmd --permanent --zone=public --add-port=80/tcp
firewall-cmd --reload
