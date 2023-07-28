app_user=roboshop
print_head(){
   echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> $1 <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
}
schema_setup(){
  if [ "$schema_setup" == "mongo"]
  then
    print_head "copy mongodb repo"
    cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

    print_head "Install mongodb"
    yum install mongodb-org-shell -y

    print_head "load schema"
    mongo --host user-dev.thumburuaditya.online </app/schema/${component}.js
  fi
}
func_nodejs(){
  print_head "Downloading nodeJs dependencies"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  print_head "Install NodeJS"
  yum install nodejs -y

  print_head "Add the application user"
  useradd ${app_user}

  print_head "Create the application directory"
  rm -rf /app
  mkdir /app

  print_head "Download the cart content"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  cd /app

  print_head "Extract the cart content"
  unzip /tmp/${component}.zip
  cd /app

  print_head "Install NodeJS dependencies"
  npm install

  print_head "Copy systemd files"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

  print_head "start cart"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}
}