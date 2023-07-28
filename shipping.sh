script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "$mysql_root_password"]
then
  echo Mysql root password is missing
  exit
fi



echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> load the schema <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
mysql -h mysql-dev.thumburuaditya.online -uroot -p${mysql_root_password} < /app/schema/shipping.sql
systemctl restart shipping