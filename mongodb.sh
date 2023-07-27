echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> copy the mongodb repo file <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Install mongoDB <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
yum install mongodb-org -y

systemctl enable mongod
systemctl start mongod

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> change the listen address <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> start mongodb<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl restart mongod

