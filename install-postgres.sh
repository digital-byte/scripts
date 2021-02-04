#!/bin/bash
###############################################
# To use:
# chmod 777 install_postgres.sh
# ./install_postgres.sh
###############################################
echo "*****************************************"
echo "         Installing PostgreSQL           "
echo "*****************************************"
sudo yum -y install postgresql96-contrib postgresql96-server
sudo service postgresql96 initdb
# Uncomment listen addresses
sudo sed -i.bak -e '/listen_addresses/s/^#//'  /var/lib/pgsql96/data/postgresql.conf
# Use MD5 Authentication
sudo sed -i.bak -e 's/ident$/md5/' -e 's/peer$/md5/' /var/lib/pgsql96/data/pg_hba.conf
#auto start on boot
sudo /sbin/chkconfig postgresql96 on
sudo service postgresql96 start
