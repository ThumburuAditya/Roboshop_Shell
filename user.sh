source ${script_path}/common.sh

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Download Node JS dependencies <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Install NodeJS <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
yum install nodejs -y

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Add the application user roboshop <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> create an application directory <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Download the user content <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> extract the user conten <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
unzip /tmp/user.zip
cd /app

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Install node js dependencies <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
npm install

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> copy the user systemd files <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
cp ${script_path}/user.service /etc/systemd/system/user.service

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> start the application <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable user
systemctl start user

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Copy mongodb repo<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Install mongodb<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Load Schema <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
mongo --host user-dev.thumburuaditya.online </app/schema/user.js