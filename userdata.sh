#!/bin/bash
# Update System
sudo yum update
# Install Docker
sudo yum install docker -y
sudo service docker start
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user
sudo yum install git
# Install Minikube
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo chmod +x minikube
sudo mv minikube /usr/local/bin/
# Start Minikube
minikube start  2>&1 | tee SomeFile.txt
# Download kubectl
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.28.3/2023-11-14/bin/darwin/amd64/kubectl
sudo chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
git clone https://github.com/ArieL19999/job-project.git
cd  job-project
kubectl apply -f deployment.yml
kubectl apply -f service.yml
sudo ssh -i ~/.minikube/machines/minikube/id_rsa docker@$(minikube ip) -L \*:80:0.0.0.0:32321


