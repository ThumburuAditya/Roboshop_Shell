script_path=$(dirname $0)
source ${script_path}/common.sh

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Configuring NodeJS repos <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Install NodeJS <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
yum install nodejs -y

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Add the user <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> create the directory <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Download catalogue content <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> extract the content <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
unzip /tmp/catalogue.zip

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Download Node JS dependencies <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
npm install

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Copy catalogue systemd files<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
cp ${script_path}/catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> start catalogue services <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Copy mongodb repos <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Install mongodb <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Load Schema <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
mongo --host mongodb-dev.thumburuaditya.online </app/schema/catalogue.js