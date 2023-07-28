app_user=roboshop
func_nodejs(){
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
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  cd /app

  echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> extract the cart content <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
  unzip /tmp/${component}.zip
  cd /app

  echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Install NodeJS depencies <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
  npm install

  echo -e "/e[36m>>>>>>>>>>>>>>>>>>>>>> copy the cart systemd files <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

  echo -e "/e[36m>>>>>>>>>>>>>>>>>>>>>> start the cart <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}
}