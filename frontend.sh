script=$(realpath "$0")
script_path=$(dirname "$(script)")
source ${script_path}/common.sh

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Install nginx <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
yum install nginx -y

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> copy the roboshop conf file <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
cp roboshop.conf /etc/nginx/default.d/roboshop.conf
rm -rf /usr/share/nginx/html/*

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> download the front end content  <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Unzip the frontend content <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> start nginx <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl restart nginx
systemctl enable nginx