app_user = "roboshop"

func_print_head(){
   echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> $1 <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
}

func_schema_setup(){
  if [ "$schema_setup" == "mongo"]
  then
    func_print_head "copy mongodb repo"
    cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

    func_print_head "Install mongodb"
    yum install mongodb-org-shell -y

    func_print_head "load schema"
    mongo --host ${component}-dev.thumburuaditya.online </app/schema/${component}.js
  fi
}

func_nodejs(){
  func_print_head "Downloading nodeJs dependencies"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  func_print_head "Install NodeJS"
  yum install nodejs -y

  func_app_prereq

  func_print_head "Install NodeJS dependencies"
  npm install

  func_print_head "Copy systemd files"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

  func_print_head "start cart"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}
}

func_app_prereq(){
  func_print_head "Add Application user"
  useradd ${app_user}

  func_print_head "create Application directory"
  rm -rf /app
  mkdir /app

  func_print_head "Download Application content"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  cd /app

  func_print_head "Extract Application content"
  unzip /tmp/${component}.zip
  cd /app
}

func_java(){

  func_print_head "Install Maven"
  yum install maven -y

  func_app_prereq

  func_print_head "Clean install maven"
  mvn clean package
  mv target/${component}-1.0.jar ${component}.jar

  func_print_head "Copy systemd files"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

  func_print_head "start shipping"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl start ${component}
}