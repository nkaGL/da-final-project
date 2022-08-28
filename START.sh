#!/bin/bash

echo "Please provide user data for Jenkins Server."
echo -n "Username: "
read -r username
echo -n "Password: "
read -s new_password
echo -n "Email: "
read -r email
echo -n "Full user name: "
read -r fullname

cd .terraform-init
terraform init
terraform apply -auto-approve
jenkins_public_ip=$(terraform output -raw jenkins_public_ip)

cd ..
sleep 180
./scripts/jenkins_init.sh 

echo "START JENKINS: http://"$jenkins_public_ip":8080/"