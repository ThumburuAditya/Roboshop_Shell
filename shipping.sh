script_path=$(dirname $0)
source ${script_path}/common.sh

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Install Maven <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
yum install maven -y

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Add Roboshop user <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> create app directory <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> download shipping content <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
cd /app

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Extract shipping content <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
unzip /tmp/shipping.zip
cd /app

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> clean install maven <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
mvn clean package
mv target/shipping-1.0.jar shipping.jar

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Copy systemd files <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
cp ${script_path}/shipping.service /etc/systemd/system/shipping.service

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Start shipping <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable shipping
systemctl start shipping

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> load the schema <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
mysql -h mysql-dev.thumburuaditya.online -uroot -pRoboShop@1 < /app/schema/shipping.sql
systemctl restart shipping