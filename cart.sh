script_path=$(dirname $0)
source ${script_path}/common.sh

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> download node js dependencies <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Install NodeJS <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
yum install nodejs -y

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> add the application user <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> add the application user <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> download cart content <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
cd /app

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> extract the cart content <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
unzip /tmp/cart.zip
cd /app

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Install NodeJS depencies <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
npm install

echo -e "/e[36m>>>>>>>>>>>>>>>>>>>>>> copy the cart systemd files <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
cp ${script_path}/cart.service /etc/systemd/system/cart.service

echo -e "/e[36m>>>>>>>>>>>>>>>>>>>>>> start the cart <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable cart
systemctl restart cart