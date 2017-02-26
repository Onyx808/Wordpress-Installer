#!/bin/bash -e
clear
echo "============================================"
echo "WordPress Install Script"
echo "============================================"
echo "Project Name: "
read -e projectname
echo "Database Name: "
read -e dbname
echo "Table Prefix: "
read -e table_prefix
echo "Database User: "
read -e dbuser
echo "Database Password: "
read -s dbpass
echo "run install? (y/n)"
read -e run
if [ "$run" == n ] ; then
exit
else
echo "============================================"
echo "A robot is now installing WordPress for you."
echo "============================================"
#move to webroot
cd /var/www/html
#download wordpress
curl -O https://wordpress.org/latest.tar.gz
#unzip wordpress
tar -zxvf latest.tar.gz
#change dir to wordpress
cd wordpress
#copy file to parent dir
#cp -rf . ..
#move back to parent dir
#cd ..
#remove files from wordpress folder
#rm -R wordpress
#create wp config
echo "============================================"
echo "Editing wp-config.php file."
echo "============================================"
cp wp-config-sample.php wp-config.php
#set database details with perl find and replace
perl -pi -e "s/database_name_here/$dbname/g" wp-config.php
perl -pi -e "s/username_here/$dbuser/g" wp-config.php
perl -pi -e "s/password_here/$dbpass/g" wp-config.php
perl -pi -e "s/wp_/$table_prefix/g" wp-config.php

perl -pi -e 'print "define('WP_AUTO_UPDATE_CORE', true ); \n" if $. == 81' wp-config.php
perl -pi -e 'print "define('WP_POST_REVISIONS', false ); \n" if $. == 82' wp-config.php
perl -pi -e 'print "define('FS_METHOD', 'direct'); \n" if $. == 83' wp-config.php
perl -pi -e 'print "define('AUTOSAVE_INTERVAL', 240 ); \n" if $. == 84' wp-config.php
perl -pi -e 'print "define('DISALLOW_FILE_EDIT',true); \n" if $. == 85' wp-config.php


perl -pi -e "s/WP_AUTO_UPDATE_CORE/\'WP_AUTO_UPDATE_CORE\'/g" wp-config.php
#set WP salts
perl -i -pe'
  BEGIN {
    @chars = ("a" .. "z", "A" .. "Z", 0 .. 9);
    push @chars, split //, "!@#$%^&*()-_ []{}<>~\`+=,.;:/?|";
    sub salt { join "", map $chars[ rand @chars ], 1 .. 64 }
  }
  s/put your unique phrase here/salt()/ge
' wp-config.php

#create uploads folder and set permissions
mkdir wp-content/uploads
chmod 775 wp-content/uploads
echo "Cleaning..."
#remove zip file
cd ..
rm latest.tar.gz
#remove bash script
mv wordpress $projectname
sudo chown -R www-data:www-data $projectname
#rm wp.sh
echo "========================="
echo "creating database."
echo "========================="
echo "create database $dbname" | mysql --login-path=$dbuser
echo "========================="
echo "Installation is complete."
echo "========================="
fi