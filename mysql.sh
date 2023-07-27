script_path=$(dirname $0)
source ${script_path}/common.sh

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Disable mysql8 version  <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
yum module disable mysql -y

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> copy mysql repo file <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
cp mysql.repo /etc/yum.repos.d/mysql.repo

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Install MySql <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
yum install mysql-community-server -y

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> start my sql <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl enable mysqld
systemctl restart mysqld

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> change the password <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
mysql_secure_installation --set-root-pass RoboShop@1