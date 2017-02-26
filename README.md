# Wordpress Installer Script

Before cloning this script make sure you have created a new database user and grant it privileges:

`CREATE USER 'newuser'@'localhost' IDENTIFIED BY 'password';`

`GRANT ALL PRIVILEGES ON * . * TO 'newuser'@'localhost';`

`FLUSH PRIVILEGES;`

After the user is created, creat a login path:

`mysql_config_editor set --login-path=newuser --host=localhost --user=newuser --password`

Clone this script and then move it to /usr/local/bin

`git clone https://github.com/Onyx808/Wordpress-Installer.git`

`mv Wordpress-Installer/wp.sh /usr/local/bin/`

Then ran the command **wp.sh** and follow the instructions on screen, have your database username and password handy.
Enjoy!
